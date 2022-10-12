Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18228C4321E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Oct 2022 01:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiJLBpl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiJLBpk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2022 21:45:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C530B642F2;
        Tue, 11 Oct 2022 18:45:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35CC4B818B5;
        Wed, 12 Oct 2022 01:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFDFDC433C1;
        Wed, 12 Oct 2022 01:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665539134;
        bh=q6LvyT2/Wm1dA9NOPD/9Q0DdubSsQCL33/i7nE3Jgow=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=A55LFStRXOZK4mblHJMCSCiyry5GgHaCbW0z8QvuSdJSwl1xQMLeOA9zE+4W2IOpk
         BUiqilRurNX0hp89fX1mKTsqzel3wKLfO7Xjb+JwGLczfnn6rL95Aa8um6COJAsfE/
         n9m9CTSY5Bm13iftoUir8I/8Jxz+oV1WaY+MQZFZGhFem+3ixNgGKarteAlEXrDVkj
         PhAKzse2kUnbzl3RBDjSreCiK82LsNT4LFerALiMgHmZ0cS/CHt+aWGVojuyvRe8kg
         6I/w60RRvVoJ8HUhedAx4SEpaEqnn5xEjBZ8X70TOEuks8jwNqo7vCAuXQQko57bok
         dA+U75CLCNOjQ==
Subject: [PATCH 2/5] populate: wipe external xfs log devices when restoring a
 cached image
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Oct 2022 18:45:33 -0700
Message-ID: <166553913349.422450.12686256615707425089.stgit@magnolia>
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
be unmounted cleanly, so we never save the contents of external log
devices.

Unfortunately, the cache restore code fails to wipe the external log
when restoring a clean image, so we end up with strange test failures
because the log doesn't match the filesystem:

* ERROR: mismatched uuid in log
*            SB : 5ffec625-d3bb-4f4e-a181-1f9efe543d9c
*            log: 607bd75a-a63d-400c-8779-2139f0a3d384

Worse yet, xfs_repair will overwrite a filesystem's uuid with the log
uuid, which leads to corruption messages later on:

Metadata corruption detected at 0x561f69a9a2a8, xfs_agf block 0x8/0x1000
xfs_db: cannot init perag data (117). Continuing anyway.

Solve this by wiping the log device when restoring.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)


diff --git a/common/populate b/common/populate
index b501c2fe45..0bd78e0a0a 100644
--- a/common/populate
+++ b/common/populate
@@ -11,7 +11,12 @@ _require_populate_commands() {
 	_require_xfs_io_command "falloc"
 	_require_xfs_io_command "fpunch"
 	_require_test_program "punch-alternating"
-	_require_command "$XFS_DB_PROG" "xfs_db"
+	case "${FSTYP}" in
+	"xfs")
+		_require_command "$XFS_DB_PROG" "xfs_db"
+		_require_command "$WIPEFS_PROG" "wipefs"
+		;;
+	esac
 }
 
 _require_xfs_db_blocktrash_z_command() {
@@ -851,7 +856,19 @@ _scratch_populate_restore_cached() {
 
 	case "${FSTYP}" in
 	"xfs")
-		xfs_mdrestore "${metadump}" "${SCRATCH_DEV}" && return 0
+		xfs_mdrestore "${metadump}" "${SCRATCH_DEV}"
+		res=$?
+		test $res -ne 0 && return $res
+
+		# Cached images should have been unmounted cleanly, so if
+		# there's an external log we need to wipe it and run repair to
+		# format it to match this filesystem.
+		if [ -n "${SCRATCH_LOGDEV}" ]; then
+			$WIPEFS_PROG -a "${SCRATCH_LOGDEV}"
+			_scratch_xfs_repair
+			res=$?
+		fi
+		return $res
 		;;
 	"ext2"|"ext3"|"ext4")
 		# ext4 cannot e2image external logs, so we cannot restore

