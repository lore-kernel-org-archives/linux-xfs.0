Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA744B8287
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 13:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790775368; cv=pass; b=FsWdzxk5sTQkRVXI8dPSuMaEHViXCt15UxCQZRuv0wPF1bP/wWfFeIWrGZgi2H9L64JSH/ma2wNEFZ//ZarAcYgUdLmNpmUK50HYII9COS0bG+OjW9pu4Uqh0TMtTebjtEzovJaVMUKEsJxHDM1ejnLQvPqUIjlEVuIcj78HLaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790775368; c=relaxed/simple;
	bh=SXhpmvBhQ+TXtxniHLWeCSa452bmcr1rqYYurbJuz+I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nH6+5yCdhERu+/NtluvFt3pMTSO94F8rQqjNkF1OvU+cgcjqcX5Ng8hCuFnFX5eIHiuaJHoqgeZqrMoke9LuYDTMl/ISNPQxYj3EuuyRKaEg9YkHoIgojzUr3HNwPLJMxeEzVisfo2FUHkXP17WJalHNcGXycaqtIdckFxMyKDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=evutIW/P; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="evutIW/P"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6ac64e54f2fso2669648a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 06:36:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790775357; cv=none;
        d=google.com; s=arc-20260327;
        b=nsj0OdljfsgkqqgAwNOqldwWMFBNqrB/ek1DAtU+Ie/aegkd9KYfmFcFCKPPnuQ86q
         a4DcRbCnBz4BXGoJAFdNmWxR8J4Yk9j7rOM2+Ucrq9or5E4f0SzA7FgSYuStKX37QCMv
         qR/3vGqbUVXMghuv50GhkpwOE+HqiWD65xNS6V6gcq/Y7KsVZtTRRiaRO51Rw4izyk4u
         o5uEDszKjwROheYRi80vtj+vpYCbEUC0Siob8Sm0K3vXuTbONP7zAD/FIwX5XwfmwvpG
         vSZIXbiUkao6QQaG5Lp0oTi4s1q1IppDaEJPnLKEF8GiO6aewl/chzTNhtt7AxF6i1ff
         6qMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4QchkhwI1w5bSASLXqcxUjuWuiosjQacZxJlQZryO/o=;
        fh=PVJaHnG+XzHLBnicyt1J3Cd1MypWHOXnuOyXBB5bxlo=;
        b=C+ksiI9XTijylzKk2e+pwLphd1Q8lyKnB0MeBESA87+IX402t6YvHLoSsa68w1zr9t
         4m8yso6MXhhgaV7eTG54auWcUF+CnGjY8vZNl9/SVLGAkx6vQ0qzUW5mZjkbcw+LIBXu
         H7hEda/5h9gReseRJZokHjqgc5Gsq0i5tL2P9S7rI/Bt5yC/4LmYdHgvF+b5y7FnZ7co
         c6GngfjUYzBDyEStFJIDqhZTyP/itGfQ4UtsdKvffDtonuRSGoAcMwCJIImkBg24j2S2
         g46bTEvIZLL8O1pKjwy+eozO8tp8/16HKGNI1s4gyWlRsIAAfmMxG0FVbGtzDlFD3Rkt
         lm8A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790775357; x=1791380157; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4QchkhwI1w5bSASLXqcxUjuWuiosjQacZxJlQZryO/o=;
        b=evutIW/PczIr77lL6OkJRMbForrjcor9PZ2o3hdDZRiEKRhK23mwBgAZwekT7qYfZi
         uNb5iE02N4k+EHRQYemqbPk6OxiLD4JWoTOxI+X9sZG6X09iq35KZKzDuBA5VN4EWor+
         R02FWb9NbrEaQ7wxNRFw3G7jHpv5iVUyOUYY6sUVzVmJMwY1R61zOgLllebu+kDoX3dd
         uQaMpgaDzn9dL0uJidEjF9TsLLg75irnMkLP41dJfAtAtLJXPaZDsFak8YsFehEUXcC+
         iX6sr2QR5wuPzKhF8SicP1fSJCGHGZgvylrU6v97f0h3xVult1azYrPjsCnr4UUKwhfI
         +AWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790775357; x=1791380157;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4QchkhwI1w5bSASLXqcxUjuWuiosjQacZxJlQZryO/o=;
        b=ffViSF3G1ebK2OuUIJenIfpc7YAQRguapVW7s4vUTlEC6dm6yr8yKOywPmxtLHiiOZ
         4l3orbLqjgiHxlEOOiA/9Td8rLS2PZJTjlGy/0ua1PlQkXHl6vyVjo+rtAs/2JXOXu2X
         ft69UAwz96DxRL4cQRhNuurdrR3x8kIJiTZmO55j3DnGCRcSru8lz8Md91jjU7LTar5J
         6MxKAEuTO4rKu3kH22pvvZOWzA+AlxD8SfG95rGU8L0g3VDY7BqbWBJLWtb7R4XcFrbd
         QmjDCfo73UFWsiCTNRcahZStpETXbIBt8udW5/LewbOags+yQcc4+zr0+CSOkQs85KPV
         NLcQ==
