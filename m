Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063363B5318
	for <linux-xfs@vger.kernel.org>; Fri, 29 May 2026 10:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780050280; cv=pass; b=eybB0/+A5AnY1WWTe7eUqp7HAt/NyE91aBZyJ2CATdNGToCvYPkk4M5fAQZ2ADT+csgUp+pliGBcmF9YktmVscmweUmaAmV+7bIlC2xEj2PK7R0De/ud7M1E9WjjOp6Amf80iQkHZR1Q5DYXea9aA7Fn69mA9DbI8scSqXOmPTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780050280; c=relaxed/simple;
	bh=Sfd3Adi+tUI+S4DxrF1vcNGy8CCGFz3QMBAnVMp6htA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TnuWeZ7UQNg2pNajnp8C4JKVuwj3o9CGXJtAyHNpUMjZ83pg9Slz/vHuwwJUy3kH/o5HgaLNDSu1j477XxlC48SCfB3e1tc1sIO6c8j0bsSlbGM21tmsnit1tIKFxk+jerzz9gWViyu2fUvhyicdM5VSYy/aJx2IF5V4VxV+4xY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i9x0FVyw; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i9x0FVyw"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50e5bea4045so107384351cf.3
        for <linux-xfs@vger.kernel.org>; Fri, 29 May 2026 03:24:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780050278; cv=none;
        d=google.com; s=arc-20240605;
        b=c/BswsA1CaRbfEJAm9E/YmQLxSF5TiJ5R+Evl+AvOXHcKWNIRmIEUDEwuAS78O5fYW
         VFVgg9IB+nw0nAD8PLz6Z2uqhWXi8GkatrTxXa+tdm9eQMzetPM4SxMlI3CicJS7OK9Z
         nPV3j3I4IDN9FnPumiB8hFY8EIS4MkZSPDjXyux/h24AlaM8vUU0VV9piLrbs2kYd93Z
         8W0bH45UiWsAlr19s5GQL1xIPgu305sPTwbByDy5RIRLJe0psL5/KzLG2fxMPbOGczRH
         rjVngagBvBItVhU7puOvVplxh3FFFfGxIMC2OQs3SER7gMpyScvyPY0js7w2FirlNRM0
         lMcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HwfD+J2kx1n2f8ryQ5IZeBmApk9xDHEgGs5Hv6L+XY8=;
        fh=KYeE5w1EQn3b5CSyjx53KlCQ1+g3mNKx7mnNkR86ot8=;
        b=hN1N5mh2XrnoArcFtbKXok9TxWrhYQLtx/me1Xf+3fV1hLIS9ddSF3lfodCzyEWgFQ
         tz0Jm2FYUqmQLqlfumkDXCjY12l9ttarf5lZvRDnumsKbd1VA2XOsCXTvci+VJ5Akc2b
         taCbQvH9lN22RhdcNFKD73qoUPdNHWuygrN+vkudbu6IfjSS/cLQqpXtWuJUXNf15Kv0
         9SL1AbYItAh9f+aViGvosVL1kMGYId+pnLIc2meMctc8T/+XIqk4Pk7Nyq4fA8rPewa2
         QKnOn1638dXcnYLaPNBWj/y43X0o9qUTVdNPrPvijyKvrhvNHctK75kW8OYy8WhU5w20
         Lo0g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780050278; x=1780655078; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HwfD+J2kx1n2f8ryQ5IZeBmApk9xDHEgGs5Hv6L+XY8=;
        b=i9x0FVywOHOlSjvXvUsMbyMMAfGacOXAkCF71ktdTgYq/BKn8YhL6Gz8vIQGjXZRgK
         L4tujeQXa+TAT8nPpJYi9gy8AWVd7lBJQXeM84lvKAj5Gc3zuCMJIQC6IWvIlJCzmepl
         c9TZkBpiCmztbmhmKwo8InF9Ku8KEtkSUOJijKVjpU0+D+mdRY6Hqx9MmSyWcKj8xAbF
         zqopdu8g+Tp4+mQJokOaWYj2zHrJJ77YIzP6GP2cC9tlKpLt1KZQFNgx4xaLKlIVxcLE
         MMFXod68XfKEa3VUUVa593xpunpOQuwq3eyD2ev57gUW773LjJjWKdU/cK97hf2Se9xH
         1cIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780050278; x=1780655078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HwfD+J2kx1n2f8ryQ5IZeBmApk9xDHEgGs5Hv6L+XY8=;
        b=YJOhaDZOAcaTRhD0LWpCPK98cQPy2Q6mDANDcWi5N2JHsOj9E4kr9WPDhuevpcPITm
         1roWSfl8LMb8YEW75m7h1NWhSo4bPO6iWjyUYT5bzxlqyqso46RSybHW+NjFFJaVb9ZD
         gxFt6hZ1SStY26EL04IobBcK8F5qeOfKpQqazN+c6eBuF2C3Ga8N53+LwmnXHmUBOHA6
         P3DMCM5wQKDAV7Xfi9m1IaIKISeNH1wZN4bpOzgc8eG8ibyHlA+OQpxtd5NUwWgLIZpT
         x5b2doOXUm/2OcE7VWzrZUa72ZC2yVYl279KsCr2bXKR4/e+/MIovEziN/IHFnVYeLnT
         oJKA==
