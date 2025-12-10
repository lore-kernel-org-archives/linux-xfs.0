Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D868A27B358
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 16:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765385845; cv=none; b=eFDD6tKMKqyCfrLUCGxaSYX5wq2kmxkjAdk5NjEMNMcXhary1qhn+1Z2sij3JvKNNc0JfrHyCS74SuPbyca2q57B1DCF96RbRMlbqbVP5ZdjHQT0dqzzcfe1mFqSxKatZa9zBdNWaLQIJPUEHBbKd8KTd5GNM1kir12zBCUFYh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765385845; c=relaxed/simple;
	bh=ne8NvOAvFFZDyWLijTFkORn2krR9QgII4t00fOofTpM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=sAOsZ57ezGwXy6fZd2ADFscahrzeHlRUX+QbC3is/wN6/eXfLauqNAq9tDZF9Tt12SFq+I5lLIl6FAzO5cVDgPVVt6DhfY77dfRM1RrorwYN5GrC1xWWcFX/PleXBlXoMr/majz2lnr58546SRwiQZp3/ra7aSdSKw6FfeVZVos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GtQOUgUi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IhMQbZnE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GtQOUgUi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IhMQbZnE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765385842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n4vjuiVWtSeDDJf5R2NBM1m79JOYpshPwskFvViMdAw=;
	b=GtQOUgUiYFGGcRH62PMmkaKekNitZoWxqIufjh6W9Y1OQup2hIj3riQU3P0dO3ArPtJjIx
	XcDeXx+BT0Fsn3GIZ/yXrgaeIXiZW3AL3XpHGQl/g3EZUCHSp6ju9JPcBQzB19BvbOx0pf
	FqyNEA7VAfrNSHLptJtNdpqntmqcZXg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-HI2_uUZqNiuIBUbNxEebAg-1; Wed, 10 Dec 2025 11:57:20 -0500
X-MC-Unique: HI2_uUZqNiuIBUbNxEebAg-1
X-Mimecast-MFC-AGG-ID: HI2_uUZqNiuIBUbNxEebAg_1765385840
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42f9ece3849so1408888f8f.1
        for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 08:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765385840; x=1765990640; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n4vjuiVWtSeDDJf5R2NBM1m79JOYpshPwskFvViMdAw=;
        b=IhMQbZnEzW7HvqdnRIBc03cVEj/JATeuPXD6lZfwWrU4jA1oBhAI4W1EU69wPBbK/o
         jvP9cOcZB0WKvqYStCPmg6GlOX5Cww55yKQ/k4L1ldhSvG55tKCGeDeBOoRXq1ztpAPU
         KuuarG1IsldM79FlrLtx2KnVLkO7rKhJBSaVe6X8r11gVRP0zB7NkKIAGCs4fT8wTycw
         tdfQltDnUvGwy0WlJhPRyrsd2tMVDUFRDWJGSRWz85bVHsekXw6jpNvGxiQmKj2TplxW
         GFGpCGaiP8z5q5QgatgZwztrBVip9qynreRQHJeVdM9FAd6fAzxLAIegWeT1pSoQpFL2
         Kqlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765385840; x=1765990640;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n4vjuiVWtSeDDJf5R2NBM1m79JOYpshPwskFvViMdAw=;
        b=tC8SoJji6zQAt2K9hX0OKCo9PQuicrmee7mBmbzQrxVNsJARBegdiwk0ggr6HkBB31
         U0CZ+hwOFAjLW/SWiSAtFPnFQqCH6dWmvu0O51zZnefkitBC4En8KLfbGAYUWYKl6thX
         UQ/L/yHHE9YOyeM2v4kM/VS/CCQ7Ske2ftFg9d+zbi6vYEQRON9Mv7YiAT//zeTMNqGF
         lvHrlbQTtgKwaRjBksYNPW+3UtdfDY18BJokFO1X/yXrsgR1sZ/uHaboXl4Ocb6UTgOZ
         l+NryddWI2mjlj2LaQQJILUKIW0aV0RHG5Z5sCpkwK4MjO18C2UUDzqTUh1kNWWma4a0
         CyxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXv3Pbb21KalmWKDZ+YKVE+BBKGCZwfx5F7/ZG2KGaQnE+P5yYX8h2r6SCitFtEZgWl+LyoywH2MjM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwU27Rw1jCoQuFBks3wdBtongJwMI2xIbGbmd8EJm/7fZu3ZATZ
	Ouhhlsl3YgiS1bNM2I/mvADH466YEHZrrRUoW8dFNVLzDx/7urf3QYbQDQU7cc1PoXi27ouMWK5
	rMoSKQGS+TS92dnN7T9Eytk/uf6XDVvKJ4nbGDDutfAu5a//5hNJ0GTsMdkEzoQ==
