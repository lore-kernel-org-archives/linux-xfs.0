Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7AE4C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4D9D20722
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:21:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GG+Dc/hp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgGAIVC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728477AbgGAIVA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:21:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAD0C061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=poj0gPsL3r4CbRF1mQcqVmt/t+8+fbMXov3ko8fZrIw=; b=GG+Dc/hpGbLI3v5sVSKYAv31Dw
        qWflT7fYGlZZcbQiZFlgjnsZxHKSPYM8Qh+SsHQ71lOAyyIFwblYRym64tdMzb4GsN8Oh4B13oMZ3
        qvplDtxz4eLjOvFy8PFbgQao06L0YIG394oDrhVoySTr0C9N6Yr4ptSz1t4TEB4falj0sLopywgHq
        ZrHPbkXhQChkKBbEbvxwR2dgW32thmfrFow5Gv6IFsxoW/PGJRHuZmOMeG+dEFNiPRWzwfaSt5A2z
        UWvp18ylyK4dKW1eYVtJ6pOMwSIo+O81KoVO2W+DHDOZg6f6hS1FNASNaEjGQP/wUTDAO8GrN+Pvh
        OlO1C1GA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqXzG-0005y5-Bv; Wed, 01 Jul 2020 08:20:58 +0000
Date:   Wed, 1 Jul 2020 09:20:58 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v4.2 3/9] xfs: redesign the reflink remap loop to fix
 blkres depletion crash
Message-ID: <20200701082058.GC20101@infradead.org>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
 <159304787925.874036.14054367123332450148.stgit@magnolia>
 <20200625172310.GO7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625172310.GO7606@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 25, 2020 at 10:23:10AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The existing reflink remapping loop has some structural problems that
> need addressing:
> 
> The biggest problem is that we create one transaction for each extent in
> the source file without accounting for the number of mappings there are
> for the same range in the destination file.  In other words, we don't
> know the number of remap operations that will be necessary and we
> therefore cannot guess the block reservation required.  On highly
> fragmented filesystems (e.g. ones with active dedupe) we guess wrong,
> run out of block reservation, and fail.
> 
> The second problem is that we don't actually use the bmap intents to
> their full potential -- instead of calling bunmapi directly and having
> to deal with its backwards operation, we could call the deferred ops
> xfs_bmap_unmap_extent and xfs_refcount_decrease_extent instead.  This
> makes the frontend loop much simpler.
> 
> Solve all of these problems by refactoring the remapping loops so that
> we only perform one remapping operation per transaction, and each
> operation only tries to remap a single extent from source to dest.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v4.2: move qres conditional to the next patch, rename bmap helper, try
> to clear up some of the smap/dmap confusion
> ---
>  fs/xfs/libxfs/xfs_bmap.h |   13 ++
>  fs/xfs/xfs_reflink.c     |  240 +++++++++++++++++++++++++---------------------
>  fs/xfs/xfs_trace.h       |   52 +---------
>  3 files changed, 142 insertions(+), 163 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 2b18338d0643..e1bd484e5548 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -158,6 +158,13 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
>  	{ BMAP_ATTRFORK,	"ATTR" }, \
>  	{ BMAP_COWFORK,		"COW" }
>  
> +/* Return true if the extent is an allocated extent, written or not. */
> +static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
> +{
> +	return irec->br_startblock != HOLESTARTBLOCK &&
> +		irec->br_startblock != DELAYSTARTBLOCK &&
> +		!isnullstartblock(irec->br_startblock);
> +}

I think reusing the previous name is a little dangerous.  Maybe rename
this to ..._is_allocated_extent_ ?

>  
>  /*
>   * Return true if the extent is a real, allocated extent, or false if it is  a

And not for the previous one: if the real goes away in the name, it
should probably be updated here as well.

The rest looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
