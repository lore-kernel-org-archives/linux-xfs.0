Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from gourmet.spamgourmet.com ([216.75.62.102]:57435 "EHLO
        gourmet8.spamgourmet.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1758720AbeAIApB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jan 2018 19:45:01 -0500
Received: from spamgourmet by gourmet7.spamgourmet.com with local (Exim 4.80)
        (envelope-from <xfs.pkoch@dfgh.net>)
        id 1eYi2H-0005ha-Ol
        for linux-xfs@vger.kernel.org; Tue, 09 Jan 2018 00:45:01 +0000
From: xfs.pkoch@dfgh.net
Subject: Re: Growing RAID10 with active XFS filesystem
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia> <20180108220139.GB16421@dastard>
Message-ID: <81974a30-7cc7-8a84-7823-b17b6222bb90@gmail.com>
Date: Tue, 9 Jan 2018 00:44:57 +0100
MIME-Version: 1.0
In-Reply-To: <20180108220139.GB16421@dastard>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: mdraid.pkoch.3c0485e297.linux-raid#vger.linux-xfs@vger.kernel.orglinux-xfs@vger.kernel.org

Hi Dave and Derrick:

Thanks for answers - seems like my interpretation of the
blocknumber was wrong.

So the culprit is the md-driver again. It's producing I/O-errors
without any hardware-errors.

The machine was setup in 2013 so everything is 5 years old
besides the xfsprogs which I compiled yesterday.

xfs_repair output is very long and my impression is that things
were getting worse with every invocation. xfs_repair itself seemed
to have problems. I don't remeber the exact message but
xfs_repair was complainig a lot about a failed write verifier test.

I will copy as much data as I can from the corrupt filesystem to
our new system. For most files we have md5 checksums so I
can test wether their contents are OK or not.

I started xfs_repair -n 20 minutes ago an it has already printed
1165088 lines of messages

Here are some of these lines:

Phase 1 - find and verify superblock...
         - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
         - zero log...
         - scan filesystem freespace and inode maps...
block (30,18106993-18106993) multiply claimed by cnt space tree, state - 2
block (30,18892669-18892669) multiply claimed by cnt space tree, state - 2
block (30,18904839-18904839) multiply claimed by cnt space tree, state - 2
block (30,19815542-19815542) multiply claimed by cnt space tree, state - 2
block (30,15440783-15440783) multiply claimed by cnt space tree, state - 2
block (30,17658438-17658438) multiply claimed by cnt space tree, state - 2
block (30,18749167-18749167) multiply claimed by cnt space tree, state - 2
block (30,19778684-19778684) multiply claimed by cnt space tree, state - 2
block (30,19951864-19951864) multiply claimed by cnt space tree, state - 2
block (30,19816441-19816441) multiply claimed by cnt space tree, state - 2
block (30,18742154-18742154) multiply claimed by cnt space tree, state - 2
block (30,18132613-18132613) multiply claimed by cnt space tree, state - 2
block (30,15502870-15502870) multiply claimed by cnt space tree, state - 2
agf_freeblks 12543116, counted 12543086 in ag 9
block (30,18168170-18168170) multiply claimed by cnt space tree, state - 2
agf_freeblks 6317001, counted 6316991 in ag 25
agf_freeblks 8962131, counted 8962128 in ag 0
block (1,6142-6142) multiply claimed by cnt space tree, state - 2
block (1,6150-6150) multiply claimed by cnt space tree, state - 2
agf_freeblks 8043945, counted 8043942 in ag 21
agf_freeblks 6833504, counted 6833499 in ag 24
block (1,5777-5777) multiply claimed by cnt space tree, state - 2
agf_freeblks 9032166, counted 9032109 in ag 19
agf_freeblks 16877231, counted 16874747 in ag 30
agf_freeblks 6645873, counted 6645861 in ag 27
block (1,8388992-8388992) multiply claimed by cnt space tree, state - 2
agf_freeblks 21229271, counted 21234873 in ag 1
agf_freeblks 11090766, counted 11090638 in ag 14
agf_freeblks 8424280, counted 8424279 in ag 13
agf_freeblks 1618763, counted 1618764 in ag 16
agf_freeblks 5380834, counted 5380831 in ag 15
agf_freeblks 11211636, counted 11211543 in ag 12
agf_freeblks 14135461, counted 14135434 in ag 11
sb_fdblocks 344528311, counted 344530989
         - 00:51:27: scanning filesystem freespace - 32 of 32 allocation 
groups done
         - found root inode chunk
Phase 3 - for each AG...
         - scan (but don't clear) agi unlinked lists...
         - 00:51:27: scanning agi unlinked lists - 32 of 32 allocation 
groups done
         - process known inodes and perform inode discovery...
         - agno = 0
         - agno = 30
         - agno = 15
bad nblocks 17 for inode 64425222202, would reset to 18
bad nextents 12 for inode 64425222202, would reset to 13
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
Metadata corruption detected at xfs_dir3_data block 0x4438f5c60/0x1000
entry "/463380382.M621183P10446.mail,S=2075,W=2116" at block 12 offset 
2192 in directory inode 64425222202 references invalid inode 
18374686479671623679
         would clear inode number in entry at offset 2192...
entry at block 12 offset 2192 in directory inode 64425222202 has illegal 
name "/463380382.M621183P10446.mail,S=2075,W=2116": would clear entry
entry "/463466963.M420615P6276.mail,S=2202,W=2261" at block 12 offset 
2472 in directory inode 64425222202 references invalid inode 
18374686479671623679
         would clear inode number in entry at offset 2472...
entry at block 12 offset 2472 in directory inode 64425222202 has illegal 
name "/463466963.M420615P6276.mail,S=2202,W=2261": would clear entry
entry "/463980159.M342359P4014.mail,S=3285,W=3378" at block 12 offset 
3376 in directory inode 64425222202 references invalid inode 
18374686479671623679
         would clear inode number in entry at offset 3376...
entry at block 12 offset 3376 in directory inode 64425222202 has illegal 
name "/463980159.M342359P4014.mail,S=3285,W=3378": would clear entry
entry "/463984373.M513992P19720.mail,S=10818,W=11143" at block 12 offset 
3432 in directory inode 64425222202 references invalid inode 
18374686479671623679
.....
..... thousends of messages about direcotry inodes referencing inode 
0xfeffffffffffffff
..... and illegal names where first character has been replaced by /
..... most agno have these messages, but some agnos are fine
.....
Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - 01:10:03: setting up duplicate extent list - 32 of 32 
allocation groups done
         - check for inodes claiming duplicate blocks...
         - agno = 15
         - agno = 30
         - agno = 0
entry ".." at block 0 offset 32 in directory inode 128849025043 
references non-existent inode 124835665944
entry ".." at block 0 offset 32 in directory inode 128849348634 
references non-existent inode 124554268735
entry ".." at block 0 offset 32 in directory inode 128849348643 
references non-existent inode 124554274826
entry ".." at block 0 offset 32 in directory inode 128849350697 
references non-existent inode 4295153945
entry ".." at block 0 offset 32 in directory inode 128849352738 
references non-existent inode 124554268679
entry ".." at block 0 offset 32 in directory inode 128849352744 
references non-existent inode 124554268687
entry ".." at block 0 offset 32 in directory inode 128849393697 
references non-existent inode 124554315786
entry ".." at block 0 offset 32 in directory inode 128849397786 
references non-existent inode 124678412289
entry ".." at block 0 offset 32 in directory inode 128849397815 
references non-existent inode 124678412340
entry ".." at block 0 offset 32 in directory inode 128849397821 
references non-existent inode 4295878668
entry ".." at block 0 offset 32 in directory inode 128849399852 
references non-existent inode 124554274851
entry ".." at block 0 offset 32 in directory inode 128849399867 
references non-existent inode 4295020775
entry ".." at block 0 offset 32 in directory inode 128849403936 
references non-existent inode 124554340368
entry ".." at block 0 offset 32 in directory inode 128849412109 
references non-existent inode 124554403877
entry ".." at block 0 offset 32 in directory inode 64425142305 
references non-existent inode 4295153925
bad nblocks 17 for inode 64425222202, would reset to 18
bad nextents 12 for inode 64425222202, would reset to 13
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
Metadata corruption detected at xfs_dir3_data block 0x4438f5c60/0x1000
would clear entry
would clear entry
would clear entry
.....
..... entry ".." at block 0 offset 32 - messages repeat over and over 
with differnt inodes
.....

Phase 5 which produced a lot of messages as well is missing
when the -n option is used.

> You added one device, not two. That's a recipe for a reshape that
> moves every block of data in the device to a different location.
Of course I was planning to add another one. If I add both in one
step I cannot predict which disk will end up in disk set-A and which
will end up in disk set-B. Since both disk sets are at different location
I have to add the additional disk at location-A first and then the second
disk at location B. Adding two disks in one step does move every
piece of data as well.

> IOWs, within /a second/ of the reshape starting, the active, error
> free XFS filesystem received hundreds of IO errors on both read and
> write IOs from the MD device and shut down the filesystem.
>
> XFS is just the messenger here - something has gone badly wrong at
> the MD layer when the reshape kicked off.
You are right - and this has happened without hardware-problems.
> Yeah, I'd like to see that output (from 4.9.0) too, but experience
> tells me it did nothing helpful w.r.t data recovery from a badly
> corrupted device.... :/
You are right again.

>> This looks like a severe XFS-problem to me.
> I'll say this again: tHe evidence does not support that conclusion.
So let's see  what the MD-experts have to say.

Kind regards

Peter

