Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n141ZUAb107633 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 19:35:30 -0600
Received: from poopey.oranged.to (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CC48E2C34
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 17:34:50 -0800 (PST)
Received: from poopey.oranged.to (poopey.oranged.to [213.198.65.20]) by
	cuda.sgi.com with ESMTP id 69wlpoZWrfOETcgT for
	<xfs@oss.sgi.com>; Tue, 03 Feb 2009 17:34:50 -0800 (PST)
Message-Id: <5CCF20F5-33D5-409E-BB27-5E1C5CB4D9E5@alink.co.za>
From: George Barnett <george@alink.co.za>
In-Reply-To: <4988EF37.7020306@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: XFS corruption on ubuntu 2.6.27-9-server
Date: Wed, 4 Feb 2009 12:34:45 +1100
References: <2653B83E-85DA-4949-BCED-AF2BA3D324E1@alink.co.za>
	<4988EF37.7020306@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 04/02/2009, at 12:28 PM, Eric Sandeen wrote:

> George Barnett wrote:
>> Hi,
>>
>> I'm seeing the following errors:
>>
>> [822153.422851] Filesystem "md2": XFS internal error xfs_da_do_buf(2)
>> at line 2107 of file /build/buildd/linux-2.6.27/fs/xfs/
>
> we really should make that more informative.
>
> What it means is that you read a piece of metadata that did not match
> any of the metadata magic numbers.
>
> hard to say whether it might be an xfs bug I think; this does come up
> occasionally though and it'd at least be nice to print more details on
> the error (what the magic *was*, what block, etc)
>
> Do you happen to have the repair output?
>
> Did your md raid lose power w/ write cache enabled?

Hi Eric,

Thanks for your response.  The system did not lose power.  This  
failure just "happens".  I have a cronjob which rsync's /data to a  
spare drive that's not on raid.  It seems that is enough to cause this  
failure.

Fortunately, I still have the xfs_repair output in my term buffer:

root@slut:/# xfs_repair /dev/md2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
         - zero log...
         - scan filesystem freespace and inode maps...
         - found root inode chunk
Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno = 0
bad magic number 0x0 on inode 18042
bad version number 0x0 on inode 18042
bad magic number 0x0 on inode 18043
bad version number 0x0 on inode 18043
bad magic number 0x0 on inode 18044
bad version number 0x0 on inode 18044
bad magic number 0x0 on inode 18045
bad version number 0x0 on inode 18045
bad magic number 0x0 on inode 18046
bad version number 0x0 on inode 18046
bad magic number 0x0 on inode 18047
bad version number 0x0 on inode 18047
bad directory block magic # 0 in block 0 for directory inode 18000
corrupt block 0 in directory inode 18000
	will junk block
no . entry for directory 18000
no .. entry for directory 18000
problem with directory contents in inode 18000
cleared inode 18000
bad directory block magic # 0 in block 0 for directory inode 18006
corrupt block 0 in directory inode 18006
	will junk block
no . entry for directory 18006
no .. entry for directory 18006
problem with directory contents in inode 18006
cleared inode 18006
bad magic number 0x0 on inode 18042, resetting magic number
bad version number 0x0 on inode 18042, resetting version number
imap claims a free inode 18042 is in use, correcting imap and clearing  
inode
cleared inode 18042
bad magic number 0x0 on inode 18043, resetting magic number
bad version number 0x0 on inode 18043, resetting version number
imap claims a free inode 18043 is in use, correcting imap and clearing  
inode
cleared inode 18043
bad magic number 0x0 on inode 18044, resetting magic number
bad version number 0x0 on inode 18044, resetting version number
imap claims a free inode 18044 is in use, correcting imap and clearing  
inode
cleared inode 18044
bad magic number 0x0 on inode 18045, resetting magic number
bad version number 0x0 on inode 18045, resetting version number
imap claims a free inode 18045 is in use, correcting imap and clearing  
inode
cleared inode 18045
bad magic number 0x0 on inode 18046, resetting magic number
bad version number 0x0 on inode 18046, resetting version number
imap claims a free inode 18046 is in use, correcting imap and clearing  
inode
cleared inode 18046
bad magic number 0x0 on inode 18047, resetting magic number
bad version number 0x0 on inode 18047, resetting version number
imap claims a free inode 18047 is in use, correcting imap and clearing  
inode
cleared inode 18047
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
         - agno = 16
         - agno = 17
         - agno = 18
         - agno = 19
         - agno = 20
         - agno = 21
         - agno = 22
         - agno = 23
         - agno = 24
         - agno = 25
         - agno = 26
         - agno = 27
         - agno = 28
         - agno = 29
         - agno = 30
         - agno = 31
         - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - check for inodes claiming duplicate blocks...
         - agno = 0
         - agno = 1
         - agno = 2
         - agno = 3
entry "classes.nib" in shortform directory 18009 references free inode  
18047
junking entry "classes.nib" in directory inode 18009
         - agno = 4
         - agno = 5
         - agno = 6
         - agno = 7
entry "Spanish.lproj" at block 0 offset 296 in directory inode  
1610630695 references free inode 18000
	clearing inode number in entry at offset 296...
         - agno = 8
         - agno = 9
         - agno = 10
         - agno = 11
         - agno = 12
         - agno = 13
         - agno = 14
         - agno = 15
         - agno = 16
         - agno = 17
         - agno = 18
         - agno = 19
         - agno = 20
         - agno = 21
         - agno = 22
         - agno = 23
         - agno = 24
         - agno = 25
         - agno = 26
         - agno = 27
         - agno = 28
         - agno = 29
         - agno = 30
         - agno = 31
entry "Resources" in shortform directory 4049684106 references free  
inode 18006
junking entry "Resources" in directory inode 4049684106
Phase 5 - rebuild AG headers and trees...
         - reset superblock...
Phase 6 - check inode connectivity...
         - resetting contents of realtime bitmap and summary inodes
         - traversing filesystem ...
bad hash table for directory inode 1610630695 (no data entry):  
rebuilding
rebuilding directory inode 1610630695
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
disconnected dir inode 18007, moving to lost+found
disconnected inode 18024, moving to lost+found
disconnected inode 18025, moving to lost+found
disconnected inode 18026, moving to lost+found
disconnected inode 18027, moving to lost+found
disconnected inode 18028, moving to lost+found
disconnected inode 18029, moving to lost+found
disconnected inode 18030, moving to lost+found
disconnected inode 18031, moving to lost+found
disconnected inode 18037, moving to lost+found
disconnected inode 18038, moving to lost+found
disconnected inode 18039, moving to lost+found
disconnected inode 18040, moving to lost+found
disconnected inode 18041, moving to lost+found
disconnected dir inode 268452448, moving to lost+found
disconnected dir inode 268452449, moving to lost+found
disconnected dir inode 536889431, moving to lost+found
disconnected dir inode 536889432, moving to lost+found
disconnected dir inode 805323820, moving to lost+found
disconnected dir inode 805323821, moving to lost+found
disconnected dir inode 1073761501, moving to lost+found
disconnected dir inode 1073761502, moving to lost+found
disconnected dir inode 1342194790, moving to lost+found
disconnected dir inode 1342194791, moving to lost+found
disconnected dir inode 1610630702, moving to lost+found
disconnected dir inode 1879067163, moving to lost+found
disconnected dir inode 2147967564, moving to lost+found
disconnected dir inode 2436769389, moving to lost+found
disconnected dir inode 2703685645, moving to lost+found
disconnected dir inode 2703685648, moving to lost+found
disconnected dir inode 2970453601, moving to lost+found
disconnected dir inode 3240533616, moving to lost+found
disconnected dir inode 3508468806, moving to lost+found
disconnected dir inode 3777743419, moving to lost+found
disconnected dir inode 4049684107, moving to lost+found
Phase 7 - verify and correct link counts...
resetting inode 5682 nlinks from 2 to 24
resetting inode 1610630695 nlinks from 21 to 20
resetting inode 4049684106 nlinks from 3 to 2
done

Regards,

George

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
