Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2JHJ9MK212457 for <xfs@oss.sgi.com>; Fri, 19 Mar 2010 12:19:09 -0500
Received: from mailout3.echostar.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE92D2623A2
	for <xfs@oss.sgi.com>; Fri, 19 Mar 2010 10:20:47 -0700 (PDT)
Received: from mailout3.echostar.com (mailout3.echostar.com [204.76.128.104])
	by cuda.sgi.com with ESMTP id aSCiOJfvsKGlei0J for
	<xfs@oss.sgi.com>; Fri, 19 Mar 2010 10:20:47 -0700 (PDT)
From: "Agarwal, Amit" <Amit.Agarwal@echostar.com>
Date: Fri, 19 Mar 2010 11:20:39 -0600
Subject: xfs_repair deletes file
Message-ID: <FF09DFEC8ECE664A856A5010EAF760BD0AF56074B4@ECHOEXCC1.SATS.CORP>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi 

I need some help related to xfs repair. 

xfs_repair is deleting files which are more than ~10G from the real time partition.  This is happening quite frequently.

xfs_repair version 3.0.0
Linux ->  2.6.18.8

Following is the output of xfs_repair

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
data fork in rt inode 16779171 claims used rt block 16538
bad data fork in inode 16779171
cleared inode 16779171
data fork in rt inode 16779185 claims used rt block 24441
bad data fork in inode 16779185
cleared inode 16779185
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
entry "es33554469.tsp" at block 0 offset 4040 in directory inode 16777344 references free inode 16779171
        clearing inode number in entry at offset 4040...
entry "es33554472.tsp" at block 1 offset 432 in directory inode 16777344 references free inode 16779185
        clearing inode number in entry at offset 432...
        - agno = 2
        - agno = 3
Phase 5 - rebuild AG headers and trees...
        - generate realtime summary info and bitmap...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
bad hash table for directory inode 16777344 (no data entry): rebuilding
rebuilding directory inode 16777344
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

Thanks for your time

Amit Agarwal


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
