Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D3D007F61
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 08:08:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B41B28F8065
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 06:08:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Jz3gNSFL6RcNWR4E (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 25 Sep 2015 06:08:01 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 00EE4C0B91AE
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 13:08:00 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8PD7pac000474
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 09:08:00 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 3/3] xfs_io: implement inode '-n' and [num] argument
Date: Fri, 25 Sep 2015 15:07:47 +0200
Message-Id: <1443186467-20110-4-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1443186467-20110-1-git-send-email-cmaiolino@redhat.com>
References: <1443186467-20110-1-git-send-email-cmaiolino@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

"-n [num]" argument, will return to the user the next inode valid on the filesystem
after [num].

Using [num] exclusive, will test if the inode [num] is a valid inode in the
filesystem or not.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 io/open.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 74 insertions(+), 10 deletions(-)

diff --git a/io/open.c b/io/open.c
index 57ff0bf..9f68de0 100644
--- a/io/open.c
+++ b/io/open.c
@@ -762,6 +762,8 @@ inode_help(void)
 " -l	-- Returns the largest inode number in the filesystem\n"
 " -s	-- Returns the physical size (in bits) of the\n"
 "	   largest inode number in the filesystem\n"
+" -n	-- Return the next valid inode after [num]"
+"[num]	   Check if the inode [num] exists in the filesystem"
 "\n"));
 }
 
@@ -774,18 +776,19 @@ inode_f(
 	__s32			lastgrp = 0;
 	__u64			last = 0;
 	__u64			lastino = 0;
-	struct xfs_inogrp	igroup[1024];
-	struct xfs_fsop_bulkreq	bulkreq;
+	__u64			userino = 0;
+	char			*p;
 	int			c;
 	int			ret_lsize = 0;
 	int			ret_largest = 0;
+	int			ret_isvalid = 0;
+	int			ret_next = 0;
+	struct xfs_inogrp	igroup[1024];
+	struct xfs_fsop_bulkreq	bulkreq;
+	struct xfs_bstat	bstat;
 
-	bulkreq.lastip = &last;
-	bulkreq.icount = 1024; /* maybe an user-defined value!? */
-	bulkreq.ubuffer = &igroup;
-	bulkreq.ocount = &count;
 
-	while ((c = getopt(argc, argv, "sl")) != EOF) {
+	while ((c = getopt(argc, argv, "sln:")) != EOF) {
 		switch (c) {
 		case 's':
 			ret_lsize = 1;
@@ -793,12 +796,34 @@ inode_f(
 		case 'l':
 			ret_largest = 1;
 			break;
+		case 'n':
+			ret_next = 1;
+			userino = strtoull(optarg, &p, 10);
+			break;
 		default:
 			return command_usage(&inode_cmd);
 		}
 	}
 
+	if ((optind < argc) && !(ret_next || ret_lsize || ret_largest)) {
+		ret_isvalid = 1;
+		userino = strtoull(argv[optind], &p, 10);
+	}
+
+	if (userino)
+		if (*p != '\0') {
+			printf("[num] must be a valid number\n");
+			exitcode = 1;
+			return 0;
+		}
+
 	if (ret_lsize || ret_largest) {
+
+		bulkreq.lastip = &last;
+		bulkreq.icount = 1024; /* User-defined maybe!? */
+		bulkreq.ubuffer = &igroup;
+		bulkreq.ocount = &count;
+
 		for (;;) {
 			if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS,
 					&bulkreq)) {
@@ -806,7 +831,7 @@ inode_f(
 				exitcode = 1;
 				return 0;
 			}
-			if (count < XFS_INODES_PER_CHUNK && count > 0)
+			if (count < 1024 && count > 0)
 				lastgrp = count;
 			if (!count)
 				break;
@@ -822,8 +847,47 @@ inode_f(
 		else
 			printf(_("Largest inode: %llu\n"), lastino);
 
+		return 0;
+	}
+
+	/* Setup bulkreq for -n or [num] only */
+	last = userino;
+	bulkreq.lastip = &last;
+	bulkreq.icount = 1;
+	bulkreq.ubuffer = &bstat;
+	bulkreq.ocount = &count;
+
+	if (ret_next) {
+		if (xfsctl(file->name, file->fd, XFS_IOC_FSBULKSTAT, &bulkreq)) {
+			if (errno == EINVAL)
+				printf("Invalid or non-existent inode\n");
+			else
+				perror("XFS_IOC_FSBULKSTAT");
+			exitcode = 1;
+			return 0;
+		}
+
+		if (!bstat.bs_ino) {
+			printf("There are no further inodes in the filesystem\n");
+			return 0;
+		}
+
+		printf("Next inode: %llu\n", bstat.bs_ino);
+		return 0;
 	}
 
+	if (ret_isvalid) {
+		if (xfsctl(file->name, file->fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq)) {
+			if (errno == EINVAL) {
+				printf("Invalid or non-existent inode number\n");
+			} else
+				perror("XFS_IOC_FSBULKSTAT_SINGLE");
+			exitcode = 1;
+			return 0;
+		}
+		printf("Valid inode: %llu\n", bstat.bs_ino);
+		return 0;
+	}
 
 	return 0;
 }
@@ -895,9 +959,9 @@ open_init(void)
 
 	inode_cmd.name = "inode";
 	inode_cmd.cfunc = inode_f;
-	inode_cmd.args = _("[-s | -l]");
+	inode_cmd.args = _("[-s | -l | -n] [num]");
 	inode_cmd.argmin = 1;
-	inode_cmd.argmax = 1;
+	inode_cmd.argmax = 2;
 	inode_cmd.flags = CMD_NOMAP_OK;
 	inode_cmd.oneline =
 		_("Query inode number usage in the filesystem");
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
