Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983D1562617
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 19:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792004411; cv=none; b=l8XW8U5QyKrszaFxtQeJsI5eRMvq0wk7yoSI2HJ+AKNA5HZ7hpJOJS2muKz4MqskoYJH/ymH9WzGC8ojVIdl0lSSM2oy6KeIeq8j0yAfpwOwuNuq1ZnMmXOe1OozcvXu2Tdvhv+sOm5+8Z7v9ybnOf+Qm5EBiG/0g25xKRvHi7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792004411; c=relaxed/simple;
	bh=Rb8XZmmvT8cxn74MXNUCeOuPGauZxlvtGCiTJh0eb40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E260am8G87EldETTvynH4vE40/Sp9/W3D9znFtIiIpyBMzws6jTRdQ8WryexClpmMxguu+HZSSoYXpO5ggU19m9mZ+zE6b+5C6wNVsPsuUHgeWI9/PMVnbPB2WMM0YXTlt/4Q6vT++3AThACCfkiT3v6zHHBblCUzaHYG/9K5KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=mWWj+UUG; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=GmnEUgmb; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="mWWj+UUG";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="GmnEUgmb"
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EInsh22643648
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 15:00:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=SHv5
	vB/tk7sll8Kkk+NHhBijfzgb1pYQHOyGwy6N4aU=; b=mWWj+UUGvdXSLYjqGKBk
	qRjyZAFUBqKDFrBsJRjkInUs3ju9ynsaD1j6tJXOE3D0QkYUleR2qkiM6AT/S4pI
	vyObvXKzpUi43jFMC6RmvfwI/sftJiI+Hw4rC/jRdrGpIQEIu2NtmXyndK6GA255
	bd1juLQfEt+qjg448awRfj7cNjD53xF9l7L663bj54t/tGEbjs/hllrUIfkkgnbe
	BIUvzpNKtqm8z3t+iPKuTj9dC/dPMoTDtxhMJvHK7TRZqVaOLjqkSpyqJWILv2w8
	1B2EwMv2fuKSjN86b6U1uEvcoH3PsxtASiWjbYjlsZ+dOFtthToPQ0JdCQVlHupv
	rQ==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ha7n8vf2a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 15:00:09 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91064f6e75bso156356286d6.3
        for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 12:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792004409; x=1792609209; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SHv5vB/tk7sll8Kkk+NHhBijfzgb1pYQHOyGwy6N4aU=;
        b=GmnEUgmbO1jtfbHlikfGcgb5g3LkhhxceJKzyzKkzdxNSUzkgIVRUVUYWO1+FzBET/
         px3EqZ2EY93UitUZh5JKkjc4Miq4tkxnRM3y9T5JHdZmsunVzdq88pJmvFKxEXGa0Bpt
         xdALZ7ADYu3QnsOGZVqEdNUY6nG/Z8AZPIA4hKEbv7VDk/KR3kP25izq0p/ebfMhbBgH
         KLnJJIjIxClFY2stKB5SL84sRpMG1hUSBcjKrTg/Z9divyzTZ88f0sDt3Wu2uPEvSnax
         zzYszrRbhFQrXy76uK5YxdL6jlLDuXB86geUlhtwYQQK4hXA0OA+1S1NFuM4QFfNMcSr
         skbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792004409; x=1792609209;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SHv5vB/tk7sll8Kkk+NHhBijfzgb1pYQHOyGwy6N4aU=;
        b=f24MUUtdzXgh69PuccpZYP2z2KhyHwtdA67a7bkJt4khbs8GsNXF011aehyVH7WczU
         n1jR6nD0zGXfXMNyqOQm+Dwpcp+r72H2QvtegCbwW8SMgKoPCAGHTbwgRPf9lLLzK0jo
         +ya8mwVKugIpfKptMtcZEEm9sza9Zpin8JWlxaJjBgvvgfdYIpH5HlwGw7sPltXT5lkN
         dVAgsmKNrs4Hm4dL9JJOqHcza5pOqJhUiwhX7pAtjCx/h8J719P7p0xZWUNpt/etagLc
         vlPacBZ1OJ2G7SxsC2YG3KYSO1ePek/6nZbt1+PZxJFX93WMymb6mz5pQPXMP1+ctHaz
         +pJw==
X-Forwarded-Encrypted: i=1; AKwUvBy/BNq8nY8akbvpvgB2h2JBtIF2Q9HmzCAQWo3lA9lsSgLkJVFOz+IJc90UQpz7WZSRWBNJEQTxrcc=@vger.kernel.org
X-Gm-Message-State: AFq9FYJs+D/nuD9gpzNk1b24EQAV7Yq3z1szNSXFAhHsVDmds30Kf+cl
	jq3grqedT6wCBXdkJvbnntG+1oIQLDPQlJELWKVRtINUS7Is/mbepZrdjLwD4reE+Abg4ks8PY9
	r3+bxNRVwkrDyHyaj7zy7AiNzo1uA8E+B3slI4zfqUdfuUbNaqySA67UKQg==
