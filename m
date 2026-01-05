Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB4C31ED94
	for <linux-xfs@vger.kernel.org>; Mon,  5 Jan 2026 09:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767605286; cv=none; b=slnAo4KKsaKxhWWbB+a+OIKrouNxFg7LZx/gzZVfowSKb8Uldu6O3J/O9XMVrDZONsWq9fceqikOnJQsR10PcmUoHQc96tdo+Cbq1PKURz2PZV8bJqKPZKAeaFjwOMzRrCUFP7Prkoxah3FMosK1fM0Y0W0Zt3jwsuu7I9aXp8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767605286; c=relaxed/simple;
	bh=LUBqn4Ylu7k53HZu4lQqsEMpRTV2mIhD9a8O6isq6MA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l1CPKZ1UEMuEBgLrtyeBN9Bx1Bf2SB3EH3gIN+XapbAcqiSJLvKe4EaHkW6+sYOCmn+LSSL+9mZXlJIOLYTg1eCjYW+0mA5f659pwdfP8XsFF0bMoLl8JFNr1NOzI5j9QpvHaw+ERhlwyBrGGLTNWmsL3VR4j5AmZgLRZjGDSGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YWC0/LoN; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YWC0/LoN"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7e1651ae0d5so10632405b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 05 Jan 2026 01:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767605279; x=1768210079; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nQIZ452wZXIK57t7CDqSPjoLHYNUHDQ+2nk1XIU16DM=;
        b=YWC0/LoNZnVjPDkmZYt659X7a3/xGc7NTkbSVt2F+3qfqjywE77kamuzBv6ilMNIF3
         lmrd9s7+Ff+8RGWcwfHBMp0t6+HqJYpVxLPisdrX5bWIp1eMC9qaR2/RB0JMvSnOcvMT
         JdHpd/QeY0GmxewsMsePEz8qRnXxKEJqL8f/aQeRGPHZomNSM9riYAhSIrVBeq6ap2kx
         Qg8U2L3S63ZFvIy0ZLT4Iq48Kti5L4PQuWuiNjzkE6DjI4OOd+Qrwz1kMzQx9qxngBgC
         o9zjXe4q+BJrAtj4lpCeuqjecZoKLAYaawBHQyaxv1J3LqMRHQgYGraCBbMTm86QLWtV
         iZsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767605279; x=1768210079;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nQIZ452wZXIK57t7CDqSPjoLHYNUHDQ+2nk1XIU16DM=;
        b=Lasu9lphxRxOuc1GmIJtjfLKePQd6w37AXnTBgp/YAh5jso4mLt+hZkybRsTQjiUK6
         7CZC4L0D2dZT6xcpmIbEh+unqoWlCDAkIyIxy4KmHtr2t9Na3W38hsZOr2vs2r01xrMy
         yzGmtsJ9Qbirv8IZp9O/KoyNrS73MfqiLEREgV3Devw2guAGAMEJQBleZZIFSbqihx5f
         JihUZW/hvoGWy3Y7IULGiFfM89gywb7ONHy2L+9M7frOVnSfYv9u5bxd1E5maIk7wWvN
         iilhPORSPT7Z/An/LIoRz+94fucDWTezna28OsFWPzcpgHEfO9HLPd35q//UJKyR5Zb3
         /jtg==
X-Forwarded-Encrypted: i=1; AJvYcCW8RNR8/p/N+Uq1JG9s7QxNFVYRmuxIhEkiBNnEpVD8PxtVn3DUqRqVj5QxvTXVlgsb+bZeMzuE2UM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ1rrhcAMz4mDOv64Sxlb8Dnrn0B1VHxi0ywgKh50o+OxSh30T
	JaMdS2dKYfwl4bg5mDj5MNYjxAj/Vk0DY5SJkKxrJmScXyo1Nlk51jkW
