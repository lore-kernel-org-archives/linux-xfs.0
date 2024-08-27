Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4223C6EB64;
	Tue, 27 Aug 2024 18:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784431; cv=none; b=IwlN9WM5dsuk8/45pn7DYQxSBrWr6uAN/y2Bnz0h1MyZssxmlrpOjBso9Tql0V/Ot3VIBE98IyEoibrB8uyRW7mMcQW5Igh+XtAI0cQMjQWuDbkzxwXVPwh5R6NpBGH+nvsQpxL4r8q3+M7btoxwJXuuhQQhQDntGR7yRuTtOV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784431; c=relaxed/simple;
	bh=5MBCroX2+T62yuTYZGeEPsseTBXsnseDLUmjN9H1Dek=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hc3R5Zy/mqc4oIF05ijKi0hEcJphl1VyzO1ZYQVxMxcub/6dh0ctCALmux7xGfw6/ElK0X+0tVqIe+6xCi8NONhXZUoh1Ih/VJEXfcJor/B1UpcfmkP3zrIEv2eHF8yvWHqtOkjuEGt98zLgt58U8sMMaNBF3Mi8bt2LyWzUBSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WwIgkMQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WwIgkMQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F42C4FEAB;
	Tue, 27 Aug 2024 18:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724784431;
	bh=5MBCroX2+T62yuTYZGeEPsseTBXsnseDLUmjN9H1Dek=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WwIgkMQrKMJ0pm1+ynWa3ttsBx6lZL0ol58vj0xoaGVQvXRCzPl7P0AFvqkhhhxOW
	 4auVHcnoGZHdMqeFKfzOif94iKl0Lhi3SrJuZ3PNNwrydMkP9kO1X4fq4FjbPzk2dy
	 24ACkYKeDI+du17FyEA0/45RM0OGkaxx+ETNIIoYj/7KhMCy5bt/pbLxgstM+TmEaV
	 kVY1fMEUqZa2wUGAmxcbKg+DdEnUHMZ2VHgANto4lD/SVVz9IN5KIAtW6bJj6O04Nz
	 wFuVUtldTcd6EMdqArTO7Bz2hqr6NTeeUzwpAI192pyguYcuwV9wld7u5bEGiLD/Hs
	 fIWRiSi5b74CQ==
Date: Tue, 27 Aug 2024 11:47:10 -0700
Subject: [PATCH 2/2] common/xfs: FITRIM now supports realtime volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <172478423415.2039664.6807634599087596331.stgit@frogsfrogsfrogs>
In-Reply-To: <172478423382.2039664.3766932721854273834.stgit@frogsfrogsfrogs>
References: <172478423382.2039664.3766932721854273834.stgit@frogsfrogsfrogs>
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

XFS now supports FITRIM to the realtime volume.  Detect this support and
enable it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs |   40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)


diff --git a/common/xfs b/common/xfs
index 7ee6fbec84..de557ebd90 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1777,8 +1777,44 @@ _require_xfs_scratch_atomicswap()
 # of 1024 byte blocks.
 _xfs_discard_max_offset_kb()
 {
-	$XFS_IO_PROG -c 'statfs' "$1" | \
-		awk '{g[$1] = $3} END {print (g["geom.bsize"] * g["geom.datablocks"] / 1024)}'
+	local statfs
+
+	# Use awk to read the statfs output for the XFS filesystem, compute
+	# the two possible FITRIM offset maximums, and then use some horrid
+	# bash magic to import the five numbers as an indexed array.  There's
+	# no better way to do this in bash since you can't readarray to build
+	# an associative array.  Elements are as follows:
+	#
+	# 0: fsblock size in bytes
+	# 1: Data volume size in fsblocks.
+	# 2: Realtime volume size in fsblocks.
+	# 3: Max FITRIM offset if we can only trim the data volume
+	# 4: Max FITRIM offset if we can trim the data and rt volumes
+	readarray -t statfs < <($XFS_IO_PROG -c 'statfs' "$1" | \
+		awk '{g[$1] = $3} END {printf("%d\n%d\n%d\n%d\n%d\n",
+			g["geom.bsize"],
+			g["geom.datablocks"],
+			g["geom.rtblocks"],
+			g["geom.bsize"] * g["geom.datablocks"] / 1024,
+			g["geom.bsize"] * (g["geom.datablocks"] + g["geom.rtblocks"]) / 1024);}')
+
+	# If the kernel supports discarding the realtime volume, then it will
+	# not reject a FITRIM for fsblock dblks+1, even if the len/minlen
+	# arguments are absurd.
+	if [ "${statfs[2]}" -gt 0 ]; then
+		if $FSTRIM_PROG -o "$((statfs[0] * statfs[1]))" \
+				-l "${statfs[0]}" \
+				-m "$((statfs[0] * 2))" "$1" &>/dev/null; then
+			# The kernel supports discarding the rt volume, so
+			# print out the second answer from above.
+			echo "${statfs[4]}"
+			return
+		fi
+	fi
+
+	# The kernel does not support discarding the rt volume or there is no
+	# rt volume.  Print out the first answer from above.
+	echo "${statfs[3]}"
 }
 
 # check if mkfs and the kernel support nocrc (v4) file systems

