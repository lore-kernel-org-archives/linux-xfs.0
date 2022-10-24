Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 510A7C38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiJXEyX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiJXEyR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:54:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A86B79ED1
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:54:12 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29NMxxcc018071;
        Mon, 24 Oct 2022 04:54:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=x6ojip6gE+S1Rx5E6jMOZzTms9YSjTZAJSOMDvLiSCg=;
 b=biHERew3AqOi38U09en74ye4M+ViYjKsw64hAMfz5DTTqRwObrulCIejZupGAyh4+ULI
 8EJVUpq9QJdr6kUijkW8B1DHKy87+i0iDeH80CPi8iwQecnAeaM5iN2HwxAe2TWAeXTj
 jxWUwZgE2EkdPYi52KwylL6CwUT5akOblK/YsyWsMp0PTieR5Z+Gy5/S1p09fph0QAKO
 OCxtdRdYdIMF9hIJgrarIWmuNsMHmo+BNYUi/QuM9PzaFUjT8j5UUpcQIYWdzItC0OFl
 fpxvcvBwVx7WgS35YXQ8mk3dbby7t0C1OPf50Npi5whHBPbQ3RDa/u7MXda+78P9k5gg JA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741jw5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:54:07 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O4Xllr030718;
        Mon, 24 Oct 2022 04:54:07 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y3bmrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:54:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1cATXRyd1n5pVT1OQG3a47qRbi7G0xKsHxEIO+eT7vEtQrUSxlxE4KixdDZVP18zkt2IC5YtvTNYDbE32U0R1S4aBVejt4SZVbJTSj8rTgHIAUStytXmSks/DVWE/XDOzxNWybyraXzw9xafuWzTZn06Bs8SXHDRGOV4QglC2trMTbxrokZtvgLPG4ueutxvVzvihprYDvyabNnNJzBWSBVeerv88xZs5UP5Z6DhGl+nnn1SEM6BOCoHkUuG7ya8Ky61wnJtOgDtT6cqwSeJ4PEarJgIpVI+jUZWorDIMn1PMDMxfAtShI4KG7eVCB4IGv33U3mzW5CUE+UydpNOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x6ojip6gE+S1Rx5E6jMOZzTms9YSjTZAJSOMDvLiSCg=;
 b=Bml4Kv7lMRqKHGCoKc1TSjmXT4/0XRem3B+k8Ek1LwN8aWXB5QcMwvHvFNc11qcH+YjZDhaYd3uUETUEUVV09Ibi7ZAwnnI3Xs6UuEU+s8Niw8rRjza/Aq3n4wxB5rcReK6vaMbtqhh/aKF2HiAZxkZJtwmEDQJqBH96vilE4lPMjMRWqCOC8KppoCZAWARGJYZugl/Yr15xnetDmYU8xO2oshAJdstWNP4UeLlPf8qcOUG27zqWiWnPGQsPfd7N8ZV1hKgAfP1lpJK77SywRZTafsOgXO3LLYsZ03hntn2lNIx86c7wi3ZI1omSuKi0emPutscvp6vL4rNiNVD6YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6ojip6gE+S1Rx5E6jMOZzTms9YSjTZAJSOMDvLiSCg=;
 b=LBAvaV3j3Z3iynj12yMxxglDMTWHaR1a8Wc7RbZ8wduhUKZC8vVkHQAafpwiCYoYNELABRBrcvcLRpqS02INqAx6THn0LyUnc60Ps7ti6Vtmtx9qRFsEaGdQAjNo3CzPJSK7AjDLtpiAfY847ZVpU2+fDrzeVudY6U8HjtwXqe0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:54:05 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:54:05 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 06/26] xfs: fix buffer corruption reporting when xfs_dir3_free_header_check fails
