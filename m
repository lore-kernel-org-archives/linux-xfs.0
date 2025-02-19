Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBD233E1;
	Wed, 19 Feb 2025 01:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927129; cv=none; b=lK08bZq4dIazZiPRaD3yw2kZCNTwkvJ/g6WAbmjmyzgpZg4Vj6N2VSgcKYiwGga2GlhwjSMunfqFcaoCTEUZM4mxjoZNkVCIS7W10RRwkRl1gntn6K3hNhcOaEgKSBg4RYFo5fz9XFwwvX57dhoQA4Pr0eokJiydxXw7U2809fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927129; c=relaxed/simple;
	bh=51My6Yz8u8TCfrys2FUYZ7haFXFP0ZDBf9M+3Zmm88I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YMyqqVvc1ZujYv0Xy6s0jeW+4ieUZGGOn8YFDs1E/R35D1dtL4Eojs87gYXSfdQHpWMKYdgXrH0N/Js3NzibcFAaOTVl8VMepX27BFo8/sf7KTpmw3c4Rqb3qZ+XFsHm10q5ypWrLAcwryREWeCMjcUaUFBpDHvmxo6OkYJee+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=otkXZgIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="otkXZgIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1552FC4CEE2;
	Wed, 19 Feb 2025 01:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927129;
	bh=51My6Yz8u8TCfrys2FUYZ7haFXFP0ZDBf9M+3Zmm88I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=otkXZgIh/lQDpDgxl5oVkzPwWGfqt3Gk6GpfE3huA2qvhcL29lef/BwBl5nqdBLje
	 CNdY1IbM5WbpsL1Nw5ziCwCiv/WnJxB/jwbBsD2TLF8NoRu6VfJ8XcApLz+P4cBK/A
	 KUGBGTZR23kaZn49Htq98ncsewpDMjvBx8QYnppHjDgtjz6cMmFQ/x58lhnEYOMSff
	 6wztetqq4f3JQEI8Xb9pa7+bnyiEheaiH3i6/bbaOPFV4amttKjvVl0BEPk1W8zQFd
	 ytJeGGsc9DPbO2qLcYXjH6SvAe+5p/2EXEZz3naBs5qfen4h8ihPndpGED3qKmuEVA
	 PBxmscExls/HA==
Date: Tue, 18 Feb 2025 17:05:28 -0800
Subject: [PATCH 07/13] xfs/3{43,32}: adapt tests for rt extent size greater
 than 1
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591239.4080556.3578802214204172288.stgit@frogsfrogsfrogs>
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

Both of these tests for the realtime volume can fail when the rt extent
size is larger than a single block.

332 is a read-write functionality test that encodes md5sum in the
output, so we need to skip it if $blksz isn't congruent with the extent
size, because the fcollapse call will fail.

343 is a test of the rmap btree, so the fix here is simpler -- make
$blksz the file allocation unit, and get rid of the md5sum in the
golden output.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/332     |    6 +-----
 tests/xfs/332.out |    2 --
 tests/xfs/343     |    2 ++
 3 files changed, 3 insertions(+), 7 deletions(-)


diff --git a/tests/xfs/332 b/tests/xfs/332
index 93c94bcdccf07e..fd91ebab164f34 100755
--- a/tests/xfs/332
+++ b/tests/xfs/332
@@ -26,7 +26,7 @@ rm -f "$seqres.full"
 echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
-blksz=65536
+blksz=$(_get_file_block_size $SCRATCH_MNT) # 65536
 blocks=16
 len=$((blocks * blksz))
 
@@ -43,10 +43,6 @@ $XFS_IO_PROG -c "fpunch $blksz $blksz" \
 	-c "fcollapse $((9 * blksz)) $blksz" \
 	-c "finsert $((10 * blksz)) $blksz" $SCRATCH_MNT/f1 >> $seqres.full
 
-echo "Check file"
-md5sum $SCRATCH_MNT/f1 | _filter_scratch
-od -tx1 -Ad -c $SCRATCH_MNT/f1 >> $seqres.full
-
 echo "Unmount"
 _scratch_unmount
 
diff --git a/tests/xfs/332.out b/tests/xfs/332.out
index 9beff7cc3704c0..3a7ca95b403e77 100644
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
index a5834cab123e7d..d5ac96d085ee6b 100755
--- a/tests/xfs/343
+++ b/tests/xfs/343
@@ -29,6 +29,8 @@ blksz=65536
 blocks=16
 len=$((blocks * blksz))
 
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
+
 echo "Create some files"
 $XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f1 >> $seqres.full
 

