Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E032517B9
	for <linux-xfs@vger.kernel.org>; Tue, 23 Dec 2025 05:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766468186; cv=none; b=GtgaiXja/E9PuuC5qj+ZrpivjMtSdQkGnbxylgIEDYAyFu8DOEeck6PIHuIF7CUPqmBKsgXyeW1qpgvXfvr6Y37b/6Ke9745swg71TypEpLPZpnavRs8GJ2vmvNxfQDVQIQy4Pvt3MbBO2df+ZaEoUWdysnhpxSSKl/3JobwzIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766468186; c=relaxed/simple;
	bh=VlgqwkzGyrE3K5mQqCM6bG2Y747dQIeSyi7etFJLJbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b5J0O8oEZAhugHGpN9b+lr/1TLcO3InXvIT1u5kK7uqXdUMaLylABdDx6jxWjeP8QXkP7GScmus3/LzK1NZwX23ddOX50QRFByCxg09ma7r1HAjMornyDPqCG84xejI15t72iJU3OIGCeZ8Bt49K05j8iSnKAIi5kOLWGY87k7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KAaAzbrs; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KAaAzbrs"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-34c2f335681so3616546a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 22 Dec 2025 21:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766468184; x=1767072984; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VlgqwkzGyrE3K5mQqCM6bG2Y747dQIeSyi7etFJLJbQ=;
        b=KAaAzbrsGMa/yJ+ZeX66ACX313azU6u48dvdzrBwSic4HN62sJmYDXTq+VchukDU1L
         8sG8trF29f9VOcpuO7lWFH+BtnrkVzkWLbshB/5Fh07Cpq7NqkxHa1xuesIgnE8tH8Qo
         c3+byqUdmpSNC/AP16Hdfch35yejCD2kiF38JOHoQK6gtdj4WyMVRlnjcQ++8plqDvIq
         NINaKHODJxbdRib8oUYW69eNX7+AvJttzXqe0FP4ujNyHKM+xMXIBDuh4kEtf5cTmD4y
         0aVURA8jPi1DS5UAj6B/qSuo7DCtY/esApe51d34XyvYMy48PHQzwV0SOMUwYx1DdqtY
         fU8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766468184; x=1767072984;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VlgqwkzGyrE3K5mQqCM6bG2Y747dQIeSyi7etFJLJbQ=;
        b=j2CJni9HlhmFoiBTprx974xlvzeswlFUWzx5Bix7Y31+pTltwMPiuLu3grGSOQNkId
         ZAENX4L5PKrsaJM7uoxVz/xZL0vwVrlr5IZ9f9U8XLwBIMARISTX8RU1/+1yrA0J1NjN
         kq6RqGMTFw5bNnE84WKB8jeW5Za9/0D+Era8Sv3E8y82sbMgaXBaYd3mhPNpqBlZEo+Y
         clLF+wkX+xuMOCBeSrfqeG4U3eidm8lFTaiLqpeImTzCWX6ePv0216rvsY/2f4Y7C3Zw
         abY277VjqrR9P6ZCONV3DTWb3kA6HfDP2bppkdvdLXnXf5uyk2yIlGD6d825ECh4o9w+
         kiTg==
X-Forwarded-Encrypted: i=1; AJvYcCUXLrA//qM6/k4wXPBFGqBFBB6RJ/m8v6tlb13O63l8dgC+BVUhqyJvfr2wWbX8+GNOM04YMSEBSXU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw+52QVRlEoqI/IXbbN8oedrnOMyaojigctYNQqXmG2E/hnM01
	uRxYK6Y7TtUKtzs8uYsTA3Map9Wj5w5W98YCfDUGAVETt4R3Q9FYYvP6Q8Pr1A==
X-Gm-Gg: AY/fxX4cKDfGJHWnw73rFJh8Pp4nk1cEjdTDdpd1s6lbR4Qws/LUb7/z8ttYYDnh8n9
	svUkYcGf8oBH8Q6U85M8rI45mUR5j+TYjA/ycj+6JoB8KF1GHCtwlWe//+zJcv6436MHZhxH4sc
	r70C1RP6ZE1dk208CIyjzmD2PyK1I6g51kZRRkDJuxgNF8qCvYuxDqsbexvy3hrj9BKM0o2fg+X
	VEUm3HgNiEPVRvS56eC2gzQmMYyzUkC1rGoujg1ApBYqCOW/IWbfSNojgQ8ysox0FZrHwBLHU8t
	VwoHom7VzUPVfSP9TeDC2tUntIgNHP8OY14qg9CieoSYcReBoevPs2OP1zSYV4oz/CXum9N3VcT
	mUdS9qBrCiNxa3NJHuYYdUZMle3K6E+Pa5PjSaXuCzHiS2uUy4e1Xu8Yd+USAG7tXNgJ6sjbzW5
	fkS5edB0HJowFWKI3wpK9rqE+z8XCXQvLOkSYPnWB0Kv4NJPKO8eOvrpP4e2Xgm0QT
X-Google-Smtp-Source: AGHT+IFX/6+bwcWXg/4km6FqYdkuwnUGcop1hJcfw4hTgcVNu0v2yNrPtPf/mgK+hd5hIFUJyC/N+g==
X-Received: by 2002:a05:7022:3705:b0:119:e56b:91e9 with SMTP id a92af1059eb24-121722dff1cmr11158229c88.26.1766468183950;
        Mon, 22 Dec 2025 21:36:23 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217243bbe3sm54039368c88.0.2025.12.22.21.36.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:36:23 -0800 (PST)
Message-ID: <4e5f6df4-b446-4ec0-a0d9-231756ee934c@gmail.com>
Date: Mon, 22 Dec 2025 21:36:22 -0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/11] fs: factor out a sync_lazytime helper
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>,
 Martin Brandenburg <martin@omnibond.com>, Carlos Maiolino <cem@kernel.org>,
 Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>,
 linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
 io-uring@vger.kernel.org, devel@lists.orangefs.org,
 linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
References: <20251223003756.409543-1-hch@lst.de>
 <20251223003756.409543-7-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> Centralize how we synchronize a lazytime update into the actual on-disk
> timestamp into a single helper.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Jan Kara<jack@suse.cz>
> Reviewed-by: Jeff Layton<jlayton@kernel.org>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


