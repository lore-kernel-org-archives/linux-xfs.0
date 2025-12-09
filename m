Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDDE3148B1
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 21:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765314337; cv=none; b=PkYoxMlop5wv3qqll7I/di601k5gNs8+gZCb8nQPkQ68RggzaMOL7oBAqu8iW7L/m7wcxbmFPa8FTDS0LbOw1aGHgXsAV3EhGusPKM4yEg+zMEhQASRlkAK6H96dZ7ZnGJhLPcRtSYr+VFFLW2qnTgGyTq8Kf7nHrCRggtisPW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765314337; c=relaxed/simple;
	bh=ydHiuDxIrW5FazFjw0AZzylfnfdPPZlpeSRd2sqLG7o=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=lK4lHlZyju9kB5WYMtFma/JdqpufjybH8fiN7Vsq66HWNwkFFzkcLplaOONesx1D95D6nyiLX/U5VgRcZEGws1BYQkocmGzU+sWh9y6jNuGNFJjcYUOrQq/eSDe2ZU+ROk961ywaz7Gf945zYVdG6N7hiFI3rhX8pZX1gvwzbTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=is7gMYUa; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JqB4XQIF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="is7gMYUa";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JqB4XQIF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765314335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5JtO+/e6kTnIf7NZZ+Q5LHQ9Py7x/v7ASju/lUvZ3DY=;
	b=is7gMYUawmI0EZJw1HoshFPbtTO/10JlRSrT8GapIffJCZH17i1lNkia3vGMPlBWz1xFVf
	SK283/2Mdk9zNPDAPRS981lO6CUouuOXXuFXDPblZPvH3MrEjxA/QcquHPUjo7EU4uIJDn
	V8HZaJ/QBEwAxIwSfASfFTqbWESoyZQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-S4wZ1WgSORmhr0bwYaeleQ-1; Tue, 09 Dec 2025 16:05:29 -0500
X-MC-Unique: S4wZ1WgSORmhr0bwYaeleQ-1
X-Mimecast-MFC-AGG-ID: S4wZ1WgSORmhr0bwYaeleQ_1765314328
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477cf25ceccso50659055e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 09 Dec 2025 13:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765314327; x=1765919127; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5JtO+/e6kTnIf7NZZ+Q5LHQ9Py7x/v7ASju/lUvZ3DY=;
        b=JqB4XQIFQTMDBo0DM9hXP0OoRD2O4EH7EYjvfgjVC0YCqnd9vYOrPFw4iskOwCseVD
         U8IXJn4eY/Q7VfYTdtVOdIv8Objaf4gV3K4TOJYQZ28ENc63Wdbm0u9hzE7KyDiKmedW
         3p+Z7FonGNHXQ1JFI2oGWRJ8KizyW9OsTb3wV7WxcoouBCz8bVzrSmubhXLYUQD2KUAq
         ndCj9HVuLEfGDrRR11BLEIw7JiAuOlHX4NsArnaGQeXo8f5f8aVZE85qhKEK5B/6t/zi
         dKteimW8El5Hy/9qdPw/PmTpRtTMS13yvwtacnIWVE5U3GmCSaYhd/l6gmL5j+teQKxv
         +9rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765314327; x=1765919127;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5JtO+/e6kTnIf7NZZ+Q5LHQ9Py7x/v7ASju/lUvZ3DY=;
        b=PmTCmSvHRbzSzzmufYO+xGULuxivkhqiPh+YWYN4UvrUb1tNLvFNJpXgtYCK/GDoCa
         qniRsVmRRJIAlnN7OvuJuZWcvEh9664tmXMqJ+0ANaPzz1pW1DJwmtNWMSZ0tQwI69Wg
         wPMiW58uUDNAhWFgbKJAH0mFSPqZ0GLE04JQZvqFlWy0Ot5f59P3RmREl6e+u4jTIdQF
         1OXAU6ySCWH8Hp/Z+lvgVSbdmBBh+fayus+4nrE146DSkxZaZvPgZSztpBCGfUaWEgBN
         ze8Hip9Yh+tclJz7s6OYNYr39ZzfOzKuk626HrleQrJ8aVFv6Adq0n1hRPsxT5c5FYNZ
         AJUw==
