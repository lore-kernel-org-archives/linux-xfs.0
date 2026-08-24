Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A084A27AC31
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 11:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787572029; cv=none; b=UCl7/8OmHini+7EtphJzICjeAyEVrzgj/QbhrTCWNhGY1iAMmqa7p7Z/cSaXe66M5Nksg9yuTZDUGnYIBsQrWzXgGVY3xHGvpxjapXsGTd+dd+zmlYN8WTTYT2aE8E8pZM41PjLN4mW5rVkB7sqrTYO4wO+eJIrILs0ubrsgYlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787572029; c=relaxed/simple;
	bh=s9lY/ZqAS5PthkZi3jgr+3PTNzJHVfFKv7iKwyjLOxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5StThDPn4C+4135wkoLqbzi3Jah4YREybeFOalQGppP5MwXPnucQ3o4WzUfWWzXhOsMCKD56sA6jkQitCLZFe0rTitKTatAOHgZBvppaGo7HMXs2aedpjd4eqGdohiys6RhrpQeN77v9aivlkPf2jS2+X0F+KBswbGb+E3PdFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TkOnHSua; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TkOnHSua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBAB1F000E9;
	Mon, 24 Aug 2026 11:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787572028;
	bh=40P8cljSeQzo3FsN+ah8Uc6vgF/nmXdWxy8upHW/8Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TkOnHSuai1kIF3Cn5ilWbnxfhtdLfWa0lf9VE64Ny7gYmJh02qZOct4kCjznNNxd5
	 mXBDDZxQdbrm08umGPMus0R2/k2eOBdNlfrmiUX9YX+1bFFMnDhuBZlzS7noWKfPGo
	 pkNcN8aefozjw8o3pEUeJw3u3TFaHrgmZcS+tsgkyIUYRCiBMc2X87QYdgysYcB1Qq
	 3A4QxykX7Zwq0xiSEwPhsZWDEaMjCC2JrGSn7I7Or+j+DZv2DTZMLvRM8gds4urABX
	 RYnI5lk8NzBeqYSMun7Yw7/XXWF/qX77hZ1b7/AMYBRuQlJG4H47E6Dio8v3QjL6/q
	 oYNQsRda8DvFA==
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
Subject: [PATCH 21/21] xfs: check v5 superblock features early
Date: Mon, 24 Aug 2026 12:40:19 +0200
Message-ID: <20260824104022.420566-22-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824104022.420566-1-aalbersh@kernel.org>
References: <20260824104022.420566-1-aalbersh@kernel.org>
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

