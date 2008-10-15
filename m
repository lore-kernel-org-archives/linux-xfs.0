Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Oct 2008 00:01:43 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F71fip020557
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 00:01:41 -0700
Date: Wed, 15 Oct 2008 18:03:13 +1100
Subject: [PATCH]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081015070313.89A8A58FA1E9@chook.melbourne.sgi.com>
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: options@melbourne.sgi.com, unrecognized@melbourne.sgi.com, with@melbourne.sgi.com, rw@melbourne.sgi.com, remount@melbourne.sgi.com, fix@melbourne.sgi.com, XFS@melbourne.sgi.com

Hi Linus,

Please include the following patch for 2.6.27.1 stable release as
suggested by Christoph Hellwig and Eric Sandeen.
It fixes a regression in the recent remount recoding
where remounting say from ro to rw allows the xfs flags to
be out of sync with the vfs flags, resulting
in failures for some programs such as touch (which end up calling xfs_setattr).
The fix is a very minor and clear.

Thanks,
Tim.

Date: Sun, 12 Oct 2008 14:30:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: xfs@oss.sgi.com
Subject: [PATCH] fix remount rw with unrecognized options

When we skip unrecognized options in xfs_fs_remount we should just break
out of the switch and not return because otherwise we may skip clearing
the xfs-internal read-only flag.  This will only show up on some
operations like touch because most read-only checks are done by the VFS
which thinks this filesystem is r/w.  Eventually we should replace the
XFS read-only flag with a helper that always checks the VFS flag to make
sure they can never get out of sync.

Bug reported and fix verified by Marcel Beister on #xfs.
Bug fix verified by updated xfstests/189.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Timothy Shimmin <tes@sgi.com>

Index: mainline/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- mainline.orig/fs/xfs/linux-2.6/xfs_super.c	2008-10-15 17:59:26.542652847 +1100
+++ mainline/fs/xfs/linux-2.6/xfs_super.c	2008-10-15 17:59:45.376217172 +1100
@@ -1323,7 +1323,7 @@ xfs_fs_remount(
 	"XFS: mount option \"%s\" not supported for remount\n", p);
 			return -EINVAL;
 #else
-			return 0;
+			break;
 #endif
 		}
 	}
