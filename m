Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFCE388879
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jun 2026 17:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782234277; cv=pass; b=uIJVtAqHm6Y75rZwPjLmhwy6b4AuePxA9m3N/vJZ84rINQbR5yejyfrh499qxhZH8zqndM1/P/Fn1LK0hruPRCrIP4Y/oHID1zq5JN8cpBFqXpaMW55tyuDwaoP7XT6EplBaT3j/VQEkdeZPLiopwcMU+2Cpjwb3jTiHOGY3hW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782234277; c=relaxed/simple;
	bh=AmdxDpSAXFZg+NG1Z53JDpqr/ZSkXDFyKiUPoH63AXc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QNiWEIJxo7m3tA/f+E2Al8LW0KjLLz3yxjeY0OM8y2qAu0kWya55n0ysucl9k/vCPZB9tSz9u8bQZ4mFB0K8tbrRHv9dgxP0gw5H8xIyzIa0AKKic19GHvyaNL4cT9GM4PZxhQad/OqhQnAypNUDBsmBIEklXmMhsis0teGrajE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e4AtgucW; arc=pass smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e4AtgucW"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-45f3cf907ceso56065f8f.2
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jun 2026 10:04:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782234275; cv=none;
        d=google.com; s=arc-20240605;
        b=NWnc8kHl1jN0qgXnypqcXXjC1pIykuUQRTRSwIQUcpquxuCeJC2cE1etQLpENPdhVG
         t+iXzR6K4uzfJ/B1VI9nc1Leqy6Nd3KiXhQuAWf6OR7f6x9jfr97NAI/kJsazASvgEyy
         q5bit0RtgNYKOBEtGUPzjevCs8RyJGGi1M63VjOcEmxsffWhii5yjoTdsq1rn27hV1yM
         ADq9BkOtVmyoqOsS75cj/MBCK9oKZKl8a9RHfU8htL1hHugG5RvUMuP03kxic7nzCSn+
         1Arsvh4mQOibyjLXlLUk5WvgcttgM8JDtoEGgn0Zhvenbw8zJNE8OJiUUwyHRQnNyw3t
         jx5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EchZhDXHLnIIeOQ/eg4q+Ls2B4SjaafDmxoTrWutOys=;
        fh=lC/kgfuF00iXAkfhUk4O3wH4JooW4ROpTnjdVZvGHnY=;
        b=HOSyMfoyS8AOM9YJX98kFHTeW5MgSjBngZXgovDHG6KyYaqYTKZ76+rl9bhC7uqpeo
         p9KcoIEJUTNwk99adCSSnsN8/6SY5iS4i5HhkZu9qMXh5FivAmAFW7/VynkKDSUBLdsV
         1nkWcUnu6Tc8HOkrM0atNPQus3lQcRSZhi7vvdNelF9xLs3O+tns7gfGq3D4O1AwMjcP
         LvGYebQhXokXgcEUeesod5v60bbh2b9eoF5Wd4grMQ7z1wWRtJ4dqFWNGIUBVf9pdYva
         ckJIqEGYNXqhblLNDpZwrd8/Jayq3wSLDj3rfcVSaerfsxbQe9Lo6lHr5JL42GzJehWQ
         jstQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782234275; x=1782839075; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EchZhDXHLnIIeOQ/eg4q+Ls2B4SjaafDmxoTrWutOys=;
        b=e4AtgucWYYgWpt5sMS0CnKX19VmWcar5VBqIGLC5uKuJaqiABj98ORCK++ET3US2uR
         jksobSSTG1VEN3FLECoHySYgLzbO5H3AeXb2N0SlQznVZHlRYEeJI9dKXdBU1GPLKicM
         onD8PFmnIJBAX6dK4jUBhRgydiZBNzj/0M1sRzZ2DybPLCwFmYhqVIbqF8eH9QOr9Mkf
         YXOGyIs/JI1riPuTjiQ/5W/kHKYEJZmI+SRjyvLWuqDgfft2pBjaPVxQi8CDiaq4Yyu2
         rrGCm4QdCoKWFotq2HF/pYffvFW+2Q71H59ee+lI1BEAqqLlip3xkYNtxe7tPwx6QrnO
         l0Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782234275; x=1782839075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EchZhDXHLnIIeOQ/eg4q+Ls2B4SjaafDmxoTrWutOys=;
        b=l5/4U0tWR2fprifwxN8m1Ch1WVldwbTscfIsCsXOkq/MfaqIX6Xth+1QLiNdF1BQ9N
         OZOgVQtjkos2628pRnYSc81fWcwKeZ2sL9+6BZEStAvAx340BJfYMEngSC8/ebhjQqve
         meJ85E0/0H7b9SLIHvB6b/Eqg5q0kIMlSqnYLwctR1faf5jfOogtf7KUDs3bv/+QC7Lw
         zwLimWbh/+LGbgl2hkr/K2Efi/fm4Z+L11EwyZsebAZPhvRhmtOzb64Wavkq6hgokaK4
         vZO/cOBlSdK2dlargWXhK8jxa1Gsalplahi4mCAfvHwisgC2r1LEJympUCYGgXRKmzDX
         /2eQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro0o9rSD14wfQYUHu3I7SiK9Pfs+kC3jaPzMpHOyQ70l+PHSzjNI19MZo/ysFNhEtlW3JWR19Wo9xM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzic/ie7LYM7JmAml8eq/q7ZmgoWvJBvyBVEBUOyLfG8HltL8kq
	LhiJFEuM45iVQviAn+Fpifg5Bq8OFadAO+1HlG6I/PfMxcuOdCK7cvC71yXCdba00SkKJ+fAtrV
	YR4AL4tORq1uwzm5/jwZNDhCI+JkSqcQ=
