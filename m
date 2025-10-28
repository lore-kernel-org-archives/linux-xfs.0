Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDF430F53A
	for <linux-xfs@vger.kernel.org>; Tue, 28 Oct 2025 11:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761652382; cv=none; b=ofIzJg5BAsTPzVn7TKqy5jph45XRCYCeQKxTb1B3ZLP5g//dgJpBOQUAvEw5oht8biZLAGKMmAATyhR0j54JlWUIZllhPlHfPwQmRdQQRRwhnVaz5F8zrMdNc6pPYPBoB9/Qf8uiY/4pn6kEe5+olGyPvmVAl2VPYE1Z1CLU2G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761652382; c=relaxed/simple;
	bh=Vi0FhiX/ggITd3I3NaqAnYfWEtdEdBan5sFdli9E1x0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o8pVGKPqvkL5v3M6iynRQov6xFQ35E8spwz/qTtLV69KdtwoBhe5WdeLaPp0JtM2VWf0ibBJFXKq9Ixf1GStiygYhTbnA955Dcs8o/T6jKO0CNBWtSfZ3wRTgmSUZFaryvOkh6q9jLO1+tIAOWuzl95PPtDN0vvKTTNM778fFtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=heqeLLJ0; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="heqeLLJ0"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-290d14e5c9aso81964325ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 28 Oct 2025 04:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761652380; x=1762257180; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9q6iVQdHrPdlSbkfXY8WLj2PD38JvG6sOUR5lttSodQ=;
        b=heqeLLJ068Girb2vt3WbZP96ddf6IJffG+EkLX57+qbPV2ZVZkL9gtEB6iX1t1zrCn
         lCF+KDCNwWYJ/zDEn4s3y3Ft1zJvFBytnhmWYYCK2QBUFUKPoKXqKge4sZnvKYO0ojmr
         4fLKhSjqXY1ih02Z5j/8KM61ixb8Rqa+lbiz5qPrW5cVBzU4HePdEpI7aeuCGoBhcrPt
         ysWaHc6ZQm6KMet2fhGYK+9tNVYKpphdYvz/oV+QrVVDVUqqnmx8UgVdsckTNQpaLP0z
         ee88+2bB1x0g/4A06RNxzsKOlcU7S1PFTh7+0qkmSVL2P1XcRrH6Miyhwg3f5m/QmR0Y
         xBEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761652380; x=1762257180;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9q6iVQdHrPdlSbkfXY8WLj2PD38JvG6sOUR5lttSodQ=;
        b=t4/wsWO2jNMBdk5c1lXsvFire2StM6uQIG2AYS9z4kzlV6ebAAjPi85eeAGh7wVLRe
         P/e7MfCjQfGjcv84XF7bbigfpc4yUYHhZ2y3fvDzqorZD3TKbfK35H1Xx8iaAgmswnDg
         xRv7qaVKUyA7JnETYAz9CSpa3I8LG+kAfgHg+qUiUJYl2t/76RkgNILQ0YlPSIRfAssU
         NGnpM/69miQV4hFgKy+c9Agk1ctIxtSNmHMSqcAaimsKoM3DUqMxFuYx0U/PAzfOq6YQ
         tkWVhNEVvBzVKkWUkZSnQZxFrP6y/j6tJz7T+wx1wQOLizzYLQlkdIfom/VsXiSnYGIY
         Gt1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWJtDAIfPsWI6KAHsWWHxQqtovpoMlR3oxM+vKftw1KK/MLS7bhy5l0zPWg7BPwu9bejK10pWSEArE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzsyo75TgGwcRpqHQ39jKEqvWkdk+PTczKwg87/kwetEh/x3hVC
	sdq/MXmCVb6HRUUXB1Q+SeB+bPNMG9JWcnHok4myKlCMZIHE+NE+6FeX
X-Gm-Gg: ASbGnctBPUvU8IqP/um/KJwPinXbaFvm75J7HkC4G/W6nCl8X1z9Rbcy3eKVe0ldf7a
	u/GWifiU39o/k8xVnsXHZUSDk/AtjGfe3Duule+Ts+13QEE/yVKDR2w8owdcZZsFPIAMcMPMaic
	xIXPKMoRdHy2E4SNsHLBfHDPJYgyuPmEacxlBzhvrMZaY5KaKpYpTUbz6QA2kthUR3mlOCIiPxp
	NRJDNvDvb+18nlLQE4JmmE4c48KHpnMdEwsLRcBSGFWb4Olpf3L9F9BYVYRS3a4DeDighA2yELq
	sAqp46NIVM4InTajytsD4x/qZJ+WpBJekdjKGjnNrsB2e1lKcapNMm+ZHs+4crB5APhlL1vtu5R
	HP/iSEiOCNKamRxc7m3c+GHIH1y6hBbS5dK1T9pe3LAgTgNS1ZFuHIiMn8tq5ut1v8vqbdJH8Cq
	eTYuuP+qtIZ5v5LtY=
X-Google-Smtp-Source: AGHT+IG4v4AwOlK6aSbRgipc1yI6p/3NKXN0fH+1iuKSdkqn9RVuz1RC/ZsuBzjtQhG2qSX1tRVw/A==
X-Received: by 2002:a17:902:fc84:b0:267:ed5e:c902 with SMTP id d9443c01a7336-294cb392202mr52068325ad.20.1761652380349;
        Tue, 28 Oct 2025 04:53:00 -0700 (PDT)
Received: from [192.168.50.87] ([49.245.38.171])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d0a4d9sm113605605ad.37.2025.10.28.04.52.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 04:53:00 -0700 (PDT)
Message-ID: <a76731af-72c3-42a2-ae14-d26c911d5c9a@gmail.com>
Date: Tue, 28 Oct 2025 19:52:56 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/3] common/zoned: add helpers for creation and
 teardown of zloop devices
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
 Hans Holmberg <Hans.Holmberg@wdc.com>, linux-xfs@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>
References: <20251022092707.196710-1-johannes.thumshirn@wdc.com>
 <20251022092707.196710-3-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <20251022092707.196710-3-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



v6->v7 is missing. I guess ...

> +
> +_find_next_zloop()
> +{
> +    local id=0
> +

added local in v7.

Reviewed-by: Anand Jain <asj@kernel.org>



Thanks, Anand

