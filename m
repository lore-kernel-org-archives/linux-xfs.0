Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186F5379C2E
	for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 06:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779863307; cv=none; b=drPI/x3laRmoAMLloA3vu7HNYu4Xi7DxcGH0jkN5NKRDdYHcK1U5AHxZkojIPC+CIKLizyL4a+e/JFoyr1fIZ76W+h2DhXz9lqTFtOJ49BqwEQedqZJpnsaA5tBCN+4s6z7I5uC8haZXJI0GJ7zVoNM5uaiLiWle4XOqKhWbKQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779863307; c=relaxed/simple;
	bh=We6YWGS7Vshkh2dzgEtNCuoy5j1D2OYhS0q5NpjAujc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=loSvi9/lJwSDqPKYLjvBLQqYtJ+i/LvWtYbzdC+h0oMGfxsh196yHPE9q/J+BD0O4JV0V1KG1kIXvcH/Zx4KvtOiqR1czwCbQ1WtH+WhMTRjb4r/cBsl2wU0HjEOjFgycJ5QLDROu/F7h0afAc4R3w4h0Tu8leAqYCxIKe94Svs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mzm0qycJ; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mzm0qycJ"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-83d31ac4017so5693488b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2026 23:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779863302; x=1780468102; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1B3JgvbLHdgt03H+AXy7jnDMjCMjXn58V4DlsX2a7Ms=;
        b=Mzm0qycJl9CHfMgSlgQHQXYW881o+Qo0mDuO/aijZlgINppzzS9lnG4zJt4PRBTle0
         eH9EuBT2jtkIZK9X7ti/tvfu+z2rRuchsYTpo+3Dtn/VPdbgesbO4DdNowZHOgwqaJTW
         Jb1NFyxxn5N9nh4W+tdeYwHJ7zZ7juK6k1PogR9USDnqwBqytW4VBO4ewYZqBNiQtzld
         mTdnOxus8ZwSs2kLjiM583C35EOiSr7Onfo6Y+kihiGmZC7xQ1aUZb9acGTt98OSAqQn
         mH9uszKLe/7XPwHmVTKKnRDMenEsy+6McShUeTkMopbRVrb2i49jtDDwwFcCj1EjMvpF
         6xzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779863302; x=1780468102;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1B3JgvbLHdgt03H+AXy7jnDMjCMjXn58V4DlsX2a7Ms=;
        b=K+Y4wgzzEW3MsktCPWT/0caRLUFCO/lapEVAgG43IIsVJWxlMjnNGQBR/pvvjuWzRw
         hDd4GbtCIkyWjXsdOa2dQDBaloTQdSimTvU1IW13LJqML0EEL68AM3esfO2iar/Ig0jQ
         fCP7U1f+kaAqQ0SEqf8hP5IuWm8IOUURGC3mL/dUWAMaKhOAQKMWGzXVK8xbLAA0Hltm
         XAbt8bNdK0eiNvEsqri3mq4Vku5uHkSpnA/8YqwmfxINj19mL+UXd8l3pyFClceHtxSp
         wOlepUTzoky0r8mnQI19cRofY+CDh+HBKaVWbTF0DF75AHQCjzoyeDnzQX31ti91AYeW
         pXlQ==
X-Forwarded-Encrypted: i=1; AFNElJ+2IeXjJ20qIFajsUGw0QEI7LYCBidiYYIqfVfeSujXYDv7m6PnbXLTbYOh0WxTU9a+C18oLk6NRgE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywuuc2ep2UdPD4Eb8KapQE33kbnNFPo82YKfMxDlG2nPl4EG/Bm
	3sVVGgQgZWT5icrtxEEyM1TwbXhGmspnOeax+jCG9vYJcAp8HbVkz6xr
X-Gm-Gg: Acq92OF/Gnm5x6Kyd7L221dDHK4l/zstRdJWLaRgnmGlZzlp7lDrmCps4a3OY/jZbkZ
	oVgWc9SYCP7AFPGjdhNkR34Ay/NSE8oxrIRXeBYkeXjNbgr6zYV6f1L84Es9C02q580C7YM1YcA
	0NnBD7cyJQmiy/QhN19ElToQSEzSj9IGDXwBxS7V7EAYiO/5K5+cjtheb2oEVnpKTHgvNGcLdgT
	NUiyxC52BQPGF3NMbKNHLijz0hBScbDU8Qpl8Rmcj+iYQvUicdZzI21FR0w8J6Xf88P5mI+wRp0
	WOTZv57sFsAd684Cf+6w6TYaRIG+6UKQM9pNvfbpqrjeMg3hNXLEm9o1Y3b5+NYjE4FOy3rcWsR
	+0F2z0T6DHC/ugkcQoA501JOvQKWoIdCyGKpE50o9FM2kChP3qtIIzOSmFkvwUYt0Ma7kS3tLn9
	96NosNrwE8wbvrtgzFnCdGJLxnvh4AK5vQktUikUvKfEP06xvm
X-Received: by 2002:a05:6a00:3c94:b0:82a:5d55:5807 with SMTP id d2e1a72fcca58-8415f580e4dmr21715172b3a.6.1779863301649;
        Tue, 26 May 2026 23:28:21 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d7301bb3sm1215872b3a.54.2026.05.26.23.28.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 23:28:21 -0700 (PDT)
Message-ID: <e3dedd67-35d8-4088-8239-8ff145e70b8e@gmail.com>
Date: Wed, 27 May 2026 14:28:18 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/10] fstests: add test for inotify isolation on
 cloned devices
To: Christoph Hellwig <hch@infradead.org>
Cc: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, amir73il@gmail.com, zlang@redhat.com
References: <cover.1779367627.git.asj@kernel.org>
 <1c60be06ce79778404079c8b1c1d2e09f64cb38e.1779367627.git.asj@kernel.org>
 <ahP1tCc81ascjwxJ@infradead.org>
 <edadc872-5796-4cff-934b-cee66fde79d2@gmail.com>
 <ahU9hpwrXyZChw9X@infradead.org>
 <e8d0caf9-df8b-415e-9f89-bc71e73a0e32@gmail.com>
 <ahaOPOQYaE1wrbA6@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <ahaOPOQYaE1wrbA6@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 27/5/26 14:25, Christoph Hellwig wrote:
> On Tue, May 26, 2026 at 11:19:30PM +0800, Anand Jain wrote:
>>> fanotity and inotify use exactly the same backends, so I'm not sure
>>> why testing both matters. 
>>
>> I noticed that back then I decided to keep both.
>> Since fsnotifywait -F is only supported from kernel 5.1x.
>> inotifywait serves the legacy LTS kernels where required.
> 
> < 5.1x is pretty old these days, I would not add test just for that.
> 
>>> Not that I care very strongly, I'm just a
>>> bit confused.
>>
>> I am happy dropping inotifywait if unnecessary and confusing.
> 
> Not a major issue, but it felt weird.
> 

Okay, dropping the inotifywait test case in the reroll.

Thanks.
