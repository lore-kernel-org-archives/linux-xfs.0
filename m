Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7762324B19
	for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 16:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761323128; cv=none; b=RCPanDVYYA5CAYF2HP41ozCXrptBDXgp/hw9RU+3dYbmHo9LIvY+HboaJ0FusZFVzSS4LoSYho/Hmf6A+dMAsB+Dd7GRmNEuR8vAwi3LpOedcMCqI4/nQwyoemAcqFIft3lF6zZSLPJSBhMSLMIDikse1pcQ1iVHP9MDtCaLbqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761323128; c=relaxed/simple;
	bh=+atxU2EiCvuEBwKzBLViHbEHLO1ByLt9iNuuwtmSwYM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k9kY3KWKnbACFWSLN65SLUi1SfJUDtpWQ3rGPfjJiQv8rTKLu/S8baapxfqBROB1YRGDX4ZIFM1GqoSQfjlN7WR/P3+KkEr7HCWl4lhyjiHUJgyvLzy2oOk8+1AWI1IwDUwghJxz30K8z+bmkXU7Nq1AIyrOSU0NHR1MPpzQyMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A0rvd96C; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A0rvd96C"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4e8b334bff3so21300541cf.2
        for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 09:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761323124; x=1761927924; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wx/1KUSrS2QODRikqv2kYXYElChlESHNJsV1usUpdu4=;
        b=A0rvd96C906D3KvaGW5vfosyQzQJmOJfkzEs1+yn+4Vr707jUNl87rUzBKsxXkXnkD
         gfmsdf1Sq1PMgTSqhLUinUoH2FLNVL0Jx1jrCoj22Eq5/TDCb2cY6Uk4QiYx250ef8Fy
         2+GSG0i+17l9eb+9IczX0WgA4xW0AUAgrxkZBEi48Nq5zGQRc6nAYBZD9dB4OJQP1OYW
         AG0Tp2bRizUOE5k8WYkajMfU+ev21sHzeqM3wHGazfKGrEegziImgRyjjWc8PdEoe7Bo
         0/yadFZUDTOGZGZj7OebQOewijjxYdIrPD8yvS0vyRAodTh18QMFOtw7+qFmemZPrr8V
         2TDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761323124; x=1761927924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wx/1KUSrS2QODRikqv2kYXYElChlESHNJsV1usUpdu4=;
        b=Q0S6p/E725Mws6D6XOeIBDEMeWgHK37wwK/6Ge0o6Xt4s2VNdpeFZknzf5kfN82Jfi
         C6xJeDSEA0g1FWCSxEF0pzzO2RkgdCXuHy83mnThyXZcM20CmCNoir5UGyt3zsRQ7fUp
         Lj3Z3/nkL2jxbRtgNKfoNZOwj5X0yvh6shecaUeTMyaSVdNKFiJzTYQyrbw8OF7svn1A
         rXY3KMhKwzxFlain3y7LrZFkIf4VDNLuvOZ7N7XhCmWpZ5wpdAJ2sA99bi9FajUg1b60
         Qkncde5+/Nv+7L8nLnF6e/zTKRAzFtOAxyohDPlL7SMit/1TpubA5o/+ZCt0fabsxcNq
         r2yw==
X-Forwarded-Encrypted: i=1; AJvYcCWLopgeag3bzLeGEchuRgo5LT5cj05EKLplj6/+QG4n+N5kDlC8B6GuVT+b2ffIk659WazJ8rcE0Js=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPlKPzmCpWiJ59ihNoklR6j4BIluXVHmQnA6U1WLThLJhXW16w
	DDS9cY/fwNdYyMWQknuImxtW3FRE+exv7Cl9sivuKzDerEl3QbOj+ZDl2Vr61wyV5Gqk2f4DzMC
	ZTs5Bgz1zScNxBMclAqZPP/xvfx5hSJk=
