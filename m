Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77AB386C31
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 21:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784929206; cv=pass; b=i1F7iHDXcr9Itt9piv3FdGgXJWEaj6d97YS0Lif4cJxIvyDpp07K2b/2GhbU8Q2Bgf/5KH4EArCisQs+IGIANFsU3tdGm/aja/bCpDBnxITCVBFhKmBALhQN95XMOV2OXW8mJe7iC+xt1NIO0WgHI/M4NXOcpPHup8zs71FvMWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784929206; c=relaxed/simple;
	bh=VjT8h0C0MEwc6Wql1bkZPcWk5J5Ghn5YmfhJSDEhSWk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MIMwHA13Br0HVGhHH6+wMTELiTXvImWHI5v01ARs1Iflm/q9u7pthtAikM3yv3NX6rw9XaLfS7glTNpboTBXtQB0huHO+00ADJRLFGrMIWsog0uYjwI+gXOthtBN1DxR+Pb/Qy5eDlrPVKeP6wcX8xtIvG2fVz/3ZbGJbwkf3jU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FpXg/nwp; arc=pass smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FpXg/nwp"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-476a130c138so926566f8f.0
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 14:40:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784929202; cv=none;
        d=google.com; s=arc-20260327;
        b=Qc/8I7GhQfBAfWqltli6Sim0V1R1k4eL+FHfranRZNKrV2DOlFkNIvrRXv2OuJeYto
         NvWvtrHzoDHweO12FTEuxV5MhqO9tpkCnFf8SF5UQuO8k0FzX8txYUMwqOHG0E+CpLia
         x7SJFTPmWGpRex1B/Dh3DVOmIjiO+UkEkrCp/7gQKGEKEYa6OWntac2woBvOalNmBATZ
         SZ70geUK6m8hIDP6495G9DxrqZC/Ldc0PN5udiepxcCdsG50G+qyX4O61eCXa+3CD0Dr
         PYi05QsEJu6h0k74qe1eRbS2YEnEEIUeq/Uz3MmQcDqK/xeLHuuZXl2NlpCxW2CvQ/fm
         R2GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RAB/Z210MZmDSDWCyj7qmtTg5HLMGjGEKXw1Q9kkiO8=;
        fh=2SJIygqnSjev1RXatQybMReff8KSmcLPef0KiFUul4Q=;
        b=OvD/Q7wStpYZ849lpHDJSlFol7SmaK2qyF88IffiVRVV1EdqqFsadlCBu454t6X+iG
         7KDRYxNWz+we85AL0B7SeyE/rCuR1OjxuNyFD+9AGfEXJAZA4QhoKQZsyqOFwe0CwBdo
         L36vFGWRrxuzwWrDK5jcYTpSfxZ3UBA2yjD6ARjRbqjYKsCTzau/GK+nGXWpiSpvDU+t
         rNZYZc70Xp4c3EoLpqCQtKHSXqWEyBUA65mAprHuwZXYj0Kdgwm+rv7sZDA7B94/o3Lf
         xwbUpJ7L/fM53gnHUdX8BXqalE+0Fx4uQQgBlhvDz0Zs2I59bX1fcoNEX4TkhKHekKFz
         KePA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784929202; x=1785534002; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RAB/Z210MZmDSDWCyj7qmtTg5HLMGjGEKXw1Q9kkiO8=;
        b=FpXg/nwpsEcnbDYbNgtN7hYZ6HKC4pBocBkVRX4UzMBx5Xw/cMmkNmElLYus4cYjYa
         MHXhm3XlJWlhuaTY2rxo+qcJ8u4K8LzLZtp2NFLA0hLTA3HjHQwoWmIYi5NYVir8Q2g3
         fw2aTZuEG2YRBN+wVKCIsfd2R4spseU9bbLRvEb67YkWmqP33NZjQ+VkUfbTJ1YgkLfL
         NOGGbwo5ibKfVgYQW/yiGUieTeBFXCODdKuin1ShfXKaIl4ScBxvjhLGZZTznW06QIEB
         PjQculeb3KJm0VN3x2P36zezi/PQZiSzyhuklQrENOaHL+MdtBUfvKxIxPlPevPsGyRe
         XHOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784929202; x=1785534002;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RAB/Z210MZmDSDWCyj7qmtTg5HLMGjGEKXw1Q9kkiO8=;
        b=NsbvER7k2B5cYsL6c+KTtOc56cFXJt/32oc49Lzt1LOJwLkFLT0ofAdHHnEF7UmMu2
         MbQfGE4c8XExqJ4MUf0A8pI72XLLzuoJjR2nb7jEJdq5fAPNKGhwReHk6LbhC7ydFkUy
         ign94cF7DTeS9xF1NzQzKt6V7+4m9NXR+69r+oyru0Lj1LC+R0TDS5nOsl4T/W10g1xE
         t+0Ms/NYxumhQKZH7yLjSrVo47JNPm8mk73xzaY2SqDRzTl73le1Jm2Dsh7YD+VE6oyV
         2rodwzVEFNS7L2ZaQks/yCJNeE1xBEX31FdwsLTU1gSlibACl8HUilKhuAVgA3WK6BMm
         3/cA==
