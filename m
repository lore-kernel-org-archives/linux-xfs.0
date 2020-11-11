Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02279C388F7
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4F0C21D7F
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:45:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="avfYtBDs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732473AbgKKApH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 19:45:07 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48600 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732471AbgKKApH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 19:45:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0XmQC110506;
        Wed, 11 Nov 2020 00:45:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ZISJicSdjUHdd449hzWRzWMRs0WaLwYokQU7Kryy2ZU=;
 b=avfYtBDsYmR/9VC5uxA31DalPdbdKtcCQMcYSAHgY2fLU9KGlPeEvgOTjcboWdJb+XzB
 UDHkHtpHvTMSXgJh6rRN8uCqDnasnDYd2j1C7zWcZGJwbe7gBbuMs6OPTpT21kfkhZ9u
 2ROzAjAnocK8jx36izW+V1QTs2a7y14bxgvoWowDL6wZqYiy3ANSBz8T/rUKmd1X4FpZ
 XtuO8hXzdkd9w03Kq1QwocPDjxp9P3r7O26c7yVziure0mfD6og0WqCw/vnERZSqamrP
 R5TLPBIHD0bqDq7gstOx13AvVYTWscuYfpaxd0nzAl4FsaSyiNGTSNeaazP5fUQPN8Wz hA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34nkhkxnps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 00:45:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0U9OV097566;
        Wed, 11 Nov 2020 00:45:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34p5gxq7u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 00:45:04 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB0j3uw029395;
        Wed, 11 Nov 2020 00:45:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 16:45:03 -0800
Subject: [PATCH 4/4] fsstress: get rid of attr_list
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 10 Nov 2020 16:45:02 -0800
Message-ID: <160505550232.1389938.14087037220733512558.stgit@magnolia>
In-Reply-To: <160505547722.1389938.14377167906399924976.stgit@magnolia>
References: <160505547722.1389938.14377167906399924976.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=2 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

attr_list is deprecated, so just call llistxattr directly.  This is a
bit involved, since attr_remove_f was highly dependent on libattr
structures.  Note that attr_list uses llistxattr internally and
llistxattr is limited to XATTR_LIST_MAX, so this doesn't result in any
loss of functionality.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 ltp/fsstress.c |   80 ++++++++++++++++++++++++++------------------------------
 1 file changed, 37 insertions(+), 43 deletions(-)


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index ad42cb65..e4940ba4 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -393,7 +393,7 @@ struct print_string	flag_str = {0};
 
 void	add_to_flist(int, int, int, int);
 void	append_pathname(pathname_t *, char *);
-int	attr_list_path(pathname_t *, char *, const int, int, attrlist_cursor_t *);
+int	attr_list_path(pathname_t *, char *, const int);
 int	attr_remove_path(pathname_t *, const char *);
 int	attr_set_path(pathname_t *, const char *, const char *, const int);
 void	check_cwd(void);
@@ -860,28 +860,36 @@ append_pathname(pathname_t *name, char *str)
 	name->len += len;
 }
 
+int
+attr_list_count(char *buffer, int buffersize)
+{
+	char *p = buffer;
+	char *end = buffer + buffersize;
+	int count = 0;
+
+	while (p < end && *p != 0) {
+		count++;
+		p += strlen(p) + 1;
+	}
+
+	return count;
+}
+
 int
 attr_list_path(pathname_t *name,
 	       char *buffer,
-	       const int buffersize,
-	       int flags,
-	       attrlist_cursor_t *cursor)
+	       const int buffersize)
 {
 	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
 
-	if (flags != ATTR_DONTFOLLOW) {
-		errno = EINVAL;
-		return -1;
-	}
-
-	rval = attr_list(name->path, buffer, buffersize, flags, cursor);
+	rval = llistxattr(name->path, buffer, buffersize);
 	if (rval >= 0 || errno != ENAMETOOLONG)
 		return rval;
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
-		rval = attr_list_path(&newname, buffer, buffersize, flags, cursor);
+		rval = attr_list_path(&newname, buffer, buffersize);
 		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
@@ -2302,32 +2310,24 @@ aread_f(int opno, long r)
 void
 attr_remove_f(int opno, long r)
 {
-	attrlist_ent_t		*aep;
-	attrlist_t		*alist;
-	char			*aname;
-	char			buf[4096];
-	attrlist_cursor_t	cursor;
+	char			*bufname;
+	char			*bufend;
+	char			*aname = NULL;
+	char			buf[XATTR_LIST_MAX];
 	int			e;
 	int			ent;
 	pathname_t		f;
-	int			total;
+	int			total = 0;
 	int			v;
 	int			which;
 
 	init_pathname(&f);
 	if (!get_fname(FT_ANYm, r, &f, NULL, NULL, &v))
 		append_pathname(&f, ".");
-	total = 0;
-	bzero(&cursor, sizeof(cursor));
-	do {
-		bzero(buf, sizeof(buf));
-		e = attr_list_path(&f, buf, sizeof(buf), ATTR_DONTFOLLOW, &cursor);
-		check_cwd();
-		if (e)
-			break;
-		alist = (attrlist_t *)buf;
-		total += alist->al_count;
-	} while (alist->al_more);
+	e = attr_list_path(&f, buf, sizeof(buf));
+	check_cwd();
+	if (e > 0)
+		total = attr_list_count(buf, e);
 	if (total == 0) {
 		if (v)
 			printf("%d/%d: attr_remove - no attrs for %s\n",
@@ -2335,25 +2335,19 @@ attr_remove_f(int opno, long r)
 		free_pathname(&f);
 		return;
 	}
+
 	which = (int)(random() % total);
-	bzero(&cursor, sizeof(cursor));
+	bufname = buf;
+	bufend = buf + e;
 	ent = 0;
-	aname = NULL;
-	do {
-		bzero(buf, sizeof(buf));
-		e = attr_list_path(&f, buf, sizeof(buf), ATTR_DONTFOLLOW, &cursor);
-		check_cwd();
-		if (e)
-			break;
-		alist = (attrlist_t *)buf;
-		if (which < ent + alist->al_count) {
-			aep = (attrlist_ent_t *)
-				&buf[alist->al_offset[which - ent]];
-			aname = aep->a_name;
+	while (bufname < bufend) {
+		if (which < ent) {
+			aname = bufname;
 			break;
 		}
-		ent += alist->al_count;
-	} while (alist->al_more);
+		ent++;
+		bufname += strlen(bufname) + 1;
+	}
 	if (aname == NULL) {
 		if (v)
 			printf(