X-Forwarded-Encrypted: i=1; AFNElJ95JxlhzXMuqknLNjuT+UaeT7kbXfc0SjKdpZBbRu0f9wMu92EJi2faY9BciI90lxRVf7i7ErC1eFc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzsar/ujCeKWFLZBjPpqnj1QrI41fn4HsY9gi7c5WllIS5svXYs
	Qh/yxKOTe84llsBe4o57MsUjSsOe/xtQXxEeFreXjIuHUq3cX9Za49ByWHcStpeF0P5VkrSeOW4
	mmZCclaIBN31rJvfUNozLaroSp5siSaE=
X-Gm-Gg: Acq92OHnJy1Oa1nScmvmDrb3BNicuy3ZMWOMkoGNSSCUBwZaQBqtJYOswHV0WJeXVw9
	iHsFiuGPIS3LM5Eys1u3YDHumm7xjFyfiyatFjC1OSJ96OJCrMWW30mQ0jeX13cROtU09UzgHtE
	TK651QMy3jK74sewLOpgRjq8LMlywRvK02NVLBb8YEIPOJ2znjHUc9Kqx6/V3+IA3iwGL+lwRjm
	ka5KPAJiC5HtqVstCm2NpGjxH4LjAhU3+F76fCfLiai7EyMFtBYKdYP64YI1aJWFvCMnk1QFJcf
	NKXxARlgRnraGy/pImM=
X-Received: by 2002:a05:622a:5786:b0:516:ddc3:6248 with SMTP id
 d75a77b69052e-5172dd201e9mr25384481cf.29.1780050277759; Fri, 29 May 2026
 03:24:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEkJfYPhWdd59RKmuNLJg-bkypHz7xiOwaWyNVu3A8CUqQCnvg@mail.gmail.com>
 <ahPhcZvPD4S20UJf@infradead.org> <CAEkJfYP5YhcwVik31Mv3iouLG2wDksb4fEbu4TSU0TAYN25w6A@mail.gmail.com>
 <CAJnrk1a=ivLcEHBOJ8Nzodb52zJ_B2X4yV16hwv_Sio84y8y1g@mail.gmail.com>
In-Reply-To: <CAJnrk1a=ivLcEHBOJ8Nzodb52zJ_B2X4yV16hwv_Sio84y8y1g@mail.gmail.com>
From: Sam Sun <samsun1006219@gmail.com>
Date: Fri, 29 May 2026 18:24:26 +0800
X-Gm-Features: AVHnY4JGm6pyY-37gGgdR-OuOkcaLG39fTSUe50PM8OnUJ5tg0TieREHbyHHcVw
Message-ID: <CAEkJfYMtEVcpNeH1SbvqUDB9KKKqhq0tX+t64uOW6dqCjqFKwA@mail.gmail.com>
Subject: Re: [BUG] iomap: NULL dereference in iomap_finish_folio_read after
 deferred failed read
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, brauner@kernel.org, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 27, 2026 at 12:13=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
>
> On Tue, May 26, 2026 at 8:25=E2=80=AFPM Sam Sun <samsun1006219@gmail.com>=
 wrote:
