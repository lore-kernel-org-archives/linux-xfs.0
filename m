Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D0DCD611D
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 18:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377520AbjJISSg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 14:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377414AbjJISSg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 14:18:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93239C;
        Mon,  9 Oct 2023 11:18:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A89AC433C7;
        Mon,  9 Oct 2023 18:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696875514;
        bh=1typOJlHDpbYjmnrNjpM9Dma+2lUr2HvGcbHAT8kdNI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uOvhc/JkrD36JT1uym6acxUtg16QQAfsn0b6bDlxTyAvpmNOVv7JH+jeoEcYrQU2E
         dITZwJfGHGH8n8FeNtpipFN/I/SlaL2lRw3dOHEcq5/qcbKnKxc50Rns47vhwtJwUR
         iePTHFsBf+g300/vActH6XegoJWtAuAog3hndsIda3dAX5Q4AnTwZwy0vXLOYVqkzi
         bdMO4TH1Iy0+xkNugzN6WCxEb+F0yYeQM8ryIlWFnO4ZGaifTGIos4Mu2/IQmQsNR4
         N1H9qapLH9CpkB0Uzwvhu4dHmN41Bw6VeMhRcD7omcpnCDnj9ViLVRlB+B4pCSKArU
         Grj7+68+tL4yQ==
Subject: [PATCH 1/3] xfs/178: don't fail when SCRATCH_DEV contains random xfs
 superblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 09 Oct 2023 11:18:33 -0700
Message-ID: <169687551395.3948976.8425812597156927952.stgit@frogsfrogsfrogs>
In-Reply-To: <169687550821.3948976.6892161616008393594.stgit@frogsfrogsfrogs>
References: <169687550821.3948976.6892161616008393594.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When I added an fstests config for "RAID" striping (aka MKFS_OPTIONS='-d
su=128k,sw=4'), I suddenly started seeing this test fail sporadically
with:

--- /tmp/fstests/tests/xfs/178.out	2023-07-11 12:18:21.714970364 -0700
+++ /var/tmp/fstests/xfs/178.out.bad	2023-07-25 22:05:39.756000000 -0700
@@ -10,6 +10,20 @@ bad primary superblock - bad magic numbe

 attempting to find secondary superblock...
 found candidate secondary superblock...
+unable to verify superblock, continuing...
+found candidate secondary superblock...
+error reading superblock 1 -- seek to offset 584115421184 failed
+unable to verify superblock, continuing...
+found candidate secondary superblock...
+error reading superblock 1 -- seek to offset 584115421184 failed
+unable to verify superblock, continuing...
+found candidate secondary superblock...
+error reading superblock 1 -- seek to offset 584115421184 failed
+unable to verify superblock, continuing...
+found candidate secondary superblock...
+error reading superblock 1 -- seek to offset 584115421184 failed
+unable to verify superblock, continuing...
+found candidate secondary superblock...
+error reading superblock 1 -- seek to offset 584115421184 failed
+unable to verify superblock, continuing...
+found candidate secondary superblock...
+error reading superblock 1 -- seek to offset 584115421184 failed
+unable to verify superblock, continuing...
+found candidate secondary superblock...
 verified secondary superblock...
 writing modified primary superblock
 sb root inode INO inconsistent with calculated value INO

Eventually I tracked this down to a mis-interaction between the test,
xfs_repair, and the storage device.

The storage advertises SCSI UNMAP support, but it is of the variety
where the UNMAP command returns immediately but takes its time to unmap
in the background.  Subsequent rereads are allowed to return stale
contents, per DISCARD semantics.

When the fstests cloud is not busy, the old contents disappear in a few
seconds.  However, at peak utilization, there are ~75 VMs running, and
the storage backend can take several minutes to commit these background
requests.

When we zero the primary super and start xfs_repair on SCRATCH_DEV, it
will walk the device looking for secondary supers.  Most of the time it
finds the actual AG 1 secondary super, but sometimes it finds ghosts
from previous formats.  When that happens, xfs_repair will talk quite a
bit about those failed secondaries, even if it eventually finds an
acceptable secondary sb and completes the repair.

Filter out the messages about secondary supers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/178     |    9 ++++++++-
 tests/xfs/178.out |    2 --
 2 files changed, 8 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/178 b/tests/xfs/178
index a65197cde3..fee1e92bf3 100755
--- a/tests/xfs/178
+++ b/tests/xfs/178
@@ -10,13 +10,20 @@
 . ./common/preamble
 _begin_fstest mkfs other auto
 
+filter_repair() {
+	_filter_repair | sed \
+		-e '/unable to verify superblock, continuing/d' \
+		-e '/found candidate secondary superblock/d' \
+		-e '/error reading superblock.*-- seek to offset/d'
+}
+
 # dd the 1st sector then repair
 _dd_repair_check()
 {
 	#dd first sector
 	dd if=/dev/zero of=$1 bs=$2 count=1 2>&1 | _filter_dd
 	#xfs_repair
-	_scratch_xfs_repair 2>&1 | _filter_repair
+	_scratch_xfs_repair 2>&1 | filter_repair
 	#check repair
 	if _check_scratch_fs; then
         	echo "repair passed"
diff --git a/tests/xfs/178.out b/tests/xfs/178.out
index 0bebe553eb..711e90cc26 100644
--- a/tests/xfs/178.out
+++ b/tests/xfs/178.out
@@ -9,7 +9,6 @@ Phase 1 - find and verify superblock...
 bad primary superblock - bad magic number !!!
 
 attempting to find secondary superblock...
-found candidate secondary superblock...
 verified secondary superblock...
 writing modified primary superblock
 sb root inode INO inconsistent with calculated value INO
@@ -45,7 +44,6 @@ Phase 1 - find and verify superblock...
 bad primary superblock - bad magic number !!!
 
 attempting to find secondary superblock...
-found candidate secondary superblock...
 verified secondary superblock...
 writing modified primary superblock
 sb root inode INO inconsistent with calculated value INO

