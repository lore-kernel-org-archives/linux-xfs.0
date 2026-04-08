Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D693A3E94
	for <linux-xfs@vger.kernel.org>; Wed,  8 Apr 2026 23:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775689756; cv=none; b=FpxAfDuoPCcXmkVFkWfErCeKxpYW24jAUUK4CIXs0euDpcteD4H2O940kgIKYGGmDkR8Eg50bAIg63l5xIiDASD516RPGcF9ME8Tj7f9klCpN6O+6GTTZdDpxFwX23QVW7AjUHCuUacK03mN4DePDx/oz7vF1iZvSxsYxqZF/Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775689756; c=relaxed/simple;
	bh=vqYjVe4t0i/AiFArpSZ9mEXLlU4rnE2ZRBBMSnozEZ0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=s8vHVbHQwEeAxNz500RhRT5nHvaB+Hy5vDTkSSI5kKlsSUPvFZVqCjMtZ7NfgMwUH/79RWqYXhniQQ4t9qLERk/eSDYS1v4IAmAmyoTdE7gRp9bQE4OGSbBST6b9sJ/auSZNCBHt7n5HpLn9agtLU/G9FtRMkb2ctJjbBOtRV6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=sX/DybFo; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="sX/DybFo"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638Mtr7O3761615
	for <linux-xfs@vger.kernel.org>; Wed, 8 Apr 2026 19:09:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=S7NO
	oLpQC1gt8jjGEOFARMhStqFULmtQPTxyzd8Tw9E=; b=sX/DybFoA6nPq2/fiQXH
	P1m4akAquZ6v2+LHTPlMLkgavf+yG/DxaGshLuCrqSsAX1UsI7rsFWWkC8zKyt6R
	o1zyLIdzrtyjaUXfI/1+JiOR3R5ucwVnwPjynyuQRSoQwEj65c1m2riCbuU9eaVi
	EDGmL0+83ljeQ52xYm3+wL9pa6Pera34PDJQGRduG35WlqlTGSk2lJmjjpiHpzmk
	inX4NVoEK2SBuy2TVftA54Yy+kkL09FQ4K1GH0WO50Ld1C0sRhaPuvjbAYxv144V
	+0qQTlQqhrroAD0eG8b9WPI88SLci48x/PbC/hNlpBaytb43vk9WRZs4dD0UUI5K
	Gg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dda3mgtxq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2026 19:09:10 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8cfdc479f68so27241785a.1
        for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2026 16:09:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775689750; x=1776294550;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=S7NOoLpQC1gt8jjGEOFARMhStqFULmtQPTxyzd8Tw9E=;
        b=O8u4P87tLDR9Oiel8N1rMLGZxhq6cjtv5f+RYnuk/PlVOfmYe29TzArRNZOvt2RQIr
         2rBqz94+9TPggif1248dIwYJiwclpF09c8P6/cMSecNNCw1dsGC6s4ay/s01ztp/4EmB
         wvVkxuvI6bfeXmI659NKrHCWD6y/wal2s8owECw0OD3ZDkS1cKmk/SoFhHbuU0BYkp5U
         Sy8cH38pHh6XCwGJGG3URF655KT434Y1qW9q0FZy0VjST9K/s7CrNtozgxBVTKMMpiqH
         LVZ6TXssFq/mBReODHQitKKYmbgvJGDkkpAH3hk/2+ctIKpUB7v8WOn+mHClb3PLeN+7
         4R0A==
X-Forwarded-Encrypted: i=1; AJvYcCU0bfW0nQLooJY/83eFHf5/9QdUIY0pTyfNdflfMpicoGnwX00mcQhGXCJVK6Mt6PO/99VkGJ9lcsI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6ntkEqylLFE6PGzeDIxFjJGrsTC2fZmUJ5NA/4Ug4CZnpD6wP
	WxX9og64sZayjr6wHjAuHwWOO5tl4cY85w49B1HFW2t93xtNI64b6yjAwHO1/y5O1htil2WjLb/
	3i/XyhrbrV5829Pf1rAXb8mmq+ce8ipgXadhZ/7/tt/DErqEPs3lObe5tuw==
