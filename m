Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E43BC4332B
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39F7364E5B
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhBJC5M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 21:57:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:41474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229711AbhBJC5M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 21:57:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42FD664E53;
        Wed, 10 Feb 2021 02:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612925791;
        bh=9rK37SCHWoZMw/WASHAYk0IjcDG0QLe4uPhRZsxhAaY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XiDApiD2/l+RASYs03cHj9Sfw5O81o00FtAo+aVOBD5HzYkww1i1xOW3eAKPolBVX
         UCitH/r4CLUBZb6NXWL3XYQMPg0PBK0VCa3u6oHmTYds7S1bnqwWN0gwxuDCTlvXju
         hF4QCOgAnZ1pi/PYRyQ8ynMExi9fGE6QB5kFAuh61xKAa3dHpPhXprHZjtf2sQ0Y1i
         f9/VRcNx6wIDFPtZnuFFlZQ5lfbLxNrXblAjgxtTgTeI18yeRXTgY7YkiB5HOu2/6I
         7q8RMjhApOxZbqfww+Hmg3ihNZ2PKw4g1mUOh9g/9UqBP0syNVLXSUeH9TXReRguOb
         RDF0vfA8H1wBg==
Subject: [PATCH 2/6] common: capture metadump output if xfs filesystem check
 fails
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 09 Feb 2021 18:56:30 -0800
Message-ID: <161292579087.3504537.10519481439481869013.stgit@magnolia>
In-Reply-To: <161292577956.3504537.3260962158197387248.stgit@magnolia>
References: <161292577956.3504537.3260962158197387248.stgit@magnolia>
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
 common/xfs |   26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)


diff --git a/README b/README
index 43bb0cee..36f72088 100644
--- a/README
+++ b/README
@@ -109,6 +109,8 @@ Preparing system for tests:
              - Set TEST_FS_MODULE_RELOAD=1 to unload the module and reload
                it between test invocations.  This assumes that the name of
                the module is the same as FSTYP.
+	     - Set SNAPSHOT_CORRUPT_XFS=1 to record compressed metadumps of XFS
+	       filesystems if the various stages of _check_xfs_filesystem fail.
 
         - or add a case to the switch in common/config assigning
           these variables based on the hostname of your test
diff --git a/common/xfs b/common/xfs
index 2156749d..ad1eb6ee 100644
--- a/common/xfs
+++ b/common/xfs
@@ -432,6 +432,21 @@ _supports_xfs_scrub()
 	return 0
 }
 
+# Save a compressed snapshot of a corrupt xfs filesystem for later debugging.
+_snapshot_xfs() {
+	local metadump="$1"
+	local device="$2"
+	local logdev="$3"
+	local options="-a -o"
+
+	if [ "$logdev" != "none" ]; then
+		options="$options -l $logdev"
+	fi
+
+	$XFS_METADUMP_PROG $options "$device" "$metadump" >> "$seqres.full" 2>&1
+	gzip -f "$metadump" >> "$seqres.full" 2>&1 &
+}
+
 # run xfs_check and friends on a FS.
 _check_xfs_filesystem()
 {
@@ -482,6 +497,9 @@ _check_xfs_filesystem()
 		# mounted ...
 		mountpoint=`_umount_or_remount_ro $device`
 	fi
+	if [ "$ok" -ne 1 ] && [ "$SNAPSHOT_CORRUPT_XFS" = "1" ]; then
+		_snapshot_xfs "$seqres.scrub.md" "$device" "$2"
+	fi
 
 	$XFS_LOGPRINT_PROG -t $extra_log_options $device 2>&1 \
 		| tee $tmp.logprint | grep -q "<CLEAN>"
@@ -491,6 +509,8 @@ _check_xfs_filesystem()
 		cat $tmp.logprint			>>$seqres.full
 		echo "*** end xfs_logprint output"	>>$seqres.full
 
+		test "$SNAPSHOT_CORRUPT_XFS" = "1" && \
+			_snapshot_xfs "$seqres.logprint.md" "$device" "$2"
 		ok=0
 	fi
 
@@ -516,6 +536,8 @@ _check_xfs_filesystem()
 		cat $tmp.repair				>>$seqres.full
 		echo "*** end xfs_repair output"	>>$seqres.full
 
+		test "$SNAPSHOT_CORRUPT_XFS" = "1" && \
+			_snapshot_xfs "$seqres.repair.md" "$device" "$2"
 		ok=0
 	fi
 	rm -f $tmp.fs_check $tmp.logprint $tmp.repair
@@ -529,6 +551,8 @@ _check_xfs_filesystem()
 			cat $tmp.repair				>>$seqres.full
 			echo "*** end xfs_repair output"	>>$seqres.full
 
+			test "$SNAPSHOT_CORRUPT_XFS" = "1" && \
+				_snapshot_xfs "$seqres.rebuild.md" "$device" "$2"
 			ok=0
 		fi
 		rm -f $tmp.repair
@@ -540,6 +564,8 @@ _check_xfs_filesystem()
 			cat $tmp.repair				>>$seqres.full
 			echo "*** end xfs_repair output"	>>$seqres.full
 
+			test "$SNAPSHOT_CORRUPT_XFS" = "1" && \
+				_snapshot_xfs "$seqres.rebuildrepair.md" "$device" "$2"
 			ok=0
 		fi
 		rm -f $tmp.repair

