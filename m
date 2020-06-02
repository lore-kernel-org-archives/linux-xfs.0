Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE706C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8EDB206C3
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:29:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hcEeoVOH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgFBE3N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:29:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35502 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFBE3N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:29:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524HC1H106599;
        Tue, 2 Jun 2020 04:29:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tFzBGKFTu0fNUmBFF/QDkVMgq1PkoemLiOCmMX4cTdA=;
 b=hcEeoVOHXgnwMBzaqrDAylXFQcLCl3PKQfRr7mOCpspFYXmORxPEOCMR7/IVNSjzWuci
 c99/M60Gm8qGHdMB7YSZPKjSN89aCyxSaQIuYxaA4rqAJk9hhBPwEK9sKmy7UPoiayHY
 gqo7ssIgxGW114mLwy4JDeIRXmN0T8sCe21zulidRR97ykGPVPjtSRwxRGAKA3qO4mSp
 QH0TcuWN0SYqGNRz/PYaWA0xxvZmQ1WO94LcUzBY8/KodIi0nvnT1Ijf0McBjbPutoAC
 MXp4zq34gLN45hzMnLkhOPkF7fDG/0uJ/c3grIRT5i1x0X0ze0Acx4xpzZxmhQjn6dpG mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31bfem1tf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:29:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524Hw33040174;
        Tue, 2 Jun 2020 04:27:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31c18sgh7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:27:07 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0524R7wY021735;
        Tue, 2 Jun 2020 04:27:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:27:06 -0700
Subject: [PATCH 02/12] xfs_repair: rename the agfl index loop variable in
 build_agf_agfl
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 01 Jun 2020 21:27:05 -0700
Message-ID: <159107202579.315004.8068578556584944834.stgit@magnolia>
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

The variable 'i' is used to index the AGFL block list, so change the
name to make it clearer what this is to be used for.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index c9b278bd..169a2d89 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -2055,7 +2055,7 @@ build_agf_agfl(
 {
 	struct extent_tree_node	*ext_ptr;
 	struct xfs_buf		*agf_buf, *agfl_buf;
-	int			i;
+	unsigned int		agfl_idx;
 	struct xfs_agfl		*agfl;
 	struct xfs_agf		*agf;
 	xfs_fsblock_t		fsb;
@@ -2153,8 +2153,8 @@ build_agf_agfl(
 		agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
 		agfl->agfl_seqno = cpu_to_be32(agno);
 		platform_uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
-		for (i = 0; i < libxfs_agfl_size(mp); i++)
-			freelist[i] = cpu_to_be32(NULLAGBLOCK);
+		for (agfl_idx = 0; agfl_idx < libxfs_agfl_size(mp); agfl_idx++)
+			freelist[agfl_idx] = cpu_to_be32(NULLAGBLOCK);
 	}
 
 	/*
@@ -2165,19 +2165,21 @@ build_agf_agfl(
 		/*
 		 * yes, now grab as many blocks as we can
 		 */
-		i = 0;
-		while (bno_bt->num_free_blocks > 0 && i < libxfs_agfl_size(mp))
+		agfl_idx = 0;
+		while (bno_bt->num_free_blocks > 0 &&
+		       agfl_idx < libxfs_agfl_size(mp))
 		{
-			freelist[i] = cpu_to_be32(
+			freelist[agfl_idx] = cpu_to_be32(
 					get_next_blockaddr(agno, 0, bno_bt));
-			i++;
+			agfl_idx++;
 		}
 
-		while (bcnt_bt->num_free_blocks > 0 && i < libxfs_agfl_size(mp))
+		while (bcnt_bt->num_free_blocks > 0 &&
+		       agfl_idx < libxfs_agfl_size(mp))
 		{
-			freelist[i] = cpu_to_be32(
+			freelist[agfl_idx] = cpu_to_be32(
 					get_next_blockaddr(agno, 0, bcnt_bt));
-			i++;
+			agfl_idx++;
 		}
 		/*
 		 * now throw the rest of the blocks away and complain
@@ -2200,9 +2202,9 @@ _("Insufficient memory saving lost blocks.\n"));
 		}
 
 		agf->agf_flfirst = 0;
-		agf->agf_fllast = cpu_to_be32(i - 1);
-		agf->agf_flcount = cpu_to_be32(i);
-		rmap_store_agflcount(mp, agno, i);
+		agf->agf_fllast = cpu_to_be32(agfl_idx - 1);
+		agf->agf_flcount = cpu_to_be32(agfl_idx);
+		rmap_store_agflcount(mp, agno, agfl_idx);
 
 #ifdef XR_BLD_FREE_TRACE
 		fprintf(stderr, "writing agfl for ag %u\n", agno);

