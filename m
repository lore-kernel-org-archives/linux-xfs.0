Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53233C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 06:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F18F207FF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 06:53:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D+f3SfsV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgHQGxL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 02:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgHQGxJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 02:53:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF669C061388
        for <linux-xfs@vger.kernel.org>; Sun, 16 Aug 2020 23:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cjn5szpb+RwUDj44CtDpqVFrpoLfZYBcL84yXup9UpQ=; b=D+f3SfsVcNg46Bdlt+biWUl/X8
        HHZgkhB9iV87BvdXH0wJZeaf/KsvS8nJhWYKtxk4bCpnD0NTLUcJZH0B1uoCk0O+PzDamv212EXO+
        3t7WxqnimG6+2pSIyM+cV3M2htXsrKMhlX9i/stPA5uZ9hi+zqFE7FrkJAVmDAW+ZFIDrsdmP4ckW
        xijnYDriGZZGkYxaR3HMDszDNUdc6C7Vp1E1QLszKKOdwXH33pVE0gnjt4ZImLCPMmcrrkRYPVfOu
        pCGmRRkAGPrlluQ+dam0lSGCZoVhjs9RC+mnTxiA93a0fiugA2Ebkqqs9wZQ4cJTRb/abJE86r1Bg
        B0J4Vffg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k7Z11-0006Y1-Dj; Mon, 17 Aug 2020 06:53:07 +0000
Date:   Mon, 17 Aug 2020 07:53:07 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH V2 02/10] xfs: Check for extent overflow when trivally
 adding a new extent
Message-ID: <20200817065307.GB23516@infradead.org>
References: <20200814080833.84760-1-chandanrlinux@gmail.com>
 <20200814080833.84760-3-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200814080833.84760-3-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 14, 2020 at 01:38:25PM +0530, Chandan Babu R wrote:
> When adding a new data extent (without modifying an inode's existing
> extents) the extent count increases only by 1. This commit checks for
> extent count overflow in such cases.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 8 ++++++++
>  fs/xfs/libxfs/xfs_inode_fork.h | 2 ++
>  fs/xfs/xfs_bmap_util.c         | 5 +++++
>  fs/xfs/xfs_dquot.c             | 8 +++++++-
>  fs/xfs/xfs_iomap.c             | 5 +++++
>  fs/xfs/xfs_rtalloc.c           | 5 +++++
>  6 files changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 9c40d5971035..e64f645415b1 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4527,6 +4527,14 @@ xfs_bmapi_convert_delalloc(
>  		return error;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +
> +	if (whichfork == XFS_DATA_FORK) {

Should we add COW fork special casing to xfs_iext_count_may_overflow
instead?

> +		error = xfs_iext_count_may_overflow(ip, whichfork,
> +				XFS_IEXT_ADD_CNT);

I find the XFS_IEXT_ADD_CNT define very confusing.  An explicit 1 passed
for a counter parameter makes a lot more sense to me.

