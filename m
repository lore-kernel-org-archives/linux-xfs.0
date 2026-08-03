Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FD843B6DE;
	Mon,  3 Aug 2026 20:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785787765; cv=none; b=hs+z/pT8OvKLmfknduoh5TWuF0hijOWrKgWW7ys/Ck3RusMEN7zxSD7RZkQDOLAaFfaEO/350q0tP+tFgbDKqazcczmOAbVsKB+RN3RH8FKq3tNjcZEvpwVVPS1x6Q6JjaqHQThTWLIeX2myhnRZdDWCVHJzkF3QwXLQLJriwxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785787765; c=relaxed/simple;
	bh=lGl7zZG/tCZ/d0EvjVC0HAenH6JBve47kUujeVEXcbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUVS9eZUaywakIg8MGp9WP7tjb8pUQUKhP3upzz0ol73UsgKktLwks9u44+f0O+NgRYSh9t1CZOpQWVIaUGD2GSBp5taSwi8ab2fdKmTx+IYXgGtA3mOfM7DzgC4J1523NiA/JbNFlAh3soOXvyVblu+ba26ccVGupfL0+/IOUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xv3GemY7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xv3GemY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E541F000E9;
	Mon,  3 Aug 2026 20:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785787763;
	bh=rZWX811rIfYR67QwB8vikVgdnuYWzMncjRnGbNdXxUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xv3GemY77kDWAyLYxMaiSPV9m1hveehoyl3i3Pa1ocRZHXhZRJfMXy7EsEdEH0+mV
	 IS4dl/QpROJ3JldTVRKPS0JS0ZIYeQ6K3ODY3IWn8R5wxt6v7M32BSYjQnNRfZz+1P
	 ivkjvC3F8h+aljDnxDI8dSwFib21pWU/HZsXqHnLqird2by4+LbX0t3/8R1OjQBtsB
	 t8xEDIT9k6idva/WTCbjmdFgKx0hpRrC65uYVS+wvUyDyzoZd1wYDYCl2DNSo30rGb
	 TALha/hctIeA2B021v7HH5kbWjdfHoqBi3vkxZOBtAJuhkEx8/EZUqa8nBimuc3qcv
	 J+1GfWBOY+TBg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v14 06/21] fsverity: don't allow setting DAX file attribute on fsverity files
Date: Mon,  3 Aug 2026 22:07:56 +0200
Message-ID: <20260803200820.393203-7-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260803200820.393203-1-aalbersh@kernel.org>
References: <20260803200820.393203-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When fsverity is enabled on the file, with FS_IOC_ENABLE_VERITY ioctl(),
it checks if file has DAX enabled and fails if that's true. However, the
opposite case is not checked.

Note, that the only other filesystem supporting DAX and fsverity is
ext4, and ext4 does check for this case.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/file_attr.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index bfb00d256dd5..473ebbe9af31 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -235,10 +235,15 @@ static int fileattr_set_prepare(struct inode *inode,
 	/*
 	 * It is only valid to set the DAX flag on regular files and
 	 * directories on filesystems.
+	 *
+	 * DAX and fsverity are incompatible.
 	 */
-	if ((fa->fsx_xflags & FS_XFLAG_DAX) &&
-	    !(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
-		return -EINVAL;
+	if (fa->fsx_xflags & FS_XFLAG_DAX) {
+		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
+			return -EINVAL;
+		if (old_ma->fsx_xflags & FS_XFLAG_VERITY)
+			return -EINVAL;
+	}
 
 	/* Extent size hints of zero turn off the flags. */
 	if (fa->fsx_extsize == 0)
@@ -246,6 +251,7 @@ static int fileattr_set_prepare(struct inode *inode,
 	if (fa->fsx_cowextsize == 0)
 		fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
 
+
 	return 0;
 }
 
-- 
2.54.0

