Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831801DF24D
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 17:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736184796; cv=none; b=PmLHOzK0bpNXDGe954Yv9SE5lMMFyed1zOh1SWnTcXsLJBUjs66yN8lH4RTapJrEURBN6nUY2rkhQt8x5rJawgz3JOQIly2gqWD8YrSIKV9kgCNaSoioXiIVl4keG+5ZvF4tgFWvt21LnnNlVD/cSM+/KmMU+Rf+xwrzT3remQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736184796; c=relaxed/simple;
	bh=Z2CQAKcqULArpxYZ51O6bCWKSghRPqh/uoMLDX5VTn4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fGGEhEd2gqkkxRypuB81XWSd5DfB8WQ116LFy7sCwP+FFT288t5b97LF2RTelj049BNQARzvSa1Tfphgoun64f655Osh6ryc1V1gwXE4LTz7WWFYdvsT+xkn1TB/4Iv3O1TGGtIIe4KBeG5ljkiJUMeHv23h58XTM5cOKBcV8vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=netrise.io; spf=pass smtp.mailfrom=netrise.io; dkim=pass (2048-bit key) header.d=netrise-io.20230601.gappssmtp.com header.i=@netrise-io.20230601.gappssmtp.com header.b=Qa3GXkm1; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=netrise.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netrise.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netrise-io.20230601.gappssmtp.com header.i=@netrise-io.20230601.gappssmtp.com header.b="Qa3GXkm1"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2efd81c7ca4so17220705a91.2
        for <linux-xfs@vger.kernel.org>; Mon, 06 Jan 2025 09:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netrise-io.20230601.gappssmtp.com; s=20230601; t=1736184792; x=1736789592; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mn66Uy2YJIA0xaENYQ+GpGHq/PhBcyIRbrqJc2jYxKA=;
        b=Qa3GXkm10nVsMJ2ij+a4O25YChlejhsYvPkfXYO+GeRUM8n9DGGrD2qP8uxvtGKf7H
         ig/DxdUWsA6jgT3bPI4I81jq8XfcqeRo3xTj+tJDrQ33lVb6AMigrewPxTxy8Q6TJOgb
         y8K/cR2dbcpo3QshqVgfKdpFyfSnVn444woXxXKRKojVbe4sIRwL/W9Y+X8MwIrd+3Vo
         c5WgNJXmV4A7OdDELxIv5N5f5ae8agkPQzhqYISfmcyAO+rBaVLn2iSkcHQusYo30XbQ
         6xj6yuafDX22TAYj5tDMc73AV3yFi97jnsWBqGeJmE8eGSa3dlTJtqSBEf+EkljXop/s
         b8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736184792; x=1736789592;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mn66Uy2YJIA0xaENYQ+GpGHq/PhBcyIRbrqJc2jYxKA=;
        b=pEHRUvuqP+PG3iD9ofCvrEQzVOc/ZG6kGOYmHW1BC6S8Qg/Uxmnp0EY6cYu63jAutX
         2LpEsQbGD5J8dT6GLxwgB39voIbnA3BaNWsv/IBZarL0vMFBAKQMMpD1UpkiH0aI/5v7
         C7MDKl+E4bGe7YHmSr6SH4oX1FA917x16NE3AYj5tKUYsYFW9uOHqndWQpBDGBGYGiCw
         tbsfwU7h8yZr86ebMFJGVY1GKtSouKoGn9rY0XOjWI9poUJ4WaDKRglNu3S0Zn7qeomg
         eE9DbHb9EvQaQhThx5l8F04JDFgUbwonA5To+rODJXGEyKamqoCxVVCQ1m9KjUjX1ch2
         yjNg==
X-Gm-Message-State: AOJu0YzZSl+dHbHxRMwugjwrfR/wK4q++g6/k6KEXK2FC3F1ltF2y35V
	iii58ykpXa1C8sHiATDxdmHTuluJurPa6H/rMDKD7m5ildgJpapEe1095FYWeZFakQ/lMrbPtop
	lVljz3L9zaeRmNENryj3wSpn4t5enT/xviWHAyrLsqR4OfHFiKDxYyg==
X-Gm-Gg: ASbGnctBhtOPGu0NamOVdWyvcylfXrIy/tZVfp+TAC3A0FHDPWuKjrcbqINPuK5fQE/
	qAa6yDhF2Cy4010rPU+L66X3t1y08c3zkB+tEew==
