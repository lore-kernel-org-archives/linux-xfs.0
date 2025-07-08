Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD98C220F4C;
	Tue,  8 Jul 2025 12:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751977675; cv=none; b=PPFaHYx6Oh9PntWM4acPGlnEu3g9cLGnDIbaFabG/ejiTDRqqvMAC6wsRjDlfO/JOi3LrFFtBho0I6vYLECuom/t/Y6y5T/jxr9BTZfoAAXWUVSBEv7k4IkUrzScl7zT7kYyGdKD3HOS9wfF2tYf2/aB5JRfAOY1uZyS7j5GD3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751977675; c=relaxed/simple;
	bh=EPrH0MQpypzbX+tCkpS73VGBROjayzO6K1EBpuHehvM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EznOx8gkLAUBv0xcL5rQ+hi/bKhwYeEfLlubHP327AyR6WPPsUAIC9II2fSO7gRnVSoXRZpAwEava+2qlJmc2cazJd5tntg+1Cfd9sIMfxbMmQ6o2qlYU7uR5xSnuIpiJPDLUg8eQGWHx/RN/U8FjxkyNZjMh4sLrFT50Y3mYX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=URUl/7YP; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="URUl/7YP"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 568CEl0U025616;
	Tue, 8 Jul 2025 12:27:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nO4MbO
	xSSz/KXFgOZDOLTWbrtwC85UMkZ6xwwBiH7YI=; b=URUl/7YPtfI7ppj/NzacnZ
	6PHP55hvLCXwDVKnsWKxiQL6f15LfZcfH/4WbdjNUAADr4tYmn/yP5ZbDeiRs0vY
	4TesGAN6cZFxPNeS8ErWcAy/4cZ/plt8wlTj9YjWs8S3IDJXuBrrf5d5EQuhR7sN
	0VKqIYC/UiDMNAUU4sWUqgnhDnKQPE29IWmo5tMecp7U1x7cIYuq0dwA+zw5nr2o
	vrmlrdcfrTi5MTUKUogYiMGYlMdm1IL5oZ7HLd6N/zkZQOgYZ3owbhWKRU6Xuozs
	rawmFUvv+pEtQ9h6gmU+2yC80HPhbNjBw1NVihvYfmkFZie+NA97pba3Bq3guhKQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47ptfyq84n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Jul 2025 12:27:33 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5689qGlE021561;
	Tue, 8 Jul 2025 12:27:32 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 47qectk2ve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Jul 2025 12:27:32 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 568CRVlu56754484
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 8 Jul 2025 12:27:31 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 47CA25805C;
	Tue,  8 Jul 2025 12:27:31 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 556C358054;
	Tue,  8 Jul 2025 12:27:25 +0000 (GMT)
Received: from [9.109.244.163] (unknown [9.109.244.163])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  8 Jul 2025 12:27:25 +0000 (GMT)
Message-ID: <51e56dcf-6a64-42d1-b488-7043f880026e@linux.ibm.com>
Date: Tue, 8 Jul 2025 17:57:23 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] block: use chunk_sectors when evaluating stacked
 atomic write limits
To: John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
        axboe@kernel.dk, cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org
References: <20250707131135.1572830-1-john.g.garry@oracle.com>
 <20250707131135.1572830-7-john.g.garry@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250707131135.1572830-7-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=crubk04i c=1 sm=1 tr=0 ts=686d0eb5 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=yJhl33u1EdvM2cd53HsA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: oFeuZO25s8jZhY9N7Q4_OwOi2QA0LlNs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA4MDEwMiBTYWx0ZWRfX9R+zUyptV1ib dvpjJ1NMO7XTm6M8VTrCdpuBTeYomqz3kec2VbCmalMuDWeMjXGDM1Ea865m1vzqCd4fSgenqdw Dg/m9c4T5haZvlwRC8/MJXLWvi+QRL2mTwEjyh+6hndAcz0lxOH4CiydXntm+fIuggviehN1wB6
 0xeqAJcAZ/daSQAAQYqWSYmaTpS2XgaLZfDyo5MG/S3pQ+MzXp2sbqXxKnLUkgiDwpKYkZltt7W 2lmN2aiosg4kuXiHKzBbxrv3aDCIL2U9LEAw99I4/qGpJ75FAnS741HCZFlTI5GucFq5djrT+U0 de3qYa1CTkA3ROi86knjPZpwcmDHhhAzC/Lp1Y7KeKlQnRnWCQL5wk5EZ1LI9jGAQeWKqUHjMxk
 wQo2HSmRgYvR9QQkuYKf3SD48nJR/ZmAOxeYEOqS/zKmi5nNsT3OwqLaus1B1WN0K2APTPek
X-Proofpoint-GUID: oFeuZO25s8jZhY9N7Q4_OwOi2QA0LlNs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-08_03,2025-07-07_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1011 impostorscore=0 malwarescore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507080102



On 7/7/25 6:41 PM, John Garry wrote:
> The atomic write unit max value is limited by any stacked device stripe
> size.
> 
> It is required that the atomic write unit is a power-of-2 factor of the
> stripe size.
> 
> Currently we use io_min limit to hold the stripe size, and check for a
> io_min <= SECTOR_SIZE when deciding if we have a striped stacked device.
> 
> Nilay reports that this causes a problem when the physical block size is
> greater than SECTOR_SIZE [0].
> 
> Furthermore, io_min may be mutated when stacking devices, and this makes
> it a poor candidate to hold the stripe size. Such an example (of when
> io_min may change) would be when the io_min is less than the physical
> block size.
> 
> Use chunk_sectors to hold the stripe size, which is more appropriate.
> 
> [0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  block/blk-settings.c | 58 ++++++++++++++++++++++++++------------------
>  1 file changed, 35 insertions(+), 23 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 761c6ccf5af7..3259cfac5d0d 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -597,41 +597,52 @@ static bool blk_stack_atomic_writes_boundary_head(struct queue_limits *t,
>  	return true;
>  }
>  
> -
> -/* Check stacking of first bottom device */
> -static bool blk_stack_atomic_writes_head(struct queue_limits *t,
> -				struct queue_limits *b)
> +static void blk_stack_atomic_writes_chunk_sectors(struct queue_limits *t)
>  {
> -	if (b->atomic_write_hw_boundary &&
> -	    !blk_stack_atomic_writes_boundary_head(t, b))
> -		return false;
> +	unsigned int chunk_sectors = t->chunk_sectors, chunk_bytes;
>  
> -	if (t->io_min <= SECTOR_SIZE) {
> -		/* No chunk sectors, so use bottom device values directly */
> -		t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
> -		t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
> -		t->atomic_write_hw_max = b->atomic_write_hw_max;
> -		return true;
> -	}
> +	if (!chunk_sectors)
> +		return;
> +
> +	/*
> +	 * If chunk sectors is so large that its value in bytes overflows
> +	 * UINT_MAX, then just shift it down so it definitely will fit.
> +	 * We don't support atomic writes of such a large size anyway.
> +	 */
> +	if ((unsigned long)chunk_sectors << SECTOR_SHIFT > UINT_MAX)
> +		chunk_bytes = chunk_sectors;
> +	else
> +		chunk_bytes = chunk_sectors << SECTOR_SHIFT;
>  

Can we use check_shl_overflow() here for checking overflow? Otherwise,
changes look good to me. I've also tested it using my NVMe disk which
supports up to 256kb of atomic writes. 

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Tested-by: Nilay Shroff <nilay@linux.ibm.com>

