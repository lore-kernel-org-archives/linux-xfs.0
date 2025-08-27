Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1179B35CEAE
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 14:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756304003; cv=none; b=E8zSPed1fyrm1bShDWptT83tmwQKS6Y1tUdzFWLYExuxexdjxKLfQggYSyze3YTdZAXxvUiqVbL/Qb6MiYqZ+IpaCcBHHyE8S+9Rfbx8bzfPiqRAVLXNSRFfr7g9aZA8f2YRdT5sypKXqIWWG7pHB8qtlC943b8OWldAI8IPTxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756304003; c=relaxed/simple;
	bh=atJOODdClqHiyWABtn7H99XGCZCvMKi85VrukrFv7JM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PGx6R5NYe1PHMi2YcDSIFLYgn+8r2oRvjV8L/hDOSAMv4MXcSNXrvnMWBcyUWAPs7pW2ffL9W98taNLeaSgeuQqU9YXF+8EgWurIi7Bk0wlNdsd1QWem/lG/7SAU/yctkiXqqx7dwi8vMHG2Qd/cq+jz+etJ6BuMK+EEGcu0B/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=s/yuSPnT; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="s/yuSPnT"
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 57R5wf9T057974
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 07:13:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=2i4RKxVSmTVz22+jjLC/Bkwn43paFJfceol2ANqhmp0=; b=s/yuSPnTmTQY
	pI2eHsMCwjwuP//kGstYYD/57RtV7Zo29w1vD53tM8ob39g49BYDB9oinvyOhS/H
	H/S6Wn1azBlfKQUfeNafyvTzQFyXE0Mcu/iBnnA1CGropzltw7x7o858JCPJETjK
	wzkSjGYaFv7DMtIFtmd+FaR+CB0c23OvP7CP0EWOsr9W2adxdGSGfXtRSsIa3kv3
	DNL1x6X3r1nu28tJNsgaXrLJQ1PfI3RGUj9dtbsgqLAPWzNJ57DCq+VXUfEBYYqF
	U7cyrS5O6ALD48pX3uTe7NVtJE0FAAsmQf5gvhQF5BC/5nxpQUfPoU32wEi2SQUM
	2xR1Njm0uA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 48svbdabfv-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 07:13:21 -0700 (PDT)
Received: from twshared31684.07.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.17; Wed, 27 Aug 2025 14:13:09 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id B16AA10CF621; Wed, 27 Aug 2025 07:13:03 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <hch@lst.de>,
        <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Hannes Reinecke
	<hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCHv4 4/8] block: simplify direct io validity check
Date: Wed, 27 Aug 2025 07:12:54 -0700
Message-ID: <20250827141258.63501-5-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250827141258.63501-1-kbusch@meta.com>
References: <20250827141258.63501-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: e1uDyWdD6-Ety8faQmY7hC-fqZ6ZjNqj
X-Authority-Analysis: v=2.4 cv=a+Uw9VSF c=1 sm=1 tr=0 ts=68af1281 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=wgemLMbJKI-cAGOf0tMA:9
X-Proofpoint-GUID: e1uDyWdD6-Ety8faQmY7hC-fqZ6ZjNqj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI3MDEyMSBTYWx0ZWRfXxPZ77IFUbOTq
 JC3c2gu+TLuVxExpt7alYhwPP9gxGsE5U1kKW7+6Y5hoZoJmnLFmhcVovlDVhiqCbaTFJ9wTj7f
 vILXfYahwe9GV/6mBhk16C+9FOtva0gcP60QyCsUrzbF8WRLvLmZuK3SZbak0XEJqeeHZkneIkh
 YEdE3Z4txwcchsxmNPtf8BonQGvitAQDZSKjh+i+BfP+c9/TSfS5p8fty/cGcfHXWK/E3GghICL
 Cy1d/sC3kmEi+kkvV5wIFqWmbpS8Bgja6ZsC9LqyTAW19+WEEX0vy34nJVWA4BzMV7kb91uQyfl
 1ZSY3gPh0qv1Lt1FuyYkVTpIE2kJMHJrAcVW/4f5r7SeTNukY1zhkXzeFAnL4I=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_03,2025-08-26_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

The block layer checks all the segments for validity later, so no need
for an early check. Just reduce it to a simple position and total length
check, and defer the more invasive segment checks to the block layer.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/fops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index d136fb5f6b6ab..19814bddd77e2 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -38,8 +38,8 @@ static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
 static bool blkdev_dio_invalid(struct block_device *bdev, struct kiocb *=
iocb,
 				struct iov_iter *iter)
 {
-	return iocb->ki_pos & (bdev_logical_block_size(bdev) - 1) ||
-		!bdev_iter_is_aligned(bdev, iter);
+	return (iocb->ki_pos | iov_iter_count(iter)) &
+			(bdev_logical_block_size(bdev) - 1);
 }
=20
 #define DIO_INLINE_BIO_VECS 4
--=20
2.47.3

