Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6057BC4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbjKFNM2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjKFNM1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:12:27 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0D1EA
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:12:24 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D28Xd002119;
        Mon, 6 Nov 2023 13:12:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=TIIT5iWYXUdP6+gBKlVmMeZLeNQuOUyWfCTqol6iMXw=;
 b=Acxx4c9uXB6zMq3dOB9nfcOAnkzMLGm1ugI1L99kc0tSrl/mrPWPOHPJrbaJn1xEU05d
 1V0gs4AFKOYUXNkLkRcB+gbjjuwjjkDCE4oDRPEjqQJM//bTdB6tQe2kqWSQPBwm+bOq
 ibeX6gIWD4qo2Z3BD/eB6xMlhx97r01ShKBjzeQVKXBsH5MqGj0aWhH89ScDK+AskRUl
 kdLNmc0lHxDW5K2FqjfXNqf5CKrgTFH+OBcxYwDbJ3IkK//Ct4O9UBl6Kxb02u6bkoKA
 f9si1n0jMvlESZ5We5N2aQPvSKepvMFXsFz/+rvd3PbFm/LjWNvUp/yh3laCnNvaAG2l /A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5dub2x7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:12:21 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6DARGN023579;
        Mon, 6 Nov 2023 13:12:20 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd4tc5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:12:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPDKGS6o7TJehXM7+J4EkB5zrXC2YIK6sMbYomJi8MC1BjM+Uid/g/X0oKkMUYV6nl2nSmTj5en49F55qem4anXbdFf2n3/NVaLuyyt2GKVaIP2muLKq02C65n1Oh3zHAutgWAeoQNVnfIKmC8PJEJRgWODFdUPGkgvrOyCSLqn84FRjh6lbPSjpLPJuQ6ksrhSdTmwO1AlnU8h7iZQji7N6ckhlW6s+5CtwoZgDyF+xfNEd7r7Hkh1V7FkhpxN+u/PAOJoNPZvzK2uun3JT/fU5xfkpf37ThRUfsGTJuOR6BVP+SBhhXkZmqQpE2iXT3VALHZZbxIYDQgpLEU3JHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TIIT5iWYXUdP6+gBKlVmMeZLeNQuOUyWfCTqol6iMXw=;
 b=GJM0/DOwSwtvL97fQra+rIIpO98yUCfSJevVC3wRao34e3+FAuTwQ+UE+FUaYzYBJ8o5U5/+b3wljun1PhaweAQFhnNQZgeu2e6SRJPBWpdVmAs3KGnWz6mcsaBIP9M6yR3hFadm33zlOLIa/bwCV4GQehR9ZELIxm0CTI6/5dz3Y02H7+Fg80s46zchrVXqd60iZKU2rXElVDOvU5mTBfOEQiCzJzE0/0ThP9dBpLz1nAH57M71Kq2qDkNHTq03NDOMVy40RHlwSRPsonN/Z44kFY1hzq90vR3JGhKOBsycN6UBEyLAF4VZqPTxpnsFCX2I8TAawXRyY67bRXjByA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIIT5iWYXUdP6+gBKlVmMeZLeNQuOUyWfCTqol6iMXw=;
 b=lFRYg7/QkY5JOwy3KRVC2rL2rqDrfQ15tF04N4j8H/d1AOSOafVLk6+ASMqGgM3+WG28V4SxsrHO1E4v+F4JrrpTbVwMe07SiLVQ7IGpItBYbwvSfZfFSRLr3YGZTvVSX5N/w3cSJFGHwpPUFUfJ6s1bCBKjPFyX3wLbtxvlz5k=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by MW4PR10MB6534.namprd10.prod.outlook.com (2603:10b6:303:224::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:12:18 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:12:18 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 12/21] xfs_db: Add support to read from external log device
