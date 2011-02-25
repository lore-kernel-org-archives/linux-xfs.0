Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1PFNSMf208917 for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 09:23:28 -0600
Received: from mail-vx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6AA432FD005
	for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 07:26:14 -0800 (PST)
Received: from mail-vx0-f181.google.com (mail-vx0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	lbQN3uQAEI6C6y9G for <xfs@oss.sgi.com>;
	Fri, 25 Feb 2011 07:26:14 -0800 (PST)
Received: by vxb39 with SMTP id 39so1527291vxb.26
	for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 07:26:13 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 25 Feb 2011 10:23:06 -0500
Message-ID: <AANLkTimJ0tdvSy+7MSykNm4mW1XoO8PQ_-G9UBonFh8V@mail.gmail.com>
Subject: xfs_repair in traversing filesystem
From: Chris Walker <christopher.walker@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

Our 35TB XFS filesystem developed some problems and was throwing these:

Filesystem "dm-0": Access to block zero in inode 160564555
start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 451b

so we're running xfs_repair on this filesystem.  It finds this inode
and everything looks good, but then it hangs at

Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...

previous posts suggest running

xfs_repair -P -o bhash=1024

is this still the best way around this problem?  We're using the
latest xfsprogs (3.1.4).

Thanks very much,
Chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
