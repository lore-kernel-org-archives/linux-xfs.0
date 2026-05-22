Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A895F82866
	for <linux-xfs@vger.kernel.org>; Fri, 22 May 2026 23:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779491693; cv=none; b=M+obNstka7eZonA5tqQ8EVeyy1yaJbhibU/a+hl2a0a3KzJlUaTAYOlaH5ytDguZ/pLAyQmlI4MfcO71yQ/d2OFXfDCV+L+8o6v0yVY4xn+H2PHkeRuHK0jCovUPVjSCc4HiqyPw0/+76O43vmxbz7YBr9PRlyFiT4uUvQlISnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779491693; c=relaxed/simple;
	bh=gV53TwSs0drt5X5gnSBlHKrw6+HA0vOx7vN5OP4e850=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nDREUyVLfd1YxXA63GWwU8xGcqjmGxm2LxIrh5ZS5s4Owc44HZ0AboX+JCXGbzOC/9TiRvdHIjsSYyvh4BeXuqGIEPMgEeUg4eDmiCc/EAbsNfHDxpack6twRR0vHrxoh7V8TAkeF7xYvVlzyWkYEJvkxfhYdjryo0HZkz/K9Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=G2A9IOS3; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="G2A9IOS3"
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MMRkR1920950
	for <linux-xfs@vger.kernel.org>; Fri, 22 May 2026 19:14:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=SCJZ
	IS3EJwvEDcATBWIFn6gHp7ruxYI8VCEk1vbgm7Y=; b=G2A9IOS3JesynR/UdOCn
	/ut7BaIFp+bYt3cWcBDa1+1qX107hdOZAXsxXWg9TXcFIIQbTqVvqIeRJL3bUjRB
	UDu7592o6g/OwynE+EnnlBOTkWS2ZjX9GmRuW1agJFz/DlTmacfQAt/E5dOs6kpg
	XYQYlsbSRI5JZ9+o7MhW637PGbZF9haOkuwD+34B9dN4iOrRO418PwB5gjKphlWD
	4hY51YdLNL2I/qkxN9JZKz9Pq7doj2Mn4gI9amxgvsz+E5/mYktzg2FkrFBroOJp
	8rjK6HV2y0PoqI+nzlXQ/e7TXg02cUei9ufFo3UQVCp84CjljxoEdHozHaD8/A2K
	ew==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4easvr30f1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Fri, 22 May 2026 19:14:49 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-90ffa709073so1762234385a.1
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2026 16:14:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779491689; x=1780096489;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SCJZIS3EJwvEDcATBWIFn6gHp7ruxYI8VCEk1vbgm7Y=;
        b=EfFkhvgv2i0X7RD7ZoJeUr5x4S9NAtntbf1RBYw7zqG5p2dSRXv/F0rwnuEmUGeFkk
         FRHK0k/TFdTuc5SnZckdR5zQSSJGfPYCcwVvZrYq6biIpy43wV2ymDllaH6gpPTwulRw
         OYrcT1WBt7GNq3LL5erm6RctFGkkVbUSyLcve7GG1hxunBVUG3CNQ51IbVY3t2Ih5GxY
         TunWL8DCL47q16VdROJwjCBD1CuylELooaQYOs7eozdPCMFblaprx22qL4I0N69p+SVe
         UtidZxPT1ZQ7npCnDJMHu706h4WIcuu+/JwO/PvZS1+s2rdN/YICk1GqYfXQSsaWptfq
         0xpg==
X-Forwarded-Encrypted: i=1; AFNElJ/ZuNjl4psyobJKdri6vMzBnn9ohD7oSx6VUwKRK8N672J6u6bZuNr0V4Ke026B4UL4UbDpJBqEYN8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyH90VMHFDrs5i7LSvHbIoGTt87gZh6eIVqeXa4S/Pqi9+alIH+
	DjeyI7YhzIlNtvdxtPWAlLr0queCKVxtdOD7dTyuSnq7zC1CfREgSMQV5nbLzo0HDBdo5MK6zGj
	4g6K2iCyxoRxthiZdv95cQrKUpEkf0I/cpNRwX7VB5qRVgJlnkdc3hlFMhw==
