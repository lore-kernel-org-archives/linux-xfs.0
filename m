Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4DHxBRU162623 for <xfs@oss.sgi.com>; Wed, 13 May 2009 12:59:12 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A43D1FA76D5
	for <xfs@oss.sgi.com>; Wed, 13 May 2009 11:03:58 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 7dkfgm78BRBwaJ5a for <xfs@oss.sgi.com>;
	Wed, 13 May 2009 11:03:58 -0700 (PDT)
Message-ID: <4A0B0A71.5010609@sandeen.net>
Date: Wed, 13 May 2009 12:59:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair after reboot refuse repair my filesystem
References: <6efe08af0905130010g5e21f4d1w9efb4ed200b5b152@mail.gmail.com>
In-Reply-To: <6efe08af0905130010g5e21f4d1w9efb4ed200b5b152@mail.gmail.com>
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
To: "Vitaly V. Ch" <vitaly.v.ch@gmail.com>
Cc: xfs@oss.sgi.com

Vitaly V. Ch wrote:
> I try few version of xfs_repair, including 3.0.1 and 2.10.2, but
> always receive something like:
> 
> xfs_repair: dir2.c:2133: process_dir2: Assertion `(ino
> !=mp->m_sb.sb_rootino && ino != *parent) || (ino ==
> mp->m_sb.sb_rootino && (ino == *parent || need_root_dotdot == 1))'
> failed.
> 
> How I can repair my data?
> 
> compressed metadump attached.
> 
> there was no hardware failure.

Hm, which OS/arch?  works ok for me on a loopback file, although
subsequent repairs do still give me:

bogus .. inode number (0) in directory inode 128, clearing inode number

[root@inode test]# rpm -qf `which xfs_repair`
xfsprogs-3.0.0-2.fc11.x86_64
[root@inode test]# xfs_mdrestore /root/xfs.dump testfile
[root@inode test]# xfs_repair testfile
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
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
zero length entry in shortform dir 132, junking 2 entries
corrected entry count in directory 132, was 2, now 0
corrected directory 132 size, was 59, now 6
bogus .. inode number (0) in directory inode 132, clearing inode number
entry "" in shortform directory 133 references invalid inode 0
zero length entry in shortform dir 133, junking 255 entries
corrected directory 133 size, was 8, now 6
entry "" in shortform directory 156 references invalid inode 0
zero length entry in shortform dir 156, junking 255 entries
corrected directory 156 size, was 8, now 6
bogus .. inode number (0) in directory inode 156, clearing inode number
        - agno = 1
zero length entry in shortform dir 268435584, resetting to 22
corrected directory 268435584 size, was 31, now 35
directory 268435584 offsets too high
corrected entry offsets in directory 268435584
bogus .. inode number (0) in directory inode 268435584, clearing inode
number
        - agno = 2
entry "" in shortform directory 536871040 references invalid inode 0
zero length entry in shortform dir 536871040, junking 2 entries
corrected entry count in directory 536871040, was 2, now 0
corrected directory 536871040 size, was 46, now 6
bogus .. inode number (0) in directory inode 536871040, clearing inode
number
        - agno = 3
zero length entry in shortform dir 805306496, junking 255 entries
corrected directory 805306496 size, was 8, now 6
        - agno = 4
entry "" in shortform directory 1073741952 references invalid inode 0
zero length entry in shortform dir 1073741952, junking 4 entries
corrected entry count in directory 1073741952, was 4, now 0
corrected directory 1073741952 size, was 101, now 6
        - agno = 5
entry "" in shortform directory 1342177408 references invalid inode 0
zero length entry in shortform dir 1342177408, junking 255 entries
corrected directory 1342177408 size, was 8, now 6
        - agno = 6
zero length entry in shortform dir 1610612864, junking 255 entries
corrected directory 1610612864 size, was 8, now 6
        - agno = 7
entry "" in shortform directory 1879048320 references invalid inode 0
zero length entry in shortform dir 1879048320, junking 255 entries
corrected directory 1879048320 size, was 8, now 6
        - agno = 8
zero length entry in shortform dir 2147483776, junking 255 entries
corrected directory 2147483776 size, was 8, now 6
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
bogus .. inode number (0) in directory inode 128, clearing inode number
bogus .. inode number (0) in directory inode 132, clearing inode number
        - agno = 1
entry "=(XC
j]e
      P"^)58|x" in shortform directory 268435584 references invalid inode 0
junking entry "=(XC
j]e
      P"^)58|x" in directory inode 268435584
bogus .. inode number (0) in directory inode 268435584, clearing inode
number
bogus .. inode number (0) in directory inode 156, clearing inode number
        - agno = 2
bogus .. inode number (0) in directory inode 536871040, clearing inode
number
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
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected dir inode 132, moving to lost+found
disconnected dir inode 133, moving to lost+found
disconnected dir inode 156, moving to lost+found
disconnected dir inode 268435584, moving to lost+found
disconnected dir inode 268435585, moving to lost+found
disconnected dir inode 536871040, moving to lost+found
disconnected dir inode 805306496, moving to lost+found
disconnected dir inode 1073741952, moving to lost+found
disconnected dir inode 1342177408, moving to lost+found
disconnected dir inode 1610612864, moving to lost+found
disconnected dir inode 1879048320, moving to lost+found
disconnected dir inode 2147483776, moving to lost+found
Phase 7 - verify and correct link counts...
resetting inode 128 nlinks from 6 to 3
resetting inode 132 nlinks from 4 to 2
resetting inode 268435584 nlinks from 3 to 2
resetting inode 536871040 nlinks from 4 to 2
resetting inode 1073741952 nlinks from 6 to 2
Note - quota info will be regenerated on next quota mount.
done

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
