Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794271105;
	b=lVGvicavNalQaB3fj/BA4NDRppenAUPDsTf+RzgW1CFbJPFyxs3zs3cD8xeTwy+QFGes
	 23aZF+XX0pf2Ls9YJ+YzUf4ZssW0FCf/bAgjV+yXP8qTKNr3ICQRc8gblxx+8Y3GNTMNY
	 HJqEPx3dXLSoB+MzmHZtdqVgMQJEHe0/sAkn0RuGJU6SlPFWqfepZQWdjlXQ/rInWrn/O
	 G2J9dEJRiHeHV1pIFrN4vAZjU+6TpKWSDt7evJayu6S/1jhlgiMN5TRdT37D3SE4lIDyb
	 4PgBe4NBgukgpO6HiqaLpxHJPmlkn4YdcUK4K7imS9zX/tm1Ml+WZwO8h5ltAqwPCEA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271105;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=YWqZWg4+x0UBJC+GEHi4fpGqrJdmCQnzyA022MQpTVc=;
	b=QQhRnWnjeruOtbGKoFdfsDSWEIL5KqrCgiq92+4jTMvTTELIGk2h+LCUTlc4Puj73jPG
	 qi8M2rUrxlU51jJZ3c4Ixk2G+9WR/NPPGibYMEvGekBNnrirlfB+xzJ9OIQnoicBSvEfU
	 GwkpZfEcbiUceydoXNgefEbyac4QgvoU0dQv2szeZUpVvWpen857GHo0iMKHO/tCSi4ra
	 G2mP98Uk4VMqDGXnA8/jEjxxh258WZMP3I7M5DmCP457r2aFsdNnWGNfv3kZkfHtA9U4+
	 sAVdQeOOsr0aQs41bipVBlfOrfcgadX5kQQjP7hHn1+9Wr8bXGFAPxtE4EZllu5PNYQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IpgrRPca;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B817C606A336;
	Tue, 10 Nov 2026 00:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IpgrRPca
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794271104;
	b=eWJrZSUSc3UtPJ9sq1dVe4VGc7pzx8u43H248XYRu+lfLRHbqoQrLPw1zkgCjzQWfEkJ
	 +9rSZ8IBTNnQb48N0KIIvIEAoRnCFPgCnDKlfQccrWGOEhgKTC59PYU30Em/g/UTB7xnc
	 iSZTG+H72/g0Z2AHm2EcgHB14tNlzfSKJ2jElVfpfOOHS+DNgj9EMTeoNvlhYjPqssK6Y
	 g8cx+AkuwuSafw259RlEwNXHp3ldHMmJIxxPRi+AzUWN90JX86U4XFuw8uiXG0H30/jra
	 u/iZqhMKL5LkOgvk2k3XW1uZqJnfbT2DRue6bywh7lN6zMy914XSLcbhGt56bbohPbg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794271104;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=YWqZWg4+x0UBJC+GEHi4fpGqrJdmCQnzyA022MQpTVc=;
	b=gOOK2lygoqKLazRuKvh6125gC841sGDiEa/WcuW4mh1+esUcLmBpEscEiTxJg8c9wdQF
	 k7p1GKk3Rzp8JPSNYB0D9toyBbv9iKNtuXPdQTNrp2N6RNJOHyCX1HO0SuKCbB5L2/AK6
	 I3ei4wWuZL+pCs6TY/dQLpQ8BuHfUxNB20ClcSY8Tx1LKpvixctwFZ4YN7F3+He4j80zo
	 HPpaQleo3qlHqCEOS+yzXnmJc3d0lreUwF9cMD4gVQMz6dAyWEJ8zDpoO4xShoXc27eFI
	 hb5dUM4CQz2PCcM06GrCAz+LrZRa1Ayl/y4LNI40pyBU0f4jUXxVqSorSLvLpLS55hg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D80E11F008A2;
	Tue, 10 Nov 2026 00:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794271104;
	bh=YWqZWg4+x0UBJC+GEHi4fpGqrJdmCQnzyA022MQpTVc=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=IpgrRPcaQCL2iTWwCZGSJq11Sud8xZ9bmiHX3jNdmGlAH/fcrracm5PDaSmeZ9OH9
	 SSaPr20Yjao5qMQLznafSCukza3gyS5gI2ordM6WVKx5NvmV8uMdevBEZa7oHA/xmQ
	 8IM/OmKLD4cBWXkYVT9IJ6ViR/0Mr01VK922+YdeKGQDX9B+OhZynu61SNDxbSsjFP
	 2cF+mpMLMNHBiCoAw0mIzsQ45M4edeVJiqxPYCyjoCyA+xRSjuD9S02QwtPISQttBL
	 5VJPSNRhVk80c6DNtcDdxqUQSwFHL03r5pzjQzJZGhWrMgVi5yT3MiE3B2X5siZBd4
	 ZZCrLSKv2L0IA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 63B2C4872D;
	Tue, 10 Nov 2026 00:38:23 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Tue, 10 Nov 2026 09:38:24 +0900
