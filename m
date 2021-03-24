Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEEF1C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 17:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 746C861A1F
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 17:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237307AbhCXRx5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 13:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237290AbhCXRxr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 13:53:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E0CC061763
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 10:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UMI80R7o3otmWWwXvxPzpHzkBWEGK/EujgpVd5+tGlw=; b=wY99KsmzaU5+vZ+/SNisp+G+6I
        kSrniHEtve5JmxUWgWE2sEdPbIdym115guKmuJPjx4DBCih1xIT7Q/pWHkRY2xHgRu/UeeyqR9d7H
        KBtDkioTedQx2oUAlE7SFOhUX6EkCl5vwFtuE3EYvMRHYZF+5lw9j4oiYiHRZiagBc5dzX7/WDxXQ
        GSAfalY9Y5kIwigULWPyAYGRYuXOCij8nqIxxiYn42B02oAjvReTK3hnjJsIgyY+tKpMfL09KMG/b
        Phr0eMxkQY7jLuwEz6I48EeOOJm/Y71XebQynrkDlfh0Mv+C57M7ZXpr3P9FDNMsFotuIgLw73TLz
        6wY+BD1A==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lP7gt-00Behy-MJ; Wed, 24 Mar 2021 17:53:29 +0000
Date:   Wed, 24 Mar 2021 17:53:11 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: deferred inode inactivation
Message-ID: <20210324175311.GA2773443@infradead.org>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543197372.1947934.1230576164438094965.stgit@magnolia>
 <20210323014417.GC63242@dread.disaster.area>
 <20210323040037.GI22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323040037.GI22100@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 22, 2021 at 09:00:37PM -0700, Darrick J. Wong wrote:
> Hmm, maybe this could maintain an approxiate liar counter and only flush
> inactivation when the liar counter would cause us to be off by more than
> some configurable amount?  The fstests that care about free space
> accounting are not going to be happy since they are measured with very
> tight tolerances.

Yes, I think some kind of fuzzy logic instead of the heavy weight flush
on supposedly light weight operations.

> > static void
> > xfs_inode_clear_tag(
> > 	struct xfs_perag	*pag,
> > 	xfs_ino_t		ino,
> > 	int			tag)
> > {
> > 	struct xfs_mount	*mp = pag->pag_mount;
> > 
> > 	lockdep_assert_held(&pag->pag_ici_lock);
> > 	radix_tree_tag_clear(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ino),
> > 				tag);
> > 	switch(tag) {
> > 	case XFS_ICI_INACTIVE_TAG:
> > 		if (--pag->pag_ici_inactive)
> > 			return;
> > 		break;
> > 	case XFS_ICI_RECLAIM_TAG:
> > 		if (--pag->pag_ici_reclaim)
> > 			return;
> > 		break;
> > 	default:
> > 		ASSERT(0);
> > 		return;
> > 	}
> > 
> > 	spin_lock(&mp->m_perag_lock);
> > 	radix_tree_tag_clear(&mp->m_perag_tree, pag->pag_agno, tag);
> > 	spin_unlock(&mp->m_perag_lock);
> > }
> > 
> > As a followup patch? The set tag case looks similarly easy to make
> > generic...
> 
> Yeah.  At this point I might as well just clean all of this up for the
> next revision of this series, because as I said earlier I had thought
> that you were still working on a second rework of reclaim.  Now that I
> know you're not, I'll hack away at this twisty pile too.

If the separate tags aren't going to disappear entirely: it would be nice
to move the counters (or any other duplicated variable) into an array
index by the tax, which would clean the above and similar code even more.

> We don't actually stop background gc transactions or other internal
> updates on readonly filesystems -- the ro part means only that we don't
> let /userspace/ change anything directly.  If you open a file readonly,
> unlink it, freeze the fs, and close the file, we'll still free it.

Note that there are two different read-only concepts in Linux:

 1) the read-only mount, as reflected in the vfsmount.  For this your
    description above is spot-on
 2) the read-only superblock, as indicated by the sb flag.  This is
    usually due to an read-only block device, and we must not write
    anything to the device, as that typically will lead to an I/O error.
