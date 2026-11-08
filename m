Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794111899;
	b=HyaUu+XGM37iPoA7FwPrTCIX/ls1Vm2VjxAQJfpFDP+UCEU4oNUwrtAg7oS3Zi3FgKou
	 3c0nGN391UKm2FxGASj1TVjd0kDEYJF7DUxLqzdkYEBrIgU/wdk30pQLFOqd2OhFGsFJI
	 RR/FPdEKCGhJQiYey6enJ60zn7uheJDnJ5NlBG3HiVsF7/C/P/O5eRD0zYepGO3IKq4B4
	 m6WfWS0SB0qOwahu3U6+MtDSjUWFBw9zaXH06IXrJHrcrSsADzGUCMpIf9K1dPKS3FVMj
	 EDfhmnD615vIM18dzEf1nHdeqAT/lCOAzBnaD1+xBkKCDhqvAnn4xhzbfxnDAhQYSeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794111899;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=nr2Wdm4cU+m3pqBJ2boexNpwuovYPWeiRQ6Ijfa/2ao=;
	b=LVeLbWabYTsNMXXPSoJyGnStrLHeOdlp0fDkESyF/CB+hIb7jZrZgH96idXTR686CCpJ
	 fkbQihrQw0NyqFXKHis/tvoYh9quxLw76QctDxoy7/Iyv4J7nU7u/22Wok2o7Q3ngvZbv
	 F2YQ/QUrLW6s2X40gfEtzjewLkovy/IznnCjc1ILffmJTUtV380yoiOkNWdf/qi1yUXBg
	 xUnQt3QA4X6IVmHNfgb5haL8Od0KUI6PiG5QoLnwVqsBID08Iql4ZxAe3CSSZKpWnvSXA
	 EwjxhB08TiDy5teb+q7eFoXCr+wC23C3PajarmyAS5qfxsHTq9uTgi2hinsLZZB+Krg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=r0Tut1ve;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=xTksu3W2;
	arc=none smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D0B606A322
	for <linux-xfs@vger.kernel.org>; Sun,  8 Nov 2026 04:24:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3D0B606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=r0Tut1ve;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=xTksu3W2
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A83dT7Q2434508
	for <linux-xfs@vger.kernel.org>; Sat, 7 Nov 2026 23:24:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=nr2W
	dm4cU+m3pqBJ2boexNpwuovYPWeiRQ6Ijfa/2ao=; b=r0Tut1veybdZKVhIjzNS
	f/LbH4m79onai7u+naDj1RMu+HNEuFy4EW25wgHYDwUimFujDwGDDoGf6N117nf5
	uxobIRKETpZGhznp3u34Tl5TgHaqv0bnQ8Wuzu7uZkKLM/biJeU7cKhNU/33t13Q
	WN0PyPJrrTIUmjAY8gvvn1HaK9/iKxwCbfbfQuMH2BKmEpafDbP0y4AyFwysGrBM
	/p3onW7+72iw/NbhjSgF9lWLBEUhinDoL7ACcEGUSGewPnLfn9RvyFZAjUcKzz7r
	3d9LPmAppzpzs5jypgm2G/Cf0Y3WFYa+F9wr7TGDC2fzDzKBNEpmXzUYEoaeif/I
	PA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4ht1tq3xdq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Sat, 07 Nov 2026 23:24:58 -0500 (EST)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-536720195ebso5076721cf.1
        for <linux-xfs@vger.kernel.org>; Sat, 07 Nov 2026 20:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794111897; x=1794716697; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nr2Wdm4cU+m3pqBJ2boexNpwuovYPWeiRQ6Ijfa/2ao=;
        b=xTksu3W2zbddPSvYXw1KCEPKyQ8qBoo9EWhExte8YiKEgvH/b1uqj54lAPkSUtshxz
         R0nQWjqIpjdswYs1BztX33DSElMaiTU3SOLuC9DUMt3IKglPtsTtvi85lBSBRqoD7n4r
         pIe11e2KTT/0akPhVzS6SeVzTcPXY1RAuiFrwXQ/6pgfHtqq8BUP+89OHUX+G6NddL+2
         1A0+Lj6OambObz9K8O2BuQhPGgvuQWVJnKC0mGnhSeg7/S4JZqAzjFECylaVaWgZQCKZ
         E4O5SAuehNTnsWNfYBMLHvjcPujC6u3iqbDA84/Un2enK7AH6GttY6Iv333XOhaB6GTT
         bQ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794111897; x=1794716697;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nr2Wdm4cU+m3pqBJ2boexNpwuovYPWeiRQ6Ijfa/2ao=;
        b=P2RF9iL2Y6AMjigOVPKdCnnm6Y5qs6ddO46IVW4Cy47aNqv4kqQsOQx3ohliOtNpw5
         v6WmFtBmp/+cGjKv6jp5U0VS3R++5hv2sKJ00PJsj1kckt+p/QcWHmcuCazt2/H3NTSb
         jXIovIF20SnusaOhgN7S7qdiALMR9Fa+uR1WibbXZkcB7WvOI+1zdBK+Lizufec2KyAy
         4UJ2/NNMzjIE0sBgn89mT4Fl7eQwnakCgusOMXjkg8KaKNvGdr3hCqU72QB/MxVd9E0R
         9huZInU2DBt7jBEo0MTdwS59ChyB3cglGNLFUkOueCjYHtYHq/0qFOQmMV3n6uaezzH0
         wYkA==