Date:   Mon,  6 Nov 2023 18:40:45 +0530
Message-Id: <20231106131054.143419-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0127.apcprd02.prod.outlook.com
 (2603:1096:4:188::7) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: d6c96c74-d4a8-4603-b29e-08dbdeca006e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E3E50HfbI8c5wvOR+YMqui3Es17ymB46J8OOPTv744SVAWTxaMQB98OCTYNuD2gU0c61oKKMHfyci34HnfTjpSVEqe/rd2wa7EsQrSGqYGeseiyTz3JFHiYjYd+AVDcCOen3smJALeCYKuHxX1JQ/F/HfUClE33p1A5DXHhA3DWXJ2MY4puKOMInBA9TcjCPw1/OgoiEFFidXcj556jegbzitx+xYXWyIALv6D1UHpXQutz6zqq7L61mYiDpVVouTTX2qoF7qHKB0Mj/2Ehxbts3cK6M1muXPQ4rWE1xuekmJN7p6f89x+PlcbQ9SQ0oRu8dMONM6C1eV/mwuWHoEavenfoMSL3ETKcWfU6R4HLEie2N3Plwbk5IdYTZX/vaqtwHJH5me0UEv9KMnSSDd9DVIKDIbr2wq7B/GAt6VAAi6o9MLl8F+Dy0bfYwHv++vKiPp/0swezWVP/hM1M8H3c8KGXqoU0ANIqq3Hg9PW4BLhnauSCbpekQwGSnne2gFUOBEc9VedXMhN/kG0fNBy5DIkcOH2UFwmDN4XZpk92lnjvKhGObEWLhis9ym7QPgJ3h8h52oAm2P1tJdR3QU64vVLQvAq+bXlwGLFg9nog0uVB+rR9HPTqTjY3b+G1B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(39860400002)(376002)(366004)(230173577357003)(230273577357003)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(2616005)(6512007)(1076003)(26005)(478600001)(6486002)(5660300002)(8936002)(36756003)(4326008)(8676002)(41300700001)(86362001)(2906002)(66556008)(66476007)(6916009)(66946007)(316002)(6666004)(6506007)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DPzcYnmCezf6C5Ad9VbjKJV/3g8AqHN2PizGPdve/sfHSCKVPGy4ZonXW9o7?=
 =?us-ascii?Q?wi8TUWrj2MlnrHOzB/igkli8RAa3r1WGpKDnl/a1txDYTr4TmKqNgmGheUnc?=
 =?us-ascii?Q?dHi9BOfJkelUCBU3D6EZl2LuM93Fx3+rPGBSfydzOoyK57zIwPXakkZ0pcwB?=
 =?us-ascii?Q?hPLjbPHJgqW0JUy52LaXhH+954///SzL7w/UqsfQ4S2Qd1io2wL8Rph/rPSH?=
 =?us-ascii?Q?AM5pes1jO987UMMnMGFq5wz3ukB5e+tcbMLfzk0KhJ6pZelv44ecnB6+21jq?=
 =?us-ascii?Q?J/Nl91fXWspJIumPwN70b0iIgF2MlOUu/M+GJEBQRr8eXaLBjBIlory0GOdC?=
 =?us-ascii?Q?j+lKMhmUPcnqHsUjWIj5XUjAimszH6XXoRsy+lOLD6uS8iGAeWMgY5/uP6Mu?=
 =?us-ascii?Q?vWIhpylupMkcF9ibJPZ/8VeLDWKn2KVZZdwFkk9RoVZKq1p0Ie7QqWYT709T?=
 =?us-ascii?Q?8/I+Mg0FipOtclOMYRhrk6gWHlUxw0QtD+H9KAH+VtN3lOTNFZb8bSiNqK2l?=
 =?us-ascii?Q?cENKkirBKNAsgk/WsypAZDluD75V/aM5/FdYIRVZSSajFvUagXEMwm0CvUI0?=
 =?us-ascii?Q?KV3PfJth/KW+sb0F1H10oJrKkS4bOlOJOb39TxuSEdc78L04H576NIoclR+t?=
 =?us-ascii?Q?1sptQsCojiCDi72UYs/zdgdbZzark3uCuVuZzqDJ24B7K3xD5E8mlep19LTs?=
 =?us-ascii?Q?paEnCksWrMklVfQKguTcLuqg+0wQMBpRR/2xGUSzMhvKUBbugUlVRqEKr1oK?=
 =?us-ascii?Q?uTvTu31/Cn2RYcAl9V34AR/3NlzKTbWnwUpyMqnF/hPZrG7qXaeWjc/BKMMS?=
 =?us-ascii?Q?H1Y6JCjJhvyXlZBD13VDEi4ooLXtB6zVVV1HRl6zPeWHgRVxeKPPwF9+DNlD?=
 =?us-ascii?Q?U+vLZ/YihNGSen/DdK27EuAa1P47zeY47/YBFTts+jfwSbdMpw8tiTxhTruc?=
 =?us-ascii?Q?KTD8BT3vMD/AU04/wS0DnnRzpZP3mo2PfysSRnFUaykO4vch4eVOlkvJN7+l?=
 =?us-ascii?Q?oAFckT0MLcCoKsvOcAoOFnLritlhgN2eWxYh2OKVMIntrK9FMrONMVUQ7jec?=
 =?us-ascii?Q?OrBhR5a/G3jmOMaqrT3mvinyVfs203o9bmDqD+6uPYSOGeW9HUCrlb6xHI37?=
 =?us-ascii?Q?E4/pfmb8KhFK+ZDIKuIHZub4YFrMZ2zU5FusT1OBjld+w5nZgRvi+lcDiIOO?=
 =?us-ascii?Q?ar3ibaJjS7/jL0v2qukDXLw7ysWzET42rLXGQJ/dY5V9cpegTR+59NOKoQZb?=
 =?us-ascii?Q?itfsAbOjkK0sSEwhEQ57LR5LhqZmEeUkmVY+wqPIFXYT2Xo1J34ZJe4K/Dbp?=
 =?us-ascii?Q?jGIDnsp5OXcjW5VFqpRcY3wNml50X0Kpq7kXhCOxwSpIG/f1MzgMBqfy4YOG?=
 =?us-ascii?Q?gAIxvClsvXkw8shxg6QyiaxrXhVXNzUzN4ya//6iduSo9g/vwQGDeUo3griT?=
 =?us-ascii?Q?mEnXwP0LZlMOYSuKzNzrBuULsjfxTjsw5Ga4nzpVZYe/zAiS1nOgBsnQrWuv?=
 =?us-ascii?Q?pFK4RX+QCaC0Kjq+0AWTv60mXGHgd+fZFzHfzJy84w0guW15aTuzBSYSofB0?=
 =?us-ascii?Q?gb2YnMdngm4vEukGgHSN4r89DBkR6t7MW6uzliFt8k7JeoHzGN2PDdkRdpUl?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Ae8nS7JwHcYs7cMWCRVu2rA99Jb/1JHDgAUqh171QIu2OCB2fyTM7/96Oo9PCDAumPrDw/lqXON+jb5aV6PhepRlf0GhlDXITkc0NdgPCce/b9nzoLprKuM4CBpBvp0ypgHAofSFbzXaf4D11gQwzClUyL7w1Ag+smgA4E/pTJXVEsuKLEgXD1YkpvCeYBNMeByuZU9CRVmtpFIINOvyX9blqVH3rGSk+ly7UWAXFMr7bk9CGmeL9n+JVlMVlGlsSVyOLrQHU26GpAIfGDKTD6HLhn7mkw5UX0r3iTeJte3oiUbB7HVVzlk9qFyS9/vLSsDJ3fT6iPuWxFRxns/FPHnqexXIr0lDNYZSsgX5N/mRM0AOlTS3EY6YthbP+E6ut4wxHctx0QvQkWb1CsP1Gcp8At3WCmVyA9DbDnLI4L1lAcUzbeLi/IP1pJW2X/p/iK7FYgEg6iKStWsMUyXSBRkAdkJqtKQdB0MqpAZ8a58mn2jfYhlE+/sM6Ih50DuGuCuCb2k02fuavkuSuqP8sqIm4oDkei1UFhbBB9VHU0FEZ4+MEKXmiQTV6WabahVbuCInx0YHJxk1ScNWXB1Hm0gw5CJmDyh1/eiwodWrexXdT7xFP7JMGJim3X0gnRIlbR7K8dleZuGjI1Jm5NrMNw9pZJ3At+xcRW4Gh9dWIsZECwA85pVs2TPVr3RJfFy3rUECepDNnD5o3UF8rBgaCe26xocY9hDft8gsF6oL4AyO+WkSJbr75xA0L3m1muAZGPjSspm3PCTCvjRUKOGc9umCSXemYSEk5QeHqDGkTu4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6c96c74-d4a8-4603-b29e-08dbdeca006e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:12:18.1539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0uTIT6hGj85blxzwhivnWf4rR5LVEWJFW8p7N35gDipqFpKp9iPrc/shYTumIPJluIiidf0vF9Whk2oO68Nbfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6534
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060106
X-Proofpoint-GUID: AYXbaMNg2n5btpTUo3vPC0gA90VfQJR-
X-Proofpoint-ORIG-GUID: AYXbaMNg2n5btpTUo3vPC0gA90VfQJR-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit introduces a new function set_log_cur() allowing xfs_db to read
from an external log device. This is required by a future commit which will
add the ability to dump metadata from external log devices.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/io.c                 | 56 +++++++++++++++++++++-------
 db/io.h                 |  2 +
 db/metadump.c           | 81 +++++++++++++++++++++++++++++++++++------
 db/xfs_metadump.sh      |  3 +-
 man/man8/xfs_metadump.8 | 14 +++++++
 5 files changed, 131 insertions(+), 25 deletions(-)

