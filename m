Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792979698;
	b=wnUbpzYMUPoh4adt1OSkNeSqZPbhTEnyJeveVNOTEu9dnsp0W2hcKqPHpWe41ICIVTR1
	 J9yoxx59uuRTNRcPkQhZDWwSd9FrrruSe8kp37uixX4FB+TAR9+xLdXVb9/xK5ZO1GBjS
	 WsFkkjTJJUnH00KIfBh+TMOfa9y9c9avCzdnVG1kDI75NCpZwjlDG3to/10n8DWYLPaVL
	 s3qKda6AD6r5a+6M7FDClpeFg7Vl21d412zMx4o1buCiM+Ov6XOmU8ef32VJD5PUfaCwg
	 Y/XF20czTKOxnD2ZsJlZdg49W4aa5wQT64HCCxuI0GIpbOcO+W0f41hF1L2pnNmnbDQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792979698;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Sp9xVnQiW9XAnSBSll47Js3D+fz7Pvqk1cGPk4dlJgw=;
	b=2yvUgMfXYQ3XeX8zUzKSF3uhiFzX3oDEOPhZw/4LYeM0szyHf+NGMMLpd+/sfh2VI1Gf
	 WiFQmdZSHRxvV1B2VVskbo1syZ9HEAkujAomNBn4yJd0TCNKvjdUq/9O6D19ttJ/9KKMv
	 whDDcJ6Pw7wVnLWR7okRafWLcdRVMvKV8DY/rERnidFE3J14Dp7H8BY6LCkYRGqvpZNSj
	 +yMD2Rvfi+mM1xKDhHq/2SQluu/BmBVCK9D8kNaJ6R7KCe2FLTP0y9Nd3Hfkrvlt0Gvhk
	 Bz+CS9roCS7Q0eZ2GbK422ifUy7SlDrfOk7kyBvl1ds95QqssS0R2eeMpMi9w22GD3w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o1L7lXq8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1EE606A31A;
	Mon, 26 Oct 2026 01:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o1L7lXq8
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792979697;
	b=cYn/Ac384VAKKqV3myLKbNEj8DIQ0CX7eR8hab4Hb06lv5ZS8hWXUelRqMn7lpVVXlBG
	 qRnebr65RyIbVgakjf4efPbqqg5pCA1NP0ae5vVIdxE7u/10ESNJpPlgPRwoHH/KGYzTH
	 GRFFRmgtEwSPMNzmwnW/Wi440gYAytYOrzNIKywOS+/FVC9RHsvzT2xsuRGot90UbGsR6
	 6lVuQUbd8i/Bble7bx0elhCM9CmzCXPg0iXR8Y6aynECetSPDjZlUk7WHi17aVOHsv/g7
	 lQc4lSRcCtvoTBC77ge4r/z49KZHLS5aMqvK5HpGakRumg/hPrtOnBeUIT9BGyyFVMg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792979697;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=Sp9xVnQiW9XAnSBSll47Js3D+fz7Pvqk1cGPk4dlJgw=;
	b=xoiLDKhCKJuDKAcVxljnXf9glZdzf2qvM5OwBna8G9XRMb6UMVN7Z36d9d+4t7gcT/fH
	 zEMhipzh3Ba1k7j0KPgeaXdytFdJTEIyaKX8Yo1mUZ0eHvNkkxBuEEETMZE2mIX8Zq5y8
	 Nd7dkgUWyCsohONDNMP1n0mwiKI/MNdta+jcnllCMhfHOhrFgP4SaOuhyOS+tgW6zQti5
	 BZJ7CHFwnCGzBLmX+xc/ff5lbc+4YPFs/85GxLCZdZ42ETeFxd7Kd+TrDkkE7UgtTn4yW
	 2NduJD6+GYmzm4laHUmoMUIgAKcN2u1LDFfHnMPbuyV5/49HffYupwg/1YAvVDO2/mg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id CFFC41F01825;
	Mon, 26 Oct 2026 01:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792979697;
	bh=Sp9xVnQiW9XAnSBSll47Js3D+fz7Pvqk1cGPk4dlJgw=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=o1L7lXq8nKs3b1E9n83K5gyuofQaOV1JVp/3SQeG7lmCOM9MKhE/FNFZSd/NnRgNC
	 OJraFnpSdJn3hergqQddfYpw81ZA12osXKLjiZ4wDVfi9GgFXcsYqu8wLK7dgFMaSu
	 TdlrUyc+Hgc0I9oVrZZ9CVALufKEpBiPNh41MnJ5LlmUco2433o9IoF4DVNMjieLsz
	 x62RaZ81BGznPz95BYrBNCFoLMmd9xoHgeYVu+hhCTZRUS07j0hMAbnK54/A8oX+or
	 UpMRVE9Tf41gw5wJx0pdWtofC+Jz8r5mf9HRiU7e63wkKFpYScckXblgsAyEpFp99M
	 jL9c7pKufhVEQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 64C9F44B8D;
	Mon, 26 Oct 2026 01:54:56 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Mon, 26 Oct 2026 10:54:56 +0900
