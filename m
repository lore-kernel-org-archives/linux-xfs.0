Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5EAAC388F7
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F1FD221F7
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:45:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h/dFSgQa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732264AbgKKApC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 19:45:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35356 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732432AbgKKApA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 19:45:00 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0ZQQl016861;
        Wed, 11 Nov 2020 00:44:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Y7vvaiIy+72Jn5DkfvcYc6/nZYqsudMwxsmRDmvXwKg=;
 b=h/dFSgQaFX+DWLCWEXp2Dh9KM9+0wlCoRL7u7ZadXIiexyXV+Z1zgsgH9V+Hc90d2RQi
 fD/+9vR/j+ZoSr+TFBNLEul6fm0iNCjlx6Zc3292MfSe51Ic6pNMpFfiXREJXrWfQSXB
 2fHANJilMKUflKuytK0S8jktdF9u8NJse8wvL64txBi3X74LQzM6K7prmI2mjmE6DPGe
 J+Cls4JsXZPj2og6ZWyCEHFdb9w6c/jyYM22Jk07rzGEo4p0yFxPmsO6Vk9qN2yez0xR
 XcZ5mGLoqvgf9JSk3hc9FDC6FLHnyPcqJc9IjPokrD8DUky7nVdmySRM8NmOFFUlm4PK Ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34p72emv6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 00:44:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0V6v1027454;
        Wed, 11 Nov 2020 00:44:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34qgp7krcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 00:44:58 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AB0ivML018557;
        Wed, 11 Nov 2020 00:44:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 16:44:57 -0800
Subject: [PATCH 3/4] fsstress: remove attr_remove
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 10 Nov 2020 16:44:56 -0800
Message-ID: <160505549612.1389938.4557085048629140407.stgit@magnolia>
In-Reply-To: <160505547722.1389938.14377167906399924976.stgit@magnolia>
References: <160505547722.1389938.14377167906399924976.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=2 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=2 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

attr_remove is deprecated, so replace it with lremovexattr.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 ltp/fsstress.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 41b31060..ad42cb65 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -394,7 +394,7 @@ struct print_string	flag_str = {0};
 void	add_to_flist(int, int, int, int);
 void	append_pathname(pathname_t *, char *);
 int	attr_list_path(pathname_t *, char *, const int, int, attrlist_cursor_t *);
-int	attr_remove_path(pathname_t *, const char *, int);
+int	attr_remove_path(pathname_t *, const char *);
 int	attr_set_path(pathname_t *, const char *, const char *, const int);
 void	check_cwd(void);
 void	cleanup_flist(void);
@@ -889,18 +889,18 @@ attr_list_path(pathname_t *name,
 }
 
 int
-attr_remove_path(pathname_t *name, const char *attrname, int flags)
+attr_remove_path(pathname_t *name, const char *attrname)
 {
 	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
 
-	rval = attr_remove(name->path, attrname, flags);
+	rval = lremovexattr(name->path, attrname);
 	if (rval >= 0 || errno != ENAMETOOLONG)
 		return rval;
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
-		rval = attr_remove_path(&newname, attrname, flags);
+		rval = attr_remove_path(&newname, attrname);
 		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
@@ -2362,7 +2362,7 @@ attr_remove_f(int opno, long r)
 		free_pathname(&f);
 		return;
 	}
-	e = attr_remove_path(&f, aname, ATTR_DONTFOLLOW) < 0 ? errno : 0;
+	e = attr_remove_path(&f, aname) < 0 ? errno : 0;
 	check_cwd();
 	if (v)
 		printf("%d/%d: attr_remove %s %s %d\n",

