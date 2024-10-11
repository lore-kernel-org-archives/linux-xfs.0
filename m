Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64A5DF59;
	Fri, 11 Oct 2024 01:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728611015; cv=none; b=EYRBz1EyXs4pXHYmD1C7jJ/fAoTWlyd/P/WYjsMxqhM+/Z02vtUFzmevy7FA+wa8dOKaLS1sUDSrsuvCC+KVL88LK/xxL7J1o/MjNW6zVtiEJ+yMXq8/6Z+N7GysbeAbh1cXkjf8hjlbQmTI1y2hB4V/P2B/5jYY1rDfFDDMGSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728611015; c=relaxed/simple;
	bh=KeyU9HvsbbHeoiDsxZWIcoXoZ04QPiBr7H1lH99+6dE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KSu+fBhL40oUVaUfcnHje2RvLv8lUIErIyOObw7DzQDY1+ReE/ATwvvsZqTgjv090LKqvp9fyCDEd2gJynY9rU08IGyYnNRPvMq3jRe9it+DKEYWyLcm2gDqWwK0iFBy7gQYrzBIDyhONO/Yc33iemSqvYisJvD4cyeald+iomI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nc1Vb1+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nc1Vb1+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F521C4CEC5;
	Fri, 11 Oct 2024 01:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728611015;
	bh=KeyU9HvsbbHeoiDsxZWIcoXoZ04QPiBr7H1lH99+6dE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Nc1Vb1+wcKGqe1JGHKkLAXtnYDJJ+f1pr+xrNNmoeT8y4DFCSfg2gBlFq0kkOI5B0
	 wV5Qmujh99a7WIUPsYKsQNO34ywb5co9Zx4Lk6U0gEzrPlEKr8TqMyFXNgxs3YQvOS
	 VT1gPoAqvEweVh+sk1No9CShbmscm6YWG2Yv+EmgspEv1ugWJKBQ3z02pK5nSbUfY3
	 V2RQxCMJTZNCy2FQsoZsFY1PTyqBsYLAQKsdQDzHez5LQUTXyvg87CPhqMp2aPHDz8
	 wbnBphtlQHmBkY9DYr5wwSL5XVjuN1vizZkVZFUfuk6Duqx3MgCmGJ525yd/dKoMZS
	 XFVHxRSNZsJQA==
Date: Thu, 10 Oct 2024 18:43:35 -0700
Subject: [PATCH 10/16] xfs/185: update for rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658673.4188964.10504961843138111495.stgit@frogsfrogsfrogs>
In-Reply-To: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
References: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
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

This old test is a bit too fixated on exact rt allocator behavior.  With
rtgroups enabled, we can end up with one large contiguous region that's
split into multiple bmbt mappings to avoid crossing rtgroup boundaries.
The realtime superblock throws another twist into the mix because the
first rtx will always be in use, which can shift the start of the
physical space mappings by up to 1 rtx.

Also fix a bug where we'd try to fallocate the total number of rtx,
whereas we should be asking for the number of free rtx to avoid ENOSPC
errors.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/185 |   65 ++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 50 insertions(+), 15 deletions(-)


diff --git a/tests/xfs/185 b/tests/xfs/185
index b14bcb9b791bb8..e48b1851f524b0 100755
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

