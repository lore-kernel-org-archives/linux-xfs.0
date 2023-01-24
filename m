Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF69BC54E94
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:36:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjAXBgo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbjAXBgm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3801BAC4
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:41 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04h8a020122
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=j1UphUgrLxNzSWpMB/bI7vBqQ2f2Hy1w5Wg7M7MEFKI=;
 b=WI+5XoV+XT4wXHNBbFtJ7HO92k+ra3lp9SevvtDAly+ZdNU7Iule56BPU+tD5CBTm66M
 MyqOEMJdjJc4MYN9drcwk987r2g3GS42LMUhu6W86IPJsN6dwSR593swcIN7HuIqyHho
 Wp4dgzqnMsFaPrHRVRWtGNnb9+mKkBor+gFP7P+g4AbuIqD9VOhtxLJJuaglKw31tPwP
 7PmogT1aMixnnxIqEzreKFB+eiKJuTOUnQ1b8TDtv6rxFsf9HfzMiELtADAZr54neiAs
 hA8LmnnI/qtXHTaDhNCF7px/LO7HTRoa5FTxNYncERlMsSGo57xnR7iPsVHskyINkE89 7A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86ybcbhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NNUYcV023170
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4akyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNbI7xgP3mhldLaNuRIV+5Fsqass/RcULP6WaGroZduP0Ww53mda3NsmWWnck0QO1N/AMCaKKbfExYaf6bcNBWlcq5+tCQdaBcbbXl3Nh9nqaCUjNoOz57zCM5gl6TElxQ4keDc/KzBJI5nZiG886dungh7oOEiBZiOt/l64jNu8zhdwBgi2VfjbgOpldzNyT3sR9rNkpacPUdNJ8pU71fPekYpJXOwtwB/cFCQlQx3n2/fd0TeUbKngzQgck9XdC8Rb4DkvpStvxuL/GLQVHY1BkrdfHkoNzhIZM03ffGb47VD8/30W0fCeoV8hRL3HCmF0CF1l0B2cpYIlB2G77w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1UphUgrLxNzSWpMB/bI7vBqQ2f2Hy1w5Wg7M7MEFKI=;
 b=O7bzSSvUtevL8OzTnYb1xEl/Lq/Xd5RMY8bjmC5SJWX+lefReLgdlMS67SVj/canlzWLbvoo6evLmVUYs3cYR01nui5FU12JK8N6MMckNqhGP42ARhutP88oSnID4bygt7ETsPQU1IgbOl+VGB08+LD3oyg6ltQrpyd9yvkGd7ovZHyPdxb1rYcIoEbBt1W+nynJCUQzd2J1Zw3q+P5WV5W/ofsjqPQ0moHyvgEW4awnW9vMaOLMbhxi1AV1iJUJREmc9qjHp786CGz9bInJ3xWZ14y/cq3cOZf7lOL7McwlmBt96AMs18D21eMDBzBeFo7aFiBY5gr3yWN9iSpjgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1UphUgrLxNzSWpMB/bI7vBqQ2f2Hy1w5Wg7M7MEFKI=;
 b=QTVi/9I/UfeQL2iVZ1zg7e+71shDiVYbxwk1fjgVuPh1s1xMZHdAendP63zvUT4nXcLzRQuZef5gKVLv0fQQldSvWzeHcwY+4NVrjGbUpmryqNcyaW3nojmgnKSPzCgqE5fDBNzhPOSQNdQlb0WITC6r/p5lbpdFglgz2bXcmLs=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Tue, 24 Jan
 2023 01:36:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:38 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 09/27] xfs: get directory offset when removing directory name
