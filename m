Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4F8ZnQK020933 for <xfs@oss.sgi.com>; Fri, 15 May 2009 03:35:50 -0500
Received: from mail-bw0-f226.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 45B88F084DC
	for <xfs@oss.sgi.com>; Fri, 15 May 2009 01:40:45 -0700 (PDT)
Received: from mail-bw0-f226.google.com (mail-bw0-f226.google.com
	[209.85.218.226]) by cuda.sgi.com with ESMTP id
	E8KfZzsCyNtY67L3 for <xfs@oss.sgi.com>;
	Fri, 15 May 2009 01:40:45 -0700 (PDT)
Received: by bwz26 with SMTP id 26so1757627bwz.20
	for <xfs@oss.sgi.com>; Fri, 15 May 2009 01:35:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6efe08af0905140150g623d5564i5f5a06b5bf8543a5@mail.gmail.com>
References: <6efe08af0905130010g5e21f4d1w9efb4ed200b5b152@mail.gmail.com>
	<4A0B0A71.5010609@sandeen.net>
	<6efe08af0905140150g623d5564i5f5a06b5bf8543a5@mail.gmail.com>
Date: Fri, 15 May 2009 08:35:54 +0000
Message-ID: <6efe08af0905150135q317d3b7dy37907332c02510c2@mail.gmail.com>
Subject: Re: xfs_repair after reboot refuse repair my filesystem
From: "Vitaly V. Ch" <vitaly.v.ch@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

HI,

on my PC:

Fri 15 May 00:02:37|root@cvv:xfs# xfs_repair -V
xfs_repair version 3.0.1
Fri 15 May 00:03:26|root@cvv:xfs# xfs_mdrestore xfs.dump xfs.metaimg
Fri 15 May 00:03:37|root@cvv:xfs# xfs_repair -v xfs.metaimg
Phase 1 - find and verify superblock...
        - block cache size set to 133976 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 2 tail block 2
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
entry "" in shortform directory 128 references invalid inode 0
zero length entry in shortform dir 128, junking 3 entries
corrected entry count in directory 128, was 3, now 0
corrected directory 128 size, was 69, now 6
bogus .. inode number (0) in directory inode 128, clearing inode number
xfs_repair: dir2.c:2115: process_dir2: Assertion `(ino !=
mp->m_sb.sb_rootino && ino != *parent) || (ino == mp->m_sb.sb_rootino
&& (ino == *p
arent || need_root_dotdot == 1))' failed.
Aborted
Fri 15 May 00:04:30|root@cvv:xfs#

\\wbr Vitaly

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
