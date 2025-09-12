Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BEE2C08C5
	for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 20:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757707809; cv=none; b=Gp8RRDHnhCvAJ/787Tf5GqNBF1Gvcrn7bt2awj7w6sev7mSPzc1D5mPERyFCqalsN/tv4BgKsHMSvdE6rttcPFSPx9vt1Hho0TtWebirq/M3ZBY0eC/Z41R/Y4Ri9zlXrqsZJ72XLZSfwhT9288QuzW8Smh/6NjuBowuADmVMpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757707809; c=relaxed/simple;
	bh=J7whkdgtw+r5eOooTlUKSxqksHF4jMLVv76DD83j+Vo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=atkJyKXCxBGCs8A+pUQLr+x0nczUnTk4fpqbFYZuI1R6uDm5d6qtbl+B1zImsB+AY59swYSB+9lnq4/WW6gQ19YNeXY++wRxlhsYzSoOupbpRkqE7h1a0ShTDIeiU5sCwDVdDxoLFnbgWj2i8NHsQrQfOmSTcccIAV0Qt2+lgko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DV6u0Isg; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DV6u0Isg"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b5e4fc9b4fso19932741cf.2
        for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 13:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757707807; x=1758312607; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kUvk3PQT9iJETVmI+H9Y57Sl5Dee/ugWdBMz2xir9FU=;
        b=DV6u0IsgVFNPqGtB+m+ojn3dj4gHL2UmDA1mE0/ukBtGUT2Cfz53LgCswjm/9J9/Bj
         nJwW0gPDkQPJ50F0nGWv6vtV7i95GejKrkoAaCtJrkugobKs5CEAvHFAGOnjb3mlLgg6
         obLjFQ/wquE5e6jJwUi6yNuZ4QCuIc/HqRsjvgLOnAQVUnKHzlg+mhEpUAvk+KFtyFih
         rv1wxxdC61fCWVORHBuTOwNSEspRnI6UZFoXRVpOVNsV+9cNCikTrnBv2Ogdv9U5bkKE
         TxgYH90afG37tIayKuUmsTDbkn3SmjuVZzvjzeHCblj7QyyL4UrASKWMUi7qg9Wo6diu
         RwJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757707807; x=1758312607;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kUvk3PQT9iJETVmI+H9Y57Sl5Dee/ugWdBMz2xir9FU=;
        b=qnc95902S4zWpjZvwpJfLScxEDM0HPFtgdDkG3gMj4omZt5jaYrsy6+i55ZrwYrbSS
         4SUNCrTbEbZEqERWGKaAHtg+1z7am+57Xc4KjpXH95XD/AjH0gEIuqBAunzrhC06slbF
         DNTmbENk6vhyZPyxwMo+A8s5+nmnuj5jqXByDcY+mahCcouTgpD2rXJijaRzbO53X0IE
         Djd14cqHdLmWn0OSZkkpUTiLbXWnuNyiC/oUkZyeslotW44nvbBtRd0qN4JZs5sLA9MA
         7cwvTwSK/UF/1A8/XU+CT5Cdajbfiwgc6bojsfQQf4EtV+FQQMS5ZxL6GXwSfqWdZwmX
         Mkig==
X-Forwarded-Encrypted: i=1; AJvYcCWrbxpCjgdtFS5wh6mskr8+lW+8bYgLVoQZcDdI7VXEgkWx5y0U2vhsEpoX8pwlGYDpCC9Rd9dG+DY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3sQl5s6WbgI+KOoOAIvJMyqHUrqVdfduHIuKcNkivZ0hRnJcu
	p1VoanO+vxKdMRM0IfX6NduSDu++C+xkWD0SgxOnzsZh9DRSD1Qr+hLxaN5RWnDiqny4TEBwyIl
	7GeVn9tFF/UD5SE7mtWjtqLnjgy+J1Q4=
X-Gm-Gg: ASbGncvLNI2kz+Ff9RUadrlmywV4ObKqWcslF3+lnWQShzJ/je1kVED+g31XQCgJvQS
	m7kYXQ+wd6AXOPvUUTQQ/Tai/Q+vQpQmLYtRW3JjoHwwET03YISUdJklcglCyLYALY1k02J9pl4
	t/0N87809gLimFfbZ2YDx2+lG9GBA/CTyLQmSx9M0c/q+PBgKhzfS/E7Cw1XuYQ3xSr1sPvauOJ
	KxA3pm1eptmz1u8hflmvPdNNFm5jQ4sxlDhrwcjejI4cB5xUH2ZhbIBx8rJ
