Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013AF3C1D56
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 23:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785542144; cv=none; b=FUWS0wgYsnqfEhQwtrnPo5goNkLhvl+Pqw28aYaukn1Mu3g2oLt/kYmaA0lRR5neDfbL8QkcMEp1TuQCE8MXpISJOfLaDvZ8cos5mrZCDYAl9WOMsu/PmRu1XmlpGfFNsZveIryrS2z5Q9b0ZE3xc4vMrC15xPH3YvI3nJd4AtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785542144; c=relaxed/simple;
	bh=wG5D40/Lu2nFYK2vM4/wbzyQ/E5JdLxxUYwVq3fVHcM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dSs1nSMKm9rkkLM/GiEbCXU70t+MMOrl8f/sIye+GKjj6A+ruAIGNZDBaOXRaA4lRB8X6bwkq/iiiHohSqTo4xmLMqDJIBiTNguuZ0JH637Dzwvz260T/b3Q6qMgS+Mg2Z68vMmJgJqsvx90TI+KsSmGL5p9V3TuH+RPDTDRl3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Uo15toe0; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Uo15toe0"
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VMb7lQ3083039
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 19:55:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=KPIA
	GymP6/Pepnye/+rZrmO39/Nbpf2QPPAXtg/RPwQ=; b=Uo15toe0rPDAPWwZwVeJ
	n4E2aKPhzCtlbJaIPoOEk9oRKi29yWUd6bKSiKw2/UEDTT8IEoVnM0DWGZyllyTD
	40GpyfJ7ynehv56/EO+/jPUwA4CByxejxRy47r6xIde4zro2qbznQsk1f3dywHQu
	wWe/OeeuDrb/CAZQvA482658TGeu20X/PI6Kw1A+xglVLpQoL80+fmUhRsCQSdex
	hBfukncjUKNjTuWp4rZ1AdX9RDFeDZK1825QXT+td5WsnXaq10PJ+COGZwtnliH8
	5iqQ8kshUmIgCn4Ssedi1QZ6CFkegXN0zS0YJNWRRYNyK7IbH/AyMNUtzTFSMG47
	Gg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fs3590syf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 19:55:41 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5276aa86d00so15908111cf.2
        for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 16:55:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785542140; x=1786146940;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KPIAGymP6/Pepnye/+rZrmO39/Nbpf2QPPAXtg/RPwQ=;
        b=jupJvkHpUAy1E9dAPlkVc5dRs7xOWvK6shg3hPap/ldkuWeQ9uQZeCc2ohkOzhayLu
         M6KmsPp+TQFAPZGg8A/54uPUrWHOQmVX9JbtRnEHKY5dvBC2IcoCttBa5TJON4H1Hzhc
         D5AWFuxBysG52eaQX9FiYyRhZ9ok0vWYhyC6cHNBeHQ6NhL3rwq66CGDLVrBiiv/dnpZ
         WDOUDcdfaEO7IKc8YfAW2WqqtXkz6+B/34crVfjg9N4+OoGw7zQLEH6lyaC+nBSPao3R
         RMiIggpFSK1XFaUltngpfVyqvt9DIG4uwoYwLdI3MFe71OG1QYB6wJiOK3hGaZz05oSm
         cEFQ==
X-Forwarded-Encrypted: i=1; AHgh+RruRdOsdp0qxRc7EREICvTopMX6F1FheRgcj1q/Bo641pXgDdpmiH7e2baibe4oyiLyMvfSKSmUpLo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyELBbu1ZRIyzKH8XCuZvHE3LHJIDkf+FcDG0JCGbPX0JV4Pz9z
	exCgLveE16uby7BSKe38gMwvYuQ6WAZ8wyBcqxBnqbsXjACYP9Z2bJXyOCXx2FxjoOmTIC8HxUt
	96JVOexiQrp0lN80YGG3N9GxmvnPDUg/LyRzNN3I0NMtPES2A3D7rW5/rqQ==
X-Gm-Gg: AR+sD10XstRMg1TiCHiOdsjXGwwc9GeMHE9VtxH7SRCrHLAa1CKcvdDD9g4urLcYfNn
	kjH1Uxel4aWwRh8tG6PpMapTvdxrHFxatHQyMa7VecSl41FvVcRyUnKd5O37qdUnd4PaSP8HW5n
	Je+bXMypqXcyghPxFra9r6ziUl837DWMtfeujh1Jrdrhgof8B37S7vLNwigowk5/gYm4itzckST
	R7h7YFCTqdjDyULI6y38nsWUHKTj2RsO+Dxn1I0NGrwqC8v88j6YRAJylbKWblMciHDr/cyedY6
	p6vN50lBNm5lxC8UwKgUCgQI4JiZm3bvmHSnc0YAo/PO2tTcuIHdM9U4i8fvixrAypdwgQ4Yk/p
	H9ZhWQwzzQr1XZQ==
