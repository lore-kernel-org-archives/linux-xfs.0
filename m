Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A2B10F9
	for <linux-xfs@vger.kernel.org>; Thu, 28 Dec 2023 03:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RLvKITnk"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-67f85fe5632so40907216d6.0
        for <linux-xfs@vger.kernel.org>; Wed, 27 Dec 2023 19:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703734487; x=1704339287; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wr/6i3uGtcBq2lmSnovedN/Aqra8mhiHNkpAabp/kic=;
        b=RLvKITnkxaLAC3pI+eoqV5qCKu9n9JYhyNtXQJW1bNmxXa7d+GG0GPjcbsPp+wKMBE
         jXjND0yC/IZScfbjDVyfhuwtvQuGlsFwowvBf/WpEKGinBBgRwhkgJpuih73SvKB9UO4
         YhHxCTUBsNrZlSXaj3pgSALtqEzWfuKSzEz9SgfCx5fMP9nnOoF33+4JwhL7fl4yOUH6
         9q3GEIkJh/F38rcwMoA9g5iezTVeXhSiboAFbRGQmcW+VugVmBs9MBJFSW47CVXGub3j
         tXIqonHftGw2tfRLxqeNn3zJCdQkmbI7bSNf0jas5J2M08g4KuHua0iDp2uG3rxvw2eb
         /r2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703734487; x=1704339287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wr/6i3uGtcBq2lmSnovedN/Aqra8mhiHNkpAabp/kic=;
        b=JHmH6HtVhij2bnwhqA2msvdmnaqOT6n+bsmxbz/A4aZw6BviOkhoxlAUT5txJwdn5S
         TpZjeha+/5g8jnH6fFFhG+I+1QhvrLrtfd4fjITcb1BZaXBzf9ZXQDlLCbP8uM3Q9VvZ
         VTM7avSCH1WOtQg2xefMZPGiDM91bpF3q/PiVAwO/EiHKkkh34UB1KpF1XApU+2cr7D5
         iw+OIiddPaota/I+TG2VyFeV17rff55AJP8zK7Bfz+HMALxKpbLNCKZsiruNGmlKmGXs
         0c7H/ncbJ9vkqdZ8BfEnuVN5Bej+JfZ3o7jAFXiFCCwRiH/+QDN9BRKePJZ+SxurTtXP
         tuoQ==
X-Gm-Message-State: AOJu0YxwkYV1jp79HryQbgjQLNne8EsddZugOCuexwOQIzNVt3LoA/cY
	Sfh89w+ZdvtCfPchyze+2dHO+Hqpp+IyJohku4k=
X-Google-Smtp-Source: AGHT+IH81K7wEo+3NoH8SmXa77ohcNv8r9WEzYYsXkkasHWZzjl+VAAv4u3y5dKHZdTwApNaG18g62oWZ5U/ZzDIxhI=
X-Received: by 2002:ad4:5b8e:0:b0:67c:cfba:5098 with SMTP id
 14-20020ad45b8e000000b0067ccfba5098mr15778103qvp.43.1703734486676; Wed, 27
 Dec 2023 19:34:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACf8WVvuBpDwMdTor_oGobAKG6ELyUMmm4-HAu--eTfZqF5+Yg@mail.gmail.com>
 <ZYs5MFJ4kc+0saVC@dread.disaster.area> <CACf8WVvA3qcDZ3O-Y_N4MH_W6zRFBES+tn4LudguwSwv9Zva+g@mail.gmail.com>
 <ZYygIuaQvNzwE09r@dread.disaster.area>
In-Reply-To: <ZYygIuaQvNzwE09r@dread.disaster.area>
From: Phillip Ferentinos <phillip.jf@gmail.com>
Date: Wed, 27 Dec 2023 21:34:10 -0600
Message-ID: <CACf8WVuHtDoJS1x5XzvBV99Z6Gp7bqbwDT4QsKsJrETtyyvFTg@mail.gmail.com>
Subject: Re: Metadata corruption detected, fatal error -- couldn't map inode,
 err = 117
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 27, 2023 at 4:07=E2=80=AFPM Dave Chinner <david@fromorbit.com> =
wrote:
>
> On Wed, Dec 27, 2023 at 02:22:47PM -0600, Phillip Ferentinos wrote:
> > On Tue, Dec 26, 2023 at 2:36=E2=80=AFPM Dave Chinner <david@fromorbit.c=
om> wrote:
> > >
> > > On Thu, Dec 21, 2023 at 08:05:43PM -0600, Phillip Ferentinos wrote:
> > > > Hello,
> > > >
> > > > Looking for opinions on recovering a filesystem that does not
> > > > successfully repair from xfs_repair.
> > >
> > > What version of xfs_repair?
> >
> > # xfs_repair -V
> > xfs_repair version 6.1.1
> >
> > > > On the first xfs_repair, I was
> > > > prompted to mount the disk to replay the log which I did successful=
ly.
> > > > I created an image of the disk with ddrescue and am attempting to
> > > > recover the data. Unfortunately, I do not have a recent backup of t=
his
> > > > disk.
> > >
> > > There is lots of random damage all over the filesystem. What caused
> > > this damage to occur? I generally only see this sort of widespread
> > > damage when RAID devices (hardware or software) go bad...
> > >
> > > Keep in mind that regardless of whether xfs_repair returns the
> > > filesystem to a consistent state, the data in the filesystem is
> > > still going to be badly corrupted. If you don't have backups, then
> > > there's a high probability of significant data loss here....
> >
> > My best guess is a power outage causing an unclean shutdown. I am
> > running Unraid:
> > # uname -a
> > Linux Tower 6.1.64-Unraid #1 SMP PREEMPT_DYNAMIC Wed Nov 29 12:48:16
> > PST 2023 x86_64 Intel(R) Xeon(R) CPU E5-2650 v4 @ 2.20GHz GenuineIntel
> > GNU/Linux
>
> I think you are largely on your own, then, in terms of recovering
> from this. I'd guess that the proprietary RAID implementation is not
> power-fail safe....
>
>
> > I was able to load the disk img in UFS Explorer on an Ubuntu machine
> > and, as far as I can tell, all the data is in the img but it reports a
> > handful of bad objects.
> > https://github.com/phillipjf/xfs_debug/blob/main/ufs-explorer.png
>
> AFAICT, that doesn't tell you that the data in the files is intact,
> just that it can access them.
>
> Keep in mind that whilst UFS-explorer reports ~321000 files in the
> filesystem, the superblock state reported by phase 2 of xfs_repair
> that there should be ~405000 files and directories in the filesystem
> (icount - ifree):
>
> ....
> sb_icount 407296, counted 272960
> sb_ifree 2154, counted 1676
> ....
>
> So, at minimum the damage to the inode btrees indicates that records
> for ~130000 allocated files are missing from the inode btrees, and
> that there should be ~80,000 more files present than UFS-explorer
> found. IOWs, be careful trusting what UFS explorer tells you is
> present - it looks like it may not have found a big chunk of the
> data present that xfs_repair was trying to recover (and probably
> going to attach to lost+found) when it crashed.
>

