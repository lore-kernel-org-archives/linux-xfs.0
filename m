Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 165D9C47E49
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 01:49:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA5DD2173B
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 01:49:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qFaejWx4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbfJVBtv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 21:49:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39976 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfJVBtv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 21:49:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9M1mv75029349;
        Tue, 22 Oct 2019 01:49:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=/d20dlFjpWHInZ/jYJrKIAQNxd2vrD3KSWlT/M+q6QQ=;
 b=qFaejWx4W2ss+gI+VcPbeKG3N+D3pKoPnyHwWXUEGnh0X1ywDoHt6Mqn6YuTL74Kii8r
 SIjMLbEiMpEdI3nfvkvmgGfAWf7WWMGRJGx7lfiT+57g8lVf4llRQcHGmoYNH/qgN/CV
 dFevZV7eWG5PyPEa+A7IpCAPAZDLJ0R1iGVyT700/81c5udOW8RW8eHv3t1gGW8NFW57
 J30PDFEog/TT3RMytMVuary59qzvyLH7TKGAyiPou3J5TnBne2Rh8cKJeWr7nPyQ/kgl
 6dUE3zT+74eSEazeEfU6GY7bMHaAot+FIkGKoxJtSOQA8US7tg0i5s77uHQ/AqxgDV7O wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vqswtbfhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 01:49:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9M1m6Ix113502;
        Tue, 22 Oct 2019 01:49:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vrc00tn5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 01:49:48 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9M1nl6k005093;
        Tue, 22 Oct 2019 01:49:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Oct 2019 18:49:47 -0700
Subject: [PATCH 1/2] xfs/435: disable dmesg checks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 21 Oct 2019 18:49:46 -0700
Message-ID: <157170898616.1172383.6811130003893894634.stgit@magnolia>
In-Reply-To: <157170897992.1172383.2128928990011336996.stgit@magnolia>
References: <157170897992.1172383.2128928990011336996.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=771
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=873 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This test corrupts the filesystem to see what assertions and other
things to get logged, so don't treat that as a failure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/435 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/435 b/tests/xfs/435
index c6c846ad..7af63158 100755
--- a/tests/xfs/435
+++ b/tests/xfs/435
@@ -42,6 +42,7 @@ _require_loadable_fs_module "xfs"
 _require_quota
 _require_scratch_reflink
 _require_cp_reflink
+_disable_dmesg_check
 
 rm -f "$seqres.full"
 

