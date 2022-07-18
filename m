Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A08CCA479
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235157AbiGRUUh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234968AbiGRUUf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:20:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15AD72CCA5
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:20:33 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHh8hE026646
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=lFFigxoVg0/7IoW7uvwD7trNiu5Jb2uweF8AW3Az49A=;
 b=jJT170ephY2eRHYtEmwocpHEjY4FDno12GaemlV0KIZdw2yldmvumTxGGTXtIK1IHgYg
 FAVpgu1Y/bN+M4VYYIXCsKx/TxF6Mg7YJwBVope4dB/1t76ERh9xmY+lpO2gFT0eeE28
 2A15ajfwZ2DkcMJMRCuS+XzuB4MUHJeBiVlR/pQrdsZ40RYbOVMm00c9vPYkXUQEVGoy
 g8ggyVtr+Iz7QahB3TONCfK6qb3/G0NRyn8wDCVMTIGGM3VztPRTFfR5GkzQGPiXFncK
 OWsFAzK8PU0WrSdDsBHbPzDiJm5ivWJI+dqGuUTvAHxULQpQ90Gw2lTdvPW+lfgQA2wG 6A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbn7a4cfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:33 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IIp4t4001290
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:31 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2sfbn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WhfHarFEihy8u9wlHxtvFl1/V6xXy2dRZybZCmgQzDRYlQd8c9AQaf7MYDBIkcPFhfvuy2vJ3bN5qT82I/oJ7pm73ochAAWVaHpPFPOL5AVc5MbPPDs8xGQ3xieC7ctBmvr/Fje2zVLLDO7auTUAWpDxHHqKMPn2g1sl3MM1oM526xt4JPI7USUaT2meFIDXoVYIVYdN0xCl8ih9/TN9zs2S2M78Gp7HZkusDwb+pDpQxFCjLXFqAmFkMKWDoqyHeI/f6DpFkmfbwPuE9YAWyvmNLIwStpMq61zLza+236cBOClUBk5rDaL9fPTHm6Ed4cR0ubC+73mKb8c8ySNEDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lFFigxoVg0/7IoW7uvwD7trNiu5Jb2uweF8AW3Az49A=;
 b=TYHN5XzWZ/0a4kbJtYtA80ACj/FFAgWL8mTyTX4WOUj4bBjxhT9Cx+8jiICMF16EjGw64ii6FwcLKHmMufIMnpImaVD/X38sPT2yswoTXPHYPxGhMunFRfHc8TQ7NJObXMzJ/uPi8CDjncuZNgF0xu5eobmvkvCxrwranILfnyuJE7PPCb/I5sqioAd4xWBNvSxGgoVNPFS2cwkJQ9m1Ev1LCV+gj0/YjpB+RF5ZYjcC6Ei0zDnoPXiW0u9GNmQKz5vDku6KSnSG3Ko5oHqXxyXZ/SeFQO06G645IyNYaYTQ4FAv81Udh4Ko62woHNYUocfwnXsZutXJadiM2X4aGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lFFigxoVg0/7IoW7uvwD7trNiu5Jb2uweF8AW3Az49A=;
 b=mh/738PDkWaO7BR7q7wE128gA4CP35YcT1uOuBwzxUCfB8UijXFwP+j0MvInxSl5UVvx4DHEZJhpQgSO3OlbP/Z+/RYmY/qoYztjUtu/fegwyQw/b7UvEmWS+VjzH9t/XjtnzGNYSEEA3pu3B2m+fpiOKd+dsVEd/JEJ1jhyNbU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS0PR10MB6128.namprd10.prod.outlook.com (2603:10b6:8:c4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.23; Mon, 18 Jul 2022 20:20:29 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 20:20:29 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 01/18] xfs: Fix multi-transaction larp replay
