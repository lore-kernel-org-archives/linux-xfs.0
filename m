Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBA43195FC
	for <linux-xfs@vger.kernel.org>; Thu,  9 Apr 2026 18:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775761160; cv=none; b=qgsBnE7vo9Rfzdw5czNCCKN1lRpnrYB4OK9Dche0TXa8wvYu2uvmHTpUJWikKoVXMYe1mEdPaDGpXuhIlm3jL9/iLO2qxdSOwx1MGeoEwHkL98izJ7cQNaIyFlCF/ZhrQTC6RvK4vzxqJ9Qec5EBYtZsASAt5yrre4TDSwGNfVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775761160; c=relaxed/simple;
	bh=83mNKZIsBND3Lg8+THcthV/SuzYcLTq1w+CNeg0fbZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pq7relgBRN3T7H/jVKRdzzSJLQhBsWou62raNyKFkhfaNPvhOF/apwfsL8brpVYhzIIHAoTTX/168/xLf5ToKSipQ3dJSPupv9l9mmRtnK/7CZ0aWCzJ0ewedMhdBvCoEge2MIpZ/vAYA1B0KTaKDC1JKvIzFaPJUsFaNyImUGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=EHz3tC4l; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="EHz3tC4l"
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639Itw0P732745
	for <linux-xfs@vger.kernel.org>; Thu, 9 Apr 2026 14:59:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=83mN
	KZIsBND3Lg8+THcthV/SuzYcLTq1w+CNeg0fbZc=; b=EHz3tC4lRgXai8PvPEZq
	pkKUs3OvD5nVT1jqwDXFpk6Rhe9R5SxV6b/feB3LGa6Ml2hWQWH9nTOnbI0jQzLo
	QLYJRGLVXQOHbFB1Vy36nqjvpb9IUyFleXcX5OznP1OtLhuMvp6uayzuz2W+yvxa
	bs5GuKsexDDUjrZp0lEwLGsyCESY+7+nHbIsv21ltQxArYbn0i1Bt/Bmp3jLurPn
	iki6jHLGtAFYO7D52XkMbj6PiglwXmCOboDjwVU3VjlwlhD1YByF+WvnaBhABguH
	kkai+Ec2gVbgexur9XaYmeywsRhFC5Ikw68louduoTGyWGonKSBQ7TCwkUGf3TYB
	lQ==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dee5e28e5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Thu, 09 Apr 2026 14:59:17 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8a16036c90eso37188436d6.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 Apr 2026 11:59:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775761157; x=1776365957;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=83mNKZIsBND3Lg8+THcthV/SuzYcLTq1w+CNeg0fbZc=;
        b=p5gFCfLIVCeVHCRK1k4G44phsfwnJS6YrB19nUCd3kNW5mRl6F1oEQfiH4DG7zKszC
         OkqJCtDz84vjC5gh3J811pMGqwzMaCJBRAiSJw2x0zleovND7qM6Yc4j1m5gED8nqMb3
         E+fSy6uxLQe1gUc92GY+Kv1wYahMwe8bM2hEpl8/ut5Y4NYCu6nNt725Bml6Rj9PBIRk
         clJ3qgzSWTIc98UQbSKZMXThK0+LGPQm8+Z9IyiRJaibNBtIXNR4UGv4UwjzsLBokgQF
         qVEMZyCtM60ig6P3DWh+Je//bBwZzazhB7f9cSNYCLWflBgtdaRafKSEZTtZaVNcvZHl
         ek/g==
X-Forwarded-Encrypted: i=1; AJvYcCU//Psf2r+GFwbQru6GPwxNPtmeR0euJPS+CH6SToJcl/yZR/ikvAQB6/e04T/xsFQcEtF/A4Qr5gw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2zhXkQFZSDwwdLLoLvdMffizlWPI1jn4HMJnoiZDL3F3H8eCT
	X4PR/uH5lymROaDrbNvFnjNqPJG0JLP4//SOVfu8u/nhkAwkuYDDNJR0lKIc2Gw9o8jTj382MNn
	5Xlum5nvCgFRSZjqBJDYYW+T2L1DY90Q4k5/dRNjKapCQP4r6YZqRRLVfeA==
