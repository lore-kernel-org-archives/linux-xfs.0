Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EF99B7F54
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 05:17:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D5CFF8F804C
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 03:17:31 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id blGc1lCJsVXPSQDR for
	<xfs@oss.sgi.com>; Tue, 09 Apr 2013 03:17:29 -0700 (PDT)
Received: from harpe.intellique.com (unknown [82.225.196.72])
	by smtp4-g21.free.fr (Postfix) with ESMTP id 54E2B4C8425
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 12:17:25 +0200 (CEST)
Date: Tue, 9 Apr 2013 12:17:26 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: xfs_repair has been running for a very long time, no disk IO.
Message-ID: <20130409121726.6342519e@harpe.intellique.com>
Mime-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


On a quite badly mangled filesystem, xfs_repair (v. 3.1.4) seems to
never end. It has run for 16 hours with absolutely no disk activity.

Usually xfs_repair takes much less than one hour on a similar (9 TB)
filesystem.

I know I should try the latest version. What else can be wrong? 
What should I try?

Last lines of output of the still running xfs_repair where it has 
been stuck since yesterday night:

entry "Panel-2333" at block 3 offset 2464 in directory inode 2190114192 references non-existent inode 60238299
        clearing inode number in entry at offset 2464...
entry "Panel-2316" at block 3 offset 2512 in directory inode 2190114192 references non-existent inode 60238300
        clearing inode number in entry at offset 2512...
entry "Panel-2309" at block 3 offset 2560 in directory inode 2190114192 references non-existent inode 60238301
        clearing inode number in entry at offset 2560...
entry "Panel-2292" at block 3 offset 2608 in directory inode 2190114192 references non-existent inode 60238302
        clearing inode number in entry at offset 2608...
entry "Panel-2290" at block 3 offset 2656 in directory inode 2190114192 references non-existent inode 60238303
        clearing inode number in entry at offset 2656...
bad attribute format 1 in inode 2190120814, resetting value
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
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...



-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
