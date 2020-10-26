Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB5DC4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9A4220809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SsBJwFJQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406857AbgJZXfA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:35:00 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:43400 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406870AbgJZXfA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:35:00 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPKe8177114;
        Mon, 26 Oct 2020 23:34:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=3NHXP+4JQh0wW9IIKowC3aBlxok8mkTroINvGvduzAA=;
 b=SsBJwFJQn0TLtsPISPz1TDwcIUc3atN+pwkTBeTo1GXCDNZNBFHOnZ8dfeQbUgnlHPhF
 YeMSzMFv0CKfEWF/Vv8q1l9f/Fh0OZgM0t2kMszGTK7oVYOXtkKmeuxAkFQqoMwu9kmy
 nUetJ0stz9QoAaSrsqBLIqLhg9m5WaSkSNvtzSdD0JY7QBydPwyziyDmLJaIPO6CQK75
 RPX4EYdAffkfbYOxNUrsdchuSYhI/FPzB0GSUglUeSWSBVzCWQ7JaPfS8RdYoSAVr9/L
 QRrltdAolxjukN6CgT0c2Wl2BR8wBphS98EqfX/lzzmqCRq57paDAJmYDj0MAaxXgwkR aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9saqd49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:34:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxFN110502;
        Mon, 26 Oct 2020 23:34:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34cx5wfs59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:34:58 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNYv84007631;
        Mon, 26 Oct 2020 23:34:57 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:34:57 -0700
Subject: [PATCH 08/26] xfs_logprint: refactor timestamp printing
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:34:56 -0700
Message-ID: <160375529676.881414.3983778876306819986.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Introduce type-specific printing functions to xfs_logprint to print an
xfs_timestamp instead of open-coding the timestamp decoding.  This is
needed to stay ahead of changes that we're going to make to
xfs_timestamp_t in the following patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 logprint/log_misc.c      |   18 ++++++++++++++++--
 logprint/log_print_all.c |    3 +--
 logprint/logprint.h      |    2 ++
 3 files changed, 19 insertions(+), 4 deletions(-)


diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index af927cbfa792..a747cbd360af 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -435,6 +435,21 @@ xlog_print_trans_qoff(char **ptr, uint len)
     }
 }	/* xlog_print_trans_qoff */
 
+void
+xlog_print_dinode_ts(
+	struct xfs_log_dinode	*ldip,
+	bool			compact)
+{
+	const char		*fmt;
+
+	if (compact)
+		fmt = _("atime 0x%x mtime 0x%x ctime 0x%x\n");
+	else
+		fmt = _("		atime:%d  mtime:%d  ctime:%d\n");
+
+	printf(fmt, ldip->di_atime.t_sec, ldip->di_mtime.t_sec,
+			ldip->di_ctime.t_sec);
+}
 
 static void
 xlog_print_trans_inode_core(
@@ -446,8 +461,7 @@ xlog_print_trans_inode_core(
 	   (int)ip->di_format);
     printf(_("nlink %hd uid %d gid %d\n"),
 	   ip->di_nlink, ip->di_uid, ip->di_gid);
-    printf(_("atime 0x%x mtime 0x%x ctime 0x%x\n"),
-	   ip->di_atime.t_sec, ip->di_mtime.t_sec, ip->di_ctime.t_sec);
+    xlog_print_dinode_ts(ip, true);
     printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%x\n"),
 	   (unsigned long long)ip->di_size, (unsigned long long)ip->di_nblocks,
 	   ip->di_extsize, ip->di_nextents);
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 1924a0af70b6..fae531d3e030 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -249,8 +249,7 @@ xlog_recover_print_inode_core(
 	printf(_("		uid:%d  gid:%d  nlink:%d projid:0x%04x%04x\n"),
 	       di->di_uid, di->di_gid, di->di_nlink,
 	       di->di_projid_hi, di->di_projid_lo);
-	printf(_("		atime:%d  mtime:%d  ctime:%d\n"),
-	       di->di_atime.t_sec, di->di_mtime.t_sec, di->di_ctime.t_sec);
+	xlog_print_dinode_ts(di, false);
 	printf(_("		flushiter:%d\n"), di->di_flushiter);
 	printf(_("		size:0x%llx  nblks:0x%llx  exsize:%d  "
 	     "nextents:%d  anextents:%d\n"), (unsigned long long)
diff --git a/logprint/logprint.h b/logprint/logprint.h
index ee85bfe5f21f..6639e1cf5862 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -29,6 +29,8 @@ extern void print_xlog_record_line(void);
 extern void print_xlog_op_line(void);
 extern void print_stars(void);
 
+void xlog_print_dinode_ts(struct xfs_log_dinode *ldip, bool compact);
+
 extern struct xfs_inode_log_format *
 	xfs_inode_item_format_convert(char *, uint, struct xfs_inode_log_format *);
 

