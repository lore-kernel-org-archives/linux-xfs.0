Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DEE1C1AAA
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 18:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738607219; cv=none; b=ti3vf9H/Ai3PMEOGB3oi4DFmu8MJKlTF/5n8+6c1xk4TuRpYbZNwJ0hdyC9NfKGUqphK7sMblFbXeBQMZni4FtyE9kwxUiG3y5qY0RiDY36ZIZDt9xvWE9OTiodDYH6fX4zXJujjmO2NYRTu+geJovH+6F7vov0noc/qu7XSRy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738607219; c=relaxed/simple;
	bh=xSG7z/hXKp+EvSu1oDHCh6ubwZsKakIvORJBWCmqVno=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E0WJVGw30DT1yMMjz8ur+Tcs7JGRNhtpjASd4Zf6d1Wq7lkn6vvyGllnLtDxKKdzL1QyDcZQuFxdd69O24NqKTnqsHDxWHve5d7gHT0jfXeq2q326zKx375AfgcA+ZW59koQYYoVe937uf0eePwOd8KTpJibeB14rAH4KV7ajv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=k4RxdLsZ; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="k4RxdLsZ"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3cda56e1dffso13764695ab.1
        for <linux-xfs@vger.kernel.org>; Mon, 03 Feb 2025 10:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738607216; x=1739212016; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kmPe/MXukWW09Nn9SxTH0uCh8TasRJaevapBMliTgBo=;
        b=k4RxdLsZjWLxrDaLgfO6eLPq3+Q2th4YJtDNIKrU3V5brjrN53uVnjgM6zqNaJwZJB
         FhHqw7qZvhoVt7JcJuZWGLeqRqFup3bMXhVYfPcAhDhwtF0X8lXu6GJImt0/s8DUFqDl
         HFG7gNFIQT9ecIjOt9c1o3WbINoBAJQl5b66GxCxqyNs+8CItDVxQShcSY9Z6xXEB9Fz
         ryP+pG+5L6rvxF2zvhUS6eLviVCN/6dsEipobbEo/XL9XR7VuSaXOogjKjGJmrJF3lhi
         WNbIleImiOS0oY2B3bTEml9Cb35DAAVu+SVQTEJT0CeGhjeHsKUw0mNjfBhkWdp2kRk+
         02iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738607216; x=1739212016;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kmPe/MXukWW09Nn9SxTH0uCh8TasRJaevapBMliTgBo=;
        b=VvwlfJRUGxbdqFSS1BRJ4g6Bp96VtGykvTXPucfW7LZhjqquGjS8UZvGEv0Xcrq0P+
         iLuV+tNaRl4QVdw8czkOOnJnrOxYKxKfrzheIk35OIjXfHheSeonxWlNDE6pd2W/k3r0
         6SUi4SaqlxfskACFLQvHmHiTsclLELCZWEUIUt8El1+VQ9NG2DZ/LJ+hSk7OIjXmoWsj
         xb8IWqYJlKzexwAfMt1De8LUFjnft1Xch8xY2cW/RN8S1b/X1Q7wRmXUR28mNf+O3YZp
         e70c8LROnGf86uvi6r9iyqsR7K1BKsb31D9Heo/DYET+N3Vc+Slm9eNo8JDNTdTgaBrG
         Qk6A==
X-Forwarded-Encrypted: i=1; AJvYcCUUjMl6N2XfDC6nETovd6qaRcBXuUOUAwSTK1uGiecFOqeIlMXgHP31HZ5SDPy8tUe/hXRQP03oWHc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQAWSzeTsYlypH4rqrlE9E+cqm1fGQ1MI8rqtaP+n8mC/J53F1
	96x/kg/YcB4oOUUYwRJsmhzMXtP/1fQVSkkEXMkBrMP4rDiKiDanLQNB9AG/ITk=
X-Gm-Gg: ASbGncvI0uxVA+mTnQZ0NCsfKZK72U+tKeUEE5UHqfGjDpmoVI8udATyM+r0tuhfQMb
	iUOzBakfL9Yxy+qt2YjbE4Ith5uu5FY0a4P+S43nBWHnKQoXbCnzzsGb68J9iiAt6eKgymiQ4dn
	LY8ljkC/mLlBwfvkDmfhibaw+LtMJ0cEILhCbQNYxaIskXIbOaa3WtUXu5FElk7/cc13keR3nH0
	l9YPmdF+mIOuVSXZ4Rj5BFRK0QaZEWBQ07jLVHK1HIEZDKcbuYcKO9QN7k6x4K99c8tcXWbK5wA
	WGhzMkH7zJk=
