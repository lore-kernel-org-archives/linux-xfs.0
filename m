Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2089190072;
	Wed, 19 Feb 2025 01:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926814; cv=none; b=CMwfqewqiXYz5QGw2+BEGBZJAybBjbt/TIu692/S7tu0eo1L6JWy+fbrnx3JjZUePs0OhMvcKm9J2blOQPRq1KFBcLrYNycbZtNAUARuvr3j3HPqrf1Q0nee1hBAlr8mL5cJjUE8daeOKcGQ+aQwR0MQiD8SiGEdtmi7xSJKw7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926814; c=relaxed/simple;
	bh=xoEhcutLggFEZrv8+/ZgQrcuPbQWa3NzM+O892meeg0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hz1FTxkT9Pji8365OymYc9nc7cls6oh20MzRv+s0b1cgm7X32y8Ww2n6meoj9sm3HzHA0uzUhcK/Tg5cUpdAiABICDIlOOiwT4FVUVXkkSy+xmveQb5HC4T9ySXYd6pecN3/HzB9jzT75I3aRSvSBXOx6RZUhdMBDc6QsvW1FXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hMMv3bH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hMMv3bH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19556C4CEE2;
	Wed, 19 Feb 2025 01:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926814;
	bh=xoEhcutLggFEZrv8+/ZgQrcuPbQWa3NzM+O892meeg0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hMMv3bH9j8mNDjb1uJgZAWWWQ8R0/KMygh+iXGXi6kHa1R8xTKOpXzOv+wi4GaVMk
	 7jpnMe2vgg+eMO2CKcguneZCDRrwoLeGaZFRAdkpq5v2MqsEnCYFT22w8Jl0U+IV6c
	 m47c940ZaRjJi7cjln5acCligXGtLtchS4Oh67EZyYXiaDhtYOCv4vlOgAjOZSnLbZ
	 CxTumWjXuYhwZ8iIvE4+tzYdeUGJ0jXj2VV2XMywo5ypowbp+1JLmSLspeAzsakNZ7
	 aAYWp1pmjMDNyj5ngVJ44bpuonNkXPtIsZ+A17Dhzzy3lu7SzMyfZIq46NnAWQggmK
	 DAYNzTzsGebRA==
Date: Tue, 18 Feb 2025 17:00:13 -0800
Subject: [PATCH 10/15] xfs/185: update for rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589364.4079457.14192019317087260403.stgit@frogsfrogsfrogs>
In-Reply-To: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This old test is a bit too fixated on exact rt allocator behavior.  With
rtgroups enabled, we can end up with one large contiguous region that's
split into multiple bmbt mappings to avoid crossing rtgroup boundaries.
The realtime superblock throws another twist into the mix because the
first rtx will always be in use, which can shift the start of the
physical space mappings by up to 1 rtx.

Also fix a bug where we'd try to fallocate the total number of rtx,
whereas we should be asking for the number of free rtx to avoid ENOSPC
errors.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/185 |   65 ++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 50 insertions(+), 15 deletions(-)


diff --git a/tests/xfs/185 b/tests/xfs/185
index f3601a5292ef0b..7aceb383ce4609 100755
--- a/tests/xfs/185
+++ b/tests/xfs/185
@@ -97,10 +97,17 @@ test "$ddbytes" -lt "$((rtbytes + (10 * rtextsize) ))" || \
 # higher than the size of the data device.  For realtime files this is really
 # easy because fallocate for the first rt file always starts allocating at
 # physical offset zero.
-alloc_rtx="$((rtbytes / rtextsize))"
+rtfreebytes="$(stat -f -c '%S * %a' $rtfile | bc)"
+alloc_rtx="$((rtfreebytes / rtextsize))"
 $XFS_IO_PROG -c "falloc 0 $((alloc_rtx * rtextsize))" $rtfile
 
-expected_end="$(( (alloc_rtx * rtextsize - 1) / 512 ))"
+# log a bunch of geometry data to the full file for debugging
+echo "rtbytes $rtbytes rtfreebytes $rtfreebytes rtextsize $rtextsize" >> $seqres.full
+echo "allocrtx $alloc_rtx falloc $((alloc_rtx * rtextsize))" >> $seqres.full
+$XFS_IO_PROG -c statfs $SCRATCH_MNT >> $seqres.full
+
+total_rtx=$(_xfs_statfs_field $SCRATCH_MNT geom.rtextents)
+expected_end="$(( (total_rtx * rtextsize - 1) / 512 ))"
 
 # Print extent mapping of rtfile in format:
 # file_offset file_end physical_offset physical_end
@@ -113,13 +120,28 @@ rtfile_exts() {
 		done
 }
 
-# Make sure that we actually got the entire device.
-rtfile_exts | $AWK_PROG -v end=$expected_end '
+# Make sure that fallocate actually managed to map the entire rt device.  The
+# realtime superblock may consume the first rtx, so we allow for that here.
+# Allow for multiple contiguous mappings if the rtgroups are very small.
+allowed_start=$((rtextsize / 512))
+rtfile_exts | $AWK_PROG -v exp_start=$allowed_start -v exp_end=$expected_end '
+BEGIN {
+	start = -1;
+	end = -1;
+}
 {
-	if ($3 != 0)
-		printf("%s: unexpected physical offset %s, wanted 0\n", $0, $3);
-	if ($4 != end)
-		printf("%s: unexpected physical end %s, wanted %d\n", $0, $4, end);
+	if (end >= 0 && ($3 != end + 1))
+		printf("%s: non-contiguous allocation should have started at %s\n", $0, end + 1);
+	if (start < 0 || $3 < start)
+		start = $3;
+	if (end < 0 || $4 > end)
+		end = $4;
+}
+END {
+	if (start > exp_start)
+		printf("%s: unexpected physical offset %d, wanted <= %d\n", $0, start, exp_start);
+	if (end != exp_end)
+		printf("%s: unexpected physical end %d, wanted %d\n", $0, end, exp_end);
 }'
 
 # Now punch out a range that is slightly larger than the size of the data
@@ -132,14 +154,27 @@ expected_offset="$((punch_rtx * rtextsize / 512))"
 
 echo "rtfile should have physical extent from $expected_offset to $expected_end sectors" >> $seqres.full
 
-# Make sure that the realtime file now has only one extent at the end of the
-# realtime device
-rtfile_exts | $AWK_PROG -v offset=$expected_offset -v end=$expected_end '
+# Make sure that the realtime file now maps one large extent at the end of the
+# realtime device.  Due to rtgroups boundary rules, there may be multiple
+# contiguous mappings.
+rtfile_exts | $AWK_PROG -v exp_start=$expected_offset -v exp_end=$expected_end '
+BEGIN {
+	start = -1;
+	end = -1;
+}
 {
-	if ($3 != offset)
-		printf("%s: unexpected physical offset %s, wanted %d\n", $0, $3, offset);
-	if ($4 != end)
-		printf("%s: unexpected physical end %s, wanted %d\n", $0, $4, end);
+	if (end >= 0 && ($3 != end + 1))
+		printf("%s: non-contiguous allocation should have started at %s\n", $0, end + 1);
+	if (start < 0 || $3 < start)
+		start = $3;
+	if (end < 0 || $4 > end)
+		end = $4;
+}
+END {
+	if (start < exp_start)
+		printf("%s: unexpected physical offset %d, wanted >= %d\n", $0, start, exp_start);
+	if (end != exp_end)
+		printf("%s: unexpected physical end %d, wanted %d\n", $0, end, exp_end);
 }'
 
 $XFS_IO_PROG -c 'bmap -elpv' $rtfile >> $seqres.full

