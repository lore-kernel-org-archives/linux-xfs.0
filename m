Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B135A34A797
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 07:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395104; cv=none; b=EHlv374G8Cat5sizfUdoyeNfOHYD3sKIZ8yP3iBq7E+ugSe52vsmWfJZJeAc4IKkoP7M6MO9LZCfPmKjx81Zv/QNfIG5565lonkWWZPNc24BMen2QDQxArfLG97j37Ji+0nAxKfWVnfoLU6rdGxb5iFnBFXvLrmndC03gb+ap8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395104; c=relaxed/simple;
	bh=ZEoFDRdKJkaZHcFnJ/ZnxZn4DtJcz5dwb/qiVw90Hj8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=L0KMkRwIiSX2+YCUNh9TP06sp8CMeANaM7YcIJFykkxcQBp6TNoan7Vz5j2H8O9RLRHw+mk2P4CKXy5MpN2T/7xPCzQDPFmbhuYsVJ+E0rBXkDi988T50AL8yBn0t9Sb1ECTQMgNpLS7BIeopjnesmAdvZ1nPLpwx+eCJhiuIE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=UCAOFlRP; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="UCAOFlRP"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6x5KA1811207
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 02:59:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=7lnM
	AQUAxGl0d0xuPXIIpzK+l0m5WwNxFhJZwOOAO20=; b=UCAOFlRPJWowBl3rU040
	SwZ/JO6HqMmh7w10K/pEOvfmU0vwubvQfrY+WMvRgG4Sga5moOoHKNyIzkVd5Dzu
	jqfahkydSebUt3mV4LY6uMauUWmZDaLaVG6DJ8zuquGQHjwda5DXs/HyE6Xiy76v
	8X3qvA6KXU7iaDGIIoDgLC6lxS2+oXXqSPwjDJUXSy22sYMka8CJlsgohpQfkcTW
	LpH4yJB+C/7+PoeS6rF2sFhJdG/fD89iCJNYXO8aOs2edt3Xj4Q0ig8B38u3LCbU
	WIuh7wRAr4Xj+4p4ZfApoiz+Gt7hx7vC+MQhge5/0L0nuYJb4SXiEk7ZY7OWpx4g
	Lg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fqrjxt50t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 02:59:04 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-92e8004d60eso399293485a.1
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 23:59:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785394743; x=1785999543;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7lnMAQUAxGl0d0xuPXIIpzK+l0m5WwNxFhJZwOOAO20=;
        b=h/2o1DaJYBQqf3fTFBMMW4udFJf7lymBYBssub8Se0t9hS3nBPlUoPzBVR4KvCOBqg
         UndnRhGdR9JcajFCvsNYpKNawC/pq85MOaBk+IWaiG/gdb/FUjzTx11pBbKHmj0Ufnw4
         cnaltgQ7E3p36sd/63XbOwKz4EJjnxg3cU/a2DC3y30g2X3kJV+Rt2Db0ucHsZ26IY9a
         wOgAf9Grl9U9M/03u0z/qDqUcNVlQW0oGUVIZfqD207sEedx+jwWrZzNaKDvsSCxlosk
         8PBh6brkGCVS8IG0C49uuzoBNTZsL9RARXlPwyXL47CW7kYAIGCHh1A/FvweKBGJRC2I
         Crew==
X-Forwarded-Encrypted: i=1; AHgh+RpyjaDQa03HKnoHybnCVkFRpyZKSvhEzAajIIcP7HucxrgKqZ0e1FLTAHYXrGLDBo3gsN0yxieQDio=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx6MXYzmcdE/1JpO6PrCAwg1kF6MNhzyTt77jA/QAI/6Rbcvu4
	6xfRZP1cUkBfplOb+T5Swb8KMaK7N+rlHJAAgLzRS3TASReGCOtFZL9pENbsP6scnu1NicTPozk
	gJFBXXfkIbsSFsGZjFcNusKrcVZYIRAYNmSmTNzZPX783NnQz9GmCABJ69w==
