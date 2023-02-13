Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B7BC636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjBMEFr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjBMEFn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:05:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254E8EC59
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:05:42 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1iP1Z026123;
        Mon, 13 Feb 2023 04:05:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5dgcZNiUWe9vg4m3rNRTUHGkWht2woznPM4wvCl8LTw=;
 b=eNglSKoHb3uRIXO1inXyxn8Yr6/hM0u9gXFEAqaShhFQ7ms95dqNg3oYcTlJK4GInfS5
 0j6jL7jqXff5An8B0bOKnBAxoItby/cfWt4OIZrUc7yQ20o7seBnJ9IIsI9de7LD+ks+
 wLTCEX9qsnL8Fbr4Ev2TNRk324Vx46/Wb24IixpKUF4f+ZuP/CVj0vwf6lroXtY1s1oh
 QBXTFNsNjhDBOwVpsUhFQDAXKNLnzf/PRL+QLxD5ek+usZqbaHUzF876+3zaxwr6UlAE
 J42dBt+WyrgQuMRtkD0B42dKyqWU5nA+ADjwvg/4hGl2q9U7ek2jPOwJYM6eA4/kY9Fo SQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1m0swqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:05:35 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D2iUUi028784;
        Mon, 13 Feb 2023 04:05:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3a987-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:05:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3hEefCxjQolkDh7tygb7uldmYbKCNHKwV5ZCBDMSVZ+QlisM8r1S7r80enb53YQH6j2Og5Lf8CAk5UqNoAg+N3NZ3dhPMUC08zhq0miSuhYcWbMKXU77z0H3TlAtMUawrJGyQRZKk59vSNM8xMib4ry8GaLZKta7GMTswSm9EdZV6miP1eACIOcRFTIGDDosGkGaq3TtMDscnGk7K/LQ7GO+IhIyUiusIkEh2X4PiKfFFIUw4wiaPljk2ei96dpvthhfv36gd/FGW/AtkcoFbe2gwagnASbULRs89XRtUufbLV0dfj+FUIFSILM//F6ybROIiP8ZbabHFRc1Kxlzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dgcZNiUWe9vg4m3rNRTUHGkWht2woznPM4wvCl8LTw=;
 b=cyAMoD8OXYk0Yku3fXpuBD8/zLfLHVMqVgTb94vuQlhAq2aQsBpQ13cTRv9ZPNbve2g2OzQV0pno243+9IHzky6uqq/uMKgUHFHLJmzn8Y7EJyJ/IX5bcgw5CkCa5/CnyzfRGyA252OfBz3M4mQXMqIEhWnfYTUV9+TOObR+ERr6YS55c2OLzCp0NCra3j8M6VIneUbf6LrXDprNLtNbc3cmhsYO49oge4MHaJOktbzlmq2wA2JuqulEXyvbD1HvIqeiaUpY6h/Xaq0OWzgimnjV3a7xLHgqzShI6q3VoQcNhY72c0QbSnDFg1chx1wTk+gjBfGQGZrii6vxb4yR/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dgcZNiUWe9vg4m3rNRTUHGkWht2woznPM4wvCl8LTw=;
 b=JsJml+PBPLS5SkMUNJvlXyz6iBcjfKv6n4K4/c+FuNo0OfCDY6kVkUnzpZb2yLifottqEB2ibJSnt4m9ItKH9iIwq9AqMORX3W4C3jQAFWUfd6nQHCdo9pqmiQQfjqfPezw3yaEoXHve8NolLnnlT4K43U6MMnY+mhXQzVdaLBs=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB5225.namprd10.prod.outlook.com (2603:10b6:610:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Mon, 13 Feb
 2023 04:05:32 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:05:32 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 05/25] xfs: merge the ->log_item defer op into ->create_intent