X-Gm-Gg: AeBDieuIN6P9dyykIbSI9oDQxQcjdnFIexPkCEuEYCBW31rYJbMnh0kXV1qqf+Dd+Nk
	h6XMhXqleG5Tef9CUuPb6DyNj7sgniEIgQIKxFpq6u86yExxrBq8M5iku+Lg1KSbHuv15jF4A+I
	xzuSFjrgcyZ3aqkWSY0wHvxZfWs+KaJu10fqWETU/gXLaYW0gJKrNXGkLwv/1NwVd6dxVUb0Kgr
	HUXBPSq2TCaibrlqJ50DAGmqD6IpIn4Yz90+aHDjnuXEMITeWqSOKePlBOoYl9SRfnTvh6NDbW+
	JFEfs1UleNSKcIKQRufkTxm/ZWRBdG250u4ytiI/6AcUAygFeP8UCrZaDeR7LmlLtm5onDlYa0f
	5SY4z3pCcT+87fDjblCA3EYpGS3yxdOx8OrmAA4QD
X-Received: by 2002:a05:6214:44a1:b0:89c:bf90:e4ea with SMTP id 6a1803df08f44-8a7042f7e4amr439710446d6.34.1775761157312;
        Thu, 09 Apr 2026 11:59:17 -0700 (PDT)
X-Received: by 2002:a05:6214:44a1:b0:89c:bf90:e4ea with SMTP id 6a1803df08f44-8a7042f7e4amr439710016d6.34.1775761156904;
        Thu, 09 Apr 2026 11:59:16 -0700 (PDT)
Received: from [10.206.71.59] ([129.236.231.31])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac849db735sm4286926d6.2.2026.04.09.11.59.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 11:59:16 -0700 (PDT)
Message-ID: <fdbb90a3-846f-4b55-b22a-5a8027bee288@columbia.edu>
Date: Thu, 9 Apr 2026 14:59:15 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v5 3/3] block: enable RWF_DONTCACHE for block devices
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
References: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
 <20260408-blk-dontcache-v5-3-0f080c20a96f@columbia.edu>
 <adfPA0_U312XhCYF@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <adfPA0_U312XhCYF@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDE3MyBTYWx0ZWRfXydGWCgymJNY4
 S5moIKrdnaS0MR5ltOzlkha5Dc/lH/U4Bz3P1cwAgB2WDZ5FQZBVaSZF+8DOtgFeuQxwZGbKx43
 y+g3VqSzX44k8ppK2q7+3JNTAQiLQBbsA7pg2DqZ6NEjmaM8F8CNP6BZldQvS/rjYHyg6tSlXiR
 mGdYUBeY0f87xckFI7mlxFjCWDLSAh/SV0xCOJZn3LivY7FZ7rtj4s5CJAuPMrnRgvKnAt3a2CR
 01Exau1TK/ChTQ1g8/x56QQPO7PTChzNDBY1Vr4fQrUWRLxc4upwEHBIse++UTd3ospmGPtAFio
 fwONwBTjaptlj4c7XFanZ4VwEMtL2Ocgu0OEdSlMc7MI99Ln3kaN5pUn1qetFsm7xJK0syNl0pP
 dCI1vv07FtrnBwCX0Wib/LbziCn52+Er0xUF26wcybVvb3IIn3HL9l7TAqVKrvt+jF42oFEKvyr
 ipINPjaKiWmBXifDpyw==
X-Proofpoint-ORIG-GUID: 2yA_HVF5fufpC4iT8A01SIOTR1rsQn-U
X-Proofpoint-GUID: 2yA_HVF5fufpC4iT8A01SIOTR1rsQn-U
X-Authority-Analysis: v=2.4 cv=UZthjqSN c=1 sm=1 tr=0 ts=69d7f705 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=RFpAoTwO7tzpE9r8PTiuXw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=VtaHy3UVxHd-gCO4CH0A:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11754
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=10 clxscore=1015 impostorscore=10
 lowpriorityscore=10 phishscore=0 priorityscore=1501 spamscore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604010000
 definitions=main-2604090173

On 4/9/26 12:08 PM, Christoph Hellwig wrote:
> For the next round please split this into the buffer.c parts for
> the infrastructure and the use in the block device file operations.

Will do.
