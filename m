Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A5D3655E6
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 16:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786378225; cv=none; b=jIgZTnXzffO/oJwuzD98glepoD52Op+pxMYtpdPxZcoASGBhQI56waIP9vvTa6A4JZYCp0Ee6C/Cx+ogWQyI+FOkQsgmW5oT1laG2uGKP2ldIYP2/ZYwEVEAPdg9tyGoNS3vUGKDm1FiJMXvDQQGnFJFADIbkjj+7tgIR5zDo4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786378225; c=relaxed/simple;
	bh=/AF03rHuJDyQBfFPu4ugDlBCG/z+8RMKjZwI9veqS/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ABlBlDXsSdSaVIe8W95jOjsJv3uuG1nCHkyUDAjzufuc5TLmY7RCFBqP7eHttj+BDXvRAIYCY6gkETOdN1SeEC6rkK5/QJJfTgXZjclh/U52P5BBkHuDmxH7YaFcCudxBU8jn7w26k9rNn3nPeS321FA/WAgclDUNJm8upsblow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=CyN46gAF; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="CyN46gAF"
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AFd1pO3441685
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 12:10:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=f0bZ
	ditIahGukFZnD48c1dgtAdNiTQKz0eXUlzu/oaY=; b=CyN46gAFzGTv5sCQAiJ+
	xhJD7DYCrTeiGETf4yox+1+3CDtlrqNvkTFW4J4vobHmLbXUHDE3doFn2xz6glN6
	k3BaKUBMntJiRVVcyGVM+aPSYqFm+iaf0XYNNoNBeRDmY9JppLG3h/hrnHSqxXvv
	vjK8KVgvBMjsQt6iPYPncBt/4wLvSNnFasjiicrFClgJgyo8becIWZAI0ulxYnrR
	6gWJbEIwkZVX0gc0uqUhLZ6UiI8xM4a2dmU0T4jB029Z7GGdBlXVd/OkAW3bqRIn
	Cc8m/OyKwiMnlPkQ7RPRQxLQ1PMxJu4vRWd97Of20SU/QcoKr4fq6yE9zIqHq0a3
	1Q==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fxykwvg1u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 12:10:22 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c083f1818so22093711cf.0
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 09:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786378221; x=1786983021;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f0bZditIahGukFZnD48c1dgtAdNiTQKz0eXUlzu/oaY=;
        b=d93LFSm2GSxxZ422fc3xW77ZgoAKyDcr2zDRcpJzt++6eayQMXG1wSjGgyi6z9Qh/B
         tSKs0DUXqS0TGqjq1pAOg9HuYFRahBU5DLRR6dKbe04SIPZNj9AWDTdItHyDOM2jle15
         hg1rlU3NWd3xIIWD/uXUfD9m9GD54oX8V9aOnRoazBRqjSTgR39jDbK8cKli/1llHgpa
         /C0xEn1qDaA8XB8ud3yPRUTtWWtqmzEeNC9y6vL95Xnkgxnr4tkrJkLpvvrn3ExDxJ01
         BX7EJft0RAvx1/M8/ifLgs+R60EQtsJkURGAAKVxnXoxhWJyFfWAuRCR/J4vgivoibzY
         M32Q==
X-Forwarded-Encrypted: i=1; AHgh+RoXFYML2lA7ELbmeH95aSNU0xh7G8Sae4w0wxgmBYq6SW9ifEoUq1egj6DkKuc2374MtM4V3Ah8EV4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUYgmGTIUdczf+zbX30re0lbRYU9GA1vEPPtbzC7aZSrZ9WFpn
	io1G5iu3VIjc+sLMzrs0OfFzl59VAehPEOXf/U7nG3NArTYg5IQTQEZ/Yz5M74aJemi5/LzjZEd
	cae8wRqepz4PbE9K0rRitwjX80GLeQQnIrnvGQKeiNK2ucde3nvf1bbnMdA==
X-Gm-Gg: AR+sD11M5v+U2B2HUQlNB42vbT2dfB4bOJhHXSFfOSC9zxDrJv4+esd93BiYQJPhYge
	eoh4yXNQ4Mut2O7eLRmjnlnbLFK0js0hNpjBNGMOgfBtWDjhqypFy+pjgW4fFKpCnPR3anXNOvN
	rdxz26dbeNGRirduoL2cjlgT8DJ5Hoeh0p7qqXGygy14vkzulGNe8EJKcTnWxHJ5ZdFtrgOBJcz
	Oh5ImpuZXEoAv/x9t6IeKR15pjinQk4DdUMBT0MyqKI3dPXqp8xF1m4ytXjWaW5+oSdfLQvVzMq
	tDb3q84VgluFiANkfmilvy2ZDTOUdkhRtHz6IlfvskWkaTgDGrZU9HI4clwWjB/4eyqnlqGlEVe
	m00ZSyq9Wgkzp3xdEfCo6PJEX5YD6ZZ1XKigBMn9ZlxZfISXTYfTaCg==
X-Received: by 2002:ac8:7fc7:0:b0:519:89b6:78b4 with SMTP id d75a77b69052e-52d20a819bamr234404641cf.40.1786378221625;
        Mon, 10 Aug 2026 09:10:21 -0700 (PDT)
