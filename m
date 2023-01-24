Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C229C05027
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbjAXBhK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbjAXBhJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:37:09 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCB51B57C
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:37:06 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04j4g022188
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=C1lm0sK2KeKSUuw7ZKnVsh38+y8qrhooA0z1zYiajTY=;
 b=ifRpH6bzCFF0GqmZ5dHWOoyDk+Ga/ws/UJr69AqVoR+MOSDb6372hascrQKTVohKG+ym
 /3DQybj0SXbT7qNeEngeE6CjlEw3zTyuU5iywtqAN6s9F/iy7URqL7ShFy3nZilO1RP7
 BYhxRiz8Y/jR6LZ7V41PGdI+Qg3aiLscWdWJaQ7dE+Zsb1YVhGbCkhVziXFkha/JgJg7
 FoUhL5vcNt9KMlIzYQL7wOR+xRENn/5kXL1d9pleEawxijbENu/fYDsqsYYYutOEzYFn
 +1UqzhgY4BrlHxoqUuqTEl8tNmiHC0qypiV+tMUTqGoMJqZH+qa2+awLY95Gpj3dbd2u tw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n88ktv8da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:06 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30O0xVZU001093
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:05 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gakvy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KAaQ5uVHg8lT845KQhquqOwO0MwRdRx3aUm/b+kBc9qLr2dVBgeZY966zl6IIRsoxo7IHS4d3wB4NArSnLjIe3IdUkwbdKYk5E4r6zdh9JsFP10gADZbxMmFtxFsvZlgq39zJrCsG2R+9Ghjk8iHGbsQ8VHrEo5Vf0icGxJhBl9v7P7ktmPFrASBSWx6SKiEp9/w3kEQwFFe0HSgmRg1jcKIeck+33WFb14N463SOeLrvW37eCye+IPh5FSrcfTZ1K4qV3e24fXCa9jV5VsmvK2OGy80IOxyMgbJ7MBFDNzOdNYvu7QdMG/KWzNh5/HfjIlC0ncFo+/M6w+5MEbzUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C1lm0sK2KeKSUuw7ZKnVsh38+y8qrhooA0z1zYiajTY=;
 b=eO5KTc19QLxFL5L5el9SpO6tLd2lRZ+hcX0aI+Up/LMLk5oS6CnCHgzjjUw5Cp/z53FvXoulswJZBOU07kBaYSf6W4O3iFz+MixHRO6IRwE7EFYyMNNK2alq5rR+p3VmYkbsrexeLP0+dtYQesEub1pKjknMiVfXrcqU0rAjJuniOin2s5/85O3lSKjDNNKl9GlozoBfRpO9vceZxcYQHS26GuugPanKv2QuHVW0Rf0Rj2spGy84admdcIgGo1IIMzNn2Z52qpEqLysii5c1VJ2N2rXBFiotMHIMrLBo82tNe+CBtrOR4Z0L4CAD3zBb1LsQHV7msi31xp+3wvMwrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1lm0sK2KeKSUuw7ZKnVsh38+y8qrhooA0z1zYiajTY=;
 b=ZjfvKgJxTW7ziC45JCKCM/qcm/AyNHEprlTXbRdaBnjfZpuxQj/38M/NQ5eZZIF0z5wlVvbpk/Vfk2p6MY9vkh93HPcP7fIfWeSV8uaVrQ5WUiHolrKkSOr2yew6rlxkxUwXPIAOhvmfcXUGC6OnmfbjWVLsTfuOKnDK4bGOWpQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.8; Tue, 24 Jan
 2023 01:37:03 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:37:03 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 25/27] xfs: Add parent pointer ioctl
