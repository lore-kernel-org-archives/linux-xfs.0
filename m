Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0260212B73
	for <linux-xfs@vger.kernel.org>; Fri,  7 Jun 2024 03:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717730719; cv=none; b=mWNRl5HLszaUXc7QpP6ZhxhevKoJ1hOInwwYz7573AnjOUNqtiDuXXqL+bx5jE9woPVX/XT/d5PbcYpl5zGWiFB2fZAXuHeqVHrnpDMWPgAck/dfWkJUns32yV4N+34o8AqWR96k5A5njXYbjOT7hbw4Xe6JQseqMfvQyuM8MYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717730719; c=relaxed/simple;
	bh=X6mSpjjqrU3vOMQPWO7r6eKQNR6aEirHSSJqXa2X6oE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ps0ZtY9+zT7gOwmWjJ++K1mriMx5bso0/OzQFurA/KADAkOLiMw9bpdZHnc29JAv8uHOU5Uki4pyzS/RXpf1dUVhov+dTpYGg4ym305z8SuD/wyLUYZEHB+E/mJJ/hjtLb3NIY6rG7bligxDXhbiBt/k4vl6UUCJYnsCQyXk3Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RDFFR44O; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RDFFR44O"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-dfa6e0add60so1827780276.3
        for <linux-xfs@vger.kernel.org>; Thu, 06 Jun 2024 20:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717730717; x=1718335517; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rqrBn0BSn4ZPxhv/+FneVuMqUGXf1tF/D4m45A73YBw=;
        b=RDFFR44OcuIuImT6nm9g1a4OQhHC6ikGWyiQukBcv5wmqCzoEhSaVBZJqFkwR8vZbr
         5zxHj5dTmqz46LT9IQH9j3k7/44nZP1lwfJHsqieXZ0sdNYy578tRX3tTh9IA8g+EdXD
         x6WjEL+lwBIfS73/SHWlOqw8344q+Zsg+xOJSDcrUPHloqCz26vMFVQPO3meus4CMfYB
         hHOEZu60pPZyjk+w36bgbT8U+QdwlG0KnP6Aqjs+2aXSvATcBSuE0GnU/79kLSwlcXBJ
         WTpYnOvGJCmFE8sC2cyktEbfosfple5xvqGwJ6GMTyPZpEtqKUM/IhKgTZ4rBOvoLm+O
         /qMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717730717; x=1718335517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rqrBn0BSn4ZPxhv/+FneVuMqUGXf1tF/D4m45A73YBw=;
        b=CK7gynUTAJQ6UOPziTXwfRQo+DDQ9mox+WguOUbp9wHe2YoKo6I/xPNVctzQYnJV7s
         UySV09T79OS1S3lec0PHQTgOa2Po6F0p2y3rsKfrufEshMzinoiLqVws9bKbfwqe8YL3
         mVuhyI6jofMMwbraLsCqj9vrX25dzmYFZtWp3Rt2wCnQznCHuGV2zbSyDyp+Rsjv4FJ+
         RpEi10q1Gz/oe71mScFvKtGpn8X/9RM3Ckqs7+YX5TaWOArR68nsBQ2kTUJQNoV/3/5G
         9yEbKroFNxYLkIAFQMmOl4dUGwdzxeKEgsnkXOlzzNX/nKjMHkDpevt075LQsHikh6cw
         qCOw==
X-Gm-Message-State: AOJu0YzoHaj1RlNkcwdrIfGXrW8HYPtKd4tOzxsQSV6PSZfIcd7ezNXj
	tyK+aFZ9Ni6BryECiEa8si2IOaVKprV45+A+ir0rE83XAZCwQc4mOWUOuOv8VK6JUDrxUSvpO47
	cZv60e1CXhI8GalTdyMLDeF7YeOc=
X-Google-Smtp-Source: AGHT+IGZLVKIPrba2NuAA9iT7DvSdw1RX72+yujsvoSVKE2cMtENquhL8jU/rxhUVzNyihxWMNRIwzq0Bevk0lJUByw=
X-Received: by 2002:a05:6902:52a:b0:de5:4f12:7ea0 with SMTP id
 3f1490d57ef6-dfaf6492747mr1447079276.8.1717730716668; Thu, 06 Jun 2024
 20:25:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240606031416.90900-1-llfamsec@gmail.com> <20240606163121.GM52987@frogsfrogsfrogs>
In-Reply-To: <20240606163121.GM52987@frogsfrogsfrogs>
From: lei lu <llfamsec@gmail.com>
Date: Fri, 7 Jun 2024 11:25:04 +0800
Message-ID: <CAEBF3_aspPkAp0Q17Qz8_eyOLtT0EFMYjSzPM-19D-enNF8ayQ@mail.gmail.com>
Subject: Re: [PATCH v3] xfs: don't walk off the end of a directory data block
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, 
	Dave Chinner <dchinner@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 12:31=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Thu, Jun 06, 2024 at 11:14:16AM +0800, lei lu wrote:
