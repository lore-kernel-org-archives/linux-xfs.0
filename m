Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47732C742A7
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjCHWi1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbjCHWiW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:22 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C67D62FC7
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:20 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328Jxtd9028463
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=GM5EA2IEsly3XIAzp+xeaVY/Stv47UmPKKPymqi60/0=;
 b=eeAKaDD5Qt8QjLKAAbMZwiFLQu+kIc0m0LRPWuNeibDuHtaBIgfkZ5eoo15S16YSKHIP
 1Blnmi9dVsTmlFI6N1P+95cu41oFrGVCa7RwM87uWCKQwmj425mQJ9m+n2f9FTq+1U1F
 9cez9yp9GYwQFllRomuA3rOUYXfLoNV/WVTO3XhZbrt7BB4g+/bpGsxIf777Y3u0WXBP
 VRYV+mAg4XGzLhRmAYUVSRRZxNn/D+Gow/BjTu5k4wo38aYcZh2C83N0IY5cMBZfVlh2
 xcAfE8yRObvlXrb+neaAZfqAnkZeYfsipcyLtw5riRjOxPGUKjTQZFdrJr4heQBdwrmj pw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418y1ef6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:20 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328LM2BM021689
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fr9dws9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RlAF12jl831pWbwjXb2hwmqmSg7bjTxjXgZFBuwP3psJnVPzX5sA/VNdEsjVga09mukZyJUe9QZ3wqRyF692wFutgUetD85b7ywXbGhhm89eL6fvLdLEO0tZpXaT9GNbrEGbolMaFCr5d1CiF8k4CEkrXcJUcB3jBlqCUUPM+UllWhtrW6mvLmlysn+ar91y9VvnNVbanQdOpf++9k/LPIB8pa5+nEUkUT76X1yzfMMYxX9NRtMoyGBdFZnUmpWQOj8YndAmUtcqeiMIWBvfeX1xwUm4zVV/xTV1jREd0WKwUUhxHN/HkPPGrGThIaYJXHBLtqiz9DzaNgGR5ae4xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GM5EA2IEsly3XIAzp+xeaVY/Stv47UmPKKPymqi60/0=;
 b=aw16LfEqpEY71JWKykfBlIzpZoR/hOVr9tk8bXwVdIcxBhocTyVqHRKcvkUckD3mXWqqg2rAcC3IWpqzbAkQizkuitevgx+e9uY+ycJP0ld2iNzg7h8uRQ9RaU5axUxh2oE1RVgWGTF2VpMAlOtRp5cFDyKl+USZL1NciHVX1Dwev0pkDJ/MctDTnisgohhv0wPNOvROExDUFTNC87NBl3qylAfqo+eFIALGzkwuapEjGybg/nCKmwj/Y3mVYZBIIe1G9GLokxmre8uph4DBn8qST6F9J/oe74FIz6ODWsDS9Z5FOe7o533nAX/cOlU4RBOiUrAy9UcsKkTMIkJiMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GM5EA2IEsly3XIAzp+xeaVY/Stv47UmPKKPymqi60/0=;
 b=plDHr8uR+lNfZYqkGxwlxW2C09FxlCLOtXJN94B1sFICRBUI7cGP9neXlo8BGWVUO0KgpWxPzYBdByjGHJXAFAkOfX8K6zku2v4dcRD7JWR08TZBo3F0Vz4mst/HEDD21FB/k5+C89x1oFE7jA6SmeB9xqVtBG/V5sP69O9j6jU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5708.namprd10.prod.outlook.com (2603:10b6:510:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Wed, 8 Mar
 2023 22:38:13 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:13 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 09/32] xfs: get directory offset when removing directory name
