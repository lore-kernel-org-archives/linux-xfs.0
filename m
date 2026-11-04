Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782799;
	b=PnTa3BxK4rWDAVE4Hs2RpnzNLgG1/LEEqNjBNMOgLOCuz4ycZtZLWt5IoBX1R4aOhQuA
	 6PziPKXlqQtVtvxFD2NMvlxoddQ1DuG2ZOjdHwwEDj08I0HpLWy6q+3tWA+QLPSLCKdzw
	 ++Td3gXy+NodMA7QjFJAPvHT6uzO/RQqxguUcNt4PQCa3EjRvDOCFv7Wjltyxq/ZTRI9d
	 wMn6dJN2jbBeVXL4fXGQSc6oLI6ttZ2gQMtQ1mb/pS1AuGEzWwDqSn2Th4U+AFFHb94HQ
	 8wRojiirnIBLN9A4h1d3DFiR3YLZziaz9Th/YXt5stmSwVs2jE5PQDXn40tIf4W7XfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782799;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=QySnXHiNefpBewjCW+bGg7EBlUqTx4zUQyl7WPT2fQ4=;
	b=MQH7u6d8mV0aL1/yKPI3Yudg3vZ8C7Cg5eT+8zAsN1D42IqWD0uw13Iu4PpMZX6eI3kt
	 E21jvZMbtZgaoXda5orxuGBCVCs+B8/1nUsc7eexpaFXGcif5993tTeBI+c7Ywvq+IGnW
	 HE9ufq39bHrORswFUf9+OjyAGE3qsNrNHukDcKciRjmu9LlqZSMG+l6BGnzvB48VBxwwe
	 QXzTcd90U7h9qO29Ob3gYvcvQJvnCK/8UvnVYzY4PHL+Em+DRsHssh9XLrQrthskrs5CO
	 ZsDo3xlyN8fWughLFEjkAHZFaeVa8R9H3JI6Sn4pcFlK+VoV2CUW1z6YRRcqu/b4r6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=QVaktO3G;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD0F606A32E;
	Wed,  4 Nov 2026 08:59:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BD0F606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=QVaktO3G
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QySnXHiNefpBewjCW+bGg7EBlUqTx4zUQyl7WPT2fQ4=; b=QVaktO3GQaXPHakLW0l/6x2S4r
	fnr2nzZ2qOKCuyrKVG3GnJTCF1kYtAJVXRYdoq9YbYr7KGzyt7HdErbelEwcxf7DaMAYx0e17Dwdv
	ebrI1W+29shmPZb591X10b6lOm5CmsffWAFNioil4WPGzUFZIqbQFCMx/nGMnhw7oWCceJhUdgBZS
	mn0NnePy+FuP+878KSwXOHtK30IOEzJ2VzuPACQi1yXWOK7YhhcvlNRW9truvHy3fNyNdTQKDQRC0
	p0jZNxo5iD3WeayC8WEjBsFFhOqpumzPTOzkUQu/e8ShQN7CPhHg3q+HHcsPNL30aixViPK/mbyFM
	oCzt7sgw==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWqc-00000004oO9-2HBf;
	Wed, 04 Nov 2026 08:59:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 09/25] xfs: put the open zone outside RCU protection in xfs_get_cached_zone
Date: Wed,  4 Nov 2026 09:57:13 +0100
Message-ID: <20261104085929.317544-10-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104085929.317544-1-hch@lst.de>
References: <20261104085929.317544-1-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

With the RT data checksum support, xfs_open_zone_put will need a
sleepable context, so move it out of the RCU critical section.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 8909c8d0f5fc..509420c63e49 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -842,9 +842,9 @@ xfs_get_cached_zone(
 		if (oz && oz->oz_allocated == rtg_blocks(oz->oz_rtg)) {
 			VFS_I(ip)->i_private = NULL;
 			spin_unlock(&ip->i_flags_lock);
+			rcu_read_unlock();
 			xfs_open_zone_put(oz);
-			oz = NULL;
-			goto out_unlock;
+			return NULL;
 		}
 		spin_unlock(&ip->i_flags_lock);
 	}
-- 
2.53.0