X-Gm-Gg: ASbGncuQhZCyoDhSEeSXEbvi1yfyvrYEv4e6jLFh38s9qbw8rhSQ+wZVpoI/RdSKt2U
	cJQcd7qm+36oJllcOD/SJ/L1ftyt9SnYlDU3X2eo/sbkHr2i41+OOsEegXzADbNlZBmXGl04zv7
	rs8MgOEtZkxbGkZkn0pSKqBKN/W/i2AiD0dteWZ9Ppa3SggOBIzXTsj6JvvT/SHokYlJsj5Cf/t
	gt0DnoML57sq87SJprGORJWbMDwf9c21RURtBJwT8keYgOcjup0PjjiY6ByugMZPOTE0tYvm+DC
	XUHHvHFNBGs9MGFDH1Hq8QgKXw==
X-Google-Smtp-Source: AGHT+IHp3wmsoO5cixVEN6RnBalbhLBxtbDmErayXQYcHx3ZFIvWvsx0O7mjIrtkdb0eYC3IVVBavdS6CsD2AIKgnrM=
X-Received: by 2002:ac8:7d88:0:b0:4b3:104:792c with SMTP id
 d75a77b69052e-4eb949095dbmr36793101cf.57.1761323124234; Fri, 24 Oct 2025
 09:25:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926002609.1302233-1-joannelkoong@gmail.com>
 <20250926002609.1302233-8-joannelkoong@gmail.com> <aPqDPjnIaR3EF5Lt@bfoster> <CAJnrk1aNrARYRS+_b0v8yckR5bO4vyJkGKZHB2788vLKOY7xPw@mail.gmail.com>
In-Reply-To: <CAJnrk1aNrARYRS+_b0v8yckR5bO4vyJkGKZHB2788vLKOY7xPw@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 24 Oct 2025 09:25:13 -0700
X-Gm-Features: AS18NWA3qoIlbq6W__AaTzux05FyB2J3eGAkfannm8GTk0lfzD_eFocAFZliHW4
Message-ID: <CAJnrk1b3bHYhbW9q0r4A0NjnMNEbtCFExosAL_rUoBupr1mO3Q@mail.gmail.com>
Subject: Re: [PATCH v5 07/14] iomap: track pending read bytes more optimally
To: Brian Foster <bfoster@redhat.com>
Cc: brauner@kernel.org, miklos@szeredi.hu, djwong@kernel.org, 
	hch@infradead.org, hsiangkao@linux.alibaba.com, linux-block@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org, kernel-team@meta.com, 
	linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2025 at 5:01=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Thu, Oct 23, 2025 at 12:30=E2=80=AFPM Brian Foster <bfoster@redhat.com=
> wrote:
> >
> > On Thu, Sep 25, 2025 at 05:26:02PM -0700, Joanne Koong wrote:
> > > Instead of incrementing read_bytes_pending for every folio range read=
 in