X-Forwarded-Encrypted: i=1; AJvYcCWaaJ0+y4A7r6qWwmWu8zADeW2/bpkgtuL2qYMTH1YZbeRgt/x7+rvfrwHOEYkx78loGFuA4/J0KAo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHIGFd7wZG3OQQ1mMQJw+CM0/wOyepVIRZzz/hhzM8I67pwlmk
	iSt3P1jpUMsfOV6TdEdBGDQl0mL7JiUVhOIF4dBFDjZl8AUb+D3BJ0P4P7rKXNkjLNX6uzKLdWv
	8zKp9fqSsEWD0n1F94dTkH18C93u6vn/yVZiBfBrXuiFYOskcMMzOTjD0FNZs/w==
X-Gm-Gg: ASbGncs7NDn/Eq8IwfRi/9TpIEUgi/2mDF/NjryHLDettX/yoVBqpG4iOvUl3ke2ppS
	Qwc7+hDCApZ3wm85SsiFcPsNT0npgs3crQIgEfbStR8i9QtaWlTooKJVu97f7DDnMxof7+m+/QM
	t3VDo2iyowyz05AB0jRmE+N8NSwvY2FQuRxRXdg9I29vTM6dJjBdRzdydJWWN3U+yPMrUcvYUyV
	DdR85FdKFDWDaQ/gR0mMw14ZA2EhwA2qFA6PeNJGn972qcgmX5Wm3v4JAQpO/rLzVryAw7Z3gUj
	phSX08iNhXTQqKP+n9R1z2C37ElkMPvvlxGmiLTQQIjVFEiBvJosuFn4k97fXvqHmiY1LsG0m7A
	xDU0DCtbcXGyeRn/Blqp5LuEaM7XTV/pxeYB1wBukev0pzmbxx4KoAx8KoSc=
X-Received: by 2002:a05:600c:34d1:b0:477:76c2:49c9 with SMTP id 5b1f17b1804b1-47a83744a33mr2306395e9.2.1765314327652;
        Tue, 09 Dec 2025 13:05:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEtCAFhErGwzqpGWe7IpcJT0+41Hr+cUdeizf5PIDHvpAkbhAflBzeSLnGEysOKGluXPZLr/A==
X-Received: by 2002:a05:600c:34d1:b0:477:76c2:49c9 with SMTP id 5b1f17b1804b1-47a83744a33mr2306225e9.2.1765314327245;
        Tue, 09 Dec 2025 13:05:27 -0800 (PST)
Received: from rh (p200300f6af498100e5be2e2bdb5254b6.dip0.t-ipconnect.de. [2003:f6:af49:8100:e5be:2e2b:db52:54b6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a82cb12fbsm10202915e9.0.2025.12.09.13.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 13:05:26 -0800 (PST)
Date: Tue, 9 Dec 2025 22:05:25 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Robin Murphy <robin.murphy@arm.com>
cc: linux-nvme@lists.infradead.org, iommu@lists.linux.dev, 
    linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-xfs@vger.kernel.org, Jens Axboe <axboe@fb.com>, 
    Christoph Hellwig <hch@lst.de>, Will Deacon <will@kernel.org>, 
    Carlos Maiolino <cem@kernel.org>
Subject: Re: WARNING: drivers/iommu/io-pgtable-arm.c:639
In-Reply-To: <4386e0f7-9e45-41d2-8236-7133d6d00610@arm.com>
Message-ID: <99e12a04-d23f-f9e7-b02e-770e0012a794@redhat.com>
References: <170120f7-dd2c-4d2a-d6fc-ac4c82afefd7@redhat.com> <4386e0f7-9e45-41d2-8236-7133d6d00610@arm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Tue, 9 Dec 2025, Robin Murphy wrote:
> On 2025-12-09 11:43 am, Sebastian Ott wrote:
>>  Hi,
>>
>>  got the following warning after a kernel update on Thurstday, leading to a
>>  panic and fs corruption. I didn't capture the first warning but I'm pretty
>>  sure it was the same. It's reproducible but I didn't bisect since it
>>  borked my fs. The only hint I can give is that v6.18 worked. Is this a
>>  known issue? Anything I should try?
>
> nvme_unmap_data() is attempting to unmap an IOVA that was never mapped, or 
> has already been unmapped by someone else. That's a usage bug.

OK, that's what I suspected - thanks for the confirmation!

I did another repro and tried:

good: 44fc84337b6e Merge tag 'arm64-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
bad:  cc25df3e2e22 Merge tag 'for-6.19/block-20251201' of git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux

I'll start bisecting between these 2 - hoping it doesn't fork up my root
fs again...

Thanks,
Sebastian

