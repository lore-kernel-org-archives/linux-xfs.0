Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F210D30BBB7
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 11:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765364924; cv=none; b=u0qNVieUAD6GyVHIk++JZxWoBmLQg5OLxnoaYeqez5Qrz3/yB+CjLg+0akVMr8kugQy6Cjgr0RWIV57z/Lp9+hmoWMsl1z/fllrYoV+gESeXOO7os3w4nyi1HYcsQXv279BtuACYIHWzCFJ6XkmIrbA3PsKYYhxFafk4SCj6Rxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765364924; c=relaxed/simple;
	bh=xG2LKaFdeFwFddZxuqrbZWFjLxnAoxQlQuYXD8DlDXs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=RL4R4jR0vqpCLNE2xv2aQq/kJtcbYMQyU77+Kq0GXYds6lWhFfdp3Wn8ICIe1ADVhCMBp6e5dh37T4sEatFGg1FI1R+pMqQzzcY7XduePtYlIUdVv1pmJoNgttNZn3kzAYpW0jfZMOloRIVZNibwehG+K1zYwoG5TKtgPeSUmoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YKJngC5Q; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IfKejryJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YKJngC5Q";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IfKejryJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765364922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dbN0X68nlefB3xcMuCNuqErFYMQLXoas1dJiWtK1NzU=;
	b=YKJngC5QFIgoytDTKJuO/7Z1x1+WCpSxOUnNAkgbegIwDb0vgdVsDOpWGepjpHN1McfnkF
	g2yJjDc3GzLu+uWvL1IvE1xR1wEYq/pq+J/F2bc2XiTcAqV2luWTWgoSDGzGFRIIm3C9Pm
	eaLb5jLcwoFuL3d9DygLbCCPy9dDRvM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-262-QmmvPLSzOVWGs6e40crUeA-1; Wed, 10 Dec 2025 06:08:40 -0500
X-MC-Unique: QmmvPLSzOVWGs6e40crUeA-1
X-Mimecast-MFC-AGG-ID: QmmvPLSzOVWGs6e40crUeA_1765364919
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-477cf25ceccso54942585e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 03:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765364919; x=1765969719; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dbN0X68nlefB3xcMuCNuqErFYMQLXoas1dJiWtK1NzU=;
        b=IfKejryJ40ndd8zIfiCV5P/kjAB1bxGPWJkArA3mgSn922aYbv5nomsgZm849hvvuT
         2aZ+7CdYCjWJ2wsgZCFq2u/wjv4QFddHuYYzH3QRpahA1qOKFLGD1fj4DF+daiyqlFZH
         QWKe1nPMjWWBnTd62vGD5KZZB+eotmguj5wpL1HGzec50CTNRACrmg9/4/CE/yOQ1YBW
         aA+L9mz8yfkkGwHTiAS4fihf1WEyBLdG7UL5E2tC/tvSmsms5+GJ1IXoKBAsRBHxn8tX
         ZaM/0IKKUxeULCadwgIhdG2r8UmOc2XEG51YKYG65SiTSnw0iBhe1TARYLckdqmixuRF
         nCXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765364919; x=1765969719;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dbN0X68nlefB3xcMuCNuqErFYMQLXoas1dJiWtK1NzU=;
        b=CPTzdlH65RIqitSx4JH+BL5IysD7SAIKUhkJZmQq3L67BlG0M5npeDAu1TmE5u/j7K
         nb0+TVUPQOniQp8W7kZNlfNVL/wRakATJiIFIyJktvrBFKI+KBGFsBPsDuFejcYtLwV4
         7mwC0sJdHoMv2xMGxGQLf1WOXzdkPNqLG5IiFHFmIR4C4CdHAHHAnqga2wM5ETbRWQBT
         ejRXC7XMlOsVuTZFt77If8kE98KoTY3oTv7isywt4W+D9ZwlywQbRizPhblPHUmRiVne
         0EJnEEMxSrBQDf8lr8WMXcfQIHEqQUkAmcpNjkEy7emOUbqBfRzCz/53V/4wFmrIr8rF
         c4gw==
