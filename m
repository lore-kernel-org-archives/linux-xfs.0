Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BEE1C38142
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjARAzz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjARAzL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:55:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0AF521E0;
        Tue, 17 Jan 2023 16:43:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87508615AC;
        Wed, 18 Jan 2023 00:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E591BC433EF;
        Wed, 18 Jan 2023 00:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674002581;
        bh=Fb6oqW1tMHFVsrwKrrchD42lq9oZroRnmzUNq8BhvT0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=eHk2GDTmG3T5alcK/kZHKRhhgqkVZye5+NhIg7IqecKpEhC7i0rW//o1K+cFSUupg
         tNA7lXeAUXN6CuA2cdshrxO06TSIvSnDySfinN5tVa2Kc1Qysrp14H+fHie8jYieIT
         7GJbMwratgU9N5/IBeW5miWZIkTzox9UeAJf63I0AgjGjhIqUZGlDowKdz3P1Eu9mY
         IX4Rmg3V/zho4cCFS3gDWJzjFANYCr1nTUnRZdKLpUiD9pypg9bY3Q2VVB93B+hctg
         5szH8lA9VWT4EUKbpwU6EsUEVWStRB2GbB7maMJ/CxmFvkwY/SRcuBgyZVO8bceLWQ
         UYdLxctGNMQfQ==
Date:   Tue, 17 Jan 2023 16:43:00 -0800
Subject: [PATCH 1/3] xfs: skip fragmentation tests when alwayscow mode is
 enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167400102759.1914975.16224258103457998795.stgit@magnolia>
In-Reply-To: <167400102747.1914975.6709564559821901777.stgit@magnolia>
References: <167400102747.1914975.6709564559821901777.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If the always_cow debugging flag is enabled, all file writes turn into
copy writes.  This dramatically ramps up fragmentation in the filesystem
(intentionally!) so there's no point in complaining about fragmentation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs    |    9 +++++++++
 tests/xfs/182 |    1 +
 tests/xfs/192 |    1 +
 tests/xfs/198 |    1 +
 tests/xfs/204 |    1 +
 tests/xfs/211 |    1 +
 6 files changed, 14 insertions(+)


diff --git a/common/xfs b/common/xfs
index 7eee76c0ee..a00d90a4b5 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1108,6 +1108,15 @@ _require_no_xfs_bug_on_assert()
 	fi
 }
 
+# Require that XFS is not configured in always_cow mode.
+_require_no_xfs_always_cow()
+{
+	if [ -f /sys/fs/xfs/debug/always_cow ]; then
+		grep -q "1" /sys/fs/xfs/debug/always_cow && \
+		   _notrun "test requires XFS always_cow to be off, turn it off to run the test"
+	fi
+}
+
 # Get a metadata field
 # The first arg is the field name
 # The rest of the arguments are xfs_db commands to find the metadata.
diff --git a/tests/xfs/182 b/tests/xfs/182
index 696b933e60..511aca6f2d 100755
--- a/tests/xfs/182
+++ b/tests/xfs/182
@@ -24,6 +24,7 @@ _require_cp_reflink
 _require_xfs_io_command "fiemap"
 _require_xfs_io_command "cowextsize"
 _require_odirect
+_require_no_xfs_always_cow	# writes have to converge to overwrites
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
diff --git a/tests/xfs/192 b/tests/xfs/192
index ced18fa3c1..eb577f15fc 100755
--- a/tests/xfs/192
+++ b/tests/xfs/192
@@ -26,6 +26,7 @@ _require_xfs_io_command "fiemap"
 _require_xfs_io_command "cowextsize"
 _require_xfs_io_command "funshare"
 _require_odirect
+_require_no_xfs_always_cow	# writes have to converge to overwrites
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
diff --git a/tests/xfs/198 b/tests/xfs/198
index c61fbab70d..e5b98609de 100755
--- a/tests/xfs/198
+++ b/tests/xfs/198
@@ -23,6 +23,7 @@ _require_cp_reflink
 _require_xfs_io_command "fiemap"
 _require_xfs_io_command "cowextsize"
 _require_odirect
+_require_no_xfs_always_cow	# writes have to converge to overwrites
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
diff --git a/tests/xfs/204 b/tests/xfs/204
index ca21dfe722..7d6b79a86d 100755
--- a/tests/xfs/204
+++ b/tests/xfs/204
@@ -28,6 +28,7 @@ _require_xfs_io_command "fiemap"
 _require_xfs_io_command "cowextsize"
 _require_xfs_io_command "funshare"
 _require_odirect
+_require_no_xfs_always_cow	# writes have to converge to overwrites
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
diff --git a/tests/xfs/211 b/tests/xfs/211
index 96c0b85b14..3ce6496afc 100755
--- a/tests/xfs/211
+++ b/tests/xfs/211
@@ -24,6 +24,7 @@ _require_cp_reflink
 _require_xfs_io_command "fiemap"
 _require_xfs_io_command "cowextsize"
 _require_odirect
+_require_no_xfs_always_cow	# writes have to converge to overwrites
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1

