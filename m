Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 23:20:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9M6Ks5d028580
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 23:20:54 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A318252B38E
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 23:22:37 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159]) by cuda.sgi.com with ESMTP id ugOoVkEh4hSzby7M for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 23:22:37 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id l26so218720fgb.8
        for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 23:22:36 -0700 (PDT)
Message-ID: <934a72850810212322o205fecd3ya21b6306dc726f2@mail.gmail.com>
Date: Wed, 22 Oct 2008 08:22:36 +0200
From: "Johan Stenehall" <stenehall@gmail.com>
Subject: Re: Partition seems to have been zero:ed. For no reason.
In-Reply-To: <20081021212158.GN25906@disturbed>
MIME-Version: 1.0
References: <934a72850810211111g20accf8ey74f0bfb8ecf38532@mail.gmail.com>
	 <20081021212158.GN25906@disturbed>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Johan Stenehall <stenehall@gmail.com>, xfs@oss.sgi.com

No LVM and since I don't know what MD are I guess not. It was a plain
parition created with mkfs.xfs and fdisk.
And no, no backups of the current partition, don't have enough diskspace
anywere do to a hd backup and dvd's take to long time to burn. But nothing
that importent was destroyed, it'l just take time to flac the cds again :).

The same problem with UUID's stoping to work happend a year ago when
upgrading kernal, so that is nothing new with ubuntu. That time I didn't
lose any information.

Thanks for the replay!

// Johan


2008/10/21 Dave Chinner <david@fromorbit.com>

> On Tue, Oct 21, 2008 at 08:11:50PM +0200, Johan Stenehall wrote:
> > After a kernal upgrade My UUIDs in /etc/fstab stoped working so I changed
> > them to /dev/sd* When rebooting again /dev/sdb2 didn't want to mount. I
> > tried to manualy mount it without success and tried to run a xfs_repair
> on
> > it. Got the following: http://pastebin.com/m44d3aa47
>
> Are you using LVM or MD? i.e. did a volume get re-assembled
> incorrectly and hence the XFS tools saw random fragments of a
> filesystem?
>
> > After that the partition still didn't want to mount. Had to overwrite the
> > inprogress flag "xfs_db> write inprogress 0", That aloud me to mount the
> > partition but it looked entirly empty.
> >
> > A very nice person, <sandeen_> (thank you), on xfs@freenode tried to
> help
> > me. However it seems like the entire disk, or part of it, have been
> zero:ed.
> >
> > Does anyone know if it's possible to recover from this? And if so how?
>
> Recovery is possible - it's called restoring from backups. You do have a
> backup, don't you?
>
> > Running Linux Ubuntu, 8.04 32-bit
> > uname -r
> > 2.6.24-21-generic
> > xfs_repair -V
> > xfs_repair version 2.9.4
>
> Hmmmmm - haven't we have these symptoms reported by a couple of
> Ubuntu users now? There's been a few ppl reporting such problems
> of late....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>


[[HTML alternate version deleted]]
