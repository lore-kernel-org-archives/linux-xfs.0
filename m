Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42ECB4A0C;
	Wed, 15 Jul 2026 06:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784096413; cv=none; b=Cl/6gcLHHsdXs0Bv2JYYEE57b4/nencI/H6TUDI7eit3wbNfOugsZc92rRYRNkg2JrPSpH30At4d7Fj7NCdQwENRdz3AQXxIlpXGbnWiZ0ApR+c30PdOrKIdiXaEMtZ9u9nilUw9PHDwiV9YUiJ40MYj6HxdyFCT0Ee0W9JzbsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784096413; c=relaxed/simple;
	bh=aUhsp1/JUfR3inEAVYboOMvwzbgaMrcbYCfaKb116TI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ugzg7vtmsWMAMi9vgcTfEOcnR6cwPTobdGSS2jPZjAeuZXrWrsos95fFDEH4KCHvl0lhqzsfUYmIwI4G3fTVzwO1htepSWvTBL7Zd8OQ78zW2UdGqGpNNYzDmMQuWsAWdNhcFBwWd1G0IRLr41liXi4tM7uSXcWms0fzqFz6tMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SayjXZfX; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SayjXZfX"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66F4BmfB3207170;
	Wed, 15 Jul 2026 06:14:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=H2bGZ44Al6jv4eaNG5eCZV4NISryMf
	k+uQ0GXE9Yjgc=; b=SayjXZfXGW0YLaNnQ47lw3Id6Nb9y1zA8AyrzXXYJ7LOyL
	qTCGXrbDz0EcpDPjlE96fx2jenNGdgvqJP6fE6sMxJ1nEahVyFM5duuTx53irAI1
	9vEW7DBVUQBdNf4w0TL1hehxKRXc1Ea8XtlkBnsI8Stca26XVdt7+fAD4RQoRlCn
	4Fg9Kctv1QvhgP3IjbxsadjcmqCTOq0AiSyeCDlk28PcKG+sEe7qeYgN4i+b4t3q
	VZmBUtn2xqbAAVgYALCQMnzLrd8FwPD7Ww/jpOuGf6T7LyT1rWab80t4jJi1iUNj
	UUNm8zDpymJpBB7cOjc3iddqyv3calMxXwunppyA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fbexws7y9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jul 2026 06:14:28 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66F64bXV007923;
	Wed, 15 Jul 2026 06:14:27 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fc15jxdc4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jul 2026 06:14:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66F6EPfO15663550
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jul 2026 06:14:25 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D86E2005A;
	Wed, 15 Jul 2026 06:14:25 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B82220040;
	Wed, 15 Jul 2026 06:14:22 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.30.16])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 15 Jul 2026 06:14:22 +0000 (GMT)
Date: Wed, 15 Jul 2026 11:44:19 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org,
        hch@infradead.org, joannelkoong@gmail.com, yi.zhang@huawei.com,
        yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
        yukuai@fnnas.com
Subject: Re: [PATCH] iomap: prevent ioend merge when io_private differs
Message-ID: <alclO6RSOoYUjP15@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260713074206.1768006-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713074206.1768006-1-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: nWmJdpKWyS3GNS0hz-2Ze4x50OXRP8ia
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE1MDA1NyBTYWx0ZWRfX1HbG+LyFL4W6
 GmOnKqpCMS/1D34X8K1KrWSdb9aUCQB+x9h0eQjyyJ0X2DXYB6nWTvTduVPONeApp3mk9BWvtDP
 K0JdVm9DSs4QgsePLXpLQWGqAROWqtwwIuUkFhCXfP3BptPtfYU5/SMyrYKamaGBI3J8woQ/FHK
 SoAvSW+H+ol9aV8EVrXRbLoqQzSIDrhcz/lAG84YnYlZiFb4F7SOhOOSxW+ta5llp+1cHKDcF7Q
 SQF2JPWmEoRpxPFQW4pwjVLnvTzJRCRxs1oONazpoN4h1bcbyrh+yKl1iwQwyy5tvD54m9OIKhH
 FPO+VQ52DTtjyS3bq5eOCeVPtGQV/NovE/Kv6tTPrMFLDWIbBrlTELc4hWqAP7o5F8te1QBOGMr
 QAyIdGWePVeQszy7x+Ux6T7Ccm6fVenMqdt4HZ9+xYc86k15BJTXRKRjrp9HC825wK/01nK3UPw
 +UAGCQ3RUvvHwJSRXMA==
X-Authority-Analysis: v=2.4 cv=XJoAjwhE c=1 sm=1 tr=0 ts=6a572544 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=AiHppB-aAAAA:8 a=i0EeH86SAAAA:8 a=VnNF1IyMAAAA:8 a=h1T4UPuZGLNwIgsweXQA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: NheAKXE8VSjVfLZcOi5XsDMDg0mYxhAC
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE1MDA1NyBTYWx0ZWRfX+u6RQX4/CNQY
 22kGY8BI10lsNaHU3B7tNSmffiCRazWZmCkzQXqqiY16/D2qzlqSDkKfH0nblrKNYbvjjyPrRTH
 iBZgX8gOGydwOmN4jJyzoXhxsIajWN0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-15_02,2026-07-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 clxscore=1011 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607150057

On Mon, Jul 13, 2026 at 03:42:06PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Different io_private values indicate distinct completion contexts that
> must not be merged together, as this could leak or corrupt the private
> data associated with each ioend.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good Yi, feel free to add

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

> ---
> This is one more change for the ext4 conversion.
> Disscussion Link:
>  https://lore.kernel.org/linux-ext4/81f4c0ec-1d80-4987-b31e-4e9ecd394c63@huaweicloud.com/
> 
>  fs/iomap/ioend.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index acf3cf98b23a..ba59570c0926 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -380,6 +380,8 @@ static bool iomap_ioend_can_merge(struct iomap_ioend *ioend,
>  
>  	if (ioend->io_bio.bi_status != next->io_bio.bi_status)
>  		return false;
> +	if (ioend->io_private != next->io_private)
> +		return false;
>  	if (next->io_flags & IOMAP_IOEND_BOUNDARY)
>  		return false;
>  	if ((ioend->io_flags & IOMAP_IOEND_NOMERGE_FLAGS) !=
> -- 
> 2.52.0
> 
