Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1644C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbiAUFUD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:20:03 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1164 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232204AbiAUFUC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:20:02 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04fiK009111;
        Fri, 21 Jan 2022 05:20:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=E1/rZKke48a/2qy9gV7gAk78ENKJhFUxMD7u+pqn2Jw=;
 b=MzVUjPVNpNw91oMbbX79jjtflMDcQwaPAMdqX5/SkLC8zPlHNNFHUaHnenBXb+WV0/Bh
 X0r27vPgNBwJ49FVgMWTlNvmjfTYo3lEJI7LOSmgaGfUS04IdpKPzKGpfAhlx1WzNY81
 NzjcDweh+siLk4EiQPy+4seXFLhTLRVmMLwKvm3bD1/zNYdUP7QM2MM0xb4VGWiknt10
 LXybMA+nv/hsFXxzg/SInoN7PUThMdcfkHbVfiE8Unb6i3hR/gU8HnEN/auJPFi4vEXf
 9gUooBKkcZ2IBQcAUo1tPJhotjc0Sz2aYoQF2fNwtPHs5Aiy/A5tEKUvq2Z41TkHeOQZ Hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhykrcp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5Gg4h081935;
        Fri, 21 Jan 2022 05:19:59 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by userp3030.oracle.com with ESMTP id 3dqj0vbk6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXOwoaowg7ZSyCR/0yb0XWgDiRuCpX6VGt06IK6m87UGTKxb1i4c0cAK41wL3SGAEhoyXZ51VlycmsU0Ey8xBp/rGFtRsaTqqT5DqNkQ5EuHQMYFs3OEllYmgErlCblPsw3g4jUKqRdzOLVmbGQG4MmvkGld6hqzJMj63gwsRXP9NUefhIAwOOHLcadHLtlgzL3hjv8Rt63/yDKRfsRRnaaATbiOIyD6WozhQLiXdu/Zy0WQ+cDpRncn47pIGuLIYITz8IlH9El7KQcxWSrKPo6GSOzpDY8+EI6aHQiF7U2J74cwS6KvbG9C+xjvJULe7mi7JxBV4005lDQlOL7ylQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E1/rZKke48a/2qy9gV7gAk78ENKJhFUxMD7u+pqn2Jw=;
 b=Y1g6+tPc4XQewQDQACvW16DgTU+iYaYIWxuqshS/LQmdMoHGqgSfKyX//MVQaci4zrA9YZ72ing/RJl4NO74hhcLEwHgbSxxRvJbE46BDNfyGacOfL47zLPy4oYNl6V/g1iWUbJ6ffdY3utBft9UZ4Y8X/ZiwBPOIby4MDSY+AryMkPP6haFidlZhbvExNHE4At++R6V3JRUXc++C++hbD8uAciL+2efxD87UljN2njdyFCaqdxO0ehaQKZD32Mj7je4GAF/9d0AVJVcawAZYvR9v9K/H+a3q3kgGzwl79jkG3BUcPIOi1+m9atQ+PzPqh5/W3SgpgSKRAC3peCuTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1/rZKke48a/2qy9gV7gAk78ENKJhFUxMD7u+pqn2Jw=;
 b=fXq0xDx1/YthPOCRSneROUvfE6VWZ8fpYaBG6v3HLrrgMBn8o3lsjTocRFNK63nXK7NPiL0OMjV7Jc0DcJrvMla+Y/d3acWqK62QthJSmnTN6VgcxLwhesT0L6m9kWZHKHrkFgtdzmz1PPMmii+ZuI5ryd1RmKtiwwkDU9/MZ4A=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CY4PR10MB1287.namprd10.prod.outlook.com (2603:10b6:903:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Fri, 21 Jan
 2022 05:19:56 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:19:56 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 13/16] xfs: Conditionally upgrade existing inodes to use 64-bit extent counters
