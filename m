Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 598ECC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348590AbiAUFVd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:21:33 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:11496 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348600AbiAUFVE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:21:04 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L043Ow017784;
        Fri, 21 Jan 2022 05:21:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=mlLTYCYA5ZyM26cXTKJHpNuWqVai+ZDZHs9vd5YF/yk=;
 b=jrmcP+1JA1LORuzgmmguG5AemJe9RSHGUQjvR7IE/WSvxigo2QZmx+K12vvjlLz8Otak
 WArw7viLKvEbwmGtwpuUQOJL4cycLob5Ot5E2oK8wQnsb6MNFr6Pp16G3Kanl4agdbw+
 M+CWYy7Bkfbmxb2N6MIxH6TSO/dRp2isWIc3Dx1gTBXIbO6KlfmQYO05b/Ba0ppPU248
 O4hPoXRWinx0Tkh85twW/mZFadCTcc3b2SltbEm24aJLvuIzGMjFOzxdIde+7fDgOdKV
 nGp6tyWZsTi3ZYcC4Ts5xAShWzd+lGo5bSHr/ue0DEMKakn4kFoIf1OrQgdqOnuMikDt sw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhyc0d42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5KhO5094500;
        Fri, 21 Jan 2022 05:21:00 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2170.outbound.protection.outlook.com [104.47.73.170])
        by userp3030.oracle.com with ESMTP id 3dqj0vbm48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dU3gRgUWauo5+dU3mgTSI7RZ52FPdWu8R3isXy3RyT8zOP1CgN+gQXMbd2jU6HbPJN1yAUtilQ24ozBF/+vYaPOZ+cEJ2TQc/iLLse8cqfzJcjwzMAepDeIeivZUjaB/kHWWZLpqOU/jjkx54PtbPqlqjHQS1o1slPsHnffIyYFwdtTTt2NQJU0IMR6t3WYbGEc6+aqXbiEBVn7mikCej4CvuaLyJCub6Fb83q2139F/Frg5JSdy5ZMJwa2EacettJPjf/lyztnya0HQSA5BLTVZWM3jePPdIGngTBSpty9iTvQbGEVDXofr7hKkXCulyB7Pk8CRo5RhyCQlWcjmeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mlLTYCYA5ZyM26cXTKJHpNuWqVai+ZDZHs9vd5YF/yk=;
 b=UBgO6f+w3Z4lF6H1y7QWfa52skZQdRr0n6IYMHcK3R+r/Warc3/1g/c6BJIUiepmJV/xMALniSkxDyHFP3FB7lrHkk7wMpXeqnQwplGeBBL0zW1Sd43YcgPwynYtrhJRVS1hu7gK8FCKOOPEnQRVhIjvwwSrUUvhWv7cU1cAfHEJfZkJNF3ZcC6FqmaRT/PJ5B4oYjrvPBWXO33MxS/BwaqhlMswOIKNIQBUQVgUZ4mey+7QZVzgFXYxOdk7sNqMv+Dr/iKcdA7AKxIWOAfbu5xaHRO52gyD/NL4plyhQGzRlmkyD7fh2RGi+DVchWQDqO+08iZyYHjnwrUOurZA2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mlLTYCYA5ZyM26cXTKJHpNuWqVai+ZDZHs9vd5YF/yk=;
 b=fVReoAacmHfllCt4xh9IwaUCeoYWazRdT+s0O8KdaM3gPANlowVoBXz7vTtHb04X11Oq+FdOHqELatIBRjDnrAnTU93WqcNiUHq8infxJiN3eZ+pTEweF/VcF7UsjvfAWJWCi0J4dq5w4qjQA+3DOtO2hsinpPxZCSVvqM5II6I=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CH0PR10MB5322.namprd10.prod.outlook.com (2603:10b6:610:c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Fri, 21 Jan
 2022 05:20:58 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:20:58 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 09/20] xfsprogs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
