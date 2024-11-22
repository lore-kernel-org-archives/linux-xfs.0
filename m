Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0445D477;
	Fri, 22 Nov 2024 16:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294259; cv=none; b=lsjkVPwXUfbEiG6G0K4QlE54bAl2qWEMTGChmelPxY+DBidI4B5sXMmVImEknhvzdxvLT2b/NWgNRBec2u40KEIYEHcKDzXesSk7Tsq/fnty6VfbJd71pHTFT+VZ5qgtqdhvQjHgzZ7Eqsd+3DqE3bTImUkMYuGAq0cp5tPyhwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294259; c=relaxed/simple;
	bh=vDejHN868eLxHTxDPPabBAQeKxYhNyPu8rgk3Fp0FjE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XtyW6VgTd5QMXjInhNZmEs2Fo4hu4Qv7bP9RInCOxl1j2aNLUxjUJGJ/tVkgWfQGc5dbD1J08CjZHDNGRNBLW9JEMIR6E8Ij/D61kFuBfhrl6+Mo5+rWyO6B+9279FpvBbtE/zjm01jJf39W1amWpe+9N8o2qQnHOzKZq38voq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o7v58s/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o7v58s/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114A2C4CECE;
	Fri, 22 Nov 2024 16:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732294259;
	bh=vDejHN868eLxHTxDPPabBAQeKxYhNyPu8rgk3Fp0FjE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=o7v58s/zRMnKItOoC8P5nLx6nbBTc86ycixv5Cj9vwy0LlOMAclBhb8lJ8VeaIHz6
	 T1GONfGrcvWpxlQBd1eyKCONcwXgrC7pETo1UAWrC8YMJ/ESp7zmYSd0/vvaz6bPiG
	 8tNW6D39T6Oj7vbPScvTuDWLpO6bEs90HGxYBiMHz8qElGNyo+JIN4CFptGO7unHXg
	 +W6MROEWgYO+QOphElCq34TAtg2haWTnVqr7YKhGccX9fbTL0Ufs8ZvNedshXgk4ys
	 YNG5ly4C4bQjp0S+ABsd9ZTMG1TtxuiWq9CULVrMlyWXG78aXtek3ETXxoK6IqITi6
	 HNAaOMv1rmc+g==
Date: Fri, 22 Nov 2024 08:50:58 -0800
Subject: [PATCH 02/17] generic/757: convert to thinp
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173229420045.358248.13209894180925094165.stgit@frogsfrogsfrogs>
In-Reply-To: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Convert this test to use dm-thinp so that discards always zero the data.
This prevents weird replay problems if the scratch device doesn't
guarantee that read after discard returns zeroes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/757 |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)


diff --git a/tests/generic/757 b/tests/generic/757
index 37cf49e6bc7fd9..6c13c6af41c57c 100755
--- a/tests/generic/757
+++ b/tests/generic/757
@@ -8,12 +8,13 @@
 # This can be seen on subpage FSes on Linux 6.4.
 #
 . ./common/preamble
-_begin_fstest auto quick metadata log recoveryloop aio
+_begin_fstest auto quick metadata log recoveryloop aio thin
 
 _cleanup()
 {
 	cd /
 	_log_writes_cleanup &> /dev/null
+	_dmthin_cleanup
 	rm -f $tmp.*
 }
 
@@ -23,11 +24,14 @@ _cleanup()
 
 fio_config=$tmp.fio
 
+. ./common/dmthin
 . ./common/dmlogwrites
 
-_require_scratch
+# Use thin device as replay device, which requires $SCRATCH_DEV
+_require_scratch_nocheck
 _require_aiodio
 _require_log_writes
+_require_dm_target thin-pool
 
 cat >$fio_config <<EOF
 [global]
@@ -47,7 +51,13 @@ _require_fio $fio_config
 
 cat $fio_config >> $seqres.full
 
-_log_writes_init $SCRATCH_DEV
+# Use a thin device to provide deterministic discard behavior. Discards are used
+# by the log replay tool for fast zeroing to prevent out-of-order replay issues.
+_test_unmount
+sectors=$(blockdev --getsz $SCRATCH_DEV)
+sectors=$((sectors * 90 / 100))
+_dmthin_init $sectors $sectors
+_log_writes_init $DMTHIN_VOL_DEV
 _log_writes_mkfs >> $seqres.full 2>&1
 _log_writes_mark mkfs
 
@@ -64,14 +74,13 @@ cur=$(_log_writes_find_next_fua $prev)
 [ -z "$cur" ] && _fail "failed to locate next FUA write"
 
 while _soak_loop_running $((100 * TIME_FACTOR)); do
-	_log_writes_replay_log_range $cur $SCRATCH_DEV >> $seqres.full
+	_log_writes_replay_log_range $cur $DMTHIN_VOL_DEV >> $seqres.full
 
 	# xfs_repair won't run if the log is dirty
 	if [ $FSTYP = "xfs" ]; then
-		_scratch_mount
-		_scratch_unmount
+		_dmthin_mount
 	fi
-	_check_scratch_fs
+	_dmthin_check_fs
 
 	prev=$cur
 	cur=$(_log_writes_find_next_fua $(($cur + 1)))

