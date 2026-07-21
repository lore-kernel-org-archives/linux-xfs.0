Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABBB46DFE0;
	Tue, 21 Jul 2026 18:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659455; cv=none; b=DdIuj5YQhdTM6BjPdfhgkFPoOwZXVdtmBL6G1Q05YnhnmsWw2/aMBZtB33y6GDN+IoF1NtwViO+ymvxctzZSN2k3U5P6B1udX67DBuVv0QBNnL4qhMfeA4RdyJYfj693v9JdM8Sm26jkhICJ6N6r5kPIpzNVjLQ3XgiST5CEPl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659455; c=relaxed/simple;
	bh=8g5BgA9mURecCv/apzQ2hLH2SYMpF55oRQsaZ2DgY7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qz7BfWhDF5mhxyMi03AzbOn7K0S/wZaQHScHTI0j8uVWsfjSYefif5CqF3LYrVUv4kTBMLqTvVkXk6AM6ADCW+5jqALB4bs+Bx2e9s9N18xWpnK0JSAC+yquYxLWTBTqDljTbWpBtKQVnlW85vyLxnOFqY5VEurC56YxyDgrCm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WataG6vo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WataG6vo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5627A1F00A3A;
	Tue, 21 Jul 2026 18:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659452;
	bh=VICvrkHJ76P3bbcz027VoiEo6h6DpXS/23ki+zkvasE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WataG6voOGeBKkFGA2WCgtoq5VWldwW+e3KlGLrdtyzqGIypmGHbIShpKTtuaRzXk
	 oxsyviofCAduJLlvtlHY6WOx4Lgqwcj4I/1jQnZz+lletXBJrkYPL9xGSe7DTPeO3A
	 NSgLL8G6yYrTSdgEMz5b210tKyCnot4yfLUAKrxMNg2pogrLKd/Zj1g6WcjzBQAd6N
	 5aUfHcSMN6rMtyB3qwNG+HHZ7dCDZixpgXdtrNYG7g6+8tdwQSWH8XWe/XCTOzSWUR
	 u4JHj/IXvSF9VIqwBei3uoTBp77fnpW2EoFbgZ0z+PjqEh/1aS140wsOQ+25MDViyk
	 shSR2wZSocb2A==
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
Subject: [PATCH v13 06/23] fsverity: don't allow setting DAX file attribute on fsverity files
Date: Tue, 21 Jul 2026 20:40:43 +0200
Message-ID: <20260721184346.416657-7-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260721184346.416657-1-aalbersh@kernel.org>
References: <20260721184346.416657-1-aalbersh@kernel.org>
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

