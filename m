Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776CC231C95
	for <linux-xfs@vger.kernel.org>; Sat,  5 Oct 2024 06:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728109535; cv=none; b=rotVOgos11rCSNZmLYDi52oroX3tZanYV22O0fPKajlTQ4g2yZki5rdr1k07eKP5qdvQ44CPSllqahCKfco1/oVSyuSemrbZ6Ya5pV6CfP35acEt3O77zuwA+Dn4CmMpsZFrtt6ycvW2JAExfqoNeVwrlkSWoB6TLQ0dwuMJFt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728109535; c=relaxed/simple;
	bh=gRLPfSS08xtXYfIx8fWFSJs7fedSXyKLBx6e/2GGw50=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ay76tykuIHzwY9tUakG4iehRe60l/Fqt8W3E/ch6/kx6dVkVgqWSZ2f3eOG5lB4aPWfMwkw2Rq1LzvSTPTC1fY3xWEjF9WntDndyN5Zp0mNzp90efUzn0Y9e4ZjfePMYDD1hlnBA2l8hC9IY0UpW+KRRdGsosnIyH9UerLKb+oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CitAWqNv; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CitAWqNv"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6cb29ff33c5so23933766d6.2
        for <linux-xfs@vger.kernel.org>; Fri, 04 Oct 2024 23:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728109533; x=1728714333; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vj3ZR8t3pGLxSGgS1vdeR2UywynnO7OgpHlIVeDDotA=;
        b=CitAWqNv+38IQ0V+ti2IBK9zVmfGtOA5+N9z28zZfbzYRfClqebhykFqM0lYEytcj3
         2KK1gqQ0o42X3SguAxEqBvevxA0lITOIZUN/qvRmtTCMc8CuOr/ugi2XFl/dxwLS93WJ
         RuOTncYg6Wm0eGfCVLOaxE3HuSz032KgO5NjFIR8maPPQvQ6ngCbxBvKicYFiGEppSpT
         a5veeMTt8KlFhAeUx7RMMGxWsuDgoVcf3+TsVNi7P++rDhj9B91mHr6H5YVmUK9EaHZ3
         JiBBFsC16FSzH+fDte64dP9in7a4N9NRpqbBpgYPTAJ0RqIRVxac+nbRKY8gEAOVvCwK
         gaqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728109533; x=1728714333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vj3ZR8t3pGLxSGgS1vdeR2UywynnO7OgpHlIVeDDotA=;
        b=fA1WJKFIc3Hf2m8NpLsxrBdQglb/w7YyjxFPAMgZPQ3GeY78e5mxSZ5f2nR0FRHw8z
         3cIEnpIJz/mLMsTRAG68oHJvstX6+SMOab1FyeyxePMr5oU7SlTwRQ7/qFRZmeQ8RxF7
         2gbezHDsyfqzEKfsSq7+DA3RzQX6b5YNXura8XhnSf5RIIfZEb8QKfnoZ1T4nf2/dawB
         L83p1/U1C4GL6/ZxX1dXrnCvdI5rUJ47UyDlZtSEZilp4EaOHwTgn1mOL0c1E1GuMIKa
         x/MWm01A6pw+AWvmODL0hYxdh3FnWKAycVcA/LVK8pNk/0p6Y7qB13fOJHrDdB7fbPZg
         praA==
X-Forwarded-Encrypted: i=1; AJvYcCW5z9mBllslLkNCPawRVfXyidMWmg7ATynEe94QtUXVw5PcWGUtJ5ezEeJson3qE+DmmEjem7sz7qg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrqbvG/QADMZjOIY5WDD/4JMlDtmjKdpkbcHL7bDLCxaQ/WfZ2
	XzKxjWPA4Msawe+bETniNdTf/7nPy7VZO5WcBMfJmylP4ZPS5C33Fs2hWkDbnX0yoxgDaus6yu2
	lLdnpaqGF/g64DCnZD4I8y4V8ZZtq8gEajwKOGg==