Subject: [PATCH] xfs: test that swapext waits for in-flight direct I/O
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261110-xfs-swapext-dio-test-v1-1-ead6ea3e23f1@samsung.com>
X-B4-Tracking: v=1; b=H4sIAH9n8moC/x3MQQqAIBBA0avErBvQKLGuEi0sx5pNhSMlRHdPW
 r7F/w8IRSaBoXog0sXCx16g6wqWze0rIftiaFRjtFY95iAotzspJ/R8YCJJaOfeGtu51msFJT0
 jBc7/dpze9wMgO2BZZgAAAA==
To: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794271103; l=6049;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=ylPTRSWaZxLfITp48AQo3BS/GJN6yjbmiPbJVD9BHYM=;
 b=BJjlurFRKFPOIsqvCUq9/kQWgF6NqVSX1YbrnwvwdWVSrUrvIgzvpZb5RAa4IDSnyu5qFBdeG
 KAe7RSFL/WmBuP/o8N0a9z+3lnl+UikqKs6XeAMuyYHfZazE92hmj0t
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

Test that XFS_IOC_SWAPEXT waits for in-flight direct I/O. A cgroup
io.max limit holds back an AIO direct write during the swap. When the
swap returns, the donor must already hold the write's data.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
The kernel fix is "xfs: wait for direct I/O before swapping extents",
posted to linux-xfs. Without it the test failed in 6 of 6 runs, 3 with
always_cow and 3 without. With it the test passed in 6 of 6 runs.
---
 tests/xfs/843     | 139 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/843.out |   2 +
 2 files changed, 141 insertions(+)

