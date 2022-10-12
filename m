Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D95C4167B
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Oct 2022 01:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiJLBpm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJLBpl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2022 21:45:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924455A8B7;
        Tue, 11 Oct 2022 18:45:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DB2B61343;
        Wed, 12 Oct 2022 01:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D01DC433C1;
        Wed, 12 Oct 2022 01:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665539139;
        bh=ast/Nk9U/aZ1POg5K/0/ODqYJFTxCmi3lIJJRuAtcy8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hpx1Acn8ZIGr3g1lQF9zJn+SUCIEGJFPmFUKhbm9qWQpkUN3OXDGNrOqBIyQP3obz
         py4qoHNevP0Oi0liwtn4Q+QUoyKNPCnJUGCUP+Ghdxcqfc7WOgNvXQjhCo4lrH3rfY
         e2jJVnTuaGsmyU/O82Z6CuCgK/GirNzC12XbeCymd5QMQGpfuZaxFgODpkSFfoGIFQ
         aimfozalBUlbxSTY06QZ7BB0vQUP7UaMoVnWMU4Cv1KdkBmgZRGCHgHNiTSBQbkPGe
         WFF9mOOP6DBLV+bBzM9TS21o3p15ZZcG7LMnPRM7zCSbFqum0hMmO2F6IicReWpX7l
         A26kZwooENKfQ==
Subject: [PATCH 3/5] populate: reformat external ext[34] journal devices when
 restoring a cached image
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Oct 2022 18:45:39 -0700
Message-ID: <166553913911.422450.17214876114235793554.stgit@magnolia>
In-Reply-To: <166553912229.422450.15473762183660906876.stgit@magnolia>
References: <166553912229.422450.15473762183660906876.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The fs population code has the ability to save cached metadumps of
filesystems to save time when running fstests.  The cached images should
be unmounted cleanly, so we never save the contents of external journal
devices.

Unfortunately, the cache restore code fails to reset the external
journal when restoring a clean image, so we ignore cached images because
the journal doesn't match the filesystem.  This makes test runtimes
longer than they need to be.

Solve this by reformatting the external journal to match the filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)


diff --git a/common/populate b/common/populate
index 0bd78e0a0a..66c55b682f 100644
--- a/common/populate
+++ b/common/populate
@@ -16,6 +16,9 @@ _require_populate_commands() {
 		_require_command "$XFS_DB_PROG" "xfs_db"
 		_require_command "$WIPEFS_PROG" "wipefs"
 		;;
+	ext*)
+		_require_command "$DUMPE2FS_PROG" "dumpe2fs"
+		;;
 	esac
 }
 
@@ -871,9 +874,20 @@ _scratch_populate_restore_cached() {
 		return $res
 		;;
 	"ext2"|"ext3"|"ext4")
-		# ext4 cannot e2image external logs, so we cannot restore
-		test -n "${SCRATCH_LOGDEV}" && return 1
-		e2image -r "${metadump}" "${SCRATCH_DEV}" && return 0
+		e2image -r "${metadump}" "${SCRATCH_DEV}"
+		ret=$?
+		test $ret -ne 0 && return $ret
+
+		# ext4 cannot e2image external logs, so we have to reformat
+		# the scratch device to match the restored fs
+		if [ -n "${SCRATCH_LOGDEV}" ]; then
+			local fsuuid="$($DUMPE2FS_PROG -h "${SCRATCH_DEV}" 2>/dev/null | \
+					grep 'Journal UUID:' | \
+					sed -e 's/Journal UUID:[[:space:]]*//g')"
+			$MKFS_EXT4_PROG -O journal_dev "${SCRATCH_LOGDEV}" \
+					-F -U "${fsuuid}"
+		fi
+		return 0
 		;;
 	esac
 	return 1

