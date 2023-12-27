Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2289481A3
	for <linux-xfs@vger.kernel.org>; Wed, 27 Dec 2023 22:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="bq3sTd3X"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6dc049c7b58so626068a34.3
        for <linux-xfs@vger.kernel.org>; Wed, 27 Dec 2023 14:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1703714855; x=1704319655; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4XjCfuwK4BSZUVvwqfIb87l7mz/4WsDi89uAge/7Fo4=;
        b=bq3sTd3XB6DnPO8X43+ZW2F7C1Mg+5GMp8+7MvdPdXxxxra3OedkNpN1hZePpYz4HR
         j8ksN1r29cmK94MHpGBNdQqdCDA1bxgmPOSLf0QusV4fP2y4vrhaMMFs78Gb/tA8YimG
         AjSqStMQgCpQXbGUxiQdi/+4aAHgh4C5dcvQNJtGSevO5gTRO2wrqUzI4sf7qqmlsaPO
         mq0RJ4fm0CBF/lkHJG+tsHPcMjsRwYdzMlgfs49novVzsVGQt17acvv1OzDHhw6p8uLI
         n6rg3xfCds7TM6Yvhom8UxR/3L8flGWsnWQ9bb/2XO/pRElCBDnBVt/fMCCIISV58nUC
         +rDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703714855; x=1704319655;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4XjCfuwK4BSZUVvwqfIb87l7mz/4WsDi89uAge/7Fo4=;
        b=RP4hiO47oZ0it+H8HYdN1QRccbyTTcEdNS2FuN76kJ8GXTXXwTCRkEP62fngru57eQ
         fAVwpLzI8cxlQjg7gcY3EYXGgNmsY4AE+coaVpJ15qYI5hVbYc01gmEZVK22qVqeigZm
         5NgT0I7cJHJJ2NDEfMYGEmDNCenL83ndS54grCcqJ3knEo42H+mbgkD/f1Zr1SPfKto6
         weirKaQsKNi2Je//6OYMsLUJNFYlRsAnu8mRm0v2y2ZDTnktF1Q86SV7u4fz5sCFV/w8
         nhJYVXQq9ng/yIW/+dX4qY1xLOa28lZkttMMWhhh4Um7RmO0//Q1Js09Gc/tQnyb2A6e
         0oXQ==
X-Gm-Message-State: AOJu0Yx0twta24iP0tvyQgYkrq6Ry/KyTBPOTvzarWNWFMYIEsTcND5d
	qArmm2j75EWQOAwgVKwEGa396fm9r7X1Uuz5L2sLnHZt/SQ=
X-Google-Smtp-Source: AGHT+IHG30QZhOKgEmr9rzROymmfA5Dj5lfVopEbidhJL6YVi4kJwpXA6OrTytKhhUtpnR78f9CUAg==
X-Received: by 2002:a05:6870:80cf:b0:203:dcde:6e83 with SMTP id r15-20020a05687080cf00b00203dcde6e83mr11032104oab.65.1703714854804;
        Wed, 27 Dec 2023 14:07:34 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id bw6-20020a056a02048600b005cd8044c6fesm5532062pgb.23.2023.12.27.14.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Dec 2023 14:07:34 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rIc3m-002YuY-2L;
	Thu, 28 Dec 2023 09:07:30 +1100
Date: Thu, 28 Dec 2023 09:07:30 +1100
From: Dave Chinner <david@fromorbit.com>
To: Phillip Ferentinos <phillip.jf@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Metadata corruption detected, fatal error -- couldn't map inode,
 err = 117
Message-ID: <ZYygIuaQvNzwE09r@dread.disaster.area>
References: <CACf8WVvuBpDwMdTor_oGobAKG6ELyUMmm4-HAu--eTfZqF5+Yg@mail.gmail.com>
 <ZYs5MFJ4kc+0saVC@dread.disaster.area>
 <CACf8WVvA3qcDZ3O-Y_N4MH_W6zRFBES+tn4LudguwSwv9Zva+g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACf8WVvA3qcDZ3O-Y_N4MH_W6zRFBES+tn4LudguwSwv9Zva+g@mail.gmail.com>

