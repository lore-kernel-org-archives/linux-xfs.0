Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 May 2008 02:02:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4D92Zc4013968
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 02:02:37 -0700
Date: Tue, 13 May 2008 19:03:11 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Unneeded kernel threads (xfs, jfs, gfs2)
Message-ID: <20080513090311.GZ155679365@sgi.com>
References: <4828CAC6.3090402@unixsol.org> <48292742.8090409@sgi.com> <482951C3.60600@unixsol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482951C3.60600@unixsol.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Georgi Chorbadzhiyski <gf@unixsol.org>
Cc: Donald Douwsma <donaldd@sgi.com>, xfs@oss.sgi.com, jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Tue, May 13, 2008 at 11:30:59AM +0300, Georgi Chorbadzhiyski wrote:
> >>http://mirrors.unixsol.org/slackware/slackware-12.1/kernels/hugesmp.s/config 
> >
> >Your distro is building all of these modules into the kernel.
> >    CONFIG_XFS_FS=y
> >    CONFIG_JFS_FS=y
> >    CONFIG_GFS2_FS=y
> >
> >This isnt exactly standard practice, normally they'd be set to =m and only
> >used if required to mount a filesystem. You may want to ask the slackware
> >people why they chose to do this for their hugexxx.s kernels.
> 
> I know that they are compiled in the kernel, but since they
> are not used isn't starting their own kthreads kind of
> unnecessary? Surely the threads can be started on demand
> only when xfs/etc volume is mounted.

Sure - XFS will start another three kernel threads per filesystem
that gets mounted. And for good measure, it cleans them up again
on unmount. :)

The other threads are per-cpu workqueue threads that are shared
across all XFS filesystems in the system and hence are started
when XFS is initialised rather than when a mount occurs.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
