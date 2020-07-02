Return-Path: <SRS0=cy20=AN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB1E6C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 12:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84657207D4
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 12:26:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PxQVg2re"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbgGBM0B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 08:26:01 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55950 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728812AbgGBM0A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jul 2020 08:26:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593692758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h/Bs39RkfHRSdMZH7kErTN9vBffP0w2QjOaESh3xnFI=;
        b=PxQVg2re5Nbz+3fkWGp3xz2mneF7vyMw/HZcGH9h/Z0xIeIDQAHrjZ787MMsMU54SdPHqt
        y6PlTm4ULXFWMxIfqU3VgK7S7M3CbEZpoI+ysgEA6Ro3v9opIW9Yb6xdA2K0WWTkq99WUX
        WqFM5AbSQWKpgDQntXfKhAxPmr9Jd5k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-5DCfmX-qOmSAMhs22Xdxmw-1; Thu, 02 Jul 2020 08:25:56 -0400
X-MC-Unique: 5DCfmX-qOmSAMhs22Xdxmw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 502F687950D;
        Thu,  2 Jul 2020 12:25:55 +0000 (UTC)
Received: from bfoster (ovpn-120-48.rdu2.redhat.com [10.10.120.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 015DD610F2;
        Thu,  2 Jul 2020 12:25:54 +0000 (UTC)
Date:   Thu, 2 Jul 2020 08:25:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: introduce inode unlink log item
Message-ID: <20200702122553.GC55314@bfoster>
References: <20200623095015.1934171-1-david@fromorbit.com>
 <20200623095015.1934171-5-david@fromorbit.com>
 <20200701143219.GC1087@bfoster>
 <20200701222428.GX2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701222428.GX2005@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 02, 2020 at 08:24:28AM +1000, Dave Chinner wrote:
> On Wed, Jul 01, 2020 at 10:32:19AM -0400, Brian Foster wrote:
> > On Tue, Jun 23, 2020 at 07:50:15PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Tracking dirty inodes via cluster buffers creates lock ordering
> > > issues with logging unlinked inode updates direct to the cluster
> > > buffer. The unlinked inode list is unordered, so we can lock cluster
> > > buffers in random orders and that causes deadlocks.
> > > 
> > > To solve this problem, we really want to dealy locking the cluster
> > > buffers until the pre-commit phase where we can order the buffers
> > > correctly along with all the other inode cluster buffers that are
> > > locked by the transaction. However, to do this we need to be able to
> > > tell the transaction which inodes need to have there unlinked list
> > > updated and what it should be updated to.
> > > 
> > > We can delay the buffer update to the pre-commit phase based on the
> > > fact taht all unlinked inode list updates are serialised by the AGI
> > > buffer. It will be locked into the transaction before the list
> > > update starts, and will remain locked until the transaction commits.
> > > Hence we can lock and update the cluster buffers safely any time
> > > during the transaction and we are still safe from other racing
> > > unlinked list updates.
> > > 
> > > The iunlink log item currently only exists in memory. we need a log
> > > item to attach information to the transaction, but it's context
> > > is completely owned by the transaction. Hence it is never formatted
> > > or inserted into the CIL, nor is it seen by the journal, the AIL or
> > > log recovery.
> > > 
> > > This makes it a very simple log item, and the changes makes results
> > > in adding addition buffer log items to the transaction. Hence once
> > > the iunlink log item has run it's pre-commit operation, it can be
> > > dropped by the transaction and released.
> > > 
> > > The creation of this in-memory intent does not prevent us from
> > > extending it in future to the journal to replace buffer based
> > > logging of the unlinked list. Changing the format of the items we
> > > write to the on disk journal is beyond the scope of this patchset,
> > > hence we limit it to being in-memory only.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/Makefile           |   1 +
> > >  fs/xfs/xfs_inode.c        |  70 +++----------------
> > >  fs/xfs/xfs_inode_item.c   |   3 +-
> > >  fs/xfs/xfs_iunlink_item.c | 141 ++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_iunlink_item.h |  24 +++++++
> > >  fs/xfs/xfs_super.c        |  10 +++
> > >  6 files changed, 189 insertions(+), 60 deletions(-)
> > >  create mode 100644 fs/xfs/xfs_iunlink_item.c
> > >  create mode 100644 fs/xfs/xfs_iunlink_item.h
> > > 
...
> > > diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
> > > new file mode 100644
> > > index 000000000000..83f1dc81133b
> > > --- /dev/null
> > > +++ b/fs/xfs/xfs_iunlink_item.c
> > > @@ -0,0 +1,141 @@
> > ...
> > > +
> > > +static const struct xfs_item_ops xfs_iunlink_item_ops = {
> > > +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> > > +	.iop_release	= xfs_iunlink_item_release,
> > 
> > Presumably we need the release callback for transaction abort, but the
> > flag looks unnecessary. That triggers a release on commit to the on-disk
> > log, which IIUC should never happen for this item.
> 
> You are probably right - I didn't look that further than "it should
> be freed at commit time" and the flag name implies it is freed at
> commit time.
> 
> Which, of course, then raises the question: "Which commit are we
> talking about here?". But because it's RFC work at this point I
> didn't bother chasing that detail down because the code worked and I
> had other things to do.....
> 

I think it's funcionally harmless since this item would never be in a
situation where that flag has an effect. FWIW, I was never a big fan of
the iop_release() factoring and it hasn't really grown on me since. I
routinely have to double/triple check these callbacks where I didn't
before, especially when we have to consider things like this behavior
altering flag and cases where some of the other callbacks route back
into the release callback, etc.

Brian

> > > +	.iop_sort	= xfs_iunlink_item_sort,
> > > +	.iop_precommit	= xfs_iunlink_item_precommit,
> > > +};
> > > +
> > > +
> > > +/*
> > > + * Initialize the inode log item for a newly allocated (in-core) inode.
> > > + *
> > > + * Inode extents can only reside within an AG. Hence specify the starting
> > > + * block for the inode chunk by offset within an AG as well as the
> > > + * length of the allocated extent.
> > > + *
> > > + * This joins the item to the transaction and marks it dirty so
> > > + * that we don't need a separate call to do this, nor does the
> > > + * caller need to know anything about the iunlink item.
> > > + */
> > 
> > Looks like some copy/paste remnants in the comment.
> 
> Yup, I did just copy-pasta at lot of stuff around here...
> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 

