Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1208438D;
	Mon,  1 Jan 2024 00:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VjMVY1+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746F4C433C8;
	Mon,  1 Jan 2024 00:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070789;
	bh=rZQRoAcAh/3zfW2Sh1mMP3nA4r5gUeCjbevpArYJvM4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VjMVY1+BB30RM2TzdfNcnHZjHWmf5dv0RQ0d1jnntO2y278UenRrGjYK9x5SWxnx9
	 XAc7ZDRqNZvxokdKRfJ0L7YIFTrPEEgQ3IUdIa2UCsCDjzZYEHJmm1HyNrIUNVxCNN
	 4s0ciBBD5nNnjufXMN+nve49sUtGf8o+N7dWY0MmJREwklyDDTHOM5ekG2BfMrlz/W
	 OlMmluCz0X5rDVkUD1xPKL3XQeAws4RhtF7kMKQqz7rBHbD5XPY+C1dCNVKl87pwPZ
	 z/9nikJPhJD8nT81aXh2ZuRYbW67nC+HFrdx8FImlEgukgNiNvuxX1vUMaS7xxat/4
	 3ZKbzLsCX2mrQ==
Date: Sun, 31 Dec 2023 16:59:48 +9900
Subject: [PATCH 08/13] xfs/3{43,32}: adapt tests for rt extent size greater
 than 1
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405031339.1826914.7325295617050633178.stgit@frogsfrogsfrogs>
In-Reply-To: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
References: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
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

Both of these tests for the realtime volume can fail when the rt extent
size is larger than a single block.

332 is a read-write functionality test that encodes md5sum in the
output, so we need to skip it if $blksz isn't congruent with the extent
size, because the fcollapse call will fail.

343 is a test of the rmap btree, so the fix here is simpler -- make
$blksz the file allocation unit, and get rid of the md5sum in the
golden output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/332     |    6 +-----
 tests/xfs/332.out |    2 --
 tests/xfs/343     |    2 ++
 3 files changed, 3 insertions(+), 7 deletions(-)


diff --git a/tests/xfs/332 b/tests/xfs/332
index a2d37ee905..c1ac87adcb 100755
--- a/tests/xfs/332
+++ b/tests/xfs/332
@@ -28,7 +28,7 @@ rm -f "$seqres.full"
 echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
-blksz=65536
+blksz=$(_get_file_block_size $SCRATCH_MNT) # 65536
 blocks=16
 len=$((blocks * blksz))
 
@@ -45,10 +45,6 @@ $XFS_IO_PROG -c "fpunch $blksz $blksz" \
 	-c "fcollapse $((9 * blksz)) $blksz" \
 	-c "finsert $((10 * blksz)) $blksz" $SCRATCH_MNT/f1 >> $seqres.full
 
-echo "Check file"
-md5sum $SCRATCH_MNT/f1 | _filter_scratch
-od -tx1 -Ad -c $SCRATCH_MNT/f1 >> $seqres.full
-
 echo "Unmount"
 _scratch_unmount
 
diff --git a/tests/xfs/332.out b/tests/xfs/332.out
index 9beff7cc37..3a7ca95b40 100644
--- a/tests/xfs/332.out
+++ b/tests/xfs/332.out
@@ -2,8 +2,6 @@ QA output created by 332
 Format and mount
 Create some files
 Manipulate file
-Check file
-e45c5707fcf6817e914ffb6ce37a0ac7  SCRATCH_MNT/f1
 Unmount
 Try a regular fsmap
 Try a bad fsmap
diff --git a/tests/xfs/343 b/tests/xfs/343
index bffcc7d9ac..fe461847ed 100755
--- a/tests/xfs/343
+++ b/tests/xfs/343
@@ -31,6 +31,8 @@ blksz=65536
 blocks=16
 len=$((blocks * blksz))
 
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
+
 echo "Create some files"
 $XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f1 >> $seqres.full
 

