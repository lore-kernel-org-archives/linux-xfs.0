Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342AB35AAB8
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 14:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756303999; cv=none; b=sqzxoikL7k05OGTifyrfyc7w4Kjn3eBpwVjVGX3dHiTYLQkYhibuX9ZeUEb34T1AP0McvqnlZcjuE/39AH2n+hNkhwfTwRT8AiseQItV8smacnURwzU1r8p7hduz4opFKhpcl+JcXegFzCkVc1emVi9z8lS7PfsburkK/jrCTyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756303999; c=relaxed/simple;
	bh=4EuDcwVcgg4XYUbwMBGRKkF0194+qMOR8Fxoz5uvsPk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DsMLgZTkvzAiW/DoGzgqTS46NOQu6JNZFpSve5syvPIE7BpuAx0Nf6kwaCZhaEoLW2Z5Z7S6YMwYmGbwPHLWRH6gWtRQb1ABYCxl3hr421AHLBRMR0rut0OC4zyG5If9VeEbXZNTMStsv3rMr1NfSNwMXYTDO5sbU+ZvS1h65ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=sh3b5UYX; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="sh3b5UYX"
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 57R7vwcn1426096
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 07:13:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=A7mQgPp2sl5oTNiddVPCjxxlfAI/+hp6HiDsqOExGuM=; b=sh3b5UYXbRqg
	vB+bUFV+rda/OsKGndrDaLFknkCQ3aauQicBfSWWQPCjCDGqIXyj95LJeczT4UGF
	+jY7w+m2kbAC7E+f5nRtMVDkmyXTKEt5u2eqS4y01jKAdnDu9y/XtkOsNTWDyOoS
	iDJKPDSHdbxrn2uobUnpodpp99wIWjGXbBWsWRiOZRbym3R2N16eKdjwqSyd/jos
	1hvIS8ChVZ5XZ4l3pdY7kyKGCOHluN879gzER6NqtBPxfRYHkYWIfZtErx/s+q5h
	O+ABay6zdk9jP9eF1sv0PpFW6eHlyuPLQWc2BvTdMfjD84roU85Y51/YYrMg7+WB
	7nV+qjqLLA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 48sx3bhvgy-17
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 07:13:16 -0700 (PDT)
Received: from twshared0973.10.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.17; Wed, 27 Aug 2025 14:13:07 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id CC92310CF623; Wed, 27 Aug 2025 07:13:03 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <hch@lst.de>,
        <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Hannes Reinecke
	<hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCHv4 5/8] iomap: simplify direct io validity check
Date: Wed, 27 Aug 2025 07:12:55 -0700
Message-ID: <20250827141258.63501-6-kbusch@meta.com>
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
X-Proofpoint-GUID: _zw6lBnt2G8o6R2L69l6h6C2-CsWpNgJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI3MDEyMSBTYWx0ZWRfX94Reb4YCLmoU
 rM+DFjkTSl/q1nCR+MdULHChP+gZ9rmu//ZgRd9lrdYIoclZ+FqaV9Seu2zd5soISj4w3soZ+LN
 MJMOD2pvJICteqabQ6vB6UVjPlSMLWEVxSIaBgJQawEQkv641+PdrOb0jmBiK/3ECn6HBafFOoi
 C4GVMKto8mS6oPhQsL4/0Hja7IInkM9aIqJ80YAPATRdkjwDZDB4EvW0s4AoKW1BWmzXC2Af83n
 3HM1U14GAGXoiTuFLXB08CJ9iSVHPMcIpTL0d3aI82vgrwkJFVkED3+2AWWRI8xFtDJgimIaLsY
 hzzly481ESmpl7yej4DQ1G7UpeX6jbWAF9nLrmnO8dj4oXhb7yEGonOLU7whs0=
X-Authority-Analysis: v=2.4 cv=B6u50PtM c=1 sm=1 tr=0 ts=68af127c cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=yYvhBQMpDZKDIMWT91YA:9
X-Proofpoint-ORIG-GUID: _zw6lBnt2G8o6R2L69l6h6C2-CsWpNgJ
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
 fs/iomap/direct-io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index fea23fa6a402f..c06e41fd4d0af 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -337,8 +337,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter=
, struct iomap_dio *dio)
 	u64 copied =3D 0;
 	size_t orig_count;
=20
-	if ((pos | length) & (bdev_logical_block_size(iomap->bdev) - 1) ||
-	    !bdev_iter_is_aligned(iomap->bdev, dio->submit.iter))
+	if ((pos | length) & (bdev_logical_block_size(iomap->bdev) - 1))
 		return -EINVAL;
=20
 	if (dio->flags & IOMAP_DIO_WRITE) {
--=20
2.47.3

