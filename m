Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C435E7F51
	for <linux-xfs@oss.sgi.com>; Mon, 15 Apr 2013 18:49:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 92D188F8073
	for <linux-xfs@oss.sgi.com>; Mon, 15 Apr 2013 16:49:34 -0700 (PDT)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id SDlWhu1HDnec9QGQ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Mon, 15 Apr 2013 16:49:33 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1URt9O-00047w-Q8
	for linux-xfs@oss.sgi.com; Tue, 16 Apr 2013 01:49:30 +0200
Received: from wombat.san-francisco.ca.us ([75.101.60.140])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 16 Apr 2013 01:49:30 +0200
Received: from kkeller by wombat.san-francisco.ca.us with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 16 Apr 2013 01:49:30 +0200
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: xfs_repair misses an fs error?
Date: Mon, 15 Apr 2013 16:47:32 -0700
Message-ID: <k5gu3axace.ln2@goaway.wombat.san-francisco.ca.us>
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
To: linux-xfs@oss.sgi.com

Hi all,

I recently had a filesystem stop, and went through the usual umount,
mount, umount, xfs_repair path.  xfs_repair didn't find any errors, but
I noticed that I was still getting some strange issues where a file in a
directory didn't have an inode and was resulting in IO errors.  Thinking
to address the problem later, I moved the directory to a different
location on the filesystem so that future backups could proceed
normally.

Later, in an attempt to collect log errors, I re-ran xfs_repair on the
filesystem.  It then found errors and corrected them, and on remount, I
found that the directory in question was repaired and no longer had a
file entry with no inode.  (So I can't reproduce that output; I didn't
save it, thinking that the second xfs_repair wouldn't fix the issue, and
I'd generate it again before posting.)

Has anyone else seen a situation where xfs_repair misses a filesystem
problem, but then finds it if a file or directory is moved?  And more
generally, is there a way to use xfs_db or similar to try to find other
inodes that might be causing similar problems?

In case it's helpful, the last xfs_repair stderr is below.
Unfortunately I didn't save the initial xfs_repair logs, but from what I
remember (which could be inaccurate, I admit) I did not see any errors.
FWIW, 8495309 was the inode of the directory that was reporting the file
with no inode before the successful xfs_repair.

--keith

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
correcting nblocks for inode 14653773, was 18446744073709486338 -
counted 1
data fork in ino 14653803 claims free block 1654114652
data fork in ino 14653833 claims free block 1654114653
        - agno = 1
correcting nblocks for inode 2161878797, was 72057594037927936 - counted
0
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
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
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
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
bad hash table for directory inode 8495309 (hash value mismatch):
rebuilding
rebuilding directory inode 8495309
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
resetting inode 9161151 nlinks from 10 to 9
resetting inode 9161407 nlinks from 8 to 9
Note - quota info will be regenerated on next quota mount.
done





-- 
kkeller@wombat.san-francisco.ca.us


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