> >
> > On Mon, May 25, 2026 at 1:43=E2=80=AFPM Christoph Hellwig <hch@infradea=
d.org> wrote:
> > >
> > > On Sat, May 23, 2026 at 06:58:46PM +0800, Sam Sun wrote:
> > > > Dear developers and maintainers,
> > > >
> > > > We encountered a NULL pointer dereference in the deferred buffered
> > > > read failure path. Unfortunately, no reproducer is available yet.
> > >
> > > [snip]
> > >
> > > > We analyzed the cause of this report. It seems that failed buffered
> > > > read bios are deferred to a global work item "failed_read_work". Th=
e
> > > > deferred worker still owns the bio/folio, but by the time it calls
> > > > `iomap_finish_folio_read()`, the folio may have been truncated,
> > > > invalidated, or otherwise detached from its mapping. In that case,
> > > > `folio->mapping` is NULL, but the error reporting path unconditiona=
lly
> > > > dereferences `folio->mapping->host`. This pattern still exists on t=
he
> > > > latest kernel commit.
> > > >
> > > > A possible fix could be avoiding the `folio->mapping->host`
> > >
> > > The folio is locked until the folio_end_read() call.  So I don't see
> > > what could legitimately clear folio->mapping here.  Curiously waiting
> > > for the reproducer to see waht is going wrong here.
> > >
> >
> > I have more data now. I agree that the folio is supposed to stay locked
> > until `folio_end_read()`, but that does not fully protect this path. Th=
e
> > problematic window is a non-final read completion, after
> > `ifs->read_bytes_pending` has been decremented and before the error rep=
orting
> > path dereferences `folio->mapping->host`. The relevant code is still
> > present in v7.1-rc5.
> >
> > The race I observed is:
> >
> > 1. A failed buffered read completion reaches `iomap_finish_folio_read()=
`.
> > 2. It decrements `ifs->read_bytes_pending`, but `finished` is false
> > (`pending_after=3D2048` in the logs below), so this completion is not t=
he one
> > that unlocks the folio.
> > 3. If the worker is delayed/preempted before the `fserror_report_io()` =
call,
> > another completion can finish the remaining bytes and unlock the folio.
> > 4. Userspace then truncates the XFS file. The truncate path removes the=
 folio
