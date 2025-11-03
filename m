Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74564287505
	for <linux-xfs@vger.kernel.org>; Mon,  3 Nov 2025 13:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762177245; cv=none; b=cHzEBbaZb5paGbYankZAVGdG2Zqt8Mcu9oRds4PSIUOM7345jS9BLskQPnkvg1B6QIdx95umMcnBmdt4B5hFPRwaQhUOxbA4FaGQfR33A1GMLTASgD4npRoEBlVxfVIRxCZkM8maBz7cMWMDzYulH65HUJeNLHSNXMFnypHYj9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762177245; c=relaxed/simple;
	bh=JZ0P1jUJT/JHdrkC2pQPX3089iJixp+OjT43MwzgNR8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KqIQY6uDdGRf+6pdZS296lwCZqknDVh+9JeGP2jAHYJzXfwA00xpJ/ojY1ZCgbykVMepx4aNStwZMOioQIvfcbvhTOeMbGti3gmqosDFOvKRhR546a+xwlSMBGpTB1T60N57uFc0wx1j6gLaSQSDlYhzi1vAWNqkRGFp5spFTfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mTPQC/TW; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mTPQC/TW"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-33ba5d8f3bfso3794492a91.3
        for <linux-xfs@vger.kernel.org>; Mon, 03 Nov 2025 05:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762177242; x=1762782042; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+8IwqJtA/22JVDtVDWFjIJd2N2jNDTeHgnje61NBmJ8=;
        b=mTPQC/TW205WGM22q1YNn+ndPJrOc6Yjahm5rTeZ0CLzA0C3ZORehURZEkV/qyA4jx
         ML8RGQqdmf68ZoDpjlBVJCYZndBFghHjftPIIGsVBVIhFEPiqBldDefn56V/2kPo4lx6
         dyy3h1DmvC7TBbOYOEBsvwfGS0bfg7kYT8DL1LP/LtICizpMdmV7MAPWJ/7GzcBjgjXl
         og21ElomjErRG678nAYWFEEeWLSCD5FMX/IN7v2wZA+m+2fEDzfIql+2hh07LcqPZclH
         V1tpcDnYGkijZIllr90/FQ5OPQS9iujhJ0+Hm963Hftbsv1loMFjknr1HaPeBTbtIJI5
         ZGrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762177242; x=1762782042;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+8IwqJtA/22JVDtVDWFjIJd2N2jNDTeHgnje61NBmJ8=;
        b=gIhQkVQQgk0Ow4ZhPbw4XOnAyuarEGFnXYBeTZd/PaI7rui0ZQOEvKk2WOvVHDTxbi
         yRzDW/ML+LQ2b5UQ9fblx7QOV5Qj0NpzfoAQihvqD25tZaiUGZzLV3F+BrTxur86q9vo
         l7tDhoWoEhr72R6k4Y2w9UHOfrM71PltUvS3oyCZ59lTGBVawQMGFbRN13GDfVCP+tU6
         w87/tTFEQqNBnBImPGpuTSjglAfUuV5/FYJao8h1PQiwlToU8/l5yRIB7YHh3NFgDhVF
         LforCMa2wwO5OWzDwnDaNLLMCTHlcY8sM69SjAwJ+y1Ro1OkvL+VBthaQ9wi8TwTP8hr
         nT7A==
X-Forwarded-Encrypted: i=1; AJvYcCW33VEQCnFEzKCiJrtn1fTMVZPZYjOW0zMyh8ku/e6e6uDr/cKuB7MEDzu9BHCCMvO2wVcZI5EVAk4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKC+NFG6S0xdB+6ToNeg+xueR5aqsI8P8cvU6Ze00UIFLtgmh+
	3UXnZyNABpQMm84CxScLanJJX8fvxxPeeADIUxCrFld1rthEXYxuyX8t
