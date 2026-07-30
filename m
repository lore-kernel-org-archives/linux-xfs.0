Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DF83C0A1D
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 06:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785394770; cv=none; b=iC8Fc65ndRFbP2ohLIzYuI1kI8wr6CZa1GktYGHZeBTBoztkxD9c9ioBFfEVI1uTQ1Kgmve7fc7fkRDMVYvhXQJGUEJj6sJcBs/hTprkBQRMuWVtzleiXwGrTFotNrHrdTEpoGmtKSC5q26iC/MKVOu5xQXFiiCWEz6bx+c+tUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785394770; c=relaxed/simple;
	bh=VqAWR9drHd5aaagFAxsb9cXKpB8GAafaVAD01CXD178=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Qd5eLAjsyp7whorm1Oltt0JJKE0rXLdh5WYRDdPAHhuZmzpYb7F/h7mziHmBzWns+GJWfT/xpt1QBrfkfo+RUZv3qk8ROByG3V5sOaUlCx3S+YBjz0+Cg8tC2B8G0gKbggapxiETMVZYhZEIxS29kYAsXHhbRBmfJ5A40YTwNe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=MpKYlVJw; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="MpKYlVJw"
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6nRIM1876227
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 02:59:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=VlLo
	mZ2ihL9HFxlrx7gRVvKB0MpDdFuMFLp7qf/zQYY=; b=MpKYlVJwcHKHdws+WTax
	xNY1KC8xJ5UwioqCDfrXm10hsZ38GifYdzzDgdp5k3EXoevWleyY1dFEYtamvhpJ
	nWsGgJa6p/YoSuJF4WIywki9iMXIn1c5Wn4DkpQGgbayfJ6qYYenwE7IR3x6i5za
	dwukXaXhPCmDnx00K9b63BM+126tHcyEXiVmjVGTroLxLwgeaoTkFFz5LrgjZQxx
	gCxc77WryoG5AoO8xqG+CIpVGqcvPcJy1Hre/qmfzNh4Lg+NyHId2TO5o74a17H5
	PMqGOiw2sWKl/vs2sNdLr6yI8HY3DLjU7PD9m6sqBVNHZv4IJI6fROiKcTd5+32Y
	+Q==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fqv948ybe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 02:59:06 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-9309af14fd7so167972785a.1
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 23:59:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785394742; x=1785999542;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VlLomZ2ihL9HFxlrx7gRVvKB0MpDdFuMFLp7qf/zQYY=;
        b=D/TvTXCIoiH/owYtrB142oDGVVSywOqEzx5lLf9TxAzpfT7pxQLC46pjWaA974nhcD
         PKbyDueriygTc15WXRZDJe9VP9M0esRcR4cx+zK3Z1MO6B5RPWXKNeXXqdHhY9Rx64o8
         nKnAKRGKZ21qYFIf/NUiiLVCJNri8+qUbHcGmJDLp3JmsbR67aR7pv67wFjfREQpBILb
         63s2UzypusFbZRbUjLUvTc+4cW5SeAyt+DCFIg2NCxb8WSQhtdvWnHDsAS/778hSlaQn
         TQu0CuPdtzKYxd9I/sdsCxTFrxuLcoyRrH0DF3dG5pWoIA8WjIQl7eFa5krbGuVGY+Ny
         Lx3Q==
X-Forwarded-Encrypted: i=1; AHgh+RprV8FQ6Giduaubwf7PfQ+1Icumz2f5HzqroVkFUDgKarDgt9Yy1kuf6Uk0nWXxK7SOXrTZ7ORE9/I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHwYJYkjVnN85pH2ttJUG+UU09Lyy7Eg+fXVg/Z5G1C5LLFsHH
	B6dpWC96Rt0Lcw7iFM0O4UNTHFyfa8iwocIlLptUY7iY6hY1dEY/Jt3X6T7J1GjpeAIRYBQda2Z
	rxX90TeeUqBBEO0hMUMKkttjJK435szowCe+j0FGBJyrGZMhnW91wcSgjWg==
X-Gm-Gg: AR+sD11mGOp5NMOrpYhzNMibipLc6zyHjOplDG6xnSamVKIuoorCAYox0P7XhFvKErt
	LMA5foipDcgrjziAOPElForpWU6M77O0/JwfolACDbKS4gj+CUQRbzoCEaMQDtGJ22fI2cZ2Mne
	TF4nxaiN5hlkR61zLz7P6tnX/zjg6e1Y72E84VictG047jFi4n3jAPsm3YOeE+AIxdfTcbdPKQV
	wBFkLj608hKmT1A5LPf6xr6oSiC5qvDTbXgPKS09icy+IArxPOf8bm/Uhzj6d3oo3e4C/QaNdZu
	5RndkNWYTA86jP2ghAP8Oe7iQ04Ur8GczWrLW4rdC9m/aiwSomRBHYavvfPtQmpZrVh3E1oIBAD
	hK0BummZsJOBIMSMhJ7X+WK9JkgDLFuzcfENHJN08aVZk3w==
X-Received: by 2002:a05:620a:4728:b0:92e:94a7:16e8 with SMTP id af79cd13be357-93485f9eb93mr142631585a.15.1785394742140;
        Wed, 29 Jul 2026 23:59:02 -0700 (PDT)
X-Received: by 2002:a05:620a:4728:b0:92e:94a7:16e8 with SMTP id af79cd13be357-93485f9eb93mr142629985a.15.1785394741655;
        Wed, 29 Jul 2026 23:59:01 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3221bc7sm349752485a.7.2026.07.29.23.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:59:00 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 30 Jul 2026 02:57:53 -0400
