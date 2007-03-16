Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Mar 2007 12:37:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2GJbX6p028624
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 12:37:35 -0700
Date: Sat, 17 Mar 2007 06:37:22 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Should xfs_repair take this long?
Message-ID: <20070316193722.GA5743@melbourne.sgi.com>
References: <45F92D8C.3090708@stsci.edu> <20070315150422.7bc5d178@harpe.intellique.com> <45F952F2.6000008@stsci.edu> <20070315231031.GP6095633@melbourne.sgi.com> <45FAB480.908@stsci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FAB480.908@stsci.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas Walker <walker@stsci.edu>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Fri, Mar 16, 2007 at 11:15:12AM -0400, Thomas Walker wrote:
>   So maybe I got bit the same way.  parted may be overwritten something 
> at the head of the volume.

Doesn't look like partition blocks at the start of each volume, though.

> Is there any way to repair the super block 
> though?  It seems that everyone agrees xfs can't do anything until it 
> has a super block somewhere and I don't seem to have one.

That's beacuse repair can't work out where things are supposed to
be without a superblock to tell it critical information.
Manually trying to find and repair a superblock is a hit and miss
affair - at this point we don't even know if the primary superblocks
have been overwritten or whether something else is wrong with LVM...

> If there's no 
> way to repair, then what about recovery? 

In a word: backups.

> I see mention of possibly 
> doing an xfs dump to another disk, reformat the original volume, and 
> then xfs restore back.  Is there any online procedure for how to do that 
> if it applies to me here?

You need to be able to mount the filesystem to dump it, so until you
can run repair there's no simple recovery option.

If the lvm config is correct and repair cannot find a valid
secondary superblock, then you really need to start doing dangerous
things to try to recover. i'd suggest taking a copy of the lvm
volumes before doing anything else.

Then, find a secondary superblock in the volume (first 4 bytes of
the sector are "XFSB" in hex) and copy that sector to block zero of
the filesystem. If repair still won't do it's stuff, then you need
to use xfs_db to modify that superblock until it does.  Then when
repair runs, you get to look in lost+found and try to work out what
all the broken bits are.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
