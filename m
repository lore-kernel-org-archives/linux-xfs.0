Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9TArSQu156239 for <xfs@oss.sgi.com>; Mon, 29 Oct 2012 05:53:28 -0500
Received: from mail-pa0-f53.google.com (mail-pa0-f53.google.com
	[209.85.220.53]) by cuda.sgi.com with ESMTP id fanRYyxaWHkkI2mC
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Oct 2012 03:55:16 -0700 (PDT)
Received: by mail-pa0-f53.google.com with SMTP id bj3so3586914pad.26
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2012 03:55:15 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 29 Oct 2012 11:55:15 +0100
Message-ID: <CADLDEKtkwaitKCsU21JnsesM70H5AwkEFQFcdmOHE0JU9Oa8nw@mail.gmail.com>
Subject: Daily crash in xfs_cmn_err
From: Juerg Haefliger <juergh@gmail.com>
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

Hi,

I have a node that used to crash every day at 6:25am in xfs_cmn_err
(Null pointer dereference). I'm running 2.6.38 (yes I know it's old)
and I'm not reporting a bug as I'm sure the problem has been fixed in
newer kernels :-) The crashes occurred daily when logrotate ran,
/var/log is a separate 100GB XFS volume. I finally took the node down
and ran xfs_check on the the /var/log volume and it did indeed report
some errors/warnings (see end of email). I then ran xfs_repair (see
end of email for output) and the node is stable ever since.

So my questions are:

1) I was under the impression that during the mounting of an XFS
volume some sort of check/repair is performed. How does that differ
from running xfs_check and/or xfs_repair?

2) Any ideas how the filesystem might have gotten into this state? I
don't have the history of that node but it's possible that it crashed
previously due to an unrelated problem. Could this have left the
filesystem is this state?

3) What exactly does the ouput of the xfs_check mean? How serious is
it? Are those warning or errors? Will some of them get cleanup up
during the mounting of the filesystem?

4) We have a whole bunch of production nodes running the same kernel.
I'm more than a little concerned that we might have a ticking timebomb
with some filesystems being in a state that might trigger a crash
eventually. Is there any way to perform a live check on a mounted
filesystem so that I can get an idea of how big of a problem we have
(if any)? i don't claim to know exactly what I'm doing but I picked a
node, froze the filesystem and then ran a modified xfs_check (which
bypasses the is_mounted check and ignores non-committed metadata) and
it did report some issues. At this point I believe those are false
positive. Do you have any suggestions short of rebooting the nodes and
running xfs_check on the unmounted filesystem?

Thanks
....Juerg


(initramfs) xfs_check  /dev/mapper/vg0-varlog
block 0/3538 expected type unknown got free2
block 0/13862 expected type unknown got free2
block 0/13863 expected type unknown got free2

<SNIP>

block 0/16983 expected type unknown got free2
block 0/16984 expected type unknown got free2
block 0/21700 expected type unknown got data
block 0/21701 expected type unknown got data

<SNIP>

block 0/21826 expected type unknown got data
block 0/21827 expected type unknown got data
block 0/21700 claimed by inode 178, previous inum 148
block 0/21701 claimed by inode 178, previous inum 148

<SNIP>

block 0/21826 claimed by inode 178, previous inum 148
block 0/21827 claimed by inode 178, previous inum 148
block 0/1250 expected type unknown got data
block 0/1251 expected type unknown got data

<SNIP>

block 0/1264 expected type unknown got data
block 0/1265 expected type unknown got data
block 0/1250 claimed by inode 1706, previous inum 148
block 0/1251 claimed by inode 1706, previous inum 148

<SNIP>

block 0/1264 claimed by inode 1706, previous inum 148
block 0/1265 claimed by inode 1706, previous inum 148
block 0/16729 expected type unknown got data
block 0/16730 expected type unknown got data

<SNIP>

block 0/16889 expected type unknown got data
block 0/16890 expected type unknown got data
block 0/16729 claimed by inode 1710, previous inum 148
block 0/16730 claimed by inode 1710, previous inum 148

<SNIP>

block 0/16889 claimed by inode 1710, previous inum 148
block 0/16890 claimed by inode 1710, previous inum 148
block 0/3523 expected type unknown got data
block 0/3524 expected type unknown got data

<SNIP>

block 0/3536 expected type unknown got data
block 0/3537 expected type unknown got data
block 0/3523 claimed by inode 1994, previous inum 148
block 0/3524 claimed by inode 1994, previous inum 148

<SNIP>

block 0/3536 claimed by inode 1994, previous inum 148
block 0/3537 claimed by inode 1994, previous inum 148
block 0/510 type unknown not expected
block 0/511 type unknown not expected
block 0/512 type unknown not expected

<SNIP>

block 0/2341 type unknown not expected
block 0/2342 type unknown not expected



(initramfs) xfs_repair /dev/mapper/vg0-varlog
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
data fork in ino 148 claims free block 3538
data fork in ino 148 claims free block 13862
data fork in ino 148 claims free block 13863
data fork in ino 148 claims free block 16891
data fork in ino 148 claims free block 16892
data fork in regular inode 178 claims used block 21700
bad data fork in inode 178
cleared inode 178
data fork in regular inode 1706 claims used block 1250
bad data fork in inode 1706
cleared inode 1706
data fork in regular inode 1710 claims used block 16729
bad data fork in inode 1710
cleared inode 1710
data fork in regular inode 1994 claims used block 3523
bad data fork in inode 1994
cleared inode 1994
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
entry "syslog" at block 0 offset 2384 in directory inode 128
references free inode 178
        - agno = 3
	clearing inode number in entry at offset 2384...
        - agno = 2
data fork in ino 148 claims dup extent, off - 0, start - 1250, cnt 16
bad data fork in inode 148
cleared inode 148
entry "nova-api.log" at block 0 offset 552 in directory inode 165
references free inode 1994
	clearing inode number in entry at offset 552...
entry "nova-network.log.6" at block 0 offset 2608 in directory inode
165 references free inode 1706
	clearing inode number in entry at offset 2608...
entry "nova-api.log.6" at block 0 offset 4032 in directory inode 165
references free inode 1710
	clearing inode number in entry at offset 4032...
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
entry "syslog.1" in directory inode 128 points to free inode 148
bad hash table for directory inode 128 (no data entry): rebuilding
rebuilding directory inode 128
bad hash table for directory inode 165 (no data entry): rebuilding
rebuilding directory inode 165
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
