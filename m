Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Oct 2006 06:54:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9GDrxaG017924
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 06:54:00 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5ED3FD196C52
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 06:53:15 -0700 (PDT)
Message-ID: <45338EC9.9010501@sandeen.net>
Date: Mon, 16 Oct 2006 08:53:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: recover xfs with v1 dirs on linux?
References: <2117b660610160232p1ffb28e0necfeeb377b5d4ead@mail.gmail.com>
In-Reply-To: <2117b660610160232p1ffb28e0necfeeb377b5d4ead@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Honza Fikar <j.fikar@gmail.com>
Cc: xfs@oss.sgi.com

Honza Fikar wrote:
> Hi everybody,
> 
> I want to recover old SGI Irix xfs disks, but I don't have any more the old
> hardware. I was able to copy the xfs partition in a file with dd and I could
> run xfs_recover, xfs_check and xfs_ncheck, which gives me the filenames. But
> I was not able to mount this file. Kernel 2.6.17 gives "Function not
> implemented", while 2.6.5 mounts, but the disk looks empty.
> 
> I think the reason is "v1 dirs":
> 
> file img4.xfs
> img4.xfs: SGI XFS filesystem data (blksz 4096, inosz 256, v1 dirs)
> 
> Is there a way to get the files? I have the innode numbers and filenames as
> an output of xfs_ncheck:
> ....
> 947364 abc/MIXDUM/MD110/20K/step9/dynrt.out.gz
> 184821 aa/Monteal/fmd3kev-45K/cluster.I.076.gz
> 1286273 abc/MIXDUM/MD111/250K/step10/dyn5.f1.gz
> ...

v1dir support was removed a short while ago, they never really worked on Linux.

http://oss.sgi.com/projects/xfs/faq.html#useirixxfs

Older kernels had rudimentary v1 support, and you may find some degree of 
functionality, or, as it seems in your case, no functionality at all.

If this is terribly important data, then some finite amount of work (involving a 
patched glibc, IIRC) might be able to get you going.

-Eric