X-Google-Smtp-Source: AGHT+IEyuUO+2S5PY1ss0mzrD/8Bps21GfK0NW3mFTDoa1PS9KYJiop0vJwIkUYeQnH8rnWNbyq+H2maJICVSBbGCUU=
X-Received: by 2002:a0c:f6cc:0:b0:6c7:c646:25fb with SMTP id
 6a1803df08f44-6cb9a30655cmr60788736d6.27.1728109533316; Fri, 04 Oct 2024
 23:25:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240930034406.7600-1-laoar.shao@gmail.com> <Zvsr76vifZeNDArE@dread.disaster.area>
In-Reply-To: <Zvsr76vifZeNDArE@dread.disaster.area>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sat, 5 Oct 2024 14:24:56 +0800
Message-ID: <CALOAHbCbqGquG=1xMiDJN042uAh+pe4v+ooFH+s0cz00Li=NgA@mail.gmail.com>
Subject: Re: [PATCH] xfs: Fix circular locking during xfs inode reclamation
To: Dave Chinner <david@fromorbit.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 1, 2024 at 6:53=E2=80=AFAM Dave Chinner <david@fromorbit.com> w=
rote:
>
> On Mon, Sep 30, 2024 at 11:44:06AM +0800, Yafang Shao wrote:
> > I encountered the following error messages on our test servers:
> >
> > [ 2553.303035] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > [ 2553.303692] WARNING: possible circular locking dependency detected
> > [ 2553.304363] 6.11.0+ #27 Not tainted
> > [ 2553.304732] ------------------------------------------------------
> > [ 2553.305398] python/129251 is trying to acquire lock:
> > [ 2553.305940] ffff89b18582e318 (&xfs_nondir_ilock_class){++++}-{3:3}, =
at: xfs_ilock+0x70/0x190 [xfs]
> > [ 2553.307066]
> > but task is already holding lock:
> > [ 2553.307682] ffffffffb4324de0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_p=
ages_slowpath.constprop.0+0x368/0xb10
> > [ 2553.308670]
> > which lock already depends on the new lock.
>
> .....
>
> > [ 2553.342664]  Possible unsafe locking scenario:
> >
> > [ 2553.343621]        CPU0                    CPU1
> > [ 2553.344300]        ----                    ----
> > [ 2553.344957]   lock(fs_reclaim);
> > [ 2553.345510]                                lock(&xfs_nondir_ilock_cl=
ass);
> > [ 2553.346326]                                lock(fs_reclaim);
> > [ 2553.347015]   rlock(&xfs_nondir_ilock_class);
> > [ 2553.347639]
> >  *** DEADLOCK ***
> >
> > The deadlock is as follows,
> >
> >     CPU0                                  CPU1
> >    ------                                ------
> >
> >   alloc_anon_folio()
> >     vma_alloc_folio(__GFP_FS)
> >      fs_reclaim_acquire(__GFP_FS);
> >        __fs_reclaim_acquire();
> >
> >                                     xfs_attr_list()
> >                                       xfs_ilock()
> >                                       kmalloc(__GFP_FS);
> >                                         __fs_reclaim_acquire();
> >
> >        xfs_ilock
>
> Yet another lockdep false positive. listxattr() is not in a
> transaction context on a referenced inode, so GFP_KERNEL is correct.
> The problem is lockdep has no clue that fs_reclaim context can only
> lock unreferenced inodes, so we can actualy run GFP_KERNEL context
> memory allocation with a locked, referenced inode safely.

Thanks for your detailed explanation.

>
> We typically use __GFP_NOLOCKDEP on these sorts of allocations, but
> the long term fix is to address the lockdep annotations to take
> reclaim context into account. We can't do that until the realtime
> inode subclasses are removed which will give use the spare lockdep
> subclasses to add a reclaim context subclass. That is buried in the
> middle of a much large rework:
>
> https://lore.kernel.org/linux-xfs/172437087542.59588.13853236455832390956=
.stgit@frogsfrogsfrogs/

Thank you for the reference link. While I=E2=80=99m not able to review the
patchset in detail, I=E2=80=99ll read through it to gain more understanding=
.

--=20
Regards
Yafang
