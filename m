Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180E1C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 09:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357533AbiDFJke (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586150AbiDFJg6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:36:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93912AE9F2
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:46 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2361hkhi014690;
        Wed, 6 Apr 2022 06:20:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=mwkj6AgvKnnAgQiIPnp6xtNeEZdODSIYCwoLetv1aiM=;
 b=VlG0Np2CXDCvmPwAcL4Boz+1g6+KegChdBEXjjghU19gvkrIZvGFQV5Acf35ytftvaQ+
 cSusSxPt9Bnsl6zk6Y9FI9kikAsTfVoSUt2QL2V7vxDnokhpRK/abRHr1GBC9V7PMM7y
 +ABs17YE/OUL3NvayGTak4SCb+hUEz3z6xMv0+VWGnTGibROYEcmjhnMc3GNbDZrrBnB
 dhqAAZUA4YXAJ7YQvBoAzB1GHtZV1SjUPB+kIQ/dCQQAlH1EUcXLOedtPjKl2bUY310G
 N58uTTVfGl1hNEQVbtn43L8y10SR58MHwjSnhYhgcEjRoiHvc48PmFiUt0jB8/aE00KY Gw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6ec9qrsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:43 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366Ai3T022522;
        Wed, 6 Apr 2022 06:20:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx48hrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nw2m+ssG2Z+R6EqZWHPDL86N81XcgZQfzWy0daVy4H+SQA0lIOm3D5LDKLQUvWoObYo+iBrgqbU/FAQ2beDgY2pC6TbiVbAJISBI0NtVif+msq7IqPtvWK+m9lIezEqFu56FQkDXX8cKteP6agNqOZf+khdJ0zxEgzHEUHY4weiCY6mH2rN7+qYi2GfI3LCwXP/S3BZX+vCPnmuCK+M3kB+7sldwQHsIKMuCnYPO86yjLM3c2uJMF+hpw+QmJQzCwkhdDLzpZcdTv76p66iTOPKKscQt6GeqlE1qScE8d+nlfdECFlo2Yi1N952QFIIid1zLwIg+A/6efle+7PSxpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwkj6AgvKnnAgQiIPnp6xtNeEZdODSIYCwoLetv1aiM=;
 b=K9e+jnC57GEXtPP9m3+0Iwh9dcJLwMvanFqJL1EM81xV9+aqsQxLwPFFhScxTjP375YXBSRGNMV2yUAYUW9HmkQjwyOkyd7xI0FQiKR4u7xJay1T/FWW+9fLXhmywEkPJsTkYZINMHHVKPlfpLebOy98YmTJXQhyJopjVkqs9wbwit4cQCUj3S5Fg8B/FtRKoi3G4IyoaQ8gbpgDDkmoiVb71QIuV2gNav/kOlW7ExnMOMtFcbimxRTXBsmXG0BH9LX4wXXuqMFZ7nJQSQQE0M1XscrCJQcYN0gGYGwR5ZWSnwko2Eajskty7e5VLew1YaXJbwlnyWuAuwjAOQ9v7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwkj6AgvKnnAgQiIPnp6xtNeEZdODSIYCwoLetv1aiM=;
 b=x8SbUYERtCVuavzllKHJpSfVhgc8cmjBX+NkHCN0L5EKF1GDLOKfgtVqU5gyVGU2H0e+oEaPDh5xHa/T0XVCQX2r/AIDKMSu4vvhTKXXHtNIwzZZNrcVeVac8VM1wHlRAzK8ZVMFMJZnvJIlFUbPDz+X9yYy/YIz/ynEiFET9CU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:38 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:38 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V9 16/19] xfs: Conditionally upgrade existing inodes to use large extent counters
