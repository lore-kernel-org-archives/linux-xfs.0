Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 403A3C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 164DA2072D
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:00:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nsgwvE4j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgHQXAJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 19:00:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52676 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728170AbgHQXAH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 19:00:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvRNO050046;
        Mon, 17 Aug 2020 23:00:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ddI/P455nkzGpADtDsn4CHbTgO5aV7pfYsexjEQY8r4=;
 b=nsgwvE4jmwz0+eYxseCFBz52GHEe7Q/OYzBp+UdAiehL3ZKIrJTumnFQ7qoosB22UZin
 TIZZ5I/M+4tcWywI+WZBkxmcOwvWJXEKlqbfY4Sd9WYrEscYwawPojTd49v+CVJwKmP9
 JH6k8LXGiUhw2wvWLCqZPMDPL9cYecb/0Zls1FNcRUALMtfsEbDx9PsgcnBJ+fxMN2U2
 zS36xp5sk/ATvzo8u+aSMPDWXGVKn1c6bAg4RQ6wDX2m1Hv/Y4gSD/9g8VnIYAnoeX+y
 6O5QIqjV73Xtmispik7ivfk9hVqJoJQk0W/DJ96qRb6a206N9ltWki59UD/AHN6uAXm/ 0w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32x7nm9ju7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 23:00:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMwtal113620;
        Mon, 17 Aug 2020 23:00:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32xsmwghjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 23:00:05 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HN04ot018305;
        Mon, 17 Aug 2020 23:00:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 16:00:04 -0700
Subject: [PATCH 11/18] xfs: refactor quota timestamp coding
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 16:00:02 -0700
Message-ID: <159770520255.3958786.18344458914688900638.stgit@magnolia>
In-Reply-To: <159770513155.3958786.16108819726679724438.stgit@magnolia>
References: <159770513155.3958786.16108819726679724438.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor quota timestamp encoding and decoding into helper functions so
that we can add extra behavior in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_dquot_buf.c  |   20 ++++++++++++++++++++
 libxfs/xfs_quota_defs.h |    6 ++++++
 2 files changed, 26 insertions(+)


diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index b5adb840d015..847b9ba5280c 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -286,3 +286,23 @@ const struct xfs_buf_ops xfs_dquot_buf_ra_ops = {
 	.verify_read = xfs_dquot_buf_readahead_verify,
 	.verify_write = xfs_dquot_buf_write_verify,
 };
+
+/* Convert an on-disk timer value into an incore timer value. */
+void
+xfs_dquot_from_disk_timestamp(
+	struct xfs_disk_dquot	*ddq,
+	time64_t		*timer,
+	__be32			dtimer)
+{
+	*timer = be32_to_cpu(dtimer);
+}
+
+/* Convert an incore timer value into an on-disk timer value. */
+void
+xfs_dquot_to_disk_timestamp(
+	struct xfs_dquot	*dqp,
+	__be32			*dtimer,
+	time64_t		timer)
+{
+	*dtimer = cpu_to_be32(timer);
+}
diff --git a/libxfs/xfs_quota_defs.h b/libxfs/xfs_quota_defs.h
index 076bdc7037ee..b524059faab5 100644
--- a/libxfs/xfs_quota_defs.h
+++ b/libxfs/xfs_quota_defs.h
@@ -143,4 +143,10 @@ extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
 extern void xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
 		xfs_dqid_t id, xfs_dqtype_t type);
 
+struct xfs_dquot;
+void xfs_dquot_from_disk_timestamp(struct xfs_disk_dquot *ddq,
+		time64_t *timer, __be32 dtimer);
+void xfs_dquot_to_disk_timestamp(struct xfs_dquot *ddq,
+		__be32 *dtimer, time64_t timer);
+
 #endif	/* __XFS_QUOTA_H__ */