Thanks for the heads up! Once the new drives get here, I'll try moving
the data out via UFS explorer and merged back into the shares. Based
on what UFS explorer _is_ showing me, most of the important files are
recoverable. There are a handful of directories I'd expect there to be
thousands of files (specifically like the `previews` folder in the
screenshot) which are not critical.

> > > > The final output of xfs_repair is:
> > > >
> > > > Phase 5 - rebuild AG headers and trees...
> > > >         - reset superblock...
> > > > Phase 6 - check inode connectivity...
> > > >         - resetting contents of realtime bitmap and summary inodes
> > > >         - traversing filesystem ...
> > > > rebuilding directory inode 12955326179
> > > > Metadata corruption detected at 0x46fa05, inode 0x38983bd88 dinode
> > >
> > > Can you run 'gdb xfs_repair' and run the command 'l *0x46fa05' to
> > > dump the line of code that the error was detected at? You probably
> > > need the distro debug package for xfsprogs installed to do this.
> >
> > At first try, doesn't look like gdb is available on Unraid and I think
> > it would be more trouble than it's worth to get it set up.
> > ---
> > On the Ubuntu machine, I have
> > # xfs_repair -V
> > xfs_repair version 6.1.1
> >
> > When running gdb on Ubuntu, I get:
> > $ gdb xfs_repair
> > (gdb) set args -f /media/sdl1.img
> > (gdb) run
> > ...
> > Metadata corruption detected at 0x5555555afd95, inode 0x38983bd88 dinod=
e
> >
> > fatal error -- couldn't map inode 15192014216, err =3D 117
> > ...
> > (gdb) l *0x5555555afd95
> > 0x5555555afd95 is in libxfs_dinode_verify (../libxfs/xfs_inode_buf.c:58=
6).
> > Downloading source file
> > /build/xfsprogs-QBD5z8/xfsprogs-6.3.0/repair/../libxfs/xfs_inode_buf.c
> > 581     ../libxfs/xfs_inode_buf.c: No such file or directory.
>
>
> 580         /* don't allow reflink/cowextsize if we don't have reflink */
> 581         if ((flags2 & (XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE))=
 &&
> 582              !xfs_has_reflink(mp))
> 583                 return __this_address;
> 584
> 585         /* only regular files get reflink */
> 586         if ((flags2 & XFS_DIFLAG2_REFLINK) && (mode & S_IFMT) !=3D S_=
IFREG)
> 587                 return __this_address;
> 588
>
> From the inode dump:
>
> v3.flags2 =3D 0x8
>
> Which is XFS_DIFLAG2_BIGTIME, so neither the REFLINK or COWEXTSIZE
> flags are set. That means repair has changed the state of the inode
> in memory if we've got the REFLINK flag set.
>
> And there we are. After junking a number of blocks in the directory
> because of bad magic numbers in phase 4, repair does this:
>
> setting reflink flag on inode 15192014216
>
> Which implies that there the multiple references to at least one of
> the data blocks in the directory. This should not be allowed, so
> the problem here is that repair is marking the directory inode as
> having shared extents when this is not allowed. Hence we trip over
> the inconsistency when rebuilding the directory and abort.
>
> Ok, so that's a bug in the reflink state rebuild code - we should be
> checking that inodes that shared extents have been found for are
> regular files and if they aren't removing the block from the inode.
>
> I'll look at this in a couple of weeks when I'm back from holidays
> if our resident reflink expert (Darrick) doesn't get to it first....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

Thanks again, especially for the quick response. I plan to keep the
original disk and the disk with the .img out of the array for some
time so when/if you do look back into this, I'm more than happy to
test anything or provide information (I like to think I'm fairly
technical, but I might need a bit more detailed instructions if it
gets complicated...).

Enjoy your holidays!
- Phillip Ferentinos