Date:   Fri, 21 Jan 2022 10:48:54 +0530
Message-Id: <20220121051857.221105-14-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3833377c-90ef-4faa-06c6-08d9dc9da9bc
X-MS-TrafficTypeDiagnostic: CY4PR10MB1287:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1287DFBEB2C31A906C7FAF19F65B9@CY4PR10MB1287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:47;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xjTdXtAV6eVG3btLeGp/tO4AwaPtsv/1IYhTk90Ql0ce9I0kbBZsVdhM0jJyirpO+QVE6ks/uX4FwIoYHxDCcBttqcMMQH02nSOFhjUk1Okmulv4WCUbsCVHldiYU3MAtfRq7jaorhiVwKluhDtDrk663E8Nzy7vha/6YUrOVlfI7/83YL5LsPIMjpyfEs1j1FgNr63bAXKUh2lOPqnmBSxTgFqTvhXWEB2VJSX5LzOWIjGqJdAJeaFyhqEz7YVgqpb5Tw1JI0AWioSxjGcLd0k51g+kMy0lsSZxVYyE/CwePsiLBePKjtHZP33yb9RK2VkvYkaE1DI+yHxlJzCRLj09KLpfVeJX7maAwnsJyxtJPE9DTlWoghG7RgAFz48bzXpzHg4CK5ahFtmu6XZBpBCpXoHgM1OiWSRnsU210piRDYlkWdGWsjZOWMZj8FxPH+ybxCjMxKzmEokM2tVP/2e0srZXxITwrFvUdqd4iLuqoxF3UZvZhykg+/ClIs5wmWA1Mx+I6V277VeQwYGU1HECeW8HQvOhHYW9XkISnUi+XmLE4ezqwmQhGXh5GaE6zcTFlJiEAHhlASqd3Tst66Lq59zoo3yB1TAYzvh6NwA8N+aVW0M7kRYlRJ1qofwuoe8ZIjour/u4Nuf+gq7EpbWCJm3T/5i8qjpl7fBu0v4kLxxF7FKRW1Lj3hILMaIWzZOfLumt1TbpK/QHqTxrwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(52116002)(66556008)(4744005)(26005)(6916009)(2906002)(8676002)(5660300002)(66946007)(2616005)(6512007)(1076003)(4326008)(38100700002)(83380400001)(66476007)(86362001)(38350700002)(8936002)(6506007)(316002)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6V4pDHojyZdQZ0AesYXIRi1d0rzHOinqW8mHya6d21Mjz9ARTwaqYXb899xH?=
 =?us-ascii?Q?h6+O0idQFeTdmC0faC9mfUrdUozYB1QZ2+yiE8bGj41bFW3CC/FAiqKQ64ix?=
 =?us-ascii?Q?vzkILP8niytSiuz3vgbnG06PyQxew0+nPrYBEZBHGxq+D4k8rHEl8foDh5Gd?=
 =?us-ascii?Q?kkFHolKHa1gHvw6uEvXRt4Nn03+VeahWCUR0oEt6S+oGTYH3rUS1RbrfUeE2?=
 =?us-ascii?Q?FC/95erYMV0OFLNo9SgsupDpLCMdSKmxp2FbnL6aR7NspwysFQtEtcHoRKU4?=
 =?us-ascii?Q?wR9JKnCchMzOe07zweppByG778zi3i5p6jisDQ2mP+Ki0mz7oEFQ4hQkilLK?=
 =?us-ascii?Q?8Jqg5x2BY146Uux+KN+LKreI9XuzYlqfPbSkJv5pMBS2xOZZV7jFHv7cXair?=
 =?us-ascii?Q?+EFE8pqquoXvdysIHGoKe7BASleog60cP0+RX+Gl1TpprtckWPEXfRN3FOYJ?=
 =?us-ascii?Q?AFmYr7/6L09iCUa4APMP6jXUezDKZ+tivF0GoFTxRjuxZmT2+m9QaEt6GpUl?=
 =?us-ascii?Q?ZXT5ukUyqem18GBgKTQX+o1mI2Ln5pNLIFN7MgJXQ9CrVR3SQn6jwqdR7Sb4?=
 =?us-ascii?Q?GHiP8D44hr7XNPTt/KUvj0OZPUW8i74d3tJiaSfFVDKkNkZI9zJNBhfm8dbw?=
 =?us-ascii?Q?IgJYtWwoqyBYsEpwrkdPAoblJ3O/AKQZd+8KBrg4+SvBSUhUjgmIJtQGJJAY?=
 =?us-ascii?Q?Si/DjrPt453n5JMnlykJV9UAVLchar32qqzVyOd/PW2V6hMI1AbbbeDIbwM8?=
 =?us-ascii?Q?D2qINjy90gOMNt2ZUuiiai9XekEGG69Ia4ZLDVMlW7BG/DD7yHiwSF+V5245?=
 =?us-ascii?Q?4BM4DFWmaRdEOlhFrs9r+IKEevDD8Y4djhNYGnFl+eegCMSGkm6merQVd34L?=
 =?us-ascii?Q?xi8qbgWhg9yb11BuG5C/dUnG3K7Qz+rYPhLmBVGxER5nSQmxEEoIHGw7uMiK?=
 =?us-ascii?Q?XssCu68V02OgIzWAw6oq1uyR7NZTRlFZ+koXgdno+CqNrqBui/HJV0vXTB/o?=
 =?us-ascii?Q?dkbyMhHCMTQVSfhRjlYhP6IGZJNBTEp5FMfMAUT9xEBnlajaJdlgQkoAdUqf?=
 =?us-ascii?Q?xrFe0/0fLPOF4Fe1CYTb6wBpocZgR+Qpk17BzAqK/80zdJJ7h165k5pT5OWp?=
 =?us-ascii?Q?0SVJme2oC9vuT5WfceBFI+dyKluj/lKibbsxngvOT8k7u0KDisbjjIFc43q0?=
 =?us-ascii?Q?Jacln12F9VS7KcXIRTKN98fGB18mLUHh7Qiag5qxxjNHRmsNQKeh0suZSBQF?=
 =?us-ascii?Q?AifgCnPuT8pLouguhuA1YIUqgLY7sgfWz+xHxePrJ5wa8DqB0jFWcx2Ga/2m?=
 =?us-ascii?Q?4PCUvCmEPANaoYaKZbwlYjzMYGow6QfNAefGaFXWLZVWU7nmg/J80Ry3dt7N?=
 =?us-ascii?Q?cbAVRCnO2Oe2xsksBE3/fujCv8POT1WYq4p94JuhZCipBUXwar1I2Hlm82HD?=
 =?us-ascii?Q?KJ9iAnouXrIvrHzFz/rc2F66bWC3Aizueg7FSTd222bbq3Q+PtGYC2mJ/Y+1?=
 =?us-ascii?Q?ZypJW5UD6Kp8xH3WDbrijEWLQ4QWLzsA3v79JWolIl80tAzfPxXQ70xlC6nu?=
 =?us-ascii?Q?pXOiS+uWdAUeF0axffqItgyGwkeQLkTEM7bSgnTZtPJIyOk2uwpz5/BY8Aa1?=
 =?us-ascii?Q?jQzlcjc+xNU5I48WLlWOe1M=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3833377c-90ef-4faa-06c6-08d9dc9da9bc
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:19:56.8096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lvzqrYKdhY+awpNlmKYzgyOItVqMGXzUDIaolUFufaHpLEfnbnX2f5jrQIVqFsmN+y6w4limgn0qZdEduK7TOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1287
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210037
X-Proofpoint-ORIG-GUID: gk6cXxOwB44XQVCUPt4pdTtw_6ViRwrv
X-Proofpoint-GUID: gk6cXxOwB44XQVCUPt4pdTtw_6ViRwrv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit upgrades inodes to use 64-bit extent counters when they are read
from disk. Inodes are upgraded only when the filesystem instance has
XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag set.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 2200526bcee0..767189c7c887 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -253,6 +253,12 @@ xfs_inode_from_disk(
 	}
 	if (xfs_is_reflink_inode(ip))
 		xfs_ifork_init_cow(ip);
+
+	if ((from->di_version == 3) &&
+	     xfs_has_nrext64(ip->i_mount) &&
+	     !xfs_dinode_has_nrext64(from))
+		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+
 	return 0;
 
 out_destroy_data_fork:
-- 
2.30.2