X-Google-Smtp-Source: AGHT+IEWbv39vMnYlQ1SD0ZUhw0yLiTfWxsf26h64ZL6lZSTKK/c4qoFwMSw183eQ+ZBkoMKnWL15JY76Ze4fGknDs4=
X-Received: by 2002:a05:622a:1805:b0:4b7:5de6:a69 with SMTP id
 d75a77b69052e-4b77d097ca4mr48388851cf.30.1757707806462; Fri, 12 Sep 2025
 13:10:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250908185122.3199171-1-joannelkoong@gmail.com>
 <20250908185122.3199171-14-joannelkoong@gmail.com> <a1529c0f-1f1a-477a-aeeb-a4f108aab26b@linux.alibaba.com>
 <CAJnrk1aCCqoOAgcPUpr+Z09DhJ5BAYoSho5dveGQKB9zincYSQ@mail.gmail.com>
 <0b33ab17-2fc0-438f-95aa-56a1d20edb38@linux.alibaba.com> <aMK0lC5iwM0GWKHq@infradead.org>
 <9c104881-f09e-4594-9e41-0b6f75a5308c@linux.alibaba.com> <CAJnrk1b2_XGfMuK-UAej31TtCAAg5Aq8PFS_36yyGg8NerA97g@mail.gmail.com>
 <6609e444-5210-42aa-b655-8ed8309aae75@linux.alibaba.com> <66971d07-2c1a-4632-bc9e-e0fc0ae2bd04@linux.alibaba.com>
 <267abd34-2337-4ae3-ae95-5126e9f9b51c@linux.alibaba.com> <CAJnrk1Y31b-Yr03rN8SXPmUA7D6HW8OhnkfFOebn56z57egDOw@mail.gmail.com>
In-Reply-To: <CAJnrk1Y31b-Yr03rN8SXPmUA7D6HW8OhnkfFOebn56z57egDOw@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 12 Sep 2025 16:09:53 -0400
X-Gm-Features: Ac12FXy-J-VlWsro9NrSIzcDj4rKWuNwCZfBlBwTbl7b7lNj5FofdR9Weg0GYow
Message-ID: <CAJnrk1ZXM-fRKytRFptKNJrdN9pSbKJqXLW80T4UY=RLRKOBKQ@mail.gmail.com>
Subject: Re: [PATCH v2 13/16] iomap: move read/readahead logic out of
 CONFIG_BLOCK guard
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Christoph Hellwig <hch@infradead.org>, brauner@kernel.org, miklos@szeredi.hu, 
	djwong@kernel.org, linux-block@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com, 
	linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 12, 2025 at 3:56=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Thu, Sep 11, 2025 at 9:11=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibab=
