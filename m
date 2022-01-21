Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69BADC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbiAUFUH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:20:07 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5458 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233731AbiAUFUG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:20:06 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04vTT017314;
        Fri, 21 Jan 2022 05:20:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=rgPecD+NF6IOyXQDH55NX1ykFjKz55FSuUaIpCox/0g=;
 b=C6DoTORlWSa7s6g9wxPR8Zp5auLcrzpkKypM6qUz4aqgVXO5IcEFOnCyEQV/uv7BiE/3
 HgDsldlOmlmzIw+4AiurVQpGacA1Ma+0U12YaN79ljpDKrNGV4HdPv+PybRnYjs6+3JF
 hQWeBr6mdVoMjqN9dcZ+zG7Jqykec7V4YwOopV+HPJH8aBtEzuhDnvk6Lllu4lpgLqPQ
 Id7Lq0B4dknfZM9E3DWbdOFQexFgjQbpLhZ+2Be80vollJ3maf1+A6NI+k3gwirKKNRL
 gi1E2tW3jUFPTSDnet7xzbQVGT0vyr19vFoxcIYBoJJSRSG0C2xmxIXSTOqD5yrPu2p1 jQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhydrc76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5G9lP156890;
        Fri, 21 Jan 2022 05:20:01 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by userp3020.oracle.com with ESMTP id 3dqj0maupf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WcBvAWnuS/JU5lc3RFE6mp9AeTOEhYkjitu3MPnt2IeDcvUScPSfwEMAkT/we1lwT3MVr52hAHkSe/aIgkrhbo59bnolPxNA4iILxxFd+FYzL9Zi36Sns0PuKAlR1vjCLRxmQ5/KhluHJCJh2DqR51WLrXvAc6MIQXmuFmvnh37FV2RU5B1BMm+sKade3eJQGSpv3nFnwOC0NFftdLtCxxowF0mcALshcJcMf+BXKKo9DjJMlVvU9V0vc5Ox9WOqKDbxPFJ/9cb5LP96TWOxi0h2OB7f63WI6DJjGuonnzcjuIJivVml3YT9kAstgcQB6Pa1CPWKiP8/oLZ+iHK5zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rgPecD+NF6IOyXQDH55NX1ykFjKz55FSuUaIpCox/0g=;
 b=YzRLTjj8bGiybOYXWQ3Jp1a1VqElpCtbmZGpu3Uh8auuuSZXfwa1FIzYkQttBrvuF+tGJYN1z5LbNPv9pmtXehW8e5XgG/EuCRykHXO2+OIp6q+YOQhmNGyb2LlQj5jyMrGjl4E2+cwb3052itBqJHS8hh3ouK+aJXOkwIMWp+IY2E4/PY9sulGdEve847+K3Wv3MSxH7HgyY6aFoCfos9uVk0zaS7Dj9F1bhn/RBO66JaQdV4zmdw85c6TQaMSfSn1N+LRDqkVjLlWB+aFaxHPHU3sy+DZOTeLzC9q29PG8tvncJu7ZwWgUSC3c6Zqd5niWK3akkpj/9CVldA61Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rgPecD+NF6IOyXQDH55NX1ykFjKz55FSuUaIpCox/0g=;
 b=fbq6KPPDFPWp4bWVUIUb/Z4QdRr6Sy4CRw6jAofC+f5Wiqy4T/9myLfsQPTwczsrfmax2xoj2SH/SeLAvBHSgNqcOD+xMgIywVUVCo7nGLpz+jkPMZ8QvILdrN7veg2yU1V2ridTsJ5ueNGNnLyBC9zGOmlTSLvrkwzojdYfu2s=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CY4PR10MB1287.namprd10.prod.outlook.com (2603:10b6:903:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Fri, 21 Jan
 2022 05:19:59 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:19:59 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 14/16] xfs: Enable bulkstat ioctl to support 64-bit per-inode extent counters