X-Gm-Gg: Acq92OFBOAqMYezVrnR6uOoBar/rD5/6KRPctDXja2CAsvCFnaNwP8n3BxQp7gOlJua
	3LkLV1vfVcIPqnW4hcZFR/oIwiA+mdu6bFn1h3g13xQhuQYsOnWHcJOLVU7fzs9NeHt8v2KID0p
	3uqfElRNQXVFQMgnJ4sGPGS2bmnaA2jJZlAKNHPtEEVD+33AFNzJFIM7pjMHwwFIvIFvCfwxPMo
	AIRXyCpwXtEHSKBcvqwpC0p0/L24AQDX4k3frjVfSxz+yuJJIbG4XT0vXoj2D4mquQawWt9yX56
	Yf57FSaQv7YjOzay8HyWH5KXXd2X/qVeZBBCnvbKvhQkJQ8cknbevOe5njAbQlpHl4s7OK89ZhK
	/cfCNKer5Jg5xzToTzkdq2zjxyCNcSFbxPOunMfZHYtiTvS7QQ+8vw1omUqk5bWN7puKZ5XZYn7
	g=
X-Received: by 2002:a05:620a:2909:b0:8f2:c47b:962e with SMTP id af79cd13be357-914b49f5399mr897288885a.49.1779491688925;
        Fri, 22 May 2026 16:14:48 -0700 (PDT)
X-Received: by 2002:a05:620a:2909:b0:8f2:c47b:962e with SMTP id af79cd13be357-914b49f5399mr897283585a.49.1779491688439;
        Fri, 22 May 2026 16:14:48 -0700 (PDT)
Received: from [10.207.65.224] (nat-128-59-177-214.net.columbia.edu. [128.59.177.214])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914bb9f4689sm249676485a.38.2026.05.22.16.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 16:14:47 -0700 (PDT)
Message-ID: <d98a35c1-882b-4752-a2c7-378872fc97a3@columbia.edu>
Date: Fri, 22 May 2026 19:14:46 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/4] buffer: add dropbehind writeback support
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-3-782e2fa7477b@columbia.edu>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260514-blk-dontcache-v6-3-782e2fa7477b@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: VH7TWPahIIclqskuMmpkBJgnsg0BM9hg
X-Proofpoint-GUID: VH7TWPahIIclqskuMmpkBJgnsg0BM9hg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDIzMiBTYWx0ZWRfXwqbD1jNP4Dnc
 xeUTZXCaWxoUkreJkFZQlpbj3oefFV7eweXP0BGTfgWFgV+VaPKFDe20pgBjWi7MhuXsO/EiqGu
 qHDvaYLOvgPPj0+ZktHHklvks85Tk+8EHOVLTy/gI2CHq1w98scpkOXaeOtAfX1KxYWF9HHwmRA
 7PR2bJsTiIm3FsPAWvUNRVbK4hnV6++9ixjR77W5LJj9BC53nYYX0DhuOmb7YH+fk9rr6oYEXlz
 6qDV9n33zB89jNAlhJedLEp4IMoyyAd5LJyGoc8GoHbFMLRG+27ovTbqXVDgyCdXw25P19c/iwM
 6CPPo8Qu3+64qttAQ88EkPFbJnUbY+0W4O0UI3Sc0bJJr252JPFPW74wsykDx0b9VC2tlcEq70l
 f8gh/oxLlXqzRdkQ7ouyUbpISjC9Jq5WlS+y19u+j/HxTD3pX2ha0ZEeuYgCXmTI0XSo66SCo/G
 04ca4wgAiOACs6ciO2Q==
X-Authority-Analysis: v=2.4 cv=D8t37PRj c=1 sm=1 tr=0 ts=6a10e369 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=n4JpGxNP30DHW88kdRRHAg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=c92rfblmAAAA:8 a=lIN9f26y6YkxF9qERjMA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11794
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 suspectscore=0 malwarescore=0 phishscore=0
 bulkscore=10 spamscore=0 adultscore=0 lowpriorityscore=10 impostorscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605220232

