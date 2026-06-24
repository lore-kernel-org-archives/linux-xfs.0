Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21D8298CA3
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 18:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782325702; cv=pass; b=W5ZwGHB11A8U+uITJmTyvuUNvks6UNi0Ax1aH+nwm7Awmv3Yp7G5apsmITBn4GC4e24lET65vLVZJnwiExccqVQm/4q67kKQ52s4+QyMqyZgrMkr5qaDfCGf8rliPNpiQdEy5QSzmAutzabNcJmBTVB7EZC+R/sZ2EOPrge6hko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782325702; c=relaxed/simple;
	bh=ZHOzVFCql8SaWut+IOlvnrIFNrVwMcDBKu12a7/J8Ng=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LOub/rpagdnqeuWn77NmQw+LGv6aOxnaGbl++8z6jJQxuPA2NMsTFyWhoJJE86104ChxJNQV8NdG+JvbGzh2qR1HqT0Qq13kSk3b2Y0isChM0Oejkx41ZYnSKP/GBLQZJcq/g1TK64RFA3OLx9TjV2uC73IrhAWFOQpK6wVfpBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BOWR2Txx; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BOWR2Txx"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-697bd41a4ecso388724a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 11:28:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782325699; cv=none;
        d=google.com; s=arc-20240605;
        b=HXUG10hP9A/PYRDNl5LAROY2X2dbpdT4zCoqgNF6FTfA3sTOmcB3fjDcIu3/GkSrxO
         RKULggrgmWPU86Zt4Jaf78CWyVDFzX0WEG4s2HP1tcQMxp/qpafaXA69oChaYnkp0giQ
         7GwEnUrIlrR1Wuwq7+7ceoKNbf0VghEQ5VUaa7wxXoEh77CDGXAOqbdmkKTAdhx8A/yt
         PODeFkef4utXuINRfMI64qSF9n9NRVtpwnZ4ECQJBLkp8hKA8U7mqwKmT5MAWZny/8Or
         PPMmYDnYrpAT0oS2es3nSMsHeXxcFQrGVovDerDYGS5Ql2A+c6Hc41n3J7pBou0a2uSA
         BFpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IhfrBCPx2bo22XbBVjSJaZbGXPjegiCJPC5ME9qZ9Uw=;
        fh=gT4J41+Y9ysi2CVWmfUA33J/PxyRg+rbhiQ/UFifeBI=;
        b=kXYDk3Cp+kkF4czda01RrqpgISd3vru21hBNEoHl/I2A3zKnxnqeKUZe4nwMxMyuIG
         JuP3Cr+BaDx9FvVmh3G+KXB5XSm0Lk7KZal/XoGLgTp1LR8s2NzvEGp8RGgVtd2ywDRR
         aeElTRNv1sQkP6GLKVqZrt6cKZWelfh5wpNO9wivLDeJmaqN8o5C6OOhOWJ5wJPIv+ls
         Y+CNLXMK6AQlIY6thbPbLnZjBv1U+ThKSyZQtlHNeF0McQE/0D0w+9k8UKMH4mNNAQWo
         /OzwrEc9aADhQU5LHHRLvR2w4mM3cS9A9/XO5UU2ROGpg0bsgqqrJTw3sxQTh3tklXS9
         3V3A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782325699; x=1782930499; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IhfrBCPx2bo22XbBVjSJaZbGXPjegiCJPC5ME9qZ9Uw=;
        b=BOWR2TxxI9gekAIE/JSJhwyvs2CRku3EQtGL67aVLw9TCk7qpuv9Q1MFEu08WdroNd
         d3lsLN03hWdyltB3/MYfHiRk7NCI8EjfH2Z9c0H7fg8FziMv2lL3UDp6CCy8KyTQ408A
         Z89WgexGY/QXjF4YEg0SVWA7UY3UxaQoWyRpyP4IJgW8BuRFWjXCkOzniv2taJv7X4RZ
         /hDkgUKtZv+gJL30KoIhZVCWcd3x38VLI6aOb1pdjaDRJyjjB0e7AXtgYF9a/ccxiy2Z
         lHZ9pap/fKAXDEiDh3F9JvWynV0/BKMJD8ZDaeEuVBC07OUtsnamp7EwXfUTcCoSB0uP
         L7lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782325699; x=1782930499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IhfrBCPx2bo22XbBVjSJaZbGXPjegiCJPC5ME9qZ9Uw=;
        b=tAgBh0ZiHxWh+4teJnYMTD4R3kLHva7Htn4NjAGdwJJU5ov3x70o783jn9QoAU8ajv
         gwIMYKPMBfvZJacKEjM0wyw1cu15tP7w5zKWD2C6TO9VQXNLddMnPt0cYxIwAJdIKlfa
         FpA6EeisYtCprLcsJf0j/+zTfJ1HM+I2cLq3937+ie4ZMr2YqghhcaYlKMCyyOemUu0e
         2FQQByw+zboRETX8u7V9Dlzk/TbLWhGHkLldsXAtIHuvwl43Lb6m49eyJQKyFo+0aROq
         5XL344PL2Pc7l60flurl2VUi2hlKvUg1aVaEON5L5rhgCGy3b0ONqZe3PMHnVaZ0ZPdZ
         bKVg==
