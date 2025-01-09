Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02529215782;
	Thu,  9 Jan 2025 10:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736417268; cv=none; b=Rd33Zf7K/2exHJpHdjstDeVn0sQYD4L9veMr5KKl/qy4gYXc1egvWS3ONa0gdz617Yeqa5yBhAhXsR3EWIIAgXOeMbphXEhVukCC2tR+Q38eGcLlhL6DftyrcSu7dQNingTyUnqmsJ1oUzJUlLuC1fThEIitbuItoMBT3qI1tFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736417268; c=relaxed/simple;
	bh=JIkRbiaeXQ2UvSJ0aRFt/Z7LnI9KY+iQSjidhL0uLE8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hJIAD9HcdkK0eR+glsgU/XyifxZhTYweH47ErgQuXOe12TwDnUZvwJX/HlrQrutZtyuhS7ArsQOJUoC2UWW0teHKU0041z9SjAc5VnQUp62a9SKDFS2yj4Pvw2eb2Eevbl4s44vLDZQK+uJ1FAMHk32fT1krAe6ug3dney7Gapg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cd19Ywx9; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cd19Ywx9"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5d3d14336f0so1054568a12.3;
        Thu, 09 Jan 2025 02:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736417265; x=1737022065; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P6AdmypWM7NigsMdgmeaZmR8uRCYasqbBWsWjJLuSkg=;
        b=Cd19Ywx97FztsKrUA9VHz2/Kr8KtKSJ+giCoZbP0VQBodPVFskf21m1qslCTMhX1vP
         Y1MIbf+mJzW6cFJzayJ5uQ0iviBUaKyE74U7qTo+I8vSq/NwUV97pTuY6fBj5YQwVlCK
         u/WClDPHi8tYuiR4fID9AfXumcgs4Zf5E3CyFIIAHA2EYq2JDyj+iPF3EFkaaAcKTpl/
         zdlUDuSelPj54ojuk4jypO4xymuq0DRoXnRvRTAd0YqNQ0dRIbOLI64B+Cu3UOF8qfxd
         3HMMEGPeKFR7dWYkMf+GX1TuX+V6VRN/MM+iKaqXYcn6VDCH3PaTNCNgeOH95zcQrp26
         BGVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736417265; x=1737022065;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P6AdmypWM7NigsMdgmeaZmR8uRCYasqbBWsWjJLuSkg=;
        b=npiWXNE/oxopwLNtqvi6Ou8Rs3wddHU+MXb/M6OQd3qji1VtKarLXrsJ29sFCiNGdw
         hophHQA0SHbq/qYPip3pyi3dmkngpo/WmuD43aCCfumRtXKODT+kHQF7PD7jdXMeOsFk
         ZOBP1/qMHaWX6Dxq5p3Ag7U2SEyJGzBlNmScL6gXSRUW3wrbvTfnQiTdgXqA4JJRqtSl
         9BLf6REnV1Cql1LkhD4+w477lZQ9gVSOtqw2RCEkUkraZ8zXs+rcSCuOc/b1IQP/4fE8
         2rogoz2ef8NQEywkuX4XaLGY1fGBiubPHabHTRhRMNGD8ID4oZVgX94BFr04eXwzfGcY
         192Q==
X-Forwarded-Encrypted: i=1; AJvYcCWnMLy1mp8XLvjcZ2EdVvlrIKfOXgJzSMb//x271qPCh6ndhHzDvx3XSLpCw1OIrF0Q2FYcMH9OchjE@vger.kernel.org, AJvYcCXyRz9Iowdc+xhtggLsjPo5ol1Uup/dKtuc2+b+7ypZtCf7SeYlUS1JhfiiTB8Xp2msolVnaR4Qj3Q7HE4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyvz+4oQXTCA5+qObzSnZgRSLM1JoT5nXeBJl0UkrKVwitZakRB
	nn9BDz4FAZnhnAJSXdKGYDz/cEDN+Ksxb+T7BRemqCVMtNf5J5zM2G2gGXpVUt3vUUkN0oJJo/D
	JRalHRApZQ5R9wcd3t6Y2nSwni88=
