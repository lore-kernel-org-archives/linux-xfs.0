Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D508AC43381
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C15CD6528D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhCIEjf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:39:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229714AbhCIEjM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:39:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA85065275;
        Tue,  9 Mar 2021 04:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264751;
        bh=Tq45zGehPxRMEUw5QknLtgg5WA3vn1LE+HtkhsKU6wc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BF2e8v1Pe435iSuecHrZxPn0tQ5tEllv6LCz2L6gtYnVtSnLZqE1odK/6Wocg9sxW
         4ZWj94C2EEM11xXGDoml6UX79aXxS3g9qsTsQQjdVUHRlp3AoUePacr7aIRBZYsD9k
         5xyuNP4EERc4wM8DJsOgNB7SoTNg+DiB8cmUg4EMNIyKyCrSxKM7VWJ1LCo5H+syhc
         Pm6LHy76Js8eM4ZreNQ7CrtmVAugn4Pq0Iy2F9Snn9KnWGmJp6NfiAOblQsSUqPrtn
         F8BxeIcVHtzrhrjOUWZXMbixzbqCDtnziO6QibfXzZY1o3EV8vNIDYmjQ/JDoqB7no
         jM4NCrE6I7MdQ==
Subject: [PATCH 1/4] common: capture metadump output if xfs filesystem check
 fails
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:39:11 -0800
Message-ID: <161526475154.1212855.395880843881325184.stgit@magnolia>
In-Reply-To: <161526474588.1212855.9208390435676413014.stgit@magnolia>
References: <161526474588.1212855.9208390435676413014.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@djwong.org>

Capture metadump output when various userspace repair and checker tools
fail or indicate corruption, to aid in debugging.  We don't bother to
annotate xfs_check because it's bitrotting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 README     |    2 ++
 common/xfs |   50 ++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 46 insertions(+), 6 deletions(-)


diff --git a/README b/README
index 43bb0cee..b00328ac 100644
--- a/README
+++ b/README
@@ -109,6 +109,8 @@ Preparing system for tests:
              - Set TEST_FS_MODULE_RELOAD=1 to unload the module and reload
                it between test invocations.  This assumes that the name of
                the module is the same as FSTYP.
+             - Set DUMP_CORRUPT_FS=1 to record metadata dumps of XFS
+               filesystems if a filesystem check fails.
 
         - or add a case to the switch in common/config assigning
           these variables based on the hostname of your test
diff --git a/common/xfs b/common/xfs
index 2156749d..b30d289f 100644
--- a/common/xfs
+++ b/common/xfs
@@ -432,6 +432,27 @@ _supports_xfs_scrub()
 	return 0
 }
 
+# Save a snapshot of a corrupt xfs filesystem for later debugging.
+_xfs_metadump() {
+	local metadump="$1"
+	local device="$2"
+	local logdev="$3"
+	local compressopt="$4"
+	shift; shift; shift; shift
+	local options="$@"
+	test -z "$options" && options="-a -o"
+
+	if [ "$logdev" != "none" ]; then
+		options="$options -l $logdev"
+	fi
+
+	$XFS_METADUMP_PROG $options "$device" "$metadump"
+	res=$?
+	[ "$compressopt" = "compress" ] && [ -n "$DUMP_COMPRESSOR" ] &&
+		$DUMP_COMPRESSOR "$metadump" &> /dev/null
+	return $res
+}
+
 # run xfs_check and friends on a FS.
 _check_xfs_filesystem()
 {
@@ -448,14 +469,16 @@ _check_xfs_filesystem()
 		extra_options="-f"
 	fi
 
-	if [ "$2" != "none" ]; then
-		extra_log_options="-l$2"
-		extra_mount_options="-ologdev=$2"
+	local logdev="$2"
+	if [ "$logdev" != "none" ]; then
+		extra_log_options="-l$logdev"
+		extra_mount_options="-ologdev=$logdev"
 	fi
 
-	if [ "$3" != "none" ]; then
-		extra_rt_options="-r$3"
-		extra_mount_options=$extra_mount_options" -ortdev=$3"
+	local rtdev="$3"
+	if [ "$rtdev" != "none" ]; then
+		extra_rt_options="-r$rtdev"
+		extra_mount_options=$extra_mount_options" -ortdev=$rtdev"
 	fi
 	extra_mount_options=$extra_mount_options" $MOUNT_OPTIONS"
 
@@ -520,8 +543,15 @@ _check_xfs_filesystem()
 	fi
 	rm -f $tmp.fs_check $tmp.logprint $tmp.repair
 
+	if [ "$ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
+		local flatdev="$(basename "$device")"
+		_xfs_metadump "$seqres.$flatdev.check.md" "$device" "$logdev" \
+			compress >> $seqres.full
+	fi
+
 	# Optionally test the index rebuilding behavior.
 	if [ -n "$TEST_XFS_REPAIR_REBUILD" ]; then
+		rebuild_ok=1
 		$XFS_REPAIR_PROG $extra_options $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
 		if [ $? -ne 0 ]; then
 			_log_err "_check_xfs_filesystem: filesystem on $device is inconsistent (rebuild)"
@@ -530,6 +560,7 @@ _check_xfs_filesystem()
 			echo "*** end xfs_repair output"	>>$seqres.full
 
 			ok=0
+			rebuild_ok=0
 		fi
 		rm -f $tmp.repair
 
@@ -541,8 +572,15 @@ _check_xfs_filesystem()
 			echo "*** end xfs_repair output"	>>$seqres.full
 
 			ok=0
+			rebuild_ok=0
 		fi
 		rm -f $tmp.repair
+
+		if [ "$rebuild_ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
+			local flatdev="$(basename "$device")"
+			_xfs_metadump "$seqres.$flatdev.rebuild.md" "$device" \
+				"$logdev" compress >> $seqres.full
+		fi
 	fi
 
 	if [ $ok -eq 0 ]; then

