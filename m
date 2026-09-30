Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3085221CF;
	Wed, 30 Sep 2026 21:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804649; cv=none; b=N74Vy0g0rJ06Rt9PAfnPDwXueCbG/IkfVfIWRkXZL9Q9V+hXGoQzfy9cwCLL59d9eN5XLi8ECV9bkXNZK2tDmaGtec0DLYwaKLOFhKECUPbkNTjhCTL+UmEFqpGfVPBDz8kR3GY2/wqtC6MaakKtnziPgctVL6zN1UkJhvX70ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804649; c=relaxed/simple;
	bh=6jGfrpS5Jl0FjihBGqxK30+kLYzuQK6S82ckCkSkp+U=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=F6Iz/n9oUnirfYU47OHP6R9l6txS/0D7EULzWrb6RQq6c65guGK7rrdnxF9r5AauMDUd2GAnkur70WU0Lydj6RJPNs0R6sImB1Zb5K2RkhtUeGanpFWcR2REmLbH6nZzUE40AocsPffPDI3E5aGhK0hn73BdVaWTWqnRdcOHifo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=nK4WOWP9; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=XM0InDx1; arc=none smtp.client-ip=202.12.124.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="nK4WOWP9";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XM0InDx1"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailflow.stl.internal (Postfix) with ESMTP id E56B21300419;
	Wed, 30 Sep 2026 17:44:05 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Wed, 30 Sep 2026 17:44:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1790804645; x=1790811845; bh=7ANX24WlQPzuYv+tWq1sOJ4UFjjGVeWsQPC
	zo36ZmO8=; b=nK4WOWP98KrgLP/ZsKBc2+u7ccyllbkCiyBAkVlNvIiM9razgty
	5uR558w7TqmR3k7a9dJeZjR6UlkK7v/YJDk2xNpHE3kntMvrJexUaqxZxdNPTEJg
	MCrG9oRhBGlC0hQ76LM4aBPBN1jNSoezchhZQeOa5yTD5cqU5tOVAJuItKdFAgTq
	lCTguyMvn484p9OUKD1BleBmFPaPx+FSe8mLrnSwYYb+MPmISuXzMIdzAzt7qrEs
	3c7WOAY+m80kfxgcTE0Nu1qhswp7GMfDWR7+I5aNcQ23arE4UCi+MTdkkQPmfw8f
	jw9OvWYqkWNW9sK7LqE3nJXjFFK+h8S/GIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790804645; x=
	1790811845; bh=7ANX24WlQPzuYv+tWq1sOJ4UFjjGVeWsQPCzo36ZmO8=; b=X
	M0InDx1+1/xcvOt8RRnztidOa9ysL/M/7BoFXMsDFtTdOmK5uM7+tDGktCT4K99C
	xJAyLwJVmZbqpigISSuqe/13h39PHVxE/2KnbJuFNaW2tHhsjWcdgP2bGxD/C1iv
	wiS075HpVMHP35Kkorq/nyDMLVpGTr+BbdNcIUdFYxG0Ztq39Jq+whZCMIma463c
	S4kYaHGM6e/WV0TANaqjOja70YeOYLqpUicNy54cOPxJdtFLqeZauv+G/E8os9+g
	0SS/yFpvsKfe0aCLc1GDxDm/0Jl2uqHuF7sCFCqKPV5rtqLPZYSKjPJyYHKnl5AJ
	Szaa725xTnm0ZYPrL8rDw==
X-ME-Sender: <xms:o4K9an6oFdKlAb7bTs28h4Y-dRMdUaqC0lkcVi6KxJrEAGCxWsRtNA>
    <xme:o4K9av0Pw5BaWsSy-ed6w40xnwYz8bHpb5piuiGV6CnRy5qZLtguGdzw2YpgP3LbA
    FBKxh6FRHxlmvDENFOiqCp7iytfLJukGxWF4a5hpgvfqsiAgA>
