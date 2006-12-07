Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 14:55:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB7MspaG008590
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 14:54:52 -0800
Message-ID: <45789B83.5010800@sandeen.net>
Date: Thu, 07 Dec 2006 16:53:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: New CentOS4/RHEL4-compatible xfs module rpms
References: <4560AB84.9060200@sandeen.net> <45784E71.4080605@falconstor.com>	 <457854CB.5030507@sandeen.net>  <45787ED4.5070801@falconstor.com>	 <1165525906.30459.25.camel@edge>  <45788927.4030207@falconstor.com>	 <1165527628.30459.31.camel@edge>  <45788CD1.9010509@falconstor.com> <1165529205.30459.36.camel@edge> <457892BB.1000203@falconstor.com> <45789341.6000809@sandeen.net> <457894DF.70603@falconstor.com> <457895FA.9010203@sandeen.net> <45789B27.1050507@falconstor.com>
In-Reply-To: <45789B27.1050507@falconstor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: geir.myrestrand@falconstor.com
Cc: xfs@oss.sgi.com, nscott@aconex.com

Geir A. Myrestrand wrote:

> O'boy, looks like it happens on SLES10 as well. It froze on the first 
> XFS freeze call, it does not return.
> 
> strace -ff -o freeze-1.txt xfs_freeze -f /mnt/xfs
>   \_ /bin/sh -f /usr/sbin/xfs_freeze -f /mnt/xfs
>       \_ /usr/sbin/xfs_io -r -p xfs_freeze -x -c freeze /mnt/xfs
> 
> A sync call hangs too. Looks like I need to test an even newer kernel...

You don't have multiple concurrent freezes happening do you....

-Eric
