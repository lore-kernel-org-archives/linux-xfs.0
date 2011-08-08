Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p78NIkEw060933 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 18:18:46 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F05841891EFB
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2011 16:18:44 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id CYYyZRyNqMOOHjsZ for
	<xfs@oss.sgi.com>; Mon, 08 Aug 2011 16:18:44 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.sc.tlinx.org (8.14.4/8.14.4/SuSE Linux 0.8) with ESMTP id
	p78NIbvc002523 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 16:18:39 -0700
Message-ID: <4E406ECD.2020708@tlinx.org>
Date: Mon, 08 Aug 2011 16:18:37 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: re: xfs: xfs_swap_extents needs to handle dynamic fork offsets
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Saw this description from a patch set to lkml:
( http://lkml.indiana.edu/hypermail/linux/kernel/1004.2/02461.html )
========================================================
From: Greg KH
Date: Thu Apr 22 2010 - 16:43:40 EST
Subj: [022/197] xfs: xfs_swap_extents needs to handle dynamic fork offsets

2.6.32-stable review patch. If anyone has any objections, please let us 
know.
------------------
From: Dave Chinner <david@xxxxxxxxxxxxx>
commit e09f98606dcc156de1146c209d45a0d6d5f51c3f upstream
=========================================================
Description says...(brackets, [], added to highlight/break apart
some sections):

...
Changing the way xfs_fsr sets up the attribute fork will prevent
this situation from ever occurring, so in the kernel code we can get
by with a preventative fix - check that the data fork in the
defragmented inode is in a format valid for the inode it is being
swapped into.  [
]
This will lead to files that will silently and
potentially repeatedly fail defragmentation, [
***] so _issue_ _a_ _warning_ to the log when this particular
failure occurs to let us know that [
***]_xfs_fsr_ _needs_ _updating/fixing_.[***]


"To help identify how to improve xfs_fsr to avoid this issue, add
trace points for the inodes being swapped so that we can determine
why the swap was rejected and to confirm that the code is making the
right decisions and modifications when swapping forks. "
....
=========================================================
lower in the code you added the message:
=========================================================
+ /* check inode formats now that data is flushed */
+ error = xfs_swap_extents_check_format(ip, tip);
+ if (error) {
+ xfs_fs_cmn_err(CE_NOTE, mp,
+ "%s: inode 0x%llx format is incompatible for exchanging.",
+ __FILE__, ip->i_ino);
goto out_unlock;
}
=========================================================

I'm seeing several of these in 'dmesg':

[873569.328221] Filesystem dm-6: fs/xfs/xfs_dfrag.c: inode 0x8227a310 
format is incompatible for exchanging.
[873623.752724] Filesystem dm-6: fs/xfs/xfs_dfrag.c: inode 0x8227a310 
format is incompatible for exchanging.
[873669.721127] Filesystem dm-6: fs/xfs/xfs_dfrag.c: inode 0x8227a310 
format is incompatible for exchanging.
...

----
am running 2.6.38.3,

& version 3.1.4-2.1 of 'xfsprogs'....

Is there a version of xfs_fsr that fixes these problems, or is this
this still something on the 'todo list' (I don't notice any other 
aberrant behaviors
that might have anything to do with this)...Just thought I'd ask about
the weird messages...

Thanks,
Linda



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
