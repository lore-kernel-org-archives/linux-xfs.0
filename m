Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0B6C4167B
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbjKFNN4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbjKFNNw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:13:52 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A27FD45
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:13:48 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D1xLH006674;
        Mon, 6 Nov 2023 13:13:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=c0aqiVk+K8zuzG8NEp16kJakpNxtYtI1xbz+J/Z9R5U=;
 b=yO2AUvbzklbWb0hX19KxAK/urHrfpqT+t6NQbaj+m8PzRsrogdGkRLFbuwrXo4qEeTOD
 ZgXyuxiYr1djkQk0XemfDQSeWY2bBSODRp0bseoNIbB0hEcDvHa5mBhZh3CROV92eAHz
 qm6rBjqgcZvBNjSzBNkLJ+wNW3q5a/QKeet9EfI2/4AOwxXzdt6K+XhizwL08iCvC/RQ
 E4lgWvf9bQIs4ef74qPoJQWL68y2vepkQ6y5OZPniyic4fzjcB2CXpkRrKdBFS1vdCfo
 1MUmnxpnJ1yf4xkmz4aTmNrvSJ3O8mmvKD6uW4iCIXI1s5dxzwfJskYWuEYxtRvn2YE1 vA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cvcb0aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:13:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6Caung024808;
        Mon, 6 Nov 2023 13:13:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdba9fv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:13:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JiHAtqqSoctkYxIXB1X1+odnWHUUeWCCtdQPxQZ91ST2Jnyd/oWjnDGcKL+JJ3QY2HmMQgPra+2l8AB6Gh3wlkb0wJg1tI3cORo2CxG66+P8MDP3Xym/WnBI04bUclsVAgjOZ/Qqnvb4Ku97WdE2IF3xxProAySDlM5uADP7B10iGgl4UoUlGs8oRcv8QIf+nmlJbIlFcDHpfZ1hiffww4g/nE/adS4k2g1Ed4kIKwJKy6FMXv5ysDnecOvGw22NG0lT4WRBKMx696snVpiYkvizvOnnVsIATe8ksUcoY7i1EgFaDEGf2e+JbPaT9yHEDzOvqWpwAMwaWDcZR6QSBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c0aqiVk+K8zuzG8NEp16kJakpNxtYtI1xbz+J/Z9R5U=;
 b=odzP4ph++ccM8HuYeo/PMwQtgEa1OJ1S4nh3LN0sq0YvbwU+PcUCkEpY/r1wNy9qt8SfpIrPSMephAtcUzH7LtSoM2eK2NAVWWVr0FX/vUfVUnNXCMaXhPSDf+F9AkhKbs5zMuhXx+ddBDXJTGnLnAb9OBRgkMXnw0fr9gnQxzKHsy7bYvryU0QjGXq1JFYhKAcqVDpV3upYcV6ES5ZN/zoq2GJsNnXw0OSnqwNdRbFaZbCnu4ti1nCL7y1hqtTaVlbzPtM1ryqbgKF4OkIhExpDSP4r/P5XJNUEA8HI6oQ1mYAjI8AGuHHfW9j+Zp3JJiZlZDYGK9tdcoAvHtE75g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0aqiVk+K8zuzG8NEp16kJakpNxtYtI1xbz+J/Z9R5U=;
 b=RAOlm+1cZrf8a+UJWThxnrjf3UWt5z15wUNjSgQt89iGTSjXoWE8BAuLPIH3WAyUS7B4Q6dkjUONH8Q/u83BojeAqQoxW0GX9ty1SsEpzdHRY1ujiVeHA961CG4bDBSytmxSaJshE50FJjNh4oxT4JPmtlmM6p47hJr4yq5JC2g=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by BN0PR10MB5127.namprd10.prod.outlook.com (2603:10b6:408:124::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:13:09 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:13:09 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 21/21] mdrestore: Add support for passing log device as an argument
