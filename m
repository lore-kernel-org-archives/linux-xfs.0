Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 09:38:52 -0800 (PST)
Received: from evaldomino.Falconstor.com (mail1.falconstor.com [216.223.47.230])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB7HciaG027043
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 09:38:45 -0800
Message-ID: <45784E71.4080605@falconstor.com>
Date: Thu, 07 Dec 2006 12:25:05 -0500
From: "Geir A. Myrestrand" <geir.myrestrand@falconstor.com>
Reply-To: geir.myrestrand@falconstor.com
MIME-Version: 1.0
Subject: Re: New CentOS4/RHEL4-compatible xfs module rpms
References: <4560AB84.9060200@sandeen.net>
In-Reply-To: <4560AB84.9060200@sandeen.net>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

Eric Sandeen wrote:
> http://sandeen.net/rhel4_xfs/kernel-module-xfs-2.6.9-42.0.2.EL-0.2-1.src.rpm 
> 
> 
> rpmbuild --rebuild --target i686 
> kernel-module-xfs-2.6.9-42.0.2.EL-0.2-1.src.rpm
> 
> will build against the currently running kernel, or
> 
> rpmbuild --rebuild --target i686 --define "kernel_topdir 
> /lib/modules/2.6.9-42.0.2.EL/build" 
> kernel-module-xfs-2.6.9-42.0.2.EL-0.2-1.src.rpm
> 
> will build against what is defined in kernel_topdir
> 
> you need matching kernel & kernel-devel rpms installed to build.
> 

I built this for RHELAS4U2 x86_64 with the 2.6.9-22.ELsmp kernel.

I did enable the xfs_direct_io_locking.patch (see inside 
kernel-module-xfs.spec for details).

However, I run into issues with xfs_freeze as it often locks up when I 
try to freeze a file system where there is I/O activity. Sometimes it 
happen on the first xfs_freeze invocation to freeze the file system, 
other times I have to unfreeze and then it happens on the second time I 
freeze. xfs_freeze never returns when this happens.

Looks like xfs_io get stuck --see partial output from `ps auxf`:

strace -ff -o freeze.txt xfs_freeze -f /mnt/xfs
  \_ /bin/sh -f /usr/sbin/xfs_freeze -f /mnt/xfs
      \_ /usr/sbin/xfs_io -r -p xfs_freeze -x -c freeze /mnt/xfs

Anyone else encountering this issue?

-- 

Geir A. Myrestrand
