Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501B42E7658
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 08:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764319113; cv=none; b=iFjXHyHwqsBapfh5y0SJBiZVFDjwi1URlkb2nP6w3QD9HZ5MjooBLbTZB1xl+a2xao6e8ZPashcYpFUnDnGqmBIkC8PqncTUB3bhTsqCpW1ehPLzLOL7H3ZFJclzT/EVc47gIqwcAc921XBs6xcF9hlFLTCagCpXPJyYxswzd2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764319113; c=relaxed/simple;
	bh=mG04EOy5shg0G6MHF6boM7DuHGiLByU6HW/XuA5FyN4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jLR+qxRQ0ksNth/Vr4vbLJRGTiDhTdIrgp27RqyKXn+xHWEeFep5YyPt+JkcafwLZOB5eQdKE9mwim0yEnMHNz/suU0uFsA+mdvE6zGMZzsAW+qLkZ+59twcRIAeljQ+T5LtFWYLo8qJ45XyumsIDF9F3ndgywVPJB1Ef4612FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dC2IxDOR; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dC2IxDOR"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ee44df7750so13668341cf.3
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 00:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764319110; x=1764923910; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=++QMIe2Gzi7z7FeXSAmSiuqg8P1uQ1lVTlMI6i3m06g=;
        b=dC2IxDOR0WeEmPZSlsUxwDLBGMsc+fIeXUYA+M+8wTeUPkh4BpLsVKWiIWaKfxtLNj
         s30DMr23fbEbBnmdth3SK0f8HTjXmqF+jpfglihhy6alcBMQrRfCQwWecd47M5pFVdI/
         UaNo6JCtvgYcDq7wVEFMYbujCkDcBTDPlacvfh1hsifnN4b8UIzOuIgib4dpdhUTJJbG
         2+WU1qaSortVni3Vwgk8eNvqX3pBqtlrAno69ovaRZ5lCGSvCGW7IcUP7pQpFuOWuyB3
         rVhw+SFUFjSr/dXCy/9Eo2Wo7ImEm0q7EpnxaFhaTiOJ4U6PHqK+EswOoX5dW4cRWPYp
         bnyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764319110; x=1764923910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=++QMIe2Gzi7z7FeXSAmSiuqg8P1uQ1lVTlMI6i3m06g=;
        b=g6DM4C3ZsZCHF2O6Jsauf7tZ81l9sAfRvcbu/24XJvWnSEUBqpVQFQeoXTtoxVZc/B
         6niuRnlFme19tvAaf/0hq+nZ52pRkJ3G1hT9iSLXSgFqtIEuz/knTEXovU3XK6qmseKj
         7SxfWpo6cXxmxJUc0WXx1MSfZLKe0PtF1EG3ELHf29iEBdEHHKpn8ngEn3x7s6qVtzsM
         HOe6IhW3Xm1eder+o1ig3wynU+m5gpBcl2t+h/ZAdcplrLLfn75fkX1/CgX2P8dYgCDW
         /CvoYUsD2HNeUpDvXPu3vPQMtiTKUF4uoYxkP9pbsY7otEwB2bBbDue42eX/LjYJPX0v
         ni+A==
X-Forwarded-Encrypted: i=1; AJvYcCXbn84KGnAtxQCsA9YtBi/PL9GtVPD2sEe1YKrtj6tKsSu7zh3YB5vXzmaaignDI4p7X4ZconREVKg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7oiqdj9/RFYXIQG1bytPwpPYCsKvIgVUh/oDTSxslmrbpAs3c
	VKQkdNLHuZ7Nt8kmfctb9Be6weMhaTm9AIobPkYNEWuPNhmtgi+ZN/YQL2aqrej2SQgFUmZFg/L
	kfBblkFx9c2s/13Xext67nZMwLN1wP3o=