Date:   Mon, 18 Jul 2022 13:20:05 -0700
Message-Id: <20220718202022.6598-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718202022.6598-1-allison.henderson@oracle.com>
References: <20220718202022.6598-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b758023f-bf51-4e9d-90a3-08da68faf530
X-MS-TrafficTypeDiagnostic: DS0PR10MB6128:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yS2gPRMVPyhuShML6Wqtxtce4hUOOV1yU5MH9sQg6rkCW9CuN6HjcpZHflThQqw0NwLXIvyiNilSREUsYkqkOD6wP5C9eVSeM5TrcDMEBw8NmfguoAB7thTiTj1ekXFgYWrB1AcCl+FuaMDqebhG5hE+w0hDKkVXq5cLLqnLgRSekwZR1OZS/oHzthksqWwfqa5aggHJopPetCnAV3Y7+9PLk7eKIWHSkBsM8HLEXSN89k1JL+rwvPRnMvBf+dW7NZBhsbJJEacEaEEcOhKdzhO7eW3qzv2Zpx4mWlVIctdBM0rNyUTfjNNqzsErEmYcX0cv0b+1zAc/tw/Z4WVuRmlzAQlO3uI/FE7svVIoBHtI3wuf+hd8DHwSYOEVTEV/DGB5Eu8YdVD6eRZeO3Ne2uC2LWuBppWilNIJft4vbGk+r30K5Q0SnT/xbUkAMugwSYBLLemuU3J6rqr8LIOtxFP0dVXoRVybb5BgmM5yWrKmVPE3bvcDfSGTNogFPq0QALNWgBduD1++PysPUg3Ra5Coc/WaK2K/YBG+i9zIikhjlVJFq418XGXJkXKU5wwB2YCdzZkyEWn8k3fNZ8rvjPJd/LGeUh1igrhbsoLSAhoLNzydKnh2CAJ10MJO3BIF/QRXNt3Z0CxXZPKD0CNxM92HstnSAe2uPpraLuD3uWraasmbT2lk+7cF+2waKPYx720tHjeTo4F3bgGzQT+lJrcJLTgJciUwV7c8NfxkQ0bE9MQSp14tbLewgFCYOaOKWQnFqIhhWK9KeV0Wc4P7NWMy/4eMrANbC0TBbJR3cKI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(376002)(346002)(366004)(6506007)(52116002)(6666004)(41300700001)(6486002)(83380400001)(5660300002)(478600001)(26005)(1076003)(186003)(2906002)(2616005)(6512007)(44832011)(6916009)(316002)(66476007)(66556008)(8676002)(66946007)(8936002)(38350700002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w1QcG3O+p/gvApcUWfzHMUJG7dNyZMq7VoID1xPUV8HRU/COn+auSXd86Nw5?=
 =?us-ascii?Q?QJQdm5yMj4ZDhKwhSuFDh1GiOmWgb6IzRER+NcAMWgoQg9oKc7b61K7v0QUR?=
 =?us-ascii?Q?Ukv544u6aPGvA4SW9/8wFTu1s/M68ZrJcB3fltlBHoDKKKtdDAzBxUjvCezY?=
 =?us-ascii?Q?jkmsAXzFfwqoLVpVSWwlGfMlgWUyQ7aXiKhH+EF80/kxbH08ZqVcDnUY1BM4?=
 =?us-ascii?Q?PCIWCCpQdBNRwf9x+gu60/LvNL7j1UJXAEteX/N/X28gp5gG7LPcLRBjETk9?=
 =?us-ascii?Q?kRR/bsJdlRDZkuQGnHFLVs8J9d5FOYge+wTlYl33wsaeU9Sq9lz7z47q+KIK?=
 =?us-ascii?Q?D4Wa9RuRGUwIEqna/Ar2ctbo6b2T98X3gdCi9eDBuoGhGXjga5GDr/72QZiY?=
 =?us-ascii?Q?T/eLNAifenAR2rnVH7FCgCbVE4N5HLsLa1TTMBqctBVdnWqQvq4VNm+VkBC8?=
 =?us-ascii?Q?IbOMjXMgVkZ2Ry9fDO4Fy95RQ2owhxRRlNDh0D/7ljUbbkjCJGiKCSnh6Kai?=
 =?us-ascii?Q?tbbYPWA01C1R8ir27cgA2BNYggz374Q3S8BkRLnFPQ/rr08E20Oz9KV6pVto?=
 =?us-ascii?Q?jmqKiupNnOuoUCbtQSKw/gnR+IbL7RVxhgSQMknFhdYO3CBpy9cbvKZT290W?=
 =?us-ascii?Q?6r6MNLvACQyGV6sIRU0sLQ63KasNI9Ivfg+FwUrGOYbMTCvHNaGJ0d33Z9Xm?=
 =?us-ascii?Q?glnOEiKdDm14IpSD9tYKZkf4z/uxCME5XR9sG4Nh7z1lBY3/ehLG2la1ggTL?=
 =?us-ascii?Q?B+C6fIOCrBOQnDS/AkBTiSWQSzDqVDxui+3hd9NISENQAPT6KSNVwELKhJSe?=
 =?us-ascii?Q?Qlgkfa4wEmcJUUJcRWkwFRhT4bRND6w27WaUHos56HZeTzs2ajpp3dcitAZX?=
 =?us-ascii?Q?bn0QYbJRvYZP9Djjx1ixbWkfW1Hihsq8NVwpeu8BAdgUl1b6yOpfjdVpXDBE?=
 =?us-ascii?Q?UWAZ/pAZdE3o2GhaExoel1VFnDjz+cpWkxLvX5OYWa4LOxSBrHdXvQsCP7xA?=
 =?us-ascii?Q?IDsV2aMij5ayiexL/eTan6AyIHxt7k5zcmQeQ0scLAEYT/UEas7mTZqWRSIm?=
 =?us-ascii?Q?crpXM/exps/4OHq/H+kvBf0xo4Wdr91SSQcBjgTiOgOSHEg+CY7dKhkevoqB?=
 =?us-ascii?Q?NJcSXViwnrzNUmgM24keIUgTdXOadKiXJrK49afUqQ+EJPYQfSaS9/XYRDvN?=
 =?us-ascii?Q?qcQ9LHjniNTVA8cmJBXVyeTmS2IS+oKD7EEBo0zRGi2KNScyYzPe0goJrk4I?=
 =?us-ascii?Q?b7Dhg+O1kidtALJfZwWs3DEIrpfRgw9sbCQKoxdQPiMoQCeu6LDoZ88y3ZVl?=
 =?us-ascii?Q?Uo7vkR+qGgRwL4V1Cdd71fcTHxGxA3EvFoGkj/KwoHrWP/5hatHfygIELzON?=
 =?us-ascii?Q?oHk+plkT9OADwYRiAockDStIlk/AAZKE5fDDxjldv+haMlZl5f0ncyHq8x2n?=
 =?us-ascii?Q?aHhVimB6l9ecAZo5e0oJBhQgW6o69KfDn4EuZWt4B8MMDUVgJfse/zdxGvDf?=
 =?us-ascii?Q?2cTzoSWQ+VlbGh+cp7jzPuRp/aLQsG0IdY4fdtGOp1fTrToUPuUWQnh9RYHH?=
 =?us-ascii?Q?P4cyP+/u+BMXtTJfHsG1EN4GRXuWv5U/cnJ9Y5Xrj8Ro1S4RDPkKFUq/H3b/?=
 =?us-ascii?Q?AA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b758023f-bf51-4e9d-90a3-08da68faf530
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 20:20:29.2309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i7mwJ4VwaSIPnk3sI1VxDOceB7T+q3JU9lqwQZ5DphoMkFo/Zc87uyrpLVs/oLp1ELfYPSkZ88vBcAn68XHHJ33733RqESYD9XTx/q//nZ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180086
X-Proofpoint-ORIG-GUID: JKgIiV6Iy7cI1nbWK8Crbcj5Q9JXwdRz
X-Proofpoint-GUID: JKgIiV6Iy7cI1nbWK8Crbcj5Q9JXwdRz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Recent parent pointer testing has exposed a bug in the underlying
attr replay.  A multi transaction replay currently performs a
single step of the replay, then deferrs the rest if there is more
to do.  This causes race conditions with other attr replays that
might be recovered before the remaining deferred work has had a
chance to finish.  This can lead to interleaved set and remove
operations that may clobber the attribute fork.  Fix this by
deferring all work for any attribute operation.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_attr_item.c | 35 ++++++++---------------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 5077a7ad5646..c13d724a3e13 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -635,52 +635,33 @@ xfs_attri_item_recover(
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		if (!xfs_inode_hasattr(args->dp))
-			goto out;
+			return 0;
 		attr->xattri_dela_state = xfs_attr_init_remove_state(args);
 		break;
 	default:
 		ASSERT(0);
-		error = -EFSCORRUPTED;
-		goto out;
+		return -EFSCORRUPTED;
 	}
 
 	xfs_init_attr_trans(args, &tres, &total);
 	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
-		goto out;
+		return error;
 
 	args->trans = tp;
 	done_item = xfs_trans_get_attrd(tp, attrip);
+	args->trans->t_flags |= XFS_TRANS_HAS_INTENT_DONE;
+	set_bit(XFS_LI_DIRTY, &done_item->attrd_item.li_flags);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_xattri_finish_update(attr, done_item);
-	if (error == -EAGAIN) {
-		/*
-		 * There's more work to do, so add the intent item to this
-		 * transaction so that we can continue it later.
-		 */
-		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
-		error = xfs_defer_ops_capture_and_commit(tp, capture_list);
-		if (error)
-			goto out_unlock;
-
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_irele(ip);
-		return 0;
-	}
-	if (error) {
-		xfs_trans_cancel(tp);
-		goto out_unlock;
-	}
-
+	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
 	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
-out_unlock:
+
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
-out:
-	xfs_attr_free_item(attr);
+
 	return error;
 }
 
-- 
2.25.1

