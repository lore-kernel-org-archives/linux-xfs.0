Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A1E47F54
	for <linux-xfs@vger.kernel.org>; Wed, 27 Dec 2023 20:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wx9ONmKW"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3bb89215406so3824546b6e.1
        for <linux-xfs@vger.kernel.org>; Wed, 27 Dec 2023 12:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703708603; x=1704313403; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P7+vbV+SnPoWRXNfBBTz+Pms5Mxhhou78klCjMgy4z8=;
        b=Wx9ONmKWmxblWm+YYzYpCM42X6vmbYW2eB8hM6CJHw0LxsZX7WBGkK96Y2fyfX35NE
         3LTV+b0hF3+rpyLzPiGFF/RtoCfnAP2r0JqDAjHaRtx+cQ2pjsEkdfX8RWZW9ty+Gd8I
         Vdl9TI4yVYrl0UQt3WOwTvklo9snXJJt/C5fIRtaYVVXi1I33UTEuKliJNxglEPuOIpm
         yo4QgZ7qKj1emOnGZ73tsSRTiVKMOn7PYzZeuy88FJUt1HJ0sxokLEwVP2n7Iza1j4f2
         aMpKMs5kKVLvxMlog6HJxY4PgtzgdHKL+fwAG2xfAZ/VYL380+2Bbu4CdXh2ZJhzhOSY
         EJkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703708603; x=1704313403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P7+vbV+SnPoWRXNfBBTz+Pms5Mxhhou78klCjMgy4z8=;
        b=lBKlKdLzTK8/kD4r18mgnq7m7xaCF4FX81Iu1t6uhF/PWYA+GjfHSYpFnUO4MpJI6O
         WSwDWAsvQ2otwMaY6p7BSyPpG+LjGwQtAjl2NH2fpxeQZlViHAJRrld62kQei6oFtY5p
         rXcaDTb8m51mqSPQauglRu1rhW1MzrcMhtsCRkQIkzledUjtkWZCbUWUMwcFWxQkuvtJ
         +mwnLeDDm0n09MVUjVru5lv1ZqqectcRsKIHBZrdThxPA+u7YLJAY4KiBKTXwGXmgSK+
         ms2JCK750BOmQvxZehAo47Ip091gDrfOIZILADS4zbUdoMyg965IozD5sm7bZoqqaIwF
         rNEw==
X-Gm-Message-State: AOJu0Yw1NhIZjHs55D/b8k/eO1mmL1je9Him3w/OInjUWBDMjoObdXsI
	V9xm78QLBYpBirB0fFKDYxxkc5MHRsa1nK3zEftL68CJdiY=
X-Google-Smtp-Source: AGHT+IEyWjteHQ4yDwagY80qM4z4h/q/yksE0fbk7zQI/BFJHSW/rD3rui9PiWZZQWl8Ix3DtpQaCRYPtnqSw7pmDhg=
X-Received: by 2002:a05:6808:3c46:b0:3bb:bf62:2f8f with SMTP id
 gl6-20020a0568083c4600b003bbbf622f8fmr4026563oib.45.1703708603638; Wed, 27
 Dec 2023 12:23:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACf8WVvuBpDwMdTor_oGobAKG6ELyUMmm4-HAu--eTfZqF5+Yg@mail.gmail.com>
 <ZYs5MFJ4kc+0saVC@dread.disaster.area>
In-Reply-To: <ZYs5MFJ4kc+0saVC@dread.disaster.area>
From: Phillip Ferentinos <phillip.jf@gmail.com>
Date: Wed, 27 Dec 2023 14:22:47 -0600
Message-ID: <CACf8WVvA3qcDZ3O-Y_N4MH_W6zRFBES+tn4LudguwSwv9Zva+g@mail.gmail.com>
Subject: Re: Metadata corruption detected, fatal error -- couldn't map inode,
 err = 117
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 26, 2023 at 2:36=E2=80=AFPM Dave Chinner <david@fromorbit.com> =
wrote:
>
> On Thu, Dec 21, 2023 at 08:05:43PM -0600, Phillip Ferentinos wrote:
> > Hello,
> >
> > Looking for opinions on recovering a filesystem that does not
> > successfully repair from xfs_repair.
>
> What version of xfs_repair?

