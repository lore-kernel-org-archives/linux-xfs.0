Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Jul 2006 17:01:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6O01EDW030944
	for <xfs@oss.sgi.com>; Sun, 23 Jul 2006 17:01:25 -0700
Date: Mon, 24 Jul 2006 10:00:30 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: XFS setting custom extent size: real-time section only?
Message-ID: <20060724100030.E2083275@wobbly.melbourne.sgi.com>
References: <20060723110919.79373.qmail@web31705.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060723110919.79373.qmail@web31705.mail.mud.yahoo.com>; from hgheist@yahoo.com on Sun, Jul 23, 2006 at 04:09:18AM -0700
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Heilige Gheist <hgheist@yahoo.com>
Cc: xfs@oss.sgi.com

On Sun, Jul 23, 2006 at 04:09:18AM -0700, Heilige Gheist wrote:
> I'm trying to get custom extent size per file working, but
> XFS_IOC_FSSETXATTR ioctl returns with EINVAL,
> both from my code or from xfs_io.
> The environment is SLES9 SP2, 2.6.5-7.252 kernel, xfsprogs-2.6.25-0.6
> After examining the kernel code in xfs_vnodeops.c we found out that
> custom extent size is supported on files in real-time section only.
> This is not mentioned anywhere else in the documentation, so I'm
> wondering whether this limitation is removed in further kernel
> versions.
> I've downloaded the recent xfsprogs-2.8.4, it uses a new flag
> XFS_XFLAG_EXTSIZE when setting the custom extent size.
> I'm not sure what kernel version do I need to work with 2.8.4, but it's
> certainly a sign that kernel support has changed.

Indeed it has.  I'm not sure which kernel version this was merged into,
but the rough timeframe can be seen on http://oss.sgi.com/projects/xfs/
on the "recent changes" table.  It wont be there in any SLES9, but IIRC
SLES10 does now include that code.

cheers.

-- 
Nathan
