Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A935C7618A
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Mar 2023 04:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjCNEV3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 00:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjCNEV2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 00:21:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DB622CAE
        for <linux-xfs@vger.kernel.org>; Mon, 13 Mar 2023 21:21:26 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32E3AdEL028497
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=6e+xUX+Gk206YkXJshU2VousrLWScIa1qzLA+trygTw=;
 b=Tl670IatXEan3ukSrkM1THp+YuuEYdDur3O0ku87zsCOA5EI2OxyKGKz22SM7g6fI8iY
 3gBoCcd1KPvA52tYcyDgUY9YV6bcPWQABcHnMYlNtO13sd0VglNZd6IlliiGCCXYtnfQ
 IoD8tKFPzqlFh4G2OnhZuZlNwUEtWLQ5ii/I48FezJOjsTE24vIlibuVUOA2bhqIh6A9
 UchmX8We67IbvlXl5X5FOI7PT9kw+5UvL7kzdqhiwSQwH7wwrsAmTA3OJc6P8NDAmPIL
 Uh2nOi13OK36shOxP9NjpxR1OjG1yWf6gik/FAeVEQvQq6bg+DhdHl9p70FgEzRMqruQ TA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8hhadean-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32E12jus007583
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p8g3cba58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UCmKLx5E0xHIvZrqsgaRYWdbIUAXX/C6SX89hUi39SUONW6EXtK5fBjhHA4MrGMJffLpJDCB4xzJkR59aSmeTSL0FmB5kCc1M90oE0LLJoFHa92PFlFo3wzM7UmBjygKV3udrUtVZShc0bQIOEGyBPnC/NRaYKheOA/wc/XhM2rLxELgv1U5cnceEoZOzve/eijWN7PNipk9CHS0+xsaF3DjBSh0rckmXq06x09ToB3Ex0cmp12Rkkkba75I3Ce/vdLNDmrqqUAHHtEO81jFcMG8GY9XyFOnZigebdjygmvhzOPR1hEmCn+yZs58SzO1pkadxPVQNGR2Pk8hqAZDtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6e+xUX+Gk206YkXJshU2VousrLWScIa1qzLA+trygTw=;
 b=b3evX8rzhJqBAer9uUen0Wkk7t5EemhvsQkgI9Q6hv/Ev3yb4goLEwRbrngC+thjBEPjE0VAmGXGPSoWoGPx+KpUJeoUCUDtEd99aXB6jgfkcyuKCSvySwKr8B8UcB1YQjTInq3oMqCk3N5kQuLn4e2t0iiahNPCzvq9uHhXjqQcTyQW6bBGlNgcIw8D5leUF9EVgddYDrwT1Sr6i3Pc2+N8zg+voLXfH9dPC4wQo/BosRaESbqBPJDWEJlCV0bdyKDacBdTLweF+whQi1eC1nGaOTJbnXIQ4qgSjt8d1YOm36Q6T0siB2zUfA4NIXK96DGo64N/WjQt+geZRfCD1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6e+xUX+Gk206YkXJshU2VousrLWScIa1qzLA+trygTw=;
 b=BLnvoUZ9xeL8F/1ez3d5A+CT7nx1JGfWfFr3obzCUcZL7hOSvCsZFVRqNp5fB/PhgBjqT+HGGJKOtKlg3Dy211o6rb290k8ljEaplhUzqyPpH8nsdRUNCPTI8Nmxs0xMl/8za4fkjuqRoGQUuCWRMPQCdsVrwNRMcyrINaIaFZo=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4371.namprd10.prod.outlook.com (2603:10b6:a03:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 04:21:23 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::b647:355b:b589:60c]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::b647:355b:b589:60c%4]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 04:21:23 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 3/4] xfs: add XFS_IOC_SETFSUUID ioctl
