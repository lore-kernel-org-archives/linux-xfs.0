Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D646AC0;
	Tue, 18 Jun 2024 00:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671872; cv=none; b=jXRhRgY7MdMjIVDfW5yC0Hc+N6xH/zSO/yNywSEN7TQjmlhE4eKVcbCPmHc9Je2LuB7+b20YuREbX4/GGOjOlO3EoDiVrmi2EU/jsMNe1VhIqDq3JZp3PHGpRx+p6hF4FL/iOer2d1v784pdvlAssUjdtplwgT+JbXRDjHwDBew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671872; c=relaxed/simple;
	bh=5ojAQWLRuwMuldWRkPKiK/uQHSX78DhaKxe/Ap7vFKw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jRM9qg6sq+EheawkLL3+xdI41odJhOBirVDdZrHvB5YjaCEgMbcUVjq7uP6CL1CBH3Rve/bohTF/ePW6ltPeBNfoAVmELlKnIrnNajQ9UKdY7gnZ10FEr8NeqGmsShAiDm5ORrqzQTxFPo2OqAb3IYOYbrv7Do3YsEpCI8+3ieY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PKUGGHuX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PKUGGHuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2E5C4AF1D;
	Tue, 18 Jun 2024 00:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671871;
	bh=5ojAQWLRuwMuldWRkPKiK/uQHSX78DhaKxe/Ap7vFKw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PKUGGHuXfUGpfkLO6i7+TnOUZCBG2FJyfjQauOnCwEZ6cxgzCPhFVxqifUneLYx5w
	 XpJLKaCuig+Qf7fXs/yfJgFXuLGI/3bTjKTQMMUKc7Acyqkf6s+Y1BCYrQ+zRmtD5M
	 l46SyRNFPD9AuZys3mQ0V0xDCDNKTJcDaaLntCQx3gt/NDZmW7QYcebJohAlWOSFIR
	 JJR3+VjjV+juIhdI/eEVmQ17JNIQ1ijTvsexG1qBqopMI026PSiPX83TIG2AFi6Z7Z
	 iKdY6DTxGit0o8KML2V1ZjdMmUXYBqiaRvFCzdLeJ3SaLrQBABoHsbmtsdgmZls7WY
	 fYZhIeOU/hg/A==
Date: Mon, 17 Jun 2024 17:51:11 -0700
Subject: [PATCH 07/11] xfs/306: fix formatting failures with parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, catherine.hoang@oracle.com
Message-ID: <171867145914.793846.1014062264186581717.stgit@frogsfrogsfrogs>
In-Reply-To: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
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

