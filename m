Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FE04035AD
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 15:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970883; cv=none; b=eC+hg+bc0qwv++jUaurtjndmb/LGvNG5ZDQq+V9I46rj+0LByX1vF0O71ffDcnYQPxcgH0jDgp/Pj9zgFvWIe7VqlRQ8p2YxOcqLRMXaldSMKGcPc8s87aRICCAzmkg4EJX+W4qL2Lozd9ab40fOCl0FYfStXY4dN1TL5JJ8JZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970883; c=relaxed/simple;
	bh=J18/YioIBwSOcae+DB8B/lPeLkRCKwvq0tlScPyjysU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRZTkJPBK13cSmqUzxJWSt+rM4U1LDpen3QoZVSOn1RwVBca5iyDzBX1c3HSc8lKeAtNbmLPs9sNaX2MPxiEQTX05vNPQ/rgFpjKdOlLilRAZ5esjAEYB0DXn2ZIoGFRWVbcTSRa4Ny2yFTamuVLokb3u+Wnp4QanvWHlo2fdEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IR0Etsne; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IR0Etsne"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SM6msRgaeWxuJOIJe0bUJITKy0kdCvG1kbRDsSFvbb4=; b=IR0EtsneqSljJEBBjS99Sir1vt
	A+F4ChmiJm2TU8N+8r3v4J5vWLn1VYRv8B/vbKY7x7ZgcSGZRxKZxjs2g0fkD12IQLNKqbmg+hlge
	aN2ee02nW6ix4y+m0q58rEZuCVFJe7lITEDELOrIiyII7m6UQkh1e2SeGysE5TBj7gOaRR04ir84J
	UGeUrvvLPH+HlSwG/13PX2NLj2j6YRKVBqWQcooyXtJ74Sz82hS/kzPEc1IZaBdYvcml0bseosCtd
	E38m347rrb1QXJaKpxn4JQhnqvM/2ruSHqXf3deqx67L2h0OCZKMQqmnMpbXeMFC+wx3WIvyuvbp9
	puPSYfHA==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7b0b-0000000DBEE-1axL;
	Tue, 31 Mar 2026 15:28:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 2/9] xfs: add a separate tracepoint for stealing an open zone for GC
Date: Tue, 31 Mar 2026 17:27:24 +0200
Message-ID: <20260331152751.4048218-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331152751.4048218-1-hch@lst.de>
References: <20260331152751.4048218-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The case where we have to reuse an already open zone warrants a different
trace point vs the normal opening of a GC zone.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_trace.h   | 1 +
 fs/xfs/xfs_zone_gc.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c5ad26a1d7bb..1c098cfc5c00 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -394,6 +394,7 @@ DEFINE_ZONE_EVENT(xfs_zone_full);
 DEFINE_ZONE_EVENT(xfs_zone_opened);
 DEFINE_ZONE_EVENT(xfs_zone_reset);
 DEFINE_ZONE_EVENT(xfs_zone_gc_target_opened);
+DEFINE_ZONE_EVENT(xfs_zone_gc_target_stolen);
 
 TRACE_EVENT(xfs_zone_free_blocks,
 	TP_PROTO(struct xfs_rtgroup *rtg, xfs_rgblock_t rgbno,
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 00a996c13d8a..0c1e22409ef1 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -543,7 +543,7 @@ xfs_zone_gc_steal_open(
 		return -EIO;
 	}
 
-	trace_xfs_zone_gc_target_opened(found->oz_rtg);
+	trace_xfs_zone_gc_target_stolen(found->oz_rtg);
 	found->oz_is_gc = true;
 	list_del_init(&found->oz_entry);
 	zi->zi_nr_open_zones--;
-- 
2.47.3

