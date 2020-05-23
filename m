Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD70EC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 09:40:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE2C120757
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 09:40:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aDnYAF8x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725270AbgEWJk4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 05:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgEWJkz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 05:40:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8E3C061A0E
        for <linux-xfs@vger.kernel.org>; Sat, 23 May 2020 02:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4uP26EX0Nn8TnpIu0O8zzCuv2vPb69YONcskigyaHTQ=; b=aDnYAF8x5GuuNmfrkAltuzPzCz
        3zGPRZMREmAZY9Rku5EpOxXdzB8RtKbqxc2vAX+NpMqnz7MGGHbtbozmtoJifW6aoOUnNNoY75Zqb
        aF1ExOlnRkIuhlobN/w2jPLGk8od5EbhNxu7yFJqu8Z/G8GtGfhiUa+9+bL+DjmABbjEWeowVCDrY
        eX0dntIgWP/YVKwiYulICABeYSFGFD8Vn5YNucZkVVnKtjzhgJaw+TLflKuz+wDTJbTy3uB2PB02x
        SPsvqWM1/I3WBGESzgpitI1/jc7P6fHbnoPFxHaskAXmmSHzQUL+1RtWH+qE9dTQhRUu6bmU2FUG7
        d+y1y/vA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcQeF-0007MP-6i; Sat, 23 May 2020 09:40:55 +0000
Date:   Sat, 23 May 2020 02:40:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/24] xfs: remove IO submission from xfs_reclaim_inode()
Message-ID: <20200523094055.GB7083@infradead.org>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-15-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-15-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +out_ifunlock:
> +	xfs_ifunlock(ip);
> +out:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_iflags_clear(ip, XFS_IRECLAIM);
> +	return false;
>  
>  reclaim:

I find the reordering of the error handling to sit before the actual
reclaim action here really weird to read.  What about something like
this folded in instead?

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9bb022a3570a3..6f873eca8c916 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1091,18 +1091,10 @@ xfs_reclaim_inode(
 	}
 	if (xfs_ipincount(ip))
 		goto out_ifunlock;
-	if (xfs_iflags_test(ip, XFS_ISTALE) || xfs_inode_clean(ip)) {
-		xfs_ifunlock(ip);
-		goto reclaim;
-	}
+	if (!xfs_inode_clean(ip) && !xfs_iflags_test(ip, XFS_ISTALE))
+		goto out_ifunlock;
 
-out_ifunlock:
 	xfs_ifunlock(ip);
-out_iunlock:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-out:
-	xfs_iflags_clear(ip, XFS_IRECLAIM);
-	return false;
 
 reclaim:
 	ASSERT(!xfs_isiflocked(ip));
@@ -1153,6 +1145,14 @@ xfs_reclaim_inode(
 
 	__xfs_inode_free(ip);
 	return true;
+
+out_ifunlock:
+	xfs_ifunlock(ip);
+out_iunlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+out:
+	xfs_iflags_clear(ip, XFS_IRECLAIM);
+	return false;
 }
 
 /*
