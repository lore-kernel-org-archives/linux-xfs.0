Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 May 2008 22:50:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4D5oMvD024105
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 22:50:23 -0700
Received: from smtp5-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50AEE16A721D
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 22:51:09 -0700 (PDT)
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35]) by cuda.sgi.com with ESMTP id VzernGI891CuPGmH for <xfs@oss.sgi.com>; Mon, 12 May 2008 22:51:09 -0700 (PDT)
Date: Tue, 13 May 2008 07:51:07 +0200
From: FD Cami <francois.cami@free.fr>
Subject: Re: Unneeded kernel threads (xfs, jfs, gfs2)
Message-ID: <20080513075107.2edc44d3@olorin>
In-Reply-To: <48292742.8090409@sgi.com>
References: <4828CAC6.3090402@unixsol.org>
	<48292742.8090409@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: Georgi Chorbadzhiyski <gf@unixsol.org>, xfs@oss.sgi.com, jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, volkerdi@slackware.com

On Tue, 13 May 2008 15:29:38 +1000
Donald Douwsma <donaldd@sgi.com> wrote:

> Georgi Chorbadzhiyski wrote:
> > Hi guys, I know that not all kernel thread users are converted to
> > start only when needed but the following is little annoying specially
> > when I'm not even using jfs, xfs and gfs2.
> > 
> > Look at the ps output from a standard distro 2.6.24.5 kernel after a
> > fresh boot:
> ...
> 
> > 
> > Kernel config can be found here:
> >   http://mirrors.unixsol.org/slackware/slackware-12.1/kernels/hugesmp.s/config
> > 
> 
> Your distro is building all of these modules into the kernel.
> 	CONFIG_XFS_FS=y
> 	CONFIG_JFS_FS=y
> 	CONFIG_GFS2_FS=y
> 
> This isnt exactly standard practice, normally they'd be set to =m and only
> used if required to mount a filesystem. You may want to ask the slackware
> people why they chose to do this for their hugexxx.s kernels.

To be able to use those filesystems on root partitions without requiring
an initrd. 

Georgi might be interested to use the generic kernel instead of the huge
one, it is available there :
http://mirrors.unixsol.org/slackware/slackware-12.1/slackware/a/kernel-generic-smp-2.6.24.5_smp-i686-2.tgz

Documentation :
http://mirrors.unixsol.org/slackware/slackware-12.1/README.TXT
http://mirrors.unixsol.org/slackware/slackware-12.1/README.initrd
http://mirrors.unixsol.org/slackware/slackware-12.1/RELEASE_NOTES

Cheers

Francois
