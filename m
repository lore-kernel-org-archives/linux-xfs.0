Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0IKjbLs128848 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 14:45:37 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1ED01171D3D
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 12:46:36 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id tFT9RsZ9rqluYaML for
	<xfs@oss.sgi.com>; Mon, 18 Jan 2010 12:46:36 -0800 (PST)
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 9F3E8AAE3B2
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 14:46:35 -0600 (CST)
Message-ID: <4B54C8AB.6080607@sandeen.net>
Date: Mon, 18 Jan 2010 14:46:35 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfsteststs: get fsstress DIO working on non-xfs filesystems
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

Pretty sure all DIO IO fails in fsstress today since XFS_IOC_DIOINFO
fails.  If so, rather than just bailing out on the op, assign
some sane default DIO parameters.

This falls down for 4k sector devices but not really sure how to get
the underlying sector size easily from here; I think we can live
with this for now.

hch suggested moving XFS_IOC_DIOINFO up higher in the vfs, that's
probably a good idea in the long run.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 6978381..dab6bf7 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -1818,9 +1818,9 @@ dread_f(int opno, long r)
 			printf(
 			"%d/%d: dread - xfsctl(XFS_IOC_DIOINFO) %s failed %d\n",
 				procid, opno, f.path, errno);
-		free_pathname(&f);
-		close(fd);
-		return;
+		diob.d_maxiosz = -1U;
+		diob.d_miniosz = 512;
+		diob.d_mem = 512;
 	}
 	align = (__int64_t)diob.d_miniosz;
 	lr = ((__int64_t)random() << 32) + random();
@@ -1888,9 +1888,9 @@ dwrite_f(int opno, long r)
 			printf("%d/%d: dwrite - xfsctl(XFS_IOC_DIOINFO)"
 				" %s failed %d\n",
 				procid, opno, f.path, errno);
-		free_pathname(&f);
-		close(fd);
-		return;
+		diob.d_maxiosz = -1U;
+		diob.d_miniosz = 512;
+		diob.d_mem = 512;
 	}
 	align = (__int64_t)diob.d_miniosz;
 	lr = ((__int64_t)random() << 32) + random();

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
