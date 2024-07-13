Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E3B13BAE5
	for <linux-xfs@vger.kernel.org>; Sat, 13 Jul 2024 17:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720892677; cv=none; b=hZrDfDgNH/009s48891VknzlXn6AZIkgR1KYimt5rbRMuQFNCRc215WWBWjd46/Ta+n8EKL5kaSl3h28seGurJb8s6UWmNojRCxFa01w0huTBNJ1r0yoZj96eRalMuxk2Is744IHenOX4kBVlAPUsV7Ge5rfHGt/sVtqx3i/0Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720892677; c=relaxed/simple;
	bh=h6qj8j/tk+9bD1Mk0fOIH8Rdp8S07IKcm6LTSRSiDyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E9FmLkM7hz2vZJgXHzGa9opBhDmEgYVUgg5cwDit7HfWSLwKWo7ncFcJaYuMKcdXDwy0QltGqU+eVgM9Hrj62YEMqSBK6f22quXcfjSSUTEpa65pf/wy7v7BBvilw9Lggyy9yEGlCq79dsAvgaYD5Jc7P/ZFMz5vNROlYubDoJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=pkm-inc.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=NWUK4CaQ; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="NWUK4CaQ"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2ee8cccf2bbso2989991fa.3
        for <linux-xfs@vger.kernel.org>; Sat, 13 Jul 2024 10:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1720892673; x=1721497473; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h6qj8j/tk+9bD1Mk0fOIH8Rdp8S07IKcm6LTSRSiDyc=;
        b=NWUK4CaQ012fah0hBV9HJeu4gkqWZcCVvVH45ahSSpmkI+jPmzPYOhYzvBngs/Qk6A
         XkNYq+ImHKSvPIVkYq5H5KPb/QroqemkIB67sWxH4QXyBwX3lVbFa/otc6G6YWs8tu8W
         EBR02jeEe7a+pGvbF0LZX5AVqc+qwO2khDRDfGpFyJbw1NGs1sVtco+95BKDVCQvYNOt
         SKD5fvNMeyFS4V2e9Mo6lq97uBPqDFOoY9OYzJ9235KR3rwoEt3RELSijmblRgLhPF1r
         wyLUbIN4R3RfoFFsiX7OvYJATmJTti1SJhUG+busn3Bp7pHvbJrjdehhR7JWghBLKzKQ
         rQXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720892673; x=1721497473;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h6qj8j/tk+9bD1Mk0fOIH8Rdp8S07IKcm6LTSRSiDyc=;
        b=oeNPb+lGjrqBX2qNb4Mb9d5wvxXqDggIHS3hWFShpEhmL//wi9aVFgJh6/V2EAX6Ge
         cOja2NVgIKhE21KlBjhzzia7dg92QAkmJbzl2D5AovAzqVO4qpFkRz00DUGoyEJIKLLv
         Bb+c3lSEhDCUeCuBkmkd93Qj+8MIZ/fworLqeIbf8+erLedGBxxlv/DGa8UNqQs87jov
         BmVz/y/PHUFpIhWVGy4DFB+qp99DtiFI3mR3FF3A6qgsrCFKy9pLJ7eTmaCtI0JbZp5u
         RHvM7uOlhHjilNDHxfwoFoGs1nsCtS3Y8XkdkJ+g7vgId4kkVE/U7LaMNMi0GKkuGsA4
         nRuw==
X-Forwarded-Encrypted: i=1; AJvYcCUM4um4b4lMP71UV7VnZFWVAop+05IAlkSkScfiYBW6dVms7NFGf8LqdKSiX37Iv33o0S3dxp2YJPjjk/AG98sFVtfBhi/DLZ7n
X-Gm-Message-State: AOJu0YwiyzcrHEVmopQJ8MkfIDoJwgv6pt32cDmbz+jV8EXIRm++22YY
	32wsPalKa5UMQJG0U+Vddz1Lm2EVXLhm6H9rDqcdWJz9im6g+/i61HFb4SAUtBg=
X-Google-Smtp-Source: AGHT+IHOoxjWrTisdhlA1m3++y8eYZnLCX54VYutH2TnfyneT7NOZDzk2yYmDCwN+K4hxjY931Pj8A==
X-Received: by 2002:a05:6512:ac6:b0:52c:9ae0:bef3 with SMTP id 2adb3069b0e04-52eb99ff48fmr9920828e87.5.1720892673384;
        Sat, 13 Jul 2024 10:44:33 -0700 (PDT)
Received: from ?IPV6:2001:470:1f1a:1c9::2? (tunnel923754-pt.tunnel.tserv1.bud1.ipv6.he.net. [2001:470:1f1a:1c9::2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc80112fsm67927066b.183.2024.07.13.10.44.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Jul 2024 10:44:32 -0700 (PDT)
Message-ID: <aff42939-93e6-4a6e-b485-a313a1acb3f7@pkm-inc.com>
Date: Sat, 13 Jul 2024 19:44:31 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: How to debug intermittent increasing md/inflight but no disk
 activity?
To: Dave Chinner <david@fromorbit.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, linux-raid@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-block@vger.kernel.org,
 linux-xfs@vger.kernel.org, it+linux-raid@molgen.mpg.de
References: <4a706b9c-5c47-4e51-87fc-9a1c012d89ba@molgen.mpg.de>
 <Zo8VXAy5jTavSIO8@dread.disaster.area>
 <7c300510-bab8-4389-adba-c3219a11578d@pkm-inc.com>
 <ZpG///ZaN9KfPPcf@dread.disaster.area>
Content-Language: en-GB
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
In-Reply-To: <ZpG///ZaN9KfPPcf@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13/07/2024 01:45, Dave Chinner wrote:

> That's irrelevant to the problem being discussed. The OP is
> reporting stalls due to the bursty incoming workload vastly
> outpacing the rate of draining of storage device. the above comment
> is not about how close to "raw performace" the MD device gets on
> NVMe SSDs - it's about how much faster it is for the given workload
> than HDDs.


NVMe raid is faster than HDD raid, that is true. Relative performance
degradation is a different matter. When used with the default bitmap
settings MD raid sends a ton of disk flushes, even with full stripe writes,
and that kills the already atrocious performance.

OP should modify his array and remove or move the bitmap to an external
drive and see how much that will help.

