Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7133F45D91B
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 16:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791564633; cv=none; b=bbYapQ+ux9a/pR1I5RD9HnQ5/2QGSS6q3w798QzXkVKtJZ3UEh6ljNlP5R3RKQjdsEEbpMf6zZwFAa8X5LXRI0UGPzp+YLC5fnMEx5tqqRd1z1tdOGlga4qbbt+k8cDzQHRhGLNNvPz1quLHLPOipWa65t74/F4z5n2KQCPXtJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791564633; c=relaxed/simple;
	bh=WPC3WLajC6lyDzmxrfBYM/ewFtKVfxYj5hP42xVnwJw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FPsmp3La2tSpZOzmgYgXY7SrjtHfYHknH6V6G0JijqF8iDt+8eyjSdtC1LIAeJzs8w31U7Fv6z1tBCOp5fuBypfnnQvdOXNpakiQCc/Bsr+PJw3BvyrOJfVqArDWfgDO9CNsPHcfBUSib6pipo+id4TtFM9YZIavAXYcioQnRuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=c+F+JGTK; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=kx4moZ/7; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="c+F+JGTK";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="kx4moZ/7"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 699GYR0H984689
	for <linux-xfs@vger.kernel.org>; Fri, 9 Oct 2026 12:50:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=ECWs
	PXcQGz2l7luRAoCKVt0T8/C+Hf8TLwM1hRXbrhI=; b=c+F+JGTK2fOvNmDnncgZ
	HLidt4lpRen90+nXgeqFfbC4aewU6vhCWagUHB6nDBsB1TWv2CsjhGyPSwrlLbjI
	m0JB+Bzs+zLQ9FJZ78ReVYObV7jS7vq5MFU/IKENG+TZ0xVhCs58DC9QjnqtDVE5
	ATCUnsSQHQ7RdcdUSZwbwKreP9t/jt1weSJ505E1yNOaG1i431EmSOhFtw6o0NOK
	08/nza9ofNA8fjf9kEKQ7jI9hB/kSL720ppsLMtsIr1Zs7YbQ3oF856M9XuBzwpV
	2Ee6y1Io5L+DkdAd8ksPXUfZSpCE3Zre4st93xz+Nb/HBUXTMMIkiRMspti3MnBY
	UQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4h6p2nn4ag-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2026 12:50:30 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5339253dc3fso145681681cf.0
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2026 09:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791564630; x=1792169430; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ECWsPXcQGz2l7luRAoCKVt0T8/C+Hf8TLwM1hRXbrhI=;
        b=kx4moZ/7hkGBRWdKMTmeP3exW1MGCl20z9wBcIzJdRywKCWvtYNKIptn3B1w8oDVuX
         i0WEDQLkGV9yxV+a+CcxZVXp1NsrtiVaVVEwT4CpzXTg87O/91yYz0Kpt5WgWTbxC6nY
         oqLSC4umP0gaerzcogc6Yy1/ntY0nAQ3mgOboIn/NBljfc04OJBNFIzjDxYUcC2NKkpI
         O9HcM8Gw96B6DSqrgR7K3oGwei6bCmq7DRecCTYwnlhwQpktav9ergHQRQTBn3+Knku4
         Z4ajAZbQe91FzQKba9OsLQgc17hD6GIaPPPLHTYL7sP/3DErZ5jqOslvax883gu0Oceg
         FMIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791564630; x=1792169430;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ECWsPXcQGz2l7luRAoCKVt0T8/C+Hf8TLwM1hRXbrhI=;
        b=B+2reeDJ9JYeFRqQ2FZVQ61qExEGbc+e6YAR+kSKgE60OykjsMv/oRJRPaAfX0/uPS
         YP/WW+DfyKHnDyX45jQYufExUG7Nz2t856aurkPrzauAsWsvkL4jxaMH8cqmsRU5WqUJ
         TiBADg7oWobrkteh9AVC86+uh6Zj6S1L5dcjDXxVyuVuYgWjWHJd4NWeA6tvyqOGqk6H
         uhCx3Hc7W/eGHI9FfZd4rZUv1Uzwj/SuX+sCFG9jhNsNbRLuG6WpMhhVq+fTpJVVukNU
         GfCccQrCD8cA7vmlM2JwPabV6NjJDrNozgKaNywZqUswa2uDOpwpuaPWHpKeQ415FN9R
         Mzzg==
X-Forwarded-Encrypted: i=1; AKwUvBz+czcHWnJzSQa5kl+hINaEqok8dDcc0oV0+a5NoxKiq+QCi1I3JNxqVjQmTmgn/u212WQsv7mmons=@vger.kernel.org
X-Gm-Message-State: AFuF++ne0sEFliZRteiukkAAApYRaaZ1rlyQvjT0G5OE/Gx2Px8fHBNr
	p0qGxPmExMOfaj29gUz4EeZlsE1Uz0uFwnfrHx+Uf2YUDkDGgBAUVRcJR0Yp92fJxFZ93GAaiK4
	yGrV2a+Jsmt0/5+K8lyHCzH1pWAkCFT6VNxAAU9fYJakHjsNp60m4vXw3Bg==