X-Forwarded-Encrypted: i=1; AKwUvBwLtcd2rTpAM9vhSA4GrH8urYn+lcCRGt1gglAnPPJTydQj1hT/fJ+uup8tJ6dhg7RWRg016XHne7M=@vger.kernel.org
X-Gm-Message-State: AFuF++l09seRKj20R0Bz8y2qU1eb/v/44K0kyWk6egpxH40uId029y0U
	oyxsYTymw3UHSiAnGT/bI0Y0cKnVdQjTIQi5ZddgdwAH4f5kIb11zKUYP4fib4lJHSbczRiMYki
	MkjaZl0FgaCEwztv8oI3Vb5cGtMsnAkY=
X-Gm-Gg: AYBFou0M8GW1t/48Q+bTjD2WZG+B6PzUcTi4IC9mgou2vXfs2qmVyni2HB83pvsQEiM
	nXTiQ3OasvuSewCLO/z8ZduzfRiiiD1uP5mlkY3+WMFoBAs/G3JB/WCT4BxG5GCbJt5pC6gjpY/
	PrRGn+ovsSJ9TkCLkO3ccueM4D9yCzRYuLAQUN/kyS3t8f7lvlaLQ6JJ6R+B3R+1HaCLW9YrklG
	hgYVEqDkaVo6eSzRihivvO0UMAE3NuM0miDJYW8X/e6tql1eykB3zt+gSOBI20hPjo9l5EQAyGT
	5xeCd5sQYdHBRrDsAqv2DSzO/Oj8ttI4EvNJN+Hz8o48tGod+GmWj0Pcn/22qgwhp4/x
X-Received: by 2002:a17:906:6a05:b0:c2d:b9b4:f4de with SMTP id
 a640c23a62f3a-c2e23d9207amr125564266b.18.1790775356627; Wed, 30 Sep 2026
 06:35:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260929034158.1455429-1-neilb@ownmail.net> <20260929034158.1455429-8-neilb@ownmail.net>
In-Reply-To: <20260929034158.1455429-8-neilb@ownmail.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 30 Sep 2026 15:35:45 +0200
X-Gm-Features: AclHuK-7IYZDCVZREHuHZMSP_wgME-NMrM9tsJnpybGevda7U-xOXfVzEqygZdo
Message-ID: <CAOQ4uxjv3Ziqy+CjbCO7noAPse+a0066UO7pkFhStnnW9FFSPg@mail.gmail.com>
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

On Tue, Sep 29, 2026 at 5:43=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrote=
:
>
> From: NeilBrown <neil@brown.name>
>
> lookup_one() is expected to be removed as it does not fit well with
> proposed changes to directory locking.
> Specifically d_alloc_parallel() will be ordered outside of i_rwsem
> and as iterate_shared() is called with i_rwsem held it is not safe
> to call d_alloc_parallel().
>
> We can instead call d_alloc_trylock() and then call the ->lookup, but
> that can fail if there is a lookup attempt concurrent with the
> readdir().
>
> ovl cannot afford for the lookup to fail as that could produce incorrect
> results, and it cannot safely drop i_rwsem temporarily as that could
> introduce races with handling of the directory cache.
>
> Instead we rely on the fact that ovl_iterate() has an exclusive lock on
> the directory, so any concurrent lookup will wait for the ovl_iterate()
> call to complete.  We allocate a separate dentry and if the lookup is
> successful, it is hashed with the result.

