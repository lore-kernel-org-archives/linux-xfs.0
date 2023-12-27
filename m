Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854104A02;
	Mon,  1 Jan 2024 00:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NenpGz1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FB5C433C8;
	Mon,  1 Jan 2024 00:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070664;
	bh=JSbRLtytCKFgJwt/RI9Yunz+T3splF080/n1zkzNzbQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NenpGz1qORvpTGuypfEnkQPhGb8ZJJ4jv32KvdZaEPfTB2FVCF/JOITzUsIrmG3aj
	 FXgxllgsG0lsDPDtaDT9Jz+eUhcnvGeF4LdOwsMEKY9p9Mjb3K36bpBL83+gs6Cnxo
	 sN8VhT3Kvy9lshUvYLhE44vqP1dktakxtgAavmz0ekb8nF2JBTn69qtbbIVc/h2YmO
	 zVQ52NBYzoacBcK0O/TizGUmqyqF5ig5rge8k1/9jAS9Q22GEU5IHEYDhJQDf+76/I
	 Fe/U0D2r7ufSHoUTJUm/rXH6ZrtxCtGHjr0UyUGuwqPgFqF1K04HzNAaO/V8UJJYCk
	 6rPDWRXR51RLw==
Date: Sun, 31 Dec 2023 16:57:43 +9900
Subject: [PATCH 2/2] common/xfs: FITRIM now supports realtime volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030894.1826812.11882587421223102904.stgit@frogsfrogsfrogs>
In-Reply-To: <170405030868.1826812.10067703094837693199.stgit@frogsfrogsfrogs>
References: <170405030868.1826812.10067703094837693199.stgit@frogsfrogsfrogs>
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
index d9aa242ec7..75f1bbcc3d 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1937,8 +1937,44 @@ _require_xfs_scratch_atomicswap()
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
 
 # Adjust MKFS_OPTIONS as necessary to avoid having parent pointers formatted

