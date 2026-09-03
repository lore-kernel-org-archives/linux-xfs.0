Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFAF45560F
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435737; cv=none; b=ARNf5ECR+fk1J/P9fXp47HawDx2/7DxFfFoQz9DMvrdVtNPsEW/sERpru0xBieGiMSkshNCsacuf8Y034z52BcnpV39V+GO6CCdKUyB3/eRsnVFsYsp1N9bdypmTFL70lIUlKw9d0YeO6VsPBs5Q9pqKdiuV9+xP7CNXpj21Aq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435737; c=relaxed/simple;
	bh=s9lY/ZqAS5PthkZi3jgr+3PTNzJHVfFKv7iKwyjLOxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ro9OUfSS1sXqJygdkTggn7cCRhpKVjSRw/HGPvl3v/HRFnSL8bQUG6u6SXxk0xK/85/mO2dS1YlkFAoMleZe2h2bMotwaorVCbZyOW6VZNKhijPINob2uLrZYfYnmedQ6QQMm/2JSGXpNVDzX736z68TII30WuXdXs91uHXRI3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FwhUY2cC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FwhUY2cC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8CD1F00A3D;
	Thu,  3 Sep 2026 11:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435725;
	bh=40P8cljSeQzo3FsN+ah8Uc6vgF/nmXdWxy8upHW/8Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FwhUY2cCdNpo/zAricm43tCQdZf9hlfqddsFNyCjZgkzonSw5u6SCGE+hFkMvCDaB
	 ez1o7LifSpw/ZaHPzpuukDLb8yaTC2ftYVJDLOxC4I5pmGQ8PGEMti4CDodtCbuYSa
	 dY6Lbvl6NHTAtA/719jB5Zot9FTMLjPiabfsgHR2RjcaWRKlpU9H9W0FNxsKPEWGzS
	 2/nss0SJCTUDM2G2LeaKnled32ck4jrmrRvw86hIbh9wrs/ToDWh8wcMCCMlMQZxPM
	 sm3ySiTQ3eAmCghQaTPYpX9U6SbLxV9DN00E3xyrbIEyQ9Emr+CHMgR/ZU1IvWKbEV
	 aPS/g7Uz/mrnw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: [PATCH v2 23/23] xfs: check v5 superblock features early
Date: Thu,  3 Sep 2026 13:40:05 +0200
Message-ID: <20260903114022.570210-24-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903114022.570210-1-aalbersh@kernel.org>
References: <20260903114022.570210-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: eb6b2cc1fc8ad566d746d128a559989ff0bba5cc

When working on a new features that reuses the existing pad in the
superblock, I noticed that mounting such a file system on an old kernel
logs a rather confusing warning:

XFS (vdc): Metadir superblock padding fields must be zero.

This is because we only validate the various feature fields in v5
superblocks after the common superblock validation helper is called.

Fix this by calling the feature validation first.

Fixes: eca383fcd63b ("xfs: refactor superblock verifiers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_sb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 7a1d85b86e59..7097bb61d48d 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1116,10 +1116,10 @@ xfs_sb_read_verify(
 	 * because _verify_common checks the on-disk values.
 	 */
 	__xfs_sb_from_disk(&sb, dsb, false);
-	error = xfs_validate_sb_common(mp, bp, &sb);
-	if (error)
-		goto out_error;
 	error = xfs_validate_sb_read(mp, &sb);
+	if (error)
+		goto out_error;
+	error = xfs_validate_sb_common(mp, bp, &sb);
 
 out_error:
 	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
-- 
2.55.0

