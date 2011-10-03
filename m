Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p93CnPXU241640 for <xfs@oss.sgi.com>; Mon, 3 Oct 2011 07:49:25 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 0/6] xfsprogs: tolerate mount or project errors
Date: Mon,  3 Oct 2011 07:49:14 -0500
Message-Id: <1317646160-5437-1-git-send-email-aelder@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This series adds a few more cleanups to libxcmd, but they (and the
ones recently) were really just ground work leading up to addressing
a specific underlying problem, which is done in the last patch (or
maybe the last two).

libxcmd includes code to initialize a table with entries that
represent mount points and project directories that may be subject
to quota enforcement.  These are then available as targets of
various operations.

When adding an entry to the table, various things can go wrong.
For example, a path defined in the projects file might not exist,
a mount point specified might not be accessible to the user, or
a memory allocation could fail.

Currently, if any error occurs when inserting an entry into this
"fs_table", exit() is called so the executing program just quits.

Since this table is simply used to define the available targets
of operations, there is no real need to exit when an error occurs
setting up just one of its entries.  In some cases everything else
might be just fine, and normally the entry that causes an error is
not even something the user cares to operate on anyway.

The trouble report that led to fixing this had to do with a
situation in which automount left some sort of artifact in the list
of mounted filesystems, and any attempt to run xfs_growfs was met
with an error that prevented it from being run.  The errant entry in
/proc/self/mounts contained something like this in the mnt_fsname
field returned by getmntent(): "/tmp/auto7fGuI5 (deleted)"

This series addresses this by both ignoring errors while
initializing fs_table, and by not exiting when an error occurs.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
