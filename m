Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5MLWuJj123843 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 16:32:56 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BFB9611E7AB7
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 14:32:54 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id l31lUtNzQhkUd7GI
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 14:32:54 -0700 (PDT)
Received: by fxm8 with SMTP id 8so1002427fxm.26
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 14:32:54 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 22 Jun 2011 14:32:53 -0700
Message-ID: <BANLkTi=gS5iO9R9pVk_df-4ofkkb0ZJgfw@mail.gmail.com>
Subject: xfs_repair: "fatal error -- ran out of disk space!"
From: "Patrick J. LoPresti" <lopresti@gmail.com>
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

I have a 5.1TB XFS file system that is 93% full (399G free according to "df").

I am trying to run "xfs_repair" on it.

The output is appended.

Question:  What am I supposed to do about this?  "xfs_repair -V" says
"xfs_repair version 3.1.5".  (I downloaded and built the latest
version hoping it would fix the issue, but no luck.)  Should I just
start deleting files at random?

Any ideas would be appreciated; I am trying to get this server back
up, and restoring 5.1T is not going to be pleasant.

Thanks!

 - Pat


Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
sb_icount 42688, counted 59328
sb_ifree 1, counted 36
sb_fdblocks 104582610, counted 24
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
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 2
        - agno = 3
        - agno = 5
        - agno = 4
        - agno = 1
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...

fatal error -- ran out of disk space!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
