Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD563A7194
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 20:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785443950; cv=none; b=nQT0tQmd3vQ9WRTGhu6SOkmUgRwbljBEsFROrPyHwXDLgQaThM23nrvVhJ0Pwj+Zu9j3r8P6kmTy6wjrmJLP7oic7r1l4XZo5aMOebDGj6RkoW9qxlAAus0r5qCVXmhSGncLxb7I3fheZ2BK//1M5MESv5Swl/3rxDkM7FeQhx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785443950; c=relaxed/simple;
	bh=G/vRUOm8L2XZ3XeP9CnNcbxvMqQWrQcmwiBXs9OOzgw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eNCGWZ4T7fVXqgZZFUOfg/WNoYI+NF5MThOagcoEJ2IN/JkNEO1P7Yv+R+CSCNBEtOAP9xshDeAI2DzF4kUFPvjUV6NnjH3Ry/OmoStEwdCGeB9qFnSSKaKodKtTdc4XUZ+0PQSatIB7aWUccSkEvt7slwP8LWLdh3BG08Bv+0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=WQ7HnPHx; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="WQ7HnPHx"
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UKY2Tw3797805
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 16:39:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=T8e8
	k+5EzrTp13lWK2mQytn9hp17i2RRCkab9M9He5A=; b=WQ7HnPHxqZL+jR81XllF
	JTKnzPju6U39UyyWhhTcphUfZ+xAg2wqUa791ebQ1v5NhvW0IuF//dLqtiOJvHMi
	fmyKW7M+TGXkdSy8yhCZpU5HL/IpFm8hExjB6Zd8ZTnCZBp0FfiM/4VmQMN3Nyjj
	wy9qKWJdLe5TFEiS34dauGmL0aNhbdETHjmjDl6ehafIPC0BA5I6nCfjcLjVALJk
	9EAViui9QVuK3SVhaPP15FKa4Vxbk1NUe/8NEuykcAZ7ZyTVvPKKcmrPB5R0nGP7
	1xqHFPEmX+ojBlGjFW+JqGfOPxg4M0VGW9uE0F4ziDhKljsql7UvZhC9GapkEQy5
	vw==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4frd6vg9we-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 16:39:06 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51a8db414c7so2965601cf.0
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 13:39:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785443945; x=1786048745;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T8e8k+5EzrTp13lWK2mQytn9hp17i2RRCkab9M9He5A=;
        b=ZHCU8EvXO+ojk7mGdIACVGzMXAwE1OpR3LPZz/HnfrQ6Gbs5uufB/D8FHfyKxZpg9t
         4jJJIptj+kNHmolPcDkSi9aKDpgo1DchYoukLJfZdAN7NqfWqy5GJDkgRsLMVPhBod0L
         /DlYeh52TM8djYg6zG6b3Y2DqDEyqDJEpkEGny0sMVvfIch7QTVqUiwtGYLn1YLJwqnq
         IWN6EyhK7CrdkeynlOuckrVzcIKVz3HRT8mXpeDnbK7yECKSE0DgUjC9oYO03ePwU2dr
         RpWu47rFPmjSAP/fKSOTtAcZII9TgBaEUlCEIZ6k+efdkxL1ZsELsNVbEX/QUL9cPvzA
         mVFg==
X-Forwarded-Encrypted: i=1; AHgh+RqQYY9RGsSs80+zVmq1Iz1UVwSKBdt5/fUMf/3iEyV6rzzU6R6oToBc/Pj3bz4JKfssFTpF35LeD28=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTF9OqlZEBlznBkwJvLcFyn5Ei1iJgDXmXXNeUm8LUvDHx+fbg
	ozT+Y7yyELGDVIeMagzfSmJtAu+aoJRsmrkmYH6nuhnWKRjbGvMINor9ddOfAJhcP87DsatW6yk
	oCTjTVoE2ZLpPxFWKddJVfnDu6qzAWy+89ZBkxdquLulkt3oSKUAjjUEyQQ==
X-Gm-Gg: AR+sD13X8Mi8KEAXGB3ahHogp2zUidb/TFuTkJyjoDu1VoUfKLjFiKkhufP4ZPOrwNw
	wbcGx9HOPNDlLidp2xOm2xIfYQVAmEcnD8bIaSi807Te4TuYeZoxqnUMO2YxmUeOvW0RCf/bUsL
	4qQABggLwyyt2iY0L8IbLOkHC/bR0BkYxzgT8tpEgoOcMCN+T8XSePo0AdCA3j9R9lCdz+hR4AK
	zscAeoBKJWuqHbOf1rzhLwYqlXgjrd5aXkDXs4ua/6/qUBaDO2NqiK8YsmaUvODsEVulnoEvsPN
	UugxPdRzYxSDPLb8aeMHbL/SjycNHsIctPH1dxproYHDy5xH/rbg+s0t0nYRGNaW89+4TiP/CBj
	MVehW06cpHuu2mJ4=
X-Received: by 2002:a05:622a:3d0:b0:51c:7b11:41a9 with SMTP id d75a77b69052e-52b38757e60mr44335411cf.86.1785443945523;
        Thu, 30 Jul 2026 13:39:05 -0700 (PDT)
