Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0AF2CA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 17:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 939AB2173E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 17:53:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m5nO6o/n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfJ3RxC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 13:53:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41056 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfJ3RxB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 13:53:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9UHj0D1142678;
        Wed, 30 Oct 2019 17:52:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=o/Il95n1YkPZ+FpaOthExYpjwvBYDPDrPj42sv3aQ7I=;
 b=m5nO6o/n+Y2hgfR0k4kDviS7owlXrWw9ePg4iUFgaUamQWykzM5/k07vTikxV07I0ieA
 LJZE9W4eMS1JzApOhPoitt9K/hEBYvWq73vkZi6Kwg/XJAM02llJkcCEB2RRk0M88C0b
 LHFviXpMA9hwvvuBE19swA4/UCFub4fsonJBlO/DIs4Kd/qhovgewjhD+vYGiBv7DWXn
 0z3e/94u0UdqEmsqCQ4cHCZM1mj6L+QrASXDYAal+hZaiUUbiqbxMho8Evsh0AWyMvmE
 cXDFhJjk/W/cDOj5KBW6ZgXn4pKBY/2KvsLPiHfNKvnmw6ic6w2Lqq6p/J8vBmrx9LoV vA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vxwhfp033-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 17:52:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9UHiqna014121;
        Wed, 30 Oct 2019 17:52:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vxwj76e0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 17:52:57 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9UHqvWI006375;
        Wed, 30 Oct 2019 17:52:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Oct 2019 10:52:57 -0700
Date:   Wed, 30 Oct 2019 10:52:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/5] xfs_repair: print better information when metadata
 updates fail
Message-ID: <20191030175256.GP15222@magnolia>
References: <157176999124.1458930.5678023201951458107.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157176999124.1458930.5678023201951458107.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910300155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910300155
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If a metadata update fails during phase 6, we should print an error
message that can be traced back to a specific line of code.  Also,
res_failed spits out a general message about "xfs_trans_reserve failed",
which is probably not where the failure happened.  Fix two incorrect
call sites.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase6.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 28e633de..91d208a6 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1354,7 +1354,8 @@ longform_dir2_rebuild(
 
 	error = dir_binval(tp, ip, XFS_DATA_FORK);
 	if (error)
-		res_failed(error);
+		do_error(_("error %d invalidating directory %llu blocks\n"),
+				error, (unsigned long long)ip->i_ino);
 
 	if ((error = -libxfs_bmap_last_offset(ip, &lastblock, XFS_DATA_FORK)))
 		do_error(_("xfs_bmap_last_offset failed -- error - %d\n"),
@@ -2972,7 +2973,10 @@ process_dir_inode(
 					XFS_ILOG_CORE | XFS_ILOG_DDATA);
 				error = -libxfs_trans_commit(tp);
 				if (error)
-					res_failed(error);
+					do_error(
+_("error %d fixing shortform directory %llu\n"),
+						error,
+						(unsigned long long)ip->i_ino);
 			} else  {
 				libxfs_trans_cancel(tp);
 			}
