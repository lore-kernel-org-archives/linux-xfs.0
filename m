Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Jul 2006 04:04:26 -0700 (PDT)
Received: from web31709.mail.mud.yahoo.com (web31709.mail.mud.yahoo.com [68.142.201.189])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6OB41DW008094
	for <xfs@oss.sgi.com>; Mon, 24 Jul 2006 04:04:03 -0700
Message-ID: <20060724110338.62600.qmail@web31709.mail.mud.yahoo.com>
Date: Mon, 24 Jul 2006 04:03:38 -0700 (PDT)
From: Heilige Gheist <hgheist@yahoo.com>
Subject: Re: XFS setting custom extent size: real-time section only?
In-Reply-To: <20060724100030.E2083275@wobbly.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com

I've checked source code of 2.6.16.13-4 in SUSE 10.1, it looks like
this limitation is no longer there.
However the lack of support for this in SLES9 complicates things a bit,
for example we're using EMC PowerPath 4.5.1 for MPIO and it doesn't
support anything but SLES9 SP2. Hardware driver support is shaky as
well.

Provided I have to stick with whatever kernel support there's in SLES9,
what are the implications of running large volumes (150-300GB) as one
big real-time section?
Do I have to have non-realtime regular section?
Should I expect a performance hit due to large size of real-time
section?

--alan




--- Nathan Scott <nathans@sgi.com> wrote:

> On Sun, Jul 23, 2006 at 04:09:18AM -0700, Heilige Gheist wrote:
> > I'm trying to get custom extent size per file working, but
> > XFS_IOC_FSSETXATTR ioctl returns with EINVAL,
> > both from my code or from xfs_io.
> > The environment is SLES9 SP2, 2.6.5-7.252 kernel,
> xfsprogs-2.6.25-0.6
> > After examining the kernel code in xfs_vnodeops.c we found out that
> > custom extent size is supported on files in real-time section only.
> > This is not mentioned anywhere else in the documentation, so I'm
> > wondering whether this limitation is removed in further kernel
> > versions.
> > I've downloaded the recent xfsprogs-2.8.4, it uses a new flag
> > XFS_XFLAG_EXTSIZE when setting the custom extent size.
> > I'm not sure what kernel version do I need to work with 2.8.4, but
> it's
> > certainly a sign that kernel support has changed.
> 
> Indeed it has.  I'm not sure which kernel version this was merged
> into,
> but the rough timeframe can be seen on
> http://oss.sgi.com/projects/xfs/
> on the "recent changes" table.  It wont be there in any SLES9, but
> IIRC
> SLES10 does now include that code.
> 
> cheers.
> 
> -- 
> Nathan
> 
> 
> 


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
