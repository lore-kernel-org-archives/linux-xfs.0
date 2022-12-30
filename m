Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2668AC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236323AbiLaDJP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236316AbiLaDJO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:09:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AF61054D;
        Fri, 30 Dec 2022 19:09:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6089F61D39;
        Sat, 31 Dec 2022 03:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B975EC433EF;
        Sat, 31 Dec 2022 03:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456152;
        bh=K5+CfoR/yWPJrjuFDFxGWGskGStK+cRvXlhc1OYHuPU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K0+6ZrSZa0VtdogAojvGUkvSc/WGsmkeBMPg44kti192PGEnbFkmJ4JP1/OL4VWTY
         U0LRqYPteIfRh+ss+UjbiK66LbvXMT7T7rnfIRQisMZqtf9gXxhtxr3AdvdubAKJH+
         N4qoTNXtWyo/WuxjTnE6SXCyeSWv1+5O04aJ/Fryk2YMf1rmo5ywkKU4XJcrkMVr5Q
         M9ePkSh2s9DUPQrandnvq8xphNDoKgasMBi2WReCqfzV5siQBSVDlZgkPiKobTV6cb
         mkke5CBGJp7uoO04SklCVqMzdKmSn6XNJsYsJ5v8yDFrDY5BpyGdHjfTB2B4rMmAiG
         2BKpClTHyx9+w==
Subject: [PATCH 3/4] common/ext4: reformat external logs during mdrestore
 operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:36 -0800
Message-ID: <167243883649.738384.9931798542555490230.stgit@magnolia>
In-Reply-To: <167243883613.738384.6883268151338937809.stgit@magnolia>
References: <167243883613.738384.6883268151338937809.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The e2image file format doesn't support the capture of external log
devices, which means that mdrestore ought to reformat the external log
to get the restored filesystem to work again.  The common/populate code
could already do this, so push it to the common ext4 helper.

While we're at it, fix the uncareful usage of SCRATCH_LOGDEV in the
populate code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/ext4     |   17 ++++++++++++++++-
 common/populate |   16 ++--------------
 2 files changed, 18 insertions(+), 15 deletions(-)


diff --git a/common/ext4 b/common/ext4
index 3dcbfe17c9..5171b8df68 100644
--- a/common/ext4
+++ b/common/ext4
@@ -134,7 +134,8 @@ _ext4_mdrestore()
 {
 	local metadump="$1"
 	local device="$2"
-	shift; shift
+	local logdev="$3"
+	shift; shift; shift
 	local options="$@"
 
 	# If we're configured for compressed dumps and there isn't already an
@@ -148,6 +149,20 @@ _ext4_mdrestore()
 	test -r "$metadump" || return 1
 
 	$E2IMAGE_PROG $options -r "${metadump}" "${SCRATCH_DEV}"
+	res=$?
+	test $res -ne 0 && return $res
+
+	# ext4 cannot e2image external logs, so we have to reformat the log
+	# device to match the restored fs
+	if [ "${logdev}" != "none" ]; then
+		local fsuuid="$($DUMPE2FS_PROG -h "${SCRATCH_DEV}" 2>/dev/null | \
+				grep 'Journal UUID:' | \
+				sed -e 's/Journal UUID:[[:space:]]*//g')"
+		$MKFS_EXT4_PROG -O journal_dev "${logdev}" \
+				-F -U "${fsuuid}"
+		res=$?
+	fi
+	return $res
 }
 
 # this test requires the ext4 kernel support crc feature on scratch device
diff --git a/common/populate b/common/populate
index 08c4bdc151..095e771d67 100644
--- a/common/populate
+++ b/common/populate
@@ -912,20 +912,8 @@ _scratch_populate_restore_cached() {
 		return $?
 		;;
 	"ext2"|"ext3"|"ext4")
-		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}"
-		ret=$?
-		test $ret -ne 0 && return $ret
-
-		# ext4 cannot e2image external logs, so we have to reformat
-		# the scratch device to match the restored fs
-		if [ -n "${SCRATCH_LOGDEV}" ]; then
-			local fsuuid="$($DUMPE2FS_PROG -h "${SCRATCH_DEV}" 2>/dev/null | \
-					grep 'Journal UUID:' | \
-					sed -e 's/Journal UUID:[[:space:]]*//g')"
-			$MKFS_EXT4_PROG -O journal_dev "${SCRATCH_LOGDEV}" \
-					-F -U "${fsuuid}"
-		fi
-		return 0
+		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}" "${logdev}"
+		return $?
 		;;
 	esac
 	return 1

