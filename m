Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BB93BCD33
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 16:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786379986; cv=none; b=ckAZ/or0R9eaKiyoXxaOSONF+Gjln5lCRnaUO8Mn2WcvtGqLAs/pWODBP+hcVEMYDh4BHhuXN3iyNhXlMk+f5S8gdUMzhNOYyz+KFqnCJeeOWvo0GnyIsqDw1E9lgqFVy+8xGKL0MLQ+PaG6/wew3ACconElDmkKuMVuY+fpshU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786379986; c=relaxed/simple;
	bh=1dVw8nrbAkxuia8Ac49iB4K1gs7YkCKauVwA5PiTKg4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=D+VrkhEXpDQgGO7vbqDvARAvNFcqHpDvjUYT7N2nP4FCjOBqcWW6WMVMHoNAIF90pS3TLzY7MfVvxu+tT5aKkMxHoTo7wM+DZdDPFBX65E6cZXIcLThmjUMHIdCR7iy5jVyc01kmJnme5FYMEhSVonGMrWVWze8wtdXa0K/IhhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=gK4/09uf; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="gK4/09uf"
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AGZNDc646740
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 12:39:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=e+BPPtqOvSp2f4p9hlj0HukM/4
	EvcLMV9fvq8zY/jWg=; b=gK4/09ufjiH+PjNIxNIToysgyH3VTFluCwCJrtSPf2
	n/H+xqxPD5N/2VMqd0mP0lXQyBpXqEta74UfG66EGNHpcdqvIkh4CkLWq0ibG4U/
	cANtQQUjRnrslosC+Mji6YUWBYpAeQ+HiDh4Gd9f83UkkNKdb96mTFxcWdp/RZNm
	PJHi4uXsj3VGAkFwBgh4AxP/GreuFB62DuGuISvncmMUpSe2+PgJjxi6ZlYDCxgQ
	EF61hn2BNm5ZCKMKG6yMOZRWbmAqDKPLFd5UHusjl4MpFm3gE5Al3B0C4MGsDgaG
	tPHHPF0+oSXfhIzvAHMMNbHjwRkbcjQiYGQifU+l9Ftg==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fy0frmmch-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 12:39:43 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c1b4d961dso842271cf.1
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 09:39:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786379982; x=1786984782;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=e+BPPtqOvSp2f4p9hlj0HukM/4EvcLMV9fvq8zY/jWg=;
        b=NeDzd0sZ0yx4BLtKv7gpUXGiAYivqXIMk7y6LGmsfsTi+/CigBofJW8oyEgUJE+XBk
         2WdE7k103fcoVuO77a/t2t6bES9rU6vrk80znhqhXQsXA6UAIgoIvXanhTHG/MxaORI+
         tU9enXsQYhrnrHV3DbBtdAz0hrV1HOmKHm4wMAprUmI2os0x0/zbA08flJNlXGT1Kq9J
         4ekhUEfXRy+MRvZcyX9G8MRRsP6mDzJvws3da+aXD36hdPnzNLSSnFXA2XCLbaTMgJcG
         oYkXj6040RFMuW/E3VOc1qF6qVDskgBuhtHFQJosb/paIAXtLECl7mo7VkFWkwooO6pC
         L6zg==
X-Forwarded-Encrypted: i=1; AHgh+RpGcU1bwDnBmwreJoBA1C+rOPd5teBLfWIcQJUIBlKDErSO17XdlpweXAYEI381MpsbvKXhEBKhpwM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy69xPQ0c77uNPFydmVKwDbBBG+6xtvtdcMAr+wGyrK2iDowBn3
	Hsu9YBO8bX/2b/J8KTWiOD0t6Dz2wWzA7RR0YmSAfl86GeXot1L9oMS/FjDDYIF5RDp840VOUi2
	srDqjuNgaXvJ9fe2SzDBOwQTJcXClUCNZABfZWAoyaLllwiwJz7JLruWXSw==
X-Gm-Gg: AR+sD13h4Afnxf9vOuUkII5XhBVq9HSZBuajRs2tXpDOSNOoNpsdP4xh3vsCaiIjFKe
	MIi59fv4PvUCH2Pb8wGVXbibvxmdtj/rd1hbtq/nQMd0y/2Vvl50cMxI0vWkqXY4cyl0K0gi2Uh
	nQDup1kSFnT9LbV92ERfBZq9XTwiK3WOgBWvudCE1RH5AmpO3riyi0qOBj9s2aU04/E0C1nk8g7
	OR7WNjm+FDe4l5IFVloYmQ9sl/K5ykrS7SwUFIqZ2fiFJZgCGCZeKM5aXQtU5umbNWkweTgtFB4
	rsVRBFvZvx0efin8ww+/5EA+9SRceKqB2VQ9BMwgCftHHkR1kv+VZ40vNt/dCq/q0AWSK6jlHn+
	CQlgtvCSJAEf7mmGE4IFPMigOfwB4JFdnhtEMA2swHYI=
X-Received: by 2002:a05:622a:2cc:b0:517:146d:2cb5 with SMTP id d75a77b69052e-52d23825fffmr193169611cf.20.1786379981907;
        Mon, 10 Aug 2026 09:39:41 -0700 (PDT)
X-Received: by 2002:a05:622a:2cc:b0:517:146d:2cb5 with SMTP id d75a77b69052e-52d23825fffmr193169081cf.20.1786379981496;
        Mon, 10 Aug 2026 09:39:41 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021506c0sm33475204f8f.11.2026.08.10.09.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 09:39:40 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 10 Aug 2026 12:39:19 -0400
