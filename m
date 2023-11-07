Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB1BC4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbjKGHHr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjKGHHq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:07:46 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2062FC
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:07:43 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72NoSE031388
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:07:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=Qx1R60DXnIB3N5o6yMynJzdO/XXQYFPlNasasf4Q6TQ=;
 b=tPlU+B8jNJ81vIfAGO8TbJzjP6vw8cSZz0JoI6Sl23ZfyVmO8WeBJXYao/ZE1pnM+x/b
 wBR30WiPnhV/cUolF5+iO3cHmEvd4kaPtnAn9R4Qp2kN6CGwR9IoD8X3FR2ygUWCd/ue
 eYoq41NnK7ymo6qvw/y2J6k89rEMsmWz0ctvPUdD6fvjAo2BnqR4oHphuh3YMddS1Aq+
 aOrlRGcgVHXtFvU73xdSaaC3zTr2lS0SUw4q2AVWIyX0DEuxoHDV0hFZrJumNDTL37k5
 VrYVuDjHdqNeMHmXsDSz106els5SvqTWBurbrYRyu/ZvCrSCSE2mMcauPShj6kNNshyO Fg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5ccdw9v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:07:42 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A76dAr2023603
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:07:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd63bhc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:07:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F3XT+GN1cNw7ylKJ+CQ1a8gHODsprgO2i8M8zaKeo9dafwTrIsDp4JPIQeP0zMGzRw0SdpXFCJEO2T3CxXioIQLkM73ggRQYNSBxU0GVj17KqdV3/2RG8hUBkVzVzan3YLeu5kgNjuUFRo+U+1A+d/g+/rtZ5vTobzXOtVrVdEvBSjDJOBZ+06JRCIuUauRwoUSS6M9JTZeMCZQmLzddZnVfhDEkv49zbaxvKBlpECmj26I9wsN0rv5KgP2lpjeJ60hl7hI/6dKZLk4Cr4gmt5QV8ywFMdAF4WLnEVDimY897yQdKGd/FiCA6ktkXPxqe/419OpcKgcmP9w8hBbLLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qx1R60DXnIB3N5o6yMynJzdO/XXQYFPlNasasf4Q6TQ=;
 b=a+xaGI2yJRzd65AqOM9xg0LRW6c9snoGSe57n7dTeK0z3+ZNOUbDV7BsqYzdOZPrHib5fLeYx1eYjpR299fdFNAQ1AezgaT5y+AXBFzCiweTjgF+ZKFs0G5i/lrmq0VwP4YMYI5M3uda5rCx7ATkH+fhgDkm8m3unH8z8Xnj8EWEf/FGIT9c+lotwgPJJwGCS9gqrnjz3tletqTajusaCS+NfG/sA3VxXxdfAxW+exRh6sST2GPbaGgyEQiTRSAYd1yhmoWyIGtkoCzhpgpqIF8O7Wzss34lccMbC1K6gltG2p/zbm12+tpvx/DXh2BecL0fZZxL2C5YDLRSkVmQgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qx1R60DXnIB3N5o6yMynJzdO/XXQYFPlNasasf4Q6TQ=;
 b=dSF9Eu7bNI4nl07UxhdO6YplX9RfkvO48kfXdGaAw8Djf70WSC9sH0qtA6Zmfqsjw3Tk+tHbLp0iOTLkP66YjmzGtcu4SWQWfTh84foaCe7VDKYCkqyT+I7oDtDFVNY9JVuWcC5KbF8HCb3nxULe7OQE+V/lFJQ0YRikF5FnXJo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by IA1PR10MB7263.namprd10.prod.outlook.com (2603:10b6:208:3f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Tue, 7 Nov
 2023 07:07:39 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:07:39 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 02/21] mdrestore: Fix logic used to check if target device is large enough
