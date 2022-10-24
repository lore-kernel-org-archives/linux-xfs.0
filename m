Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC12C3A59D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 05:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiJXFLL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 01:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiJXFLJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 01:11:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4CF69F75
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 22:11:09 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O2vB38026245;
        Mon, 24 Oct 2022 05:11:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=YFEeYAodylVE99pgaQ3CHejYnkEct4/kPgtrAOP0j3w=;
 b=PI1J5qdSOT2nFkxvFlyjOwOAz+J6EOnwL8wXTr/1Pl9cTf9jZHpMM1RichbPoJ8vsgf0
 Nh8D8IEJGWfMcXS2hRPIIboQkiL0sVGGOwJhH4mw93wUUDMPTciTDQ7TEqF2l13U42iL
 peJl3WTk1i7bjtgSRjlIRPN7x5HUfV7q+NatZkqsy9HmgTmPPVj3iLUayqv2doTtS4yY
 23Z9oIgnKYQMn9FxZwQ0F1QnsQuezjwK9U7ZQOAqAkQjv2Trwh7HEC/S8qcU+tXG8ncH
 ePdSBNgtkbtf7rODUOxJF8M3GE36LIBn7q56QIgyt4aJ3MvEGMMeUUBeqCXVLFHkzwNJ kA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc6xdtnfh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 05:11:01 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O49Ru6003633;
        Mon, 24 Oct 2022 04:56:06 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y9bpmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:56:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPWqzwWzoOaLH2Zg6uqGp3q8M1kXSVSVturDLLrGm9odMOgPOsh3ER1foNnj1UzjQTItF2mOBGVHQADMMpKY1whJH1M8No8AB7u6LQIpJ9/Cj94JIf58se7Q1gzNzdoYrCV3sZI8SnMLVvRWGsiPpeWCABT3c79PSrXVQ+c9+VFLxLlqNzkNjwg1bE1lv/3u2YzJN14DU0bnB+OIx6HijtBKloBOcrsXvZ6g7eC2N4F+/lFMiFpbjlSnuIDUgqC1NWCtq0oZzW/Gq97zpGEakiQ4DIRn6iXjLYgbK6g/ADsOzIZBdOBpqSI5VaKC6JElC9EviVD3OXUYe4neKdqOJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YFEeYAodylVE99pgaQ3CHejYnkEct4/kPgtrAOP0j3w=;
 b=GE1wAxzHwFtna0whaq7sMyaXRSa5wR271mjjtQbt034TArQ3ZqvtE+JkL2+K0Y5aAv+6xmhvD5ptOoki89kedxEN9uEHpViMVTMdyCUlB72+8A3rUQPh73Uz8gbu4FbPLuqmY3/H6/JmD7452Ko4dOXSe8bADlCgN6uiunPHLa4IsdQIUy+7N2oUhKDfRoshZi4dNungSuJeuJvTua42jKwTTV1dm66oX83Exss7ybBg4VnmyRRsRWpZQAcnaYuSL54Ja2g0vf0uFkB0YqFd24oZdrw+i8pMAOe0/C1Ju8hxcwrb6mieY12P/C52eHUlEBnW/Ovx4aBjgeWX9GFzKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YFEeYAodylVE99pgaQ3CHejYnkEct4/kPgtrAOP0j3w=;
 b=yx+dwGj38MWz8TXbPsB7wR56HgwEJcK6E9rhQREdo326kWuoLsIMi5sgev0srbSjKgGbD+4nf3AcOHD4nDE9hxCxlFJZi1s3+um3WZKD7zCJ1puEkuVpW7qCdG3ERfn2kdCRT5j3DBEPoIc2oFS7XEgLOg+woX+ffdHgxhNy8+4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB4906.namprd10.prod.outlook.com (2603:10b6:610:c6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:56:05 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:56:05 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 22/26] xfs: trylock underlying buffer on dquot flush
