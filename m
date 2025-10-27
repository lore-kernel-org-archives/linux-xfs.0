Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D81328EB
	for <linux-xfs@vger.kernel.org>; Mon, 27 Oct 2025 07:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761548519; cv=none; b=DCDDuvjWRU3JGJT1XKjZlUbGoVLz6fYRCv/TGIMn5qN2v9H304sofZRmNlDPLtylFQmndNDpa93arsKTthGMtFzwjGPPQezAQpmsG/QImL16C4lu+XTqokmWi6wXae35t/Bin8xuTYNEBoKu8pW2dz58IcsXpbHXWQmKD3rOkFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761548519; c=relaxed/simple;
	bh=QAw7tkYuoFSJoMKWAEcFFOsFD2SOzOAHnbMr5PvFS4I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GrpXZpU9/GKivNeIEUzq62rU1U6IFqZKUi40MdTWdVAtw5i+lHoI4me1eRYpDsghnRCu1oMRw0/IXKZVhFgjKQkbHAHUUGVP2L6hxdLj2W4ppjI6vKJv1I8n6uGHk6SRH8r+4gTDgLKtS4yeMrzQJ6mrZ2fGxISQOxX3aSUwhtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bw55kA7s; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bw55kA7s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=fvJTY9dDctadndK3TC7//tld1ZjbMXXyWoRipYRLuAM=; b=bw55kA7suF/2OZxttBtkzKFhr0
	r0PRRf/Vopr0IMIvDsqA0Dm7Bq7Ncg0YYvOGZ24Q79EwVoK+5pOmZjIpP4ffkrwD7cStCkikxRBla
	VnLhK7NzPeGPBYdHpCddzZBxREOOIM1jidxZ2gC/0m8Dl1baLP0iXnhLO9kCkwg75HDq7k9a6qp8v
	AJZ7zKmbFLj8Uc4rcplVew00A/tjSEjB7WFzP0TQReNXxTfq0RtBU7oi+tNswRrzAaStE/1coFJac
	9lJdZpL6FOTrqQR5lGFKllH/6bzaJl0k+7f1l04fnRN30CGZ0AheCwUV2Aw+Cctiocemp+QAQvt9d
	eKKIM7yA==;
Received: from [62.218.44.66] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDHEr-0000000DF6x-0ZeC;
	Mon, 27 Oct 2025 07:01:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: cmaiolino@redhat.com
Cc: linux-xfs@vger.kernel.org,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH, resend] xfs: remove the unused bv field in struct xfs_gc_bio
Date: Mon, 27 Oct 2025 08:01:50 +0100
Message-ID: <20251027070154.727014-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 fs/xfs/xfs_zone_gc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index efcb52796d05..09830696b5f9 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -117,7 +117,6 @@ struct xfs_gc_bio {
 	struct xfs_rtgroup		*victim_rtg;
 
 	/* Bio used for reads and writes, including the bvec used by it */
-	struct bio_vec			bv;
 	struct bio			bio;	/* must be last */
 };
 
-- 
2.47.3

