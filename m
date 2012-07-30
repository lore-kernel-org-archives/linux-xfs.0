Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6UG0ZDb058548 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 11:00:35 -0500
Received: from oxmail.registrar-servers.com (oxmail.registrar-servers.com
	[64.22.89.133]) by cuda.sgi.com with ESMTP id GbsQafp5L1Ly9YtF
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 09:00:34 -0700 (PDT)
Received: from app1.ox.registrar-servers.com (app1.ox.registrar-servers.com
	[172.20.180.3]) (using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by oxmail.registrar-servers.com (Postfix) with ESMTPSA id 7CB73C30001
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 12:00:34 -0400 (EDT)
Date: Mon, 30 Jul 2012 18:00:34 +0200 (CEST)
From: "jamie@x-edit.co.uk" <jamie@x-edit.co.uk>
Message-ID: <769346391.171271.1343664034505.JavaMail.open-xchange@oxwebmail.registrar-servers.com>
Subject: xfs_repair no modify output
MIME-Version: 1.0
Reply-To: "jamie@x-edit.co.uk" <jamie@x-edit.co.uk>
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
To: xfs@oss.sgi.com

Hi List,
Sorry for the stupid question, just wanted a quick clarification on the
following excerpts from an xfs_repair no modify.

# xfs_repair -nv /dev/sdc1
Phase 1 - find and verify superblock...
        - block cache size set to 115088 entries
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
bad nblocks 717 for inode 146, would reset to 716
bad nblocks 2 for inode 147, would reset to 1
        - agno = 1
 <SNIP>
        - agno = 27
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
bad nblocks 717 for inode 146, would reset to 716
bad nblocks 2 for inode 147, would reset to 1
        - agno = 1
 <SNIP>
        - agno = 27
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - agno = 0
entry "xxxx" in directory inode 128 not consistent with .. value (8589934720) in
inode 134,
would junk entry
        - agno = 1
entry "YYYY" in dir 4294967424 points to an already connected directory inode
145
        would clear entry "YYYY"
        - agno = 2
 <SNIP>
        - agno = 27
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected dir inode 4294967424, would move to lost+found
Phase 7 - verify link counts...
would have reset inode 128 nlinks from 6 to 5
would have reset inode 146 nlinks from 1 to 2
would have reset inode 147 nlinks from 1 to 2
No modify flag set, skipping filesystem flush and exiting.

        XFS_REPAIR Summary    Mon Jul 30 12:58:03 2012

Phase           Start           End             Duration
Phase 1:        07/30 12:53:40  07/30 12:53:40
Phase 2:        07/30 12:53:40  07/30 12:53:49  9 seconds
Phase 3:        07/30 12:53:49  07/30 12:55:33  1 minute, 44 seconds
Phase 4:        07/30 12:55:33  07/30 12:57:10  1 minute, 37 seconds
Phase 5:        Skipped
Phase 6:        07/30 12:57:10  07/30 12:58:03  53 seconds
Phase 7:        07/30 12:58:03  07/30 12:58:03

Total run time: 4 minutes, 23 seconds

Does this in effect mean that the file YYYY will end up and lost+found and
directory (and its contents) will end up in lost+found.
Namely easy enough to move back. Or will the contents of XXXX be lost?

Cheers
   Jamie

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