> > This adds sanity checks for xfs_dir2_data_unused and xfs_dir2_data_entr=
y
> > to make sure don't stray beyond valid memory region. Before patching, t=
he
> > loop simply checks that the start offset of the dup and dep is within t=
he
> > range. So in a crafted image, if last entry is xfs_dir2_data_unused, we
> > can change dup->length to dup->length-1 and leave 1 byte of space. In t=
he
> > next traversal, this space will be considered as dup or dep. We may
> > encounter an out of bound read when accessing the fixed members.
> >
> > In the patch, we check dup->length % XFS_DIR2_DATA_ALIGN !=3D 0 to make
> > sure that dup is 8 byte aligned. And we also check the size of each ent=
ry
> > is greater than xfs_dir2_data_entsize(mp, 1) which ensures that there i=
s
> > sufficient space to access fixed members. It should be noted that if th=
e
> > last object in the buffer is less than xfs_dir2_data_entsize(mp, 1) byt=
es
> > in size it must be a dup entry of exactly XFS_DIR2_DATA_ALIGN bytes in
> > length.
> >
> > Signed-off-by: lei lu <llfamsec@gmail.com>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_dir2_data.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_dat=
a.c
> > index dbcf58979a59..71398ce0225f 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_data.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> > @@ -178,6 +178,12 @@ __xfs_dir3_data_check(
> >               struct xfs_dir2_data_unused     *dup =3D bp->b_addr + off=
set;
> >               struct xfs_dir2_data_entry      *dep =3D bp->b_addr + off=
set;
> >
> > +             if (offset > end - xfs_dir2_data_entsize(mp, 1)) {
> > +                     if (end - offset !=3D XFS_DIR2_DATA_ALIGN ||
> > +                         be16_to_cpu(dup->freetag) !=3D XFS_DIR2_DATA_=
FREE_TAG)
> > +                             return __this_address;
> > +             }
>
> Let me work through the logic here.  If @offset is too close to @end to
> contain a dep for a single-byte name, then you check if it's an 8-byte
> dup.  If it's not a an 8-byte dup, then you bail out.  Is that correct?
>
> So if we get to this point in the function, either @offset is far enough
> away from @end to contain a possibly valid dep; or it's an 8-byte
> FREE_TAG region that's possibly correct.
>
> I think the logic is correct, though I think it would be clearer if
> you'd add this to xfs_dir2_priv.h:
>
> static inline unsigned int
> xfs_dir2_data_unusedsize(
>         unsigned int            len)
> {
>         return round_up(len, XFS_DIR2_DATA_ALIGN);
> }
>
> and modify the loop to read like this:
>
>         /*
>          * Loop over the data/unused entries.
>          */
>         while (offset < end) {
>                 struct xfs_dir2_data_unused     *dup =3D bp->b_addr + off=
set;
>                 struct xfs_dir2_data_entry      *dep =3D bp->b_addr + off=
set;
>                 unsigned int                    reclen;
>
>                 /*
>                  * Are the remaining bytes large enough to hold an
>                  * unused entry?
>                  */
>                 if (offset > end - xfs_dir2_data_unusedsize(1))
>                         return __this_address;
>
>                 /*
>                  * If it's unused, look for the space in the bestfree tab=
le.
>                  * If we find it, account for that, else make sure it
>                  * doesn't need to be there.
>                  */
>                 if (be16_to_cpu(dup->freetag) =3D=3D XFS_DIR2_DATA_FREE_T=
AG) {
>                         xfs_failaddr_t  fa;
>
>                         reclen =3D xfs_dir2_data_unusedsize(be16_to_cpu(d=
up->length));
>                         if (lastfree !=3D 0)
>                                 return __this_address;
>                         if (be16_to_cpu(dup->length) !=3D reclen)
>                                 return __this_address;
>                         if (offset + reclen > end)
>                                 return __this_address;
>                         ...
>                         offset +=3D reclen;
>                         continue;
>                 }
>
>                 /*
>                  * This is not an unused entry.  Are the remaining bytes
>                  * large enough for a dirent with a single-byte name?
>                  */
>                 if (offset > end - xfs_dir2_data_entsize(mp, 1))
>                         return __this_address;
>
>                 /*
>                  * It's a real entry.  Validate the fields.
>                  * If this is a block directory then make sure it's
>                  * in the leaf section of the block.
>                  * The linear search is crude but this is DEBUG code.
>                  */
>                 if (dep->namelen =3D=3D 0)
>                         return __this_address;
>                 reclen =3D xfs_dir2_data_entsize(mp, dep->namelen);
>                 if (offset + reclen > end)
>                         return __this_address;
>                 if (!xfs_verify_dir_ino(mp, be64_to_cpu(dep->inumber)))
>                         return __this_address;
>                 ...
>                 offset +=3D reclen;
>         }
>
> What do you all think?

it looks clearer.

>
> --D
>
> > +
> >               /*
> >                * If it's unused, look for the space in the bestfree tab=
le.
> >                * If we find it, account for that, else make sure it
> > @@ -188,6 +194,8 @@ __xfs_dir3_data_check(
> >
> >                       if (lastfree !=3D 0)
> >                               return __this_address;
> > +                     if (be16_to_cpu(dup->length) % XFS_DIR2_DATA_ALIG=
N !=3D 0)
> > +                             return __this_address;
> >                       if (offset + be16_to_cpu(dup->length) > end)
> >                               return __this_address;
> >                       if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup))=
 !=3D
> > --
> > 2.34.1
> >
> >
