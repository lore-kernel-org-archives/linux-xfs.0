Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888191754B;
	Wed, 21 May 2025 22:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867312; cv=none; b=kpf6dVvUKGtKj4IZ/YHZP/jQX0ZqcUMEEl+aId6RY2CeMm0UkO6mP3Z0tOBRk5t2MeXskE5IrJICASwugGBH7tZHaGwLLcXrl39zjRz5uzwGNB72WeolshyMVz3rmBu1tsdO12KK7fcqtN+mkjqxE+CSesdf5YSOJjH43xMKeKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867312; c=relaxed/simple;
	bh=dPaxILFmhNsClQCIOcFPUU+fZ4kInwwpCOj9FSijCJ0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bIP5qocwigRPC40MnMdcFNLujkAi2w3s76+XeW+sgJN/tEHuVPAZn1m9wrbNUmMQHyj9TSs0zLejhOkbpPidwO+Xtk8bRFG7mT5Nqfn8e9GOhZnnPYWhM32gueVI+sz2rrIxPpypm5VQrP3tzLrUHrHqJYypAVMiJavkMapKoPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iImzUZtT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iImzUZtT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E489C4CEE4;
	Wed, 21 May 2025 22:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747867312;
	bh=dPaxILFmhNsClQCIOcFPUU+fZ4kInwwpCOj9FSijCJ0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iImzUZtTOZF5iXkftxLcLMc+ZPAmDEL+59LjuoCunHNFFtrh9A1/THDxCYb1aK+ry
	 kOEM5lBSbyuP12UJnNNmMR1z/yWjhARhnzKiLSzACe61k2trshJFQc5A4YKRc4sbMB
	 WMjYE9nroGpX/4RnCBIlTR9tLDjLrcjpJ/2ZGYv2vtDfTEXZmBz7N40OWU8xVKVPd5
	 lt/NM3DzsLbHmv1QNDRpMOq7NLy9AGFIZ2k0fT4MlqEJQpLeNSAuB34gx4mIcRpaKg
	 vsQqXuewUXwELg9K8L00jADW0c61y69bGqDmVgjQh1/Ka+5YBgRHfssQlriZfVMZoG
	 n34uysnXm1/kQ==
Date: Wed, 21 May 2025 15:41:51 -0700
Subject: [PATCH 4/4] xfs/432: fix metadump loop device blocksize problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <174786719464.1398726.8513251082673880762.stgit@frogsfrogsfrogs>
In-Reply-To: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>
References: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make sure the lba size of the loop devices created for the metadump
tests actually match that of the real SCRATCH_ devices or else the tests
will fail.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/metadump |   12 ++++++++++--
 common/rc       |    7 +++++++
 2 files changed, 17 insertions(+), 2 deletions(-)


diff --git a/common/metadump b/common/metadump
index 61ba3cbb91647c..4ae03c605563fc 100644
--- a/common/metadump
+++ b/common/metadump
@@ -76,6 +76,7 @@ _xfs_verify_metadump_v1()
 
 	# Create loopdev for data device so we can mount the fs
 	METADUMP_DATA_LOOP_DEV=$(_create_loop_device $data_img)
+	_force_loop_device_blocksize $METADUMP_DATA_LOOP_DEV $SCRATCH_DEV
 
 	# Mount fs, run an extra test, fsck, and unmount
 	SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV _scratch_mount
@@ -123,12 +124,19 @@ _xfs_verify_metadump_v2()
 
 	# Create loopdev for data device so we can mount the fs
 	METADUMP_DATA_LOOP_DEV=$(_create_loop_device $data_img)
+	_force_loop_device_blocksize $METADUMP_DATA_LOOP_DEV $SCRATCH_DEV
 
 	# Create loopdev for log device if we recovered anything
-	test -s "$log_img" && METADUMP_LOG_LOOP_DEV=$(_create_loop_device $log_img)
+	if [ -s "$log_img" ]; then
+		METADUMP_LOG_LOOP_DEV=$(_create_loop_device $log_img)
+		_force_loop_device_blocksize $METADUMP_LOG_LOOP_DEV $SCRATCH_LOGDEV
+	fi
 
 	# Create loopdev for rt device if we recovered anything
-	test -s "$rt_img" && METADUMP_RT_LOOP_DEV=$(_create_loop_device $rt_img)
+	if [ -s "$rt_img" ]; then
+		METADUMP_RT_LOOP_DEV=$(_create_loop_device $rt_img)
+		_force_loop_device_blocksize $METADUMP_RT_LOOP_DEV $SCRATCH_RTDEV
+	fi
 
 	# Mount fs, run an extra test, fsck, and unmount
 	SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV SCRATCH_LOGDEV=$METADUMP_LOG_LOOP_DEV SCRATCH_RTDEV=$METADUMP_RT_LOOP_DEV _scratch_mount
diff --git a/common/rc b/common/rc
index 4e3917a298e072..9e27f7a4afba44 100644
--- a/common/rc
+++ b/common/rc
@@ -4527,6 +4527,8 @@ _create_loop_device()
 }
 
 # Configure the loop device however needed to support the given block size.
+# The first argument is the loop device; the second is either an integer block
+# size, or a different block device whose blocksize we want to match.
 _force_loop_device_blocksize()
 {
 	local loopdev="$1"
@@ -4539,6 +4541,11 @@ _force_loop_device_blocksize()
 		return 1
 	fi
 
+	# second argument is really a bdev; copy its lba size
+	if [ -b "$blksize" ]; then
+		blksize="$(blockdev --getss "${blksize}")"
+	fi
+
 	curr_blksize="$(losetup --list --output LOG-SEC --noheadings --raw "$loopdev")"
 	if [ "$curr_blksize" -gt "$blksize" ]; then
 		losetup --direct-io=off "$loopdev"

