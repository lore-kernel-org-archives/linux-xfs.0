Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24B74D7D51
	for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2026 09:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790672688; cv=none; b=jy78+fstegFIqAJ15CERJYAZVrppn3JesmFUq5mWe2SjKCuno+QIi7twSHTNWIe3jdGZCMZArK5zMEVV0oh0D3GUhIlXbM7FCN0nyPvssQ8Nwxe9MbCFklH+IySWTuotp5Ja4izHMBwOt1Wx9viTEM6s/62+sfAfOrIiZxbbEhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790672688; c=relaxed/simple;
	bh=qIkpliZGABu/1DsQ9lqxJf6xulmYU8xgQLf18jeRo/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ubdhS6l+CgnUtsAZvBaf1uxfrZMenJzg1OnErHebsDpSnAAUn0jMU2ts4Od7s2IwZxbn4DpLD9o/RWURdVwmmJvoAiH/r/zsRRWmEj46bg3mNj9gFFdwPk3B1J7B1ifRiQeqSa6XwZtJRLAW2xzI3SMepgw1BStNhMerr5kPk7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Cvw+v+7g; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=CncbDnl6; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Cvw+v+7g";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="CncbDnl6"
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68T8XuXt2070049
	for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2026 04:47:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Nhw8
	v53Ku7yoHr9osqQh1xifI8ymi7aYlLItUVuMPgU=; b=Cvw+v+7gR9f6uZsw52F0
	MXPD0qPAq9Q+gdETTR50hu6HwIZyql1BqQ3hngAWoZ7hl1s8zJNa7ENhtX8qRMO1
	d6KwAcEU5x4qHip70NKL1Lezj+cZokgT4qnL1JdgCQ8xpGy83Ui3/sofCsgfB9oG
	dUvHuciNrM+Py803HDSfzYIvJepGceM7aogzK11x7D8ZJDUaVMOYnx7Z7/Ft8vcA
	8Pe0WcyhxnBwiMfSmRXhVk/cDdJeh9z4MMgMyjQqU0IiHBDTp3fEI5yoje1PBuQZ
	tR5V09oftFknpJBxo2xlBxs60tiJnAJ/mOoXMLygEXtEJNmkhg4KndL1MLVdhFZF
	+A==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gyxp5bq4h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2026 04:47:44 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-936aa34873bso756603385a.3
        for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2026 01:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1790671664; x=1791276464; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nhw8v53Ku7yoHr9osqQh1xifI8ymi7aYlLItUVuMPgU=;
        b=CncbDnl68wrk+LwE/fGS2yfT9w5F+q5j4wX5pEJqePFRYUHqnQrC7w3oflSW9pwJP4
         lT/S2RN6v6C+rEKkSff+ZhkfhlvX6Nz2L1eN16lrLxXtU9kJWAwNEbli+3s+XknpfgnB
         kEHn+RB8pKQsQvNi6G7ybN19eh/y1n04xQKcX2zqr2nm6lNGwN7O98oL44lodjd7i4ft
         4t2T0Ts0oN9dyt5N1Y/8FEuEZRh7bn7GLzX5liXZhxxsjYt+Ryx52sbClqFaql0s9kJ3
         YAHEPUsy2IMYgD2Jivzza1L20BJzV9zdGgX+Et/l+AFJ5B5yStTSKK6OAngCYXdUCJQH
         wjQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790671664; x=1791276464;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nhw8v53Ku7yoHr9osqQh1xifI8ymi7aYlLItUVuMPgU=;
        b=Wu73rqObzlk8yhNQqBroD2sqObHulUDX0DWOb/IdN1VdvVxAIcnSgM7S/qV/av0AtI
         RhlZJjlGrUEXsQW+csMrSLxv95j/C5pySsgTDMa9ZjC1epaFL/LDqkfPpVcCCGOGR8u7
         s1mybl1NF700PJmP4DQ1ngrIGPPhGIfeWM7E4UGRdMc+mGOtagIBAaTnnWGvl4xmq5Oy
         /nttH6FhMKSsBp4EeM6+uSYsEhJgy+aMbWU2wbe86Y2S8L2/La9DJM+T85gh2Jgu0+K9
         1g3V1VW67o8jpeN1J3tdXHr5cgGHy5xDBnadpJncsapCfaCxFuYLVXld1XhSD3neUvBw
         W4tw==
X-Forwarded-Encrypted: i=1; AKwUvBzNagD9wfoW1dPU6nbqgXb5igMXOOHnbaS5zUqj53ush/h39NJJvBmvbnNgY6VlCMB6dy3fSezf/Xc=@vger.kernel.org
X-Gm-Message-State: AFuF++m2wQH4cWthPt42bdMJUaumb5Gg0D5obE8sbJQt0VL2Tcc6Ua6V
	LzeyQfsH78TOwolyyspqwroSw3egU0NjXDrRw+K1ed6EfJ6RMYiljhXviaiqPXtCJghRLEcfJzN
	BE3hNwgy0rsmYBiQA7O0jIq3OmIWurifKpjmFFQmhUnjWMtQCiANQKieM9A==