X-Received: by 2002:a05:622a:3d0:b0:51c:7b11:41a9 with SMTP id d75a77b69052e-52b38757e60mr44335011cf.86.1785443945082;
        Thu, 30 Jul 2026 13:39:05 -0700 (PDT)
Received: from [10.206.71.35] ([129.236.231.134])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-529e2d8251asm48127221cf.19.2026.07.30.13.39.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 13:39:04 -0700 (PDT)
Message-ID: <15506dc8-e5b8-4fa8-a85f-912a92edb83f@columbia.edu>
Date: Thu, 30 Jul 2026 16:39:03 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/5] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
        Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>,
        Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Hillf Danton <hdanton@sina.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
        Christoph Hellwig <hch@lst.de>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-3-3e8e6850068d@columbia.edu>
 <amsHrVCJnuXzeGG1@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <amsHrVCJnuXzeGG1@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: HpengTmWPH4nYu0zV6bckBWbn3dhzHNB
X-Proofpoint-ORIG-GUID: HpengTmWPH4nYu0zV6bckBWbn3dhzHNB
X-Authority-Analysis: v=2.4 cv=ffudDUQF c=1 sm=1 tr=0 ts=6a6bb66a cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=Mx06nvryMUGB95QVe9e23A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=qsXxR-sLYAu0WPx4Yu8A:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDE0OSBTYWx0ZWRfXyul6aQs31ct6
 LoPiE6CGuREkCVeCmQdU7BO5nvB0Gd7e4zoq/dVW2bw53sdZxAgQWpI6yptBmkli/UAfZxN1j6K
 L744mNPSj4oKjPZZTE+MlpMaove3+kEgcKz73O2ClwO1TatJoFmHeb28qAk1TWXfp/ux7mHqtZ2
 v6YUz74fekR+gv6SExmp73dRv7SPFBmkFTKJcg+0yrBarWwRGVZTK8S64iOUM/B/GQhHb9vHZKk
 hPxt+PK4Sq3GPtQtz6zOpUq+hImGmp5O36WPFSvKsRqI4fvulg16aEQiO4d+v5wKKFmSdeqLClq
 4VSYSgxGBt6bjeHcV/OXNN4zA5OiyRh3megcuCX7Pdp9piITr7XTbV+iKX1SYfQ5qCUK3W1FWIw
 Z4QYcWDrckVO4UOUtIIQNpRqFKDpFC7rndWOMrVo5NByr8AbsQsuYNHGRZMZqJGr9t6xTvCDIup
 KSe7uTtVZ7xc2tlZayg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDE0OSBTYWx0ZWRfX6oTKUHKQZeKP
 rCt8v3ZeH7BZ/TxJ+uKckGGc6DMkUGNH5v77qKewfeKPtMe8h3izxST71SMWlsry/uA6ClvFjaV
 zryueMzHLkfr0wr4lRm2og9XFj8mbf8hxXF29lCcgAxbqxIzBN6+
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11860
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=10 phishscore=0 bulkscore=10 adultscore=0
 malwarescore=0 impostorscore=10 priorityscore=1501 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300149

On 7/30/26 4:13 AM, Christoph Hellwig wrote:
> On Thu, Jul 30, 2026 at 02:57:53AM -0400, Tal Zussman wrote:
>> Set BIO_COMPLETE_IN_TASK on iomap writeback bios when a dropbehind folio
>> is added. This ensures that bi_end_io runs in task context, where
>> folio_end_dropbehind() can safely invalidate folios.
>> 
>> With the bio layer now handling task-context deferral generically,
>> IOMAP_IOEND_DONTCACHE is no longer needed, as XFS no longer needs to
>> route DONTCACHE ioends through its completion workqueue. Remove the flag
>> and its NOMERGE entry.
>> 
>> Without the NOMERGE, regular I/Os that get merged with a dropbehind
>> folio will also have their completion deferred to task context.
>> 
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> 
> This seems to be missing the bug fix you identified for the double
> deferral?

Sorry, I misunderstood and assumed you'd take care of it in a follow-up.
I'll adjust it as below and send v8.

> I although thought a bit how that could be done cleaner, see below:
> 
>>  		ioend_flags |= IOMAP_IOEND_SHARED;
>> -	if (folio_test_dropbehind(folio))
>> -		ioend_flags |= IOMAP_IOEND_DONTCACHE;
> 
> I'd keep this flag.
> 
>>  	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
>>  		ioend_flags |= IOMAP_IOEND_BOUNDARY;
>>  
>> @@ -256,6 +254,9 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
>>  	if (!bio_add_folio(&ioend->io_bio, folio, map_len, poff))
>>  		goto new_ioend;
>>  
>> +	if (folio_test_dropbehind(folio))
>> +		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
> 
> And move setting the flag to iomap_ioend_writeback_submit, and only
> for the case where no io_bio.bi_end_io is already assigned.
> 

To confirm, this would only work because XFS provides its own task context
and is the only consumer of iomap that sets its own io_bio.bi_end_io.
If another filesystem set it and didn't provide task context, this would
break, right? I can add a comment about this requirement, but I want to
confirm the intent, as it feels a little fragile as-is.

