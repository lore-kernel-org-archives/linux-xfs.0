Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F5E9C7619D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E772B21D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MNaiU0xu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgBTBmb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:42:31 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48420 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727476AbgBTBmb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:42:31 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1cUtY039822;
        Thu, 20 Feb 2020 01:42:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=baj94MHEM+IJpZ8LpMTDIXZKBjr47MuJ1Eg2bbwhU/w=;
 b=MNaiU0xuV2IfVCUwjOJX7TT0TmDXfFbzX0KVCqv5H978QxfzCHRwCNMmdijen7wJh2EX
 C0cYJ4ILsUQ6sxvDRPDGo6vPYv1xvrv8frKYlPHBPhSCY3YwZqq3sUqxoN3Xmh7j4NV5
 +L3fvOMB0EHgvmGbqIWtWjxYnw/yT0zFSy4vULz5ZW5znJ9HlqAR9EJn3VHq0h/6KTHR
 w9hkljTGw+104idoISNASiOs1Af/MwMyYR7PzHTfeRbn2MFRbd8IPLhwR6ohjilGU5YS
 7FB5HhZuE4CQtJp0J2qp0yaHQCT/X0bkXnDgf0VOq81buqvvuXmB/Ny1bF9vECQVYMu/ gA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2y8ud16s9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gJE7189098;
        Thu, 20 Feb 2020 01:42:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2y8ud96wn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:28 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1gRZv005854;
        Thu, 20 Feb 2020 01:42:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:42:26 -0800
Subject: [PATCH 7/8] xfs_repair: check that metadata updates have been
 committed
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:42:25 -0800
Message-ID: <158216294593.601264.16626864880754547783.stgit@magnolia>
In-Reply-To: <158216290180.601264.5491208016048898068.stgit@magnolia>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=2 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=2 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new function that will ensure that everything we changed has
landed on stable media, and report the results.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/xfs_repair.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index eb1ce546..c0a77cad 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -690,6 +690,36 @@ check_fs_vs_host_sectsize(
 	}
 }
 
+/* Flush the devices and complain if anything bad happened. */
+static bool
+check_write_failed(
+	struct xfs_mount	*mp)
+{
+	int			d, l, r;
+
+	libxfs_flush_devices(mp, &d, &l, &r);
+
+	if (d == -ENOTRECOVERABLE)
+		do_warn(_("Lost writes to data device, please re-run.\n"));
+	else if (d)
+		do_warn(_("Error %d flushing data device, please re-run.\n"),
+				-d);
+
+	if (l == -ENOTRECOVERABLE)
+		do_warn(_("Lost writes to log device, please re-run.\n"));
+	else if (l)
+		do_warn(_("Error %d flushing log device, please re-run.\n"),
+				-l);
+
+	if (r == -ENOTRECOVERABLE)
+		do_warn(_("Lost writes to realtime device, please re-run.\n"));
+	else if (r)
+		do_warn(_("Error %d flushing realtime device, please re-run.\n"),
+				-r);
+
+	return d || l || r;
+}
+
 int
 main(int argc, char **argv)
 {
@@ -703,6 +733,7 @@ main(int argc, char **argv)
 	struct xfs_sb	psb;
 	int		rval;
 	struct xfs_ino_geometry	*igeo;
+	bool		writes_failed;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -1106,6 +1137,8 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 	format_log_max_lsn(mp);
 	libxfs_umount(mp);
 
+	writes_failed = check_write_failed(mp);
+
 	if (x.rtdev)
 		libxfs_device_close(x.rtdev);
 	if (x.logdev && x.logdev != x.ddev)
@@ -1125,6 +1158,8 @@ _("Repair of readonly mount complete.  Immediate reboot encouraged.\n"));
 
 	free(msgbuf);
 
+	if (writes_failed)
+		return 1;
 	if (fs_is_dirty && report_corrected)
 		return (4);
 	return (0);