# xfs_repair -V
xfs_repair version 6.1.1

> > On the first xfs_repair, I was
> > prompted to mount the disk to replay the log which I did successfully.
> > I created an image of the disk with ddrescue and am attempting to
> > recover the data. Unfortunately, I do not have a recent backup of this
> > disk.
>
> There is lots of random damage all over the filesystem. What caused
> this damage to occur? I generally only see this sort of widespread
> damage when RAID devices (hardware or software) go bad...
>
> Keep in mind that regardless of whether xfs_repair returns the
> filesystem to a consistent state, the data in the filesystem is
> still going to be badly corrupted. If you don't have backups, then
> there's a high probability of significant data loss here....

My best guess is a power outage causing an unclean shutdown. I am
running Unraid:
# uname -a
Linux Tower 6.1.64-Unraid #1 SMP PREEMPT_DYNAMIC Wed Nov 29 12:48:16
PST 2023 x86_64 Intel(R) Xeon(R) CPU E5-2650 v4 @ 2.20GHz GenuineIntel
GNU/Linux

I was able to load the disk img in UFS Explorer on an Ubuntu machine
and, as far as I can tell, all the data is in the img but it reports a
handful of bad objects.
https://github.com/phillipjf/xfs_debug/blob/main/ufs-explorer.png

> > The final output of xfs_repair is:
> >
> > Phase 5 - rebuild AG headers and trees...
> >         - reset superblock...
> > Phase 6 - check inode connectivity...
> >         - resetting contents of realtime bitmap and summary inodes
> >         - traversing filesystem ...
> > rebuilding directory inode 12955326179
> > Metadata corruption detected at 0x46fa05, inode 0x38983bd88 dinode
>
> Can you run 'gdb xfs_repair' and run the command 'l *0x46fa05' to
> dump the line of code that the error was detected at? You probably
> need the distro debug package for xfsprogs installed to do this.

At first try, doesn't look like gdb is available on Unraid and I think
it would be more trouble than it's worth to get it set up.
---
On the Ubuntu machine, I have
# xfs_repair -V
xfs_repair version 6.1.1

When running gdb on Ubuntu, I get:
$ gdb xfs_repair
(gdb) set args -f /media/sdl1.img
(gdb) run
...
Metadata corruption detected at 0x5555555afd95, inode 0x38983bd88 dinode

fatal error -- couldn't map inode 15192014216, err =3D 117
...
(gdb) l *0x5555555afd95
0x5555555afd95 is in libxfs_dinode_verify (../libxfs/xfs_inode_buf.c:586).
Downloading source file
/build/xfsprogs-QBD5z8/xfsprogs-6.3.0/repair/../libxfs/xfs_inode_buf.c
581     ../libxfs/xfs_inode_buf.c: No such file or directory.

> > fatal error -- couldn't map inode 15192014216, err =3D 117
> >
> > The full log is:
> > https://raw.githubusercontent.com/phillipjf/xfs_debug/main/xfs_repair_1=
.log
>
> That's messy.
>
> > Based on another discussion (https://narkive.com/4dDxIees.10), I've
> > included the specific inode:
> > https://raw.githubusercontent.com/phillipjf/xfs_debug/main/xfs_db_01.lo=
g
>
> Nothing obviously wrong with that inode in the image file - it's a
> directory inode in node format that looks to be internally
> consistent.  But that inode has been processed earlier in the repair
> process, so maybe it's bad in memory as a result of trying to fix
> some other problem. Very hard to say given how much other stuff is
> broken and is getting either trashed, re-initialised or repaired up
> to that point....
>
> > I also cannot create a metadump due to the following issue:
> > https://raw.githubusercontent.com/phillipjf/xfs_debug/main/xfs_metadump=
_01.log.
>
> No surprise, metadump has to traverse the metadata in order to dump
> it, and if the metadata is corrupt then the traversals can fail
> leading to a failed dump. The more badly damaged the filesystem is,
> the more likely a metadump failure is.
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com

I only had one extra 12TB drive on hand which currently has the .img
of the bad drive on it. Have some 10TB drives on order which should
give enough space to restore data with UFS Explorer and, if so, will
resolve all these issues. But, possibly, this information is helpful
for development.

Thanks for the help! Please let me know what more info I can provide.
- Phillip Ferentinos