X-Gm-Gg: ASbGnctcBWbSWYxmJAOR3imIowdeMUz5yJO5wZIffylrMdYYHEpRy9GOmyiF8KQhfT+
	b/ASwDBcdnZa/gSVE0ZP8Xr5kVQBzTd+vH89mpQ==
X-Google-Smtp-Source: AGHT+IFuzi3nN0knj3HDIs13nrydXRfWSadzau6Plh2LEtDniqoOjGxjWSqZz0Y92HstmwzudgaKZueAMdApMJ0lCEc=
X-Received: by 2002:a05:6402:254d:b0:5d0:81dc:f20e with SMTP id
 4fb4d7f45d1cf-5d972e1c5cfmr5269174a12.17.1736417264794; Thu, 09 Jan 2025
 02:07:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241226061602.2222985-1-chizhiling@163.com> <Z23Ptl5cAnIiKx6W@dread.disaster.area>
 <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com> <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com> <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com> <CAOQ4uxjgGQmeid3-wa5VNy5EeOYNz+FmTAZVOtUsw+2F+x9fdQ@mail.gmail.com>
 <dca3db30-0e8f-4387-9d4d-974def306502@oracle.com>
In-Reply-To: <dca3db30-0e8f-4387-9d4d-974def306502@oracle.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 9 Jan 2025 11:07:32 +0100
X-Gm-Features: AbW1kvahk4nffT7_HvPoxPWZBNd3E5RnG3GdolP_rCrPlt_Yx3wBNwznQN9OQAQ
Message-ID: <CAOQ4uxiMiLkie03QA9ca_3ARzwg7rm31UFBo6THdVUDvr0u6fw@mail.gmail.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: John Garry <john.g.garry@oracle.com>
Cc: Chi Zhiling <chizhiling@163.com>, Dave Chinner <david@fromorbit.com>, djwong@kernel.org, 
	cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chi Zhiling <chizhiling@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 8, 2025 at 1:16=E2=80=AFPM John Garry <john.g.garry@oracle.com>=
 wrote:
>
>
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index c488ae26b23d0..2542f15496488 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -777,9 +777,10 @@ xfs_file_buffered_write(
> >          ssize_t                 ret;
> >          bool                    cleared_space =3D false;
> >          unsigned int            iolock;
> > +       bool                    atomic_write =3D iocb->ki_flags & IOCB_=
ATOMIC;
> >
> >   write_retry:
> > -       iolock =3D XFS_IOLOCK_EXCL;
> > +       iolock =3D atomic_write ? XFS_IOLOCK_SHARED : XFS_IOLOCK_EXCL;
> >          ret =3D xfs_ilock_iocb(iocb, iolock);
> > --
> >
> > xfs_file_write_checks() afterwards already takes care of promoting
> > XFS_IOLOCK_SHARED to XFS_IOLOCK_EXCL for extending writes.
> >
> > It is possible that XFS_IOLOCK_EXCL could be immediately demoted
> > back to XFS_IOLOCK_SHARED for atomic_writes as done in
> > xfs_file_dio_write_aligned().
> >
> > TBH, I am not sure which blockdevs support 4K atomic writes that could
> > be used to test this.
> >
> > John, can you share your test setup instructions for atomic writes?
>
> Please note that IOCB_ATOMIC is not supported for buffered IO, so we
> can't do this - we only support direct IO today.

Oops. I see now.

>
> And supporting buffered IO has its challenges; how to handle overlapping
> atomic writes of differing sizes sitting in the page cache is the main
> issue which comes to mind.
>

How about the combination of RWF_ATOMIC | RWF_UNCACHED [1]
Would it be easier/possible to support this considering that the write of f=
olio
is started before the write system call returns?

Note that application that desires mutithreaded atomicity of writes vs. rea=
ds
will only need to opt-in for RWF_ATOMIC | RWF_UNCACHED writes, so this
is not expected to actually break its performance by killing the read cachi=
ng.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/20241220154831.1086649-1-axboe@ke=
rnel.dk/
