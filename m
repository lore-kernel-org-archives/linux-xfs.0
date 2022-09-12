Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B43FECAAD5
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiILN3l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiILN3k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:29:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7AF64F0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:29:36 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDEGCd020724;
        Mon, 12 Sep 2022 13:29:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Y3n3A1Uww99KnV/SKc0MFBrCF67oNe7REf5nEpt3wLQ=;
 b=b/GD1do5Meq6vWUomdPidWcUDm/NDqDEp/srIrWBhWfTmB1HTg0ngX6mrYJLrlJogn5M
 BLJ79/O8/ygf9Prz7IkAtLIHEzyCPElHrssuNkmrhk/t1xycWW3Oac6M6ZvwPOly8Ca9
 yIVONNWZlSZm9IpC5WUAnxdgfHw6HrHN0yvRI9EOJwd/mEHa8rEEC4a17AHVKnwTq4lY
 5WV1txxX8wBTUoZkuCImYz9aKJuyka3UzwIolPLlfBpZbyU5SX+mYTcfIcJZKL3rZmd+
 WnjRjr+PPUK9q53eV6zDJrxwsjpANvNiLjRSJSMOHfNeAdXMDoXRyyyWcpV8r2RSZLc6 GQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgj6skfbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:29:32 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEihv017042;
        Mon, 12 Sep 2022 13:29:31 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jgh12hpqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:29:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9RqO5/uNkJJckxqCF7I6lKj6iFKy8ZXYBxatKiKBjfcLIWbzEJKUhB5NWv/Iw+4jZnNjuDr8Z/xmwggK3zFoZSVEuPoEp1FdlPdaNBdrca2XiFNaVUSKn5RPATH095v5Lexf/tIOzCojryibJSe2GfIZvhkmfVqra2KPcBvMUL9MGZYDWwspREVddbbayG/T1YfPqoKOZMble+Npx6XxLfHgDY14vzg6xWScw+tT0pn/7xdIwmj2olwSiZSVVi7J10B4e1ap382mLlUSRcq7o/tP4NaZgTqDyJPeSd/TnrvwLKoAs3ZU+5Fklw6owA7Et6Q5p50GlkCiSD95JIWMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y3n3A1Uww99KnV/SKc0MFBrCF67oNe7REf5nEpt3wLQ=;
 b=R1TJ4gszkMvAxeDYo11wniYitzy4n8w5tQMgKfTNaDKwux30I8pMAS1rdCSn8lb0jMGzHf2KA9QmdCxc83+LgTLSrB5vp4WemWqS9nfBlDpOpZ47kN7L5C1IaIujtujXakGVcbsnSyH/p8N2AmosB7x0oJLhINOO7VVUv82K3xS63KQ9uwOmp4VpbzAdxipmmuHMEFB4o5UgQSs6adZNRfYqudONQ+CanpE1XjL9XkJI8hyNIKSCEjf8h1sZJNmcKleGy5SGB3X1hKB0twzKzoXNWG3ltoDtaMqAwOmFlE7sHYwaVWZWMw4xh5vMhG3PoJmM2CbmUzwTp9kstwEkIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y3n3A1Uww99KnV/SKc0MFBrCF67oNe7REf5nEpt3wLQ=;
 b=dqG+2h0I5idqkd/575djaFc68mQd4+BV8WTOqwjBlHLSVpW8z/gQXcCniKCcLoxHv0JF4HnYMO0WYJ0d6MdldobtOgHWcXR59yLUag/U9x+6XVPWXKWlX5Rgc808I/ExNrS1mieJDG+acNzdVUmh9/lndUBKr1yczGOdBzPTzm0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MN2PR10MB4318.namprd10.prod.outlook.com (2603:10b6:208:1d8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 13:29:29 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:29:29 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 14/18] xfs: stabilize insert range start boundary to avoid COW writeback race
