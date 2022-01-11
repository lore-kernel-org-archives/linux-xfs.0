Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D9EDC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 21:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245510AbiAKVus (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 16:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245524AbiAKVus (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jan 2022 16:50:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED4AC06173F;
        Tue, 11 Jan 2022 13:50:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1122617BB;
        Tue, 11 Jan 2022 21:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C71C36AEF;
        Tue, 11 Jan 2022 21:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641937847;
        bh=NaqQCVM27DZNRlOv1wTnB5F3U0mgVAI9QELoiaiameA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CYrBZ+1dwX9d/Qb7E/eIo5Outr7i5zi8EPEZr197dHuHGYbzXXvxnLfKoykk+afYH
         4h/1R6dmAyN0SMoPUofEj6ayDm3wC5dDYiL7UYC2mJmD3n+hV/4ov4iK5n8P7W5gVn
         bsLKDzRtb+t0Ke6nKyt6clm/a2GeFrWOBWEM+XuEazCoeE6Led+HwBvRXOpeb5Gu20
         JhWSBRX5+JD0OSLPKVQhQs5mrKFRmhjnbslalqm2wTAcdFnWdYa+Fd+r//Lc4+DI2B
         OAqTuYRb9PTWC1qhYBJeWjV085FFZEu8MrWc0hKFmkjpnAfn66MATtUGPTD2y5N633
         juBc5Umw5XFjQ==
Subject: [PATCH 7/8] iogen: upgrade to fallocate
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Jan 2022 13:50:46 -0800
Message-ID: <164193784690.3008286.8689130816813600863.stgit@magnolia>
In-Reply-To: <164193780808.3008286.598879710489501860.stgit@magnolia>
References: <164193780808.3008286.598879710489501860.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update this utility to use fallocate to preallocate/reserve space to a
file so that we're not so dependent on legacy XFS ioctls.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 ltp/iogen.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)


diff --git a/ltp/iogen.c b/ltp/iogen.c
index 2b6644d5..6c2c1534 100644
--- a/ltp/iogen.c
+++ b/ltp/iogen.c
@@ -928,7 +928,15 @@ bozo!
 		   fd, f.l_whence, (long long)f.l_start, (long long)f.l_len);*/
 
 	    /* non-zeroing reservation */
-#ifdef XFS_IOC_RESVSP
+#if defined(HAVE_FALLOCATE)
+	    if (fallocate(fd, 0, 0, nbytes) == -1) {
+		fprintf(stderr,
+			"iogen%s:  Could not fallocate %d bytes in file %s: %s (%d)\n",
+			TagName, nbytes, path, SYSERR, errno);
+		close(fd);
+		return -1;
+	    }
+#elif defined(XFS_IOC_RESVSP)
 	    if( xfsctl( path, fd, XFS_IOC_RESVSP, &f ) == -1) {
 		fprintf(stderr,
 			"iogen%s:  Could not xfsctl(XFS_IOC_RESVSP) %d bytes in file %s: %s (%d)\n",
@@ -936,8 +944,7 @@ bozo!
 		close(fd);
 		return -1;
 	    }
-#else
-#ifdef F_RESVSP
+#elif defined(F_RESVSP)
 	    if( fcntl( fd, F_RESVSP, &f ) == -1) {
 		fprintf(stderr,
 			"iogen%s:  Could not fcntl(F_RESVSP) %d bytes in file %s: %s (%d)\n",
@@ -946,8 +953,7 @@ bozo!
 		return -1;
 	    }
 #else
-bozo!
-#endif
+# error Dont know how to reserve space!
 #endif
 	}
 
@@ -962,7 +968,15 @@ bozo!
 		    (long long)f.l_len);*/
 
 	    /* zeroing reservation */
-#ifdef XFS_IOC_ALLOCSP
+#if defined(HAVE_FALLOCATE)
+	    if (fallocate(fd, 0, sbuf.st_size, nbytes - sbuf.st_size) == -1) {
+		fprintf(stderr,
+			"iogen%s:  Could not fallocate %d bytes in file %s: %s (%d)\n",
+			TagName, nbytes, path, SYSERR, errno);
+		close(fd);
+		return -1;
+	    }
+#elif defined(XFS_IOC_ALLOCSP)
 	    if( xfsctl( path, fd, XFS_IOC_ALLOCSP, &f ) == -1) {
 		fprintf(stderr,
 			"iogen%s:  Could not xfsctl(XFS_IOC_ALLOCSP) %d bytes in file %s: %s (%d)\n",
@@ -970,8 +984,7 @@ bozo!
 		close(fd);
 		return -1;
 	    }
-#else
-#ifdef F_ALLOCSP
+#elif defined(F_ALLOCSP)
 	    if ( fcntl(fd, F_ALLOCSP, &f) < 0) {
 		fprintf(stderr,
 			"iogen%s:  Could not fcntl(F_ALLOCSP) %d bytes in file %s: %s (%d)\n",
@@ -980,8 +993,7 @@ bozo!
 		return -1;
 	    }
 #else
-bozo!
-#endif
+# error Dont know how to (pre)allocate space!
 #endif
 	}
 #endif

