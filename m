Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5219F7ED;
	Mon,  1 Jan 2024 00:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dRamzwR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6318C433C8;
	Mon,  1 Jan 2024 00:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070773;
	bh=5tGYjlAVtTsCmR1z/8/XOITcG+nNZq/DfjTeq+f8+nc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dRamzwR1NFkbup5MSQlhDx5lCWoFSiAe32RH1rZyx/zASVK/vM/GW9Oy8Rny627BX
	 oQoYZvGhUEhQDOq4zBeZisLuxQWy9bo2mudu6XcsF4cTvNve1g+zwSzfPJjPlBYkny
	 uhYyODggDLrC4Cen42OBkQ0lsunKss6MGfaozIUFNA1n3lgjOoJcfY1ygcmgEgu2lv
	 g40zXVueVMJpYouLPJNg/KCfQ0Ceis9BnXK3VT/KwkgQmgfrnXcheJWJE+mPA1MV0x
	 ui+abxjzkfFOGH7SJ98b8EbDBwnlQIK3LT5HfRc7ORlHX06QKwXaV+yfHe7EBJwMUA
	 BDDwSEmlTQhYg==
Date: Sun, 31 Dec 2023 16:59:33 +9900
Subject: [PATCH 07/13] xfs/341: update test for rtgroup-based rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405031325.1826914.2968755576593092081.stgit@frogsfrogsfrogs>
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

Now that we're sharding the realtime volume into multiple allocation
groups, update this test to reflect the new reality.  The realtime rmap
btree record and key sizes have shrunk, and we can't guarantee that a
quick file write actually hits the same rt group as the one we fuzzed,
so eliminate the file write test since we're really only curious if
xfs_repair will fix the problem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/341     |   10 +++-------
 tests/xfs/341.out |    1 -
 2 files changed, 3 insertions(+), 8 deletions(-)


diff --git a/tests/xfs/341 b/tests/xfs/341
index 8861e751a9..561054f0bd 100755
--- a/tests/xfs/341
+++ b/tests/xfs/341
@@ -32,10 +32,10 @@ blksz="$(_get_block_size $SCRATCH_MNT)"
 rtextsz_blks=$((rtextsz / blksz))
 
 # inode core size is at least 176 bytes; btree header is 56 bytes;
-# rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
+# rtrmap record is 24 bytes; and rtrmap key/pointer are 48 bytes.
 i_core_size="$(_xfs_get_inode_core_bytes $SCRATCH_MNT)"
-i_ptrs=$(( (isize - i_core_size) / 56 ))
-bt_recs=$(( (blksz - 56) / 32 ))
+i_ptrs=$(( (isize - i_core_size) / 48 ))
+bt_recs=$(( (blksz - 56) / 24 ))
 
 blocks=$((i_ptrs * bt_recs + 1))
 len=$((blocks * rtextsz))
@@ -57,10 +57,6 @@ _scratch_xfs_db -x -c 'path -m /realtime/0.rmap' \
 	-c "write u3.rtrmapbt.ptrs[1] $fsbno" -c 'p' >> $seqres.full
 _scratch_mount
 
-echo "Try to create more files"
-$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f5 >> $seqres.full 2>&1
-test -e $SCRATCH_MNT/f5 && echo "should not have been able to write f5"
-
 echo "Repair fs"
 _scratch_unmount 2>&1 | _filter_scratch
 _repair_scratch_fs >> $seqres.full 2>&1
diff --git a/tests/xfs/341.out b/tests/xfs/341.out
index 75a5bc6c61..580d788954 100644
--- a/tests/xfs/341.out
+++ b/tests/xfs/341.out
@@ -2,6 +2,5 @@ QA output created by 341
 Format and mount
 Create some files
 Corrupt fs
-Try to create more files
 Repair fs
 Try to create more files (again)

