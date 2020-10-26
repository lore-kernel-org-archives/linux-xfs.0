Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78762C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41FB620809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:33:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sx0uV4yB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406506AbgJZXd5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:33:57 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42580 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406482AbgJZXd4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:33:56 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPOPu177120;
        Mon, 26 Oct 2020 23:33:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/lDMMuf19pkPwalcpYnbJOLa9uMieT610+hZqZXat8k=;
 b=Sx0uV4yB9zBby72Atq8Fyc6If/Mbm23x16eEvxrBDYMdr6W7V5JJpzHK4r2mkeF/Bb8T
 lZveizZyogjVJe8byghm+bZZHPpiVsmqhfT/zIzo1Bh2Q8hH7XQdTk7Tz15ZoOMwaOTK
 1g4UUQ3OH7RLA3PYczlosg0YLae6vF+MOduqiTjqX8MygokbQzD4zRLKr2lm393SqfzA
 umIqStVzKEHOJrCHCk40pdfx9Os0SNfgyy4EO3X9QGNIqIT0OSL1ZDbOLb6CT7Dw7Yx8
 Dw6ha41xievFDvsZZBHuoLL32LwnJQ2FxQ/WmsW+xXzO2xMxCSFQpkj7gW8uyMADzrZV 0w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9saqd0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:33:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxGd110443;
        Mon, 26 Oct 2020 23:33:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx5wfrms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:33:53 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNXpqA005415;
        Mon, 26 Oct 2020 23:33:52 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:33:51 -0700
Subject: [PATCH 7/9] xfs_repair: regenerate inode btree block counters in AGI
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:33:50 -0700
Message-ID: <160375523066.880355.14411170857056218197.stgit@magnolia>
In-Reply-To: <160375518573.880355.12052697509237086329.stgit@magnolia>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Reset both inode btree block counters in the AGI when rebuilding the
metadata indexes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/repair/phase5.c b/repair/phase5.c
index 446f7ec0a1db..b97d23809f3c 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -172,6 +172,11 @@ build_agi(
 				cpu_to_be32(btr_fino->newbt.afake.af_levels);
 	}
 
+	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+		agi->agi_iblocks = cpu_to_be32(btr_ino->newbt.afake.af_blocks);
+		agi->agi_fblocks = cpu_to_be32(btr_fino->newbt.afake.af_blocks);
+	}
+
 	libxfs_buf_mark_dirty(agi_buf);
 	libxfs_buf_relse(agi_buf);
 }

