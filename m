Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5312438F62E
	for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2026 09:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776679150; cv=pass; b=ERCNVyqUEQ1jh2c90GgtH+KX/B6UWwbuk17EHvtipBjQu83GtyJkqCJJIHbHf0tT0GuHEBA8wBBb0b56EjR/nJPTqhPoTmZCKsAnNV0wjSXqspqEu07ZIODYAYXeS/e54WEHRX96hoGgHDdX0WTZs0gGVyq7xRsyjdIRwST3igY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776679150; c=relaxed/simple;
	bh=A+0ZYRI4bhrzd4DznVs14BK30lBCNe0iSlUNS3kYy5w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ENhrT9fvTO99jo7TC4kBa8Z+PcSZ3siY9Va0k+6xLCMxfoFB4lf6jn+OoZWsr0NvSrE928dkgYwM5vKmJ1QMtf2NjaVuuRq/pIPxalUPUatHILmTpcZnZIS5Iv2JxYHtuc1hHdNReFcfoe6juJ8pdZtV8kE2xK4QsdxUD69+1u8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HlYWisiD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=M1DLN7dz; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HlYWisiD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="M1DLN7dz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776679148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A+0ZYRI4bhrzd4DznVs14BK30lBCNe0iSlUNS3kYy5w=;
	b=HlYWisiDfjcdzdzQ/is+OmR5Z0wKGtI2OJt03uWvC8UsDqBU+rppZFehMbFnE2pj9M5Uxj
	8gor+XiVhklW9b2S21zlt4L+GE6pHuN33/G5fmVArxPmFgS9kVLrAFkL7+UhrWK6cGBYTs
	RCEU3EcENWRodeeAaGBxWnDAL1vyEqs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-ccy_pW3SNCCkOUw3rnSnJA-1; Mon, 20 Apr 2026 05:59:06 -0400
X-MC-Unique: ccy_pW3SNCCkOUw3rnSnJA-1
X-Mimecast-MFC-AGG-ID: ccy_pW3SNCCkOUw3rnSnJA_1776679145
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b90bb54d034so371796866b.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2026 02:59:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776679145; cv=none;
        d=google.com; s=arc-20240605;
        b=CDiipp7fj/JDv0CVI59vUHgIucih0MB/SRXWgrYo7EaZS9LA6OSPnRNxkwwuZV7eR2
         w0P7nBG0E3n5EqA0JXPN+Uy2B7a8Mlck2Qsaq99gIsKTfr7a42udYqBE1osCsXoF9l3H
         aVjKrzQZQvzNx2PA4dHPRLtCQwY/x+MZicyropWfRaHunSQK5f9NfIonRLqcBVFoeaix
         k4XEJQN7MvYKGVi9L0hBxdmHbx7fkYljGlaPyHWL09GTFhRTJKxU7TsWaLKbKkIrkbTz
         Ir9hEJ/2cO5K9IoYvHir7z1wagJfA0xioxvV4VIQwVbC619xACNJC5CKYnrJp2aEwHZM
         rAeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A+0ZYRI4bhrzd4DznVs14BK30lBCNe0iSlUNS3kYy5w=;
        fh=clwkdnuvt6MfNmx4IuNEBXt+jxiS+Mutcf4dJKVBWiU=;
        b=RTJfvZphJablO7rnFBk2TZoK3oUL5Wr6KbgD1FjI4uDMUKS2SBr0Vi7bsB0hAAKp+z
         jskcIm6nBJTH5SxR5I7UK06rtrBeApgpKwHZwbGip14Sk6pkoZPq9mMZf0jGIF1OLc7C
         e3j7hwkRkppW6mOgS2+GY18VGbrZi0kJke5gihn0Tcwt0JtcCFeL6X5JKLOx/OUf4qiv
         z51o6E7fQ7qsRvHgCR9lxLEm26INaPNGNCw91KXpVKKUyEP6fXzHxjLAXfSGAIYomAPs
         ob6r7xvBOAKwGlx8nfWQGin2jtu4RqePzKdlmDjvdgPJfaQoO54gkrieHwC/qLw/Jvg9
         /fIw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776679145; x=1777283945; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A+0ZYRI4bhrzd4DznVs14BK30lBCNe0iSlUNS3kYy5w=;
        b=M1DLN7dzmjiktBGpxl/tG6WDF7kt6aERi6JJuBhhwyb6CFl4gK7YVivznkGd4gsUwn
         4wnQYAnkeW48q21WCzwAAX2K5f90pV0hOFp8BZqmb2G1NSGBiKjGLGc294UXvHVM44I3
         j+YQCE3yHLfNnw2qpgkNJjMdLHPMhU7ETC9RXm96A1JVgiPMtdbNAx/DftbHq3msl2kf
         TMzlK5w6HiPx/+eZKR+v/pt9h/Or3isiM2lvW2a2zUI4lnmmYeiUEQiH2Gp302d900/e
         w3diz/urhEiD+sgevp8KPJ/BcHIKg/b6atAQmSCKAsI7DAuDEYOEwtFxpwIsjKfruY5u
         H/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776679145; x=1777283945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A+0ZYRI4bhrzd4DznVs14BK30lBCNe0iSlUNS3kYy5w=;
        b=iFz3SWY1EnQLhWhYJMMwvKBKk9gxwa2A+KnZ4USw0sCHGb7fyrvsVsAiAx6u1T7zI6
         eRlAFyJxA4TagJaNedDuig4hxQgFj1dXW5rWAX57y8+LG/00THfFLc4uKBIecDwgP6X/
         WAdxK32YSewbyAbGg8jfiVY6BPS73YBxoA74t2dlbi6F/clxk/qDOj5CLpf+W8Ir0SKw
         vsG+UntEvrz1ZYRSGZYCUs4UOKuMIoUKApvwbhEmFCJ5UWrjbgs0u1IRx0ElTU/mgEM3
         UE+5740uDG3IVveHHw9FYhdJGs70y4r5UQ58o4rQ7BBzYpt/LsfqaSPSq859fJOAqj2r
         NMcg==
