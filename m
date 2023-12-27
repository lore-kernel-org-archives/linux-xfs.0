Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0257EE;
	Mon,  1 Jan 2024 01:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fv3IyO+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CEAC433C7;
	Mon,  1 Jan 2024 01:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070946;
	bh=H7LrtpjWIjCPTWP+1OQCQlLph2koDrat4UkLQ1WobcU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Fv3IyO+WDtpGZHqujGIsfOCJ6hsT6vlHVG3nFKbvGazvVO5f3h5gyYncKzjeQbIXK
	 LdhMarQEjkXdo1fgJqN6y6Axsc6p9RIuJc+MQb2qHmg7MxfFL79NJoNbUoJKhcZHhu
	 g1RWWgwW4s23pPrCUt1HKSRoB9IvCfCJ6GLzbqtdNY9XrB1EQfOo2X1JTWHKX9/0SV
	 Hhyf3oSCGG7n7I0jPRA9w9w7T5R2DXWQaNtK/n4jco3/35PTTNUYLU3w8XsQyT3Z7h
	 0iNUbqmCn4EwGYTLn/5lHT7oxM9qCOShRU78GEpMmDRIuk79qZs6cmjZF/YiSdh24i
	 59hZe5DeptnSg==
Date: Sun, 31 Dec 2023 17:02:25 +9900
Subject: [PATCH 4/9] xfs/27[24]: adapt for checking files on the realtime
 volume
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405032069.1827358.7647888380084910379.stgit@frogsfrogsfrogs>
In-Reply-To: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
References: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/272 |   40 +++++++++++++++++++++++++------------
 tests/xfs/274 |   62 ++++++++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 70 insertions(+), 32 deletions(-)


diff --git a/tests/xfs/272 b/tests/xfs/272
index d5f3a74177..edc5b16967 100755
--- a/tests/xfs/272
+++ b/tests/xfs/272
@@ -40,26 +40,40 @@ $here/src/punch-alternating $SCRATCH_MNT/urk >> $seqres.full
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
index cd483d77bc..f16b49fc1c 100755
--- a/tests/xfs/274
+++ b/tests/xfs/274
@@ -40,34 +40,58 @@ _cp_reflink $SCRATCH_MNT/f1 $SCRATCH_MNT/f2
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

