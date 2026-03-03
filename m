Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339ED191F84;
	Tue,  3 Mar 2026 00:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498484; cv=none; b=HK7/pcDjrpT0rsuVkWj29l9Hn8sj8MEy0Ek75qMpGAGRPXmgGcdOBD9ibtzmq3G1DCIwtGIq5IEQoFFaJ+W0k9wwrDTsZ9M5Asr4A9eH71fj/wIRadrrPnYAPLhGMY5cIuyJw2Q0BLZBew2W9z2TiQYHeUjXn5bmn1bZV/tDeOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498484; c=relaxed/simple;
	bh=M2MfOqpBBk/blSnhRnoFq8ddePD9FZPdle5NVRqJQDE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dSRrFQTuVBW1Hm9qPatcYd5+XusMwEei/1MeRmxfjz0CO5HAXAbWuhItRo4heUBEg1BT8G22OC1XnT2eqQNzB4P173j/G+JSgyPjcCGm3sxygFtlPtC47gTRQVPWqMfri3Uev37Tqq6geZvxU2+dz8egimlwfzDvC2mLvrDyGKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uWjfceL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uWjfceL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB876C19423;
	Tue,  3 Mar 2026 00:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498483;
	bh=M2MfOqpBBk/blSnhRnoFq8ddePD9FZPdle5NVRqJQDE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uWjfceL5P1SFuJynS+s/K+FK85ygW0+Nu444Ll7JCAvAixl0kU4QNl/thimqv0+cf
	 /FKHge1JbubDCcKYIL1uK/fNg/+FMK55RWPs07+68+AZE07GespmqNo3VMwbMHpWfe
	 HipuhRJ7s+/TGSwcWyFt3GZPKYLH55j17bFJpWhJpMmAW3S2XSqPihrbXfJgaiC2pq
	 tbSR910ETwU35QNi57w9w9uY+z86CLmxLJ31VGky/Gs+UpgnYuwFThTKXFPjUCPhw8
	 CNc6Lwn1ioo8k13M6BgGatbv53OL0Ty0junWxnd2lOXIDEDonBAXvUJx8LMlJ/5VLL
	 rI43jL1vVzXJQ==
Date: Mon, 02 Mar 2026 16:41:23 -0800
Subject: [PATCH 02/13] xfs: test for metadata corruption error reporting via
 healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177249785805.483507.14510385335927372965.stgit@frogsfrogsfrogs>
In-Reply-To: <177249785709.483507.8373602184765043420.stgit@frogsfrogsfrogs>
References: <177249785709.483507.8373602184765043420.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Check if we can detect runtime metadata corruptions via the health
monitor.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc          |   10 ++++++
 tests/xfs/1879     |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1879.out |    8 ++++
 3 files changed, 111 insertions(+)
 create mode 100755 tests/xfs/1879
 create mode 100644 tests/xfs/1879.out


diff --git a/common/rc b/common/rc
index fd4ca9641822cf..38d4b500b3b51f 100644
--- a/common/rc
+++ b/common/rc
@@ -3013,6 +3013,16 @@ _require_xfs_io_command()
 		echo $testio | grep -q "Inappropriate ioctl" && \
 			_notrun "xfs_io $command support is missing"
 		;;
+	"healthmon")
+		testio=`$XFS_IO_PROG -c "$command -p $param" $TEST_DIR 2>&1`
+		echo $testio | grep -q "bad argument count" && \
+			_notrun "xfs_io $command $param support is missing"
+		echo $testio | grep -q "Inappropriate ioctl" && \
+			_notrun "xfs_io $command $param ioctl support is missing"
+		echo $testio | grep -q "Operation not supported" && \
+			_notrun "xfs_io $command $param kernel support is missing"
+		param_checked="$param"
+		;;
 	"label")
 		testio=`$XFS_IO_PROG -c "label" $TEST_DIR 2>&1`
 		;;
diff --git a/tests/xfs/1879 b/tests/xfs/1879
new file mode 100755
index 00000000000000..75bc8e3b5f4316
--- /dev/null
+++ b/tests/xfs/1879
@@ -0,0 +1,93 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1879
+#
+# Corrupt some metadata and try to access it with the health monitoring program
+# running.  Check that healthmon observes a metadata error.
+#
+. ./common/preamble
+_begin_fstest auto quick eio selfhealing
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.* $testdir
+}
+
+. ./common/filter
+
+_require_scratch_nocheck
+_require_scratch_xfs_crc # can't detect minor corruption w/o crc
+_require_xfs_io_command healthmon
+
+# Disable the scratch rt device to avoid test failures relating to the rt
+# bitmap consuming all the free space in our small data device.
+unset SCRATCH_RTDEV
+
+echo "Format and mount"
+_scratch_mkfs -d agcount=1 | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
+. $tmp.mkfs
+_scratch_mount
+mkdir $SCRATCH_MNT/a/
+# Enough entries to get to a single block directory
+for ((i = 0; i < ( (isize + 255) / 256); i++)); do
+	path="$(printf "%s/a/%0255d" "$SCRATCH_MNT" "$i")"
+	touch "$path"
+done
+inum="$(stat -c %i "$SCRATCH_MNT/a")"
+_scratch_unmount
+
+# Fuzz the directory block so that the touch below will be guaranteed to trip
+# a runtime sickness report in exactly the manner we desire.
+_scratch_xfs_db -x -c "inode $inum" -c "dblock 0" -c 'fuzz bhdr.hdr.owner add' -c print &>> $seqres.full
+
+# Try to allocate space to trigger a metadata corruption event
+echo "Runtime corruption detection"
+_scratch_mount
+$XFS_IO_PROG -c 'healthmon -c -v' $SCRATCH_MNT > $tmp.healthmon &
+sleep 1	# wait for program to start up
+touch $SCRATCH_MNT/a/farts &>> $seqres.full
+_scratch_unmount
+
+wait	# for healthmon to finish
+
+# Did we get errors?
+check_healthmon()
+{
+	cat $tmp.healthmon >> $seqres.full
+	_filter_scratch < $tmp.healthmon | \
+		grep -E '(sick|corrupt)' | \
+		sed -e 's|SCRATCH_MNT/a|VICTIM|g' \
+		    -e 's|SCRATCH_MNT ino [0-9]* gen 0x[0-9a-f]*|VICTIM|g' | \
+		sort | \
+		uniq
+}
+check_healthmon
+
+# Run scrub to trigger a health event from there too.
+echo "Scrub corruption detection"
+_scratch_mount
+if _supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV; then
+	$XFS_IO_PROG -c 'healthmon -c -v' $SCRATCH_MNT > $tmp.healthmon &
+	sleep 1	# wait for program to start up
+	$XFS_SCRUB_PROG -n $SCRATCH_MNT &>> $seqres.full
+	_scratch_unmount
+
+	wait	# for healthmon to finish
+
+	# Did we get errors?
+	check_healthmon
+else
+	# mock the output since we don't support scrub
+	_scratch_unmount
+	cat << ENDL
+VICTIM directory: corrupt
+VICTIM directory: sick
+VICTIM parent: corrupt
+ENDL
+fi
+
+status=0
+exit
diff --git a/tests/xfs/1879.out b/tests/xfs/1879.out
new file mode 100644
index 00000000000000..2f6acbe1c4fb22
--- /dev/null
+++ b/tests/xfs/1879.out
@@ -0,0 +1,8 @@
+QA output created by 1879
+Format and mount
+Runtime corruption detection
+VICTIM directory: sick
+Scrub corruption detection
+VICTIM directory: corrupt
+VICTIM directory: sick
+VICTIM parent: corrupt

