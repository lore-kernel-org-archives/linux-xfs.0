Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FEC9C43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6825621741
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:44:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PNLRxp2R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgIOBoS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:44:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50536 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIOBoR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:44:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1dJUL012987;
        Tue, 15 Sep 2020 01:44:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HZJmizr7+pUF3cuvWbKJzbl0H8BgQzkW7Owqrj6n3vk=;
 b=PNLRxp2RYDFmyF1/7jqySOW6afCnSsEdDiAdZhIaX472lWgwKHInEhZZhm3Jn10WPnJd
 Kmi3QEgeVh3kzzppdR60NVLr+2iAm6x741wfwJBu4iya69djbraeJ6agz8QyHbLTm/rg
 JjnY4sTNjH2LLePRPnloBL++G/uC8B53p1mhPY58R1tPc3fbb5Kk6uQfZGzMezjFWBnB
 OXmHgueAla69uTRtjPDAtrLhHnLb0S6jtfNKWWWcPwtSSf1gkvLYT4a9B0IatnLoYJeV
 cwov1fWthuFB7FBWLmbypQzeNTkpO3+FGCB6u/rTHD7/AqVZCZUrTrooJu0T2+xveHVp Kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33gp9m1wse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:44:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1eeK9022063;
        Tue, 15 Sep 2020 01:44:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33h88x2vgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:44:14 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08F1iD0n007071;
        Tue, 15 Sep 2020 01:44:13 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:44:13 +0000
Subject: [PATCH 12/24] overlay/020: make sure the system supports the required
 namespaces
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:44:12 -0700
Message-ID: <160013425217.2923511.11863740582450765597.stgit@magnolia>
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't run this test if the kernel doesn't support namespaces.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/overlay/020 |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/tests/overlay/020 b/tests/overlay/020
index 85488b83..9029f042 100755
--- a/tests/overlay/020
+++ b/tests/overlay/020
@@ -32,10 +32,16 @@ rm -f $seqres.full
 
 # real QA test starts here
 
+require_unshare() {
+	unshare -f -r "$@" true &>/dev/null || \
+		_notrun "unshare $@: not supported"
+}
+
 # Modify as appropriate.
 _supported_fs overlay
 _supported_os Linux
 _require_scratch
+require_unshare -m -p -U
 
 # Remove all files from previous tests
 _scratch_mkfs

