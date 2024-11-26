Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544E98F40;
	Tue, 26 Nov 2024 01:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584064; cv=none; b=Cny1Chr1WYcujHDZQ9R78y3U9kNEjMI90R0WePQ0JEsTT29crK1iHmESntucfL6KFDQ7wolw0or2q0IyoJFcOA+BBwOABivBBPc4Z+Mt+d6QsyxN2zuwMKtedPid0OTkrB4MN/11cQXkBUseN3lRCzJlMI9sW3KXa4yqCO7+TQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584064; c=relaxed/simple;
	bh=lGeUt/i/gDeyl0ELHUQ7/2iFviEl45XJmogXUkGtvJ0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n2t4cTr4CxJc6XY4w9AXw2P4G0GGjB6J+y15hJTuZT5siCTK/SV5vx+QD4URlTvhpSTy2Zj5NsyaFBihQCLaGX/1QNGxDswhk0oUgPR03rteMEiVem/Zjj3gVlZOg6lJAb4pmU27NsZrWKI9YhtCKTu2UqFJU7kDvSEPP7xBxvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HChpX60x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HChpX60x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B106CC4CECE;
	Tue, 26 Nov 2024 01:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584063;
	bh=lGeUt/i/gDeyl0ELHUQ7/2iFviEl45XJmogXUkGtvJ0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HChpX60xdVPbrdrIb32DVdKilDR5rrjjBjNoEBweHTV308QNBn+rkXzb3q2l1cDaq
	 EvuR+hCKwrh1JgwWkMaCz9cHW+yD3xFKAgmpe8wMKN+wSWxtmSLuZ3pDGPmLyT4XV0
	 jvsWc+rPJx6CLNxzxZcGu0k9F9kZrnuE2/wW1Vys1Nf0h3RG3OcFAgTwmeRsYHNCiR
	 pFg7UlZ6zMaNokAQ1AJOK0OcZPy27O3tudArC4d5nkocn29nYko4XYchX3jPDpgFou
	 fSuV0OfcKgmxXsFHzIIv9KiZVIAF7tkVe79gzvfeZpGpV2NPE5j39aD96yNFJmMKnb
	 FqNxYYII5MYIw==
Date: Mon, 25 Nov 2024 17:21:03 -0800
Subject: [PATCH 02/16] generic/757: convert to thinp
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258395101.4031902.14954667811124439467.stgit@frogsfrogsfrogs>
In-Reply-To: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
References: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

