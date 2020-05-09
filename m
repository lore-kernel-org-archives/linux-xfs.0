Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6ACC28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5E112063A
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:32:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IugF8J5Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgEIQct (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:32:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50822 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728323AbgEIQcp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:32:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GMgWj072358;
        Sat, 9 May 2020 16:32:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=f++7BFIHVMBNgLAEB8a0e8OUHCMIqY5TfZTmLGsT4CM=;
 b=IugF8J5ZOdEADyYSEp4JA6NGCnv4JNv+ThjH7a+zAa+KCIiiMPnV3UagV/su48pI9+Ph
 3f/F0jnFcoKbJHysYbq3sAZD3KIUFdw2gAF2TCWksoCxVeCQLB0dBDHiu6tIpYlCFSw5
 Z06qM+qO/tji31n5hX66jYfKfJB0RuPc2UMaFpLep4xi0gUMYcTjvZMYPA5NCzuZjVDg
 vBnzQu23nHpU0MWCRUDBHgUnpTVhRU+w6G4nbbAiMhhQ8bmcDQP8ltWzX+AsZJRvo18b
 dFBnd4w7BS3DZjgnmSX0EzFgMYbcey/lmaz0DkT/FwJJd9Nglc/gifNfsC7z84xRo5u7 RA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30wkxqs6jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:32:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GWaN1118560;
        Sat, 9 May 2020 16:32:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30wwwpnjdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:32:42 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049GUBFM020319;
        Sat, 9 May 2020 16:30:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:30:11 -0700
Subject: [PATCH 03/16] xfs_repair: check for AG btree records that would wrap
 around
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:30:11 -0700
Message-ID: <158904181121.982941.11919205494567354626.stgit@magnolia>
In-Reply-To: <158904179213.982941.9666913277909349291.stgit@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

For AG btree types, make sure that each record's length is not so huge
that integer wraparound would happen.

Found via xfs/358 fuzzing recs[1].blockcount = ones.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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

