Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7291F6677
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 14:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731420442; cv=none; b=eSTIZsPdcD1evCLjMfj9Y9/t61gk8lNcSYdYIKfABDF7oTJqVMpefFttLlHth5iAOg7UcpBWZkUB/0pcF009Mc9JrdFW6dcy1U82ZbrlK8p9Sbe8WTMDT6RuNFHcEIRDoa3ZOEimbDX93qRvIobCjEbIgydieyIX3aWP+TuKgME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731420442; c=relaxed/simple;
	bh=FgXKW6BhffGyYtDU5ECCxoHBzDo0QQz41DIfSkBu6LA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EZlShHSi0n4ZVEI38LGSXEVN41oWWEaUibu+agCsZ6RbMYuR1WyTDN+nAJPEUsqLh/Ht+DjL8SAnaPvoab/LB2v12NSE75i2ykFn8lQ13HtWhx7mBB5/1mEYJum2O0oSlTG70/PHj1GM4TDzIV5hVkSWOXxEyBWtgEtEWn67NEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Q581Fl3C; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Q581Fl3C"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-290c69be014so2528637fac.3
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 06:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731420439; x=1732025239; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XBLxl8MQn90IOYFQNE2QB3bhcSqpZYc/78jBtkc8gSY=;
        b=Q581Fl3C6vodl50RvVDAzxLsSqnREQ062qx27W8c6tI+slZqca+De3AkT7dWm1BQ42
         A9Dkp6IgY1DybaEpM+zC+39rqWDkHMhG0lvxQsKCW2QAx/dcCtFMenMD9YJfPXOjiKV1
         W6bXtttTHFoaJKLDzhAAFbGvf+jerD4xswuJA7uBjGowW9kdXMpZ8M3bC1SdX4osCE17
         +BWo2ZI9CJNv0uV3UH8HfIawhGPa3q3r7kHt1RppgE31wUZtO3xg7KCtYZXMlWbZLYuy
         /l4Kac1BdFCr5is15MBtMforzhVqOlT/3C3dmonSjkb+PdIQNT/FCsfgUhOtCWfOhH1m
         aQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731420439; x=1732025239;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XBLxl8MQn90IOYFQNE2QB3bhcSqpZYc/78jBtkc8gSY=;
        b=QN2eda4OFJ1/h9uifMmEaIdessLOyqN7mvxQJTleJ/3yqaIHBntFRF5euMFEY+qrYN
         PImVvejavPQPZesY6evfUOgX1mAkSLMZuRvf+eldXZXEesk7yuxkR4WyuCxOzFzG4Bm/
         gExzSMFXHi+IvybMx4SseirnZfGgM32WoBIhNQAEkP+9Y8Xq27gJjf5XHdqgqduicooR
         EHcC2RTQlln4Q1cAo2R3R0UwLSoheXArN/kSlRXtxRn9zr9YaVsQZPX1Wogh7mGjretX
         NfPQFH0htLuge8yol6KBhLBPIh2jxdWgtqUTi/n8FHj/uLLAxu7dI0Zile3+BkWFSHWf
         rSsg==
X-Forwarded-Encrypted: i=1; AJvYcCVDTfNoLS2hEU+0n/fZBMZmDgokBD6dkOyjub2ozWUVyyWKL9nKsBSvJ9T/3PseUGJNtWaUo+VdGmE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9wGQy6+pxHa2Gcob8TvxtQIHhzh+zbWc07VTC1cu0ZG0mGpRR
	e8iykr2Inbeb+SiAxUuUPItwwCy/9xXcZU4eZbTdXS9qyUsy/86Xne14iIPxX9g=
X-Google-Smtp-Source: AGHT+IE6/Zulglee42EqR6pm4NxzY3D1VnQ/4OdFs+x6lB09KGsOVRrOZIf6id75vga3Werl3HOmGQ==
X-Received: by 2002:a05:6871:7b09:b0:277:da52:777 with SMTP id 586e51a60fabf-295600acfa1mr13774116fac.11.1731420438736;
        Tue, 12 Nov 2024 06:07:18 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-29546c92853sm3381006fac.18.2024.11.12.06.07.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 06:07:18 -0800 (PST)
Message-ID: <1671bb73-2e51-4ecc-b33d-d0b483348cda@kernel.dk>
Date: Tue, 12 Nov 2024 07:07:16 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/16] mm: add PG_uncached page flag
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hannes@cmpxchg.org,
 clm@meta.com, linux-kernel@vger.kernel.org, willy@infradead.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20241111234842.2024180-1-axboe@kernel.dk>
 <20241111234842.2024180-4-axboe@kernel.dk>
 <lponnb7dxjx3htksbggjoasvby6sa2a4ayrkcykdnxvypwy4pp@ci2fnmcyrke7>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <lponnb7dxjx3htksbggjoasvby6sa2a4ayrkcykdnxvypwy4pp@ci2fnmcyrke7>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/12/24 2:12 AM, Kirill A. Shutemov wrote:
> On Mon, Nov 11, 2024 at 04:37:30PM -0700, Jens Axboe wrote:
>> Add a page flag that file IO can use to indicate that the IO being done
>> is uncached, as in it should not persist in the page cache after the IO
>> has been completed.
> 
> I have not found a way to avoid using a new bit. I am unsure if we have
> enough bits on 32-bit systems with all possible features enabled.

I think it should be OK, at least the kernel test bot reports build
success on all the archs it tests, which has a lot of 32-bit archs. I
have to say I didn't check on numbering and if the mm subsystem has a
BUILD_BUG_ON() for bits exceeding the allowable value for unsigned long
on the host, but I'm assuming it does?

> In the worst-case scenario, we may need to make the feature 64-bit only.
> I believe it should be acceptable as long as userspace is prepared for the
> possibility that RWF_UNCACHED may fail. It is not going to be supported by
> all filesystems anyway.

Right, I would not even see that as a big issue. 32-bit would just see
-EOPNOTSUPP for any fs, even ones that support it on 64-bit archs.

-- 
Jens Axboe
