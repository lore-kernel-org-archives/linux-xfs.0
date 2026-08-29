Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805BD35C180
	for <linux-xfs@vger.kernel.org>; Sat, 29 Aug 2026 15:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788017896; cv=none; b=fm7AcMdJeEUemi9TZ03T9QOl44vUtabG+m0qsGuoXjl5zzrmzM+LaNGLkEiTRoy8V4kqMt6T9+wI0l07jppWD4N5MgNGMc7MXtMHm4y+4i7AIkUt61nGwMU+ecw5Py5TNUrjVQ2Xu/G4bL0/+3YPM4ngpYOG3QSkpSEiXlXI15U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788017896; c=relaxed/simple;
	bh=xxpR0ksxkA/ONSsugSlrSih0kyNuN6ltaN0MKPNAGsA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HwM1/DYe1mtgQBImwnUvMXJt8AiTTPTCJvXPJ/KGCTw7BGGb/FGF9b+wSpAhO3rUlnZLUZo5COuHPGVb1n88UsFPeuT+qPbMB2oVa1NZ7MlzsH5l88g1P/dg/vATaz9t9o2FCPqiJXqQOIgjeJkblIr2CX3aWbhEK62GYggFiO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Gu2zFIuG; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=0ifOm1MR; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Gu2zFIuG";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="0ifOm1MR"
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TEetjb1322199
	for <linux-xfs@vger.kernel.org>; Sat, 29 Aug 2026 11:25:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=TFVW
	lDwfNWxgPSj86otvED5lH0a6QKBTMoQ7ChKGCcU=; b=Gu2zFIuGUDCk+rJ2VDBk
	70a9GXKIRmd3CKMeiyckWv/D5MP7Zgaj/CA+sovdSkrETK1IrJb2qFnGnQEaNT3S
	N9KtoDtS2aWLMgdaZS8EG79pcfDMQu06yKTxqcmPhJVJAftER9ykGtp1pbja1UeX
	kUFeO1YwKQdpDr1sZdsz5l4M5OOqmQkrZTmdrHduJ4FxpamhWS1IQq9E37/oh+3q
	nZtzyUcZ5SRVAnnPNjuAJxQT4FXqYOGakyKLjlrLX5KwZ+Imu1kdoq89hPFZ5bjm
	jEkOlYV+J6fGeVEAdtwq+7wZe5VJJ9mAqHAPx4qs90lyy6hcLcj/IAjQH5/0tLN2
	0w==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gbsppa489-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Sat, 29 Aug 2026 11:25:58 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52fb8f67601so26575571cf.3
        for <linux-xfs@vger.kernel.org>; Sat, 29 Aug 2026 08:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788017157; x=1788621957; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TFVWlDwfNWxgPSj86otvED5lH0a6QKBTMoQ7ChKGCcU=;
        b=0ifOm1MRHIokQoCLKKln9UwJX05fY5zGsha7JGzt1uRIj5LpHZaY208S+c6YLJrhmW
         7zrHiU5LzWrRkkA/u0CDLUIIUes1o41ewruui/mSKmFAscYE9P3IHGUVdfgsKp0ipRj5
         fdTKzjRzuzmVxu3M/5aRTmreeesVBV3CmhyG5O6whHEq7AXT0CPHEQASpMdpsBiVtTyz
         sgxEKXbRINQ9Aq2hb5ZWOFuMqQErL7V0DBSbyJ5peU6qQHMKBSu5Uz3+e49r/ygyzSP0
         ej37DLE+c3+tw4I8GQHTxKtbyvCqGVSAlHIHptqSklT3T7M6Jg8WVnu7DSs4MMF98xk1
         zkVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788017157; x=1788621957;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TFVWlDwfNWxgPSj86otvED5lH0a6QKBTMoQ7ChKGCcU=;
        b=a0sWfiXMEQKMl353oLWK3fJV9+toOW8XNmEsb1CyQp17Hu0Vrr7UycVgN9PfajgXv7
         LBCU2GwCPWExznnCh569dlFqgpbrBeqh7cmtd0ERXrmFdUxhROb3g3VYaqDRKQCZpggY
         VOxw1bwp3uvaaDnyoFwoQri/lH0TL9nqkJ0vnY1dlVF91NBdvg8ejXKnQRTi8R+rSFp9
         hy6dfmIybXzPSvrdxSHNATO8P9BZQPuBZwJ21jIOAl4/ZwxSdZ518tbf6swV6nzQy57L
         hcbOQtjSsaCP2u2KA0lRM4mxwZJZW9FWpmjVSWuDpbV2pKs3d5i6+TxdArnVweMFPxJE
         m/0Q==
