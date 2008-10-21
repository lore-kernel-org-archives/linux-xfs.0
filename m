Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 14:20:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9LLKIf6015741
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 14:20:19 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 156731B1057C
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 14:22:01 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id UwmZmOhGr3hwj4Nc for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 14:22:01 -0700 (PDT)
Date: Wed, 22 Oct 2008 08:21:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Partition seems to have been zero:ed. For no reason.
Message-ID: <20081021212158.GN25906@disturbed>
References: <934a72850810211111g20accf8ey74f0bfb8ecf38532@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <934a72850810211111g20accf8ey74f0bfb8ecf38532@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Johan Stenehall <stenehall@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 21, 2008 at 08:11:50PM +0200, Johan Stenehall wrote:
> After a kernal upgrade My UUIDs in /etc/fstab stoped working so I changed
> them to /dev/sd* When rebooting again /dev/sdb2 didn't want to mount. I
> tried to manualy mount it without success and tried to run a xfs_repair on
> it. Got the following: http://pastebin.com/m44d3aa47

Are you using LVM or MD? i.e. did a volume get re-assembled
incorrectly and hence the XFS tools saw random fragments of a
filesystem?

> After that the partition still didn't want to mount. Had to overwrite the
> inprogress flag "xfs_db> write inprogress 0", That aloud me to mount the
> partition but it looked entirly empty.
> 
> A very nice person, <sandeen_> (thank you), on xfs@freenode tried to help
> me. However it seems like the entire disk, or part of it, have been zero:ed.
> 
> Does anyone know if it's possible to recover from this? And if so how?

Recovery is possible - it's called restoring from backups. You do have a
backup, don't you?

> Running Linux Ubuntu, 8.04 32-bit
> uname -r
> 2.6.24-21-generic
> xfs_repair -V
> xfs_repair version 2.9.4

Hmmmmm - haven't we have these symptoms reported by a couple of
Ubuntu users now? There's been a few ppl reporting such problems
of late....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
