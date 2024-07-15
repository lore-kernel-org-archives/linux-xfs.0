Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C2D17BB4
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jul 2024 17:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721063365; cv=none; b=h1PR6/LTtKTNIlCdb2yh/r7Pwi4HlGReWG+uw14e7v0G0j0zwuUvmEVR86PTjedZ5QUzsYAekiUYskJFJDaS3hJ55OOvwU6Bm1gWYRxFvuLUcdALbkHHN+zae4AblVdlz+C2kqrT9JCCIkILxa5T4N6ugUHKXNEUGdQkXWeqt1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721063365; c=relaxed/simple;
	bh=vwPsWIiurtodLLXIq17rRYh589Z+9bZssCvshzmOBIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LLGUhFSfyTPUGWWsDkmHbIzH8hGMxMTE4m0XAGVJqNw3RakVfEgqkMlKWmgLwOfJBbANbYgPqPo37nRU7Wd9mJ2K1RukkAI85UwsZf1nI7SAMHzRUCpW+WoF7RjkZMiHQKJiRXTfcImnf499RJCychUrAUA27n67fxiNAI6gA70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XP13zSRM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XP13zSRM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=K6JPa+xGJzJEPLqeaSKfAoyoxbgY4u2TPWHs1UMQcW8=; b=XP13zSRMdqWm2Aew8B21zjjlix
	HjKQZcbIB9+ZzVKxypwdB5dB8g32wNJDIO1oi+dqNychkvbYlTN3qP8Of1exVk81qENndTZ68QFB9
	rCyHPVCE45n8M9dPTDnrNRMiCK2yZQoALYH1UxigwbPEIzK5Bj45AVl1Uul2CitheCMBZ/sqNACLF
	1lPLP2quv1U7nyhyUcozdBezYEDfNiHhVMKWR2UGnH8jROVYQRGofPX8h+k9blqYDqreQFgLTARPF
	V/0E8mOR5y/dx+gU3CtCfhiengVdVa2up5pJJVQs+bDcV2LI8TVuDUk71Ph04lnoKuvzyNDgn5Cfe
	m/yaUgsw==;
Received: from 2a02-8389-2341-5b80-db80-1e1e-8ccd-126e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db80:1e1e:8ccd:126e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sTPCR-00000007osp-1DZF;
	Mon, 15 Jul 2024 17:09:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: cmaiolino@redhat.com
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] repair: btree blocks are never on the RT subvolume
Date: Mon, 15 Jul 2024 19:09:15 +0200
Message-ID: <20240715170915.776487-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

scan_bmapbt tries to track btree blocks in the RT duplicate extent
AVL tree if the inode has the realtime flag set.  Given that the
RT subvolume is only ever used for file data this is incorrect.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/scan.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/repair/scan.c b/repair/scan.c
index 338308ef8..8352b3ccf 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -390,22 +390,11 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
 			break;
 		}
 		pthread_mutex_unlock(&ag_locks[agno].lock);
-	} else  {
-		/*
-		 * attribute fork for realtime files is in the regular
-		 * filesystem
-		 */
-		if (type != XR_INO_RTDATA || whichfork != XFS_DATA_FORK)  {
-			if (search_dup_extent(XFS_FSB_TO_AGNO(mp, bno),
-					XFS_FSB_TO_AGBNO(mp, bno),
-					XFS_FSB_TO_AGBNO(mp, bno) + 1))
-				return(1);
-		} else  {
-			xfs_rtxnum_t	ext = xfs_rtb_to_rtx(mp, bno);
-
-			if (search_rt_dup_extent(mp, ext))
-				return 1;
-		}
+	} else {
+		if (search_dup_extent(XFS_FSB_TO_AGNO(mp, bno),
+				XFS_FSB_TO_AGBNO(mp, bno),
+				XFS_FSB_TO_AGBNO(mp, bno) + 1))
+			return 1;
 	}
 	(*tot)++;
 	numrecs = be16_to_cpu(block->bb_numrecs);
-- 
2.43.0

