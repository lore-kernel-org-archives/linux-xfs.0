Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1384C3033EB
	for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 04:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779855186; cv=pass; b=DYyv7CGJ9+NWDk3jYMRiorbBlpzhGq3UfAcrqv4ma/Btu03JChAvwnVeFINUEv8xYoQ66IgHGeqczKaVC8YkgfDrLrCRvGDagN8Kbd4Byh8Ngo7XdbF2XXsV5aMuhwn6RmVsJ1PFGG/MsmuZS53w5CfGeFQHe3Ksyni+vpefa9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779855186; c=relaxed/simple;
	bh=rK5qEgI+ayIosJ4JrzScRyJ0Tg6kjMJCfjufW1kWoMU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q2MXrtlegmXeCUi9gylKmXtvyMYlSjSKjCqfv0sjXBb/rZXTtsrh8IOoKtNFovuheTUAI6FPbX6ySIvd8R1WQRRwwGEKmN/954FXt90xC4bsYJdzGvT2LP8Bzf7F5BU15Ituk6p71a1XHIkdiFxKUNzp+NJQKEegmkiLAcu1io0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OYnRkW/2; arc=pass smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OYnRkW/2"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43d7645adbdso6947733f8f.1
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2026 21:13:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779855183; cv=none;
        d=google.com; s=arc-20240605;
        b=LghhkbpY/ISnjRV8qZr3w91sH04OKWlKOFWfgQOmHDb7AZw7RT4snyV9KQXyLhd7N9
         Z1eFuw9+CGOf2tTlw1Xk3rEWCzER4jlT70ptfldYkc0Z8otQV+0zIcquZeSRZFdmZHMH
         JVwgKqxr+4QHZbEQOwyuX7WcDT+G78aLPKnGVN4b1GpRcCD6KucJJUg+/11Cn33uaiwA
         s/kNI2+fp4c/RnpjxQ+YSo2Rhpn5BM10lUqxmPpEua+lYsDp9K0YL4iFvaiZ3uLXLEjz
         y9pKoWnG1mvpT6z/DdCzEpZkhV+z+K0fAUbLl50VmWN+zEfugRi+RoMLbX+MfssjUuHi
         Ghbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PQh95HH5EUt2hdoybPfMx/605ecf+e0yU2uPrQaxulU=;
        fh=GqCgDB2MjYQluocTbhwvQ1m+dfLOim3Fi9d9WsZuLdo=;
        b=GWSLgJzFbcNJa1CtMrIyodMFgj2KZjuk9xul57AsQPj3TRu3sM/GumWoxdoQ1H8H2y
         mDCGzqVAVspRj6uTJlCTzJLKGClzQF0fIqxPy1MX8jd5k+9aFWzatP5K/TogE4tKnMMx
         uJnxz2bAa71hwQW66aJCQHLgJWj9qlMMt+lPiD2SaNTbbzLyboGLR1Cjnez6vHIvlfh+
         8eifZX4kw6TQMdTmP/Bg4ZhWAaxnojQ3RBaxySaI5+rg0U2yfH8uWqZG/NqPQVYbZ5Q3
         Q5LjcPmk1z9X6iPycssifAMQfRIk148vU+C03LCkX8VoO969CF/7Gg+Aym/EfOP7GaD+
         zNXQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779855183; x=1780459983; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PQh95HH5EUt2hdoybPfMx/605ecf+e0yU2uPrQaxulU=;
        b=OYnRkW/2yYLjfdjk3eBV3GRRVV8IlKINksjc8wIE+6qz5cwgLoyq/Xpyti+Toj18y2
         0pZfJwqsdCD//IxaHQCBwtOuINX9lDR+ge09f6nPtmsFDhYPb+i+ETe6gVkQnMuGtiL/
         xICJNnLHnMjeTB6GGyw67i89EP9aQNDZQGcJ+JaTzKksFexT8hFFmzwagf1fNZjl24q3
         aFdhwLWFa3bXP8ihLW3lc0sL0ADLENgxuEPCeyh7MHb1ic33vyaINcrmXCNzJw/M+nDv
         nh7YmlSnoJC5GkGaocCPziu2n/vUnvmwFASNPdv24ojqIm3tgTfth+jOWdpq85LLVOla
         U11Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779855183; x=1780459983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PQh95HH5EUt2hdoybPfMx/605ecf+e0yU2uPrQaxulU=;
        b=A2L8RFu+pQl62LrUqUI3tvyddJcQXM1O2pcK/atV1BxJJToaog9/Y1WjT8HUoayecX
         +YGP5D2PJpO23mFSdOob+eRbuMcai78KhgoxCJKQnOdD4h6cWioy7hDJMyi2M1V0mHJk
         OT7yqss3f8bplNPe3xTq6EulZ6RjYKVUmOA+CALCzEghJ5qZYfALuAeunDWKMSIcsQ+x
         P6RC5SCxWOUBMKSBoU9oziZx9TCG5b1+FVa4gK8oUXmpTz6qAVcLFmCY1gclKBZ+T0mA
         90zqVdK9cmnqPMk31NtnShqhGr0xFwcZnXT9eSd1qarQoi6CHqVqiCV55TwFsnlL44qj
         2GxQ==
