Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33BB32A3F2
	for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 17:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764092298; cv=none; b=nRk3I/Zu7d4BvUhEHGwF6IraV0MPhn3UMYEcsoYA8IurLK4aIVBg9HWCeS33SSSUM+PtiLsb46M16NxWmrxs/dtr5Cj+Sv7ZJRvd7tQ8XrME9H2RGppZK9hp/8udmjjEH4U3gJoCF+EpKtgPridRxHC3S5m15AZWIyLCfsVkuCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764092298; c=relaxed/simple;
	bh=iPGMl91c7t5RGa6luUsGuLLK2Y4Uq1XKEbahe9phnZw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PjXmBwE2/wHTj9Vi9Jz0Q7o7ufPxyYpvZBmTfwLjkPa//L6FZh61Zl8PgX0iuvk+x7ppNpgCvklnbAWtcnuY1xNqGODCW+niljpt1w2ZDnCnta+fPFYl0FYsbwHGD6UhTuU3T7OhunlUz6VRs1LBhqPrOdixgGBov6894aB8YPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MP3eRqnj; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MP3eRqnj"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-948fbdbc79fso137578739f.0
        for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 09:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764092296; x=1764697096; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y/RYkXbjr0Zws5PkDP81koxcOw7wQafJJolXOcPbtL0=;
        b=MP3eRqnjDMu+VfgIgoXsIjZip2LrEx1us53r4meudiB9JGUbZ72aOCwHVqeWpcZFMf
         brjS7X4GVj403fOyNyRKQvVZgImprMv3zy3CchjzM+GyfO9KuAvEZRo5BLVq7yb1JW5q
         SDs7kehGdkBeTBcTdxTsopwd7wvwVVqvy408yKdzW0gEqgdkhuketmjwGMzY7tz/Z1Oo
         RAYaSxGergG2kfyxRGyXiE5ezp35bLfalGIF4hzgKt+PdBqUIvuhfIChYxFmyuaIhCVf
         CD81Odhm44Ln9mP2TZF0/SRi6UX6k8xoOAJQc44N7ZQHA+ovauUoXEg2ucKX0zVJe694
         35EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764092296; x=1764697096;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y/RYkXbjr0Zws5PkDP81koxcOw7wQafJJolXOcPbtL0=;
        b=QQEuVwlfO9dwV1LWgP0V+MouS4mzilAxCHmu/g+/rDuyg406RTx7NdA6iENjSLG83b
         n2xUf4VSoXDw4kcq5NHp68uM1/yauZnBqJJZ3+opX33Qr1AGryeRm1BeGaUffTCJMhj4
         vZDTbvVfTSPc2XhFUnAzlwiO3n/X1v5dJYEaODRVf6dEi1USE1reLnwCys2e25MFS1xF
         hGPPKEPEtfXxT5ak79j5UNh8JVYZ2+QHkrr4PMXwQk6LGj3tkbRSjfoo6FtPMslxXarG
         CAyGCT/OaMP5y0DP+H7bkneF4/oJwr+dVjCifQFdhL3WxWRbPzo0oTCSPdFOVNZzPwzR
         WCMg==
X-Forwarded-Encrypted: i=1; AJvYcCUfKSfRlt7POJrPFLKjfZ7VJcgID6xbW9N7qOhZsUC++Yr96kGTA2vvQZkXL5fAiNDuJVnBVQWIIuE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOSe5vsPb8QAP4CftBqTs29bCaGTw2b2DojaFpOzFQPZ744qH3
	KNp+kTD/L7X1P6Tcdxl7na0sWWz0389tSaH5MBQ6Bde+8K2CZhDktKsF3tiNDIA3+lI=
X-Gm-Gg: ASbGncuCwqDuYuu71ghAndyCEDyuZ/ebFmwf7fom3HFSq1oAf+kxu9NTAoIWoqI2fF5
	4mDNmaeL1+hmy1oW0/1ywDgAaImAqNyxzHVlXldvcMGHuHFSYh/5be3OeBY+Ctd1jl+l5RA06eV
	XQuYXABwGKJjMnKvx/S5bvQgjbuaKJCTjnzifwigDBqb9qfDNOt7I/wi3Nhgg33i6Ag4sSUiMYA
	wElPpHBeZeVFhSOjZGUBcBzp3To+Jldg28wpJsbKigXnrx/Lvxw9ESffX1e0XZTtnV/cyZoUp4Y
	gUyUi31lgLYvoYlRfuqgmNK0ufoJscOZ990PFPOR6ECwOXvckCwfkyXjrTEFLGfsfxeQ/dvGtbp
	HZQ5lP1G4VPOztasktvFsV3peHdwhhRAFlYKwdiQJaZsF432JSxE5b/wqZn7Cg/v9v3Q=
X-Google-Smtp-Source: AGHT+IEIHRk7SwMmVS4xtcTCAS6Qp+OrN5pgC4aYwqKQ9jNrDNwsm/zNssFdQ4CwiXZVR7EmZb+prg==
X-Received: by 2002:a05:6638:c0fb:b0:5ac:cd9a:4c4c with SMTP id 8926c6da1cb9f-5b999555c41mr3179432173.2.1764092295677;
        Tue, 25 Nov 2025 09:38:15 -0800 (PST)
Received: from [192.168.1.99] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b954b48bdcsm6970840173.45.2025.11.25.09.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 09:38:15 -0800 (PST)
Message-ID: <e3f09e0c-63f4-4887-8e3a-1fb24963b627@kernel.dk>
Date: Tue, 25 Nov 2025 10:38:13 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/6] block: ignore discard return value
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, yukuai@fnnas.com,
 hch@lst.de, sagi@grimberg.me, kch@nvidia.com, jaegeuk@kernel.org,
 chao@kernel.org, cem@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, bpf@vger.kernel.org,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
 <20251124234806.75216-2-ckulkarnilinux@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251124234806.75216-2-ckulkarnilinux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/24/25 4:48 PM, Chaitanya Kulkarni wrote:
> __blkdev_issue_discard() always returns 0, making the error check
> in blkdev_issue_discard() dead code.

Shouldn't it be a void instead then?

-- 
Jens Axboe

