Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1462914
	for <linux-xfs@vger.kernel.org>; Wed, 23 Oct 2024 13:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729690683; cv=none; b=MnXYgpQjnSo0UcIAetj5uiaR0j/t/9bpDFey4wS6bv80wjB87Uwd/aIVEb104Me6hzyDFPHzLQFehFP469udIhlBojVg/vdY89J4r9D4Z5bzBUptMXtACouykU59uSIRHGE0PdsDr2ydqxcwAaNCMMUfPNR5khFDIAnhCXyvki4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729690683; c=relaxed/simple;
	bh=FU8F+XEww1F9LMGaK9nnb2ZdnN4V5D3lIch14enJvhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+AvbjM0h7EbQymLuuNpnelb7VbdMM+3f83581Ltz7ZwKWN0pmV6TchcAWNlNgHcD7UIuf4ZL7FqZTrEBsV7P/U/NNpSu5msg2B5NGihZBJ/4378jQLsaco4mNzxSPCzNCYxJ6ClMtI+oDI2+s8agpURDOqS5lg/o7OldsaY8ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nxpirRuQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nxpirRuQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7rVeCOZnY6uXUIGfClkZFlmtdkD4SlX+rqbCKt+kFYE=; b=nxpirRuQqokN2i+lbNO5Su0LQK
	oJcL6N5AQOdKJ/DkPN8h5OdC79FrcGJEXaEyeRxfyggf0LYMJGSxuLl4pYxdsIOsdY2pn4MTKiTvl
	2eD22I34lerAR0VN7XSQqbxJyG4DZI0K01AesXnSiBrvc241QGDWlX5kheRLWnEJfglS42BHnit/o
	cxR7e3iJ8Ft3/vuiAFeRc8Vm8eHVMBiMvq503g12RayPeyw1gVF8FWoDmcAjbYeNhZEoadH4CTQgw
	UFEMlTJNMUYGWYIm3yta5CthdCuWiKW52D5q98OreC11otFtuRERMkE5eIweU7PaoFGDIcUP1ZesU
	/NpaVF6A==;
Received: from 2a02-8389-2341-5b80-8c6c-e123-fc47-94a5.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8c6c:e123:fc47:94a5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t3bYm-0000000EZWB-2hn4;
	Wed, 23 Oct 2024 13:38:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
Subject: [PATCH 1/2] xfs: fix finding a last resort AG in xfs_filestream_pick_ag
Date: Wed, 23 Oct 2024 15:37:22 +0200
Message-ID: <20241023133755.524345-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241023133755.524345-1-hch@lst.de>
References: <20241023133755.524345-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When the main loop in xfs_filestream_pick_ag fails to find a suitable
AG it tries to just pick the online AG.  But the loop for that uses
args->pag as loop iterator while the later code expects pag to be
set.  Fix this by reusing the max_pag case for this last resort, and
also add a check for impossible case of no AG just to make sure that
the uninitialized pag doesn't even escape in theory.

Reported-by: syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
---
 fs/xfs/xfs_filestream.c | 23 ++++++++++++-----------
 fs/xfs/xfs_trace.h      | 15 +++++----------
 2 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index e3aaa0555597..88bd23ce74cd 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -64,7 +64,7 @@ xfs_filestream_pick_ag(
 	struct xfs_perag	*pag;
 	struct xfs_perag	*max_pag = NULL;
 	xfs_extlen_t		minlen = *longest;
-	xfs_extlen_t		free = 0, minfree, maxfree = 0;
+	xfs_extlen_t		minfree, maxfree = 0;
 	xfs_agnumber_t		agno;
 	bool			first_pass = true;
 	int			err;
@@ -107,7 +107,6 @@ xfs_filestream_pick_ag(
 			     !(flags & XFS_PICK_USERDATA) ||
 			     (flags & XFS_PICK_LOWSPACE))) {
 				/* Break out, retaining the reference on the AG. */
-				free = pag->pagf_freeblks;
 				break;
 			}
 		}
@@ -150,23 +149,25 @@ xfs_filestream_pick_ag(
 		 * grab.
 		 */
 		if (!max_pag) {
-			for_each_perag_wrap(args->mp, 0, start_agno, args->pag)
+			for_each_perag_wrap(args->mp, 0, start_agno, pag) {
+				max_pag = pag;
 				break;
-			atomic_inc(&args->pag->pagf_fstrms);
-			*longest = 0;
-		} else {
-			pag = max_pag;
-			free = maxfree;
-			atomic_inc(&pag->pagf_fstrms);
+			}
+
+			/* Bail if there are no AGs at all to select from. */
+			if (!max_pag)
+				return -ENOSPC;
 		}
+
+		pag = max_pag;
+		atomic_inc(&pag->pagf_fstrms);
 	} else if (max_pag) {
 		xfs_perag_rele(max_pag);
 	}
 
-	trace_xfs_filestream_pick(pag, pino, free);
+	trace_xfs_filestream_pick(pag, pino);
 	args->pag = pag;
 	return 0;
-
 }
 
 static struct xfs_inode *
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ee9f0b1f548d..fcb2bad4f76e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -691,8 +691,8 @@ DEFINE_FILESTREAM_EVENT(xfs_filestream_lookup);
 DEFINE_FILESTREAM_EVENT(xfs_filestream_scan);
 
 TRACE_EVENT(xfs_filestream_pick,
-	TP_PROTO(struct xfs_perag *pag, xfs_ino_t ino, xfs_extlen_t free),
-	TP_ARGS(pag, ino, free),
+	TP_PROTO(struct xfs_perag *pag, xfs_ino_t ino),
+	TP_ARGS(pag, ino),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
@@ -703,14 +703,9 @@ TRACE_EVENT(xfs_filestream_pick,
 	TP_fast_assign(
 		__entry->dev = pag->pag_mount->m_super->s_dev;
 		__entry->ino = ino;
-		if (pag) {
-			__entry->agno = pag->pag_agno;
-			__entry->streams = atomic_read(&pag->pagf_fstrms);
-		} else {
-			__entry->agno = NULLAGNUMBER;
-			__entry->streams = 0;
-		}
-		__entry->free = free;
+		__entry->agno = pag->pag_agno;
+		__entry->streams = atomic_read(&pag->pagf_fstrms);
+		__entry->free = pag->pagf_freeblks;
 	),
 	TP_printk("dev %d:%d ino 0x%llx agno 0x%x streams %d free %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-- 
2.45.2

