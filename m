Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9653C3CF952
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 21:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778795530; cv=none; b=V0tBMOwo02T9qiGiW24E4r0+xeCQ2/Bp1AIHBlV8sNXq/IGVj/YrTjZJ7YAc6qhUnJRWrgw2zv0pczBciJkvbLCQJ0guNOA5gWjULpsf8SNAxr4oAr+UnwLi6rDu+Da2a8tJpmPkwE6eZHQMQJk7nDMg0OCK9HA9P6rRwT0siHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778795530; c=relaxed/simple;
	bh=5MBJYs1Ny9I8ogr/547ALSAn0Pj03wWQCXtJIb2TJHQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ca2p7eMjkfbU9OkBGHbjOxV9yxvTNqujRh3aMba2GLKd6MRpaQ6N50R3vfswT2diW0JtNIUoWHkEo6xdM4u7MVJk4LdDO/2e84qovj0zOsoxRprSo0XivECRl0iYw2+8r7qpGXS5jr/OTpvKM1EnOKdjho0hTjwvLZb04XzAznA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=tBt53dWq; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="tBt53dWq"
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64ELgj6V610163
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 17:51:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=6kqw
	7BAzD2WWgy7QOAIi6FHWqeO1F7nxlJS1uusq/eg=; b=tBt53dWqDG+4YQvP+yzf
	t08Mdq9u5NAo2gghpSycmflWYst40GFzx5jWQAqvDBXC9c9xly/C3sWSTmVurFWZ
	Vx/VsGGDRmszucNqshm3wKuYSxkPI+S09nfFpFyGxDQmoIdk/ehJcqfaZJa16SKo
	qE7wWfYnudBRXoQ9SXVciqfcnZjxUp8kZW38QhxYqCeyjT3N4YnvgsE/hLQH/PIw
	ADyyyR0CCO781xiYtzXjFkE4qBAWM428/9tks/eHETxMC+c5tnfxoYkysukZ2Cv6
	1ba4WBu8dUZxR5oCYIn6aXy2gCnn0nSX1M45JKGJBApZHLKWxL0oZNlP4l12z1Em
	UA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e5m219m3a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 17:51:52 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-90d6fe98316so684127585a.3
        for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 14:51:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778795512; x=1779400312;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6kqw7BAzD2WWgy7QOAIi6FHWqeO1F7nxlJS1uusq/eg=;
        b=Kdu2xlSbapv811ecnOv4G0P3eIE/OiACsPwWDpa2Uc2HMTTuJ1FAyT3GfLoJPE3bu6
         SFI1Cv64Rx+expg8s9UJCxXlbjYWW5CQY6KiOZ6ZpjemP8lx7Rx5zxaGlZaZ+3MraebE
         OpgL4Wm8f5hfn5AMneBqs80EUNTzBWn2vo09Gdt08+Sfh6KWqrqVtsqfA269jPjfsxAp
         SLCz6y+/uKu9JSx7onkZtNgcIpj7HtvL8aFj38ihTtZ54JXHytmuHyoCELw1YRgpX7N4
         eSfFWB+AOS8btmvgPNG+cKo2+2t5L/EQhCoEglRTtGm63IBiaPz7qnoh+6cJnodofPkw
         pWuQ==
X-Forwarded-Encrypted: i=1; AFNElJ92Y8eJq+FIS91epasY5D2lpk+yikmDJxw6QnyXyJwgkmHUlS6g1stsu41taKAuKdcUS8KQYsiWd2o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqxUpfFYKn2p9raY1HN9/t5KC23XGAgVGuw6iS2ZNhohxDAyGP
	sKSzsZ6MHtuytCi2WnDS36pOo+Df5bmt5e0/iTogUzrmQ9yZeOGpixobyGYB+y5fOstmjn8SCe4
	h5TYvEIi/OYe1cuRM/XiNp/QRSNTYlFbB0s0m1rkBFZ0RHWuz6aNcsRyrew==
X-Gm-Gg: Acq92OEh8+BIK9d/8X8ZBLnB836FWb3Cqd/nqz7mOfGUpBXh2jcS2XuO1pvE4HdvYZt
	ocev5K6VF7K4aODW749VTLloEcf9edgttfymXCTiobiRSmPUj3F/8p6YaO+6+xsdsDUR5Cjhj9M
	qvVy3dejf6LpBarN1qB/xEV0vZnJC8tekiFiTII0VWzqmfJREfay+Xu26YcZt0giC5CviOQT1MC
	IRuVUA/tBidBG6wNiaV8Ias5oPgyhspOZ9FRtsBZjh/Rl3j7axclH1jrs6iJPINNhvjWIu+BKaW
	pARfY3rRza3hj+e31fKkJIq6qZ5BMHaCaxFrf59oC/z1lqqlXDUW2R9Oe7Y+sZMNiWVng3QWJcW
	4/vIolzERtXaEc5mFPBQuVD1dxAoplsAP
