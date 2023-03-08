Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DAE3C64EC4
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjCHWjJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjCHWjH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:39:07 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564DA5ADF9
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:39:04 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328Jwg2J021992
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:39:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=kmZSEmx36yTqtiETZ4vr8FH1l75IcseSvObnLOyOdyk=;
 b=GJynIcVJ1+NMxJnfAYPUinvciD0N3QRm66DRu0pKgjp63kR8W2rjx95TRYVGPnDHfFJU
 gW+lGPZ9gHI2AIux+ppMzat5D3ntm5lOV+dc/43beW621uDa2XTO084WdpECRq+naDJY
 uLE1kMQ5H3obbiOYbdhaOcyd7xbBg/7+9qxH+m/2qFljJgpIKNbBZKmfNfm4rT1JXAVO
 OJS3MV45DYahV6tha3T/+WueYSSDziHX1j0wk7plqTx4efdFY6496G7Tc4y7IZiyEKAA
 mAt3a/6AMMa3tgOG43e1lWXTV6jXLvPhH1shzW3tiVtcebM+Pfn0Xw+PnT5ZEpbdU9FB nw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4168se15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:39:03 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328M0gkk020914
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:52 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fu8my98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTYUpCsBQf/z1XyjPJCl0hHicjN1s+laqyNnXv1oPAzZrsDqe3PQzZD/vUiCOQOrpC5O7gWyEIKi36r3+7csfGD2fjMCFkI22xG6YRWAKz3c0O9PgMFKnn3UwqyPpxKuz6ycenJBXHg1gYJJkVh39BuJEYksR/rnxjyS+LwknZJrO1pQkPkr8uzKunFGnmGwK18vNSmVY6QPwJbmtRpMFaRU/qWcicj8/nItvPhMLsGeQ4GQoq7UAryytL3nW9Sp8EQ6P3UknDAzIxFO1MXCb3USYBUDUbFzJSuTx+HQpg9G66ZWTNuJsViDJut4xmy4sXubrVtCIEu/HKOo0HF/+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmZSEmx36yTqtiETZ4vr8FH1l75IcseSvObnLOyOdyk=;
 b=Z/ZDYE1cDmrESZ80VEm31XFmvV21inw2l3Raw9DXlRr0oBJcpOnLAq05caI6n3G5Y/cUEN+vMlDfDW8ySduCOTrQh9qYorg5VgFlCAJKBRD7knjAzoEIBvw3Tn8l6UzrbKZp+9bHzMdYdARu288WSZVdP2UIyg04l/3dy0thgnV5cECWz4rxViAamOL8pjIc3bxNXqp0OGF5wVzAognOIYIlPfKw6d/T2Bvl5OGLKM3Wfr8KIvzExx2PsZ6oFrPO2o4+rxqvE8gnRjf7XPlshLkITuz/TIqoqPd8V7+eoiRPiesTfEZnbBUW/5tVPrkDnMJNxXDOr25GT+eWmqd4NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmZSEmx36yTqtiETZ4vr8FH1l75IcseSvObnLOyOdyk=;
 b=Lg7pcX10WUIM5wLnd5+n829Y5nGnuRipZBZzaB6otFK4FggR+jFpzCloTOzROFV5qaCj+F2L5cRLxcsd3k4hihcP4X4IZ1xnkdwu0u+MMVGaMIv7IOqeqCBPk+jiibIGrLXWkPRHh0IVEgUNvF399b1GI6hCcHJ3ZxITTTGFGBw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4162.namprd10.prod.outlook.com (2603:10b6:a03:20c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 22:38:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:50 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 29/32] xfs: add xfs_trans_mod_sb tracing
