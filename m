Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D3C367CA2
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 23:22:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C4EC8304051
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 21:22:25 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7GGykP2fNMLlIDek for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 21:22:22 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfs: fixes for XFS_DIFLAG2_DAX support
Date: Mon, 15 Feb 2016 16:22:10 +1100
Message-Id: <1455513734-15192-1-git-send-email-david@fromorbit.com>
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
Cc: ross.zwisler@linux.intel.com, jack@suse.cz

Hi folks,

This is a series to add the correct constraints to using the on-disk
inode flag to enable DAX on per-file basis. The same constraints are
placed on setting the flag on directories for inheritance purposes.

These constraints are:
	- the inode flag is limited to regular files or directory
	  inodes.
	- the S_DAX flag is only ever set on regular files
	- the flag can only ever be set on filesystems which have
	  blocksize == PAGE_SIZE (for now)
	- When the flag is set or cleared, the current mapping
	  contents are flushed and then invalidated so that the new
	  access mode starts with an empty mapping.
	- Setting or clearing the flag is atomic w.r.t. IO and
	  page faults.

I've tested these manually with xfs_io (patchset for supporting
chattr +x/-x to be sent soon), and it all appears to work as
expected. I'd like to push these for 4.5-rc6 so the initial kernel
with support for this flag doesn't do silly things, so comments,
testing and review woul dbe appreciated.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