Date:   Mon, 12 Sep 2022 18:57:38 +0530
Message-Id: <20220912132742.1793276-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0057.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::10) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MN2PR10MB4318:EE_
X-MS-Office365-Filtering-Correlation-Id: b8639131-95e7-47c1-7858-08da94c2d1ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fTYQU6rXn8j+cXe5QqkySpF4ueCzuHxws19bFABaxD7KogPq67Nvb5Zp0fudzhcJqYjtlHH6lddnhfK/zx6USWuSCW/iy8Zy+k7BkiKVtlnMbOmR5VoywX9pzifQr4FgTN5WoeH1XUOWXwAsV7OQBz809gvBJf8uF1jEHeL1tVdFJMBb4DahSeS+mBw1m8bKDTRKDH2HBuap5x+nY3ozSyOghABIGRs5OjJx7DVcKgp4wsTP3TdZ3QSCutqRCYWDvdoOGzMIjK7cNvmijkvqAjaCQL1sOkNrX0fJwqHh5oiZAUJEkNuNKipfOUMuyLOOYnSiGf3MQqatwtYKe6qkEEnY2RSmoL4WdQK1UKNIInnJA5zKTXlLZv/BVB157NOam40Ri+S2mVPjFgHgAiEVcHvOZFpBOHKteNITGVYlVBNFgQdBw9THRUzjnfGujmvOUbrLr9BUPKCrorvv48MvN94zqKVUebrDa0WQ2vTh95xithwKpWoUn0JJw9vxlzHJaBtOGXDsrH7Tn05j20iw/Ze7O3gArCxO7doss0oUVVfYmZWmoW9/4+f06rQzJPOH/KSnlY3883sBxO7jBlPUBPfJNP8EE9lhOBsP685kCZZvcIlHJCMOZsowSUAjVRLtcxdNTgREBDjzG/FUTHuIQWh4bX5pN7WQtcn/soD0FB3ZTHdMWFbtLFcGKHNlMwie0pkwwlP7PIyaP4fZKZRbwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(346002)(396003)(39860400002)(366004)(1076003)(6506007)(26005)(478600001)(6486002)(6512007)(6666004)(186003)(83380400001)(2906002)(2616005)(8936002)(5660300002)(6916009)(316002)(41300700001)(36756003)(66556008)(66946007)(66476007)(38100700002)(8676002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ezy4dIo7f8PKC+qQHDu0kFu7KiFtNvGmfKJX7eDn27cPC+Lq8UIPSsKpMWI1?=
 =?us-ascii?Q?jp58AtaPoCw30lPzXNFmg7060YzNH5NQuUbI5nnERAl+jPPqrm4aTOW9RPTe?=
 =?us-ascii?Q?8TeFSGbDik2Z2KMBPP1VkygyKn8Cm7Ll4qspJCeuR2qNHwxU1zOB0ahJ77lq?=
 =?us-ascii?Q?otaqWZmgXc6HvfznKZahgDuS5LBQOfxdhD5f7WM56vIZpn0BawDnT6puobrO?=
 =?us-ascii?Q?ZPdGpcwpzJg+dfQlYgmasVcl2BSdsTe0yRhX4Y7zEK/GC2X9Yx1EEMcWEAzA?=
 =?us-ascii?Q?etk1lft12FT/F1MJc9uZ6apgFYYPphE8tXwPpc0MFCzBlN2IQnkJN9/HW39I?=
 =?us-ascii?Q?/f5QLxdk7Ycj/sM8b2GjHVaXlfeNA183KAOsAf3/USvWXDHkCYSV38QbIA2Y?=
 =?us-ascii?Q?1UpwDf4VVXiepgcdqDFYmEsCkMVPMWsJb0uyuHllbQe7WIoPKU+QzVOJ6t4j?=
 =?us-ascii?Q?1TeHaaSv0akQJ1Rej0ElbTtKJ+63+AfsfeUuW+A1FoGwWZc93RDTR1OZWvgo?=
 =?us-ascii?Q?ZfN2+EQdkkfwmdZitn/UJwHaZu1R7nAsm/2d86rcYmxjb4zQmEtH4NzUjlgs?=
 =?us-ascii?Q?hlNZY8BH7aPFdl9bFrs2ujJLTEcdgEDUgAgbX8n91aSW/36tN7Vu+0rdl7o4?=
 =?us-ascii?Q?AU88uVFPd1gzIny7PBGokPq+rhPvI/e7oXkIj+ewyqOD9nQ79rfZ4kX7AIJE?=
 =?us-ascii?Q?rz60TrVj28goUeI3zYjsCoB9Sj6On3Qsdtvwria2k3zNlRoCr2y2YwecTG5X?=
 =?us-ascii?Q?wLD5QpRHOMEWVJKy/OstNxAvg1FYznt2lZHaPZQhZMD3+VH9YA50phGtPi3D?=
 =?us-ascii?Q?oVZtJr6JnILQ+poM8ISAd7ZL8NZsh/3OM/sOYI5FR+9abZhar8XyoubxAlsp?=
 =?us-ascii?Q?Qe0+rDkGGKSbm/VaIQnvH1XvNmrE9LlJelWaVkMcZvOsRkRBSGJyHvE7dl9b?=
 =?us-ascii?Q?tZxeEmUxCCZ2n5MEpqvZoUIO7cXSVInS7RzEkB8W/EUjpp1WzDmxbcHca22X?=
 =?us-ascii?Q?Nzs0CDqiJ5rwsXJUHLm6qtUEC/MxciMlaO2WJ9KwhTCKrAaLIxEgxvSI5z2N?=
 =?us-ascii?Q?fS4F1yufbaLPAfBU4jUT+OTbqJ9G5K1B0YKjXKyUfNmkQSr4e6NUuMUMjC+B?=
 =?us-ascii?Q?Pf6pLCNvyj6J7IhZgaIpP0gziDwBOeVXcXpwmlWZhUEniMtYEtVZsijt8VO7?=
 =?us-ascii?Q?umtr9hMbEY/rWvEYAGLwWty+DQql9kX964RmAE6C8ydCbyFJhZZ4P8+3MO1Y?=
 =?us-ascii?Q?dE9ZaN7zShJcYj+h4QCQ/eJtlwPV6oitMi3QlCCeO3se/NTZNEKtn6xpdQUU?=
 =?us-ascii?Q?swjWXnHvria38lmTtk4Pxgb7bhgrXfXO35S6RS5GE5ZjILorX4OWKVbFBVvM?=
 =?us-ascii?Q?yNK6qBW976e20ggNbiaCQiuQ1OPa8Zb+PSNALg7AZr7PI5RkpJ7gRDuMFyTe?=
 =?us-ascii?Q?wxIYaNXRSNQ8iCbQ2/vcmNYkSiOChZ7zeKWazlbB26GWfZmi5Mf6sWspRy5M?=
 =?us-ascii?Q?aw4p5IJt/lkcLDrxbc8jw9n4EReQomV+eQ/ddDoOeYNA0gRo1RsVaAoPovyy?=
 =?us-ascii?Q?pPxgLkyNsXD/7b3LBr+teN1Yd1WIp909LIsm0CcOPHT97BbOCMSs2bU68F/K?=
 =?us-ascii?Q?xg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8639131-95e7-47c1-7858-08da94c2d1ef
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:29:29.6012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QMxFXPgop69/1jT+AcyZZKHlUnAUQfbO3JuJDWOrPS2wHHAeqw0rTzWpNWTZThmTPxT0IXpSxXPzf/4+vktv/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4318
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_09,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209120045
X-Proofpoint-GUID: 8SQdY6QZv-6mw4m-ob2tGak9ltt5z4qn
X-Proofpoint-ORIG-GUID: 8SQdY6QZv-6mw4m-ob2tGak9ltt5z4qn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit d0c2204135a0cdbc607c94c481cf1ccb2f659aa7 upstream.

generic/522 (fsx) occasionally fails with a file corruption due to
an insert range operation. The primary characteristic of the
corruption is a misplaced insert range operation that differs from
the requested target offset. The reason for this behavior is a race
between the extent shift sequence of an insert range and a COW
writeback completion that causes a front merge with the first extent
in the shift.

The shift preparation function flushes and unmaps from the target
offset of the operation to the end of the file to ensure no
modifications can be made and page cache is invalidated before file
data is shifted. An insert range operation then splits the extent at
the target offset, if necessary, and begins to shift the start
offset of each extent starting from the end of the file to the start
offset. The shift sequence operates at extent level and so depends
on the preparation sequence to guarantee no changes can be made to
the target range during the shift. If the block immediately prior to
the target offset was dirty and shared, however, it can undergo
writeback and move from the COW fork to the data fork at any point
during the shift. If the block is contiguous with the block at the
start offset of the insert range, it can front merge and alter the
start offset of the extent. Once the shift sequence reaches the
target offset, it shifts based on the latest start offset and
silently changes the target offset of the operation and corrupts the
file.

To address this problem, update the shift preparation code to
stabilize the start boundary along with the full range of the
insert. Also update the existing corruption check to fail if any
extent is shifted with a start offset behind the target offset of
the insert range. This prevents insert from racing with COW
writeback completion and fails loudly in the event of an unexpected
extent shift.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |  2 +-
 fs/xfs/xfs_bmap_util.c   | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e7fa611887ad..8d035842fe51 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5876,7 +5876,7 @@ xfs_bmap_insert_extents(
 	XFS_WANT_CORRUPTED_GOTO(mp, !isnullstartblock(got.br_startblock),
 				del_cursor);
 
-	if (stop_fsb >= got.br_startoff + got.br_blockcount) {
+	if (stop_fsb > got.br_startoff) {
 		ASSERT(0);
 		error = -EFSCORRUPTED;
 		goto del_cursor;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index d6d78e127625..113bed28bc31 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1167,6 +1167,7 @@ xfs_prepare_shift(
 	struct xfs_inode	*ip,
 	loff_t			offset)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	int			error;
 
 	/*
@@ -1179,6 +1180,17 @@ xfs_prepare_shift(
 			return error;
 	}
 
+	/*
+	 * Shift operations must stabilize the start block offset boundary along
+	 * with the full range of the operation. If we don't, a COW writeback
+	 * completion could race with an insert, front merge with the start
+	 * extent (after split) during the shift and corrupt the file. Start
+	 * with the block just prior to the start to stabilize the boundary.
+	 */
+	offset = round_down(offset, 1 << mp->m_sb.sb_blocklog);
+	if (offset)
+		offset -= (1 << mp->m_sb.sb_blocklog);
+
 	/*
 	 * Writeback and invalidate cache for the remainder of the file as we're
 	 * about to shift down every extent from offset to EOF.
-- 
2.35.1

