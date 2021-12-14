Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E25C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhLNIuM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:50:12 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:30260 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhLNIuL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:50:11 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE71w82018096;
        Tue, 14 Dec 2021 08:50:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Jy5wAhLoDqtrf7O1e21eU+SvgDE1LGWnwnCSTcu1Fi4=;
 b=KTWg2YTOJBqP19iwYb3lhCqhrHnfnvi/cSW5MpKyvUHz4uM1EUlmdWJ/TWwcHO1az3ML
 93kbgMf5wAhMCbj2xQSyOvpsFzZkeuZ+Z8SI8UVQc5tjsjVH7/cDt3cj79oufJQ3EiJn
 hiubOkkRyGkDrxG3EUIXVoRjOr2c5U3/0HRHjoKwcBn9gGzrdURjsmJwYDESB8FP46Em
 kOB0LNNgDqDoNU1y1Fbkb/A5PvEkD5WSJIJimOUO4srn/3RQZ5Q/RT/zosR8PTwNQAaa
 TLA1qn8V2GPzwF9Pd12B64+KeWlVcyJRHVMGb7R1a2t1Ic/e0ZviPKGqTwCpG3YJExmQ ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx5akau1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8fnp1104427;
        Tue, 14 Dec 2021 08:50:08 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by aserp3030.oracle.com with ESMTP id 3cvj1djtbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ft6rfJH6pWB0l/fSdgYX2v+wAI1dKtt9FXvgrX/PknmU0Q+fVSrn8lL7QRucR/fCluG/w+Km5AcIi5fwTv2iRW2DayNIIfc5ueV5kBBMFudh0Y1Stfdp9QJndIngDVsDKgNp1ViqFGAS/iyarXCANgXj9kk7dzoDE9cen7MtDwcMgK4Wsb/rjcKb4yTb49jXiLhUgQV5alByStkn/aYCMyhTOqNkzNM3cnAioSZryzxZBjrCCXo8Mg5a6cxp3lxZfqFmzr24EivN3cCMS5U6SYFyOF8w6rracu0A1XYuSEr4kB+3SfqFSuHr7I8jzcGlQ2iNbfx1meAsKUVZB0A2vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jy5wAhLoDqtrf7O1e21eU+SvgDE1LGWnwnCSTcu1Fi4=;
 b=S6EOt14Ke7lLPiVbvkBb16D8BLJbmG5B9Wsn2v5Nmwq+rZMvP+INUE11Au/JaN8ZIskN5ykHT/LeBfh+NB2PJkQGog9rG/IIfvJZCgKC5Iv+4hhZClCAWnmmONZhPyn32vMLKakkRX+irN3eC//LhM38Mke+zxLrkXjOcTupRIp+6E/vYA6VAPkyTSGXRYi6eGOgrDtgKdvWZYTNCajiat9RSXV41mr4yPxEbeLxaKdCNZrGq+/sJ/yEpRVb+AlKICt7/Lk/iFMunYeRjye17+Za0ShMBYbMWIyXQLOMg2babd6v6l1u2cbOBVmLBp3iliUGDk0Ym7M/JIukvOQDUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jy5wAhLoDqtrf7O1e21eU+SvgDE1LGWnwnCSTcu1Fi4=;
 b=J2uQ4EZD2/OyDQ37Z9rMD2WH7Q6eRYWh4gCNITRRzbNPofk7E1hTvTqirKlMAmMc/U6AENOqHx/j/Otns6K1mnLzdXZEl3REkXeErL87NJTUOlPd6UToj+ICXAT1nbaHTzRIF3LS1B6MTsMIFuomEgKbawIaIuSzD5GIY+O/0Ms=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:50:07 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:50:07 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 14/20] xfsprogs: Conditionally upgrade existing inodes to use 64-bit extent counters
