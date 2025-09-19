Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCAC2E3B00
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 09:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758273865; cv=none; b=Q+ehh4Pq99XgKUnNIqjU2ITfsHsMq/FKQI3g07Ip5rQVoEZ7umPx3iyBY6YKLQOF6BYhmNRzWbQW4YMd5y7weqQHPBUjTj0Ekwp3iH/GvRd9oHrBSpJR8FCXpFcQZMiqAo87gkLa6DuB2tlO+VNJ+wSyaYM7JRCXKJtV2k2d5hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758273865; c=relaxed/simple;
	bh=KQiTAQdiwN+GJ50j+5K2WRjp/AryOxnjKJ+Cu9OgotA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IFOjJgHLj0ctmn81pfvEvA0E3XGZB0nGFdv7tUplkdTaqcsR3AOFCAstqNZkEeS97NhfH/LZveticw/7hx7EFu0qwJSq7BAXa+EuoyV20twYq4jwq5c7RFvi7sviBEbY5HzjZfUrpFcORwJ8c3IYrxw/4jOLFdG9K5Rxhf+NRdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=gO3EkDqm; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="gO3EkDqm"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b58b1b17d7so19859761cf.1
        for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 02:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1758273861; x=1758878661; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LGK83wgkCsEHYgUlZnWfhWk+fS3ibzSHWue8+kKX8SI=;
        b=gO3EkDqmrvD38Lo3LtI4ZknKbm3H+aJ2QpJZi/GZ37rNjVp3KjG6S3PWXtmLqtt+qB
         PkPI0s5HJWzQOLQvWYc3Q4x69DxmfIK5ynoF5XFt0ZchFuKy2AXHCWPTvGeTARE6viwc
         IR09W8Tzq4Avp1oc+VzA105UDmRBunA/H8IJQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758273861; x=1758878661;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LGK83wgkCsEHYgUlZnWfhWk+fS3ibzSHWue8+kKX8SI=;
        b=nfI//YGIpW719lWXoTmoyGxE2MKLE8NwJ/pLWiHQXPAxl+CzSBIREXf5f2GtY9Nscy
         WjGJzDMK5yHjGYf4ZYSCcN/mSz8PDmyHUrhriiyoKsTG03n3vfThjR9p7DHG8aJroevM
         s5s05w9yxMqAWmJh2b6V4rBEkOWc/9H7YosOucI8WCyu6+xXk/U9ARzy0aJkJ5tXbMKX
         XEilxdQEu+KTm1Sdg77Mt9MkcVlqRohK450ZLVG8xHPiDNrHqzmnQ/Jy0QPI13R9sMK7
         Dp2BEYn2w00jIarJeHttErkI0rQxQMX/Zn8+ikS1UUpn6VbqKmA2TA10GOuxJbnM+JNN
         rFng==
X-Forwarded-Encrypted: i=1; AJvYcCUCMqAy3HC7mpg+UEHocEW625MhaOhO4Gh+PtfZrH5/KGBuO/ekFYRX4hChIDKUWCgrcJy1ftlOel8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywunyns8Y6nT54BN7LU1jukp9P1ffkgcIkm+zhLKWLFsqPjqdmg
	J9cSW72Um8l18EA0n9ckSbv/VgqtD5EoKo6M4xSJNnor9FfMkYF2MeZnFEZFb0fvVBJ2cCb0rx7
	nMNiSPRuMSZfUZ4rgJZII86TaqwfO4XclDM8zzrC/c8vj4f2BUJpb
X-Gm-Gg: ASbGncvupV1Bgm8aYgXLWfBrt7Z99gaycJlhTvAcBgQ47d6PYu9uOZhjRU8E6gsZkHn
	UQ3Seo6pgnNHvrp0FwLIHDhlK+Hi+llMu3awKg9OCuZCWN0mLNvldP++05dMKX5UQwQIMccqZbN
	aeQy9r2/NzfZVSJ75V+tpQgGX1HYNvkaIp02xFFUoyd+/+lTT2s8bXPIiNKvVuhJilLE2MRMG9X
	KY47pLFgw4hStEEj2Hd0AvMnVaIkgW0Ja6NFBE=
X-Google-Smtp-Source: AGHT+IFVKeGNA8iwunayOdCnDn5gUFohC0mpxMLUoxxNAtrXMYz0aKJkUCwQzwld8NOhocQEH/GMZcFPKFcgY7oqbys=
X-Received: by 2002:a05:622a:349:b0:4b7:ad20:9393 with SMTP id
 d75a77b69052e-4c03c19445bmr33624631cf.4.1758273860883; Fri, 19 Sep 2025
 02:24:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798149979.381990.14913079500562122255.stgit@frogsfrogsfrogs>
 <175798150113.381990.4002893785000461185.stgit@frogsfrogsfrogs>
 <CAJnrk1YWtEJ2O90Z0+YH346c3FigVJz4e=H6qwRYv7xLdVg1PA@mail.gmail.com> <20250918165227.GX8117@frogsfrogsfrogs>
In-Reply-To: <20250918165227.GX8117@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 19 Sep 2025 11:24:09 +0200
X-Gm-Features: AS18NWCjc_3E0iwkIgU5uLF3JTSa4tc2BBRJoi7PMNgtkSa_UrI5XoMgEJYheE8
Message-ID: <CAJfpegt6YzTSKBWSO8Va6bvf2-BA_9+Yo8g-X=fncZfZEbBZWw@mail.gmail.com>
Subject: Re: [PATCH 4/8] fuse: signal that a fuse filesystem should exhibit
 local fs behaviors
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, bernd@bsbernd.com, linux-xfs@vger.kernel.org, 
	John@groves.net, linux-fsdevel@vger.kernel.org, neal@gompa.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 18 Sept 2025 at 18:52, Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Wed, Sep 17, 2025 at 10:18:40AM -0700, Joanne Koong wrote:

> > If I'm understanding it correctly, fc->local_fs is set to true if it's
> > a fuseblk device? Why do we need a new "ctx->local_fs" instead of
> > reusing ctx->is_bdev?
>
> Eventually, enabling iomap will also set local_fs=1, as Miklos and I
> sort of touched on a couple weeks ago:
>
> https://lore.kernel.org/linux-fsdevel/CAJfpegvmXnZc=nC4UGw5Gya2cAr-kR0s=WNecnMhdTM_mGyuUg@mail.gmail.com/

I think it might be worth making this property per-inode.   I.e. a
distributed filesystem could allow one inode to be completely "owned"
by one client.  This would be similar to NFSv4 delegations and could
be refined to read-only (shared) and read-write (exclusive) ownership.
A local filesystem would have all inodes excusively owned.

This's been long on my todo list and also have some prior experiments,
so it's a good opportunity to start working on it again:)

Thanks,
Miklos






>
> --D
>
> > Thanks,
> > Joanne
> >
> > >         err = -ENOMEM;
> > >         root = fuse_get_root_inode(sb, ctx->rootmode);
> > > @@ -2029,6 +2030,7 @@ static int fuse_init_fs_context(struct fs_context *fsc)
> > >         if (fsc->fs_type == &fuseblk_fs_type) {
> > >                 ctx->is_bdev = true;
> > >                 ctx->destroy = true;
> > > +               ctx->local_fs = true;
> > >         }
> > >  #endif
> > >
> > >