X-Forwarded-Encrypted: i=1; AHgh+RoOyIQ5MYUAWUNTW+c1NH97kkqmZ1+k2MCpMqAXzbIg1o5dl9AqOuTx5l8KBxyj/nDCJ/0KTo40S6Q=@vger.kernel.org
X-Gm-Message-State: AFuF++mdX1nMcwILVtPWO13H2bEdTnA+Y3B6213T5ckhZT//30C1w+Go
	iSKkk6pXzlP6CVRRWrSG1pyKAD9zSQ9OMGcIwEbzpXdPbZOcIqvQ+2AhUDngX7vPGaoQ4bYz/B0
	sfHjEKOMDWbxEu7hVADMA8jk59MRUVnvMAf/IUkVKvBbLvsFrexuW4UP97Q==
X-Gm-Gg: AR+sD13E82QM22SAJ68klv+KHcBCLTkDBiO1NBryKhr0zRnRv2mrmkdXU/T5j6mfQCa
	YVVN5d76o3onFnjpkJqGS24u+921uq9Dln9q6VzKZu09//XHHdH7fKN8XrsihP0uhOS9V2onFqV
	+Da26Vo90V044AuHk/YRccdDr0zOELHmCd1SUWE89phmOBQuV5yoUf764v5OaM9sE7eOa8S1OI0
	N3fVZsTM6gvpWZT22oB3cqebw+zT9g8Q1A9rzZu48GMTX4JRY8y8HmBABNo+fj9nuu27Y+TlOK3
	FTTt8F0mIOutPsDkkxfI+oZvz+Frxpw67O0JR1twNFJsjdzaTweQ+WWwWRkW41z0wPx0REGhJdq
	bMjWWVUxizPDVssRmOnshzZfKCmVWE/qPq2taNjL9MFScFk8=
X-Received: by 2002:a05:622a:95:b0:519:8998:661b with SMTP id d75a77b69052e-52fb9640d64mr173116301cf.20.1788017157648;
        Sat, 29 Aug 2026 08:25:57 -0700 (PDT)
X-Received: by 2002:a05:622a:95:b0:519:8998:661b with SMTP id d75a77b69052e-52fb9640d64mr173115921cf.20.1788017157157;
        Sat, 29 Aug 2026 08:25:57 -0700 (PDT)
Received: from [192.168.0.175] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cca1ed292sm84339685e9.8.2026.08.29.08.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Aug 2026 08:25:56 -0700 (PDT)
Message-ID: <6672b30b-427f-45ed-a172-4c47a63d2c7c@columbia.edu>
Date: Sat, 29 Aug 2026 18:25:53 +0300
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/5] block: add task-context bio completion
 infrastructure
To: Barry Song <baohua@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,
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
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>,
        Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Hillf Danton <hdanton@sina.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-erofs@lists.ozlabs.org
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu>
 <CAGsJ_4wUvLoKGafR3U-ji1kUUaz6K_QdN6QxMT-apSaO5tXp0A@mail.gmail.com>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <CAGsJ_4wUvLoKGafR3U-ji1kUUaz6K_QdN6QxMT-apSaO5tXp0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: ylKS5msfNJLVG5eLP3dhY38JHbEqdJee
