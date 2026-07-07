Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718FD43846E
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 17:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783446885; cv=pass; b=m6JuzvLHVie2hVF84Mkl0ZVgC4oRnkpyliZZ24Ms8cDOv0oiT/BJpEX3oyFFlFJQAEuwBCh+Wb8huApFmZVmvvI3NUKqcFrQKP882yPals2sh0XjgAyVgZbxHqZ7aKFmNDpOfowYQGAcRp62hM4RcBEnsRzAGPfZrf26cMR8s9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783446885; c=relaxed/simple;
	bh=EuFL4uhXJGv3MM67VHNzQD/tFGuAWH3mcr+o90zw9Pw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IcrvbCEow2gEnwIbhTLM6k1Xgp7USMZeIPAOBcPSzQeaZS0T8qClrC6sfOTETIyXAlaeZcsroMUC4TzMu6Oi/cV8NlQsKWCzInE23Nhd8BQRmCFzZ1KNNwp7mt27VyuX+COBeka85BVWKtDGfsnSOAa4yeq95CDBaQJFECET1gY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GzjANDRQ; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GzjANDRQ"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6983d3dae7aso1449605a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jul 2026 10:54:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783446882; cv=none;
        d=google.com; s=arc-20260327;
        b=D1qXkA42R21WTOHTnuJloNrMf3GFxQMfEDB8sk9JFY0ZTk4mV6Ruk9WJH8aBIYXnW/
         ZMffWDgXidOke5DkHQpNUjAwo6ih23Y4eyYJ72Yjx2mi1KJpE6M4cwEPQ+nbLaeCdvrn
         VtYsDDFsDwQSfm23HmANbj1Wn9/+QD21Y2AxrJ7TSaLeuz3oWlVrZbKdP0MelrXkwFjV
         2pmLLnm8bUf6c8csO538xPkBsv3PF5Vh8dEiL3AJ0VWGoH1HnqN0oxnaQoH0xh2XBv2o
         W/H89LlSHOW/vhZT5Foianh+PFQrtL9mcB6GYr4cyadSMpLhm/u0ymf6Cw32j+9Xzirl
         9K0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xn4XMeZqP0NIt93eLbyX2J166JuV5EVbQGn1Eim9kOI=;
        fh=VO9G9V85A1goBnrg1ECtAmfzl0RGopWXOZslzFD+Erc=;
        b=Xw/N54XyqU2HzeFymjBZbor7BkdwmYmkbATyN0ESVMYnYMwxqlcU3NwzFYJXxUs/bf
         qZhaLzu1x9Y/fpERC7POan3Qyl1EGnrEtwNz9urrS98dftQeJ+ZxKZNEyx3TAX9dI74U
         ibdCdLhyKXmnwUsxkyoWPNJ5bM5NaeWzlGW7BaZAjX7MM8yCc7LTjxXfaoB9b0ZF2CsE
         CfvmERYmv5DC26wKyG5X9oot1F78wF/6cGZL4L06s5RzerKzOfDOPps43d8s7j8pEYaP
         P1nT8iQ3Y4BpiWRzY8zvoGJz+zIi1X838tI7CpSmvmPgNc+u94DU8vIk0+HqTl1+bfOH
         q1Yw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783446882; x=1784051682; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xn4XMeZqP0NIt93eLbyX2J166JuV5EVbQGn1Eim9kOI=;
        b=GzjANDRQWSlc49lrwC8zjj/ffMNrL6mnEQVMXxJATDpjiX+rscPfJX1OA9ZQhpJFMW
         i3XPxkS9LbLikq9zc0jIqD2k7YsC8PoAg4Rgw/QAFEJolLafxURiXPi5OS/rMFM+Uuht
         VvYVWW2IC8OpTCCBoD2C5dmm6MVQ1ccMV+POOyr67luXZiQH7y9lv8OBvRLd1WVDqyw2
         gZTBg4goU1Z8i2Wj02XyyLWldnyM1t9e8rimGpcmg2+odCJys8v0ZJly9CV7XwrgSTw8
         Lrn6Z/jMeiAx3LHE8SXSkXWQYotJx78g8T+oj59nM9N3DHGRLNjrSv440D+ebb0mUq/f
         +eew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783446882; x=1784051682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xn4XMeZqP0NIt93eLbyX2J166JuV5EVbQGn1Eim9kOI=;
        b=IdAGjZSm6K08mEdNCIQfbyoJcm01I/1b/Vrkn1k4kp/b6T9V3f7qWse+r1GD/DUuuf
         U6ZHaPgeLFvVkLu/NHVJ9a+KdUUnfvWUy7Y7/AllxTyebPvMxtZY8mJa6fvcFBfAILxO
         /JGYpaqZhoYdcnlHxK/OzSd3Ec+nJoYEFmWiZYmOqDOh5/x/W4dq+P3O8j3wuPEFvxvq
         UyXG/4NcVEeNevSl8s6w3pljzNZV4xRJ++gbP9db6k5cqXpZQpI+GRG1yFJsGjhCfxSg
         UGZdPNmVPkGADvHnx0XM68hp7j7HTviBp5pZN/Pq0w87oqS8dMMpR6x99qeFBNQnwVPk
         ydAQ==
