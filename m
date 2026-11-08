Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.139.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794111901;
	b=3fj6Bjgp6vviboKfKyDl8ak0vtGCRtaJYNLsveEbH+yKFNi6Px+FDzKyBcE0Vnv1iGqL
	 h8JvAv7PMff7r9df8ZVGmK/QMh0kmsBYf/57EeCIvnLxTE+Pe0e7rnxy/YAwiBuvWiGtz
	 EkSzN9LSYiXDeskc7kW11ZIdaZn2CjThMExCHhD5fh0hERooTEQHwX4svH9HLKp5t8T/X
	 OA36l7Ai7ioz3sGNta4tmp/nRy2eB3/mHTWuAXW4ZKxaiJnTbXs7iv+fFCOLUPo7yg0v5
	 prf6OJc3hQX0tnlBHEr7iCgFUdfp3u/vpP4Qvp/D9k/suDqrZ2b+zedS8Y8myrm9kfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794111901;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=KZJMLmuXX9sJhrtyIz3QqrKY753KM/thMo2GKlgX/ZY=;
	b=CQYBNY1OHd/CzjwpWj2kpYw8dcnVv5b0H3JG0QDalVKvDxu4B6FDTM7zhvmWtSL+uYoz
	 GEV5OfFe9I0BxVGI8SCMutl7SKB6tWuTuCYqk14fiOcJ3r/vWTro9nNZDOKkD84ifUylZ
	 4AwmMU10NRNIW6AiE5skXloQyIOEz/N5uAYALA7RcE2rxi4csj+GMR9pqGCyrj59oXwNp
	 gCg9Lv8wEmQkL+/+IxsZfZZrLLjbB9J1L36RT1dESLoTgfqKeMS2elTPcDFTyN6tZYuZQ
	 QA6XPb462b6dF0op+yK8WdLleDXtD0bq1zX2HkRBF8GoyBNrknHUT8dgz7eWdwgNUQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=QTlZKnSq;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=ii601FQr;
	arc=none smtp.remote-ip=148.163.139.74
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4C3606A335
	for <linux-xfs@vger.kernel.org>; Sun,  8 Nov 2026 04:24:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD4C3606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=QTlZKnSq;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=ii601FQr
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A83dPhq2207141
	for <linux-xfs@vger.kernel.org>; Sat, 7 Nov 2026 23:24:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=KZJM
	LmuXX9sJhrtyIz3QqrKY753KM/thMo2GKlgX/ZY=; b=QTlZKnSqJMb+trqFGS6U
	AZ7w/DFE0vw9ltjPsMynYi1Q6FrW8Wk5UVmjUTI3JPX0b00cd58UJ5A/0KHMBDYX
	nS7qmIwJA8+eZCe73U2OMUC6VdJHJWMI2dAh3ISkk1IocjjsNwDi54rXFvac97Rb
	FDXnK/gJ5FJIzupP/v7mHqfwRDVXcvE0JakFvXDoWDmM/pmvV/ic7IO3Xq5PyyeQ
	BfPe9Yecxap6gs5+hzDJIiMufH1TNCHF9meVL3X3n871YusaivyUhy/e71tGi/PM
	Y0Jm8LAvs4p/gPZrWroGX6jp2nueUC5J5uPipq2EVvj129G0C++goEgyLu5RM/3V
	Bg==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ht0ur3wq1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Sat, 07 Nov 2026 23:24:58 -0500 (EST)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91e8b51c11dso2477516d6.2
        for <linux-xfs@vger.kernel.org>; Sat, 07 Nov 2026 20:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794111898; x=1794716698; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KZJMLmuXX9sJhrtyIz3QqrKY753KM/thMo2GKlgX/ZY=;
        b=ii601FQr7cfN6jCjSyEFGn7xpVfcpuK8gVH5oYBBcOx+tZH1NLMzB3WxGcC42516LV
         sW2/JO9v4jtqVdGUWAPF9Tp6X70eWK+L3P8F8f6Pm/X694jF1q9hCJHZoXqoBXu9cjAX
         lhXA88TJLN95Dd/HRs5G2jPykW/rRCR2QLdhlZ6MxxB0TV40zivfMhQfXbMYMfXKGCOI
         OMMD0gDKPyzFPyxjBnal/4/0KBar1smOlan7iAzSOU1GdkC9u30TvuifluJapWsdxJ0u
         PVU/Z6yi2PDPSD9qXXcYIQRxatJweYei9mS1XimdS0kCU60d4wGkbRfS1TiHZFzIVBYE
         PKyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794111898; x=1794716698;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KZJMLmuXX9sJhrtyIz3QqrKY753KM/thMo2GKlgX/ZY=;
        b=svwxrDkhDF+a+RrwaRztS+2bACilkaxQIkOudagEwb+bfAqqgz7neirVdf4WhbBrOS
         xmJPNVE7rYz9G2ermLbGJ2IH+akFvNo0/Jyf44XEUeauvdQrHgCV8FomT55T4zjqahZK
         kcYENPayu/UZNKn19H/Xp0Lf17LPrddUHmxML3EnNUJsMF6GkYLxw/WX8tJjTOHTtr8Q
         4tpvNBFdQS72Ckm1idDK1ZibleLzL7doLWIemiM6npnNGr64cv6MzOEtR5lwtgQKonlu
         1qjP8bMP0L5/r9hSfBknWNluKIXX9+qhmZFnBEktu67cwiPnm+BPU+26wQqWfDidk+TG
         4ECQ==