X-Gm-Gg: AYBFou3XxWhcE6+0P7XAJKg0JcxeraRj1FhphAkQMZnwSCEo9gToA/klDZC9y3JUo2/
	qK4Bqj6aDXvHl8RJYLmZt0eDQSJ5qAORXuXhqj9xGcX3KWAJ42ik9tjxpSpHY2fLyJOca3P42Ru
	TSxazBMsqAbFeRWy2YDmjNJ9e93mg7aqJpKVcGzye1lYtTIPPm4+74hWE9+R+4Hn205Ze/9i8F5
	hm/NizvZP//jfe5/OAInywNMzN6/oUrFKH+jXKFjJRIm+cio2N5BEkwPxluCJvUCCnu18dV782u
	YkRjyN2ldIjBqKtpj6mGjfWScCGAm4Dch18JgJt9Nq14bJKFgzwIOddczVf2j0d6rAp59hLnQpr
	VsHeuOSoroLLw
X-Received: by 2002:a05:620a:4446:b0:93b:6113:218 with SMTP id af79cd13be357-93c43b80eb8mr2546609985a.12.1790671664161;
        Tue, 29 Sep 2026 01:47:44 -0700 (PDT)
X-Received: by 2002:a05:620a:4446:b0:93b:6113:218 with SMTP id af79cd13be357-93c43b80eb8mr2546608385a.12.1790671663703;
        Tue, 29 Sep 2026 01:47:43 -0700 (PDT)
Received: from [10.192.23.156] ([82.142.85.169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48af508cedfsm2418391f8f.30.2026.09.29.01.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 01:47:42 -0700 (PDT)
Message-ID: <bb13358b-24f2-4462-92ef-0e538ab314a2@columbia.edu>
Date: Tue, 29 Sep 2026 10:47:30 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/9] block: fail a short atomic pin in
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
References: <20260923-blkdev-fixes-v5-0-89e60d66eb38@columbia.edu>
 <20260923-blkdev-fixes-v5-5-89e60d66eb38@columbia.edu>
 <69579dae-285d-472c-ba69-4279e5170502@linux.dev>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <69579dae-285d-472c-ba69-4279e5170502@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=K9i3jCWI c=1 sm=1 tr=0 ts=6abb7b30 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xSnE1pX28jTrkUJPvDlzhA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=5vhaLU_8k3ht0VnDKtMA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: qs2u8daolH93ox3QfHoP0vraNng68PFQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDAzMyBTYWx0ZWRfX6Tt4/tQ57tZM
 3wD0ETiW9Rqn2On0xZXSwtg/lS6s2oWGfhH3qY96BHcjJdJVbedIPNJYm7bWvxPSHTovn3xiGS4
 XqtMQH+n20Z0LqXMEp2gdBvXX6jtdb7v838gHjkks2mmfA7O3F8UFSUsUJxY3q0KQv2vZlumZg7
 kA2Mt3gk+zzlOKmBLIhk+qobuoFWbLJjI/xT7Db9W7Z71Lme+h0z/igmJ6tbIUIhA7nlk+v1T0W
 AEjJoFI9jUs4yUBlAUu4DP3Sx18om5dxx5I8f4u7zBTtE7Cs9zTXIbbRR72+sFPSZOjQda7qqEW
 dXKmXbOju9LMcL0L7O+2ppg7RyuBOqZJCmdqdVw7Dulp0V79X3d1328FgFFODC2M7AHzRYPFJE2
 1OP0bigouPgjPFGx4qWtXFoVj8qYwtSeen/kPtoXQsIeGsnqP8oGHzweolzeLd2fEyn1gzstdEy
 u87XTtMDvxXCJ4c6yJQ==
X-Proofpoint-ORIG-GUID: qs2u8daolH93ox3QfHoP0vraNng68PFQ
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDAzMyBTYWx0ZWRfX41Ewe5n6Wzsl
 Y6gh/s6sOva27j/C7ZQp5DIuODsNhHnQ0zz3IWD18XmutwbHDQqbKeWgcWr+RfxAtnwtnqj3AdY
 vjSCCY/VGASFKcJZHpROdXGRbdMWEljgjnSR0k+VL9WaLn+pHmad
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11919
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 priorityscore=1501 bulkscore=10 impostorscore=10
 spamscore=0 adultscore=0 clxscore=1015 lowpriorityscore=10 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609290033

On 9/25/26 9:37 AM, John Garry wrote:
> On 9/24/26 00:56, Tal Zussman wrote:
>> On a partial page pin, __blkdev_direct_IO_simple() and
>> __blkdev_direct_IO_async() submit what was pinned with REQ_ATOMIC set
>> and leave the rest to the buffered fallback, tearing an IOCB_ATOMIC
>> write.
>> 
>> This can be triggered deterministically. A 16K pwritev2(RWF_ATOMIC)
>> whose last page is PROT_NONE, on a scsi_debug device with atomic_wr=1,
>> completes short with only three of the four pages written, violating
>> RWF_ATOMIC semantics.
> 
> I don't mean to load more work, but a blktests case for this would be
> great. I am consider doing it if you are too busy.
> 
> Thanks!
> 

No problem, I already have a reproducer so it's easy enough. I'll send
it in the next couple of days.