Date:   Mon, 24 Oct 2022 10:23:10 +0530
Message-Id: <20221024045314.110453-23-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0011.apcprd04.prod.outlook.com
 (2603:1096:4:197::10) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB4906:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ac12495-d3de-471b-d4fa-08dab57c0e66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +dCdw0udfv825JQNnxRegpcb5qZBGzwrQHjCCdAEnl9bWviY2LNh8CseXpSOrADktdCUuANQnqPmhSyTMCXkD/uvpiN+53mzXap6hp2prM1+yjnNbMf3JUoZ4rZ6O5LEE19O4AdNk+WIBSw06aCy4OCpEw1J++szmO5iog5dxV0AZLOLETQuCHYiu3tCuKMnVsDIL1pnbNloliXjf5moi/9cxwkoPBKvTTDm5X+BUbluRg2/x6FqZnn9Plj/iCK76YMEJ8Mf+HUBf9UeWJcxq1y0gA50TqUfiz8cGpse7yAKF4O2RWfKru8x81Trveta3JzgHcfgTmv8Nari1uNaSvcb1I1Z+bSJgTaouU7ynu7n2BWtfhPMuMwxaD8KycuFrbYFhuzZlxOSDFyP0TRNzGeJ3MY26ohf8Eh3KnW20XxL33H3lvTMy02aP/ye0YI6OehpxHQMT0kyOWNnFOmeUHG1+HJ+nbpWSBjmVwgL3lZ5KjiW25HKtq3CPfeAMBgheqrJUcP+Bzx2MNXy+l9xbvKgf2z9+oAhWibFwPr2p0hCg5otUTmPS0ljwsMcrqwpQiUy2tr7k5+TNCa2lnqav6O6Q3VeMRXkQTVvvmaLwzD7/CItd0+oH3poZdlJ4v/GDKrj40s1VzPNxVGvjgijhhb/NmI4vhBP2DbkauCIDnQAVumu/yIBlnJAzocqSyznvXQPxiy+w4s8mEr8VYcPzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199015)(2616005)(1076003)(66556008)(66946007)(66476007)(5660300002)(6506007)(186003)(6666004)(83380400001)(36756003)(6486002)(4326008)(478600001)(8676002)(38100700002)(86362001)(41300700001)(8936002)(6916009)(2906002)(26005)(6512007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ScK3o4GwlbTjzAVKoMleridVv3P9e5oq2Zp2qMgVOPmDK8vIyfotzFttbyMD?=
 =?us-ascii?Q?ZaYClsNU9gNmQhHwoXnQaZKjrihL16Iy/tN1xL2RO0Q7QhGWER1YJIe9CTfU?=
 =?us-ascii?Q?CyOlyPfIbwnyn3dfW22etqmE98haiXbuhV94IJn7dWWEvOO1W1JxNqLDC47q?=
 =?us-ascii?Q?7fcQy9kDydrabphlLtpjv4BOAtkTinpcNuZepnA5NOFa1ZWAuq8W7UpwDLuq?=
 =?us-ascii?Q?oCfbJjZO2coiky7/kV623qSiafneNNcb7/efo3a4kDNGxril/askWDTnNh3t?=
 =?us-ascii?Q?wBVXWlE8AzGZZ8pF3rlYfd3dbO8D2nOs9rbAKJwQAkEUwT0Vm90u6UOZxDfC?=
 =?us-ascii?Q?zv/PBTstb+ZXgwaS0KZnS0Bai2zawYQGGi5MFbVL3jm1Y73dBr8KBkugZ3kO?=
 =?us-ascii?Q?sb2iYwY56N75Y3+hCWfw3HvW4BSwlblVBLpXQqCqg8BtQlnLL4/RPP5HAKJL?=
 =?us-ascii?Q?LGNfFaIeH4nrYEzVr4uGVzo2Rlg1cIMP4ewV5NGS5VyLmw6+2JIQKAuKRCvL?=
 =?us-ascii?Q?VBMB3fyHtAIOiQUYkZVk/hO5WKpUm2DQMblOMoLn6Ui/CWQKr4dcxDl6MJle?=
 =?us-ascii?Q?XvG6AzccQUZ5y7MFbzq3QL33RybQdWK3QmZCgvelosmp36PS4dUThDZRf7tT?=
 =?us-ascii?Q?mandtiA+gsVr1tmZmMqR9YXvIgfuX3Cnhhu0O2KO3fe/DHnF9/+4cBMwitNL?=
 =?us-ascii?Q?eXkcIpPRrfwqioFZaB+wCgYuYDw6XIlCEXawGCtYun/B6EdE1xzVLQUrBPZu?=
 =?us-ascii?Q?nAxFOsMeIOSEXxmC+FMhnYCyiiP7xXaUKlJbll4MWl6NA+JxQ9Dkz3Qpy+BQ?=
 =?us-ascii?Q?C9TcSKZgxFHqgiasnyky/EhT3ViLn1/3IRFiyz0QTfHvdzouE4IAe0L4VwU0?=
 =?us-ascii?Q?I9sTOIyYsrKRTfrDcNJeLmvvLt2jzY/2QKl0uuwhBIkFkwqOOBHyeqSn33WF?=
 =?us-ascii?Q?R3Hic/VO5araujDwduNiSNvSpCT85uCWMd8uhljr4yokDexiBS6jrImrRDIU?=
 =?us-ascii?Q?IR2caubNjvo4lc14ARN9khuVg+B/4jaT7E9lrlHLFa92sSz9KD+gGK19AOP8?=
 =?us-ascii?Q?ktKQ5bklJRYxsWrut1RPGsydq49VHPBAjLEVEvwAfLafQm20WtB7IRTcjvgV?=
 =?us-ascii?Q?Xb8mvkbCu9MTOWjjBmSJgfcCE+SDR247w8IBKQ0hiHpLKxyHWNUzXyrjRkcc?=
 =?us-ascii?Q?bumbwqp3S8vMg87KWAH4uP0IqgHwhUyHdaYTlkCkGecGrjgj69+6lct8V4gO?=
 =?us-ascii?Q?T767gQiaZcAoKByqSTjga+a+oSsk8fVCNN6xwRupMT0jLC3G39oL44/FflIY?=
 =?us-ascii?Q?womgGxN3ePH/DclI1D0+PGFEqU/WgGtR9PQw1jYm/9/ahHm8ODIj56/8nZaH?=
 =?us-ascii?Q?HYISCmnyqXGi40T4Br7sTDL+IBIShQQdh5T+cCY7s5pNdPK5OtgfuhIR3d4J?=
 =?us-ascii?Q?oOjeal/NnxgwfFjIrzEhH/UIAIp/sYFdbTv0rWtvo0r9xa2z3HbqMcpNZXXl?=
 =?us-ascii?Q?ocY7959IpmExbYKSKWvxgyQhEpalZ2vf60USZvISihJl9+TcfqmgZweJqgrl?=
 =?us-ascii?Q?IHdJIyB4/3WWnWVhBt6N1QmBZVBtunJnosWsyW4ExGAifEXPL5jYYCRLONcm?=
 =?us-ascii?Q?7w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac12495-d3de-471b-d4fa-08dab57c0e66
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:56:05.1351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RchPt6E5R3aG/8TUb3JjaXRvJIvavtOohH4uKH5l2DxoUqmXttdcvZmkrsAYCkzLxXqKp5r1FslFjT2qdDucVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4906
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240031
X-Proofpoint-GUID: KNf_WGRVbboYMrsWdMoo0cM6z333uSgD
X-Proofpoint-ORIG-GUID: KNf_WGRVbboYMrsWdMoo0cM6z333uSgD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 8d3d7e2b35ea7d91d6e085c93b5efecfb0fba307 upstream.

A dquot flush currently blocks on the buffer lock for the underlying
dquot buffer. In turn, this causes xfsaild to block rather than
continue processing other items in the meantime. Update
xfs_qm_dqflush() to trylock the buffer, similar to how inode buffers
are handled, and return -EAGAIN if the lock fails. Fix up any
callers that don't currently handle the error properly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_dquot.c      |  6 +++---
 fs/xfs/xfs_dquot_item.c |  3 ++-
 fs/xfs/xfs_qm.c         | 14 +++++++++-----
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 55c73f012762..9596b86e7de9 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1105,8 +1105,8 @@ xfs_qm_dqflush(
 	 * Get the buffer containing the on-disk dquot
 	 */
 	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
-				   mp->m_quotainfo->qi_dqchunklen, 0, &bp,
-				   &xfs_dquot_buf_ops);
+				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
+				   &bp, &xfs_dquot_buf_ops);
 	if (error)
 		goto out_unlock;
 
