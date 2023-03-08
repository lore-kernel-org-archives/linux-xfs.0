Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF22CC678D5
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjCHWim (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCHWih (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:37 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46FA62FD9
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:28 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328Jwg5o007250
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=xijsW7B9KBer/+NXz4hfOr6cRZuKHo40ucfTqSVHY4Q=;
 b=ZYwi0daRuXayHEtJ1IeGxgUskqprqG3QpNYTMJ1oO6D9qRSsb0yZTt/cxMHhXmqGleOW
 fe8QPMFBuvA2u3LgNYT1/uQCRZiGFDg+FLlERdGfiYMw8oobK58u902krWUJezkPh0QT
 XFpc8Kdi6DQiE2GyAXGjVHONUNQM6NAd6Aw9rFh7b790/nCUY5+UImX05DooPXB4wnz4
 AzZAwIGKefTkyy5QY4mA6VSe0clJThcffYC5bNSjhfe83VBlxGHzmSHQOWgfI0L9gWaQ
 xY4NW17QYGt/aCY/KyGfWB/d+MlYwFfoTzXi23gmQqn4zSM/iirO9a5tfLoD5uJL4zoN eQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p415j1fba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328L4ZYl015690
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6femx3j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L8GS5CMJnto5z446txTLV7Lw15Ga18kfDNlmDEjSRFmA++eD/U5WUUxcBfvExS2951BRWen7AyfuoJkefU4FhRvBc1LFhWmBvA/dXd8Ag+erX+HRs6K5uZBRJpCndR3tuep42wK00cKReDXxcJ4Xzwlg1V8JFN30LmWICPKm1bjhjb5oiMgqTiRrBwdpwwiFQkN2JbwtwLNZXnSVMnk4JrSZMR2F4rxdaPB6LSV7I3yc6HXqj72hgcq1tTIQDU7C8Rm7tpJ+SX0JMzCD4Tt1X1SpRsuyWM1POmyKm72BL1gjAXN2O/sKgKYFTSunULcsZ4FToFBdIV62MQOr5MtASw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xijsW7B9KBer/+NXz4hfOr6cRZuKHo40ucfTqSVHY4Q=;
 b=SVyFzewVYNeeq2lBeONMxm+F6YOhljRlYQyRzDrjR6HZGnPnYUlUJ8z7tobppmW5fZtPPj5o9C+IwnSO3OitmynTR+og3nYY/fPZUH6Ps/aj0ZdD6lTTPaYc3mjVMXn3OTP3NRCABpa22uCYauqotY/NsT9aB7wQZRKgfXwWonN6juohBOUImr/ubcI2RjV0/9RW2LpJeuVW5Cmd4gXmNbHvVDa9+CHfE4ba7UBaHZTSqeEPDB9kUg7TTE/twePgwqmbCKIhoxxd5yA77IaHV1reckbFyL1If072ILNCkBHuuUf3PcL0wsYR3mNUO4rWHmHAz15pa2nbNL/LF1EkLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xijsW7B9KBer/+NXz4hfOr6cRZuKHo40ucfTqSVHY4Q=;
 b=KNeW7yzavklvMYUbQY+2JkjgeqHOo+lEpRCp6vKWEgNZ9ph7QdgdrtxKKSvKNlC15orL/0/yfdLONOsrVexz02+EOcmGoQ5inSJTUJc3wjhiA2Yk2GeYpod/6Txg8IQ0ivApbhl1fpX7MSVJ5a88dBJh+151vIaP2OMG6FnZ3ig=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5708.namprd10.prod.outlook.com (2603:10b6:510:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Wed, 8 Mar
 2023 22:38:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:24 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 15/32] xfs: parent pointer attribute creation
Date:   Wed,  8 Mar 2023 15:37:37 -0700
Message-Id: <20230308223754.1455051-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0148.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5708:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b4f8948-e0c5-48d2-56d3-08db2025d38d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OqLyBpnx9U8nnd9nZ/HVg2fQ7g2cwwpFsE4WQzwbnjgehSKtSZjDhTLnTZwpu4hS0Gp3FKNuGivID9XCKBnXWqMTrq5XELUbFyN7JUfsrCGEMV+phGzt0a1tYO470lDAmP1Tf6IOqeqqymwDPh5sRWjXYB3WberiqnfoBWQdFqa562nAdqBjuTgIIZFuiySQx4rZ01CW1grNin5nec8Ih3Vl0RVjARI/Co1Rc4Xci1qtFsuie77TnnkxhVxmL5aJlc0pV80x3hNfb6qm8ysLM6Yy0Y0jfsqbBO4ty+Q0YKDoVzliadPZ/wQ7Z3JUrkQ22Vw3Dgn2FZDtyFQfrEdIUWw0dyyeSD6/sVypMfp7REvw76tNC+uh4dpZimzug6CwBjdW/QBmAKNng6OwUrWz+sBWfEN9+bNtYFNNObMnf9jL0rZkXhZiHQfuPeZOL9F08kXS5ySIyeQUaTIKf7ROcj8q/xy0kdYNGfgJOCmtK2LfxySGrdHW7j1nD4mNHnSNr0mKHlQe+QOE7MCtbyB4EeAiaIF35HRWwMM9QKXNPlqBeSFsS7A+Ky5rY6LIrXdG2BE5J2nM+CQH/VryByt6i+TF7dU8zTrcRLUjKt4p7kfH5pWSE15kvfOIYCvvN/oP2D+ajI6RtoqvkZMgaMw3eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199018)(36756003)(6666004)(478600001)(83380400001)(6486002)(6506007)(186003)(9686003)(1076003)(2616005)(6916009)(6512007)(8936002)(66476007)(66946007)(2906002)(66556008)(41300700001)(8676002)(30864003)(86362001)(5660300002)(26005)(316002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aAHvaor0UsWhDrK11KZb+gxVcRZvLmORTaHctn2yLep3guzMY2Wk8THbyxg8?=
 =?us-ascii?Q?kc8GXHZpKsr7fVQzHIuKIMIh3DBx5DlfrFJDms3EIvGyUdlDu/C1aSEqMqS7?=
 =?us-ascii?Q?GaAzB7DVqhewAUeUCohbmZ5kiaT7sq7bMl+QKN4LZYWrxMnGNEiZfBCdZygg?=
 =?us-ascii?Q?2gABtsBraMPoyXIQlqmgx2z+Sr08z0ce6hyYJAk/ZEca4Fm1EjS9w28C1XUg?=
 =?us-ascii?Q?rY76PMVt4QDYEwP17dsG51N7iLIFHGJ/RHmQtX1x63UscLC1B9yeh0zfbFLC?=
 =?us-ascii?Q?TaGohfLJMnUATrlvVan4k9CfCGCgvXMzDg2CBK7gHs/2fwfIYXcJs7qlWORp?=
 =?us-ascii?Q?nsVpW/FVELqKvknhjyvkDgQMtOhCDfPX97/grIxDzlz0GKsSHQmxHlR3SiSu?=
 =?us-ascii?Q?EPxQJVRi/fFbsSMGjBoxpxcdM3WMqIoXVzQqSgwTL7REvaHrpDmA6sBwOPXJ?=
 =?us-ascii?Q?p8Rjuec/Y2vRKr1kBfwfOH3FGtD6uShDTagzxCBr2AhgFAG0WUW2B11u/jN1?=
 =?us-ascii?Q?pvF9GtfIAfKrhD6BI9jA1r6RPP38C4AeklcdGjb7PxfvFu+CxDspy2SaMwuN?=
 =?us-ascii?Q?mYkIv3zcIQU9V+ScAXqy6tSvpjuUd2/TN5pMHlk/LGPKfz7Z7yCY+M0nkxUB?=
 =?us-ascii?Q?EGfwjVur1nWtDFfuCS05EOGya+GWQufVzneE7tMvDtbNJl2Lod4gIbIoWc/J?=
 =?us-ascii?Q?hIr9M4gv1WMEqCnlCdxFpE5NawvX+yXm2NPTYBsI9jsyAHjqGazBsaPA07b5?=
 =?us-ascii?Q?htuUR81UTWrr9SpDPh0ivK50F+k2YL4Fc/2YqtxoNwiJ4zaiWzMP+jUzYAoQ?=
 =?us-ascii?Q?d9O2s0pTEZ6jXNyoY1vwZdKcTLRG0520eikMoOMGBqWmQ5EPO3QboPmGRSRE?=
 =?us-ascii?Q?9HaqcluVopUBXeaTAle0vjfw5/L1oHO23l5H0eRVfs7qbb22xS3sES9rAgsp?=
 =?us-ascii?Q?7I2wI/TM1KkxcxBlvbG277Qa4oCf6blG55v2dedSu60AeZikjqhSsYRQAXN0?=
 =?us-ascii?Q?KmszRsOY6FO6ocDXYRhseLUbs+gowggS8idOdAuh+Qrz9ThgQQo1Qnb3ZEjr?=
 =?us-ascii?Q?VAyuz0GdpzAD7moQVMPT2jsoPTtMbF0uA6sauxkS81Zc70fENkroSBXkB7IY?=
 =?us-ascii?Q?exs5mD45/L8HOdkdb1W51nH6ZbqQDijA+G0vMcxm+74JiRcPlmFk0wFCko04?=
 =?us-ascii?Q?wztKVlu2vEWYQWgd1plVhUu7RznhOmcbPMMJ0ekpAT56bxHx1vimUurBC4vQ?=
 =?us-ascii?Q?rr+bcWiR4nQCx8iUjpSwisqIX+R6aI1adsrnWZcajO0A52sOcVnlLLr3EPjM?=
 =?us-ascii?Q?2fBX+dk0tUzAOepgYDTCEJKTYzzk5Ei/TesTu3UoAr+9rnx6TYxj15Cw6mt8?=
 =?us-ascii?Q?xVJ8vqmEkRTmc0LFDNzfILjqMoDcyw39+LQYUeN109ikD37QTpTSndO1PL2V?=
 =?us-ascii?Q?Ay7gualrTpEUZ44bY2Q2vU7jyvW8zpLgTuuMbr9jUppKeNZY57HmSvbimEox?=
 =?us-ascii?Q?tp9SRNBkQ9HECmVFQmykaPu2FCfMUG8h5lnC8BMgmC3rJPzaptR1UqQKIqp0?=
 =?us-ascii?Q?m/Y/MK7DuPoZOZMETGGAF9kqk1JB5h9eGS+qc90IxACpjAKeCYJB1oue5lyd?=
 =?us-ascii?Q?gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 9in2i4D6aeM8kzAwEs2prBXCpYJ0WC9/Wr20uOeh6wVJEd3RURBc8QcF7k1DqbRUQ3VRwJ2UOUuAMmDhva3cUVUJ30eaCBNIyTOyIkVTRrPkJPMW15789+rt/iEeGdy49Tdl0A60kpAaKZJoOydWhp7TRkBYXcD+wNTg2eqSKRrmfTzhAqmhtKN0jhDMH+p4U4QP69XYF//abMT5MdRlhbWJiLbkV2ADpZKqXG/PK1CB46AD9B2pt4rxLLqFCAxk0WVa3FlWiKk6CBE0VIxMSIT1vePUdcjsPMPt/lC/YR787omcgEq9LoWD+YI6JRmjQydO1Wcb8YXje8Qc3VYPLFqUtCjuJG1MWa+k9U62a0URqx0JTI3PZjD3nR8/jwhTm5F7uEPQmxweEczoJ/IBlaqrXUcEGVfr7ie4w5Zni8f5vOly8kZgmUQw+d4BZ3lfHc0D/eD5xTGgfCsArOXUqEc3AHP7VPDddcSlo3dFioQUTo78paiiAizSpT1l/eWerX4koPIvN2w9GpQ1uSeCFXQwByduF0EY33wQdLUKbbH8c0AglM01sV2ix5x8Ccy9IaZmtyw9SykpykpPkOIju6FaWQDO6IaqeL2DnmoFvlBT/B/z58g2WowVPmNP1nLwBbTP4YlhPTZ1k9BGskYAUDxloatySUEXGRLBHbeGc3XVClVK7jUtCm6GIlQxotsY0Op/TapJUi3YfOF1PmTwa8bJ322OPn3kKx0f4l5Kw0BC9p1CnDVoxqeAbLcQl7zHg9iWtsm2JQ5FYaOfiFcZTQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b4f8948-e0c5-48d2-56d3-08db2025d38d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:23.9909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ujj0lHhfHgyhSMGYYQlTtFERb70CfhWiS0a7fGaDP30ZftyTYs4f6afThlwE5HiDgOBYSbjfW98it0UroYAHkp20TRTQCL8L28tSNGzKCUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5708
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: fxv-_yulforc7RaiqX-wsjOQQSxlvULe
X-Proofpoint-ORIG-GUID: fxv-_yulforc7RaiqX-wsjOQQSxlvULe
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add parent pointer attribute during xfs_create, and subroutines to
initialize attributes

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile               |   1 +
 fs/xfs/libxfs/xfs_attr.c      |   4 +-
 fs/xfs/libxfs/xfs_attr.h      |   4 +-
 fs/xfs/libxfs/xfs_da_format.h |  12 ---
 fs/xfs/libxfs/xfs_parent.c    | 139 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h    |  57 ++++++++++++++
 fs/xfs/xfs_inode.c            |  64 +++++++++++++---
 fs/xfs/xfs_super.c            |  10 +++
 fs/xfs/xfs_xattr.c            |   4 +-
 fs/xfs/xfs_xattr.h            |   2 +
 10 files changed, 271 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 03135a1c31b6..e2b2cf50ffcf 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -40,6 +40,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
 				   xfs_log_rlimit.o \
+				   xfs_parent.o \
 				   xfs_ag_resv.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 711022742e34..f68d41f0f998 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -886,7 +886,7 @@ xfs_attr_lookup(
 	return error;
 }
 
-static int
+int
 xfs_attr_intent_init(
 	struct xfs_da_args	*args,
 	unsigned int		op_flags,	/* op flag (set or remove) */
@@ -904,7 +904,7 @@ xfs_attr_intent_init(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index b79dae788cfb..0cf23f5117ad 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -544,6 +544,7 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
+int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
@@ -552,7 +553,8 @@ bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
-
+int xfs_attr_intent_init(struct xfs_da_args *args, unsigned int op_flags,
+			 struct xfs_attr_intent  **attr);
 /*
  * Check to see if the attr should be upgraded from non-existent or shortform to
  * single-leaf-block attribute list.
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 75b13807145d..2db1cf97b2c8 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -826,16 +826,4 @@ struct xfs_parent_name_rec {
 	__be32  p_diroffset;
 };
 
-/*
- * incore version of the above, also contains name pointers so callers
- * can pass/obtain all the parent pointer information in a single structure
- */
-struct xfs_parent_name_irec {
-	xfs_ino_t		p_ino;
-	uint32_t		p_gen;
-	xfs_dir2_dataptr_t	p_diroffset;
-	const char		*p_name;
-	uint8_t			p_namelen;
-};
-
 #endif /* __XFS_DA_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
new file mode 100644
index 000000000000..6b6d415319e6
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -0,0 +1,139 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_da_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr_sf.h"
+#include "xfs_bmap.h"
+#include "xfs_defer.h"
+#include "xfs_log.h"
+#include "xfs_xattr.h"
+#include "xfs_parent.h"
+#include "xfs_trans_space.h"
+
+struct kmem_cache		*xfs_parent_intent_cache;
+
+/*
+ * Parent pointer attribute handling.
+ *
+ * Because the attribute value is a filename component, it will never be longer
+ * than 255 bytes. This means the attribute will always be a local format
+ * attribute as it is xfs_attr_leaf_entsize_local_max() for v5 filesystems will
+ * always be larger than this (max is 75% of block size).
+ *
+ * Creating a new parent attribute will always create a new attribute - there
+ * should never, ever be an existing attribute in the tree for a new inode.
+ * ENOSPC behavior is problematic - creating the inode without the parent
+ * pointer is effectively a corruption, so we allow parent attribute creation
+ * to dip into the reserve block pool to avoid unexpected ENOSPC errors from
+ * occurring.
+ */
+
+
+/* Initializes a xfs_parent_name_rec to be stored as an attribute name */
+void
+xfs_init_parent_name_rec(
+	struct xfs_parent_name_rec	*rec,
+	struct xfs_inode		*ip,
+	uint32_t			p_diroffset)
+{
+	xfs_ino_t			p_ino = ip->i_ino;
+	uint32_t			p_gen = VFS_I(ip)->i_generation;
+
+	rec->p_ino = cpu_to_be64(p_ino);
+	rec->p_gen = cpu_to_be32(p_gen);
+	rec->p_diroffset = cpu_to_be32(p_diroffset);
+}
+
+int
+__xfs_parent_init(
+	struct xfs_mount		*mp,
+	struct xfs_parent_defer		**parentp)
+{
+	struct xfs_parent_defer		*parent;
+	int				error;
+
+	error = xfs_attr_grab_log_assist(mp);
+	if (error)
+		return error;
+
+	parent = kmem_cache_zalloc(xfs_parent_intent_cache, GFP_KERNEL);
+	if (!parent) {
+		xfs_attr_rele_log_assist(mp);
+		return -ENOMEM;
+	}
+
+	/* init parent da_args */
+	parent->args.geo = mp->m_attr_geo;
+	parent->args.whichfork = XFS_ATTR_FORK;
+	parent->args.attr_filter = XFS_ATTR_PARENT;
+	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
+	parent->args.name = (const uint8_t *)&parent->rec;
+	parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+
+	*parentp = parent;
+	return 0;
+}
+
+int
+xfs_parent_defer_add(
+	struct xfs_trans	*tp,
+	struct xfs_parent_defer	*parent,
+	struct xfs_inode	*dp,
+	struct xfs_name		*parent_name,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+
+	args->trans = tp;
+	args->dp = child;
+	if (parent_name) {
+		parent->args.value = (void *)parent_name->name;
+		parent->args.valuelen = parent_name->len;
+	}
+
+	return xfs_attr_defer_add(args);
+}
+
+void
+__xfs_parent_cancel(
+	xfs_mount_t		*mp,
+	struct xfs_parent_defer *parent)
+{
+	xlog_drop_incompat_feat(mp->m_log);
+	kmem_cache_free(xfs_parent_intent_cache, parent);
+}
+
+unsigned int
+xfs_pptr_calc_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	/*
+	 * Pptrs are always the first attr in an attr tree, and never larger
+	 * than a block
+	 */
+	return XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) +
+	       XFS_NEXTENTADD_SPACE_RES(mp, namelen, XFS_ATTR_FORK);
+}
+
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
new file mode 100644
index 000000000000..d5a8c8e52cb5
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_PARENT_H__
+#define	__XFS_PARENT_H__
+
+extern struct kmem_cache	*xfs_parent_intent_cache;
+
+/*
+ * Dynamically allocd structure used to wrap the needed data to pass around
+ * the defer ops machinery
+ */
+struct xfs_parent_defer {
+	struct xfs_parent_name_rec	rec;
+	struct xfs_da_args		args;
+};
+
+/*
+ * Parent pointer attribute prototypes
+ */
+void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
+			      struct xfs_inode *ip,
+			      uint32_t p_diroffset);
+int __xfs_parent_init(struct xfs_mount *mp, struct xfs_parent_defer **parentp);
+
+static inline int
+xfs_parent_start(
+	struct xfs_mount	*mp,
+	struct xfs_parent_defer	**pp)
+{
+	*pp = NULL;
+
+	if (xfs_has_parent(mp))
+		return __xfs_parent_init(mp, pp);
+	return 0;
+}
+
+int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
+			 struct xfs_inode *dp, struct xfs_name *parent_name,
+			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+void __xfs_parent_cancel(struct xfs_mount *mp, struct xfs_parent_defer *parent);
+
+static inline void
+xfs_parent_finish(
+	struct xfs_mount	*mp,
+	struct xfs_parent_defer	*p)
+{
+	if (p)
+		__xfs_parent_cancel(mp, p);
+}
+
+unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
+				     unsigned int namelen);
+
+#endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 62c9fb2cb96e..b63d42d2fb23 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -37,6 +37,8 @@
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
+#include "xfs_parent.h"
+#include "xfs_xattr.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -946,10 +948,32 @@ xfs_bumplink(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
+static unsigned int
+xfs_create_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret;
+
+	ret = XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp, namelen);
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
+static unsigned int
+xfs_mkdir_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	return xfs_create_space_res(mp, namelen);
+}
+
 int
 xfs_create(
 	struct mnt_idmap	*idmap,
-	xfs_inode_t		*dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	umode_t			mode,
 	dev_t			rdev,
@@ -961,7 +985,7 @@ xfs_create(
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	int			error;
-	bool                    unlock_dp_on_error = false;
+	bool			unlock_dp_on_error = false;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -969,6 +993,8 @@ xfs_create(
 	struct xfs_trans_res	*tres;
 	uint			resblks;
 	xfs_ino_t		ino;
+	xfs_dir2_dataptr_t	diroffset;
+	struct xfs_parent_defer	*parent;
 
 	trace_xfs_create(dp, name);
 
@@ -988,13 +1014,17 @@ xfs_create(
 		return error;
 
 	if (is_dir) {
-		resblks = XFS_MKDIR_SPACE_RES(mp, name->len);
+		resblks = xfs_mkdir_space_res(mp, name->len);
 		tres = &M_RES(mp)->tr_mkdir;
 	} else {
-		resblks = XFS_CREATE_SPACE_RES(mp, name->len);
+		resblks = xfs_create_space_res(mp, name->len);
 		tres = &M_RES(mp)->tr_create;
 	}
 
+	error = xfs_parent_start(mp, &parent);
+	if (error)
+		goto out_release_dquots;
+
 	/*
 	 * Initially assume that the file does not exist and
 	 * reserve the resources for that case.  If that is not
@@ -1010,7 +1040,7 @@ xfs_create(
 				resblks, &tp);
 	}
 	if (error)
-		goto out_release_dquots;
+		goto out_parent;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -1020,6 +1050,7 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
+	init_xattrs = init_xattrs || xfs_has_parent(mp);
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(idmap, tp, dp, ino, mode,
@@ -1034,11 +1065,11 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	unlock_dp_on_error = false;
+	xfs_trans_ijoin(tp, dp, 0);
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
+				   resblks - XFS_IALLOC_SPACE_RES(mp),
+				   &diroffset);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1054,6 +1085,17 @@ xfs_create(
 		xfs_bumplink(tp, dp);
 	}
 
+	/*
+	 * If we have parent pointers, we need to add the attribute containing
+	 * the parent information now.
+	 */
+	if (parent) {
+		error = xfs_parent_defer_add(tp, parent, dp, name, diroffset,
+					     ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * create transaction goes to disk before returning to
@@ -1079,6 +1121,8 @@ xfs_create(
 
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, parent);
 	return 0;
 
  out_trans_cancel:
@@ -1090,10 +1134,12 @@ xfs_create(
 	 * transactions and deadlocks from xfs_inactive.
 	 */
 	if (ip) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
+ out_parent:
+	xfs_parent_finish(mp, parent);
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2479b5cbd75e..69ba6569e830 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -41,6 +41,7 @@
 #include "xfs_attr_item.h"
 #include "xfs_xattr.h"
 #include "xfs_iunlink_item.h"
+#include "xfs_parent.h"
 
 #include <linux/magic.h>
 #include <linux/fs_context.h>
@@ -2124,8 +2125,16 @@ xfs_init_caches(void)
 	if (!xfs_iunlink_cache)
 		goto out_destroy_attri_cache;
 
+	xfs_parent_intent_cache = kmem_cache_create("xfs_parent_intent",
+					     sizeof(struct xfs_parent_defer),
+					     0, 0, NULL);
+	if (!xfs_parent_intent_cache)
+		goto out_destroy_iul_cache;
+
 	return 0;
 
+ out_destroy_iul_cache:
+	kmem_cache_destroy(xfs_iunlink_cache);
  out_destroy_attri_cache:
 	kmem_cache_destroy(xfs_attri_cache);
  out_destroy_attrd_cache:
@@ -2180,6 +2189,7 @@ xfs_destroy_caches(void)
 	 * destroy caches.
 	 */
 	rcu_barrier();
+	kmem_cache_destroy(xfs_parent_intent_cache);
 	kmem_cache_destroy(xfs_iunlink_cache);
 	kmem_cache_destroy(xfs_attri_cache);
 	kmem_cache_destroy(xfs_attrd_cache);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 7b9a0ed1b11f..8224aed5f938 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -27,7 +27,7 @@
  * they must release the permission by calling xlog_drop_incompat_feat
  * when they're done.
  */
-static inline int
+int
 xfs_attr_grab_log_assist(
 	struct xfs_mount	*mp)
 {
@@ -61,7 +61,7 @@ xfs_attr_grab_log_assist(
 	return error;
 }
 
-static inline void
+void
 xfs_attr_rele_log_assist(
 	struct xfs_mount	*mp)
 {
diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
index 2b09133b1b9b..7e0a2f3bb7f8 100644
--- a/fs/xfs/xfs_xattr.h
+++ b/fs/xfs/xfs_xattr.h
@@ -7,6 +7,8 @@
 #define __XFS_XATTR_H__
 
 int xfs_attr_change(struct xfs_da_args *args);
+int xfs_attr_grab_log_assist(struct xfs_mount *mp);
+void xfs_attr_rele_log_assist(struct xfs_mount *mp);
 
 extern const struct xattr_handler *xfs_xattr_handlers[];
 
-- 
2.25.1