Date:   Mon, 23 Jan 2023 18:36:18 -0700
Message-Id: <20230124013620.1089319-26-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0272.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::7) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: 581ab375-cc55-47c5-a3f9-08dafdab7e5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xe25W7w19k9kq9cn7ALAgTSvRsbfXc3yQFAbapIcCWuriA980eQf2o5or4B6PVILdvR0ymEgtUTG8RV+H3cfLsuA8OllHYl1bDDkeuLX7N3N6uboJD+aJio3OVOFejEtK5MqQSK4aMi2U/M8iL6MfP2y2KHqqftkRpmWcL35Gaf/2VItFIcPY5f2WsUt29AQb2wSKNzRiXYB9jkbJVYxjaxAZ1Nxm4E8l7rI1tsfaTrx+twX7QC08LSTFSFgVrkEC2nGWj/rEQ9RAjQ1eL2tQRZswjxe6X5p6TWInvL4dI0SQCK3g9iJrBxYIdDAa0drsdkGsjxofEbHxXk5xqMYxneDZViPmLkKJbsVcM4ccBmxPcw9J1OIHScC4EP27QSRskxGlw/5183S3oM/WYPr9oEP6UanHXKCSKWKKKLUoeHICfb8JKDf9LKioaYugQptC7Fpjl4XG87GFdz/Rz2TylSBTbH26ZmdYy5BKxaLtzz49lAWpEmA9xwHyM+9lcaCIcVVxDg+sY7tI8m/M20eNFhn0LHXfkL7v+LxI57oDJZFTygpz9eT3b5MSL4yznJee//7Z5YbOC1V9tDywx8KHMy11Vv0EiXXzvA5lIokwLUqQJ8zDbYFRsCcqWiKsntOGaDz8yLrIyNDpBMa4cf6XQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(66556008)(66476007)(83380400001)(6916009)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(316002)(2616005)(2906002)(30864003)(38100700002)(5660300002)(8936002)(6512007)(6486002)(26005)(9686003)(186003)(478600001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/GvKl9j/qcF1blaed0tSj/E1RVC04Sk74TfRK/1OS/1S4CgZDzwLiUPK7WQC?=
 =?us-ascii?Q?IVMQhwt4Y3lvVif96EiObFJLIHWVQFpH2RqgrfjgSuu2wywIocHt6328DC6W?=
 =?us-ascii?Q?3lLEspVYpMlO6+liU24dmeUMqq0ytLRyHR6SkRuwsdEoXJb67Pw5zreUuT1Z?=
 =?us-ascii?Q?j5yGuvGdV6is+vffLWXHcXFUVqIXNmQEgrQsgauK28Jg/bcKWb9+SE0ZcHeT?=
 =?us-ascii?Q?jGIbof4x0cP88Ex6zZTZApl68MpGyJAIXIlsTiW7mMQdCDlrqNTiNH73wTby?=
 =?us-ascii?Q?/JaGVD4JcdatEqqqM5pzwN1AWx68+OFVjc5ilNBfRqoKcI0gAuNwVeBbigzk?=
 =?us-ascii?Q?njm/2yY5hWbKjekEdt4BNJvhE46SkG1Dr7mmxk0a0rq11KeAtLjPYfSanqcE?=
 =?us-ascii?Q?y0blNk3KJIT4uuZm1UNjbjZBBBP/5yq7mcnzJJtUB41f+eam8K9Ji3e8FTPm?=
 =?us-ascii?Q?z6FqxTNC7vM1z+tGag5i8WYHK7bh0qOQwcqlyh/vCRoQyI+TSnMLZuNr6Qmp?=
 =?us-ascii?Q?LUIneiiLypTID+O2cb+c3dLIXwCHiHOMpsJ4qM0ETJ/UWPqY8mq9oXvj8/K9?=
 =?us-ascii?Q?Fo5lE+JKQQuwEsKenuBMthnyyGRsBn5vNpq8LAxQOqt1jsrqXsJK1qHs8cEI?=
 =?us-ascii?Q?o3URXOJrxNm1TFpKJUCRWMsAl6yMIaYy1nTdwCR4NTI3HLu3GBWjiLkIvK6y?=
 =?us-ascii?Q?vGGw7Ppw6uD0hTwXXMeBC+sMxtujnOmIn3/MwZNrNRZUiznRS1OSLy1DFafQ?=
 =?us-ascii?Q?dritTY5vAWQ5qhrW24uEDvc/tCafPOOdKFWNPxam6cEpdvCjQMP+W+TP1SP/?=
 =?us-ascii?Q?06h/TTdOHs90YIt1BTHf1xEFo5AQ0unFp7Fqe/N4fk+8QlRcCwD5A+r/ulFa?=
 =?us-ascii?Q?iLsv9urjppcUCHKDFCkBj0X8/hTevuhK8fM7PcGY82NOsU4xkip6UFwTSbin?=
 =?us-ascii?Q?2LVv5GVPA9XKzo7C0wbFeaTQVth/mSwUZUHVR2ZPX6LTshxcrI8c4OMyjPLX?=
 =?us-ascii?Q?y2mYfpX0HzGj0kx+etzxR0uaKdrJidLKgzgJkNjujAj6cWpACDmbEIHRGGEf?=
 =?us-ascii?Q?meEPORSdTGIpSxUFxq1RXmgypW8pL/Bq8jrRejh/K2hoee1lOLD8ECDnIk7M?=
 =?us-ascii?Q?jyUBIiRDRw4YELdhND2rjutuFTc5JXqlxS+kp/yTZKE7h/xOd9V1K0vjI+0/?=
 =?us-ascii?Q?EdOZXco0lSDJt4ZEzVVNHHY4KYvKNz/OA9quhoKiTyEFLCA/SqfvndW256vg?=
 =?us-ascii?Q?8IGmGwM7GhZuZ9L1hkpBm+Wk80ONgx2mKxxt9Q2EbITGedMxmLrPEt+qFl1a?=
 =?us-ascii?Q?RzVBeFJ5DllGKx+WnlYhOLLpVLOCKvhpO94FwgD9R89yo0thhgbUygJTroND?=
 =?us-ascii?Q?qvHN7Y9tE6hrWQNIEJXsCCjIAwy3Z70qQ7PHG/Bmg51XyyU70GX8rXCvLjFl?=
 =?us-ascii?Q?lf1Ygg6ttZyXaNZxJuXZFLuiU7bVCzn8hN6k9kGeYL8NrMYo2ZVExrEhBla0?=
 =?us-ascii?Q?224fnGbzv9awJWdXidJq7tgIqP36f8EgPEQUvECZIfDF9GXRbkJDrgGJJmtz?=
 =?us-ascii?Q?A9wxhaQydDKmQZ2ZMjHJHnkN/kgcrkvkiRDrpMDDmi3OhoEJeI3hmRwaPqt/?=
 =?us-ascii?Q?4w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: VfM9vWR5P0qFaO89YPmDFDRl2hx/gbWjEanbE78m0c2z7/wFWCt4jzgMIDvdjzfKbHG2k1aENg44q6Lr5cG9WqQPCWP+EmHCbHG8lSgrKYDpwGjwPsiUw9DufnctcvPdyol2jIooEMnBCkDwqibE6eoM4W8s06wrg1nhlJa+3mm2iGLnXxk90McjeSvHA+vgM7b1alhYGGLvy/LPyMG0QI8xT8RpEiNEmWH13aBQrFy7+3zYDc2qmFiChTw1hClAKB7fRapx+P5S9YnoeMrhln9RxiYxe7NwJ+Zf0D60sFt9eiAnWmbTd+d4j7joXAumxBBBO4913h54eh0JuAWCymRugEYLri6CV1KPqrpAybPXL+f6bDj+H6yqoiwEsUxdHPQjo6ZtrWL25Uk2Qy39gx7P05u10ddu1BRirS7ejmUqaURIVe78dQJ/CTkan6QY/u6LXcxIKILwefX88bQf3NlcpelQJGY7+IGS8D/nWay4FqJMlFvdT1jeelKK1VWhFW+yx6czFVL0Gzq+wj941AYLjAEHsh0BfII5JCCuq80ALLuX7SnPpj6UeAtehsGy3kzaiEUzK5UCjRCVHUhuCXQAZAvwdpYQcK2wMkCk+8AqbkdMcPxIAyuucjrB9QUDcisZojBNYugQLY97QPxmc8GuXrj0hpX2rzX9jkn5ouTrWI0MGGTLtsGA6ApMGB3yWutMQWOgGy3jfuNUVutljkKieBNjJ6fJwP/WmI64UyoljG+I3DH+7Sp5GD3/dMFXyJ6E9srCKpfp+SEfNfpYmQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 581ab375-cc55-47c5-a3f9-08dafdab7e5a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:37:02.9013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l3SbWY2tLfzIBz4JHg9lekKygHvXAkSRmUoHf4q6VgSQaGWcK2ab+yrSC7EiMjpw3mmhkyslkpuGkglM2pIxOgo8qP/+xj4bKJkiDZRwaE4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240010
