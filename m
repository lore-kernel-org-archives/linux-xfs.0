Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Mar 2007 08:16:53 -0800 (PST)
Received: from nz-out-0506.google.com (nz-out-0506.google.com [64.233.162.225])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l21GGj6p017391
	for <xfs@oss.sgi.com>; Thu, 1 Mar 2007 08:16:46 -0800
Received: by nz-out-0506.google.com with SMTP id m22so431561nzf
        for <xfs@oss.sgi.com>; Thu, 01 Mar 2007 08:16:45 -0800 (PST)
Message-ID: <29a617af0703010748g51ef81b1x9c0467602d09793@mail.gmail.com>
Date: Thu, 1 Mar 2007 16:48:41 +0100
From: "M Kili" <m0kili@gmail.com>
Subject: can't mount xfs partition
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Background:

Windows XP installation overwrote the MBR with broken partition
layout. I used gpart to figure out the partition table. Primary
partitions were detected correctly and can be mounted, unfortunately
all important data are in logical partitions, most of which are XFS.
The beginings of the partitions were found, but the ends might be a
little off, I don't know.

If I try to mount any of the XFS partitions, I get this message:

mount: /dev/hda5: can't read superblock

I dded this partition to a file and run xfs_repair with this result:

# xfs_repair -f hda5.img
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - clear lost+found (if it exists) ...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - ensuring existence of lost+found directory
        - traversing filesystem starting at / ...
        - traversal finished ...
        - traversing all unattached subtrees ...
        - traversals finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
------------------------------------------------

xfs_check doesn't give any message, and still, the image can't be
mounted, with the same error:
# mount -o loop hda5.img /mnt/
mount: /dev/loop0: can't read superblock

Output of fdisk print partition table (5, 6, 7, and 9 are XFS):

Disk /dev/hda: 320.0 GB, 320072933376 bytes
86 heads, 15 sectors/track, 484606 cylinders, total 625142448 sectors
Units = sectors of 1 * 512 = 512 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/hda1              63    37752742    18876340   83  Linux
/dev/hda2        37752750    37833073       40162   83  Linux
/dev/hda3        37833075    48323504     5245215   83  Linux
/dev/hda4        48323505   625142447   288409471+   5  Extended
/dev/hda5        48323521    87389120    19532800   83  Linux
/dev/hda6        87409666   560228673   236409504   83  Linux
/dev/hda7       560459656   581660935    10600640   83  Linux
/dev/hda8       581681521   582741795      530137+  82  Linux swap / Solaris
/dev/hda9       582741811   625116634    21187412   83  Linux

Is there any help?

Another question: I'm running now on one older hd, however, it has
some read errors. Is it possible to use the already discovered

Thanks, Marek
