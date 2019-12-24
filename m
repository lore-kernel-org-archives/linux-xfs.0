Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34212C2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 08:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07E1B20706
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 08:21:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pKl0gn6x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbfLXIV1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 03:21:27 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33728 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfLXIV1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 03:21:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Yj3ctisse7ix2b/PkGbc3YPFpeNBUdsKD0c8fcGnVnQ=; b=pKl0gn6xsiJXGeeXuMafAbYcT
        BWkJNdA6u89A1bGnvJGadzjbt7AuYCya801YxMnsWbhCEzhjg0gmnjxKCYuxpDogZ8v6/H7n4aQ4l
        Qgil4Njsw1f+x+aAGg8vCIpvCHtrt2b68IMLgXWBn/Lck4dB/wwVWlM60Sc7D8XRKRK/ofD8vyM8c
        lIcZVjl6wQtHqwP3uiN/Gi/ARHPhqClRFh7kT91WuPj6KnyuAt7OVUGq+LRAzlHLog+PKYuU/tze/
        zozFjKv5bfCtsVIYLkY+S5vr2dK93CWXSqLF8YFIsSN7vkAilVjUW+25BuKqgBb+D+H0oeaFdHeDa
        s0Exak+ig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijfRX-0003Tv-5m; Tue, 24 Dec 2019 08:21:27 +0000
Date:   Tue, 24 Dec 2019 00:21:27 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: truncate should remove all blocks, not just to the
 end of the page cache
Message-ID: <20191224082127.GA26649@infradead.org>
References: <20191222163630.GS7489@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191222163630.GS7489@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 22, 2019 at 08:36:30AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs_itruncate_extents_flags() is supposed to unmap every block in a file
> from EOF onwards.  Oddly, it uses s_maxbytes as the upper limit to the
> bunmapi range, even though s_maxbytes reflects the highest offset the
> pagecache can support, not the highest offset that XFS supports.
> 
> The result of this confusion is that if you create a 20T file on a
> 64-bit machine, mount the filesystem on a 32-bit machine, and remove the
> file, we leak everything above 16T.  Fix this by capping the bunmapi
> request at the maximum possible block offset, not s_maxbytes.
> 
> Fixes: 32972383ca462 ("xfs: make largest supported offset less shouty")

Why would that fix that commit?  The commit just changed how do derive
the value, but not the value itself.

> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 401da197f012..eaa85d5933cb 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1544,9 +1544,12 @@ xfs_itruncate_extents_flags(
>  	 * possible file size.  If the first block to be removed is
>  	 * beyond the maximum file size (ie it is the same as last_block),
>  	 * then there is nothing to do.
> +	 *
> +	 * We have to free all the blocks to the bmbt maximum offset, even if
> +	 * the page cache can't scale that far.
>  	 */
>  	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
> -	last_block = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> +	last_block = (1ULL << BMBT_STARTOFF_BITLEN) - 1;
>  	if (first_unmap_block == last_block)
>  		return 0;

That check is now never true.  I think that whole function wants some
attenttion instead.  Kill that whole last_block calculation, switch to
__xfs_bunmapi and pass ULLONG_MAX for the rlen input and just exit the
loop once rlen is 0.
