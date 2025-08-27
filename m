Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318EA35FC05
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 14:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756304013; cv=none; b=i6vEsNBaNXxP5myEsvHvwVwHdtJ2+I/rLaSO1YVENh6m0lNsDXfLf5fNyyV9RtDd7qIU/GgKWqDZjwsyfXXT6YHBbe74jqvUupbCIhbF8EPBVJyvWX8G8RlpTHNcZtZgokth8/+AbVj7GUnRH0BM3XJRhjYKCjXpAzj2T/62xz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756304013; c=relaxed/simple;
	bh=hNWh89z7bVho/nucDYtzmjo0CgvLk3JXnCFimcvoW48=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dLyw36bIaPri74iZGnEG2lZIcXYVPckxGLTE6NJWV0i20dO1wkses3Fdxg5AQeyLmJwMHjS1s0YZyQy9gLgW3mys+ydnwT8PCgt5A59UruIGQcxtSarl3KeRKEj/Kd2wsSPn5IJOd0GGaMfb7o9mCmsr4H/IBFqmwl1SdHGwPyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=bC/BpT8Y; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="bC/BpT8Y"
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 57R9lsdv1665081
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 07:13:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=TvAw+PhgN5KIMKT9wim4ffyA9Ijp09dFqqsdzWDRAtM=; b=bC/BpT8YEIRS
	0ZSTq8zY4hHjzHh2iyu7vjxwsZ98WtSFlCrfK3r7G8Gk6Se2r94lagSoSxON+DvL
	mAlPkMVgqdpHr33b1rww/IJEHR/vxXXZlA72oMPxmoLAtm5bRExzKdZhst/3SBJ8
	88gOBN0E72i+MejIfwKfPGLNsDRwTwMIjdqZoxURm+a+lur/Wg4NzwESM5OhTBdL
	pjRB80fwTyK2oAzxHCebNiqosYcavSy3Zm9LbbN+Dl8G2n1YD2BZl8fQlHqm57Co
	Q9py5rM9h9wzlDkTR2eFN/7dUfipFwyZT0Qvm/LI0Sm4N28FBBmfJI7pCwCMQF7t
	M2+pXC8r1w==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 48sypx9cjr-14
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 07:13:26 -0700 (PDT)
Received: from twshared71707.17.frc2.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.17; Wed, 27 Aug 2025 14:13:15 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id EB42010CF629; Wed, 27 Aug 2025 07:13:03 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <hch@lst.de>,
        <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Hannes Reinecke
	<hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCHv4 7/8] blk-integrity: use simpler alignment check
Date: Wed, 27 Aug 2025 07:12:57 -0700
Message-ID: <20250827141258.63501-8-kbusch@meta.com>
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
X-Authority-Analysis: v=2.4 cv=V9F90fni c=1 sm=1 tr=0 ts=68af1286 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=yetF5jY7WHH6jeiS1L0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI3MDEyMSBTYWx0ZWRfX8QR17OV8IxEE
 AMFZ/R/dtfVimKEo2u3ncaKV12z4RrdZLxsRUJV8a+taMOzgYB3c4fJ7GGK7iIi3seYy2+LDDZx
 TVWlawE0cRbH7rWmhnQgA6LH6uP/ie/Jy6Ui2LwWRy6PZ2qTQeF1v8/yMY7qMB1Y+YJIfM4vy1O
 Az0279namG9tXgI4QdPh2p5wjUxgf3a3YDgCxtiOChoe0v+sPyTOQ7wqBDs7n95xqf8Q37AQ4yc
 Q9nJaXwfH4T4UWwlY6UbTPxU7HXEpMesrqE0WmzmuZKVTkIw5sheBkA+cqa02xQVS+oOg5Nyr5S
 2u4VoKHnX6gUxvUADaoGkwTw4brak8s3haQYnRvK/BN0IBYVhcBXiQEhbiqgcE=
X-Proofpoint-GUID: MFBxR-Ew1wJSMCJPFt8G_8Ot6nQxmhM6
X-Proofpoint-ORIG-GUID: MFBxR-Ew1wJSMCJPFt8G_8Ot6nQxmhM6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_03,2025-08-26_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

We're checking length and addresses against the same alignment value, so
use the more simple iterator check.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 6b077ca937f6b..6d069a49b4aad 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -262,7 +262,6 @@ static unsigned int bvec_from_pages(struct bio_vec *b=
vec, struct page **pages,
 int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
 {
 	struct request_queue *q =3D bdev_get_queue(bio->bi_bdev);
-	unsigned int align =3D blk_lim_dma_alignment_and_pad(&q->limits);
 	struct page *stack_pages[UIO_FASTIOV], **pages =3D stack_pages;
 	struct bio_vec stack_vec[UIO_FASTIOV], *bvec =3D stack_vec;
 	size_t offset, bytes =3D iter->count;
@@ -285,7 +284,8 @@ int bio_integrity_map_user(struct bio *bio, struct io=
v_iter *iter)
 		pages =3D NULL;
 	}
=20
-	copy =3D !iov_iter_is_aligned(iter, align, align);
+	copy =3D iov_iter_alignment(iter) &
+			blk_lim_dma_alignment_and_pad(&q->limits);
 	ret =3D iov_iter_extract_pages(iter, &pages, bytes, nr_vecs, 0, &offset=
);
 	if (unlikely(ret < 0))
 		goto free_bvec;
--=20
2.47.3

