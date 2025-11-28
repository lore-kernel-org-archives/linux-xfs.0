Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BA31F0E29
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 01:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764293431; cv=none; b=ZRog3CNLoCJH5xp5XyxRM/KoA/CtLyBHG5ByPqwp9dDZQjeTT05pcKbZlU2JLbCHU+sIXaIw0t975BbadMhKPtSlNhmp9fDoc5YsKDI2Y+vuvOl4Y9RpFxjwIPexMMTs1yGPNGHpUpvb+LnzEZth+q3DaMehYS0pJak2uRpGxO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764293431; c=relaxed/simple;
	bh=KBcsmp5at+jJviL3J+0mcROw+lr8j4mNJ+AGY+9OtGY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U3hLKRrveeEKFcI1i0cgDl1kuiNAGw6HTOhWBfHNvY6bQMQLltnesU6vfN3VB2SZsqrTTOJZS21toLDCfJZugTZZ7RYKTfGNfxWaC3s+PHfex/KGqWn7buAn8KQxsGgx42owd9oCpNOCvlLD4UGwEOJTWyZOnNshZY5c4naJQiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PrW0c073; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PrW0c073"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ed861eb98cso14413311cf.3
        for <linux-xfs@vger.kernel.org>; Thu, 27 Nov 2025 17:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764293428; x=1764898228; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D5P89IZigPftxBdPjv0hBiMVJle7Ici8oyWvWVUIt1w=;
        b=PrW0c073q25bN1iavUUz4yt2Lb7EDAaUNYuID8JvdL4Xqrpty3F94+Ub+MRj0sIpmp
         7Nmg1jzeK9v+6Kc4BEAiYFTKakDhLljigRRz7UoUMWB6OdCKU6IrpVAsnLJV+qcZuZ0K
         AQOogidI4CxP3264iBMSLFJRZK3azTv1tSdqVs4vCLmM+5V01xSCHiUKoJRx4/qDyeyO
         ou86edpciL0JbHCvXrJT7szrI9evagYdm8cVZel9ce1nudjrAB7LgZrc19a6Sraa5V77
         s3JKZxI9slhgWAGGYoLoDC/6s2dZ02JcvdJ0jLTnEXhJyWYtTkIodODXxsVBw3p5t+CB
         lWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764293428; x=1764898228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D5P89IZigPftxBdPjv0hBiMVJle7Ici8oyWvWVUIt1w=;
        b=sjEBJ/ajgnbPjQjU5k1bGMOBslXy+flA1Kyo3v5a+24BrhRmM7pzTGMvSFecDNZaKl
         gvyWZgIjVo5JB35RD8U/yV9cgz1w/ZOF1ueRJsw9xLnkceUVSlgGms8MCzPEHPHWFSHX
         Te2C/I600gC9hqOar2Z14wYRASNkHEN2dBuPgVmHdzFrAhk15XWplEXjZVHEytWAYyKt
         NN5E/ltCtdLgO3xtIogI61Bx5PZeAtKwbqNBi2d8mTVVtDMDmlgef+z40kqt2OGE+sc6
         tfhJh7k+DgOVpLD5cU8eDqUclSrT/HhQ2DYmvVUyDviwHlSbKGnFUDly1MUjFvXp5qXn
         IQHA==
X-Forwarded-Encrypted: i=1; AJvYcCVoeRayLFC+Qy8Hl938w+357SXLoqKBh5VywFZaL8BBYElfj57JAKyikYE8zEOc4myLFu8SPObZvyI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGS3vNK9UsdLdDJcMLXt1mLpXdYXMKc+ZAArjrXEi93kZ2K+VC
	ON+wWwNJ+uDOrBKo3r6uDbVj6i1QQOVHaJeS6rXHAXo4OUe7h6GIrrahSDQU7zNWEmg58njURoK
	MGWzSUYZSZGbIzmEyxzz8SIiBXtE79Cg=
X-Gm-Gg: ASbGncvs7qq412Pv7W6JqqNr0OkmCWPxm0pagaxR77jJv+A2zr8EI+8m6nBb0SlOQCl
	mdaBg8xue0y8xoersFSpTuphYBG0epwEY5Cyvu9rzdMjseCGyEEkJtOQboSTbI6NXUq3eONqZpM
	8kNO80iLo6ulF5o1i4EZlAbjvb8tKFt09cMReuGbOL/AI4zWRMmOjn8U7h3OC6Xfa0pkIgu4Xat
	RAvVSx+hXK6s5LNxxXvGrjerFH1mN4wV09MunYnEAgbPF8vp8J5oGFGO4xpoEHTZUQefSQ=
X-Google-Smtp-Source: AGHT+IHLwC+N+hhLqdlufghZ5fhnM4rSYysjvUV/1fIoNRweHCYWM0pQrvWGMYNUf8igtQ6F3vcEMbZAHieS7voSeP4=
X-Received: by 2002:ac8:57d0:0:b0:4ee:827:7e62 with SMTP id
 d75a77b69052e-4ee58b05b62mr339066531cf.82.1764293427985; Thu, 27 Nov 2025
 17:30:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <aSBA4xc9WgxkVIUh@infradead.org> <CANubcdVjXbKc88G6gzHAoJCwwxxHUYTzexqH+GaWAhEVrwr6Dg@mail.gmail.com>
 <aSP5svsQfFe8x8Fb@infradead.org> <CANubcdVgeov2fhcgDLwOmqW1BNDmD392havRRQ7Jz5P26+8HrQ@mail.gmail.com>
 <aSf6T6z6f2YqQRPH@infradead.org>
In-Reply-To: <aSf6T6z6f2YqQRPH@infradead.org>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Fri, 28 Nov 2025 09:29:52 +0800
X-Gm-Features: AWmQ_bnZka8N-6d6tnub2wv_mKK_srvt07g0FExU0PMtOqpsh3yITqQM0jweo2c
Message-ID: <CANubcdVhDZ+G5brj6g+mBBOHLyeyM9gWaLJ+EKwyWXJjSoi1SQ@mail.gmail.com>
Subject: Re: Fix potential data loss and corruption due to Incorrect BIO Chain Handling
To: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig <hch@infradead.org> =E4=BA=8E2025=E5=B9=B411=E6=9C=8827=
=E6=97=A5=E5=91=A8=E5=9B=9B 15:17=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Nov 27, 2025 at 03:05:29PM +0800, Stephen Zhang wrote:
> > No, they are not using bcache.
>
> Then please figure out how bio_chain_endio even gets called in this
> setup.  I think for mainline the approach should be to fix bcache
> and eorfs to not call into ->bi_end_io and add a BUG_ON() to
> bio_chain_endio to ensure no new callers appear.  I
>

Okay, thanks for the suggestion.

> > If there are no further objections or other insights regarding this iss=
ue,
> > I will proceed with creating a v2 of this series.
>
> Not sure how that is helpful.  You have a problem on a kernel from stone
> age, can't explain what actually happens and propose something that is
> mostly a no-op in mainline, with the callers that could even reach the
> area being clear API misuse.
>

Analysis of the 4.19 kernel bug confirmed it was not caused by the
->bi_end_io call. Instead, this investigation led us to discover a differen=
t bug
in the upstream kernel. The v2 patch series is dedicated to fixing this new=
ly
found upstream issue.

Thanks,
shida
>