X-Authority-Analysis: v=2.4 cv=B6qJFutM c=1 sm=1 tr=0 ts=6a92fa06 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=bN2RZfqcuyHWyQBaeeoA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDEzMyBTYWx0ZWRfXzBRpGsKA/9Nx
 mm36puV3OK1Co7kgVPdDoHZOFTMsSLo7ehtj0vIdWigMnkR6F2I6r30WOpslqJyGNXJUMfKzwNa
 oQVME/w9bMjpZhEF/OzWkwF0PtdvTLd+uaL+nQbocp9SAS0wmhcw/C+tuyiJUbQKMb3kMWr3ZAn
 VStFTUKwy9tooDkaT0zOqLzG8t1j2R2tscAQnUdvWE6bu6AQLqwAnD7+gukHZIouli4CWQtrOX8
 QyOXtzgqAG2jWrcfvnn6MaKve/YgIIeHCIWeNKQ4G0GhAXrGWlIfY98Gd7uWphAPKBFetCgZNAV
 IEweuYPfOFnTOItldeUSUnHmedCl/jKwUlw1/47Z7/yZUwcgX1FWA8DXSYd6qBZgBcjBRVgDInd
 WVHP0Q1AiIKhzhDzj40PYc67BU+XWpy2vlXB8t17T2u6jzuvVn6NmasEYIT+0+rSoyxcHfN9LDA
 zpTyB9gdsk8+BocQFKw==
X-Proofpoint-GUID: ylKS5msfNJLVG5eLP3dhY38JHbEqdJee
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDEzMyBTYWx0ZWRfX5Au2bMEsZsM7
 8M1jFnaMDSs8XveEpfJgeFFBqqZWn3cyaKLMU9tEeCUeGIqu5AaHeKovIZ7lSddvniYIZhFRdAn
 YmrPYzuYdXlybTU9GwqbVBlvbsb0e+W0kJ+HaIiqU4Dr/eWbLsJe
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 malwarescore=0 impostorscore=10 clxscore=1015
 phishscore=0 bulkscore=10 priorityscore=1501 lowpriorityscore=10 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608290133

On 8/16/26 7:11 AM, Barry Song wrote:
> Hi Tal,
> 
> Thanks very much for the patch. I’m just a bit confused that
> folio_end_dropbehind() only requires in_task(), and nothing more.
> 
> void folio_end_dropbehind(struct folio *folio)
> {
>          if (!folio_test_dropbehind(folio))
>                  return;
> 
>          /*
>           * Hitting !in_task() should not happen off RWF_DONTCACHE writeback,
>           * but can happen if normal writeback just happens to find dirty folios
>           * that were created as part of uncached writeback, and that writeback
>           * would otherwise not need non-IRQ handling. Just skip the
>           * invalidation in that case.
>           */
>          if (in_task() && folio_trylock(folio)) {
>                  filemap_end_dropbehind(folio);
>                  folio_unlock(folio);
>          }
> }
> 
> But we’re applying a much stricter check with bio_in_atomic():
> 
> +static inline bool bio_in_atomic(void)
> +{
> +     if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
> +           return true;
> +     if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
> +           return true;
> +      return !preemptible();
> +}
> 
> I feel like something may be missing either in
> folio_end_dropbehind() itself or somewhere in the
> filesystem/block-device path.
> 
> Do you know why they don’t match each other?
> 
> Best Regards
> Barry
> 

Hi Barry,

Apologies for the delay.

As far as I can tell, the in_task() in folio_end_dropbehind() wasn't meant
to be a generic test for if it's safe to sleep, but rather filtered out the
known unsafe case of buffer_head writeback completing from IRQ context.
In contrast, the bio_in_atomic() check needs to be stricter since the bi_end_io()
callbacks could sleep or the callers could be holding locks, RCU, etc.

I see there's some more discussion about this at [1], but I suspect there are
other instances that are (incorrectly) using in_task() as a proxy for being able
to sleep (like f2fs_read_end_io(), but I haven't looked too closely at it).

Additionally, it probably only makes sense to use bio_in_atomic() when there's
some deferral path, since with CONFIG_PREEMPT_COUNT=n, it'll always return true.

Thanks,
Tal

[1]: https://lore.kernel.org/linux-fsdevel/20260829121335.3491374-1-qwjhust@gmail.com/T/