Date:   Mon, 13 Feb 2023 09:34:25 +0530
Message-Id: <20230213040445.192946-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0008.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::10) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: 83085a61-00e7-4f0e-4860-08db0d778cd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v/AVGiAm9vEbT5T2vhgZ6wNeTJjvZU3dptGXJ25ADLVMsZy3Rq65tcWecw1uDNAIGucKxG0jj17CG3yiU96DvZrddqX+kNkvYcv/Os5UV2/OrYupACPhbmVeG8k8vXE8bkl9XeA0zEX922oPRbWyXc1WD4GwFTTXgPluO6rlyrmUXTmVIXjW6bDCIBJWdP5pDW6xrh/9QoI5NuD0Nd9kHS9aVukZYD+FouTZ7aC0RdMwqCBehjAn2J00qvD5WdH0y22TiXhvys6hhoIqxlx8K2ur5LkhJDaGaKet8ewLPwaX4jK08W86f/hhbqIwJ7EyJFRMsR8Le4u8UGb8S+3b+onsIUFnf8sw27FkI1T+OiVyo0Ttue09K28PyEOwyTwbYsjZmmHnWSoIKERFBvL4hEH08EkwLH7rKxfit7E3+Wu+ZErDJaft18UmLrRu5p740ybWLGCGCisN6wIlaQPXHKUArDW9TEkMskrqpO4zQ6+18/ZyoH3BoLTFUGJHXyHSDGeVA153CBX34VyPH/BnaQ+gkArCWTcPw80SMtece1fQ2nOBoVQiFs8G9YFsdzW9vsSTMopo7lAwwXsPO3Bex2fRxXXDh7PVgh/yw4GWpfBV+UOKgTIIO1yqmlqobmuYWlwAGt6gmCIBXSFtd/fUug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(2906002)(8936002)(36756003)(30864003)(5660300002)(86362001)(2616005)(83380400001)(6916009)(4326008)(316002)(38100700002)(66556008)(66946007)(66476007)(41300700001)(8676002)(6486002)(478600001)(6666004)(6512007)(1076003)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yKGB4m5mfrtx2go/GWYgQlfyGzJQnb8nZAXJ19toeCM/8MVyWNgDp5kAH4T7?=
 =?us-ascii?Q?PdgkjNz+DZ5az3sGiy7eDdUM+agnTKxMJc2InWhnWjqBHum8T/HuSdEcX69x?=
 =?us-ascii?Q?wr9DuTkVEL9xxS1NeJf1SsFVCcO7rQ6bePJxnNNIozLRIrTO5vIQJDX5wDg1?=
 =?us-ascii?Q?EQFN0i80baJHae8mm5Bej6CQQSOSRZ/wBnaJ0nBb0xWj9OTGn3eD4vA/d0sM?=
 =?us-ascii?Q?jngs+p6QSQFmdMqbdVSHxn56gUm88l58kobWg6tN3iOsPnlW6Q65lwN2INq9?=
 =?us-ascii?Q?AIZkHI7E4gTsnxKq0iy+bnesOeUZm59Vv1SME8ar2t5JwY5GrO/DGlma8U3V?=
 =?us-ascii?Q?odvYtJlZ+BaT5ExdkD8CcXxQZm7k8A5SISrBZQRZitek8H6tpQ//gCZ6xLz1?=
 =?us-ascii?Q?1zRkCOpyQ5HBHYgMOP2Z1ECpFnGKZ4cU0dqAhHptDOdT/2SKt6TInacEiBVP?=
 =?us-ascii?Q?+luSbHqY6IuTm4V63b4aqv6Nk62GiDbZq5EU8pB9MM5YyEDNXnjjvV6HH0gv?=
 =?us-ascii?Q?J3mnzygtjZcLjWPlng4hU5IqW9Ry+EaduKHmzve8oOJ2tXG0DN3hiIUnxjUt?=
 =?us-ascii?Q?W7LXiXMtUy+1pJm4MHCHv6KKF1rsscTQeJSvwX5M5gRQ3FXLXjDMSU1t7bZO?=
 =?us-ascii?Q?FhSXjdT0W79NR5wmcuPdx1xCC30DGPqryVM/vbnVZPd4qN20euDrxqv9ny2b?=
 =?us-ascii?Q?sOkvhNDkPHZ9Uoc2hZTEhsr1x0veakAPeuYd+spF8zthI+G2BWghLU1SFX4n?=
 =?us-ascii?Q?UJu0SOUgml0UR05cvl6kDiHTKAXg+NMDaqIrZaoQ2y961le+tU+AbHS6bWzh?=
 =?us-ascii?Q?r1MDAVGVQChivCD+yMxQdwjG7pIOWaKj/wbIyc7jfDwCEMagppEJV4dPfydf?=
 =?us-ascii?Q?mCYh8njUUKNi09ECzM/Unt27Pt+B7152QflPsv2SJeWoqtrLUy88J6aCWIlj?=
 =?us-ascii?Q?bmWL2qrNVznT04SFUhU9RHEqlXzbZnxNbOL1yGZbxXVS2bT1ZH8rnG0gA/EK?=
 =?us-ascii?Q?aNrRDpO1ufPnOyByrNeG4EcjumRstGqAAvDk/LyNX6IzwfuZizve3gh/ZlAV?=
 =?us-ascii?Q?sbxRhQyPwR2IOrsBCuUU+EPFn23wikDW3vfyoO7Lyvc6iYO0q9ChnQYLDAOB?=
 =?us-ascii?Q?STnzg/cunud1X1ppFwycKNY4ciIkksxiu7OUUCV/FCf+vLbrDEQHEyy+AZgI?=
 =?us-ascii?Q?bFQNjpLXuZTT+hgLhOZix9Q+spsIdDqQT5enGqGmAJX8JsuFKgf5aAPZCWmh?=
 =?us-ascii?Q?ZRSn+Ai9tOAjnkoE4aJYYGLkGGVnb28bLdSc5MoFA0KHIIxoFl/8grg+B0Ps?=
 =?us-ascii?Q?MtHbNosgqB59GqX76ZysloqiQd+6Mo3+qYtWUVA1PeuBPkOLr94QHfzMFUYn?=
 =?us-ascii?Q?Hk2EGgo/rwhevQfjQyYKCZSkj4EedFfdSB08epIfOeaz1wxlEXjhcvJi5R39?=
 =?us-ascii?Q?naMHdyKu3DkecsQ8HSIuvYEiUFRODwnJELxh+XJtxvrJGKoFPmqccccT6GGN?=
 =?us-ascii?Q?iQDnuSxjZKADSigMKJwS1aAxHdZ2deuMpye3VVNzzIBUPgN32e9dVLnQseWs?=
 =?us-ascii?Q?96+5moPlG0QSYBpr47RLkYehjvWYZgABQFkBsNaqDfkwoq8MYOX6Xgx6iTRp?=
 =?us-ascii?Q?bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /vU1FbrleAxJ+9DMfDDPKg6yEFM7ISAhqdKpgv3F0NTCQFc6QHcye0MJ2bafo50p6BSiMBQgREdgaC9KuJpyb8r+Yz/ezTPoqH5SFgtzxDo9/F1x0Lb3JgevV0MVf8clRDfuUjpMwvMWEsb+4+72pF7DAdpx3sb2pigtvT8xcdllBRbqdiV6o6gKlvwjqw7UOFFDQPDR+fLrDDG+/JMyJzR72qhuzOusw+zZAPlpLhrjM20pLThPmiQWWX7EiLy8X3az7ochbmrp3xvdxizCwBnm6qZgOUiLVIjV1T655MogKnaHoq/7w0lMabdQzwvlTsKCiKbGtnXHMallHZu1mXayowoLDyQf1GTTwQlYB83jKM6KKhff2426E/9QBVgFUenr6yG9AJO6kwBNlXQYRHN47qBYm6PYTCV/pj0e/0frOA9rcvhAdfJgYmeOqsv0nfZlDVezTB/qO9XFATTF63NNpNct9Vs3XtV5WO3GXoEzj6bqSONDjyXCm5IjtrUgDGEzB8NbCriky0NZqU4h0knztIOfiY7iSE0T/vhj7Ph2Od961QNj27pLNtKf56c7VsZnOOHnJoEOdC0y/ppRmxvDznSHJzvhnW3TXeIbgJFWNZVH84ToTyfmcoRfC4kH1sz6imAdHasiIGAjAZ+MyxCxG+PsYnq4A41c9mEhJtbqLy+58/AGTFAm4RDxEunhlNmx4xknt8u0yfFk9PJFYSaXN9LbUqe0GegZ1eD19xhA6WmOEooz2PKV8C5dmYo+u7Lx6HzGoOtp3Ij5d56eLaAIHKTCxRaYEb2NYJs9KWA5bADku/hb6db33zqRHKiT
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83085a61-00e7-4f0e-4860-08db0d778cd4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:05:31.9767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 96c2kKrUPc8a5CG7RApNLRU5ZSdvbskH+QnblZd+yfkr6OtpjG60em6uzo883GlNT4BVGIpNlFidjRyOzib5jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302130036
X-Proofpoint-GUID: jaO_bAJgNKKFZaSEuEO7438s518Un6DJ
X-Proofpoint-ORIG-GUID: jaO_bAJgNKKFZaSEuEO7438s518Un6DJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit c1f09188e8de0ae65433cb9c8ace4feb66359bcc upstream.