X-Forwarded-Encrypted: i=1; AKwUvBwkRA3nNvAD8GYeAZLWsHqAjkyv97+eV5AFDigqA0VXRuTCwiinD+Dp8nPaaCkP3dbY8+vc9fJ6w2E=@vger.kernel.org
X-Gm-Message-State: APuU4Z8RRsLx9FajozK52tE+hC2q9vrD2xf+4O6BL+efawHfai1ymbbn
	7HtyZAzGqVvTP7ojqWAkb3n/fI673U5MU7awNQW9Mio4/YmshK2CkPH2XtaWDjX7Dk1LTHhud1C
	ipDzctQOc4UvqvQvMq/JGfUuBLeTC2Ovc7BxuGsEwhsQhJEQggd46eRG1Mg==
X-Gm-Gg: AYBFou0SZSVm7CXhryehNMWI3bTNbMGykWJAKuBCt//8no9l6K8foRPHGTQoIxLx+mo
	Saq0jA3cO8JrSu34NlAeYeHE5ixe/TfK6yLcwXDskhO6hUf/aGtsKr+3XtIsVt3Lv/Ujn/1Q76c
	ebeUzKmFTs+m+HwCAJXFk5UqzFjEbxsI8rysOYn6c9qhhJsozv1PR1ryL1uMaJ6X260a/HaV0YR
	PgO9IDtJRYFwgqQnNSLDekhvXT/tQDDE3r/DVgSI8RA16foci1B8gXSybdISNojPuItzPqvMB2B
	ciaEHwz7wgaBVvsEW/P1TZvy7p5a41lacIbxm3YdkguMMZ2YR6HERfQ5729W1bfM5tTUjeEzXMj
	xF/1ggHGsJEHasAZ+hHIepkIPcsJZy4I2i9kzEynJElS21mxQ0KHFKMyl0SPNITNjXYu5PdzxWs
	yh4PaI8rJWbn3cl5QgwA==
X-Received: by 2002:a05:622a:5507:b0:535:36d:dd97 with SMTP id d75a77b69052e-552a50afd9cmr5945731cf.48.1794111897255;
        Sat, 07 Nov 2026 20:24:57 -0800 (PST)
X-Received: by 2002:a05:622a:5507:b0:535:36d:dd97 with SMTP id d75a77b69052e-552a50afd9cmr5945671cf.48.1794111896856;
        Sat, 07 Nov 2026 20:24:56 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91eceb56290sm10085586d6.1.2026.11.07.20.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 20:24:56 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sat, 07 Nov 2026 23:24:35 -0500
