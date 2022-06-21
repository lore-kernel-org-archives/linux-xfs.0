Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B193C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jun 2022 06:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344836AbiFUGuh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jun 2022 02:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiFUGug (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jun 2022 02:50:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FEC1929E
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jun 2022 23:50:35 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25L0whbh012569;
        Tue, 21 Jun 2022 06:50:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=u0BHQfMom8rDaqZOv+VAGBLGTQuslGOeno0cK4JygbQ=;
 b=vDggeeFEFfiS+4MTgOC0/ALFgam0HmdFVAoqAQvLDZVh7nuD91ApbdzXV4gkW8/faV4i
 VaChuQvuGclVYpuZ0ofJVfWm5uR1aq4hKWvH2qKYvTkZxiQuUAfSpL4XkRgEyGfK3sx4
 /u2f8g7DrPNCe52bDbF5utkJDwlfpOUTPQUmV7wnz8aawSdN1HgPX4byhXi2gN+fM4Iz
 2e5cRNj6hopqogdrCkhuKIbASzLLr664crYe23WrG7Yyc9D21gGhvmBNakGULxqw6zWx
 f21DhUzGEbUb8D7N+2ZB+BRiz44vCT3gQNMU19UPY4dBM6TR0B+A3DkKZWJ0+NAnkixu ow== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs6asvq1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 06:50:34 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25L6oUaG035450;
        Tue, 21 Jun 2022 06:50:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gth8w0whc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 06:50:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WU8XAGEv7XR5KkPYiIuq/v8nxRiBoNsHiHrLmF2tFJWjVHK4dkQYuYNz1yNKkS/9W9+mi78OMt12UffXADEiUeq9uZfHSyqEV+rb7S+/DI7d1qq+kAp45cK3e7w2+usjxf7QDXhMQpnqMsvre7/nLkTpfj+MOCYJKSt7bQuoLGcYuCb/aEzV4FO1XMGNR5nPMrXF5ftdig1Mzts7+SwQOvKosd3aFkS7qW4nXK/D1dDFRsF9W+jeRubWo6uJK2Md5rqA0WX/tk41Exb983yPzfaiPU39F8dkHUtTEghxMylv4s8J0lTuCq5crMcNmRkayjgNihGX3hJFRyZX/rptIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0BHQfMom8rDaqZOv+VAGBLGTQuslGOeno0cK4JygbQ=;
 b=VXr7fDKTpAjkjv0Ljwl32g2PF07XE+2pRDNIZwOGOWvCvZqzD8wuEBStpqNVZYZyDUCOWlU6LZ0SmuRf/7XoYXJvgir7pYM05IPjk2YjEl7pkIhZdNS2+wogIUOnp6IYn3i2EYoHtSVJg1X/zs8C/Die7iBOcaGJWUcXx4WqQRy1nll12i/WnIIApgWBKUZ+tJxnbEOnwCUXcvb74PCcRklarw6Zf/5vw3GcB2YbmleCtDlbGPXfz2UiEURAyhAWcyUli3fdRKfGmxUurXLajfUhGSoMgGgLsgbBk58sM4Rn8LtXniDDHXJZM/D8Tk2NquOmcoKmuAwlgvTqBB2Tqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0BHQfMom8rDaqZOv+VAGBLGTQuslGOeno0cK4JygbQ=;
 b=Ph0FLz6lhzcLaNJ3zwvKZ9ZWCqNXCHwU2hIn8M3KQJdpkux8br83IK0oL5Zu09/yM/VpkeLwDTewDM4XTb2Qjrc9PqZRxrxCqST5w4HY6jj4wzb/ihT/l8boKlaz3wPJotMzhv2R7DP+H/hL5ZgPitFQkO/z8VErv4uxAa7VmxU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM6PR10MB3545.namprd10.prod.outlook.com (2603:10b6:5:17f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Tue, 21 Jun
 2022 06:50:31 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::40f8:b9ca:accb:8970]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::40f8:b9ca:accb:8970%2]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 06:50:30 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, sandeen@sandeen.net
