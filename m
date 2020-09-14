Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25342C43461
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 07:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C142521548
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 07:25:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fwUxqw5t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgINHZC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 03:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgINHZB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 03:25:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98083C06174A
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2020 00:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/puGbY8CtTOcJgsxZuw8/b+ddsSufVlCrXxYWKB+htY=; b=fwUxqw5toKDekLNoDaaxLs/F16
        2d2MnfZ2YaJwJZjK0rn9aXW3UHJx10JzL36rMpIs4S3aHj8t1dDQxYMAUC/q83cPSTm2QHTva40eH
        o1qHRa7qgyunGBn1IKrPWWQzw1nO9C9Sah+w+y53neMB2aRaExfTJl4mZa/cTDdsAEqFcbzFf4Wkj
        izn07r6Sxovw151KRSBmRtOXOQct9xYOehTeMWBRp5Glzrq9I/TD3zTjNsVEMfLmb9MQtGbP3zlO7
        lpQ3ytEAvR0D4mbb/0DEf5MpK/+cHd4LDMYIKnWNp8fm9sNdej4Nky1JlaZun7OYI97XIfFzkLazx
        0aRItH+Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kHirD-0007dJ-Vi; Mon, 14 Sep 2020 07:25:00 +0000
Date:   Mon, 14 Sep 2020 08:24:59 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: Re: [PATCH] xfs: Set xfs_buf type flag when growing summary/bitmap
 files
Message-ID: <20200914072459.GA29046@infradead.org>
References: <20200912130015.11473-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200912130015.11473-1-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 12, 2020 at 06:30:15PM +0530, Chandan Babu R wrote:
> The following sequence of commands,
> 
>   mkfs.xfs -f -m reflink=0 -r rtdev=/dev/loop1,size=10M /dev/loop0
>   mount -o rtdev=/dev/loop1 /dev/loop0 /mnt
>   xfs_growfs  /mnt
> 
> ... causes the following call trace to be printed on the console,
> 
> XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 331
> Call Trace:
>  xfs_buf_item_format+0x632/0x680
>  ? kmem_alloc_large+0x29/0x90
>  ? kmem_alloc+0x70/0x120
>  ? xfs_log_commit_cil+0x132/0x940
>  xfs_log_commit_cil+0x26f/0x940
>  ? xfs_buf_item_init+0x1ad/0x240
>  ? xfs_growfs_rt_alloc+0x1fc/0x280
>  __xfs_trans_commit+0xac/0x370
>  xfs_growfs_rt_alloc+0x1fc/0x280
>  xfs_growfs_rt+0x1a0/0x5e0
>  xfs_file_ioctl+0x3fd/0xc70
>  ? selinux_file_ioctl+0x174/0x220
>  ksys_ioctl+0x87/0xc0
>  __x64_sys_ioctl+0x16/0x20
>  do_syscall_64+0x3e/0x70
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> This occurs because the buffer being formatted has the value of
> XFS_BLFT_UNKNOWN_BUF assigned to the 'type' subfield of
> bip->bli_formats->blf_flags.
> 
> This commit fixes the issue by assigning one of XFS_BLFT_RTSUMMARY_BUF
> and XFS_BLFT_RTBITMAP_BUF to the 'type' subfield of
> bip->bli_formats->blf_flags before committing the corresponding
> transaction.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/xfs_rtalloc.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 6209e7b6b895..192a69f307d7 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -767,8 +767,12 @@ xfs_growfs_rt_alloc(
>  	struct xfs_bmbt_irec	map;		/* block map output */
>  	int			nmap;		/* number of block maps */
>  	int			resblks;	/* space reservation */
> +	enum xfs_blft		buf_type;
>  	struct xfs_trans	*tp;
>  
> +	buf_type = (ip == mp->m_rsumip) ?
> +		XFS_BLFT_RTSUMMARY_BUF : XFS_BLFT_RTBITMAP_BUF;

Nit:  can you turn this into a normal if / else?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