Date:   Fri, 21 Jan 2022 10:50:08 +0530
Message-Id: <20220121052019.224605-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121052019.224605-1-chandan.babu@oracle.com>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dde2e20-869e-4d2b-fca1-08d9dc9dce70
X-MS-TrafficTypeDiagnostic: CH0PR10MB5322:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB5322B0829BC8242E3A7ED30AF65B9@CH0PR10MB5322.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4fM9BGMK6ykUhzbpdV0YyWuKu/34NAJvllaaCkJq741E1iOhx6iEZBnWDfFa+m3OccYn6BJoZb4yc1Zn4Achme0bV+CN1yqtnMx6gkzu+pKs+ErUqqQdh4ojk2Wm1vrsUpI+9UixvD2+kYHtphTDdVKnysqD7AgPwaUOhGhQUlwTSH5+1uLlY8wDlj+rp+toJ+u3iDh0bd7uDvvZ35K4+aFDYRWIauwlUCOYhgMu5lBFULzIQgjQC3XfL4ABIflRYBWwVQtIIypkKKqVmvxClHTlhKWnpoR33yrMXpaMssqkGqW9B4FesZKa30r+md1DT3FAQIWKF+rokygx72ANZ18iNwesJqt1VXjRUdtKTUF3Y4RVB4qwVoAwWwM6GMzHt3YH2GnjRyIb+9Ko2HxwfaEI47BRpc9HaPtDcD421gkzED6ByN+Q+FQznBZSGWU4VZu+s7Y40Sn+t4NmS5CXQ3ID+NFjuoVqAqpgQcTPA7jXThkzrQWL9dDIuK/DFTsslXBKEHVNX+StSZu2ej2U6lsDilPnHS0XBpfyid3T4pvueyvu7EkrKfhXMBhIBfBoTqW4hNOA+33luJrqbIwvQ7diba1hnRTmHB4UQukeCHfKPUUUbYX9anXXAmwz2U2wCJOlUZP5jP908V1mV2WOhKE24ijPdf/FboLd9QXWhPrvU9wh6kMjcYQ92dmzV1CiEtunC/0qZc76TYOI9QLGDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(4326008)(316002)(8936002)(36756003)(38350700002)(38100700002)(6916009)(1076003)(2906002)(508600001)(6506007)(66946007)(66556008)(66476007)(83380400001)(5660300002)(6512007)(8676002)(6486002)(86362001)(52116002)(6666004)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ah+hO2piuEf7zisFiBSQAezTWmMErhYbx1EuHZF9jRJ/4yWtFqGcPdkr7KO2?=
 =?us-ascii?Q?TdbOBJ66hNj/ny90VO4QZOTARk7LYdu0IUkLlwh1/YqfL+jiJ+qN6vk+z/wG?=
 =?us-ascii?Q?LjsunTOzzJ+nO12gfMmNWNf2JZ1FyjgIGtgYPYkXi3ZpPYNjYaOrwYit+IVL?=
 =?us-ascii?Q?Kg9bDUYoOD2HuwP+/VNKAMdRYc5JpatesxaYUC20FuUM1/Z7YQzYOBngT7Vv?=
 =?us-ascii?Q?Ww7awOQ4oXzIdQkdyzPM3QqmWu0uz4Cs+289rCZxPFvvxVZ2ZBstN1w4VNoY?=
 =?us-ascii?Q?FtReXQanQckB0Sjxb0eblIM4poCzlxW//VLdp818U60dSwkiAqcTE0W7a5zr?=
 =?us-ascii?Q?5y7wyybo7j4NVPFtStpvYFERcIHLl2icBbtDe+M/AYAjfJC1Q+Xod8c7Iia9?=
 =?us-ascii?Q?DOEoHQkH8a+28gZxJJLOCvRl+iAMo0qQR2KXW/NNnXrbKg9zKAA1jDjJbxJj?=
 =?us-ascii?Q?kafefZkiED+iKkG/3pJbzBzaumqaIxRR6bNL/A8hC9JCvZ+phyHmdkwwRZZV?=
 =?us-ascii?Q?h7nuI7zNSZs4Dw7QYd8HFPjUrlGQ7Hehz4DRBUCJvO0kLKomvoag5gmy3jzn?=
 =?us-ascii?Q?GvNJKBGIdpPBuYoOIq7+c6M3AY0L2lqICL8maZm9QnJaWRvf8dQ3t4NWiflJ?=
 =?us-ascii?Q?deNxv9fBxYydI1L11RgJlNCUdLrlHA9fetUr3SVdqQme4efKycukLZaUNh+H?=
 =?us-ascii?Q?V/bV4gL3TpewgsNI/fV77WToFPKptNU+Uy3lfA+DO70+BJwxuFU7AFUUuebV?=
 =?us-ascii?Q?ogDOIEguVc5FSrb0PFMCQRoQLHTK7W14mSdLXJRRwslXBZF5317qe9lM1P0R?=
 =?us-ascii?Q?mzhxFcJJpNwpdJorhCi9IiiTTisyyBbthG2ErPENHKzaRfgucPGtTrj6Sr2X?=
 =?us-ascii?Q?47jRf5OTbroAbM6fjda0zulJPSQK3EPc360RaNlCGDUYPWytpQjpA4afCimI?=
 =?us-ascii?Q?/AiZh2/jU42DnWYPc70rJCisggxh09YXP4tOVYsGIXdiI7f8oToDXf6TvzMO?=
 =?us-ascii?Q?br+rnLKpEK2Nas8vL51Jsc8f30ZZo6iyAXAfbvcAQ6f+psgYMOMGOww8ixo/?=
 =?us-ascii?Q?Hc2EHtSPj66hSVxcHEVfjRajIE8or+fsVLsM1Y68wb92GclOdJDd9NLvxZkP?=
 =?us-ascii?Q?5PhUOUnDTd9tm0OntSYE4etY79CKZKWgq4ndq/qslpO9ljSfdHaQim29CKJb?=
 =?us-ascii?Q?HzQhQuIOW6ADJUMaGuAhbZ8xIurCcBqcaV+ulastW4lL53ufCBjBwbl7YHLK?=
 =?us-ascii?Q?zkcs5YaUETK31PmjNWJOWqzlt0T4RhmNbrjQdFYiMKfeheJw/PLzr4Sev6wp?=
 =?us-ascii?Q?DFqaDVTIwDdWq5+bRY+v4/Z1jg4YO2IeAkBCfa3Le/YcOS3QLy+lvYYFzx7/?=
 =?us-ascii?Q?a5GYRntzkiX7guVcHuUMghRhi3SB7mETWhocniBygWxrLnE8zs3d6xdkKyHE?=
 =?us-ascii?Q?Is6zb5Kc1RhQZFraNJGioll/Y01fC8bVNfiNAxZrqcu8IvYHFNs0TGkOSGEz?=
 =?us-ascii?Q?dCmHxvRw2HACgAkoaDS3qJYR3nCq+qxdmyYTeVYwqHQ0v+UkJrxm+VPYoXvQ?=
 =?us-ascii?Q?jOEK2LdTHgJ07PmQIgf/S9E4/257TkxLxx7JQf4jZxW+wMT7klA84rYsDBqW?=
 =?us-ascii?Q?ygp1xrcl3h7EsLV6+DvsBxQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dde2e20-869e-4d2b-fca1-08d9dc9dce70
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:20:58.4247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3pqdgLZCM6pcOvAn5bw1EOMEPGTrUec7Dc8yO+uV2mriUFPAleK3e/Wp5UdaLrLypTGWfLh3EMvNJTATgL/MUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5322
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210038
X-Proofpoint-ORIG-GUID: 9JgpcPBvJSoRiSK1zThXFS4YJa5nqFF-
X-Proofpoint-GUID: 9JgpcPBvJSoRiSK1zThXFS4YJa5nqFF-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_FSOP_GEOM_FLAGS_NREXT64 indicates that the current filesystem instance
supports 64-bit per-inode extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_fs.h | 1 +
 libxfs/xfs_sb.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index c43877c8..42bc3950 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -251,6 +251,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
+#define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* 64-bit extent counter */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 7ab13e07..6045266e 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1136,6 +1136,9 @@ xfs_fs_geometry(
 	} else {
 		geo->logsectsize = BBSIZE;
 	}
+	if (xfs_has_nrext64(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
+
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.30.2