X-Proofpoint-GUID: CwH30sEw9tEoow4M708Dt7VoxQp9a62r
X-Proofpoint-ORIG-GUID: CwH30sEw9tEoow4M708Dt7VoxQp9a62r
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a new file ioctl to retrieve the parent pointer of a
given inode

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile            |   1 +
 fs/xfs/libxfs/xfs_fs.h     |  74 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.c |  10 +++
 fs/xfs/libxfs/xfs_parent.h |   2 +
 fs/xfs/xfs_ioctl.c         |  94 ++++++++++++++++++++++++++-
 fs/xfs/xfs_ondisk.h        |   4 ++
 fs/xfs/xfs_parent_utils.c  | 126 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_parent_utils.h  |  11 ++++
 8 files changed, 321 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e2b2cf50ffcf..42d0496fdad7 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -86,6 +86,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
 				   xfs_pwork.o \
+				   xfs_parent_utils.o \
 				   xfs_reflink.o \
 				   xfs_stats.o \
 				   xfs_super.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b0b4d7a3aa15..9e59a1fdfb0c 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -752,6 +752,79 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+#define XFS_PPTR_MAXNAMELEN				256
+
+/* return parents of the handle, not the open fd */
+#define XFS_PPTR_IFLAG_HANDLE  (1U << 0)
+
+/* target was the root directory */
+#define XFS_PPTR_OFLAG_ROOT    (1U << 1)
+
+/* Cursor is done iterating pptrs */
+#define XFS_PPTR_OFLAG_DONE    (1U << 2)
+
+ #define XFS_PPTR_FLAG_ALL     (XFS_PPTR_IFLAG_HANDLE | XFS_PPTR_OFLAG_ROOT | \
+				XFS_PPTR_OFLAG_DONE)
+
+/* Get an inode parent pointer through ioctl */
+struct xfs_parent_ptr {
+	__u64		xpp_ino;			/* Inode */
+	__u32		xpp_gen;			/* Inode generation */
+	__u32		xpp_diroffset;			/* Directory offset */
+	__u64		xpp_rsvd;			/* Reserved */
+	__u8		xpp_name[XFS_PPTR_MAXNAMELEN];	/* File name */
+};
+
+/* Iterate through an inodes parent pointers */
+struct xfs_pptr_info {
+	/* File handle, if XFS_PPTR_IFLAG_HANDLE is set */
+	struct xfs_handle		pi_handle;
+
+	/*
+	 * Structure to track progress in iterating the parent pointers.
+	 * Must be initialized to zeroes before the first ioctl call, and
+	 * not touched by callers after that.
+	 */
+	struct xfs_attrlist_cursor	pi_cursor;
+
+	/* Operational flags: XFS_PPTR_*FLAG* */
+	__u32				pi_flags;
+
+	/* Must be set to zero */
+	__u32				pi_reserved;
+
+	/* # of entries in array */
+	__u32				pi_ptrs_size;
+
+	/* # of entries filled in (output) */
+	__u32				pi_ptrs_used;
+
+	/* Must be set to zero */
+	__u64				pi_reserved2[6];
+
+	/*
+	 * An array of struct xfs_parent_ptr follows the header
+	 * information. Use xfs_ppinfo_to_pp() to access the
+	 * parent pointer array entries.
+	 */
+	struct xfs_parent_ptr		pi_parents[];
+};
+
+static inline size_t
+xfs_pptr_info_sizeof(int nr_ptrs)
+{
+	return sizeof(struct xfs_pptr_info) +
+	       (nr_ptrs * sizeof(struct xfs_parent_ptr));
+}
+
+static inline struct xfs_parent_ptr*
+xfs_ppinfo_to_pp(
+	struct xfs_pptr_info	*info,
+	int			idx)
+{
+	return &info->pi_parents[idx];
+}
+
 /*
  * ioctl limits
  */