Date:   Mon, 24 Oct 2022 10:22:54 +0530
Message-Id: <20221024045314.110453-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0110.jpnprd01.prod.outlook.com
 (2603:1096:404:2a::26) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bc47f19-7979-4e73-2910-08dab57bc704
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kOwYxlC1tSO3aeGhqvedx84lYH/zsmdKkCSlz8+E4oheZnnwx4/fwNKF2bmR3e0AnalDPaYYV2wlbKfqW0daGIqXctNMkMGN86EIoZtb6t6BGjbbfec/pR9+8gTXQPkK80K9ORvH6ERO4zfN04CYnmc5e6rmgDOcAQxvw6uuzycvx7Be1JWJ62W0iYC4n8HSX8aMiHDXUxrKuGcXkgH7/ZP6UQESeI6IEmmM2Ccs7S+aVu3/pjcZCZwtKyB9e2SNd5t/bjr6AgqCt5c6NsZTT/WGB6RA/lIz1nDXj3zvRUVgMrMafCVopz9aWkqb4GCN0BHCybDGRnXuhkpXUuNYi5YcgCCM1/k3o0rDlYlFdwVsjzeRIuId1afHKqUmRDj/Cyma0KKUlx33Gmi8Aw1GsoaP3lbpADcMmKaZmcRHAhbZk5P0WywUSNugJ4d3VCJNml5n2i2Ikw8eLljqAW8SuPwagSktDYlazekZlXc/PxYeUicRt719oIkN5wuK3XznAp5poBMO1LGL2GgWamIiJjnO/pRCStXIWfJt5xuwr1xbLFjGg595/bewmCp+JR+F3y+WKSFO/s3oCxsG7dwQDKsevFYkOnl9iE/VPdVIkqTxmqh6r2KBlMe+FqspfgIkdGY4RdjcLYli7Vst7FFp9AK4FGtePnr34wXGcQjOL231yFKaUDg5yvjeFrveP03i0yPoZK3X5ayG/5Hw4UBbCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(6916009)(83380400001)(2906002)(5660300002)(6512007)(26005)(6486002)(4326008)(8676002)(8936002)(86362001)(66556008)(66946007)(36756003)(66476007)(2616005)(316002)(1076003)(186003)(478600001)(38100700002)(6506007)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0G9hJt+9c9evtamchQDbs2qEf+Dg53c/31YN6xfXKC1W2Xa5/o5jOJ12TTyr?=
 =?us-ascii?Q?lRUz1YILnXIUq0uAb6/Nh8hWwF7yqX3S9mBtesYaOPdu1MVWvlgTdagA+1Dp?=
 =?us-ascii?Q?HzO0kfdKE7iKpyBBd2jobT1nULqSiKeJyrRmPr8CQfShQA10EB3cN4759LuB?=
 =?us-ascii?Q?HDsqlRfK0mfoXoRD34OLRF4oA+jFUf+KGOqv96o6ACNDpOjR0bVvTIfJifuj?=
 =?us-ascii?Q?iNPOdnP4a+SeN8k2otoV0h+GaAwD3VI0n+j+j9ZhdFu09fO2OPNgKUJMK7i+?=
 =?us-ascii?Q?KhYYpUJL3CcCpu4o0y1EARcXRwIMmps2s08+bIMaI2FTSbTlhCDsPPzuqY9M?=
 =?us-ascii?Q?sChzlBngZmy9d5/cNv8PPmQNeTmnvp/8zpRfaef47EESSfXA3T8tPdXc5uLV?=
 =?us-ascii?Q?bFRKXpRaXwD19Y4VRFJZ/IkonniM8TWjnNr+2p70L5q7DqCgRefFHcdy9fhb?=
 =?us-ascii?Q?N73zg65qH1E3Kz7dP2tdY7h4gNZbitx2Q6D3rV66DsHjzMZfHherW+F78D/9?=
 =?us-ascii?Q?dvOjQZeZyCmlVix7V9o1iut5Wee94TeCbuSm4rWBMm5IH77bvM1npzZ2wa8E?=
 =?us-ascii?Q?TDwBMQWnakDcPV6nltnOsez1Bh6fetfdAWcEQpOYqsZ0B8wVX0ny008/uZK2?=
 =?us-ascii?Q?B3OI2drpSSswiWrH+la8oGSjO7pRvjc/oVdIbGqALxTZ06eNv3UD0BPaK40A?=
 =?us-ascii?Q?POAUzea0O7g5/VFtzdLO7vyWzvAp9Xv3+wgy58rP5WGUiFvE8gJ8xe8/Uky6?=
 =?us-ascii?Q?wq5ugCcTZ3GQZyy0b89jR4oDI9+ZMRzRBsRU0dWl6wzQUpEG1qBjkk0WgUpG?=
 =?us-ascii?Q?nAXNXCqNuixZOa/qWqOd7PEWHHsa9oqQDv5zcHpNg21wIgvnybwZbxnTVnD4?=
 =?us-ascii?Q?VxDCsOteHSUrbLK/iGjKC4srXlR7nfJDjwrEq1vjdzOGXLHVHDGo0xQzc/zJ?=
 =?us-ascii?Q?uz16mpJgSid4ZZB0d6ixPV25H4DYMQj87IziOO9nl56GjA5huxdjOhc7RVWH?=
 =?us-ascii?Q?C6HZWhsGN4LijRb2CQ8eCvO9KerevNEdOvvHzxSghDmGTIo3itW9oclhbjcT?=
 =?us-ascii?Q?xE1F50lvwoXAW7S2DgqGDDdq4jqtMvWXuLxD09dvMrg87iLmyU8dgpB1Xy5c?=
 =?us-ascii?Q?w99b7YitKdSmvE1VN/HAjwTsJVHbi5YhOGQAP+VYGn4eKHAXOPg/4JcCmg5n?=
 =?us-ascii?Q?2Z6M4tTNe6TMummojSpyjwTzIfkA04FOgn6UjoaqoWljtfDzJuGGdTgyLbdQ?=
 =?us-ascii?Q?ZPbeBJmduF5v0YoifonKf8lJhh65rgmWzaQxXgbcb51u2D/7qCitGzLTn6TF?=
 =?us-ascii?Q?fDAalqMytmOfQUcyxqw8roqAN2g43/pwnMIgsax2IOamJnba8xbZeZ02yD+M?=
 =?us-ascii?Q?R02yXhpNq3UdzfmS4awHUZmAAO2kZ/wIvYuhBVitF4JazvXalXJ9b9ivtV5O?=
 =?us-ascii?Q?nwEMGCDPirqykIg0YKCmuUjz1OAbXV+402JeJMRVpHfP04j1XHlfChLYBTnA?=
 =?us-ascii?Q?2pTbUfRzKZ6FYEZ9iQJpT21ZoDgYCAXUULGF/ijL7f1TEzpHOE8jYthD5LG/?=
 =?us-ascii?Q?rfMieMqaVwuTHvYhV0omLiiejIymebvWxiHhlMfh6JIMxSeiDBdc4CWG208a?=
 =?us-ascii?Q?Rw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bc47f19-7979-4e73-2910-08dab57bc704
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:54:05.3077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K9h3REpW+KIb8NlRuiYzJd9TJzVw9Z18tjBGkF5WdmvxGL+ncgLlbMWvJACvD5hKoQTqhl5gJmYr35lsMuMatg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240031
X-Proofpoint-GUID: 7XAWMoF4T0A4F1h4jszNAHFN6iDK1Sbb
X-Proofpoint-ORIG-GUID: 7XAWMoF4T0A4F1h4jszNAHFN6iDK1Sbb
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit ce99494c9699df58b31d0a839e957f86cd58c755 upstream.