X-Received: by 2002:a05:620a:170c:b0:910:5637:4bec with SMTP id af79cd13be357-911cd1752admr254278085a.18.1778795512200;
        Thu, 14 May 2026 14:51:52 -0700 (PDT)
X-Received: by 2002:a05:620a:170c:b0:910:5637:4bec with SMTP id af79cd13be357-911cd1752admr254272685a.18.1778795511761;
        Thu, 14 May 2026 14:51:51 -0700 (PDT)
Received: from [127.0.1.1] ([129.236.229.175])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba18132fsm354966085a.6.2026.05.14.14.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 14:51:51 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 14 May 2026 17:51:16 -0400
Subject: [PATCH v6 3/4] buffer: add dropbehind writeback support
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260514-blk-dontcache-v6-3-782e2fa7477b@columbia.edu>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
In-Reply-To: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778795507; l=3250;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=5MBJYs1Ny9I8ogr/547ALSAn0Pj03wWQCXtJIb2TJHQ=;
 b=9bQ2fojDINOqvoN+XUOT5/4ajyDiEcYRuoe/toJiMW2IYEErMQPP4nWP0kyaFXtYEdFs8QavD
 IoIc3c+yGL9AJoDL8xs3GhMcj/KZ4S3T3QanBUhqIizKxZ8785C3SWR
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: IBTmnyWG5a3JI48bXhFtAqfWtcGgKdnu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDIxNiBTYWx0ZWRfX7/UqUi/R8Mlo
 H0TSE4vHMEaKAPodywD0y3ngvtHnd9iRoxL1hMmwEYa4gVTE0997WSIUjCprG1sxPUF5LH6qrYE
 P8xppX8cyenphu8oAF0Tq6Xi9nrRfQDPUaRIoKGSyZtPxvtvC3O6AMG6Ub8+6fjC5McUiycXKH+
 r9WljGyN3nfOodhGrYREvy6JEeSNxaCf57iQ3N3FRrJxIsOhOyJwQam+voqKS28vnbgjYDuVGvx
 i89nrQ4d9ntARzms/m52GTjGasvCzQETRLlszhjIIxt3rhR3svU62AkX5QBQop950ON7vPd+LSY
 z2i3db4+PU4TssNcq82udh0mRs2c8JOe5wRfLGlhX0DfgPi2G3Q19JTCFTW9HGDMvFefX/SKzDb
 V7nHsiR+UIxPLmfAQfjfBpUxV9OlX9bn/XGlfdiE71IUPBRUB8/FJE1EoDQklXHO0nwSUrgKu71
 3nUunhe4kM1leJdhFvg==
X-Authority-Analysis: v=2.4 cv=VLjtWdPX c=1 sm=1 tr=0 ts=6a0643f8 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=nkegbr1AwBRna+m8FBH0UQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=H0jnwmGZIJSlLSF8bakA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: IBTmnyWG5a3JI48bXhFtAqfWtcGgKdnu
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11786
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=10 lowpriorityscore=10 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0 clxscore=1015
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605140216

Add block_write_begin_iocb() which threads the kiocb through to
__filemap_get_folio() so that buffer_head-based I/O can use DONTCACHE
behavior. When the iocb has IOCB_DONTCACHE set, FGP_DONTCACHE is
passed to mark the folio for dropbehind. The existing
block_write_begin() is preserved as a wrapper that passes a NULL iocb.

Set BIO_COMPLETE_IN_TASK in submit_bh_wbc() when the folio has
dropbehind set, so that buffer_head writeback completions get deferred
to task context.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/buffer.c                 | 19 +++++++++++++++++--
 include/linux/buffer_head.h |  3 +++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b0b3792b1496..d0abaf44d782 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2138,14 +2138,19 @@ EXPORT_SYMBOL(block_commit_write);
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
@@ -2160,6 +2165,13 @@ int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
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
@@ -2715,6 +2727,9 @@ static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
 
 	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
 
+	if (folio_test_dropbehind(bh->b_folio))
+		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
+
 	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))
 		buffer_set_crypto_ctx(bio, bh, GFP_NOIO);
 
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index e4939e33b4b5..4ce50882d621 100644
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