Date:   Mon, 13 Mar 2023 21:21:08 -0700
Message-Id: <20230314042109.82161-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20230314042109.82161-1-catherine.hoang@oracle.com>
References: <20230314042109.82161-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0156.namprd03.prod.outlook.com
 (2603:10b6:a03:338::11) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4371:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eb50ecb-38c6-4829-f405-08db244391d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9OzO25p5v0VoWKkhTT+rz1hSUcPEyg9YbsvuwUDnl8gIs506HOfhv001q6T4kgEo1uru8vb3zfKhR23+4hrOJ9/fTA1j3MpEk9QkPVs8fxCoMETNMN5GIXOsMq6HchqD1A1US6m8k3GFKeEFdicEffkRS5kd2oau/GrXjQbsrLeVN5ZiMQNzm65gYpbqbq0m3BX8+L/+/lPu3RKVZsoPK8xGPBub06RDDkOJVOLZMBPhBwcUhtay7spnoNdHxQelD+THXdykURk8UXlYs2IYMK45cgzxUJJcCFJGXB/bEI1bUeLdBBcp6OCgrCbhfI6ct5m7SaYffZlx6nPE5OUVXnt7NoMKVh4/DJCaNjW4efxA/hYNvFIG+pAVUXJIyOGtj5k4ON/LuSRiDVWVxeHm2pa6VcLx+3Tj3ldESJDL1SEElClr3FaXOEvYkzaPbSyJhOc/phwLxUvHAKy6my4cMX2euAB+1jq40+HCAG5v8enVvKSpEPXrpzJezGlCRpXqg862cYshwdivSckdrcN8jFXyhXPfMYM2TdlU7z7sjPCCHmDVjbwzJJo2MRDp1AoMfR10eh4uIJN7u+TOGdZFOJG1/tUXs1rKZQu//h/EADf2LllPrKvqss1x9IA+N/q2SzqJNcvMqEugc/qdaPrG2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199018)(36756003)(86362001)(6916009)(41300700001)(6512007)(6506007)(1076003)(186003)(5660300002)(2616005)(8936002)(316002)(478600001)(6486002)(8676002)(66556008)(66476007)(66946007)(38100700002)(6666004)(2906002)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jRJ8gjXuWjcxwf2+wfLBr1EkP2byAndMTSoWM18TifMPufnTAGLjOM8kCwvs?=
 =?us-ascii?Q?3hWwX7k+ruoZxmiATIdqNcei33zbA8/k9RYCJj12bSagwVoU2NBzWfGx0OFN?=
 =?us-ascii?Q?PzKOMLEHntw7/CSp+oOCvTrm8hPvr1ebYE3N7OahmCE4JXd2h2n7v0oCjnyQ?=
 =?us-ascii?Q?LFW0rv1SFJZPx78gIC2ZiPgH1z6CQ4xRCLwM0z6ouOXjiPW8zqUoNv3yjnAZ?=
 =?us-ascii?Q?/EPKNySOiRMMw8zteaqpJG35EpgNobkl046FnrYT4Nc1yEDToDQ4hBXKupOl?=
 =?us-ascii?Q?ODOHdpIRceekxmR1fm7STks2HF250tOikhhToDvKKD2eivUl1AM10fSL62iN?=
 =?us-ascii?Q?kVuU3TsNM7vd3OKw7Ml2c9kDZHencOU7cCMvZTdrZp+n5kgxr2EEeTvdUGuk?=
 =?us-ascii?Q?rXWY1E1p1dqx7cXeCuSjy+C+ThsQeU4trdvixJGJzSiwF/cTfwi4RPVjjCov?=
 =?us-ascii?Q?ZMKTPxqqB08sakDBwHUuWCKklmEcyI5l3rQfiVdqI4zYjL1fI2cXqlsMJKjB?=
 =?us-ascii?Q?UNb2Uu14wfyk4IrudYV8QbEZpgMOk5csuyIRRr5OTmyzd3hfwvjGdQKRJzEw?=
 =?us-ascii?Q?qHMDgaDEnXVPRHHn5G4p6jJxoQbhnPml0YerRQAHlo76yuGe85B6zloHsJ/8?=
 =?us-ascii?Q?9bY15j1FxT7P8mG+9yKhB8AN/Q7eXuoDZxv3hj8xWGHD/i5X7BbVef3qK2y4?=
 =?us-ascii?Q?ZVqzN4UdsE8quQ2NY1eYRMNb8kWoLx/ANgVR6aorGYow61XEFNd/9+O2rMHU?=
 =?us-ascii?Q?vPMfPVnbQT1YglNQF2o3DoB9LLEfLlCVnffIZ8sMv7RvNHDm7yB+et8Blf2x?=
 =?us-ascii?Q?mNuH23XZ49/azXAlJ4wo7vTDDWCVhL26z47eBdMkVfHdHOHkSsImsUS14OSe?=
 =?us-ascii?Q?M1OAs8ALJIb6mBzyaV0jF0518SGkGWtkjJF6ZmwN7XOfBKAYZq9zEvrHb4kj?=
 =?us-ascii?Q?iveP/BI5PxyCw+wFcRDF6e+kDujU2MmfCnAVJtcWjQk4hfr1sFNSvZK1yhzs?=
 =?us-ascii?Q?ulC+oZJYsP+RPuuGxCf7JmYn/Gb/TdLUQ7NrTpLo01FIdNARwggenEu5QTnp?=
 =?us-ascii?Q?BLbd/GEvOSDSJ5t1o5mdsf7xXGsMNCXBLF/VFkpnWQVbgZu9DQaFVukchMl+?=
 =?us-ascii?Q?y4h6JTQnTAcFCfTox6R2JRY8lKkLf+tU318FoEszkPKg8MH1gcqJ+KJmrOHe?=
 =?us-ascii?Q?WqU2NXTsdik+zWzz+Vr0AjjE52+GojYtZ8ztW/XQvBL9blnBKdJKTeyGEvEB?=
 =?us-ascii?Q?lQ+Q4k2e+pI1Y+wmo5eqo2dqRPEdmLuqgDv9Wigx4o16+/ezgzYE7KzfzRh7?=
 =?us-ascii?Q?T+T1/F8GGvu0dNOW82FFov0DqVLT3f4BRFd3SVBJe1GbAz7jVpS0cTLC6Wo8?=
 =?us-ascii?Q?99WKYOIHCH0ohgOIXNtXGGjVdT0uNjHD46HFsSflix31hQa3bBPL/W6sEnr+?=
 =?us-ascii?Q?yI65JKVoCeRb9PH2x8OH3SY4sSDIfoTFmdE6Ts6j/iMlF5t3IaCC/wS1pS7W?=
 =?us-ascii?Q?tyVt4dJVJoM6I4Ub2M0PwyKiLnA1K4/WWyg24hj0R8S5yY2ggBspfNV+tLle?=
 =?us-ascii?Q?nx2UCPArgpg6Uy1FlR989HHHCwdrBq4LNFjqlhntTVNbWU2GittmhQCuvb1L?=
 =?us-ascii?Q?XDr4sqnAbpQSbZrftzt4W0aU4JCpyAagwtLhw90RYYawlCyrvNjyNihLv1d/?=
 =?us-ascii?Q?wLVLpg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mZSOLrivoqf9wAANOWce8kMadhyiID1tXhJ3vEIIRqBS2P/rEeJ3rJEQy+aUseaT+SBAZw8mtpyMR+OKqv1d7nDxUO1OWWP7ypr7Qz3oT7iQ0/3jqfnQ8nWg/CdoK7VqBlTtZWXiOFfh7pmyJXeMLPiezlmfwSbmp2gJYzMDQK8KAKbJpsTduSRxf72naj+YpQ4PhF/C6DujUZd3dD+b17wpm/pHgyOFoErNBoqeYQQ3daMg3yiHmurR8WJs2kU3fQMB+dFy3Zw+aK2KkcyxsRKvoWvTWImAHq/dYcbraSPZZPCxJsDR96PoxxhJliT1aLPJ48yTmdCngaGepKt3u2rFzZ1KVGb2cz7sgJCbbGe0IDe7lhTIFrC+KXt/mevNYSDCLwpVNM0vqex7z/y3TT9GLQB2Cn9WyzDgXmktXi2xfyks7Q0y5x8sHByikQ/pTU4nVrlyFEiyXkmiZDqPWgp2E/JJBrynCiDBkK9LzOjp/JUk5wDm7DdwPy21JPzR+zHypvengEe8glnSE7t0DssztofIgfQMCnlPzWKHM2vZbS4igP7IX4X5dRtwEunRmkGRIJXd4Ba+BPNxKEnx9i5hu7Ly93lc/cZ5MTlpfW+9C8GO/JxBaTmht8t0kenJRcLYtC8LISMjJuCaF7cQmgT0r/FBerhyOHAocjEJAoQfIyQFgePWUc2Z7Lp02kq2oZ6E0ZzqGEC/ganTg5+7J8YRI4knbSj2GvO4GbeX/h+C9q+eauBxuGxs6o2SwqsWKbBxNjDQ2iGvq53VEeP9xw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb50ecb-38c6-4829-f405-08db244391d6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 04:21:23.2811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3WcnlVf8jeHpa7b+c59rSHAfZQ+7BCULxitkx+iOyfEOfT/TBhMnyp/czrKp3Zpm5AGGBnCZROrPYwogWwZBV+8DsxPlUr8pu7y5bNvZrDA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4371
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-13_13,2023-03-13_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303140037
X-Proofpoint-GUID: wSBl1HAdpRaEwp7SoxVHc_0N4v6jxCpG
X-Proofpoint-ORIG-GUID: wSBl1HAdpRaEwp7SoxVHc_0N4v6jxCpG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a new ioctl to set the uuid of a mounted filesystem.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   1 +
 fs/xfs/xfs_ioctl.c     | 107 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log.c       |  19 ++++++++
 fs/xfs/xfs_log.h       |   2 +
 4 files changed, 129 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 1cfd5bc6520a..a350966cce99 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -831,6 +831,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
 #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
 #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
