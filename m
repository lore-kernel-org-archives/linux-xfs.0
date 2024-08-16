Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796371C579A
	for <linux-xfs@vger.kernel.org>; Fri, 16 Aug 2024 21:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845018; cv=none; b=YGA2Vk5OqpGt4aDYpbUgnAGQcFEMFlfI5AmEqjvAuvbGvgsbzdCE5Fb5VTsdkzIvehf2KGw7y9KilOLlHMr52KqBREiyDCGfQ44aLY+UBFEWKTVfKGWmspN2NupuLe20DEcvXHI5JPnuoPwofsg446dOK0B+j4A+2hD4SxVTBcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845018; c=relaxed/simple;
	bh=RrhtA8chO+720d9E0B35k2giRus4rgiVXOK8dqkrAg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lWlPCd0GllFtXg9jCOjHdJIx2TW2irL0oDFYvy4Rc2UiJzGTu0uEKq9mqLV5LXU1Bnm6EX6YRt+1SF5U4/bjwlnW6wP+CbZ2SyY3SJQ8xRgAkM/dluvfBbfWGV+lgP/a59Q/8rMiHvPpxdMCnH4FqvxMcJ4118VnMcbYqPhKISk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cBsx+Sf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cBsx+Sf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13BDC32782;
	Fri, 16 Aug 2024 21:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723845017;
	bh=RrhtA8chO+720d9E0B35k2giRus4rgiVXOK8dqkrAg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cBsx+Sf8GoQoxbD88RZSIjQZl0ppXimFt9x/iIlfHCBp5oJRw/DTF4Y0r+UwtqRV9
	 6Zn4q2aiJ3sDeKbTHWNM7c6QCngOzmFDkwT43fqU3JCITsa4bL1bLh6AOtU8cl3Utj
	 ZkDJWAkfF1JJ7o1Fdmqh+bKk+43eWxs/7M0tc/+lNSRqtVdlOk3+Rg6gs+bjOPOlZR
	 e14pSakhJy5pTuj8WPB3aJ9HXSoSoN1KkeY/m/hVC3fG/vaGx8IB5W0RcmV9zg+hzH
	 hpCf2826tfozymRP0QwOZIjgAcjG89qj0oDizgULpUkgqra5pyiN4ETiJQy1Idynjp
	 O13dchdkhrrow==
Date: Fri, 16 Aug 2024 14:50:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't extend the FITRIM range if the rt device
 does not support discard
Message-ID: <20240816215017.GK865349@frogsfrogsfrogs>
References: <20240816081908.467810-1-hch@lst.de>
 <20240816081908.467810-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240816081908.467810-3-hch@lst.de>

On Fri, Aug 16, 2024 at 10:18:43AM +0200, Christoph Hellwig wrote:
> Fix the newly added discard support to only offer a FITRIM range that
> spans the RT device in addition to the main device if the RT device
> actually supports discard.  Without this we'll incorrectly accept
> a larger range than actually supported and confuse user space if the
> RT device does not support discard.  This can easily happen when the
> main device is a SSD but the RT device is a hard driver.
> 
> Move the code around a bit to keep the max_blocks and granularity
> assignments together and explicitly reject that case where only the
> RT device supports discard, as that does not fit the way the FITRIM ABI
> works very well and is a very fringe use case.

Is there more to this than generic/260 failing?  And if not, does the
following patch things up for you?

--D

From: Darrick J. Wong <djwong@kernel.org>
Subject: [PATCH] generic/260: fix for multi-device xfs with mixed discard support

Fix this test so that it can handle XFS filesystems with a realtime
volume when the data and rt devices do not both support discard.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc  |   12 ++++++++++-
 common/xfs |   65 +++++++++++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 64 insertions(+), 13 deletions(-)

diff --git a/common/rc b/common/rc
index b718030a59..426f2de43b 100644
--- a/common/rc
+++ b/common/rc
@@ -4207,6 +4207,16 @@ _require_batched_discard()
 	fi
 }
 
+_bdev_queue_property()
+{
+	local dev="$1"
+	local property="$2"
+	local default="$3"
+
+	local fname="/sys/block/$(_short_dev "$dev")/queue/$property"
+	cat "$fname" 2>/dev/null || echo "$default"
+}
+
 # Given a mountpoint and the device associated with that mountpoint, return the
 # maximum start offset that the FITRIM command will accept, in units of 1024
 # byte blocks.
@@ -4214,7 +4224,7 @@ _discard_max_offset_kb()
 {
 	case "$FSTYP" in
 	xfs)
