Return-Path: <SRS0=ZB14=6Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E8BC54E49
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 737D921973
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:33:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HPm5PGXy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgEJHdU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 May 2020 03:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgEJHdT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 May 2020 03:33:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD6AC061A0C
        for <linux-xfs@vger.kernel.org>; Sun, 10 May 2020 00:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NiCIHIZTgot7z/QS2qpi9BqBDhexVPHZYN6sWjslpI0=; b=HPm5PGXyOYAIiIQDxrpEfZyitG
        9/fLNkaTEJpn68SHqPtsUWuY9TyU0WOereUC+0ohjY+zNTUXAjaiOfd68GOId4z8KARSzMRLCCWla
        wi4RF4KdAMce48Uyw+j+2hQJcV+sG0L476Dr9qfx9L4wraUu/2WgdPXvnxWfSW3nmomQrpmSR7cam
        +er7aBKbDVFZQP/jo71mdmEteLKZAFKKybqi5mTe90ztUQCM2QgxBAEOMUI/z5eDtX5OFT+7Q0ixt
        +tOCKurKJ+37t8EGNqx6R9wxpzROgGUBcq0BP27kRxwpuVdyYLzMBNqZvhCBCjKLlAXbxm61oI8i0
        YNwWxT/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXgSc-0002QP-IO; Sun, 10 May 2020 07:33:18 +0000
Date:   Sun, 10 May 2020 00:33:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/16] xfs_repair: fix rmapbt record order check
Message-ID: <20200510073318.GH8939@infradead.org>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904183079.982941.15948246247495283555.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904183079.982941.15948246247495283555.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:30:30AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The rmapbt record order checks here don't quite work properly.  For
> non-shared filesystems, we fail to check that the startblock of the nth
> record comes entirely after the previous record.
> 
> However, for filesystems with shared blocks (reflink) we correctly check
> that the startblock/owner/offset of the nth record comes after the
> previous one.
> 
> Therefore, make the reflink fs checks use "laststartblock" to preserve
> that functionality while making the non-reflink fs checks use
> "lastblock" to fix the problem outlined above.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/scan.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/repair/scan.c b/repair/scan.c
> index 7c46ab89..7508f7e8 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -925,15 +925,15 @@ struct rmap_priv {
>  static bool
>  rmap_in_order(
>  	xfs_agblock_t	b,
> -	xfs_agblock_t	lastblock,
> +	xfs_agblock_t	laststartblock,
>  	uint64_t	owner,
>  	uint64_t	lastowner,
>  	uint64_t	offset,
>  	uint64_t	lastoffset)
>  {
> -	if (b > lastblock)
> +	if (b > laststartblock)
>  		return true;
> -	else if (b < lastblock)
> +	else if (b < laststartblock)
>  		return false;
>  
>  	if (owner > lastowner)

So this is just a variable rename and looks obviously fine.

> @@ -964,6 +964,7 @@ scan_rmapbt(
>  	int			hdr_errors = 0;
>  	int			numrecs;
>  	int			state;
> +	xfs_agblock_t		laststartblock = 0;
>  	xfs_agblock_t		lastblock = 0;
>  	uint64_t		lastowner = 0;
>  	uint64_t		lastoffset = 0;
> @@ -1101,14 +1102,15 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
>  			/* Check for out of order records. */
>  			if (i == 0) {
>  advance:
> -				lastblock = b;
> +				laststartblock = b;
> +				lastblock = end - 1;
>  				lastowner = owner;
>  				lastoffset = offset;
>  			} else {
>  				bool bad;
>  
>  				if (xfs_sb_version_hasreflink(&mp->m_sb))
> -					bad = !rmap_in_order(b, lastblock,
> +					bad = !rmap_in_order(b, laststartblock,
>  							owner, lastowner,
>  							offset, lastoffset);
>  				else

This looks correct, but really hard to read. I'll send a follow on
cleanup.

Reviewed-by: Christoph Hellwig <hch@lst.de>
