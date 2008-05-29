Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 May 2008 23:59:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4T6x5eB001043
	for <xfs@oss.sgi.com>; Wed, 28 May 2008 23:59:28 -0700
Message-ID: <483E5462.1080604@sgi.com>
Date: Thu, 29 May 2008 16:59:46 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Question for XFS (mounting and clean bit)
References: <20080527181336.22qjfcgcfdlwsg40@webmail.versatel.de>
In-Reply-To: <20080527181336.22qjfcgcfdlwsg40@webmail.versatel.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andre Nitschke <andre.nitschke@versanet.de>
Cc: xfs@oss.sgi.com

Hi Andre,

I didn't follow all of this, sorry.
When you ask about the "clean bit", I assume that you are referring
to "clean XFS mount for filesystem".
We effectively mark it clean if we do a successful unmount.
As part of unmount, we write an unmount record into the xfs log.
On the next mount we look for the head of the log and then for the
unmount record nearby. If we find the unmount record then we know
we have had a clean unmount previously, otherwise we replay the log.
So it's really a question of doing an unmount versus resetting the
box beforehand or forcing a shutdown beforehand.
I guess the other question would be if it is possible to mount
the filesystem and try to do no write i/o such that the ondisk log
is not touched at all since the last unmount.
I believe so. You can use "xfs_logprint -t" to see if the head
has moved and it is clean or not etc..
IIRC we did have an sb counters thing recently where in an idle state
we were logging the super block counters - Dave (dgc) fixed this one.

--Tim

Andre Nitschke wrote:
> Hello,
> i am a Linux User from Germany and chanched to xfs. I use Debian 4 and the
> installer creates lilo. Because of a wrong configuration i destroyed the
> lilo.conf and rebootet with a systemrescuecd. from here i mount the xfs
> partition and try to run lilo, but it fails.
> then i had a realy bad idea. i unmount the xfs partition and then mount it as
> root, but there exit a root file system.
> i type
> mount /dev/sda2 /
> no error appears. i could not access the partiton from the hdd, only see the
> tmpfs from the live-boot cd. hm
> i type mount and the mount command says:
> tmpfs on / as tmpfs (rw)
> ....(some entrys...)
> /dev/sda2 on / as xfs (rw)
> ok, both devices were mountet as /
> but i could only access the tmpfs system from the live cd.
> i try to reboot. the system sends the term and kill signal, then hang up.
> nothing happesn.
> i press reset.
> then linux startet normal and says ...
> 
>  XFS mounting filesystem sda2
>  Ending clean XFS mount for filesystem: sda2
> 
> so i think nothing should happens to the xfs.
> but i cant stop thinking, go to my testpc with linux and xfs and create the same
> situtation. everytime ... clean xfs.
> when i start writing data and then press reset comes this message:
> 
>  SGI XFS Quota Management subsystem
>  XFS mounting filesystem hda2
>  Starting XFS recovery on filesystem: hda2 (logdev: internal)
>  Ending XFS recovery on filesystem: hda2 (logdev: internal)
> 
> i have two questions. first, is the xfs on my working-machine damaged by my bad
> idea mounting two devices as root
> and secound, is the clean bit removed when mounting a xfs or when i first write
> data on it?
> 
> thanks
> 
> andre
> 
> 
