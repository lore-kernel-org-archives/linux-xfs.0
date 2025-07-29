Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE641FBCAF;
	Tue, 29 Jul 2025 20:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753819758; cv=none; b=nbkz4+Ayauq+ZkLKJBfUjvF2Vu3QA4E+DLan8QtTWs04SY2TNUdYG2VGqh260ZWirLlm0xwD0qu81xpjdz6pRwaHtnfWB1u39EZryVHZnK1fmfO3dBgSdQHqm18wMD4INNhLhia4VieFHTArEUYJrKh+8KozWmtZeA92c/Vd/i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753819758; c=relaxed/simple;
	bh=0h14q8EhiT1Apvmj6m4wxrlZRngrzGo7ZmopHTGFZtY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u33Y1l8Hl6TRO1yQH9/YTmOfTaYdi8tYhs7uNKyf+Y7fPSsDozEXqdoAD76ghDXoAWbmAyWBY5zFUj1b/Z1ivVha0d+y6LjXQZt6wqkenk3e7Ru04NjZily32oS9ID886h+eHvysaSuubNv3sdzr0kdGyCUX0HTJgvHHppI4mYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UzEQ2axN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UzEQ2axN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D84C4CEF7;
	Tue, 29 Jul 2025 20:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753819757;
	bh=0h14q8EhiT1Apvmj6m4wxrlZRngrzGo7ZmopHTGFZtY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UzEQ2axNzZEvvgYzyBmPkzCE3oYUB/nT9FVzr0eZAohHofbgfjoAxVJL1m2wuIwuE
	 y1qGxEQq70Lu52Tsh1PTtxjiENjxM5hPI2B1xx1RDCPCt0qGwQFG1yfWX5fIol0XoM
	 OghkhcWzgJoCWCBnlhwgRY/d7hIqEgLnnp8+O2jrhR9fJsljdFIznmEzl1x4P2uCbB
	 N1gfe2cWse803pYVdZAAdyQXVL7srJsNP++0xhUzrY0pbqJ77nCmnAIVwU6m06sdys
	 tvi6J/0p8c1OxaW7AMsC3J9BLussadHe+XXUY3ixO81IB0Gprt0AS8ty9ymdBtRzo7
	 apIty7d/QfDjg==
Date: Tue, 29 Jul 2025 13:09:17 -0700
Subject: [PATCH 4/7] generic/767: only test the hardware atomic write unit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <175381957973.3020742.7280346741094447176.stgit@frogsfrogsfrogs>
In-Reply-To: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This test sets up scsi_debug so that we can test the fs and block layer
code for hardware-accelerated atomic writes (and not just a software
fallback).  However, the userspace ABI for detecting atomic write
geometry has changed since the start of development (to include said
software fallback) so we must add some extra code to find the real
hardware capabilities, and base the write sizes based on that.

This fixes a test failure with 32k blocksizes because the advertised
atomic_write_unit_max is 128M and fallocate quickly runs out of space.

While we're at it fix a stupid variable usage bug in the loop.

Cc: <fstests@vger.kernel.org> # v2025.07.13
Fixes: fa8694c823d853 ("generic: various atomic write tests with hardware and scsi_debug")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/atomicwrites |    6 ++++++
 tests/generic/767   |   16 +++++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)


diff --git a/common/atomicwrites b/common/atomicwrites
index 95d545a67cadda..33526399d2e980 100644
--- a/common/atomicwrites
+++ b/common/atomicwrites
@@ -18,6 +18,12 @@ _get_atomic_write_unit_max()
         grep -w atomic_write_unit_max | grep -o '[0-9]\+'
 }
 
+_get_atomic_write_unit_max_opt()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep -w atomic_write_unit_max_opt | grep -o '[0-9]\+'
+}
+
 _get_atomic_write_segments_max()
 {
 	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
diff --git a/tests/generic/767 b/tests/generic/767
index 31d599eacfd63b..161fef03825db4 100755
--- a/tests/generic/767
+++ b/tests/generic/767
@@ -61,8 +61,18 @@ $XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
 sector_size=$(blockdev --getss $SCRATCH_DEV)
 min_awu=$(_get_atomic_write_unit_min $testfile)
 max_awu=$(_get_atomic_write_unit_max $testfile)
+opt_awu=$(_get_atomic_write_unit_max_opt $testfile)
 
-$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+echo "min:$min_awu max:$max_awu opt:$opt_awu" >> $seqres.full
+
+# We want to test hardware support, so use that if detected
+if [ -n "$opt_awu" ] && [ "$opt_awu" != "0" ]; then
+	write_size="$opt_awu"
+else
+	write_size="$max_awu"
+fi
+
+$XFS_IO_PROG -f -c "falloc 0 $((write_size * 2))" -c fsync $testfile
 
 # try outside the advertised sizes
 echo "two EINVAL for unsupported sizes"
@@ -73,8 +83,8 @@ _simple_atomic_write $max_i $max_i $testfile -d
 
 # try all of the advertised sizes
 echo "all should work"
-for ((i = min_awu; i <= max_awu; i *= 2)); do
-	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+for ((i = min_awu; i <= write_size; i *= 2)); do
+	$XFS_IO_PROG -f -c "falloc 0 $((write_size * 2))" -c fsync $testfile
 	_test_atomic_file_writes $i $testfile
 done
 

