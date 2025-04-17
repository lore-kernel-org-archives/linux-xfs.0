Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957331E49F
	for <linux-xfs@vger.kernel.org>; Thu, 17 Apr 2025 14:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744899284; cv=none; b=l8ZxdPK1R/yhaAAY5fUMB/5ir1UuhsNOuZH3in9MThcB3uJBG91Aquj/yEq6D1fU/oOGvZWA23EktSPlIgR/RyRdtTXHEZSnRd4cZrwc/EcC0ZXzJrKZa2OMdhzP+yecLvoodilLsaE39LjgyUm+/B9/9Qeg8ULm/DyktenGkpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744899284; c=relaxed/simple;
	bh=PHipDsCHak1c/eMdQXa07T6IB9oSI9JZ/2Qi75AY/W4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZBh6jRjL+LMkUfBjhE3/PLWVqb00IsYe5bfGq603tRlN2OWQVQJ2WODMRc4vqsjhgOP43TGF58KWYIi9CGA8zEOh67Fcx0zHY1ZYwwdpnEW0QUDt2SjRb5R2zRg8a3NtRbu+KhkAcXCF/0sJDWZQcLMui+TEBK7srR87mZu0GQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dIztZP6S; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dIztZP6S"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ac289147833so151351766b.2
        for <linux-xfs@vger.kernel.org>; Thu, 17 Apr 2025 07:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744899280; x=1745504080; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:disposition-notification-to
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a8sqJ8uWezZ2sJM82D++dq/yIQRZ3WEd756/6ZJQ4to=;
        b=dIztZP6S3QylbNL/eqr9Z0Mf/Y7iYPacAE7lSXETJy/hBsDGBVkojNroQYTpp0WL4l
         fl10uW7eHr6Xyb3XTJ1UfoduSCL52tJGHdzsEO2015tGDW77wgzCdUoKzqhzXqlgDF4d
         u2HrC0xlVzy6HJ5e3a359Dyt4uVPthk4g5790QnZon0u/OYz4dWClFJgDTw94DlrkBme
         ZSMHYGzeA5is2KxNE57NllmxlCh6P+QW9KQR2ZiE6S94OOyibY5Z+z6lT5jh+oj7+r2Z
         UCkXuZ5Uh/pHiM58ko+PChCO8rb8VIGH2SuOBvFlqGBH/N4wNTSadazgWTBVMhNRc3p9
         V0fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744899280; x=1745504080;
        h=content-transfer-encoding:in-reply-to:disposition-notification-to
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=a8sqJ8uWezZ2sJM82D++dq/yIQRZ3WEd756/6ZJQ4to=;
        b=d1GtUnVG99fXL9RCGVBLLYUNPp1Xl1NG5CEcyqs1QorLUQTOmScF6wEe8I26cm6+UM
         3WLF2h6/baLEEmKugMlSe30hBrdYlaGipgfchKdk9MhgTaxhdues3cIn3ERcy846Xws/
         VItYMWvX2PXAEATBjuzWos5Lt6aqtDT78sx+7LJkwps9vRZGf/asHAoDaBxksOWWNvUU
         bSdix+EmjL3Dp44f0VZxPNo2/uzTHPGbcwuBWBW6LHYhs4+6t7IGNAIo3lIBDl3YwKQD
         zaSA5tUMKoyF2gxMjk8hNvKnwG/GPy5raNbPFKwBvTWaLcuIGiH3zO4RCuVPNtbygHw9
         Su6w==
X-Gm-Message-State: AOJu0YwJsdJUHv5/OI/w5shl6OXonMkqtxG4R+bGMGDPd5LlnFBUILd5
	xOjjD6rRh5S/jKedAsEwJM05aqLiLOMCZa6CyGehTUj2gocuE3rr
X-Gm-Gg: ASbGncu5GQrE9AMkLQqJ1RICfoKT+hvMhTZ6KatvCUrYBXYGFgwebPP/fWKRhtco/u3
	ziFYaSFL48JQdVYGQSGqshTVRTJL4A4aipnpmy6gLBS678bmplrNXz0HSLsmitPzXwNgTTVsX4t
	MpQGzKfckD/TyCmg86TZL2vuAT5k758PdVMK18KpUUHbKgltMSrW3x3v8RycwBxfCcYfd6p3Har
	u8dZz9LzvL1lTPHYZ1Oxql0pn693/fnyyc2tEQA55celKRN0VyOwaeh/g0TmXWG1wb4mi2NMzNP
	eSPP3c6HZhAGMa+p3eVrV7teyG9rh4j3eCUjP9tSrRgVGcLjy9aQLqZlU6gCG0hvwfEl31n1CUE
	=
X-Google-Smtp-Source: AGHT+IHxdJjZnfHzPAoXMwc93rHc38RE8eLaYd+JBl2GwrehUTE/uvCaunaZCov9fB1PTa3AxdwC/g==
X-Received: by 2002:a17:907:86a9:b0:aca:c864:369a with SMTP id a640c23a62f3a-acb428dad28mr553126366b.18.1744899279522;
        Thu, 17 Apr 2025 07:14:39 -0700 (PDT)
Received: from ?IPV6:2a01:e11:3:1ff0:a52d:d3c8:a4ac:6651? ([2a01:e11:3:1ff0:a52d:d3c8:a4ac:6651])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb58ef85ecsm125014766b.115.2025.04.17.07.14.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Apr 2025 07:14:39 -0700 (PDT)
Message-ID: <6882ed09-26ee-490b-9a07-8178651b9d8e@gmail.com>
Date: Thu, 17 Apr 2025 16:14:38 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/2] proto: read origin also for directories, chardevs
 and symlinks. copy timestamps from origin.
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
 smoser@chainguard.dev
References: <20250416144400.940532-1-luca.dimaio1@gmail.com>
 <20250416144400.940532-3-luca.dimaio1@gmail.com>
 <20250416160716.GG25675@frogsfrogsfrogs>
Content-Language: en-US
From: Luca Di Maio <luca.dimaio1@gmail.com>
In-Reply-To: <20250416160716.GG25675@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Thanks Darrick for the review

> On 4/16/25 18:07, Darrick J. Wong wrote: The protofile format that
> mkfs.xfs uses has been static for 52 years, I don't know that
> expending a large amount of effort on it is worth the time.  If you
> really must have reproducible filesystem images, would it be easier
> to allow overriding current_time() via environment vars?

It's nice to preserve the source timestamps, for example, in case we
have also reproducible builds for packages and rootfs (in tar.gz format)
Fixing it to a set time would lose that information in the "translation"

> On 4/16/25 18:07, Darrick J. Wong wrote: (I also don't really get
> why anyone cares about bit-reproducible filesystem images; the only
> behavioral guarantees are the userspace interface contract.
> Filesystem drivers have wide latitude to do whatever they want under
> the covers.)

For distribution of said disks and avoiding re-doing work (eg: if the
checksum matches, we know there were no changes, thus we can skip the 
publication CI)

I've reviewed the patch, in order to not change the prototype file
specification whatsoever.
The new patch will leverage a comment that `xfs_protofile` inserts since
its first iteration:

": Descending path [foo]"

This way, if the comment is not found, like for older files, the new
behavior will simply be ignored.

This should address the compatibility concerns.
I've tested this incoming patch with a matrix of 
"old-protofiles/new-mkfs/new-protofile/old-mkfs" and it seems there are 
no compatibility issues.

Thanks
L.
