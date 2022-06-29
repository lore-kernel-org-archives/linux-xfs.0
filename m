Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A63BC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 21:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiF2VpD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 17:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiF2VpC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 17:45:02 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3D2D3818E
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 14:45:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 43D765ECFCE;
        Thu, 30 Jun 2022 07:45:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o6fUY-00Cck9-P8; Thu, 30 Jun 2022 07:44:58 +1000
Date:   Thu, 30 Jun 2022 07:44:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: add in-memory iunlink log item
Message-ID: <20220629214458.GZ227878@dread.disaster.area>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-10-david@fromorbit.com>
 <YrzCWswNIPu0jmrG@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrzCWswNIPu0jmrG@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62bcc7dc
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=7-415B0cAAAA:8
        a=AruSYX0dkyrtsAuDTzMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 29, 2022 at 02:21:30PM -0700, Darrick J. Wong wrote:
> On Mon, Jun 27, 2022 at 10:43:36AM +1000, Dave Chinner wrote:
> > diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
> > new file mode 100644
> > index 000000000000..fe38fc61f79e
> > --- /dev/null
> > +++ b/fs/xfs/xfs_iunlink_item.c
> > @@ -0,0 +1,180 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2020, Red Hat, Inc.
> 
> 2022?

2020 is correct - that's when I originally wrote this and first published it.

> > + * All Rights Reserved.
> > + */
> > +#include "xfs.h"
> > +#include "xfs_fs.h"
> > +#include "xfs_shared.h"
> > +#include "xfs_format.h"
> > +#include "xfs_log_format.h"
> > +#include "xfs_trans_resv.h"
> > +#include "xfs_mount.h"
> > +#include "xfs_inode.h"
> > +#include "xfs_trans.h"
> > +#include "xfs_trans_priv.h"
> > +#include "xfs_ag.h"
> > +#include "xfs_iunlink_item.h"
> > +#include "xfs_trace.h"
> > +#include "xfs_error.h"
> > +
> > +struct kmem_cache	*xfs_iunlink_cache;
> > +
> > +static inline struct xfs_iunlink_item *IUL_ITEM(struct xfs_log_item *lip)
> > +{
> > +	return container_of(lip, struct xfs_iunlink_item, item);
> > +}
> > +
> > +static void
> > +xfs_iunlink_item_release(
> > +	struct xfs_log_item	*lip)
> > +{
> > +	struct xfs_iunlink_item	*iup = IUL_ITEM(lip);
> > +
> > +	xfs_perag_put(iup->pag);
> > +	kmem_cache_free(xfs_iunlink_cache, IUL_ITEM(lip));
> > +}
> > +
> > +
> > +static uint64_t
> > +xfs_iunlink_item_sort(
> > +	struct xfs_log_item	*lip)
> > +{
> > +	return IUL_ITEM(lip)->ip->i_ino;
> > +}
> 
> Since you mentioned in-memory log items for dquots -- how should
> iunlinks and dquot log items be sorted?

ip->i_ino is the physical location of the inode - I'd use the
physical location of the dquot buffer if that was being logged.

> (On the off chance the dquot comment was made off the cuff and you don't
> have a patchset ready to go in your dev tree -- I probably wouldn't have
> said anything if this looked like the usual comparator function.)

No, there's nothing coming down the line for dquots right now.

> > +/*
> > + * On precommit, we grab the inode cluster buffer for the inode number we were
> > + * passed, then update the next unlinked field for that inode in the buffer and
> > + * log the buffer. This ensures that the inode cluster buffer was logged in the
> > + * correct order w.r.t. other inode cluster buffers. We can then remove the
> > + * iunlink item from the transaction and release it as it is has now served it's
> > + * purpose.
> > + */
> > +static int
> > +xfs_iunlink_item_precommit(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_log_item	*lip)
> > +{
> > +	struct xfs_iunlink_item	*iup = IUL_ITEM(lip);
> > +	int			error;
> > +
> > +	error = xfs_iunlink_log_dinode(tp, iup);
> 
> Hmm, so does this imply that log items can create new log items now?

Yup, now it's been sorted, we can lock the buffer, modify the
unlinked list and log the buffer, adding the new buffer log item to
the transaction.

That's the whole point of the in-memory log item - it records the
change to be made, then delays the physical change until it is safe
to lock the object we need to change.

This minimises the length of time we have to hold the object locked
during a transaction by dissociating the in-memory change from the
on-disk format changes. I plan to use this technique a lot more in
future...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
