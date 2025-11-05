Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8912080C8
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 02:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762309045; cv=none; b=OGJ/2jsx92hVw6/WcsqU3E8OtKw+dXl9yOTJP1GvO8B6ldu4oyOfbybkECp9i3uqUcMRNcVvABkDaYLTaqbmKqlffbT2rUHwCfG3i0NmmqfrFTFIK7/YeoVX90kss5S+rt8v3Fg8ifpSifl1JvQh5NtasGRd/uyNPhTYc4GZQvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762309045; c=relaxed/simple;
	bh=tIkUTPwyZxnsrTixu38fGF7ItfuUWaUD0A4ZjzU7nQw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uUOEx5ITOGE5IGJKevk7md3BQ+fIJagz6PJwMmzgTOOdQSyunvPKidy+3fofNNqCj9Z+iFDvCcvSCQNMPfNPpYlQhbKYf9DShoGpGQjtna8vOhVMho8707CAkwDtBwM70Jo85qcqzu94TG7AToDV7HHGAzxVvOf24lv9X36DqpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MWkXTJSJ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MWkXTJSJ"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-292fd52d527so62963045ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 04 Nov 2025 18:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762309043; x=1762913843; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H6BPDj3wavhdGIBE9zS61DdhM4idE+BoIHjh+Hrdzy4=;
        b=MWkXTJSJ5ZL4ErTJIoUQo/iNguMVRjHrQanPorc4eTV5Rlv8QYjCLFiGHjKmRjpRwk
         4xxxKav3v6eLPXwNtCrgTZC5Iop06bfiTf9kPSewONmGJ+UX3VxZGBJZVTEiU1924+1V
         4L51dAELkUT1pCO7iX/m427VCRuBlmTdMnmF5/ZZYx241HwHFjtO0QFEiXdqd6lUticB
         DgoAcy4oQ9r1QW+/ArBqc98iNqaLw9dNhJWssQoWMYA7q1jydTZm1+PQeJQ6i1VNs85H
         d4la/h/hbfXqIDObtkaLHY8CZwI/g8N5hzXS1dVqxS0FJhVmaN/AwwasIxuBsi37d5O3
         6EyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762309043; x=1762913843;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H6BPDj3wavhdGIBE9zS61DdhM4idE+BoIHjh+Hrdzy4=;
        b=V72HmbRmBWRsuVMfjB+aAkvs8MhIrbSQGM36EXRufGwx0s5D/aNB+iWXN1XX4JEAB3
         X+8B0Syx+B7WwWhWGjnWI7iYySv/qr+w9fIfdgxt4JxDOrO63trs2Iu5uB2W+hZ/qHcT
         1tzSyFttrsok06a7gfI4duSa0ma7LtmvjUWtCn5W+LhO5cZXjte84g2ObeXNujpZI7nb
         Uvx+Z1lbqNCcIuzm3Wn9lvHrC0HRSdEdTT/z6+iZZ4wHdAXOq16i7hEtFzoHIKc8UraE
         /4+2W07R1CfKSPPnvpBs3d1oc58SQH4RBnU+75NFnRf6nvARsNn2yyw/X4KheHkCm27i
         97Kg==
X-Gm-Message-State: AOJu0YxSL4ATj/awKfyZA9Z+zqKDYXwCRvnovvENVzpcS0Rb23yMmtZO
	ueS2yFsnweJo9wpvi+UJiQjXmUEFr4+qQ12gIFvn087p8/q2arcBsAsY
X-Gm-Gg: ASbGnctW6RiFIyApm2XG5v8FU4saB4jFT2B5gU1ZSSbVDiR41iLXMU+A80mnp0xL37r
	0/f9wu5gu6LdB4mRdLVq9x00xlZC6h/2T8wz2MhyE+xCaNp99lETuwgEnt7zo1BtcvZY1/Gl68V
	/MF64/6qTHMBv33mlluC+MccjtoWXMAQzRqLkWQFaA6EM6dVCJdj14ltHvh+klE7+iWmaiA54EN
	WwMHwUZH1TxPJdGVF/VieWJpirAiJB/mnN6fBhhiuIgB2Cnm7+jNZcU2NtRxnMZS6+CaTGm3Bhy
	wh1FEtY6tgFGvvHW6KgPr6cSOQlVlNTGIc5YUgGSpCtt+3Zo+ZXRA2KqetwOdqhJNh3+B1heRjj
	2Q52BS2/LT/aHsZU15MkeIuQTtU3TjkhsdO8mwo5RGg4cmRYQGoFcMJapOjuluhKV1yXPO/3uUW
	Cz++grXqx7/dcebEGed9empx4=