a.com> wrote:
> >
> > On 2025/9/12 09:09, Gao Xiang wrote:
> > >
> > >
> > > On 2025/9/12 08:06, Gao Xiang wrote:
> > >>
> > >>
> > >> On 2025/9/12 03:45, Joanne Koong wrote:
> > >>> On Thu, Sep 11, 2025 at 8:29=E2=80=AFAM Gao Xiang <hsiangkao@linux.=
alibaba.com> wrote:
> > >>
> > >>>> But if FUSE or some other fs later needs to request L2P informatio=
n
> > >>>> in their .iomap_begin() and need to send L2P requests to userspace
> > >>>> daemon to confirm where to get the physical data (maybe somewhat
> > >>>> like Darrick's work but I don't have extra time to dig into that
> > >>>> either) rather than just something totally bypass iomap-L2P logic
> > >>>> as above, then I'm not sure the current `iomap_iter->private` is
> > >>>> quite seperate to `struct iomap_read_folio_ctx->private`, it seems
> > >>>
> > >>> If in the future this case arises, the L2P mapping info is accessib=
le
> > >>> by the read callback in the current design. `.read_folio_range()`
> > >>> passes the iomap iter to the filesystem and they can access
> > >>> iter->private to get the L2P mapping data they need.
> > >>
> > >> The question is what exposes to `iter->private` then, take
> > >> an example:
> > >>
> > >> ```
> > >> struct file *file;
> > >> ```
> > >>
> > >> your .read_folio_range() needs `file->private_data` to get
> > >> `struct fuse_file` so `file` is kept into
> > >> `struct iomap_read_folio_ctx`.
> > >>
> > >> If `file->private_data` will be used for `.iomap_begin()`
> > >> as well, what's your proposal then?
> > >>
> > >> Duplicate the same `file` pointer in both
> > >> `struct iomap_read_folio_ctx` and `iter->private` context?
> > >
> > > It's just an not-so-appropriate example because
> > > `struct file *` and `struct fuse_file *` are widely used
> > > in the (buffer/direct) read/write flow but Darrick's work
> > > doesn't use `file` in .iomap_{begin/end}.
> > >
> > > But you may find out `file` pointer is already used for
> > > both FUSE buffer write and your proposal, e.g.
> > >
> > > buffer write:
> > >   /*
> > >    * Use iomap so that we can do granular uptodate reads
> > >    * and granular dirty tracking for large folios.
> > >    */
> > >   written =3D iomap_file_buffered_write(iocb, from,
> > >                                       &fuse_iomap_ops,
> > >                                       &fuse_iomap_write_ops,
> > >                                       file);
> >
> > And your buffer write per-fs context seems just use
> > `iter->private` entirely instead to keep `file`.
> >
>
> I don=E2=80=99t think the iomap buffered writes interface is good to use =
as a
> model. I looked a bit at some of the other iomap file operations and I
> think we should just pass operation-specific data through an
> operation-specific context for those too, eg for buffered writes and
> dio modifying the interface from
>
> ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter
> *from, const struct iomap_ops *ops, const struct iomap_write_ops
> *write_ops, void *private);
> ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter, const
> struct iomap_ops *ops, const struct iomap_dio_ops *dops, unsigned int
> dio_flags, void *private, size_t done_before);
>
> to something like
>
> ssize_t iomap_file_buffered_write(const struct iomap_ops *ops, struct
> iomap_write_folio_ctx *ctx);
> ssize_t iomap_dio_rw(const struct iomap_ops *ops, struct iomap_dio_ctx *c=
tx);
>
> There=E2=80=99s one filesystem besides fuse that uses =E2=80=9Citer->priv=
ate=E2=80=9D and
> that=E2=80=99s for xfs zoned inodes (xfs_zoned_buffered_write_iomap_begin=
()),
> which passes the  struct xfs_zone_alloc_ctx*  through iter->private,
> and it's used afaict for tracking block reservations. imo that's what
> iter->private should be used for, to track the more high level
> metadata stuff and then the lower-level details that are
> operation-specific go through the ctx->data fields. That seems the
> cleanest design to me. I think we should rename the iter->private
> field to something like "iter->metadata" to make that delineation more
> clear.  I'm not sure what the iomap maintainers think, but that is my
> opinion.
>
> I think if in the future there is a case/feature which needs something
> previously in one of the operation-specific ctxes, it seems fine to me
> to have both iter->private and ctx->data point to the same thing.
>
>
> Thanks,
> Joanne
>
> > >
> > >
> > > I just try to say if there is a case/feature which needs
> > > something previously in `struct iomap_read_folio_ctx` to
> > > be available in .iomap_{begin,end} too, you have to either:
> > >   - duplicate this in `iter->private` as well;
> > >   - move this to `iter->private` entirely.
> > >
> > > The problem is that both `iter->private` and
> > > `struct iomap_read_folio_ctx` are filesystem-specific,
> > > I can only see there is no clear boundary to leave something
> > > in which one.  It seems just like an artificial choice.
> > >
> > > Thanks,
> > > Gao Xiang
> > >
> > >>
> > >>
> > >>>
> > >>>> both needs fs-specific extra contexts for the same I/O flow.
> > >>>>
> > >>>> I think the reason why `struct iomap_read_folio_ctx->private` is
> > >>>> introduced is basically previous iomap filesystems are all
> > >>>> bio-based, and they shares `bio` concept in common but
> > >>>> `iter->private` was not designed for this usage.
> > >>>>
> > >>>> But fuse `struct iomap_read_folio_ctx` and
> > >>>> `struct fuse_fill_read_data` are too FUSE-specific, I cannot
> > >>>> see it could be shared by other filesystems in the near future,
> > >>>> which is much like a single-filesystem specific concept, and
> > >>>> unlike to `bio` at all.
> > >>>
> > >>> Currently fuse is the only non-block-based filesystem using iomap b=
ut
> > >>> I don't see why there wouldn't be more in the future. For example,
> > >>> while looking at some of the netfs code, a lot of the core
> > >>> functionality looks the same between that and iomap and I think it
> > >>> might be a good idea to have netfs in the future use iomap's interf=
ace
> > >>> so that it can get the large folio dirty/uptodate tracking stuff an=
d
> > >>> any other large folio stuff like more granular writeback stats
> > >>> accounting for free.
> > >>
> > >> I think you need to ask David on this idea, I've told him to
> > >> switch fscache to use iomap in 2022 before netfs is fully out [1],
> > >> but I don't see it will happen.
> > >>
> > >> [1] https://lore.kernel.org/linux-fsdevel/YfivxC9S52FlyKoL@B-P7TQMD6=
M-0146/

(sorry, just saw this part of the email otherwise I would have
included this in the previous message)

Thanks for the link to the thread. My understanding is that the large
folio optimizations stuff was added to iomap in July 2023 (afaict from
the git history) and iomap is entangled with the block layer but it's
becoming more of a generic interface now. Maybe now it makes sense to
go through iomap's interface than it did in 2022, but of course David
has the most context on this.


Thanks,
Joanne

> > >>
> > >> Thanks,
> > >> Gao Xiang
> > >
> >