X-Gm-Gg: AfdE7clhTnooaKHmHvhv4k/OqBlTWKs6sNWXktw0CHvCfbctwfDlqBW+F8waV84DnpL
	IBNDMbuOLqvpDuXR5Hkt4VHPrLHD9+hS82OA/7f6ZXRkI351yjShEnmikhzu+zrRdesi3dR0gPT
	kfeX92NK7WuKaG1h8es20Rzn7YET8Ls9FKfJ5ND4UDrz4rNQuDAsTNMOk3PcYJuctp7Oj6WHd09
	SAm8dRq1TVu1fSfcE4+GGDvknCipKzJz9kgWUct1zWdGxLfHzQMkDAdepBgphke9wlEa6dtpgN8
	MAp4pmOJFNl6yrnIjiSfoLzotmvvXxm1L2j2EHvc28psJJJIsGlA
X-Received: by 2002:a05:6000:46c4:b0:464:5df5:332a with SMTP id
 ffacd0b85a97d-46add1841f7mr4198572f8f.34.1782234274518; Tue, 23 Jun 2026
 10:04:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623135208.1812933-1-hch@lst.de> <20260623135208.1812933-2-hch@lst.de>
In-Reply-To: <20260623135208.1812933-2-hch@lst.de>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 23 Jun 2026 10:04:22 -0700
X-Gm-Features: AVVi8Cdq1cSEiVKuIT7rCtOjoNPEfhV6BkfHSOO37MXbTaAKd3fDSsQ7oc8pKTc
Message-ID: <CAJnrk1bq7pJEwwDuimp6GzCfdhrjhzs=MFAdRLOAdkJWmeSg7w@mail.gmail.com>
Subject: Re: [PATCH 1/2] iomap: consolidate bio submission
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Kelu Ye <yekelu1@huawei.com>, 
	Yifan Zhao <zhaoyifan28@huawei.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 6:52=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> Add a iomap_bio_submit_read_endio helper factored out of
> iomap_bio_submit_read to that all ->submit_read implementations for
> iomap_read_ops that use iomap_bio_read_folio_range can shared the
> logic.
>
> Right now that logic is mostly trivial, but already has a bug for XFS
> because the XFS version is too trivial:  file system integrity validation
> needs a workqueue context and thus can't happen from the default iomap
> bi_end_io I/O handler.  Unfortunately the iomap refactoring just before
> fs integrity landed moved code around here and the call go misplaced,
> meaning it never got called.  The PI information still is verified by
> the block layer, but the offloading is less efficient (and the future
> userspace interface can't get at it).
>
> Fixes: 0b10a370529c ("iomap: support T10 protection information")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