Date:   Mon,  6 Nov 2023 18:40:54 +0530
Message-Id: <20231106131054.143419-22-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0001.apcprd06.prod.outlook.com
 (2603:1096:4:186::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BN0PR10MB5127:EE_
X-MS-Office365-Filtering-Correlation-Id: 46acd054-f2dc-405e-b528-08dbdeca1f12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y3HRskgAELjzh5mLW4Ma9IltxCqelLzExo8XvaKMBW8ZCmDNWekvX9+WBOl7vBC8U+UPg1b7iJ7VaZKong9xOOldH+y66I+6w32xPa+EiQFTqJZH4scXgp/0bkFHZ+B/Lypu4cr9cQ08z5GdRkA6218EOv6yzzX3m1AIKcsYy4h2fZo5OaF2ulDq6i3wgG5ujJTPajsdrZwRJi21J5Pzb4UET8hz8FVzA9/YQ2/VERmHWG+2UBAdyjiE2V/LKiSNmVL8sEk4Xt4Wc0MG6W1G1fERRfliQ4VHImgYHQNiiNuWXFBIF5mNU5SqvuVAhs1Kc1rdw0AthIUt+2HXPfJYpGj3JfqEgNLOKm1NqGD9R4/RqeYmf1Y81dkgeKUMnT920QJ1Fg6nqP6ysJ89mqJ7Nx8x7ZQT59Nc+OZZi54U55kuohL/bx7uozOYLVjV/2UTSMGY9eoREQU85/JElZAZNO56g42hOjn0ErVhyIzM+NAtqsWEl/v3ncEKorvw6cxoAznrB4sCh1GqR8uxE80iZCS8rSe8pizHQdT6C/vZ7yE9Rb07omUchLBE8NtShxPoRttXjpizYs8X48Noclqlp4uSfAvW6h+Qlaf6tlYxgi4l4gefuHwGfitRm5DsUnBo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(136003)(346002)(376002)(230173577357003)(230922051799003)(230273577357003)(64100799003)(1800799009)(186009)(451199024)(478600001)(41300700001)(6512007)(6506007)(2616005)(6486002)(6666004)(83380400001)(8676002)(8936002)(2906002)(1076003)(5660300002)(66946007)(26005)(316002)(6916009)(66476007)(66556008)(38100700002)(4326008)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+ZQ+ynlKbg3flbd+2Hhq2h7QNq9+sxRs7pVKJNk5HeGYwfnh6bO1a4lh4Dbn?=
 =?us-ascii?Q?Cq9Kl/r/nRnSrS0deo03a/cEdf3JTE+AR1p4QaRK61S+GdiRL6W6VCX0nTu/?=
 =?us-ascii?Q?HZQjEC+RYtqW+MKN/z46PI0YWUIqnv4k3NHKQ2o8Uvx3VTlIUIOMiEHrPZfr?=
 =?us-ascii?Q?QS8aFejEfx08joKwOIxINpVcMGOEu1DeDhGtZp7LbxY9NkFlCn/6bthYvI4L?=
 =?us-ascii?Q?lKRvy8YV7DIv4kDHTnINVSRGGX3hRVzAMo627zd18RMTdXHYWvOEfV6/yHc9?=
 =?us-ascii?Q?695TFirT2vfBeK8Czy/BR2oZHmA3SoTqeyJEJa/xRhmyzN+248DZsx8sM/SI?=
 =?us-ascii?Q?LAAZhe792Z8F7rKeSEZiT/+ZmcseC9yWsYhW/h1+xnwUkKs5HWchw5kO31m9?=
 =?us-ascii?Q?ZDzPogpFvSYU7EpussxBfUeHJLivUqAjkMx8pga9NgayJ4Xv05qFamXyXLEH?=
 =?us-ascii?Q?5gXOERG03AoEXn9KzPHi2a+T+mnv/ibHGQX/Q9qw7tF2UNKktQ6xceXa6w+8?=
 =?us-ascii?Q?nPeRpYhXqLvxw/TJlgv+eaftcuTc8Pnw+w9nYzyuJ8Hj8+qNUKOSQK3HJz9j?=
 =?us-ascii?Q?0c8Qfj/gn8wWb2BYpeiZCCrl1W9AWxSQH0Yaqhve6SRrUtJZBVl+50sGNIIb?=
 =?us-ascii?Q?dlxAzfu9IbOyCMxqHurB61pWycibqcyfiWvKA6ol5nRiDCUa3y+zKSjUtXAG?=
 =?us-ascii?Q?cLr2Ac1QnMWIH6lEJcve/Y0cY89o7K5pmWkK03642x2d4yKnOK4YYBKzKUK6?=
 =?us-ascii?Q?HzISUT6TrzQ7Y/8xUg20fO+cMpIl43AJc128gphAfAlHThpWIGakjC0yKpiz?=
 =?us-ascii?Q?8w0Oc1fPhRNUfDLmX/fmB0WhUNJSt9cAwoH1dHuGWcZiyWyAdFlkYxLAmNKG?=
 =?us-ascii?Q?ViZlJglfpDQt7FWDGZetf1GAbwSorN7XvEDZHj2G1ft3O2tWvxIXvv/gXl5V?=
 =?us-ascii?Q?aX0H//cXRdmJ2lvO4h9mdawu80gx5zg1dip5H3fli2gHEEYpc6cqpo4Fc+AB?=
 =?us-ascii?Q?afJQJFV3LXG1u4bv6HySLPqbCvE/xDGllJngr2+FpMuUx8hlY+zHZ8oZ9qzM?=
 =?us-ascii?Q?M/Ha3MNsxWgRXHzG+a9EhJOcU9wSjgsJJhm9c21LUCYF+QnSmKT5PLny8oXP?=
 =?us-ascii?Q?8wWtY1aK/XU6BOL3YceGGtb57Oo/ieQTfLtWc68wbqkZ0WIpUwcLLio1Ghab?=
 =?us-ascii?Q?KzCjldokbbhkG8mv282oJC7FWTw1W6i+CIopH7dR40/B2XvhGXSRVjObzwXk?=
 =?us-ascii?Q?6I1AjkPFKuAZhCNTLlozfGh+zQeV0BfVic9SHUNvqmrb+27IXwv6fzIA3GiR?=
 =?us-ascii?Q?u0f+P5Vc4RB7mxIGdaO/jiqencxhGu21jCRZqzcZjNPHDbyuagjIO8+8Rs4f?=
 =?us-ascii?Q?HyBrzQNehWZKyMbOdj/dXMffv36V/nS313kr8OrrSx1sEc97slXeEdv/EC3Y?=
 =?us-ascii?Q?Aqwoo1IZ/P1kl5uAu9KlcTqo0j3aLPTjYaD8JodVijkIXErqQYZkckbYBZu8?=
 =?us-ascii?Q?kmgJfNcDFKAPEQ6fVeZaLNYxzsRXZaCjftsx7IN9EvulcH1KzK0pUReExCMu?=
 =?us-ascii?Q?2E6iBvQGPUJMTyacuPUlPUz86QGiob+knA5o9+7EM7HINPZbNGViFI7eIGtG?=
 =?us-ascii?Q?HQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 7yK0JGx3/nypWBeBlTlC9dxB3/I9cHsIsrr/yNRU/cWccnxgTCTb1IHVN/25y09g9SaHelruLiV8PDg8uzU2eIlmTmGItom5yO9SlDt5whPbbZU201V/D2CpMCzmD6bs0JjNfGXmLlbwTjVMsewEHMJ0p/ww3HeU4o8u5cGkiptzCGqituky4js+6nTx/z7Sa+uO2Z/uAWAq3Ra/TVTMGHKTwhM+3kHI0OxeBUCEOy1CyhNJ6UANAnpk8Kj/Pbw6AOSWv0tgAXUBYnxoHbGK98e60Q7P7LS8SCLkq13Jqe/qV+0golVkqbyJnTcS2XdyMUwDzN57BGqD+SyR3vZBKVz+TAZRZtZtW/PlueuVD84IxXdYhg0HCQrJga51pPtrw4WUZUijS7WwotMpxfGzLVKfYNfCMK0gsmDqHuadaK3a62JDOWzLcMdsaAJEyn5158rSPxK091+Y8shVaeeselQBGniCGL6I14M+HLpz7NvzIuZQxNmu4M1/i2UJb6gnx3Aw6ciHcqkK2j2Xc4CNi3MLG+P/d2N1vaW7mf7p4Srs5Yj+AVoH4/RsJGOcrU/tdC6yS7tBZE+L8G4+s7g04YRKmckVcAvpeELDY4Fy/5Qg8h7asFHtqZ5lSckDg5q5ep2eFEeR9mxmfAkp+OfRjBOGREe5iEbOIXs5IrefFO++vTjvmL6M9GUOuBWdPTTMTlZAVPG/wpA96vCpeiEXrKyQsnfORE2l175U6UYxaPGAlXPFBZC+vtYrqiH5c+toCH8vfhX4NF9mtDPKx+ZLI4yh52BzbBIk6cYrYGch0Pw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46acd054-f2dc-405e-b528-08dbdeca1f12
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:13:09.1975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wiH4rSe11VBMPcnCdB9cYIlkjfLuqeGR9HIqHvFEOHwWWZugRjrB1RPWcRUqob1b7elDl9WaKD7MWdM82BBSKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5127
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060107
X-Proofpoint-GUID: hRZ_9ZiIawamlIugXYPXIPV4kN6SMuwu
X-Proofpoint-ORIG-GUID: hRZ_9ZiIawamlIugXYPXIPV4kN6SMuwu
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

metadump v2 format allows dumping metadata from external log devices. This
commit allows passing the device file to which log data must be restored from
the corresponding metadump file.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 man/man8/xfs_mdrestore.8  |  8 ++++++++
 mdrestore/xfs_mdrestore.c | 11 +++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
index 72f3b297..6e7457c0 100644
--- a/man/man8/xfs_mdrestore.8
+++ b/man/man8/xfs_mdrestore.8
@@ -5,6 +5,9 @@ xfs_mdrestore \- restores an XFS metadump image to a filesystem image
 .B xfs_mdrestore
 [
 .B \-gi
+] [
+.B \-l
+.I logdev
 ]
 .I source
 .I target
@@ -49,6 +52,11 @@ Shows metadump information on stdout.  If no
 is specified, exits after displaying information.  Older metadumps man not
 include any descriptive information.
 .TP
+.B \-l " logdev"
+Metadump in v2 format can contain metadata dumped from an external log.
+In such a scenario, the user has to provide a device to which the log device
+contents from the metadump file are copied.
+.TP
 .B \-V
 Prints the version number and exits.
 .SH DIAGNOSTICS
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 105a2f9e..2de177c6 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -459,7 +459,8 @@ static struct mdrestore_ops mdrestore_ops_v2 = {
 static void
 usage(void)
 {
-	fprintf(stderr, "Usage: %s [-V] [-g] [-i] source target\n", progname);
+	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] source target\n",
+		progname);
 	exit(1);
 }
 
@@ -484,7 +485,7 @@ main(
 
 	progname = basename(argv[0]);
 
-	while ((c = getopt(argc, argv, "giV")) != EOF) {
+	while ((c = getopt(argc, argv, "gil:V")) != EOF) {
 		switch (c) {
 			case 'g':
 				mdrestore.show_progress = true;
@@ -492,6 +493,10 @@ main(
 			case 'i':
 				mdrestore.show_info = true;
 				break;
+			case 'l':
+				logdev = optarg;
+				mdrestore.external_log = true;
+				break;
 			case 'V':
 				printf("%s version %s\n", progname, VERSION);
 				exit(0);
@@ -528,6 +533,8 @@ main(
 
 	switch (be32_to_cpu(headers.magic)) {
 	case XFS_MD_MAGIC_V1:
+		if (logdev != NULL)
+			usage();
 		mdrestore.mdrops = &mdrestore_ops_v1;
 		break;
 
-- 
2.39.1

