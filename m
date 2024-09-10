Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617451A0708
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 19:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725996097; cv=none; b=R1rmFwtQQjCPbc5fs+NEdM19eQlM28b82DtiC48aNEafX6UNTy0Kflt7+Xa6/u5QBYycPOR2zbpRaQ6EeXu8MtPbyIvFMfFG8jTr6y8KRW2rTyBoM7taZonh/Grz1idlT3LQpEjZd6BdMFsv8lYDdKy7jfUexuGF9AAaQ4kHheA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725996097; c=relaxed/simple;
	bh=o+isGT375rznUuyCnHiY488KhfVAUOC/5n5RbwrhNYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tcNyLTZzji0w3xV/4bpXyYeIeFiDHBfeNgk/HrMxWIAnkTtxWH44TGn9McMsJCYK8LOF3V10/iJAZzSsIRVKqmBeZleXOlYyFNca2Cr7CfEs5dQ6uM+l7pt99u7sSvTHFMTv9cvbXevPq/B9VlXRJuiQlXJRGWYsh2mzF7eHy5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0rmjrA50; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0rmjrA50"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-82521c46feaso256393839f.2
        for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 12:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725996094; x=1726600894; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mOWZEzCzgSPVAG028VLnVxHUP1ia+npqcWvvmw8LBvU=;
        b=0rmjrA50jFm6i8BEBLENQfoG6dgDxxZDFAbMwcVpkFemZRPDyeVK5ejVC9WzULeZ39
         W6FLK2mB07y19E7jw8+OEVrDT4AyJSBSjY0sgGKEv5YAZKtAX59P6DKv822zFL1tYY3D
         fwzS2qUOnsJi4uHjpKTZuBEbo5b5B4umHjcElrZTEYojLGFSffifYH5z1GyTE4k7PbIF
         GBH6SvKoYyoHmF/s7xt0U4KKBd1RNqHrv5dT56KxsSFGWwRXh5fSH16SFq3M+HsXVHfm
         4vd49dSvtK+vL43EEB/F3B15v2hkKGJhX4Oiik6KinCACGvVaaQjnGRhNaaIg4nI5grh
         oP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725996094; x=1726600894;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mOWZEzCzgSPVAG028VLnVxHUP1ia+npqcWvvmw8LBvU=;
        b=EJ++RmX4wsRMvxWHUJKYUFS2OMB3GLOjrQqVra+Zu1Oe5YSQXRvKk9T+uf8WolpH8h
         ds0yQQTclfj3DVz5ZIJI5HanWxhgXQWmdMo6Lhd1ui4Uc4l/vXtC9CENxCPrAoQrZxZY
         VIGMQMy/tvMuLj8k+Gfnca2UGPvDMiczuYB8fQdoTVlU0ZttB5Zip1K77ol7wTEwrQKm
         QrexbRQ+z5J8dgwZqM+h4w4UadHovPWqaTht+77wikKyFuBFydA7BykMHYM5kV/G194a
         wa+n9mqpKQjg7yUHDBJvJf6oCuUKO4BJvjq/6uIsbpYCqnX8f1clvtouJEET4iKXHpZz
         HcDg==
X-Forwarded-Encrypted: i=1; AJvYcCWDfTWh3PGahKS4vTcHdBRJnXG7SuCjKU0k7VAx3gIizqFHvuG0xuyDfoXlMDIcvTxnVkAV6+87A8E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzndwisKeClkdbhyyBZYtkDn8VucLYZnjdDqx0Z6VviXniLKjC1
	/G5fKP7fR9WTcaUZB0hXXiyZr0U7mPYukvA3PdKYAksqPxhhq8z7KIh9FgExcOo=
X-Google-Smtp-Source: AGHT+IGx3wAHFaAGfb07EAu2FYC+9BjFVSNQk48DQLYU5QsBhA7VsAXe5CVDKV3R7lfPiN1V9lLjRg==
X-Received: by 2002:a05:6602:6d84:b0:82c:fd75:813a with SMTP id ca18e2360f4ac-82cfd75832dmr363399439f.1.1725996094348;
        Tue, 10 Sep 2024 12:21:34 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d09451dba8sm1766258173.16.2024.09.10.12.21.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 12:21:33 -0700 (PDT)