X-Gm-Gg: ASbGnctpbI2RVKCTkA+1PRfUUYdjIZ0NMvm8swaRYxWbF+EXJKHaMzuSp/ahhr04NWZ
	ZkL0qUTkyFm99Jg8uFXXrUHihL0ynoXLq+Xb0L0YufB16wtM21RGUHqvx9cDx5NDdxWjIyjV2I0
	6uHcYOSppByAK2pKI8br7RaTOucpi4VoLxcPcTnoLZq2KVaFxB7xunlvhZkxOVgw8Z+DB7yklic
	xzkZ73zx0mj3mI6wztbLGqWFaqAftNUqX17BMGYaQlARWLj35CXw4FF/62k4JeFjll9zbDs6Okh
	sWHB4TxDP2rrTnRgK+cztx1TiNsAnPhPNd7eW5AEBqpew/voFISP0aDoSWUXYnyRLwK+vzriRxy
	tuBlw7DYNz5fq1/OBFatJ9om5C0g1oN8Gczr4C4L1590iPaPt2Yue06VgGfMKmDTKHoGgcT6IQt
	JS7QPg4eliays0TIBampzNQR7XHbms5I+FitVO+1qgvy2LWEuO8qsrWuBeUBtvwiIxFQC6opmH
X-Google-Smtp-Source: AGHT+IGpJsA054j4ViTtI38jqwpBxx4LnXSeC5cZfa9rXdhBelszsgUGjl8r93/Fsuxn/l+FZEUG2g==
X-Received: by 2002:a17:90b:2f48:b0:330:bca5:13d9 with SMTP id 98e67ed59e1d1-3408309ae43mr14629306a91.32.1762177242379;
        Mon, 03 Nov 2025 05:40:42 -0800 (PST)
Received: from ?IPV6:2409:8a00:79b4:1a90:5d7b:82d2:2626:164a? ([2409:8a00:79b4:1a90:5d7b:82d2:2626:164a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3407ef4c263sm5374195a91.3.2025.11.03.05.40.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 05:40:42 -0800 (PST)
Message-ID: <07ab7f80-889e-4a28-adf9-12fc038bdc27@gmail.com>
Date: Mon, 3 Nov 2025 21:40:18 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fix missing sb_min_blocksize() return value checks in
 some filesystems
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
 Yongpeng Yang <yangyongpeng.storage@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo
 <sj1557.seo@samsung.com>, Jan Kara <jack@suse.cz>,
 Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sasha Levin <sashal@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
 stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
 "Darrick J . Wong" <djwong@kernel.org>,
 Yongpeng Yang <yangyongpeng@xiaomi.com>
References: <20251102163835.6533-2-yangyongpeng.storage@gmail.com>
 <87cy60idr2.fsf@mail.parknet.co.jp>
Content-Language: en-US
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
In-Reply-To: <87cy60idr2.fsf@mail.parknet.co.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/3/2025 12:46 AM, OGAWA Hirofumi wrote:
> Yongpeng Yang <yangyongpeng.storage@gmail.com> writes:
> 
>> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
>> index 9648ed097816..d22eec4f17b2 100644
>> --- a/fs/fat/inode.c
>> +++ b/fs/fat/inode.c
>> @@ -1535,7 +1535,7 @@ int fat_fill_super(struct super_block *sb, struct fs_context *fc,
>>   		   void (*setup)(struct super_block *))
>>   {
>>   	struct fat_mount_options *opts = fc->fs_private;
>> -	int silent = fc->sb_flags & SB_SILENT;
>> +	int silent = fc->sb_flags & SB_SILENT, blocksize;
>>   	struct inode *root_inode = NULL, *fat_inode = NULL;
>>   	struct inode *fsinfo_inode = NULL;
>>   	struct buffer_head *bh;
>> @@ -1595,8 +1595,13 @@ int fat_fill_super(struct super_block *sb, struct fs_context *fc,
>>   
>>   	setup(sb); /* flavour-specific stuff that needs options */
>>   
>> +	error = -EINVAL;
>> +	blocksize = sb_min_blocksize(sb, 512);
>> +	if (!blocksize) {
> 
> 	if (!sb_min_blocksize(sb, 512)) {
> 
> Looks like this one is enough?
> 

Thanks for the review. Yes, blocksize doesn't serve any other purpose. 
I'll remove it in v2.

Yongpeng,

>> +		fat_msg(sb, KERN_ERR, "unable to set blocksize");
>> +		goto out_fail;
>> +	}

