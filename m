Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E67067CA0
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 22:41:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6F923AC002
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 20:41:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BQycTAJrz0mmuAIF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 17 Jun 2016 20:41:09 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 22F52D47B0
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 03:41:09 +0000 (UTC)
Received: from [IPv6:::1] (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id u5I3f777014582
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 23:41:08 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: set rsumino version to 2
Message-ID: <ebc1e9d3-a68b-115f-3a41-12e5579a085e@redhat.com>
Date: Fri, 17 Jun 2016 22:41:07 -0500
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

If we run xfs/033 with "-m crc=0", the test fails
with a repair output difference:

     Phase 7 - verify and correct link counts...
    +resetting inode INO nlinks from 0 to 1
     done

This is because when we zero out the realtime summary
inode and rebuild it, we set its version to 1, then
set its ip->i_d.di_nlink to 1.  This is a little odd,
because v1 inodes store their link count in di_onlink...

Then, later in repair we call xfs_inode_from_disk(),
which sees the version one inode, and converts it to
version 2 in part by copying di_onlink to di_nlink.
But we never *set* di_onlink, so di_nlink gets reset to
zero, and this error is discovered later in repair.

Interestingly, mk_rbmino() was changed in 138659f1
to set version 2; it looks like mk_rsumino was just
missed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

My only other point of confusion is that prior to
ff105f7 libxfs: update to 3.16 kernel code
the "resetting inode..." message wasn't emitted; I'm
not sure what changed there to affect this.  :/

diff --git a/repair/phase6.c b/repair/phase6.c
index 0a71164..774e2cd 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -760,7 +760,7 @@ mk_rsumino(xfs_mount_t *mp)
 			error);
 	}
 
-	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 1;
+	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 2;
 	memset(&ip->i_d, 0, sizeof(ip->i_d));
 
 	VFS_I(ip)->i_mode = S_IFREG;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
