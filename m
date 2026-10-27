Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.129.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793097616;
	b=jyw7xxUENtYy8KZ/Ztq97q0lfnmijfzcAnyUyDF9qWsQ6H24qq5N6yoHfDgNoAxfdLAL
	 OKtrCZnfJTekgjj7ijzVd8j1pcErSSUhtGm4uWA0hNuw5TfDBIf1iufZSLglfip7DXMft
	 ohI8yZ5aqnvhp5uhQsARY0p0tJPae2dwlNJwU6RH6biZGg7VrZ2ctfZ6WjsmyLQshRv64
	 pxDngDR9q6bZ2tgnOz50pWEFUZksoOremCwz0nJTMjLJp5u8DDwUnRvW+fLCEmTq0C02J
	 fLn6r/jC8bzZGAI95kilkPSX+z+W6nMYBHj6Dh2H7mzukQh7F5kD0oda7H35oLeE3XQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793097616;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=7OYbDDzUmC/dcU5eCCTLOKEwzBV+TagsGcae08wBOPY=;
	b=AdF2H/k4yYrlMXkaPupN/yoX52JHGUvtPSbvZ7qEdWFMHXOvIEqcfwXaZ4z+wK6fG5Rd
	 wAKaAQQbzyhYjNe32+95M70S3Lx5Hx0vcIbYU+sJPSFXga1x3DZFA5zhYThMswufgcKRD
	 XSCO6dcBRdZ0rSimfFM8xd0ayJPCdVw26A6+kNtv2kyIY756aLbwe0smXtsZkAUXD0MkR
	 LFkSrojKreRniTawR4kEXrxNCuvQG34qNzQBi1dEP6xrQrB5Gs+iFTWksL9s3cH9SFJVw
	 s8A88ZDxaqoFfSNg1fb4KvqBz7fVVIixa7z8DvtcU+RsxHMYaq35JFGNvSeTwjvoPuA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=T6ohI07B;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=rdaIlOvb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF38606A330
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 10:40:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDF38606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=T6ohI07B;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=rdaIlOvb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793097614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7OYbDDzUmC/dcU5eCCTLOKEwzBV+TagsGcae08wBOPY=;
	b=T6ohI07Bq5uaX4aA4YhCJTwLjbQPW0XiwkFSwN0Muc3xcIqqnO8p3lNvbK9HrskiaXifSC
	rOE9Zc0M1+Gly/UKhfZ4emQbjBDcdJWAVMZ0b1J4yRV5+1j+fJafdwZivYhSjZbO56NyvT
	IU6ztlNCybAS9vp7KS5VepMaKKSJRC4=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-O9OtvLn3NX6x8huqHqkGiA-1; Tue, 27 Oct 2026 06:40:13 -0400