Date:   Fri, 21 Jan 2022 10:48:55 +0530
Message-Id: <20220121051857.221105-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121051857.221105-1-chandan.babu@oracle.com>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0027.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::22) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58981698-c647-4df8-d7c0-08d9dc9dab1c
X-MS-TrafficTypeDiagnostic: CY4PR10MB1287:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1287F01E9C2CB696AEF08543F65B9@CY4PR10MB1287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9qDse1QIZG0PXTt5ncBfswZVI+MqMVUXag8DuCl2Ehab78q//tZTIjYVmZtdpMoV6vMuvpXHiMugiKMP1RXY53X0ghWprEm/NqWFtx87YbfX0PQMSiqGJDnOmuOkhxcf4zOR7VX7yG1sU/fOHYS2XA36wIUG7EYql3oeiXdSkAZfwh4YLOGa4a/tL5UscbaqeCOvTimRaUuVNDbr+IDyeCr5UmiFlOrHWmRQX7E8ZFD+m6/qkkJ8WhAub168U4Ed1Ri9cy53Y6HvkaN8TZgBYM4Ka0PGWEL3eMIB0DLvlnxmCLaUWISQYswUjV387PLykNXTzircWTvNWtQzmXa+qep8uvObuXB0XGVsYJhOAKDqY9dH0Y1gdojb6LBnticytp6DGBnvTklZrOAL+503GmuOoo/5thI9Jknd/fioD35Yc0HN4/u/wXJ8O+UrHQycN8SHL2lD0GHHVItKw/0lGb9rpW5p3EffLsHKoWw6BOWGM2ovSuBr80W0S3mD8VNmQWKq29+gyN9+jzrfHDT8IbV9yXbFJW3vKEkBTb+M0VoWPcQFsaiRuriYC8ywNBsRuaQpAvwpj93W2k+eB1zLwZijzQHJ1oUx1B/8o942KEHvc7IJMX9dkuLpzfL1KGo81ICZNtSRt/TzfF/1vgVAKee+RoKtKAvfGbd7ImSXWTa9D2lCXmOfr03Ldl+cyfwPYtqn7CQ9B9iHIyzHHWtt/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(52116002)(66556008)(26005)(6916009)(2906002)(8676002)(5660300002)(66946007)(2616005)(6512007)(1076003)(4326008)(38100700002)(83380400001)(66476007)(86362001)(38350700002)(8936002)(6506007)(316002)(6486002)(6666004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9xu6lQZTmux/dXwQ4IpuzAnPiNeocGxsbZftV0GIRljyjSLeq0muiI8Uq+9F?=
 =?us-ascii?Q?yVQQGsQVnkXWYLdVCz7ZCZor09sSSlAr8LcuiT+f8DydsH7Kq4Lg0rMFMYaP?=
 =?us-ascii?Q?S1sB4qnVR7dmVwTE6AUbtoS6TttDy8nPPZz9dC1EQ9hNKIQeXU0xs+DUWba8?=
 =?us-ascii?Q?5x1G8DA4+t7s/clmTlfs2UEag4SOKN3Q2kxsSTN8ftKTdd870eBTuQ63f/uU?=
 =?us-ascii?Q?szTWh2/K+MY8YmNvpkrssd2vhb2rinczM16D/5ndzXcIp9TmLiWtG4AbaVRs?=
 =?us-ascii?Q?VX1eVclemVv3BjrJgS5Y6WzVdoJPGZUvMRy08dV9DEgxyIwloMehOwhtsTXB?=
 =?us-ascii?Q?ig1UsR3kYD6ph+42e74tOrafmORp05NrGxNyed0+bwqgdc61TVJQvTF3hi34?=
 =?us-ascii?Q?0kFX3YwXuCpkLNnt/rirYDvYzGqot/cE/uET5puJrd00HPhF49FWmCIJPuTV?=
 =?us-ascii?Q?iXAIugAPnIzGd9FUugccN1++6kgH/JdREg7EH2Al8CReSTmz8in7U8RxjX0t?=
 =?us-ascii?Q?9vMq9uv5UZns5tHkX2Bc+pMO3+JDlyY2Nd1VHizW4aV8WaPdl5K/jcoO4Evq?=
 =?us-ascii?Q?h+c3GnZDRn/YwFsbBf+EPN+WEQ2uTw7PW89Pde37DLdpVAnYaAQayCkGYGH9?=
 =?us-ascii?Q?j8Y0w/AwsXbryPl9AY7YKKCkvwopjUvR8DM5QR1cgc+mKXfnmwhUoGMPXZVx?=
 =?us-ascii?Q?ODtVr8yEhIOb4sPJx24SNCqWXPVPmuH7bjym5dBkX8ehpY4DQZgZwY7BFvLx?=
 =?us-ascii?Q?00ZUWeNGGEpuz2AQ1X4czHxa7WU7CBMpwXCdgsTlsWnfdDmtnASXrorKGm1H?=
 =?us-ascii?Q?bTm6NdpY27A1NFzO8ne6uPb7fM8WV24FNxXHkUz3UnqcbmtzJsZWRcLtlLZ+?=
 =?us-ascii?Q?vsSmuRY8nZvsS5vhEgGvpYSZnbUvoiKugX21CTjGkvpZpi95exA/3tsZGx8s?=
 =?us-ascii?Q?0Iw4tbE/vvDRF4MMSC+n2/CZ3UBqE4ZvfBMmArzIr3inNqA68wo6drBlwAjN?=
 =?us-ascii?Q?DBCpDV4UszI7AdtTobo2tD8JmQfL4IG6vIS1gC5JWY37yBE0pwKoVi0yWPG1?=
 =?us-ascii?Q?uulvI0UR9eExnV5MtJpclMPAQHyVTC1JFxLs9q+kWqd8z4NIUXu1S8N0gatF?=
 =?us-ascii?Q?u99RzfZ8b3dbSWaNwKuNmLeQbdeVMI+S302Qb1pw04bspczd9DFWeLbHlEBi?=
 =?us-ascii?Q?3UtWNXcpxTFXPV+u5CEEqpkJ1lZQkbBG1w650rixwuex3cFO3+hodkb7e8EX?=
 =?us-ascii?Q?JaLd4aclnm9ZWBBrriFo9LfdmnVfDuKZKBbP43b/Y0qWQpctHWzdVpl6TgF+?=
 =?us-ascii?Q?l1LsZ/yg/fYW2mEVLzdv0wMnGhGuY6VS6GR74wlu5yrSgiw9XOWl6JCGQI2R?=
 =?us-ascii?Q?jnwzDqxSZDX8HGiktRW1ITD25XuCZqluIroD0rmmioJADdnSkudiY1VqvwR/?=
 =?us-ascii?Q?AmyMVxpQ0JE8t/Z0rtfo5c9ccXJgPju4h0sA6CUbO7Zm8x04OFSJe9LhU1el?=
 =?us-ascii?Q?rwwWR+1wBdHZ2e84oRuYlrEyiraXgQrrSHF+2yDdWVmTbhc6qECIUh87q5Hf?=
 =?us-ascii?Q?LmiUg/ngerqUhyE6UBa7lPSEDpDSHk/fk90gQrPp8oAQrprsh0D0bvRXbmvJ?=
 =?us-ascii?Q?lbpAyovnnDKmYAvVBe1JT3Y=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58981698-c647-4df8-d7c0-08d9dc9dab1c
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:19:59.0749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9V7NHQak8dkW3yntbgUI1oLwAKrpW9IEWitqLsIcJBczwsxYq7WscoPykftwngkcvSZZgrPkPSaPn7dU9uyXUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1287
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210037
X-Proofpoint-GUID: xLriYk5k-f_It5ddoXf2eQCErz8s6UlO
X-Proofpoint-ORIG-GUID: xLriYk5k-f_It5ddoXf2eQCErz8s6UlO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The following changes are made to enable userspace to obtain 64-bit extent
counters,
1. Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
   xfs_bulkstat->bs_pad[] to hold 64-bit extent counter.
2. Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to indicate that
   it is capable of receiving 64-bit extent counters.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h | 12 ++++++++----
 fs/xfs/xfs_ioctl.c     |  3 +++
 fs/xfs/xfs_itable.c    | 27 +++++++++++++++++++++++++--
 fs/xfs/xfs_itable.h    |  7 ++++++-
 fs/xfs/xfs_iwalk.h     |  7 +++++--
 5 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 42bc39501d81..4e12530eb518 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -393,7 +393,7 @@ struct xfs_bulkstat {
 	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
 
 	uint32_t	bs_nlink;	/* number of links		*/
-	uint32_t	bs_extents;	/* number of extents		*/
+	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
 	uint32_t	bs_aextents;	/* attribute number of extents	*/
 	uint16_t	bs_version;	/* structure version		*/
 	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
@@ -402,8 +402,9 @@ struct xfs_bulkstat {
 	uint16_t	bs_checked;	/* checked inode metadata	*/
 	uint16_t	bs_mode;	/* type and mode		*/
 	uint16_t	bs_pad2;	/* zeroed			*/
+	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
 
-	uint64_t	bs_pad[7];	/* zeroed			*/
+	uint64_t	bs_pad[6];	/* zeroed			*/
 };
 
 #define XFS_BULKSTAT_VERSION_V1	(1)
@@ -484,8 +485,11 @@ struct xfs_bulk_ireq {
  */
 #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
 
-#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
-				 XFS_BULK_IREQ_SPECIAL)
+#define XFS_BULK_IREQ_NREXT64	(1 << 2)
+
+#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
+				 XFS_BULK_IREQ_SPECIAL | \
+				 XFS_BULK_IREQ_NREXT64)
 
 /* Operate on the root directory inode. */
 #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 29231a8c8a45..5d0781745a28 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -893,6 +893,9 @@ xfs_bulk_ireq_setup(
 	if (XFS_INO_TO_AGNO(mp, breq->startino) >= mp->m_sb.sb_agcount)
 		return -ECANCELED;
 