+#define XFS_IOC_SETFSUUID	     _IOR ('X', 129, uuid_t)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 55bb01173cde..f0699a7169e4 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -38,6 +38,7 @@
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
+#include "xfs_log.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
@@ -1861,6 +1862,109 @@ xfs_fs_eofblocks_from_user(
 	return 0;
 }
 
+static int
+xfs_ioc_setfsuuid(
+	struct file			*filp,
+	struct xfs_mount		*mp,
+	uuid_t				__user *uuid)
+{
+	uuid_t				old_uuid;
+	uuid_t				new_uuid;
+	uuid_t				*forget_uuid = NULL;
+	int				error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!xfs_sb_is_v5(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&new_uuid, uuid, sizeof(uuid_t)))
+		return -EFAULT;
+	if (uuid_is_null(&new_uuid))
+		return -EINVAL;
+
+	/* Check that the uuid is unique and save a slot in the uuid table. */
+	if (!(xfs_has_nouuid(mp))) {
+		error = xfs_uuid_remember(&new_uuid);
+		if (error)
+			return error;
+		forget_uuid = &new_uuid;
+	}
+
+	error = xfs_internal_freeze(mp);
+	if (error)
+		goto out_drop_uuid;
+
+	spin_lock(&mp->m_sb_lock);
+	uuid_copy(&old_uuid, &mp->m_sb.sb_uuid);
+
+	/*
+	 * On a v5 filesystem, every metadata object has a uuid stamped into
+	 * the header.  The particular uuid used is either sb_uuid or
+	 * sb_meta_uuid, depending on whether the meta_uuid feature is set.
+	 *
+	 * If the meta_uuid feature is set:
+	 * - The user visible uuid is set in sb_uuid
+	 * - The uuid used for metadata blocks is set in sb_meta_uuid
+	 * - If new_uuid == sb_meta_uuid, then we'll deactivate the feature
+	 *   and set sb_uuid to the new uuid
+	 *
+	 * If the meta_uuid feature is not set:
+	 * - The user visible uuid is set in sb_uuid
+	 * - The uuid used for meta blocks should match sb_uuid
+	 * - If new_uuid != sb_uuid, we need to copy sb_uuid to sb_meta_uuid,
+	 *   set the meta_uuid feature bit, and set sb_uuid to the new uuid
+	 */
+	if (xfs_has_metauuid(mp) &&
+	    uuid_equal(&new_uuid, &mp->m_sb.sb_meta_uuid)) {
+		mp->m_sb.sb_features_incompat &= ~XFS_SB_FEAT_INCOMPAT_META_UUID;
+		mp->m_features &= ~XFS_FEAT_META_UUID;
+	} else if (!xfs_has_metauuid(mp) &&
+	    !uuid_equal(&new_uuid, &mp->m_sb.sb_uuid)) {
+		uuid_copy(&mp->m_sb.sb_meta_uuid, &mp->m_sb.sb_uuid);
+		mp->m_sb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_META_UUID;
+		mp->m_features |= XFS_FEAT_META_UUID;
+	}
+
+	uuid_copy(&mp->m_sb.sb_uuid, &new_uuid);
+	spin_unlock(&mp->m_sb_lock);
+
+	xlog_iclog_update_uuid(mp);
+
+	xfs_buf_lock(mp->m_sb_bp);
+	xfs_buf_hold(mp->m_sb_bp);
+
+	xfs_sb_to_disk(mp->m_sb_bp->b_addr, &mp->m_sb);
+	error = xfs_bwrite(mp->m_sb_bp);
+	xfs_buf_relse(mp->m_sb_bp);
+	if (error)
+		goto out_drop_freeze;
+
+	/* Update incore state and prepare to drop the old uuid. */
+	uuid_copy(&mp->m_super->s_uuid, &new_uuid);
+	if (!(xfs_has_nouuid(mp)))
+		forget_uuid = &old_uuid;
+
+	/*
+	 * Update the secondary supers, being aware that growfs also updates
+	 * backup supers so we need to lock against that.
+	 */
+	mutex_lock(&mp->m_growlock);
+	error = xfs_update_secondary_sbs(mp);
+	mutex_unlock(&mp->m_growlock);
+
+	invalidate_bdev(mp->m_ddev_targp->bt_bdev);
+	xfs_log_clean(mp);
+
+out_drop_freeze:
+	xfs_internal_unfreeze(mp);
+out_drop_uuid:
+	if (forget_uuid)
+		xfs_uuid_forget(forget_uuid);
+	return error;
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -2149,6 +2253,9 @@ xfs_file_ioctl(
 		return error;
 	}
 
