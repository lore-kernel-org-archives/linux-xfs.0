Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490F8C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 21:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiF2Vtv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 17:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiF2Vts (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 17:49:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E8BDF3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 14:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6903D616B2
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 21:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67B7C34114;
        Wed, 29 Jun 2022 21:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656539386;
        bh=QphxaGHkk7uOyVslBVDuyg18hR1c30LVVkqu6NGGH/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mKF/a8Gxb1+msGzZBObbq71TUZ3TUpP3bL9bNc3/Y1+JUhCTGkXi2wzOzkgHUrnRc
         LTzaVLG5rCZgylQgguGi6heZmHs3IbuVEA7OFFkXwVamE8pXECXthAOSs95yRa39WB
         IPiE19KVi5Zxrl2AOOyg8m4w+QqiaYXj9zHIltTKJ4nv+F74uGE3QqkGrMp8jK2B60
         iJrsmOf7q07uwQzysAipgRalwubmk9OvU2BA1PkECKPASkrElZHk1w3AiemXPae3Qj
         VmXnq5v280GvF8M2yfpzhV2RDHblrG5wG6+h4BTL4XLFeU2rin6h8e95iDZYCtpKPw
         Tl9oedmDIOxcQ==
Date:   Wed, 29 Jun 2022 14:49:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: add in-memory iunlink log item
Message-ID: <YrzI+vbHY4eOjh/N@magnolia>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-10-david@fromorbit.com>
 <YrzCWswNIPu0jmrG@magnolia>
 <20220629214458.GZ227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629214458.GZ227878@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 30, 2022 at 07:44:58AM +1000, Dave Chinner wrote:
> On Wed, Jun 29, 2022 at 02:21:30PM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 27, 2022 at 10:43:36AM +1000, Dave Chinner wrote:
> > > diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
> > > new file mode 100644
> > > index 000000000000..fe38fc61f79e
> > > --- /dev/null
> > > +++ b/fs/xfs/xfs_iunlink_item.c
> > > @@ -0,0 +1,180 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Copyright (c) 2020, Red Hat, Inc.
> > 
> > 2022?
> 
> 2020 is correct - that's when I originally wrote this and first published it.
> 
> > > + * All Rights Reserved.
> > > + */
> > > +#include "xfs.h"
> > > +#include "xfs_fs.h"
> > > +#include "xfs_shared.h"
> > > +#include "xfs_format.h"
> > > +#include "xfs_log_format.h"
> > > +#include "xfs_trans_resv.h"
> > > +#include "xfs_mount.h"
> > > +#include "xfs_inode.h"
> > > +#include "xfs_trans.h"
> > > +#include "xfs_trans_priv.h"
> > > +#include "xfs_ag.h"
> > > +#include "xfs_iunlink_item.h"
> > > +#include "xfs_trace.h"
> > > +#include "xfs_error.h"
> > > +
> > > +struct kmem_cache	*xfs_iunlink_cache;
> > > +
> > > +static inline struct xfs_iunlink_item *IUL_ITEM(struct xfs_log_item *lip)
> > > +{
> > > +	return container_of(lip, struct xfs_iunlink_item, item);
> > > +}
> > > +
> > > +static void
> > > +xfs_iunlink_item_release(
> > > +	struct xfs_log_item	*lip)
> > > +{
> > > +	struct xfs_iunlink_item	*iup = IUL_ITEM(lip);
> > > +
> > > +	xfs_perag_put(iup->pag);
> > > +	kmem_cache_free(xfs_iunlink_cache, IUL_ITEM(lip));
> > > +}
> > > +
> > > +
> > > +static uint64_t
> > > +xfs_iunlink_item_sort(
> > > +	struct xfs_log_item	*lip)
> > > +{
> > > +	return IUL_ITEM(lip)->ip->i_ino;
> > > +}
> > 
> > Since you mentioned in-memory log items for dquots -- how should
> > iunlinks and dquot log items be sorted?
> 
> ip->i_ino is the physical location of the inode - I'd use the
> physical location of the dquot buffer if that was being logged.
> 
> > (On the off chance the dquot comment was made off the cuff and you don't
> > have a patchset ready to go in your dev tree -- I probably wouldn't have
> > said anything if this looked like the usual comparator function.)
> 
> No, there's nothing coming down the line for dquots right now.

Ok.

> > > +/*
> > > + * On precommit, we grab the inode cluster buffer for the inode number we were
> > > + * passed, then update the next unlinked field for that inode in the buffer and
> > > + * log the buffer. This ensures that the inode cluster buffer was logged in the
> > > + * correct order w.r.t. other inode cluster buffers. We can then remove the
> > > + * iunlink item from the transaction and release it as it is has now served it's
> > > + * purpose.
> > > + */
> > > +static int
> > > +xfs_iunlink_item_precommit(
> > > +	struct xfs_trans	*tp,
> > > +	struct xfs_log_item	*lip)
> > > +{
> > > +	struct xfs_iunlink_item	*iup = IUL_ITEM(lip);
> > > +	int			error;
> > > +
> > > +	error = xfs_iunlink_log_dinode(tp, iup);
> > 
> > Hmm, so does this imply that log items can create new log items now?
> 
> Yup, now it's been sorted, we can lock the buffer, modify the
> unlinked list and log the buffer, adding the new buffer log item to
> the transaction.
> 
> That's the whole point of the in-memory log item - it records the
> change to be made, then delays the physical change until it is safe
> to lock the object we need to change.

Wheeee :)

> This minimises the length of time we have to hold the object locked
> during a transaction by dissociating the in-memory change from the
> on-disk format changes. I plan to use this technique a lot more in
> future...

Cool.  All I can think of is matrixpeople transmogrifying into Agent
Smiths :P

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
