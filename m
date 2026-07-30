Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0573BB695
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 06:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785394765; cv=none; b=U8Vwv/v8hhznC9y4JiCdBAIYampAs9nxHHEbT6CJCwXmMeG1L+ljQ9seZ+4lwUgu1eIEEhB43DYpeMd7G7/QvMmVDxrpQnfrG2+kdPtVhiTOJ/H5W6ekhM0g2MtAVq/y8QU8ZH4rZbzvRqyONics6Cm6rrpC/E2WNUXWH+qqYRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785394765; c=relaxed/simple;
	bh=Tk8jUyrOqQ7WXa1eqV1nq7SPxnPRM7zEp3j/WZJSWC8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pUUzThRSMxNEYoKRUHGj9Qs7pCRiuZse4F7qbuRG8MCi/vYJ/B7y8Ua8/lRIU97673Ka4LJI3uwy5JoR+skCRI3/mNaw9eRHehmRcHXaP159E8yPKDYwyVMdYp3rHMQCz8Zh0/hZXKV5FEZvULQwtfYU9PoowdxQScshJbGAW78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=i0qRx6nS; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="i0qRx6nS"
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6Y8Tt1963848
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 02:59:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Wwzd
	h+lefzQ3Mewr3ag7PKLqaiugNuHuZ6D8zRZNNZY=; b=i0qRx6nSvdRp35M11yLi
	zCDL5833R4xWz9ehYcDjCN+iJy81EVfUbRN08bHwKN4Sv0jCdbucXr7pPAXPrQxg
	1n32YTlFzi84Wr18ittxMIrJzVdRnkygO8LEM7xlODihfBD+KKpFhVBicsOyZBR4
	JD+7PIf6HomtCv8bssHFR2jU/sxf0CVVHqPgBDVeubE9hqpuQG2Q/5k475unjLYu
	leSSOvM4xxdsLdk3pxUwcrvIJrrT21ENuMSN5TaP/FL7OVtRqYOQU+/M1DKF509J
	66cfLiS/MOEbOYUmN638Fpjn7j7NmlsYIk9r74XBJWePIIUuy2ZYsp95KPo8t/ry
	nw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fqrjyj5ej-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 02:59:11 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-92e4f946461so214626385a.2
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 23:59:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785394745; x=1785999545;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wwzdh+lefzQ3Mewr3ag7PKLqaiugNuHuZ6D8zRZNNZY=;
        b=hGdp+IY/BX40aZRUdVZRW79HU6+yLRsDjvs8o2XhVVfTyoiKnxXnKtRjQuOlkQjmaV
         95Jg/KBz0f9k3KjKHnt+Sgv2fWqBrgWtKIBN97c2SAL0iMZkFF9fzpQssBkqV1qTqWH9
         TY7EnXCQQiER7oiP405pwhB1CaG5gxIvwsZIzPoCNougSg/F8gXcktmS70Qi/f9baJ+X
         /uddm64IsgLFxQzQbsM9uqvKyll8HzvOy1UD/GERzHUIOlocvCFMkb3nKIB+fhTSVS2d
         LEHPc9y6wpbv2K5a3Yy+SQlt9PuMT15df2miTAFyWmZ/qJP5Y2TxzYicnciTHZhs394O
         LZ2A==
X-Forwarded-Encrypted: i=1; AHgh+Rree3bBh8b0r0c702xdJlp7Qlh6Sbmene+h5ieLTx9wT0IeZzF8jVAXNHrQ4UQw+UdOPPl8XqmazX0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxt73he4O2qUQTlqQN3crxidB6Vg57NyrEde8z/PbFC0WgQ/Ut+
	6UekTECSF9H9E29H9Y1hQf1OC6L37a1pTxB8YrbOfRZ7FCPHaJWE/JL83lZEtGQXpP59xdXhAww
	RGf8tcdLZ8ymZZLmN10dDcRYK8foYLAqo2G2z9XEProCGKXlzo+TyhvlP8g==
X-Gm-Gg: AR+sD11Av5fKnBPTcNGbKOtoA+l05qGxilGIsvY5OKcPKTJ2jN9YiDmTv0wUCzo+Og8
	DPX8ND0lATLf2h8QbRYpBiV+0J9D2SnRvKvOwhE6X5RLEcmroqH5updRFyY6WMq72Zeztt1oLfp
	lyAORQvUWr4Eb1nfgBT+6BhYxBB145sMNdAin5KhehWyKmvUBN9OP2Vv0JYWmcV91nzUJLNcXSO
	IGncJ3clfwtXKP5VZu9+cxJqZ4SC29koxOFtc6NXwlr4WtT+bxVz5I2RFh8WeMPGWGmWRxOXu2w
	Ghw0HfRedynJjYAAksykM+QYXocCUsixCX3oXl/1UrF0T7Vy4pK+1bbBHS/V8xlFmLQess+ltdQ
	J/vu7SpnexMJudouL907tcE9U8f78BdpVWOyP+iMzk6q3wA==