X-Forwarded-Encrypted: i=1; AL+hErHpxikyxLNct4IdH1AHncA8UbqCsiCHou3jZlEQz4aPQ+w7gmHsrqpX56Ft+tL73D+87C0+FsVU8L8=@vger.kernel.org
X-Gm-Message-State: APuU4Z983Umm1LT6DtmGIe739PNzLNRrBmAYpFuDWGMWdDtaCwKAnmhX
	vKcOeezHxnRCsEU0BMtfTHnWqaGvh/eqBT0LWyFxyElxyM3G5qmBfolXdndMgkrmzvPui6o87xk
	xFDPOQyumq5Gqo9k5WpfVotGNkfG57cPWQfB5wFwZtUWjhPKRFvEQATltJQ==
X-Gm-Gg: AYBFou0qAtWw3T04EO9HSul4E+NRgw6DZrnaoSecVLdDVlf6AcLrscYBa3rNrrRdeHO
	eBnDwJwTDs0DXKt8CVsUnB3Xunt0CFoI1LvZuga5p9Chf+soauzXJxW2isCFF6jsqOnK6h5EwEM
	ZfvWUVtnWNjr7JVro3ydVhdD9LIzsZh3y3N63RFOsXsY+i7jKVqIp97BrcT+lmzL/WSDAkguxcF
	DJyZP2ep0Vqrl76lOsLIPNjyf8VWElFNei8WIfwFYvheLXaH4MWbkbAJv/ujCfmOWKChjUCrqVv
	FmTjKusQrLkEcMBmHDsmo4wQ1b7x9yKtEGZqjbjJV88Z1kC7+YqF+JsSJpKq3z7pEC3Nq0Yf+vp
	issal8fvXxIqTe5P3iLI7JnpB89T59nnsWDPlsLirmiUBOWV8IvdpCw6oeH7UVQpHKzarckX98j
	zKl9ozsZACeo0zA/iDxQ==
X-Received: by 2002:a05:6214:f2b:b0:917:aa8e:474f with SMTP id 6a1803df08f44-91ed241d308mr5684336d6.23.1794111898155;
        Sat, 07 Nov 2026 20:24:58 -0800 (PST)
X-Received: by 2002:a05:6214:f2b:b0:917:aa8e:474f with SMTP id 6a1803df08f44-91ed241d308mr5684156d6.23.1794111897712;
        Sat, 07 Nov 2026 20:24:57 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91eceb56290sm10085586d6.1.2026.11.07.20.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 20:24:57 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sat, 07 Nov 2026 23:24:36 -0500