X-ME-Received: <xmr:o4K9ampxb2POcbUrmxxkCIH9R_GF7fTF87HkVy30aseRZTjCsUmNMt2cVwRQ_yzKmQknYMelmUMd_7j1348qQ19ySji9QB8>
X-ME-Proxy-Cause: dmFkZTE88JaBd72bzN9WKmDLMIAdc8yPdEr2e1dY8hYycQh71cA7dktVoAtxocNOhiZIqd
    XE2Lz5YC24ZiSb3gg42UrbiN0T+wGibcVtziFDxKbabAWobdNTDlKJK9FW4je5MLGNFYWF
    njSQ5JqEWu5Lu4o8A7r7mBl2z3S1m+RxF2xgsusbwCure7sDWYdKZuWr31AJnIZAVGXc5o
    GQkiPEIzkldRDD38rAxWO7B28PLHHHUoZFTy46Gqr6gXP8SrTJsnMOuSLc6WFiSoM9VABn
    TSb2K72dTtRK+nmyMMe/+FG8WUSE8aENyj2P3VnDowAejdxrkJE28T8U81CdReS9ImVUjc
    Uw/z1cWyG04/8h7m2I40m3s0F5ginzpm54xz6yHhLIiEhMDqCZA2NuGgcMisqRs/yDqhFd
    s2BToRJUZwlxdC0PeFiwCCuBd5Q7er5DY4dFDBvYr8oz8u21R/6U+L506utdp0iG1j9FKz
    qQybyn+i6IJttGwfavr2ZFym48otz2WUK322KS2clzenGrbzRVo2/l12yauF0P2mJk5ucu
    KHIMv7SLwBsMZIPzNLxfw7Ni2qoh9Fyc0pSvLMnX2DwvOzPdNZlOJCN9vK9LWmF7yXrRH4
    T08XtHCXJ24PlbfDt3gtIAXlYKEQH+PBq+MXobEQ+f9zBzVZnanIC63951fw
X-ME-Proxy: <xmx:o4K9am8qCo0uEzCfM7Lr365_EQUepSF6bQwPau5BCxvx3G1eqMwqsg>
    <xmx:o4K9ap4om6wHDllUpFNK8yIRpojzfG0GuxzvCzvpWLww6FjcDatWbA>
    <xmx:o4K9ai1VY9NLH3I4ku6U_9yoBVc1cFsWtPszkr_cr1_-H5rxEfV2Qg>
    <xmx:o4K9ajjP3mgsz2-en6le1ZsLmxbPrM1KRR5IVPfrLd6VZpPZrUII2A>
    <xmx:pYK9aoPp5yYDmSjA4R94pVS8ct7fFcniPcJ5mIE429VO0-P9IogrOOSF>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 30 Sep 2026 17:43:56 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Amir Goldstein" <amir73il@gmail.com>
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, "Kees Cook" <kees@kernel.org>,
 "Joel Granados" <joel.granados@kernel.org>,
 "Richard Weinberger" <richard@nod.at>,
 "Anton Ivanov" <anton.ivanov@cambridgegreys.com>,
 "Johannes Berg" <johannes@sipsolutions.net>,
 "Breno Leitao" <leitao@debian.org>,
 "Andreas Hindborg" <a.hindborg@kernel.org>,
 "Jan Harkes" <jaharkes@cs.cmu.edu>, "Hugh Dickins" <hughd@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Namjae Jeon" <linkinjeon@kernel.org>,
 "Hyunchul Lee" <hyc.lee@gmail.com>, "Carlos Maiolino" <cem@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>,
 "Jeff Layton" <jlayton@kernel.org>, "Jan Kara" <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
 linux-um@lists.infradead.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu,
 linux-mm@kvack.org, ntfs@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] ovl: stop using lookup_one() in ovl_iterate().
In-reply-to:
 <CAOQ4uxjv3Ziqy+CjbCO7noAPse+a0066UO7pkFhStnnW9FFSPg@mail.gmail.com>
References: <20260929034158.1455429-1-neilb@ownmail.net>
  <20260929034158.1455429-8-neilb@ownmail.net>
  <CAOQ4uxjv3Ziqy+CjbCO7noAPse+a0066UO7pkFhStnnW9FFSPg@mail.gmail.com>
Date: Thu, 01 Oct 2026 07:43:52 +1000
Message-id: <179080463287.37859.4262341831478331513@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Wed, 30 Sep 2026, Amir Goldstein wrote:
> On Tue, Sep 29, 2026 at 5:43=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrote:
> >
> > From: NeilBrown <neil@brown.name>
> >
> > lookup_one() is expected to be removed as it does not fit well with
> > proposed changes to directory locking.
> > Specifically d_alloc_parallel() will be ordered outside of i_rwsem
> > and as iterate_shared() is called with i_rwsem held it is not safe
> > to call d_alloc_parallel().
> >
> > We can instead call d_alloc_trylock() and then call the ->lookup, but
> > that can fail if there is a lookup attempt concurrent with the
> > readdir().
> >
> > ovl cannot afford for the lookup to fail as that could produce incorrect
> > results, and it cannot safely drop i_rwsem temporarily as that could
> > introduce races with handling of the directory cache.
> >
> > Instead we rely on the fact that ovl_iterate() has an exclusive lock on
> > the directory, so any concurrent lookup will wait for the ovl_iterate()
> > call to complete.  We allocate a separate dentry and if the lookup is
> > successful, it is hashed with the result.
>=20
> Please document this assumption with:
>=20
> rwsem_assert_held_write(&dir->d_inode->i_rwsem);
>=20
> and comment in the code. Having it in the git commit message is not
> enough for future code reviewers.

Yes, I can do that.

