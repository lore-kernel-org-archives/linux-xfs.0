Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Mar 2007 15:13:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2KMDJ6p007133
	for <xfs@oss.sgi.com>; Tue, 20 Mar 2007 15:13:21 -0700
Date: Wed, 21 Mar 2007 09:13:05 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: xfsrepair memory consumption
Message-ID: <20070320221305.GR32602149@melbourne.sgi.com>
References: <200703201532.06076.daniele@interline.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703201532.06076.daniele@interline.it>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Daniele P." <daniele@interline.it>
Cc: xfs@oss.sgi.com

On Tue, Mar 20, 2007 at 03:32:05PM +0100, Daniele P. wrote:
> Hi all,
> I'm just asking if any work has been done/is in progress to improve
> xfs_repair memory consumption.

Work is in progress, but it won't really solve your problem.
See, you've got:

> enceladus:~# df -i /dev/sdb1
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> /dev/sdb1            293049664 6511481 286538183    3% /media/300

6 million inodes in your filesystem, and a certain points in
repair we have to hold indexes of them all (plus some state) in
memory. Phase 6 is one of these points.

In terms of inode count, I generally use the rule that for every
10million inodes you need a gigabyte of RAM for repair - you needed
about 500MB for 6million inodes.

We have been trimming bits and pieces off this per-inode usage
but there comes a point where you just need more memory. That
is, as filesystem size grows, so does the amount of memory
needed to repair it in a finite time....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