+	case XFS_IOC_SETFSUUID:
+		return xfs_ioc_setfsuuid(filp, mp, arg);
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fc61cc024023..d79b6065ee9c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3921,3 +3921,22 @@ xlog_drop_incompat_feat(
 {
 	up_read(&log->l_incompat_users);
 }
+
+/*
+ * Cycle all the iclog buffers and update the uuid.
+ */
+void
+xlog_iclog_update_uuid(
+	struct xfs_mount	*mp)
+{
+	int			i;
+	struct xlog		*log = mp->m_log;
+	struct xlog_in_core	*iclog = log->l_iclog;
+	xlog_rec_header_t	*head;
+
+	for (i = 0; i < log->l_iclog_bufs; i++) {
+		head = &iclog->ic_header;
+		memcpy(&head->h_fs_uuid, &mp->m_sb.sb_uuid, sizeof(uuid_t));
+		iclog = iclog->ic_next;
+	}
+}
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 2728886c2963..6b607619163e 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -163,4 +163,6 @@ void xlog_use_incompat_feat(struct xlog *log);
 void xlog_drop_incompat_feat(struct xlog *log);
 int xfs_attr_use_log_assist(struct xfs_mount *mp);
 
+void xlog_iclog_update_uuid(struct xfs_mount *mp);
+
 #endif	/* __XFS_LOG_H__ */
-- 
2.34.1

