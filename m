Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15933D2FB;
	Fri, 11 Oct 2024 01:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610797; cv=none; b=fwmpd2hCJ/gLCkUbvkrHX1exXhEsU4MUcn9MQtqmvZDhxstBBiHks6WrGITfBX7H3Lo3KzMALuElJ3oL+sJoX6UfFMUnDCl8jcfbwuvP83ycRzvtNLDGitH6+Z5uwo4fZabxdIk2Y/bSwtDQGtCs0B7yNKf/yU1WrW8T9rgskgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610797; c=relaxed/simple;
	bh=zuvucxL1strdJQr94nCWbaKvbzc/z3BnauNYC/vHtd0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fhjsm+qBxTV4oo1TAJE4yN3GXU84XRF48VUHaxE75fgUA+3qQT5FuOcUR4ecsPRH275qxlxGSm6laF9plMERcRBKJAlGzDl/rhOWFyY2f0NXmo+bQQmSUtg6JBpf67bt5g9VM3FaMIToAxauuWWtBvyrnG0+2ob0+h+p+S18/LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aMP6YZoU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMP6YZoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3ABBC4CEC5;
	Fri, 11 Oct 2024 01:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610797;
	bh=zuvucxL1strdJQr94nCWbaKvbzc/z3BnauNYC/vHtd0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aMP6YZoUQ3piJU2iJ0qx+7YgJotS/CFu4JdTtiO6f/MWnRdQupWoqxRinVjR4UO2V
	 VtGs4Z5/vU/MhBz3Gqt2WmZrPyfXV9ViYAieVMMsa+LnK2B9XKSVo0R2y1qsCVEMRF
	 RH7R1hd+CZQqU41Wm5Xn5q1/SNvS1giyGUW2bBL7H56pfpqVhrsl9/XEUMS4T3gLFA
	 O0u6827iW5Uwfo8/f7jJT6nYPgB6ZSxWY/57Lyr5N9eoWlCsjd6RwDxFRH2NpR9/Xf
	 9neP+w1Mb1AxvBJRudIDo6bx4AuSA9E8BgV56ekQLZuT7/9b5oxoJkaeP++wC9kI4E
	 uAY979CTTzFEw==
Date: Thu, 10 Oct 2024 18:39:56 -0700
Subject: [PATCH 07/11] xfs/509: adjust inumbers accounting for metadata
 directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658104.4187056.9848487655097432837.stgit@frogsfrogsfrogs>
In-Reply-To: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
References: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
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

The INUMBERS ioctl exports data from the inode btree directly -- the
number of inodes it reports is taken from ir_freemask and includes all
the files in the metadata directory tree.  BULKSTAT, on the other hand,
only reports non-metadata files.  When metadir is enabled, this will
(eventually) cause a discrepancy in the inode counts that is large
enough to exceed the tolerances, thereby causing a test failure.

Correct this by counting the files in the metadata directory and
subtracting that from the INUMBERS totals.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/509 |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/509 b/tests/xfs/509
index 53c6bd9c0772a1..9b07fecc5d1a10 100755
--- a/tests/xfs/509
+++ b/tests/xfs/509
@@ -91,13 +91,13 @@ inumbers_count()
 	bstat_versions | while read v_tag v_flag; do
 		echo -n "inumbers all($v_tag): "
 		nr=$(inumbers_fs $SCRATCH_MNT $v_flag)
-		_within_tolerance "inumbers" $nr $expect $tolerance -v
+		_within_tolerance "inumbers" $((nr - METADATA_FILES)) $expect $tolerance -v
 
 		local agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
 		for batchsize in 71 2 1; do
 			echo -n "inumbers $batchsize($v_tag): "
 			nr=$(inumbers_ag $agcount $batchsize $SCRATCH_MNT $v_flag)
-			_within_tolerance "inumbers" $nr $expect $tolerance -v
+			_within_tolerance "inumbers" $((nr - METADATA_FILES)) $expect $tolerance -v
 		done
 	done
 }
@@ -142,9 +142,28 @@ _require_xfs_io_command inumbers
 DIRCOUNT=8
 INOCOUNT=$((2048 / DIRCOUNT))
 
+# Count everything in the metadata directory tree.
+count_metadir_files() {
+	# Each possible path in the metadata directory tree must be listed
+	# here.
+	local metadirs=('/rtgroups')
+	local db_args=('-f')
+
+	for m in "${metadirs[@]}"; do
+		db_args+=('-c' "ls -m $m")
+	done
+
+	local ret=$(_scratch_xfs_db "${db_args[@]}" 2>/dev/null | grep regular | wc -l)
+	test -z "$ret" && ret=0
+	echo $ret
+}
+
 _scratch_mkfs "-d agcount=$DIRCOUNT" >> $seqres.full 2>&1 || _fail "mkfs failed"
 _scratch_mount
 
+METADATA_FILES=$(count_metadir_files)
+echo "found $METADATA_FILES metadata files" >> $seqres.full
+
 # Figure out if we have v5 bulkstat/inumbers ioctls.
 has_v5=
 bs_root_out="$($XFS_IO_PROG -c 'bulkstat_single root' $SCRATCH_MNT 2>>$seqres.full)"

