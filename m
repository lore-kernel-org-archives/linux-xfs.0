Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28744C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbiLaDTi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiLaDTg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:19:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E26E2733;
        Fri, 30 Dec 2022 19:19:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE4B561D4E;
        Sat, 31 Dec 2022 03:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43299C433EF;
        Sat, 31 Dec 2022 03:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456775;
        bh=Y+Tq+XT2d1H1z/xXG67Z2UBC2OBogFGX1zfcTx0WOTI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CYf+PH7XkKlR3wUK9+Svq5CFfNfqab+ihw93aUA7r18+9uzICJqNMhlRYmJ9AZZak
         p32P0dFdfhRG4YYXHmf78Lz3lre5gtrkEIrRDekc2ay27OebyxLDHeVSFHldiPIgdK
         YfMRWvMeAi8n8r/xSn1I6A3cAardkYihLgFAEyW6MmzUUBMWpuhxofC35clUHluZ8/
         ZYGloTO5TKWNb4P1JqYRvRZ0t3ArfzRcpnPexIilZ2227aAV6FMrLs+CQj52QR7+t+
         CYn72GfV+XzoJbLXjHfqJmcYpVUHkKVi/yi+9G6azNfWmjfN3ZvmFw83q6cUdAeuL5
         e0mazQJ/us0mA==
Subject: [PATCH 4/4] generic/303: avoid test failures on weird rt extent sizes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:53 -0800
Message-ID: <167243885324.740527.2775632077491737501.stgit@magnolia>
In-Reply-To: <167243885270.740527.7129374192035439232.stgit@magnolia>
References: <167243885270.740527.7129374192035439232.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix this test to skip the high offset reflink test if (on XFS) the rt
extent size isn't congruent with the chosen target offset.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc         |   23 +++++++++++++++++++++++
 tests/generic/303 |    8 +++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)


diff --git a/common/rc b/common/rc
index cfe765de2e..3c30a444fe 100644
--- a/common/rc
+++ b/common/rc
@@ -4488,6 +4488,29 @@ _get_file_block_size()
 	esac
 }
 
+_test_congruent_file_oplen()
+{
+	local file="$1"
+	local alloc_unit=$(_get_file_block_size "$file")
+	local oplen="$2"
+
+	case $FSTYP in
+	nfs*|cifs|9p|virtiofs|ceph|glusterfs|overlay|pvfs2)
+		# Network filesystems don't know about (or tell the client
+		# about) the underlying file allocation unit and they generally
+		# pass the file IO request to the underlying filesystem, so we
+		# don't have anything to check here.
+		return
+		;;
+	esac
+
+	if [ $alloc_unit -gt $oplen ]; then
+		return 1
+	fi
+	test $((oplen % alloc_unit)) -eq 0 || return 1
+	return 0
+}
+
 # Given a file path and a byte length of a file operation under test, ensure
 # that the length is an integer multiple of the file's allocation unit size.
 # In other words, skip the test unless (oplen ≡ alloc_unit mod 0).  This is
diff --git a/tests/generic/303 b/tests/generic/303
index 95679569e4..ef88d2357b 100755
--- a/tests/generic/303
+++ b/tests/generic/303
@@ -48,7 +48,13 @@ echo "Reflink past maximum file size in dest file (should fail)"
 _reflink_range $testdir/file1 0 $testdir/file5 4611686018427322368 $len >> $seqres.full
 
 echo "Reflink high offset to low offset"
-_reflink_range $testdir/file1 $bigoff_64k $testdir/file6 1048576 65535 >> $seqres.full
+oplen=1048576
+if _test_congruent_file_oplen $testdir $oplen; then
+	_reflink_range $testdir/file1 $bigoff_64k $testdir/file6 $oplen 65535 >> $seqres.full
+else
+	# If we can't do the ficlonerange test, fake it in the output file
+	$XFS_IO_PROG -f -c 'pwrite -S 0x61 1114110 1' $testdir/file6 >> $seqres.full
+fi
 
 echo "Reflink past source file EOF (should fail)"
 _reflink_range $testdir/file2 524288 $testdir/file7 0 1048576 >> $seqres.full

