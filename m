Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Mar 2007 16:43:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2KNhc6p025597
	for <xfs@oss.sgi.com>; Tue, 20 Mar 2007 16:43:40 -0700
Message-Id: <200703202343.KAA28746@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: xfsrepair memory consumption
Date: Wed, 21 Mar 2007 10:48:53 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <20070320221305.GR32602149@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "'Daniele P.'" <daniele@interline.it>
Cc: xfs@oss.sgi.com

Hi Daniele,

The nlink/phase 7 patch I recently sent out does reduce this 
inode memory requirements which should address the issue you 
see.

I'm going to make one further optimisation in this patch 
which I will repost most likely next week.

Regards,
Barry.

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of David Chinner
> Sent: Wednesday, 21 March 2007 9:13 AM
> To: Daniele P.
> Cc: xfs@oss.sgi.com
> Subject: Re: xfsrepair memory consumption
> 
> On Tue, Mar 20, 2007 at 03:32:05PM +0100, Daniele P. wrote:
> > Hi all,
> > I'm just asking if any work has been done/is in progress to improve
> > xfs_repair memory consumption.
> 
> Work is in progress, but it won't really solve your problem.
> See, you've got:
> 
> > enceladus:~# df -i /dev/sdb1
> > Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> > /dev/sdb1            293049664 6511481 286538183    3% /media/300
> 
> 6 million inodes in your filesystem, and a certain points in
> repair we have to hold indexes of them all (plus some state) in
> memory. Phase 6 is one of these points.
> 
> In terms of inode count, I generally use the rule that for every
> 10million inodes you need a gigabyte of RAM for repair - you needed
> about 500MB for 6million inodes.
> 
> We have been trimming bits and pieces off this per-inode usage
> but there comes a point where you just need more memory. That
> is, as filesystem size grows, so does the amount of memory
> needed to repair it in a finite time....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> 
> 