@@ -797,6 +870,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
+#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_parent_ptr)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 954a52d6be00..fa3d645731a9 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -27,6 +27,16 @@
 #include "xfs_parent.h"
 #include "xfs_trans_space.h"
 
+/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
+void
+xfs_init_parent_ptr(struct xfs_parent_ptr		*xpp,
+		    const struct xfs_parent_name_rec	*rec)
+{
+	xpp->xpp_ino = be64_to_cpu(rec->p_ino);
+	xpp->xpp_gen = be32_to_cpu(rec->p_gen);
+	xpp->xpp_diroffset = be32_to_cpu(rec->p_diroffset);
+}
+
 /*
  * Parent pointer attribute handling.
  *
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 9021241ad65b..898842b4532d 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -24,6 +24,8 @@ void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
 			      uint32_t p_diroffset);
 void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
 			       struct xfs_parent_name_rec *rec);
+void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
+			 const struct xfs_parent_name_rec *rec);
 int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5cd5154d4d1e..df5a45b97f8f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -37,6 +37,7 @@
 #include "xfs_health.h"
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
+#include "xfs_parent_utils.h"
 #include "xfs_xattr.h"
 
 #include <linux/mount.h>
@@ -1675,6 +1676,96 @@ xfs_ioc_scrub_metadata(
 	return 0;
 }
 
+/*
+ * IOCTL routine to get the parent pointers of an inode and return it to user
+ * space.  Caller must pass a buffer space containing a struct xfs_pptr_info,
+ * followed by a region large enough to contain an array of struct
+ * xfs_parent_ptr of a size specified in pi_ptrs_size.  If the inode contains
+ * more parent pointers than can fit in the buffer space, caller may re-call
+ * the function using the returned pi_cursor to resume iteration.  The
+ * number of xfs_parent_ptr returned will be stored in pi_ptrs_used.
+ *
+ * Returns 0 on success or non-zero on failure
+ */
+STATIC int
+xfs_ioc_get_parent_pointer(
+	struct file			*filp,
+	void				__user *arg)
+{
+	struct xfs_pptr_info		*ppi = NULL;
+	int				error = 0;
+	struct xfs_inode		*ip = XFS_I(file_inode(filp));
+	struct xfs_mount		*mp = ip->i_mount;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* Allocate an xfs_pptr_info to put the user data */
+	ppi = kmalloc(sizeof(struct xfs_pptr_info), 0);
+	if (!ppi)
+		return -ENOMEM;
+
+	/* Copy the data from the user */
+	error = copy_from_user(ppi, arg, sizeof(struct xfs_pptr_info));
+	if (error) {
+		error = -EFAULT;
+		goto out;
+	}
+
+	/* Check size of buffer requested by user */
+	if (xfs_pptr_info_sizeof(ppi->pi_ptrs_size) > XFS_XATTR_LIST_MAX) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	if (ppi->pi_flags & ~XFS_PPTR_FLAG_ALL) {
+		error = -EINVAL;
+		goto out;
+	}
+	ppi->pi_flags &= ~(XFS_PPTR_OFLAG_ROOT | XFS_PPTR_OFLAG_DONE);
+
+	/*
+	 * Now that we know how big the trailing buffer is, expand
+	 * our kernel xfs_pptr_info to be the same size
+	 */
+	ppi = krealloc(ppi, xfs_pptr_info_sizeof(ppi->pi_ptrs_size), 0);
+	if (!ppi)
+		return -ENOMEM;
+
+	if (ppi->pi_flags & XFS_PPTR_IFLAG_HANDLE) {
+		error = xfs_iget(mp, NULL, ppi->pi_handle.ha_fid.fid_ino,
+				0, 0, &ip);
+		if (error)
+			goto out;
+
+		if (VFS_I(ip)->i_generation != ppi->pi_handle.ha_fid.fid_gen) {
+			error = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (ip->i_ino == mp->m_sb.sb_rootino)
+		ppi->pi_flags |= XFS_PPTR_OFLAG_ROOT;
+
+	/* Get the parent pointers */
+	error = xfs_attr_get_parent_pointer(ip, ppi);
+
+	if (error)
+		goto out;
+
+	/* Copy the parent pointers back to the user */
+	error = copy_to_user(arg, ppi,
+			xfs_pptr_info_sizeof(ppi->pi_ptrs_size));
+	if (error) {
+		error = -EFAULT;
+		goto out;
+	}
+
+out:
+	kmem_free(ppi);
+	return error;
+}
+
 int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp)
@@ -1964,7 +2055,8 @@ xfs_file_ioctl(
 
 	case XFS_IOC_FSGETXATTRA:
 		return xfs_ioc_fsgetxattra(ip, arg);
-
+	case XFS_IOC_GETPARENTS:
+		return xfs_ioc_get_parent_pointer(filp, arg);
 	case XFS_IOC_GETBMAP:
 	case XFS_IOC_GETBMAPA:
 	case XFS_IOC_GETBMAPX:
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 9737b5a9f405..6a6bd05c2a68 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -150,6 +150,10 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_32, efi_extents,	16);
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
 
+	/* parent pointer ioctls */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_ptr,            280);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_pptr_info,             104);
+
 	/*
 	 * The v5 superblock format extended several v4 header structures with
 	 * additional data. While new fields are only accessible on v5
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
new file mode 100644
index 000000000000..771279731d42
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_ioctl.h"
+#include "xfs_parent.h"
+#include "xfs_da_btree.h"
+#include "xfs_parent_utils.h"
+
+/*
+ * Get the parent pointers for a given inode
+ *
+ * Returns 0 on success and non zero on error
+ */
+int
+xfs_attr_get_parent_pointer(
+	struct xfs_inode		*ip,
+	struct xfs_pptr_info		*ppi)
+{
+
+	struct xfs_attrlist		*alist;
+	struct xfs_attrlist_ent		*aent;
+	struct xfs_parent_ptr		*xpp;
+	struct xfs_parent_name_rec	*xpnr;
+	char				*namebuf;
+	unsigned int			namebuf_size;
+	int				name_len, i, error = 0;
+	unsigned int			lock_mode, flags = XFS_ATTR_PARENT;
+	struct xfs_attr_list_context	context;
+
+	/* Allocate a buffer to store the attribute names */
+	namebuf_size = sizeof(struct xfs_attrlist) +
+		       (ppi->pi_ptrs_size) * sizeof(struct xfs_attrlist_ent);
+	namebuf = kvzalloc(namebuf_size, GFP_KERNEL);
+	if (!namebuf)
+		return -ENOMEM;
+
+	memset(&context, 0, sizeof(struct xfs_attr_list_context));
+	error = xfs_ioc_attr_list_context_init(ip, namebuf, namebuf_size, 0,
+			&context);
+	if (error)
+		goto out_kfree;
+
+	/* Copy the cursor provided by caller */
+	memcpy(&context.cursor, &ppi->pi_cursor,
+		sizeof(struct xfs_attrlist_cursor));
+	context.attr_filter = XFS_ATTR_PARENT;
+
+	lock_mode = xfs_ilock_attr_map_shared(ip);
+
+	error = xfs_attr_list_ilocked(&context);
+	if (error)
+		goto out_unlock;
+
+	alist = (struct xfs_attrlist *)namebuf;
+	for (i = 0; i < alist->al_count; i++) {
+		struct xfs_da_args args = {
+			.geo = ip->i_mount->m_attr_geo,
+			.whichfork = XFS_ATTR_FORK,
+			.dp = ip,
+			.namelen = sizeof(struct xfs_parent_name_rec),
+			.attr_filter = flags,
+		};
+
+		xpp = xfs_ppinfo_to_pp(ppi, i);
+		memset(xpp, 0, sizeof(struct xfs_parent_ptr));
+		aent = (struct xfs_attrlist_ent *)
+			&namebuf[alist->al_offset[i]];
+		xpnr = (struct xfs_parent_name_rec *)(aent->a_name);
+
+		if (aent->a_valuelen > XFS_PPTR_MAXNAMELEN) {
+			error = -EFSCORRUPTED;
+			goto out_unlock;
+		}
+		name_len = aent->a_valuelen;
+
+		args.name = (char *)xpnr;
+		args.hashval = xfs_da_hashname(args.name, args.namelen),
+		args.value = (unsigned char *)(xpp->xpp_name);
+		args.valuelen = name_len;
+
+		error = xfs_attr_get_ilocked(&args);
+		error = (error == -EEXIST ? 0 : error);
+		if (error) {
+			error = -EFSCORRUPTED;
+			goto out_unlock;
+		}
+
+		xfs_init_parent_ptr(xpp, xpnr);
+		if (!xfs_verify_ino(args.dp->i_mount, xpp->xpp_ino)) {
+			error = -EFSCORRUPTED;
+			goto out_unlock;
+		}
+	}
+	ppi->pi_ptrs_used = alist->al_count;
+	if (!alist->al_more)
+		ppi->pi_flags |= XFS_PPTR_OFLAG_DONE;
+
+	/* Update the caller with the current cursor position */
+	memcpy(&ppi->pi_cursor, &context.cursor,
+			sizeof(struct xfs_attrlist_cursor));
+
+out_unlock:
+	xfs_iunlock(ip, lock_mode);
+out_kfree:
+	kvfree(namebuf);
+
+	return error;
+}
+
diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
new file mode 100644
index 000000000000..ad60baee8b2a
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#ifndef	__XFS_PARENT_UTILS_H__
+#define	__XFS_PARENT_UTILS_H__
+
+int xfs_attr_get_parent_pointer(struct xfs_inode *ip,
+				struct xfs_pptr_info *ppi);
+#endif	/* __XFS_PARENT_UTILS_H__ */
-- 
2.25.1