Subject: [PATCH] xfs: test that FITRIM discards every free extent of a
 fragmented AG
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
Message-Id: <20261026-xfs-fitrim-test-v1-1-494775ebc15d@samsung.com>
X-B4-Tracking: v=1; b=H4sIAPCy3moC/x3MMQqAMAxA0atIZgO1gqBXEQdbE81glaaIUHp3i
 +Mb/s+gFIUUpiZDpEdUrlDRtQ34Yw07oWzVYI0dOmN7fFmRJUU5MZEmdOwMu9X7kRlqdUdief/
 jvJTyAb7AmMNhAAAA
To: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792979696; l=8775;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=Xg/V81glUEGFoz4Dtf/RjKN9TErRqDNanvKKGok4Sl8=;
 b=5XNcQQDUc3glVwRb7lheYpWfdcoouuVu+TSRl+Rn4aCgULtSn5uwgD2efG8lvbw/kKZ3kmVFt
 anQm0IQFGC3B2pZSN6My1zBHbEp/9pLtsgIuiUPeiw3OBZUhTDESV5/
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

A whole-device FITRIM walks each AG but the last by length. Two
kernel bugs left free extents of such an AG undiscarded.

Build one free space layout for each bug on a loop device. After
fstrim, check that each free extent that held data is a hole in the
image file.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
The kernel patches are at https://lore.kernel.org/r/20261026-xfs-fitrim-skip-v1-0-cddd8414f99c@samsung.com

Without them the test fails: 409 of 512 and 6 of 15 free extents
that held data were not discarded. With both it passes, also with
MKFS_OPTIONS "-m rmapbt=0,reflink=0" and "-d agcount=16" (first
layout only).
---
 tests/xfs/842     | 220 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/842.out |   2 +
 2 files changed, 222 insertions(+)

