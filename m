Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698F330AABE
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 09:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764841666; cv=none; b=al7jPn+tOGcwpWs3pEGAH2uuzSQAPS9A27n/Ik0f2TLQP7Wc3ARWVgsg1lQk8c0BQgI0fUM07ka7zpAgc05ebrKWTEOZ352lqNny9W4IoZFiXmlNXiXTyDayVdtVNe3XwWIQILl8fWNwF35IOPoHVFymDagEh6ICN/mR/hwya+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764841666; c=relaxed/simple;
	bh=taDeiDW/72M220qK9OMYywRnj3wq52jhDjlnqF5wot0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bz6ihOgV8A8DAhxxpc2KWnNyetNey2BM1DvHfQQHZ3dbCFvFIJVwDityRF+lR45LkuwQhHr3OnLpppJxHzkDO6/ExvPkyDYPo+Awy3uw0uqNqFoYfmDBSE1Axt/N3LRWZOIUjlhU2K1sK9W+3z7IydzCcJCTduiLA3VbhGU8oUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GC9sZGfl; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GC9sZGfl"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-bbf2c3eccc9so865941a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 04 Dec 2025 01:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764841664; x=1765446464; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lni2lotCj6H+AmjNSFQSoTPmehSO8h0OlOHdI4siafA=;
        b=GC9sZGfl00MXhKeOSZhztcJ5UXEMHYmXSdqkwzPgTaN6lvwSznnV3lDkwTabkiWWQb
         NXTBN8xqAMv3sGPbThvJZQkTSUJ1B//kykiiCgBZTpfjORQz9xrR/HfW3H43iK2q+FnM
         m6UanCA4zEZ6/Hlo7Cl/ndM5iW0FA5AuxqOBT/ojJYdQEFFm2GZm9MAddkkG7mAIBsbI
         UXecoEfEtQeWxcZ9J6iavwSRe2SVKi1tbQ4j1se2pQNhJfS3SfYZeN7QRtq8dKcv4M3g
         m2lUJYzlFvuP0xQLXmLMhckjIZmMaynUhtelZBvM31BotB/1eQ+ezIfJRzjH4QeoxR0g
         WPTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764841664; x=1765446464;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lni2lotCj6H+AmjNSFQSoTPmehSO8h0OlOHdI4siafA=;
        b=XZH+OU/Wj8Nj1pm2u7Q4rDY2k7HJRltd0fEPeu3vDIswoUs2tqyVGv+fWK1FFKISpK
         yemN6lYPZeeVAz5X86FWhWIOsWLUrrxIzH8xG72gFvYyOdp/Qbp+XVMhMtVM2CY9PWod
         wkdyDdkfddsc68cDSA0wGTui64FdB3owqD+T7g3AIPD7bPK32mcR18S+laFU/busqYEN
         GP8jGJyR7jTEpAEugsPdRkxZ/rao80cd3bAB5ltHuz0N3VsELw8lV54R0SO/EZ/BZpcX
         BSHFQ3ejy/hmDWsDmmsvRmIORBX31BufDDxmG+Eqkqd4Wog+pLDpQftH/A7mcOSrcD2n
         /M+g==
X-Gm-Message-State: AOJu0YxKSs8wO8kHcj4S+APh/ZtyQDGeyjt0SIxLuK8QWcaePDbJ4CiU
	7VDL7mQP6HFt/2y6WTC+T0UnCbybofxywz3NHGddeFhM9uGJE/73ZClm
X-Gm-Gg: ASbGncsg5jBty4MM5iV1eqXrjD/m52PgfuHsAbfkH4OjDfJhJL98CeaydwH1ITJYQJ3
	kKuRKLa3hOZbKu50s+xUvsXMHXfJ5n6zM8xDUR1yRXFQE992I3F1B+sMPMO6RcUQqzRID51vO4q
	8RZfx8gwa2tSAP0GP2AUYak7rhBuZFPgLwzHGmvmq2TqW/E16hzV1kSccJetbgqtb//Ys81kRnC
	UzG82K927nPi+L8Cg1H3+lwk3r2P87S7h3BBvxJrt4iIbO8Yf0Y/kVphgnkTLKpAsJ3EcNRRcQH
	QPcfjI1H7v9dsNeGaUDn3Ib0df5Mc7KKg8zU+M7O5rQi9VMhX7LO0Yt5LFRz7Ron/8UKar/JtrN
	k37itTplgF5UhK5pNaLy34B6xcITQg07AqVJ2ggmsGU9NGEEwl12s6bToZbd6C9vHSB/WCA1iJo
	DT9gHGF1B+vtPNqe7dHKgpow==
X-Google-Smtp-Source: AGHT+IE9SeIzvNmExcdm61AyXbn0uVh81iIMx0uxAy4DyyaP+xY4CdD610P0GtcDBk0yH5EmUV6Cug==
X-Received: by 2002:a17:903:1104:b0:295:55fc:67a0 with SMTP id d9443c01a7336-29d9ec32352mr32461275ad.2.1764841664484;
        Thu, 04 Dec 2025 01:47:44 -0800 (PST)
Received: from [192.168.0.120] ([49.207.204.153])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae49c8b6sm14822935ad.13.2025.12.04.01.47.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 01:47:44 -0800 (PST)
Message-ID: <7f554000-97da-480c-8ada-a23e32b43f4f@gmail.com>
Date: Thu, 4 Dec 2025 15:17:40 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] xfs: Fix xfs_grow_last_rtg()
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 djwong@kernel.org
References: <1e5fa7c83bd733871c04dd53b1060345599dcef9.1764765730.git.nirjhar.roy.lists@gmail.com>
 <aTFWJrOYXEeFX1kY@infradead.org>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aTFWJrOYXEeFX1kY@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 12/4/25 15:06, Christoph Hellwig wrote:
> On Wed, Dec 03, 2025 at 06:15:45PM +0530, Nirjhar Roy (IBM) wrote:
>> The last rtg should be able to grow when the size of the
>> last is less than (and not equal to) sb_rgextents.
>> xfs_growfs with realtime groups fails without this
>> patch. The reason is that, xfs_growfs_rtg() tries
>> to grow the last rt group even when the last rt group
>> is at its maximal size i.e, sb_rgextents. It fails with
>> the following messages:
> Please use up all 73 characters of the commit log to improve
> readability.
Okay.
>
> The change looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Thank you.
>
> Can you submit a test case for this to xfstests?

Yes, I can do that.

--NR

>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

