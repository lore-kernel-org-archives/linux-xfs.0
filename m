Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n110DZdQ138277 for <xfs@oss.sgi.com>; Sat, 31 Jan 2009 18:13:35 -0600
Received: from idcmail-mo1so.shaw.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6B30D455C
	for <xfs@oss.sgi.com>; Sat, 31 Jan 2009 16:12:53 -0800 (PST)
Received: from idcmail-mo1so.shaw.ca (idcmail-mo1so.shaw.ca [24.71.223.10]) by
	cuda.sgi.com with ESMTP id rkWLmYv51cwlyDzF for
	<xfs@oss.sgi.com>; Sat, 31 Jan 2009 16:12:53 -0800 (PST)
Received: from bender.lan.kevinjamieson.com (bender.lan.kevinjamieson.com
	[192.168.1.110])
	by mail.kevinjamieson.com (Postfix) with ESMTP id 66AA12009C
	for <xfs@oss.sgi.com>; Sat, 31 Jan 2009 16:12:52 -0800 (PST)
Message-ID: <4984E904.3020509@kevinjamieson.com>
Date: Sat, 31 Jan 2009 16:12:52 -0800
From: Kevin Jamieson <kevin@kevinjamieson.com>
MIME-Version: 1.0
Subject: dm_get_dirattrs can write past end of user buffer
Reply-To: kevin@kevinjamieson.com
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
To: xfs@oss.sgi.com

I have observed segfaults with an application that calls dm_get_dirattrs
with the latest DMAPI kernel built from SGI CVS.

The problem appears to be in dm_filldir:

	needed = dm_stat_size(namelen + 1);
	...
	error = -xfs_dm_bulkattr_iget_one(cb->mp, ino, 0,
		statp, needed);
	...
	/*
	 * On return from bulkstat_one(), stap->_link points
	 * at the end of the handle in the stat structure.
	 */
	statp->dt_compname.vd_offset = statp->_link;
	statp->dt_compname.vd_length = namelen + 1;

xfs_dm_bulkattr_iget_one() sets statp->_link to needed, so the name ends
up getting written past the space reserved for the name, which can
exceed cb->spaceleft.

The below patch appears to fix the problem.


Index: fs/xfs/dmapi/xfs_dm.c
===================================================================
RCS file: /cvs/linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c,v
retrieving revision 1.81
diff -u -r1.81 xfs_dm.c
--- fs/xfs/dmapi/xfs_dm.c	28 Oct 2008 05:39:09 -0000	1.81
+++ fs/xfs/dmapi/xfs_dm.c	31 Jan 2009 23:08:07 -0000
@@ -1793,7 +1793,7 @@
 
 	memset(statp, 0, dm_stat_size(MAXNAMLEN));
 	error = -xfs_dm_bulkattr_iget_one(cb->mp, ino, 0,
-			statp, needed);
+			statp, DM_STAT_SIZE(*statp, 0));
 	if (error)
 		goto out_err;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
