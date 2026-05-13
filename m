Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CBB3A426D
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 19:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778702175; cv=none; b=Ws4SQ/kxGJHl2BJ88wtuhKWWp5T9d0mNvvuR8SNB9nyfzqlNQSFD/Q0vS6DaWcNF5eqkrRAeXee+bm9Vrw+YCg2VLwaNAzTiB6cVM+FsA3C4EuZdnOePzM7fQtcMqTP/7/kgzNoOvpnWApNWFMlkUyFLaPsZ6oTt0CunCbLCH8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778702175; c=relaxed/simple;
	bh=DZwcPmH+04E4hEMYfZxmWOphebXi2TK5M+0gKLhYoho=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=oFYG1IpBPwM31AFyUMXNT7dcVZ84dbIN1jBbiMEV0WxBob1wdIeeYWULBCN67i6jC2kZYz6w1pH46y4DxV0zPYgb+NRzsbJrYEt11fZruSkagobp+EDbcY0D92exmo3G8MpF0MvnnvNc/i9GE7OagxessYex0aEgAcyLBuT7MD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=f6Pt21f3; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="f6Pt21f3"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7dcd689829eso6349812a34.3
        for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 12:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778702171; x=1779306971; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=krbyiVc8jSJdhIcgAt5f1amAPCSUW93oLBkGCtEucHU=;
        b=f6Pt21f3Ba14Ughj5nW6FhvEeVxnfyxR9Hfd9N7qfBD4kWEcfzBLegRro2xaxCtbp1
         4TEoU78u9kP28JeO9U0b8EcJsREKriT3MhAY0wmftebymQVxymEiXhRfPXSHFih4UZ0v
         NKdxQz6d/Gcpy1N+ZW++VET0zyzI8kGSKr0chlV0oQCAGSlmfIRglFiX3+Q2QuiyoiA/
         YzfcMT3DtoJcyUtulPMnUF7dCBTrkTklahLRCYunTq0esIWG+yJ14TQbHoz6U2KgOpUC
         mBWxUlVHn2a6ztPjnlaFqb31OFSIOAgBZs9PPmQTBx0tJ0uZJO81Y1Bh+1IiVQA+kjsQ
         jNCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778702171; x=1779306971;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=krbyiVc8jSJdhIcgAt5f1amAPCSUW93oLBkGCtEucHU=;
        b=QEm0yW/pSeJqKjW/4gWcbxKO+mDYC88eAUp4Aw5N1wK710lY0qvM72p90zkWixy+B0
         O9IXN6IzdgwU5xS4drhkTD6RpleZURb1Zs9vJ3RHEiLkbSov7GuDXAUOFLXt7aul5/kp
         Yq7HpBsmbL2DZ3SwEi1KyH51vXipqXLUZMXR7tw9cZww3N6TxlsesCtDhFAq1q1IUuz8
         6cMpuR0mbfS3qNQLOSq3l4E5CtSRQgFGm/C5EPxx2rn38m2A0UO9iaxyJE3t5Eo3YeEh
         lJVPdbRsoWc7viHpDxgPQq1DMBsjg3u9qHluf/DvzKdZQabnonIEcBSVqAlnUwbXPsKY
         j3tQ==
X-Forwarded-Encrypted: i=1; AFNElJ/C8KoZhlGZqBHsMqdAOITprnjN/u9LrvhVcPnLZPQK4duiewm8ADLkVz9cAhDlXxrFJ/998SImsRQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywnpy5eSEL3Ckje1A/rac07+/DQ6GONJ1FR8d5Vltf1yWEHlMwN
	Kpzg0gSgb0nK9yTumagFV98OMj23HCWDyybIo7q/ywvbAmZ1kJdFhB+bNu4KKdWc8inff4jNRq3
	wG9bg
X-Gm-Gg: Acq92OEVXJQLWuAElCli4eA4Q45hh4vB46GRTVFSVk1Lsx18BofEhU3zJbAHytTdV0o
	3ozCIhbYmnOzYOPV8SK41TAnffjXSFjxofXKNLgt6iWUp+35EZO7fYya2PzNmK0e6whDS9MXcKi
	keRtWf/mRrabGIdxIumhBlxiqbEIaw85MfkZtBzLXc5KIVFHbDuBNLbtCauGm0AQLVJPtf7ye/D
	zrX7lkFe14cFMvwiXDOQU2gLw7/hgo+bvm5uNifvTtMTVSiPJocxhnkkHJPDso6aF0h7Lofd4oY
	y1PtX4B4ynPGsUfRNBkKS88xZ8S6QFkfo0vC72W32tZln5tTavPRY1KDoBlsGxG3U+wSMmmNeFR
	h/pQp48U/MIBM5LCacUEGbmZt5F/+VAKFuHtxL7ENgOdKcjI0dTL9lZtMNbPtcplm7KzqRMjeQm
	mbaIuCKE5DUdqVZKBJUZBt9Mv/E2dujqW2SZOLUbGHeoTISXwFVBJ1FdA34NPPdzVH30MTYWXE7
	qtYqCxc
X-Received: by 2002:a05:6820:152a:b0:694:9a67:edf6 with SMTP id 006d021491bc7-69b78d81c1cmr2797284eaf.17.1778702170672;
        Wed, 13 May 2026 12:56:10 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69b25cb58b2sm10339019eaf.8.2026.05.13.12.56.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 12:56:10 -0700 (PDT)
Message-ID: <30acedd3-e994-4810-8952-613b7d0bd9ca@kernel.dk>
Date: Wed, 13 May 2026 13:56:09 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: fix block layer bounce buffering for block size > PAGE_SIZE v2
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>,
 Pankaj Raghav <pankaj.raghav@linux.dev>, linux-block@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260507050153.1298375-1-hch@lst.de>
 <683792db-32fc-4765-9ba6-3712af01676c@kernel.dk>
Content-Language: en-US
In-Reply-To: <683792db-32fc-4765-9ba6-3712af01676c@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/13/26 11:15 AM, Jens Axboe wrote:
> On 5/6/26 11:01 PM, Christoph Hellwig wrote:
>> Hi all,
>>
>> this series has two fixes that make the new block layer bounce
>> buffering code work for the block size > PAGE_SIZE case.
>>
>> Changes since v1:
>>  - update a commit log to better describe the applicability
> 
> Can we get some Fixes tags on these, please?

Looked myself to not delay this any further, both marked with:

Fixes: 8dd5e7c75d7b ("block: add helpers to bounce buffer an iov_iter into bios")

-- 
Jens Axboe
