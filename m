Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78A218C332
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2026 00:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783037837; cv=pass; b=reXIEkXVdZ41IGYwAtNb5fo7Zeb+QPyswmcuI4K8EK9CTsU3BFij11IE2VNVDsXRyzgI/5kgkcJ7QiWuBoWtX+tuT9nviaP6xCQZjPJ0uAA/6/H0sYFYnaX/VF+I+jRBUq7GqY5BEmm8PdiMfZLAndYno02nHMcH5HFzdLuIaRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783037837; c=relaxed/simple;
	bh=kRH5ME6cl2uOZNTf4Hz7cjp4HebVSYInnLBFWd3k8/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RJpzDru+K6V2Ty2UduxCS4icX/94CQE7PSfQPcuqlaMd4QPCF796LNLYrBcLA8ekovTJJ4pmK4myqhKMUns9dLu2rcC5uqBxvzQqDz0l/R1E85uWe8g6g92DXXa1fWZ00160DB8H6EMZi2LCjvYFx/mL1ChJZNEB9UIZ2dGCAlQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a253fLdl; arc=pass smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a253fLdl"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-493c55d5c7aso12080285e9.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 17:17:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783037834; cv=none;
        d=google.com; s=arc-20260327;
        b=jBFINqinC39RK5G98ciHbJkVJ9Rx3OnvTRNfv2QURKHhiO1td6lnMN9du1kLXNJ9sv
         dfnTLgB8yAz8hCh4+gA3Dz2SGYPEa7m494kBAo1W+8A3Gj//rGCETAKA6OdHDGr6d2Bk
         Zjhex7AYAIVX5+nArKkqN2bZQDbx3Z1INbW1y1i17DYQDY3QxrRf+sjLO5D7Ef7q1Zky
         z/pfJs+AQea+nAg2VNJLVXvRve26d2zH5NQ5rNewtqibRdGZnUPUOAP2a1ko4MZVFuLl
         j/d4HzhDnD/cx/lrDN2pyyJ+VjzrvcbEXcgBy1CSvj1u3hveg1rzzjHpEEG3ydvZfdva
         xcxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vU7OEUrLlyve1bXZ6P0sGV5EAt2DQDqFHvcpp7wTUdg=;
        fh=SnjNo5MJRqMajmZ8NNuCUtUYVGecZA1bV0jrD3augMo=;
        b=H7FkoDNxsPNkGfgxSH0kNl5bucBUaunx4UwTv4NG1vCdXeZpiAS9T/rPZIFQ7dxXLN
         ldC71fXd7M+AZzBpz4WUxJJy3N/+3PrO1EfIIq3iZjRVtuVfa/w0nd6Ay8SPu3wEvI4R
         tjAzn4yjxAHR1XPOkNOINiih8xEbHxHTQGsIyuxsQ/6lCMsVCkrHzgN1ZMEPfhgJdBYZ
         mGnKxEsnMbFf86VMLv1zdzNdhzfkVhkwf2NLQGpgxYOrdN53dg3o0Bneom/LXm23bVKY
         akkkTczimYCIHorixuRFKnwvhbPwoZQ+rtgaADrjaHjRE0lesChPefpgQ4CmSa2f9xq+
         gi8w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783037834; x=1783642634; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vU7OEUrLlyve1bXZ6P0sGV5EAt2DQDqFHvcpp7wTUdg=;
        b=a253fLdlbH8sjLvBQuxc18I7crzBttsxvYqvDQKjdsDqmfby4HxHTiwKBeYtfQQ1p2
         fh/NNNkiEW9X42YMwUy5BL6qjFZsgG79TS93wnUMg1ENd7lC9bWuRUojmsAlFGZlG7oR
         SPjr+K7XCDpAgW3mCbvg+3BmePEaE825ByxEhVgqByT1XDwEnrKuSX5d/yF2BLyer5mS
         ChzX45p2lDAQtLYtKI3ytM7J+SsLMMfkvDL4l5QHFiLAakQhDJWvXcVQTV0RU+xHFX02
         oIR4u6PTI4Aj/4YErRx6q+umHvbfjb03WNF1DboheuhkNRvK6jK32I/h0fQL9HRfAZcY
         tvCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783037834; x=1783642634;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vU7OEUrLlyve1bXZ6P0sGV5EAt2DQDqFHvcpp7wTUdg=;
        b=SkoAEPBdO0MzKK+JILbMhhEuwHQouJ1ASc6c7yDewA1yp+jTef9Gw+hvOV+KsauqOI
         N2n8GAZnQIEGZzsLmklH3v9B5QEeSnnBN5JltbMZhLxXWpzHnpvofM+k2H56011bGZXv
         jZltCvdJSUER9uyW/389y2G+g2MXKQnm3zPg/FJaVoFjbFVrOTR1fhQ58qu79V5Gd4mE
         rHEanoyN2qWNYInQNsMbtO4+hhJrc4n+qPAxtRbbYmDVWnHcMRRGpxo91KrUif5AuQ1/
         2E9hAu+RWpCT/47kVRc30DxHHmVu3VB5hBvNloKVGRP/f5ptzyMSDxfCUCodqkRub+of
         ++cA==
X-Forwarded-Encrypted: i=1; AFNElJ9gJvApJzm8iwy3D50YEO5ZMgjz5NE9DwSicwxsm+O+NO/2EjcRcwsTD4K7mS14l5aLLYCMjXZ+X/I=@vger.kernel.org
X-Gm-Message-State: AOJu0YytgYnNXbixh2WMmCt0iHgfRR0bkboM0hYL7kGwD/4jrrv2dLZq
	oAyGhhpkMIz8G5dYUmy6EGkoCvApHQb3So3yhr87K2C3y2cwpSzmf+f3lBHg35QIqglNm+p4wX2
	WtqqcW6U7ybZ98mzHwmCPZISHZCTiO9U=
