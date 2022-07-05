Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96138C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jul 2022 22:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbiGEWCN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 18:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbiGEWCL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 18:02:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33735192BD;
        Tue,  5 Jul 2022 15:02:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8307F61CF4;
        Tue,  5 Jul 2022 22:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC637C341C7;
        Tue,  5 Jul 2022 22:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657058528;
        bh=GOYMgz7XSCWP9DdDMpNAnUvAnivgHsXFREbZ4MCVg8s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mHoZwmKwbAEpjzNtEsak548Z6W4bbYj59t1AoULu10PC2phvhpItO//06tPaHfaaG
         ebryUTNEvFTUFhrYHCydiTLEqe17qinJm6XoThZVk/cCWw3Sd99pf33U5e2/ViIgkD
         9CX/qwNhqTGpTi1xPiME5DYIYii8jRCDXknFpzGjxSF2M43rFhhVsiVBwg3lCo50m2
         OHEaN7e2r4Age7kbep+1++PeGf3Z1alC+/NWzHDGxQy8hvjhNTvT6x2Xn/GsmfPejM
         Fgp9oELn8kwUYmlxlMN/xmKcw5GiaRWsVkjfeJaO34pnwHis4qi2gT/j6K0DdjnjZZ
         J8qkUxWNae/KQ==
Subject: [PATCH 1/3] xfs: fix test mkfs.xfs sizing of internal logs that
 overflow the AG
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 05 Jul 2022 15:02:08 -0700
Message-ID: <165705852849.2820493.14066599391475531621.stgit@magnolia>
In-Reply-To: <165705852280.2820493.17559217951744359102.stgit@magnolia>
References: <165705852280.2820493.17559217951744359102.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix a few problems with this test -- one of the things we test require
mkfs to run in -N mode, so we need to have a certain amount of free
space, and fix that test not to use -N mode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/144 |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)


diff --git a/tests/xfs/144 b/tests/xfs/144
index 2910eec9..706aff61 100755
--- a/tests/xfs/144
+++ b/tests/xfs/144
@@ -16,6 +16,10 @@ _begin_fstest auto mkfs
 # Modify as appropriate.
 _supported_fs xfs
 _require_test
+
+# The last testcase creates a (sparse) fs image with a 2GB log, so we need
+# 3GB to avoid failing the mkfs due to ENOSPC.
+_require_fs_space $TEST_DIR $((3 * 1048576))
 echo Silence is golden
 
 testfile=$TEST_DIR/a
@@ -26,7 +30,7 @@ test_format() {
 	shift
 
 	echo "$tag" >> $seqres.full
-	$MKFS_XFS_PROG $@ -d file,name=$testfile &>> $seqres.full
+	$MKFS_XFS_PROG -f $@ -d file,name=$testfile &>> $seqres.full
 	local res=$?
 	test $res -eq 0 || echo "$tag FAIL $res" | tee -a $seqres.full
 }
@@ -38,13 +42,13 @@ for M in `seq 298 302` `seq 490 520`; do
 	done
 done
 
+# log end rounded beyond EOAG due to stripe unit
+test_format "log end beyond eoag" -d agcount=3200,size=6366g -d su=256k,sw=4 -N
+
 # Log so large it pushes the root dir into AG 1.  We can't use -N for the mkfs
 # because this check only occurs after the root directory has been allocated,
 # which mkfs -N doesn't do.
-test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0 -N
-
-# log end rounded beyond EOAG due to stripe unit
-test_format "log end beyond eoag" -d agcount=3200,size=6366g -d su=256k,sw=4 -N
+test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0
 
 # success, all done
 status=0