On Wed, Dec 27, 2023 at 02:22:47PM -0600, Phillip Ferentinos wrote:
> On Tue, Dec 26, 2023 at 2:36 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Thu, Dec 21, 2023 at 08:05:43PM -0600, Phillip Ferentinos wrote:
> > > Hello,
> > >
> > > Looking for opinions on recovering a filesystem that does not
> > > successfully repair from xfs_repair.
> >
> > What version of xfs_repair?
> 
> # xfs_repair -V
> xfs_repair version 6.1.1
> 
> > > On the first xfs_repair, I was
> > > prompted to mount the disk to replay the log which I did successfully.
> > > I created an image of the disk with ddrescue and am attempting to
> > > recover the data. Unfortunately, I do not have a recent backup of this
> > > disk.
> >
> > There is lots of random damage all over the filesystem. What caused
> > this damage to occur? I generally only see this sort of widespread
> > damage when RAID devices (hardware or software) go bad...
> >
> > Keep in mind that regardless of whether xfs_repair returns the
> > filesystem to a consistent state, the data in the filesystem is
> > still going to be badly corrupted. If you don't have backups, then
> > there's a high probability of significant data loss here....
> 
> My best guess is a power outage causing an unclean shutdown. I am
> running Unraid:
> # uname -a
> Linux Tower 6.1.64-Unraid #1 SMP PREEMPT_DYNAMIC Wed Nov 29 12:48:16
> PST 2023 x86_64 Intel(R) Xeon(R) CPU E5-2650 v4 @ 2.20GHz GenuineIntel
> GNU/Linux

I think you are largely on your own, then, in terms of recovering
from this. I'd guess that the proprietary RAID implementation is not
power-fail safe....


> I was able to load the disk img in UFS Explorer on an Ubuntu machine
> and, as far as I can tell, all the data is in the img but it reports a
> handful of bad objects.
> https://github.com/phillipjf/xfs_debug/blob/main/ufs-explorer.png

AFAICT, that doesn't tell you that the data in the files is intact,
just that it can access them.

Keep in mind that whilst UFS-explorer reports ~321000 files in the
filesystem, the superblock state reported by phase 2 of xfs_repair
that there should be ~405000 files and directories in the filesystem
(icount - ifree):

....
sb_icount 407296, counted 272960
sb_ifree 2154, counted 1676
....

So, at minimum the damage to the inode btrees indicates that records
for ~130000 allocated files are missing from the inode btrees, and
that there should be ~80,000 more files present than UFS-explorer
found. IOWs, be careful trusting what UFS explorer tells you is
present - it looks like it may not have found a big chunk of the
data present that xfs_repair was trying to recover (and probably
going to attach to lost+found) when it crashed.

> > > The final output of xfs_repair is:
> > >
> > > Phase 5 - rebuild AG headers and trees...
> > >         - reset superblock...
> > > Phase 6 - check inode connectivity...
> > >         - resetting contents of realtime bitmap and summary inodes
> > >         - traversing filesystem ...
> > > rebuilding directory inode 12955326179
> > > Metadata corruption detected at 0x46fa05, inode 0x38983bd88 dinode
> >
> > Can you run 'gdb xfs_repair' and run the command 'l *0x46fa05' to
> > dump the line of code that the error was detected at? You probably
> > need the distro debug package for xfsprogs installed to do this.
> 
> At first try, doesn't look like gdb is available on Unraid and I think
> it would be more trouble than it's worth to get it set up.
> ---
> On the Ubuntu machine, I have
> # xfs_repair -V
> xfs_repair version 6.1.1
> 
> When running gdb on Ubuntu, I get:
> $ gdb xfs_repair
> (gdb) set args -f /media/sdl1.img
> (gdb) run
> ...
> Metadata corruption detected at 0x5555555afd95, inode 0x38983bd88 dinode
> 
> fatal error -- couldn't map inode 15192014216, err = 117
> ...
> (gdb) l *0x5555555afd95
> 0x5555555afd95 is in libxfs_dinode_verify (../libxfs/xfs_inode_buf.c:586).
> Downloading source file
> /build/xfsprogs-QBD5z8/xfsprogs-6.3.0/repair/../libxfs/xfs_inode_buf.c
> 581     ../libxfs/xfs_inode_buf.c: No such file or directory.


580         /* don't allow reflink/cowextsize if we don't have reflink */
581         if ((flags2 & (XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)) &&
582              !xfs_has_reflink(mp))
583                 return __this_address;
584
585         /* only regular files get reflink */
586         if ((flags2 & XFS_DIFLAG2_REFLINK) && (mode & S_IFMT) != S_IFREG)
587                 return __this_address;
588

From the inode dump:

v3.flags2 = 0x8

Which is XFS_DIFLAG2_BIGTIME, so neither the REFLINK or COWEXTSIZE
flags are set. That means repair has changed the state of the inode
in memory if we've got the REFLINK flag set.

And there we are. After junking a number of blocks in the directory
because of bad magic numbers in phase 4, repair does this:

setting reflink flag on inode 15192014216

Which implies that there the multiple references to at least one of
the data blocks in the directory. This should not be allowed, so
the problem here is that repair is marking the directory inode as
having shared extents when this is not allowed. Hence we trip over
the inconsistency when rebuilding the directory and abort.

Ok, so that's a bug in the reflink state rebuild code - we should be
checking that inodes that shared extents have been found for are
regular files and if they aren't removing the block from the inode.

I'll look at this in a couple of weeks when I'm back from holidays
if our resident reflink expert (Darrick) doesn't get to it first....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
