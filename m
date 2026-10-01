Received: from mail-ed2-f16.google.com (mail-ed2-f16.google.com [74.125.228.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DE23EC69A
	for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2026 07:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790840041; cv=pass; b=tyCRLDaLIwLfjaZNG1sMfDENISvC+9flMDEj60cB7sGqui7XjJi6TYJMApo2RDKKc4nJVMycaaqL4Q2owHn73LYDHsLoOr0vh8My2Fahrb1x0qkqZnwDf27O1F3vr2utr0ja0fqRBQUv08aQ60MK1A83NJQnqN6iYinCCf2NmI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790840041; c=relaxed/simple;
	bh=KLrl1JmKD/j4lbwTIj965Z/B9W7suYuEx4nj7ZOOSaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AAwjUKDiBjkKaH21dxerwRj3xqrAW1YCyQ0GF2E8ybtVxjrdUdYyWcuJpPb/uxcPqv6xP4twh3KbiD1597A131YjDcs8ug0yFTiDDte1JeWEpoNFppd4ouKotSvfWgCsB5GuI/1p/odvDW9bm9N3e8rAlJGImKx6uUvbqNGFniI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r+c6jcDk; arc=pass smtp.client-ip=74.125.228.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r+c6jcDk"
Received: by mail-ed2-f16.google.com with SMTP id 4fb4d7f45d1cf-6a9984f9adcso10543161a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 01 Oct 2026 00:33:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790840037; cv=none;
        d=google.com; s=arc-20260327;
        b=Y353vQsv+y6s2SbV4sMrHe697XHxQhOlfyuyYI4A+trHqEM/NrmGUkK1fIq8BNXU2D
         sHoYsvFgBRXG+/Av740DjC3M/SNNQ8eD5RjK3KR3D3wZ35YWBZv8cT29Y3+CaM7SI4qA
         qLaxRQi5TQvUo8cHfBbpxDf3CdmXBbJBXPL43TKxZfA43L1QSSz+eZ9sSBhvimZbGkgO
         C+i5qnl+OOzxF0BkC9AODpsPPfOp7fyUJAcDWyRISmY5uBD3mAalzfB7cj3YONU7Yxdw
         T1RsuYWlQtNi71k/qbB/jXE2pmmvjKm/exq5TVPVStAPp9x3WVY94Akki9V32NipEnf/
         sZ+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WTf1zoaT0Wsrc4m5L9oFar53LMEzHBHomKhDhLKQLu0=;
        fh=QM6FFCumXR7mHIhIYBEYIxkw5D1WYjoKprPFKHHgck0=;
        b=OeT6JjuRFxj6iwdr6JuDNFxOXGv26OQaLX5P6PERdLjrnUpSeaHklaq5uJLUA1x9qj
         S1Haq3wd1kNVAYnyMU1ClH+0s6TbAyTRHYVdFzLweR+6MXBZBMqtAhR004dNrb8OAp/H
         EG7/prvUjFcT4ViMQ/nH7lkZ1as9r61GSzTUTQymf36nwSQcHkfWGJauueT2aiStNQIy
         gDDK7xYa9r+4ONV1+zu4Nafo3ZQ+03+SxOkz1OSC0YNfeFJgi4QHxetAfzvZJtWLqwln
         Anx7UFsjAr0uLbvE1eAfdzr99vc4G+PVf0KG7B/eYtsss2MYtW+/fuRkKG+FLhekZGIo
         tNlw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790840037; x=1791444837; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WTf1zoaT0Wsrc4m5L9oFar53LMEzHBHomKhDhLKQLu0=;
        b=r+c6jcDkInpp2da4rFoYRjeQKSHHssJ6AXRMK6sRiUcaxe7Tc28b+vPeEpibiuvV6b
         QRrvitxv0IYDYVxvpCDaexooCfZIKnyv3liyxE5vZBLIdRFr0GichjZHq8An6/oXky6H
         w62nGgSlIxambhvcRALR7lDpiX60loURqY811tZ8i7Jv1vQ/4OVzYRK4I6eNnLKObvDL
         MUUg+kVWJdXIriBILmvr7rVCa0n+DI6j1GsPNzcXF8sjxnR99ubkZZFD5VekuR0Ok1Em
         6jcXRYsHliEL7i5l7eePAif5g/lHqPuifkTOrwqAahZMAQ7Uo4ECJiNbbvJF6waXLJXl
         k0Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790840037; x=1791444837;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WTf1zoaT0Wsrc4m5L9oFar53LMEzHBHomKhDhLKQLu0=;
        b=DOSQv3u14/6nYa1gBxROxZ5BZ9zvieDNvfq0dTAxfpFZR4PslLt9CKYKgUC10qO4Da
         hScchG3AckdRorYtjngq3QQ3qIm1Qh9Aveoa5ziLmkXEM+ngfhrJXyeQpr434A1p1pGs
         1yj0d3RU1tRi6V+WfMxOZ5KuXBRKbxFu/PZQmEcy/hB+PARUSbZEcwEVEM1+fUI/Qzir
         NECIvLotdabfwvtC+cD9zbzmDk45Ej0AicKaf9TgaCVoAJ5u3G7l+2uka3COJfITQLKS
         wPAB/jy/uxWnDahpo/SMUZk0owOmSZgjzBeEDVtTYr37k0WCNOz4UlwtH0T/t/jg2mEm
         1AmQ==
X-Forwarded-Encrypted: i=1; AKwUvBwg5tkYBk9NbyMx7wEOOlsN07uad4l30zXNTX2jgbJQNkRcTIJP8fpOSpa3P0hK+1uYyRGM0DaYvQ4=@vger.kernel.org
X-Gm-Message-State: AFq9FYKh6X+GQHlYIOiLWBO78YCjMs0r536qh2s/wg1hTq7nLjcbYZu0
	mPgQoq7L2i93dcweSWe0jZTQt8zW2idlNy8zOvDYXgNo9uw6mIESs2k1lPAtvOowMFIsekEqMeB
	xBP7w3+9Yzr6jGIDOYRwaksuzkGfz5GQ=
X-Gm-Gg: AYBFou2lCehmw8703wnKXsJrf3RBNsxFaesCGhLz1teyN30wnEMELytWZblkct2vHQr
	hx8OnI00zMka2TfqWyyD8pEfhUziCppyoSxotowTmR7GQJ48lS/OY+CD4um+XkBZcnXgenZptbK
	olNFQwVHNgR2wAre0LYbnuEEdJh91SPbSVghuuej217/sDtwgFob070hcybnVi4NbILYtE+41zv
	/9iNqagg7X8yDLWajRW4ppEtpUVvDErzrkQgNTNbfEzQmTeabB0EyQW9D1tyxQJV/A42jtyVVFJ
	0PsNUJ86xR8JbjS4KSqMuo1lpUUcdtMEwBCjVdoN1chEEaZapJTRvqwH
X-Received: by 2002:a05:6402:3227:b0:6ac:9a44:d3ed with SMTP id
 4fb4d7f45d1cf-6ae1986075bmr3067340a12.5.1790840036710; Thu, 01 Oct 2026
 00:33:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260929034158.1455429-1-neilb@ownmail.net> <20260929034158.1455429-8-neilb@ownmail.net>
 <CAOQ4uxjv3Ziqy+CjbCO7noAPse+a0066UO7pkFhStnnW9FFSPg@mail.gmail.com> <179080463287.37859.4262341831478331513@noble.neil.brown.name>
In-Reply-To: <179080463287.37859.4262341831478331513@noble.neil.brown.name>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 1 Oct 2026 09:33:44 +0200
X-Gm-Features: AclHuK9MIhHprf4aDgaMwd_4tZZMvI-V-gvxwkigtEk9UN12WMcOwDyiP913px0
Message-ID: <CAOQ4uxgEG6Wt1z7JO+v2sjs=Aoav0u7eLz+Ge3UqhVG4msBkwA@mail.gmail.com>
Subject: Re: [PATCH 7/7] ovl: stop using lookup_one() in ovl_iterate().
To: NeilBrown <neil@brown.name>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Kees Cook <kees@kernel.org>, 
	Joel Granados <joel.granados@kernel.org>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Breno Leitao <leitao@debian.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Jan Harkes <jaharkes@cs.cmu.edu>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Hyunchul Lee <hyc.lee@gmail.com>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-um@lists.infradead.org, 
	codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, linux-mm@kvack.org, 
	ntfs@lists.linux.dev, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 30, 2026 at 11:44=E2=80=AFPM NeilBrown <neilb@ownmail.net> wrot=
e:
>
> On Wed, 30 Sep 2026, Amir Goldstein wrote:
> > On Tue, Sep 29, 2026 at 5:43=E2=80=AFAM NeilBrown <neilb@ownmail.net> w=
rote:
> > >
> > > From: NeilBrown <neil@brown.name>
> > >
> > > lookup_one() is expected to be removed as it does not fit well with
> > > proposed changes to directory locking.
> > > Specifically d_alloc_parallel() will be ordered outside of i_rwsem
> > > and as iterate_shared() is called with i_rwsem held it is not safe
> > > to call d_alloc_parallel().
> > >
> > > We can instead call d_alloc_trylock() and then call the ->lookup, but
> > > that can fail if there is a lookup attempt concurrent with the
> > > readdir().
> > >
> > > ovl cannot afford for the lookup to fail as that could produce incorr=
ect
> > > results, and it cannot safely drop i_rwsem temporarily as that could
> > > introduce races with handling of the directory cache.
> > >
> > > Instead we rely on the fact that ovl_iterate() has an exclusive lock =
on
> > > the directory, so any concurrent lookup will wait for the ovl_iterate=
()
> > > call to complete.  We allocate a separate dentry and if the lookup is
> > > successful, it is hashed with the result.
> >
> > Please document this assumption with:
> >
> > rwsem_assert_held_write(&dir->d_inode->i_rwsem);
> >
> > and comment in the code. Having it in the git commit message is not
> > enough for future code reviewers.
>
> Yes, I can do that.
>
> >
> > Other than that, I have no further comments, but I would like
> > to have a review from Miklos before this patch lands, because
> > I don't remember him reviewing any of the revisions and this is subtle.
> > I am a bit concerned that we have no test coverage for this subtle code=
.
> >
> > >
> > > When the concurrent lookup gets i_rwsem it mustn't do its own lookup =
-
> > > it must use the existing dentry.  This is found, if it exists, using
> > > try_lookup_noperm().
> > >
> > > Signed-off-by: NeilBrown <neil@brown.name>
> > > ---
> > >  fs/overlayfs/namei.c   | 12 ++++++++++++
> > >  fs/overlayfs/readdir.c | 26 ++++++++++++++++++++++++--
> > >  2 files changed, 36 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > > index ca899fdfaafd..f56e33fd4d6b 100644
> > > --- a/fs/overlayfs/namei.c
> > > +++ b/fs/overlayfs/namei.c
> > > @@ -1385,6 +1385,7 @@ struct dentry *ovl_lookup(struct inode *dir, st=
ruct dentry *dentry,
> > >         struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
> > >         struct ovl_entry *poe =3D OVL_E(dentry->d_parent);
> > >         bool check_redirect =3D (ovl_redirect_follow(ofs) || ofs->num=
datalayer);
> > > +       struct dentry *alias;
> > >         int err;
> > >         struct ovl_lookup_ctx ctx =3D {
> > >                 .dentry =3D dentry,
> > > @@ -1399,6 +1400,17 @@ struct dentry *ovl_lookup(struct inode *dir, s=
truct dentry *dentry,
> > >         if (dentry->d_name.len > ofs->namelen)
> > >                 return ERR_PTR(-ENAMETOOLONG);
> > >
> > > +       /*
> > > +        * The existence of this in-lookup dentry might have forced
> > > +        * readdir to do the lookup with a new dentry.  If so we must
> > > +        * return that one.
> > > +        */
> > > +       alias =3D try_lookup_noperm(&QSTR_LEN(dentry->d_name.name,
> > > +                                           dentry->d_name.len),
> > > +                                 dentry->d_parent);
> > > +       if (alias && !IS_ERR(alias))
> > > +               return alias;
> > > +
> > >         with_ovl_creds(dentry->d_sb)
> > >                 err =3D ovl_lookup_layers(&ctx, &d);
> > >
> > > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > > index e7fe29cb6028..bc41da4bace8 100644
> > > --- a/fs/overlayfs/readdir.c
> > > +++ b/fs/overlayfs/readdir.c
> > > @@ -574,8 +574,30 @@ static int ovl_cache_update(const struct path *p=
ath, struct ovl_cache_entry *p,
> > >                 }
> > >         }
> > >         /* This checks also for xwhiteouts */
> > > -       this =3D lookup_one(mnt_idmap(path->mnt), &QSTR_LEN(p->name, =
p->len), dir);
> > > -       if (IS_ERR_OR_NULL(this) || !this->d_inode) {
> > > +       this =3D d_alloc_trylock(dir, &QSTR_LEN(p->name, p->len));
> > > +       if (this =3D=3D ERR_PTR(-EWOULDBLOCK)) {
> > > +               /*
> > > +                * Some other thread is looking up this name and will
> > > +                * block on i_rwsem before it can complete the lookup=
.
> > > +                * We will do the lookup in a new dentry and when tha=
t
> > > +                * lookup gets a turn it will find and return this
> > > +                * dentry.
> > > +                */
> > > +               this =3D d_alloc_name(dir, p->name);
> > > +               if (!this)
> > > +                       this =3D ERR_PTR(-ENOMEM);
> > > +       }
> > > +       if (!IS_ERR(this) && d_unhashed(this)) {
> > > +               /* Either we got an in-lookup or we made our own unha=
shed */
> > > +               struct dentry *alias =3D ovl_lookup(dir->d_inode, thi=
s, 0);
> > > +
> > > +               d_lookup_done(this);
> > > +               if (alias) {
> > > +                       dput(this);
> > > +                       this =3D alias;
> > > +               }
> > > +       }
> > > +       if (IS_ERR(this) || !this->d_inode) {
> > >                 /* Mark a stale entry */
> > >                 p->is_whiteout =3D true;
> > >                 if (IS_ERR(this)) {
> >
> > How do you test your patch set? Do you have tests that exercise
> > parallel create/lookup/readdir?
> >
> > It would be irresponsible to merge code without showing that the `alias=
`
> > branches have been exercised. Do you have an idea how to do that?
>
> I think that to trigger the 'alias' code we would need to instrument the
> code to block and wait.
> e.g.  when readdir sees a particular name it could signal the test
> harness somehow and then wait.  The test harness would trigger a lookup
> of the name which would block on the parent i_rwsem.
> The readdir then continues somehow and gets -EWOULDBLOCK and installs
> the alias dentry.  When it completes the lookup continues and picks up
> the alias.
>
> Is there some way to set a tracepoint to block?
>
> Maybe it would be enough to have something like:
>    if (strcmp(name, "MAGIC_NAME") =3D=3D 0) {
>         printk("waiting for MAGIC_NAME\n");
>         ssleep(15);
>    }
>
> and have the test harness watch dmesg for MAGIC_NAME then trigger the
> lookup.   Then adds some tracing to ovl_lookup() to ensure it picks up
> the right thing...

For this patch I am not asking for instrumentation with CI regression tests=
.
A word from you that you tested all the unexercised alias branches manually
and how (e.g. include printk and sleep test report) is the minimum
that I require
to avoid merging subtle test-compiled-only code.

For your parallel dirops odyssey as a whole, I think that proper
fstests coverage is
a must before the last step of relaxing the dir lock and the sooner you sta=
rt
with this the better the test coverage for all the perp series along the wa=
y.

Thanks,
Amir.