diff --git a/tests/xfs/842 b/tests/xfs/842
new file mode 100755
index 0000000..73c1ede
--- /dev/null
+++ b/tests/xfs/842
@@ -0,0 +1,220 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Samsung Electronics Co., Ltd. All Rights Reserved.
+#
+# FS QA Test No. 842
+#
+# Check that a whole-device FITRIM discards every free extent. It walks the
+# free space of each AG but the last by length, from the longest free extent
+# down, in batches of XFS_DISCARD_MAX_EXAMINE (100) records. Kernels got two
+# layouts wrong:
+#
+# - an AG with more than one batch of free extents: the second and later
+#   batches skipped the free extents below the block where the previous batch
+#   stopped;
+# - an AG with several free extents of the longest length: only the one with
+#   the lowest block number was discarded.
+#
+. ./common/preamble
+_begin_fstest auto quick trim
+
+_cleanup()
+{
+	cd /
+	_unmount $loop_mnt &> /dev/null
+	[ -n "$loop_dev" ] && _destroy_loop_device $loop_dev
+	rm -rf $tmp.* $img_file
+}
+
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"xfs: don't skip free extents in later batches of a whole-AG FITRIM"
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"xfs: don't skip free extents of the longest length in a whole-AG FITRIM"
+
+_require_test
+_require_loop
+_require_fstrim
+_require_test_program "punch-alternating"
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "fiemap"
+_require_xfs_spaceman_command "freesp"
+
+img_file=$TEST_DIR/$seq.img
+img_size=$((512 << 20))
+loop_mnt=$tmp.mnt
+mkdir -p $loop_mnt
+
+touch $img_file
+_xfs_force_bdev data $img_file
+_require_fs_space $img_file 262144
+
+# Make a filesystem on a new image file and mount it, with file data on the
+# data device.
+make_fs()
+{
+	local gran
+
+	_unmount $loop_mnt &> /dev/null
+	[ -n "$loop_dev" ] && _destroy_loop_device $loop_dev
+	loop_dev=
+	rm -f $img_file
+	touch $img_file
+	_xfs_force_bdev data $img_file
+	truncate -s $img_size $img_file
+	loop_dev=$(_create_loop_device $img_file)
+	_mkfs_dev $loop_dev
+	_mount $loop_dev $loop_mnt
+	_xfs_force_bdev data $loop_mnt
+
+	block_size=$(_get_block_size $loop_mnt)
+	gran=$(cat /sys/block/$(basename $loop_dev)/queue/discard_granularity)
+	[ "$gran" -le "$block_size" ] || \
+		_notrun "discard granularity $gran > block size $block_size"
+}
+
+# Record the free extents, FITRIM the whole filesystem and report each free
+# extent that held data in the image file and is not a hole in it afterwards.
+# $1 names the layout. $2 is an awk condition on n0, the number of such free
+# extents of an AG, and t0, the number of them that have the AG's longest
+# length; an AG walked by length must meet it for the layout to show the bug.
+# Returns 1 if no AG does.
+check_trim()
+{
+	local name=$1 cond=$2
+	local agcount agsize spb formed written missed
+
+	# Cycle the mount so that no freed extent is still busy.
+	_unmount $loop_mnt
+	_mount $loop_dev $loop_mnt
+
+	agcount=$(_xfs_mount_agcount $loop_mnt)
+	agsize=$($XFS_INFO_PROG $loop_mnt | \
+		sed -n 's/.*agsize=\([0-9]*\) blks.*/\1/p')
+	spb=$((block_size / 512))
+
+	# Ranges of the image file that hold data. Free space that was never
+	# written is a hole already and cannot show whether it was discarded.
+	$XFS_IO_PROG -c fiemap $img_file | grep -v hole | \
+		sed -n 's/.*\[\([0-9]*\)\.\.\([0-9]*\)\]:.*/\1 \2/p' > $tmp.data
+
+	# Free extents from GETFSMAP, as "agno agbno length first last written"
+	# with the first and last sector on the loop device. xfs_db freesp
+	# also counts the blocks on the AGFL, which are not free space and are
+	# not discarded.
+	$XFS_SPACEMAN_PROG -c "freesp -d" $loop_mnt | \
+		awk -v spb=$spb -v agsize=$agsize '
+		FILENAME == ARGV[1] {
+			ds[FNR] = $1; de[FNR] = $2; n = FNR; next
+		}
+		NF == 3 && $1 ~ /^[0-9]+$/ && $2 ~ /^[0-9]+$/ &&
+		$3 ~ /^[0-9]+$/ {
+			s = spb * ($1 * agsize + $2)
+			e = s + spb * $3 - 1
+			w = 0
+			for (i = 1; i <= n; i++)
+				if (ds[i] <= e && s <= de[i])
+					w = 1
+			print $1, $2, $3, s, e, w
+		}' $tmp.data - > $tmp.free
+	echo "$name: free extents (agno agbno length first last written)" \
+		>> $seqres.full
+	cat $tmp.free >> $seqres.full
+
+	# A whole-device FITRIM walks the last AG by block number and every
+	# other AG by length.
+	formed=$(awk -v last=$((agcount - 1)) '
+		$1 != last {
+			if ($3 > m[$1]) { m[$1] = $3; t[$1] = 0 }
+			if ($3 == m[$1]) t[$1] += $6
+			n[$1] += $6
+		}
+		END {
+			for (a in n) {
+				n0 = n[a]; t0 = t[a]
+				if (n0 > 0 && ('"$cond"')) c++
+			}
+			print c + 0
+		}' $tmp.free)
+	if [ "$formed" -eq 0 ]; then
+		echo "$name: no AG walked by length has the layout" \
+			>> $seqres.full
+		return 1
+	fi
+
+	$FSTRIM_PROG $loop_mnt >> $seqres.full 2>&1 || \
+		_fail "$name: fstrim failed"
+	_unmount $loop_mnt
+
+	# Holes in the image file, which are the ranges that were discarded.
+	$XFS_IO_PROG -c fiemap $img_file | grep hole | \
+		sed 's/.*\[\(.*\)\.\.\(.*\)\].*/\1 \2/' > $tmp.holes
+	[ -s $tmp.holes ] || _fail "$name: no holes in $img_file"
+
+	written=$(awk '$6 == 1' $tmp.free | wc -l)
+	missed=$(awk -v full=$seqres.full -v name=$name '
+		FILENAME == ARGV[1] {
+			hs[FNR] = $1; he[FNR] = $2; n = FNR; next
+		}
+		$6 == 1 {
+			for (i = 1; i <= n; i++)
+				if (hs[i] <= $4 && $5 <= he[i])
+					next
+			print name ": not discarded: sectors " $4 "-" $5 >> full
+			missed++
+		}
+		END { print missed + 0 }' $tmp.holes $tmp.free)
+	echo "$name: written free extents: $written, not discarded: $missed" \
+		>> $seqres.full
+	[ "$missed" -eq 0 ] || \
+		echo "$name: $missed free extents were not discarded"
+	return 0
+}
+
+layouts=0
+
+make_fs
+_require_batched_discard $loop_mnt
+
+# Write a 64 MiB file and punch out every other 64k of it. The file is allocated
+# from one AG, which is left with about 512 written free extents below the free
+# space after the file.
+$XFS_IO_PROG -f -c "falloc 0 64m" -c "pwrite -S 0x58 -b 1m 0 64m" -c fsync \
+	$loop_mnt/file >> $seqres.full
+blks=$((65536 / block_size))
+[ "$blks" -gt 0 ] || blks=1
+$here/src/punch-alternating -s $blks -i $((2 * blks)) $loop_mnt/file
+check_trim batches "n0 > 200" && layouts=$((layouts + 1))
+
+make_fs
+
+# Fill the filesystem with one file, then write 8 MiB of every 32 MiB of it and
+# punch that out. The punched ranges are written in the image file, and in most
+# AGs they are the longest free extents, several of the same length. A failed
+# fallocate does not change the file size; older xfs_io exits 0 after one.
+size=0
+touch $loop_mnt/fill
+for step in $((64 << 20)) $((1 << 20)) $((64 << 10)); do
+	while [ $((size + step)) -le $img_size ]; do
+		$XFS_IO_PROG -c "falloc $size $step" $loop_mnt/fill &> /dev/null
+		[ "$(stat -c %s $loop_mnt/fill)" -eq $((size + step)) ] || break
+		size=$((size + step))
+	done
+done
+echo "filled $size bytes" >> $seqres.full
+hole=$((8 << 20))
+period=$((32 << 20))
+writes=()
+punches=()
+for ((off = 0; off + hole <= size; off += period)); do
+	writes+=(-c "pwrite -S 0x59 -b 1m $off $hole")
+	punches+=(-c "fpunch $off $hole")
+done
+$XFS_IO_PROG "${writes[@]}" -c fsync $loop_mnt/fill >> $seqres.full
+$XFS_IO_PROG "${punches[@]}" $loop_mnt/fill
+check_trim ties "t0 >= 2" && layouts=$((layouts + 1))
+
+[ "$layouts" -gt 0 ] || _notrun "no AG walked by length has either layout"
+
+echo "Silence is golden"
+_exit 0
diff --git a/tests/xfs/842.out b/tests/xfs/842.out
new file mode 100644
index 0000000..643d052
--- /dev/null
+++ b/tests/xfs/842.out
@@ -0,0 +1,2 @@
+QA output created by 842
+Silence is golden

---
base-commit: d07dca72d2455f4ba8c660ad4c008541ccccb707
change-id: 20261023-xfs-fitrim-test-bfb0fbacc9ff

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


