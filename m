Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C04F1F462F
	for <linux-xfs@vger.kernel.org>; Thu,  8 May 2025 16:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746722213; cv=none; b=k3sInHy1AaHWWy4PMWyIiyHyjz21a55NjgJLL/77z03g+IP4UWPSKlForDPf0Vp9u5vm+Sbwjk8lrtC1rNrAyUmu9QFESBKdbr9M8AjX+3Ct6ZFYsyZM/AQF/vUNsSZUm0V6Rov7F1W8NYPxBJ5/bQPrYDKT3ClL100MXjJUE34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746722213; c=relaxed/simple;
	bh=vBPrtrb/i0MtQtw8oGQa9CBASnmCKouOQ1Y8PpBfDrw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hz0GCGyaj2X6WUWJqUM5zkZQqpzOeEVffciclBVAcl9x4r/mjudrrQOciUYZu8TJWc6V43nl7bvXqV9uJb//qgdUq/MiReMaREQgj7O6y5FeWKsMYAOsZjaGlOjkoPye4Rw9SREBJNlj+OznbaT6wj72tn1HJgaLLP24ppKU/dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c2XZC3pp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c2XZC3pp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746722210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Sy8oyOH24J7YslH5esm45VGpXm0mpp5qY5ThOYlhhY=;
	b=c2XZC3ppaSyEu31+JPBYXg0Xwt3r0JjU5eyjv1q+sHUyEl9GsHxV0Woe00Vfc/k7UkAt7w
	0w4yYGMIKm+Ope1EGFuHCBnLd885+8To9eOHpP03rFlJ9xbCJTLr5hCGLseM+RObI3GlKI
	6/MegXlLaC4LRzX/lp5YvLKu6et83W8=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-oLy9rZbrMhiSI__E8gNUVw-1; Thu, 08 May 2025 12:36:49 -0400
X-MC-Unique: oLy9rZbrMhiSI__E8gNUVw-1
X-Mimecast-MFC-AGG-ID: oLy9rZbrMhiSI__E8gNUVw_1746722208
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-22fc0e42606so4774505ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 08 May 2025 09:36:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746722207; x=1747327007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Sy8oyOH24J7YslH5esm45VGpXm0mpp5qY5ThOYlhhY=;
        b=BmcbhK7cBxNbwYRPPmbK+30nK+zjHcUxNM9+Pwtx4yYujy9ATzxuZNyyUrDkqZq1Ug
         kjmjSJWGMDOnwYrMXQuW/2iTDCxz4fEZLzNIzDTKr7WHVXbz10uyuDUBqBr5R3DSeWFZ
         ls3KqhHx92ju2bzwueu7qHvnI0d/7qJwpn/X2Wlmcx2n9vExR6oW0xihB9AXdVg8rgLR
         Gu2mtHUUOt8bvD8HtXVMwRW9V/neLjpNc9QGTfxxn8LIW4As2+XzihFrNO8lQ6QKsL0D
         uChoK/4der+/CFXyNq9ywM+Rhi7o3lVvJ3W60hoK6XCSfkb8fN0fzSG+IfFnb7Ryc6xy
         vpOw==
X-Forwarded-Encrypted: i=1; AJvYcCXgBi2nCeopeZTXXgRKrpIhVLs0smISQnRB6R3JUNQBWMW9exPnhTQwJH8VkB6O2OoA/vj3X6DJP3g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf5ZjqVjGaEPk0OmaQLQG9lS+6GQ8GSnGrGFdI8Nua0ylmIFse
	KMpYzLezsTWnUK+rNDf0CawRov32hqyTbKxW6H2OXb4MCiHJtJ6gzuXLPzJw7HuWRgd3MYrIeMG
	MnHAZbt1+TrCWO2AhBm/oTGof8qlnQMlWnFVgXAAHvl8+7wDIvV3GUFnvr/em7M7hQjGxmNO1Nt
	3qHahZHPKgNJ6mYTrSdaPFzI0BzYavuyfA
