Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A5D255E4B
	for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2025 18:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739211163; cv=none; b=fFh18sqZvrr0R+Ha6k0g0LRD48/u424IQzAAuil9HG4heLMe0kYC/0R/sF6GzOsK9GV6ZW3sa9uZ64XiBSo28IcmHYqQjkAC3+G0VvcXQSruFIQJDQPc81LtwowLwdl5qFi7u4Tp5093MYjYsAfcKjgeoynn32KRBnonB87dyEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739211163; c=relaxed/simple;
	bh=3/MHfhlR7A1fMCKuzyQ9kYjcRJa0otc+shpPn/Aicas=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=tVQ8ieMQKFMGrZiHlnmvdXvZ33Fs/0IT1hfFcx5/25JmycsaOsc9Dn9KD0AGK7czIFlobgnslqTY66mqron73hxXcUjP3gzU8wzzjM/DA/7JS9rg/BfVKdmr2EQJ/ZwIqGQiQh3ouXlQeVW5p6A0sGOnGIF9lrBaNiL/npFtzqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scylladb.com; spf=pass smtp.mailfrom=scylladb.com; dkim=pass (2048-bit key) header.d=scylladb.com header.i=@scylladb.com header.b=z0b8llt8; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scylladb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scylladb.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=scylladb.com header.i=@scylladb.com header.b="z0b8llt8"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2f441791e40so6469758a91.3
        for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2025 10:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb.com; s=google; t=1739211161; x=1739815961; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ghqe50qYZAx8/Up2NeOnbz1uVUWHYq1gR6XXZUhiI3o=;
        b=z0b8llt83pPx5PjRHlWIT7qmb5sy1rAJz8lWlbXxjsxf2997pHjrpVh9l1c8qCvvLf
         3H3fGGd1Ct4HGcCmGjba0UAOTxveLF0yFRGbIny8AERJ3ScAOJ7kbwpa3TtZ2HnRfFYi
         +OG6mrocqNnj3NLvLSu/Xk8Je8wPNOB9utiNESqwULsaqiyKZHU+Fv2fR6nkTpincS0w
         kooryDLcPvjhIDePU8YnhtLluGxBj4YOsUlZCgWNIK/d9e7dOwb8BECvakXyIrlHs4jy
         c0OZrbTVdy4XAfoAU4rAckhgQIWDKaCMSCLyEPxg7Z1GfkkIz4RWhhaOO15IcHvLWrvM
         +3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739211161; x=1739815961;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ghqe50qYZAx8/Up2NeOnbz1uVUWHYq1gR6XXZUhiI3o=;
        b=FBby0D2gmgyq1K9Hwwl7u48WUEw/sKlQebF0vSgEHs2cwlQqsLo8QLjU8WIEP8CSzh
         SSHyRG24iID3IWFxRsYZRBjSp5NjxhIC6jMlQDEAsr1hqG9wExPAeBYHzsvuchBkegBv
         ZpW+2Epv4c8uJnQ9pUCHGFskvdq2/9YYLkKZHaGcZRABLvSF7iCbP0aBG9Ml0Htobkym
         BhPGyJfkm3CAJtohPlJKU4lYigFZrWm7FXH0IRN+MK1Zi+tjRO3cL/hxPs0JbLBXh589
         fceuyUZWiGkeEk7OGWwHF1VO13WIzz5EY+HSYOOP3yiQgpxPnSeu0ocMRjzo6JirS4s2
         iN9A==
X-Gm-Message-State: AOJu0Yxj6+SioqL9mguf7YvA3Rk2sGXbPPp8U/Hajf5JfnoBN9FL7+j1
	v9wthzIOeBV54Pmf0YDWp9nmnl56FGT3cDX2pjQmjOhj0Vqwd8uZlNmBT79EpgT87DPSUDzpTWN
	QO1aoADIeQdMiGwMXgJVAxGDvPVWB+FVAn2o6biAkZ+YyUWmx3oZGt0uggEwdh62tu96vFD9n0/
	MYKx6UumXLClczD5fBqr0n1nHh1YaqbjHqk1YJZSRjXJ8CLGk/f4HBrDqwFAmsRmmUFj3CSMlVF
	V7+bSO1ynFfx/l0J9RVYx0sQZsSmH6aTlNYGv9x6hMrEK8U/8EdcpxKIHf+14Knv0IO6vOyU1Z2
	0oKMb2WLjiPnh2hfF9GIAzhrbE8oc/nKuUkXihUri3rVSJIQc7jH2A6VA4LJWyriyvjhjhneSHj
	ZDL+QRPrRF0LEfXWY75QezeIw