X-Forwarded-Encrypted: i=1; AHgh+Ro/ZK3eFka5iGNILl9paocKuwaTYJ8YHAAhqurLTRmz8Dw+6LU/yD8/HxFD7D1qvD0huQX8h0NrXWI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIvAAH//K00uUdoQvQvsHK33XyRspsAiSrkvRK457sdK4ORlvw
	TT2K/W0lm6DfGZ/wmVF58878/bQXAGbmr2pEUxd6k1WPF6qmbo9BG88TaHYrvgn+XlAXIC4EPSa
	ZPP2Qqquz29KNL6LQSn7mEsd1cmhQhTs=
X-Gm-Gg: AR+sD10rhjjUvZqWi8jbh/jCdOYApbsitbUzfI6O4azTHQN4qXAOzHeHppTfHzkficm
	vV0JX67xErKgBOMgctQrnmSQJiQHVZfYTyluuW+XzzAEm3N3byyD2GND8bn3J5Gq8OavH3WXdk6
	e4piiL1xG18IDym7DwPJzgkTehBXDLkIo4ke36Gwbq1Mef2TKJ/R01nz7Y85ddKL3Bc4LhATCu2
	Y+C7a2/4sulT5YdRCS3Cuq3fLjVk+wT9cLoRfJg3rqHRY+PX3tI7y+S5c7TckPcLgXV1DwXcidM
	FOiIlzbswVCn+uXrHYJLHdXUuUPU36XiRl8M0xC0Hg==
X-Received: by 2002:a05:6000:27ce:b0:47f:928e:21f7 with SMTP id
 ffacd0b85a97d-47f928e23f7mr6329327f8f.55.1784929202068; Fri, 24 Jul 2026
 14:40:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723050201.3381045-1-hch@lst.de> <20260723050201.3381045-3-hch@lst.de>
 <20260723164722.GF7380@frogsfrogsfrogs>
In-Reply-To: <20260723164722.GF7380@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 24 Jul 2026 14:39:49 -0700
X-Gm-Features: AUfX_mynOUqF9g7tlIXhMduTjnHTQ0m_VqSSHi-dOSMHoEm_AgBHSxiCdTlP2Is
Message-ID: <CAJnrk1Z9wxXf+=d-+5VMcCiDiy4Q7UsBGvzwaPQtAok6avjKPw@mail.gmail.com>
Subject: Re: [PATCH 2/3] iomap: decouple simple direct I/O reads from iomap_dio_rw
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, changfengnan@bytedance.com, 
	Christian Brauner <brauner@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 9:47=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Thu, Jul 23, 2026 at 07:01:40AM +0200, Christoph Hellwig wrote:
> > The pending iomap_iter_next conversion creates performance issues for t=
he
> > new simple direct I/O read fast path, because it assumes a model where
> > the iterator must be advanced at the end, which the direct I/O read fas=
t
> > path tries to avoid.
> >
> > Side step this by splitting the simple path from iomap_dio_rw, and
> > require the file systems to call into it explicitly, and pass only a
> > ->begin callback.  This allows to drop various checks for incompatible
> > features while creating a requirement for the file system to only call
> > the simple path for cases that it can handle.
> >
> > As a side-benefit we can now inline the initial part of the simple
> > direct I/O read fast path and let the compiler convert the indirect cal=
l
> > to ->begin into a direct call.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/ext4/ext4.h        |   3 +
> >  fs/ext4/file.c        |   4 +-
> >  fs/ext4/inode.c       |   2 +-
> >  fs/iomap/direct-io.c  | 208 ++++++++++--------------------------------
> >  fs/xfs/xfs_file.c     |  14 +--
> >  fs/xfs/xfs_iomap.c    |   2 +-
> >  fs/xfs/xfs_iomap.h    |   4 +
> >  include/linux/iomap.h |  66 ++++++++++++++
> >  8 files changed, 136 insertions(+), 167 deletions(-)
> >
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index b37c136ea3ab..e134c0193e2b 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -4007,6 +4007,9 @@ static inline void ext4_clear_io_unwritten_flag(e=
xt4_io_end_t *io_end)
> >  extern const struct iomap_ops ext4_iomap_ops;
> >  extern const struct iomap_ops ext4_iomap_report_ops;
> >
> > +int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length=
,
> > +             unsigned flags, struct iomap *iomap, struct iomap *srcmap=
);
> > +
> >  static inline int ext4_buffer_uptodate(struct buffer_head *bh)
> >  {
> >       /*
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index eb1a323962b1..f20d92255546 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -91,7 +91,9 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb,=
 struct iov_iter *to)
> >               return generic_file_read_iter(iocb, to);
> >       }
> >
> > -     ret =3D iomap_dio_rw(iocb, to, &ext4_iomap_ops, NULL, 0, NULL, 0)=
;
> > +     ret =3D iomap_dio_read_simple(iocb, to, ext4_iomap_begin);
>
> I was kinda wondering if you can pass ext4_iomap_ops.iomap_begin here
> to avoid the declaration in ext4.h?

I think it ends up being a bit cleaner to do it here, otherwise the
subsequent ext4 patch that replaces .iomap_begin()/.iomap_end() with
.iomap_next() will have to do it.

Thanks,
Joanne