Date:   Wed,  8 Mar 2023 15:37:31 -0700
Message-Id: <20230308223754.1455051-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:a03:40::26) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5708:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e154043-c18d-4f40-56be-08db2025cd35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fh1BtLxjDea6s/Ev9Y+kgwQ29Lq17NqQ45wW4ff9dNW9/sFogfvK2f+epFrvPgmgDZI3HkMs+q0DWBOOUcErnlHTccOUtUI7BMeqFNcDtCdUtMOz1FSVsDPeX1zRpVXs5qDbIpG60DMVcD0Jc1T+qBLBe2t2bGOk8f8vi+/Sl5iRGGRZSZ7WURh8GWmhNNJh/uTkSwRSB23XvkemI3dS7p29jiPvVfvZoaeq4kgjKKdaL9HGb/3zrbK3s+f6TBoQxHowy1VslEe+MxeNebBC0sWTc6dgVbkccdXWKIXNqJwjhpsV/ZExf98Bm8cwxKh0+9hmCeGzXA5ZrnUXVz3yVjeU4Q9Pt+IIW7++QVgeQoOeW/tseHWo2KmX6zxO2iM4vyUHUgjZUV+mnvTNSyXkbbq1Idukur5B6Dh/Irg0dnenQ2GZ0eS2ZqZQThgV0Pi8+QN6tW7O+V0+EWB9xwEcMxHUW5vkRXVLqqBLjczt+REoqywQxYJ0Q3fnL6pXU3zYFKvyVbfu9FzABEtDnhCRFPiVDcaECiPDbz6k8JAP5C2GVPdygjs/20DEZCMizQDdi0cUev4N8rkUBbVG/2pVZqs0jAAzjpxa35qWD6MVlR5vth1wtTpxceM3Ji2BrlatObZvRNkv8JjXnx7MwQ+CGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199018)(36756003)(6666004)(478600001)(83380400001)(6486002)(6506007)(186003)(9686003)(1076003)(2616005)(6916009)(6512007)(8936002)(66476007)(66946007)(2906002)(66556008)(41300700001)(8676002)(86362001)(5660300002)(26005)(316002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?udy2ZDbTa820kwt8gf3lsMXfqY5oxc9uQd8tQPUW0JG+yZQbBsfTZJCuF4WD?=
 =?us-ascii?Q?X6qSuQB/eaw4ZDN9G5c5n/qvieVHjQz1Z5/u0e4piss9HQVolwq+mgQl0MJv?=
 =?us-ascii?Q?kNMUTFV6EInIR/TKiDGQeDFLH6HAhGVjgSZ058s4Ce11vs9KvL9e/jNtqnvJ?=
 =?us-ascii?Q?n8G3vosDsWpxqwIHbpazIwVyp8L182d1jvHDl91HloZLk8C3laC6QEzeWrTs?=
 =?us-ascii?Q?6oMbkOteanOtoSeH+AXxeZAIhbcUvng5ErFwEC0DKr0JtJ2QKp8dVqagXCUM?=
 =?us-ascii?Q?5tp7EEtCBb/UJeRIFI9geD479dK2TA0/5YDgbLwjbODafHn3MTMolCp4RaN3?=
 =?us-ascii?Q?xz1wDIXU2bfsjr5O7JO6c8BTdscWPglE8csSkEj5CAyB1CWmB7kNMwetNej2?=
 =?us-ascii?Q?RjuX8DCPubN9ihoLJl2UHmHvdPdhpV7rDj3NBP2zlG1RnYnTxfkpqrKHGFe7?=
 =?us-ascii?Q?wGoCK5mj5E7e6SiFRHN9MPCtFYwtzs9yKlEE8agyTUjeyCmrMwcwgnIW8uAC?=
 =?us-ascii?Q?u3QZdHGa/6Ef+B3yy/GRV+yxjJ0B+BWJHAw9h8uL3awgVgiE0dxduwYDbcPA?=
 =?us-ascii?Q?/hgOEKMQpyuuQ4XJgsn50eA60v03VC/MuGPcEv7CEkWCDQOkWGLIKYVx6/VV?=
 =?us-ascii?Q?rgPciRTo/BWkXYvI2EshXP00Ll3yhvBMait0mRZYE5xnzANOgTupgUR4aKOA?=
 =?us-ascii?Q?7brtya6jl3GZO5i0GxCVkhZDCInHKX5vv4XUxDl1uYoRICg273okj/5e6gVJ?=
 =?us-ascii?Q?vuU5jSJi9AUQ9RLgF2qdJsqS84gqRfbSpRe+xxegOkk6Q8fa4gGsvKut34bX?=
 =?us-ascii?Q?wDpnsE4NhMR5711bM8OwETyow+vRwggIMXZ0KGdfeoqTunl4XCK5ivnLpjmy?=
 =?us-ascii?Q?mGBUcsedRdZHiNQ0UwtNn+IXODhdEXGS2nY76ztd2c7b4r0ll9U7xChj1Kfq?=
 =?us-ascii?Q?7wVcJzzclzcXM4s/ye4PPosncCjyRob3r0zylO6U3is9zVkGzEgO80WvLeFo?=
 =?us-ascii?Q?C2ZC73lw/xuIjdYFXJLWuD+d9JzSfQKdTt+kSw0CPu8bbJXHYiE+xNb8Xy4z?=
 =?us-ascii?Q?Yx9IvtPAviJXj1bBlIHFkgAw7igbuGLcIJGm2lf2mG2+puCGOBDh9UD8lY6q?=
 =?us-ascii?Q?QhI4AQn6Kjse4pEFkmcuFuO/EdhXF4GCITvFCnJovtjU7Xgto2+brqvdV7gd?=
 =?us-ascii?Q?4iBN4QDuj1Q65FMncYrftSwZ+LeiDHfgElMf8aY1/sl+oid/e/m9o6rH5rwY?=
 =?us-ascii?Q?RyYs9nc7+XmccUwHYKaBz1nfEpk2azf1cCcazKv4G8NXyMqp00CQ1/X8wfRu?=
 =?us-ascii?Q?5PJlJyQllU99FLWI8K0uKhWZ9t8wsPS/lSg+L7vV+2OMWvGDn3JsDi5MQocl?=
 =?us-ascii?Q?MMMuSbOkH80yJw6eibSP4Cl2vp4P/BbfmCoJv2LxfqYkRPg3Qqise9bQnSro?=
 =?us-ascii?Q?euTelm/aSbjwLXFuv3q/9Mfh3jQ8lARziQtD3JpWReLftuBny6Tm9PpzjQJw?=
 =?us-ascii?Q?xQf1gR3EXq27JAclrsr7Xz1MAnbXPL9G0ZfwkmBIs9uEHC6d1K0c4cPcH6kH?=
 =?us-ascii?Q?ja/WmnDvlzz0ZqgddpwnhlF7XvJLOcJU0evr2sbPZKzn9crwrW+PFNEmbO7d?=
 =?us-ascii?Q?3g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: JG7FwnBz0U4ZH9pj/zglfWXdCyRZB8sflt4jYkR3y86oD3oBJr6dl2YtEq10S6HImXHC6E3ghCC8bGVyK6tOhEUo2PeznMglT6EjdFzf3dLyS9hkx3LawY1cRu6JWk+WY8SlQHH03HFxmFlzzK/4YRB781rSSCb1wdbwX7OxvGgadHuY7ql0dCV8rkjm9rkpL0DWtbqitX71RvSlljARBAGtI/T6Q3jWoZPjmKne2BGJHO8TNEW7YukmuDy8zTmrNpoMyP/oPe1BVHfNvbE8HDLLRbK6ZLs2XPxdgf+/8ioVjO79SjdkBj0vCmD5Ckxef289Ga1ir6M/Al5Vziwk9pvnEZk/jDHbbHIZ3BcCaCgJs1I0n4sVOLzzU2p1vPJNAfPUZXWSctYR9hQ5tA1+Pg4mJNRxsR7Y3uYmhYsBmmYsUlsi5kwxwAYv5hynQQyD/0vHcJBUL6aYQ/DNCZr3D066Ec8Tu8dBxBQ4y3MV41skBITpdUOIU8x4tJmBe1wutTJgF626ntWV+cmDhn/kRKQZl6YO7/zO9OCrNn6TL7JI1AcP/BMvvIA2b/Hx6bqhx8ia5MlUfsLY1mXm0NoH3boT/+xYqN1DWss3H5q2S2Pw2hl1sTOWkHwcfKExGDCgJkdALZfEm8d2vSsDL4bbx7uPnAlN+ZZ5H59KUun84nVD3Q4cOKM9xxgcHWj4ywyQKvlVjEB1bUQuXdRGflRfyrwC1clKr6espdetJhs6ls9kkC4dQg1wCm4AMJpRRyMy788ch+Tak3494fWDaWsZWw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e154043-c18d-4f40-56be-08db2025cd35
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:13.3323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q2fw8dx94rIn5RIj6iO7lq1MFuycsPMc3Sr4vg+3iD7NU1LWDvtfHHgUO4kiKABY0q8Po58Jb6ayrc8j949NsxJB21Nn/g8H22+05SLTe7w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5708
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: f8tCCzaiKu-ljXLqfnuLQLsth7uH5Spu
X-Proofpoint-ORIG-GUID: f8tCCzaiKu-ljXLqfnuLQLsth7uH5Spu
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when removing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_remove.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c       | 6 +++++-
 fs/xfs/libxfs/xfs_dir2.h       | 3 ++-
 fs/xfs/libxfs/xfs_dir2_block.c | 4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 5 +++--
 fs/xfs/libxfs/xfs_dir2_node.c  | 5 +++--
 fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
 fs/xfs/xfs_inode.c             | 4 ++--
 7 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 69a6561c22cc..891c1f701f53 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -436,7 +436,8 @@ xfs_dir_removename(
 	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	xfs_ino_t		ino,
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -481,6 +482,9 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index d96954478696..0c2d7c0af78f 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -46,7 +46,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot,
+				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 70aeab9d2a12..d36f3f1491da 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -810,9 +810,9 @@ xfs_dir2_block_removename(
 	/*
 	 * Point to the data entry using the leaf entry.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	/*
 	 * Mark the data entry's space free.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 9ab520b66547..b4a066259d97 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1386,9 +1386,10 @@ xfs_dir2_leaf_removename(
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
 	lep = &leafhdr.ents[index];
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-		xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address)));
+		xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	needscan = needlog = 0;
 	oldbest = be16_to_cpu(bf[0].length);
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 5a9513c036b8..39cbdeafa0f6 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1296,9 +1296,10 @@ xfs_dir2_leafn_remove(
 	/*
 	 * Extract the data block and offset from the entry.
 	 */
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	ASSERT(dblk->blkno == db);
-	off = xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address));
+	off = xfs_dir2_dataptr_to_off(args->geo, args->offset);
 	ASSERT(dblk->index == off);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 44bc4ba3da8a..b49578a547b3 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -969,6 +969,8 @@ xfs_dir2_sf_removename(
 								XFS_CMP_EXACT) {
 			ASSERT(xfs_dir2_sf_get_ino(mp, sfp, sfep) ==
 			       args->inumber);
+			args->offset = xfs_dir2_byte_to_dataptr(
+						xfs_dir2_sf_get_offset(sfep));
 			break;
 		}
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f76e73db62da..ec5ebbc4d52f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2508,7 +2508,7 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
@@ -3098,7 +3098,7 @@ xfs_rename(
 					spaceres);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres);
+					   spaceres, NULL);
 
 	if (error)
 		goto out_trans_cancel;
-- 
2.25.1

