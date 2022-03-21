Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40257C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344376AbiCUFU1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbiCUFUW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:20:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686AE34BB1
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:58 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KLu9iK029266;
        Mon, 21 Mar 2022 05:18:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=NBmyC/j5wjRQ+Picixl9YqR449DLQNV6SDqiIDeE/Q4=;
 b=SiWa7ovK9T3ckEAYOdeDefopXhNQJBwbKU0udCvsKWkv0HzE4kCdgRiMn5kNsZpXxE9W
 uPsd7DUt/uKecgSsL1oj9TyZkOyAHbCbTUV9K0cNECf2CMjbEfO9unjv3qMhfC+lUILg
 wRqRDwAIDb9HlSAGRvJ+SVtL9luSAJoT0eraI8MrqAITrz4xoEUdQ1Sd01ijxltwyu0g
 Xru/ZCNEekgAy74dALwrEpR0yliWwyUuDIHtuD48LIhF/Hp3d3XL6LBFPa8Qmf7ux+6J
 +HuXlvHXEpUKQs5LoelL9U4KWt8fBTsI2V2hy1SH+rN45rJrH63n7hN5fWMJtbJwWwZE 8Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew7qt22vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5Fwir057906;
        Mon, 21 Mar 2022 05:18:54 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2046.outbound.protection.outlook.com [104.47.56.46])
        by userp3020.oracle.com with ESMTP id 3exawgev56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbpPUG9yPIy6roG3FckVGlglHrSVETXhZVjxxl/e3ML4b2LZukqHunNkiQ0fK4Bc6YPRY4QIdIf2vSa6mSRyfalJdiGi5JMrfXTXx7r3SRuQHRUm5B4ztEg7YM31TpJCCLA51EbNgarRQ6C82yRI7uOIw4/jxIerkJv3gcsecfyO0UKxrqIWufzB2KqzxGOD6Q8Cepjxu1EeizQJ0KRviLo65US+35yjQ7GGUXNRA+9uji2K2MOH2IlPTelKJmHARgCWG128UiHd7nA5728CS/nBIO4YHqD7bVURX/fH7vgUstOjyqFyv62QFMRyjpOL21tHer1jCqbZlkFLqnFp5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NBmyC/j5wjRQ+Picixl9YqR449DLQNV6SDqiIDeE/Q4=;
 b=M/Zqck4m5fNeS7embUjoxrFZbUg/33WY/+UZkvTryNuBLQ2UhRu3JpwgzhOzYt9CzlBnUOCMFGN59xMFYEZPnD89NeFeBppfUEf/q6m0OBY0vDu9emGcZ3vjjj+D4QArkVP7XnCanAKscY2w/7cFrYYROB+AgtICJKNsslwRwwOSU2bX99ExdTg/cR9lBdQZHf53ffNDgnG0vtgORy3u4JGpAluhFukqzzpk+1SyJDTJ1q5vTMEBEY17X8bSz4kdqnIrW2a8/Nse6p7grknbW/GSVRXocSvcZ74AeHcDzED1YDlikzIiQWyAEO5XUusaFO1CDNkcUa9tTJPxUMhx7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBmyC/j5wjRQ+Picixl9YqR449DLQNV6SDqiIDeE/Q4=;
 b=IXJ0S85m9ExVw915FL30JphfhBLDrzvB+lYg3clIeqf61SCW3LZQ2MCNpPI3rA9Dk5q/45LoB5c+KgViOrEqPi0vUoUiT2tGsjxz6PPnPxalzJMjUvFE7ddmoylKQWNcpVh3Yb7bLwAq7iCKNJsMTyYJ0FEDKOWPNpHQJRhuwr0=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO6PR10MB5537.namprd10.prod.outlook.com (2603:10b6:303:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22; Mon, 21 Mar
 2022 05:18:52 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:52 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V8 19/19] xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags
Date:   Mon, 21 Mar 2022 10:47:50 +0530
Message-Id: <20220321051750.400056-20-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321051750.400056-1-chandan.babu@oracle.com>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0120.jpnprd01.prod.outlook.com
 (2603:1096:405:4::36) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74cff524-aa3c-4c4f-bcb7-08da0afa49d8
X-MS-TrafficTypeDiagnostic: CO6PR10MB5537:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB55374235F748FD167AD914E3F6169@CO6PR10MB5537.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NpgLvLkZKkue887LaRR1HhVpOmQavDwbm74MOqvgqrWuAa3B+5q4VGW05wLd3AQduQ7iXMP0LXQ7M2D+tPLMRsKmy+aM/juCQzpj3OSpPWwJTc0mx4p77jJ/PMP3b0OmnsHndpE1P9EZd2zJdPPDOUsMZw1pO/FQk9yIetgEQIVkVO+Dv+9x9H89uuHYnH1AP4Wi+lxC6Lf9cYB8T5Nrw8GrEJ+BOABiIi56Gdzu94UO5evuMYTvp2CLraixvABnLN68gqIxTw0daOEMcge9YNI5Fk/3D98m0nM9Ba42eD58PYnIIoHgGsZDGtlAcHWyn5baP2CLsAgaZyuf/gTf97tliLvPna4DFg0YOj+uV0Is+lamJ1YIuJ2c2XKSJ1HFSpC8hyLBmFMmIN72BpU86mWGwiQviDRZ0orY0M4Ehit7Fd9nKGyCniQfza/jzn06AUnFtYpw2ArR9e2gBjSkZMcoX89yjedKUWK7Pum3zGy5YjnkY+OG3bdoS1mVERzTyNo79U2Zr8vHmtCrJZYLfTPdErAQsaCaSjexPRu5B2bQafVPOe9iGyilgruleldGwSzugiDVX4IApN7KWfzmy3hM+479fDdODlOJThp0RI9Mhh9B9vQR2bok02yTSL4Np1UXlhNmM7PrSeUnM0JyrBGJ1gPkDDddOAA1GsLD1OKOe+V9bliFrLMJTJXpp8KPtWAAfiTSu8dxBCupu/qKlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(2616005)(4326008)(66476007)(66556008)(66946007)(6512007)(6486002)(86362001)(6916009)(8676002)(508600001)(316002)(26005)(36756003)(52116002)(4744005)(5660300002)(8936002)(186003)(6506007)(83380400001)(2906002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5qPJ0ipJjznPUMsbSEliMaujt/M7NMlEnq131XpVz15p2lVrgqsLwUNNw7Bc?=
 =?us-ascii?Q?Uyocv9ZUIOqHXupKWqo0CakyieTPjV+muoDpm7RSt72S9wWs82z00DAmMx7N?=
 =?us-ascii?Q?113Drzh3TzqoGbJVfYJssBkI4m5ZYsJ4L0lo/I42470PbU52tUsybSXsQnGc?=
 =?us-ascii?Q?rYNINyFGrTboctgJ3NLf72Il6lNAo0+JzoN+bTnKygekbaYpGZWPNVDUnrdZ?=
 =?us-ascii?Q?xZlD3VMZUPv8tmrqBOqM0wds2rfsO9VSE2wwXbetVa37za2kCSWiPA7NeTdH?=
 =?us-ascii?Q?Fps9eEX0dWlkEy4SPiHGcrkLu8IUxghe20pa2FfPCqSch3PxN3pYtQMsaGle?=
 =?us-ascii?Q?+psBX+Oy0KSClZRPjeLS4c5eFeQVK7oPxuyMrlrbEtrIOa76PLoGErzC0qwq?=
 =?us-ascii?Q?/VCyXjakZl/JeHMhKzhnsMV/OVwNsZLAQWJUhisdYoQ5vi+GM8DyguSBQJpa?=
 =?us-ascii?Q?3rEae1HVY4ebyY+Ipp3nRJvi0TBiJWMt2E/aUAsoAo6S1punQHuCBUPvCUaO?=
 =?us-ascii?Q?uRaAlUMD718gapwoV3JfdDNddSvC1bV7pbO9SgRzw/GGxg6v8Yb41O9ptBKu?=
 =?us-ascii?Q?h2PF1unmXTx6zjcGbNWIIADBYtvW+/vVQFxpFwGN19uNBXdi2EQRcy5cwjeF?=
 =?us-ascii?Q?Q4edWbyGBb2iN4LSps5pC0HwJlHUJbcoAcm0qFKLHdX12PvQkJsakitVkOZr?=
 =?us-ascii?Q?CwXgit06rfidy2RAZVmEzkuCWGFhMDBqfDyEoXTsEvTOwSEpxbfaZN/KEshI?=
 =?us-ascii?Q?lK9KVqFx6vFw/4CechsQ9Z99HLw+mKqXwkxUvdwTuYomVFG1lIl00qTM+G/A?=
 =?us-ascii?Q?fQ7eX3JCJv5FBgUppYlUCFH/0SebdWgXZJTGHJL6I+kqVX1PRF+n+j39QXXm?=
 =?us-ascii?Q?sHufsIj1//uVZl4sxztMCAuFHlIJcT2/OmHDD2gcYZ0BuqmNudd+EVR/sJ/D?=
 =?us-ascii?Q?00lfMHnCeY76nPXC0g/+TT23AUb+oA7DxOkfT7IJOtIRK8UA87C5V7zKqUtx?=
 =?us-ascii?Q?0HZ3mDrlaY5buMOYAINHJFMXy6t+4ZQEsZ9CF5pl4+ihCUOKqDVvTvMQLRxQ?=
 =?us-ascii?Q?rtw9UJvue05Vbi3wnUyMbMa7jzoeXOm1dGLiwNnJ/EWh6EkBJiYpFIljW6E0?=
 =?us-ascii?Q?Xa9pDzobmma02KUBNuQbpiORs3YZcwqM1E8jXPZBo+yqYdyu/2u4bvWJYSm1?=
 =?us-ascii?Q?6Xx7ksQwrUgDrxGZnQIeWO2G5mn8DBjk583GxIlhDibiVhEWnr50XJQbyY3a?=
 =?us-ascii?Q?9KbM3/hX8bgdG28U7mCust+B0qh7yn1npLR6Lx5mvFcVOywxsrsSmc9KKCUo?=
 =?us-ascii?Q?JXXeB2pgfM4B/aa1vfIZrBRpk8ZgRW1ZrPSkZgdsOzAn+wl+FWq2b2jrr8rI?=
 =?us-ascii?Q?E0xskwdBBXz48hA1Yy/nhWTRs729EbikEbniPw6V0+rUNU7qi7pVVsIpwnAw?=
 =?us-ascii?Q?P+0s8GuZY6Ey1pOwmJ0E7mzS030JOyWNJ6+/fpHrk6Ui7Ny5K6HUGg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74cff524-aa3c-4c4f-bcb7-08da0afa49d8
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:52.5576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: juW7+Oz1/aZzkicEzWcNgqw4I5dnUdjvwYFKAi/sZKbIuJgGKDLmBSAIB6KrQmCgI6MQMI1PRTQPfRkTNx5STA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210033
X-Proofpoint-GUID: GGAKByvdhh8dYIVeUdGuEfMTFPREwxcp
X-Proofpoint-ORIG-GUID: GGAKByvdhh8dYIVeUdGuEfMTFPREwxcp
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit enables XFS module to work with fs instances having 64-bit
per-inode extent counters by adding XFS_SB_FEAT_INCOMPAT_NREXT64 flag to the
list of supported incompat feature flags.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 82b404c99b80..25a157b615ce 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -378,7 +378,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
-		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
+		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
+		 XFS_SB_FEAT_INCOMPAT_NREXT64)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
-- 
2.30.2