X-Gm-Gg: ASbGncsrCuMkyGu0eNVThY95Lq7bqL+8lpRh36NAY5wM2zB3G3LDyHgEub6qEzmonb0
	9K4eGQ8o4GQKRxT0deGnXfe1gNL2oEe1V6pD8Bi7KpaiJ8XUPrAGup7YVWGvuqNIJ1pM=
X-Received: by 2002:a17:902:dacc:b0:22f:9f6a:7cf with SMTP id d9443c01a7336-22f9f6a087bmr52375515ad.52.1746722207630;
        Thu, 08 May 2025 09:36:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFOga95s4ugQHj2BrxOHrDPH4klkqUXdLSEjSZLSKS48ak5d9Jaa4piV3knillJ1R9IKfWAzRuA2EVkK9NE5C8=
X-Received: by 2002:a17:902:dacc:b0:22f:9f6a:7cf with SMTP id
 d9443c01a7336-22f9f6a087bmr52375275ad.52.1746722207305; Thu, 08 May 2025
 09:36:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250508133427.3799322-1-agruenba@redhat.com> <aBzABse9b6vF_LTv@bfoster>
 <20250508150446.GB2701446@frogsfrogsfrogs> <aBzLib4tHj351di2@bfoster> <20250508160422.GN1035866@frogsfrogsfrogs>
