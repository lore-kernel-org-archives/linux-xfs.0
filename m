Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 09:53:51 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB7HrdaG028993
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 09:53:45 -0800
Message-ID: <457854CB.5030507@sandeen.net>
Date: Thu, 07 Dec 2006 11:52:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: New CentOS4/RHEL4-compatible xfs module rpms
References: <4560AB84.9060200@sandeen.net> <45784E71.4080605@falconstor.com>
In-Reply-To: <45784E71.4080605@falconstor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: geir.myrestrand@falconstor.com
Cc: xfs@oss.sgi.com

Geir A. Myrestrand wrote:

> However, I run into issues with xfs_freeze as it often locks up when I 
> try to freeze a file system where there is I/O activity. Sometimes it 
> happen on the first xfs_freeze invocation to freeze the file system, 
> other times I have to unfreeze and then it happens on the second time I 
> freeze. xfs_freeze never returns when this happens.
> 
> Looks like xfs_io get stuck --see partial output from `ps auxf`:
> 
> strace -ff -o freeze.txt xfs_freeze -f /mnt/xfs
>   \_ /bin/sh -f /usr/sbin/xfs_freeze -f /mnt/xfs
>       \_ /usr/sbin/xfs_io -r -p xfs_freeze -x -c freeze /mnt/xfs
> 
> Anyone else encountering this issue?
> 

Did you have this problem on the previous version?

You might do sysrq-t (echo t > /proc/sysrq-trigger) and see where the
thread is stuck.

-Eric