X-Received: by 2002:a05:620a:2886:b0:8cf:c106:faca with SMTP id af79cd13be357-93485fe35d1mr140937285a.36.1785394745160;
        Wed, 29 Jul 2026 23:59:05 -0700 (PDT)
X-Received: by 2002:a05:620a:2886:b0:8cf:c106:faca with SMTP id af79cd13be357-93485fe35d1mr140935685a.36.1785394744677;
        Wed, 29 Jul 2026 23:59:04 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3221bc7sm349752485a.7.2026.07.29.23.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:59:03 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 30 Jul 2026 02:57:55 -0400
Subject: [PATCH v7 5/5] block: enable RWF_DONTCACHE for block devices
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-blk-dontcache-v7-5-3e8e6850068d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785394735; l=1234;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Tk8jUyrOqQ7WXa1eqV1nq7SPxnPRM7zEp3j/WZJSWC8=;
 b=os6OKouVgqku2jRKGVaPk1noDMT3+eXOUJzWQsRazIMJ1bPae/JGJpIYkqGCxir04AYNo7/bT
 w+Brhzebg6AAvdsxWkzbY3bN7osSNAQdnJPqVkijmqj/2VMhvYhfElf
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX/gTdANAVVaAr
 KSWoqQGAkWHp6TAPm/kVtku2+HL4vZUXnpHslzKDxCTxNsVV1yTzIGuumcwn07MdQktqNobKUf3
 p7rUcBvMyof/CGPYUZd45MT0wgzGoNJQuVqs8rDQZJNbhnckoEuHOUbPh3OBHuDCdNtop7XC4FJ
 xE4gVGj0kUlfs79Oyk/y/mufIuGRlqrmGw+dHEYXVGsdiGi/Q/eZJHqdwzD2RdBKZ8U38JgAVuq
 Zlhd7ngHHHU5xd0y+UXbEYbH3+yvsDg1NfTgBzoRPEkc+QCo1TGPEjQKiZbIB4KgpULChV+q3FR
 3gPpU7VugkvOMpVYEzoMShrBtrA0l5Pa+ep4mNiAkdA+FJTXsGX/lKsK9VBdyBA7zF3W1bJmkoA
 R+REZk56uZwB9Wdxf1bga6e/NEmN4dflhis91+zaJkiMHozhBaUlDCJx2ZP+1aPbxuRFd+h9ir1
 cQOHg5ax5GZjKyOBz0Q==
X-Proofpoint-ORIG-GUID: cdgFgZdj8jdX3-EujkLySupY_Cb2vW_g
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfXxIdy7yyEBgsp
 pr8CY7LmC304nF1HNd63Xwc1Sm8tCf2OGHzaF1fQHFcWM/6P/0S6I5It7OjLKJEJp58TCu4LNdo
 49SIjXfNnPjHalVFJUOylyxMoSDg7t4hOoQb6MG76Cc+S0VPQnKX
X-Authority-Analysis: v=2.4 cv=EYD4hvmC c=1 sm=1 tr=0 ts=6a6af63f cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=J9_MS8zF8NN3zyd_QTgA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-GUID: cdgFgZdj8jdX3-EujkLySupY_Cb2vW_g
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11859
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 lowpriorityscore=10 spamscore=0 bulkscore=10
 malwarescore=0 adultscore=0 impostorscore=10 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300048

Block device buffered reads and writes already pass through
filemap_read() and iomap_file_buffered_write() respectively, both of
which handle IOCB_DONTCACHE. Enable RWF_DONTCACHE for block device files
by setting FOP_DONTCACHE in def_blk_fops.

For CONFIG_BUFFER_HEAD=y, writeback goes through buffer_head's
__bh_submit() which sets BIO_COMPLETE_IN_TASK on dropbehind folios. For
CONFIG_BUFFER_HEAD=n, writeback goes through iomap which handles it via
BIO_COMPLETE_IN_TASK on the ioend bio.

This support is useful for databases that operate on raw block devices,
among other userspace applications.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/fops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 15783a6180de..8b39c53b6393 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -941,7 +941,7 @@ const struct file_operations def_blk_fops = {
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,
-	.fop_flags	= FOP_BUFFER_RASYNC,
+	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
 };
 
 static __init int blkdev_init(void)

-- 
2.39.5

