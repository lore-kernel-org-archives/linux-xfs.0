Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F14C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 04:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3AED61A1A
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 04:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhCYE0e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 00:26:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhCYE0T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 00:26:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF55B61A14;
        Thu, 25 Mar 2021 04:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616646378;
        bh=suw02nFoR2dIvh3NZL15ydaZYwgZRG0mcplmj3z0lsE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fJNYt1gzgMFBQOT15FxK+ttedn5AEEZtO/bzFy3CSSJrJbx2We4Qznr5k0y3EYsF3
         Yg45oLpAIeDftXL6Ncx1Axfq1+NUe4AGmgG8QNlYhulgIdoCNd7sZa86ezixz+4Ggu
         k40XolAA9inGiCLFcSfA4HGIb7arM8ZVMvm4bIlNq8WreOStPMKF8gPpiltGI9qk8j
         UaS6J8g0CvRHix/gbJL/bHj4og4mTWsv/1o4WldHv2NwYj7y2S6L0K7kCKfSg+hqLc
         ezYbAF8N0C7+E3cpUVoMlHjJAa0XHeobUymqyK/5etFaYiYg8If92REjnDF6MDgMQB
         42OTK6IYz/nIw==
Date:   Wed, 24 Mar 2021 21:26:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: deferred inode inactivation
Message-ID: <20210325042618.GC4090233@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543197372.1947934.1230576164438094965.stgit@magnolia>
 <20210323014417.GC63242@dread.disaster.area>
 <20210323040037.GI22100@magnolia>
 <20210324175311.GA2773443@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324175311.GA2773443@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 05:53:11PM +0000, Christoph Hellwig wrote:
> On Mon, Mar 22, 2021 at 09:00:37PM -0700, Darrick J. Wong wrote:
> > Hmm, maybe this could maintain an approxiate liar counter and only flush
> > inactivation when the liar counter would cause us to be off by more than
> > some configurable amount?  The fstests that care about free space
> > accounting are not going to be happy since they are measured with very
> > tight tolerances.
> 
> Yes, I think some kind of fuzzy logic instead of the heavy weight flush
> on supposedly light weight operations.

Any suggestions?  I'll try adding a ratelimit to see if that shuts up
fstests while preventing userspace from pounding too hard on
inactivation.

> > > static void
> > > xfs_inode_clear_tag(
> > > 	struct xfs_perag	*pag,
> > > 	xfs_ino_t		ino,
> > > 	int			tag)
> > > {
> > > 	struct xfs_mount	*mp = pag->pag_mount;
> > > 
> > > 	lockdep_assert_held(&pag->pag_ici_lock);
> > > 	radix_tree_tag_clear(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ino),
> > > 				tag);
> > > 	switch(tag) {
> > > 	case XFS_ICI_INACTIVE_TAG:
> > > 		if (--pag->pag_ici_inactive)
> > > 			return;
> > > 		break;
> > > 	case XFS_ICI_RECLAIM_TAG:
> > > 		if (--pag->pag_ici_reclaim)
> > > 			return;
> > > 		break;
> > > 	default:
> > > 		ASSERT(0);
> > > 		return;
> > > 	}
> > > 
> > > 	spin_lock(&mp->m_perag_lock);
> > > 	radix_tree_tag_clear(&mp->m_perag_tree, pag->pag_agno, tag);
> > > 	spin_unlock(&mp->m_perag_lock);
> > > }
> > > 
> > > As a followup patch? The set tag case looks similarly easy to make
> > > generic...
> > 
> > Yeah.  At this point I might as well just clean all of this up for the
> > next revision of this series, because as I said earlier I had thought
> > that you were still working on a second rework of reclaim.  Now that I
> > know you're not, I'll hack away at this twisty pile too.
> 
> If the separate tags aren't going to disappear entirely: it would be nice
> to move the counters (or any other duplicated variable) into an array
> index by the tax, which would clean the above and similar code even more.

Ok done.

I refactored xfs_perag_{clear,set}_reclaim_tag into a generic helper
that sets an ICI tag on the inode radix tree and the perag radix tree.
This cleaned up a bunch of redundant code, and enabled me to trim down
the inactivation patch quite a bit.  Now each function that wants to set
inode flags does so directly (after taking the locks) and calls the ICI
helper to deal with the radix trees.

Also, refactoring reclaim to use xfs_inode_walk was pretty simple, and I
even integrated (rather heavily modified) code from the "void *args" ->
"eofb" and the "get rid of iter_flags" patches you posted.

> > We don't actually stop background gc transactions or other internal
> > updates on readonly filesystems -- the ro part means only that we don't
> > let /userspace/ change anything directly.  If you open a file readonly,
> > unlink it, freeze the fs, and close the file, we'll still free it.
> 
> Note that there are two different read-only concepts in Linux:
> 
>  1) the read-only mount, as reflected in the vfsmount.  For this your
>     description above is spot-on
>  2) the read-only superblock, as indicated by the sb flag.  This is
>     usually due to an read-only block device, and we must not write
>     anything to the device, as that typically will lead to an I/O error.

<nod> I /think/ we handle this properly, but it's late...

--D
