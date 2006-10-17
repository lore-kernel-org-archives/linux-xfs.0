Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Oct 2006 00:41:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9H7f1aG025622
	for <xfs@oss.sgi.com>; Tue, 17 Oct 2006 00:41:03 -0700
Reply-To: <mg@sgi.com>
From: "Mike Gigante" <mg@sgi.com>
Subject: RE: recover xfs with v1 dirs on linux?
Date: Tue, 17 Oct 2006 16:34:13 +1000
Message-ID: <004401c6f1b6$441f1f30$10370e86@SGIGORT>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <45338EC9.9010501@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Eric Sandeen' <sandeen@sandeen.net>, 'Honza Fikar' <j.fikar@gmail.com>
Cc: xfs@oss.sgi.com


Actually the real answer is that this is something that SGI Managed Services
can do for a one-off fee. We will not be supporting V1 directories on Linux
and there is simply not sufficient demand/$$ to justify SGI engineering
doing the work required to implement a tool.

I spoke to the local SGI Customer Support Manager and he assures me that any
SGI service organisation worldwide would happily do this kind of service.

Mike

---
Mike Gigante
Engineering Director, Fileserving Technologies
SGI, Melbourne, Australia
NOTE: new phone number +61 3 9963 1951

-----Original Message-----
From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] On Behalf Of
Eric Sandeen
Sent: Monday, October 16, 2006 11:53 PM
To: Honza Fikar
Cc: xfs@oss.sgi.com
Subject: Re: recover xfs with v1 dirs on linux?

Honza Fikar wrote:
> Hi everybody,
> 
> I want to recover old SGI Irix xfs disks, but I don't have any more 
> the old hardware. I was able to copy the xfs partition in a file with 
> dd and I could run xfs_recover, xfs_check and xfs_ncheck, which gives 
> me the filenames. But I was not able to mount this file. Kernel 2.6.17 
> gives "Function not implemented", while 2.6.5 mounts, but the disk looks
empty.
> 
> I think the reason is "v1 dirs":
> 
> file img4.xfs
> img4.xfs: SGI XFS filesystem data (blksz 4096, inosz 256, v1 dirs)
> 
> Is there a way to get the files? I have the innode numbers and 
> filenames as an output of xfs_ncheck:
> ....
> 947364 abc/MIXDUM/MD110/20K/step9/dynrt.out.gz
> 184821 aa/Monteal/fmd3kev-45K/cluster.I.076.gz
> 1286273 abc/MIXDUM/MD111/250K/step10/dyn5.f1.gz
> ...

v1dir support was removed a short while ago, they never really worked on
Linux.

http://oss.sgi.com/projects/xfs/faq.html#useirixxfs

Older kernels had rudimentary v1 support, and you may find some degree of
functionality, or, as it seems in your case, no functionality at all.

If this is terribly important data, then some finite amount of work
(involving a patched glibc, IIRC) might be able to get you going.

-Eric