Date:   Mon, 23 Jan 2023 18:36:02 -0700
Message-Id: <20230124013620.1089319-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0001.namprd21.prod.outlook.com
 (2603:10b6:a03:114::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BLAPR10MB5041:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e4021a0-fb2d-4638-84f0-08dafdab6f6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nw+D2gWraZSOUonLe/FAAx6Qiky5sc8j2GrL0rbuC+AMzydvp0ya8vB6E8LxPxPV5ODEADY3W+9D5kk5KrsJtjXBbdPbVOzIgfYORctf8lhqwIMR9PS15+2hhqXgl9nyf81s1Ft7UarYbYs2oV05z+HvlO1j/EilMxQ1I6rZN9xyIrOfroEFnskfqE2wrMv6/VIfAgzXSSdn+U4hjVCmR5PwMvRc8i8ESWo7qmS2qCQM+BXuus0CQuWy2hm1OwMUd2OMQiNKBEL9pdGsyQ2vqQCw9IYQQZkXXVinh4aOu4NxMf9yRIvJpdCU6JegdOKWZ4M/oxkZ2Yfpe5Hy11Jg86j1E3E5ZWqd5ggKtMv6bAfg3dG9MkngRXs+UPSxCPTr1KiT7e8Xsj9+eGG8aSDPPqDvkxrAgrXjCL20/bZLVYL1Ko5vjBFOOqgkKjpuIeFvJoo8A0JTTDyYodJj8fj8jPiVzwtRuXwVByUstqHWW1mEQUnDGRrm3FpTkCKUGE12DgLO9Lyn3C753OpsPTkGGrx9XWy0KUvKD4TeHe4f3abj9as9n04NSxDnB+zjAWnvgSfyiz7HDH5hRV4vYclduXNweQU8T7K+rhxFFg3Or9TzM1tfKLWOdkXFDU6mvgclgqU2tqFOcn/N1gDSuk5aZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(366004)(39860400002)(136003)(451199015)(6486002)(478600001)(6666004)(26005)(6506007)(9686003)(6512007)(186003)(2616005)(38100700002)(1076003)(316002)(86362001)(6916009)(41300700001)(83380400001)(8676002)(66946007)(66556008)(36756003)(66476007)(8936002)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vvaEyNHoJVqummRtqi3xMWEUFlMP+TJmO3TqshVhYe6lM3eONAi3r4EMLQ3G?=
 =?us-ascii?Q?L+7qVwhOzLEtoPgSMO5/Yv/fsxfSxhqyI11++xZVt9yyex8j6I1yzz5y5okE?=
 =?us-ascii?Q?ww2quGwWEOTT90E8ZS8AaDAM6oiYGZDSfvGnkEONu3UsdCCOsctpMcWSvhbP?=
 =?us-ascii?Q?fRYoRhMGMkR32Cel4jgg8HVEreWi3VlwNBoUh96RowGc/BGAyR4hBlwHRHfp?=
 =?us-ascii?Q?f7GovThuaKPYinxHUDcp0jw7r51zuLMlQdb3UyMNwMrbG5lnhXT3dHSP0qxk?=
 =?us-ascii?Q?Ft3YkADERjihiXPTx9iM1FQikFtk4uTGrAlWnj18//5RrEllOSX1eO5Yiv9K?=
 =?us-ascii?Q?7qp1wFjPZRFzccv+V0SAwaXpXFHNynsUuVZ9JPTkUq1C3f83dyy6eHCh9CSs?=
 =?us-ascii?Q?ikqXDYjjkB9ZpnoU41u8+In2AJ7p65VlHXjXaDjvQ4RIrypjHkyY/+2p2Oxa?=
 =?us-ascii?Q?gK3Pt5ZD+P5zwUKFRn6CEs9AkLo9Hemak0xrhtOe/Lba4XDC3Tw0uqgZGnB4?=
 =?us-ascii?Q?sUD+NDnTf3icTBfp0wFFJ5A/jEqi1GozLQGOO7kJ2Lq+rCQ/hTdfJS3NgStm?=
 =?us-ascii?Q?/PivdOhCpQznEu/ao96jM0AIxd6leTGPDrDIs6GDQCCPlpdWeD6FucaaJ6Hc?=
 =?us-ascii?Q?NQQidI6t+PSiqyvuVAqIgDF/HEUkZqttP0IJGnBmm/ttixAtkUHJw/+H+A34?=
 =?us-ascii?Q?qoEN/q0LLvhWzRUhybiSDKCAD47aJaopGnMA5zFOQ/ml3l71pqZcuWo2c768?=
 =?us-ascii?Q?ZLr/Pu+vF65zi4CubB/orDfTspjsbSXoSajUUbpiMu6F4CqguGibZkrZJczV?=
 =?us-ascii?Q?p7tuYV0a5NamS9KF8kNrW7a6u2ZUy6Vj41Y21qX+usoIl2GXE3RrtJVTwNkf?=
 =?us-ascii?Q?UiVPtBAYYppeh7QJcE8bXsQWVbtBkIDup3tCGLXjT+T7EQ8PTfSX/Luet0NS?=
 =?us-ascii?Q?m3UqdVsHpNl8y3SBBqoYxTyrleCa12fyHwAv2svJNYCCpAisQs0jvYcurDBU?=
 =?us-ascii?Q?Q30goke+Z2ofLcK3YolocleNSjCbPkpLfJW64uUrWTjeKC4u4vD149mfIsU9?=
 =?us-ascii?Q?qAZjW9IEu+bsqx2F4qPXYfEAPpHr/uSdRoxt9326GNt18YqJHG5fXjEtxwjK?=
 =?us-ascii?Q?wQInWqVaawpN1KrOZ92isNZgZkSWNvR0SSqL6s0KK1Wbj/XqK+WaFUdTk3rD?=
 =?us-ascii?Q?ZooW2sdzLD27A8FbLbRlGtSESKoVN1q3BsjuWwAykN7AwVJ/oVz4/+BtmtMl?=
 =?us-ascii?Q?R82j3YfH++vg2W0bJwZPe15AOuoau/lMxg645Zv4HjPCpRiba+Cv7PGDkHJL?=
 =?us-ascii?Q?r6Tvo1G/V7+cNIFVjx+bZM/Wftc33msfG2quMTS4X7lmxLL+k/UMTYzwki+M?=
 =?us-ascii?Q?kwBH1MsS/Rv1zxWF4yeNS/6fXZegrUkUbEKUml+mm3k8zs4Lt8bQAGcrRAwj?=
 =?us-ascii?Q?GwAMpbn5ngRWLkyIp80cwOYoDjINme4il4Ex8U65yqt88KTpmayRkwn9Rrjo?=
 =?us-ascii?Q?PzMz4fJD2IG6FbcGpHwehcQKDbX/W4/eSOIvqOfY8jEbhdFHyYvZP08meWzt?=
 =?us-ascii?Q?vKHHnhMJUMXnYe4ZUvBhUz8ulPbV4rV+AJrQU33viYKQF5WBFEI43HyNCzGf?=
 =?us-ascii?Q?EA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: LTRej+venUDsvRR+CLnyxZzh3d4Ywh4pa+NDphrtnxLxpfqlQaHlnbRS2rAllwUMpx551b+GIaqJPlgp6X3EEO5FDGYsZDztgvN/5JMXbrHrdgCZyoZ/KiImf/5dI5Ggh67FzWmuRGmIwY/Tfu476MZC7CSm8BevFGEVcsqJFcKw18dxStTI2dg8Uv2C+ehdgVQkkscPb1hAzsIYWlxtOWDiwlNMfO+BjtfIyoOh41DlBOZzd3LEQfRW0hSpYEFe/i6kgaW8wBTLjhmqyCeq5MRIhreyq04D0IEzwASt932nC+u74aJIkXblw1iTkrMgWycs4lhWJwarnhxSiYBpV5yi6OUIOTB2Zcd3z2XhiCZhYkyhA9o4adqjVSJQHB//uCuXxVcjrDWXD29vs2nS/ik2wC4j/ZvYWw6oASTAr92A37Aa4wrsGZLy/kE1JbEhfCfZGKX24AIH2eHLdxO9KV5H50zWmIO3LyAoggvAnGkCXw/SnB7W4kc6OfcyX+fw8T4QZSBTrt19W3csZRvuAOfJ2UKEMsEKFz8U9FApD/sx5+cQu1ZdBExo9SnxTkVbtpkmb+Aru9ftirsED3LRHT6Jepsc/cb1diDZqOdqc7cs3JiWa/JdmLM1/W1i5es8ch92TOZOq+OwS6c2/sjBiskFheMfvn85Bn4VQ8W6fsIa/mN9seXxmsluxM9wukjqLlGK3wVRAEHmTytcujNZ1t/Ysb/EmLejdR7TIjeEBxcx6YOITygsnC8JmOBET7Sw/E+GiO9XI9LTkVxaks/nPg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e4021a0-fb2d-4638-84f0-08dafdab6f6f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:37.9191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R7Gt2IhacTsscrDOX+zKy6Ttvngbdeseb3EiMifQzu6L6zycK6yLRkNiMhmE8W/4q+tVvx0iVkUL5Ok6IbiDa2nDmPyLXZ8ydFxH+Jjfqkw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5041
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240010
X-Proofpoint-GUID: mieq1TnRL6RnmdQZjb1miwlq5Dz8JC1b
X-Proofpoint-ORIG-GUID: mieq1TnRL6RnmdQZjb1miwlq5Dz8JC1b
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
index 143de4202cf4..e5ed8bdef9fe 100644
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

