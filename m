Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B9AC4332B
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 17:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC11C2222A
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 17:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436747AbhARRyo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 12:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407196AbhARRjr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 12:39:47 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFB2C0613C1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 09:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=arNQA0yrAJYn2Sy7bjubn0srkVAw0hZajwhmB5pCdfI=; b=cc0trx8Pla20S/THq9U5VUPC/m
        Ku5nLywWBwOom+YN6E7f1of9uKMhVjeIkuC3ykIlEputPH/NQIAtWZIwY0MpmUOMFO4L8JtoogagI
        ndPLPREiRnsWiipiD0dOzOjKSF19yOPosAvDFsHkQ3eMKUWPc0irZiZsXmYQ8/5SoY1JJuCte2jBG
        336uLZlMB2ywX4dW6e2DgDug3hdFLHRUfjAUFaBer3sNZhvRy2UlWUIVvyV8RBvOQhoeEDbGvpMP7
        r4eiSxU4j0kUT8/Yspr6v/bAuNKiK302ORZalEBcZUPeLz0T7lkQnd0ZLlhXFghIaRIIb8NkRdXoW
        k8baAC3w==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l1YUJ-00D9zt-2l; Mon, 18 Jan 2021 17:38:47 +0000
Date:   Mon, 18 Jan 2021 17:38:47 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: refactor the predicate part of
 xfs_free_eofblocks
Message-ID: <20210118173847.GC3134885@infradead.org>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
 <161040740813.1582286.3253329052236449810.stgit@magnolia>
 <X/8KS4it5LAkN6Xr@infradead.org>
 <20210114224953.GJ1164246@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114224953.GJ1164246@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 14, 2021 at 02:49:53PM -0800, Darrick J. Wong wrote:
> > > +	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
> > > +	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> > > +	if (last_fsb <= end_fsb)
> > > +		return 0;
> > 
> > Where does this strange magic come from?
> 
> It comes straight from xfs_free_eofblocks.
> 
> I /think/ the purpose of this is to avoid touching any file that's
> larger than the page cache supports (i.e. 16T on 32-bit) because inode
> inactivation causes pagecache invalidation, and trying to invalidate
> with too high a pgoff causes weird integer truncation problems.

Hmm.  At very least we need to document this, but we really should not
allow to even read in an inode successfully under this condition..

Screams for a nice little test case..

> > 	xfs_ilock(ip, XFS_ILOCK_SHARED);
> > 	if (ip->i_delayed_blks) {
> > 		*has = true;
> > 		goto out_unlock;
> > 	}
> > 	if (!(ip->i_df.if_flags & XFS_IFEXTENTS)) {
> > 		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> 
> Is it even worth reading in the bmap btree to clear posteof blocks if we
> haven't loaded it already?

True, we can return early in that case.  I'm also not sure what the
i_delayed_blks check is supposed to do, as delalloc extents do show
up in the iext tree just like normal extents.
