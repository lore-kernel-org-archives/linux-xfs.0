Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27ADFC636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjBMEGN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjBMEGM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:06:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739E7EC61
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:06:10 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1icYL019814;
        Mon, 13 Feb 2023 04:06:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=rxXruwHuzANIGORStyi3SU9LC+iCWUB7RmN7vVCLR6Q=;
 b=EznuZ7jbVMaRdny69aZjJrWqOuzYwwAfWphK2u+QmiOxT71zy7FGzjHN35pTx9OUzTKf
 2+y/gj+aPjfrNpIo5PtBzFkKZLrZXe9hOBWHTjJuJubyfDtc611OLytST8ifJB5jFdF0
 GR9TgWE2f+M9fqDahwXbkO32LPMeeEtVVpe2FxNhLdpQEDpeFqor8OUUHS/ukTss84eA
 bvV7Sf1t6C4FdJvAQ2n8TfP726tRbpXsenSo0lhMhA1h6mu5kkPlySl9K+INe4s6x8Lx
 ruA/4Alikj/mcK/CIUh4ChtlreaxYAD48TjyNvjRDIg7QmwGTJtIY4dLLDDdihv/4X6b cw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2w9sv4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:06:07 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D3IKaB028861;
        Mon, 13 Feb 2023 04:06:06 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3a9jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:06:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4FBP0l8E4YNN0IYGzb86/sS0RKtIAEQHQZnzuBZ0tnWiUNs4PAyVruJA8UE/WuhzHr3VR3suNJEDRgT8NTgqmxHhnf+qeGlpxc8r+Q+cY2fdgG0FOWQUXDeXgZpM1xz+tVtaf0TDQkUg1jbaCMaorVnMyjTy/WbSN9uPIqATjPHnanxzY4enIGKJj2bOJkzWppglc9G2qOFsXx4GfKS26T9/Mz0IL/+8rz3bNyyBMfllKTOpufZHs6LBjqJVVeYTOTC/GNf04rAOsdcQEsEkfZBPGJXU4AkWNgam7lvdXG54ma2XMbi74kSqQ5gr/8LayUpmnqgJES3dA8yKvBKZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rxXruwHuzANIGORStyi3SU9LC+iCWUB7RmN7vVCLR6Q=;
 b=hfZiDLRohrSpRay6SgtR67dYFcT13P+AQ+LCThpay5pC4w40mA3DRTFdEsnA8y7JJnF9QRemkWShSNj41fn99YnGBmC992+FH1KPVSYmWFfPm57qoUClpS5FrSam8dvjsYJgVpw7LT22DUnxb85CpfnNCvqyFGfhupRucmCwZEHHfDxiNhPeWbBwRu1Cl3leQLmNj7H5h4Q/xEDB+GFfeXdJ3mevDpf1UbNFR2AM3VI4YvbLbaynd88qrsxmm4bqdqfwbWpm9S/Bk/964xBQptqOJTegv0Y0kT5pgHomipAnYKC9dKWxnCiBwLzhhZAIIl/A/0XoJtm8vfkOh8gaPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxXruwHuzANIGORStyi3SU9LC+iCWUB7RmN7vVCLR6Q=;
 b=yp4WcM0dhPjafk9RpDrSvw75AUue17HHOUb3z0Vl4Qi3XSlNKXalo7RBLMXfzEuVTXbvhotoqRDHmMnS+hyKKbxItfa5ALjR7KSiu1O2M/oqWkRLdua3M4f0t02TV2buwtukz4XkcrTdC8kh4n+i31WQ78zMHtDpaDpUo76Rl1M=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB5225.namprd10.prod.outlook.com (2603:10b6:610:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Mon, 13 Feb
 2023 04:06:04 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:06:04 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 09/25] xfs: log new intent items created as part of finishing recovered intent items