X-Gm-Message-State: AOJu0YwISpp5CKD/ppb2IzlOcMoLdj9Z3BK6i4+/tlAb61e+7aJUfEop
	a8B1uk8jT0mYqd7jy0j0K7rYeLw3tkGg+/oAh3sFFvXV29Z2vwNtiO4XYe1ZIm25viFJ6AaVe2r
	QQdXNROhuvXS3ZQmtk+RABYNwClXE59cFfWyl792iqllCkrB+b9iisUrgKXPgoQeN9yx+B/SK6Y
	x1g1iNgZhTR/5aNrU2ZnSHOl8/mGwhe/vBReUb
X-Gm-Gg: AeBDietILbWBRYOrjs7UKRil6fC8zJFskuTHQqnE/zzUZr/BmUINNl7xIOcklO0oseo
	j9m1Jby9y6+UOgF1C+eFiGuOqC3kVuRH3648WlDDhoghrDPEeHR4O9KV8LqaOzOQ8oVaD33dQ3Z
	wlPfO0d8epGABoMglL5rZTb8ZqcThJO17Go/NHdcoQ2Ia/Qhcvu2xWWdDgchknTN6fu4JTSpI6A
	jVzJHqOzZy9yyuj6I09GTihhJNml+2FIDCS9i6RKuuNu6BH
X-Received: by 2002:a17:906:ee8a:b0:b9d:7b9d:df02 with SMTP id a640c23a62f3a-ba421debe8emr542313566b.17.1776679144864;
        Mon, 20 Apr 2026 02:59:04 -0700 (PDT)
X-Received: by 2002:a17:906:ee8a:b0:b9d:7b9d:df02 with SMTP id
 a640c23a62f3a-ba421debe8emr542311766b.17.1776679144298; Mon, 20 Apr 2026
 02:59:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260415071657.23412-1-ravising@redhat.com> <ad88TluB4FIP3yJV@infradead.org>
 <CAF-d4OvKZOsez5589KUYTjRz05PQHCQ-uRkXu-3iaO3tOjcavA@mail.gmail.com> <aeBv_xvDTmuzEhV1@infradead.org>
In-Reply-To: <aeBv_xvDTmuzEhV1@infradead.org>
From: Ravi Singh <ravising@redhat.com>
Date: Mon, 20 Apr 2026 15:28:52 +0530
X-Gm-Features: AQROBzD_UsKC0IhQ4Ae2Ri5WaWay6e3YXdaKJYXBxxPywhXucTckxG6JecxZqFA
Message-ID: <CAF-d4Ose1YMaHy5Jy_QmLwDQvBC7m2Bt5ftzmYnZwheSyhX+EQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: flush delalloc blocks on ENOSPC when creating symlinks
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	djwong@kernel.org, dchinner@redhat.com, esandeen@redhat.com, cem@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 16, 2026 at 10:43=E2=80=AFAM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> On Wed, Apr 15, 2026 at 06:54:00PM +0530, Ravi Singh wrote:
> > > While we're at it - do we also want it for tempfiles and scrub?
> > > i.e., should we move this logic into xfs_trans_alloc_icreate,
> > > similar to the quota logic?
> > >
> > tmpfiles and scrub tempfiles are created without
> > directory entries, so they don't need a new directory block
> > allocation and don't hit this ENOSPC path.
>
>
> But we still ned the ialloc space reservation for all these cases.
>

You're right - the ENOSPC comes from xfs_trans_alloc() failing
to reserve blocks via xfs_dec_fdblocks(), which is the same
 global counter for all callers. Even the smaller
XFS_IALLOC_SPACE_RES reservation for tmpfiles can fail there
when delalloc pressure has consumed the available fdblocks.

I did try several runs to reproduce the ENOSPC for tmpfile
creation, but wasn't able to trigger it in practice - the
smaller reservation makes it much harder to hit. That said,
the code path is the same and it makes sense to handle it
centrally rather than leave the gap.

> > As for moving the logic into xfs_trans_alloc_icreate(),
> > xfs_flush_inodes() is a heavier operation (sync_inodes_sb).
> > Pushing it down into xfs_trans_alloc_icreate() would make every
> > caller pay for that flush, including paths that don't need it.
>
> Only if we git enospc and need to restart the underlying
> xfs_trans_alloc call, similar to how it handles quotas.
>
>

v2 moves the xfs_flush_inodes() retry into
xfs_trans_alloc_icreate() and removes the existing caller-level
retry from xfs_create()


Thanks,
Ravi