+	if (hdr->flags & XFS_BULK_IREQ_NREXT64)
+		breq->flags |= XFS_IBULK_NREXT64;
+
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index c08c79d9e311..c9b44e8d0235 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -20,6 +20,7 @@
 #include "xfs_icache.h"
 #include "xfs_health.h"
 #include "xfs_trans.h"
+#include "xfs_errortag.h"
 
 /*
  * Bulk Stat
@@ -64,6 +65,7 @@ xfs_bulkstat_one_int(
 	struct xfs_inode	*ip;		/* incore inode pointer */
 	struct inode		*inode;
 	struct xfs_bulkstat	*buf = bc->buf;
+	xfs_extnum_t		nextents;
 	int			error = -EINVAL;
 
 	if (xfs_internal_inum(mp, ino))
@@ -102,7 +104,27 @@ xfs_bulkstat_one_int(
 
 	buf->bs_xflags = xfs_ip2xflags(ip);
 	buf->bs_extsize_blks = ip->i_extsize;
-	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
+
+	nextents = xfs_ifork_nextents(&ip->i_df);
+	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
+		xfs_extnum_t max_nextents = XFS_MAX_EXTCNT_DATA_FORK_OLD;
+
+		if (unlikely(XFS_TEST_ERROR(false, mp,
+				XFS_ERRTAG_REDUCE_MAX_IEXTENTS)))
+			max_nextents = 10;
+
+		if (nextents > max_nextents) {
+			xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			xfs_irele(ip);
+			error = -EOVERFLOW;
+			goto out;
+		}
+
+		buf->bs_extents = nextents;
+	} else {
+		buf->bs_extents64 = nextents;
+	}
+
 	xfs_bulkstat_health(ip, buf);
 	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
 	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
@@ -279,7 +301,8 @@ xfs_bulkstat(
 	if (error)
 		goto out;
 
-	error = xfs_iwalk(breq->mp, tp, breq->startino, breq->flags,
+	error = xfs_iwalk(breq->mp, tp, breq->startino,
+			breq->flags & XFS_IBULK_IWALK_MASK,
 			xfs_bulkstat_iwalk, breq->icount, &bc);
 	xfs_trans_cancel(tp);
 out:
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 7078d10c9b12..38f6900176a8 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -13,12 +13,17 @@ struct xfs_ibulk {
 	xfs_ino_t		startino; /* start with this inode */
 	unsigned int		icount;   /* number of elements in ubuffer */
 	unsigned int		ocount;   /* number of records returned */
-	unsigned int		flags;    /* see XFS_IBULK_FLAG_* */
+	unsigned long long	flags;    /* see XFS_IBULK_FLAG_* */
 };
 
 /* Only iterate within the same AG as startino */
 #define XFS_IBULK_SAME_AG	(XFS_IWALK_SAME_AG)
 
+#define XFS_IBULK_ONLY_OFFSET	32
+#define XFS_IBULK_IWALK_MASK	((1ULL << XFS_IBULK_ONLY_OFFSET) - 1)
+
+#define XFS_IBULK_NREXT64	(1ULL << XFS_IBULK_ONLY_OFFSET)
+
 /*
  * Advance the user buffer pointer by one record of the given size.  If the
  * buffer is now full, return the appropriate error code.
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 37a795f03267..11be9dbb45c7 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -26,9 +26,12 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
 		unsigned int inode_records, bool poll, void *data);
 
 /* Only iterate inodes within the same AG as @startino. */
-#define XFS_IWALK_SAME_AG	(0x1)
+#define XFS_IWALK_SAME_AG	(1 << 0)
 
-#define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG)
+#define XFS_IWALK_NREXT64	(1 << 1)
+
+#define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG |	\
+				 XFS_IWALK_NREXT64)
 
 /* Walk all inode btree records in the filesystem starting from @startino. */
 typedef int (*xfs_inobt_walk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
-- 
2.30.2

