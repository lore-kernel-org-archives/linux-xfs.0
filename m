Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EB844CAC1
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 08:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789977967; cv=none; b=Kbk1W7xPN+KuZnu+mYFecTYgLSPCM8wzmZtrWA9oA2N2V28aKllWazYraZALLcs2CVXEboWlxaTG+ZCar/av27+/t6S7FKu4rcbODcjIEltW6dLXNAsIUkfuMpZS+NmdWI8W50k1mzCK9Poj/U9fIcy1tU4Es2ZCYXPaEbs0qck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789977967; c=relaxed/simple;
	bh=weGnp7IBbryCjvpWBBTbgpO4sETZOPpzMirjmNwz5rA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gtrUymkmgUrpaHesciJaSIWhZswS5hjBTfD/IbnB0t4cM3yK7D9VMvOJhc+jOpZV4ZFuyAa6xjUGexPFMkMX0C/teCOvb1P0wS5HoXFmnGJNusfn1i1gxU/7djBo71dhfmsjjsrvDvKD4vKhd6jPiJMX/If7ENNP+ohsruvSXjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=0b1t.tech; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.230.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=0b1t.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfc9b6eeso27184166d6.0
        for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 01:06:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789977964; x=1790582764;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=weGnp7IBbryCjvpWBBTbgpO4sETZOPpzMirjmNwz5rA=;
        b=UjqbMrRRuHlwQ4yzE1VEywu1aGZyR0CpLfS4Rayv5A1eX7cvGe/EF36OP0S1UcLyu/
         W7KGq0xpgT35IE4taex9KcKtq7wP1s3qIPVdxlrqSTOFO7G+vhwZj1KfTniaofR2kFHG
         mUrFoDOUlXyiGtPndlYAhh3ik1I9aadVU6DTYqshNtCHTKTMPqh9fHWJM+gbutWkPtw4
         FxhAxj4/LIqkFi534x/qWRNxmGJUI9nZOldEYK+SsMIeljfcgHwP8Ctv0FIaczfR8Aee
         C3RI0s/OtiQRaicbvL4eIYGPIixLGhazFbuzPg5lC65SxCnJ8zLtujYNqmXA53ZZWNf1
         tvUw==
X-Forwarded-Encrypted: i=1; AKwUvBykWXUh497r/A+HY4lIJ6gOZmo9KW9eFh7Dbh12Fmk6bCpL5AL/4vBFyw04zJHCtRvpd/lNCK7aS7w=@vger.kernel.org
X-Gm-Message-State: AFuF++lUc87U8KsCj18nsD4XGWO943OJbxO+hTCCUvf5MP2uvk18gK+6
	QLDeZHjXs243HJ2A7cXPz5Q3VlOMuSwLxpaGXKhidv6jItYbgfBfz3AXcw0V0VAbnnDDvXtt
X-Gm-Gg: AYBFou2UsarDsbduio/dmMFX8Xj8tHs+wamAVVNqN4vFvC0jrT0SD2KSBZ2KHuc/Yrv
	farIJGTAsqO7uzL+R0Zv6bM4cKWAoqZGVFcAY34r+ZRsosHMlwCr7hX+UHShL8Rb0N4dUGFL3lu
	EQDZ0HnKp+B7+btJbb40AFjZB/VKPYL4BVFEo5AC3LTdDUW3vgAgpOTue7sUvVF52QxY/nXkxqK
	wCgbNAIYXw7X5ZFKq7Y3b6DYO/u796SnnIJwAvaWKOxtWXvEhrWfoMdcscZ9kddJ4BcIDXR9Af0
	NQLivKVhdifCl9BQaAOKx+OVoY+IYHEaQOtVhpOtiFYuS/BQRaKIFQSx/eZ63c6ynm5QzfaMvGH
	Tx1uUgS1TziUze1dDCn4A/SZlpwPsLRy4me4H91dONkl84LtyejGwzAcr0bAZi+t9Cs5jBqbU38
	/lINDmky47SyHomfcH4bvCBGoOVcsy4Q6OAmqGAHfsYFFtB6NsFa4GWhLy9EpWUwCsssPOTjj7B
	4RXpNSYbKvT7HRNIJOgHZAhMI8Z