Subject: [PATCH] xfs_repair: Use xfs_extnum_t instead of basic data types
Date:   Tue, 21 Jun 2022 12:20:10 +0530
Message-Id: <20220621065010.666439-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0123.jpnprd01.prod.outlook.com
 (2603:1096:400:26d::9) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29d343b7-8a3a-45b2-f3c1-08da53525522
X-MS-TrafficTypeDiagnostic: DM6PR10MB3545:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3545DD32B469F126A636AA4BF6B39@DM6PR10MB3545.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SvyDKKeH+jJ5RwrsACCCbKZLdWpvcNwbYeb6DaKJ6Xp3vRdMggMu99fXC7V5WwvwoQjhLpU2rkfRN2I4/s1+m/PObZxvC7Qc1YBYzp15hvW33IC1SeogrzYUUBoH5P7dbZy+Pm/OnaVYXzhiW8aFqr5ufVyoSU7x3RXF17h+6RoS6x6S3BDk7V48SQwG3Fv8rbGYIpjml2+WxEW0QlSkXJZXpqexQsfGJUA5UX0BA52lZcNNfKvi6RKHXBFvBWVujrRWffzIQuJFzkb4zsdYidyRHRR1EDnFevnE32sby5ZCkHo3bt2Ucf7yflCg1WURat9oOJoDPe0J08QStvfXKXPx+tx8yD92ZslDgWmdHWT25K3gmHB4yWHsbZJe78yvNg8YsylBi57lQ/RSPbprBLuIeHjDNBsyDqpGCrJ/WpKK9DEllemmvJZovxE5mtSfpN0Rar21uozaT+5KWazRami3uk5tIqTVcqok4pZFY27p4kqivjeInbh40+GktBcUD1asS9T0dVPuE8sH6a1FmuoF2ATg9cfQd7I0xjk8rVtfjb0LyiBg294p+x1Y83pxWqPcp6Vwwdn16KwBeLwn+TJU8XefUxhUxHViB39sS51K1IrHvQTR2elS8ITc7r4DWIhbR29BfyS+r10+gZBCSIvYXphDelarr9ArZPH0YBiE3lRyCiU2ndUT/BMpjCaPVpacJHLCKEZuGiTrIWScQPufF2Tpsbii+8b7VKWTKA5I2lnO0tYDPfTrGIpG3HrI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(136003)(346002)(39860400002)(396003)(26005)(52116002)(41300700001)(5660300002)(6486002)(66946007)(83380400001)(8936002)(478600001)(6506007)(2616005)(38350700002)(6666004)(6512007)(86362001)(186003)(2906002)(1076003)(8676002)(6916009)(66476007)(36756003)(316002)(4326008)(66556008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jua6jaj5Jci/PUgRYSTgJarwJtyny2MOhLQTXS5TBhsdexuhWVKQQqM8eVFi?=
 =?us-ascii?Q?ZVRA1zOUIm8JvwmAdrG04xCM6n/DVRXLra+hYe5jcYmXytktVpodhBqPpCDj?=
 =?us-ascii?Q?goTUDvO0P1ctmGjfl036sIK41j9HeNbmdfiucyK7VXMZh2GPqH3LpDSR9zhY?=
 =?us-ascii?Q?hzZBfl5uOx51OuutY8lCSagmvPyax0sqTfPrKmw7sOSC5z306MqJLgxTpVzB?=
 =?us-ascii?Q?foUrQR29tFgVuj+JehNeP9KNJSQ+zinARgWPNoRl2unxz9/gcjkGV7pqDA6G?=
 =?us-ascii?Q?PwZvWqcs641PsL8lzmGlglKDiuINuD4MdWKDeF33XDd124EO+wY4WwdWJUVt?=
 =?us-ascii?Q?AopbYIoP+kpW8oePjPlCpgKV5V5mJW4b4j1RdfoDvaODP97givcdJZiikLlx?=
 =?us-ascii?Q?YHMBZYXMJJEk++De9FAbcXgwuHATB/Fyz0gWx+X32I9KXuJR9t9NbL03yPEA?=
 =?us-ascii?Q?XTjJxB6ZFS5/f16yf3i1v1aYKUdKF11cOSnk1/PXJIQj1bq75JMCarsvzQoY?=
 =?us-ascii?Q?QkJha+eifJ/X93GE2dyHSpr4aVQRTvfhjBu/+AJWnDTxPqCSbXmtJX5iQD+7?=
 =?us-ascii?Q?qULmM5Dmw2pojRwbSqzIX6gR7f+TAOgBm1wCzVzBSfnrR4Q88GXJs+Cvu/KD?=
 =?us-ascii?Q?DVGHWFM0abjDUdGshEZgD3q7ONj2oJXstqtUTJmWi1PDJmYfKOj+weMGEqVs?=
 =?us-ascii?Q?A32aYmbQ8pHHDy8BPoEyyseCXC/RM2lhGMaLauLEgRD/rrgHWrSZaKDcj6Hs?=
 =?us-ascii?Q?XHguXtJHc6CXgh2utdAQKFApC9J32gTc2eFNCXBN35J2qFcLT/fCHLrlL4uN?=
 =?us-ascii?Q?cguMzzKOE5YXQEch/np+uyKzJ3h9XGQ/ugA78N4BjGX3/XSxsFq7Wb/OT0wm?=
 =?us-ascii?Q?n0426Q0p5Rjb4/Q2MsPDZk2hkzVsht0MmqGgSRlYEFTur0zzHiycnGEL+Kg4?=
 =?us-ascii?Q?BaxXlc4Z3hmH+f/FIOuWz3GjQMED/DV8gZVBWM7DONcqo85kRivZrPYRZVTm?=
 =?us-ascii?Q?UvM5cVQQ+HgwmbqgZXa8UFJHbPPX0mAkkcrUhw1l84JQUk685adkhz8dQRQ7?=
 =?us-ascii?Q?yB8yRsM457a7ojuVgyGm7qEPTjgBHiCy9u+V4S2Kw43JE9PX2OIgB5A+CW6v?=
 =?us-ascii?Q?72XQ1BH+NU1VJ/H/6aqyks9QR+jjuQiof/mYUd8sLta1FHcs3mNu7GWc0PV1?=
 =?us-ascii?Q?GHukj7dMh8L3WAIYJ5JhVP1/Rxy0Nd46TMv+jOXcPMn69OrcJXW/DfBxpeAP?=
 =?us-ascii?Q?Ly2e4qku0QGFQCxxNAa3nAp2EgVb5J/9OYdul5OdUusj4pXEj+ZxCiJNedkB?=
 =?us-ascii?Q?X0vRplTnGqdLoZUCrsoyZBdxQvHY9KFfIesM7SFZ70YmR1kLNR3/tcOULTYk?=
 =?us-ascii?Q?5jKcI47Ikp0r5bFSGln8MEWXESBN4DWBSuRes8qYR0NFy3l0H79i3w3+Q2Kt?=
 =?us-ascii?Q?BoyQoc02LwcRWsDyyn4M7+b9xG31z5100wAtNUGxAWBwwwQSlxazYjAyjJWu?=
 =?us-ascii?Q?RBRtlaojGS84i85Ron0ChLbE5ySjraGoxJtg94eC43wO4racgOwZkD0GqqeC?=
 =?us-ascii?Q?DuxOOkhf4s3760ICPGHUKiPBlX/pNivZ9Favq9Uyr5MnHMt0CfCkWcpvr02A?=
 =?us-ascii?Q?1lT4U+DuSGd2qYKMkOF/B8mw1WNw+5Pz3vyPoa1t64K5uIERdFOMooSwIwxO?=
 =?us-ascii?Q?A6zcWEnFl4h95ZrDJc1Cv3QPr2Njk4Cytlz8l0sStXNqOZouj+nkMtdXNvmt?=
 =?us-ascii?Q?t2wkdeHmzAuj6jWhj2c4t0dKytPj2aM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29d343b7-8a3a-45b2-f3c1-08da53525522
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 06:50:30.9155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SFtOK0TGY/W9Hhop7u/TLOJFsRnEskHzN4EqJQ2/8H5pZx6+DYqTYzMVA+sdW5QIBXqcLUHDzL5gziLadTX8CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3545
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-21_03:2022-06-17,2022-06-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206210029
X-Proofpoint-ORIG-GUID: ldLeCl85i1ywtvXO27ib77skFdGIN5a7
X-Proofpoint-GUID: ldLeCl85i1ywtvXO27ib77skFdGIN5a7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_extnum_t is the type to use to declare variables whose values have been
obtained from per-inode extent counters. This commit replaces using basic
types (e.g. uint64_t) with xfs_extnum_t when declaring such variables.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 repair/dinode.c | 18 +++++++++---------
 repair/scan.c   |  6 +++---
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index 5a02751a..71801522 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -759,7 +759,7 @@ process_btinode(
 	int			type,
 	int			*dirty,
 	xfs_rfsblock_t		*tot,
-	uint64_t		*nex,
+	xfs_extnum_t		*nex,
 	blkmap_t		**blkmapp,
 	int			whichfork,
 	int			check_dups)
@@ -773,7 +773,7 @@ process_btinode(
 	char			*forkname = get_forkname(whichfork);
 	int			i;
 	int			level;
-	int			numrecs;
+	xfs_extnum_t		numrecs;
 	bmap_cursor_t		cursor;
 	uint64_t		magic;
 
@@ -934,7 +934,7 @@ process_exinode(
 	int			type,
 	int			*dirty,
 	xfs_rfsblock_t		*tot,
-	uint64_t		*nex,
+	xfs_extnum_t		*nex,
 	blkmap_t		**blkmapp,
 	int			whichfork,
 	int			check_dups)
@@ -1794,8 +1794,8 @@ static int
 process_inode_blocks_and_extents(
 	struct xfs_dinode	*dino,
 	xfs_rfsblock_t		nblocks,
-	uint64_t		nextents,
-	uint64_t		anextents,
+	xfs_extnum_t		nextents,
+	xfs_extnum_t		anextents,
 	xfs_ino_t		lino,
 	int			*dirty)
 {
@@ -1894,7 +1894,7 @@ process_inode_data_fork(
 	int			type,
 	int			*dirty,
 	xfs_rfsblock_t		*totblocks,
-	uint64_t		*nextents,
+	xfs_extnum_t		*nextents,
 	blkmap_t		**dblkmap,
 	int			check_dups)
 {
@@ -2003,7 +2003,7 @@ process_inode_attr_fork(
 	int			type,
 	int			*dirty,
 	xfs_rfsblock_t		*atotblocks,
-	uint64_t		*anextents,
+	xfs_extnum_t		*anextents,
 	int			check_dups,
 	int			extra_attr_check,
 	int			*retval)
@@ -2288,8 +2288,8 @@ process_dinode_int(xfs_mount_t *mp,
 	int			di_mode;
 	int			type;
 	int			retval = 0;
-	uint64_t		nextents;
-	uint64_t		anextents;
+	xfs_extnum_t		nextents;
+	xfs_extnum_t		anextents;
 	xfs_ino_t		lino;
 	const int		is_free = 0;
 	const int		is_used = 1;
diff --git a/repair/scan.c b/repair/scan.c
index c8977a02..603d29a3 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -133,7 +133,7 @@ scan_lbtree(
 				xfs_fsblock_t		bno,
 				xfs_ino_t		ino,
 				xfs_rfsblock_t		*tot,
-				uint64_t		*nex,
+				xfs_extnum_t		*nex,
 				blkmap_t		**blkmapp,
 				bmap_cursor_t		*bm_cursor,
 				int			isroot,
@@ -144,7 +144,7 @@ scan_lbtree(
 	int		whichfork,
 	xfs_ino_t	ino,
 	xfs_rfsblock_t	*tot,
-	uint64_t	*nex,
+	xfs_extnum_t	*nex,
 	blkmap_t	**blkmapp,
 	bmap_cursor_t	*bm_cursor,
 	int		isroot,
@@ -204,7 +204,7 @@ scan_bmapbt(
 	xfs_fsblock_t		bno,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
-	uint64_t		*nex,
+	xfs_extnum_t		*nex,
 	blkmap_t		**blkmapp,
 	bmap_cursor_t		*bm_cursor,
 	int			isroot,
-- 
2.35.1