X-Gm-Gg: ASbGncvbeL4Lfmk7YFSI8ptJ2ntMOad3W53GNCO/owbkJ4Zf+LvaMjsBilaN7kR9x5N
	zN8KDEQJqSsgrR6d3RQGDcMl1ne3B7ufqHuEYXvy+ckarVE/7biR0W2GObXbnL3lraRq+dYzNME
	MFeHty88qlSUp3ig==
X-Google-Smtp-Source: AGHT+IH42tWjnTVpToH+j5t5Jo4/pmVQaB9GJtJldKzz+C6W598q1wQBxNOoLHTh4L4xQClrCInTELzbqnmG1Vghncw=
X-Received: by 2002:a17:90b:2e47:b0:2fa:20f4:d277 with SMTP id
 98e67ed59e1d1-2fa243e39dbmr22125692a91.24.1739211160478; Mon, 10 Feb 2025
 10:12:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Raphael S. Carvalho" <raphaelsc@scylladb.com>
Date: Mon, 10 Feb 2025 15:12:24 -0300
X-Gm-Features: AWEUYZla75N_T1omj1dgRRrPxpzZF8m_so82a-s0ma_JD4_WjgtvDUIb2E1F1E8
Message-ID: <CAKhLTr1UL3ePTpYjXOx2AJfNk8Ku2EdcEfu+CH1sf3Asr=B-Dw@mail.gmail.com>
Subject: Possible regression with buffered writes + NOWAIT behavior, under
 memory pressure
To: linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org
Cc: djwong@kernel.org, Dave Chinner <david@fromorbit.com>, hch@lst.de, 
	Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-CLOUD-SEC-AV-Sent: true
X-CLOUD-SEC-AV-Info: scylladb,google_mail,monitor
X-Gm-Spam: 0
X-Gm-Phishy: 0
X-CLOUD-SEC-AV-Sent: true
X-CLOUD-SEC-AV-Info: scylla,google_mail,monitor
X-Gm-Spam: 0
X-Gm-Phishy: 0

While running scylladb test suite, which uses io_uring + buffered
writes + XFS, the system was spuriously returning ENOMEM, despite
there being plenty of available memory to be reclaimed from the page
cache. FWIW, I am running: 6.12.9-100.fc40.x86_64

Tracing showed io_uring_complete failing the request with ENOMEM:
# cat /sys/kernel/debug/tracing/trace | grep "result -12" -B 100 |
grep "0000000065b91cd1"
       reactor-1-707139  [000] ..... 46737.358518:
io_uring_submit_req: ring 00000000e52339b8, req 0000000065b91cd1,
user_data 0x50f0001e4000, opcode WRITE, flags 0x200000, sq_thread 0
       reactor-1-707139  [000] ..... 46737.358526: io_uring_file_get:
ring 00000000e52339b8, req 0000000065b91cd1, user_data 0x50f0001e4000,
fd 45
       reactor-1-707139  [000] ...1. 46737.358560: io_uring_complete:
ring 00000000e52339b8, req 0000000065b91cd1, user_data 0x50f0001e4000,
result -12, cflags 0x0 extra1 0 extra2 0

That puzzled me.

Using retsnoop, it pointed to iomap_get_folio:

00:34:16.180612 -> 00:34:16.180651 TID/PID 253786/253721
(reactor-1/combined_tests):

                    entry_SYSCALL_64_after_hwframe+0x76
                    do_syscall_64+0x82
                    __do_sys_io_uring_enter+0x265
                    io_submit_sqes+0x209
                    io_issue_sqe+0x5b
                    io_write+0xdd
                    xfs_file_buffered_write+0x84
                    iomap_file_buffered_write+0x1a6
    32us [-ENOMEM]  iomap_write_begin+0x408
