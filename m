Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0C6667F86
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 08:20:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7EEA4AC006
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 06:20:50 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	lBlhc6kq7wxEUXCa for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 06:20:49 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8s2g-0004xv-Uy
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8s2g-0007MY-Tv
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [RFD 13/17] xfs: allow linkat() on
	O_TMPFILE files
Date: Mon, 12 Aug 2013 23:20:03 +1000
Message-Id: <1376313607-28133-14-git-send-email-david@fromorbit.com>
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

The VFS allows an anonymous temporary file to be named at a later
time via a linkat() syscall. Inodes that are created as O_TMPFILE
are marked with a special flag I_LINKABLE that tells the VFS that it
is OK to add a link to the inode even though it currently has a zero
link count.

To support this in XFS, we need to have xfs_link() detect this flag
is set and behave appropriately when detected. When this situation
is detected, we have ot ensure that the transaciton reservation
takes into account the additional overhead of removing the inode
from the unlinked list.

Once we have determined that we can add the directory entry for the
new link, we can remove the inode from the unlinked list and then
add the directory entry. We do the operation in this order so that
the AGI locking versus directory block allocation (and hence AGF
locking) is the same as xfs_create() does.

Finally, when we bump the link count, we need to ensure we don't
assert fail on the zero link count that the O_TMPFILE inode has.
This is the only case where incremeting the link count when it is
zero is now valid, so we need to make sure that xfs_bumplink()
checks this precisely. The VFS should ensure that I_LINKABLE is
removed on the first link of an anonymous file so care is needed to
ensure that the checks capture this behaviour, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_utils.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_utils.c b/fs/xfs/xfs_utils.c
index 0025c78..fb2fa6c 100644
--- a/fs/xfs/xfs_utils.c
+++ b/fs/xfs/xfs_utils.c
@@ -293,6 +293,7 @@ xfs_bumplink(
 {
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
+	/* tmpfiles won't like this */
 	ASSERT(ip->i_d.di_nlink > 0);
 	ip->i_d.di_nlink++;
 	inc_nlink(VFS_I(ip));
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