Subject: [PATCH 1/2] block: fail a short atomic bounce in
 bio_iov_iter_bounce_write()
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261107-blkdev-atomic-bounce-v1-1-f66344262096@columbia.edu>
References: <20261107-blkdev-atomic-bounce-v1-0-f66344262096@columbia.edu>
In-Reply-To: <20261107-blkdev-atomic-bounce-v1-0-f66344262096@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>
Cc: John Garry <john.garry@linux.dev>, Christoph Hellwig <hch@lst.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794111894; l=1259;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=7TVx2/mnFenAz9IetxnT56jaB8MDSx8eh+EB+HeZVY0=;
 b=gtfq1Uu5lL/o51CiwuZdW8JnZsS7EQmgCr/CjLWHC40wFPmi8TmuWNFXBbg1XMM4G8/JGXrcj
 IRjI+Ygqmz+Ci2lYcH5eeFDgH5zKF0bslDSMzRf7bm3ZBsZZc9/7jcr
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=RuFQvymK c=1 sm=1 tr=0 ts=6aeff99a cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=zEHqqOqeF9Yo6E5rROsA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-GUID: 0_xmgkKSxFJ-riqkhGLjmoSbrHd7ySnc
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA4MDAxNyBTYWx0ZWRfX0LH/OF7Kmesn
 o5z1gLLJOJ6qcFl4baVdOOR5/dK1FZfE6+jmAwtV4iV6hjOZGsMbDIHvSU0/KyFM0Lq3OKtMlNn
 2dFGjewbLudwvqV/0oCfQf0ydMuR3wO2OY8WnWZGBfeY5TgYj3Bw
X-Proofpoint-ORIG-GUID: 0_xmgkKSxFJ-riqkhGLjmoSbrHd7ySnc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA4MDAxNyBTYWx0ZWRfX5TUtSBQUb/4F
 JJURmUc5CO+DbpsjBF0+ACy0DT8YLyyBcxBb9Ob50kc90hU19tEOg26Ag9+fMBFgvVy3jtZQH2P
 rn38mvi8y0jm/pKu7OTolEWG40Y7xJXaJFcpohPaDiQQaRpcK/IlLL9g8BLWahIwSALdiOcTkiW
 p70yerJEVwX0GCRdCCgtR31fjiQoasONR+RswIHZ09doMgKU90AIMo0hcP7uI8511I9bYmUW8Z5
 wkbUzFeGFZ/Wahx15kyBdnsXnr26gPRcUE32CtlaoWi30e5u80Uu1BTG06ux6xrxOR4nhcFjDnJ
 ub4P6nIk0iKW5KfCr4sV6fcQbZ252eXLf1FU5AZpvxXNeq9s64Nf0p4dzqSyn0qY+qLuML8vc9u
 p2nxqa3mQfFtVnOkTMOV3IzyTuKAqknQK5COHXVyJ/AlAw2lewnVkVHBEwr+HHzxk7L6SA2hXrk
 d0ujMYKcKjwrhAFdEJA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11959
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 adultscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 impostorscore=10 spamscore=0 bulkscore=10 lowpriorityscore=10 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611080017

bio_iov_iter_get_pages() fails a REQ_ATOMIC bio that doesn't cover the
whole iterator, since an atomic write is submitted as a single bio, and
submitting only part of it would tear the write. In contrast,
bio_iov_iter_bounce_write() doesn't. If a folio allocation fails partway
through, it returns a short bio, which for an atomic write triggers a
WARN_ON_ONCE() in iomap_dio_bio_iter_one().

Make bio_iov_iter_bounce_write() also check that a REQ_ATOMIC bio covers
the whole iterator, and clean up and return -EINVAL if it doesn't.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/bio.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index b0fcc69de653..61a3812520a2 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1523,6 +1523,16 @@ int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
 		}
 	}
 
+	/*
+	 * An atomic write is submitted as a single bio, so it has to cover
+	 * the whole iterator or it would be torn.
+	 */
+	if ((bio->bi_opf & REQ_ATOMIC) && iov_iter_count(iter)) {
+		iov_iter_revert(iter, total_copied);
+		bio_free_folios(bio);
+		return -EINVAL;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(bio_iov_iter_bounce_write);

-- 
2.39.5

