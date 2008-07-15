Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Jul 2008 00:46:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6F7kDwf010161
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2008 00:46:13 -0700
Received: from rproxy.teamix.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F00A3E213C8
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2008 00:47:20 -0700 (PDT)
Received: from rproxy.teamix.net (postman.teamix.net [194.150.191.120]) by cuda.sgi.com with ESMTP id qiBUppcJx3bXWsiK for <xfs@oss.sgi.com>; Tue, 15 Jul 2008 00:47:20 -0700 (PDT)
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: Is it possible the check an frozen XFS filesytem to avoid downtime
Date: Tue, 15 Jul 2008 09:47:17 +0200
References: <200807141542.51613.ms@teamix.de> <487C1BAF.2030404@sgi.com>
In-Reply-To: <487C1BAF.2030404@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807150947.17727.ms@teamix.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

Am Dienstag, 15. Juli 2008 05:38:23 schrieb Timothy Shimmin:
> Hi Martin,
>
> Martin Steigerwald wrote:
> > Hi!
> >
> > We seen in-memory corruption on two XFS filesystem on a server heartbeat
> > cluster of one of our customers:
> >
> >
> > XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1563 of file
> > fs/xfs/xfs_alloc.c.  Caller 0xffffffff8824eb5d
> >
> > Call Trace:
> >  [<ffffffff8824cff3>] :xfs:xfs_free_ag_extent+0x1a6/0x6b5
> >  [<ffffffff8824eb5d>] :xfs:xfs_free_extent+0xa9/0xc9
> >  [<ffffffff88258636>] :xfs:xfs_bmap_finish+0xf0/0x169
> >  [<ffffffff88278b4c>] :xfs:xfs_itruncate_finish+0x180/0x2c1
> >  [<ffffffff8829071a>] :xfs:xfs_setattr+0x841/0xe59
> >  [<ffffffff8022e868>] sock_common_recvmsg+0x30/0x45
> >  [<ffffffff8829adc8>] :xfs:xfs_vn_setattr+0x121/0x144
> >  [<ffffffff8022a06d>] notify_change+0x156/0x2ef
> >  [<ffffffff883bf9c6>] :nfsd:nfsd_setattr+0x334/0x4b1
> >  [<ffffffff883c61d6>] :nfsd:nfsd3_proc_setattr+0xa2/0xae
> >  [<ffffffff883bb24d>] :nfsd:nfsd_dispatch+0xdd/0x19e
> >  [<ffffffff8833a10e>] :sunrpc:svc_process+0x3cb/0x6d9
> >  [<ffffffff8025b20b>] __down_read+0x12/0x9a
> >  [<ffffffff883bb816>] :nfsd:nfsd+0x192/0x2b0
> >  [<ffffffff80255f38>] child_rip+0xa/0x12
> >  [<ffffffff883bb684>] :nfsd:nfsd+0x0/0x2b0
> >  [<ffffffff80255f2e>] child_rip+0x0/0x12
> >
> > xfs_force_shutdown(dm-1,0x8) called from line 4261 of file
> > fs/xfs/xfs_bmap.c. Return address = 0xffffffff88258673
> > Filesystem "dm-1": Corruption of in-memory data detected.  Shutting down
> > filesystem: dm-1
> > Please umount the filesystem, and rectify the problem(s)
> >
> > on
> >
> > Linux version 2.6.21-1-amd64 (Debian 2.6.21-4~bpo.1)
> > (nobse@backports.org) (gcc version 4.1.2 20061115 (prerelease) (Debian
> > 4.1.1-21)) #1 SMP Tue Jun 5 07:43:32 UTC 2007
> >
> >
> > We plan to do a takeover so that the server which appears to have memory
> > errors can be memtested.
> >
> > After the takeover we would like to make sure that the XFS filesystems
> > are intact. Is it possible to do so without taking the filesystem
> > completely offline?
> >
> > I thought about mounting read only and it might be the best choice
> > available, but then it will *fail* write accesses. I would prefer if
> > these are just stalled.
> >
> > I tried xfs_freeze -f on my laptop home directory, but then did not
> > machine to get it check via xfs_check or xfs_repair -nd... is it possible
> > at all?
> >
> > Ciao,
>
> When I last tried (and I don't think Barry has done anything to it to
> change things) it wouldn't work.
> However, I think it could/should be changed to make it work.

I am wondering whether it would need to set an option at all.

Shouldn't checking a filesystem that is not being written too be safe? So 
xfs_check and xfs_repair -n could just check whether fs is readonly or frozen 
and if so continue without requiring a special option? They can print the 
fact aka

Checking a frozen filesystem

or 

Checking a read only filesystem

in the beginning tough.

Only thing is the log itself... when that is not cleared upon a freeze or 
readonly mount, it might be a problem for xfs_check and xfs_repair -n.

Ciao,
-- 
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
