Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50383C35DEA
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2027620838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:11:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lVLNUSh3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgBYALa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:11:30 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55376 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBYALa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:11:30 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P09Kbe033726;
        Tue, 25 Feb 2020 00:11:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qS+c29V4b9uqPYdBEoisXQqxx/ZV9Sp10aB2LWExdoU=;
 b=lVLNUSh3h0wJpVP/y6HBsjUxqEDsiliYWs2t5K0bHcvvPloSvAwqnisVB6NsWvEbfj9Q
 0eyoEy3y9wjDe1cKJMOq7XYK2yRNVaKv7m7IyMjR3EXaCfC4g4jslMDVqyHDniSRXIJm
 MwpWuDHVIoUf6ZVpC8OzYEAHg17ft1gEwx8PzA6SLfiTxlMBRRix4W6ybWo2msKCaY4S
 Y8VY94MhBiV28rhXNx1bK4phg7yte/e4nV3++kqu/059uyzT9mCHf3NnlhQHueILZlFa
 CMlP95qBEsGjhBWgwPgrBGjM2gk/To7nU3PGeev/xfUIq3qZKJD8ixkgfjhkVH567DsS hQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ycppr8gju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:11:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07wj2109442;
        Tue, 25 Feb 2020 00:11:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ybe12eng8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:11:27 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P0BRtc031870;
        Tue, 25 Feb 2020 00:11:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:11:27 -0800
Subject: [PATCH 2/2] libxfs: clean up libxfs_destroy
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Feb 2020 16:11:26 -0800
Message-ID: <158258948621.451256.5275982330161893261.stgit@magnolia>
In-Reply-To: <158258947401.451256.14269201133311837600.stgit@magnolia>
References: <158258947401.451256.14269201133311837600.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=2 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=2 impostorscore=0
 spamscore=0 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

It's weird that libxfs_init opens the three devices passed in via the
libxfs_xinit structure but libxfs_destroy doesn't actually close them.
Fix this inconsistency and remove all the open-coded device closing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 copy/xfs_copy.c     |    2 +-
 db/init.c           |    8 +-------
 include/libxfs.h    |    2 +-
 libxfs/init.c       |   31 +++++++++++++++++++++++--------
 mkfs/xfs_mkfs.c     |    7 +------
 repair/xfs_repair.c |    7 +------
 6 files changed, 28 insertions(+), 29 deletions(-)


diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index a6d67038..7f4615ac 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -1200,7 +1200,7 @@ main(int argc, char **argv)
 
 	check_errors();
 	libxfs_umount(mp);
-	libxfs_destroy();
+	libxfs_destroy(&xargs);
 
 	return 0;
 }
diff --git a/db/init.c b/db/init.c
index 0ac37368..e5450d2b 100644
--- a/db/init.c
+++ b/db/init.c
@@ -217,13 +217,7 @@ main(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 	libxfs_umount(mp);
-	if (x.ddev)
-		libxfs_device_close(x.ddev);
-	if (x.logdev && x.logdev != x.ddev)
-		libxfs_device_close(x.logdev);
-	if (x.rtdev)
-		libxfs_device_close(x.rtdev);
-	libxfs_destroy();
+	libxfs_destroy(&x);
 
 	return exitcode;
 }
diff --git a/include/libxfs.h b/include/libxfs.h
index aaac00f6..504f6e9c 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -136,7 +136,7 @@ typedef struct libxfs_xinit {
 extern char	*progname;
 extern xfs_lsn_t libxfs_max_lsn;
 extern int	libxfs_init (libxfs_init_t *);
-extern void	libxfs_destroy (void);
+void		libxfs_destroy(struct libxfs_xinit *li);
 extern int	libxfs_device_to_fd (dev_t);
 extern dev_t	libxfs_device_open (char *, int, int, int);
 extern void	libxfs_device_close (dev_t);
diff --git a/libxfs/init.c b/libxfs/init.c
index 197690df..913f546f 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -259,6 +259,21 @@ destroy_zones(void)
 	return leaked;
 }
 
+static void
+libxfs_close_devices(
+	struct libxfs_xinit	*li)
+{
+	if (li->ddev)
+		libxfs_device_close(li->ddev);
+	if (li->logdev && li->logdev != li->ddev)
+		libxfs_device_close(li->logdev);
+	if (li->rtdev)
+		libxfs_device_close(li->rtdev);
+
+	li->ddev = li->logdev = li->rtdev = 0;
+	li->dfd = li->logfd = li->rtfd = -1;
+}
+
 /*
  * libxfs initialization.
  * Caller gets a 0 on failure (and we print a message), 1 on success.
@@ -385,12 +400,9 @@ libxfs_init(libxfs_init_t *a)
 		unlink(rtpath);
 	if (fd >= 0)
 		close(fd);
-	if (!rval && a->ddev)
-		libxfs_device_close(a->ddev);
-	if (!rval && a->logdev)
-		libxfs_device_close(a->logdev);
-	if (!rval && a->rtdev)
-		libxfs_device_close(a->rtdev);
+	if (!rval)
+		libxfs_close_devices(a);
+
 	return rval;
 }
 
@@ -913,9 +925,12 @@ libxfs_umount(
  * Release any global resources used by libxfs.
  */
 void
-libxfs_destroy(void)
+libxfs_destroy(
+	struct libxfs_xinit	*li)
 {
-	int	leaked;
+	int			leaked;
+
+	libxfs_close_devices(li);
 
 	/* Free everything from the buffer cache before freeing buffer zone */
 	libxfs_bcache_purge();
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 1038e604..7f315d8a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3945,11 +3945,6 @@ main(
 	if (error)
 		exit(1);
 
-	if (xi.rtdev)
-		libxfs_device_close(xi.rtdev);
-	if (xi.logdev && xi.logdev != xi.ddev)
-		libxfs_device_close(xi.logdev);
-	libxfs_device_close(xi.ddev);
-	libxfs_destroy();
+	libxfs_destroy(&xi);
 	return 0;
 }
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index ccb13f4a..38578121 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1111,12 +1111,7 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 	if (error)
 		exit(1);
 
-	if (x.rtdev)
-		libxfs_device_close(x.rtdev);
-	if (x.logdev && x.logdev != x.ddev)
-		libxfs_device_close(x.logdev);
-	libxfs_device_close(x.ddev);
-	libxfs_destroy();
+	libxfs_destroy(&x);
 
 	if (verbose)
 		summary_report();