X-Forwarded-Encrypted: i=1; AHgh+RoSaaGzXviWqEWVmaXNlTfoIsS1dcGoMszW0w6f9V9Payue4SliwhKAeRmMRVh42uQcRN4cC7QZbtE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVm7yHZqcD5Xrf8B+zdfc6+ucLAzSooc+32UTz6XzqDO/8KAK6
	T+J6cR9hXd3C74Wrj3GQlHbRfFiTvPyioE5Qj/IdSZ5SlukWD09J8zVln3TJDuCzcWgvA4wC8fl
	nX4eXREnv/U6+Slvx8i36rkqvreBUmGFhl2Wq6xM=
X-Gm-Gg: AfdE7cmgOjSU8trOy5QVYAHNRrmxOGiSQjk/2y+E8fqimpk6Kyz54efXT9B4+1kR2jb
	uELuoim/guI9gAtEIrNqQ99mmfxaGo+dKDDeccl53F+Ti7mU/kChzMp3ZPwwJwzerSSFS88qeHx
	YMzrwsBFUXSvDk3CjhMOaS5heLvDQ0gv+eg8bqw8ovAyMOWN8QtHn9QGS4x2a2c2v+xNDGFwyYU
	RRBopK1HsPncH5axf/JZSRHgONW16v3XmbBWGH4E3T8KJRANWiPgpMVvYRaK1BCEtNFHdZbeWmU
	Px2YrHK8jSmrKLOzc19IyRWO1/eg2I3VL5x9oVI=
X-Received: by 2002:a17:907:c817:b0:c12:a638:8644 with SMTP id
 a640c23a62f3a-c15aec028c3mr206330166b.23.1783446881658; Tue, 07 Jul 2026
 10:54:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260703151543.3335583-2-bestswngs@gmail.com> <20260707163445.GA9392@frogsfrogsfrogs>
