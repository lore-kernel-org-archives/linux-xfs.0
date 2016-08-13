Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E15447CCF
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 12:25:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 61CF0AC003
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:25:56 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id spiqLhphJfiDx28c (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:25:54 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 4B88420449
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:25:53 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3sBTDc5nMnz104J
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:25:52 +0200 (CEST)
Resent-Message-ID: <20160813172456.GI3858@nyan>
Resent-To: xfs@oss.sgi.com
Message-Id: <16eb2ae9106fd3c5cc921b6be45a96a593d7a308.1471107858.git.felix.janda@posteo.de>
In-Reply-To: <cover.1471107858.git.felix.janda@posteo.de>
References: <cover.1471107858.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sat, 13 Aug 2016 18:20:47 +0200
Subject: [PATCHv2 xfsprogs 11/14] fsr: remove workaround for statvfs on Mac OS
	X
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

It can be removed since fsr is no longer built on Mac OS X.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 fsr/xfs_fsr.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 98390e7..9cffa1b 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -945,11 +945,7 @@ fsrfile_common(
 			fname, strerror(errno));
 		return -1;
 	}
-#ifndef statvfs64
 	bsize = vfss.f_frsize ? vfss.f_frsize : vfss.f_bsize;
-#else
-	bsize = vfss.f_bsize;
-#endif
 	if (statp->bs_blksize * statp->bs_blocks >
 	    vfss.f_bfree * bsize - minimumfree) {
 		fsrprintf(_("insufficient freespace for: %s: "
@@ -1717,11 +1713,7 @@ xfs_getrt(int fd, struct statvfs64 *sfbp)
 		close(fd);
 		return -1;
 	}
-#ifndef statvfs64
 	bsize = (sfbp->f_frsize ? sfbp->f_frsize : sfbp->f_bsize);
-#else
-	bsize = sfbp->f_bsize;
-#endif
 	factor = fsgeom.blocksize / bsize;         /* currently this is == 1 */
 	sfbp->f_bfree = (cnt.freertx * fsgeom.rtextsize) * factor;
 	return 0;
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
