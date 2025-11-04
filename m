Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B9B2E92B5
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 11:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762255937; cv=none; b=BhiyAM/GREbnEJbBDa9iEkpO6XGEgB/JfaUH0w0LTuzE+LfVTM+4TxKpeffgvoI61aCbtoXnPxBLD6fTxapxvWR0vsXxwcsEGh+1JhlobWWO3cN/gebTGEHUGb3ZwPqZpH0njCAFMExQclesxj42Bw+L0w00tecg0Vw2kl42zjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762255937; c=relaxed/simple;
	bh=Sw7bSqlGqr5IT9Xat5i0E71Exlf9sKUY61iDbp4a4t4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oTxxpEjPifJ1rPKnjS6zt5jFwj4av2WRm6bii1uUbTAhz6bGdFq05MYhWWDJwtva0UAdHtcTbXmB5HAlJirJ/cXF2/zpNW2QfujwrvVv5HgFyV4Xg7BgFKx6g+g0AcwxOzIiGDwPt9Tdj5RbNYqgIjnvKB0zUz11ukohD1XqZ6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kPdGemG0; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kPdGemG0"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b593def09e3so3911400a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 04 Nov 2025 03:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762255934; x=1762860734; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aoSxDhxS90f6BeCfm1xZZ+x6pE+INoKbsN0wsldLLGc=;
        b=kPdGemG0DCN+yk6LnPqF6SDXZwGjacksJbxEPAQ6EyolxXjOUZpfBzAn/Pl7k+Q4TT
         jKVEBkLxw0PAc81bkRAnFi7ee4QAsf067QCz8f4AcbEorBk2zLOwDQS/8dwQU0Geg6pr
         ZjL74Jy2o36rugOgpMQCs06r3+pDmoD0haJCSdRVtFNQnJgwSWivGxp/ojPt+9lo9+Po
         8HgJJPsnLuQVKAzQReWRwAWcOfa64v9ZQqY24Ow1BfmfHgW0kDuAyNbF+DpehP0D0Gda
         bArD5/LML6RZnxojefkB1q2i6FFih35tYVKmZYVfC6OOp5h4MgwabhkVxfOGHagJIMHS
         zUwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762255934; x=1762860734;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aoSxDhxS90f6BeCfm1xZZ+x6pE+INoKbsN0wsldLLGc=;
        b=qhmrOJXYDhHAZPTacdSC0kQO2DCMIdOeLI7eYHW8OTV4mVKFmpIMZqg1b/6IV3ye+D
         FaTbjTkHJxOLr/92Hx1vmLc9qaaOWmPM4N6CuwMDDSZZrbL+UiLjwS24IK7gFK1rqgwQ
         7IEP6lmoxqA7y/nqqSpqv6yDqmgYoRL6A+/gHccoNO0dVQYzdmGZuFNqC2ejwvi/Bk0s
         8wSasuh4DKstdVIVYkgn6uOm4T81vTykpYV7XPsAJPYjtLUOiiNb4GgxX0wvbT1y4SBg
         pb+7Sl0n96a+YEH2bs8tOI2r4Pzo3QZVBC+iilWPNqIj5PImifGXCkMkcZDR9An0Gaem
         o3xA==
X-Forwarded-Encrypted: i=1; AJvYcCXIwJsMduniDawXT1CBLb/Rp4kMNH1eO33fnq3nfcIZ7cPsOe2Fe0z3FbtXYN+PxbavOq2HbAxDSYE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHT9COZ32DWIITyiRXKirBEDJoOdicTU9gnrhYQwxwengTjpPC
	4jKfxSdsBnzqfeavekwnRxrCsGSgB+EhHr5urpEkR3aUERFaAmtBC/kj
X-Gm-Gg: ASbGncswNh3oPVf7Q/wvOt5mWjF4P9/14nAgyAj3eGPuDeQJfk9gechJQarGQKEsqaR
	eSO8iU4JabpomBnH2C0DLlHGgPQjVqZtPAzePGoJEmdVrlVzz0+3gcPshtJ7bIBfES5nEWBNQMv
	dUUoFwc3uG4pJSlZcyTpfWnksW/EV64d6I7W5I8ghHI0B/Lx7xpwfbY49k6IIO/w83ZFYfzJtCU
	YxvwE4hGCdQmiIT8KBJHecRr+NQu5zIiJCrKfM+aZkBIFSm1nBFTNaBt8/Kipoh1eA1ymgx8zrE
	axfewcK6IwmOBFDFG+8ihIrqhB1QNhGIx4sp/i5CSyOaWULxkz376DZhs3CJPOEDqNsG7u58vn9
	PntJuvTR9zYyIVXWk5dOsVP+Ow8tgtqQQu+Z+Z+ZdQH9LbHSHvJWpZoIYhq//MxXBeVK7XsDluQ
	i7cZKa/VeBXgl83J/E2zA=
X-Google-Smtp-Source: AGHT+IFQi4sy7Pt+iNRc3yBEyf08yF9LpgtHzOpvhx7vFHjqpeB38ssLGuLoFfNxgUkcZVwLEr9mCA==
X-Received: by 2002:a05:6300:8a03:b0:34e:865e:8a65 with SMTP id adf61e73a8af0-34e866de6cbmr2005737637.52.1762255934090;
        Tue, 04 Nov 2025 03:32:14 -0800 (PST)
Received: from [10.189.138.37] ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7acd6919401sm2618951b3a.65.2025.11.04.03.32.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 03:32:13 -0800 (PST)
Message-ID: <8031227a-8a27-4aa0-8ca2-c44f494e9ad2@gmail.com>
Date: Tue, 4 Nov 2025 19:32:09 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/5] isofs: check the return value of
 sb_min_blocksize() in isofs_fill_super
To: Christoph Hellwig <hch@infradead.org>,
 Yongpeng Yang <yangyongpeng.storage@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo
 <sj1557.seo@samsung.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
 Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
 stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
 "Darrick J . Wong" <djwong@kernel.org>,
 Yongpeng Yang <yangyongpeng@xiaomi.com>
References: <20251103164722.151563-2-yangyongpeng.storage@gmail.com>
 <20251103164722.151563-4-yangyongpeng.storage@gmail.com>
 <aQndM_Bq1HPRNyds@infradead.org>
Content-Language: en-US
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
In-Reply-To: <aQndM_Bq1HPRNyds@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/25 19:02, Christoph Hellwig wrote:
> On Tue, Nov 04, 2025 at 12:47:21AM +0800, Yongpeng Yang wrote:
>> From: Yongpeng Yang <yangyongpeng@xiaomi.com>
>>
>> sb_min_blocksize() may return 0. Check its return value to avoid
>> opt->blocksize and sb->s_blocksize is 0.
>>
>> Cc: <stable@vger.kernel.org> # v6.15
>> Fixes: 1b17a46c9243e9 ("isofs: convert isofs to use the new mount API")
>> Reviewed-by: Jan Kara <jack@suse.cz>
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
> 
> This should probably use pr_err instead.
> 

Thanks for the review. The other functions in fs/isofs/inode.c use 
"printk(KERN_ERR|KERN_DEBUG|KERN_WARNING ...)", so I used 
"printk(KERN_ERR ...)" for consistency.

Yongpeng,
