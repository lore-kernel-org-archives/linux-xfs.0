Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p786jtpN019872 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 01:45:55 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E49716906CE
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2011 23:47:09 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	1hemMlZCf3AiXalL for <xfs@oss.sgi.com>;
	Sun, 07 Aug 2011 23:47:09 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] splice: i_mutex vs splice write deadlock V2
Date: Mon,  8 Aug 2011 16:45:25 +1000
Message-Id: <1312785927-10662-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org

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

Version 2:
- add a new function to take an actor to do the work of splicing the
  data to the file. Convert generic_file_splice_write to use this,
  and make XFS call it with a different actor fuction that avoids
  the i_mutex.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