xfs_verifier_error is supposed to be called on a corrupt metadata buffer
from within a buffer verifier function, whereas xfs_buf_mark_corrupt
is the function to be called when a piece of code has read a buffer and
catches something that a read verifier cannot.  The first function sets
b_error anticipating that the low level buffer handling code will see
the nonzero b_error and clear XBF_DONE on the buffer, whereas the second
function does not.

Since xfs_dir3_free_header_check examines fields in the dir free block
header that require more context than can be provided to read verifiers,
we must call xfs_buf_mark_corrupt when it finds a problem.

Switching the calls has a secondary effect that we no longer corrupt the
buffer state by setting b_error and leaving XBF_DONE set.  When /that/
happens, we'll trip over various state assertions (most commonly the
b_error check in xfs_buf_reverify) on a subsequent attempt to read the
buffer.

Fixes: bc1a09b8e334bf5f ("xfs: refactor verifier callers to print address of failing check")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 1c8a12f229b5..c8c3c3af539f 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -208,7 +208,7 @@ __xfs_dir3_free_read(
 	/* Check things that we can't do in the verifier. */
 	fa = xfs_dir3_free_header_check(dp, fbno, *bpp);
 	if (fa) {
-		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
+		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
 		*bpp = NULL;
 		return -EFSCORRUPTED;
-- 
2.35.1

