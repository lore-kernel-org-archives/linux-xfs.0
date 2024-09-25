Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4389E1D5ADC
	for <linux-xfs@vger.kernel.org>; Wed, 25 Sep 2024 18:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727290622; cv=none; b=larAq/frwYx5Dlyh+D9TNLtW/DUOAzsu6qSPdyKgVf5OPvYt8aieZFjem6AzfpVLbCnD2p7S2RPaqGdLNIZJxVQrHjantsizEVt6oK/ZOmmkdqwcv7ozTTPeJkdsUL0pa0CcgGQgG82r3qEadfWjIUr9YNBtGCiPREtvj+si8SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727290622; c=relaxed/simple;
	bh=4rBnXXGiFHTqpkIwm8UtTcs7hwR2SLU+AooUtd4bdc0=;
	h=Message-ID:Date:MIME-Version:Subject:References:To:From:
	 In-Reply-To:Content-Type; b=ZJA4Jk2pmh6gV1wlQm7vTfgAuD+ttByPYIh4uhBPWtx/vQTgCJ0HH2Tkw6iAXzAq/w1ocNb5/GwNJziaMTIXhUs1GR8m7h30J4BG30833OpwnN+iXrwErLYdwi3WHpikxI4IwXlMkh8sU0Ghu2/r1xqBzjwU/lOt3CAA86WCt9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f4FZ9Oq5; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f4FZ9Oq5"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a8a706236bfso11668766b.0
        for <linux-xfs@vger.kernel.org>; Wed, 25 Sep 2024 11:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727290619; x=1727895419; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:to:references
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oT9gPF1Od20ea28bcdF8w9e3zNJmHYHO88Ebul+ybKg=;
        b=f4FZ9Oq5gZbYTmGI4CdlVYNmwqo/tPLoYAfHmQrEBREF+/bt+8ZZS++voQaO15tn6M
         YMRftTzhtjhEokLBHxpr2O6GP0DBb9PGEsn3mOvduahk1Voh1QCfLkIXqEyhVN8vGMlG
         2cxvgo6pnsdN2/YVjFpxZbMUK43DvfLo2Tb8oN3UJVuUTUqrbfLbqYGOj0xamQAuhPNG
         FhI7O885jjKsyCGZ81mY2YLK2IImXIgPk2yaXAtGfo3xLN+INk1nyEudwz+OtwFznUny
         p8rW6/vBzUcwCXMIpPnwsVgURQJTVJnPEbc+gZDHzo1hnRjsG8edCA01lOgQQWs+4X2f
         PfkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727290619; x=1727895419;
        h=content-transfer-encoding:in-reply-to:from:to:references
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oT9gPF1Od20ea28bcdF8w9e3zNJmHYHO88Ebul+ybKg=;
        b=lf0u8k3zFIcY5cAZSAQKgC8jydd2H8bJrqw7mEiXKPTiEcyFJv+TpyUxbixjphSWuS
         Gr3df6BzdvLzAClh5yd9cv4zx2Q+hGkCPDUX3bP5Iczq3HdLbNR3zmsbUTnOL2gCGgr6
         Jx5a8nEEcvspTDDC9esJIFzLak5YqUO04N5SUw3RLlXE5yy+/J5SSFkQ/UpmbO+cfEpr
         BZsrSNPt3xfFQOc+6DMN+nRZyFM0i8RNwGoB+3NFToqI5vH914IpHBg+xAN3wCno2jBt
         JVOl5gDdA9AQrMiHoGp9X6Vdq1ZnbzJDQb3dxxhq3PZKS5OQYHmgfCazoQxXNiObXuQT
         doWA==
X-Gm-Message-State: AOJu0Yz18PyBW5eJ+r8HnSxADFx3LY02/ak3B/zZS/SlqfL1lIWXX/ZV
	ctK2irXJzs4amrnAkt+9pR4fMSKL/XzeCHMCnl4OHGV1Oz4ukEuz/hAw+A==
X-Google-Smtp-Source: AGHT+IEjFTRHKuHvmdIcKh+V27y025qIH+BrVgUOimHYo8UI2GArqgyJX49N0fZZjJ7FucxrddL7CQ==
X-Received: by 2002:a05:6402:518e:b0:5c7:2184:2d95 with SMTP id 4fb4d7f45d1cf-5c721842e4amr2546251a12.14.1727290619027;
        Wed, 25 Sep 2024 11:56:59 -0700 (PDT)
Received: from [192.168.50.50] (78-0-56-95.adsl.net.t-com.hr. [78.0.56.95])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c5cf4c50a0sm2208129a12.62.2024.09.25.11.56.57
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2024 11:56:57 -0700 (PDT)
Message-ID: <0278bb98-082a-4f08-8a68-2310807d1993@gmail.com>
Date: Wed, 25 Sep 2024 20:56:57 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Worried about XFS recovery taking too long. Please help :D
Content-Language: hr
References: <5f7e37d9-2376-46ee-b6db-d74e14948b61@gmail.com>
To: linux-xfs@vger.kernel.org
From: =?UTF-8?Q?Filip_Stoji=C4=87?= <filip.taka@gmail.com>
In-Reply-To: <5f7e37d9-2376-46ee-b6db-d74e14948b61@gmail.com>
X-Forwarded-Message-Id: <5f7e37d9-2376-46ee-b6db-d74e14948b61@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Don't know where or who to contact anymore. Found this email on 
https://xfs.wiki.kernel.org/

I got an almalinux server with /var on a soft raid5 6x8tb disks.
There was a power failure and now on boot it states this:

XFS (md3): Starting recovery (logdev: internal)

Eventually it times out and continues the rest of the boot which kicks 
it into emergency mode. (I guess because it doesn't have /var mounted) 
and mount continues running in the background using 100% of 1 core.

This has now been running for 215+ hours. Is this ok?

Anyone having any information on this would be greatly appreciated.

Thank you!
--Filip