Date:   Wed,  6 Apr 2022 11:49:00 +0530
Message-Id: <20220406061904.595597-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061904.595597-1-chandan.babu@oracle.com>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0047.jpnprd01.prod.outlook.com
 (2603:1096:405:1::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 773808f7-8f64-41d2-f5ad-08da1795917f
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5564D9C2DC6A988E8D6B0B1BF6E79@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dlfT27xNmepCbxngYBy+/5mA2l7wC9ugU3z8+5Vp/h4ZoTnquV0t4oIP8BVUrzinltIalxEFpvHAHYF48Y2eKkxPd/kFWbKtZ0QYBSMjO2eFHrJJIkh/vPLLo0iZvcqpmxSgoUovJFBX2Gnrtj0NDndAia+J844trt0HdFZ1K6d/96vnSjDT9fyaJciW7uDk1bH0kyE4bpVAefcC8OwEQBXAAOrz3RvIw2ZDbDGhQ1Lukxqr29l6cSbttTNiQKL/nroFqOFbdJQ5oaIs8/TxSbuWif7/AEV6hzFDhashp8N9X52W2OAZFXXLF+KkVZzDEL/V2fbMJNmkH/RHm022YiKzplXH3VFV8ftq+CRufqrzrCjuhhyoMsNibnlyH6oUDanjw8Aa/D9wMQnbtkLnBhf5RPXeQ3SaME9qsh2ZywD79rQUbkiY2Iiboi3tdbfgxvFPMUM9rm8VBp1C02s8tl/bw62XXKKBZZVIxWOiwnLHzQDPeK7Av/EtKSMTJjW83d8gwrF8rerbDWIB0SAkb1oxnnDJK6+vJ+InVfyXivVP5K7m5+6R/Mu6u7yNHB5kE0OKwiGREVyMaUVTLR8l8mdrdQbPswZTCDNCtNX8dblCO7LfNE3peE9oYDev7wELiCHp49xg8z7LIqAq7unu66g8VLf92Wa6mjJ1v3FLDSFEYaqE0g0fYmAcSyIl8T1mnm34X6ff57wjv+IFHot+Xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66476007)(66946007)(6506007)(66556008)(52116002)(6512007)(6486002)(6916009)(4326008)(8676002)(6666004)(316002)(5660300002)(1076003)(8936002)(2616005)(83380400001)(86362001)(38350700002)(38100700002)(2906002)(26005)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vwd3pRGR7tJO58zTbyxUM3FTKmgtxWw8ez52wh3hwiYFGbHniLq7Yb+uDzCK?=
 =?us-ascii?Q?tVUsMNSTt2iGFfvIWY66Ot8QmtodFgkx0LflzlLsCLO2skaGVTqZ0ZSEfl7u?=
 =?us-ascii?Q?fPEtpyok1NSL7zP+6c05USwqpprBbUpGcdDpTxQPD3vH4GvTuTyXFEIi7XAc?=
 =?us-ascii?Q?KmNRHQJPbjAoZ+csUgLecN9Q2m0PlrRET+5yzGDwZA8zmy9tKYrNMg3cqp0/?=
 =?us-ascii?Q?j7AcDs/f+KMuytggLdA+YZfIQK+fpgr6M25SWdu9YbNAq8ahHt+l3SuJzzzb?=
 =?us-ascii?Q?7FsuLcR+rgDxDPNd820w07UegVQf7cTPqqzs9sUTWFxr5wIcUf4E6HolN3uY?=
 =?us-ascii?Q?IN4u2LqAnD5t/03JHF0thtuWUuN3KjJEmQy27GeNp5HB3T8VZcaAFn9d9G70?=
 =?us-ascii?Q?Um8zrfnJW/cYaR/6JPx+FevfLAOuxQbgu9P97kc12yEjehoK8s4FCwQNmmSy?=
 =?us-ascii?Q?YxW3gBS/b/v/P8BbAJWj9qrcGNKn+wdG11ZvjnD7vYiFBb3ZWopV1ostzIAe?=
 =?us-ascii?Q?bsdYrrqXpShOGM26WObUNnRDJiFNh7zqNJwTIA1Ov9u9r/JjnCKBKTscfwPg?=
 =?us-ascii?Q?LLhdvxcrSrT2SEJku1xX7Hp0zOJ35EOoPu1g9pAXN6giTuimnis/ycA0QZEO?=
 =?us-ascii?Q?gHKOMU3kWWrpBSOQklTZ/5hOxElIEhwDNFOTmnuflhDG0KOo2bAcSMdG5dOQ?=
 =?us-ascii?Q?sRoN0hhucONUQoSTLfaQHjKddP4+GcgPcsd6JPgrTdT47BwPNKdykUIIFhF9?=
 =?us-ascii?Q?G7t+hJMn9UrKe33NXQKJxViSsdTLA+k9kakHDVKrAaDj+vYtd5UJZVsqbIcR?=
 =?us-ascii?Q?ix33gaudJV/D4ZXtrPbF1579vN3edt4J17ohwVnGxhdudMDOFMxo73FZuSVL?=
 =?us-ascii?Q?PQR7hPmDwFIPGFap3GHUyQFkGBlcR642iGL+prIrXmrLqtKg4uze+7KE2HmE?=
 =?us-ascii?Q?Q8CScmWJc32LUZvJhqjYtSFoG/40Hwe5RL5GOdQixAb0YjU1GeHWeGt62Kie?=
 =?us-ascii?Q?bKunVlzfnpghj8k4dbr+AO+t9ju8Q1evR8bDjnCk6rUKdFq0E7E9+xkN7OeW?=
 =?us-ascii?Q?EXdVjZqc2atvhoA4iabEZFMt4dYkbU0lbGE9LQx7oV+fYZLHoIff0WBrYDKN?=
 =?us-ascii?Q?adkBALhX70z+p+ooZuGKSoovyqykcVZV14nrBR8Pk24wC0NtCwmby/jyLsJi?=
 =?us-ascii?Q?9LXdHyFzkc+nQDDzFFJpEgi+Vrv+WfwlsbQ3Y9rVeax0m1/UAuqV8ILb777p?=
 =?us-ascii?Q?h6kGwwGS30x4qSzHYeGuWeYIrbMNZ8QNExCYZmE71auzdZUa1kzpUC5G6jje?=
 =?us-ascii?Q?NMsczU4NkHIky2nHUjD5KBavFEcACi91PsQd8qiFea/eMuTjQRLJeDOV3x/m?=
 =?us-ascii?Q?eGRNbaiLnCUK2GSSx/4iWjAYXdqHoLe6wWQoatTPCDDhvAnUHXLBZBLhRxWa?=
 =?us-ascii?Q?pYoaNiJVA+JTvTGzd6eUexjJVK37Imt3N5D9nikstb1PpvM93lQthQZuEZRC?=
 =?us-ascii?Q?/Vlhh2t4DMPBJmncyB6OJip8NKap3fG5dHdVAzGZTbi0vu5sYnej0FDpvX2g?=
 =?us-ascii?Q?h/+D7Xnz/+9ItPPAY7owRGkejgV8uSyChjcKK61g4G916+70qG1sAYgUt1eE?=
 =?us-ascii?Q?b0KIqrmHrwvQvemfzdzzIIck35Xa6oJYQYrIdVCT6f1ePpBatXZbFcyxqbol?=
 =?us-ascii?Q?pp3tXfBoXmeZXm3sqKfVHa804eHYtcpt+p2lPM1ZT8ggc67AdSjhyxeXSI4W?=
 =?us-ascii?Q?YhsHvlnPXyAvD3XwSWxfu54/1grflxo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 773808f7-8f64-41d2-f5ad-08da1795917f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:38.6713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sSX4mXvAh1yBSddTLPNwlUAsy3m96rMkTi2o3B+cJU6qTlLzZT60eCKWNS6f8JXUPpTumxlfCxCsIhyZfbb9HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204060027