diff --git a/db/io.c b/db/io.c
index 3d257236..5ccfe3b5 100644
--- a/db/io.c
+++ b/db/io.c
@@ -508,18 +508,19 @@ write_cur(void)
 
 }
 
-void
-set_cur(
-	const typ_t	*type,
-	xfs_daddr_t	blknum,
-	int		len,
-	int		ring_flag,
-	bbmap_t		*bbmap)
+static void
+__set_cur(
+	struct xfs_buftarg	*btargp,
+	const typ_t		*type,
+	xfs_daddr_t		 blknum,
+	int			 len,
+	int			 ring_flag,
+	bbmap_t			*bbmap)
 {
-	struct xfs_buf	*bp;
-	xfs_ino_t	dirino;
-	xfs_ino_t	ino;
-	uint16_t	mode;
+	struct xfs_buf		*bp;
+	xfs_ino_t		dirino;
+	xfs_ino_t		ino;
+	uint16_t		mode;
 	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
 	int		error;
 
@@ -548,11 +549,11 @@ set_cur(
 		if (!iocur_top->bbmap)
 			return;
 		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
-		error = -libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
+		error = -libxfs_buf_read_map(btargp, bbmap->b,
 				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
 				ops);
 	} else {
-		error = -libxfs_buf_read(mp->m_ddev_targp, blknum, len,
+		error = -libxfs_buf_read(btargp, blknum, len,
 				LIBXFS_READBUF_SALVAGE, &bp, ops);
 		iocur_top->bbmap = NULL;
 	}
@@ -589,6 +590,35 @@ set_cur(
 		ring_add();
 }
 
+void
+set_cur(
+	const typ_t	*type,
+	xfs_daddr_t	blknum,
+	int		len,
+	int		ring_flag,
+	bbmap_t		*bbmap)
+{
+	__set_cur(mp->m_ddev_targp, type, blknum, len, ring_flag, bbmap);
+}
+
+void
+set_log_cur(
+	const typ_t	*type,
+	xfs_daddr_t	blknum,
+	int		len,
+	int		ring_flag,
+	bbmap_t		*bbmap)
+{
+	if (mp->m_logdev_targp->bt_bdev == mp->m_ddev_targp->bt_bdev) {
+		fprintf(stderr, "no external log specified\n");
+		exitcode = 1;
+		return;
+	}
+
+	__set_cur(mp->m_logdev_targp, type, blknum, len, ring_flag, bbmap);
+}
+
+
 void
 set_iocur_type(
 	const typ_t	*type)
diff --git a/db/io.h b/db/io.h
index c29a7488..bd86c31f 100644
--- a/db/io.h
+++ b/db/io.h
@@ -49,6 +49,8 @@ extern void	push_cur_and_set_type(void);
 extern void	write_cur(void);
 extern void	set_cur(const struct typ *type, xfs_daddr_t blknum,
 			int len, int ring_add, bbmap_t *bbmap);
+extern void	set_log_cur(const struct typ *type, xfs_daddr_t blknum,
+			int len, int ring_add, bbmap_t *bbmap);
 extern void     ring_add(void);
 extern void	set_iocur_type(const struct typ *type);
 extern void	xfs_dummy_verify(struct xfs_buf *bp);
diff --git a/db/metadump.c b/db/metadump.c
index 81023cf1..f9c82148 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -38,7 +38,7 @@ static void	metadump_help(void);
 
 static const cmdinfo_t	metadump_cmd =
 	{ "metadump", NULL, metadump_f, 0, -1, 0,
-		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] filename"),
+		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] [-v 1|2] filename"),
 		N_("dump metadata to a file"), metadump_help };
 
 struct metadump_ops {
@@ -75,6 +75,7 @@ static struct metadump {
 	bool			zero_stale_data;
 	bool			progress_since_warning;
 	bool			dirty_log;
+	bool			external_log;
 	bool			stdout_metadump;
 	xfs_ino_t		cur_ino;
 	/* Metadump file */
@@ -108,6 +109,7 @@ metadump_help(void)
 "   -g -- Display dump progress\n"
 "   -m -- Specify max extent size in blocks to copy (default = %d blocks)\n"
 "   -o -- Don't obfuscate names and extended attributes\n"
+"   -v -- Metadump version to be used\n"
 "   -w -- Show warnings of bad metadata information\n"
 "\n"), DEFAULT_MAX_EXT_SIZE);
 }
