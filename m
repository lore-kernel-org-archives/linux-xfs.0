Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.203
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793861968;
	b=5ptQizH7ZpCPYAe1S/JIKVDdNkXXLiIgYP39JHdWW7MCPwf6siqVvtqGAF8NnBeWfvhs
	 1xWoWFHlhR9wLBcsPDw0JStx9h4W4MYSVGNsXXwSqBQlzE3SHywYyoDtdX/lGydWwUfhC
	 m0ty1lejMSADVlwpjiToTn1ZlqhTue45SSI/gwYpwKLxjS7eYtsqFihgGrVdM1f/96S1G
	 BwUlnsHJly8NekO+oIGCZtXF2WnkMohOVfV7rpxHJ4qAJjYQpNXXdw/8gxb9PHvRW/8pg
	 aQS0yTajXPMeIg+no+sOoLN3Goh+OZu/ZwIk+49uY02DF34+ALa59Bjv/cl2MnV40SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793861968;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nIzPxp67nycIcgpn1aR+9cX2c2A9Fk/9SrE7eGQSDVI=;
	b=JnK1PIAln+AW1SLWBCFfyKSTmOiPnp5CytxSwhuz96xTlDApA9gbJmIVOXt0dYhQGBra
	 oBtzgOTAi0N/tEdqUYDFaUXYOErhZOJeh10CwxRlbMjMmeMCLvJdPBmD/Mm3H6/VprPfE
	 7LbfsRAvNsH/CMCBDJzba+L9n7J2Fv279Odcfp2ffoNgh7VTNbAfuhINrl5cHD5hmpSQ6
	 xmPCBguQLJGQc4frewvgcddFX6SirNVnFPsiq4hRCN6/HskK68VmKP1fK15bIQ4mEvKPx
	 DBUhFjCJDsRlb5GOGNgx56Sr4wr9XzMp5G4OQIy+RMqJaq0aHyxlzyPT2eVOg4+XW0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=URJ69ifo;
	arc=none smtp.remote-ip=95.215.58.203
Received: from mta1.migadu.com (out-203.mta1.migadu.com [95.215.58.203])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0D1606D801
	for <linux-xfs@vger.kernel.org>; Thu,  5 Nov 2026 06:59:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D0D1606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=URJ69ifo
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xVc3emtqQK3gdjiaDH2/ozjRn5r+zA/0E88efrFuawg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793861965; v=1; x=1794466765;
 b=URJ69ifo97ROruZ6pmwjXf0aKmSur7mh2uvlDandRG7mz4fCmrISF3oG8QPrDgE6EtbpnoLX
 DDOkrLFAjlHrjyterio5ErE9cY4DTjD2rrmzaqCHaS/HCXbs+pcE5kLsyhLVR0lxf7DWy2zDiJH
 ybQo4+FLjg9nVwpWWXkCsyjQ=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7015cdc676c618de;
	Thu, 05 Nov 2026 06:59:25 +0000
X-Mizu-Trace-ID: 7015cdc676c618de
X-Migadu-Flow: FLOW_OUT
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
To: Jens Axboe <axboe@kernel.dk>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	asml.silence@gmail.com,
	hch@lst.de,
	Anuj Gupta <anuj1072538@gmail.com>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Li Wang <liwang@kylinos.cn>
Subject: [RFC 1/6] block: refuse a dma-buf bio that carries a crypto context
Date: Thu,  5 Nov 2026 14:58:42 +0800
Message-ID: <20261105065847.196540-2-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
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

From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>

A dma-buf bio has no pages for the crypto layer to walk: the
software fallback would read the map as bio_vecs.  Refuse it in
blk_mq_submit_bio() before it can reach that path.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 block/blk-mq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index be5671966787..f0d978b1724f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3138,8 +3138,10 @@ void blk_mq_submit_bio(struct bio *bio)
 		goto queue_exit;
 	}
 
+	/* a dma-buf bio has no pages for integrity work or contents crypto */
 	if (unlikely(op_is_dmabuf(bio->bi_opf) &&
-		bdev_has_integrity_csum(bio->bi_bdev))) {
+	    (bdev_has_integrity_csum(bio->bi_bdev) ||
+	     bio_has_crypt_ctx(bio)))) {
 		bio_endio_status(bio, BLK_STS_NOTSUPP);
 		goto queue_exit;
 	}
-- 
2.43.0