These are aways called together, and my merging them we reduce the amount
of indirect calls, improve type safety and in general clean up the code
a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c  |  6 ++---
 fs/xfs/libxfs/xfs_defer.h  |  4 ++--
 fs/xfs/xfs_bmap_item.c     | 47 +++++++++++++++---------------------
 fs/xfs/xfs_extfree_item.c  | 49 ++++++++++++++++----------------------
 fs/xfs/xfs_refcount_item.c | 48 ++++++++++++++++---------------------
 fs/xfs/xfs_rmap_item.c     | 48 ++++++++++++++++---------------------
 6 files changed, 83 insertions(+), 119 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index a799cd61d85e..081380daa4b3 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -185,14 +185,12 @@ xfs_defer_create_intent(
 	bool				sort)
 {
 	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
-	struct list_head		*li;
 
 	if (sort)
 		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
 
-	dfp->dfp_intent = ops->create_intent(tp, dfp->dfp_count);
-	list_for_each(li, &dfp->dfp_work)
-		ops->log_item(tp, dfp->dfp_intent, li);
+	dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
+			dfp->dfp_count);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 7c28d7608ac6..d6a4577c25b0 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -50,8 +50,8 @@ struct xfs_defer_op_type {
 	void (*finish_cleanup)(struct xfs_trans *, void *, int);
 	void (*cancel_item)(struct list_head *);
 	int (*diff_items)(void *, struct list_head *, struct list_head *);
-	void *(*create_intent)(struct xfs_trans *, uint);
-	void (*log_item)(struct xfs_trans *, void *, struct list_head *);
+	void *(*create_intent)(struct xfs_trans *tp, struct list_head *items,
+			unsigned int count);
 	unsigned int		max_items;
 };
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 243e5e0f82a3..b6f9aa73f000 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -278,27 +278,6 @@ xfs_bmap_update_diff_items(
 	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
 }
 