X-Gm-Gg: AR+sD10u+u5/xR6vsl4eNynwjjrfRrEWw0hgf7VC6dhc/7scfn2sHf6cqz+eKR8glH7
	9If1Pve1lsJuv2WgTMCYsKf0dzSxxbmLqmpb3jAFYYqVY6C7tTDsWAyTJhWyB6OQ9yTFJKqsAvu
	sA0gYvUkXTO9/B1nVbJd3xq4jllyt5hx+vJSo2R7IrVQUcyYOiOlWDzPu0UVaP4568pC3+MSCyl
	cd8wA7es1kggUxfsBmwEJUv7mxWWF87yAy7K8QMk/2KdzM7B8YiO5B5pedOMwtjh2MWl25uGwz7
	PrbqpOVhJEY0ccL8EUhJBWN/yVoj52aUQ3DTgR4P7U5AQHxaBK8LQ9c5ucTd+qWiJAxjG0cd0FB
	C7p+VOazqgtMMzqPUAU4Sv1pXBnn0jXZXHkHXFYhCdkiaTg==
X-Received: by 2002:a05:620a:1a05:b0:92b:6805:9175 with SMTP id af79cd13be357-93486af1e68mr113648285a.61.1785394743701;
        Wed, 29 Jul 2026 23:59:03 -0700 (PDT)
X-Received: by 2002:a05:620a:1a05:b0:92b:6805:9175 with SMTP id af79cd13be357-93486af1e68mr113645485a.61.1785394743228;
        Wed, 29 Jul 2026 23:59:03 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3221bc7sm349752485a.7.2026.07.29.23.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:59:02 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 30 Jul 2026 02:57:54 -0400
Subject: [PATCH v7 4/5] buffer: set BIO_COMPLETE_IN_TASK for dropbehind
 writeback
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-blk-dontcache-v7-4-3e8e6850068d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785394735; l=981;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ZEoFDRdKJkaZHcFnJ/ZnxZn4DtJcz5dwb/qiVw90Hj8=;
 b=b+UxIQsoik7/2fDHnDW0olnU1/qVCDwC00Ozr0+zhh1d0+inVyiX96cXmklJSMAHbamG5lxnQ
 vFMiJx13/y+CaUo/njnCuStF0po4vXeZjTMmpT6DPvkv37PX9GBWJ6S
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX/kVNionX/o/7
 5yVimOOztipLeUKju+FjhcQvcUXyKR/f06ya5C64QoP/vX40pTDmCtXUax7WOsKN7Og1faL+gN/
 EgXwYOKC6Une6l/o/+7GDZcA2JTgKVmD6MUMmRjSBKCGCaVNdmG9
X-Proofpoint-ORIG-GUID: 1qdZcuEFRbY0Coh7ZV8OGaRxhzjFzjIG
X-Proofpoint-GUID: 1qdZcuEFRbY0Coh7ZV8OGaRxhzjFzjIG
X-Authority-Analysis: v=2.4 cv=ObCoyBTY c=1 sm=1 tr=0 ts=6a6af639 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=WzT6SMHhq-VMa0lE35UA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX+J8sTPL3MAHe
 ERTTht3UHgeMarpTZP2RbOnAiTDLkqDvN7RxaxYpVewVuUYyFBmZnbtpkvNt+3BJqSc4QbmgStE
 lhmHM+hZPEZrlYNEI7A2xueQGDcd5jMjcC8LRhBqtxPl6VztULNeOqohuke495Vvdto+4wb2xv4
 Wfo2OzDf2Xpl0mABhc53+NTE8IP0tD58peHpMHwcAavlP94OkrHHAgSXscEeiYNo2dm8sPA4Nrj
 hv1UAMytP7HunYPu2zMcqutnmkHuJenDN6NEHp30JHKSUCXIrozmj8Ovq2w/9uBnSgxo9DCOJvg
 Wrl1Yh8V25KJEY8cTC9UCpvaAvBKLZ2/IbdzMwYQB/TcATN8afRsRDqyi7eP22tGAmB43JZkzzS
 BnRwX6yqftgYeH+0PN/5djkzEP9bjBMKtx8aZhGVZixAYnke9hcKhsU4Aq26QbsHAHvyLDXpgTh
 3R+O3ZWCA7/YknuQKag==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11859
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 bulkscore=10 malwarescore=0 impostorscore=10
 adultscore=0 priorityscore=1501 lowpriorityscore=10 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300048

Set BIO_COMPLETE_IN_TASK in __bh_submit() for write bios when the folio
has dropbehind set, so that buffer_head writeback completions get
deferred to task context where folio_end_dropbehind() can safely
invalidate folios.

Read completions are not deferred since dropbehind invalidation for
reads is handled synchronously by the reader.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/buffer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index 9af5f061a1f8..6f099847240e 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1203,6 +1203,9 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
 
 	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
 
+	if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
+		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
+
 	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))
 		buffer_set_crypto_ctx(bio, bh, GFP_NOIO);
 

-- 
2.39.5

