Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CF45C43334
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jul 2022 23:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbiGEXNS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 19:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbiGEXNQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 19:13:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30861BEA1
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 16:13:13 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265Kx1U2028599
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jul 2022 23:13:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=zyReXrNbO1+syHgtDcM5GFuAma/kL1yM6mKmtOcqkEY=;
 b=ldFu1rOQVhfBQqoltM4E6wOrekwlAJy0/wIYHuYr9CgDxUbqSTTuquD3shK0cyxf7R/7
 cFsUGucYU7B5YLDDWi3IYIAHOuG4DhJ3EgmHWzPWPpA7M/UOFBsl3JSqHvIihJDEG0ZL
 t701J3IQG87U+WUQWiUndmYkrd6ffpFVwagiBUpdPqIcIqCLHZ+ceQgwCXQKbIv0JqhF
 NETTeZxazVTVco+9WQb74ggG9oW9B/ZRXAt2RfvEoIrY4ABjIPPKpazeMhO4PDqawM6m
 Xhw5XkYLHzRhNotxasu6R7LqSuWsN/t/Y9/d9dUEqAXmEEkl5t5jpF2zrDFplBV/2Tki Uw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubygemn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jul 2022 23:13:13 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 265MvHuN027118
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jul 2022 23:13:11 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h4ud5bw4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jul 2022 23:13:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/6gpgkklaOmCcGmKjTPhb5EQNrSsxQRIwcNfFEGuFa1Uaq64c0mkwypgWyq4+/5RLXet6DdoO4Gvwyd0f+9kbMzsHM0j/79qr759Jvu+vKkUSN23IZxKx0VNy05IFTWIC+D9Ubjn1yiQIyMbu/JkmTdXSjd5s7yEDhJEtFzg5X5/zryHAKMkIZXSozDJBsaHucncOc41ssgOUpM/JoGui6xcKx2/YfCpQ1FCkbDDZxmOaEbLyUKbrribLJakO1JLUANhEW/1fwvF+4Fn6h4iRxi7u3x4gFUyD8/dZlnvSTkqLG1Yt7RqgIN1mt8fXWdHy2xrSSYIWp0u+3J/fOBNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zyReXrNbO1+syHgtDcM5GFuAma/kL1yM6mKmtOcqkEY=;
 b=O1oE4fZTnjy9n5H5yjUJddYHHex3ORgBBI0My6oH10aoFLLGoFxiU9BD0RPHKepgmt5nSKbbb2yDw2qpwoCJTz4Hskq7c/aQoA1XCSqQcY7TkxY0GZgXNuIy2SbsFa7Llkhx8/4svGqSwGWkeg5b7waf697IQWj1qdTE00gYrr4ht2zj/o6LdBDxTS8OJxn5lOa8ITXC8z3zH5Hvbd5rE8q/wXHd6nX6OKRdVrf2kVidK3xYTDqEmELx9FqmwCKAvtT1/9l88u4N0ikK5Xwk2YLGgKd1w9TSSNLNy6fyzYGC0hyu0tTvYLNsfd4aarIsAs+4ysu+8lBdnn4LU1JaQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zyReXrNbO1+syHgtDcM5GFuAma/kL1yM6mKmtOcqkEY=;
 b=Iw2/qf9wDmt4+XkeLIQ5X4U85V+vKb8c8dzdk9RFd1KGdlIaQnubP0FzPIxbXgVsw9RlQwX1Kxdtz0OKgdrjQsYZQlcHitWAbvf/v3WM+goS8LY0xtOEtYU4wrMCEa9eSi02p5dK9uXM6sux3r+PEsyx8WObaO8JPXSGc41Ir6c=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BL0PR10MB2977.namprd10.prod.outlook.com (2603:10b6:208:31::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Tue, 5 Jul
 2022 23:13:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%8]) with mapi id 15.20.5395.022; Tue, 5 Jul 2022
 23:13:07 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH 1/1] xfs: Fix multi-transaction larp replay