-/* Get an BUI. */
-STATIC void *
-xfs_bmap_update_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_bui_log_item		*buip;
-
-	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
-	ASSERT(tp != NULL);
-
-	buip = xfs_bui_init(tp->t_mountp);
-	ASSERT(buip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &buip->bui_item);
-	return buip;
-}
-
 /* Set the map extent flags for this mapping. */
 static void
 xfs_trans_set_bmap_flags(
@@ -326,16 +305,12 @@ xfs_trans_set_bmap_flags(
 STATIC void
 xfs_bmap_update_log_item(
 	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
+	struct xfs_bui_log_item		*buip,
+	struct xfs_bmap_intent		*bmap)
 {
-	struct xfs_bui_log_item		*buip = intent;
-	struct xfs_bmap_intent		*bmap;
 	uint				next_extent;
 	struct xfs_map_extent		*map;
 
-	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
 
@@ -355,6 +330,23 @@ xfs_bmap_update_log_item(
 			bmap->bi_bmap.br_state);
 }
 
+STATIC void *
+xfs_bmap_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count)
+{
+	struct xfs_bui_log_item		*buip = xfs_bui_init(tp->t_mountp);
+	struct xfs_bmap_intent		*bmap;
+
+	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
+
+	xfs_trans_add_item(tp, &buip->bui_item);
+	list_for_each_entry(bmap, items, bi_list)
+		xfs_bmap_update_log_item(tp, buip, bmap);
+	return buip;
+}
+
 /* Get an BUD so we can process all the deferred rmap updates. */
 STATIC void *
 xfs_bmap_update_create_done(
@@ -419,7 +411,6 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.diff_items	= xfs_bmap_update_diff_items,
 	.create_intent	= xfs_bmap_update_create_intent,
 	.abort_intent	= xfs_bmap_update_abort_intent,
-	.log_item	= xfs_bmap_update_log_item,
 	.create_done	= xfs_bmap_update_create_done,
 	.finish_item	= xfs_bmap_update_finish_item,
 	.cancel_item	= xfs_bmap_update_cancel_item,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index d3ee862086fb..45bc0a88d942 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -412,41 +412,16 @@ xfs_extent_free_diff_items(
 		XFS_FSB_TO_AGNO(mp, rb->xefi_startblock);
 }
 
-/* Get an EFI. */
-STATIC void *
-xfs_extent_free_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_efi_log_item		*efip;
-
-	ASSERT(tp != NULL);
-	ASSERT(count > 0);
-
-	efip = xfs_efi_init(tp->t_mountp, count);
-	ASSERT(efip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &efip->efi_item);
-	return efip;
-}
-
 /* Log a free extent to the intent item. */
 STATIC void
 xfs_extent_free_log_item(
 	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
+	struct xfs_efi_log_item		*efip,
+	struct xfs_extent_free_item	*free)
 {
-	struct xfs_efi_log_item		*efip = intent;
-	struct xfs_extent_free_item	*free;
 	uint				next_extent;
 	struct xfs_extent		*extp;
 
-	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
 
@@ -462,6 +437,24 @@ xfs_extent_free_log_item(
 	extp->ext_len = free->xefi_blockcount;
 }
 
+STATIC void *
+xfs_extent_free_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_efi_log_item		*efip = xfs_efi_init(mp, count);
+	struct xfs_extent_free_item	*free;
+
+	ASSERT(count > 0);
+
+	xfs_trans_add_item(tp, &efip->efi_item);
+	list_for_each_entry(free, items, xefi_list)
+		xfs_extent_free_log_item(tp, efip, free);
+	return efip;
+}
+
 /* Get an EFD so we can process all the free extents. */
 STATIC void *
 xfs_extent_free_create_done(
@@ -516,7 +509,6 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.diff_items	= xfs_extent_free_diff_items,
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
-	.log_item	= xfs_extent_free_log_item,
 	.create_done	= xfs_extent_free_create_done,
 	.finish_item	= xfs_extent_free_finish_item,
 	.cancel_item	= xfs_extent_free_cancel_item,
@@ -582,7 +574,6 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 	.diff_items	= xfs_extent_free_diff_items,
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
-	.log_item	= xfs_extent_free_log_item,
 	.create_done	= xfs_extent_free_create_done,
 	.finish_item	= xfs_agfl_free_finish_item,
 	.cancel_item	= xfs_extent_free_cancel_item,
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index d5708d40ad87..254cbb808035 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -284,27 +284,6 @@ xfs_refcount_update_diff_items(
 		XFS_FSB_TO_AGNO(mp, rb->ri_startblock);
 }
 
-/* Get an CUI. */
-STATIC void *
-xfs_refcount_update_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_cui_log_item		*cuip;
-
-	ASSERT(tp != NULL);
-	ASSERT(count > 0);
-
-	cuip = xfs_cui_init(tp->t_mountp, count);
-	ASSERT(cuip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &cuip->cui_item);
-	return cuip;
-}
-
 /* Set the phys extent flags for this reverse mapping. */
 static void
 xfs_trans_set_refcount_flags(
@@ -328,16 +307,12 @@ xfs_trans_set_refcount_flags(
 STATIC void
 xfs_refcount_update_log_item(
 	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
+	struct xfs_cui_log_item		*cuip,
+	struct xfs_refcount_intent	*refc)
 {
-	struct xfs_cui_log_item		*cuip = intent;
-	struct xfs_refcount_intent	*refc;
 	uint				next_extent;
 	struct xfs_phys_extent		*ext;
 
-	refc = container_of(item, struct xfs_refcount_intent, ri_list);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
 
@@ -354,6 +329,24 @@ xfs_refcount_update_log_item(
 	xfs_trans_set_refcount_flags(ext, refc->ri_type);
 }
 
+STATIC void *
+xfs_refcount_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_cui_log_item		*cuip = xfs_cui_init(mp, count);
+	struct xfs_refcount_intent	*refc;
+
+	ASSERT(count > 0);
+
+	xfs_trans_add_item(tp, &cuip->cui_item);
+	list_for_each_entry(refc, items, ri_list)
+		xfs_refcount_update_log_item(tp, cuip, refc);
+	return cuip;
+}
+
 /* Get an CUD so we can process all the deferred refcount updates. */
 STATIC void *
 xfs_refcount_update_create_done(
@@ -432,7 +425,6 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.diff_items	= xfs_refcount_update_diff_items,
 	.create_intent	= xfs_refcount_update_create_intent,
 	.abort_intent	= xfs_refcount_update_abort_intent,
-	.log_item	= xfs_refcount_update_log_item,
 	.create_done	= xfs_refcount_update_create_done,
 	.finish_item	= xfs_refcount_update_finish_item,
 	.finish_cleanup = xfs_refcount_update_finish_cleanup,
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 02f84d9a511c..adcfbe171d11 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -352,41 +352,16 @@ xfs_rmap_update_diff_items(
 		XFS_FSB_TO_AGNO(mp, rb->ri_bmap.br_startblock);
 }
 
-/* Get an RUI. */
-STATIC void *
-xfs_rmap_update_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_rui_log_item		*ruip;
-
-	ASSERT(tp != NULL);
-	ASSERT(count > 0);
-
-	ruip = xfs_rui_init(tp->t_mountp, count);
-	ASSERT(ruip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &ruip->rui_item);
-	return ruip;
-}
-
 /* Log rmap updates in the intent item. */
 STATIC void
 xfs_rmap_update_log_item(
 	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
+	struct xfs_rui_log_item		*ruip,
+	struct xfs_rmap_intent		*rmap)
 {
-	struct xfs_rui_log_item		*ruip = intent;
-	struct xfs_rmap_intent		*rmap;
 	uint				next_extent;
 	struct xfs_map_extent		*map;
 
-	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &ruip->rui_item.li_flags);
 
@@ -406,6 +381,24 @@ xfs_rmap_update_log_item(
 			rmap->ri_bmap.br_state);
 }
 
+STATIC void *
+xfs_rmap_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_rui_log_item		*ruip = xfs_rui_init(mp, count);
+	struct xfs_rmap_intent		*rmap;
+
+	ASSERT(count > 0);
+
+	xfs_trans_add_item(tp, &ruip->rui_item);
+	list_for_each_entry(rmap, items, ri_list)
+		xfs_rmap_update_log_item(tp, ruip, rmap);
+	return ruip;
+}
+
 /* Get an RUD so we can process all the deferred rmap updates. */
 STATIC void *
 xfs_rmap_update_create_done(
@@ -476,7 +469,6 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.diff_items	= xfs_rmap_update_diff_items,
 	.create_intent	= xfs_rmap_update_create_intent,
 	.abort_intent	= xfs_rmap_update_abort_intent,
-	.log_item	= xfs_rmap_update_log_item,
 	.create_done	= xfs_rmap_update_create_done,
 	.finish_item	= xfs_rmap_update_finish_item,
 	.finish_cleanup = xfs_rmap_update_finish_cleanup,
-- 
2.35.1