X-Received: by 2002:ac8:7fc7:0:b0:519:89b6:78b4 with SMTP id d75a77b69052e-52d20a819bamr234403791cf.40.1786378221085;
        Mon, 10 Aug 2026 09:10:21 -0700 (PDT)
Received: from [192.168.0.165] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997402a89bsm4159805e9.0.2026.08.10.09.10.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 09:10:19 -0700 (PDT)
Message-ID: <8eb00a03-d6c6-423e-9768-48fd2566f11d@columbia.edu>
Date: Mon, 10 Aug 2026 19:10:16 +0300
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RWF_DONTCACHE regression fix for xfs
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
 <annkDbhXBEeMoNVT@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <annkDbhXBEeMoNVT@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: co-ybwvnf4-9yIQhAlP2U8piFn3XbOER
X-Authority-Analysis: v=2.4 cv=S43pBosP c=1 sm=1 tr=0 ts=6a79f7ee cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=dys9yn6NND9hJ5TNHOUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEzOSBTYWx0ZWRfXwBKyVYkwThdq
 dTg+cr207+GJZNaD1fStaqkMep4bgc7T0NR7uabEHmqbvYFtfbEdGwMnbXavmh1JBEuoX1Gl/KS
 1gYwtlMHm8p8lo05CJMuti4YYfHP0xHll6IqQcsR3W4hKkONpq/4HQbl3eduT66PaBkQGh62DgS
 +FYVT3dMLu7GZzxfurwTh9ZmcVtp7hecbV/gaqtZEUHnQe4zF64amrBUPz0nYrIiSmWLm6e/Wp4
 iR92hBd/O0yyJBKvVKQvxNutkCFnOgTp1Fe8/mNilz5aCPHb97lXVbffHd0qi/iFL6e41c8wJoQ
 lpPY0H6TUXYQO7QmiZWjQk2rWNA8+0PbwDf+fT8K8AB/y9PVtuBUiFYT7mE5wer76dc3ixObabM
 TBHM6PcN/wecg8SBAW8gufS7DrwP53sYn28XpgXZ+G64liJfeKpx/Jw3mbdNVNx9LciCs6x+09d
 EGFe4tC6mXBUO+ciKpA==
X-Proofpoint-GUID: co-ybwvnf4-9yIQhAlP2U8piFn3XbOER
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEzOSBTYWx0ZWRfX12j0ToxCkdL1
 EhCzuN79VW2RO5oSinLKBrRyvVJCFqSWkInOreesdlC08Sa6qAaBToqQxQkha2lOsc/oZ0gkqh3
 3hjh+qL6rgMmZKcFt7GZxdHo8/0G09EXRc7awUbxPw1QF4oADzxq
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11871
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 adultscore=0 bulkscore=10 spamscore=0
 malwarescore=0 suspectscore=0 phishscore=0 lowpriorityscore=10
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100139

On 8/10/26 10:45 AM, Christoph Hellwig wrote:
> Below is Tal's suggested fixup for xfs with the whitespace damage fixeѕ.
> It should probably be attributed to Tal instead.  Can you handled it
> from here and send it to Jens with your signoff/authorship to avoid
> the performance regression in XFS?
> 

Yes, will do shortly. Thanks Christoph!

> From: Christoph Hellwig <hch@lst.de>
> Subject: xfs: avoid double deferrals for RWF_DONTCACHE writes
> 
> XFS already defers some writes to a workqueue when transactions are
> needed to process the I/O completion.  Disable the block layer bio
> task completion in this case to avoid a major performance drop.
> 
> Fixes: efbde6f9f449 ("iomap: use BIO_COMPLETE_IN_TASK for dropbehind writeback")
> ---
>   fs/xfs/xfs_aops.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index f73e26d9c9f9..059846a8d65c 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -372,10 +372,14 @@ xfs_writeback_submit(
>   	}
>   
>   	/*
> -	 * Send ioends that might require a transaction to the completion wq.
> +	 * Send ioends that might require a transaction to the completion wq,
> +	 * and disable the block layer task completion for them as there is no
> +	 * need to defer twice.
>   	 */
> -	if (xfs_ioend_needs_wq_completion(ioend))
> +	if (xfs_ioend_needs_wq_completion(ioend)) {
>   		ioend->io_bio.bi_end_io = xfs_end_bio;
> +		bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
> +	}
>   
>   	return iomap_ioend_writeback_submit(wpc, error);
>   }
> @@ -481,7 +485,14 @@ xfs_zoned_writeback_submit(
>   {
>   	struct iomap_ioend		*ioend = wpc->wb_ctx;
>   
> +	/*
> +	 * Defer all completions to our workqueue as all zoned writes require a
> +	 * transaction to be persisted.  This also means we never need the block
> +	 * layer in-task completion for a task context.
> +	 */
>   	ioend->io_bio.bi_end_io = xfs_end_bio;
> +	bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
> +
>   	if (error) {
>   		ioend->io_bio.bi_status = errno_to_blk_status(error);
>   		bio_endio(&ioend->io_bio);
> -- 
> 2.53.0
> 