X-Gm-Gg: AeBDievlVo3YfeQruW0RQgqH5BvM2QUsxVxqVLyh96RfjLK8n+9PBOxpYIeDxsFzeVa
	nnXTlJ8oh4xSr6u8AOHw3yn4X4CBo/k+pzSBh5sXFgESkmDBXr0vvyV+gnGkP9aYNxcGJmXnTA0
	IWmVwB/l5FuMM8r8G8ACYI8r/Xzy0rRD9fjCR7FB0ZEL+Wi74gpIQyUOYSzltz5rBf/0BgUvAKY
	DEf+PvQrni3EjDhVhoZ+vT7Y7XkxoXWXwcXvDazKIOj/BixasBsd5NlkVKo5HA6L8iCbwKxYXGq
	5h30AyhBZHaV0AUM/K+2bCJTDXFuMKbB2JByCwxIxj6oSAMdsI6qARqoKfvua8bmVIZafc8ol97
	LqJUFDEXdhBxvn3shm46eROx3dJ84D4bY
X-Received: by 2002:a05:620a:2848:b0:8cf:df8b:1e5e with SMTP id af79cd13be357-8d4185c9512mr3194928285a.5.1775689749879;
        Wed, 08 Apr 2026 16:09:09 -0700 (PDT)
X-Received: by 2002:a05:620a:2848:b0:8cf:df8b:1e5e with SMTP id af79cd13be357-8d4185c9512mr3194922385a.5.1775689749261;
        Wed, 08 Apr 2026 16:09:09 -0700 (PDT)
Received: from [127.0.1.1] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8dc1514d382sm125665485a.4.2026.04.08.16.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 16:09:08 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 08 Apr 2026 19:08:51 -0400
Subject: [PATCH RFC v5 3/3] block: enable RWF_DONTCACHE for block devices
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260408-blk-dontcache-v5-3-0f080c20a96f@columbia.edu>
References: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
In-Reply-To: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775689745; l=4833;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=vqYjVe4t0i/AiFArpSZ9mEXLlU4rnE2ZRBBMSnozEZ0=;
 b=TkXe1cDpr+0h2BcgYcYMwDXJ9OzGkB0Fsjl6RdOUbuhHuLsFpdpyPcESqIE4200vy+eNNs/A+
 038SUVLSqekBHFqdXjGfViao6J1wkhHyywZ87y01bw5yaC4bwnIIKLF
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=OdWoyBTY c=1 sm=1 tr=0 ts=69d6e016 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=KmSSIXLuV57r0wwE8Y4A:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: Y1V9UmZzqnVgEYh22CPaAP27z3tQfuQ7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDIxNCBTYWx0ZWRfX2LR7Tg9oPmum
 1mQMechKvShTmSVT3AdoXZSczKbbSnB/oWq91MukQqi+IjHoCfj9WQffPph8Ml1n6sp5se/9v6Q
 eRc4+Py/uFpZdDP2RcjSTo9VvPApa2YGYRexwhjizYIPhey9dLiNamq5YtPIomHFag2dXZiFSHI
 WYDNV4lWXfVqkFwHarAgiIHH1yzC6cH8RNsRsoBVyVX2pJLSYPctlpYjySpiuPQx+kPuMyodKN9
 DLHYQoQS7VE8THbyX1qIUGea+52BCR2KQBz4dxy90m7waUI6fHQmYvdJeGhEwMqe0RMYGroB9lN
 Lg2WTkgddlZ7f7rpXBDNwMiXmyMUEdwJDgWkuQdXBb6Z6Q9njb09k1SrwRxqm6KnrQ09LBedIRq
 256EQ5MmBcQoewoL3kMP78/XnSsokZbHgO9ReqIlY0wyTeH8Ua7gtNPPIVfb5DBquVs+2SnGW0d
 WbEDmVjAmhignZDDxug==
X-Proofpoint-GUID: Y1V9UmZzqnVgEYh22CPaAP27z3tQfuQ7
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11753
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 priorityscore=1501 malwarescore=0 bulkscore=10
 impostorscore=10 lowpriorityscore=10 adultscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080214

Block device buffered reads and writes already pass through
filemap_read() and iomap_file_buffered_write() respectively, both of
which handle IOCB_DONTCACHE. Enable RWF_DONTCACHE for block device files
by setting FOP_DONTCACHE in def_blk_fops.

