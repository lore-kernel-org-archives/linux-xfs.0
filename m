Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 690AF7CA2
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:21:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5ABED304032
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:21:16 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	D3FHGklRBLqYr7lP for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 23:21:14 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVwPu-0004lr-Ls
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVwPu-00013l-Kl
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/15] xfsprogs: libxfs kernel sync to 4.6-for-next
Date: Wed, 17 Feb 2016 18:20:37 +1100
Message-Id: <1455693652-3899-1-git-send-email-david@fromorbit.com>
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

Hi folks,

This series brings the xfsprogs libxfs code in sync with what is
currently in the kernel for-next branch. This is aimed at the
xfsprogs for-next branch so that Darrick can use this as the base
for his rmap/reflink xfsprogs tree.

The only "interesting" thing in this series is the xfs_icdinode
modifications. I've made the structures similar to the kernel
so the same macros can be used, and jumped one step ahead of the
kernel by adding XFS_ISREG/XFS_ISDIR wrappers to keep the userspace
conversions simple.

Overall, it turned out ot be a lot simpler than I though it would
be, and points to the general direction that needs to be taken here:
use the xfs_dinode for anythign futzing directly with on disk
inodes, use the xfs_inode for everything else. I also noticed a
coupl eof good opportunites for factoring, such as the repeated
copy/paste of inode allocation and initialisation code.

Comments welcome!

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