X-Gm-Gg: AY/fxX5wrJK3blqmz8KKwDGTrsFe2LOcnpgpCWVrXTkPSo9n9bFgGPz0vR75ytI1x4h
	2paoRidrUonPSTKWRLaA/ApyaOXi1mgtpKtvfW0lUkDn8mJLfYpbsHRojTPJv1hgHaNjADTKM0O
	Vu0ZYLIIhJrBEOKtG8oSfayQ+QzvroBp8EB4rwWMBcOghtSyTEul4EXUd46iil1x3+xcumtF6Qi
	2JBZLZ1QquBAKBl5UR2gQWNsGN+N6uT/llkakMeyPDZRacMazo79zzGTAQumjZWrZza/+S0EJUG
	S8gDSSGXVJbh8gdOWCOKutNKeDpAciepfbfQwwQphA0VjBxXP2vuFZiiUNVvLLDlPE5NsswRLSm
	YEO6+axU+qdMsv1ykklcrfQtQAUplRlUhAjLkjtg15jG8tZj70J7jA6sOg8OdXTOwOt7MB3jC6u
	lr5NDbgr6zdP1OFDwJiWZFpS5b2loqnxGu
X-Google-Smtp-Source: AGHT+IEZmNkq8Gl/dnJOg3s3RWvfca6b9cqNrss8LiqWrUnkpu+7dey1SrWISomWv3jO23drZv2kBA==
X-Received: by 2002:a05:6a00:4509:b0:7e8:4587:e8c1 with SMTP id d2e1a72fcca58-7ff6647983bmr40451269b3a.52.1767605279080;
        Mon, 05 Jan 2026 01:27:59 -0800 (PST)
Received: from [10.4.111.0] ([139.177.225.226])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7af35f37sm47508520b3a.18.2026.01.05.01.27.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jan 2026 01:27:58 -0800 (PST)
Message-ID: <dc92f814-043c-45b2-8d2a-403f462434d4@gmail.com>
Date: Mon, 5 Jan 2026 17:27:54 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iomap: add allocation cache for iomap_dio
To: Christoph Hellwig <hch@infradead.org>
Cc: brauner@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 guzebing <guzebing@bytedance.com>, Fengnan Chang <changfengnan@bytedance.com>
References: <20251121090052.384823-1-guzebing1612@gmail.com>
 <aSA9VTO8vDPYZxNx@infradead.org>
From: guzebing <guzebing1612@gmail.com>
In-Reply-To: <aSA9VTO8vDPYZxNx@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/11/21 18:22, Christoph Hellwig 写道:
> On Fri, Nov 21, 2025 at 05:00:52PM +0800, guzebing wrote:
>> From: guzebing <guzebing@bytedance.com>
>>
>> As implemented by the bio structure, we do the same thing on the
>> iomap-dio structure. Add a per-cpu cache for iomap_dio allocations,
>> enabling us to quickly recycle them instead of going through the slab
>> allocator.
>>
>> By making such changes, we can reduce memory allocation on the direct
>> IO path, so that direct IO will not block due to insufficient system
>> memory. In addition, for direct IO, the read performance of io_uring
>> is improved by about 2.6%.
> 
> Have you checked how much of that you'd get by using a dedicated
> slab cache that should also do per-cpu allocations?  Note that even
> if we had a dedicated per-cpu cache we'd probably still want that.
I’m sorry for the long delay in replying to your email due to some other 
matters. I hope you still remember this revision. First, thank you for 
your response.

Yes, I try to use a dedicated kmem cache to allocate cache for iomap-dio 
structure. However, when system memory is sufficient, kmalloc and kmem 
cache deliver identical performance.

For direct I/O reads on the ext4 file system, the test command is:

./t/io_uring -p0 -d128 -b4096 -s32 -c32 -F1 -B1 -R1 -X1 -n1 -P1 /mnt/004.txt

The measured performance is:

kmalloc: 750K IOPS
kmem cache: 750K IOPS
per-CPU cache: 770K IOPS
> 
> Also any chance you could factor this into common code?
> 
For a mempool, we first allocate with kmalloc or kmem cache and finally 
fall back to a reserved cache—this is for reliability. It’s not a great 
fit for our high‑performance scenario.

Additionally, the current need for frequent allocation/free (hundreds of 
thousands to millions of times per second) may be more suitable for the 
bio or dio structures; beyond those, I’m not sure whether similar 
scenarios exist.

If we were to extract a generic implementation solely for this, would it 
yield significant benefits? Do you have any good suggestions?

I’d appreciate your review.