X-Gm-Gg: AYBFou0dEkdjNqF6xGkcDnV8TGK1lkrj+p5nSQZguuu+t+VDnkTyAFtEHgaFXbVuZCO
	e9KLfaMxGWgc3kjRjIqjxm8s8bQ4Gm/wKqb2GJTGHqfEmHF/pAnmHlliGzL1uOyD2LhBcC386IH
	TYwkPyTDrjEtMW4G4LqPogUWg+lZmoGt4aLmkjHxX0bVs/uwg2rJx2N0Ekc9X2jjPz+y1RwSc1S
	qvuqXvijg8y+sK86DaYNDjOhJ/oC7x+jsoe9n+JxGBgXJglu517/MWlCTvINLAn/cpuTaNPGGSU
	1HT1FeIEH6WyH6FzfxnA+imctpUSK8YawGu4vXh+HzaLLF+aAJ1P0aGnn12UNzpE/XKV5mu2+1z
	bPk0UlWK+7GWyPKe8Zqmm0DWnBFBVXANvscoRq7Iuprvhlx8=
X-Received: by 2002:a05:622a:5809:b0:535:70c5:d39 with SMTP id d75a77b69052e-5359fdf44aemr39879481cf.62.1791564629618;
        Fri, 09 Oct 2026 09:50:29 -0700 (PDT)
X-Received: by 2002:a05:622a:5809:b0:535:70c5:d39 with SMTP id d75a77b69052e-5359fdf44aemr39878711cf.62.1791564628897;
        Fri, 09 Oct 2026 09:50:28 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-194.net.columbia.edu. [128.59.178.194])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5359b77d0eesm22234701cf.19.2026.10.09.09.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 09:50:28 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Fri, 09 Oct 2026 12:50:16 -0400
Subject: [PATCH v6 8/9] block: unpin all pages of a bvec in
 bio_iov_iter_align_down()
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-blkdev-fixes-v6-8-307939c387df@columbia.edu>
References: <20261009-blkdev-fixes-v6-0-307939c387df@columbia.edu>
In-Reply-To: <20261009-blkdev-fixes-v6-0-307939c387df@columbia.edu>
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
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791564615; l=3797;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=WPC3WLajC6lyDzmxrfBYM/ewFtKVfxYj5hP42xVnwJw=;
 b=6jzqSXDrOoy+QHGbmCvy3U9AmK4IjKh8EMJmiFe1GMXfqvx7b/oTlV6UMY01kXAnfx2ix/bFK
 nNTvwSL9gs5ACYB4IQhX8Xim/kfJt86cZetgoN3wCb3FiTOvnc0pxaL
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=eaGo7LEH c=1 sm=1 tr=0 ts=6ac91b56 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=u0MKzLA9JmpizDwXU9Rxjg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=VwQbUJbxAAAA:8 a=JF9118EUAAAA:8 a=FzqJyQ6YvfuMctRh2gUA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=xVlTc564ipvMDusKsbsT:22
X-Proofpoint-ORIG-GUID: 5v9Z-qzem1sfTvQPrEyxnysDcXGf9vS9
X-Proofpoint-GUID: 5v9Z-qzem1sfTvQPrEyxnysDcXGf9vS9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA2NyBTYWx0ZWRfX6XaBUsakheAl
 Tnwfse7G3B2NGhr8/Pg0X9DVmkbp8N2P6OJD7KBxK2HM330O0bFAjjUPRRs7uaB/rAghi6czQuB
 nwykGQfpp/4Z1h8PJmrX8QTOX2lqOx0wvD7RoqKWzlpSnlO2nsZ8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA2NyBTYWx0ZWRfX7Hw/IA6aty8E
 6H1mAXIC0EfmxbucpOCOzF3vZ0l7+8F9nlx4H1kuN8h2QchBC/n9jy7O2e9m0rmIOkHVVt302zz
 dR3GR1yWXI+/XoR2cHh/7sE/bqlA1LOGCBPu4fPCRJBd0TYGFlls1rfiBMG4OUb5ljOBdSyrOhL
 bdhra1451UdQXUhMDcR78vtz/Ipz9ZxZTSA/aVAPEkljoXmJPFemhq4iHjruW876gTd+AgvpE6f
 UPa8zPRrgwsATnVES/DequMBE4oKOxZVYg0UWwKm+QsidtLf+5OBnjO+4nZofsHdeqontA9jQWV
 Sspdsuo1hoG9oKGd7VvZY+WTFRBz0lvNxjTMh+SdV/olX3h2nAZV90fwsvFeUaG4+NG1Mobuq8n
 +0EQKtV44WXOTKepwvEh6LCOg7M+I7+FCEFDfza8Fci2XO9iofEWZJTHbfSH5oeKvCU6bMMXG8E
 zBew5OeD5LEQTqTNdhw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11930
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 priorityscore=1501 impostorscore=10
 lowpriorityscore=10 malwarescore=0 phishscore=0 bulkscore=10 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610020000
 definitions=main-2610090067

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
index c89a0d5d6e61..a1e9ffd5982d 100644
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
 
@@ -1510,17 +1536,6 @@ int bio_iov_iter_bounce(struct bio *bio, struct iov_iter *iter, size_t maxlen,
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

