Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957613081B7
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 02:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760494226; cv=none; b=fqFwy8Uf0jOaKA0QTEz20c3HvNDbVEPNwSs0t3AOr99OuTNuRll8t/9cP7TmUSaGsvmMJ3bfY2Nhh9028m2km7kYEyVyMysgXFTAi3VhpoujOh9lnT+mMeidGvbTPM5RRDIFyJHxweH2UEKDu4JlDJ/6PYKzK67mXzD0UbO3qSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760494226; c=relaxed/simple;
	bh=D54eOCSdeufYDLdWrbR8Ycvs+NXgYkk492AJPpiaEtk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CFglby256Jh+zj3xB8AxFm25Z+OD1P1eQoFiS1Vw6aASszLUYGml9SA7UxjCrsggUdBL0payWGmcqyRJtH4waTEymPRD6gPMXj30Hq/gh8EWo3tKPxXevLycyhsxr3Gsny12HPYuLGS5zOBkv+20kvZ/3X598r+RonarlFGRWnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mowiwkkc; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mowiwkkc"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b3b27b50090so1110116966b.0
        for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 19:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760494223; x=1761099023; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tf2fQ0gJbCyc+H10TcghIqVsJ4/+Biafcb9EsAvZcl0=;
        b=MowiwkkcodcqOn3cLNQ53GZ+9sNXYdLITsBEgjBYyf58FCn4C2SWwlrpwlscUEMZxa
         Ynrd8Q2jr8OtSHhjhGCMPeZA4guwEyuIjNzoPD0bE6snbgD1RTt+ePHugQ6cLGrH5Hjp
         v6sVG5OeSm/+Wxs2O5ZU1KuEfgIqDCWUacoF6VHfAGuHQm5kapU03WTYZhr6OCb+SfXW
         DCmk7awp025eXX8jqBH7e39fk4dhFuAev+jWfnge+3ESHl8zMMWTXAZeimi+5keg+Dre
         cvw4LcLebikcTGi27kqRxfnLnebb8HYhEdD618c8zjYIW0PZBVehr7N7hLT3v42tTOnb
         WReA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760494223; x=1761099023;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tf2fQ0gJbCyc+H10TcghIqVsJ4/+Biafcb9EsAvZcl0=;
        b=a7EwUOhiPH+XFqzbVs6OYNBJ3CuWYNLptTE35rnCEPMNI16hgUtPfuetBI1101z7cL
         a+9i/fREW2iPwhvSAVS2yu2WoTcqSbgVHNp2tAb5hiKzSfIjWooz+v+kDV3ucYqnOBvj
         sCq81e2C9k6UV/Nu9WFW8/fIDIT2JdE1uTgZHA9DGOLJi8w/7PRpGStTGU4EKz8H0WDX
         M0P8Jjn2phSW76V8gNk2g7AB7bgywOqAYtOYhdMU5KXhHx8oKLNMoADeBA6kNi/cnNgV
         euzfnSUpp7S2QgA8wuPhl95dNlQ6HHpOWi65uCqtkyMKL6h617VJ+X3gLuT5djtmzucz
         BlPA==
X-Forwarded-Encrypted: i=1; AJvYcCWNhmz3NFv0GS75Bz5IfzYGg3ilzFLFe/I5q3K1cL78WSVLI/KZABX7CVppo4gFfM1nLlCXCfIEBH0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlBLAe1WDj9hS6TBd9NvQig1J5Nbz4lRfAIOimbSD7RMt7ys6s
	DJEIX4gInRp+BNVBfDvtdg/7uRBKiSfUZ0Lgry2fbCV24hnJ/BeEHva5aqmatk8q1M3WPosMAlP
	CIZFCFL5KP1sd/d+QmcVVkgjuzYTDBvQ=
X-Gm-Gg: ASbGnctORxXoqLmDiHQ8tkH2LxlyaZ1r4bPDj7cvUS/ULYXDcjHrsF9JZDkZ2lsao+I
	nv4Z82uWq+dF9TfdUwlAIfInQvwGJQBSdyktZDyPkmtA8YvDgpJy8cUYiN1IYknDu5q3Qcfex2z
	xWYEON9H+VFld1hYwaMTiZZKy6wgOxQ3a0m9LFPLTvPR3yUWb6P/jyLEHVikaGCHZ0enz92qJu1
	ADU9TkFR6omBhtqcGrmoxv6upbpI7LAPqI1bnlOp5Iy60mMtGglZ45zGg==
X-Google-Smtp-Source: AGHT+IHdVVEm39YWzMl1LNpGiBlqkvaUyflBG1tNW6GMG9o/ZGDg1s+GsqNDZBzZGU20lHi3/5OtOSjsi5i+koqZYh4=
X-Received: by 2002:a17:906:ef05:b0:b4e:d6e3:1670 with SMTP id
 a640c23a62f3a-b50aa48ca83mr2928920266b.11.1760494222641; Tue, 14 Oct 2025
 19:10:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251009075929.1203950-1-mjguzik@gmail.com> <20251009075929.1203950-14-mjguzik@gmail.com>
 <ua3koqbakm6e4dpbzfmhei2evc566c5p2t65nsvmlab5yyibxu@u6zp4pwex5s7>
 <CAGudoHGckJHiWN9yCngP1JMGNa1PPNvnpSuriCxSM1mwWhpBUQ@mail.gmail.com> <aO7khoBHdfPlEBAE@dread.disaster.area>
