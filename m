Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17BAAC25B06
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 21:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiHIVB1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 17:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiHIVAq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 17:00:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41552B62D;
        Tue,  9 Aug 2022 14:00:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB39FB8188D;
        Tue,  9 Aug 2022 21:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9CEC433C1;
        Tue,  9 Aug 2022 21:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660078838;
        bh=B+7LINfVIN5J/jLBsiVtpQl19QhMXPxoFieq1IBDMbI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UQTGBKEZByv3g0W27KAoC5VIL9v/xEb05WOnvg6rkVN6qdh/nyJIKYIFgRMxLZZ53
         EqKnauHWuHOANsiC1KptYDZ4m6eg+i8FO4+M1SrdLq1pn+KVVd9elzHRIEYwRzgbG4
         d0JIf81wn3+YP1FzHaUKbl4BoRjdpyXxmVd7xV1g5FQabhT+/td9lwAfoq3HO5Bqyo
         whpTr4yHnh1kxWaoyxe/5EE4cvupLluBhb8ggmBbVPjPrnV69iVm9q20CqJ73BQWlf
         ye03RjgHUyy2tPai6g3SlK++44H9cUWawfWGUAt7cHw3rlxU0YcInflShPLeXz4w3z
         MPZRzUk61n5JQ==
Subject: [PATCH 1/1] xfs/{015,042,076}: fix mkfs failures with nrext64=1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 09 Aug 2022 14:00:37 -0700
Message-ID: <166007883796.3274939.8920861122422263977.stgit@magnolia>
In-Reply-To: <166007883231.3274939.3963254355857450803.stgit@magnolia>
References: <166007883231.3274939.3963254355857450803.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

One of my XFS fstests systems is configured with multiple 34G block
devicesm each with a 4k LBA size for the scratch filesystem.  If I turn
on large extent counts with -i nrext64=1, I see the following failures
from each of these three tests:

-used inodes is in range
+max log size 4083 smaller than min log size 4287, filesystem is too small

Note that this particular output is dependent on having a recent
xfsprogs with "mkfs: complain about impossible log size constraints"
applied, else you get a far more obscure message about the log being too
small.

It turns out that you can simulate this pretty easily:

# truncate -s 34G /tmp/a; losetup -f -b 4096 /tmp/a
# truncate -s 34G /tmp/b; losetup -f -b 4096 /tmp/b
# mkfs.xfs -f -N /dev/loop0  -r rtdev=/dev/loop1 -d rtinherit=1,size=32m -i nrext64=1
max log size 4083 smaller than min log size 4287, filesystem is too small

If I turn off nrext64, the fs geometry I get is:

meta-data=/dev/loop0             isize=512    agcount=2, agsize=4096 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=8192, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=954, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =/dev/loop1             extsz=4096   blocks=8912896, rtextents=8912896

So it's pretty obvious what happened here -- the AG size is 4096 blocks.
mkfs has to leave enough free space in each AG to handle the AG space
btree roots, the AG headers, and the AGFL, which means the log can't be
more than 4083 blocks.  libxfs computes the minimum log size to be 4287
blocks, which is why the format fails.

Fix this problem by bumping the filesystems up to 96M, which provides
enough space in each AG to handle a ~20M internal log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/015     |    4 ++--
 tests/xfs/042     |   14 +++++++-------
 tests/xfs/042.out |    4 ++--
 tests/xfs/076     |    2 +-
 4 files changed, 12 insertions(+), 12 deletions(-)


diff --git a/tests/xfs/015 b/tests/xfs/015
index 2bb7b8d5..a7f4d243 100755
--- a/tests/xfs/015
+++ b/tests/xfs/015
@@ -40,10 +40,10 @@ _require_scratch
 # need 128M space, don't make any assumption
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
-_require_fs_space $SCRATCH_MNT 131072
+_require_fs_space $SCRATCH_MNT 196608
 _scratch_unmount
 
-_scratch_mkfs_sized $((32 * 1024 * 1024)) > $tmp.mkfs.raw || _fail "mkfs failed"
+_scratch_mkfs_sized $((96 * 1024 * 1024)) > $tmp.mkfs.raw || _fail "mkfs failed"
 cat $tmp.mkfs.raw | _filter_mkfs >$seqres.full 2>$tmp.mkfs
 # get original data blocks number and agcount
 . $tmp.mkfs
