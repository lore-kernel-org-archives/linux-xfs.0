Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 06 Dec 2007 13:06:49 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB6L6YaU030872
	for <xfs@oss.sgi.com>; Thu, 6 Dec 2007 13:06:41 -0800
Date: Fri, 7 Dec 2007 08:06:36 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS_Repair PRoblem
Message-ID: <20071206210636.GM115527101@sgi.com>
References: <14194915.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14194915.post@talk.nabble.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Kingghost <mrlitres@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 06, 2007 at 08:10:21AM -0800, Kingghost wrote:
> 
> Hello,
> 
> So I was seeing my serial link go up and down so I rebooted and everything
> was working fine, except my vg0 wouldnt mount. So I tried to xfs_repair it
> and this is the output I recieved.
> 
> slutb0x:/# xfs_repair -o assume_xfs /dev/vg0/media 
> Phase 1 - find and verify superblock... 
> sb root inode value 18446744073709551615 (NULLFSINO) inconsistent with
> calculated value 128 

NULLFSINO? Something has overwritten your superblock with a bunch of -1
values?

> resetting superblock root inode pointer to 128 
> sb realtime bitmap inode 18446744073709551615 (NULLFSINO) inconsistent with
> calculated value 129 
> resetting superblock realtime bitmap ino pointer to 129 
> sb realtime summary inode 18446744073709551615 (NULLFSINO) inconsistent with
> calculated value 130 
> resetting superblock realtime summary ino pointer to 130 
> Phase 2 - using internal log 
> - zero log... 

Uh-oh - you ran a xfs_repair -L, didn't you?
> 
> missing inbetween 
> 
> rebuilding directory inode 1225702584 
> bad hash table for directory inode 1342177425 (no data entry): rebuilding 

And a bunch of trashed directory structures...

> disconnected dir inode 752117670, moving to lost+found 
> disconnected inode 809433019, moving to lost+found 
> disconnected dir inode 823780059, moving to lost+found 
> disconnected dir inode 823780089, moving to lost+found 
> 
> fatal error -- creation of .. entry failed (117), filesystem may be out of
> space 

117 = EUCLEAN - corrupted filesystem. Sounds like there's more corruption
there than was discovered or the underlying disk is still corruption blocks.
What version of repair are you running ?

This is a dying disk you're trying to repair right?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
