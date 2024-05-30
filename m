Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0E61CF94
	for <linux-xfs@vger.kernel.org>; Thu, 30 May 2024 03:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717038671; cv=none; b=T/QLWGQ33R/e4bdmnPADuOBKlYjbx1mIaLJSc8NiNeM/B1V7F9dRQ15T3PKCA65rX/AdmkqPzZ7+7zQfClUdF6eyJo1y07zjYpjOYlz0xsMNNkT5eUj84BItQtW6zyPNcXjWxfN9ep3dhx5OxARvq35dyg/sCQrKNosGHqScG2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717038671; c=relaxed/simple;
	bh=MS26ewq5Af4l2YDSMSyq/+H/66Q+VIFpOkyBtn0usu0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GNMZpSNyxp7g9ZhayzSZ74qm9qrJk0j1euZdbYewlqR63WVj0kppIS5kHCvEZsTkscCDjfzBPJro3J7NLy8fKW4O9ENjiw7Ncgm5B59O5wj/8sb95GDJatsqDqdqOgMqrJGkFWiLbzcb4EJvUBHaMv6pXeJShweEFZOmVR7JxVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fb6cA6Zg; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fb6cA6Zg"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-62a08091c2bso4512157b3.0
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2024 20:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717038668; x=1717643468; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+gFTiaHj0vVqREzuIhMS/ejU0qQA44MJosNolGvQfZ8=;
        b=fb6cA6ZgqrwPLfFC+bRfu8AB4olU4REdDZF138bSZGWVAtwyG4lpdeo+Oa0wdQDEjD
         a+rU7P9uaqHrPNVXNYohxyOUiZnvG2CmSRdc1HWEpzHRAaLR70qyQRc7Fxd6BdsWBRsF
         Y2mJDqjha4gpmnhWvv2UEWB8feJxi5xckIlns6pgtwmjlLhgPrlzgxoO3y/6ivWch8gY
         J4go/OOsv9FmyzpfXGJNuf8IjIraV6wH+Zzj7SgGSUl1ostp4LuAPP8YU50pW65lGQTf
         PsizX27Rb+2hTsivCH2qqQlvUbWZDm2r/nGeyRIUrcZk9wChNpubrksxSejqRxlqEoHE
         r6uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717038668; x=1717643468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+gFTiaHj0vVqREzuIhMS/ejU0qQA44MJosNolGvQfZ8=;
        b=MuH3fytjPJ9vMicBBGvp5BesFq7CknjlHs5LG58htSauBkC9Xxvny9+Z2heSd5I5oh
         fNcS5+0Fs0nGHKmkqznsHhZJ52i/pJwAJqVEKTi0XecNDpZNxK72WbAhyyqrNGfFYuiq
         OFjQTkZFlrlGqDrjPmNsXBv409vz7rGqF+P6EzJyBeRIQ2Pd0xj4Hmbp4YQOPTzpn+DD
         YGTNLF2Y5dGe5jsc9jbCcz7eYg5o/ZZ0Ppqchzrl+5fcjZ7jV6oxhKmFTje4Ssk2hcLp
         gljJ9cYEVUDNL6y+hvYBj9hiqcX+v90qkwJTjfhpbNdvbAbMvnWtxr5BICgwjMVToFcv
         AzJA==
X-Forwarded-Encrypted: i=1; AJvYcCVytTzkLNXlpZlyFlKl6swEgnV4EAU3fhQOwnl04Y4kZmP3LIHbmBqNSWCyJPFCR/l6Bi5aylxUu+rJpddMe512VPcUMoi4eAYd
X-Gm-Message-State: AOJu0YytrG9TOyfajKWm0T1UNNgsq6g22uDz527Z+fSqi2mgGx1C0zjn
	qUEgKt5vkmZMZ9rEjzUzLMai7ajjjXZbP1s3tTb8Gu/rXU0oof6nrX12pfVwigsjCkIKXCM7xXS
	PIieYmkGK6ndAir3Ps5dmivNKt/AzRiSBX/aomfeJ
X-Google-Smtp-Source: AGHT+IECnaKKcXqWFb2tETpBW6AGkbSI7TWffAf4CLY0jJRXIygbwJT4qOG4aUW5wiKtJ42czIo0/kK70CAC1+tF3XE=
X-Received: by 2002:a0d:ee87:0:b0:61e:a62:d8fc with SMTP id
 00721157ae682-62c6bc014f8mr10157657b3.20.1717038668270; Wed, 29 May 2024
 20:11:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240529225736.21028-1-llfamsec@gmail.com> <Zlfmu4/kVJxZ/J7B@dread.disaster.area>
