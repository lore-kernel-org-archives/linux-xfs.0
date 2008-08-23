Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Aug 2008 21:01:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7N40Ncj013384
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 21:00:25 -0700
Received: from chef.nerp.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D47353C4B54
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 21:01:45 -0700 (PDT)
Received: from chef.nerp.net (chef.nerp.net [199.199.210.160]) by cuda.sgi.com with ESMTP id eVhsx75TCVuoUPuY for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 21:01:45 -0700 (PDT)
From: "Dan Redig" <dan@nerp.net>
Subject: Re: xfs_quota free
Date: 22 Aug 2008 18:01:00 -1000
Message-ID: <3302272903.2274591@chef.nerp.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lists@nerdbynature.de
Cc: xfs@oss.sgi.com, burgwalds@saic.com

Hi,

I'm running 2.6.22 on CentOS 4.4.  I don't have the version of XFS tools on me right now.  I do believe I got the right package.  Would the 32 bit binaries format and manipulate he other features of XFS properly and only fail on free blocks?

thanks!!

Dan


-----Original Message-----
From: Christian Kujau <lists@nerdbynature.de>
Date: Friday, Aug 22, 2008 2:40 pm
Subject: Re: xfs_quota free
To: Dan <dan@nerp.net>
CC: xfs@oss.sgi.com

On Fri, 22 Aug 2008, Dan wrote:
 data is on /dev/sdb.  Basically it boils down to xfs_quota -c 'free -r -h' 
 /mnt I think but I get the following error:

> XFS_IOC_FSGEOMETRY_V1: Invalid argument

A similar issue has been reported in http://lists.xensource.com/archives/html/xen-users/2007-10/msg00577.html

Which kernel are you running?

C.
-- BOFH excuse #266:

All of the packets are empty.
