Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 00:16:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9O7GQaG030482
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 00:16:28 -0700
Date: Tue, 24 Oct 2006 17:15:33 +1000
From: David Chinner <dgc@sgi.com>
Subject: [REVIEW 0 of 4] Fix xfs_iunpin use after free badness
Message-ID: <20061024071533.GQ11034@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: t-nagano@ah.jp.nec.com, xfs-dev@sgi.com

The following 4 patches fix the long standing issues with
xfs_iunpin accessing the linux inode after it has been freed.

The first patch cleans up the i_flags_lock handling and the
setting and clearing of the i_flags. This has
been posted before in a different context, and is simply a cleanup patch.

The second patch removes the need for grabbing the linux
inode in xfs_iunpin(). This causes deadlocks when the xfslogd
drops the final reference to an inode and needs to issue a transaction
when the log is full. We can do this by providing a guarantee
external to xfs_iunpin() that when either of the XFS_IRECLAIM
or XFS_IRECLAIMABLE flags are set on the xfs inode there is
no linux inode to look up.

The third patch fixes the xfs_iget_core() handling of the
XFS_IRECLAIMABLE flag so it doesn't violate the guarantee we
need to provide to xfs_iunpin() w.r.t. the existence of a
linux inode.

The last patch closes a race condition in xfs_iunpin()
as we need to guarantee the atomicity of the last unpin
and the checking of the XFS_IRECLAIM* flags otherwise
pre-emption or interrupt can cause us to race with
xfs_iget_core() which would now see the inode as unpinned
and hence clear the XFS_IRECLAIMABLE flag.

Many thanks go to Takenori Nagano for his help in getting to
the bottom of this issue and the testing that he has done.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