diff --git a/tests/xfs/042 b/tests/xfs/042
index d62eb045..657abd21 100755
--- a/tests/xfs/042
+++ b/tests/xfs/042
@@ -51,14 +51,14 @@ _require_scratch
 
 _do_die_on_error=message_only
 
-echo -n "Make a 48 megabyte filesystem on SCRATCH_DEV and mount... "
-_scratch_mkfs_xfs -dsize=48m,agcount=3 2>&1 >/dev/null || _fail "mkfs failed"
+echo -n "Make a 96 megabyte filesystem on SCRATCH_DEV and mount... "
+_scratch_mkfs_xfs -dsize=96m,agcount=3 2>&1 >/dev/null || _fail "mkfs failed"
 _scratch_mount
 
 echo "done"
 
-echo -n "Reserve 16 1Mb unfragmented regions... "
-for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
+echo -n "Reserve 32 1Mb unfragmented regions... "
+for i in `seq 1 32`
 do
 	_do "$XFS_IO_PROG -f -c \"resvsp 0 1m\" $SCRATCH_MNT/hole$i"
 	_do "$XFS_IO_PROG -f -c \"resvsp 0 4k\" $SCRATCH_MNT/space$i"
@@ -68,7 +68,7 @@ echo "done"
 
 # set up filesystem
 echo -n "Fill filesystem with fill file... "
-for i in `seq 0 1 31`; do
+for i in `seq 0 1 63`; do
 	_do "$XFS_IO_PROG -f -c \"falloc ${i}m 1m\" $SCRATCH_MNT/fill"
 done
 _do "xfs_bmap -vp $SCRATCH_MNT/fill"
@@ -83,7 +83,7 @@ echo "done"
 # create fragmented file
 #_do "Delete every second file" "_cull_files"
 echo -n "Punch every second 4k block... "
-for i in `seq 0 8 32768`; do
+for i in `seq 0 8 65536`; do
 	# This generates excessive output that significantly slows down the
 	# test. It's not necessary for debug, so just bin it.
 	$XFS_IO_PROG -f -c "unresvsp ${i}k 4k" $SCRATCH_MNT/fill \
@@ -94,7 +94,7 @@ _do "sum $SCRATCH_MNT/fill >$tmp.fillsum1"
 echo "done"
 
 echo -n "Create one very large file... "
-_do "$here/src/fill2 -d nbytes=16000000,file=$SCRATCH_MNT/fragmented"
+_do "$here/src/fill2 -d nbytes=32000000,file=$SCRATCH_MNT/fragmented"
 echo "done"
 _do "xfs_bmap -v $SCRATCH_MNT/fragmented"
 _do "sum $SCRATCH_MNT/fragmented >$tmp.sum1"
diff --git a/tests/xfs/042.out b/tests/xfs/042.out
index a25885b6..e7ec3d41 100644
--- a/tests/xfs/042.out
+++ b/tests/xfs/042.out
@@ -1,6 +1,6 @@
 QA output created by 042
-Make a 48 megabyte filesystem on SCRATCH_DEV and mount... done
-Reserve 16 1Mb unfragmented regions... done
+Make a 96 megabyte filesystem on SCRATCH_DEV and mount... done
+Reserve 32 1Mb unfragmented regions... done
 Fill filesystem with fill file... done
 Use up any further available space... done
 Punch every second 4k block... done
diff --git a/tests/xfs/076 b/tests/xfs/076
index 8eef1367..db88b43d 100755
--- a/tests/xfs/076
+++ b/tests/xfs/076
@@ -69,7 +69,7 @@ _require_xfs_sparse_inodes
 # bitmap consuming all the free space in our small data device.
 unset SCRATCH_RTDEV
 
-_scratch_mkfs "-d size=50m -m crc=1 -i sparse" | tee -a $seqres.full |
+_scratch_mkfs "-d size=96m -m crc=1 -i sparse" | tee -a $seqres.full |
 	_filter_mkfs > /dev/null 2> $tmp.mkfs
 . $tmp.mkfs	# for isize
 