X-Gm-Gg: AYBFou0yFN/dqBgfJdQ3bztkNOwM9+RDDD4VJnY/xR3LVMXCS23EXFqu+JGbiTLu9h9
	2iecnGptCH5RC+IjbDOhDSqo9czmztYVslcUBXP3qmh9EtfjijyrQG+hirY6ol4T0bYMc8oqMJD
	U7hnZAXa3IqxZVK4gpA2IPSvgI6SAKTL1WP0kHMyTJf1rHP4bRwjVDt492TwnI5cdDiHhqoDCQq
	Bqar5A2mA1GqICHmA87kllzKrkxlJCIFWV2vPH/bQ3Ky7IpZ4c0U2aWU9S2RaYL/iDBaqM97l/m
	ZgAEaFPnnWCfqa8M7i0a6Wquq6qmT789HH8KuBB7uRspf9wj2QvzUldnrsgOLT0cifvaPzG5Zkd
	cLSeyCXPPefnei0EZPUSvGdM9fSQM6ut/X61KM4xk8qxP21h3
X-Received: by 2002:ad4:5c85:0:b0:91b:5d39:e12b with SMTP id 6a1803df08f44-91b5d39e8fcmr282066366d6.52.1792004403626;
        Wed, 14 Oct 2026 12:00:03 -0700 (PDT)
X-Received: by 2002:ad4:5c85:0:b0:91b:5d39:e12b with SMTP id 6a1803df08f44-91b5d39e8fcmr282065896d6.52.1792004403051;
        Wed, 14 Oct 2026 12:00:03 -0700 (PDT)
Received: from [10.207.9.0] (nat-128-59-176-148.net.columbia.edu. [128.59.176.148])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b3864dsm59747086d6.14.2026.10.14.12.00.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 12:00:02 -0700 (PDT)
Message-ID: <54a2b38f-f863-48dc-be26-b18949be337d@columbia.edu>
Date: Wed, 14 Oct 2026 15:00:01 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/9] block: fail a short atomic pin in
 bio_iov_iter_get_pages()
To: John Garry <john.garry@linux.dev>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Hannes Reinecke <hare@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Keith Busch <kbusch@kernel.org>, "Martin K. Petersen" <mkp@kernel.org>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Sashiko <sashiko-bot@kernel.org>
References: <20261009-blkdev-fixes-v6-0-307939c387df@columbia.edu>
 <20261009-blkdev-fixes-v6-5-307939c387df@columbia.edu>
 <82978d5c-3e08-48e9-bf0a-7913e1cd0507@linux.dev>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <82978d5c-3e08-48e9-bf0a-7913e1cd0507@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: p5esj0Skvv0n2EXRbsq7x87zH9M5PEPf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA3NSBTYWx0ZWRfX6d2BhTqf7ilv
 En7J0rIFH+qx+PFvOnm7eP9JeMRqj/fY84WRFlObJzYdV4hCLc+x9FemZ5zKjhUX/5BpOvSHoj7
 cw0//MVITrwvfLay2bdElHGK9W/kkNT7c8KcOdX2HbGtmCjqzsPac0tiK+GBNEuvTxuDo3yh2eV
 ulA9OsBRAM1OQWaZyuLocqR+vDimV9+GHHresdZIl5Td9naDnmkB5RXHRNNnOb2vI/NOhbiH7t/
 +ef9I+U92DvhOHdYTNEgQFWGtYgJ9LeAf9rKHD4wtXTEZ2Va5u6Ou5kOQuc2hYOi4dUEsYARJBx
 dzZy3RRdih7q/zYTYbez9mzdrR08ezgAVJh7aooFAYI5zAlvqmv3u9YNdTaHSmtGZAJnlx1trL8
 dVLZXph26AFqOdPZX+YdsodWVXhVnMhlUbUgtBCUHuCRerzpDyIEpF4vg0PDVsywWGD63J2XtqJ
 JPWvgXH4M9KJ/LCAA4A==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA3NSBTYWx0ZWRfX5ema5q7Hvqwy
 Qmi0SRISdFxK408iKJ/LgCOitZJA/0sFsqW3fCOCkcqVMFBEsa1DZn65o/39DZGad407gwhh33a
 SKAvgilW63xdSAZJuE8qERuDTZ2jcRwtMmrwXJHiT6KTQ4jIWZKe
X-Proofpoint-ORIG-GUID: p5esj0Skvv0n2EXRbsq7x87zH9M5PEPf
X-Authority-Analysis: v=2.4 cv=G8iJgNk5 c=1 sm=1 tr=0 ts=6acfd139 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=dxtdfZqDOO0kCslK4e47hQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=p2SREvNk3m13K0H494MA:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11935
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 adultscore=0 lowpriorityscore=10 phishscore=0
 priorityscore=1501 impostorscore=10 suspectscore=0 malwarescore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610140075

On 10/13/26 4:40 AM, John Garry wrote:
> I think that you can now remove the REQ_ATOMIC check after the
> iomap_dio_bio_iter_one() -> bio_iov_iter_get_pages() call also; however,
> considering the trees, it's better to wait until 7.4-rc1 is released.
> 
> Thanks,
> John
> 

Sounds good, I'll queue that up for post-merge window.

Thanks,
Tal
