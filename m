Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6I44qQL079181 for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 23:04:52 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F9021D8822D
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 21:04:50 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	nmvi8vNir3JtjeeT for <xfs@oss.sgi.com>;
	Sun, 17 Jul 2011 21:04:50 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] splice: i_mutex vs splice write deadlock
Date: Mon, 18 Jul 2011 14:04:42 +1000
Message-Id: <1310961884-11634-1-git-send-email-david@fromorbit.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

generic_file_splice_write() takes the inode->i_mutex after the
filesystem has taken whatever locks it needs to ensure sanity.
however, this typically violates the locking order of filesystems
with their own locks in that the order is usually i_mutex ->
filesystem lock.

XFS is such a case, and generic_file_splice_write() is generating
lockdep warnings because of lock inversions between the
inode->i_mutex and the XFS_I(inode)->i_iolock. There is also a
reported case of fio causing a deadlock when it mixes IO types
(e.g. splice vs direct IO).

This patch set introduces generic_file_splice_write_unlocked() and
factors the code such that __generic_file_splice_write() will only
lock the i_mutex if called from the locked variant. The second patch
modifies XFS to use the new function.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
