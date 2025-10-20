Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752A321CC51
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 14:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760971446; cv=none; b=CzRnDPz/HVttyKovRhv1JdhwRJi4/mHpV5pwnevuRfXo/Rt+Gpzq6ArbCXnf8KnXqB1vmuy6jRBsyI4hTmwngB1MURpmmhois7EsGs/x2bV/8T71nuwXP3oyJtpDvFv3Q2+MOE9ccfMqPCmRca3iRU56maSlXiQNEMO8t0NtsGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760971446; c=relaxed/simple;
	bh=k9KvN0OFKCJUWJxD40CcRTTuH6NiWMBudZAyF6pCvY4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XZdqyyT98GjHXGJwowPcsgzZL9SkYxZ7anrRjHToYB+kc0ZpHyBinCzZe36jpV7LKuHxbjhNfqePc9hkmCIMz+NwPKRweYiQy0FIMX9nNGZEqGGv1wy+Rrz2c6qohl9Ul63CIvfZKoJiQ7NN0KeytBgFM+/ZhIvYaFlHXrQ9300=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=njgosrKv; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="njgosrKv"
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59KAnq8C3854342
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 07:44:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=Ok47DknFlhtWA7VtVhZOhx9DX/WpTLnuDg2vmf+PDL0=; b=njgosrKvEvdF
	e8kzUBKtuKA+fMQCdjgclLTxz/USh0upm75T8eMZS6bRAeP1njFV7uYtSDjj11Rq
	f8dSce7aokKXtdHDnN6+VPkR0QOD9X0C7oPzY7ezy8CgexrOA0I1CaWSBqWFXpbz
	PZuR2XoLen8ECfNQWgxsUA41vNxgCcWI2msHCB8ZelPQwL5jjiyOjmF8gTp2VTv0
	7J71Z/8zyWO42H38EKD3NZZMzJJ8Bv8LU6jC3lIXoisoD4tkRKco83yiIaxvxbpU
	8W3/p9kkQyum3D7++UuDhZ8nkDQhF3xAzUZSN5meuDAtzSfYbiQKiS762yzLoZgI
	61PVJDUYDg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49wkp19a21-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 07:44:03 -0700 (PDT)
Received: from twshared10560.01.ash9.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 20 Oct 2025 14:43:59 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id F1AA62E64BDB; Mon, 20 Oct 2025 07:43:56 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dsterba@suse.com>, <cem@kernel.org>, <linux-btrfs@vger.kernel.org>,
        <linux-xfs@vger.kernel.org>, <hch@lst.de>
CC: Keith Busch <kbusch@kernel.org>, Chris Mason <clm@fb.com>
Subject: [PATCH 2/2] btrfs: handle bio split errors for append
Date: Mon, 20 Oct 2025 07:43:56 -0700
Message-ID: <20251020144356.693288-2-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251020144356.693288-1-kbusch@meta.com>
References: <20251020144356.693288-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 9N4rKZJx0OrhDUG6cUVoqf8eGNTu9Odf
X-Authority-Analysis: v=2.4 cv=eozSD4pX c=1 sm=1 tr=0 ts=68f64ab3 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=FOH2dFAWAAAA:8
 a=ABllRBBG4x9hLAaS6EQA:9
X-Proofpoint-ORIG-GUID: 9N4rKZJx0OrhDUG6cUVoqf8eGNTu9Odf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIwMDEyMiBTYWx0ZWRfX4D/TstTyaGva
 6St7s7NBd8TIthUXwWMmfVSW64+h2sSaWCOTG3BvkktzoSXrDViZAIrx4PvsfmHIiEHtPcbFjVC
 DWgujTMaE30xg8L2VN8F1VkSEf4NA1qUKz9sxRUhsum7H2DeIFf0z+nBxnnX5ZbyKkJ5/7l61Mh
 fXcxvmsnKyfqYmG8jzbOOZJEdujuPfDR9NdjP6GRb74OZpzTTzNuS1J8Cypvn2cxnVXP1MvuW/l
 ioyOjS7mW40QRGqghNllDdozJL1yfEB+9nd9z/vDj5n5HOXktiqLrYY3FFV0Kkj0Oc76FhWl9ol
 +BQQ4BYUD3W12aR+v1fA0X9NpqCr1wN3wQdnn7BlUpf/3fEcw3DzqWWDI5l1hu/Qp8R3NBoBbeY
 R5u2ifdSzd8kmYjUSQaqoo+sKAEgLw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_04,2025-10-13_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

bio_split_rw_at may return a negative error value if the bio can not be
split into anything that adheres to the block device's queue limits.
Check for that condition and fail the bio accordingly.

Reported-by: Chris Mason <clm@fb.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 fs/btrfs/bio.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 21df48e6c4fa2..0ca86526a8bd8 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -646,6 +646,8 @@ static u64 btrfs_append_map_length(struct btrfs_bio *=
bbio, u64 map_length)
 	sector_offset =3D bio_split_rw_at(&bbio->bio, &bbio->fs_info->limits,
 					&nr_segs, map_length);
 	if (sector_offset) {
+		if (unlikely(sector_offset < 0))
+			return sector_offset;
 		/*
 		 * bio_split_rw_at() could split at a size smaller than our
 		 * sectorsize and thus cause unaligned I/Os.  Fix that by
@@ -685,8 +687,14 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbi=
o, int mirror_num)
 	}
=20
 	map_length =3D min(map_length, length);
-	if (use_append)
+	if (use_append) {
 		map_length =3D btrfs_append_map_length(bbio, map_length);
+		if (IS_ERR_VALUE(map_length)) {
+			status =3D errno_to_blk_status(map_length);
+			btrfs_bio_counter_dec(fs_info);
+			goto end_bbio;
+		}
+	}
=20
 	if (map_length < length) {
 		struct btrfs_bio *split;
--=20
2.47.3