X-Google-Smtp-Source: AGHT+IE++BU2O8JQpt7HYbw6TmSbY2jYuURe6MlRPjUn+bbcbA/TIdA7kQ69DKS/hJBBM/+qoToJ21dRBhxseho8ZRg=
X-Received: by 2002:a17:90b:2805:b0:2ee:d024:e4f7 with SMTP id
 98e67ed59e1d1-2f452d37b34mr103538686a91.0.1736184792669; Mon, 06 Jan 2025
 09:33:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAE9Ui5nCVmeOGkOwJA4anU4oJ8evy7HqAXmPt+yhvwC_SJ5_uA@mail.gmail.com>
 <20250102232007.GV6174@frogsfrogsfrogs>
In-Reply-To: <20250102232007.GV6174@frogsfrogsfrogs>
From: Tom Samstag <tom.samstag@netrise.io>
Date: Mon, 6 Jan 2025 09:33:01 -0800
Message-ID: <CAE9Ui5kkrt_e8kWRLZVP-7MBQe19uebMexxpmkFUHfNJ7iAFTQ@mail.gmail.com>
Subject: Re: xfs_db bug
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested-by: Tom Samstag <tom.samstag@netrise.io>

On Thu, Jan 2, 2025 at 3:20=E2=80=AFPM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> On Thu, Jan 02, 2025 at 02:14:45PM -0800, Tom Samstag wrote:
> > Hi!
> >
> > I'm encountering what I believe to be a bug in xfs_db with some code
> > that worked previously for me. I have some code that uses xfs_db to
> > copy some specific data out of an XFS disk image based on an inode
> > number. Basically, it does similar to:
> >
> > inode [inodenum]
> > dblock 0
> > p
> > dblock 1
> > p
> > dblock 2
> > p
> > [etc]
> >
> > This worked on older versions of xfs_db but is now resulting in
> > corrupted output. I believe I've traced the issue to the code
> > introduced in https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/co=
mmit/?id=3Db05a31722f5d4c5e071238cbedf491d5b109f278
> > to support realtime files.
> >
> > Specifically, the use of a `dblock` command when the previous command
> > was not an `inode` command looks to lead to the data in
> > iocur_top->data to no longer contain inode data as expected in the
> > line
> > if (is_rtfile(iocur_top->data))
> >
> > I don't know the code well enough to submit a fix, but some quick
> > experimentation suggested it may be sufficient to move the check for
> > an rtfile to inside the push/pop context above after the call to
> > set_cur_inode(iocur_top->ino).
> >
> > Hopefully this describes the issue sufficiently but please let me know
> > if you need anything else from me.
>
> Oh, yeah, that's definitely a bug.  Thank you for isolating the cause!
> Does the following patch fix it for you?
>
> --D
>
> From: Darrick J. Wong <djwong@kernel.org>
> Subject: [PATCH] xfs_db: fix multiple dblock commands
>
> Tom Samstag reported that running the following sequence of commands no
> longer works quite right:
>
> > inode [inodenum]
> > dblock 0
> > p
> > dblock 1
> > p
> > dblock 2
> > p
> > [etc]
>
> Mr. Samstag looked into the source code and discovered that the
> dblock_f is incorrectly accessing iocur_top->data outside of the
> push_cur -> set_cur_inode -> pop_cur sequence that this function uses to
> compute the type of the file data.  In other words, it's using
> whatever's on top of the stack at the start of the function.  For the
> "dblock 0" case above this is the inode, but for the "dblock 1" case
> this is the contents of file data block 0, not an inode.
>
> Fix this by relocating the check to the correct place.
>
> Reported-by: tom.samstag@netrise.io
> Cc: <linux-xfs@vger.kernel.org> # v6.12.0
> Fixes: b05a31722f5d4c ("xfs_db: access realtime file blocks")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  db/block.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/db/block.c b/db/block.c
> index 00830a3d57e1df..2f1978c41f3094 100644
> --- a/db/block.c
> +++ b/db/block.c
> @@ -246,6 +246,7 @@ dblock_f(
>         int             nb;
>         xfs_extnum_t    nex;
>         char            *p;
> +       bool            isrt;
>         typnm_t         type;
>
>         bno =3D (xfs_fileoff_t)strtoull(argv[1], &p, 0);
> @@ -255,6 +256,7 @@ dblock_f(
>         }
>         push_cur();
>         set_cur_inode(iocur_top->ino);
> +       isrt =3D is_rtfile(iocur_top->data);
>         type =3D inode_next_type();
>         pop_cur();
>         if (type =3D=3D TYP_NONE) {
> @@ -273,7 +275,7 @@ dblock_f(
>         ASSERT(typtab[type].typnm =3D=3D type);
>         if (nex > 1)
>                 make_bbmap(&bbmap, nex, bmp);
> -       if (is_rtfile(iocur_top->data))
> +       if (isrt)
>                 set_rt_cur(&typtab[type], xfs_rtb_to_daddr(mp, dfsbno),
>                                 nb * blkbb, DB_RING_ADD,
>                                 nex > 1 ? &bbmap : NULL);
