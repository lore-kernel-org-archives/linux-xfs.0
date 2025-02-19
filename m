Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444B881724;
	Wed, 19 Feb 2025 00:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926736; cv=none; b=ZRfOVcyVq0h4TsnaexgTLM2qCqCH+Toq5eHs1By9WycE4z+qda+53Kh4eprRxRmQnKFXMrVvk4R2zZnZROLpqRj1/odfzeb+JTfTVibEtZ2QSvKapka1oADxb9ThIoloUgD32jN92PQSrxeK8kE/Sl0tNpD2+oQ+0ky9fAfjkoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926736; c=relaxed/simple;
	bh=ofR2nfAv6ZdrOoUdpGDrZifQWcILDaZXQ3B7wGvAI/k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nw9VSP80TJr+6kATusXhvZrarxJirSXyyt57IZ4H8wGiaj64wiyc2pKIdvlygNmy7IncapLiSLCrb3doXcNgixGFMbZTlYCVA0U8xd415V3Wwgnu0rpGM/WAO8pQeJwjOcK1JWnW0kHSRN5y+pIXTIozHQclKsOtu+BlUL/pM6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e+ZbsAKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e+ZbsAKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1572AC4CEE2;
	Wed, 19 Feb 2025 00:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926736;
	bh=ofR2nfAv6ZdrOoUdpGDrZifQWcILDaZXQ3B7wGvAI/k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e+ZbsAKi3bU3Juewi29FkhRAEJZSb6SfBkWBZ6HSOl/ALC95v9s7dHDt4vLTV2U+k
	 O6b6v6XE8+Ak0by/f0PWMUIHlIBKP4To5VmnMLziP2sXMVF1zLWOLfd1o1VlNVGgRi
	 OpeO8XRL85tjxshbrFVb/StQ4SujsaFZdmLl/fXBMo7jbJZKcx8JXDCQMitbmOr8D+
	 6PawGWG3i+MeP8WgZIP8HPa+Bd0KjaQgFa7KrcMQjvUz9+kxwP7Y6kmk5TjCCfTcSR
	 1ZX+9gwRLP4hQKd7+J5rSns0EzeFyl1krQX2XXzTbAJA6vAhGEfE7fqQIpYTsI1r4p
	 V866YEksmSzGQ==
Date: Tue, 18 Feb 2025 16:58:55 -0800
Subject: [PATCH 05/15] common/ext4: reformat external logs during mdrestore
 operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589272.4079457.17538661785920086668.stgit@frogsfrogsfrogs>
In-Reply-To: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The e2image file format doesn't support the capture of external log
devices, which means that mdrestore ought to reformat the external log
to get the restored filesystem to work again.  The common/populate code
could already do this, so push it to the common ext4 helper.

While we're at it, fix the uncareful usage of SCRATCH_LOGDEV in the
populate code.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/ext4     |   17 ++++++++++++++++-
 common/populate |   18 +++++-------------
 2 files changed, 21 insertions(+), 14 deletions(-)


diff --git a/common/ext4 b/common/ext4
index 13921bb8165a4d..e1b336d3d20cba 100644
--- a/common/ext4
+++ b/common/ext4
@@ -134,7 +134,8 @@ _ext4_mdrestore()
 {
 	local metadump="$1"
 	local device="$2"
-	shift; shift
+	local logdev="$3"
+	shift; shift; shift
 	local options="$@"
 
 	# If we're configured for compressed dumps and there isn't already an
@@ -148,6 +149,20 @@ _ext4_mdrestore()
 	test -r "$metadump" || return 1
 
 	$E2IMAGE_PROG $options -r "${metadump}" "${SCRATCH_DEV}"
+	res=$?
+	test $res -ne 0 && return $res
+
+	# ext4 cannot e2image external logs, so we have to reformat the log
+	# device to match the restored fs
+	if [ "${logdev}" != "none" ]; then
+		local fsuuid="$($DUMPE2FS_PROG -h "${SCRATCH_DEV}" 2>/dev/null | \
+				grep 'Journal UUID:' | \
+				sed -e 's/Journal UUID:[[:space:]]*//g')"
+		$MKFS_EXT4_PROG -O journal_dev "${logdev}" \
+				-F -U "${fsuuid}"
+		res=$?
+	fi
+	return $res
 }
 
 # this test requires the ext4 kernel support crc feature on scratch device
diff --git a/common/populate b/common/populate
index e6804cbc6114ba..32dc5275e2debd 100644
--- a/common/populate
+++ b/common/populate
@@ -1034,20 +1034,12 @@ _scratch_populate_restore_cached() {
 		return $?
 		;;
 	"ext2"|"ext3"|"ext4")
-		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}"
-		ret=$?
-		test $ret -ne 0 && return $ret
+		local logdev=none
+		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+			logdev=$SCRATCH_LOGDEV
 
-		# ext4 cannot e2image external logs, so we have to reformat
-		# the scratch device to match the restored fs
-		if [ -n "${SCRATCH_LOGDEV}" ]; then
-			local fsuuid="$($DUMPE2FS_PROG -h "${SCRATCH_DEV}" 2>/dev/null | \
-					grep 'Journal UUID:' | \
-					sed -e 's/Journal UUID:[[:space:]]*//g')"
-			$MKFS_EXT4_PROG -O journal_dev "${SCRATCH_LOGDEV}" \
-					-F -U "${fsuuid}"
-		fi
-		return 0
+		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}" "${logdev}"
+		return $?
 		;;
 	esac
 	return 1