X-MC-Unique: O9OtvLn3NX6x8huqHqkGiA-1
X-Mimecast-MFC-AGG-ID: O9OtvLn3NX6x8huqHqkGiA_1793097612
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-7044b48537dso5005393eaf.2
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 03:40:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793097612; cv=none;
        d=google.com; s=arc-20260327;
        b=QSqebR8qPPLSzK+UogUOu+jF/oj6C1NShjr4kh/54k7V7D9/7wXmGT3euU7LyoDyqQ
         Uy28ucx5/a9RDHDMq8VlhSe+djoacsDh6785xs6X53NsmtX+ZtVpslwL8wDk+iDxClof
         JbePvsBBBVWNAsVCrl4Haxfrf5sGqHW+eBXKVKIegB2MV54gfL1eztPkNeaZBnrxv2L3
         4Arq8SKG0j8O/rfhsDfj7tAscZ9TnsAwxgzZ0sQauIhjPY+Pv3dajwi7D94CBHb/JCFD
         EdvtbOcBlZIy/chAvUgM8CmhCFABoek9XlnQgPSIwy1nX0fCxIqbez1R8PL3jeIxx2ga
         obrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7OYbDDzUmC/dcU5eCCTLOKEwzBV+TagsGcae08wBOPY=;
        fh=Ak7T838pPpHQlZSaTOmUC2idjJvV/3yGAeWOoBIwLm4=;
        b=FSNPW2MLC6b+EGrNOn9s01N+hkQu00apP2b7f5X8i6qAADbVUFihBhZ+4SmyWk2Fmk
         CzaJkNap4AvPVSCAJahZY3Fr/GExVyFHIx2258bRls9wQzk/pHFJbxtz4synenCGgIt/
         QC6pNrtGwXU1dHJe8+ygCGBMN92BtXOzOtVEozpd0h3x+k8/6YXcw3iI+/+P/WNkwxFe
         Glkhl/o+NU0cMOf64rPUFpkaL3vIGDsqMVwJccPbhrLqvTbUj2mg8gfDnDHIr/rDMKRk
         6PFNq6/wCT7GuEGWVC81N9/wlFNhfi2C0Ol3RAuD5t9/xJ17LKhkHFPRrI+DGvmYvoV+
         1TLg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793097612; x=1793702412; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7OYbDDzUmC/dcU5eCCTLOKEwzBV+TagsGcae08wBOPY=;
        b=rdaIlOvb1bW+BBtDAaU2ztnVZrmM46iad4pdCwjIASfVstOHRCtQhe7CFW1BlHEE3O
         F7dXa5FOtp34k+QO1GbusbiYDr7Dw05SaLO56u5T0dWXbGgW3boEEkDCIg8OIpCFb9k0
         1C1QvT0NZsOU2FDNif7+msBkjbjsp3eU7CWZml0z5qS7orASs7sCsM+pC180uUE2uMnl
         XuRr7I/GwgHRKXOSSTZ3Xb+5emkgIfKHrMpDneEAg7GFo+rQCbDiokYff7jIA22Pmf4+
         pgyCGvKnHkb/sWoVF2H1wIcOtAMywRKG7GIwLrduUDtAkPtePCfZNh8H1oR2ugYF2p4/
         UVPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793097612; x=1793702412;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7OYbDDzUmC/dcU5eCCTLOKEwzBV+TagsGcae08wBOPY=;
        b=SR2U8/aACt20YlBSW8OaiLd/wqnlzVIhRp6nGxJjw5ezqiXmp4O8P+txIHvrjihCGq
         UlRebZj59R7OYrJUCKXIAkizxPbeoUPtgc14Kk2Q3+uL/pbQoABy60VE0CQzDg+59B/Y
         H2h2Ye7/E+EC2YR5dOWwSVABgEDLJFpKFU61jebxC0PAWJ/6OTGoty+ZfGFobDVYOoG0
         0j3F+r5hs/CFLyBZxSvfhzHVAQz2WzWUOpd73gVwCf1YF32/P7MrWRpLAyiWNspOyqrF
         m5gADe/oHKCx64b61EfHGSPAa5DcfeyLIcxKkrDeuwBoX3RNkrseiYiKVaEqC1dGXPDN
         uSqQ==
X-Forwarded-Encrypted: i=1; AKwUvBy5lkArRMONKDnZgsyklFAoSdHCUYI68wKrFWs9koykuPWmwJe7nrtiia78M1ZhbbU1J19mswgcmug=@vger.kernel.org
X-Gm-Message-State: AFq9FYLGwuzgm/fStHGMNalHYwrOT0J4r9R1TBOAAhYqCAUhOxzhwNcW
	2+TChdsI2pDtLGzxgD3Uw1YVwzC1cgvJhX9zINOejHYQvf+xAqGbOgcs4Eb9TgjshMBoThkjHcW
	aSECkfosLuyTcQ2fiyCwIdnQeGbqKkApT1XorV/DdL0n0DaX4frukd7IatNXQLin64nf/NwkBKM
	Y/j+nm8S0S8Kt3m3SxOhVqDukjlKC0DR/c1GIw
