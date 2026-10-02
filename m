Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D813C411A03;
	Fri,  2 Oct 2026 22:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980653; cv=none; b=fKTxcLboOolJ5SSG1oum7WOOMJymvN9tebZ5E/tanoOz7NyrMQ95/s4Ai6nYu5la9rrIvXLF1WnaNPP0zbHgjo6huCVlXVJMlO3G+f/SkSvunP5wgOdk2QcRjVhGGPOql/L5FBxaDPXml3flfNQgXf1ONCEKTwoVQ4BCM/YdCzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980653; c=relaxed/simple;
	bh=NciHHsUwbDFuZeKCsrcMzZSUKpPt3AZax3aBo18/9+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPNj5u5h5LECqb+0DeVc7kHuUKBxoZf2XeTjIUKWDGTXQS969qEixwMIBgBSsfap0ZZoSB5UHmtKai+Vu9O+/UDKAaSEqidw8XQsrp2c0ggleLtXAADQjcfVloRZ3xWVy0xHvIiWy49Auk+PjQs8ELQq0UX6d5ivrfWr8dmB09M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OEaM6Ilz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OEaM6Ilz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD9B1F00893;
	Fri,  2 Oct 2026 22:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790980650;
	bh=nbiOvvmh3uAAd1oxFar1z2uB37LIOE/Lgee7w9bmdyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OEaM6Ilz8wEalxqxW4RlHAB/L8XqhWxXwEAxiLKewJye9vhz5bG+NATN/YFaN5IpG
	 yWsJAsptz9sUEUCYWCpUvgSJyEXHuXjnQ9ah/20SZrURo1SaJuFs3v2hu8wsutEO/S
	 4qFI9rmeepYpgaNmgiWkOycA6MV0gYVLvDqaXxEJUiaqeG84urAmcDKNvZADtd0Mir
	 KmX/NDZb7fb9kZWSUSB+ur62k9cJoU7WpqrWoznu+G2ckxLdbJVeOE1eQTXdy47iWi
	 /14VMESV2btPQkm434A6y+yiecauQvW6oOEVKs3ZwWmCKYgw0ILP4IcHHthrtH16Bs
	 no80OKQWBoXEQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v17 05/21] fsverity: don't allow setting DAX file attribute on fsverity files
Date: Sat,  3 Oct 2026 00:36:46 +0200
Message-ID: <20261002223705.2175542-6-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261002223705.2175542-1-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
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
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
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

