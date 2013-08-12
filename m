Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8C0747F72
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 08:20:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4E3598F8059
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 06:20:49 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	hxKOfpHWJ7EnEK06 for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 06:20:47 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8s2g-0004xu-UO
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8s2g-0007MT-TL
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM *****  [RFD 12/17] xfs: add tmpfile methods
Date: Mon, 12 Aug 2013 23:20:02 +1000
Message-Id: <1376313607-28133-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1376313607-28133-1-git-send-email-david@fromorbit.com>
References: <1376313607-28133-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

To add O_TMPFILE support, we need to add a new method to the VFS
interface.  This method does the dentry manipulation and drives the
transactional inode allocation and links it to the unlinked inode
list.

The inode allocation needs new transaction reservations that cover
onyl the free inode allocation modifications - it does not need the
reservations that cover directory entry additions. With these
reservations, we can call the newly factored inode allocation
function to get an allocated inode.

The final step is to link the inode into the unlinked list on the
AGI so that the inode will be freed and reclaimed when it is no
longer referenced - that will remove it form the unlinked list at
that time. If we crash with the O_TMPFILE still open, log recovery
will process the unlinked lists and free it at that point in time.

Once the inode is added to the unlinked list, we can commit the
transaction and link the inode to the provided dentry and finish
initialising the VFS part of the dentry.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 9c20a2c..82ea957 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1082,6 +1082,7 @@ static const struct inode_operations xfs_dir_inode_operations = {
 	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
+	//.tmpfile		= xfs_vn_tmpfile,
 };
 
 static const struct inode_operations xfs_dir_ci_inode_operations = {
@@ -1108,6 +1109,7 @@ static const struct inode_operations xfs_dir_ci_inode_operations = {
 	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
+	//.tmpfile		= xfs_vn_tmpfile,
 };
 
 static const struct inode_operations xfs_symlink_inode_operations = {
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
