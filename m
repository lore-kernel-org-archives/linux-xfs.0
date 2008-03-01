Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Feb 2008 20:09:30 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2148lkE024722
	for <xfs@oss.sgi.com>; Fri, 29 Feb 2008 20:08:50 -0800
Received: from toro.qb3.berkeley.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 12121635E09
	for <xfs@oss.sgi.com>; Fri, 29 Feb 2008 20:09:15 -0800 (PST)
Received: from toro.qb3.berkeley.edu (toro.QB3.Berkeley.EDU [169.229.244.93]) by cuda.sgi.com with ESMTP id pmmP16nH7wxD2IRx for <xfs@oss.sgi.com>; Fri, 29 Feb 2008 20:09:15 -0800 (PST)
Date: Fri, 29 Feb 2008 20:09:15 -0800 (PST)
From: slaton <slaton@berkeley.edu>
Subject: Re: Linux XFS filesystem corruption (XFS_WANT_CORRUPTED_GOTO)
In-Reply-To: <op.t67spv073jf8g2@pc-bnaujok.melbourne.sgi.com>
Message-ID: <Pine.LNX.4.64.0802291513420.19767@toro.qb3.berkeley.edu>
References: <Pine.LNX.4.64.0802221718430.13471@toro.qb3.berkeley.edu>
 <47C343D1.30304@sandeen.net> <Pine.LNX.4.64.0802251447390.20825@toro.qb3.berkeley.edu>
 <Pine.LNX.4.64.0802271441390.19923@toro.qb3.berkeley.edu>
 <op.t67spv073jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Thanks Barry. Couple of follow-up questions:

For "making an entire of the device", i presume you mean using dd, since 
it's an unmounted filesystem?

Also, I noted that my system's older xfsprogs 2.6.13-1 doesn't include 
xfs_metadump; is this a newer utility?

Rather than updating this system, i'm thinking of performing the recovery 
from a linux LiveCD type setup. I was thinking of Knoppix 5.1.1, which 
includes

 linux 2.6.19
 xfsprogs 2.8.11-1

Any concerns with these? Or would you strongly recommend i roll my own 
xfsprogs 2.9.4 and use the system itself (choice of kernels 2.6.17.11 or 
2.6.23.16)?

thanks
slaton

Slaton Lipscomb
Nogales Lab, Howard Hughes Medical Institute
http://cryoem.berkeley.edu

On Thu, 28 Feb 2008, Barry Naujok wrote:

> On Thu, 28 Feb 2008 09:44:04 +1100, slaton <slaton@berkeley.edu> wrote:
> 
> > Hi,
> > 
> > I'm still hoping for some help with this. Is any more information 
> > needed in addition to the ksymoops output previously posted?
> > 
> > In particular i'd like to know if just remounting the filesystem (to 
> > replay the journal), then unmounting and running xfs_repair is the 
> > best course of action. In addition, i'd like to know what recommended 
> > kernel/xfsprogs versions to use for best results.
> 
> I would get xfsprogs 2.9.4 (2.9.6 is not a good version with your 
> kernel), 
> ftp://oss.sgi.com/projects/xfs/previous/cmd_tars/xfsprogs_2.9.4-1.tar.gz
> 
> To be on the safe side, either make an entire copy of your drive to 
> another device, or run "xfs_metadump -o /dev/sda1" to capture a metadata 
> (no file data) of your filesystem.
> 
> Then run xfs_repair (mount/unmount maybe required if the log is dirty).
> 
> If the filesystem is in a bad state after the repair (eg. everything in 
> lost+found), email the xfs_repair log and request further advise.
> 
> Regards,
> Barry.
> 
> 
> > thanks
> > slaton
> > 
> > Slaton Lipscomb
> > Nogales Lab, Howard Hughes Medical Institute
> > http://cryoem.berkeley.edu
> > 
> > On Mon, 25 Feb 2008, slaton wrote:
> > 
> > > Thanks for the reply.
> > > 
> > > > Are you hitting http://oss.sgi.com/projects/xfs/faq.html#dir2 ?
> > > 
> > > Presumably not - i'm using 2.6.17.11, and that information indicates the
> > > bug was fixed in 2.6.17.7.
> > > 
> > > I've attached the output from running ksymoops on messages.1. First
> > > crash/trace (Feb 21 19:xx) corresponds to the original XFS event; the
> > > second (Feb 22 15:xx) is the system going down when i tried to unmount the
> > > volume.
> > > 
> > > Here are the additional syslog msgs corresponding to the Feb 22 15:xx
> > > crash.
> > > 
> > > Feb 22 15:47:13 qln01 kernel: grsec: From 10.0.2.93: unmount of /dev/sda1
> > > by /bin/umount[umount:18604] uid/euid:0/0 gid/egid:0/0, parent
> > > /bin/bash[bash:31972] uid/euid:0/0 gid/egid:0/0
> > > Feb 22 15:47:14 qln01 kernel: xfs_force_shutdown(sda1,0x1) called from
> > > line 338 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff88173ce4
> > > Feb 22 15:47:14 qln01 kernel: xfs_force_shutdown(sda1,0x1) called from
> > > line 338 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff88173ce4
> > > Feb 22 15:47:28 qln01 kernel: BUG: soft lockup detected on CPU#0!
> > > 
> > > thanks
> > > slaton
> > 
> > 
> 