X-Forwarded-Encrypted: i=1; AFNElJ/MVDnfJy6tNASN2V+qwSXIdJ0ylFRv357qINuAVmJ9Sl7LGeQONWrMJG6qRopyFTDtY+9n+LSKxOk=@vger.kernel.org
X-Gm-Message-State: AOJu0YypUX5uUtVBQxFqr/oZB+0WYU1zmhFZcXkviofAgM8MXMnut6S3
	lRK8RkBGeDx2Qk7mnXQJ2504QAaNPzlDVyr6DttgtCMaxaKhcS4mITz2r1zgp/0++BIC5mvQs5A
	I3e5umsG2j4Jt7XlHjLMHQOi/Q1sbeaU=
X-Gm-Gg: Acq92OHe8l6exlDOyd7TvLqpcDF1AHCFmsiwW9N1QS9x9MpgaVnjzCCMkqbc8zU4ego
	A2gED14lzY3FworlGtU4DGlPegi/6lN32ZJR0zLKuzsZaHuenqaHZGx6EOw9KV2uAcSEquA9bAS
	k+iGNBJDbfIG5IOeSyaURQUk7GpoReYSLGICzmf1yCdnQ7mtMDL0FYrR3impKZTGmfEdBOBoyoL
	i4mnwDriDjceyaPPoSZcjqZfifDPjwXRx7cru+CVV/ARznBQr12v+9Z749BPcYdWytdHfh3wpy+
	acGF4KcOdEt/BtpEgjswqTefV5Xa2mK6Rg==
X-Received: by 2002:a5d:5d02:0:b0:43e:b0f8:66f1 with SMTP id
 ffacd0b85a97d-45eb3afd371mr35042981f8f.43.1779855183235; Tue, 26 May 2026
 21:13:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEkJfYPhWdd59RKmuNLJg-bkypHz7xiOwaWyNVu3A8CUqQCnvg@mail.gmail.com>
 <ahPhcZvPD4S20UJf@infradead.org> <CAEkJfYP5YhcwVik31Mv3iouLG2wDksb4fEbu4TSU0TAYN25w6A@mail.gmail.com>
In-Reply-To: <CAEkJfYP5YhcwVik31Mv3iouLG2wDksb4fEbu4TSU0TAYN25w6A@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 26 May 2026 21:12:50 -0700
X-Gm-Features: AVHnY4LEEg-Gx__4supnB3_zW54o5z27MTN9TUGXHb-6cuRhEgGpfQXWgr6q6bw
Message-ID: <CAJnrk1a=ivLcEHBOJ8Nzodb52zJ_B2X4yV16hwv_Sio84y8y1g@mail.gmail.com>
Subject: Re: [BUG] iomap: NULL dereference in iomap_finish_folio_read after
 deferred failed read
To: Sam Sun <samsun1006219@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, brauner@kernel.org, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 26, 2026 at 8:25=E2=80=AFPM Sam Sun <samsun1006219@gmail.com> w=
rote:
>
> On Mon, May 25, 2026 at 1:43=E2=80=AFPM Christoph Hellwig <hch@infradead.=
org> wrote:
> >
> > On Sat, May 23, 2026 at 06:58:46PM +0800, Sam Sun wrote:
> > > Dear developers and maintainers,
> > >
> > > We encountered a NULL pointer dereference in the deferred buffered
> > > read failure path. Unfortunately, no reproducer is available yet.
> >
> > [snip]
> >
> > > We analyzed the cause of this report. It seems that failed buffered
> > > read bios are deferred to a global work item "failed_read_work". The
> > > deferred worker still owns the bio/folio, but by the time it calls
> > > `iomap_finish_folio_read()`, the folio may have been truncated,
> > > invalidated, or otherwise detached from its mapping. In that case,
> > > `folio->mapping` is NULL, but the error reporting path unconditionall=
y
> > > dereferences `folio->mapping->host`. This pattern still exists on the
> > > latest kernel commit.
> > >
> > > A possible fix could be avoiding the `folio->mapping->host`
> >
> > The folio is locked until the folio_end_read() call.  So I don't see
> > what could legitimately clear folio->mapping here.  Curiously waiting
> > for the reproducer to see waht is going wrong here.
> >
>
> I have more data now. I agree that the folio is supposed to stay locked
> until `folio_end_read()`, but that does not fully protect this path. The
> problematic window is a non-final read completion, after
> `ifs->read_bytes_pending` has been decremented and before the error repor=
ting
> path dereferences `folio->mapping->host`. The relevant code is still
> present in v7.1-rc5.
>
> The race I observed is:
>
> 1. A failed buffered read completion reaches `iomap_finish_folio_read()`.
> 2. It decrements `ifs->read_bytes_pending`, but `finished` is false
> (`pending_after=3D2048` in the logs below), so this completion is not the=
 one
