Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7buNp204203 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:37:56 -0600
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74D87B7610
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:37:12 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.152])
	by cuda.sgi.com with ESMTP id kfv8uNKX9OgWWmF2 for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:37:12 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id 19so3558293fgg.8
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:37:12 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 26 Jan 2009 09:37:11 +0200
Message-ID: <6efe08af0901252337m22844fc2yee3cef2a8ed8ac6@mail.gmail.com>
Subject: xfs_repair refuse to repair my corrupted xfs partition
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
To: xfs@oss.sgi.com

Hi All!

After reboot I found out on my XFS partition only one non-enterable
folder /public.

#xfs_check -s /dev/loop0
#xfs_check /dev/loop0
dir 128 entry                                           public bad offset 0
dir 128 bad size in entry at 68
root directory 128 has .. 0
dir 132 bad size in entry at 13
dir 132 offsets too high
dir 133 size is 8, should be 6
dir 156 size is 8, should be 6
dir 268435584 size is 31, should be 13
dir 268435584 offsets too high
dir 536871040 bad size in entry at 13
dir 536871040 offsets too high
dir 805306496 size is 8, should be 6
dir 1073741952 entry                                         printerP
bad offset 0
dir 1073741952 bad size in entry at 68
dir 1342177408 size is 8, should be 6
dir 1610612864 size is 8, should be 6
dir 1879048320 size is 8, should be 6
dir 2147483776 size is 8, should be 6
link count mismatch for inode 16384 (name ?), nlink 0, counted 4
link count mismatch for inode 8192 (name ?), nlink 0, counted 2
link count mismatch for inode 4096 (name ?), nlink 0, counted 1
link count mismatch for inode 96419840 (name ?), nlink 0, counted 1
link count mismatch for inode 8388608 (name ?), nlink 0, counted 1
link count mismatch for inode 0 (name ?), nlink 0, counted 9
link count mismatch for inode 128 (name ?), nlink 5, counted 1
link count mismatch for inode 132 (name ?), nlink 4, counted 2
link count mismatch for inode 133 (name ?), nlink 2, counted 1
link count mismatch for inode 156 (name ?), nlink 2, counted 1
link count mismatch for inode 268435584 (name ?), nlink 3, counted 1
link count mismatch for inode 268435585 (name ?), nlink 3, counted 2
link count mismatch for inode 536871040 (name ?), nlink 4, counted 1
link count mismatch for inode 805306496 (name ?), nlink 2, counted 1
link count mismatch for inode 1073741952 (name ?), nlink 6, counted 1
link count mismatch for inode 1342177408 (name ?), nlink 2, counted 1
link count mismatch for inode 1610612864 (name ?), nlink 2, counted 1
link count mismatch for inode 1886546286 (name ?), nlink 0, counted 1
link count mismatch for inode 1879048320 (name ?), nlink 2, counted 1
link count mismatch for inode 2147483776 (name ?), nlink 2, counted 1
#xfs_repai /dev/loop0
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
xfs_repair: dir2.c:2133: process_dir2: Assertion `(ino !=
mp->m_sb.sb_rootino && ino != *parent) || (ino == mp->m_sb.sb_rootino
&& (ino == *parent || need_root_dotdot == 1))' failed.


What I can do for repair my data? There was no hardware failure

\\wbr Vitaly Chernookiy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
