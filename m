Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735F7C5517A
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33FCD21D7F
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:44:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dWS1KcIi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732441AbgKKAoy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 19:44:54 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48480 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732432AbgKKAoy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 19:44:54 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0XmHX110483;
        Wed, 11 Nov 2020 00:44:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tkXCYU/47noBy5aVHguIPhk5KrRsc7NNJTDueCtqj1s=;
 b=dWS1KcIiKY34m5lpNDMw4EWyPsiiPpO4VDAz/tVFWBnKlJqkhtsdHR/cS8QUWONQidgH
 YYFVM4lI3GZBSieVGW7Q8XRdxPUdBBhQ+mcR7Y2OeFMRN9Y8zcC2AJ6xWVC7+1768Skr
 AQgpu8h4+JFLU7TYbDAJXSBA9mTDoQ55jkCxzMOeovdJw7JJBBP3dZmacFg+xQ09jM8r
 EGxMGJXPzmfiGaVQNi/3mPqGPsk/cXFm7pMrSjFFwyjG9iJfIZyIrnRdHZN5rRKyLcel
 whS9ut+a5/x40mmv+/Ru8ZSmbhEH0LZd5d0zLJr9f09AYt5MNuo/iv9mX2rQPE37hf1T SQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34nkhkxnpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 00:44:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0UrOG171436;
        Wed, 11 Nov 2020 00:44:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34p5g12qbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 00:44:52 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AB0ipM8001091;
        Wed, 11 Nov 2020 00:44:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 16:44:50 -0800
Subject: [PATCH 2/4] fsstress: stop using attr_set
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 10 Nov 2020 16:44:49 -0800
Message-ID: <160505548994.1389938.10129281247073522665.stgit@magnolia>
In-Reply-To: <160505547722.1389938.14377167906399924976.stgit@magnolia>
References: <160505547722.1389938.14377167906399924976.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=919 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=2 mlxlogscore=938 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

attr_set is deprecated, so replace it with lsetxattr.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 ltp/fsstress.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 1238fcf5..41b31060 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -395,7 +395,7 @@ void	add_to_flist(int, int, int, int);
 void	append_pathname(pathname_t *, char *);
 int	attr_list_path(pathname_t *, char *, const int, int, attrlist_cursor_t *);
 int	attr_remove_path(pathname_t *, const char *, int);
-int	attr_set_path(pathname_t *, const char *, const char *, const int, int);
+int	attr_set_path(pathname_t *, const char *, const char *, const int);
 void	check_cwd(void);
 void	cleanup_flist(void);
 int	creat_path(pathname_t *, mode_t);
@@ -909,19 +909,19 @@ attr_remove_path(pathname_t *name, const char *attrname, int flags)
 
 int
 attr_set_path(pathname_t *name, const char *attrname, const char *attrvalue,
-	      const int valuelength, int flags)
+	      const int valuelength)
 {
 	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
 
-	rval = attr_set(name->path, attrname, attrvalue, valuelength, flags);
+	rval = lsetxattr(name->path, attrname, attrvalue, valuelength, 0);
 	if (rval >= 0 || errno != ENAMETOOLONG)
 		return rval;
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
-		rval = attr_set_path(&newname, attrname, attrvalue, valuelength,
-			flags);
+		rval = attr_set_path(&newname, attrname, attrvalue,
+				     valuelength);
 		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
@@ -2392,7 +2392,7 @@ attr_set_f(int opno, long r)
 		len = 1;
 	aval = malloc(len);
 	memset(aval, nameseq & 0xff, len);
-	e = attr_set_path(&f, aname, aval, len, ATTR_DONTFOLLOW) < 0 ?
+	e = attr_set_path(&f, aname, aval, len) < 0 ?
 		errno : 0;
 	check_cwd();
 	free(aval);

