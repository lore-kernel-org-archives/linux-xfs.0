Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D0C34D93E;
	Tue, 21 Oct 2025 18:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761072093; cv=none; b=SJQow4iydWaVqDzxG+WtdGNNaUG3jM1CU1D8TGsUB5sNTVZZ/66Oaz7XayoyUfic9yi9sADN355HACBH1Tknsk9ahSPKuMYTFJBFVfqiCnWbbnrcbUAI0VBAg4TStGJGSTzGLhDWt2+MXb6aaAxb2pwXC8u+FuHKEFqXANDAAIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761072093; c=relaxed/simple;
	bh=57X0Ro3E9jZhv82s+4nSlqehOPsNoiHPlFovmQiRs34=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CdIpM/TsYfLP2k2KNKDgZuBzEJz5R46FnB9QP8yaruUpkTf5jIa0H+t85rXNdjv0Io6PVuCE2v0IkaoD7Nj7Ua72mC6ZCopFeq7F3LgYP8uQqoNbTW0oKyj+MSftL/X3ZgJJ78qBlkaZv7UgwHI5KTldMdPX8y2DOFLLqK+8+O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OtzHpzB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OtzHpzB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF08C4CEF1;
	Tue, 21 Oct 2025 18:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761072093;
	bh=57X0Ro3E9jZhv82s+4nSlqehOPsNoiHPlFovmQiRs34=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OtzHpzB4YiXqs9j7Hcvx+xuKXrgrUdURnKO7AM3BoDyzCtO91xbBi8AB32AYHZIsY
	 WBqyN2y4CWx/xrRInZDjHdZ+C1U8txD7PoGLKuZQqRZa52UxVb38ZHYg/aXbTRLCiR
	 WX8B81Y4MAkUSx3w83EJbcfLWbGx83bZ2QKudtc6aukrFUTrxAeE2sWqL+yGsgkEYd
	 tOPzOU54QjeMnRvCpi3NPnXl8mSzssKSKlMyMMbuCLe6EaR+HpbduldaCvcea1JHsd
	 3ovDIeu44knHKcsWmhZPcMeGtYFLipE/YA2quYliVqp+VTtTi5NcpOsnlm+MCXX3XQ
	 dP5QhIWLtINsw==
Date: Tue, 21 Oct 2025 11:41:33 -0700
Subject: [PATCH 09/11] generic/778: fix severe performance problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <176107188833.4163693.9661686434641271120.stgit@frogsfrogsfrogs>
In-Reply-To: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This test takes 4800s to run, which is horrible.  AFAICT it starts out
by timing how much can be written atomically to a new file in 0.2
seconds, then scales up the file size by 3x.  On not very fast storage,
this can result in file_size being set to ~250MB on a 4k fsblock
filesystem.  That's about 64,000 blocks.

The next thing this test does is try to create a file of that size
(250MB) of alternating written and unwritten blocks.  For some reason,
it sets up this file by invoking xfs_io 64,000 times to write small
amounts of data, which takes 3+ minutes on the author's system because
exec overhead is pretty high when you do that.

As a result, one loop through the test takes almost 4 minutes.  The test
loops 20 times, so it runs for 80 minutes(!!) which is a really long
time.

So the first thing we do is observe that the giant slow loop is being
run as a single thread on an empty filesystem.  Most of the time the
allocator generates a mostly physically contiguous file.  We could
fallocate the whole file instead of fallocating one block every other
time through the loop.  This halves the setup time.

Next, we can also stuff the remaining pwrite commands into a bash array
and only invoke xfs_io once every 128x through the loop.  This amortizes
the xfs_io startup time, which reduces the test loop runtime to about 20
seconds.

Finally, replace the 20x loop with a _soak_loop_running 5x loop because
5 seems like enough.  Anyone who wants more can set TIME_FACTOR or
SOAK_DURATION to get more intensive testing.  On my system this cuts the
runtime to 75 seconds.

Cc: <fstests@vger.kernel.org> # v2025.10.20
Fixes: ca954527ff9d97 ("generic: Add sudden shutdown tests for multi block atomic writes")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/778 |   39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)


diff --git a/tests/generic/778 b/tests/generic/778
index 8cb1d8d4cad45d..3e070fc7d157d5 100755
--- a/tests/generic/778
+++ b/tests/generic/778
@@ -113,21 +113,32 @@ create_mixed_mappings() {
 	local off=0
 	local operations=("W" "U")
 
+	# fallocate the whole file once because preallocating single blocks
+	# with individual xfs_io invocations is really slow and the allocator
+	# usually gives out consecutive blocks anyway
+	$XFS_IO_PROG -f -c "falloc 0 $size_bytes" $file
+
+	local cmds=()
 	for ((i=0; i<$((size_bytes / blksz )); i++)); do
-		index=$(($i % ${#operations[@]}))
-		map="${operations[$index]}"
+		if (( i % 2 == 0 )); then
+			cmds+=("pwrite -b $blksz $off $blksz")
+		fi
+
+		# batch the write commands into larger xfs_io invocations to
+		# amortize the fork overhead
+		if [ "${#cmds[@]}" -ge 128 ]; then
+			$XFS_IO_PROG -f -c "${cmds[@]}" "$file" >> /dev/null
+			cmds=()
+		fi
 
-		case "$map" in
-		    "W")
-			$XFS_IO_PROG -fc "pwrite -b $blksz $off $blksz" $file  >> /dev/null
-			;;
-		    "U")
-			$XFS_IO_PROG -fc "falloc $off $blksz" $file >> /dev/null
-			;;
-		esac
 		off=$((off + blksz))
 	done
 
+	if [ "${#cmds[@]}" -gt 0 ]; then
+		$XFS_IO_PROG -f -c "${cmds[@]}" "$file" >> /dev/null
+		cmds=()
+	fi
+
 	sync $file
 }
 
@@ -336,9 +347,9 @@ echo >> $seqres.full
 echo "# Populating expected data buffers" >> $seqres.full
 populate_expected_data
 
-# Loop 20 times to shake out any races due to shutdown
-for ((iter=0; iter<20; iter++))
-do
+# Loop 5 times(ish) to shake out any races due to shutdown
+iter=0
+while _soak_loop_running $((5 * TIME_FACTOR)); do
 	echo >> $seqres.full
 	echo "------ Iteration $iter ------" >> $seqres.full
 
@@ -361,6 +372,8 @@ do
 	echo >> $seqres.full
 	echo "# Starting shutdown torn write test for append atomic writes" >> $seqres.full
 	test_append_torn_write
+
+	iter=$((iter + 1))
 done
 
 echo "Silence is golden"

