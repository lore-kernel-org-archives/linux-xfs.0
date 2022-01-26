Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A825DC5DF62
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jan 2022 02:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbiAZCL4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jan 2022 21:11:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47198 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236160AbiAZCLz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jan 2022 21:11:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DA5761053;
        Wed, 26 Jan 2022 02:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EB5C340E0;
        Wed, 26 Jan 2022 02:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643163115;
        bh=Up8ri8XznPh3+2sVTNbFREwtwLq1JDidS9t/yh1ok1s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=U/lI6rRCOtCo4Xk5bXtXO3VBJ3jH7LZ2BeQvONGVfwfmQ4zLSm7OFbXYDyDa1Dp3x
         xb6YDZubNq8zs4lupbkG5JWR2NtEGl+e5++qTcv7f9dzNS3+0mxhopyiCrBqt3TjR6
         lOIG8Ff9ym4lj5I+4QXSXOi33BRwMZR1PmdjEmxnzJJSHYVYT1ijXrrS2abQk/vpAv
         wfBXn/KgmQ/hxl3+VZ0SnUVRzvRWt+dDhxji4d6arxMGEkiaNSSBRI5diH/bm/tq66
         7Qd09aSwYLnv8/OgqUqab8o50c8/AbKbYLK7PutAGnoLNrEZhaEHjgNusm+j4Ivfwt
         V2B6QfgOGWzeg==
Subject: [PATCH 2/2] fstests: skip tests that require XFS_IOC_ALLOCSP
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 25 Jan 2022 18:11:54 -0800
Message-ID: <164316311463.2594527.15258066711888915917.stgit@magnolia>
In-Reply-To: <164316310323.2594527.8578672050751235563.stgit@magnolia>
References: <164316310323.2594527.8578672050751235563.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Deprecating this, so turn off the tests that require it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc      |    4 ++--
 ltp/fsstress.c |    4 ++++
 tests/xfs/107  |    1 +
 3 files changed, 7 insertions(+), 2 deletions(-)


diff --git a/common/rc b/common/rc
index b3289de9..6a0648ad 100644
--- a/common/rc
+++ b/common/rc
@@ -2507,8 +2507,8 @@ _require_xfs_io_command()
 		rm -f $testcopy > /dev/null 2>&1
 		param_checked="$param"
 		;;
-	"falloc" )
-		testio=`$XFS_IO_PROG -F -f -c "falloc $param 0 1m" $testfile 2>&1`
+	"falloc"|"allocsp")
+		testio=`$XFS_IO_PROG -F -f -c "$command $param 0 1m" $testfile 2>&1`
 		param_checked="$param"
 		;;
 	"fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" | "funshare")
diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 5f3126e6..23188467 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -2045,6 +2045,7 @@ afsync_f(opnum_t opno, long r)
 void
 allocsp_f(opnum_t opno, long r)
 {
+#ifdef XFS_IOC_ALLOCSP64
 	int		e;
 	pathname_t	f;
 	int		fd;
@@ -2094,6 +2095,7 @@ allocsp_f(opnum_t opno, long r)
 	}
 	free_pathname(&f);
 	close(fd);
+#endif
 }
 
 #ifdef AIO
@@ -3733,6 +3735,7 @@ fiemap_f(opnum_t opno, long r)
 void
 freesp_f(opnum_t opno, long r)
 {
+#ifdef XFS_IOC_FREESP64
 	int		e;
 	pathname_t	f;
 	int		fd;
@@ -3781,6 +3784,7 @@ freesp_f(opnum_t opno, long r)
 		       procid, opno, f.path, st, (long long)off, e);
 	free_pathname(&f);
 	close(fd);
+#endif
 }
 
 void
diff --git a/tests/xfs/107 b/tests/xfs/107
index 577094b2..1ea9c492 100755
--- a/tests/xfs/107
+++ b/tests/xfs/107
@@ -20,6 +20,7 @@ _begin_fstest auto quick prealloc
 _supported_fs xfs
 _require_test
 _require_scratch
+_require_xfs_io_command allocsp		# detect presence of ALLOCSP ioctl
 _require_test_program allocstale
 
 # Create a 256MB filesystem to avoid running into mkfs problems with too-small