> > from the page cache and clears `folio->mapping` in
> > `delete_from_page_cache_batch()`.
> > 5. The delayed worker resumes and dereferences `folio->mapping->host`.
>
> Does it not suffice to just call fserror_report_io() before
> decrementing ifs->read_bytes_pending? eg
>
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index d7b648421a70..d55b936e6986 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -400,6 +400,11 @@ void iomap_finish_folio_read(struct folio *folio,
> size_t off, size_t len,
>         bool uptodate =3D !error;
>         bool finished =3D true;
>
> +       if (error)
> +               fserror_report_io(folio->mapping->host, FSERR_BUFFERED_RE=
AD,
> +                                 folio_pos(folio) + off, len, error,
> +                                 GFP_ATOMIC);
> +
>         if (ifs) {
>                 unsigned long flags;
>
> @@ -411,11 +416,6 @@ void iomap_finish_folio_read(struct folio *folio,
> size_t off, size_t len,
>                 spin_unlock_irqrestore(&ifs->state_lock, flags);
>         }
>
> -       if (error)
> -               fserror_report_io(folio->mapping->host, FSERR_BUFFERED_RE=
AD,
> -                                 folio_pos(folio) + off, len, error,
> -                                 GFP_ATOMIC);
> -
>         if (finished)
>                 folio_end_read(folio, uptodate);
>
>
> With read_bytes_pending still > 0, it's guaranteed that the folio is
> locked and truncate can't invalidate folio->mapping yet as it requires
> the folio lock.
>
> Thanks,
> Joanne
>

Yes, that makes sense. For the race I observed, moving
fserror_report_io() before the read_bytes_pending decrement should
keep the failing completion's range counted while folio->mapping->host
is used.  That means another completion should not be able to make
read_bytes_pending reach zero and unlock the folio before the error
report runs, so truncate/invalidation should not be able to clear
folio->mapping in that window.

So this looks like it addresses the interleaving I reproduced.  Thanks
for pointing this out.

Best,
Yue

> >
> > In other words, the truncate path clears the mapping after the folio
> > has legitimately
> > been unlocked by another, final read completion. The unsafe part is tha=
t the
> > non-final failed completion uses `folio->mapping->host` without holding=
 a lock
> > or reference that keeps `folio->mapping` stable.
> >
> > One possible interleaving is:
> >
> > ```
> > CPU0: failed_read_work CPU1: another read completion CPU2: userspace tr=
uncate
> > -------------------------------------
> > ---------------------------------- --------------------------------
> >
> > iomap_finish_folio_read(folio, err)
> >
> > lock(ifs->state_lock)
> > ifs->read_bytes_pending -=3D len
> > finished =3D false
> > unlock(ifs->state_lock)
> >
> > if (error)
> >   /* about to execute:
> >   * fserror_report_io(folio->mapping->host, ...)
> >   */
> > <preempted here>
> >                                       iomap_finish_folio_read(folio, 0)
> >
> >                                       lock(ifs->state_lock)
> >                                       ifs->read_bytes_pending -=3D len
> >                                       finished =3D true
> >                                       unlock(ifs->state_lock)
> >
> >                                       folio_end_read(folio, true)
> >
> >
> >           open(..., O_TRUNC)
> >
> >             do_truncate()
> >
> >               truncate_setsize()
> >
> >                 truncate_inode_pages()
> >
> >
> >           lock_folio(folio)
> >
> >           delete_from_page_cache_batch()
> >
> >             folio->mapping =3D NULL
> >
> >           unlock_folio(folio)
> >
> > <resumed>
> >   fserror_report_io(folio->mapping->host, ...)
> >                               ^^^^^^^^^^^^^^
> >                               NULL now
> > ```
> >
> > To validate the race on v7.1-rc5, I used a diagnostic build that is
> > equivalent to
> > placing a breakpoint immediately before the original dereference.
> > The diagnostic patch:
> >
> > - logs non-final failed completions and records the folio/mapping being=
 used by
> > the error path;
> > - logs immediately before the existing `folio->mapping =3D NULL` assign=
ments in
> > `page_cache_delete()` and `delete_from_page_cache_batch()`;
> > - defers only the non-final `fserror_report_io(folio->mapping->host, ..=
.)` by
> > one second so the truncate race has time to run.
> >
> > With the syz corpus on v7.1-rc5 plus the diagnostic breakpoint:
> >
> > ```text
> > [ 116.142333] d280-iomap-latest: deferred non-final fserror
> > folio=3Dffd40000013ea940 mapping=3Dff1100004560b6b8 pending_after=3D204=
8
> > comm=3Dkworker/0:7
> > [ 116.177780] d280-filemap-latest: delete_from_page_cache_batch
> > clearing watched folio=3Dffd40000013ea940 mapping=3Dff1100004560b6b8
> > host=3Dff1100004560b4a0 ino=3D9286 index=3D0 locked=3D1 ref=3D4 comm=3D=
syz.5.30
> > [ 117.330579] d280-iomap-latest: deferred fserror
> > folio=3Dffd40000013ea940 mapping=3D0000000000000000 host=3D000000000000=
0000
> > index=3D0 pos=3D0 off=3D0 len=3D2048 locked=3D0 ref=3D1 comm=3Dkworker/=
0:9
> > [ 117.336816] Oops: general protection fault, probably for
> > non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> > [ 117.337746] KASAN: null-ptr-deref in range
> > [0x0000000000000000-0x0000000000000007]
> > [ 117.339635] Workqueue: events d280_deferred_report_work
> > ```
> >
> > The detach is done by the normal truncate path:
> >
> > ```text
> > delete_from_page_cache_batch()
> > truncate_inode_pages_range()
> > truncate_pagecache()
> > xfs_vn_setattr_size()
> > xfs_vn_setattr()
> > notify_change()
> > do_truncate()
> > path_openat()
> > do_file_open()
> > __x64_sys_open()
> > ```
> >