>=20
> Other than that, I have no further comments, but I would like
> to have a review from Miklos before this patch lands, because
> I don't remember him reviewing any of the revisions and this is subtle.
> I am a bit concerned that we have no test coverage for this subtle code.
>=20
> >
> > When the concurrent lookup gets i_rwsem it mustn't do its own lookup -
> > it must use the existing dentry.  This is found, if it exists, using
> > try_lookup_noperm().
> >
> > Signed-off-by: NeilBrown <neil@brown.name>
> > ---
> >  fs/overlayfs/namei.c   | 12 ++++++++++++
> >  fs/overlayfs/readdir.c | 26 ++++++++++++++++++++++++--
> >  2 files changed, 36 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index ca899fdfaafd..f56e33fd4d6b 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -1385,6 +1385,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct=
 dentry *dentry,
> >         struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
> >         struct ovl_entry *poe =3D OVL_E(dentry->d_parent);
> >         bool check_redirect =3D (ovl_redirect_follow(ofs) || ofs->numdata=
layer);
> > +       struct dentry *alias;
> >         int err;
> >         struct ovl_lookup_ctx ctx =3D {
> >                 .dentry =3D dentry,
> > @@ -1399,6 +1400,17 @@ struct dentry *ovl_lookup(struct inode *dir, struc=
t dentry *dentry,
> >         if (dentry->d_name.len > ofs->namelen)
> >                 return ERR_PTR(-ENAMETOOLONG);
> >
> > +       /*
> > +        * The existence of this in-lookup dentry might have forced
> > +        * readdir to do the lookup with a new dentry.  If so we must
> > +        * return that one.
> > +        */
> > +       alias =3D try_lookup_noperm(&QSTR_LEN(dentry->d_name.name,
> > +                                           dentry->d_name.len),
> > +                                 dentry->d_parent);
> > +       if (alias && !IS_ERR(alias))
> > +               return alias;
> > +
> >         with_ovl_creds(dentry->d_sb)
> >                 err =3D ovl_lookup_layers(&ctx, &d);
> >
> > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > index e7fe29cb6028..bc41da4bace8 100644
> > --- a/fs/overlayfs/readdir.c
> > +++ b/fs/overlayfs/readdir.c
> > @@ -574,8 +574,30 @@ static int ovl_cache_update(const struct path *path,=
 struct ovl_cache_entry *p,
> >                 }
> >         }
> >         /* This checks also for xwhiteouts */
> > -       this =3D lookup_one(mnt_idmap(path->mnt), &QSTR_LEN(p->name, p->l=
en), dir);
> > -       if (IS_ERR_OR_NULL(this) || !this->d_inode) {
> > +       this =3D d_alloc_trylock(dir, &QSTR_LEN(p->name, p->len));
> > +       if (this =3D=3D ERR_PTR(-EWOULDBLOCK)) {
> > +               /*
> > +                * Some other thread is looking up this name and will
> > +                * block on i_rwsem before it can complete the lookup.
> > +                * We will do the lookup in a new dentry and when that
> > +                * lookup gets a turn it will find and return this
> > +                * dentry.
> > +                */
> > +               this =3D d_alloc_name(dir, p->name);
> > +               if (!this)
> > +                       this =3D ERR_PTR(-ENOMEM);
> > +       }
> > +       if (!IS_ERR(this) && d_unhashed(this)) {
> > +               /* Either we got an in-lookup or we made our own unhashed=
 */
> > +               struct dentry *alias =3D ovl_lookup(dir->d_inode, this, 0=
);
> > +
> > +               d_lookup_done(this);
> > +               if (alias) {
> > +                       dput(this);
> > +                       this =3D alias;
> > +               }
> > +       }
> > +       if (IS_ERR(this) || !this->d_inode) {
> >                 /* Mark a stale entry */
> >                 p->is_whiteout =3D true;
> >                 if (IS_ERR(this)) {
>=20
> How do you test your patch set? Do you have tests that exercise
> parallel create/lookup/readdir?
>=20
> It would be irresponsible to merge code without showing that the `alias`
> branches have been exercised. Do you have an idea how to do that?

I think that to trigger the 'alias' code we would need to instrument the
code to block and wait.
e.g.  when readdir sees a particular name it could signal the test
harness somehow and then wait.  The test harness would trigger a lookup
of the name which would block on the parent i_rwsem.
The readdir then continues somehow and gets -EWOULDBLOCK and installs
the alias dentry.  When it completes the lookup continues and picks up
the alias.

Is there some way to set a tracepoint to block?

Maybe it would be enough to have something like:
   if (strcmp(name, "MAGIC_NAME") =3D=3D 0) {
	printk("waiting for MAGIC_NAME\n");
	ssleep(15);
   }

and have the test harness watch dmesg for MAGIC_NAME then trigger the
lookup.   Then adds some tracing to ovl_lookup() to ensure it picks up
the right thing...

NeilBrown

>=20
> Thanks,
> Amir.
>=20

