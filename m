Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7DC1F5608;
	Thu, 16 Jan 2025 23:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070583; cv=none; b=QQ4rTt5BVfFcjnpj1q9YJHvTdNH9PCYkpRdwOdwnVlU3Q903cbzVaE0qhW0pMzHs43Hv9UeMdNsk9jVMFYIP3cpauni2v5y0yhXmay9tb7vnlAjNvx0RzKWokHvPZW9ob3TVIrEBQUjxyseP3zWVD3CAh+WpnIA+76KoNQu7Rzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070583; c=relaxed/simple;
	bh=Iw4t699RvEK0soPcLHfWcXPINGsWZ3+yX52nmWR2sb4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UklgDgQ7//KCE1EEP9bq8TWm0Wu+dJYjDQUdo70g0ClcHXstEhmsOgprMnTs/VgYF5H/wVKIpmH3LiyWjOEkcK39m/fyAaNK4yUdpf7Uoitd8UEX+0z36mhp6SJl0dvosgNzIZdGIFxjUY78xpdGx/1LOdkBLYXJ2uuMXVA9vVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HEGuruDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HEGuruDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661A0C4CED6;
	Thu, 16 Jan 2025 23:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070583;
	bh=Iw4t699RvEK0soPcLHfWcXPINGsWZ3+yX52nmWR2sb4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HEGuruDLvZ8wjCdls6mFhpOCW25uIFd/0wSN4vgSIRl96wFXosN5Tn58wXnFfZiQV
	 Uf7vsdYkCNwgUm/yscJzyInNM0iS/0fSLhl2va2yeQ1e0yonMU89XzqqyqNBrw1IZa
	 oBibSiNdrGQmztKeUuPzrp+RqMtLT2eWFulX4m7IBQlNFX/UgTYwJ4fUmJDNSU0qk/
	 nnmRHI3pHIcakLcZfV4kgIk0xaeRl3AQ5xI/nv9vChSqJpgCkoRWFca2lC9EzY5JYU
	 D5CIiMlQRQlEXbihpsALWtU5LPYN1xzM/nu1Df2LdV/y/vkDvtBXsEK19t0YByMb9d
	 3nJ3Cxpg10ZBg==
Date: Thu, 16 Jan 2025 15:36:22 -0800
Subject: [PATCH 05/14] common/populate: use metadump v2 format by default for
 fs metadata snapshots
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706976139.1928798.13803844705915710708.stgit@frogsfrogsfrogs>
In-Reply-To: <173706976044.1928798.958381010294853384.stgit@frogsfrogsfrogs>
References: <173706976044.1928798.958381010294853384.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're snapshotting filesystem metadata after creating a populated
filesystem, force the creation of metadump v2 files by default to
exercise the new format, since xfs_metadump continues to use the v1
format unless told otherwise.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/populate |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)


diff --git a/common/populate b/common/populate
index 65fbd19b30e4e1..96fc13875df503 100644
--- a/common/populate
+++ b/common/populate
@@ -55,7 +55,12 @@ __populate_fail() {
 	case "$FSTYP" in
 	xfs)
 		_scratch_unmount
-		_scratch_xfs_metadump "$metadump" -a -o
+
+		mdargs=('-a' '-o')
+		test "$(_xfs_metadump_max_version)" -gt 1 && \
+			mdargs+=('-v' '2')
+
+		_scratch_xfs_metadump "$metadump" "${mdargs[@]}"
 		;;
 	ext4)
 		_scratch_unmount
@@ -1043,8 +1048,12 @@ _scratch_populate_save_metadump()
 		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 			logdev=$SCRATCH_LOGDEV
 
+		mdargs=('-a' '-o')
+		test "$(_xfs_metadump_max_version)" -gt 1 && \
+			mdargs+=('-v' '2')
+
 		_xfs_metadump "$metadump_file" "$SCRATCH_DEV" "$logdev" \
-				compress -a -o
+				compress "${mdargs[@]}"
 		res=$?
 		;;
 	"ext2"|"ext3"|"ext4")

