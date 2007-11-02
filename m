Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 19:22:57 -0700 (PDT)
Received: from sc3app27.rit.edu (sc3app27.rit.edu [129.21.35.56])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA22MpxU016149
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 19:22:54 -0700
Received: from cias-jpspgd-macbook.jayps.home
 (cpe-72-230-182-205.rochester.res.rr.com [72.230.182.205])
 by smtp-server.rit.edu (PMDF V6.3-x14 #31420)
 with ESMTPSA id <0JQU00675XA7QD@smtp-server.rit.edu> for xfs@oss.sgi.com; Thu,
 01 Nov 2007 22:22:56 -0400 (EDT)
Date: Thu, 01 Nov 2007 22:22:54 -0400
From: Jay Sullivan <jpspgd@rit.edu>
Subject: Re: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
In-reply-to: <472A87FA.7000804@sandeen.net>
Message-id: <9489F071-7966-4230-9DAC-D783B6B9600A@rit.edu>
MIME-version: 1.0
References: <06CCEA2EB1B80A4A937ED59005FA855101AED1BE@svits26.main.ad.rit.edu>
 <472A87FA.7000804@sandeen.net>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Good eye:  it wasn't mountable, thus the -L flag.  No recent  
(unplanned) power outages.  The machine and the array that holds the  
disks are both on serious batteries/UPS and the array's cache  
batteries are in good health.

~Jay

On Nov 1, 2007, at 10:14 PM, Eric Sandeen wrote:

> Jay Sullivan wrote:
>
> > I ran xfs_repair -L on the FS and it could be mounted again,
>
> Was it not even mountable before this, or why did you use the -L flag?
> If the log is corrupted that points to more problems... perhaps you've
> had some power loss & your write caches evaporated, and lvm doesn't do
> barriers?
>
> -eric
>
>



[[HTML alternate version deleted]]