For CONFIG_BUFFER_HEAD=y paths, add block_write_begin_iocb() which
threads the kiocb through so that buffer_head-based I/O can use
DONTCACHE behavior. The existing block_write_begin() is preserved as a
wrapper that passes a NULL iocb. Set BIO_COMPLETE_IN_TASK in
submit_bh_wbc() when the folio has dropbehind so that buffer_head
writeback completions get deferred to task context.

CONFIG_BUFFER_HEAD=n paths are handled by the previously added iomap
BIO_COMPLETE_IN_TASK support.

This support is useful for databases that operate on raw block devices,
among other userspace applications.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/fops.c                |  5 +++--
 fs/buffer.c                 | 22 +++++++++++++++++++---
 include/linux/buffer_head.h |  3 +++
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 4d32785b31d9..d8165f6ba71c 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -505,7 +505,8 @@ static int blkdev_write_begin(const struct kiocb *iocb,
 			      unsigned len, struct folio **foliop,
 			      void **fsdata)
 {
-	return block_write_begin(mapping, pos, len, foliop, blkdev_get_block);
+	return block_write_begin_iocb(iocb, mapping, pos, len, foliop,
+				     blkdev_get_block);
 }
 
 static int blkdev_write_end(const struct kiocb *iocb,
@@ -967,7 +968,7 @@ const struct file_operations def_blk_fops = {
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,
-	.fop_flags	= FOP_BUFFER_RASYNC,
+	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
 };
 
 static __init int blkdev_init(void)
diff --git a/fs/buffer.c b/fs/buffer.c
index ed724a902657..c60c0ad6cc35 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2239,14 +2239,19 @@ EXPORT_SYMBOL(block_commit_write);
  *
  * The filesystem needs to handle block truncation upon failure.
  */
-int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
+int block_write_begin_iocb(const struct kiocb *iocb,
+		struct address_space *mapping, loff_t pos, unsigned len,
 		struct folio **foliop, get_block_t *get_block)
 {
 	pgoff_t index = pos >> PAGE_SHIFT;
+	fgf_t fgp_flags = FGP_WRITEBEGIN;
 	struct folio *folio;
 	int status;
 
-	folio = __filemap_get_folio(mapping, index, FGP_WRITEBEGIN,
+	if (iocb && iocb->ki_flags & IOCB_DONTCACHE)
+		fgp_flags |= FGP_DONTCACHE;
+
+	folio = __filemap_get_folio(mapping, index, fgp_flags,
 			mapping_gfp_mask(mapping));
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
@@ -2261,6 +2266,13 @@ int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
 	*foliop = folio;
 	return status;
 }
+
+int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
+		struct folio **foliop, get_block_t *get_block)
+{
+	return block_write_begin_iocb(NULL, mapping, pos, len, foliop,
+				      get_block);
+}
 EXPORT_SYMBOL(block_write_begin);
 
 int block_write_end(loff_t pos, unsigned len, unsigned copied,
@@ -2589,7 +2601,8 @@ int cont_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 		(*bytes)++;
 	}
 
-	return block_write_begin(mapping, pos, len, foliop, get_block);
+	return block_write_begin_iocb(iocb, mapping, pos, len, foliop,
+				     get_block);
 }
 EXPORT_SYMBOL(cont_write_begin);
 
@@ -2801,6 +2814,9 @@ static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
 
 	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
 
+	if (folio_test_dropbehind(bh->b_folio))
+		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
+
 	fscrypt_set_bio_crypt_ctx_bh(bio, bh, GFP_NOIO);
 
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index b16b88bfbc3e..ddf88ce290f2 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -260,6 +260,9 @@ int block_read_full_folio(struct folio *, get_block_t *);
 bool block_is_partially_uptodate(struct folio *, size_t from, size_t count);
 int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
 		struct folio **foliop, get_block_t *get_block);
+int block_write_begin_iocb(const struct kiocb *iocb,
+		struct address_space *mapping, loff_t pos, unsigned len,
+		struct folio **foliop, get_block_t *get_block);
 int __block_write_begin(struct folio *folio, loff_t pos, unsigned len,
 		get_block_t *get_block);
 int block_write_end(loff_t pos, unsigned len, unsigned copied, struct folio *);

-- 
2.39.5

