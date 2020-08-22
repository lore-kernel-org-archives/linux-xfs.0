Return-Path: <SRS0=ZMk+=CA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EBADC433E1
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 07:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBE2420825
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 07:41:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gswg64xF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgHVHlS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Aug 2020 03:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgHVHlS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Aug 2020 03:41:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13F6C061573
        for <linux-xfs@vger.kernel.org>; Sat, 22 Aug 2020 00:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l674i0CRdqSsIlclw81Nl6YVeD6OyCvyDF7B825RH/s=; b=Gswg64xFzhGRMSDRqbVZMSUZFd
        y5xkZT6S/LlPVQ/5XcEMKVrYbqSldyet6fnSJ0jhit6LxE9v2kRb2i2CE5eah9g73Az1rrGE4wC/O
        mQ8w3s6yZXqvpWjpXTa3B5OEYYB/VU6Erx1hq0W6faXzWDJhnpJCwGqZ+S/jWAayDJ6vh25NmW1Jd
        2DFhrH/g9kSfZwIT3Cm2OZ34RLYspzZOuJkI/UVpG4PIbbVm7pCLXFoYP/A2qV8OfpagrzrY43Ab3
        JBWqaYB0rLws22qQZPrc+K/F86eFgBNCM8hbDlXakj3be2X1SP2mbmj7QXMY/86e9IleVkTXDNPPi
        U1l+zt7A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9O9M-0002X1-5m; Sat, 22 Aug 2020 07:41:16 +0000
Date:   Sat, 22 Aug 2020 08:41:16 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/13] xfs: xfs_iflock is no longer a completion
Message-ID: <20200822074116.GA8859@infradead.org>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092556.2567285-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 12, 2020 at 07:25:44PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> With the recent rework of the inode cluster flushing, we no longer
> ever wait on the the inode flush "lock". It was never a lock in the
> first place, just a completion to allow callers to wait for inode IO
> to complete. We now never wait for flush completion as all inode
> flushing is non-blocking. Hence we can get rid of all the iflock
> infrastructure and instead just set and check a state flag.
> 
> Rename the XFS_IFLOCK flag to XFS_IFLUSHING, convert all the
> xfs_iflock_nowait() test-and-set operations on that flag, and
> replace all the xfs_ifunlock() calls to clear operations.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c     | 17 ++++------
>  fs/xfs/xfs_inode.c      | 73 +++++++++++++++--------------------------
>  fs/xfs/xfs_inode.h      | 33 +------------------
>  fs/xfs/xfs_inode_item.c | 15 ++++-----
>  fs/xfs/xfs_inode_item.h |  4 +--
>  fs/xfs/xfs_mount.c      | 11 ++++---
>  fs/xfs/xfs_super.c      | 10 +++---
>  7 files changed, 55 insertions(+), 108 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 101028ebb571..aa6aad258670 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -52,7 +52,6 @@ xfs_inode_alloc(
>  
>  	XFS_STATS_INC(mp, vn_active);
>  	ASSERT(atomic_read(&ip->i_pincount) == 0);
> -	ASSERT(!xfs_isiflocked(ip));
>  	ASSERT(ip->i_ino == 0);
>  
>  	/* initialise the xfs inode */
> @@ -123,7 +122,7 @@ void
>  xfs_inode_free(
>  	struct xfs_inode	*ip)
>  {
> -	ASSERT(!xfs_isiflocked(ip));
> +	ASSERT(!xfs_iflags_test(ip, XFS_IFLUSHING));
>  
>  	/*
>  	 * Because we use RCU freeing we need to ensure the inode always
> @@ -1035,23 +1034,21 @@ xfs_reclaim_inode(
>  
>  	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
>  		goto out;
> -	if (!xfs_iflock_nowait(ip))
> +	if (xfs_iflags_test_and_set(ip, XFS_IFLUSHING))
>  		goto out_iunlock;
>  
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
>  		xfs_iunpin_wait(ip);
> -		/* xfs_iflush_abort() drops the flush lock */

Maybe keeps this as

		/*  xfs_iflush_abort() clears XFS_IFLUSHING */

> @@ -3661,7 +3643,6 @@ xfs_iflush_cluster(
>  		 */
>  		if (XFS_FORCED_SHUTDOWN(mp)) {
>  			xfs_iunpin_wait(ip);
> -			/* xfs_iflush_abort() drops the flush lock */

Same here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
