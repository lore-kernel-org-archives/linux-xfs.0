Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06743AB498;
	Fri, 10 Jul 2026 08:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673623; cv=none; b=RI4VmeKI5LjX6ctkRib20MMv9/3dwZcnqRifgwy6eMcdZN9wKskhKPO+TDG8xpcMnx8h/btIfINse4HB5xqiFdnh1Bn+XdOaxxf+V68PbNsnswtU/p5Fyw/9Oky+gJwI3rpYHSyr4i4e+CQgolA+pSla4R+si5eJw+lzrXQFbNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673623; c=relaxed/simple;
	bh=8g5BgA9mURecCv/apzQ2hLH2SYMpF55oRQsaZ2DgY7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZx0tUkHIHe0O0nMQwXCSYT4bnVHK3wTjXVElHaCL7p2siOtzTea8BMsBd0u36Serz3vss9tkiGVbHgEzd7RNlKJuKbjAPN/WnAWa24U8w+3DfS11IsGsNh7w/ou64/kurt1nH0eEG5Xoo5Ddgi2jLlnWYtZ9aCgeZ5ajmTZruw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pol/abMS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pol/abMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C01C1F00A3A;
	Fri, 10 Jul 2026 08:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783673622;
	bh=VICvrkHJ76P3bbcz027VoiEo6h6DpXS/23ki+zkvasE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pol/abMS6ySkJ4PqqvJwcwpqSGWEVT90r/FwswEBZceAtfieFJ5j/QhoLAQHHpaU5
	 ufrPV0oVuJbMIbzd1F8j5yvdZ7B9pOgRXiqbQqGH8MkuaRWeQcFKq5GkGMgoUwScGj
	 qoN8uJq1hQfVh0SxYUZqstF6NgpEpbxH2UzZKj42uj0skyfNs05gUgokl95NkSxC55
	 xOeJiscFouAnS5zcnKZtIDXb4Obe5+0fUPbNfIVgEn3/8wp8xCM1ZqtQzIyirHpSLw
	 s3g3d+YkgXr89PfQgmdqekgX5idBQHPmKTrRWyU59CBMKRuJvhnTg7eyyHdDBfxpUF
	 c5ECCMOB2oTMQ==
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
Subject: [PATCH v11 06/20] fsverity: don't allow setting DAX file attribute on fsverity files
Date: Fri, 10 Jul 2026 10:52:34 +0200
Message-ID: <20260710085256.3464201-7-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710085256.3464201-1-aalbersh@kernel.org>
References: <20260710085256.3464201-1-aalbersh@kernel.org>
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

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/file_attr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index bfb00d256dd5..5424ec4e3949 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -246,6 +246,11 @@ static int fileattr_set_prepare(struct inode *inode,
 	if (fa->fsx_cowextsize == 0)
 		fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
 
+	/* Can not enable DAX on fsverity file */
+	if ((old_ma->fsx_xflags & FS_XFLAG_VERITY) &&
+			fa->fsx_xflags & FS_XFLAG_DAX)
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.54.0

