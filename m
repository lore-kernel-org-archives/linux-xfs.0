Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B565046C82A
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 23:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790207835; cv=none; b=hELjdR8HzQ2aIVMfzN1LYL7FkI74VsPBJ0OwaB2FJcbP6xRhmthAS1i58wwC8LBkNR0XFlqI3Hn0gIdjFDDSIa6L38OFFjPK2jwbyROAyiYOqoDH4rxjyIk5LsYJK6d8a9w6YbZIUNHbuEvEmDQBhXAaG0GJQB6e5+JuM8y+F5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790207835; c=relaxed/simple;
	bh=X3wzWg0roOO1ptF7ZnClA9IB/TZQgfMHMl8KC4TDQ/E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g3YX028qFaUrdzUAwNtwt5T17/tyGztpLrdzVrY+EvilBv8LRSvVcWV28ZsMlXF5sIjFY2aGqd2t1oMQugIYEgzrFSB7swcven5CxFaxDzNofTuH5+ndzVgCdwqOuXU0jz/ONCn8eQcJkSAAg78RSrr1bcvAMTZDF6OdMDO1by4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Z2MCRHl/; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=c6cIKits; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Z2MCRHl/";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="c6cIKits"
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68NNCUJm1939585
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 19:57:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=n4kk
	5mXgXhks+NNWJaLVIMvxQ7me08UQy0+SMcJDZMs=; b=Z2MCRHl/vKPc2LHq6tNc
	XiYQw6yOkzNTqDAp9gtSovJ+djDIR3yIu281WzCBIw4w/sMK3Muaqvq1LRmKhXQi
	DtjBf6/AEDdzb+NfGS07pop80K3LJxY6DsdPJ+tqhOh0DDvx5BSjUCpUKV3z/VFr
	95l8DwW75vkML3Uth12IMdTz3+vDwOY8DYG4qqR3LyQHyzOf06mVk3Jjs4eI8MSk
	aIHlLOV1H7BmPnz2YPW5KJiqDiBc/26ruL+xDJXiAoTlByG6IdSSlCF/SrcfSAgm
	pdc6gzxfeNofkDGwmbuHljjPtrXokS+tZtR9Qjdlvb1lE6sWRgTz7JsE6QJUqFc8
	nQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gvqtcrbrs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 19:57:07 -0400 (EDT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38f97b3f853so1824916a91.3
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 16:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1790207827; x=1790812627; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n4kk5mXgXhks+NNWJaLVIMvxQ7me08UQy0+SMcJDZMs=;
        b=c6cIKits6iwQFGkTJ60ZxJN6j3pf3uceVMo/ZtV6fdV2Ad0LUdS16FL5ywz/IS/0Kl
         +jSzhMrLzLI4RqbXFTS+dQ2zpqoRHRXsPocgDSy7zxU0R1EfbmPUDuZMyLTheZbaMGv2
         KZezOqg0/Brwlu0TPCwygk/W4utF5WzuwDdDqvm+y//4bzA2mNqMJJczw68iUtHgmTim
         2V4IO7vreo+OzAIKc49bvnQ9xD8AiOtSuQiPgy498DTmEZHITB+j+OTdRsGGmHcZhXVi
         +YHcA2VOZ2vmbGr8HDnHYJjm+tLdWl6zmXzeLJJkeQzgUYvF9c7S55NvRDsxjfL1ZhA/
         BKoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790207827; x=1790812627;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n4kk5mXgXhks+NNWJaLVIMvxQ7me08UQy0+SMcJDZMs=;
        b=C7u0XiZDJMJZHFmkFuyb6FEbFpGAdd7Cf3wzyVw2xjf4HnGRUs7is2CwPXk5aI/eLZ
         x8OaBNK9FbYYsO63ErjzuOg4XuedtuaRAVA/p+QW5F69NP8FPjyqo/8fmoDLuZfIwJcr
         otpYnX13B6NmRvAmyGXGlFa34bK9sEdhKFh86dVmER/YArMdYg4HmaRZOkcmYwV9RvCa
         JZkg0LWUrirqSFVF4OVAmciFvKaEKBGiDKbduWctclvUh8lPPWW3wIp4WhqF8jbQ7vJy
         bhw57SGMWb/ROnnWZlDV97gNAcr+QwuVLYs7308uStKOFKrG5D04Ga+UvdDsbotWrSrz
         6UQw==
X-Forwarded-Encrypted: i=1; AKwUvBxTc6SvEJeUZmSxoFDbu+eZ+kNxIYfiECjEVGXb8l9wiAOIm58po/W9me0n57Scq9aOvzyAIvf2gXg=@vger.kernel.org
X-Gm-Message-State: AFuF++mYIMfODj/I8LsxsmeKSdky/gnicS4TeSYoDBm6MLf416wvBsVH
	R8h+qhwBFSjiaE3A82+67f2l/xibQKUxLr+nekHj/ZPPZRjkdxpamHq6ibtFpz2OVBf8s7F7Ocd
	IXhZMbMVKpGta/JoUDLbwuRvgAF+qfQgMqEdT9dTJHyCe6orYh7ZRbGX/Ze/8Dcwnkg==
X-Gm-Gg: AYBFou1hmPK+vRnfzNMniwO6u5HAsERoMmPXmE1NeQEv5Housbrrv1k3o2/GqxMCFbh
	xrpl7EXOCCMyf3sbEWbbdJpJrjQ7htbMKqH3f03sHRZt55tkmphrhCNB47GjLBlJyQAAU3ESjhT
	FojVnaFMOM9CTVNpDJbtUaMDkKTa6ItZ16VPtN8grouoH7xKGJTpmHk1z20HhtgdI4/H9uB8fof
	KFduJCTzsWKgwjWobi9QjlnOon/Vt8v43iYG9vwtq1BECMNcB4lVXCfK263dyBZONLAeZF7gSCd
	rvJrhVj7RAN+PnTyOo6Eg15LNYLbhC/Q4s6bt4t3kIXbj1BY7oIVnHzgh9vFYa12GDQN0I1Xmtt
	QTCQHcQYal2glv8LnuyhHViUYPa4dTmJ6sChqFCNotSTJ0g==
X-Received: by 2002:a17:90b:48c1:b0:3a0:4023:bb09 with SMTP id 98e67ed59e1d1-3a09896f0fcmr599641a91.56.1790207827099;
        Wed, 23 Sep 2026 16:57:07 -0700 (PDT)
X-Received: by 2002:a17:90b:48c1:b0:3a0:4023:bb09 with SMTP id 98e67ed59e1d1-3a09896f0fcmr599623a91.56.1790207826584;
        Wed, 23 Sep 2026 16:57:06 -0700 (PDT)
Received: from [127.0.1.1] (RED-LION-HO.car2.Seattle1.Level3.net. [4.53.155.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0976ca5f9sm1331613a91.14.2026.09.23.16.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 16:57:06 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 23 Sep 2026 19:56:41 -0400
Subject: [PATCH v5 8/9] block: unpin all pages of a bvec in
 bio_iov_iter_align_down()
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-blkdev-fixes-v5-8-89e60d66eb38@columbia.edu>
References: <20260923-blkdev-fixes-v5-0-89e60d66eb38@columbia.edu>
In-Reply-To: <20260923-blkdev-fixes-v5-0-89e60d66eb38@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Hannes Reinecke <hare@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        John Garry <john.garry@linux.dev>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, Keith Busch <kbusch@kernel.org>,
        "Martin K. Petersen" <mkp@kernel.org>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790207813; l=3797;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=X3wzWg0roOO1ptF7ZnClA9IB/TZQgfMHMl8KC4TDQ/E=;
 b=g4+/LTObucWvEWYZXfmJp4B6cmRKAbNTyAz0wKbmoGjCkzwVFz7bDsWDkVVnaWn5uqvP88rn4
 zjtaC1yXvB/Dk3xu1zozB9M+ot0fQCoFlZVvmBYL6IjksSdLpbLuexF
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDEwMCBTYWx0ZWRfX8DFaEnDmxkon
 v6UmLcikVeVppB+dK6yARLIqaePfqp0nIQKD42wrSxz2vqsGquKVMjgPn5vCrGMTV8/1T0DlBQ1
 MsW+ZWv/KF5GRotVouio2mDfAzo18ST1GwGQLBayKTuEsiQPLexnoF/wwxaQ2yPpBC7vAsVXA8q
 yxyNC+gh7aeMeYhVH27o8mv+BWwbsP66obnvKdcjuj8f2kbpoVHYl/9LevLtghr1KhNWNnEzAdd
 bZCHg/RpqI4v12SGj0Emc08Ik5K5/o9o/UqPA0MGh7ovL+JZL9BQ728oAIWsh9RmfeovlygDTvA
 nq+R49htxGgve/UkWMqb/9MtiDxzMY4EI9c0WKOEndAQmQ/y4G+xxty9hqzu8tmHp5gGwTVAzWr
 dRZoIci9g5fFDYTNaMSdGjoBcDbAyFk1COrUFPtRz8aJLxvLjX7QL/KODtdKrcCW3Qq/ZA9SgaJ
 y7hw/NgywZlXPhXqzEA==
X-Proofpoint-GUID: WJkUHnbOXWuBF-dZtqMJLT6YtqYuDOqj
X-Proofpoint-ORIG-GUID: WJkUHnbOXWuBF-dZtqMJLT6YtqYuDOqj
X-Authority-Analysis: v=2.4 cv=LtYHWXdc c=1 sm=1 tr=0 ts=6ab46753 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=6aZ3Ysb2zzbY2sELL/OBJw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=VwQbUJbxAAAA:8 a=JF9118EUAAAA:8 a=FzqJyQ6YvfuMctRh2gUA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22 a=xVlTc564ipvMDusKsbsT:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDEwMCBTYWx0ZWRfX5v7Op8pFfxix
 CE7ZtbrA+r8+kR/Gnnt1Rmu4CYyXDsH3HzE9dQ4oOF8P2fZMI1K1Vj13UMxev0KbFWD7QMQuxlw
 6ihMDXL+Z28Wk8cT7MIQ7FUC/KrkRotd1PR4qQWt1IuULnjQiWOf
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11914
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 lowpriorityscore=10 clxscore=1015 malwarescore=0 bulkscore=10 adultscore=0
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609230100

bio_iov_iter_align_down() drops trailing bvecs with unpin_user_page(),
but a bvec built by iov_iter_extract_bvecs() can span several pages of
one folio, each with its own pin. All but the first pin leak.

The partially trimmed bvec has the same problem. Shrinking bv_len does
not release the pins for the pages cut off by the trim, and
__bio_release_pages() only unpins the pages bv_len still covers at
completion.

Both issues occur only with a logical block size above PAGE_SIZE and a
large folio backing the user buffer. On a device with a 64K logical
block size, an O_DIRECT pwritev() from a hugetlb mapping that ends 16K
past a block boundary leaks one huge page per call, whether the
remainder is its own bvec or the tail of a larger one.

Unpin all pages of a dropped bvec with bvec_unpin(), and unpin the
pages trimmed off the last bvec as well. Move bvec_unpin() up and split
its page count into a helper so both sites share it.

Fixes: 20a0e6276edb ("block: align the bio after building it")
Assisted-by: Claude:claude-fable-5
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/bio.c | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index dff84c0b54bd..50b9f303c351 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1197,6 +1197,21 @@ bool bio_iov_iter_set(struct bio *bio, const struct iov_iter *iter)
 	return true;
 }
 
+static unsigned int bvec_nr_pages(const struct bio_vec *bv)
+{
+	return (bv->bv_offset + bv->bv_len - 1) / PAGE_SIZE -
+		bv->bv_offset / PAGE_SIZE + 1;
+}
+
+static void bvec_unpin(struct bio_vec *bv, bool mark_dirty)
+{
+	struct folio *folio = bvec_folio(bv);
+
+	if (mark_dirty)
+		folio_mark_dirty_lock(folio);
+	unpin_user_folio(folio, bvec_nr_pages(bv));
+}
+
 /*
  * Aligns the bio size to the len_align_mask, releasing excessive bio vecs that
  * __bio_iov_iter_get_pages may have inserted, and reverts the trimmed length
@@ -1206,6 +1221,7 @@ static int bio_iov_iter_align_down(struct bio *bio, struct iov_iter *iter,
 				   struct bio_vec *bv, unsigned len_align_mask)
 {
 	size_t nbytes = bio->bi_iter.bi_size & len_align_mask;
+	unsigned int npages;
 
 	if (!nbytes)
 		return 0;
@@ -1214,14 +1230,24 @@ static int bio_iov_iter_align_down(struct bio *bio, struct iov_iter *iter,
 	bio->bi_iter.bi_size -= nbytes;
 	while (nbytes >= bv->bv_len) {
 		if (bio_flagged(bio, BIO_PAGE_PINNED))
-			unpin_user_page(bv->bv_page);
+			bvec_unpin(bv, false);
 
 		if (!--bio->bi_vcnt)
 			return -EFAULT;
 		nbytes -= bv->bv_len;
 		bv--;
 	}
+
+	/*
+	 * __bio_release_pages() only unpins the pages still covered by
+	 * the trimmed bv_len. Count the pages spanned before and after
+	 * the trim and unpin the difference.
+	 */
+	npages = bvec_nr_pages(bv);
 	bv->bv_len -= nbytes;
+	npages -= bvec_nr_pages(bv);
+	if (npages && bio_flagged(bio, BIO_PAGE_PINNED))
+		unpin_user_folio(bvec_folio(bv), npages);
 	return 0;
 }
 
@@ -1503,17 +1529,6 @@ int bio_iov_iter_bounce(struct bio *bio, struct iov_iter *iter, size_t maxlen,
 	return bio_iov_iter_bounce_read(bio, iter, maxlen, minsize);
 }
 
-static void bvec_unpin(struct bio_vec *bv, bool mark_dirty)
-{
-	struct folio *folio = bvec_folio(bv);
-	size_t nr_pages = (bv->bv_offset + bv->bv_len - 1) / PAGE_SIZE -
-			bv->bv_offset / PAGE_SIZE + 1;
-
-	if (mark_dirty)
-		folio_mark_dirty_lock(folio);
-	unpin_user_folio(folio, nr_pages);
-}
-
 static void bio_iov_iter_unbounce_read(struct bio *bio, bool is_error,
 		bool mark_dirty)
 {

-- 
2.39.5

