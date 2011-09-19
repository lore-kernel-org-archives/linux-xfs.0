Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8JCSQVa249396 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 07:28:26 -0500
Received: from seldrel01.sonyericsson.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 479DA16A9C74
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 05:33:37 -0700 (PDT)
Received: from seldrel01.sonyericsson.com (seldrel01.sonyericsson.com
	[212.209.106.2]) by cuda.sgi.com with ESMTP id i7yNHuVuyab5U6Wz
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 05:33:37 -0700 (PDT)
From: "Assarsson, Emil" <Emil.Assarsson@sonyericsson.com>
Date: Mon, 19 Sep 2011 14:28:23 +0200
Subject: silent corruption after kernel panic?
Message-ID: <2BF070A7A2375D46BA1B6087F8D5DCB68BEA722B40@seldmbx01.corpusers.net>
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

Hi,

We are running a 20TB XFS filesystem on top of LVM2 and SAN storage (HP
Open-V) with multipathd. Ubuntu Lucid. The disk write cache is enabled
and we use mount options rw.

This is a log of events taken from my memory and can have missed out
things :-P

The system panicked and automatically restarted after 30 seconds.

It seemed to be ok but after awhile we got cases where users got files
with zero length. We tried to run xfs_check on the filesystem but it
couldn't find any problems with it. After that we restarted the system
and the files (even the files that was zero length) seemed ok again. But
then we got messages (short version):
-----
Sep 16 06:40:34 seldlnx034 kernel: [54607.977261] XFS internal error
XFS_WANT_CORRUPTED_RETURN at line 381 of
file /build/buildd/linux-2.6.32/fs/xfs/xfs_alloc.c.  Caller
0xffffffffa01eed36
Sep 16 06:40:34 seldlnx034 kernel: [54607.996676]  [<ffffffffa0215383>]
xfs_error_report+0x43/0x50 [xfs]
Sep 16 06:40:34 seldlnx034 kernel: [54607.996689]
-----

... and files written during this period became corrupt (zero length).

We did a xfs_repair on the filesystem (short version):
-----
entry "fw-radmp_all.deb" at block 0 offset 944 in directory inode
157891962 references free inode 195983876
	clearing inode number in entry at offset 944...
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
bad hash table for directory inode 13786 (no data entry): rebuilding
rebuilding directory inode 13786
bad hash table for directory inode 2130829772 (no data entry):
rebuilding
rebuilding directory inode 2130829772
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
------

We have made a verification of the files now I we don't have any known
problems with the file system now but the files created when the file
system was broken needed to be recreated.



How can I avoid this in the future and how can I ensure that I get
informed about a problem? Do I do anything wrong with the setup that you
can see?

--
Emil Assarsson
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