Date:   Wed,  8 Mar 2023 15:37:51 -0700
Message-Id: <20230308223754.1455051-30-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR10CA0024.namprd10.prod.outlook.com
 (2603:10b6:510:23d::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BY5PR10MB4162:EE_
X-MS-Office365-Filtering-Correlation-Id: 87c4a5e7-29bb-47ea-30a0-08db2025e354
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4/bCYNQjICxQmXax2SLvJUDck/FjZVy1VGfl3n5um1MIWCJzMh2eTs+837MV7uyDW3Ya+iAz8+DuXnTO2Zd39L2VQuhT0r8/SyiIBDDw61s6C+ceebDl4wHNUl+i5kBM8OX0lPiO0bsAE1TeRhxpSRwUs1h+IBfq6NSWT+cehM9/IDQqFty/1nbWQXmjtKlAFZKHBSCdxdlDOGNJ8ahffA0gQdsDRmkVnq98Yu1locUEmuiXZb16ETF/+6mC0P5KBB/22qW7qdVr+gCsYtgFYRpxDdWDxTL4tavx/ux9Bw3dkoBQfXDYs8AW5wVijU5o7CukAaGlRaF/xJPZ4vgYLYuKb+XND6FTma7b6GwXB1ZFRzZgrxafNAJgo8cnYOBZDc0NLHemEh0f64VkygNzyeaBplso4dc/2/FuSsfoKibKlglsKZfxRtCTW/OAn2GYiJhXyUCFiF9v0wOq5K6DVmzWBZh/eznC/4BwgwCo2CJN15HxURqd3K1+4gAe/cH2AA0shY1/ZsDjdySF6sgA14B2Q8HEfkDEhmRqYb1MNusZ5+mP5Z7YrVcJyfM2jZRYDorNNBkioi2zXXpKe9mxzHx36vls4pmsPYxQL6gXYvQzmiuHolAFcUVkmMabdB94ekCLl00rRHB14aPpsiI+Xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199018)(5660300002)(8936002)(8676002)(66946007)(66556008)(86362001)(66476007)(36756003)(478600001)(83380400001)(316002)(41300700001)(6486002)(6916009)(2906002)(186003)(38100700002)(6512007)(26005)(9686003)(6506007)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TPAvps2+Of6JuFSC/iTkEWq1xjZZNfuWuTnkioU+VgBSxfrWecigLBorCc4p?=
 =?us-ascii?Q?7+CEngYAmeIwcF6fAa672lZwhf8+a8NKDEpjyn24e/cNLMiAQn1ysnARdf0b?=
 =?us-ascii?Q?mx/uvpQfK0lVNIn0+gKy847ZHU7abc8oO3zlH9zOnYakLdnVKaOsjEA7JI4e?=
 =?us-ascii?Q?dEuiBirpqT/5oLwDmx94jBVXNHAqXULKiOuEtut1SxggQ0+R/nZRgPmMmZNF?=
 =?us-ascii?Q?Al/Jt8QBMZh1a9Y6XjQs60OLFRZ+WSJRXls0NbJX8dtZw5VyQCh1j91ilFZm?=
 =?us-ascii?Q?4EzZy9t1p0lFyrzhd4i2bnngpf38p6Za5eBhZEiEq7Kp/lO5fSoFoq9gvvJq?=
 =?us-ascii?Q?cDDtzDPpTLsCYxgtTr43zIxmXJXfCReq5XVxftGqU4qdzk+vdrk7BnqC1pmz?=
 =?us-ascii?Q?HfHgz18OdVn3zqFC22TnLBZutvjcfCQrNmWhcj+WXu8S+sOaOhSgRx6M8fTu?=
 =?us-ascii?Q?3OWdxhMOxpxF7VkIFbyopBRyR4RGE/VQEn4u3V4mqG+PtDsA9WMtg7yULeJV?=
 =?us-ascii?Q?7/L2fXtGHfURwJ2rkwWmgi2mBR5Rynux9Rpr2ySGeeSKmJH1z+w66f5A7Zeo?=
 =?us-ascii?Q?+dNj8M2ctGFWe6Brjj48ehOXesxLSD2MnF8We7R6wQGyRywHDtlnCbO/+6sT?=
 =?us-ascii?Q?LEJIZcFFke+HF2EgdHNfk6rP9CetOvWGsu81WTum/dh7kt7nvQHGC+djBmHy?=
 =?us-ascii?Q?NEu+Egzucj0RALGOVMVGwt2JjuoEtt5EfRSmwDd1lba5TTBBO/UTpVbf4l4c?=
 =?us-ascii?Q?H1GxCOnyH0fA19gIxgstQ7VJzSrdEKYkwZL56VV/UkwGixRX5/cSbROfgDw3?=
 =?us-ascii?Q?gmL1EbCTPiWEn1R9MUcHf8SvTwueulFWEkP7MKwaAGk7cAQR9PLv6Hw1v48D?=
 =?us-ascii?Q?s5mU5FxmCyArT1T0T4Hgd6tyJYQO8txgf/OakhmNP8cFNrZOpW1y+bfWL87o?=
 =?us-ascii?Q?wHSd3wV5smbgnW/lLwKek3C6Hv9Ki/nX8R3YDXFa4gooDzrgHWH40i3mjK31?=
 =?us-ascii?Q?BmfQ281VzhLLGrc31qpN+F+ltylu/dja2N/wf3Rx011qbXS6KqX+e/TkCHrN?=
 =?us-ascii?Q?iXNmWEAkqpdUGHWTod+cmyGrARJSkj1Ga0Q44mX4qwR9Rga+bp5DykGYnJ6C?=
 =?us-ascii?Q?E0/N5pVnshLdnLJsz84tj/uZNx2Hq7T1FqByWjubaw6imcJAjGHsmej7pS2X?=
 =?us-ascii?Q?Kj0faxiohLUTxXjmqjjH/7LCvPSt+pQqlhf89IpAFFo2E9nwHfXpxE8uD5WK?=
 =?us-ascii?Q?5QJsXgFv/8tlMGXz8QXKejLm+EOYI8pTAkFUgmO6rjDzedjTEJep3fAme/El?=
 =?us-ascii?Q?bziJ6jM+cn4id/vn3lhvw9D91MN7eSGMVkKFVygZ1lFs+napEZuiRvov/O7O?=
 =?us-ascii?Q?+f5k7ILP6I62VonxCh8zOsgnieiivaSbhjH7Ft6sJ4N4XOgrBVp4hJQUGZXh?=
 =?us-ascii?Q?6yYpQMAqRnAMuvAl3fvDjGjdFHsBea6Iv2rO9ccAZzYL0J3y3TKZAJQ4K6mV?=
 =?us-ascii?Q?3QlA9HTobB8oA0h+k9ezBOvfyqUpLQJemETguWYfP2LGXNfWHwZM+wpudFR9?=
 =?us-ascii?Q?fPxsN7zInPwaAkKn+idL1HcGFnUvI4LSuBnHpT1N0qZJQDMeHvxgAvcDDQp7?=
 =?us-ascii?Q?/Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 46UhZR6XjVDjsbESVJ2aO7ujlD1Bb/AC4+1Bi78FY7HjxP1xbdU/yk1nnd22O2/wJadneVCzU3j8RjFpYBZeFV/j8uIKbsj1JGQZQbtKSI+WAV6pe27+3DzYy05O60Dez6eRJbbrZfciwIWVkdn633WUwWg8uzOqZCcfA2uwpxX/4IADU8xE+Dz75zTkV3Hg1mI1tKptoAJeV2mElcgBdDk3+G8QoIFt0Z1MzB390Eo5CyYWTrWgedye4fcyclMsBr43aqJNx5xROSFygqs8nIe7EU6e4+DPAGrMYarzgubK2YopWTDTkS09lrXCA5RHQB5kWWyp9Nx3DQ++jKI/+bEqng4jOraHogHnik7mYjoZDRfJjU2iTKHi7gOTxvGFoSigZhzsiHGQmPwjel7p79nWRNudVytZXNoF56yYwsOIUlo9OiELW+ZRj1g0nVKlfoT1+XS7gQoitjjFEDsPr/65OFNtAIvZsQ0i/qJdmtpmzgXpSoJvA+wfSvN+1qTqUkqV4cgbgOKgzJb6aL//Zjj6KA0KE/4rebAXg0lLks7+8R2g412sgoEL0y8VXAtvRapDV6HAoQVp1DNgL2dRlrD88PGFohCjpAjsPq0Pj8zqO5zEtbAN1NmjRKilwZHEOpodvGCkNl7wXYulM7C4ZHeVyS90n6tStUt2gjGK+jXK3MkObTbXdob6gQwbMZKN4Z7EBm/78EhIV71ttA0eoqwXepNPESwTIHamOJjyzYtu3l0y0YmrfVmC3XprbNLChkqSAclTK9pH+3AMfvPNCg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87c4a5e7-29bb-47ea-30a0-08db2025e354
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:50.4287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G34aGd3w+yfN5c7lkAujafnA8lbd3w9XqaZ897im86qniRfxEBODPDvz1i2eT/jaV5cS09ki/fTWajIjBzl7qjxHWMVJ2oStUW8qYHxnUGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4162
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080190
X-Proofpoint-GUID: eBvgbwKvyUrmtLaxyO8H9zcA3xPxkhhq
X-Proofpoint-ORIG-GUID: eBvgbwKvyUrmtLaxyO8H9zcA3xPxkhhq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Reservationless operations are not allowed with parent pointers because
the attr expansion may cause a shutdown if  an operation is retried without
reservation and succeeds without enough space for the parent pointer.  Add
tracing to detect if this shutdown occurs.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_trans.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7e656dd42362..e32aa547222e 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -375,8 +375,10 @@ xfs_trans_mod_sb(
 		 */
 		if (delta < 0) {
 			tp->t_blk_res_used += (uint)-delta;
-			if (tp->t_blk_res_used > tp->t_blk_res)
+			if (tp->t_blk_res_used > tp->t_blk_res) {
+				xfs_err(mp, "URK blkres 0x%x used 0x%x", tp->t_blk_res, tp->t_blk_res_used);
 				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			}
 		} else if (delta > 0 && (tp->t_flags & XFS_TRANS_RES_FDBLKS)) {
 			int64_t	blkres_delta;
 
-- 
2.25.1