-		_xfs_discard_max_offset_kb "$1"
+		_xfs_discard_max_offset_kb "$@"
 		;;
 	*)
 		$DF_PROG -k | awk -v dev="$2" -v mnt="$1" '$1 == dev && $7 == mnt { print $3 }'
diff --git a/common/xfs b/common/xfs
index 9501adac4c..5ad60a3ddc 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1882,7 +1882,13 @@ _require_xfs_scratch_atomicswap()
 # of 1024 byte blocks.
 _xfs_discard_max_offset_kb()
 {
+	local mount="$1"
+	local dev="$2"
 	local statfs
+	local datadev_discard=
+	local rtdev_discard=
+	local dev_discard_max=
+	local rtdev_discard_max=
 
 	# Use awk to read the statfs output for the XFS filesystem, compute
 	# the two possible FITRIM offset maximums, and then use some horrid
@@ -1895,31 +1901,66 @@ _xfs_discard_max_offset_kb()
 	# 2: Realtime volume size in fsblocks.
 	# 3: Max FITRIM offset if we can only trim the data volume
 	# 4: Max FITRIM offset if we can trim the data and rt volumes
-	readarray -t statfs < <($XFS_IO_PROG -c 'statfs' "$1" | \
-		awk '{g[$1] = $3} END {printf("%d\n%d\n%d\n%d\n%d\n",
+	# 5: Max FITRIM offset if we can only trim the rt volume
+	readarray -t statfs < <($XFS_IO_PROG -c 'statfs' "$mount" | \
+		awk '{g[$1] = $3} END {printf("%d\n%d\n%d\n%d\n%d\n%d\n",
 			g["geom.bsize"],
 			g["geom.datablocks"],
 			g["geom.rtblocks"],
 			g["geom.bsize"] * g["geom.datablocks"] / 1024,
-			g["geom.bsize"] * (g["geom.datablocks"] + g["geom.rtblocks"]) / 1024);}')
+			g["geom.bsize"] * (g["geom.datablocks"] + g["geom.rtblocks"]) / 1024,
+			g["geom.bsize"] * g["geom.rtblocks"] / 1024);}')
 
 	# If the kernel supports discarding the realtime volume, then it will
 	# not reject a FITRIM for fsblock dblks+1, even if the len/minlen
 	# arguments are absurd.
 	if [ "${statfs[2]}" -gt 0 ]; then
-		if $FSTRIM_PROG -o "$((statfs[0] * statfs[1]))" \
+		case "$dev" in
+		"$SCRATCH_DEV")
+			rtdev_discard_max="$(_bdev_queue_property "$SCRATCH_RTDEV" discard_max_bytes 0)"
+			;;
+		"$TEST_DEV")
+			rtdev_discard_max="$(_bdev_queue_property "$TEST_RTDEV" discard_max_bytes 0)"
+			;;
+		*)
+			echo "Unrecognized device $dev" >&2
+			rtdev_discard_max=0
+			;;
+		esac
+
+		if [ "$rtdev_discard_max" -gt 0 ] &&
+		   $FSTRIM_PROG -o "$((statfs[0] * statfs[1]))" \
 				-l "${statfs[0]}" \
-				-m "$((statfs[0] * 2))" "$1" &>/dev/null; then
-			# The kernel supports discarding the rt volume, so
-			# print out the second answer from above.
-			echo "${statfs[4]}"
-			return
+				-m "$((statfs[0] * 2))" "$mount" &>/dev/null; then
+			# The kernel supports discarding the rt volume
+			rtdev_discard=2
 		fi
 	fi
 
-	# The kernel does not support discarding the rt volume or there is no
-	# rt volume.  Print out the first answer from above.
-	echo "${statfs[3]}"
+	# The kernel supports discarding the rt volume
+	dev_discard_max="$(_bdev_queue_property "$dev" discard_max_bytes 0)"
+	if [ "$dev_discard_max" -gt 0 ]; then
+		datadev_discard=1
+	fi
+
+	case "$datadev_discard$rtdev_discard" in
+	"12")
+		# Both devices support it
+		echo "${statfs[4]}"
+		;;
+	"1")
+		# Only the data device supports it
+		echo "${statfs[3]}"
+		;;
+	"2")
+		# Only the rt device supports it
+		echo "${statfs[5]}"
+		;;
+	*)
+		# No support at all
+		echo 0
+		;;
+	esac
 }
 
 # check if mkfs and the kernel support nocrc (v4) file systems