Date:   Tue,  5 Jul 2022 16:13:01 -0700
Message-Id: <20220705231301.165785-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::26) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f42eca90-e80b-4ad0-8c2f-08da5edbebc4
X-MS-TrafficTypeDiagnostic: BL0PR10MB2977:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FCYujPG0k06cdbNF2Cb8tF+7NELpB3rBVmBYfYRXMA/D5E7HWrnYmNDHpvcLWSPvx6xePKtQCySnkRiJwDCglR6cHTPmtofq41VcRTfWDq4Jhr/bxWcGRFPVal45j0iNiWry8uRnLDUHgX6etin/viZZ73b6tOp6+Rds3Fnc6XSwWrJDt4oPjqBMskAljKzxj04XbKMo7SNdThyrHTRlGfLSSelPolPnxK7NpebWPUs/BnXBqGwWv6O7kztLsDySwzZipZ/W5F/cUaWT4SGocW29lhwPHlXIW1TdfqWPA0bUdjgW1IIKhC0Nza54XJ6eDd5usFH1wKvrz9k4U5qELj91b6VaYb+Wgn8DyLMv0gbhDHkaxT4S7qa70XoeRcujJbJtS9PaqUBGZbjCSDDRuF0qXSXqt1z3rOPGceVjZfpTs2uBMT3JC6FfjFInat0S8/I4jKd/Y8aGJvys5cRvTmtJziUZpp0ayRJkxQjl3zQKOPzD4W/Z32qcN+Y3B5C0UJe2BdT2G2pgej8p0xtD/2ik5ihpCQkVNZUoQq4Uw4EqhQHGW/GV49VZmeFp5O7evBkPMf78RW3KwTyVtayCtQFjIjett1Wu8+urgxGPj863hGHwf/7bjI8jL+XIiQUqAYl8EQvIr1Iwirphg1zWTdft80Nxk+sRAHBTlrz8fIGqZkna2ROOkGfZCXEYKHbMUrlWBQaf4ZPOQGZseXjMLczeXAFwkRFmnSqfHV5/ZeIScNiwUx5CAEUUkChpe4DHJq+vQUcjKr3ChKQLhKqgXzm7SwdUqObMMoakPCzqyyqOQBlvBqmc9swmylQnVzeX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(346002)(39860400002)(396003)(376002)(38350700002)(38100700002)(66946007)(66476007)(5660300002)(8676002)(66556008)(316002)(86362001)(6916009)(26005)(1076003)(2906002)(2616005)(36756003)(6486002)(41300700001)(6666004)(478600001)(8936002)(6506007)(186003)(44832011)(52116002)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YMui7tTwPdHq8L94XCMEfUsndwbruz4SAz77dlilqsqrSl4NiX7BPHL4D4mJ?=
 =?us-ascii?Q?UECUHnraIoBVQIya+9+hqiReOWG+TJJCrlGONsUuhNKcABh2UH+a5oiK0rMb?=
 =?us-ascii?Q?PGlvv/LMGkE/GSy0vNBcd33OX/h0eBd93vV64uzsaIl5TfGbldmOMi2TNNFz?=
 =?us-ascii?Q?5DfmuUNyivVA7SqBs6gm64/ahXKUqCw8kVJBnaQU1lTi/chlN32CRfciJdL4?=
 =?us-ascii?Q?7CrRWSXsJMZUCjCxP4TXum+/V4v7vFOnyc262JVvCV4xylxYL81qdgjYEd8R?=
 =?us-ascii?Q?e7PvPjWrhRoajKP6KJJr7SYXBP8XTeI19MPdpi/j1G+Z6pOoIg69bSK9s1rD?=
 =?us-ascii?Q?nPMw9cUk4AJT1NqT7VJ9pwvCzoAPE2JmHgcdtE46wGwPrX9kHmLw3qKOwvL+?=
 =?us-ascii?Q?2Nkuc/aZLS951TVBKpms0N7ZtXlsV6hlWv0FhRa0hdTqeaVJeR6GWEkVPPGJ?=
 =?us-ascii?Q?Lrw3QLYd6f7E58AIu/iRvBWCxXjfTist7eb4ID0KczS6jR8QRYGGBxvcdJ+H?=
 =?us-ascii?Q?0qbOjmhvE8A/TpotksDI1Np+52/f5EJfVKre5uTyxj1NqxAk13ihwmiSAwVg?=
 =?us-ascii?Q?z211/ihPcbN+b45d69ftI/Ld4XpMqdyQTKNhT7Qm48pns3jWk+jMzBkcJ0lZ?=
 =?us-ascii?Q?Bs7kMa6KMeIrOnUY4OqyYtGrf7Rmo//zwQUPF3x4i2aWUXUN2xOrSfO6cFp1?=
 =?us-ascii?Q?btEO4lncGiwaHKdXRVdzuvxGxAs2lWPX2c7TThehfp0FSHdW1jZauOAOPd6v?=
 =?us-ascii?Q?Zn7zTZCDt8sRDDYe+cvAquZik7/gDddezQyA+hVUC9tsh58kV80TPPb3kW+M?=
 =?us-ascii?Q?Zc3F36WH8g6512TyNFmxIhqIRxEY3GfGpTCLr1J39FYRYyz7B9Ir3MbNYz6k?=
 =?us-ascii?Q?h0MMXNIgx7bhGuJL69bAwQoPJgQAnCYtFDKfBv7TFtGGfSYsLLWCW8xnuHIY?=
 =?us-ascii?Q?y4LNHQoW2PGjF0Xy310Ubm8dIDcp+tG+e6Ncx3HhrMVVirv3WJDmrTHInROr?=
 =?us-ascii?Q?44/umDBvdRlgwhbzEGIuRYU2UXcKlUJMjVQys41+7MBqPE0frUaOOm6PTt8R?=
 =?us-ascii?Q?cEdnjpqvtR+7dkC6gJQa/ycfNkOnQWkq5s9r+Nz9BXRK0KD/ik9W7FZpz5wI?=
 =?us-ascii?Q?hjxC7oiyhxWxTiJdDzipt5N9xbiDT/zQ7ErsyIdxU0+Saq4JjEqs7C+uD066?=
 =?us-ascii?Q?3pxu6mx64IH8CHPSl1mSs0DeR/UfnEGioXeekOsa4B2xmnqD4co2qReXaxzF?=
 =?us-ascii?Q?I2FXU9UHREA73PpRpEjaswQe5ShjDy9F0oy0vT3jen/ZWVkhNNCVSuVyYYIX?=
 =?us-ascii?Q?v5AXw7tBRtoJxS6ing3i5RjAH0+DljGZ0IxIIk4oVADz1AR0c3ZUCtkW/4wY?=
 =?us-ascii?Q?ArIYshlym8raQH9O3SUKJb40wPMBoYxZg22XpOnIDtfiKtpCL6rO4CvvO0xD?=
 =?us-ascii?Q?xzB17Sf70OpoeIjgOnLUOZjf9z5pm6PaBqX4D/3Vq5z8zL0WTrgeGWylA2nK?=
 =?us-ascii?Q?X+0C6uE85IFxj+au/nzC79XYs/qt+dvO5whYCSMwhiAuLAy3nooOshQrEY7X?=
 =?us-ascii?Q?tInAUBUH5E+p9656nN3wYW98zFhKKUM/92+sO5q2CZK6u8BM01/7zle4Jpy3?=
 =?us-ascii?Q?bA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f42eca90-e80b-4ad0-8c2f-08da5edbebc4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 23:13:07.4140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jtGW6jP5z15pjtnFWPJYJj6/Zb4g1achCKJ0rl5eLVCJoTiAp8422eI5gEuoGcAKarME2YWUBE2gZiObmpEj3Ipipli9lLvsK+Iwd6xaias=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2977
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-05_18:2022-06-28,2022-07-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207050099
X-Proofpoint-GUID: 9Q3huTJ2DecryvIEr25hdBhbAPBVKEWR
X-Proofpoint-ORIG-GUID: 9Q3huTJ2DecryvIEr25hdBhbAPBVKEWR
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

This patch is meant to be a POC for one possible solution to this
bug

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

