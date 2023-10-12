Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0EDBC46CA1
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 15:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379065AbjJLPJZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 11:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379226AbjJLPJZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 11:09:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5669BBE;
        Thu, 12 Oct 2023 08:09:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFB0C433C9;
        Thu, 12 Oct 2023 15:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697123363;
        bh=c4xm7Xc8WSKFZ0+YzvQLIYbytuX3ANs0TCSoY6sm7+w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S4vP6jVARqZ3/Hni1JUa/1D0lQBeETtVkNgQoBaZjwylvBi6ZQqk600uOumF3GSMX
         Rt6I220NYp5IcPxc/Nmxr5glvDfCnY8zp8r5i09365w/E9R6TJVgKWc04QmX35JF+L
         LIRb8MHtOIG+jpkiWKI1oPRLatQNGNxGsiZbimK8tTt/VScSvamue3QIncwOnBgi09
         OdJlp0bmtOumpAfnYsJ4756PvditV5uWXtyyeDEjKdlZpaYZtZkkAstrZ1G/bs8awa
         63cA8VJlZiwcWSZqsieGbjeF7CQd3mtDBLavcunC/0yeC+Ko9ZtwAZqppEVDNYWaQg
         Xj1vGS4rsr7/Q==
Date:   Thu, 12 Oct 2023 08:09:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH v2 1/3] xfs/178: don't fail when SCRATCH_DEV contains random
 xfs superblocks
Message-ID: <20231012150922.GF21298@frogsfrogsfrogs>
References: <169687550821.3948976.6892161616008393594.stgit@frogsfrogsfrogs>
 <169687551395.3948976.8425812597156927952.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169687551395.3948976.8425812597156927952.stgit@frogsfrogsfrogs>
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

If the device doesn't support discard, _scratch_mkfs won't zero the
entire disk to remove old dead superblocks that might have been written
by previous tests.  After we shatter the primary super, the xfs_repair
scanning code can still trip over those old supers when it goes looking
for secondary supers.

Most of the time it finds the actual AG 1 secondary super, but sometimes
it finds ghosts from previous formats.  When that happens, xfs_repair
will talk quite a bit about those failed secondaries, even if it
eventually finds an acceptable secondary sb and completes the repair.

Filter out the messages about secondary supers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: fix commit message to identify the problem in fstests, drop the
irrelevant mumbbling about SCSI UNMAP
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
