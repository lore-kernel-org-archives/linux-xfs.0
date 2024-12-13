Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2592AE66
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081339; cv=none; b=SW8ZHNSFbULav9EMOthXYp3rp9QV31wsmNJ6L5baQg0kgTeUwq6A9Gr7b7VADig1BYLoHlPImg1ETaGBWRRdk82H74oUdtJcTDQs0UxlBsXF3MBQ/Fv0bUE9bxuYhEDGzcWqon/t9ZBot7wOIH/kru2yB/YY1Xsm1TVoHYltN5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081339; c=relaxed/simple;
	bh=OMlzWL+OkIoAFIB+9cMDyrLMzvazVgKu9nxMOzReVEU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tK9JcZZM4tztOIzyguPlIAbY17/S3k1kupaeN7JAcecQzhbRpWa93EqCwvu8tNqyl5Jp5tRmU/sbE9UKVVoSpYlAa1A5xXB9HpJ0JCLdX/w+BiUrp8r0gAC+2slWhfjk5LzAYPjCwnewNMqexj2oEeIrr91MJPebmwq9tETUPWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=owltronix.com; spf=none smtp.mailfrom=owltronix.com; dkim=pass (2048-bit key) header.d=owltronix-com.20230601.gappssmtp.com header.i=@owltronix-com.20230601.gappssmtp.com header.b=0b5HAFw6; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=owltronix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=owltronix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=owltronix-com.20230601.gappssmtp.com header.i=@owltronix-com.20230601.gappssmtp.com header.b="0b5HAFw6"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aa6a3c42400so260281666b.0
        for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=owltronix-com.20230601.gappssmtp.com; s=20230601; t=1734081336; x=1734686136; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sbd7PVSa5BpfTCe05qorvYFwWUz25Es8saRgH6wIFpY=;
        b=0b5HAFw6xd+uGiR3I9JAnUDomSCwQ2DuHIxLkBfnMbMlFBrGE2x0qd+MIRIwVe8GFF
         WkFLkwelZdtr4yg75QsjGlOc+1a3gekvHMHIjxskPStn93HRsUIHLxFKydg8sfsZSHWx
         HkJTZbY8Kl66Hc0lq/i3a/q+G9L7XAMbsgvhAzLE/v1+NNVhUxJ1NpY3mZf+jc+hDFZr
         qkouvbLfo7tjrucTzxuheEDFxuCrFR6iuOLhDCI0B4fjdrzol9lFm+SxG/wg3XdeP9Vw
         0av9h+IbSjtzwNrO/rrE2v0bYnUKeM5zh75WtgRbP8uMqIC0DYhRHwIJs3wVCcOsNSHn
         xWaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734081336; x=1734686136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sbd7PVSa5BpfTCe05qorvYFwWUz25Es8saRgH6wIFpY=;
        b=cWmoQ/KTsZ9DRJfuomFc92qpe+Kud3dK+DuSGnpyywQ5+zl7rciCZ4HrdWNxNeINU/
         r9ekk8m9ZJM8pgcLU5GkPAxJ++j+BNxjFIaeA9a/zxYdc7vx7dB+D2Lyb//ti4+Df2yQ
         8pgUMucUBXx8EWORKW5HifbBueyv11BGidAXKzQ7XjSq8Bx5qb4TnfuxcKqaMxfiig/N
         cEhbMI7r3jxQRD//JJS51Rto1BWju5ukSDljJl8BCRgerMqjRqWwPYSz6pN1FwaCaJ67
         zGx2a2QGcAS5GgLKTq1ewB9a8lY44TN5qj9zLJdxNtKGYLTggFbuU1Bpmv62CIynExwx
         Ey/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUxFNabUDkVvY0tWCamWxZ5EZMtWv26WO550V1Tqc4rT0zbGDRRUzNjK8K7PEpJMvc1yAI3we7VhyM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFMHpW+hUJejZnNObRUXrUVvz+cD2NrcvqVItQH+bqOmgPVXNz
	tL7aVmw88HxTyv56YOD29XW5k68wLJ7jjbu/JUn9l/mWwqjw/4QB3oDh5Ds0TT1CWrTmrLakF3s
	1mcB69REQ0svIGjeUhuNB71Ic8qE/DijHPBuiKQ==
X-Gm-Gg: ASbGncvuKalXK6gfh633B0zbmp/CSYkkZmbs9Csopt0uyDPr2GGEdQUTW7cYvX+L/sN
	p42IAnlEinKmwVzNoMm14Oua3aCltxpn0WtvQ