Message-ID: <894a9361-d232-41c5-8090-89fd61fadb28@kernel.dk>
Date: Tue, 10 Sep 2024 13:21:32 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Regression v6.11 booting cannot mount harddisks (xfs)
To: Jesper Dangaard Brouer <hawk@kernel.org>,
 Damien Le Moal <dlemoal@kernel.org>,
 Linus Torvalds <torvalds@linuxfoundation.org>,
 LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: Netdev <netdev@vger.kernel.org>, linux-ide@vger.kernel.org,
 cassel@kernel.org, handan.babu@oracle.com, djwong@kernel.org,
 Linux-XFS <linux-xfs@vger.kernel.org>, hdegoede@redhat.com,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 kernel-team <kernel-team@cloudflare.com>
References: <0a43155c-b56d-4f85-bb46-dce2a4e5af59@kernel.org>
 <d2c82922-675e-470f-a4d3-d24c4aecf2e8@kernel.org>
 <ee565fda-b230-4fb3-8122-e0a9248ef1d1@kernel.org>
 <7fedb8c2-931f-406b-b46e-83bf3f452136@kernel.org>
 <c9096ee9-0297-4ae3-9d15-5d314cb4f96f@kernel.dk>
 <0ad933b9-9df5-4acc-aa72-d291aa7d7f4d@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0ad933b9-9df5-4acc-aa72-d291aa7d7f4d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/10/24 1:19 PM, Jesper Dangaard Brouer wrote:
> 
> 
> On 10/09/2024 20.38, Jens Axboe wrote:
>> On 9/10/24 11:53 AM, Jesper Dangaard Brouer wrote:
>>> Hi Hellwig,
>>>
>>> I bisected my boot problem down to this commit:
>>>
>>> $ git bisect good
>>> af2814149883e2c1851866ea2afcd8eadc040f79 is the first bad commit
>>> commit af2814149883e2c1851866ea2afcd8eadc040f79
>>> Author: Christoph Hellwig <hch@lst.de>
>>> Date:   Mon Jun 17 08:04:38 2024 +0200
>>>
>>>      block: freeze the queue in queue_attr_store
>>>
>>>      queue_attr_store updates attributes used to control generating I/O, and
>>>      can cause malformed bios if changed with I/O in flight.  Freeze the queue
>>>      in common code instead of adding it to almost every attribute.
>>>
>>>      Signed-off-by: Christoph Hellwig <hch@lst.de>
>>>      Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>>>      Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
>>>      Reviewed-by: Hannes Reinecke <hare@suse.de>
>>>      Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
>>>      Link: https://lore.kernel.org/r/20240617060532.127975-12-hch@lst.de
>>>      Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>>   block/blk-mq.c    | 5 +++--
>>>   block/blk-sysfs.c | 9 ++-------
>>>   2 files changed, 5 insertions(+), 9 deletions(-)
>>>
>>> git describe --contains af2814149883e2c1851866ea2afcd8eadc040f79
>>> v6.11-rc1~80^2~66^2~15
>>
>> Curious, does your init scripts attempt to load a modular scheduler
>> for your root drive?
> 
> I have no idea, this is just a standard Fedora 40.
> 
>>
>> Reference: https://git.kernel.dk/cgit/linux/commit/?h=for-6.12/block&id=3c031b721c0ee1d6237719a6a9d7487ef757487b
> 
> The commit doesn't apply cleanly on top of af2814149883e2c185.
> 
> $ patch --dry-run -p1 < ../block-jens/block-jens-bootfix.patch
> checking file block/blk-sysfs.c
> Hunk #1 FAILED at 23.
> Hunk #2 succeeded at 469 (offset 56 lines).
> Hunk #3 succeeded at 484 (offset 56 lines).
> Hunk #4 succeeded at 723 with fuzz 1 (offset 45 lines).
> 1 out of 4 hunks FAILED
> checking file block/elevator.c
> Hunk #1 FAILED at 698.
> 1 out of 1 hunk FAILED
> checking file block/elevator.h
> Hunk #1 FAILED at 148.
> 1 out of 1 hunk FAILED
> 
> I will try to apply and adjust manually.

Just apply it on top of current -git, doesn't have to be your bisection
point.

-- 
Jens Axboe