X-Gm-Gg: ASbGncuiuXOl5fqlT3RZqkE2h+A9fuHZNCImbTSGmiF2fSUUazFlVBFI5r+VhH6tqD1
	F6MaiiNRsT0UTAMXgIGeOxk3jMo7TA73jN3qznOXLfq8aGxFLmbtVwm6iuV8WyVMj5GN1+9kjDZ
	WvEhIx0/7FL37KHE6l0hEuIgkfGawIvtHIB+qBVVjw9tasylKyU08jV9VElAu1abNx9B+DaRq3F
	xKkIAlYjfuIuKDt0yuwoL+QA4vIzsZCrXf0HQBCMtZ4uFNQFCwGk6unvHpZi3s34jm1KwA=
X-Google-Smtp-Source: AGHT+IEfh/pR5dVEp+MyGlS6Z0E5USpuJd+WqXIzQcqzstZI05ioUW/B3ey2i9/MpvyCwVsDk2BTTIWfhdBYNOpApmc=
X-Received: by 2002:ac8:5a4d:0:b0:4e7:1eb9:605d with SMTP id
 d75a77b69052e-4ee5883f99cmr321417371cf.11.1764319110284; Fri, 28 Nov 2025
 00:38:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
In-Reply-To: <20251128083219.2332407-1-zhangshida@kylinos.cn>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Fri, 28 Nov 2025 16:37:54 +0800
X-Gm-Features: AWmQ_bkmQmYK3DJQjInSuzOGjciJ8sGZNWSCY3EbybUAu4bZJ47LIxlxmcK_q9w
Message-ID: <CANubcdUgYpxBqPrsOnFpGJK8S9DM46DT6hriu4kDckPMVzc-Fw@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] Fix bio chain related issues
To: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

zhangshida <starzhangzsd@gmail.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=8828=E6=
=97=A5=E5=91=A8=E4=BA=94 16:32=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Hi all,
>
> While investigating another problem [mentioned in v1], we identified
> some buggy code in the bio chain handling logic. This series addresses
> those issues and performs related code cleanup.
>
> Patches 1-4 fix incorrect usage of bio_chain_endio().
> Patches 5-12 clean up repetitive code patterns in bio chain handling.
>
> v2:
> - Added fix for bcache.
> - Added BUG_ON() in bio_chain_endio().
> - Enhanced commit messages for each patch
>
> v1:
> https://lore.kernel.org/all/20251121081748.1443507-1-zhangshida@kylinos.c=
n/
>
>
> Shida Zhang (12):
>   block: fix incorrect logic in bio_chain_endio
>   block: prevent race condition on bi_status in __bio_chain_endio
>   md: bcache: fix improper use of bi_end_io
>   block: prohibit calls to bio_chain_endio
>   block: export bio_chain_and_submit
>   gfs2: Replace the repetitive bio chaining code patterns
>   xfs: Replace the repetitive bio chaining code patterns
>   block: Replace the repetitive bio chaining code patterns
>   fs/ntfs3: Replace the repetitive bio chaining code patterns
>   zram: Replace the repetitive bio chaining code patterns
>   nvdimm: Replace the repetitive bio chaining code patterns
>   nvmet: use bio_chain_and_submit to simplify bio chaining
>
>  block/bio.c                       | 15 ++++++++++++---
>  drivers/block/zram/zram_drv.c     |  3 +--
>  drivers/md/bcache/request.c       |  6 +++---
>  drivers/nvdimm/nd_virtio.c        |  3 +--
>  drivers/nvme/target/io-cmd-bdev.c |  3 +--
>  fs/gfs2/lops.c                    |  3 +--
>  fs/ntfs3/fsntfs.c                 | 12 ++----------
>  fs/squashfs/block.c               |  3 +--
>  fs/xfs/xfs_bio_io.c               |  3 +--
>  fs/xfs/xfs_buf.c                  |  3 +--
>  fs/xfs/xfs_log.c                  |  3 +--
>  11 files changed, 25 insertions(+), 32 deletions(-)
>
> --
> 2.34.1
>

Apologies, I missed the 'h' in the email address when CC'ing
hsiangkao@linux.alibaba.com.

Thanks,
Shida
