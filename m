Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Oct 2006 18:13:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9C1DXaG013062
	for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 18:13:36 -0700
Date: Thu, 12 Oct 2006 11:12:46 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: [UNSURE] Re: Software raid 5 with XFS causing strange lockup
 problems
Message-ID: <CEE324EA1343CC78767B563F@boing.melbourne.sgi.com>
In-Reply-To: <acd894d40610111210o6468f40kd99ee6e0f5b148e1@mail.gmail.com>
References: <acd894d40610102307n7fd07108u67d1b1015eeeb594@mail.gmail.com>	
 <452CF770.5050902@sandeen.net>	
 <acd894d40610110921j61bcf5cdn57887c386f54f6c8@mail.gmail.com>	
 <Pine.LNX.4.64.0610111318570.27351@p34.internal.lan>	
 <acd894d40610111141p6895995dq89fd5b19b59222d5@mail.gmail.com>	
 <Pine.LNX.4.64.0610111442180.27351@p34.internal.lan>
 <acd894d40610111210o6468f40kd99ee6e0f5b148e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ian Williamson <notian@gmail.com>, xfs@oss.sgi.com

Hi Ian,

--On 11 October 2006 2:10:28 PM -0500 Ian Williamson <notian@gmail.com> 
wrote:

> /dev/md0:
>  Timing buffered disk reads:  286 MB in  3.01 seconds =  94.97 MB/sec
>
> For write I don't have pipebench installed, and this isn't internet
> facing at the moment, so I can't install it.
>
> I just ran an xfs_repair on /dev/md0 and it did this:
> -------------------------------------------------------------------------
> ian@ionlinux:~$ sudo xfs_repair /dev/md0
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>        - zero log...
>        - scan filesystem freespace and inode maps...
>        - found root inode chunk
> Phase 3 - for each AG...
>        - scan and clear agi unlinked lists...
>        - process known inodes and perform inode discovery...
>        - agno = 0
> bad attribute format 0 in inode 260, resetting value
>        - agno = 1
> inode 135921976 - bad extent starting block number 955543538733351,
> offset 2405220210012692
> bad data fork in inode 135921976
> cleared inode 135921976
> zero length extent (off = 0, fsbno = 0) in ino 136766006
> bad data fork in inode 136766006
> cleared inode 136766006
>        - agno = 2
> inode 268439335 - bad extent starting block number 4389451776, offset
> 8989827926016
> bad data fork in inode 268439335
> cleared inode 268439335
>        - agno = 3
> inode 402653478 - bad extent starting block number 6493419520, offset
> 123364807018496
> bad data fork in inode 402653478
> cleared inode 402653478
>        - agno = 4
>        - agno = 5
>        - agno = 6
>        - agno = 7
> inode 939524376 - bad extent starting block number 384617748308622,
> offset 13946791523993872
> bad data fork in inode 939524376
> cleared inode 939524376
>        - agno = 8
>        - agno = 9
>        - agno = 10
>        - agno = 11
>        - agno = 12
>        - agno = 13
>        - agno = 14
>        - agno = 15
>        - agno = 16
>        - agno = 17
>        - agno = 18
>        - agno = 19
> inode 2550140476 - bad extent starting block number 3836083423429920,
> offset 1232124454554406
> bad data fork in inode 2550140476
> cleared inode 2550140476
>        - agno = 20
>        - agno = 21
> inode 2818586148 - bad extent starting block number 2465278532745658,
> offset 9727159296556827
> bad data fork in inode 2818586148
> cleared inode 2818586148
>        - agno = 22
>        - agno = 23
>        - agno = 24
>        - agno = 25
>        - agno = 26
>        - agno = 27
>        - agno = 28
>        - agno = 29
>        - agno = 30
>        - agno = 31
>        - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>        - setting up duplicate extent list...
>        - clear lost+found (if it exists) ...
>        - clearing existing "lost+found" inode
>        - deleting existing "lost+found" entry
>        - check for inodes claiming duplicate blocks...
>        - agno = 0
>        - agno = 1
> entry "07 - Film Score Pt. II.mp3" at block 0 offset 312 in directory
> inode 135921969 references free inode 135921976
>        clearing inode number in entry at offset 312...
> entry "Torrent downloaded from Demonoid.com.txt" in shortform
> directory 136766004 references free inode 136766006
> junking entry "Torrent downloaded from Demonoid.com.txt" in directory
> inode 136766004
>        - agno = 2
> entry "robot_worldlight.png" at block 3 offset 2608 in directory inode
> 268436754 references free inode 268439335
>        clearing inode number in entry at offset 2608...
>        - agno = 3
> entry "automail.php" at block 0 offset 104 in directory inode
> 402653475 references free inode 402653478
>        clearing inode number in entry at offset 104...
>        - agno = 4
>        - agno = 5
>        - agno = 6
>        - agno = 7
> entry "core.write_compiled_include.php" at block 0 offset 808 in
> directory inode 939524356 references free inode 939524376
>        clearing inode number in entry at offset 808...
>        - agno = 8
>        - agno = 9
>        - agno = 10
>        - agno = 11
>        - agno = 12
>        - agno = 13
>        - agno = 14
>        - agno = 15
>        - agno = 16
>        - agno = 17
>        - agno = 18
>        - agno = 19
> entry "auth.php" at block 0 offset 48 in directory inode 2550140475
> references free inode 2550140476
>        clearing inode number in entry at offset 48...
>        - agno = 20
>        - agno = 21
> entry "IMG_0245.jpg" at block 0 offset 1944 in directory inode
> 2818581782 references free inode 2818586148
>        clearing inode number in entry at offset 1944...
>        - agno = 22
>        - agno = 23
>        - agno = 24
>        - agno = 25
>        - agno = 26
>        - agno = 27
>        - agno = 28
>        - agno = 29
>        - agno = 30
>        - agno = 31
> Phase 5 - rebuild AG headers and trees...
>        - reset superblock...
> Phase 6 - check inode connectivity...
>        - resetting contents of realtime bitmap and summary inodes
>        - ensuring existence of lost+found directory
>        - traversing filesystem starting at / ...
> rebuilding directory inode 135921969
> rebuilding directory inode 2818581782
> rebuilding directory inode 2550140475
> rebuilding directory inode 268436754
> rebuilding directory inode 402653475
> rebuilding directory inode 939524356
>        - traversal finished ...
>        - traversing all unattached subtrees ...
>        - traversals finished ...
>        - moving disconnected inodes to lost+found ...
> disconnected dir inode 3221929786, moving to lost+found
> Phase 7 - verify and correct link counts...
> done
> -------------------------------------------------------------------------
> Right now I am copying a 20Gig directory off of the raid onto another
> drive with no problems. Does an xfs filesystem need to be repaired on
> a regular basis?

Ideally, no :-)
We don't expect corruption on a regular basis :)

> Any ideas on what might be "corrupting" it?
No sorry.
Some random thoughts:
Has the filesystem had any unclean mounts? Like due to power loss?
Do you have a "Disabling barriers" msg in your logs for xfs?
What were your mkfs and mount parameters, version of linux?
Before repairing the filesystem, you can run "xfsrepair -n" to find
the errors and then get a better print out of the inodes using
"xfs_db -r -c 'inode xxxx' -c 'p' device".

--Tim