Subject: [PATCH 2/2] iomap: remove the atomic write length check in
 iomap_dio_bio_iter_one()
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
Message-Id: <20261107-blkdev-atomic-bounce-v1-2-f66344262096@columbia.edu>
References: <20261107-blkdev-atomic-bounce-v1-0-f66344262096@columbia.edu>
In-Reply-To: <20261107-blkdev-atomic-bounce-v1-0-f66344262096@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>
Cc: John Garry <john.garry@linux.dev>, Christoph Hellwig <hch@lst.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794111894; l=1480;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=raAZDoGoyOUdBE+OG2rr/mS13qUOspHTisqUqAlpy7c=;
 b=CLzcS9Tl3wtyGtCIhcgXJGXi+GUmlZBXZqeULwvnGRqHuLjZlROfZcK+k64yvGX7pHkOtdT0O
 kJ+c0z9sJP4BJNuptANA537ABkv5+MZNClcxLmCZoYiCbzo1pJK+689
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA4MDAxNyBTYWx0ZWRfXy1+EVEtpCWDa
 beA9Qx3ErMliNfeuIaiemeTdH9fdIXJSQsXNVTYNvr1W7EbLuzW4Tq/TQpmvz9gCVHpfsbLsWN0
 Kfg74WxbR2IegblaB67AlVOTeIHT9RuseMemyGD6xJkygeV9HIEwdMHvMaElMLIdzF/h09yUpX5
 bs+4DfSxTgwVvm3zTmTmLuA6nILv7+tSEvQpF99+Jw4Qmw0OVX2vLo9KE2tULDvzy+gXg7O4mkL
 uDynlDQW+mEqRsB11cbP89yb/ZRs5LHH9mUogG+oLPyAQKh7SNfF3WyMfpf0F5BnpQj3EZLr5DO
 5aPvWaLyCkIDFUn3x8F2eyUGpAqup9hEVXytMdNN7X55jY6S2oqBq+oSfVELkj1OBObvkaQJiWN
 dJv4+ENbYfekUZl8UvfZ3q0/oGSyzEUdZbrJie6uJRwlosu7nbqFxY7hm93tcQoc7QCW8Lz0jFE
 nfLs0XiI1B8HfB1IWQg==
X-Authority-Analysis: v=2.4 cv=K/a3jCWI c=1 sm=1 tr=0 ts=6aeff99a cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=VwQbUJbxAAAA:8 a=I7NSszDGB1yI4--CJuAA:9 a=QEXdDO2ut3YA:10
 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-ORIG-GUID: pGSl7niup3Bx2o4c0k93khZxUDy67AZD
X-Proofpoint-GUID: pGSl7niup3Bx2o4c0k93khZxUDy67AZD
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA4MDAxNyBTYWx0ZWRfX+F/LvB0cZIFI
 OtO+cc5ddKjOXSxDRsy/p+ra5bpc693fqEJgN/IpiF1VOwFg191vU/wH0PuvP+YH2gibAj4zlws
 gxiFkevhyS4bhOBJmiR3vSsAZateG+XgCF36CB4/McYQ4dvVSS1U
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11959
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 lowpriorityscore=10 clxscore=1015 priorityscore=1501 spamscore=0
 impostorscore=10 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611080017

bio_iov_iter_get_pages() and bio_iov_iter_bounce_write() now fail a
REQ_ATOMIC bio that doesn't cover the whole iterator, so the bio here
always covers iomap_length() and the check can't trigger. Remove the
check.

Suggested-by: John Garry <john.garry@linux.dev>
Link: https://lore.kernel.org/all/82978d5c-3e08-48e9-bf0a-7913e1cd0507@linux.dev/
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/iomap/direct-io.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ad041ac3252a..aca7cbaea4af 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -370,15 +370,6 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 		goto out_put_bio;
 	ret = bio->bi_iter.bi_size;
 
-	/*
-	 * An atomic write bio must cover the complete length.  If it doesn't,
-	 * error out.
-	 */
-	if ((op & REQ_ATOMIC) && WARN_ON_ONCE(ret != iomap_length(iter))) {
-		ret = -EINVAL;
-		goto out_bio_release_pages;
-	}
-
 	if (dio->flags & IOMAP_DIO_WRITE)
 		task_io_account_write(ret);
 	else if ((dio->flags & IOMAP_DIO_USER_BACKED) &&
@@ -393,11 +384,6 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 	iomap_dio_submit_bio(iter, dio, bio, pos);
 	return ret;
 
-out_bio_release_pages:
-	if (dio->flags & IOMAP_DIO_BOUNCE)
-		bio_free_folios(bio);
-	else
-		bio_release_pages(bio, false);
 out_put_bio:
 	bio_put(bio);
 	return ret;

-- 
2.39.5

