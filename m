Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D323C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:25:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46F3220659
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:25:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0D3bPc8l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgFBEZf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:25:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46192 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgFBEZe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:25:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524ISFv121736;
        Tue, 2 Jun 2020 04:25:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=O18ot5zOb1loWyrXY4Qwj1C8MzNz+bjPn/RnijNPXgQ=;
 b=0D3bPc8lErqmN0L7QyudKRGI7ZdvS0ATRr5l105aw3EgDN+Kn+ahrOQP19LOiwO0RCHu
 xHId3UGNxFALxohBP22aJYn9SAYgQ2nHXY4oyQpHk5nvTrzFob8JFLSNCyLupbARG/0K
 yJ5kaFZoFVrSuoaaO0mRXq/Zg4gBRigLYjC413t0e41KpcaWGLCOTW63RVRpEm1yF9HC
 /jHs/1SXlF2jdGpkiw8T09ObtzxULMz0is94eUvUCyqk5NVbg/U84C4OLfNbUC85dwZX
 0NH660lgVslxHPQSrgTBcCx8hc0ma2cuF45HVjQrEbAWB19yGW+r9KVsJhRHhEVvHtHI lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31d5qr20n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:25:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524JDxm091125;
        Tue, 2 Jun 2020 04:25:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31c1dwge0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:25:29 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524PTcw020452;
        Tue, 2 Jun 2020 04:25:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:25:28 -0700
Subject: [PATCH 04/17] xfs_repair: check for AG btree records that would wrap
 around
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 01 Jun 2020 21:25:27 -0700
Message-ID: <159107192786.313760.11817417037779916800.stgit@magnolia>
In-Reply-To: <159107190111.313760.8056083399475334567.stgit@magnolia>
References: <159107190111.313760.8056083399475334567.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 mlxscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

For AG btree types, make sure that each record's length is not so huge
that integer wraparound would happen.

Found via xfs/358 fuzzing recs[1].blockcount = ones.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/scan.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


diff --git a/repair/scan.c b/repair/scan.c
index 5c8d8b23..1ddb5763 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -684,7 +684,8 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 					b, i, name, agno, bno);
 				continue;
 			}
-			if (len == 0 || !verify_agbno(mp, agno, end - 1)) {
+			if (len == 0 || end <= b ||
+			    !verify_agbno(mp, agno, end - 1)) {
 				do_warn(
 	_("invalid length %u in record %u of %s btree block %u/%u\n"),
 					len, i, name, agno, bno);
@@ -1066,7 +1067,8 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 					b, i, name, agno, bno);
 				continue;
 			}
-			if (len == 0 || !verify_agbno(mp, agno, end - 1)) {
+			if (len == 0 || end <= b ||
+			    !verify_agbno(mp, agno, end - 1)) {
 				do_warn(
 	_("invalid length %u in record %u of %s btree block %u/%u\n"),
 					len, i, name, agno, bno);
@@ -1353,7 +1355,8 @@ _("leftover CoW extent has invalid startblock in record %u of %s btree block %u/
 					b, i, name, agno, bno);
 				continue;
 			}
-			if (len == 0 || !verify_agbno(mp, agno, end - 1)) {
+			if (len == 0 || end <= agb ||
+			    !verify_agbno(mp, agno, end - 1)) {
 				do_warn(
 	_("invalid length %u in record %u of %s btree block %u/%u\n"),
 					len, i, name, agno, bno);

