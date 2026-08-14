Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC77541DDE5;
	Fri, 14 Aug 2026 09:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699559; cv=none; b=OPApkPFKrgOEzBAEgXi0PrAz/2N3w7C2Q55AIpafcs01i/hUnj5rSj9UfHyXWB+WMdnX3aLRJfGzqXutjjIROB/gap9eZKTpFBJ8XocWSCaF5i+OEqLYMwynAqrhPYwGFlck6XIz3qnpvpDYu6K9VB6AJw2RaztTylTidDC2e7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699559; c=relaxed/simple;
	bh=iZBmDz3Sv67MAW+UD9i/oqwH8WTJDT8+YCS1y4L9QB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmExEbN+0SQ62fDu1/w7cuWucWrb428MoAisejSog6A1xsPqc3fxupuliMGgrQCw60t+91SLZWLZXTwHrT+V+YZIY93NLH4I7a5Qvs36zuCGm1s1fJ/VtNfw6MI12qmvvNS90prOj7HpzUWyuPg8kiQ7nKj9mJacILaVBEIAM+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BNjxHWA5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BNjxHWA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4491F00A3A;
	Fri, 14 Aug 2026 09:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699558;
	bh=B6LynSTm43VxBrGeNfUSbV9r/RlWcb4DP+IF4QhqBeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BNjxHWA52N9hZ6iVbTtZ01/VdOyRio0Tjvz9UzDSlYmhvKstAcDxpv3Tvb0xuwI10
	 SPF2NorRGvfD7qVwvQ39a7Tv1SL7+TbRDDnD1ladFfcsPF/HEFA7zb7a54183FSybD
	 gt4XLp+4GnfShvD5ndr6EtX/19B+TRZYePtfUBK+iezPia7cwYfjhJM6sOOCyeDrIZ
	 cYzb3Ix+Sh57gdCyDf6klHe8fJMIqZNOxPyrmIqI52kjkwnkIX4/6xn6U91yc/S+Aq
	 h9VHJ0K6YETHg7nZ9FOGLZj4UmILA3ihxhFx9RNLsbyNH43DFVrRNAMfKCjMc4Ri1m
	 AC8gwnC1YvTug==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com,
	Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v15 05/25] fsverity: don't allow setting DAX file attribute on fsverity files
Date: Fri, 14 Aug 2026 11:24:22 +0200
Message-ID: <20260814092448.1818082-6-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260814092448.1818082-1-aalbersh@kernel.org>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/file_attr.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index bfb00d256dd5..391edd1d0ce3 100644
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
-- 
2.54.0

