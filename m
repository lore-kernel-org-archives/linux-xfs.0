Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3DA214223
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 17:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739985179; cv=none; b=RXU0b7HeAzwCgk3UnzE4Q4E41+Ccw+jYXyj0K+bFhWX69P40McDmiRAZdCJTwvYkFtqCT47LnevmBE+Gk73fZac3gF1+1LNstI/OOaX5ladecOnZrdxTybFmimL9IJbvsX8SVR7rx6c5mpzB+c5qBaBeqILwihco3yDfCzHnhWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739985179; c=relaxed/simple;
	bh=Lha31XubA+k7fhd7fr4kwF9wfyExIRMIg5kuNPMn1B4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=paKuJ0RDYypDj6hxRMyBw6g8ojbVuZCDema4FXnsMBHKajHuEPRoBfWmtdT99iQgBkLKhku6n9K6a0+dGck+B0+PUayQVre7IG5hAR5C4BRCCRW6ItUEw3/0xwAMAXo5MWEPLr2FCZK6xMVhd+4GvvTtEIGEwZ5VfoPUovAXdSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iCLOkmbH; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iCLOkmbH"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-85598a3e64bso1781339f.1
        for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 09:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739985176; x=1740589976; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IQfGKt/Vn1M9EM8LSo6jsXvRLnjOcNMdYpalZiyZtNI=;
        b=iCLOkmbHzXHaMUY8j4sb8mNz8DTmjTpVUp19+4Ec9ZkNnRq1EMCPoXJE4cYRl16G+3
         fz1rPqxRYhLKm8kgZhe8wvksKfaR0wTp/XoXhQc99z8jNhUZTf6p/RV1rqJtF9qFktIF
         WSCuIU9uoBYjMSZ6dTBBqIP/yAdQY8Xt+U7w10OWzXP4iB/Z0zMn0Movu+qH42yzoxd0
         Ijxup8CNo/yz6ybIISEAjNIfRNqc/itSwfsFDCgQ3o06SB8mmuCu3E4Ao/M6DzGTsfIz
         YPRAh5RqJIFn77UQ/3Era5RVP3qBnLc1Cil9lRPElBhWUlY+6GIbT+yEqsXljeN62wt/
         noTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739985176; x=1740589976;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IQfGKt/Vn1M9EM8LSo6jsXvRLnjOcNMdYpalZiyZtNI=;
        b=KRxS3Ownam6Qjqj/NobPFRjXoOgr9l37EaqDuhH8aYmYhaGkgv4Ir+jLvUY8Ubso3O
         YWpjw70+bVDTUcnbKOG+c3DeTniHg5AzxqLi03i2dtwrqSEW1rtwIZMY7YGbuGUJd2PJ
         2LtJZK5gM7YYO1W1enzSGGbHHvByDjGsM2ePvw9G03uXo6+C8Y+cqmr4TI8kK9HoOIL3
         /R1UzGFmwfRg9jhyffskSuTobP2fFKemaUljpbk+Yw0rcZxTSs3oVic4BvUyIz4cay1A
         P5ngqqdISZj+m3wBV0n0IaNm9mOKTHINjZnhNZIlGUmcYPTm+whWvTSYL8ZJ0L1NzVK0
         o7qg==
X-Gm-Message-State: AOJu0YzZcaj3QZ/m6QKDiy7lmM6gTZ2yB77FOkoTwqzSofaz+66Aqd69
	ySEqPgOZSwHKTWmx2Yejk+cmUst5Pqnrndk7XDbi9xL2j5k0P2lD3Mg5YBiub9uSlbMIF3z5ph5
	L
X-Gm-Gg: ASbGncvyuD026m3sPIUBqmoIae8UMUKbu/sVkVc+vz2359uS6E+ipEbJeCQl7XybZXO
	e6b5/42W0MCuQzYpciyIMrpNl9nKdEus4TAAEnbfPLpBkuwqDbLsfHawbRU+64nP9IDZAo4BnZV
	9CRTsu3pqwQjxoB2O7jo0IEzO7YWmvmbASHhAJPzfSSGYaRTM8b6vkLeA7m9ut0Ii9VRu/f0S5P
	HOgIClIHpixSCj1fswKyBZt3p3yW06BUx1pz9B8g+gHyz0rhE+6OJVTmCDoqotN1fhSsR9N3gvH
	qhPWSJrBpxQ=
X-Google-Smtp-Source: AGHT+IFvCCYOL63Wo/yo1TFnKmtRWgsBPQ3qsvGNUh9DO0BmLmKTYvjxtAglatFmfgaYIZ82l2xmuw==
X-Received: by 2002:a05:6602:164c:b0:855:c259:70ee with SMTP id ca18e2360f4ac-855c25971camr79752139f.12.1739985176126;
        Wed, 19 Feb 2025 09:12:56 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-855a4caee76sm88876439f.31.2025.02.19.09.12.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2025 09:12:55 -0800 (PST)
Message-ID: <b025a842-1c67-4369-992a-494220755548@kernel.dk>
Date: Wed, 19 Feb 2025 10:12:54 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v2 0/2] Add XFS support for RWF_DONTCACHE
From: Jens Axboe <axboe@kernel.dk>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
References: <20250204184047.356762-1-axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250204184047.356762-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/4/25 11:39 AM, Jens Axboe wrote:
> Hi,
> 
> Now that the main bits are in mainline, here are the XFS patches for
> adding RWF_DONTCACHE support. It's pretty trivial - patch 1 adds the
> basic iomap flag and check, and patch 2 flags FOP_DONTCACHE support
> in the file_operations struct. Could be folded into a single patch
> at this point, I'll leave that up to you guys what you prefer.
> 
> Patches are aginst 6.14-rc1.

Gentle ping on this one.

-- 
Jens Axboe