Date:   Mon, 13 Feb 2023 09:34:29 +0530
Message-Id: <20230213040445.192946-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0039.apcprd02.prod.outlook.com
 (2603:1096:4:196::9) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: 658ac214-dfc5-42b3-0972-08db0d77a047
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RNb6moRnP0FTn5sq0FKTLg+3q2jHPJe8On1ZrWJxdf1WO9Ea1rn6/Lpz3JGHzZ2i0e39zU/rv5MJ0sGSf2eTG+np8wZeFnBobKUQBQPqXKl+wiPFAuq8tS0HoWo2jInuDFmmMVp1/vTpP86CmQ1oJze1WYp6lfIOFW2WefAbq3hKXLsDi8qDDXlPUPTzaQ341aptsQRLqAn/4GaceeKFCUozTqrhBV+OS7JefRkE/gfkK9/il2j+JVFBowBHUZ62nNjrMpLGecGN2HODOt9EEGcRilW8naHJbvujkFMdxdDgr4PjRu6g3fgn4gnXZdOjLYra+OVWlPHzm5elD6pispsw16nscWDCBUZHojGMwSkswgSi/np8rC36gkCYgYmzOrOyby5MkfGp1YUozdh6SBHt6+tODynBBjx7UItfIvA+MV2I9n2fOdRHxIP8prxkW55gKoK1LhT7uRWgJbkBPrRyzui1Hczt8nIpoCzDdDu3MXm9i/0+jBF2EXqdtW8yeb2SmFX4t75C8rYgpuHo/ZY1B6WJSkQx48m+pWa5SesTEA3HhHOoKJS0Dn7g/XvbikNeNHVP3cIJwzXmCaUwmA24xKRPtcnUJtm/gsEaUOeWvx5lZoWTGB/1YQwJFaIjLOjpHVAHVeqJ914byyaBxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(2906002)(8936002)(36756003)(5660300002)(86362001)(66899018)(2616005)(83380400001)(6916009)(4326008)(316002)(38100700002)(66556008)(66946007)(66476007)(41300700001)(8676002)(6486002)(478600001)(6666004)(6512007)(1076003)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CwRIGky1mOq93AmvJeGM3y6DDmLdu1HhItkwO+y2vMMqJ+FId8vnbeJ3H+b5?=
 =?us-ascii?Q?eeYAPHT0yTuXX/G7Pol6akirZb4EmBilp9OJXSc68b7uqo0FN7h6GJy5qptd?=
 =?us-ascii?Q?TQxQKhdv36NlUGLZvvgFWggA2cWDhyGZ2NdzAABdwv8kC8slN89HaMt+GdHZ?=
 =?us-ascii?Q?a6EBgt6f6++vfOm5zVcRVet6aD6ZnTD8VFL8aG82jI2l8EX+aShGSAc8M10Y?=
 =?us-ascii?Q?hemmboyRBTqdtrhudJ/K2IXeO6wSjD1qnGiecW7Of6kLqF0pf1PSkFC8tHx+?=
 =?us-ascii?Q?CZdorbm2Zi2/vEh0qLgT2hUZPvghCxPb3cyZZI4UdTtBvbYXYI5tbn29daia?=
 =?us-ascii?Q?iKWcWjW3n7uhNH8Q6WgrI3wOpR5Fz0+fAHLIMggO5u0KTPZK+7812yTFHzYD?=
 =?us-ascii?Q?OO9i/Ymkq8RaOdQYOWV+y2N+bdr6zFZhT4oCr9n734QqRgLoxZnMfjftG6Gt?=
 =?us-ascii?Q?VZXaRFuQZSWkbj8AHf3PBW3lIkBAYw2uKbAeoDcdi3a0SKeXt1sD1V8PWR6J?=
 =?us-ascii?Q?IAVgz+y3pVbunSjJ8OLZU9Lo6L+nZWvj5CimNUTjGqbV65+noOz5MPYROBXb?=
 =?us-ascii?Q?zqRcY4t5Op+ln1/8euFLmjA8laZ238ManETAirmClQ8XEli9b2ibE1XlxjDj?=
 =?us-ascii?Q?Vbu/EBmDqX8hnPNkIqqeUdwKD2KLOd+Fhwux3UkHlhAamc5+BKBMTjMwU/LE?=
 =?us-ascii?Q?ySwnztB0CSLVVIouVepUwGtNiPOvgV2mCOEStKTUqqA46DIHvdmK9Fn0b8dV?=
 =?us-ascii?Q?znhEI40+6/B9M8AjqAAvURe2KuCTY9H+2PRZP4l99SO+WPMvEKzRA0VDLL6v?=
 =?us-ascii?Q?DU0qkcvQOEjTOqXFuHbXwYq4bfFaZwSgqE/J933vOIWQ7X3tZLJgAy0IfSxy?=
 =?us-ascii?Q?nlXxKbIlQvXhbHztz5E9uJcsEvr/RETkqY381XeaTANenM/O7Yb0/x2eNogq?=
 =?us-ascii?Q?hmKHTVLEcppvDKGl4+2cfPchOqPNpMyoDPggrBdWP+B51g9woPAjEGLVjxey?=
 =?us-ascii?Q?aRWKuggrIasgxX7pE2RLLVjv4wT8CaYiK/TbZgEVFZCovLlbAJRMxC5UTI/4?=
 =?us-ascii?Q?hVAUnPEQBTeIcHTbuNBJMU2kpRItmKgl7utDyyneFBLljOkevuMaOl9u+Fm/?=
 =?us-ascii?Q?dDzestPFqz1I58rgPm7EWTNSm/6hzcrBpEJ7iDrzmKPGmof2Ns+rnDjgHNIF?=
 =?us-ascii?Q?dYzqsENhyWbi1Zf8eFffbBiEe6iyLwhcNwSEbjo9Dl0khCEQkLJIPVzZfBL9?=
 =?us-ascii?Q?JRA3bVEzStJWUM2Wo8Kg0tHYmpEhwNcIe6tono6LMuTPwk9rHpGYcPeVh2DD?=
 =?us-ascii?Q?EoSqmoGSdzSyhFTOMfbnqdTiyp8roVn2HUuUIy7KlK/jZo3w8TUQrQfef2+/?=
 =?us-ascii?Q?LmokGLq1fFpZYwnmsmMDfurECMLT2XSr2TuQWlCiw7e3iiX823G4vZB957S9?=
 =?us-ascii?Q?amYdELoKGWHReM8FMdUte9F2rY9YSWDTVlYi0GnoKovxH25mh5iK9jnn6646?=
 =?us-ascii?Q?FrxnfAUKkSjTP5dnWWhjD5HjZcy+D7pXJHaPnYP47nm4ixX3AAymv4UZEBzf?=
 =?us-ascii?Q?mUQbiBY3wYko6oJhfXXUdwhDZmwHMRKrV5Aafxy8oxw2v+mXdO3Mmil4Nt9U?=
 =?us-ascii?Q?Wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: aZ1EN/0UXA+E2xaavkGXkxFLQoIvD5MJD/AFGOZXwhL28qNRHhBzUOEiOx1ZfrIqmk9Kyb8bbRUwOKY3lCtYL+jwQS8Ns5lmS2TFgrx2oh2mDDAx+4TE1fOFStk+K69OHlKNA9hCN7HL8PicENRC4NptNDRSdT9R54+kKadP1B+CO49hWywF0JuSDz45IuxvLgndQSZYuWyCILo9dNN+hk8jBB043IO7Cq5BNav4QQpMQM7SkYXeBU/CxQWFGpgAECO8WSq/QpJWlCrzSj7MP+K/zCLvy5vCEo0+BfxCteR4fyOOlIrZsCrk9qsK5wBeWarQREVLt8c8v9ZLJAG5kAQMPEolfX0/NPJqN2DuuEq5A8KLEpY83j1KNtf2RbM19SNzaLgjytAzdc8WaDJFpn6AZPfwaRVQEae25LJxujNkMPU5lWUi4HuQ8tuWu+Z7wt9QNBUkr+k/i/lq+m0y2qGS2bRUabZfQwHiXdpc1zP29VcV6IClvaygJTFpm5gxGU1qhP29a1/25cXVr23Hi59UVO3HPn4p9Uk1ZKcmozHxkkOyXJr3vdECA6uPKr/JwlPN0KLIo3CL1Ntlh+O+rtGX+rUKfnaylH3NDeJ5NrVBBqyLKi78qRvzq6De6l+i5txP151JzyUYHFe+i9fHB+2Mrf4dEuMz+5NmX6TvEiP2D6/QNtAmTysCG54YBNON3r5WLpXqZUFvAERxCKkHaEJ9czTdgXRedcF1xTsToUe1cuvtrYbXRAjW0YVWCq9hnsnHU1yQ30LjA8TLyYHDNxKeotDO6yelaF8K5klY+IPrIiB8Vn6p2zg8Qoab1uyv
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 658ac214-dfc5-42b3-0972-08db0d77a047
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:06:04.5273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QUbDNBhoiPMJMNktMwvedg1/JWzOyKCcsk0dBbNg1oAS4eURJ848tdArAHtE/TZ+EHnmzoKppJ+y9oJvv71LUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302130036
X-Proofpoint-GUID: Tt99OGdwYz6ci5A-Is6ZCgOprr9Q7x68
X-Proofpoint-ORIG-GUID: Tt99OGdwYz6ci5A-Is6ZCgOprr9Q7x68
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 93293bcbde93567efaf4e6bcd58cad270e1fcbf5 upstream.

