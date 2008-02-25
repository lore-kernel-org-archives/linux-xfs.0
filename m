Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 09:03:28 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1PH3K7n002189
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 09:03:21 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73ECFEB8E82
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 09:03:46 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id wfiYHLb3wrjaYtA6 for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 09:03:46 -0800 (PST)
Message-ID: <47C2F4EF.4020008@sandeen.net>
Date: Mon, 25 Feb 2008 11:03:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS on Red Hat EL5
References: <00fa01c874b5$1908d150$8e0010ac@sg.lcl> <alpine.DEB.1.00.0802211401590.17484@p34.internal.lan> <47BDD390.1040102@sandeen.net> <000601c877c5$d33297b0$8e0010ac@sg.lcl>
In-Reply-To: <000601c877c5$d33297b0$8e0010ac@sg.lcl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Miakell Figueredo <figueredom@scoregroup.com>
Cc: 'Justin Piszcz' <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com

Miakell Figueredo wrote:
> Hi Eric:
> 
>  
> 
> I'm getting the following when rebuilding
> "kernel-module-xfs-2.6.17-1.2519.4.21.el5-0.2-1.src.rpm": (Any Ideas?)
> 

how did you invoke the build, and did you have a matching kernel and
kernel-devel rpm installed?

-Eric

> 
> + STATUS=0
> 
> + '[' 0 -ne 0 ']'
> 
> + cd xfs
> 
> ++ /usr/bin/id -u
> 
> + '[' 0 = 0 ']'
> 
> + /bin/chown -Rhf root .
> 
> ++ /usr/bin/id -u
> 
> + '[' 0 = 0 ']'
> 
> + /bin/chgrp -Rhf root .
> 
> + /bin/chmod -Rf a+rX,u+w,g-w,o-w .
> 
> + echo 'Patch #0 (xfs-ootbuild.patch):'
> 
> Patch #0 (xfs-ootbuild.patch):
> 
> + patch -p1 -s
> 
> + echo 'Patch #1 (xfs-kernel-has-roundup.patch):'
> 
> Patch #1 (xfs-kernel-has-roundup.patch):
> 
> + patch -p1 -s
> 
> + echo 'Patch #2 (xfs-fix-mrinit.patch):'
> 
> Patch #2 (xfs-fix-mrinit.patch):
> 
> + patch -p1 -s
> 
> + echo 'Patch #3 (xfs-vfs-interface-fixes.patch):'
> 
> Patch #3 (xfs-vfs-interface-fixes.patch):
> 
> + patch -p1 -s
> 
> + echo 'Patch #4 (xfs-no-i_blksize.patch):'
> 
> Patch #4 (xfs-no-i_blksize.patch):
> 
> + patch -p1 -s
> 
> + echo 'Patch #5 (xfs-fail_migrate_page-header.patch):'
> 
> Patch #5 (xfs-fail_migrate_page-header.patch):
> 
> + patch -p1 -s
> 
> + cp /usr/src/redhat/SOURCES/config.xfs .
> 
> + exit 0
> 
> Executing(%build): /bin/sh -e /var/tmp/rpm-tmp.15200
> 
> + umask 022
> 
> + cd /usr/src/redhat/BUILD
> 
> + cd xfs
> 
> + LANG=C
> 
> + export LANG
> 
> + unset DISPLAY
> 
> + make 'TOPDIR=%{kernel_topdir}' modules
> 
> make -C %{kernel_topdir} OOT_BUILD=y SUBDIRS=/usr/src/redhat/BUILD/xfs
> modules
> 
> make: *** %{kernel_topdir}: No such file or directory.  Stop.
> 
> make: *** [modules] Error 2
> 
> error: Bad exit status from /var/tmp/rpm-tmp.15200 (%build)
> 
>  
> 
>  
> 
> RPM build errors:
> 
>     user sandeen does not exist - using root
> 
>     group sandeen does not exist - using root
> 
>     user sandeen does not exist - using root
> 
>     group sandeen does not exist - using root
> 
>     user sandeen does not exist - using root
> 
>     group sandeen does not exist - using root
> 
>     user sandeen does not exist - using root
> 
>     group sandeen does not exist - using root
> 
>     user sandeen does not exist - using root
> 
>     group sandeen does not exist - using root
> 
>     user sandeen does not exist - using root
> 
>     group sandeen does not exist - using root
> 
>     user sandeen does not exist - using root
> 
>     group sandeen does not exist - using root
> 
>     user sandeen does not exist - using root
> 
>     group sandeen does not exist - using root
> 
>     user sandeen does not exist - using root
> 
>     group sandeen does not exist - using root
> 
>     Bad exit status from /var/tmp/rpm-tmp.15200 (%build)
> 
>  
> 
> -----Original Message-----
> From: Eric Sandeen [mailto:sandeen@sandeen.net]
> Sent: Thursday, February 21, 2008 2:40 PM
> To: Justin Piszcz
> Cc: Miakell Figueredo; xfs@oss.sgi.com
> Subject: Re: XFS on Red Hat EL5
> 
>  
> 
> Justin Piszcz wrote:
> 
>> Eric makes some RPMs for them..
> 
>  
> 
> Yep, take a look at http://sandeen.net/rhel5_xfs
> 
>  
> 
> They're a bit outdated at this point, though I'm not aware of any
> 
> significant bugs.
> 
>  
> 
> Or, the centos distro has similar (if not the same) rpms.
> 
>  
> 
> RHEL does not support xfs, so using xfs may change whatever support
> 
> agreements you have in place.
> 
>  
> 
> -Eric (speaking only for himself)
> 
>  
> 
>> On Thu, 21 Feb 2008, Miakell Figueredo wrote:
> 
>>
> 
>>> Hello:
> 
>>> 
> 
>>> 
> 
>>> 
> 
>>> Is there an RPM for XFS on Red Hat? Currently we are running
> 
>>> "2.6.18-53.1.13.el5xen #1 SMP Mon Feb 11 13:41:50 EST 2008 x86_64 x86_64
> 
>>> x86_64 GNU/Linux" and installed "xfsprogs.i386-2.9.5-1.fc9" and I cannot
> 
>>> mount the volume.
> 
>  
> 
