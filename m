Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70A40C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C88D2063A
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:30:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ePN9jUxu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgEIQa1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:30:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49344 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgEIQa1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:30:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GMgq6072468;
        Sat, 9 May 2020 16:30:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=V4PTRXsPW6H9tFpKgl1/9RL1RSD94gFHz5PqHdB8qJk=;
 b=ePN9jUxuqHOvJQE+Jht4scwNOe63CkHU1t5hpdmNfsy8CXS/N69JmqCxpctHhsGZc1sC
 CRG5S1vYsss5p1IUxo81GuLq0twAoPbNvbof1NFN2A8RjQ+qWOjnl1hdzETNnTfy5FX0
 3JnJgtwVloxQLzuxOlBtNHurLpD2vDkMpbyS6rSvHObxWss25ghfTHxn1o0onF3rJL56
 8bLB8N7kJgXFRtoHO7nS+rWgFbIH72IzXojytJUi2KIL704zPmtlcY3p4AYrnrTtuzRH
 1u3C9baFXDx9zNHlUBXM8HQ8sbR4EUxt8Pu3A07kfUmDVrvPDl3lbz3VmH5uxFmd2Mom KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30wkxqs6ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:30:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GTurh112443;
        Sat, 9 May 2020 16:30:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30wx11cutv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:30:25 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049GUOmp025757;
        Sat, 9 May 2020 16:30:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:30:24 -0700
Subject: [PATCH 05/16] xfs_repair: check for out-of-order inobt records
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:30:24 -0700
Message-ID: <158904182463.982941.12723858451786554882.stgit@magnolia>
In-Reply-To: <158904179213.982941.9666913277909349291.stgit@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0
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

Make sure that the inode btree records are in order.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/scan.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/repair/scan.c b/repair/scan.c
index 2d156d64..7c46ab89 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1947,6 +1947,7 @@ scan_inobt(
 	const struct xfs_buf_ops *ops)
 {
 	struct aghdr_cnts	*agcnts = priv;
+	xfs_agino_t		lastino = 0;
 	int			i;
 	int			numrecs;
 	int			state;
@@ -2029,7 +2030,16 @@ _("inode btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		 * the block.  skip processing of bogus records.
 		 */
 		for (i = 0; i < numrecs; i++) {
+			xfs_agino_t	startino;
+
 			freecount = inorec_get_freecount(mp, &rp[i]);
+			startino = be32_to_cpu(rp[i].ir_startino);
+			if (i > 0 && startino <= lastino)
+				do_warn(_(
+	"out-of-order ino btree record %d (%u) block %u/%u\n"),
+						i, startino, agno, bno);
+			else
+				lastino = startino + XFS_INODES_PER_CHUNK - 1;
 
 			if (magic == XFS_IBT_MAGIC ||
 			    magic == XFS_IBT_CRC_MAGIC) {