In-Reply-To: <Zlfmu4/kVJxZ/J7B@dread.disaster.area>
From: lei lu <llfamsec@gmail.com>
Date: Thu, 30 May 2024 11:10:57 +0800
Message-ID: <CAEBF3_ayLsCJVPdZQCb=gHtiFCNG9C3xcGv4_cnUpmS8TQRdYw@mail.gmail.com>
Subject: Re: [PATCH] xfs: don't walk off the end of a directory data block
To: Dave Chinner <david@fromorbit.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, chandan.babu@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for your time.

I just add check for the fixed members because I see after the patch
code there is some checks for dup and dep. "offset +
be16_to_cpu(dup->length) > end" for dup and "offset +
xfs_dir2_data_entsize(mp, dep->namelen) > end" for dep.
=E2=80=9Cxfs_dir2_data_entsize(mp, dep->namelen)=E2=80=9D ensures the align=
ment of the
dep.

Dave Chinner <david@fromorbit.com> =E4=BA=8E2024=E5=B9=B45=E6=9C=8830=E6=97=
=A5=E5=91=A8=E5=9B=9B 10:38=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, May 30, 2024 at 06:57:36AM +0800, lei lu wrote:
> > This adds sanity checks for xfs_dir2_data_unused and xfs_dir2_data_entr=
y
> > to make sure don't stray beyond valid memory region. It just checks sta=
rt
> > offset < end without checking end offset < end.
>
> Well, it does do this checking, but it assumes that the dup/dep
> headers fit in the buffer because of entry size and alignment
> constraints.
>
> > So if last entry is
> > xfs_dir2_data_unused, and is located at the end of ag.
>
> Not sure what this means.
>
> > We can change
> > dup->length to dup->length-1 and leave 1 byte of space.
>
> Ah, so not a real-world issue in any way.
>
> Regardless, this is the corruption we are failing to catch.  All the
> structures in the directory name area should be 8 byte aligned, and
> we should be catching dup->length % XFS_DIR2_DATA_ALIGN !=3D 0 and
> reporting that as corruption.
>
> This also means that the smallest valid length for dup->length is
> xfs_dir2_data_entsize(mp, 1), except if it is the last entry in the
> block (i.e. at end - offset =3D=3D XFS_DIR2_DATA_ALIGN), in which case
> it may be XFS_DIR2_DATA_ALIGN bytes in length.
>
> IOWs, we're failing to check for both the alignment and the size
> constraints on the dup->length field, and that's the problem we need
> to fix to address the out of bounds read error being reported.
>
> Can you please rework the patch to catch the corruption you induced
> at the exact point we are processing the corrupt object, rather than
> try to catch an overrun that might happen several iterations after
> the corrupt object itself was processed?
>
> > In the next
> > traversal, this space will be considered as dup or dep. We may encounte=
r
> > an out-of-bound read when accessing the fixed members.
>
> Verifiers are supposed to validate each object in the structure is
> within specification, not be coded simply to prevent out of bounds
> accesses. i.e. if the next traversal trips over an out of bounds
> access, then one of the previous iobject verifications failed to
> detect an out of bounds value that it should not have missed.
>
> > Signed-off-by: lei lu <llfamsec@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_dir2_data.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_dat=
a.c
> > index dbcf58979a59..08c18e0c1baa 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_data.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> > @@ -178,6 +178,9 @@ __xfs_dir3_data_check(
> >               struct xfs_dir2_data_unused     *dup =3D bp->b_addr + off=
set;
> >               struct xfs_dir2_data_entry      *dep =3D bp->b_addr + off=
set;
> >
> > +             if (offset + sizeof(*dup) > end)
> > +                     return __this_address;
> > +
> >               /*
> >                * If it's unused, look for the space in the bestfree tab=
le.
> >                * If we find it, account for that, else make sure it
> > @@ -210,6 +213,10 @@ __xfs_dir3_data_check(
> >                       lastfree =3D 1;
> >                       continue;
> >               }
> > +
> > +             if (offset + sizeof(*dep) > end)
> > +                     return __this_address;
>
> That doesn't look correct - dep has a variable sized array and tail
> packed information in it that sizeof(*dep) doesn't take into
> account. The actual size of the dep structure we need to consider
> here is going to be a minimum sized entry -
> xfs_dir2_data_entsize(mp, 1) - as anything smaller than this size is
> definitely invalid and we shouldn't attempt to decode any of it.
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
