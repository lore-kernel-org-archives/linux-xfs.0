Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8BD7EF;
	Mon,  1 Jan 2024 00:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sP/IBduC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE46AC433C7;
	Mon,  1 Jan 2024 00:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070319;
	bh=+36B7195VR9jl2Gu3IH7SWLqhI39xRLJcR776BqQRbg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sP/IBduCX0RZmRTUkxawCnjkiu+nm2EX9Zrl7dXaQgOPaWPB/KTpQ4jbSPY05JJJY
	 RjjSuPMacyPGWzT8XDprGBTHU0bOVQr90GzGoS4b3djfG28Haw6fuxC/hVQHVgBOcT
	 ECO+bvwPkShF/p/2W7x/CkdkIBnA4TUV/KylOESVJWWWYyPl2MrK8QijGQjnpm7Uqd
	 Qv8Y/bU/6OOiCD5sfZ6isAE66Ogdxoui0tKX8C7W2KYlcYJPQzAcbJBtS21zbT9Tfw
	 tjXDYjQ+Pp2D8cQtw1sWoZVbH53Lwd/dPzLkUXI79VLW/JaJZJsnLl37ST558yrDr1
	 My+RuWGqQMfrQ==
Date: Sun, 31 Dec 2023 16:51:59 +9900
Subject: [PATCH 08/11] xfs/509: adjust inumbers accounting for metadata
 directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405029955.1826032.8448465090415123895.stgit@frogsfrogsfrogs>
In-Reply-To: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
References: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
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
 tests/xfs/509 |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/509 b/tests/xfs/509
index d04dfbbfba..b87abef964 100755
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
@@ -143,9 +143,26 @@ _supported_fs xfs
 DIRCOUNT=8
 INOCOUNT=$((2048 / DIRCOUNT))
 
+# Count everything in the metadata directory tree.
+count_metadir_files() {
+	local metadirs=('/realtime' '/quota')
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

