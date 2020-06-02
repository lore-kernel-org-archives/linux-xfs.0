Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC18C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBB482074B
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:29:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qnSIZqXj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbgFBE3F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:29:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35430 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFBE3F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:29:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524I5HG107526;
        Tue, 2 Jun 2020 04:29:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Aa3vQaJvpCUEHa03s/pUDzMK9CQezfQIMlk5yEn9Rsw=;
 b=qnSIZqXjjYkHSSVKMDS9OAGIT3af3QjQKDq3xrsCYvFqZ+cO8GKDOYYFFtBi8ZdpnQeW
 +UjegosoAVws4Ja4lqv2JRrkrz1U2w/IkfKhqs4yYdHz0aRyutRHC/zj8o+6SU2Up8g5
 Qh/mqlxNZ25RM83Y3qJxaLvfa7wumI+DWbCHnoVkhxRv9D3o7qjPLIM2Xq+z8wQvv7Mr
 MY7rRM1i0HlEsiprQNA39zUQvOB7pNO1VLOZvBcuV6AZXj5AT8wsTIISWz6F3gmMNMNM
 CMMRhyboosYabSgknMmkEbI2oFiYYfFQVvAMyKa6ntw4JRVs5ustxffIpfDbCIaCZ2Mx Yg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31bfem1ter-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:29:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524HxxB040289;
        Tue, 2 Jun 2020 04:27:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31c18sgh55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:27:01 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524R0ZL021490;
        Tue, 2 Jun 2020 04:27:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:27:00 -0700
Subject: [PATCH 01/12] xfs_repair: drop lostblocks from build_agf_agfl
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 01 Jun 2020 21:26:59 -0700
Message-ID: <159107201957.315004.49440739053731951.stgit@magnolia>
In-Reply-To: <159107201290.315004.4447998785149331259.stgit@magnolia>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=2 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=2
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We don't do anything with this parameter, so get rid of it.

Fixes: ef4332b8 ("xfs_repair: add freesp btree block overflow to the free space")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 677297fe..c9b278bd 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -2049,7 +2049,6 @@ build_agf_agfl(
 	struct bt_status	*bno_bt,
 	struct bt_status	*bcnt_bt,
 	xfs_extlen_t		freeblks,	/* # free blocks in tree */
-	int			lostblocks,	/* # blocks that will be lost */
 	struct bt_status	*rmap_bt,
 	struct bt_status	*refcnt_bt,
 	struct xfs_slab		*lost_fsb)
@@ -2465,9 +2464,9 @@ phase5_func(
 		/*
 		 * set up agf and agfl
 		 */
-		build_agf_agfl(mp, agno, &bno_btree_curs,
-				&bcnt_btree_curs, freeblks1, extra_blocks,
-				&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
+		build_agf_agfl(mp, agno, &bno_btree_curs, &bcnt_btree_curs,
+				freeblks1, &rmap_btree_curs,
+				&refcnt_btree_curs, lost_fsb);
 		/*
 		 * build inode allocation tree.
 		 */

