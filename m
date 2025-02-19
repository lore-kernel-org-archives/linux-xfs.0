Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E5F286292;
	Wed, 19 Feb 2025 01:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927114; cv=none; b=tRjmohzwqLs5v5TddSAmLg3TRYqEZer7TUWoL3g2cRuD8y68UyGkI3nV9FeZ/9vCXsrgpyEAV1Jql6/5efGmCVGUoSYpjC9tNI+xauKq98fb5bsmPocMz/r/aoiOautcJ47C4ZoeBXk6PicDIeZifaIJW+VrV6UWyVejCghqzbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927114; c=relaxed/simple;
	bh=ABeLMAhOkE9cbF0HYyNr8T3r/c/c36CgzIjClyN8PUE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Btii0zDXha4V42fABlrn4f1z/2sETEv42qbk9YKBzkyOBb1nJjwYP6MVasDaUQUqcnS5Eshgww68OM2LXog3G/Z7cbCHSCVciAjRRjVT8E3fbhJCq8FaoYyRd8JymbM1dJpHw+uDOuP0EMQC44MNiYBDlFLuzu1sdbd54EqjCQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UljYS3Mz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UljYS3Mz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702BFC4CEE2;
	Wed, 19 Feb 2025 01:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927113;
	bh=ABeLMAhOkE9cbF0HYyNr8T3r/c/c36CgzIjClyN8PUE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UljYS3MzE9mIKEdcpi3oEQ3Vvd2/RBVQssZjd70He7wi6g7VMAtUZBYvqKCwcxvbO
	 DmxG2GNGmqpFAIr0g/Dj+mnOS1P+dAE8qMwo25F97O/rvzSwJYPYyw27agjx7ylkpj
	 dRyJFz6nUUTcdB39jpkE8oWtJwGqWfxLuRgWrt47kRMkhnWbS757vzRxLMD3NjCAWQ
	 lFtG9Y9sFW3QhPQLDT2Ae8YfoI0tUsqlOWN6MYmwboilA8nIg/MNe3tc3Yaxkvqu6q
	 6Ipuxk7lzpEZ22EF5Gf3fdJf+nGAMWLdpruiw8j6NIp6PBxLJYOapZXbpRk3T9aVZT
	 EXbkhgBvFydcQ==
Date: Tue, 18 Feb 2025 17:05:13 -0800
Subject: [PATCH 06/13] xfs/341: update test for rtgroup-based rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591223.4080556.9240285310117453482.stgit@frogsfrogsfrogs>
In-Reply-To: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/341     |   10 +++-------
 tests/xfs/341.out |    1 -
 2 files changed, 3 insertions(+), 8 deletions(-)


diff --git a/tests/xfs/341 b/tests/xfs/341
index e9aea42f429ffd..fd450135b45de3 100755
--- a/tests/xfs/341
+++ b/tests/xfs/341
@@ -30,10 +30,10 @@ blksz="$(_get_block_size $SCRATCH_MNT)"
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
@@ -55,10 +55,6 @@ _scratch_xfs_db -x -c 'path -m /rtgroups/0.rmap' \
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
index 75a5bc6c61191a..580d78895417c9 100644
--- a/tests/xfs/341.out
+++ b/tests/xfs/341.out
@@ -2,6 +2,5 @@ QA output created by 341
 Format and mount
 Create some files
 Corrupt fs
-Try to create more files
 Repair fs
 Try to create more files (again)