X-Gm-Gg: AYBFou1xMkVhsgbshEQ8UAL4yatLgF1PC9W0IFXyMo6vno1NWifkQMb2qDUeFds+/hV
	i42UJVak/RC86vCKMMf32QlgkpXJCrJzy2XMQUnkG1nKlYpXVVo7pht+g2bhB+2DyVvTcyygjYD
	NShiSQ54xECvmijguyNd+E89R++UMF/yTVh5CREIDQeOA5M/+fGXlMQw==
X-Received: by 2002:a05:6820:828:b0:70b:a287:72b5 with SMTP id 006d021491bc7-70ba287795bmr4283941eaf.20.1793097612228;
        Tue, 27 Oct 2026 03:40:12 -0700 (PDT)
X-Received: by 2002:a05:6820:828:b0:70b:a287:72b5 with SMTP id
 006d021491bc7-70ba287795bmr4283925eaf.20.1793097611786; Tue, 27 Oct 2026
 03:40:11 -0700 (PDT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016091628.295119-1-lherbolt@redhat.com> <atoO8FTTt97n5oXv@bfoster>
In-Reply-To: <atoO8FTTt97n5oXv@bfoster>
From: Lukas Herbolt <lherbolt@redhat.com>
Date: Tue, 27 Oct 2026 11:39:34 +0100
X-Gm-Features: AclHuK_m8lZbkotZuR9w7kW9eff4dLNdlzU6LcQDjKpyj2QbDPGB5jhyLJrf5vI
Message-ID: <CAM4Jq_7g1iTimXtGcy91ruEjHHv2t+X2voWiqTdPUY4WEzD+4A@mail.gmail.com>
Subject: Re: [PATCH 1/1] xfs: add test for ENOSR/ENOSPC on DIO into delalloc extents
To: Brian Foster <bfoster@redhat.com>
Cc: zlang@kernel.org, fstests@vger.kernel.org, hch@lst.de, 
	linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 22, 2026 at 3:26=E2=80=AFPM Brian Foster <bfoster@redhat.com> w=
rote:
>
> On Fri, Oct 16, 2026 at 11:16:25AM +0200, Lukas Herbolt wrote:
> >   Test if a DIO extending write into a speculative delalloc region on a
> >   fragmented XFS filesystem does not trigger a dirty transaction cancel
> >   (-ENOSR) or return a spurious -ENOSPC.
> >
> >   With allocsize=3D128MB, a buffered write creates a large delalloc ext=
ent.
> >   A subsequent DIO write at i_size lands in the speculative prealloc
> >   region. On a fragmented filesystem, xfs_bmapi_write converts the
> >   delalloc starting from offset 0 but the allocation is too short to
> >   reach the DIO offset, causing either -ENOSR (dirty transaction cancel
> >   and filesystem shutdown) or -ENOSPC (wrong error from xfs_bmapi_write=
).
> >
> >   Assisted by LLM.
> >
> >   Fixed by kernel commits:
> >     2a9b99d45be0 xfs: pass the actual offset and len to xfs_bmapi_alloc=
ate
> >     21255afdd729 xfs: do not allocate the entire delalloc extent
> >     6773da870ab8 xfs: fix error returns from xfs_bmapi_write
> >
> > Co-developed-by: Eric Sandeen <sandeen@redhat.com>
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > Signed-off-by: Lukas Herbolt <lherbolt@redhat.com>
> > ---
> >  .gitignore                 |   2 +
> >  src/Makefile               |   3 +-
> >  src/buffer_direct_io.c     | 154 ++++++++++++++++++++++++++++++++
> >  src/fragment_fs.c          | 101 +++++++++++++++++++++
> >  src/mix_buffer_direct_io.c | 175 +++++++++++++++++++++++++++++++++++++
> >  tests/xfs/842              |  63 +++++++++++++
> >  tests/xfs/842.out          |   2 +
> >  7 files changed, 499 insertions(+), 1 deletion(-)
> >  create mode 100644 src/buffer_direct_io.c
> >  create mode 100644 src/fragment_fs.c
> >  create mode 100644 src/mix_buffer_direct_io.c
> >  create mode 100755 tests/xfs/842
> >  create mode 100644 tests/xfs/842.out
> >
> ...
>
> Just a few higher level comments..
>
> > diff --git a/src/buffer_direct_io.c b/src/buffer_direct_io.c
> > new file mode 100644
> > index 000000000000..01b19994a2e2
> > --- /dev/null
> > +++ b/src/buffer_direct_io.c
> ...
> > diff --git a/src/fragment_fs.c b/src/fragment_fs.c
> > new file mode 100644
> > index 000000000000..cee4edef73ff
> > --- /dev/null
> > +++ b/src/fragment_fs.c
> > @@ -0,0 +1,101 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2026 Eric Sandeen, Lukas Herbolt
> > + */
> > +
> > +/*
> > + * Fragment filesystem by creating fixed-size files and then deleting
> > + * every n-th one.
> > + *
> > + * Usage:
> > + *   fragment_fs <directory> <prefix> <file size> <delete every n-th f=
ile>
> > + */
> > +
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <unistd.h>
> > +#include <fcntl.h>
> > +#include <errno.h>
> > +#include <sys/statvfs.h>
> > +
> > +static int fragment_fs(const char *dir, const char *prefix,
> > +                    off_t size, int delete_nth)
> > +{
> > +     char path[4096];
> > +     int i, fd;
> > +     int created =3D 0;
> > +
> > +     fprintf(stderr, "Fragmenting filesystem (filling to ENOSPC)...\n"=
);
> > +
> > +     for (i =3D 0; ; i++) {
> > +             snprintf(path, sizeof(path), "%s/%s_%06d", dir, prefix, i=
);
> > +             fd =3D open(path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
> > +             if (fd < 0) {
> > +                     if (errno =3D=3D ENOSPC)
> > +                             break;
> > +                     perror("open frag file");
> > +                     return -1;
> > +             }
> > +             if (fallocate(fd, 0, 0, size) < 0) {
> > +                     close(fd);
> > +                     unlink(path);
> > +                     if (errno =3D=3D ENOSPC)
> > +                             break;
> > +                     perror("fallocate frag file");
> > +                     return -1;
> > +             }
> > +             close(fd);
> > +             created++;
> > +     }
> > +     fprintf(stderr, "Created %d files\n", created);
> > +
> > +     fprintf(stderr, "Deleting every %d-th file...\n", delete_nth);
> > +     for (i =3D 0; i < created; i +=3D delete_nth) {
> > +             snprintf(path, sizeof(path), "%s/%s_%06d", dir, prefix, i=
);
> > +             unlink(path);
> > +     }
> > +     sync();
> > +
> > +     {
> > +             struct statvfs st;
> > +             if (statvfs(dir, &st) =3D=3D 0) {
> > +                     unsigned long free_mb =3D (st.f_bfree * st.f_bsiz=
e)
> > +                                             / (1024 * 1024);
> > +                     fprintf(stderr,
> > +                             "%d files remain, ~%lu MB free\n",
> > +                             created - created / delete_nth, free_mb);
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
> > +
>
> Any chance we can reuse existing code in fstests for this sort of free
> space fragmentation? For example, see the punch-alternating tool and/or
> something like generic/186 (if useful, maybe that code can be lifted
> into a common helper).
>
I used to xfs_io to fragment the fs but it tool much more time. I will chec=
k
how it's done in the g/186 and see if we can use common helper
> ...
> > diff --git a/src/mix_buffer_direct_io.c b/src/mix_buffer_direct_io.c
> > new file mode 100644
> > index 000000000000..0af227a7c9f0
> > --- /dev/null
> > +++ b/src/mix_buffer_direct_io.c
> > diff --git a/tests/xfs/842 b/tests/xfs/842
> ...
>
> It looks like we have two mix I/O helper programs here, where this one
> appears unused..?
Ugh, I was doing some rename and I missed that.
>
> Also both appear to have some minor whitespace damage in the form of
> trailing spaces at the end of some lines, so it might be worth fixing
> that up as well.
>
> > new file mode 100755
> > index 000000000000..b2b2f7c493e7
> > --- /dev/null
> > +++ b/tests/xfs/842
> > @@ -0,0 +1,63 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2026 Lukas Herbolt.  All Rights Reserved.
> > +#
> > +# FS QA Test 842
> > +#
> > +# Regression test for XFS -ENOSR dirty transaction cancel during DIO
> > +# write into a speculative delalloc region on a fragmented filesystem.
> > +# With allocsize=3D128MB, a buffered write creates a large delalloc ex=
tent.
> > +# A subsequent DIO extending write at i_size triggers xfs_bmapi_write =
to
> > +# convert the delalloc from offset 0; on a fragmented FS the allocatio=
n
> > +# is too short to reach the DIO offset, returning -ENOSR and cancellin=
g
> > +# a dirty transaction, which shuts down the filesystem.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto enospc
> > +
> > +_cleanup()
> > +{
> > +     cd /
> > +     rm -r -f $tmp.*
> > +}
> > +
> > +_require_test
>
> Looks like we don't use the test dev in this test.
>
> > +_require_scratch
> > +_require_test_program "fragment_fs"
> > +_require_test_program "buffer_direct_io"
> > +
> > +_scratch_mkfs_sized $((1<<30)) > "$seqres.full" 2>&1
> > +_scratch_mount -o allocsize=3D131072k >> "$seqres.full" 2>&1
> > +
> > +src/fragment_fs $SCRATCH_MNT frag 4096 2 >> "$seqres.full" 2>&1
> > +src/buffer_direct_io $SCRATCH_MNT >> "$seqres.full" 2>&1
> > +RET=3D$?
> > +
> > +_dmesg_since_test_start | grep -q "detected at xfs_trans_cancel"
> > +DMESG_CHECK=3D$?
> > +
> > +if [ $RET -eq 5 -a $DMESG_CHECK -eq 0 ]; then
> > +     _fixed_by_kernel_commit 2a9b99d45be0 \
> > +             "xfs: pass the actual offset and len to xfs_bmapi_allocat=
e"
> > +     _fixed_by_kernel_commit 21255afdd729 \
> > +             "xfs: do not allocate the entire delalloc extent"
> > +     _fail "ENOSR dirty transaction cancel detected (ret=3D$RET)"
> > +
> > +elif [ $RET -eq 28 ]; then
> > +     _fixed_by_kernel_commit 2a9b99d45be0 \
> > +             "xfs: pass the actual offset and len to xfs_bmapi_allocat=
e"
> > +     _fixed_by_kernel_commit 21255afdd729 \
> > +             "xfs: do not allocate the entire delalloc extent"
> > +     _fixed_by_kernel_commit 6773da870ab8 \
> > +             "xfs: fix error returns from xfs_bmapi_write"
> > +     _fail "ENOSPC returned from xfs_bmapi_write (ret=3D$RET)"
> > +
> > +elif [ $RET -eq 0 ]; then
> > +     echo "Silence is golden"
> > +else
> > +     _fail "Unknown error: src/buffer_direct_io error code $RET"
> > +fi
>
> A brief comment above this might be helpful. I'm also curious if it can
> be simplified a little. For example, I'm not sure we need to explicitly
> _fail when we can rely on golden output and/or the dmesg checking that
> happens by default. Also it looks like the commit hints are duplicate
> except for the -ENOSPC specific one. So perhaps we could do something
> like the following?
>
> echo "Silence is golden"
>
> # words about the error codes, i.e. EIO vs ENOSPC?
> if [ $RET -neq 0 ]; then
>         _fixed_by_kernel_commit <X>
>         _fixed_by_kernel_commit <Y>
>         [ $RET -eq 28 ] && _fixed_by_kernel_commit <Z>
>         echo "... error code $RET"
> fi
>
> Brian
>
> > +
> > +# success, all done
> > +status=3D0
> > +exit
> > diff --git a/tests/xfs/842.out b/tests/xfs/842.out
> > new file mode 100644
> > index 000000000000..643d05289a33
> > --- /dev/null
> > +++ b/tests/xfs/842.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 842
> > +Silence is golden
> > --
> > 2.56.0
> >
> >
>

Thanks

--
Lukas Herbolt
SSME
Red Hat

