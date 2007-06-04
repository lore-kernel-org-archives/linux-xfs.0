Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 02:15:45 -0700 (PDT)
Received: from astra.simleu.ro (astra.simleu.ro [80.97.18.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l549FfWt006143
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 02:15:42 -0700
Date: Mon, 4 Jun 2007 10:41:54 +0200
From: Iustin Pop <iusty@k1024.org>
Subject: Re: XFS shrink functionality
Message-ID: <20070604084154.GA8273@teal.hq.k1024.org>
References: <1180715974.10796.46.camel@localhost> <20070604001632.GA86004887@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604001632.GA86004887@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Ruben Porras <nahoo82@gmail.com>, xfs@oss.sgi.com, cw@f00f.org

Disclaimer: all the below is based on my weak understanding of the code,
I don't claim I'm right below. 

On Mon, Jun 04, 2007 at 10:16:32AM +1000, David Chinner wrote:
> Any work for this would need to be done against current mainline
> of the xfs-dev tree.
> 
> Yes, that patch is out of date, and it also did things that were not
> necessary i.e. walk btrees to work out if AGs are empty or not.

Well, I did what I could based on my own understanding of the code.
Sorry if it's ugly :)

> > I'm really curious about what happened to this patches and why they were
> > discontinued. The second part never was made public, and there was also
> > no answer. Was there any flaw in any of the posted code or anything in
> > XFS that makes it especially hard to shrink [3] that discouraged the
> > development?
> 
> The posted code is only a *tiny* part of the shrink problem.

My ideea at that time is to start small and be able to shrink an empty
filesystem (or empty at least regarding the AGs that you want to clear).

The point is that if AGs are lockable outside of a transaction
(something like the freeze/unfreeze functionality at the fs level), then
by simply copying the conflicting files you ensure that they are
allocated on an available AG and when you remove the originals, the
to-be-shrinked AGs become free. Yes, utterly non-optimal, but it was the
simplest way to do it based on what I knew at the time.

> > After that, the first questions that arouse are,
> > would there be some assistance/groove in from the developers? 
> 
> Certainly there's help available. ;)
Good to know. If there is at least more documentation about the
internals, I could try to find some time to work on this again.
> 
> > What are the programmers requirements from your point of view?
> 
> Here's the "simple" bits that will allow you to shrink
> the filesystem down to the end of the internal log:
> 
> 	0. Check space is available for shrink
Can be done by actually allocating the space to be freed at the
beggining of the transaction. Right? This is actually a bit more than
needed, since when freeing an AG you also free some non-available space,
but it's ok.

> 	1. Mark allocation groups as "don't use - going away soon"
> 		- so we don't put new stuff in them while we
> 		  are moving all the bits out of them
> 		- requires hooks in the allocators to prevent
> 		  the AG from being selected for allllocations
> 		- must still allow allocations for the free lists
> 		  so that extent freeing can succeed
> 		- *new transaction required*.
> 		- also needs an "undo" (e.g. on partial failure)
> 		  so we need to be able to mark allocation groups
> 		  online again.

So a question: can transaction be nested? Because the offline AG
transation needs to live until the shrink transaction is done. I was
more thinking that the offline-AG should be a bit on the AG that could
be changed by the admin (like xfs_freeze); this could also help for
other reasons than shrink (when on a big FS some AGs lie on a physical
device and others on a different device, and you would like to restrict
writes to a given AG, as much as possible).

> 	2. Move inodes out of offline AGs
> 		- On Irix, we have a program called 'xfs_reno' which
> 		  converts 64 bit inode filesystems to 32 bit inode
> 		  filesystems. This needs to be:
> 		  	- released under the GPL (should not be a problem).
> 			- ported to linux
> 			- modified to understand inodes sit in certain
> 			  AGs and to move them out of those AGs as needed.
> 			- requires filesystem traversal to find all the
> 			  inodes to be moved.
Interesing. I've read on the mail list of this before, but no other
details.

> 
> 		  % wc -l xfs_reno.c
> 		  1991 xfs_reno.c
> 
> 		- even with "-o ikeep", this needs to trigger inode cluster
> 		  deletion in offline AGs (needs hooks in xfs_ifree()).
This part (removal of inodes) is not actually needed if the icount ==
ifree (I presume this means that all the existing inodes are free).

> 	3. Move data out of offline AGs.
> 		- this is difficult to do efficiently as we do not have
> 		  a block-to-owner reverse mapping in the filesystem.
> 		  Hence requires a walk of the *entire* filesystem to find
> 		  the owners of data blocks in the AGs being offlined.
> 		- xfs_db wrapper might be the best way to do this...
> 
> 	<AGs are now empty>
> 
> 	4. Execute shrink
> 		- new transaction - XFS_TRANS_SHRINKFS
> 		- check AGs are empty
> 		  	- icount == 0
> 			- freeblks == mp->m_sb.sb_agblocks
> 			  (will be a little more than this)
> 		- check shrink won't go past end of internal log
> 		- free AGs, updating superblock fields
> 		- update perag structure
> 		  	- not a simple realloc() as there may
> 			  be other threads using the structure at the
> 			  same time....
> 

My suggestion would be to start implementing these steps in reverse. 4)
is the most important as it touches the entire FS. If 4) is working
correctly, then 1) would be simpler (I think) and 3) can be implemented
by just running a forced xfs_fsr against the conflicting files. I don't
know about 2).

Sorry if I'm blatantly wrong in my statements. Good to have more
information!

regards,
iustin
