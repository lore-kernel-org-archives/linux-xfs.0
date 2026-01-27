Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365FB35CB86
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 14:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769525799; cv=pass; b=JKG12QcDbuNe0zZpmOgpMon0B3if9lPHyOumK+Php7UzP9wIC4yXdnMiP5FckceHJfy/Igbu2npdD0p+sLYa1ZCtsG/Nf4Br+siYGeQMHV/fKQmzTU4qagV0yK6weZmAurrqR/+b8nPBXjN5QffI2Hm6rz45XVZt4I58y4QeBtU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769525799; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gcfOaOhn2qYSbJZxZzIt4kaf7Ys2zV1ZovPPYGFbeD8ybu42W0c+3pSoGkvDd36tEZlmdus1egvXL3Dlhr6/1pVBNlOk64kGAmwVQDGhfWcqN8iahd1x/65IV45w6/qloiA4YH3QI/OPyvbiyHyWNmJhSH/AMcpRQlgKPvadcq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D6bBcinw; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D6bBcinw"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64b92abe63aso11585661a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 06:56:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769525796; cv=none;
        d=google.com; s=arc-20240605;
        b=fesy5gqyMHHD7es6O7Q11aXa7+fd3U7Vq/ZmdV7apD37SF3+vR85z0MiwRWI0BYb42
         nCuYs2zglgyFMp6aozlp4g54PxO7FAwq7HCdfHc6LXCV0DdhlvbMLO2jPQzg1VonqIN9
         qjOS1bcKLkUXotpUT8jSSk3Y6A3vdwzfr7BvN3DgUTUpBUNgZRP9tDRGwhLvjNPY5yHp
         OVSinsAySmMPCWRxyD/vUutKI4Yqu4YMXms/G2+TTn5jed8Sa0ovOJ0bDtoDI+K91gtV
         ufIBtQAsTCbf2tKf7cYk91tOc9/As4oH3BQzovnPhxEym9RzcELsdTVYqOfWbhDmfuKs
         owuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=x5h3ywS05IDDjdUMVUGt+UdefJ86dTr4l8AQ+XIndaA=;
        b=ZTKMGImw/y9JGZ/DwEK6ljGgfJgMfarI0n5wNc4NSbNKyiDzm53rwwFY+Jdya2noUs
         8QeVX5gPdD+3IThLXlNIVsq7wXfiRwQmhZnFiKAiqrdjN6QHrcYS71xGieXCGtDjNOKF
         vSY1TFUnHiWWR+WgGwTIv/g4lI2UmHULEufgotaI7rFZvfEgWef3lIVTBV++2ON3sbYY
         tb4rDcVKdHpAxszCstyEZSmXaBy7AQJuenrLUHnBWsC6sUe3Pw4Zt5xeYdtT1tfSPBuA
         pbDUWgfx0By3Q+W9WWB6KeGXgtyLtfA8rG8lIDCE8E7nPSc/YkKhh646PIYBZ4l+L/JE
         KLRw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769525796; x=1770130596; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=D6bBcinwm0RIvdV6DoySuwScrLT2pRNjw/p8hTZY/XYRWCnIyhhgION4m2aHtOl4YD
         4fck5g7uO1UyVoYR3WOTP82KvNN2GO9B+1FijMglTVx6gVCOXX1zoHPnNMwZY4BLmGIj
         95xc51jH7r1vukxG3p07DTF9Hw3ziAUY7AV+7RwXMm7skCHlh3Sn/f8qjf865jaok4VB
         +dt5k9wpaF7Vqjo7Ool6yRfGKh94sFCIr9ZostDjpsOffEvA4+NCB+fu1DAebuDuR0Wg
         Ej/i9a827rfdU90sILJ9TVrM6LdrlaWoA7D5zB1Ayp2n74aoREgAxS0MXfd8+cdI39Qd
         r1lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769525796; x=1770130596;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=aGGJYEvwMB6aKvNzQg7ybxCcCQyVc0VgIFiBU8lftpGbjJS91F7uI71rUkXriBqmyR
         enVL1rhlnyv0PxQFSkF/1ICkbHn3aEw7ZDm6aWXa/B11rGhWoqy42EmMAImJSvUA1dvs
         ++BjeOHJi3e3n7GpL6YEI3jV9APTxzUcCC8/3L1ZWnWk1Y9kIl+z+15P0y54rhIVm3J6
         D5e/O7Zhu/wZQm2OufL+jHbwtk/aB742ww8btHXh6ISkUH+pK4HMjVE1fuPRmQHCxMfd
         1dh5aLbpEuEN706XYn4XrBgm72H2hzROZn/bRV4NFEmeoUahORlVFcff1KljfB24I+C8
         2xIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYB/oQhVs2zOrLvycMuvrKkqfgVukBmP5HzSokRfFy/7hdLaMR/sUXiOfxbtdqOetaL1pmEdoZzxw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAcMpamxcF9QvGNAKbEj4zNgegDp12H4CZU0zIM39GvRndwhe7
	ofAUknvtCKxjQxjxMuxQyYYTQPe+sjt1r8R7eMspn176GLcS4rDsGvb5ljjm+PahmtREKPmhNMb
	KjurloVyFuRGgfx3H+Kzj7+6YCaDyJKn3UM57gg==
X-Gm-Gg: AZuq6aLiiHIx79tBkJG5OrXF2yW11TAbNaVNV+V+HyNGEtnrSJbK2pLaQcZVefuG7xw
	ncg4zPJtTZs1FjxFsIoh4vAFob+N5Ik8JHiTOL7g4on3KaBvpbrzuuZi/UXYlpr2YVAMXKza2/b
	AH79Xx1FFXyr5gwgybAuSC3PNM0M7FHZwG14ox59EdNXVVP1fNfTn7sGJZde4CMBj7evZUKbk3o
	VLXu8T2nJDWPBulRanjrksq4wEF4Xy9mDoAtlFA7xEGlPninH3+8fp5ueTi5jdRGPZ8/QjIJERp
	wfZTBtHJwHNNNe9kfZ7kZNL5Yz7WMyKIPY+wPHNjV4GSgDMqLod56emUpQ==
X-Received: by 2002:a05:6402:358e:b0:64c:e9b6:14d8 with SMTP id
 4fb4d7f45d1cf-658a6086b03mr1532367a12.16.1769525796336; Tue, 27 Jan 2026
 06:56:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-4-hch@lst.de>
In-Reply-To: <20260121064339.206019-4-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 27 Jan 2026 20:25:59 +0530
X-Gm-Features: AZwV_QjH1kmIMaQrUVHIXGBlrGO-v9DSB6aQQaOIY-kGTdF4jliUvC8MjPPK3J8
Message-ID: <CACzX3AtYb5d8iySouG5Dn81vtuwwGtQzqZdWCm-d8ZUCLq-6Cw@mail.gmail.com>
Subject: Re: [PATCH 03/15] block: add a bdev_has_integrity_csum helper
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