X-Google-Smtp-Source: AGHT+IHqsD49MtdAMqOdI3Gzul6/eKmhgbjK07S6IAzDaxxE2lDnQSEEGnMNpSVBQi2FD1p4foVMpaLbUVmPLMJp4gw=
X-Received: by 2002:a17:906:7943:b0:a9a:662f:ff4a with SMTP id
 a640c23a62f3a-aa6c3cc12d0mr701814866b.0.1734081335867; Fri, 13 Dec 2024
 01:15:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-11-hch@lst.de>
 <20241212213833.GV6678@frogsfrogsfrogs>
In-Reply-To: <20241212213833.GV6678@frogsfrogsfrogs>
From: Hans Holmberg <hans@owltronix.com>
Date: Fri, 13 Dec 2024 10:15:25 +0100
Message-ID: <CANr-nt0QY-8Dwh2Vj_US4ZYBXB1Y1jF=Ms3G0ALM2wS=MopAbA@mail.gmail.com>
Subject: Re: [PATCH 10/43] xfs: preserve RT reservations across remounts
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 12, 2024 at 10:38=E2=80=AFPM Darrick J. Wong <djwong@kernel.org=
> wrote:
>
> On Wed, Dec 11, 2024 at 09:54:35AM +0100, Christoph Hellwig wrote:
> > From: Hans Holmberg <hans.holmberg@wdc.com>
> >
> > Introduce a reservation setting for rt devices so that zoned GC
> > reservations are preserved over remount ro/rw cycles.
> >
> > Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_mount.c | 22 +++++++++++++++-------
> >  fs/xfs/xfs_mount.h |  3 ++-
> >  fs/xfs/xfs_super.c |  2 +-
> >  3 files changed, 18 insertions(+), 9 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 4174035b2ac9..db910ecc1ed4 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -465,10 +465,15 @@ xfs_mount_reset_sbqflags(
> >  }
> >
> >  uint64_t
> > -xfs_default_resblks(xfs_mount_t *mp)
> > +xfs_default_resblks(
> > +     struct xfs_mount        *mp,
> > +     enum xfs_free_counter   ctr)
> >  {
> >       uint64_t resblks;
> >
> > +     if (ctr =3D=3D XC_FREE_RTEXTENTS)
> > +             return 0;
> > +
> >       /*
> >        * We default to 5% or 8192 fsbs of space reserved, whichever is
> >        * smaller.  This is intended to cover concurrent allocation
> > @@ -683,6 +688,7 @@ xfs_mountfs(
> >       uint                    quotamount =3D 0;
> >       uint                    quotaflags =3D 0;
> >       int                     error =3D 0;
> > +     int                     i;
> >
> >       xfs_sb_mount_common(mp, sbp);
> >
> > @@ -1051,18 +1057,20 @@ xfs_mountfs(
> >        * privileged transactions. This is needed so that transaction
> >        * space required for critical operations can dip into this pool
> >        * when at ENOSPC. This is needed for operations like create with
> > -      * attr, unwritten extent conversion at ENOSPC, etc. Data allocat=
ions
> > -      * are not allowed to use this reserved space.
> > +      * attr, unwritten extent conversion at ENOSPC, garbage collectio=
n
> > +      * etc. Data allocations are not allowed to use this reserved spa=
ce.
> >        *
> >        * This may drive us straight to ENOSPC on mount, but that implie=
s
> >        * we were already there on the last unmount. Warn if this occurs=
.
> >        */
> >       if (!xfs_is_readonly(mp)) {
> > -             error =3D xfs_reserve_blocks(mp, XC_FREE_BLOCKS,
> > -                             xfs_default_resblks(mp));
> > -             if (error)
> > -                     xfs_warn(mp,
> > +             for (i =3D 0; i < XC_FREE_NR; i++) {
> > +                     error =3D xfs_reserve_blocks(mp, i,
> > +                                     xfs_default_resblks(mp, i));
> > +                     if (error)
> > +                             xfs_warn(mp,
> >       "Unable to allocate reserve blocks. Continuing without reserve po=
ol.");
>
> Should we be able to log *which* reserve block pool is out?

Yep, that should be useful I think. We could do something like this:

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 20d564b3b564..6ef69d025f9a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -674,6 +674,10 @@ xfs_rtbtree_compute_maxlevels(
        mp->m_rtbtree_maxlevels =3D levels;
 }

+static const char * const xfs_free_pool_name[XC_FREE_NR] =3D {
+               "free blocks", "free rt extents", "available rt extents"
+};
+
 /*
  * This function does the following on an initial mount of a file system:
  *     - reads the superblock from disk and init the mount struct
@@ -1081,7 +1085,8 @@ xfs_mountfs(
                                        xfs_default_resblks(mp, i));
                        if (error)
                                xfs_warn(mp,
-       "Unable to allocate reserve blocks. Continuing without reserve pool=
.");
+"Unable to allocate reserve blocks. Continuing without reserve pool for %s=
.",
+                               xfs_free_pool_name[i]);
                }

                /* Reserve AG blocks for future btree expansion. */
