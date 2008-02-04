Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Feb 2008 20:31:06 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m144UtRR022140
	for <xfs@oss.sgi.com>; Sun, 3 Feb 2008 20:30:58 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E19059798C
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2008 20:31:17 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id ECr9N5X038xk7C1Y for <xfs@oss.sgi.com>; Sun, 03 Feb 2008 20:31:17 -0800 (PST)
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 3FB8418DAFEF1
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2008 22:30:45 -0600 (CST)
Message-ID: <47A694F3.9010307@sandeen.net>
Date: Sun, 03 Feb 2008 22:30:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: unpushed 4-month-old mods?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

At least these three mods which I did back in September to get Fedora 8
/ 2.6.23 into shape on 4k stacks, and a bugfix, are still not pushed to
kernel.org, and are missing in 2.6.24...

Is there any reason for the holdup?  Makes me wonder what else isn't
pushed...

-------------

Refactor xfs_mountfs

Refactoring xfs_mountfs() to call sub-functions for logical
chunks can help save a bit of stack, and can make it easier to
read this long function.

The mount path is one of the longest common callchains, easily
getting to within a few bytes of the end of a 4k stack when
over lvm, quotas are enabled, and quotacheck must be done.

With this change on top of the other stack-related changes
I've sent, I can get xfs to survive a normal xfsqa run on
4k stacks over lvm.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Merge of xfs-linux-melb:xfs-kern:29834a by kenmcd.

  Refactor xfs_mountfs

and:

optimize XFS_IS_REALTIME_INODE w/o realtime config

Use XFS_IS_REALTIME_INODE in more places, and #define it to
0 if CONFIG_XFS_RT is off.  This should be safe because mount
checks in xfs_rtmount_init:

# define xfs_rtmount_init(m)    (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))

so if we get mounted w/o CONFIG_XFS_RT, no realtime inodes should
be encountered after that.

Defining XFS_IS_REALTIME_INODE to 0 saves a bit of stack space,
presumeably gcc can optimize around the various "if (0)" type
checks:

xfs_alloc_file_space    -8
xfs_bmap_adjacent       -16
xfs_bmapi               -8
xfs_bmap_rtalloc        -16
xfs_bunmapi             -28
xfs_free_file_space     -64
xfs_imap                +8  <-- ?  hmm.
xfs_iomap_write_direct  -12
xfs_qm_dqusage_adjust   -4
xfs_qm_vop_chown_reserve -4

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Merge of xfs-linux-melb:xfs-kern:30014a by kenmcd.

  Use XFS_IS_REALTIME_INODE() rather than open coding the check.

fix 32-bit compat ioctls for GETXFLAGS, SETXFLAGS, GETVERSION

XFS_IOC_GETVERSION, XFS_IOC_GETXFLAGS and XFS_IOC_SETXFLAGS all
take a "long" which changes size between 32 and 64 bit platforms.

So, the ioctl cmds that come in from a 32-bit app aren't as expected,
for example on GETXFLAGS,

        unknown cmd fd(3) cmd(80046601){t:'f';sz:4}

due to the size mismatch.

So, use instead the 32-bit version of the commands for compat ioctls,
and other than that it doesn't take any more manipulation.

Also, for both native and compat versions, just define them to
the values as defined in fs.h

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Merge of xfs-linux-melb:xfs-kern:29849a by kenmcd.

  fix 32-bit compat ioctls for GETXFLAGS, SETXFLAGS, GETVERSION
