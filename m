Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C46BA32;
	Mon,  1 Jan 2024 00:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WVVR0Ioh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067EDC433C8;
	Mon,  1 Jan 2024 00:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070085;
	bh=5ojAQWLRuwMuldWRkPKiK/uQHSX78DhaKxe/Ap7vFKw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WVVR0IohL/jXELqwEOyRG6csCZBhm9NtcQtPB+LI2Gf8kjvl9uS+iWbFJu+nfb1HH
	 pCogra2RDlSEWma8NiWmc3LpnzBlXZsruoWuyT8HE40ef7KnaJRdxeriaVLD6c1Y+B
	 LAyxtiUQroyz2Uq8+tBEx5gaBrr5+Ol/GcyHxv39RrAPltr5gYCjHuR7Ji3WMXswI5
	 ZnPcBjZ81S0thaRsET0/lvIgE8c408ECRf0IXsk156vAvvs/Ncr4bjZ8rgCLNpy8xb
	 HaQYoy50eqhqj9hYsLKxmDsXkkYXpYIMweFXzJrSxWejWgpVyd/UXk1EbS+O27urNi
	 ys8R7P0ubnc3w==
Date: Sun, 31 Dec 2023 16:48:04 +9900
Subject: [PATCH 07/11] xfs/306: fix formatting failures with parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <170405028520.1824869.7940248988690229009.stgit@frogsfrogsfrogs>
In-Reply-To: <170405028421.1824869.17871351204326094851.stgit@frogsfrogsfrogs>
References: <170405028421.1824869.17871351204326094851.stgit@frogsfrogsfrogs>
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

The parent pointers feature isn't supported on tiny 20MB filesystems
because the larger directory transactions result in larger minimum log
sizes, particularly with nrext64 enabled:

** mkfs failed with extra mkfs options added to " -m rmapbt=0, -i nrext64=1, -n parent=1," by test 306 **
** attempting to mkfs using only test 306 options: -d size=20m -n size=64k **
max log size 5108 smaller than min log size 5310, filesystem is too small

We don't support 20M filesystems anymore, so bump the filesystem size up
to 100M and skip this test if we can't actually format the filesystem.
Convert the open-coded punch-alternating logic into a call to that
program to reduce execve overhead, which more than makes up having to
write 5x as much data to fragment the free space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/306 |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/tests/xfs/306 b/tests/xfs/306
index b57bf4c0a9..152971cfc3 100755
--- a/tests/xfs/306
+++ b/tests/xfs/306
@@ -23,6 +23,7 @@ _supported_fs xfs
 _require_scratch_nocheck	# check complains about single AG fs
 _require_xfs_io_command "fpunch"
 _require_command $UUIDGEN_PROG uuidgen
+_require_test_program "punch-alternating"
 
 # Disable the scratch rt device to avoid test failures relating to the rt
 # bitmap consuming all the free space in our small data device.
@@ -30,7 +31,8 @@ unset SCRATCH_RTDEV
 
 # Create a small fs with a large directory block size. We want to fill up the fs
 # quickly and then create multi-fsb dirblocks over fragmented free space.
-_scratch_mkfs_xfs -d size=20m -n size=64k >> $seqres.full 2>&1
+_scratch_mkfs_xfs -d size=100m -n size=64k >> $seqres.full 2>&1 || \
+	_notrun 'could not format tiny scratch fs'
 _scratch_mount
 
 # Fill a source directory with many largish-named files. 1k uuid-named entries
@@ -49,10 +51,7 @@ done
 $XFS_IO_PROG -xc "resblks 16" $SCRATCH_MNT >> $seqres.full 2>&1
 dd if=/dev/zero of=$SCRATCH_MNT/file bs=4k >> $seqres.full 2>&1
 $XFS_IO_PROG -c "fsync" $SCRATCH_MNT/file >> $seqres.full 2>&1
-size=`_get_filesize $SCRATCH_MNT/file`
-for i in $(seq 0 8192 $size); do
-	$XFS_IO_PROG -c "fpunch $i 4k" $SCRATCH_MNT/file >> $seqres.full 2>&1
-done
+$here/src/punch-alternating $SCRATCH_MNT/file
 
 # Replicate the src dir several times into fragmented free space. After one or
 # two dirs, we should have nothing but non-contiguous directory blocks.

