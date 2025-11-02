Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68262E555
	for <linux-xfs@vger.kernel.org>; Sun,  2 Nov 2025 14:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762095250; cv=none; b=sfJX2Uqlqkmahve0nQCW2hrXesNS1bQohHLyUqyV//lKfksCuMNjoUglJhMGq5D6VsSRzCt0uI3N9ba99GmiuxGBssiV5W970q+Taj9RGzEToS3Y6DRQ0ZYWvxHz+VBCcf3yMk7f+ow4OdT98z45uGKahxGJ72+gJ0Z1PAYry+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762095250; c=relaxed/simple;
	bh=bxlaRRL2nlhlY73i6Z4C9oKQbVYkM51GfKeaLJcEQCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rvhPkD2YQATC/Owx03JzLgbTTpkU5XWyBeSJ8WwJghi/W1m2QTvI6YTqAQ+moATXOCUGdSDIp4M6wQfbALstZ+1csxI6Ex89JXXCQWa6w3esHOhk2Pj3C0te/pYIGvWP0s5eF629L6VL54td/nOH5AA3AhailcgRMTe5d5z/M6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YWqT83DM; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YWqT83DM"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-27d3540a43fso35798875ad.3
        for <linux-xfs@vger.kernel.org>; Sun, 02 Nov 2025 06:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762095249; x=1762700049; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fbBV+bsxsJJo9i4W5rlnGSN2o5UCpIao/xa2AtsqV4U=;
        b=YWqT83DMvAFc7vKG142AHXBf+zWFhN884IslkqgpLI8sspgPFKJZ9hemsMsrrkrK5z
         FWlVQw44SjhqXk4mmtDHYQHzFBzsEUvSYXa2K+odeqhJ7H+gkcbmq0H0ueQWUwViYLDZ
         hUVErENyQjvaL0/kzMmfXRhibwMg32MoibakV2gyKt2EgYVpZcVZMOCza2HASgnbWvJl
         N7633hu9/9WpcOFYViHYp5WjXCJFWHvWkc4ZGkH7YERqRMFyoa4KkuzKwdmuikgyN6Oz
         uacOyF34uPNZI0LMU1Ep2f8suCKwQDwmrDpQlEN3BMhRDVy8Un0yg3m0TOhuoKO5farK
         TTTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762095249; x=1762700049;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fbBV+bsxsJJo9i4W5rlnGSN2o5UCpIao/xa2AtsqV4U=;
        b=gWrx+jysAL8K2Y84RugW7Su8MxYhlDdcCqmWy5VU4suExSIcl6V/U22Ozr1WvDmVJ0
         DNvqRY0trAV3vRt1q+fhZ67aj0WxwFMPbkj7Gxx2x3BureMj3tqy9CA+/Ye3nqLirWqv
         IaHWQNEWCxdW4f+LOY8gZ5KdB7a1roXCwuacfLIlGQ/I5PebBRefMuPCiYfXpbHW+T65
         s+dJ4CLHIII1S+66ibAZDsjeGDgomTm4DRfO7+RrnwarFd1KDwaybv/o1cNXZvbn7lBp
         ySN0U5kmU49LyTJht6BNLFqMMZSejIVBEfrdfKN16SHH0WWEQQwiRtdxjQZZ1YHXC0cc
         AegQ==
X-Forwarded-Encrypted: i=1; AJvYcCVohetS5WsuR48GWR1tvEb0XyQpdRBfnw04urhslOHcCP4udV0HPc1OuZ5gxYITCcXptlk79TZgkBU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyK6cYkwieMFpEM2AaRd3icxsqq0nE/tqkoJfuDGTqTH3KFwwIr
	NX+lVWgZoy0T5+amcMCHM0QZF9ncL4U4T6Ku5/uUapQV1JWCMwG3NfGf
X-Gm-Gg: ASbGncvn3g/zrZZfOK0DLRBV5Ha4V7X3VDIJp8c8nxjBDkGfC3qN40z1F0z2eQm+61M
	+aa5WgQ4ktBn3TL2NEJhQGSAhwsGRhG5VBH+EM9I2FdCwIfrXDJkaxfZh50UQWev7oql1WmG/gb
	A4S39wq4UyeZc6aX3IpQbifQH/ad1RmmreF3Iv96WP+2gjYLdi19B12n9FUFCMFIY6XWIlz7Ozn
	poU4bX//XHhQPp6i2TL2rh5l7Ov0EzFAG4R77qtEyT0ELSIteWCqt/K9r4lYeozT7WN0g5+2Vhm
	XgZZB2KSl7GW5TAyux89n55LLHAk8RQ0FYeqpFeB+WwLxqgg12CO4bbu1rS6ZWB8ICWk4OcyMns
	XEHVtFobEe2YpNLfwb2jkfCPN3Hxv219cZSSt1b3ifQaPpmsUbJf1WVIk8YeMYteGn128moJ00a
	UwKAkPewb7bTyrsYWG5n9VuEUDDHfk29DjejcxT79BNkWNexQHArk9GGiogJ3nAHz8plYycPkVW
	5MQcF56
X-Google-Smtp-Source: AGHT+IHnLWfHGWwD5xspKTLkP9JN/NSwcFfGAB6JIFTeuFpTGFd9k9unp0HkbTkr2AtQX9XeHiH/Qw==
X-Received: by 2002:a17:903:2f8f:b0:249:3efa:3c99 with SMTP id d9443c01a7336-2951a600e39mr135629275ad.61.1762095248528;
        Sun, 02 Nov 2025 06:54:08 -0800 (PST)
Received: from ?IPV6:2409:8a00:79b4:1a90:bcd5:ef4:19ca:265d? ([2409:8a00:79b4:1a90:bcd5:ef4:19ca:265d])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b95c44f7363sm5581091a12.6.2025.11.02.06.54.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Nov 2025 06:54:08 -0800 (PST)
Message-ID: <ef70adab-ed59-45c7-b6f0-93b61fdb620b@gmail.com>
Date: Sun, 2 Nov 2025 22:53:57 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fix missing sb_min_blocksize() return value checks in
 some filesystems
To: Matthew Wilcox <willy@infradead.org>, "Darrick J. Wong"
 <djwong@kernel.org>
Cc: Yongpeng Yang <yangyongpeng.storage@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Jan Kara <jack@suse.cz>,
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Yongpeng Yang <yangyongpeng@xiaomi.com>
References: <20251031141528.1084112-1-yangyongpeng.storage@gmail.com>
 <20251031152324.GN6174@frogsfrogsfrogs>
 <aQTpLEHURCmkpU3K@casper.infradead.org>
Content-Language: en-US
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
In-Reply-To: <aQTpLEHURCmkpU3K@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/1/2025 12:51 AM, Matthew Wilcox wrote:
> On Fri, Oct 31, 2025 at 08:23:24AM -0700, Darrick J. Wong wrote:
>> Hrmm... sb_min_blocksize clamps its argument (512) up to the bdev lba
>> size, which could fail.  That's unlikely given that XFS sets FS_LBS and
>> there shouldn't be a file->private_data; but this function is fallible
>> so let's not just ignore the return value.
> 
> Should sb_min_blocksize() be marked __must_check ?

Thanks for the review. I'll add the __must_check mark to 
sb_min_blocksize() and include the Fixes tag in v2.

Yongpeng,