X-Forwarded-Encrypted: i=1; AJvYcCXgFTpuvM09GX/k567HtEQqXGZN2x+f9crzN+u/FOEgQBkPovuSJAlBn8adYC2WAUxeAwNumxv9Xp4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrBOqyJH70vC4zC/chqYDfDsbSfpvxCcLgBpkXB6kcRVfQfHwK
	RzMDlJ/B5LBa7JDuSSY1tiUcii1KVZ+4Os4XY1LNJ36CZwBZlywHRfR0qJkAHZ9YUJxmqyvzp++
	rhJj/u1k8poGCGWSl6S7VX9/rxmEZpRZoIeAtMdMIbHvnRko8UkB9cmPW8O3EkC+30kvdjg==
X-Gm-Gg: AY/fxX7KWo5bLVHPB1VEZEGKShDgE/23agfG2gYdrZk5rwamKnRxn+DMdgtY9mlGvDp
	a5BxwSJxDf8kdZPoy5ynM0qe6t0W3nEqZ7NYGo9NklteTWIiyEf1lBzThEvGGDrzsnPVHKqSSjA
	DHr7VsDMQUSKYYA+qmbRALPfgb84ET+3DGjxJI3jLby0V10UcXjWYZCnPtI9vWdoj7Nub6l6Ey/
	GGC1YywOy4r41CfRDzyoN7FcmzYAmQHcxYbsYahzp7M+DnRp57j8pTGcWatKzktZwu5uDOOOtJc
	zclnRNrY2WSk9sqef2QEVCgMv63QdVZUKOdmRVuxlB8TfQfkg1bhSrU7wQpe/CB9DClOLw/rtS/
	jAsHW5Og1x8qe1bf6G4iw8JrfarpB3Tl8a2+jQbitp4aaVyu90+yVh+5Dljo=
X-Received: by 2002:a05:6000:268a:b0:42b:394a:9e3 with SMTP id ffacd0b85a97d-42fa3b00152mr2209766f8f.38.1765364919269;
        Wed, 10 Dec 2025 03:08:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH0OaN9j3Rde1ToL7S2gPoe2gtnyWZiRtxW5eKFrQy2596pkXnfcwP8FxRZ0y1ST+KG1zmerA==
X-Received: by 2002:a05:6000:268a:b0:42b:394a:9e3 with SMTP id ffacd0b85a97d-42fa3b00152mr2209718f8f.38.1765364918819;
        Wed, 10 Dec 2025 03:08:38 -0800 (PST)
Received: from rh (p200300f6af498100e5be2e2bdb5254b6.dip0.t-ipconnect.de. [2003:f6:af49:8100:e5be:2e2b:db52:54b6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeae9sm37425520f8f.13.2025.12.10.03.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 03:08:38 -0800 (PST)
Date: Wed, 10 Dec 2025 12:08:36 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Keith Busch <kbusch@kernel.org>
cc: linux-nvme@lists.infradead.org, iommu@lists.linux.dev, 
    linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-xfs@vger.kernel.org, Jens Axboe <axboe@fb.com>, 
    Christoph Hellwig <hch@lst.de>, Will Deacon <will@kernel.org>, 
    Robin Murphy <robin.murphy@arm.com>, Carlos Maiolino <cem@kernel.org>
Subject: Re: WARNING: drivers/iommu/io-pgtable-arm.c:639
In-Reply-To: <aTj-8-_tHHY7q5C0@kbusch-mbp>
Message-ID: <acb053b0-fc08-91c6-c166-eebf26b5987e@redhat.com>
References: <170120f7-dd2c-4d2a-d6fc-ac4c82afefd7@redhat.com> <aTj-8-_tHHY7q5C0@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Wed, 10 Dec 2025, Keith Busch wrote:
> On Tue, Dec 09, 2025 at 12:43:31PM +0100, Sebastian Ott wrote:
>> got the following warning after a kernel update on Thurstday, leading to a
>> panic and fs corruption. I didn't capture the first warning but I'm pretty
>> sure it was the same. It's reproducible but I didn't bisect since it
>> borked my fs. The only hint I can give is that v6.18 worked. Is this a
>> known issue? Anything I should try?
>
> Could you check if your nvme device supports SGLs? There are some new
> features in 6.19 that would allow merging IO that wouldn't have happened
> before. You can check from command line:
>
>  # nvme id-ctrl /dev/nvme0 | grep sgl

# nvme id-ctrl /dev/nvme0n1 | grep sgl
sgls      : 0xf0002

Thanks,
Sebastian

