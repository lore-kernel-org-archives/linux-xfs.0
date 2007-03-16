Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Mar 2007 13:09:08 -0700 (PDT)
Received: from donner.stsci.edu (donner.stsci.edu [130.167.251.65])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2GK926p002775
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 13:09:04 -0700
From: Thomas Walker <walker@stsci.edu>
Subject: Re: Should xfs_repair take this long?
Reply-To: walker@stsci.edu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070316160900.CNS43969@comet.stsci.edu>
Date: Fri, 16 Mar 2007 16:09:00 -0400 (EDT)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com


  I already had xfs_repair scan the entire 6TB (took it 56 hours, which is the reason for the subject line).  So it couldn't find a SB anywhere on that volume and it walked all over it.  Therefore I guess the SB has been overwritten by something, maybe parted.  As for the LVM physicals being in the wrong order, I can try to reverse them but I'm really pretty sure I have it right.  Still, since the scan by xfs_repair couldn't find a SB anywhere I don't know what I would gain.

   We don't have a backup of these volumes, but I'm told by the user that almost all the data can be retrieved again from our archive, it's just a pain in the neck to do that.  So while it would be nice to recover it won't be critical.

   Before wrapping this up, if you could just clarify a couple things.  If I look at the bytes at the beginning of each physical part of the LVM's, what am I looking for?  "XFSB"?  If I do find that byte string, why couldn't xfs_repair find it when it did the scan and what do I do with it if I do find one?  We see a software product call ufsexplorer that claims to be able to recover data without an XFS super block, anybody try it?

    I appreciate your help and time,

  Thomas Walker

---- Original message ----
>Date: Sat, 17 Mar 2007 06:37:22 +1100
>From: David Chinner <dgc@sgi.com>  
>Subject: Re: Should xfs_repair take this long?  
>To: Thomas Walker <walker@stsci.edu>
>Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com
>
>On Fri, Mar 16, 2007 at 11:15:12AM -0400, Thomas Walker wrote:
>>   So maybe I got bit the same way.  parted may be overwritten something 
>> at the head of the volume.
>
>Doesn't look like partition blocks at the start of each volume, though.
>
>> Is there any way to repair the super block 
>> though?  It seems that everyone agrees xfs can't do anything until it 
>> has a super block somewhere and I don't seem to have one.
>
>That's beacuse repair can't work out where things are supposed to
>be without a superblock to tell it critical information.
>Manually trying to find and repair a superblock is a hit and miss
>affair - at this point we don't even know if the primary superblocks
>have been overwritten or whether something else is wrong with LVM...
>
>> If there's no 
>> way to repair, then what about recovery? 
>
>In a word: backups.
>
>> I see mention of possibly 
>> doing an xfs dump to another disk, reformat the original volume, and 
>> then xfs restore back.  Is there any online procedure for how to do that 
>> if it applies to me here?
>
>You need to be able to mount the filesystem to dump it, so until you
>can run repair there's no simple recovery option.
>
>If the lvm config is correct and repair cannot find a valid
>secondary superblock, then you really need to start doing dangerous
>things to try to recover. i'd suggest taking a copy of the lvm
>volumes before doing anything else.
>
>Then, find a secondary superblock in the volume (first 4 bytes of
>the sector are "XFSB" in hex) and copy that sector to block zero of
>the filesystem. If repair still won't do it's stuff, then you need
>to use xfs_db to modify that superblock until it does.  Then when
>repair runs, you get to look in lost+found and try to work out what
>all the broken bits are.....
>
>Cheers,
>
>Dave.
>-- 
>Dave Chinner
>Principal Engineer
>SGI Australian Software Group
