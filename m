Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C9E36C9E4
	for <linux-xfs@vger.kernel.org>; Fri, 22 May 2026 23:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779491840; cv=none; b=GEZ2lzUbn9g3Gl9loFvcTUvYfWXADGtSf+5vyk1xcv3P2Q5iIRGaDw7ZviM2uCT9Rk5cgvODTFEgH27Tr+LDyJdrM9W0iaVCKDDSA3VPG7LhnWo2JxYyyXEJ21z0sMfZkGzHZZnVZ3hMatcWgCo1DWvNMaaKrc7QbiQ5UieuHmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779491840; c=relaxed/simple;
	bh=4g38+1lKxMMFXNGYi+/tGlmbD39J/6oFSR8yf9ZHHoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FWkrPyngq2W6BYPL9cicg7F9Y7cJaerr4OPPz9IRgW3FUeUhh3w69INlqCUazu6nlp/YB5XDX2iecHqd+HaWsd5tyxZG1WGm0Kp3TTTw4yadXnH0bzprgaZSZaUCcuGjOKEuTK0dfgup4+hOutA7JGZaefvypX6FsFCI98GPFVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=QCzNXMoc; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="QCzNXMoc"
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MMS5gd3463658
	for <linux-xfs@vger.kernel.org>; Fri, 22 May 2026 19:17:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=XolI
	xwfsVJBVBpTPhnOybhIeNs+9oP88EwbFpg7C0dI=; b=QCzNXMocAxNFTmwB5r82
	Iqr6KeBeNApgLe1JbrJXqMTH7Hv0Jt/WD3PXKZ/QXCCaHxNZnn7Cil8P0gyKLaZv
	DWa07xsv7CrqPRbXnIU40NAL0kpe5neyU5MB0D0nSvHNPjBZq1at98019jHZbOE3
	9g6gkdgK+gyYrvYu1WCQVHRC1VK7MVRiBOCNXxobfa1CXAaZYTlihRJo2JKZpq8E
	AI1jZOOmEZE6eGOhYGuOC2N/WUrRf67sQd7RyFsswLHPrLlCbfd44HeFHwp6RxpT
	j8T6/BvDioIehEh0yVkyfu3Y4ybyW3Q/KGibGcM/+R8a2gbWyj/1VhE1uhi2jsxH
	Mg==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4easgfu6de-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Fri, 22 May 2026 19:17:17 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5165d10e036so126115671cf.3
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2026 16:17:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779491837; x=1780096637;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XolIxwfsVJBVBpTPhnOybhIeNs+9oP88EwbFpg7C0dI=;
        b=VS8H+SOe8/te6CvjdinjwY2QP+Rel8a39ba9K3glu2UG5xzvVbCHIz0VWBOKR0L4om
         Q8GDMt5V7SF/3XJraOmc94k1nCoGmTs9V1PWpkL+8ORWUKq2byDxT752oW1d+yyDtgCl
         edb4tlilw1gKFuZFFHP+KV1jumADF1X3FO6vcwyped1XEkV41YCwKPsFwYjH9BxYbCNT
         w2kuEkgwGmguccFm+X1trkLcbeAcg9syxxGqh2WEB02uw3DjFpvBLT1MRW4ZWvO/Y8jp
         djZSZTKSKwNK1W4aaL7RAzp9C61WeegK3dedIRsUD9e8QHDGiRhkPi+Tsk4/t2Tkhkb7
         qnxQ==
X-Forwarded-Encrypted: i=1; AFNElJ+7GqB8bLRx4iBCigMz7ZY9vuRFWT6jU492UwgcSCsOxd7eg2EfvXTLYJ5xob0uAweP8Fqgr5A9Uyw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkEe6aydhRAvE0TUk3mzNn++w3QE3ASyrEdPjc9rGhXYdByQ/M
	JdPo9gD0LYfTT0RyaNCOKNsdyAkAsCkN1RvxpTry9SU3/qNtekafeFBavNCChoBW1R8t8vnTUgF
	YbOKWAWof5cXG/Ivoe+ZtF7uLlw83yFlgUAeXXNvTyKzE5Hq7zbcWN+7NAA==
X-Gm-Gg: Acq92OGjyjNSOUnx00hED7ijR78MxxumFyZloEsd3zBud1I9oYIq3vXCZ2vuW4rQdGG
	ivvFh4RrUkxDoSFolC79R6TQZKeEzEDFv3QpjhZqokbroRwMgk8kuGhxNF4uocy0GuM/yeE5qjZ
	5LP8dFPWb/hvhdOMY7LYvktUCm9c4O0nmrTNW9ktyx6E2PZLN3XkjINksdYuD0XICNRbAOpeiKt
	9Mz7yTjiYA6cgk6JhD03+vnrPSrmjOUSFz83oFKH0p9FjH7PTIbh94egn3nT2Dk1TAqxRxWiU8F
	0ChzzkqTLiV8RmBVIZY8wwxhh4wRwMpgy793A4SXIYW+o1c30vSABRtXIkM4cNNejkGyrn6XACt
	maFlotogNHP5rybU992Y4hFmlUWZILeKW8jjz2amxpTPWz2kkzAwHb6OWBrTdZsEJMUULCF3Wps
	g=
X-Received: by 2002:ac8:58cd:0:b0:516:d8c6:3e64 with SMTP id d75a77b69052e-516d8c6436fmr59502371cf.53.1779491837057;
        Fri, 22 May 2026 16:17:17 -0700 (PDT)