X-Forwarded-Encrypted: i=1; AHgh+RphKvM7ZDvf7RhLidC1JH7nP7RJUdfW9Ve7q5jFQ5XojLCIUQV+Mxnev4bdBc5SQ60GGYgJFjkTA5A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrpIbgxq/kckdxAn6mxJF0HzvU9qSX5t/0CAeE1bPyH6tEkprT
	pe8VgDwP5Lw43DZB7XqmJr/XC7mr7QabKsigv3LKagHDNthFXAlBw9UA5FTXUJiADBTTQara03W
	Lj+RYq16FX59eyxh/qQ0nh08VrkxTC0U=
X-Gm-Gg: AfdE7cna1PlPs/hbHdSZrAYf3WDrZpZZQOJ55t4iZKKxYdvCSxj2exHqvzLUb4UzWk8
	jfTpmg16Dhhl/DKCZR2IYIjvCmkl7ZFE1d5zkKSWy1ueqkpIO+5Uo/rg9dSs4B7+hgJSswMTlTz
	h/o6VkcSAjcxv5n/0UuApnOWHD+by2Z2MeeXtootWLPMrSzvk0h5hEOIBCaYbs95eon8mvgM1ou
	YR2QKVMHWdlEVqBVU3iQw5w0Y4CGkP6jF2NMRA38BgKDCE8rlQJXXTmqAjauANzlkNI73NQQJfd
	KC9hTmxqQl5+XPx+SaczbWDkZztB1s1ff20NBqjYfg==
X-Received: by 2002:a17:907:6092:b0:c0e:5863:c43a with SMTP id
 a640c23a62f3a-c119f31a3abmr262416866b.52.1782325698917; Wed, 24 Jun 2026
 11:28:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260616053850.2188-1-aditya.ansh182@gmail.com>
 <20260616053850.2188-3-aditya.ansh182@gmail.com> <20260624173531.GQ6078@frogsfrogsfrogs>
In-Reply-To: <20260624173531.GQ6078@frogsfrogsfrogs>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Wed, 24 Jun 2026 23:58:07 +0530
X-Gm-Features: AVVi8CcNiBkpPROb-Qwk2ugzdpjDhvIo4ukRzNgmcKq8r-O7ZLvrtK_1tNU3dGQ
Message-ID: <CAK5ssPP6FL+6i8z+0QdE-9DSp0rC_U2S20qdxY7Kmdp7RS0xRw@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] xfs: prevent close() from hanging on frozen filesystems
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Darrick,

Thanks for the feedback and review! I hope you had a great
vacation.

I looked closely at wrapping the block inside xfs_file_release()
with sb_start_write_trylock(), but I believe sticking with the
transaction flag approach is much more robust for a few reasons:

Lock Ordering Safety & Lockdep:
In XFS, the canonical locking hierarchy is:

sb_start_write (freeze lock) -> IOLOCK -> ILOCK ->
xfs_trans_alloc

xfs_file_release() already holds XFS_IOLOCK_EXCL (acquired via
xfs_ilock_nowait()). Attempting to acquire
sb_start_write_trylock() inside that block would mean acquiring
the freeze lock while holding the IOLOCK. Even though a trylock
itself does not block, this is a direct inversion of the
canonical locking hierarchy and is highly likely to trigger
lockdep dependency warnings.

Keeping the check inside xfs_trans_alloc() relies on
well-defined, centralized write-count evaluation, avoiding any
lockdep headaches.

Encapsulation and Readability:
Open-coding the freeze trylock at the VFS release boundary makes
xfs_file_release() quite fragile and harder to reason about
over time. The resulting nested conditional block is prone to
subtle bugs during future refactoring of the file release and
blockgc paths.

Architectural Consistency:
xfs_trans_alloc() is the canonical, centralized place in XFS to
manage write-count blocking semantics. The
XFS_TRANS_WRITECOUNT_TRYLOCK flag provides an explicit, clean
interface to tell the transaction layer exactly how to handle a
freeze, rather than bypassing it at a higher layer.

Given that this keeps the VFS/XFS interface clean and Christoph has
already reviewed/endorsed this version, I'd prefer to move forward
with the current iteration unless there is a strict functional
downside you see to the flag approach.

Thanks again for the review and guidance!

Best regards,
Aditya

