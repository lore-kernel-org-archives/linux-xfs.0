Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D2E230D0F;
	Fri, 21 Mar 2025 21:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742592507; cv=none; b=odugCOw0yKJEYuazkAbNVZFtdQCTtdEl/rqozUqPeQbNPAxtMgLsZtI8EStR85e8wtfS4ZS/OaTpJEUex6MV+LGZMrnBin4i8WD3HJ29X+Q84Ulo+cJqgjyOHwUXxNKjw1wxSfHZotfQ+OwDKD1VFOPT9fGI6Zwb0qXNejXkRY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742592507; c=relaxed/simple;
	bh=6XQfFPFWe8qmXzqEW5yZUQgzjBk4DuB1/FvHi8Ldxc4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uGkc6W7vtsf87uU8MByHleE6zUEqIyIlcXUnANt6ARkyGpBjt65I0T2D1I+AGjdfVR0fnfiCNgeAfvho6XNhwDWfl2UkpJigQvmVVA0woleTfd/5VM6r3/s0Nk7lch1QtjcGxk1nMKH8ZkOd1IuAMW1iS7ax61bQnbDUwzk/J1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uUHi0orZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uUHi0orZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426F1C4CEE3;
	Fri, 21 Mar 2025 21:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742592507;
	bh=6XQfFPFWe8qmXzqEW5yZUQgzjBk4DuB1/FvHi8Ldxc4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uUHi0orZ3RZdrglOJP7+m50vXDRlW9ZLd/U23lWACMZoK3cGWBmRjTMoo46B8Jodt
	 tT99lnw4D3G6SHuOxJn0IDdCpXRDCl7LLUVjrbkOI7pjAaVf86VJugBPu5QtueQqtS
	 ZQ4rX4+Dnl/Rxfwa3brsrjxezwGZTxRzWWQyF3VXhkhs1HtDRu2veNOk4lYeQzX3So
	 +zHdbZq4N6Uq04k6k2PSUOqEryqpe1izaLEOYKo39HjcGTY4LSwFmwzwMPRYCQFJDa
	 VS/XrwX8ATJaVHazXWgzAot4QpRj3umb7wh1yCrk9Pu7fBA0XQexNGsbiYXmfETFhD
	 Pt3tS4BoSHLMw==
Date: Fri, 21 Mar 2025 14:28:26 -0700
Subject: [PATCH 4/4] xfs/818: fix some design issues
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org
Message-ID: <174259234036.743619.7066882477727740142.stgit@frogsfrogsfrogs>
In-Reply-To: <174259233946.743619.993544237516250761.stgit@frogsfrogsfrogs>
References: <174259233946.743619.993544237516250761.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

While QA'ing zoned filesystem support, I discovered some design errors
in this test:

1) Since we're test formatting a sparse file on an xfs filesystem,
there's no need to play games with optimal device size; we can create
a totally sparse file that's the same size as SCRATCH_DEV.

2) mkfs.xfs cannot create realtime files, so if it fails with that,
there's no need to continue the test.

3) If mkfs -p fails for none of the proscribed reasons, it should exit
the test.  The final cat $tmp.mkfs will take care of tweaking the golden
output to register the test failure for further investigation.

Cc: <fstests@vger.kernel.org> # v2025.03.09
Fixes: 6d39dc34e61e11 ("xfs: test filesystem creation with xfs_protofile")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/818 |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/818 b/tests/xfs/818
index aeb462353df7e9..bc809390b9e340 100755
--- a/tests/xfs/818
+++ b/tests/xfs/818
@@ -75,9 +75,8 @@ _run_fsstress -n 1000 -d $SCRATCH_MNT/newfiles
 make_stat $SCRATCH_MNT before
 make_md5 $SCRATCH_MNT before
 
-kb_needed=$(du -k -s $SCRATCH_MNT | awk '{print $1}')
-img_size=$((kb_needed * 2))
-test "$img_size" -lt $((300 * 1024)) && img_size=$((300 * 1024))
+scratch_sectors="$(blockdev --getsz $SCRATCH_DEV)"
+img_size=$((scratch_sectors * 512 / 1024))
 
 echo "Clone image with protofile"
 $XFS_PROTOFILE_PROG $SCRATCH_MNT > $testfiles/protofile
@@ -99,7 +98,21 @@ if ! _try_mkfs_dev -p $testfiles/protofile $testfiles/image &> $tmp.mkfs; then
 	if grep -q 'No space left on device' $tmp.mkfs; then
 		_notrun "not enough space in filesystem"
 	fi
+
+	# mkfs cannot create realtime files.
+	#
+	# If zoned=1 is in MKFS_OPTIONS, mkfs will create an internal realtime
+	# volume with rtinherit=1 and fail, so we need to _notrun that case.
+	#
+	# If zoned=1 is /not/ in MKFS_OPTIONS, we didn't pass a realtime device
+	# to mkfs so it will not create realtime files.  The format should work
+	# just fine.
+	if grep -q 'creating realtime files from proto file not supported' $tmp.mkfs; then
+		_notrun "mkfs cannot create realtime files"
+	fi
+
 	cat $tmp.mkfs
+	exit
 fi
 
 _mount $testfiles/image $testfiles/mount