In-Reply-To: <20260707163445.GA9392@frogsfrogsfrogs>
From: Weiming Shi <bestswngs@gmail.com>
Date: Wed, 8 Jul 2026 01:54:04 +0800
X-Gm-Features: AVVi8CfV1zFrCZkjA5rxB_HtbN0qBut7wD4yjhV1JylLb-_MdTdasNcu_QQc20E
Message-ID: <CANgPUi1WyKHZ2_Cjk-Z1knL+WvZuwKXVxR5uNT_adPTpKLK_RQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: reject attr leaf blocks with inconsistent usedbytes
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	Brian Foster <bfoster@redhat.com>, Xiang Mei <xmei5@asu.edu>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Darrick J. Wong <djwong@kernel.org> =E4=BA=8E2026=E5=B9=B47=E6=9C=888=E6=97=
=A5=E5=91=A8=E4=B8=89 00:34=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Jul 03, 2026 at 08:15:44AM -0700, Weiming Shi wrote:
> > xfs_attr3_leaf_verify() checks each attr leaf entry on its own, but nev=
er
> > checks that the entries' nameval regions are disjoint. A crafted leaf c=
an
> > point several entries at overlapping offsets: every entry passes the
> > per-entry check, yet the summed entry sizes far exceed the nameval regi=
on.
> >
> > ichdr.usedbytes is kept as the exact sum of the entries'
> > xfs_attr_leaf_entsize() (see xfs_attr3_leaf_add()), so for such a leaf =
the
> > real sum no longer matches usedbytes. When the leaf is later repacked,
> > xfs_attr3_leaf_compact() resets firstused to blksize and calls
> > xfs_attr3_leaf_moveents(), which subtracts each entry size from firstus=
ed;
> > the oversized sum underflows the 32-bit firstused and the following mem=
move
> > writes out of bounds. The same repack runs from xfs_attr3_leaf_rebalanc=
e()
> > and xfs_attr3_leaf_unbalance(). The only guard is an ASSERT, which is
> > compiled out on production kernels.
> >
> > A single setxattr() on a file with such a leaf, after mounting a crafte=
d
> > image, triggers the write:
> >
> >   BUG: KASAN: use-after-free in xfs_attr3_leaf_moveents (fs/xfs/libxfs/=
xfs_attr_leaf.c:2788)
> >   Write of size 400 at addr ffff88802b187f98 by task exploit
> >    xfs_attr3_leaf_moveents (fs/xfs/libxfs/xfs_attr_leaf.c:2788)
> >    xfs_attr3_leaf_compact (fs/xfs/libxfs/xfs_attr_leaf.c:1790)
> >    xfs_attr3_leaf_add (fs/xfs/libxfs/xfs_attr_leaf.c:1563)
> >    xfs_attr_set_iter (fs/xfs/libxfs/xfs_attr.c:556)
> >    xfs_attr_set (fs/xfs/libxfs/xfs_attr.c:1244)
> >    xfs_xattr_set (fs/xfs/xfs_xattr.c:186)
> >    __vfs_setxattr (fs/xattr.c:218)
> >    vfs_setxattr (fs/xattr.c:339)
> >    __x64_sys_fsetxattr (fs/xattr.c:774)
> >
> > Sum the entry sizes while verifying and reject the leaf unless the sum
> > equals usedbytes and usedbytes fits in [firstused, blksize).  The onlin=
e
> > scrubber already validates this in xchk_xattr_block(); this brings the
> > read/write verifier in line with it so the bad leaf is rejected before =
any
> > reshape can run.
> >
> > Fixes: c84760659dcf ("xfs: check attribute leaf block structure")
> > Reported-by: Xiang Mei <xmei5@asu.edu>
> > Assisted-by: Claude:claude-opus-4-8
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr_leaf.c | 17 +++++++++++++++--
> >  1 file changed, 15 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_lea=
f.c
> > index 86c5c09a5db4..9814dcfbd7ac 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -300,7 +300,8 @@ xfs_attr3_leaf_verify_entry(
> >       struct xfs_attr3_icleaf_hdr             *leafhdr,
> >       struct xfs_attr_leaf_entry              *ent,
> >       int                                     idx,
> > -     __u32                                   *last_hashval)
> > +     __u32                                   *last_hashval,
> > +     unsigned int                            *usedbytes)
> >  {
> >       struct xfs_attr_leaf_name_local         *lentry;
> >       struct xfs_attr_leaf_name_remote        *rentry;
> > @@ -344,6 +345,7 @@ xfs_attr3_leaf_verify_entry(
> >       if (name_end > buf_end)
> >               return __this_address;
> >
> > +     *usedbytes +=3D namesize;
> >       return NULL;
> >  }
> >
> > @@ -376,6 +378,7 @@ xfs_attr3_leaf_verify(
> >       char                            *buf_end;
> >       uint32_t                        end;    /* must be 32bit - see be=
low */
> >       __u32                           last_hashval =3D 0;
> > +     unsigned int                    usedbytes =3D 0;
> >       int                             i;
> >       xfs_failaddr_t                  fa;
> >
> > @@ -410,11 +413,21 @@ xfs_attr3_leaf_verify(
> >       buf_end =3D (char *)bp->b_addr + mp->m_attr_geo->blksize;
> >       for (i =3D 0, ent =3D entries; i < ichdr.count; ent++, i++) {
> >               fa =3D xfs_attr3_leaf_verify_entry(mp, buf_end, leaf, &ic=
hdr,
> > -                             ent, i, &last_hashval);
> > +                             ent, i, &last_hashval, &usedbytes);
> >               if (fa)
> >                       return fa;
> >       }
> >
> > +     /*
> > +      * usedbytes must equal the summed entry sizes and fit in the
> > +      * nameval region; otherwise a later repack underflows firstused
> > +      * in xfs_attr3_leaf_moveents().
> > +      */
> > +     if (usedbytes !=3D ichdr.usedbytes)
> > +             return __this_address;
> > +     if (ichdr.usedbytes > mp->m_attr_geo->blksize - ichdr.firstused)
>
> Interesting ... where did this new logic come from?  xchk_xattr_block
> doesn't perform this test.
>
> --D
>
> > +             return __this_address;
> > +
> >       /*
> >        * Quickly check the freemap information.  Attribute data has to =
be
> >        * aligned to 4-byte boundaries, and likewise for the free space.
> > --
> > 2.43.0
> >
> >

Yeah, you're right, sorry. scrub only checks "usedbytes =3D=3D summed sizes=
"
  (my first check). It has nothing for the second one,

        if (ichdr.usedbytes > mp->m_attr_geo->blksize - ichdr.firstused)

  The closest scrub test is "usedbytes > blksize", which bounds usedbytes
  against the whole block, not the nameval region, so it wouldn't catch thi=
s.
  Saying the scrubber already validates it was just wrong.

  My reproducer's leaf (firstused=3D3616, real summed entsize=3D6000, usedb=
ytes
  field=3D8) is actually caught by the first check, since 6000 !=3D 8. But =
the
  first check alone isn't enough: an image that instead sets the usedbytes
  field to the oversized real sum passes the equality, and then only the
  second check (6000 > 4096-3616) rejects it before moveents underflows
  firstused. So both are needed.

  I'll drop the scrubber reference in v2. Code's unchanged. Thanks.