Date:   Tue,  7 Nov 2023 12:37:03 +0530
Message-Id: <20231107070722.748636-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR03CA0019.apcprd03.prod.outlook.com
 (2603:1096:404:14::31) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|IA1PR10MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: 80ba02e0-8042-4d7a-0b3a-08dbdf603a89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1vsG+6MFzKDCQM2oNy2N5Y7qI7JKNEWSiXk9M56SuNNc59p9JdWBv0ucU+lYkOqODR5j0EvS9H1VF1Zsu0ftXuHseOkbVmkSCdBcKDjGsEjFUumveTlgy1SNUsWrumiS+W7UIdhNxcRBmCmy7ZZqycZI3nancn7DkcqulCedOzYmO446jFBdCCeQXAfQ959nuCsTjyugpBCQ4kvfTOWD6JuYwGOGzegldjWIvA2fA2gGkXWZXU6Q68CA4j00zar8LxMbfnyZXqJOiY+vpdTQamO3G4uFnFaGvWf6Jryt0gGrI5dYufTMcbz9cR8KZT+oPQCHE3W9yMbAvSHj29SZWtv+HjQuDuVWZKIur+MHmPnzwsiogpeMWE8EJ6YW+wUjlYV/h0o3jb/IowWvQiKJ7m4g9m1c/chyLmeNlUkL//p/8mIwVaScRv5gWosCQPmCS54rag1w9vKlMO3xATGwTu903BdAHvWWJEoeYLLaXjwkE3zANL7uYfJajDBHxqyYqcOlafYujyEpBB445Tlsq6PjUxvt7WEqPKbaJab4bCD004Qo4NvUYw3s0jbslQ/9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(396003)(366004)(136003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(26005)(1076003)(38100700002)(83380400001)(5660300002)(2616005)(6486002)(6506007)(6666004)(478600001)(6512007)(36756003)(316002)(6916009)(66946007)(66476007)(66556008)(8936002)(8676002)(86362001)(4744005)(41300700001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tJWsOpC07BHRJJHNThhkhxKal1l3ZOUk6VvjqVt01RVjjdOUisakl6ZXsSxC?=
 =?us-ascii?Q?va9J3yShfyTO0SDpdAuEyAjgePuELPAxsqt/OEGC1U0BVx+6cdC1g0A++j/9?=
 =?us-ascii?Q?+l/hsaXzCll6yCB9w4sAivgv5uWkuMrTed+If2HQEc9sfFOQ882UPbd3+N8o?=
 =?us-ascii?Q?kt+NTrmpvZH7Oe1mj3/YXII4nJiewW40Wj95Nm69OateNugFnQn8TbeL1eQO?=
 =?us-ascii?Q?03vH777jfJ7arUbClZfNglp4AkGFAu9/t1yMhtovn5HNxfiDZRDquAOpAqSg?=
 =?us-ascii?Q?nvfEppw5lybqB6VFNROzoXROIsFTnuTall24FERZfCuqLcDVxZjD+1l/4ZfR?=
 =?us-ascii?Q?CDoy7PTUG0FmYuaFkM7rVTOWgTDSzXmH3CAtEYD3AwBoyQJO8qWG/7pr6n4l?=
 =?us-ascii?Q?csyFLjHU7nKd7q4V/G5UJuKLbopI4PPEsjD2t2ybdwWVd8ft8f4wLf4aYatc?=
 =?us-ascii?Q?VpWYIeAw466XNlupvQeZaXQ5PPTWHXxxQWzoUXyYhmrzZbGVHEiGdZqYJVW4?=
 =?us-ascii?Q?ApBynCmANvguzCRbS4Nc8qYqrrR9g67CNtUhxCCne9f0FNbARpZzs/EWcedJ?=
 =?us-ascii?Q?9NTnXvQ/YYnMxUbt+xAqoQXRjpCOYKXDgTcP1ZMQbizotcSIN7pnCvvhZNiO?=
 =?us-ascii?Q?rSsR14Mel0CvOdSlDZuU1v0384o6eOnGZVsq7ekwf4L5RtQth3vZHOJf6pp/?=
 =?us-ascii?Q?XVD/A95XpxFXy0cUvnb3GzWmQ+F01/jmr6FAQAW/XBhU31wHQRYbcBSdnd5O?=
 =?us-ascii?Q?vbfzxvYkh08Xjrr7s99MpbtcWzlTwtAmIobiNcX9kXclMAJP6ezN3SFLspQR?=
 =?us-ascii?Q?xrXSprxTTRrK0gatn7ZvMqy6KJ28lnsLKOQCBpUqoQ0g3VGRnTQ9IBKemwSL?=
 =?us-ascii?Q?1UDQYzKKvGiBlhyMQ+qb6wcVRmrZ0x3NRBGbCmo54Ld2m1MyZITpl42hQ1Ud?=
 =?us-ascii?Q?CDp8uh2pjvsslH5QRQ1hDLzr9ew82SK33NsZ4DQZMq5fopfCztUsl2DCTVhn?=
 =?us-ascii?Q?+MWEHQrL646sXLSazZROv8Rf1w52ThPQe4fy31eDK/6wsIwDi8FbSl0wzIUi?=
 =?us-ascii?Q?rqyYcAVaW9yVGXKmZNJ/ZlTQ4ASw2wS9YXimVcdX55pf5RuUBEJaD7eqdYve?=
 =?us-ascii?Q?SLndhVi0B/mQJSQ3RojkuES5mDajMqLrvx/6GUywuEUrpQGt3OJ/pMYdvnh1?=
 =?us-ascii?Q?d4w0kKjWveyz+JUtCOp/iuupXJ1CbMm9VIIaGbo+tDiGYZrxmwvLeJijo412?=
 =?us-ascii?Q?V7txERkYguY7GIB+JUUHRcYtKaSypjAyV2HefwTzYEVK7VzBDi8eQn6YkShZ?=
 =?us-ascii?Q?GQMzwPMqL4s6LIz7ylyuvdFnXGxY8sEZ5thwFzEOXJuhcH/4c2iuj1+FGynI?=
 =?us-ascii?Q?0dPnbrOP4h0Y6OTMYguNdjAOMXk0v6QtPjGMOxqY+OD3RB4eqAwsvbSuKtL/?=
 =?us-ascii?Q?OQd5qVvhgqvghKSZkAhzrDYn6wkY9TH+k/yUG6DINtIp2rtqC0UDei/GYEVi?=
 =?us-ascii?Q?NAHgnFi2K5sRaTTUyf9KXwRjAyKKf44SZhMVBoDtoI+o63i6/njmmKtRmJhZ?=
 =?us-ascii?Q?bXZP2x8gsXHbvKGQthAJQZ1P0dLwSsYmIcUHq5EozEzvNZx2GW6QO1qrLi41?=
 =?us-ascii?Q?3A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XKZ1JXczuodHVT4tcIljrJVcF0KjFJaE4uN55Y0YsugYgfAi7tEWyXFxtHNR8QYR+EpIwgXZmyLb6B2YOnzhU2ODLmy/76U9/Dqp6V/T4h9EL5gvJhJYrJh856pCjafBQHsw/RkRD7L6yOgnDOskjX1atUNOm4Baw2nAmOcGJ29tOlG/OYze+LYKnBpE23eFKlfMMQmwFPjmGEYWbN66D65DTSKZemn3Sk/eUnoStLDq3CU9ieFrcdSd4HeaBnJFpjBlRqD4+cWzT2jzDHdrdJqXcs7RRu/XGBStyNlvPKNVxHvCVB2DhBWJkRs5mqhf9Bnq63umKXiLS7SNBKUDYxQ0HePVY9tp5u/20GUugTP23cN3ChdtJPh7FVtejGzeS1tunRCfDwYWferiZ2UcGpu7ho33RbK07W+6VQ6uleMz+wy63OZm/ZBM3VnYcvWn2UoNC9/U0gGY71vbcsexSjWGG7xyIXgZIJpR9tzv99rF13jYfXCr3J9ysBB4Ga53MPfGxP1utzEm306HAIf7H4WxDHyz6g7TljqP8EgYfIZP+oW+tfXyya6DjmmENULT2D0WAFRzpPWKN68on3W+mkQVyNnN3A0W/abfKNjlxFzTzoaoi8gHKDhWS8sW6296ivWGJgpTFlItPgqzF3zPFo5jb8w7FXp0eKuJMFjL4JsQ451NUfElN1yODtT1PknaJaN+BOkDZT05NOuXHOr4Ym+G1AxextVnkWu3Yx/qJM9mWMQQN6IQ0e2es59hdDfN7pKUdK6Rr8kNdhMVrDr+VQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80ba02e0-8042-4d7a-0b3a-08dbdf603a89
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:07:39.5634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f0QwjRJFGelPR4DQjq3hSlRHBODuuw1FHYCfWUgzjgSXL/ASwMjp/17zjPr3zdunP+clEpmV/T0yXxzNKENqRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=931 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070057
X-Proofpoint-ORIG-GUID: ST0tx1kVn9epg-TnatJ_YAJLRlo-Rrat
X-Proofpoint-GUID: ST0tx1kVn9epg-TnatJ_YAJLRlo-Rrat
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The device size verification code should be writing XFS_MAX_SECTORSIZE bytes
to the end of the device rather than "sizeof(char *) * XFS_MAX_SECTORSIZE"
bytes.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 7c1a66c4..333282ed 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -115,7 +115,7 @@ perform_restore(
 	} else  {
 		/* ensure device is sufficiently large enough */
 
-		char		*lb[XFS_MAX_SECTORSIZE] = { NULL };
+		char		lb[XFS_MAX_SECTORSIZE] = { 0 };
 		off64_t		off;
 
 		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
-- 
2.39.1