X-Proofpoint-GUID: iGGACs6sDVTIKbOyZ5tqO_HuK18Axo1o
X-Proofpoint-ORIG-GUID: iGGACs6sDVTIKbOyZ5tqO_HuK18Axo1o
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit enables upgrading existing inodes to use large extent counters
provided that underlying filesystem's superblock has large extent counter
feature enabled.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c       | 10 ++++++++++
 fs/xfs/libxfs/xfs_bmap.c       |  6 ++++--
 fs/xfs/libxfs/xfs_format.h     |  8 ++++++++
 fs/xfs/libxfs/xfs_inode_fork.c | 19 +++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
 fs/xfs/xfs_bmap_item.c         |  2 ++
 fs/xfs/xfs_bmap_util.c         | 13 +++++++++++++
 fs/xfs/xfs_dquot.c             |  3 +++
 fs/xfs/xfs_iomap.c             |  5 +++++
 fs/xfs/xfs_reflink.c           |  5 +++++
 fs/xfs/xfs_rtalloc.c           |  3 +++
 11 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 23523b802539..66c4fc55c9d7 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -776,8 +776,18 @@ xfs_attr_set(
 	if (args->value || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
+		if (error == -EFBIG)
+			error = xfs_iext_count_upgrade(args->trans, dp,
+					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
 		if (error)
 			goto out_trans_cancel;
+
+		if (error == -EFBIG) {
+			error = xfs_iext_count_upgrade(args->trans, dp,
+					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
+			if (error)
+				goto out_trans_cancel;
+		}
 	}
 
 	error = xfs_attr_lookup(args);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4fab0c92ab70..82d5467ddf2c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4524,14 +4524,16 @@ xfs_bmapi_convert_delalloc(
 		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 
 	error = xfs_iext_count_may_overflow(ip, whichfork,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
+	if (error == -EFBIG)
+		error = xfs_iext_count_upgrade(tp, ip,
+				XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
 		goto out_trans_cancel;
 
-	xfs_trans_ijoin(tp, ip, 0);
-
 	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
 	    bma.got.br_startoff > offset_fsb) {
 		/*
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 43de892d0305..bb327ea43ca1 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -934,6 +934,14 @@ enum xfs_dinode_fmt {
 #define XFS_MAX_EXTCNT_DATA_FORK_SMALL	((xfs_extnum_t)((1ULL << 31) - 1))
 #define XFS_MAX_EXTCNT_ATTR_FORK_SMALL	((xfs_extnum_t)((1ULL << 15) - 1))
 
+/*
+ * This macro represents the maximum value by which a filesystem operation can
+ * increase the value of an inode's data/attr fork extent count.
+ */
+#define XFS_MAX_EXTCNT_UPGRADE_NR	\
+	min(XFS_MAX_EXTCNT_ATTR_FORK_LARGE - XFS_MAX_EXTCNT_ATTR_FORK_SMALL,	\
+	    XFS_MAX_EXTCNT_DATA_FORK_LARGE - XFS_MAX_EXTCNT_DATA_FORK_SMALL)
+
 /*
  * Inode minimum and maximum sizes.
  */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index bb5d841aac58..1245e9f1ca81 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -756,3 +756,22 @@ xfs_iext_count_may_overflow(
 
 	return 0;
 }
+
+int
+xfs_iext_count_upgrade(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	uint			nr_to_add)
+{
+	ASSERT(nr_to_add <= XFS_MAX_EXTCNT_UPGRADE_NR);
+
+	if (!xfs_has_large_extent_counts(ip->i_mount) ||
+	    (ip->i_diflags2 & XFS_DIFLAG2_NREXT64) ||
+	    XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
+		return -EFBIG;
+
+	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 6f9d69f8896e..4f68c1f20beb 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -275,6 +275,8 @@ int xfs_ifork_verify_local_data(struct xfs_inode *ip);
 int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
 int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
 		int nr_to_add);
+int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
+		uint nr_to_add);
 
 /* returns true if the fork has extents but they are not read in yet. */
 static inline bool xfs_need_iread_extents(struct xfs_ifork *ifp)
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 761dde155099..593ac29cffc7 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -506,6 +506,8 @@ xfs_bui_item_recover(
 		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
 
 	error = xfs_iext_count_may_overflow(ip, whichfork, iext_delta);
+	if (error == -EFBIG)
+		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
 	if (error)
 		goto err_cancel;
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 18c1b99311a8..52be58372c63 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -859,6 +859,9 @@ xfs_alloc_file_space(
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
+		if (error == -EFBIG)
+			error = xfs_iext_count_upgrade(tp, ip,
+					XFS_IEXT_ADD_NOSPLIT_CNT);
 		if (error)
 			goto error;
 
@@ -914,6 +917,8 @@ xfs_unmap_extent(
 
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 			XFS_IEXT_PUNCH_HOLE_CNT);
+	if (error == -EFBIG)
+		error = xfs_iext_count_upgrade(tp, ip, XFS_IEXT_PUNCH_HOLE_CNT);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1195,6 +1200,8 @@ xfs_insert_file_space(
 
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 			XFS_IEXT_PUNCH_HOLE_CNT);
+	if (error == -EFBIG)
+		error = xfs_iext_count_upgrade(tp, ip, XFS_IEXT_PUNCH_HOLE_CNT);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1423,6 +1430,9 @@ xfs_swap_extent_rmap(
 				error = xfs_iext_count_may_overflow(ip,
 						XFS_DATA_FORK,
 						XFS_IEXT_SWAP_RMAP_CNT);
+				if (error == -EFBIG)
+					error = xfs_iext_count_upgrade(tp, ip,
+							XFS_IEXT_SWAP_RMAP_CNT);
 				if (error)
 					goto out;
 			}
@@ -1431,6 +1441,9 @@ xfs_swap_extent_rmap(
 				error = xfs_iext_count_may_overflow(tip,
 						XFS_DATA_FORK,
 						XFS_IEXT_SWAP_RMAP_CNT);
+				if (error == -EFBIG)
+					error = xfs_iext_count_upgrade(tp, ip,
+							XFS_IEXT_SWAP_RMAP_CNT);
 				if (error)
 					goto out;
 			}
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 5afedcbc78c7..eb211e0ede5d 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -322,6 +322,9 @@ xfs_dquot_disk_alloc(
 
 	error = xfs_iext_count_may_overflow(quotip, XFS_DATA_FORK,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
+	if (error == -EFBIG)
+		error = xfs_iext_count_upgrade(tp, quotip,
+				XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
 		goto err_cancel;
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 87e1cf5060bd..5a393259a3a3 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -251,6 +251,8 @@ xfs_iomap_write_direct(
 		return error;
 
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, nr_exts);
+	if (error == -EFBIG)
+		error = xfs_iext_count_upgrade(tp, ip, nr_exts);
 	if (error)
 		goto out_trans_cancel;
 
@@ -555,6 +557,9 @@ xfs_iomap_write_unwritten(
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_WRITE_UNWRITTEN_CNT);
+		if (error == -EFBIG)
+			error = xfs_iext_count_upgrade(tp, ip,
+					XFS_IEXT_WRITE_UNWRITTEN_CNT);
 		if (error)
 			goto error_on_bmapi_transaction;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 54e68e5693fd..1ae6d3434ad2 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -620,6 +620,9 @@ xfs_reflink_end_cow_extent(
 
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 			XFS_IEXT_REFLINK_END_COW_CNT);
+	if (error == -EFBIG)
+		error = xfs_iext_count_upgrade(tp, ip,
+				XFS_IEXT_REFLINK_END_COW_CNT);
 	if (error)
 		goto out_cancel;
 
@@ -1121,6 +1124,8 @@ xfs_reflink_remap_extent(
 		++iext_delta;
 
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, iext_delta);
+	if (error == -EFBIG)
+		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
 	if (error)
 		goto out_cancel;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index b8c79ee791af..3e587e85d5bf 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -806,6 +806,9 @@ xfs_growfs_rt_alloc(
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
+		if (error == -EFBIG)
+			error = xfs_iext_count_upgrade(tp, ip,
+					XFS_IEXT_ADD_NOSPLIT_CNT);
 		if (error)
 			goto out_trans_cancel;
 
-- 
2.30.2