diff --git a/tests/xfs/843 b/tests/xfs/843
new file mode 100755
index 0000000..2a4ab53
--- /dev/null
+++ b/tests/xfs/843
@@ -0,0 +1,139 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Samsung Electronics Co., Ltd. All Rights Reserved.
+#
+# FS QA Test No. 843
+#
+# Check that XFS_IOC_SWAPEXT waits for direct I/O that is still in flight.
+# An AIO direct write to the target is held back by a cgroup io.max limit
+# while the target's extents are swapped with a donor. When the swap
+# returns, the donor must already hold the write's data.
+#
+. ./common/preamble
+_begin_fstest auto quick swapext aio
+
+_cleanup()
+{
+	[ -n "$fio_pid" ] && wait $fio_pid > /dev/null 2>&1
+	if [ -n "$cgdir" ]; then
+		rmdir $cgdir/$seq-cg > /dev/null 2>&1
+		[ -n "$drop_io_cgroup" ] && \
+			echo "-io" > $cgdir/cgroup.subtree_control 2> /dev/null
+	fi
+	_unmount $SCRATCH_MNT > /dev/null 2>&1
+	[ -n "$loop_dev" ] && _destroy_loop_device $loop_dev > /dev/null 2>&1
+	cd /
+	rm -f $tmp.*
+}
+
+. ./common/cgroup2
+
+_require_scratch_nocheck
+_require_cgroup2 io
+_require_loop
+_require_block_device $SCRATCH_DEV
+_require_non_zoned_device $SCRATCH_DEV
+_require_xfs_io_command swapext
+_require_odirect
+_require_aio
+
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"xfs: wait for direct I/O before swapping extents"
+
+filesize=$((1024 * 1024))
+# A 1 MiB write at this rate stays in the throttle for about 4 seconds.
+wbps=262144
+
+fio_config=$tmp.fio
+cat > $fio_config <<EOF
+[swapext-dio]
+filename=$SCRATCH_MNT/target
+ioengine=libaio
+direct=1
+rw=write
+bs=$filesize
+size=$filesize
+iodepth=1
+overwrite=1
+buffer_pattern=0x63
+EOF
+_require_fio $fio_config
+
+# io.max cannot be set on a partition, so use a loop device as generic/563
+# does.
+loopsize_mb=$(_small_fs_size_mb 256)
+_require_scratch_size_nocheck $((loopsize_mb * 1024))
+loop_dev=$(_create_loop_device_like_bdev $SCRATCH_DEV $SCRATCH_DEV \
+					 $((loopsize_mb * 1024 * 1024)))
+smajor=$((0x`stat -L -c %t $loop_dev`))
+sminor=$((0x`stat -L -c %T $loop_dev`))
+
+_mkfs_dev $loop_dev >> $seqres.full 2>&1
+_mount $loop_dev $SCRATCH_MNT || _fail "mount failed"
+_xfs_force_bdev data $SCRATCH_MNT
+
+cgdir=$CGROUP2_PATH
+drop_io_cgroup=
+grep -q -w io $cgdir/cgroup.subtree_control || drop_io_cgroup=1
+echo "+io" > $cgdir/cgroup.subtree_control || _fail "subtree control"
+mkdir -p $cgdir/$seq-cg
+echo "$smajor:$sminor wbps=$wbps" > $cgdir/$seq-cg/io.max || \
+	_notrun "cannot set io.max"
+
+$XFS_IO_PROG -f -d -c "pwrite -q -S 0x61 -b $filesize 0 $filesize" \
+	$SCRATCH_MNT/target >> $seqres.full
+$XFS_IO_PROG -f -d -c "pwrite -q -S 0x62 -b $filesize 0 $filesize" \
+	$SCRATCH_MNT/donor >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -q -S 0x63 -b $filesize 0 $filesize" \
+	$tmp.expected >> $seqres.full
+
+# Start the throttled AIO direct write. XFS drops the iolock once the bio is
+# submitted, so the swap below can take the iolock while the write is still
+# in flight. The write updates the target's timestamps when it is submitted.
+ctime0=$(stat -c %z $SCRATCH_MNT/target)
+(echo $BASHPID > $cgdir/$seq-cg/cgroup.procs && \
+	exec $FIO_PROG $fio_config --output=$tmp.fio.out) &
+fio_pid=$!
+for ((i = 0; i < 100; i++)); do
+	[ "$(stat -c %z $SCRATCH_MNT/target)" != "$ctime0" ] && break
+	sleep 0.1
+done
+[ "$(stat -c %z $SCRATCH_MNT/target)" != "$ctime0" ] || \
+	_fail "direct write was not submitted"
+
+# io.stat counts the write when io.max lets it through. Fewer bytes than
+# the write means it is still queued just before the swap.
+wbytes=$(sed -n "s/^$smajor:$sminor .*wbytes=\([0-9]*\) .*/\1/p" \
+	$cgdir/$seq-cg/io.stat)
+echo "wbytes before swapext: ${wbytes:-0}" >> $seqres.full
+[ "${wbytes:-0}" -lt $filesize ] || \
+	_notrun "direct write was not held back by io.max"
+
+$XFS_IO_PROG -c "swapext $SCRATCH_MNT/donor" $SCRATCH_MNT/target
+
+# The donor now owns the target's old data. The swap waits for the write,
+# so the donor already holds what the write wrote. This also holds when
+# always_cow sends the write to CoW staging blocks. The swap drops the
+# donor's page cache, so this first read comes from the disk.
+donor_sum=$(_md5_checksum $SCRATCH_MNT/donor)
+
+wait $fio_pid || _fail "fio failed"
+fio_pid=
+cat $tmp.fio.out >> $seqres.full
+
+# A missing io.stat line also reads as 0 above. Make sure that io.max did
+# account for the write, so the swap really ran while it was held back.
+wbytes=$(sed -n "s/^$smajor:$sminor .*wbytes=\([0-9]*\) .*/\1/p" \
+	$cgdir/$seq-cg/io.stat)
+echo "wbytes after the write: ${wbytes:-0}" >> $seqres.full
+[ "${wbytes:-0}" -ge $filesize ] || \
+	_notrun "direct write was not charged to the io.max cgroup"
+
+[ "$donor_sum" = "$(_md5_checksum $tmp.expected)" ] || \
+	echo "donor does not hold the direct write after swapext"
+
+_unmount $SCRATCH_MNT
+_check_xfs_filesystem $loop_dev none none
+
+echo Silence is golden
+_exit 0
diff --git a/tests/xfs/843.out b/tests/xfs/843.out
new file mode 100644
index 0000000..87c1350
--- /dev/null
+++ b/tests/xfs/843.out
@@ -0,0 +1,2 @@
+QA output created by 843
+Silence is golden

---
base-commit: d07dca72d2455f4ba8c660ad4c008541ccccb707
change-id: 20261109-xfs-swapext-dio-test-8b98685a4d10

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


