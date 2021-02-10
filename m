Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32581C433E9
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6F7C64E54
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbhBJC5s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 21:57:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:41616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233689AbhBJC5r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 21:57:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC04264E56;
        Wed, 10 Feb 2021 02:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612925821;
        bh=Id3sApaEtPNT2zXbLul2XIraSHK4YF63UhDYzcj7QHU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Jbs92Nf2GZUDMT2+7lDxe0GguiTrhDvtm8v0H37Wku2FxRyp1XZcchZRdaVKp7/h8
         ejoUo+vBjN2ZDgoM4a80lucflKTw7JejQrLJJrbWsSdLos3Sue5Tqrc4giUGoEbQpS
         hsU6cqoOUGKTwBAHnssv3rIh7gamD9k/jsLf4QkEwT1pMiptwFdal3yFqzAh49/taw
         WQVdnr2I07xSV0d61VXJK22LkUVLq7iSjS7ITzdxvM3AKapQ/isTJKN0MuILBTLTeX
         VOaBrbl77gRUgLcDXDqkwVURrDKrIhdGAuOOlhRGHO1ID2ntOsdESFF/EqaY9brBsk
         +t8Tc+xdm6k1A==
Subject: [PATCH 1/2] xfs: fix filestreams tests when rtinherit=1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 09 Feb 2021 18:57:00 -0800
Message-ID: <161292582052.3504701.14931035226865872354.stgit@magnolia>
In-Reply-To: <161292581498.3504701.4053663562108530233.stgit@magnolia>
References: <161292581498.3504701.4053663562108530233.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The filestreams allocator can only be selected for files that reside on
the data volume.  In commit ee3e0010, we sprinkled calls to
_require_no_rtinherit in the filestreams tests so that there wouldn't be
regressions reported if the filesystem is formatted with -d rtinherit=1.

This unnecessarily limits test coverage because userspace can control
the device selection parameters quite easily with xfs_io chattr.  Make
the filestreams tests unset SCRATCH_RTDEV so that the allocator isn't
thrown off by the rtbitmap consuming space on the data device.

Fixes: ee3e0010 ("xfs/realtime: add _require_no_rtinherit function")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/filestreams |    5 +++++
 tests/xfs/170      |    1 -
 tests/xfs/171      |    1 -
 tests/xfs/172      |    1 -
 tests/xfs/173      |    1 -
 tests/xfs/174      |    1 -
 tests/xfs/445      |    5 +++++
 7 files changed, 10 insertions(+), 5 deletions(-)


diff --git a/common/filestreams b/common/filestreams
index 267dcb3c..8165effe 100644
--- a/common/filestreams
+++ b/common/filestreams
@@ -90,6 +90,11 @@ _test_streams() {
 	local use_directio="$7"
 	local expected_result="$8"	# "fail" if failure is expected
 
+	# Disable the scratch rt device to avoid test failures relating to the
+	# rt bitmap consuming free space in our small data device and throwing
+	# off the filestreams allocator.
+	unset SCRATCH_RTDEV
+
 	local size=`expr $agsize \* 1024 \* 1024 \* $agcount`
 	_scratch_mkfs_xfs -dsize=$size,agcount=$agcount >/dev/null 2>&1 \
 		|| _fail "mkfs failed"
diff --git a/tests/xfs/170 b/tests/xfs/170
index f7f0dd27..84023e4d 100755
--- a/tests/xfs/170
+++ b/tests/xfs/170
@@ -33,7 +33,6 @@ _cleanup()
 _supported_fs xfs
 
 _require_scratch
-_require_no_rtinherit
 
 _check_filestreams_support || _notrun "filestreams not available"
 
diff --git a/tests/xfs/171 b/tests/xfs/171
index 35503b23..0239081a 100755
--- a/tests/xfs/171
+++ b/tests/xfs/171
@@ -32,7 +32,6 @@ _cleanup()
 _supported_fs xfs
 
 _require_scratch
-_require_no_rtinherit
 
 _check_filestreams_support || _notrun "filestreams not available"
 
diff --git a/tests/xfs/172 b/tests/xfs/172
index 36b4e650..56c34e69 100755
--- a/tests/xfs/172
+++ b/tests/xfs/172
@@ -32,7 +32,6 @@ _cleanup()
 _supported_fs xfs
 
 _require_scratch
-_require_no_rtinherit
 
 _check_filestreams_support || _notrun "filestreams not available"
 
diff --git a/tests/xfs/173 b/tests/xfs/173
index 8ed86d96..f37d2719 100755
--- a/tests/xfs/173
+++ b/tests/xfs/173
@@ -32,7 +32,6 @@ _cleanup()
 _supported_fs xfs
 
 _require_scratch
-_require_no_rtinherit
 
 _check_filestreams_support || _notrun "filestreams not available"
 
diff --git a/tests/xfs/174 b/tests/xfs/174
index 58038939..fc3de04f 100755
--- a/tests/xfs/174
+++ b/tests/xfs/174
@@ -32,7 +32,6 @@ _cleanup()
 _supported_fs xfs
 
 _require_scratch
-_require_no_rtinherit
 
 _check_filestreams_support || _notrun "filestreams not available"
 
diff --git a/tests/xfs/445 b/tests/xfs/445
index 7215fa59..d35010a9 100755
--- a/tests/xfs/445
+++ b/tests/xfs/445
@@ -57,6 +57,11 @@ _require_xfs_io_command "falloc"
 # check for filestreams
 _check_filestreams_support || _notrun "filestreams not available"
 
+# Disable the scratch rt device to avoid test failures relating to the rt
+# bitmap consuming free space in our small data device and throwing off the
+# filestreams allocator.
+unset SCRATCH_RTDEV
+
 # use small AGs for frequent stream switching
 _scratch_mkfs_xfs -d agsize=20m,size=2g >> $seqres.full 2>&1 ||
 	_fail "mkfs failed"

