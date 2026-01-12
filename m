Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3A833372A
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 20:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768249375; cv=none; b=AQizHhxDzv3GKel2wl8DDtltoSZo1K2Z1j8PbpJgV5CKqcPhgTuDnP9gOicEiyp0ue8pcTx2/GZ9autaXF4/qlWTSr6AM1Is9DigYAK97LMNATnh2Q3STwk9LZEZy2iMG3OaALzcrl7fhwu7eITUcac5g2Kk4cN93HAupRAlEJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768249375; c=relaxed/simple;
	bh=VLm0Mq+Xbhw/4KcFwhFW0O10++JM7RrRwqkrv4L1Hc4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ovhPFjEoDM84kP9ehixRMmc+kSNqyWvsNGHCCpmOyrA9tJPVhhpMd/BnwoNZ89OGvPQDZVbWsi3Vh56bXMOftIG5YukqqdcEaoHbl+1UGQ6nzrZhVO9cJw2135OpAcCU2xHsganQ3gSXP/ACbaeQAxHZxuL5/Md5vn77RRcjpxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iKMWt/jL; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iKMWt/jL"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-455749af2e1so3743370b6e.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 12:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768249369; x=1768854169; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IwWB+/fY94QWljmsXRrsjQLvx0GIiS+pb/U2oEVnEX8=;
        b=iKMWt/jL9SyrG4fjKn/e+71xNhlrODAxxIK9P49KqMT8B1PL17KTKTlH6+F7h53ONx
         60id+QaXkl7zfqb06N0WmoVrIW/NSZ5X6yyHqr6dL13L/DKAUSyQdqMOGFxvHr/6247+
         +F4T91ch3dbFEbiCx/W2zyynK33B5LRlCE4sVUwL8zp3w0LZW4osyGqSmSXDU0x3C0Mn
         LwhdwP+ryTUUDYjDVmQuRsj/QrgHgscEDGC5ISakIvw7OJ/60CNQeOIXU50r0PwaZw4S
         oWioaDx1ruh/LcIcpAYb6hz/YKEIcRpUfRFegOYf2ohC4TY9VIjcv7jAAwkJgUF0HEM5
         XHaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768249369; x=1768854169;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IwWB+/fY94QWljmsXRrsjQLvx0GIiS+pb/U2oEVnEX8=;
        b=YBNWvgCWJCqMKo+khjlgk9GaQTUTMJHVI7O+qRuLh41D6GcQNffCt1AI+Ea1QQScPD
         H3r9ZoiAFeVGlJnn1Tdf70Oo84p1gcaElGYL+JT08PrzGI56I9ESQcM8vWeClJ90GF0n
         8U0aF2YyutsXt7VBegA9JUiIPFrCeFA+6VPC1Bfm6YQX4YDOR8ACRWYGA0ZBvsH1fcLb
         M8yFqXAde/ubLTZpNL5cv7djHj2FaL5MI4Druf1XAV11kECbKVJJw8UkG/K/Xfe8uwIH
         01VpWN3lpH//8RYfcY8JxBGFSIqnhje50HVWUwUwP4UkQvyfm+sXMLeI1161NoR3BM3R
         hRcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfUUZhFpMDUZJRUE4/Qz+2n8DdZDa9b9Pr7NZUb9Z31AgsaRlR/1p7+ENDrMdjG8uJPcU7JNQNUOs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjFaKKh1LKRgK6K6NWfkGtTqPHRv6/5puIKzz6umI/eTRh1yP7
	7RL0NSAnwAqYisyJwEbpDJaLNPoeClmBN9PsTHrJnCbQ9FmfVIyTtNa+Zjk4QYUDWCja3rCUgZn
	rq2Li
X-Gm-Gg: AY/fxX6a6MagKtN0xKBNfjD+TvrIEDG2vk+T1t6ILV6iW99GegmXo9oEGcz7lFQFanS
	LVA8utTiaKJNkOnv94LN250yXGxwlsDYUPbxr9ucomMT2ZjFeOKZp9UMni8XgcFiyutJX6hZFQn
	J7k/ZqEGcWaDOaF71oRRPniqbVgbZqPbJIG/HfUG8BTpKqBnKyOC7MGU+ZLGHfEYX+ChtOX5OYr
	HT4GqSM5WRikkgYDn6BAOAqiAbd/aQgI1zCAvB56NFmpMSrjnT7lrSLzX6OSkgMlIjCbXiIuNoy
	YDcCMyw1Ptk3dTJsy1s+MSogw3OUxFyjfdUuqeHK/8ssF2tAmyBE66eU5Q46YRa7cdlpQWjTFv2
	pP45A94lnuXoOyCIDx1Wf3yBbIPRRdNGeeFy3EFTh2qmmnkPuMKIWXqB1WVG56X6rSGfp+uFrcG
	bg31MeWpw=
X-Received: by 2002:a05:6808:2222:b0:44d:9f05:7159 with SMTP id 5614622812f47-45c6223caa1mr322649b6e.29.1768249369411;
        Mon, 12 Jan 2026 12:22:49 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e183916sm8728075b6e.5.2026.01.12.12.22.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 12:22:48 -0800 (PST)
Message-ID: <7ac7d7ad-45ec-478d-b37e-ba369b9cc147@kernel.dk>
Date: Mon, 12 Jan 2026 13:22:47 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] block: add a bio_reuse helper
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, Hans Holmberg
 <hans.holmberg@wdc.com>, linux-block@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20260106075914.1614368-1-hch@lst.de>
 <20260106075914.1614368-2-hch@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260106075914.1614368-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/6/26 12:58 AM, Christoph Hellwig wrote:
> Add a helper to allow an existing bio to be resubmitted withtout
> having to re-add the payload.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

