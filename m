Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Mar 2007 12:20:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2GJKm6p025204
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 12:20:50 -0700
Date: Sat, 17 Mar 2007 06:20:37 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Should xfs_repair take this long?
Message-ID: <20070316192037.GZ5743@melbourne.sgi.com>
References: <20070315202027.CNS24438@comet.stsci.edu> <20070316013227.GO5743@melbourne.sgi.com> <45FA7C37.4070001@stsci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FA7C37.4070001@stsci.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas Walker <walker@stsci.edu>
Cc: xfs@oss.sgi.com

On Fri, Mar 16, 2007 at 07:15:03AM -0400, Thomas Walker wrote:
> 
>    No problem.  The error was with the iflag=direct, apparently RHEL4 
> doesn't like that option so I took it out.  Here's the output from each 
> of the xfs volumes;
> 
> [root@hla-ags ~]# dd if=/dev/mapper/vg0-hladata3 bs=512 count=1 | od -Ax -x
> 1+0 records in
> 1+0 records out
> 000000 0000 6419 0000 0c00 0000 7419 0000 0c00
> 000010 0000 8419 0000 0c00 0000 9419 0000 0c00

That's not a XFS superblock :(

> [root@hla-ags ~]# dd if=/dev/mapper/vg1-hladata2 bs=512 count=1 | od -Ax -x
> 1+0 records in
> 000000 7970 6f72 746f 203a 2030 0a2f 500a 414c
> 000010 4e49 4b0a 3120 410a 560a 3120 0a34 6964
> 000020 2072 2e31 2e30 3572 392f 3830 4b0a 3420
> 000030 690a 746f 0a61 2056 3531 660a 6c69 2065

Neither is that - it's a bunch of text that doesn't
make much sense to me....

This would explain why xfs_repair is having trouble.

>         Does that help with a diag?

It tells us that something has either overwritten the start of the
partitions, or the lvm volumes have been put together incorrectly so
the superblocks are not where it should be. I'd check that the LVM
config is correct (again)....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