Please document this assumption with:

rwsem_assert_held_write(&dir->d_inode->i_rwsem);

and comment in the code. Having it in the git commit message is not
enough for future code reviewers.

Other than that, I have no further comments, but I would like
to have a review from Miklos before this patch lands, because
I don't remember him reviewing any of the revisions and this is subtle.
I am a bit concerned that we have no test coverage for this subtle code.

>
> When the concurrent lookup gets i_rwsem it mustn't do its own lookup -
> it must use the existing dentry.  This is found, if it exists, using
> try_lookup_noperm().
>
> Signed-off-by: NeilBrown <neil@brown.name>
> ---
>  fs/overlayfs/namei.c   | 12 ++++++++++++
>  fs/overlayfs/readdir.c | 26 ++++++++++++++++++++++++--
>  2 files changed, 36 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index ca899fdfaafd..f56e33fd4d6b 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -1385,6 +1385,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct=
 dentry *dentry,
>         struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
>         struct ovl_entry *poe =3D OVL_E(dentry->d_parent);
>         bool check_redirect =3D (ovl_redirect_follow(ofs) || ofs->numdata=
layer);
> +       struct dentry *alias;
>         int err;
>         struct ovl_lookup_ctx ctx =3D {
>                 .dentry =3D dentry,
> @@ -1399,6 +1400,17 @@ struct dentry *ovl_lookup(struct inode *dir, struc=
t dentry *dentry,
>         if (dentry->d_name.len > ofs->namelen)
>                 return ERR_PTR(-ENAMETOOLONG);
>
> +       /*
> +        * The existence of this in-lookup dentry might have forced
> +        * readdir to do the lookup with a new dentry.  If so we must
> +        * return that one.
> +        */
> +       alias =3D try_lookup_noperm(&QSTR_LEN(dentry->d_name.name,
> +                                           dentry->d_name.len),
> +                                 dentry->d_parent);
> +       if (alias && !IS_ERR(alias))
> +               return alias;
> +
>         with_ovl_creds(dentry->d_sb)
>                 err =3D ovl_lookup_layers(&ctx, &d);
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index e7fe29cb6028..bc41da4bace8 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -574,8 +574,30 @@ static int ovl_cache_update(const struct path *path,=
 struct ovl_cache_entry *p,
>                 }
>         }
>         /* This checks also for xwhiteouts */
> -       this =3D lookup_one(mnt_idmap(path->mnt), &QSTR_LEN(p->name, p->l=
en), dir);
> -       if (IS_ERR_OR_NULL(this) || !this->d_inode) {
> +       this =3D d_alloc_trylock(dir, &QSTR_LEN(p->name, p->len));
> +       if (this =3D=3D ERR_PTR(-EWOULDBLOCK)) {
> +               /*
> +                * Some other thread is looking up this name and will
> +                * block on i_rwsem before it can complete the lookup.
> +                * We will do the lookup in a new dentry and when that
> +                * lookup gets a turn it will find and return this
> +                * dentry.
> +                */
> +               this =3D d_alloc_name(dir, p->name);
> +               if (!this)
> +                       this =3D ERR_PTR(-ENOMEM);
> +       }
> +       if (!IS_ERR(this) && d_unhashed(this)) {
> +               /* Either we got an in-lookup or we made our own unhashed=
 */
> +               struct dentry *alias =3D ovl_lookup(dir->d_inode, this, 0=
);
> +
> +               d_lookup_done(this);
> +               if (alias) {
> +                       dput(this);
> +                       this =3D alias;
> +               }
> +       }
> +       if (IS_ERR(this) || !this->d_inode) {
>                 /* Mark a stale entry */
>                 p->is_whiteout =3D true;
>                 if (IS_ERR(this)) {

How do you test your patch set? Do you have tests that exercise
parallel create/lookup/readdir?

It would be irresponsible to merge code without showing that the `alias`
branches have been exercised. Do you have an idea how to do that?

Thanks,
Amir.