Subject: [PATCH] xfs: avoid double deferrals for RWF_DONTCACHE writes
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-xfs-dontcache-double-defer-v1-1-aea7484b3e49@columbia.edu>
X-B4-Tracking: v=1; b=H4sIALb+eWoC/yXMQQrCQAyF4auUrB1IRxTxKuIik2baiExl0pZC6
 d2NdvXev/k2MKkqBvdmgyqLmo7Foz01wAOVXoJ23hAxXvHWYlizhW4sExMP4m9Obx/JUgPJOdM
 FE2FkcOBTJev6xx/Po21OL+HpJ8K+fwEx2RpgfgAAAA==
X-Change-ID: 20260810-xfs-dontcache-double-defer-ae3fa50ba02c
To: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786379979; l=2117;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=1dVw8nrbAkxuia8Ac49iB4K1gs7YkCKauVwA5PiTKg4=;
 b=J2RtFKGjmGGQZlE9chrI+urEUn9ROGe+QzTLmqzAsEYbReC3BuS6IvwP3bkhsK+eJgE4g9vHG
 sxrYq9ROhdjAiJ3p/0Lved0ky9kPpSwjM9eNM4uvkOYziZVUIFUUiuT
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: _PPxp5BDdn9whddb2z5Wgo3w_FuaYOZX
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDE0MiBTYWx0ZWRfXyCzd9BuR+5oj
 mYGcHvKAFzC71EdwE8dpkbxVci2MRf+0SRfPR7KnlzeehotBEhgJ460o/XO99StskM/qiZV2UNB
 vMaBJX951lcRNLZfDZhtrenQSa8K4i0RbCbgD8vpnkmALQHQ8pM5
X-Proofpoint-ORIG-GUID: _PPxp5BDdn9whddb2z5Wgo3w_FuaYOZX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDE0MiBTYWx0ZWRfX6kfk6BSBhXNT
 KS3JGQARRNyyT/x8gJ/NXBIOiqtzZdXrfakTFtrNK67wLmK6Xje4riKL2UVKBoBdJSqK/TDvajZ
 gzMpphkjky8iZYNHyYEZ//qcmeCfZ+3dZCRSb4iKjJGpOdKeiU4tVf5PwIGlKtTzJ9b3xNKLu/x
 eJ3MKpU/pT0jt3OBFwvXRfdIHf6louDVGrZkhVVgNgt5/ZZ8DM8jOcPH7Em3jMS2/dfBJNlTXxq
 uam47flWuSWc0zMtUY/8BcDW463N9YcQQ29GdvOhzl4/NCFu7PCwA6RRXet3F4LKUTOPPttRT+i
 bMcZgyPN+w/KbLwk2tt9DCM3Z0ADczxN91reyzLbszXsAkCqBCrO6ihmxuZDfiYPAUrSvuXO7Q1
 EHw4ggf2DSbul/mViqmGTbqu/n+qwWSHt3e8NxdF8X/DDacOLZgPK7+GMNtDx/x7kYe7uOHgqlX
 MV98SyZZT9Tuz8V9e9A==
X-Authority-Analysis: v=2.4 cv=L6YtheT8 c=1 sm=1 tr=0 ts=6a79fecf cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=YmEKMl2L6wtdMVtX8_UA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11871
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 bulkscore=10 adultscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=10 impostorscore=10
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100142

XFS already defers some writes to a workqueue when transactions are
needed to process the I/O completion. Disable the block layer bio task
completion in this case to avoid a major performance drop.

Fixes: efbde6f9f449 ("iomap: use BIO_COMPLETE_IN_TASK for dropbehind writeback")
Link: https://lore.kernel.org/all/8124341f-3af2-4a16-897d-38db5ab5a9d4@columbia.edu/
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
Follow-up fix for the RWF_DONTCACHE task-completion series. This is
targeting the block tree. [1]

[1]: https://lore.kernel.org/linux-block/annkDbhXBEeMoNVT@infradead.org/
---
 fs/xfs/xfs_aops.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index cd8de8c82d78..74a6089abadf 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -549,10 +549,14 @@ xfs_writeback_submit(
 	}
 
 	/*
-	 * Send ioends that might require a transaction to the completion wq.
+	 * Send ioends that might require a transaction to the completion wq,
+	 * and disable the block layer task completion for them as there is no
+	 * need to defer twice.
 	 */
-	if (xfs_ioend_needs_wq_completion(ioend))
+	if (xfs_ioend_needs_wq_completion(ioend)) {
 		ioend->io_bio.bi_end_io = xfs_end_bio;
+		bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
+	}
 
 	return iomap_ioend_writeback_submit(wpc, error);
 }
@@ -663,7 +667,14 @@ xfs_zoned_writeback_submit(
 {
 	struct iomap_ioend		*ioend = wpc->wb_ctx;
 
+	/*
+	 * Defer all completions to our workqueue as all zoned writes require a
+	 * transaction to be persisted. This also means we never need the block
+	 * layer in-task completion for a task context.
+	 */
 	ioend->io_bio.bi_end_io = xfs_end_bio;
+	bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
+
 	if (error) {
 		ioend->io_bio.bi_status = errno_to_blk_status(error);
 		bio_endio(&ioend->io_bio);

---
base-commit: 30df3ab3c92d0e7854c54df6ae66f4aa6eb5b3d2
change-id: 20260810-xfs-dontcache-double-defer-ae3fa50ba02c

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>