> > > (which requires acquiring the spinlock to do so), set read_bytes_pend=
ing
> > > to the folio size when the first range is asynchronously read in, kee=
p
> > > track of how many bytes total are asynchronously read in, and adjust
> > > read_bytes_pending accordingly after issuing requests to read in all =
the
> > > necessary ranges.
> > >
> > > iomap_read_folio_ctx->cur_folio_in_bio can be removed since a non-zer=
o
> > > value for pending bytes necessarily indicates the folio is in the bio=
.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> > > ---
> >
> > Hi Joanne,
> >
> > I was throwing some extra testing at the vfs-6.19.iomap branch since th=
e
> > little merge conflict thing with iomap_iter_advance(). I end up hitting
> > what appears to be a lockup on XFS with 1k FSB (-bsize=3D1k) running
> > generic/051. It reproduces fairly reliably within a few iterations or s=
o
> > and seems to always stall during a read for a dedupe operation:
> >
> > task:fsstress        state:D stack:0     pid:12094 tgid:12094 ppid:1209=
1  task_flags:0x400140 flags:0x00080003
> > Call Trace:
> >  <TASK>
> >  __schedule+0x2fc/0x7a0
> >  schedule+0x27/0x80
> >  io_schedule+0x46/0x70
> >  folio_wait_bit_common+0x12b/0x310
> >  ? __pfx_wake_page_function+0x10/0x10
> >  ? __pfx_xfs_vm_read_folio+0x10/0x10 [xfs]
> >  filemap_read_folio+0x85/0xd0
> >  ? __pfx_xfs_vm_read_folio+0x10/0x10 [xfs]
> >  do_read_cache_folio+0x7c/0x1b0
> >  vfs_dedupe_file_range_compare.constprop.0+0xaf/0x2d0
> >  __generic_remap_file_range_prep+0x276/0x2a0
> >  generic_remap_file_range_prep+0x10/0x20
> >  xfs_reflink_remap_prep+0x22c/0x300 [xfs]
> >  xfs_file_remap_range+0x84/0x360 [xfs]
> >  vfs_dedupe_file_range_one+0x1b2/0x1d0
> >  ? remap_verify_area+0x46/0x140
> >  vfs_dedupe_file_range+0x162/0x220
> >  do_vfs_ioctl+0x4d1/0x940
> >  __x64_sys_ioctl+0x75/0xe0
> >  do_syscall_64+0x84/0x800
> >  ? do_syscall_64+0xbb/0x800
> >  ? avc_has_perm_noaudit+0x6b/0xf0
> >  ? _copy_to_user+0x31/0x40
> >  ? cp_new_stat+0x130/0x170
> >  ? __do_sys_newfstat+0x44/0x70
> >  ? do_syscall_64+0xbb/0x800
> >  ? do_syscall_64+0xbb/0x800
> >  ? clear_bhb_loop+0x30/0x80
> >  ? clear_bhb_loop+0x30/0x80
> >  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > RIP: 0033:0x7fe6bbd9a14d
> > RSP: 002b:00007ffde72cd4e0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > RAX: ffffffffffffffda RBX: 0000000000000068 RCX: 00007fe6bbd9a14d
> > RDX: 000000000a1394b0 RSI: 00000000c0189436 RDI: 0000000000000004
> > RBP: 00007ffde72cd530 R08: 0000000000001000 R09: 000000000a11a3fc
> > R10: 000000000001d6c0 R11: 0000000000000246 R12: 000000000a12cfb0
> > R13: 000000000a12ba10 R14: 000000000a14e610 R15: 0000000000019000
> >  </TASK>
> >
> > It wasn't immediately clear to me what the issue was so I bisected and
> > it landed on this patch. It kind of looks like we're failing to unlock =
a
> > folio at some point and then tripping over it later..? I can kill the
> > fsstress process but then the umount ultimately gets stuck tossing
> > pagecache [1], so the mount still ends up stuck indefinitely. Anyways,
> > I'll poke at it some more but I figure you might be able to make sense
> > of this faster than I can.
> >
> > Brian
>
> Hi Brian,
>
> Thanks for your report and the repro instructions. I will look into
> this and report back what I find.

This is the fix:

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 4e6258fdb915..aa46fec8362d 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -445,6 +445,9 @@ static void iomap_read_end(struct folio *folio,
size_t bytes_pending)
                bool end_read, uptodate;
                size_t bytes_accounted =3D folio_size(folio) - bytes_pendin=
g;

+               if (!bytes_accounted)
+                       return;
+
                spin_lock_irq(&ifs->state_lock);


What I missed was that if all the bytes in the folio are non-uptodate
and need to read in by the filesystem, then there's a bug where the
read will be ended on the folio twice (in iomap_read_end() and when
the filesystem calls iomap_finish_folio_write(), when only the
filesystem should end the read), which does 2 folio unlocks which ends
up locking the folio. Looking at the writeback patch that does a
similar optimization [1], I miss the same thing there.

I'll fix up both. Thanks for catching this and bisecting it down to
this patch. Sorry for the trouble.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20251009225611.3744728-4-joannelk=
oong@gmail.com/
>
> Thanks,
> Joanne
> >