> that unlocks the folio.
> 3. If the worker is delayed/preempted before the `fserror_report_io()` ca=
ll,
> another completion can finish the remaining bytes and unlock the folio.
> 4. Userspace then truncates the XFS file. The truncate path removes the f=
olio
> from the page cache and clears `folio->mapping` in
> `delete_from_page_cache_batch()`.
> 5. The delayed worker resumes and dereferences `folio->mapping->host`.

Does it not suffice to just call fserror_report_io() before
decrementing ifs->read_bytes_pending? eg

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d7b648421a70..d55b936e6986 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -400,6 +400,11 @@ void iomap_finish_folio_read(struct folio *folio,
size_t off, size_t len,
        bool uptodate =3D !error;
        bool finished =3D true;

+       if (error)
+               fserror_report_io(folio->mapping->host, FSERR_BUFFERED_READ=
,
+                                 folio_pos(folio) + off, len, error,
+                                 GFP_ATOMIC);
+
        if (ifs) {
                unsigned long flags;

@@ -411,11 +416,6 @@ void iomap_finish_folio_read(struct folio *folio,
size_t off, size_t len,
                spin_unlock_irqrestore(&ifs->state_lock, flags);
        }

-       if (error)
-               fserror_report_io(folio->mapping->host, FSERR_BUFFERED_READ=
,
-                                 folio_pos(folio) + off, len, error,
-                                 GFP_ATOMIC);
-
        if (finished)
                folio_end_read(folio, uptodate);


With read_bytes_pending still > 0, it's guaranteed that the folio is
locked and truncate can't invalidate folio->mapping yet as it requires
the folio lock.

Thanks,
Joanne

>
> In other words, the truncate path clears the mapping after the folio
> has legitimately
> been unlocked by another, final read completion. The unsafe part is that =
the
> non-final failed completion uses `folio->mapping->host` without holding a=
 lock
> or reference that keeps `folio->mapping` stable.
>
> One possible interleaving is:
>
> ```
> CPU0: failed_read_work CPU1: another read completion CPU2: userspace trun=
cate
> -------------------------------------
> ---------------------------------- --------------------------------
>
> iomap_finish_folio_read(folio, err)
>
> lock(ifs->state_lock)
> ifs->read_bytes_pending -=3D len
> finished =3D false
> unlock(ifs->state_lock)
>
> if (error)
>   /* about to execute:
>   * fserror_report_io(folio->mapping->host, ...)
>   */
> <preempted here>
>                                       iomap_finish_folio_read(folio, 0)
>
>                                       lock(ifs->state_lock)
>                                       ifs->read_bytes_pending -=3D len
>                                       finished =3D true
>                                       unlock(ifs->state_lock)
>
>                                       folio_end_read(folio, true)
>
>
>           open(..., O_TRUNC)
>
>             do_truncate()
>
>               truncate_setsize()
>
>                 truncate_inode_pages()
>
>
>           lock_folio(folio)
>
>           delete_from_page_cache_batch()
>
>             folio->mapping =3D NULL
>
>           unlock_folio(folio)
>
> <resumed>
>   fserror_report_io(folio->mapping->host, ...)
>                               ^^^^^^^^^^^^^^
>                               NULL now
> ```
>
> To validate the race on v7.1-rc5, I used a diagnostic build that is
> equivalent to
> placing a breakpoint immediately before the original dereference.
> The diagnostic patch:
>
> - logs non-final failed completions and records the folio/mapping being u=
sed by
> the error path;
> - logs immediately before the existing `folio->mapping =3D NULL` assignme=
nts in
> `page_cache_delete()` and `delete_from_page_cache_batch()`;
> - defers only the non-final `fserror_report_io(folio->mapping->host, ...)=
` by
> one second so the truncate race has time to run.
>
> With the syz corpus on v7.1-rc5 plus the diagnostic breakpoint:
>
> ```text
> [ 116.142333] d280-iomap-latest: deferred non-final fserror
> folio=3Dffd40000013ea940 mapping=3Dff1100004560b6b8 pending_after=3D2048
> comm=3Dkworker/0:7
> [ 116.177780] d280-filemap-latest: delete_from_page_cache_batch
> clearing watched folio=3Dffd40000013ea940 mapping=3Dff1100004560b6b8
> host=3Dff1100004560b4a0 ino=3D9286 index=3D0 locked=3D1 ref=3D4 comm=3Dsy=
z.5.30
> [ 117.330579] d280-iomap-latest: deferred fserror
> folio=3Dffd40000013ea940 mapping=3D0000000000000000 host=3D00000000000000=
00
> index=3D0 pos=3D0 off=3D0 len=3D2048 locked=3D0 ref=3D1 comm=3Dkworker/0:=
9
> [ 117.336816] Oops: general protection fault, probably for
> non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> [ 117.337746] KASAN: null-ptr-deref in range
> [0x0000000000000000-0x0000000000000007]
> [ 117.339635] Workqueue: events d280_deferred_report_work
> ```
>
> The detach is done by the normal truncate path:
>
> ```text
> delete_from_page_cache_batch()
> truncate_inode_pages_range()
> truncate_pagecache()
> xfs_vn_setattr_size()
> xfs_vn_setattr()
> notify_change()
> do_truncate()
> path_openat()
> do_file_open()
> __x64_sys_open()
> ```
>