@@ -1176,7 +1176,7 @@ xfs_qm_dqflush(
 
 out_unlock:
 	xfs_dqfunlock(dqp);
-	return -EIO;
+	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index cf65e2e43c6e..baad1748d0d1 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -189,7 +189,8 @@ xfs_qm_dquot_logitem_push(
 		if (!xfs_buf_delwri_queue(bp, buffer_list))
 			rval = XFS_ITEM_FLUSHING;
 		xfs_buf_relse(bp);
-	}
+	} else if (error == -EAGAIN)
+		rval = XFS_ITEM_LOCKED;
 
 	spin_lock(&lip->li_ailp->ail_lock);
 out_unlock:
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index fe93e044d81b..ef2faee96909 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -121,12 +121,11 @@ xfs_qm_dqpurge(
 {
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
+	int			error = -EAGAIN;
 
 	xfs_dqlock(dqp);
-	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
-		xfs_dqunlock(dqp);
-		return -EAGAIN;
-	}
+	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0)
+		goto out_unlock;
 
 	dqp->dq_flags |= XFS_DQ_FREEING;
 
@@ -139,7 +138,6 @@ xfs_qm_dqpurge(
 	 */
 	if (XFS_DQ_IS_DIRTY(dqp)) {
 		struct xfs_buf	*bp = NULL;
-		int		error;
 
 		/*
 		 * We don't care about getting disk errors here. We need
@@ -149,6 +147,8 @@ xfs_qm_dqpurge(
 		if (!error) {
 			error = xfs_bwrite(bp);
 			xfs_buf_relse(bp);
+		} else if (error == -EAGAIN) {
+			goto out_unlock;
 		}
 		xfs_dqflock(dqp);
 	}
@@ -174,6 +174,10 @@ xfs_qm_dqpurge(
 
 	xfs_qm_dqdestroy(dqp);
 	return 0;
+
+out_unlock:
+	xfs_dqunlock(dqp);
+	return error;
 }
 
 /*
-- 
2.35.1