Subject: [PATCH v7 3/5] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-blk-dontcache-v7-3-3e8e6850068d@columbia.edu>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
In-Reply-To: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
        Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Hillf Danton <hdanton@sina.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
        Christoph Hellwig <hch@lst.de>, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785394735; l=3060;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=VqAWR9drHd5aaagFAxsb9cXKpB8GAafaVAD01CXD178=;
 b=vBSV9PuGaob7EwfUbiGv6fypiN4LKkZCFKVdXD+PIQv8LCcBMfs8U5vzkhknkhDiwC6C0Zrx+
 5R4OEUS3RiTCHa0v/202zDRtO2dKByH8pttxUhsn6U5qKVyhcv1ODCk
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX8qe4dMhH3EQG
 ZoWs8AOfpZZVD00yneKvws99xOszWGyscfTRibQtjqgTfUp0roMwbucaPX8FULNcxqAs7OiMs3V
 7LzK9KmcNnWMPy/wK2Oqph9PwzTtmm7f17Qos5uyBJv1cJ3cg2ej
X-Authority-Analysis: v=2.4 cv=d+HFDxjE c=1 sm=1 tr=0 ts=6a6af63a cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=aYi4XJYX91a15INjywwA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-GUID: bQ31PUwqTqzV6BSEptRVznhSpaASJAe4
X-Proofpoint-ORIG-GUID: bQ31PUwqTqzV6BSEptRVznhSpaASJAe4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfXwRpG7sONGCn0
 NT+FzzH2tYsCxjqWJpDnvIaYNqF+/c9BF82gnnVjqRWUYmlCrOtNtyXKPGThBz4ml8e6of2DGnj
 z5hgm2eMot+OSbRu0VJpP4v4cDNZ9uVvUkPjucBqSn+yVqjEmLv8ANZVifvEkiQMfGKN1rewKhL
 c0EYSxYVh+YVfB/3KRdD8ccGqHMAkH4rS/GKvKMSARfEd1Aq/l4r4jdlTr8pyHDg5TcsR8748I1
 NQT8DcZ3rPNqiozOpItQNsoAKvgvQLHOkxcQX/lf6lxVNENPBxHlvBJKFEl0qxRsjDgugwf9zUz
 dMHO8PHlozZ5Ps5lNrIap1vYLgIxkOug6HXpVXmsQMOxPNVrAWHeA2uwNM8Jpc7SjWeqdjzPrwN
 1ZxAWIdKlzskgC0Vt517BvfUKJfoX/2RKjXA3/Pq3nx+Bc1o9tY2tR56/iebaX5iXAkjhKgQsuy
 VM2eNSZ4uzELNSP3Gjw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11859
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 adultscore=0 phishscore=0 lowpriorityscore=10
 clxscore=1015 bulkscore=10 priorityscore=1501 malwarescore=0 impostorscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300048

Set BIO_COMPLETE_IN_TASK on iomap writeback bios when a dropbehind folio
is added. This ensures that bi_end_io runs in task context, where
folio_end_dropbehind() can safely invalidate folios.

With the bio layer now handling task-context deferral generically,
IOMAP_IOEND_DONTCACHE is no longer needed, as XFS no longer needs to
route DONTCACHE ioends through its completion workqueue. Remove the flag
and its NOMERGE entry.

Without the NOMERGE, regular I/Os that get merged with a dropbehind
folio will also have their completion deferred to task context.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/iomap/ioend.c      | 5 +++--
 fs/xfs/xfs_aops.c     | 4 ----
 include/linux/iomap.h | 5 +----
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 30468d51b5ad..1ae8a8fb8503 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -238,8 +238,6 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 
 	if (wpc->iomap.flags & IOMAP_F_SHARED)
 		ioend_flags |= IOMAP_IOEND_SHARED;
-	if (folio_test_dropbehind(folio))
-		ioend_flags |= IOMAP_IOEND_DONTCACHE;
 	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
 		ioend_flags |= IOMAP_IOEND_BOUNDARY;
 
@@ -256,6 +254,9 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 	if (!bio_add_folio(&ioend->io_bio, folio, map_len, poff))
 		goto new_ioend;
 
+	if (folio_test_dropbehind(folio))
+		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
+
 	/*
 	 * Clamp io_offset and io_size to the incore EOF so that ondisk
 	 * file size updates in the ioend completion are byte-accurate.
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 51293b6f331f..cd8de8c82d78 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -522,10 +522,6 @@ xfs_ioend_needs_wq_completion(
 	if (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED))
 		return true;
 
-	/* Page cache invalidation cannot be done in irq context. */
-	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE)
-		return true;
-
 	return false;
 }
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 56b43d594e6e..68af4935a107 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -404,16 +404,13 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
 #define IOMAP_IOEND_BOUNDARY		(1U << 2)
 /* is direct I/O */
 #define IOMAP_IOEND_DIRECT		(1U << 3)
-/* is DONTCACHE I/O */
-#define IOMAP_IOEND_DONTCACHE		(1U << 4)
 
 /*
  * Flags that if set on either ioend prevent the merge of two ioends.
  * (IOMAP_IOEND_BOUNDARY also prevents merges, but only one-way)
  */
 #define IOMAP_IOEND_NOMERGE_FLAGS \
-	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT | \
-	 IOMAP_IOEND_DONTCACHE)
+	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT)
 
 /*
  * Structure for writeback I/O completions.

-- 
2.39.5

