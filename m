Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB411D5CD4
	for <linux-xfs@vger.kernel.org>; Thu, 18 Dec 2025 21:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766093265; cv=none; b=S79S11B9cvboMZSnfivI6lmJg5SWL/uWbLwaIuBlogHAmIQbQ5YzZgBlEshe4hB6CFNB8G9iWVoBsUHNirdxefuAu/ryidROeu/6vKsUPr9ZwUXcOrDg5j0jWVxUdqDgIb+d/hS55PIPvwsCy6t/A/l6qtXXpNDN5zFjgA+tJx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766093265; c=relaxed/simple;
	bh=ssp6MgaMGnnKdoqFisDTFr9/zz2YnKqd/trrmdIJETQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dt2F9xKTH+Gy/iu/yQ2gweJtEucOIJQMyrFKANqqmKV+9d+zTSSUy0wprPPxOWda+wxp1xrSlKvz6jWAaTNuidBjC7qvBkU8qtvCMkWqylshCNrhXM4wGinasgXlKEW43gIv+PZluWSI1JcGl9WT4iVNtBS9ZEhr0UWzJ/qCOoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IpjYr05S; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IpjYr05S"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a0a33d0585so10797735ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 18 Dec 2025 13:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766093263; x=1766698063; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mtKlcFT+8oac25TBdlE/6dhf/oQjmi8HEpnZr0zN7f8=;
        b=IpjYr05Sawiov8nyEBLLYIFxseaYcVcYw+kEAWNIRNBYXQnNs2xxUCG1Zr77hbk3uo
         mjbufBIrqT+dofy0t21RZAZJQSgXAxZbc7pgBx0kujOEHJKWkUARgbiPgFAcbtsYgmHR
         zfVGJaOcfMspIN9CY3ZayoO355IXWKcEQKzpY1I4R6CRwijqXR5WlY1CiJ2LGTYE6Q8G
         8HM0AMK6fygecu/1nw3jcCC9qWz5mJNJPlFhxNcGwi9sj2E3YMiFFCFCA8D8RhUXuaH8
         +FdtY3Xa1BkY/slmg/dtUKYydgIvtfJD3CEm86PjtTNWVR6O/wX/sgchkBdTMCluEIQx
         Xm7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766093263; x=1766698063;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mtKlcFT+8oac25TBdlE/6dhf/oQjmi8HEpnZr0zN7f8=;
        b=xIcf0sVU9Vq1FDwEBHE8gQOktiWAr1GD8jz/pjnMzMH9Gq+84CZkEPZT91R4uMJn1S
         vAiSlZQpvCg12lV96kF9T/ZYwadlBO4dI2BI9ogcFoH+En0P8dCxJv+FzLgnLml2sutP
         Ku+y4BXaQbmdq1obe18Td0mml5YJj7kpIOi1/xEgDg2AaHfxLMgq/gSUjIbDMk/JMnau
         Z/U92sJBgOoJsnPBpm7FfEXKuOtgnKo+C+oUanBMYKx3QmzpCBOUXEbImZ1e4kCp0c1x
         fcObsg7k1QsTZY8cEr0k6ZBFVrbPDSpemxdExrkww0l1rYcBE4CU0YZaptnjXlYSaZ32
         YywA==
X-Forwarded-Encrypted: i=1; AJvYcCUEqgrhSLCYWzAZVrnJh9DbakGZdGPm0No1q8LWkrA2qsGmbzSupylGyvN+fQkhYMJM99nWRrRwq1o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBDdAxOiYHwqldENAtgn2FQtjhHt8fLvQ7Pt8X+syQvLOJ5e4A
	0/eLSVfa6oFytK9MX51sQ8LxY1pwWaBSybHz+fNpvGMA10O7hR5kb82u
X-Gm-Gg: AY/fxX5zIDUzkL8gcT20MCXDiB4A/CUa9ki2xlsYmGfsOCSZhaGUdT9re1rqgaqHCD7
	FeoXmNSrb5B8Yn0aEjw4vwdeBQi9UsbQgW8RrjqzlR9Ql7KfgeJTev6IP2S1fMlGaVtiL3kdMc3
	kCD74rORQimCSwk7/FEYiJcNq+fBCTjAit3zESes/L5Lg1uUpW3D7j/T+yBfHWXubU6Au8R0Jwy
	CFcQVAZ8xoI7vNn6+LDxL/mHUVjcBe1Lj8nL/BEp7BUlfnVTJ7v5jqR2fK6LfprbM+IAjtqJKE7
	AWDvDOOLDgtAY3NW/GriqOGRXwDulzx4ChNrqJtHYypb6Tf5MmeFcJjk+vfgWUHDwALdboc4/St
	o5zSIw6AzsrwurcWJSDwe1AESLCY7oR8anrFN86UFphFKN34uLFgtH1CW9IXaYGBX0M2Ts6tBj9
	PzsW6Ku4jVgsVqjuM=
X-Google-Smtp-Source: AGHT+IFy7ceREQxfkIyUxi+oyD4JXaH5EBPvU1D27q3jSDSQbKE1yT3afkwTKTiOeRnMobUoeH8j8g==
X-Received: by 2002:a17:903:2ac5:b0:2a1:3ee7:cc7a with SMTP id d9443c01a7336-2a2f2223616mr6333525ad.17.1766093263501;
        Thu, 18 Dec 2025 13:27:43 -0800 (PST)
Received: from [192.168.50.70] ([49.245.38.171])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d76ce3sm2079125ad.90.2025.12.18.13.27.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Dec 2025 13:27:43 -0800 (PST)
Message-ID: <3286164e-71b5-4111-8c63-c6f9856a9dd7@gmail.com>
Date: Fri, 19 Dec 2025 05:27:40 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/13] dmflakey: override SCRATCH_DEV in _init_flakey
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
Cc: Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>,
 "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20251218073023.1547648-1-hch@lst.de>
 <20251218073023.1547648-2-hch@lst.de>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <20251218073023.1547648-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 18/12/25 15:29, Christoph Hellwig wrote:
> _init_flakey already overrides SCRATCH_LOGDEV and SCRATCH_RTDEV so that
> the XFS-specific helpers work fine with external devices.  Do the same
> for SCRATCH_DEV itself, so that _scratch_mount and _scratch_unmount just
> work, and so that _check_scratch_fs does not need to override the main
> device.
> 
> This requires some small adjustments in how generic/741 checks that
> mounting the underlying device fails, but the new version actually is
> simpler than the old one, and in xfs/438 where we need to be careful
> where to create the custom dm table.
> 

Reviewed-by: Anand Jain <asj@kernel.org>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