X-Received: by 2002:ac8:58cd:0:b0:516:d8c6:3e64 with SMTP id d75a77b69052e-516d8c6436fmr59501831cf.53.1779491836515;
        Fri, 22 May 2026 16:17:16 -0700 (PDT)
Received: from [10.207.65.224] (nat-128-59-177-214.net.columbia.edu. [128.59.177.214])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516d8b0065asm25972531cf.2.2026.05.22.16.17.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 16:17:16 -0700 (PDT)
Message-ID: <f8d509c7-c0c0-4196-9a82-a6f8ae24ffc2@columbia.edu>
Date: Fri, 22 May 2026 19:17:15 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/4] block: enable RWF_DONTCACHE for block devices
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
 <20260514-blk-dontcache-v6-4-782e2fa7477b@columbia.edu>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260514-blk-dontcache-v6-4-782e2fa7477b@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=NZbWEWD4 c=1 sm=1 tr=0 ts=6a10e3fd cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=n4JpGxNP30DHW88kdRRHAg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=c92rfblmAAAA:8 a=7QGR7LCADlPcIrvLOjwA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-GUID: 9yx4oWfdoi0Xp5Q4nFm5ZECmZMnMNfSZ
X-Proofpoint-ORIG-GUID: 9yx4oWfdoi0Xp5Q4nFm5ZECmZMnMNfSZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDIzMiBTYWx0ZWRfX4KVp/QLDkMB4
 JRiZ3ow6eSPAtJitppOW6Rs6zrWwdJYsbOt7uA1MidQg2XGIddmGBkNHrRUslWIIQ0Gx4iJ6/f2
 /5Q2ZOlfCKOXD1e69qfMXQXEn0CorrMV4S4XK/z/aK0ovq6EUqFvZOZPFmdERADUzAUcmp6/Ml4
 eG5hNlmL2ksuQbmvOd2+VBqu3bsgjZlIvsMziTbZ96eUevCK3JCb+BVkwDp9lPbt43VG6EEVTiz
 vNqW0L7pkZHUpY1HnqwXO2/QAJSXONNJja+zza6BkiFqXho+Qw4A1bQj+Y44dOBoDcftetb/Shi
 ajnBK2UOds6GHMb74cUs4Z5gb77EhAphrotajuoeyEtMbQPwYuW266uA+mqQILT3+7EqEKwZeEB
 aCJUCIXX27MsOy6l2boH/ONeaK5CeQtXs2YEJdbKvgq70F7MhyJQ6c3BNo4uhJ6zt/5D+vYV3Tj
 PMO72dSAIYNObBZ/bpQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11794
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 lowpriorityscore=10 adultscore=0 impostorscore=10
 clxscore=1015 spamscore=0 priorityscore=1501 malwarescore=0 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605220232

On 5/14/26 5:51 PM, Tal Zussman wrote:
> Block device buffered reads and writes already pass through
> filemap_read() and iomap_file_buffered_write() respectively, both of
> which handle IOCB_DONTCACHE. Enable RWF_DONTCACHE for block device files
> by setting FOP_DONTCACHE in def_blk_fops.
> 
> For CONFIG_BUFFER_HEAD=y paths, use block_write_begin_iocb() in
> blkdev_write_begin() to thread the kiocb through so that buffer_head
> writeback gets dropbehind support.
> 
> CONFIG_BUFFER_HEAD=n paths are handled by the previously added iomap
> BIO_COMPLETE_IN_TASK support.
> 
> This support is useful for databases that operate on raw block devices,
> among other userspace applications.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Responding to Sashiko review inline:

Link: https://sashiko.dev/#/patchset/20260514-blk-dontcache-v6-0-782e2fa7477b%40columbia.edu

Q: "Could this code path be unreachable during block device writes?
Block device buffered writes use blkdev_write_iter(), which unconditionally
delegates to blkdev_buffered_write() and subsequently
iomap_file_buffered_write(). The iomap infrastructure bypasses the legacy
address_space_operations .write_begin method.
During a write, iomap_write_begin() handles buffer head allocation internally
by calling __block_write_begin_int() directly. This naturally inherits the
FGP_DONTCACHE flag passed down from the kiocb via iomap_get_folio().
If the VFS write paths were actually calling .write_begin for block devices, a
CONFIG_BUFFER_HEAD=n kernel would crash with a NULL pointer dereference since
def_blk_aops does not define .write_begin or .write_end in that configuration."

A: So this actually seems legit... doesn't look like anything actually calls 
blkdev_write_begin() or blkdev_write_end(), unless I'm missing something.
block_write_begin_iocb() usage seems necessary for bh-based filesystems, but
block devices seem to use iomap for writes unconditionally.

> ---
>  block/fops.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index bb6642b45937..31b073181d87 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -504,7 +504,8 @@ static int blkdev_write_begin(const struct kiocb *iocb,
>  			      unsigned len, struct folio **foliop,
>  			      void **fsdata)
>  {
> -	return block_write_begin(mapping, pos, len, foliop, blkdev_get_block);
> +	return block_write_begin_iocb(iocb, mapping, pos, len, foliop,
> +				     blkdev_get_block);
>  }
>  
>  static int blkdev_write_end(const struct kiocb *iocb,
> @@ -966,7 +967,7 @@ const struct file_operations def_blk_fops = {
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= blkdev_fallocate,
>  	.uring_cmd	= blkdev_uring_cmd,
> -	.fop_flags	= FOP_BUFFER_RASYNC,
> +	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
>  };
>  
>  static __init int blkdev_init(void)
> 