In-Reply-To: <aO7khoBHdfPlEBAE@dread.disaster.area>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 15 Oct 2025 04:10:10 +0200
X-Gm-Features: AS18NWA6lCnHDvapi5wh7WY086sFtNru8nAF8St7zzP5vFF3dZCD2VdTn7VIJY4
Message-ID: <CAGudoHHY2ZpSjYda94FZos8jRsaqZ_XcR7ZDDuY0AgvbnvehyQ@mail.gmail.com>
Subject: Re: [PATCH v7 13/14] xfs: use the new ->i_state accessors
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, brauner@kernel.org, viro@zeniv.linux.org.uk, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	josef@toxicpanda.com, kernel-team@fb.com, amir73il@gmail.com, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 15, 2025 at 2:02=E2=80=AFAM Dave Chinner <david@fromorbit.com> =
wrote:
>
> On Fri, Oct 10, 2025 at 05:40:49PM +0200, Mateusz Guzik wrote:
> > On Fri, Oct 10, 2025 at 4:41=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
> > >
> > > On Thu 09-10-25 09:59:27, Mateusz Guzik wrote:
> > > > Change generated with coccinelle and fixed up by hand as appropriat=
e.
> > > >
> > > > Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> > >
> > > ...
> > >
> > > > @@ -2111,7 +2111,7 @@ xfs_rename_alloc_whiteout(
> > > >        */
> > > >       xfs_setup_iops(tmpfile);
> > > >       xfs_finish_inode_setup(tmpfile);
> > > > -     VFS_I(tmpfile)->i_state |=3D I_LINKABLE;
> > > > +     inode_state_set_raw(VFS_I(tmpfile), I_LINKABLE);
> > > >
> > > >       *wip =3D tmpfile;
> > > >       return 0;
> > > > @@ -2330,7 +2330,7 @@ xfs_rename(
> > > >                * flag from the inode so it doesn't accidentally get=
 misused in
> > > >                * future.
> > > >                */
> > > > -             VFS_I(du_wip.ip)->i_state &=3D ~I_LINKABLE;
> > > > +             inode_state_clear_raw(VFS_I(du_wip.ip), I_LINKABLE);
> > > >       }
> > > >
> > > >  out_commit:
> > >
> > > These two accesses look fishy (not your fault but when we are doing t=
his
> > > i_state exercise better make sure all the places are correct before
> > > papering over bugs with _raw function variant). How come they cannot =
race
> > > with other i_state modifications and thus corrupt i_state?
> > >
> >
> > I asked about this here:
> > https://lore.kernel.org/linux-xfs/CAGudoHEi05JGkTQ9PbM20D98S9fv0hTqpWRd=
5fWjEwkExSiVSw@mail.gmail.com/
>
> Yes, as I said, we can add locking here if necessary, but locking
> isn't necessary at this point in time because nothing else can
> change the state of the newly allocated whiteout inode until we
> unlock it.
>

I don't have much of an opinion about this bit. Not as per my response
I added routines to facilitate not taking the lock (for the time being
anyway).

> Keep in mind the reason why we need I_LINKABLE here - it's not
> needed for correctness - it's needed to avoid a warning embedded
> in inc_nlink() because filesystems aren't trusted to implement
> link counts correctly anymore.

Ok, I did not know that. Maybe I'll take a stab at sorting this out.

xfs aside, for unrelated reasons I was looking at the placement of the
indicator to begin with. Seems like for basic correctness this in fact
wants the inode lock (not the spin lock) and the spin lock is only
taken to synchronize against other spots which modify i_state. Perhaps
it should move, which would also obsolete the above woes.

> Now we're being told that "it is too dangerous to let filesystems
> manage inode state themselves" and so we have to add extra overhead
> to code that we were forced to add to avoid VFS warnings added
> because the VFS doesn't trust filesystems to maintain some other
> important inode state....
>

Given that this is how XFS behaved for a long time now and that
perhaps the I_LINKABLE handling can be redone in the first place,
perhaps Jan will be willing to un-NAK this bit.

> So, if you want to get rid of XFS using I_LINKABLE here, please fix
> the nlink VFS api to allow us to call inc_nlink_<something>() on a
> zero link inode without I_LINKABLE needing to be set. We do actually
> know what we are doing here, and as such needing I_LINKABLE here is
> nothing but a hacky workaround for inflexible, trustless VFS APIs...
>
> > > > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > > > index caff0125faea..ad94fbf55014 100644
> > > > --- a/fs/xfs/xfs_iops.c
> > > > +++ b/fs/xfs/xfs_iops.c
> > > > @@ -1420,7 +1420,7 @@ xfs_setup_inode(
> > > >       bool                    is_meta =3D xfs_is_internal_inode(ip)=
;
> > > >
> > > >       inode->i_ino =3D ip->i_ino;
> > > > -     inode->i_state |=3D I_NEW;
> > > > +     inode_state_set_raw(inode, I_NEW);
>
> "set" is wrong and will introduce a regression. This must be an
> "add" operation as inode->i_state may have already been modified
> by the time we get here.

There were complaints about original naming and _add/_del/_set got
whacked. So now this settled on _set/_clear/_assign, per the cheat
sheet in the patch. So this does what it was supposed to.