X-Received: by 2002:a05:622a:2618:b0:51a:8f3a:13b9 with SMTP id d75a77b69052e-52b566b184dmr44464621cf.16.1785542140295;
        Fri, 31 Jul 2026 16:55:40 -0700 (PDT)
X-Received: by 2002:a05:622a:2618:b0:51a:8f3a:13b9 with SMTP id d75a77b69052e-52b566b184dmr44464271cf.16.1785542139795;
        Fri, 31 Jul 2026 16:55:39 -0700 (PDT)
Received: from [10.1.46.221] ([217.192.152.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807b8d04fsm6127465e9.3.2026.07.31.16.55.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 16:55:38 -0700 (PDT)
Message-ID: <adf05cdf-0c73-4cf1-b1f7-9d063c891eaf@columbia.edu>
Date: Sat, 1 Aug 2026 01:55:36 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/5] block: enable RWF_DONTCACHE for block devices
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
        Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale
 <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Hillf Danton <hdanton@sina.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
        Christoph Hellwig <hch@lst.de>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-5-3e8e6850068d@columbia.edu>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260730-blk-dontcache-v7-5-3e8e6850068d@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: Z3El0VkJ8zdfUi-O92bgAhjGemLoKxEW
X-Authority-Analysis: v=2.4 cv=XMAAjwhE c=1 sm=1 tr=0 ts=6a6d35fd cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=NgQitlhRlW+MZLNskBD3Jw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=c92rfblmAAAA:8 a=jDzJYAX_DjbP0Cb_QUIA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDE3NyBTYWx0ZWRfXwOP0ehI1MaWn
 4BXkxCD6FmPFBRekeGbFcxyTCNGUAlZ4td5V41C4sl0nErsEs97GyM+URRMiYOmLvcoz1k1kcv/
 ad5rmMMlCueP3lfB6/5w6avF82Ht/PLtH1M6TA9ev3MRfcRKkaXN+G6ayEx4ejoF4LcIDePjj6+
 co9GVoxtkPWHqxhWJLWJEOZQxsFAoiomz3d9UiIxJX/AKks19wpu3hX9MHzteTcB4uaCnGPPJ/k
 tdFHWLhXRO5HpQ/UarByeKG/xgdiEFC2CiIIEpQvynss+K70oU9kM1L1NFVFQOWmnS/E2BYHGRu
 KxeT4kxbZPbkoA4qwOzuycWfiJT1kFSq8mIzMUIGL57ug9BQatyXXVciGWnMefyGIS2tSRjLpv8
 74M1TJbFgT3bIqSZU5lfflk4roXFfPSM8vRLtr3j4d4338GnQf7scIJJNIEIUBVoPHMV8AvrodI
 0u0QQbx4uvZpjdjLm1w==
X-Proofpoint-GUID: Z3El0VkJ8zdfUi-O92bgAhjGemLoKxEW
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDE3NyBTYWx0ZWRfX970n1tGccfNX
 +sAsExLFvMVb6NlTTSvueP7j9qzAUZN2f+gvuPeLu97TNo5jHyaY87G7tTLoSpUqAJU2AFUrQUC
 mZXzIri+H9msEbxS9GW2dNahBwUbpMH10pcEGdpOLBcVIszmup7j
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11861
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=10 priorityscore=1501 impostorscore=10
 lowpriorityscore=10 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607310177

On 7/30/26 2:57 AM, Tal Zussman wrote:
> Block device buffered reads and writes already pass through
> filemap_read() and iomap_file_buffered_write() respectively, both of
> which handle IOCB_DONTCACHE. Enable RWF_DONTCACHE for block device files
> by setting FOP_DONTCACHE in def_blk_fops.
> 
> For CONFIG_BUFFER_HEAD=y, writeback goes through buffer_head's
> __bh_submit() which sets BIO_COMPLETE_IN_TASK on dropbehind folios. For
> CONFIG_BUFFER_HEAD=n, writeback goes through iomap which handles it via
> BIO_COMPLETE_IN_TASK on the ioend bio.
> 
> This support is useful for databases that operate on raw block devices,
> among other userspace applications.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  block/fops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index 15783a6180de..8b39c53b6393 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -941,7 +941,7 @@ const struct file_operations def_blk_fops = {
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= blkdev_fallocate,
>  	.uring_cmd	= blkdev_uring_cmd,
> -	.fop_flags	= FOP_BUFFER_RASYNC,
> +	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
>  };
>  
>  static __init int blkdev_init(void)
> 

It looks like Sashiko found a couple pre-existing issues in this file [1].
I've reproduced the first and looking into the second. Will send patches
once confirmed.

(FWIW the other issues Sashiko reported seem overblown.)

[1]: https://sashiko.dev/#/patchset/20260730-blk-dontcache-v7-0-3e8e6850068d%40columbia.edu?part=5