On Wed, Jun 24, 2026 at 11:05=E2=80=AFPM Darrick J. Wong <djwong@kernel.org=
> wrote:
>
> On Tue, Jun 16, 2026 at 05:38:50AM +0000, Aditya Srivastava wrote:
> > From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> >
> > When a file with active speculative post-EOF preallocations is closed,
> > xfs_file_release() synchronously triggers xfs_free_eofblocks() to clean
> > them up. This requires allocating a write transaction (xfs_trans_alloc)=
,
> > which blocks indefinitely if the filesystem is currently frozen or in t=
he
> > process of freezing, as it waits to acquire the superblock's write lock=
.
> >
> > As a result, a close() system call on a read-write file descriptor can
> > hang indefinitely in percpu_rwsem_wait() until the filesystem is thawed=
,
> > even if the file is closed by a non-writer process or after all writing
> > activity has already ceased.
> >
> > To fix this properly and avoid any potential race conditions where a fr=
eeze
> > might come in immediately after a writable check, pass the new
> > XFS_TRANS_WRITECOUNT_TRYLOCK flag to xfs_trans_alloc() when freeing
> > speculative preallocations in xfs_file_release().
> >
> > If xfs_free_eofblocks() returns -EAGAIN on a trylock failure, we cleanl=
y
> > bypass setting XFS_EOFBLOCKS_RELEASED on the inode, ensuring subsequent
> > releases or the background blockgc garbage collector can successfully r=
etry
> > the cleanup once the filesystem thaws.
> >
> > Also, add the new trans_flags parameter to xfs_free_eofblocks() to make
> > its usage stand out, and update existing callers to pass 0 to preserve
> > standard blocking paths.
> >
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D205833
> > Link: https://bugzilla.redhat.com/show_bug.cgi?id=3D1474726
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> > ---
> >  fs/xfs/xfs_bmap_util.c | 10 ++++++----
> >  fs/xfs/xfs_bmap_util.h |  2 +-
> >  fs/xfs/xfs_file.c      |  8 +++++---
> >  fs/xfs/xfs_icache.c    |  2 +-
> >  fs/xfs/xfs_inode.c     |  2 +-
> >  5 files changed, 14 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 0ab00615f1ad..a99aae4a1631 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -574,7 +574,8 @@ xfs_can_free_eofblocks(
> >   */
> >  int
> >  xfs_free_eofblocks(
> > -     struct xfs_inode        *ip)
> > +     struct xfs_inode        *ip,
> > +     uint                    trans_flags)
> >  {
> >       struct xfs_trans        *tp;
> >       struct xfs_mount        *mp =3D ip->i_mount;
> > @@ -604,9 +605,10 @@ xfs_free_eofblocks(
> >               return 0;
> >       }
> >
> > -     error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, =
&tp);
> > +     error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0,
> > +                             trans_flags, &tp);
> >       if (error) {
> > -             ASSERT(xfs_is_shutdown(mp));
> > +             ASSERT(error =3D=3D -EAGAIN || xfs_is_shutdown(mp));
> >               return error;
> >       }
> >
> > @@ -928,7 +930,7 @@ xfs_prepare_shift(
> >        * into the accessible region of the file.
> >        */
> >       if (xfs_can_free_eofblocks(ip)) {
> > -             error =3D xfs_free_eofblocks(ip);
> > +             error =3D xfs_free_eofblocks(ip, 0);
> >               if (error)
> >                       return error;
> >       }
> > diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> > index c477b3361630..c13774aa0892 100644
> > --- a/fs/xfs/xfs_bmap_util.h
> > +++ b/fs/xfs/xfs_bmap_util.h
> > @@ -66,7 +66,7 @@ int xfs_insert_file_space(struct xfs_inode *, xfs_off=
_t offset,
> >
> >  /* EOF block manipulation functions */
> >  bool xfs_can_free_eofblocks(struct xfs_inode *ip);
> > -int  xfs_free_eofblocks(struct xfs_inode *ip);
> > +int  xfs_free_eofblocks(struct xfs_inode *ip, uint trans_flags);
> >
> >  int  xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
> >                        struct xfs_swapext *sx);
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 845a97c9b063..76c9b2fe7c51 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1806,9 +1806,11 @@ xfs_file_release(
> >        */
> >       if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
> >           xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> > -             if (xfs_can_free_eofblocks(ip) &&
> > -                 !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
> > -                     xfs_free_eofblocks(ip);
> > +             if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
> > +                 xfs_can_free_eofblocks(ip) &&
> > +                 !xfs_free_eofblocks(ip, XFS_TRANS_WRITECOUNT_TRYLOCK)=
)
> > +                     xfs_iflags_set(ip, XFS_EOFBLOCKS_RELEASED);
>
> Could you prevent the close() stalls by surrounding this with
> sb_start_write_trylock instead of passing transaction allocation flags
> all the way down?
>
> OFC that results in a messy if test:
>
>                 if (xfs_can_free_eofblocks(...) &&
>                     !xfs_iflags_test(...RELEASED) &&
>                     !sb_start_write_trylock(...)) {
>                         if (!xfs_iflags_test_and_set(...))
>                                 xfs_free_eofblocks(ip);
>                         sb_end_write(...);
>                 }
>
> <shrug> Sorry if this is noise, I've been on vacation.
>
> --D
>
> > +
> >               xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> >       }
> >
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 2040a9292ee6..c575b4acb24c 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -1259,7 +1259,7 @@ xfs_inode_free_eofblocks(
> >       *lockflags |=3D XFS_IOLOCK_EXCL;
> >
> >       if (xfs_can_free_eofblocks(ip))
> > -             return xfs_free_eofblocks(ip);
> > +             return xfs_free_eofblocks(ip, 0);
> >
> >       /* inode could be preallocated */
> >       trace_xfs_inode_free_eofblocks_invalid(ip);
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index ddf2707c8894..14d3cd04a79f 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1423,7 +1423,7 @@ xfs_inactive(
> >                * reference to the inode at this point anyways.
> >                */
> >               if (xfs_can_free_eofblocks(ip))
> > -                     error =3D xfs_free_eofblocks(ip);
> > +                     error =3D xfs_free_eofblocks(ip, 0);
> >
> >               goto out;
> >       }
> > --
> > 2.47.3
> >
> >