iter=3D&{.inode=3D0xffff8c67aa031138,.len=3D4096,.flags=3D33,.iomap=3D{.add=
r=3D0xffffffffffffffff,.length=3D4096,.type=3D1,.flags=3D3,.bdev=3D0x=E2=80=
=A6
pos=3D0 len=3D4096 foliop=3D0xffffb32c296b7b80
!    4us [-ENOMEM]  iomap_get_folio
iter=3D&{.inode=3D0xffff8c67aa031138,.len=3D4096,.flags=3D33,.iomap=3D{.add=
r=3D0xffffffffffffffff,.length=3D4096,.type=3D1,.flags=3D3,.bdev=3D0x=E2=80=
=A6
pos=3D0 len=3D4096

Another trace shows iomap_file_buffered_write with ki_flags 2359304,
which translate into (IOCB_WRITE & IOCB_ALLOC_CACHE & IOCB_NOWAIT)
And flags 33 in iomap_get_folio means IOMAP_NOWAIT, which makes sense
since XFS translates IOCB_NOWAIT into IOMAP_NOWAIT for performing the
buffered write through iomap subsystem:

fs/iomap/buffered-io.c- if (iocb->ki_flags & IOCB_NOWAIT)
fs/iomap/buffered-io.c: iter.flags |=3D IOMAP_NOWAIT;


We know io_uring works by first attempting to write with IOCB_NOWAIT,
and if it fails with EAGAIN, it falls back to worker thread without
the NOWAIT semantics.

iomap_get_folio(), once called with IOMAP_NOWAIT, will request the
allocation to follow GFP_NOWAIT behavior, so allocation can
potentially fail under pressure.

Coming across 'iomap: Add async buffered write support', I see Darrick wrot=
e:

"FGP_NOWAIT can cause __filemap_get_folio to return a NULL folio, which
makes iomap_write_begin return -ENOMEM.  If nothing has been written
yet, won't that cause the ENOMEM to escape to userspace?  Why do we want
that instead of EAGAIN?"

In the patch ''mm: return an ERR_PTR from __filemap_get_folio', I see
the following changes:
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -468,19 +468,12 @@ EXPORT_SYMBOL_GPL(iomap_is_partially_uptodate);
 struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos)
 {
        unsigned fgp =3D FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE | FG=
P_NOFS;
-       struct folio *folio;

        if (iter->flags & IOMAP_NOWAIT)
                fgp |=3D FGP_NOWAIT;

-       folio =3D __filemap_get_folio(iter->inode->i_mapping, pos >> PAGE_S=
HIFT,
+       return __filemap_get_folio(iter->inode->i_mapping, pos >> PAGE_SHIF=
T,
                        fgp, mapping_gfp_mask(iter->inode->i_mapping));
-       if (folio)
-               return folio;
-
-       if (iter->flags & IOMAP_NOWAIT)
-               return ERR_PTR(-EAGAIN);
-       return ERR_PTR(-ENOMEM);
 }

This leads to me believe we have a regression in this area, after that
patch, since iomap_get_folio() is no longer returning EAGAIN with
IOMAP_NOWAIT, if __filemap_get_folio() failed to get a folio. Now it
returns ENOMEM unconditionally.

Since we pushed the error picking decision to __filemap_get_folio, I
think it makes sense for us to patch it such that it returns EAGAIN if
allocation failed (under pressure) because IOMAP_NOWAIT was requested
by its caller and allocation is not allowed to block waiting for
reclaimer to do its thing.

A possible way to fix it is this one-liner, but I am not well versed
in this area, so someone may end up suggesting a better fix:
diff --git a/mm/filemap.c b/mm/filemap.c
index 804d7365680c..9e698a619545 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1964,7 +1964,7 @@ struct folio *__filemap_get_folio(struct
address_space *mapping, pgoff_t index,
                do {
                        gfp_t alloc_gfp =3D gfp;

-                       err =3D -ENOMEM;
+                       err =3D (fgp_flags & FGP_NOWAIT) ? -ENOMEM : -EAGAI=
N;
                        if (order > min_order)
                                alloc_gfp |=3D __GFP_NORETRY | __GFP_NOWARN=
;
                        folio =3D filemap_alloc_folio(alloc_gfp, order);


Am I missing something?

Regards,
Raphael