In-Reply-To: <20250508160422.GN1035866@frogsfrogsfrogs>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 8 May 2025 18:36:35 +0200
X-Gm-Features: ATxdqUHFh-_FLdJ7RDDp4s_hWnEIEGLd8h624_PYGb02H_L-J16CwkuiDKzTbJo
Message-ID: <CAHc6FU5YSR6w3Hh2ZeAiLeAbuz9kpZVg9UfrHQECicnMzGc4Mg@mail.gmail.com>
Subject: Re: [RFC] gfs2: Do not call iomap_zero_range beyond eof
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 8, 2025 at 6:04=E2=80=AFPM Darrick J. Wong <djwong@kernel.org> =
wrote:
> On Thu, May 08, 2025 at 11:19:37AM -0400, Brian Foster wrote:
> > On Thu, May 08, 2025 at 08:04:46AM -0700, Darrick J. Wong wrote:
> > > On Thu, May 08, 2025 at 10:30:30AM -0400, Brian Foster wrote:
> > > > On Thu, May 08, 2025 at 03:34:27PM +0200, Andreas Gruenbacher wrote=
:
> > > > > Since commit eb65540aa9fc ("iomap: warn on zero range of a post-e=
of
> > > > > folio"), iomap_zero_range() warns when asked to zero a folio beyo=
nd eof.
> > > > > The warning triggers on the following code path:
> > >
> > > Which warning?  This one?
> > >
> > >     /* warn about zeroing folios beyond eof that won't write back */
> > >     WARN_ON_ONCE(folio_pos(folio) > iter->inode->i_size);
> > >
> > > If so, then why are there folios that start entirely beyond EOF?
> > >
> >
> > Yeah.. this gfs2 instance is simply a case of their punch hole mechanis=
m
> > does unconditional partial folio zeroing via iomap zero range, so if a
> > punch hole occurs on some unaligned range of post-eof blocks, it will
> > basically create and perform zeroing of post-eof folios. IIUC the cavea=
t
> > here is that these blocks are all zeroed on alloc (unwritten extents ar=
e
> > apparently not a thing in gfs2), so the punch time zeroing and warning
> > are spurious. Andreas can correct me if I have any of that wrong.

gfs2 uses ext2-style indirect blocks. It doesn't have extents, delayed
allocation, or any kind of unwritten data tracking.

> Oh, right, because iomap_zero_iter calls iomap_write_begin, which
> allocates a new folio completely beyond EOF, and then we see that new
> folio and WARN about it before scribbling on the folio and dirtying it.
> Correct?

Yes, or at least that's also my understanding.

> If so then yeah, it doesn't seem useful to do that... unless the file
> size immediately gets extended such that at least one byte of the dirty
> folio is within EOF.  Even then, that seems like a stretch...

i_size isn't going to change in a punch hole operation:

int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
{
        [...]
        switch (mode & FALLOC_FL_MODE_MASK) {
        [...]
        case FALLOC_FL_PUNCH_HOLE:
                if (!(mode & FALLOC_FL_KEEP_SIZE))
                        return -EOPNOTSUPP;

> > > > >   gfs2_fallocate(FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE)
> > > > >     __gfs2_punch_hole()
> > > > >       gfs2_block_zero_range()
> > > > >         iomap_zero_range()
> > > > >
> > > > > So far, gfs2 is just zeroing out partial pages at the beginning a=
nd end
> > > > > of the range, whether beyond eof or not.  The data beyond eof is =
already
> > > > > expected to be all zeroes, though.  Truncate the range passed to
> > > > > iomap_zero_range().
> > > > >
> > > > > As an alternative approach, we could also implicitly truncate the=
 range
> > > > > inside iomap_zero_range() instead of issuing a warning.  Any thou=
ghts?
> > > > >
> > > >
> > > > Thanks Andreas. The more I think about this the more it seems like
> > > > lifting this logic into iomap is a reasonable compromise between ju=
st
> > > > dropping the warning and forcing individual filesystems to work aro=
und
> > > > it. The original intent of the warning was to have something to cat=
ch
> > > > subtle bad behavior since zero range did update i_size for so long.
> > > >
> > > > OTOH I think it's reasonable to argue that we shouldn't need to war=
n in
> > > > situations where we could just enforce correct behavior. Also, I be=
lieve
> > > > we introduced something similar to avoid post-eof weirdness wrt uns=
hare
> > > > range [1], so precedent exists.
> > > >
> > > > I'm interested if others have opinions on the iomap side.. (though =
as I
> > > > write this it looks like hch sits on the side of not tweaking iomap=
).
> > >
> > > IIRC XFS calls iomap_zero_range during file extending operations to z=
ero
> > > the tail of a folio that spans EOF, so you'd have to allow for that t=
oo.
> > >
> >
> > Yeah, good point. Perhaps we'd want to bail on a folio that starts
> > beyond EOF with this approach, similar to the warning logic.
>
> ...because I don't see much use in zeroing and dirtying a folio that
> starts well beyond EOF since iomap_writepage_handle_eof will ignore it
> and there are several gigantic comments in buffered-io.c about clamping
> to EOF.
>
> <shrug> But maybe I'm missing a usecase?

Unrelated to iomap_zero_range(), but gfs2 has this fairly scary
special case in which it does insist on writing folios beyond eof. See
gfs2_write_jdata_folio(); this was introduced and is described in
commit fd4c5748b8d3 ("gfs2: writeout truncated pages").

> --D
>
> > Brian
> >
> > > --D
> > >
> > > > Brian
> > > >
> > > > [1] a311a08a4237 ("iomap: constrain the file range passed to iomap_=
file_unshare")
> > > >
> > > > > Thanks,
> > > > > Andreas
> > > > >
> > > > > --
> > > > >
> > > > > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > > > >
> > > > > diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
> > > > > index b81984def58e..d9a4309cd414 100644
> > > > > --- a/fs/gfs2/bmap.c
> > > > > +++ b/fs/gfs2/bmap.c
> > > > > @@ -1301,6 +1301,10 @@ static int gfs2_block_zero_range(struct in=
ode *inode, loff_t from,
> > > > >                                  unsigned int length)
> > > > >  {
> > > > >         BUG_ON(current->journal_info);
> > > > > +       if (from > inode->i_size)
> > > > > +               return 0;
> > > > > +       if (from + length > inode->i_size)
> > > > > +               length =3D inode->i_size - from;
> > > > >         return iomap_zero_range(inode, from, length, NULL, &gfs2_=
iomap_ops,
> > > > >                         NULL);
> > > > >  }
> > > > >
> > > >
> > > >
> > >
> >
> >
>

Thanks,
Andreas

