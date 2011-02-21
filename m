Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1LJ4GGB168556 for <xfs@oss.sgi.com>; Mon, 21 Feb 2011 13:04:16 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 11BA412B868F
	for <xfs@oss.sgi.com>; Mon, 21 Feb 2011 11:06:59 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0AAHGXtH4vS6TSAj for
	<xfs@oss.sgi.com>; Mon, 21 Feb 2011 11:06:59 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1LJ6wli003572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 21 Feb 2011 14:06:59 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p1LJ6v26016016
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 21 Feb 2011 14:06:58 -0500
Message-ID: <4D62B7D1.4040901@redhat.com>
Date: Mon, 21 Feb 2011 13:06:57 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: Don't ever try to set the device blocksize in repair
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
To: xfs-oss <xfs@oss.sgi.com>

On 4k devices, we get this warning from repair:

# xfs_repair /dev/sdc2
xfs_repair: warning - cannot set blocksize 512 on block device /dev/sdc2: Invalid argument
Phase 1 - find and verify superblock...
...

but things proceed without trouble after that.

I'm unable to find any history or reason for setting the
device blocksize at the beginning of repair, and in any case,
things clearly work without doing so.  So, let's just remove it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/init.c b/repair/init.c
index 654c406..bc10cc4 100644
--- a/repair/init.c
+++ b/repair/init.c
@@ -143,7 +143,7 @@ xfs_init(libxfs_init_t *args)
 	}
 
 	args->usebuflock = do_prefetch;
-	args->setblksize = !dangerously;
+	args->setblksize = 0;
 	args->isdirect = LIBXFS_DIRECT;
 	if (no_modify)
 		args->isreadonly = (LIBXFS_ISREADONLY | LIBXFS_ISINACTIVE);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