X-Gm-Gg: AfdE7cnHrV4PvHUFwyszkfClQhjWDQnKAKZnriyOtMBLxak5ehnurCDzX7nD+3W+Fh7
	5S+YlF35jC4yjcv1U3hFWBP27DaG5yJcl3zQUJrb39BftzpgiL2N0YxxPdWPGioFTyybPgNkATT
	mvGUSJ6/cODyw4QAVTgOglbMB7Vzj0UNvaFDp/dKyqiogDPjxdnKDD5n9yzJ95u8hALU4nj7yR3
	k7uObEn2CNH/SH9g4lOUcGjBCyrTIg+yMyGsgt2xfMxAOOWWAWgotECtOxseia1elE4xkL+A/rB
	PwiAnh8kyx9kV6tX6/F4KBqezktBab4WC3m6/wF9Rhjhedd53DIilix64Ofm2ZI=
X-Received: by 2002:a05:600c:46d0:b0:493:bc4a:c6b6 with SMTP id
 5b1f17b1804b1-493c2ba1d3emr113298325e9.38.1783037834179; Thu, 02 Jul 2026
 17:17:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-18-joannelkoong@gmail.com> <20260702165841.GM9392@frogsfrogsfrogs>
In-Reply-To: <20260702165841.GM9392@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 2 Jul 2026 17:17:02 -0700
X-Gm-Features: AVVi8CcxJan3XgaMiYmE7l9m1K7rjamtB3vH8NBAZsWn7x4K1BrIcNnVAJIzZPo
Message-ID: <CAJnrk1YW0gKRVvHRC+WeKoV2vrquzaC6UkipZkQ34Z0RAQDjtg@mail.gmail.com>
Subject: Re: [PATCH v2 17/18] iomap: pass iomap_next_fn directly instead of
 struct iomap_ops
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: brauner@kernel.org, hch@lst.de, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Dan Williams <djbw@kernel.org>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>, 
	"open list:FILESYSTEM DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>, 
	"open list:EROFS FILE SYSTEM" <linux-erofs@lists.ozlabs.org>, 
	"open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>, 
	"open list:F2FS FILE SYSTEM" <linux-f2fs-devel@lists.sourceforge.net>, 
	"open list:FUSE FILESYSTEM [CORE]" <fuse-devel@lists.linux.dev>, 
	"open list:GFS2 FILE SYSTEM" <gfs2@lists.linux.dev>, "open list:NTFS3 FILESYSTEM" <ntfs3@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 9:58=E2=80=AFAM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index 3f0932e46fd6..0aa8abc438c1 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -626,7 +626,7 @@ static int iomap_read_folio_iter(struct iomap_iter =
*iter,
> >       return 0;
> >  }
> >
> > -void iomap_read_folio(const struct iomap_ops *ops,
> > +void iomap_read_folio(iomap_next_fn iomap_next,
>
> If you took my earlier suggestion to rename the typedef to
> iomap_iter_fn, then this parameter ought to be named iter_fn.

Hmm... maybe at that point, it's self-explanatory enough that the arg
could just be called "iter" instead of "iter_fn"?

>
> >               struct iomap_read_folio_ctx *ctx, void *private)
> >  {
> >       struct folio *folio =3D ctx->cur_folio;
> > @@ -650,7 +650,7 @@ void iomap_read_folio(const struct iomap_ops *ops,
> >               fsverity_readahead(ctx->vi, folio->index,
> >                                  folio_nr_pages(folio));
> >
> > -     while ((ret =3D iomap_iter(&iter, ops)) > 0) {
> > +     while ((ret =3D iomap_iter(&iter, iomap_next)) > 0) {
> >               iter.status =3D iomap_read_folio_iter(&iter, ctx,
> >                               &bytes_submitted);
> >               iomap_read_submit(&iter, ctx);
> > @@ -688,22 +688,22 @@ static int iomap_readahead_iter(struct iomap_iter=
 *iter,
> >
> >  /**
> >   * iomap_readahead - Attempt to read pages from a file.
> > - * @ops: The operations vector for the filesystem.
> > + * @iomap_next: The iomap_next callback for the filesystem.
>
> "The iomap iteration function for the filesystem" ?
>
> Using the term "iomap_next" in the definition for iomap_next isn't that
> helpful.

Agreed, I'll replace this with your suggestion.

>
> >       return ret;
> > @@ -824,16 +824,16 @@ xfs_file_dio_write_atomic(
> >       unsigned int            iolock =3D XFS_IOLOCK_SHARED;
> >       ssize_t                 ret, ocount =3D iov_iter_count(from);
> >       unsigned int            dio_flags =3D 0;
> > -     const struct iomap_ops  *dops;
> > +     iomap_next_fn           dops;
> >
> >       /*
> >        * HW offload should be faster, so try that first if it is alread=
y
> >        * known that the write length is not too large.
> >        */
> >       if (ocount > xfs_inode_buftarg(ip)->bt_awu_max)
> > -             dops =3D &xfs_atomic_write_cow_iomap_ops;
> > +             dops =3D xfs_atomic_write_cow_iomap_next;
> >       else
> > -             dops =3D &xfs_direct_write_iomap_ops;
> > +             dops =3D xfs_direct_write_iomap_next;
>
> Probably ought to be called iter_fn, or at least something that isn't
> "dops".

Nice spotting, I'll rename this in the next version.

Thanks,
Joanne