X-Google-Smtp-Source: AGHT+IFx2ocS68xjEU9L4zcXe4rV+LvRKAnlq3Mf2EtVKWjG5ORJzl4W4X+vt62L+bo2yaw0EpQwKw==
X-Received: by 2002:a92:c269:0:b0:3d0:137a:8c9d with SMTP id e9e14a558f8ab-3d0137a8ddcmr141912185ab.8.1738607216095;
        Mon, 03 Feb 2025 10:26:56 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec745ccc7fsm2273432173.69.2025.02.03.10.26.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2025 10:26:55 -0800 (PST)
Message-ID: <20bd06ae-0410-4243-a850-6cd10934c3ce@kernel.dk>
Date: Mon, 3 Feb 2025 11:26:54 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] iomap: make buffered writes work with RWF_DONTCACHE
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
References: <20250203163425.125272-1-axboe@kernel.dk>
 <20250203163425.125272-2-axboe@kernel.dk>
 <20250203171930.GA134532@frogsfrogsfrogs>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250203171930.GA134532@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/3/25 10:19 AM, Darrick J. Wong wrote:
> On Mon, Feb 03, 2025 at 09:32:38AM -0700, Jens Axboe wrote:
>> Add iomap buffered write support for RWF_DONTCACHE. If RWF_DONTCACHE is
>> set for a write, mark the folios being written as uncached. Then
>> writeback completion will drop the pages. The write_iter handler simply
>> kicks off writeback for the pages, and writeback completion will take
>> care of the rest.
>>
>> This still needs the user of the iomap buffered write helpers to call
>> folio_end_dropbehind_write() upon successful issue of the writes.
> 
> I thought iomap calls folio_end_writeback, which cares of that?  So xfs
> doesn't itself have to call folio_end_dropbehind_write?

Yep it does, stale commit message! I'll fix it up and send out a v2.

>>  fs/iomap/buffered-io.c | 4 ++++
>>  include/linux/iomap.h  | 1 +
>>  2 files changed, 5 insertions(+)
>>
>> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
>> index d303e6c8900c..ea863c3cf510 100644
>> --- a/fs/iomap/buffered-io.c
>> +++ b/fs/iomap/buffered-io.c
>> @@ -603,6 +603,8 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
>>  
>>  	if (iter->flags & IOMAP_NOWAIT)
>>  		fgp |= FGP_NOWAIT;
>> +	if (iter->flags & IOMAP_DONTCACHE)
>> +		fgp |= FGP_DONTCACHE;
>>  	fgp |= fgf_set_order(len);
>>  
>>  	return __filemap_get_folio(iter->inode->i_mapping, pos >> PAGE_SHIFT,
>> @@ -1034,6 +1036,8 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
>>  
>>  	if (iocb->ki_flags & IOCB_NOWAIT)
>>  		iter.flags |= IOMAP_NOWAIT;
>> +	if (iocb->ki_flags & IOCB_DONTCACHE)
>> +		iter.flags |= IOMAP_DONTCACHE;
>>  
>>  	while ((ret = iomap_iter(&iter, ops)) > 0)
>>  		iter.processed = iomap_write_iter(&iter, i);
>> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
>> index 75bf54e76f3b..26b0dbe23e62 100644
>> --- a/include/linux/iomap.h
>> +++ b/include/linux/iomap.h
>> @@ -183,6 +183,7 @@ struct iomap_folio_ops {
>>  #define IOMAP_DAX		0
>>  #endif /* CONFIG_FS_DAX */
>>  #define IOMAP_ATOMIC		(1 << 9)
>> +#define IOMAP_DONTCACHE		(1 << 10)
> 
> This needs a mention in the iomap documentation.  If the patch below
> accurately summarizes what it does nowadays, then you can add it to the
> series with a:

Thanks Darrick, I'll add that and your SOB as well.

-- 
Jens Axboe

