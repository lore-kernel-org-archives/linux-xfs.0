Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B3C3CC7DF;
	Wed, 24 Jun 2026 17:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782322969; cv=none; b=PIiI20ZX4AqqU4EneXjQQAwctmeUo+gK1Z/n71feRVkvhb9pncNXjfMAs69qzXMc6EdceHuvWgqPgkXYq6F+feDDpgPrtfak0m2DmTn74AhKg/7p4JUObr5EipQwBArbVZSEodyHoVqr/y4eUGGaBCbT6lCzLE1bIZHhXLY1s+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782322969; c=relaxed/simple;
	bh=2ZycE3Xs0J5KLMwS+1EP6QccRLENONtX1HayvXH1Hbk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=atLtzgTjzruJlpnqo9/VV1fSGhToPGPu3L7m7KMFU+oK20gACSbf67YFxSEGbXp3hZnCyyFNKuy/w6/ufh1HzWiuJ5/1TFJ8KDfqk8sY3SdNBBpQcSgnW9X9nAn2YNz+kcij1qR2XMSmEGHT+YBcHDfeyINZAOv3hX4s5GDoeps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JqlOnzJa; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JqlOnzJa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=4ElqMcyD4SnoVaQLQg03XYigTcdoKEg/OF55QxzEAiY=; b=JqlOnzJae0InaYPAqvmaT+XGXF
	NE3lCHDU5phMBdzAM0HLvga9mK44xqUP0uku/iiapVYmuLjOEM+VKVi+h7bwd8BB16qeT4l/lfmIg
	2SIx6fLUOWfTVym/Me6CJgOXR1ipgT/pe0/F1t9vo8he1xfBSlllk6a/u0RpRimgPl7UA194cMa64
	yzePfkpVxA92FFtp86Kn552jKOUeI4t/GsTykC34EA+ZlWt1C/fN6/dsKhH0qJBAuNVx75rbPSvfc
	dd1VSfF91HTtSS3fxrHwadeNMYE0Azmzg1MOxzcSKVwVQX1CEV7zE5P9buW9h7bJ0DMTPeblo5bex
	FJA0OTSQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcRcT-00000008SR5-2ov3;
	Wed, 24 Jun 2026 17:42:37 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev
Subject: [PATCH] iomap: Remove FGP_NOFS from iomap_get_folio()
Date: Wed, 24 Jun 2026 18:42:26 +0100
Message-ID: <20260624174228.2015893-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FGP_NOFS is legacy; filesystems should be using memalloc_nofs_save/restore
instead.  We have it here in iomap because it was buried in
grab_cache_page_write_begin() and we didn't want to change this behaviour
as part of the folio transition.

I have tested this with XFS and see no issues.  Other filesystems (cc'd)
may need to make adjustments.  Please test with lockdep enabled.

Cc: "Darrick J. Wong" <djwong@kernel.org> (iomap)
Cc: Jens Axboe <axboe@kernel.dk> (block)
Cc: Namjae Jeon <linkinjeon@kernel.org> (exfat, ntfs)
Cc: Sungjong Seo <sj1557.seo@samsung.com> (exfat)
Cc: Yuezhang Mo <yuezhang.mo@sony.com> (exfat)
Cc: Miklos Szeredi <miklos@szeredi.hu> (fuse)
Cc: Andreas Gruenbacher <agruenba@redhat.com> (gfs2)
Cc: Hyunchul Lee <hyc.lee@gmail.com> (ntfs)
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com> (ntfs3)
Cc: Carlos Maiolino <cem@kernel.org> (xfs)
Cc: Damien Le Moal <dlemoal@kernel.org> (zonefs)
Cc: Naohiro Aota <naohiro.aota@wdc.com> (zonefs)
Cc: Johannes Thumshirn <jth@kernel.org> (zonefs)
Cc: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org
Cc: fuse-devel@lists.linux.dev
Cc: gfs2@lists.linux.dev
Cc: ntfs3@lists.linux.dev
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 8d4806dc46d4..27bc2455a98d 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -768,7 +768,7 @@ EXPORT_SYMBOL_GPL(iomap_is_partially_uptodate);
  */
 struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
 {
-	fgf_t fgp = FGP_WRITEBEGIN | FGP_NOFS;
+	fgf_t fgp = FGP_WRITEBEGIN;
 
 	if (iter->flags & IOMAP_NOWAIT)
 		fgp |= FGP_NOWAIT;
-- 
2.47.3

