Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86CCDC83F12
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239951AbjH2XKb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239934AbjH2XKE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:10:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055FEFD;
        Tue, 29 Aug 2023 16:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F8C261208;
        Tue, 29 Aug 2023 23:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECACBC433C8;
        Tue, 29 Aug 2023 23:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350600;
        bh=DuN6xtJz12N0695qCMcwpsZIt2qwbzyKB8EJ4P1Jxuk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=J7DKExPiboHISHGVlY7azaX/Ofk8D8MgOC5jUp8L7Q9sWpwojfZcf/oJzNLRrHAOO
         5gXlI6kYLWXSRe+NWvhK5hsSrfhhfymbLExx3j7bOfQ8J20bMVxaywkXJvYr/2RZfK
         ChsrvV1Mzc6qRtbWGCCwUbzdmX6IQAe9ct86xCvitEJZpXpPyzqfbVmavBA7Maa152
         RQ6bIfhRiNNMr1OlWZGKYHW/3iUtuD2JM/vdfr6KmcPPdAIlrcPJxSQVtXNV9r4c67
         E+yDeDnW01+71zvTB/zQBqp2sKQW9vkwPiVdxy3GeTwnnMpkJOFgCJHbJsmoEdJIF9
         OvxI61UvHSi0Q==
Subject: [PATCH 2/2] xfs/270: actually test log recovery with unknown rocompat
 features
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, david@fromorbit.com,
        sandeen@sandeen.net
Date:   Tue, 29 Aug 2023 16:09:59 -0700
Message-ID: <169335059947.3526409.5659717618354794568.stgit@frogsfrogsfrogs>
In-Reply-To: <169335058807.3526409.15604604578540143202.stgit@frogsfrogsfrogs>
References: <169335058807.3526409.15604604578540143202.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that log recovery will not succeed if there are unknown
rocompat features in the superblock and the log is dirty.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/270     |   82 ++++++++++++++++++++++++++++++++++++-----------------
 tests/xfs/270.out |    2 +
 2 files changed, 58 insertions(+), 26 deletions(-)


diff --git a/tests/xfs/270 b/tests/xfs/270
index 511dfe9fcd..08bfb1c4d4 100755
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
@@ -85,6 +92,29 @@ fi
 
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
+# ro mount should succeed even with log recovery
+echo "ro mount test"
+_try_scratch_mount -o ro 2>>$seqres.full
+if [ $? -ne 0 ]; then
+	_fail "ro mount test failed"
+fi
+cat $SCRATCH_MNT/testfile > /dev/null
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