X-Google-Smtp-Source: AGHT+IEYmsytaR1mEiRZPjc6ohcI5FrMoE1+JkNMyyS9qC58igvtXBSkpPErsXNTO8SABAM2YSvmsQ==
X-Received: by 2002:a17:902:f684:b0:24b:1625:5fa5 with SMTP id d9443c01a7336-2962acfd7e2mr27115905ad.11.1762309042615;
        Tue, 04 Nov 2025 18:17:22 -0800 (PST)
Received: from [10.189.138.37] ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29601998336sm41935745ad.31.2025.11.04.18.17.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 18:17:22 -0800 (PST)
Message-ID: <ed736d06-3f91-43d9-b24f-60c54807a1c9@gmail.com>
Date: Wed, 5 Nov 2025 10:17:17 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/5] isofs: check the return value of
 sb_min_blocksize() in isofs_fill_super
To: Damien Le Moal <dlemoal@kernel.org>,
 Yongpeng Yang <yangyongpeng.storage@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Jan Kara <jack@suse.cz>,
 Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sasha Levin <sashal@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-block@vger.kernel.org, stable@vger.kernel.org,
 Matthew Wilcox <willy@infradead.org>, "Darrick J . Wong"
 <djwong@kernel.org>, Yongpeng Yang <yangyongpeng@xiaomi.com>,
 Christoph Hellwig <hch@lst.de>
References: <20251104125009.2111925-2-yangyongpeng.storage@gmail.com>
 <20251104125009.2111925-4-yangyongpeng.storage@gmail.com>
 <0a04e68d-5b2a-4f0b-8051-60a0b7381d17@kernel.org>
Content-Language: en-US
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
In-Reply-To: <0a04e68d-5b2a-4f0b-8051-60a0b7381d17@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/25 05:29, Damien Le Moal wrote:
> On 11/4/25 21:50, Yongpeng Yang wrote:
>> From: Yongpeng Yang <yangyongpeng@xiaomi.com>
>>
>> sb_min_blocksize() may return 0. Check its return value to avoid
>> opt->blocksize and sb->s_blocksize is 0.
>>
>> Cc: <stable@vger.kernel.org> # v6.15
>> Fixes: 1b17a46c9243e9 ("isofs: convert isofs to use the new mount API")
>> Reviewed-by: Jan Kara <jack@suse.cz>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
>> ---
>>   fs/isofs/inode.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
>> index 6f0e6b19383c..ad3143d4066b 100644
>> --- a/fs/isofs/inode.c
>> +++ b/fs/isofs/inode.c
>> @@ -610,6 +610,11 @@ static int isofs_fill_super(struct super_block *s, struct fs_context *fc)
>>   		goto out_freesbi;
>>   	}
>>   	opt->blocksize = sb_min_blocksize(s, opt->blocksize);
>> +	if (!opt->blocksize) {
>> +		printk(KERN_ERR
>> +		       "ISOFS: unable to set blocksize\n");
> 
> Nit: using pr_err() maybe better here ? Not sure what isofs prefers.
> 

Thanks for the review. I checked fs/isofs/inode.c, and other functions
seem to prefer using "printk(KERN_ERR|KERN_DEBUG|KERN_WARNING ...)"
rather than "pr_err|pr_debug|pr_warn".

Yongpeng,

>> +		goto out_freesbi;
>> +	}
>>   
>>   	sbi->s_high_sierra = 0; /* default is iso9660 */
>>   	sbi->s_session = opt->session;
> 
> 

