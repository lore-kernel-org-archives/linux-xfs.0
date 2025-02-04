Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FA725A62C;
	Tue,  4 Feb 2025 21:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704185; cv=none; b=laa7mMU4wDFm+m/v18AZLNAmRFa1f4FD8wa+HC9r2bw3p145NZvxmhE0MTCTM6zIgPlcvgambwWQZiK/DShRfaVIPFE5RFntmgYihKlad4jKniTyG9ynkWeHSjyck6ehezosKhBYG/RdSIGJUBngkQD7cvxAAxRGD1ghtpzYrfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704185; c=relaxed/simple;
	bh=4Vo3B1NoJiPb9nFIR2rlIEtOJQFxP3eMgT4R8v4e5o8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ARmr/2dqpqH/f817SLEPRNyFX+0jGopTfs2xnkoqGNtDRjpx/+uD1juss3BryDuWDIsppZS2w2O8UF1CoBDSAyQ0nCscdCOL/q5+gWY1sKkm2S1DtSXbGLUSPX/2NndN7GSB1wPA3qAF11StVD68Nb90CgtLaJf4Z99hL4g01U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qAspzpRi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qAspzpRi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36603C4CEDF;
	Tue,  4 Feb 2025 21:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704185;
	bh=4Vo3B1NoJiPb9nFIR2rlIEtOJQFxP3eMgT4R8v4e5o8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qAspzpRiw/COltPHDU75F1EY11Tmua4/D3GtKbz2bL62+hH/yYPECfxx/pef4cezm
	 jR84RfaszjTOA7qBkDu46VyejHjxiaozT+vt2tcCrwYlyi2ooedHn2LAXvpADPVad/
	 0fv3/ew2PqIXKNpYmKkdIbALx4614gPM3qN/KWVWTmktGikjmI+edUcm1h/CP62a5W
	 6ek5DVel5KIjYvvp5Msa1VeHIO8ZCuwJhnmzSz4tuROjBehEBv6l8qDlgVvH3er58f
	 Lc8hGWWAY/LfuvMb7eNVOz7EV20s6GSX5oMgnIjhqKdlLfmQK9BQbWx/lWUUcfM+rE
	 06CRGfwx2/XnQ==
Date: Tue, 04 Feb 2025 13:23:04 -0800
Subject: [PATCH 03/34] metadump: fix cleanup for v1 metadump testing
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406154.546134.10921594277629712989.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In commit ce79de11337e38, the metadump v2 tests were updated to leave
the names of loop devices in some global variables so that the cleanup
method can find them and remove the loop devices.  Inexplicably, the
metadump v1 test function was not upgraded.  Do so now.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: ce79de11337e38 ("fstests: clean up loop device instantiation")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 common/metadump |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)


diff --git a/common/metadump b/common/metadump
index 493f8b6379dc0b..a4ec9a7f921acf 100644
--- a/common/metadump
+++ b/common/metadump
@@ -61,7 +61,6 @@ _xfs_verify_metadump_v1()
 	local metadump_file="$XFS_METADUMP_FILE"
 	local version=""
 	local data_img="$XFS_METADUMP_IMG.data"
-	local data_loop
 
 	# Force v1 if we detect v2 support
 	if [[ $MAX_XFS_METADUMP_FORMAT > 1 ]]; then
@@ -75,18 +74,19 @@ _xfs_verify_metadump_v1()
 	SCRATCH_DEV=$data_img _scratch_xfs_mdrestore $metadump_file
 
 	# Create loopdev for data device so we can mount the fs
-	data_loop=$(_create_loop_device $data_img)
+	METADUMP_DATA_LOOP_DEV=$(_create_loop_device $data_img)
 
 	# Mount fs, run an extra test, fsck, and unmount
-	SCRATCH_DEV=$data_loop _scratch_mount
+	SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV _scratch_mount
 	if [ -n "$extra_test" ]; then
-		SCRATCH_DEV=$data_loop $extra_test
+		SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV $extra_test
 	fi
-	SCRATCH_DEV=$data_loop _check_xfs_scratch_fs
-	SCRATCH_DEV=$data_loop _scratch_unmount
+	SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV _check_xfs_scratch_fs
+	_unmount $METADUMP_DATA_LOOP_DEV
 
 	# Tear down what we created
-	_destroy_loop_device $data_loop
+	_destroy_loop_device $METADUMP_DATA_LOOP_DEV
+	unset METADUMP_DATA_LOOP_DEV
 	rm -f $data_img
 }
 

