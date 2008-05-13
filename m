Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 May 2008 22:29:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4D5Sxdl022830
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 22:29:03 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id PAA11667; Tue, 13 May 2008 15:29:38 +1000
Message-ID: <48292742.8090409@sgi.com>
Date: Tue, 13 May 2008 15:29:38 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: Unneeded kernel threads (xfs, jfs, gfs2)
References: <4828CAC6.3090402@unixsol.org>
In-Reply-To: <4828CAC6.3090402@unixsol.org>
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Georgi Chorbadzhiyski <gf@unixsol.org>
Cc: xfs@oss.sgi.com, jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Georgi Chorbadzhiyski wrote:
> Hi guys, I know that not all kernel thread users are converted to
> start only when needed but the following is little annoying specially
> when I'm not even using jfs, xfs and gfs2.
> 
> Look at the ps output from a standard distro 2.6.24.5 kernel after a
> fresh boot:
...

> 
> Kernel config can be found here:
>   http://mirrors.unixsol.org/slackware/slackware-12.1/kernels/hugesmp.s/config
> 

Your distro is building all of these modules into the kernel.
	CONFIG_XFS_FS=y
	CONFIG_JFS_FS=y
	CONFIG_GFS2_FS=y

This isnt exactly standard practice, normally they'd be set to =m and only
used if required to mount a filesystem. You may want to ask the slackware
people why they chose to do this for their hugexxx.s kernels.

Don
