Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 17:13:13 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5T0D7tL028948
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 17:13:08 -0700
Subject: Re: xfs_fsr, performance related tweaks
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <4683ADF5.9050901@corky.net>
References: <4683ADF5.9050901@corky.net>
Content-Type: text/plain
Date: Fri, 29 Jun 2007 10:12:09 +1000
Message-Id: <1183075929.15488.148.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Just Marc <marc@corky.net>
Cc: xfs@oss.sgi.com

On Thu, 2007-06-28 at 13:47 +0100, Just Marc wrote:
> ...
> I looked at how the 'io' utility marks files as no-defrag; it calls 
> xfsctl(path, fd, XFS_IOC_FSSETXATTR, &attr); -- this requires a path, 
> which is not available to me when fsr is run in its default mode
> which 
> traverses all xfs filesystems rather than gets to run on a single
> file. 

Just call the ioctl directly - fsr is already doing this in a bunch
of places (even has a call to XFS_IOC_FSSETXATTR already, elsewhere).
The xfsctl wrapper is just to give some tools platform independence -
on IRIX (shares xfs_io code) some of the syscalls take paths, but on
Linux only file descriptors are used.

cheers.

--
Nathan
