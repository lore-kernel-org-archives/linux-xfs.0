Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Feb 2008 14:44:16 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1RMi9q2030283
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2008 14:44:13 -0800
Received: from toro.qb3.berkeley.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 98188624642
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2008 14:44:36 -0800 (PST)
Received: from toro.qb3.berkeley.edu (toro.QB3.Berkeley.EDU [169.229.244.93]) by cuda.sgi.com with ESMTP id Q57Zdi5XPIp2uaoo for <xfs@oss.sgi.com>; Wed, 27 Feb 2008 14:44:36 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by toro.qb3.berkeley.edu (Postfix) with ESMTP id 2EC7223913A
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2008 14:44:04 -0800 (PST)
Date: Wed, 27 Feb 2008 14:44:04 -0800 (PST)
From: slaton <slaton@berkeley.edu>
Subject: Re: Linux XFS filesystem corruption (XFS_WANT_CORRUPTED_GOTO)
In-Reply-To: <Pine.LNX.4.64.0802251447390.20825@toro.qb3.berkeley.edu>
Message-ID: <Pine.LNX.4.64.0802271441390.19923@toro.qb3.berkeley.edu>
References: <Pine.LNX.4.64.0802221718430.13471@toro.qb3.berkeley.edu>
 <47C343D1.30304@sandeen.net> <Pine.LNX.4.64.0802251447390.20825@toro.qb3.berkeley.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Hi,

I'm still hoping for some help with this. Is any more information needed 
in addition to the ksymoops output previously posted?

In particular i'd like to know if just remounting the filesystem (to 
replay the journal), then unmounting and running xfs_repair is the best 
course of action. In addition, i'd like to know what recommended 
kernel/xfsprogs versions to use for best results.

thanks
slaton

Slaton Lipscomb
Nogales Lab, Howard Hughes Medical Institute
http://cryoem.berkeley.edu

On Mon, 25 Feb 2008, slaton wrote:

> Thanks for the reply.
> 
> > Are you hitting http://oss.sgi.com/projects/xfs/faq.html#dir2 ?
> 
> Presumably not - i'm using 2.6.17.11, and that information indicates the 
> bug was fixed in 2.6.17.7.
> 
> I've attached the output from running ksymoops on messages.1. First 
> crash/trace (Feb 21 19:xx) corresponds to the original XFS event; the 
> second (Feb 22 15:xx) is the system going down when i tried to unmount the 
> volume.
> 
> Here are the additional syslog msgs corresponding to the Feb 22 15:xx 
> crash.
> 
> Feb 22 15:47:13 qln01 kernel: grsec: From 10.0.2.93: unmount of /dev/sda1 
> by /bin/umount[umount:18604] uid/euid:0/0 gid/egid:0/0, parent 
> /bin/bash[bash:31972] uid/euid:0/0 gid/egid:0/0
> Feb 22 15:47:14 qln01 kernel: xfs_force_shutdown(sda1,0x1) called from 
> line 338 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff88173ce4
> Feb 22 15:47:14 qln01 kernel: xfs_force_shutdown(sda1,0x1) called from 
> line 338 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff88173ce4
> Feb 22 15:47:28 qln01 kernel: BUG: soft lockup detected on CPU#0!
> 
> thanks
> slaton