[Slightly edit fs/xfs/xfs_bmap_item.c & fs/xfs/xfs_refcount_item.c to resolve
merge conflicts]

During a code inspection, I found a serious bug in the log intent item
recovery code when an intent item cannot complete all the work and
decides to requeue itself to get that done.  When this happens, the
item recovery creates a new incore deferred op representing the
remaining work and attaches it to the transaction that it allocated.  At
the end of _item_recover, it moves the entire chain of deferred ops to
the dummy parent_tp that xlog_recover_process_intents passed to it, but
fail to log a new intent item for the remaining work before committing
the transaction for the single unit of work.

xlog_finish_defer_ops logs those new intent items once recovery has
finished dealing with the intent items that it recovered, but this isn't
sufficient.  If the log is forced to disk after a recovered log item
decides to requeue itself and the system goes down before we call
xlog_finish_defer_ops, the second log recovery will never see the new
intent item and therefore has no idea that there was more work to do.
It will finish recovery leaving the filesystem in a corrupted state.

The same logic applies to /any/ deferred ops added during intent item
recovery, not just the one handling the remaining work.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c  | 26 ++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h  |  6 ++++++
 fs/xfs/xfs_bmap_item.c     |  2 +-
 fs/xfs/xfs_refcount_item.c |  2 +-
 4 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index ad7ed5f39d04..4991b02f4993 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -186,8 +186,9 @@ xfs_defer_create_intent(
 {
 	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 
-	dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
-			dfp->dfp_count, sort);
+	if (!dfp->dfp_intent)
+		dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
+						     dfp->dfp_count, sort);
 }
 
 /*
@@ -390,6 +391,7 @@ xfs_defer_finish_one(
 			list_add(li, &dfp->dfp_work);
 			dfp->dfp_count++;
 			dfp->dfp_done = NULL;
+			dfp->dfp_intent = NULL;
 			xfs_defer_create_intent(tp, dfp, false);
 		}
 
@@ -552,3 +554,23 @@ xfs_defer_move(
 
 	xfs_defer_reset(stp);
 }
+
+/*
+ * Prepare a chain of fresh deferred ops work items to be completed later.  Log
+ * recovery requires the ability to put off until later the actual finishing
+ * work so that it can process unfinished items recovered from the log in
+ * correct order.
+ *
+ * Create and log intent items for all the work that we're capturing so that we
+ * can be assured that the items will get replayed if the system goes down
+ * before log recovery gets a chance to finish the work it put off.  Then we
+ * move the chain from stp to dtp.
+ */
+void
+xfs_defer_capture(
+	struct xfs_trans	*dtp,
+	struct xfs_trans	*stp)
+{
+	xfs_defer_create_intents(stp);
+	xfs_defer_move(dtp, stp);
+}
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 7b6cc3808a91..bc3098044c41 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -61,4 +61,10 @@ extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
 
+/*
+ * Functions to capture a chain of deferred operations and continue them later.
+ * This doesn't normally happen except log recovery.
+ */
+void xfs_defer_capture(struct xfs_trans *dtp, struct xfs_trans *stp);
+
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index f4d5c5d661ea..8cbee34b5eaa 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -541,7 +541,7 @@ xfs_bui_recover(
 	}
 
 	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
-	xfs_defer_move(parent_tp, tp);
+	xfs_defer_capture(parent_tp, tp);
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index a8d6864d58e6..7c674bc7ddf6 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -574,7 +574,7 @@ xfs_cui_recover(
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
 	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
-	xfs_defer_move(parent_tp, tp);
+	xfs_defer_capture(parent_tp, tp);
 	error = xfs_trans_commit(tp);
 	return error;
 
-- 
2.35.1