@@ -2589,8 +2591,20 @@ copy_log(void)
 		print_progress("Copying log");
 
 	push_cur();
-	set_cur(&typtab[TYP_LOG], XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
-			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
+	if (metadump.external_log) {
+		ASSERT(mp->m_sb.sb_logstart == 0);
+		set_log_cur(&typtab[TYP_LOG],
+				XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
+				mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN,
+				NULL);
+	} else {
+		ASSERT(mp->m_sb.sb_logstart != 0);
+		set_cur(&typtab[TYP_LOG],
+				XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
+				mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN,
+				NULL);
+	}
+
 	if (iocur_top->data == NULL) {
 		pop_cur();
 		print_warning("cannot read log");
@@ -2751,6 +2765,8 @@ init_metadump_v2(void)
 		compat_flags |= XFS_MD2_COMPAT_FULLBLOCKS;
 	if (metadump.dirty_log)
 		compat_flags |= XFS_MD2_COMPAT_DIRTYLOG;
+	if (metadump.external_log)
+		compat_flags |= XFS_MD2_COMPAT_EXTERNALLOG;
 
 	xmh.xmh_compat_flags = cpu_to_be32(compat_flags);
 
@@ -2811,6 +2827,7 @@ metadump_f(
 	int		outfd = -1;
 	int		ret;
 	char		*p;
+	bool		version_opt_set = false;
 
 	exitcode = 1;
 
@@ -2822,6 +2839,7 @@ metadump_f(
 	metadump.obfuscate = true;
 	metadump.zero_stale_data = true;
 	metadump.dirty_log = false;
+	metadump.external_log = false;
 
 	if (mp->m_sb.sb_magicnum != XFS_SB_MAGIC) {
 		print_warning("bad superblock magic number %x, giving up",
@@ -2839,7 +2857,7 @@ metadump_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "aegm:ow")) != EOF) {
+	while ((c = getopt(argc, argv, "aegm:ov:w")) != EOF) {
 		switch (c) {
 			case 'a':
 				metadump.zero_stale_data = false;
@@ -2863,6 +2881,17 @@ metadump_f(
 			case 'o':
 				metadump.obfuscate = false;
 				break;
+			case 'v':
+				metadump.version = (int)strtol(optarg, &p, 0);
+				if (*p != '\0' ||
+				    (metadump.version != 1 &&
+						metadump.version != 2)) {
+					print_warning("bad metadump version: %s",
+						optarg);
+					return 0;
+				}
+				version_opt_set = true;
+				break;
 			case 'w':
 				metadump.show_warnings = true;
 				break;
@@ -2877,12 +2906,42 @@ metadump_f(
 		return 0;
 	}
 
-	/* If we'll copy the log, see if the log is dirty */
-	if (mp->m_sb.sb_logstart) {
+	if (mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
+		metadump.external_log = true;
+
+	if (metadump.external_log && !version_opt_set)
+		metadump.version = 2;
+
+	if (metadump.version == 2 && mp->m_sb.sb_logstart == 0 &&
+	    !metadump.external_log) {
+		print_warning("external log device not loaded, use -l");
+		return 1;
+	}
+
+	/*
+	 * If we'll copy the log, see if the log is dirty.
+	 *
+	 * Metadump v1 does not support dumping the contents of an external
+	 * log. Hence we skip the dirty log check.
+	 */
+	if (!(metadump.version == 1 && metadump.external_log)) {
 		push_cur();
-		set_cur(&typtab[TYP_LOG],
-			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
-			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
+		if (metadump.external_log) {
+			ASSERT(mp->m_sb.sb_logstart == 0);
+			set_log_cur(&typtab[TYP_LOG],
+					XFS_FSB_TO_DADDR(mp,
+							mp->m_sb.sb_logstart),
+					mp->m_sb.sb_logblocks * blkbb,
+					DB_RING_IGN, NULL);
+		} else {
+			ASSERT(mp->m_sb.sb_logstart != 0);
+			set_cur(&typtab[TYP_LOG],
+					XFS_FSB_TO_DADDR(mp,
+							mp->m_sb.sb_logstart),
+					mp->m_sb.sb_logblocks * blkbb,
+					DB_RING_IGN, NULL);
+		}
+
 		if (iocur_top->data) {	/* best effort */
 			struct xlog	log;
 
@@ -2958,8 +3017,8 @@ metadump_f(
 	if (!exitcode)
 		exitcode = !copy_sb_inodes();
 
-	/* copy log if it's internal */
-	if ((mp->m_sb.sb_logstart != 0) && !exitcode)
+	/* copy log */
+	if (!exitcode && !(metadump.version == 1 && metadump.external_log))
 		exitcode = !copy_log();
 
 	/* write the remaining index */
diff --git a/db/xfs_metadump.sh b/db/xfs_metadump.sh
index 9852a5bc..9e8f86e5 100755
--- a/db/xfs_metadump.sh
+++ b/db/xfs_metadump.sh
@@ -8,7 +8,7 @@ OPTS=" "
 DBOPTS=" "
 USAGE="Usage: xfs_metadump [-aefFogwV] [-m max_extents] [-l logdev] source target"
 
-while getopts "aefgl:m:owFV" c
+while getopts "aefgl:m:owFv:V" c
 do
 	case $c in
 	a)	OPTS=$OPTS"-a ";;
@@ -20,6 +20,7 @@ do
 	f)	DBOPTS=$DBOPTS" -f";;
 	l)	DBOPTS=$DBOPTS" -l "$OPTARG" ";;
 	F)	DBOPTS=$DBOPTS" -F";;
+	v)	OPTS=$OPTS"-v "$OPTARG" ";;
 	V)	xfs_db -p xfs_metadump -V
 		status=$?
 		exit $status
diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index c0e79d77..1732012c 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -11,6 +11,9 @@ xfs_metadump \- copy XFS filesystem metadata to a file
 ] [
 .B \-l
 .I logdev
+] [
+.B \-v
+.I version
 ]
 .I source
 .I target
@@ -74,6 +77,12 @@ metadata such as filenames is not considered sensitive.  If obfuscation
 is required on a metadump with a dirty log, please inform the recipient
 of the metadump image about this situation.
 .PP
+The contents of an external log device can be dumped only when using the v2
+format.
+Metadump in v2 format can be generated by passing the "-v 2" option.
+Metadump in v2 format is generated by default if the filesystem has an
+external log and the metadump version to use is not explicitly mentioned.
+.PP
 .B xfs_metadump
 should not be used for any purposes other than for debugging and reporting
 filesystem problems. The most common usage scenario for this tool is when
@@ -134,6 +143,11 @@ this value.  The default size is 2097151 blocks.
 .B \-o
 Disables obfuscation of file names and extended attributes.
 .TP
+.B \-v
+The format of the metadump file to be produced.
+Valid values are 1 and 2.
+The default metadump format is 1.
+.TP
 .B \-w
 Prints warnings of inconsistent metadata encountered to stderr. Bad metadata
 is still copied.
-- 
2.39.1