X-Received: by 2002:ad4:5c6c:0:b0:90e:9d41:d44e with SMTP id 6a1803df08f44-9129c7904fbmr94445676d6.21.1789977964021;
        Mon, 21 Sep 2026 01:06:04 -0700 (PDT)
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com. [74.125.230.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91260aa0f99sm61790226d6.38.2026.09.21.01.06.03
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 01:06:03 -0700 (PDT)
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfc9b6e3so32560996d6.1
        for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 01:06:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxi4JhdnsvFXfOzogItaL90svJTXvDCMal+xfu4eHv+pRlLmGpM02GYcDkHyQJpLojDjMMMDA4wA68=@vger.kernel.org
X-Received: by 2002:a05:620a:7013:b0:939:fe9a:6437 with SMTP id
 af79cd13be357-93bf551bb21mr913701985a.6.1789977963158; Mon, 21 Sep 2026
 01:06:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260909060924.1102037-1-hch@lst.de> <20260909060924.1102037-14-hch@lst.de>
 <arDN1UdZIydNLUjz@shinmob>
In-Reply-To: <arDN1UdZIydNLUjz@shinmob>
From: 0wnerD1ed <l7z@0b1t.tech>
Date: Mon, 21 Sep 2026 16:05:52 +0800
X-Gmail-Original-Message-ID: <CAKTh27_szTVmVmV26ASynzdJUwQEe49wCxMNq5ifRH9z7tiykA@mail.gmail.com>
X-Gm-Features: AcwNN1V0k4-278Z_kDhRyPxGbZjTPAIgWklsd_xSilZS02b4Xifc_jGYXYctnbM
Message-ID: <CAKTh27_szTVmVmV26ASynzdJUwQEe49wCxMNq5ifRH9z7tiykA@mail.gmail.com>
Subject: Re: [PATCH 13/16] xfs: add support for lazy direct read bounce buffering
To: "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>, 
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 21 Sept 2026 at 14:40, Shin'ichiro Kawasaki
<shinichiro.kawasaki@wdc.com> wrote:
> I found that recent blktests CI trial runs started reporting the failure of
> the test case block/046 [1]. I confirmed that it is observed with the kernel at
> the linux-block for-next branch. I bisected and found the this commit triggers
> the failure. The error message "preadv returned -1 (errno 22)" was printed at
> src/bio-bounce-read.c line 121 [2].

Thanks for the report. I've taken a look at the v3 series. block/046
deliberately uses iovec lengths of 1, one logical block, and one logical
block minus 1 to create the partial extraction state that exposed the
original double unpin.

Patch 13 stops passing IOMAP_DIO_BOUNCE to iomap_dio_rw(), so the
request now goes through the ordinary bio_iov_iter_get_pages() path
first. That path validates each iovec against bdev_dma_alignment(),
and the one-byte first iovec is rejected with EINVAL before it is
pinned and before xfs_ioend_submit_read() can select lazy or always
bounce mode.

> AFAIU, the test case does direct read to a null_blk with bounce buffer, and the
> kernel side introduced some new requirements to use bounce buffer for direct
> I/Os. Then, I guess the test case requires some refinements to meet the new
> requirements.
>
> 0wnerD1ed, may I ask your help to fix this failure? At this moment, I don't have
> much time to dig into this.

Setting csum/read_bounce to always therefore would not make this
particular request reach the new bounce implementation. Patch 16 also
removes bio_iov_iter_bounce_read(), including the special bvec layout
that block/046 was written to exercise. Changing the helper to use
aligned input and forcing always mode would test the replacement iomap
implementation, but it would not preserve coverage of the original
regression.

I have prepared a minimal local blktests change that keeps block/046
active on kernels using the legacy implementation and marks it not run
when the mounted XFS instance exposes the new csum/read_bounce
interface. That preserves the existing fixed-versus-vulnerable
coverage without treating EINVAL as a successful result. A separate
test could cover the new lazy and always implementations with aligned
input and an oracle appropriate to those paths.