Date:   Tue, 14 Dec 2021 14:18:05 +0530
Message-Id: <20211214084811.764481-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084811.764481-1-chandan.babu@oracle.com>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::31) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7cec97e-97d0-4916-fdc4-08d9bedeba58
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2656CB7AB5A52724E6EDB259F6759@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:47;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pfmdr62Qm5ux/NXsG7G1OcJs1RIEXsdAMqe4gSKJYIU/wjTnjlWF8IN3cVo+Rvz5Au0bI8qkmICHPQ4bPccEn9MbGRENrvjA+xqrPboNVmV3Z5XHl1jUCN29aqoTWle6O9zVKMcYROlVwcdp3ZnSK93hXTXdsZnsIblJDAmcwUKxrbefum96KryY9dskzfmrbz+Fq1QOqkAExEjFCFk5gXUCVApetOejNbPZFu30gg9w+57oe4t98KQ/dRvlIIGEt1vHA5YI9pOLp6bVOltyNz0dFg+T2EH35fF1G4+CfYdqgd9CTpcp0unHr7OGyXC1hsHAjmYmurZmzT4flHAtETXWGyxwFHThcGGsChlnvevR4SLko8NW/bhcwBG9CaeFCiQ4Ty/Xtsp24B81QMRK0BAXCvaXuXhw03FWh+B36S3COmDCTYqKW4T/QpiKFwPfBlKtAqJamCOdHQK2gcAsnn3Vi+INc6uNw5ptH1uD0zCXKM5uWp05GOLCY7z6JotJYsfm+qd4Zh2xLk34IvSzmkG5z48tAjZuFihc4+HamQSEyqUpIVkbbH6jHgDom1K/kSfFZOFGaXnTQxfDDyPt3bHuVqz/xp0NnABpzWXytTneL3vgcX+AjQ/N0/ZVlL/n2ufv3lnQjZdPOzwYhp7xqqyuro80H6AfhQrXd0AajZMKPF0xuKGJYVV5KULLnGsUXu/HpD/euBctOqoarNV9xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(52116002)(86362001)(186003)(6512007)(8936002)(6916009)(66946007)(38100700002)(38350700002)(5660300002)(6486002)(316002)(8676002)(66556008)(66476007)(2906002)(1076003)(83380400001)(2616005)(36756003)(4326008)(26005)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BL+WNSTtAFPgKUzMSfs+okBI60e7612KbG7jbkE6A0A0Y+tX9+j0CcvNV1xg?=
 =?us-ascii?Q?FGJYNoj8B+QaFADczFcLPmVD3LpRyfvYHOQcOxtYqHarOUUN2UHbc+g52ZP5?=
 =?us-ascii?Q?230FXpvMLZi2OGpMw5+/bH1J4phd2NOsMAM14nZaOeCxPFfEXDM7/Ku4YGP6?=
 =?us-ascii?Q?k69wr50LveYbJgqVEd8J30rQw1VqoQx1S4FvcoBxCI3spxHVkyeKSDkOYSHL?=
 =?us-ascii?Q?I3rvaaae9DQ0RKT7eXlcxyPkmsK9+Aw3JJBzaPG0/EZq2GVKRWKcAdwmnUqs?=
 =?us-ascii?Q?kT0FVIi28QV9t2sWvNnElcVZqV7seV8CJPwj9cI2/6TQ8kEMBfcp4ibqjiJY?=
 =?us-ascii?Q?LEBNkzzRw3RJttQcH3TtFWm6XI5P3LIymWBCNnSoyT6cWnuy51+NXq+4h49p?=
 =?us-ascii?Q?OAiNzg93TyhJQp7VNMI6lYZ4YV9rRVTDBMDA3WybPkhW4RMn+AonORNQ7U6s?=
 =?us-ascii?Q?ABECu6XwTyvvxQfqd8tHZDVNT//lvy+ZUJm6NSYIP+eAMMCAcOuDzSofaB5v?=
 =?us-ascii?Q?ez/K5h7AEl2WUIQR1I6JTKR/qczwrhn8LzbQzd6WUox+XIwPUcK9fgp3MjAj?=
 =?us-ascii?Q?hs6LPa2no8ZLAepONFIniBaUfeNVIRImecaWi58ss9NJxuB/Sab0x61RXaDQ?=
 =?us-ascii?Q?7JfAWes7QdEPzL093aWtdjq6B84DLfaial9tooLFK01wJa+alR7CVTv7mQbY?=
 =?us-ascii?Q?JCdsw8GpVSYytkcY6TRhiFt5jmtXJkO/b7ehVOo7gDHvbIhbbpU5rlggNGJd?=
 =?us-ascii?Q?zqQFAur6wBctInmQdi5PtQcCn45GZkdBDTUsHReFlVxR4SDV+y9wd7ARF4n6?=
 =?us-ascii?Q?0lfc5xRKrJXrX0w4UXvC0+NSSHq3Po2L39E2V+wXVZD12BSqDZ6iMWKfTNPt?=
 =?us-ascii?Q?vaO5igzD2G+E6tmSnclUzWyYjqdqQfWPeyX3/YclWv8CgdASlcpnekEAnI9J?=
 =?us-ascii?Q?I28LwyBqRy0Ftf9lFpIcf+6WLHY4AfOdsOQTAWvaCDJwr7emvVV8iJS9jXR+?=
 =?us-ascii?Q?lR+ggzHcoixwW0bFmdSbIS4qAuFEvn4zJzuuZw2UmBeZcNALcz7stNm+EZMp?=
 =?us-ascii?Q?CmoisNAgEOvyIkKc5syTG0eQmAaFIjCXq4gau63dw0CVYvUDtHXefFlxUK0F?=
 =?us-ascii?Q?d9Glnx+cRPQ+SuAREvQfBRNIcTtvuBEz5LgCAPxZrbdZWAPvvSltjtGD0TIc?=
 =?us-ascii?Q?e0peUTyvYcWBPG+srFV2DEQQ8iqEJ/qYXkg88Q/c1r5PiIr5iA+JoBLODFuc?=
 =?us-ascii?Q?E3qpSxKIwW9ro2PwnqUuWLdZmNtJa7S//GRASIgJ93gPyi5yI4K2Cd2o6fJv?=
 =?us-ascii?Q?csbN/X5iXnJ5hMcJNVLRtgU3l274YdpwT2wAO2jhQ/Jo9jN1c/S9csiFV8wT?=
 =?us-ascii?Q?cwZrOtRvhxEvWndaAm/WIs9fK3NbV91KfiudMlCMwZv5WNNhw25s14H0GHBM?=
 =?us-ascii?Q?WArvETL+crL7FoWbuHzNX1NaQIk+cQTMKcVhi+5ZIiQg0eW5w+4d7AEbuucd?=
 =?us-ascii?Q?4lalcJbS2M7wmf5PCMDQ2aLovPwEyhSQ9aANJNAaNt4pIwMcD+sM/tijfl7M?=
 =?us-ascii?Q?kF3sm0JKI3Gpuulm7QcYz14LZsFqJdmPJ9Xda6crTD6jmxf46xD1XoiW9brF?=
 =?us-ascii?Q?pD9Mn3AufRRyGlS2K649r3g=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7cec97e-97d0-4916-fdc4-08d9bedeba58
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:50:07.1701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: elHztojCaYlCj3u0ejzJttEn8ww+wVCJi7XnSuCzEaKXuq8AhMYKQ5VktusE8BrrgsiSxQZ+/GcZf4X+I1Mw4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140049
X-Proofpoint-GUID: 8RaQ2YrmV9BlnmIryIkgmOjA5WBq82bF
X-Proofpoint-ORIG-GUID: 8RaQ2YrmV9BlnmIryIkgmOjA5WBq82bF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit upgrades inodes to use 64-bit extent counters when they are read
from disk. Inodes are upgraded only when the filesystem instance has
XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag set.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_inode_buf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 5c6de73b..a484e14b 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -250,6 +250,12 @@ xfs_inode_from_disk(
 	}
 	if (xfs_is_reflink_inode(ip))
 		xfs_ifork_init_cow(ip);
+
+	if ((from->di_version == 3) &&
+		xfs_sb_version_hasnrext64(&ip->i_mount->m_sb) &&
+		!xfs_dinode_has_nrext64(from))
+		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+
 	return 0;
 
 out_destroy_data_fork:
-- 
2.30.2

