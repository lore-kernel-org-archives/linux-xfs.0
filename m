Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Jul 2006 05:10:00 -0700 (PDT)
Received: from web31705.mail.mud.yahoo.com (web31705.mail.mud.yahoo.com [68.142.201.185])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6NC9hDW030060
	for <xfs@oss.sgi.com>; Sun, 23 Jul 2006 05:09:43 -0700
Message-ID: <20060723110919.79373.qmail@web31705.mail.mud.yahoo.com>
Date: Sun, 23 Jul 2006 04:09:18 -0700 (PDT)
From: Heilige Gheist <hgheist@yahoo.com>
Subject: XFS setting custom extent size: real-time section only?
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I'm trying to get custom extent size per file working, but
XFS_IOC_FSSETXATTR ioctl returns with EINVAL,
both from my code or from xfs_io.
The environment is SLES9 SP2, 2.6.5-7.252 kernel, xfsprogs-2.6.25-0.6
After examining the kernel code in xfs_vnodeops.c we found out that
custom extent size is supported on files in real-time section only.
This is not mentioned anywhere else in the documentation, so I'm
wondering whether this limitation is removed in further kernel
versions.
I've downloaded the recent xfsprogs-2.8.4, it uses a new flag
XFS_XFLAG_EXTSIZE when setting the custom extent size.
I'm not sure what kernel version do I need to work with 2.8.4, but it's
certainly a sign that kernel support has changed.
Can anyone shed a light on this?

Thanks,
Alan


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
