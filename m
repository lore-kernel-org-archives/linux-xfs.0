Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4979EC88CB2
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 23:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbjHXX2N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237312AbjHXX2J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 19:28:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1CB19B0
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 16:28:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1433060C16
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 23:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72211C433C7;
        Thu, 24 Aug 2023 23:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692919686;
        bh=2GxWfyN7L7MXXz0DElcxJfxXrjphFMUoXKbRtKd9Cx0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=et/bUqza3PPlctb1VNS5XwC86tNUz6IP/JO11GSuqKcynsICcBX03f3zoP9ObriF4
         ak8qagydKlMcwHVXN8SYEPaq98d25iGWOtHR07of81nqWXToSgK+m07ksWAMWxGp90
         S0VT86QW1oOHrMAfP7RlGOT554l3qPtpRkQnTOzKAHuVqwJBhWWw6ktcQDZoXdbTrX
         1kWMkKxID1YHsdpzpg55FIKD/tP56n8XFtu3C581a1NwAPpwqhXc3L3FnCbauUrVcB
         TveOS7zRocbiRuiufLfpHwM6S+NP7UchHW90cYr6ojzFpiG5M3uwwzMC5ye2A4S1FS
         8nHEaabEgm9Yw==
Date:   Thu, 24 Aug 2023 16:28:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, sandeen@sandeen.net
Subject: [PATCH 5/3] xfs/270: actually test log recovery with unknown
 rocompat features
Message-ID: <20230824232805.GC17912@frogsfrogsfrogs>
References: <169291929524.220104.3844042018007786965.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169291929524.220104.3844042018007786965.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that log recovery will not succeed if there are unknown
rocompat features in the superblock and the log is dirty.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/270     |   81 ++++++++++++++++++++++++++++++++++++-----------------
 tests/xfs/270.out |    2 +
 2 files changed, 57 insertions(+), 26 deletions(-)

diff --git a/tests/xfs/270 b/tests/xfs/270
index 511dfe9fcd..ee925b0fc6 100755
--- a/tests/xfs/270
+++ b/tests/xfs/270
@@ -21,41 +21,48 @@ _supported_fs xfs
 _require_scratch_nocheck
 # Only V5 XFS disallow rw mount/remount with unknown ro-compat features
 _require_scratch_xfs_crc
-
-_scratch_mkfs_xfs >>$seqres.full 2>&1
-_scratch_mount
-echo moo > $SCRATCH_MNT/testfile
-_scratch_unmount
+_require_scratch_shutdown
 
 # set the highest bit of features_ro_compat, use it as an unknown
 # feature bit. If one day this bit become known feature, please
 # change this case.
+set_bad_rocompat() {
+	ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0")
+	echo $ro_compat | grep -q -E '^0x[[:xdigit:]]$'
+	if [[ $? != 0  ]]; then
+		echo "features_ro_compat has an invalid value."
+		return 1
+	fi
 
-ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0")
-echo $ro_compat | grep -q -E '^0x[[:xdigit:]]$'
-if [[ $? != 0  ]]; then
-	echo "features_ro_compat has an invalid value."
-fi
+	ro_compat=$(echo $ro_compat | \
+			    awk '/^0x[[:xdigit:]]+/ {
+					printf("0x%x\n", or(strtonum($1), 0x80000000))
+				}')
 
-ro_compat=$(echo $ro_compat | \
-		    awk '/^0x[[:xdigit:]]+/ {
-				printf("0x%x\n", or(strtonum($1), 0x80000000))
-			}')
+	# write the new ro compat field to the superblock
+	_scratch_xfs_set_metadata_field "features_ro_compat" "$ro_compat" "sb 0" \
+					> $seqres.full 2>&1
 
-# write the new ro compat field to the superblock
-_scratch_xfs_set_metadata_field "features_ro_compat" "$ro_compat" "sb 0" \
-				> $seqres.full 2>&1
+	# read the newly set ro compat filed for verification
+	new_ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0" \
+							2>/dev/null)
 
-# read the newly set ro compat filed for verification
-new_ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0" \
-						2>/dev/null)
+	# verify the new ro_compat field is correct. Without xfsprogs commit
+	# f4afdcb0ad ("xfs_db: clean up the salvage read callsites in set_cur()"),
+	# we can't get new_ro_compat value.
+	if [ "$new_ro_compat" != "$ro_compat" ]; then
+		echo "Unable to set new features_ro_compat. Wanted $ro_compat, got $new_ro_compat"
+		return 1
+	fi
+	return 0
+}
 
-# verify the new ro_compat field is correct. Without xfsprogs commit
-# f4afdcb0ad ("xfs_db: clean up the salvage read callsites in set_cur()"),
-# we can't get new_ro_compat value.
-if [ "$new_ro_compat" != "$ro_compat" ]; then
-	echo "Unable to set new features_ro_compat. Wanted $ro_compat, got $new_ro_compat"
-fi
+# Once with a clean filesystem...
+_scratch_mkfs_xfs >>$seqres.full 2>&1
+_scratch_mount
+echo moo > $SCRATCH_MNT/testfile
+_scratch_unmount
+set_bad_rocompat
 
 # rw mount with unknown ro-compat feature should fail
 echo "rw mount test"
@@ -85,6 +92,28 @@ fi
 
 _scratch_unmount
 
+# And again with a dirty filesystem...
+_scratch_mkfs_xfs >>$seqres.full 2>&1
+_scratch_mount
+echo moo > $SCRATCH_MNT/testfile
+$XFS_IO_PROG -x -c 'shutdown -f' "${SCRATCH_MNT}"
+_scratch_unmount
+set_bad_rocompat
+
+# rw mount with unknown ro-compat feature should fail
+echo "rw mount test"
+_try_scratch_mount 2>>$seqres.full
+if [ $? -eq 0 ]; then
+	_fail "rw mount test failed"
+fi
+
+# ro mount should not succeed due to log recovery
+echo "ro mount test"
+_try_scratch_mount -o ro 2>>$seqres.full
+if [ $? -eq 0 ]; then
+	_fail "ro mount test succeeded"
+fi
+
 # success, all done
 status=0
 exit
diff --git a/tests/xfs/270.out b/tests/xfs/270.out
index edf4c25489..a519d2f328 100644
--- a/tests/xfs/270.out
+++ b/tests/xfs/270.out
@@ -2,3 +2,5 @@ QA output created by 270
 rw mount test
 ro mount test
 rw remount test
+rw mount test
+ro mount test
