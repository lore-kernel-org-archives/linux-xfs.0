Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6705C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Jan 2022 18:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347960AbiARS3O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jan 2022 13:29:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55448 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244209AbiARS3N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jan 2022 13:29:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C02A46151F;
        Tue, 18 Jan 2022 18:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB56BC36AE9;
        Tue, 18 Jan 2022 18:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642530551;
        bh=Shc/zIlRh4rielm96p+ts4LgCHpUmZPeFVTWBw1CgxY=;
        h=Date:From:To:Cc:Subject:From;
        b=H/jjq1zzP7NqNH0EtEPQQ7ZKQJH6JOry5R3A2lhqp7NIYkToFoB5zKGhBuHKXWnNm
         YrTgEXlJ7gVZNaZIOYwMVB2CU6UrYrjECyX9BE9T4l0l00Sl05TP4uvxv+oVTV/Fjq
         XCnb2SQzWUmKnoEyLNmZaVLPvsMyakKhOaPqac2U2CK1bVa7x1AWJMzg4mpGgKsimX
         t1BwXrbVKyHqJ07FCSWVXebN8BTQGtTGJeE49kXMz0XDL1p/moJDoGm29hsdrnquxD
         yvdeIolMjAkPU4rSp26yG4EeohKN/F2v27IMeIx9Ew4sYpWvaSaqis+ACAVKRRjVVU
         aIG9V4QcrAbFA==
Date:   Tue, 18 Jan 2022 10:29:10 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH v2] iogen: upgrade to fallocate
Message-ID: <20220118182910.GC13514@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update this utility to use fallocate to preallocate/reserve space to a
file so that we're not so dependent on legacy XFS ioctls.  Fix a minor
whitespace error while we're at it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: fix the fallocate flags for the resvsp replacement code
---
 ltp/iogen.c |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/ltp/iogen.c b/ltp/iogen.c
index 2b6644d5..c43cc1d0 100644
--- a/ltp/iogen.c
+++ b/ltp/iogen.c
@@ -922,13 +922,21 @@ bozo!
 	    f.l_whence = SEEK_SET;
 	    f.l_start = 0;
 	    f.l_len = nbytes;
-	    
+
 	    /*fprintf(stderr,
 		    "create_file: xfsctl(%d, RESVSP, { %d, %lld, %lld })\n",
 		   fd, f.l_whence, (long long)f.l_start, (long long)f.l_len);*/
 
 	    /* non-zeroing reservation */
-#ifdef XFS_IOC_RESVSP
+#if defined(FALLOCATE)
+	    if (fallocate(fd, FALLOC_FL_KEEP_SIZE, 0, nbytes) == -1) {
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
+#if defined(FALLOCATE)
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
