Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Jun 2007 17:16:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l540GpWt026604
	for <xfs@oss.sgi.com>; Sun, 3 Jun 2007 17:16:53 -0700
Date: Mon, 4 Jun 2007 10:16:32 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS shrink functionality
Message-ID: <20070604001632.GA86004887@sgi.com>
References: <1180715974.10796.46.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180715974.10796.46.camel@localhost>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ruben Porras <nahoo82@gmail.com>
Cc: xfs@oss.sgi.com, iusty@k1024.org, cw@f00f.org

On Fri, Jun 01, 2007 at 06:39:34PM +0200, Ruben Porras wrote:
> Hello, 
> 
> I'm investigating the possibility to write myself the necessary code to
> shrink an xfs filesystem (I'd be able to dedicate a day/week). Trying to
> know if something is already done I came across the mails of a previous
> intent [0], [1] (I'm cc'ing the people involved). 

Oh, thanks for pointing those out - they're before my time ;)

> At a first glance the patch is a little outdated and will no more apply
> (as of linux 2.16.18, which is the last customised kernel that I was
> able to run under a XEN environment), because at least the function
> xfs_fs_geometry is changed. 

Any work for this would need to be done against current mainline
of the xfs-dev tree.

Yes, that patch is out of date, and it also did things that were not
necessary i.e. walk btrees to work out if AGs are empty or not.

> I'm really curious about what happened to this patches and why they were
> discontinued. The second part never was made public, and there was also
> no answer. Was there any flaw in any of the posted code or anything in
> XFS that makes it especially hard to shrink [3] that discouraged the
> development?

The posted code is only a *tiny* part of the shrink problem.

> After that, the first questions that arouse are,
> would there be some assistance/groove in from the developers? 

Certainly there's help available. ;)

> How doable is it?

It is doable.

> What are the programmers requirements from your point of view?

Here's the "simple" bits that will allow you to shrink
the filesystem down to the end of the internal log:

	0. Check space is available for shrink

	1. Mark allocation groups as "don't use - going away soon"
		- so we don't put new stuff in them while we
		  are moving all the bits out of them
		- requires hooks in the allocators to prevent
		  the AG from being selected for allllocations
		- must still allow allocations for the free lists
		  so that extent freeing can succeed
		- *new transaction required*.
		- also needs an "undo" (e.g. on partial failure)
		  so we need to be able to mark allocation groups
		  online again.

	2. Move inodes out of offline AGs
		- On Irix, we have a program called 'xfs_reno' which
		  converts 64 bit inode filesystems to 32 bit inode
		  filesystems. This needs to be:
		  	- released under the GPL (should not be a problem).
			- ported to linux
			- modified to understand inodes sit in certain
			  AGs and to move them out of those AGs as needed.
			- requires filesystem traversal to find all the
			  inodes to be moved.

		  % wc -l xfs_reno.c
		  1991 xfs_reno.c

		- even with "-o ikeep", this needs to trigger inode cluster
		  deletion in offline AGs (needs hooks in xfs_ifree()).
	
	3. Move data out of offline AGs.
		- this is difficult to do efficiently as we do not have
		  a block-to-owner reverse mapping in the filesystem.
		  Hence requires a walk of the *entire* filesystem to find
		  the owners of data blocks in the AGs being offlined.
		- xfs_db wrapper might be the best way to do this...

	<AGs are now empty>

	4. Execute shrink
		- new transaction - XFS_TRANS_SHRINKFS
		- check AGs are empty
		  	- icount == 0
			- freeblks == mp->m_sb.sb_agblocks
			  (will be a little more than this)
		- check shrink won't go past end of internal log
		- free AGs, updating superblock fields
		- update perag structure
		  	- not a simple realloc() as there may
			  be other threads using the structure at the
			  same time....


Initially, I'd say just support shrinking to whole AGs - you've got to empty
the whole "partial-last-ag" to ensure we can shrink it anyway, so doing
a subsequent grow operation to increase the size afterwards should be trivial.

Once this all works, we can then tackle the "move the log" problem which will
allow you to shrink to much smaller sizes.

As you can see, doing a shrink properly is not trivial, which is probably
why it has't gone anywhere fast....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