On 5/14/26 5:51 PM, Tal Zussman wrote:
> Add block_write_begin_iocb() which threads the kiocb through to
> __filemap_get_folio() so that buffer_head-based I/O can use DONTCACHE
> behavior. When the iocb has IOCB_DONTCACHE set, FGP_DONTCACHE is
> passed to mark the folio for dropbehind. The existing
> block_write_begin() is preserved as a wrapper that passes a NULL iocb.
> 
> Set BIO_COMPLETE_IN_TASK in submit_bh_wbc() when the folio has
> dropbehind set, so that buffer_head writeback completions get deferred
> to task context.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Responding to Sashiko review inline:

Link: https://sashiko.dev/#/patchset/20260514-blk-dontcache-v6-0-782e2fa7477b%40columbia.edu

> ---
>  fs/buffer.c                 | 19 +++++++++++++++++--
>  include/linux/buffer_head.h |  3 +++
>  2 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index b0b3792b1496..d0abaf44d782 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2138,14 +2138,19 @@ EXPORT_SYMBOL(block_commit_write);
>   *
>   * The filesystem needs to handle block truncation upon failure.
>   */
> -int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
> +int block_write_begin_iocb(const struct kiocb *iocb,
> +		struct address_space *mapping, loff_t pos, unsigned len,
>  		struct folio **foliop, get_block_t *get_block)
>  {
>  	pgoff_t index = pos >> PAGE_SHIFT;
> +	fgf_t fgp_flags = FGP_WRITEBEGIN;
>  	struct folio *folio;
>  	int status;
>  
> -	folio = __filemap_get_folio(mapping, index, FGP_WRITEBEGIN,
> +	if (iocb && iocb->ki_flags & IOCB_DONTCACHE)
> +		fgp_flags |= FGP_DONTCACHE;
> +
> +	folio = __filemap_get_folio(mapping, index, fgp_flags,
>  			mapping_gfp_mask(mapping));
>  	if (IS_ERR(folio))
>  		return PTR_ERR(folio);
> @@ -2160,6 +2165,13 @@ int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
>  	*foliop = folio;
>  	return status;
>  }

Q: "Is an EXPORT_SYMBOL() or EXPORT_SYMBOL_GPL() needed for
block_write_begin_iocb()?
Since the legacy wrapper block_write_begin() remains exported, it appears
filesystems compiled as loadable modules (like ext4 or fat) will encounter
linker errors if they attempt to transition to the new API."

A: Can be added once filesystems want to use it.

> +
> +int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
> +		struct folio **foliop, get_block_t *get_block)
> +{
> +	return block_write_begin_iocb(NULL, mapping, pos, len, foliop,
> +				      get_block);
> +}
>  EXPORT_SYMBOL(block_write_begin);
>  
>  int block_write_end(loff_t pos, unsigned len, unsigned copied,
> @@ -2715,6 +2727,9 @@ static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
>  
>  	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
>  
> +	if (folio_test_dropbehind(bh->b_folio))
> +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
> +

Q: "Does this add unnecessary workqueue overhead for read operations?
While task-context deferral is required for asynchronous writeback completions
to allow folio_end_writeback() to sleep and invalidate the folio, read
dropbehind invalidation is handled synchronously in the reader's task context
via filemap_end_dropbehind_read().
Could this be gated by an op == REQ_OP_WRITE or op_is_write(opf) check so
that read bio completions aren't forced into a workqueue?"

A: Seems worth adding a op_is_write(opf) check to avoid deferring read
dropbehind completions.

>  	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))
>  		buffer_set_crypto_ctx(bio, bh, GFP_NOIO);
>  
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index e4939e33b4b5..4ce50882d621 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -260,6 +260,9 @@ int block_read_full_folio(struct folio *, get_block_t *);
>  bool block_is_partially_uptodate(struct folio *, size_t from, size_t count);
>  int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
>  		struct folio **foliop, get_block_t *get_block);
> +int block_write_begin_iocb(const struct kiocb *iocb,
> +		struct address_space *mapping, loff_t pos, unsigned len,
> +		struct folio **foliop, get_block_t *get_block);
>  int __block_write_begin(struct folio *folio, loff_t pos, unsigned len,
>  		get_block_t *get_block);
>  int block_write_end(loff_t pos, unsigned len, unsigned copied, struct folio *);
> 

