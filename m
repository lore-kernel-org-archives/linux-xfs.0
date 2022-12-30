Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF5EC3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235950AbiLaAsT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235851AbiLaAsS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:48:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1652E1C90A;
        Fri, 30 Dec 2022 16:48:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA4FF61D5F;
        Sat, 31 Dec 2022 00:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1345EC433D2;
        Sat, 31 Dec 2022 00:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447697;
        bh=c8QkEqe00lw8DQ0TO3dWToOxaWxUcwYcOP0E/w0lp1k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e3x/uW3q5Bkm+hf4lHUKE4DLuxbl2X0SygOtv0DAcKXa86PCBSUVIAit5H++pav3d
         +lU/bNUvvZJYK8quiBZdRK92OXRMAjeQyq+gDU+sppsvrHzQ3wGDBNs8Kt9qPs48KB
         OETchGE8ffCy8E//5watHGAmDRhuc/xNIOBUo/KM/neXp6eoWanWj6+PjtGH+ieMTI
         KHq2GMrDc/2X3PzO/4tvmyYY58g8mDUZmPUFNNd6lpw0LmdjC3tGfdpQHkZq2BRc8L
         PZk8ABXfAivUKRugYsLpgovTFCddftjIO0qLkJ/XgqD1poBD1egEoaiHT+SoGLdSz3
         +kakcAmH/M4UQ==
Subject: [PATCH 16/24] xfs/{35[45],455}: fix bogus corruption errors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:41 -0800
Message-ID: <167243878115.730387.3527984376924446960.stgit@magnolia>
In-Reply-To: <167243877899.730387.9276624623424433346.stgit@magnolia>
References: <167243877899.730387.9276624623424433346.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The AGFL fuzz tests first fuzz the entire block header, and second
extract flfirst from the AGF header to start a second round of targeted
fuzzing of live bno pointers in the AGFL.  However, flfirst (and the
AGFL field detection at the start of the second round of fuzzing) are
detected after we've already been fuzz testing, which means that the
AGFL might be garbage because repair failed or was not called.  If this
is the case, test will fail because the _scratch_xfs_db -c 'agf 0' -c
'p flfirst' call emits things like this:

Fuzz AGFL flfirst
Metadata corruption detected at 0x55f4f789fbc0, xfs_agfl block 0x3/0x200
Metadata corruption detected at 0x55b7356e0bc0, xfs_agfl block 0x3/0x200
Done fuzzing AGFL flfirst

Fix this by restoring the scratch fs before probing flfirst and starting
the second round of fuzzing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/354 |    7 ++++++-
 tests/xfs/355 |    7 ++++++-
 tests/xfs/455 |    7 ++++++-
 3 files changed, 18 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/354 b/tests/xfs/354
index b10ce1d68f..8abf527ea6 100755
--- a/tests/xfs/354
+++ b/tests/xfs/354
@@ -28,8 +28,13 @@ echo "Fuzz AGFL"
 _scratch_xfs_fuzz_metadata '' 'offline' 'agfl 0' >> $seqres.full
 echo "Done fuzzing AGFL"
 
-echo "Fuzz AGFL flfirst"
+# Restore a correct copy of the filesystem before we start the second round of
+# fuzzing.  This avoids corruption errors from xfs_db when we probe for flfirst
+# in the AGF and later when _scratch_xfs_fuzz_metadata probes the AGFL fields.
+__scratch_xfs_fuzz_mdrestore
 flfirst=$(_scratch_xfs_db -c 'agf 0' -c 'p flfirst' | sed -e 's/flfirst = //g')
+
+echo "Fuzz AGFL flfirst"
 SCRATCH_XFS_LIST_METADATA_FIELDS="bno[${flfirst}]" _scratch_xfs_fuzz_metadata '' 'offline' 'agfl 0' >> $seqres.full
 echo "Done fuzzing AGFL flfirst"
 
diff --git a/tests/xfs/355 b/tests/xfs/355
index 530c9a970a..2d552a591c 100755
--- a/tests/xfs/355
+++ b/tests/xfs/355
@@ -28,8 +28,13 @@ echo "Fuzz AGFL"
 _scratch_xfs_fuzz_metadata '' 'online' 'agfl 0' >> $seqres.full
 echo "Done fuzzing AGFL"
 
-echo "Fuzz AGFL flfirst"
+# Restore a correct copy of the filesystem before we start the second round of
+# fuzzing.  This avoids corruption errors from xfs_db when we probe for flfirst
+# in the AGF and later when _scratch_xfs_fuzz_metadata probes the AGFL fields.
+__scratch_xfs_fuzz_mdrestore
 flfirst=$(_scratch_xfs_db -c 'agf 0' -c 'p flfirst' | sed -e 's/flfirst = //g')
+
+echo "Fuzz AGFL flfirst"
 SCRATCH_XFS_LIST_METADATA_FIELDS="bno[${flfirst}]" _scratch_xfs_fuzz_metadata '' 'online' 'agfl 0' >> $seqres.full
 echo "Done fuzzing AGFL flfirst"
 
diff --git a/tests/xfs/455 b/tests/xfs/455
index 96820bc3b8..9f06c71fa2 100755
--- a/tests/xfs/455
+++ b/tests/xfs/455
@@ -29,8 +29,13 @@ echo "Fuzz AGFL"
 _scratch_xfs_fuzz_metadata '' 'none' 'agfl 0' >> $seqres.full
 echo "Done fuzzing AGFL"
 
-echo "Fuzz AGFL flfirst"
+# Restore a correct copy of the filesystem before we start the second round of
+# fuzzing.  This avoids corruption errors from xfs_db when we probe for flfirst
+# in the AGF and later when _scratch_xfs_fuzz_metadata probes the AGFL fields.
+__scratch_xfs_fuzz_mdrestore
 flfirst=$(_scratch_xfs_db -c 'agf 0' -c 'p flfirst' | sed -e 's/flfirst = //g')
+
+echo "Fuzz AGFL flfirst"
 SCRATCH_XFS_LIST_METADATA_FIELDS="bno[${flfirst}]" _scratch_xfs_fuzz_metadata '' 'none' 'agfl 0' >> $seqres.full
 echo "Done fuzzing AGFL flfirst"
 

