Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12065207A0B
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311429; cv=none; b=uLqeAPX6SSoNFxZlUNQr4mSBybI0dYZ+NTFZ0BdBwac9DsTVBk98eAtFc/QGTqQ3G9GQhqkgWhCx8BmUoD1qzJlkgSxsx0F8YEq/Yq2Z6kieNYCWhWnJPeHpSDydc1Si5B1V9l9DmoRtgTa9lrLgt6bVbipk77gfwotNwxRuys8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311429; c=relaxed/simple;
	bh=Fz+VQ98rjmR/sd0Xn5lnsQW05MHFRD6QrGXEkE1MgWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngenarkFn4ks2Cl6Ly3vC8xLgoqf+oNXp5KJtriNsrU0RsHQRf1XR5SmaZfdfSBybFdYXc7GeTf59u25hMkRA3h82IGeTecTuw6cftAZLLw2xy0bgatOX7THz8Mbha5Pt+2iTxPEKq52a3AghEoaCJmdF/QNAOb92rv6+ixUfEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jb7EQf7h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jb7EQf7h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1wnosQPGBbkVfv+zQEOYANeG5zQUKngi+ewHdEBmmhk=; b=jb7EQf7hc6Jj7Ixe7wtuHG7Hj+
	Yjh/jNk8l/1LmQwqFuWs88hvNgXVyG8kpo+ySBHueNLPnNzNnRJbwUEywmQ2AdAiO9Z5oePMUddyq
	FDqxq3MOUqQn1gdmfdDi0hin/v+LgKC8dey4CFiI2wIRbYlcAz3menh5NPoojzOgYf6cOR3SP4HCQ
	6GpItOO6WfnLkWHApRrgsnV3NzIrBRnQEm0dJP3cTQoD8VLSE6hqCFbo9wY4pEJxQMCwJLMtJyo4t
	D0rgdPDb0Hr8ibwMqSxZQ7aZCb+W6Iw8nikT4FF/PS4H1dusXo06S+zlEJHFttofrWR8bpN3I5/zt
	HK3SqSBw==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOrzu-000000002Ya-0Sm8;
	Fri, 28 Nov 2025 06:30:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 02/25] logprint: remove xlog_print_dir2_sf
Date: Fri, 28 Nov 2025 07:29:39 +0100
Message-ID: <20251128063007.1495036-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128063007.1495036-1-hch@lst.de>
References: <20251128063007.1495036-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The code has been stubbed out since the initial creation of the
xfsprogs repository.  Open code the single-line printf in the
data fork caller (attr forks can't contain directories) and remove
the dead code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 40 +---------------------------------------
 1 file changed, 1 insertion(+), 39 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 88679e9ee1dc..bde7e2a5f1db 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -504,42 +504,6 @@ xlog_print_trans_inode_core(
     }
 }
 
-static void
-xlog_print_dir2_sf(
-	struct xlog	*log,
-	xfs_dir2_sf_hdr_t *sfp,
-	int		size)
-{
-	__be64		pino;	/* parent inode nr */
-	xfs_ino_t	ino;
-	int		count;
-	int		i;
-	char		namebuf[257];
-	xfs_dir2_sf_entry_t	*sfep;
-
-	printf(_("SHORTFORM DIRECTORY size %d\n"),
-		size);
-	/* bail out for now */
-
-	return;
-
-	printf(_("SHORTFORM DIRECTORY size %d count %d\n"),
-	       size, sfp->count);
-	memmove(&pino, &(sfp->parent), sizeof(pino));
-	printf(_(".. ino 0x%llx\n"), (unsigned long long) be64_to_cpu(pino));
-
-	count = sfp->count;
-	sfep = xfs_dir2_sf_firstentry(sfp);
-	for (i = 0; i < count; i++) {
-		ino = libxfs_dir2_sf_get_ino(log->l_mp, sfp, sfep);
-		memmove(namebuf, (sfep->name), sfep->namelen);
-		namebuf[sfep->namelen] = '\0';
-		printf(_("%s ino 0x%llx namelen %d\n"),
-		       namebuf, (unsigned long long)ino, sfep->namelen);
-		sfep = libxfs_dir2_sf_nextentry(log->l_mp, sfp, sfep);
-	}
-}
-
 static int
 xlog_print_trans_inode(
 	struct xlog		*log,
@@ -643,7 +607,7 @@ xlog_print_trans_inode(
 	    case XFS_ILOG_DDATA:
 		printf(_("LOCAL inode data\n"));
 		if (mode == S_IFDIR)
-		    xlog_print_dir2_sf(log, (xfs_dir2_sf_hdr_t *)*ptr, size);
+		    printf(_("SHORTFORM DIRECTORY size %d\n"), size);
 		break;
 	    default:
 		ASSERT((f->ilf_fields & XFS_ILOG_DFORK) == 0);
@@ -672,8 +636,6 @@ xlog_print_trans_inode(
 		break;
 	    case XFS_ILOG_ADATA:
 		printf(_("LOCAL attr data\n"));
-		if (mode == S_IFDIR)
-		    xlog_print_dir2_sf(log, (xfs_dir2_sf_hdr_t *)*ptr, size);
 		break;
 	    default:
 		ASSERT((f->ilf_fields & XFS_ILOG_AFORK) == 0);
-- 
2.47.3