X-Gm-Gg: ASbGncvXeOtKYkPm3yI2+lgHdLJiQ29OXXOzweExoUnh7Zqc15Thl/KwApJvAq10L6W
	4fBl8kKimnPA3rC4VhP2RtJtwya9wCMhejeY4BTbtSCBBd80b7lL4iECVI4BNsr4R5qJnBf125k
	U9xFCBEsAIGaEpxCZX4Kvhh/PkUu2e3zGQOlpwrSStKlgUeGZxp624/W2n4HFoaYgaztmE5qbzE
	/kDNAJggNp94P1CzulPH72WLfe0ZkOJGlflQQVW30zyTjiXBxHs2CDiHcPwe3ot5BtVEwJPDMo4
	SAG52RCPve5MVMS2oIcfq36jAG+j/rsfcIXk99waeZ+XxpnIWAK9SnmSxfkMKVJI9S+Q5cWxtjz
	FiQH8qnTLzGPmaz6X9VFNBa9d4w6alyHJ4pYmH+XzFMXVzZRMkRowcWpOOsw=
X-Received: by 2002:a05:600c:4703:b0:476:4efc:8ed4 with SMTP id 5b1f17b1804b1-47a8380c006mr28364505e9.11.1765385839643;
        Wed, 10 Dec 2025 08:57:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE1ErKmvwfO917QfwpOmc3kdwchwTX5DWogSYZNPVxkP8iDCKVQ0toYxrjvCOwIlDXwEtINDA==
X-Received: by 2002:a05:600c:4703:b0:476:4efc:8ed4 with SMTP id 5b1f17b1804b1-47a8380c006mr28364255e9.11.1765385839191;
        Wed, 10 Dec 2025 08:57:19 -0800 (PST)
Received: from rh (p200300f6af498100e5be2e2bdb5254b6.dip0.t-ipconnect.de. [2003:f6:af49:8100:e5be:2e2b:db52:54b6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8837fdd5sm1473825e9.13.2025.12.10.08.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 08:57:18 -0800 (PST)
Date: Wed, 10 Dec 2025 17:57:17 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Keith Busch <kbusch@kernel.org>
cc: linux-nvme@lists.infradead.org, iommu@lists.linux.dev, 
    linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-xfs@vger.kernel.org, Jens Axboe <axboe@fb.com>, 
    Christoph Hellwig <hch@lst.de>, Will Deacon <will@kernel.org>, 
    Robin Murphy <robin.murphy@arm.com>, Carlos Maiolino <cem@kernel.org>
Subject: Re: WARNING: drivers/iommu/io-pgtable-arm.c:639
In-Reply-To: <aTlXuhmsil7YFKTR@kbusch-mbp>
Message-ID: <6cb5157f-c14b-5a86-c26d-50aaadf8d3ca@redhat.com>
References: <170120f7-dd2c-4d2a-d6fc-ac4c82afefd7@redhat.com> <aTj-8-_tHHY7q5C0@kbusch-mbp> <acb053b0-fc08-91c6-c166-eebf26b5987e@redhat.com> <aTlXuhmsil7YFKTR@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Wed, 10 Dec 2025, Keith Busch wrote:
> On Wed, Dec 10, 2025 at 12:08:36PM +0100, Sebastian Ott wrote:
>> On Wed, 10 Dec 2025, Keith Busch wrote:
>>> On Tue, Dec 09, 2025 at 12:43:31PM +0100, Sebastian Ott wrote:
>>>> got the following warning after a kernel update on Thurstday, leading to a
>>>> panic and fs corruption. I didn't capture the first warning but I'm pretty
>>>> sure it was the same. It's reproducible but I didn't bisect since it
>>>> borked my fs. The only hint I can give is that v6.18 worked. Is this a
>>>> known issue? Anything I should try?
>>>
>>> Could you check if your nvme device supports SGLs? There are some new
>>> features in 6.19 that would allow merging IO that wouldn't have happened
>>> before. You can check from command line:
>>>
>>>  # nvme id-ctrl /dev/nvme0 | grep sgl
>>
>> # nvme id-ctrl /dev/nvme0n1 | grep sgl
>> sgls      : 0xf0002
>
> Oh neat, so you *do* support SGL. Not that it was required as arm64
> can support iommu granularities larger than the NVMe PRP unit, so the
> bug was possible to hit in either case for you (assuming the smmu was
> configured with 64k io page size).
>
> Anyway, thanks for the report, and sorry for the fs trouble the bug
> caused you.

No worries, it was a test system in need for an upgrade anyway.
Thanks for the quick fix!

> I'm working on a blktest to specifically target this
> condition so we don't regress again. I just need to make sure to run it
> on a system with iommu enabled (usually it's off on my test machine).

Great!

