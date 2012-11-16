Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG1DVf7044235 for <xfs@oss.sgi.com>; Thu, 15 Nov 2012 19:13:31 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	0qKA8lFF98ukPetr for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 17:15:35 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TZAW8-0006x3-O5
	for xfs@oss.sgi.com; Fri, 16 Nov 2012 12:14:48 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TZAW8-0006Mg-IT
	for xfs@oss.sgi.com; Fri, 16 Nov 2012 12:14:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs_quota: correctly initialise the default path
Date: Fri, 16 Nov 2012 12:14:48 +1100
Message-Id: <1353028488-24436-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When we initial xfs_quota, we place lots of information into the
fs_table. This includes all the devices/mount points the user has
specified as a global command line parameter to report on, as well
as all the paths under project quota control.

There is a "current path" pointer (fs_path) maintained by the code
that points somewhere into the fs_table. After the table is
initialised, fs_path always points to the last entry in the table,
and hence has to be re-initialised to point at the desired entry
before it can be used properly.

In the case of xfs_quota, if the command passed on the command line
is a non-global command, the command is called multiple times, each
time after the libxcmd args_command() callback is run. That starts
with an index of 0, and until the callback returns zero it will keep
passing whatever the last returned value was into the callback.

xfs_quota supplies such a callback, and it's purpose is to iterate
over the fs_table setting fs_path to the next mount point in the
table. IOWs, non-global quota functions get called once for each
mount point specified on the command line. However, it also means
that for global functions, the fs_path pointer is not
re-initialised and hence if there are project quotas configured the
fs_path pointer does not point to a mount point andhence commands
may malfunction..

The problem that demonstrated this is the report function. It does
it's own fs_table iteration if the command requires it, and so only
should be called once to avoid outputting the same information
multiple times.  That's what the previous patch fixed by making the
command global, but this now has the effect of making commands that
need to operate on the device specified on the global command rely
on the fs_path variable pointing at that device.

Further, commands executed by the interactive method are always
treated as global commands, so the report command never worked as a
global command in the presence of a configured project quota setup.

Fix the problem by initialising the fs_path pointer correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 quota/init.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/quota/init.c b/quota/init.c
index 3293b90..0b481f7 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -140,6 +140,15 @@ init(
 
 	init_commands();
 	add_args_command(init_args_command);
+
+	/*
+	 * Ensure that global commands don't end up with an invalid path pointer
+	 * by setting the default device at the first specified on the CLI
+	 */
+	if (argc != optind)
+		fs_path = fs_table_lookup(argv[optind], FS_MOUNT_POINT);
+	else
+		fs_path = &fs_table[0];
 }
 
 int
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
