Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6F54502A;
	Wed, 19 Feb 2025 01:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927269; cv=none; b=SO3FFUJIWezZ6KugDgb0ZUkhnieW8W8fYDrpvhIo3+wao057OcSw4JMm8GVNlYdmBJfTMlrDsMxPGqDl+SB40AKKOMtUqntBLIgTqtG85JPxy3uagP/VLWkGZLtJwz3GgLirtZTZBYLKPdb6juyRdigKDA1rpjtoY5otva3AZdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927269; c=relaxed/simple;
	bh=3s9JEf45++qGPOR/dsHI/m8uBaVJN88IRdMpgL0+vho=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=khtU9lfezNK4nuePYD/PIZcQmvPQJqus7aX2xtyRxUsYGL8SXFwKrXShb1ivJsdBmpQQf06dpZ3dzeXCZuSJ62+XfB20yv1mNPdd5Ke/EMiO2vWJUCpIIjJYoHwJYM8I7AyCAP3Ru4dSY6NRqPRJQKFCYFo0c/K9yPwZDusghiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YMrYIj9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YMrYIj9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861B8C4CEE2;
	Wed, 19 Feb 2025 01:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927269;
	bh=3s9JEf45++qGPOR/dsHI/m8uBaVJN88IRdMpgL0+vho=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YMrYIj9qoaTRXLZ3IVylKU2sVmg7bMKdmoXcA33TnEk0XHMBIEBawDHgp7BH2usQX
	 vOreZVKHeIkMLdz/8bCST85Pk22/gqbxA5gK8vZeS4uSpkNGi2V5TnZ5GkZBIrLHX1
	 3zhuRmVc7qn08sKefqF417DXE8W/wZJPiNRATHQuyyMM+ZB/12y5h6eFewwGruvk6B
	 KYeI4OhxREAe3nzhDjfSpevV3Qx4sONBdmJD99ptHY4ehhoh26OmySSd98MZJOwE2L
	 VbtIVUnWb4WPOWUvdfCyccbccGEaeNpdv16z5/eqlgXT3oGGtz4dLYzSZYOOOmU5Ip
	 XhRzyN5MNvA9A==
Date: Tue, 18 Feb 2025 17:07:49 -0800
Subject: [PATCH 3/7] xfs/27[24]: adapt for checking files on the realtime
 volume
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591808.4081089.9156294813216623549.stgit@frogsfrogsfrogs>
In-Reply-To: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
References: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Adapt both tests to behave properly if the two files being tested are on
the realtime volume.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/272 |   40 +++++++++++++++++++++++++------------
 tests/xfs/274 |   62 ++++++++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 70 insertions(+), 32 deletions(-)


diff --git a/tests/xfs/272 b/tests/xfs/272
index 1d0edf67600aa5..0a7a7273ac92a0 100755
--- a/tests/xfs/272
+++ b/tests/xfs/272
@@ -38,26 +38,40 @@ $here/src/punch-alternating $SCRATCH_MNT/urk >> $seqres.full
 ino=$(stat -c '%i' $SCRATCH_MNT/urk)
 
 echo "Get fsmap" | tee -a $seqres.full
-$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT >> $seqres.full
 $XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT | tr '[]()' '    ' > $TEST_DIR/fsmap
+cat $TEST_DIR/fsmap >> $seqres.full
 
 echo "Get bmap" | tee -a $seqres.full
-$XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/urk >> $seqres.full
 $XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/urk | grep '^[[:space:]]*[0-9]*:' | grep -v 'hole' | tr '[]()' '    ' > $TEST_DIR/bmap
+cat $TEST_DIR/bmap >> $seqres.full
 
 echo "Check bmap and fsmap" | tee -a $seqres.full
-cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
-	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total}(| [01]*)$"
-	echo "${qstr}" >> $seqres.full
-	grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
-	found=$(grep -E -c "${qstr}" $TEST_DIR/fsmap)
-	test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
-done
+if $XFS_IO_PROG -c 'stat -v' $SCRATCH_MNT/urk | grep -q realtime; then
+	# file on rt volume
+	cat $TEST_DIR/bmap | while read ext offrange colon rtblockrange total crap; do
+		qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${rtblockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${total}(| [01]*)$"
+		echo "${qstr}" >> $seqres.full
+		grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
+		found=$(grep -E -c "${qstr}" $TEST_DIR/fsmap)
+		test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
+	done
 
-echo "Check device field of FS metadata and regular file"
-data_dev=$(grep 'inode btree' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
-rt_dev=$(grep "${ino}[[:space:]]*[0-9]*\.\.[0-9]*" $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
-test "${data_dev}" = "${rt_dev}" || echo "data ${data_dev} realtime ${rt_dev}?"
+	echo "Check device field of FS metadata and regular file"
+else
+	# file on data volume
+	cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
+		qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total}(| [01]*)$"
+		echo "${qstr}" >> $seqres.full
+		grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
+		found=$(grep -E -c "${qstr}" $TEST_DIR/fsmap)
+		test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
+	done
+
+	echo "Check device field of FS metadata and regular file"
+	data_dev=$(grep 'inode btree' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+	rt_dev=$(grep "${ino}[[:space:]]*[0-9]*\.\.[0-9]*" $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+	test "${data_dev}" = "${rt_dev}" || echo "data ${data_dev} realtime ${rt_dev}?"
+fi
 
 # success, all done
 status=0
diff --git a/tests/xfs/274 b/tests/xfs/274
index a6bdc7c032bb38..bb07ca7b58cf8a 100755
--- a/tests/xfs/274
+++ b/tests/xfs/274
@@ -38,34 +38,58 @@ _cp_reflink $SCRATCH_MNT/f1 $SCRATCH_MNT/f2
 ino=$(stat -c '%i' $SCRATCH_MNT/f1)
 
 echo "Get fsmap" | tee -a $seqres.full
-$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT >> $seqres.full
 $XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT | tr '[]()' '    ' > $TEST_DIR/fsmap
+cat $TEST_DIR/fsmap >> $seqres.full
 
 echo "Get f1 bmap" | tee -a $seqres.full
-$XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/f1 >> $seqres.full
 $XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/f1 | grep '^[[:space:]]*[0-9]*:' | grep -v 'hole' | tr '[]()' '    ' > $TEST_DIR/bmap
+cat $TEST_DIR/bmap >> $seqres.full
 
-echo "Check f1 bmap and fsmap" | tee -a $seqres.full
-cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
-	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total} 010[01]{4}$"
-	echo "${qstr}" >> $seqres.full
-	grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
-	found=$(grep -E -c "${qstr}" $TEST_DIR/fsmap)
-	test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
-done
+if _xfs_is_realtime_file $SCRATCH_MNT/f1 && ! _xfs_has_feature $SCRATCH_MNT rtgroups; then
+	# file on rt volume
+	echo "Check f1 bmap and fsmap" | tee -a $seqres.full
+	cat $TEST_DIR/bmap | while read ext offrange colon rtblockrange total crap; do
+		qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${rtblockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${total} 010[01]{4}$"
+		echo "${qstr}" >> $seqres.full
+		grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
+		found=$(grep -E -c "${qstr}" $TEST_DIR/fsmap)
+		test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
+	done
+else
+	# file on data volume
+	echo "Check f1 bmap and fsmap" | tee -a $seqres.full
+	cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
+		qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total} 010[01]{4}$"
+		echo "${qstr}" >> $seqres.full
+		grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
+		found=$(grep -E -c "${qstr}" $TEST_DIR/fsmap)
+		test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
+	done
+fi
 
 echo "Get f2 bmap" | tee -a $seqres.full
-$XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/f2 >> $seqres.full
 $XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/f2 | grep '^[[:space:]]*[0-9]*:' | grep -v 'hole' | tr '[]()' '    ' > $TEST_DIR/bmap
+cat $TEST_DIR/bmap >> $seqres.full
 
-echo "Check f2 bmap and fsmap" | tee -a $seqres.full
-cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
-	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total} 010[01]{4}$"
-	echo "${qstr}" >> $seqres.full
-	grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
-	found=$(grep -E -c "${qstr}" $TEST_DIR/fsmap)
-	test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
-done
+if _xfs_is_realtime_file $SCRATCH_MNT/f2 && ! _xfs_has_feature $SCRATCH_MNT rtgroups; then
+	echo "Check f2 bmap and fsmap" | tee -a $seqres.full
+	cat $TEST_DIR/bmap | while read ext offrange colon rtblockrange total crap; do
+		qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${rtblockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${total} 010[01]{4}$"
+		echo "${qstr}" >> $seqres.full
+		grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
+		found=$(grep -E -c "${qstr}" $TEST_DIR/fsmap)
+		test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
+	done
+else
+	echo "Check f2 bmap and fsmap" | tee -a $seqres.full
+	cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
+		qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total} 010[01]{4}$"
+		echo "${qstr}" >> $seqres.full
+		grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
+		found=$(grep -E -c "${qstr}" $TEST_DIR/fsmap)
+		test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
+	done
+fi
 
 # success, all done
 status=0

