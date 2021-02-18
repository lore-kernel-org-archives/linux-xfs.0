Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E0CFC43381
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55AFB64EB4
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbhBRSp4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:45:56 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60396 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbhBRQrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:01 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUTS1059536
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Pwi8W5JQ/VXAEsCu8s+pt6HfHMOKFOFm+RgPQLKMLL4=;
 b=MJr5En3v9Ec/AkjgfoDe33e6Uw3OR/V2eMrtUQzlkVHeU5t9jtWROqsGguLS77NXuUz2
 sS9+/4nOluyrigIeO1uwRoPvGArbBp6eRt8wvDsZvz7HxerkHMFSewWi0y/Jwt1m3C9h
 gE7t/MoadmB59Rg+opA6GJBJsgswSTGZ+vHETFkBu7dxK4GqKTBO/96UuEHrk7JdM+Io
 uxVSNmDlFh3NwB+ZCi8l/ypkdiYL8VzaJn9PsyUYTZzUxXDgq8444SKR6m0zmFuCfjbJ
 Z01zySVmAsqaRIvbcYDarKR3643CUNozRohGLMM8vb7Nv9hv6EJrbNFac8YPmj2FSRd+ dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36p49bersj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUSZR114925
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3030.oracle.com with ESMTP id 36prbqyww9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F7/wG4kKBwJlnOtBxRmXqg2yrawqIH2/vncjK+YNStAigFzrr8ePqqHhQR/iChlj2wVcCEdniwdMsNla6EVQ+aFwl6mfR5YqCJ91DRgUSU6Dqd0P2vpds+3tVNqlYKewW2sarnj2xkTyfp7/yApJtDB91sIrAY/wnh18/mSPRPHCc+6n57y9zypyqglTghG/vMJYuTEdY1Kx2LGfanl/E2moZjw7P8PrxnGLkU/hlyKbQM1ySJDYTWGJYZxMZBmfxtjytwCt3ZzmpbvtfIB9IkRgFvDvDq8j+G6qJquladZoStwg+CoutbTsBqrMFwXZmgd48LVGcNOJRwPHXE3wUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pwi8W5JQ/VXAEsCu8s+pt6HfHMOKFOFm+RgPQLKMLL4=;
 b=CzPJmVsBrNNZT+SGxOA9mIdWUXN478OmyPUxU3dOx41TjpbEeufcBvccYEJiFD3rUxxRlsO4A9Dz/mpX08DgQ6cSG9QOsyPr7RBmelQ6BpkDlpifGtK4A8E+J+4QLOGBw9SQYinAc9CfPZkHZ1Yr6/HM1XsiCIoJcjcLTPrIPybgxtTuamYHbFfl3rX9wYyThWLKS4DQQNU3kq+A4v+Y/32IIvAyMfNQIDKWhrLUw+uTEJQazeanNI2Z4f1G/bSCnEG7NdoZ+2KY57EXiq5ycW/b1NXX8gffHNsGfg1VpBt5q3xJYn9gvlvVWRd7sqTtUcS76yfoYCZ5/VLIG+5xLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pwi8W5JQ/VXAEsCu8s+pt6HfHMOKFOFm+RgPQLKMLL4=;
 b=pB/9jG0wCsIVBhmQgb3QTWFHXVp5v2AMv7TSPvlkOKQo2lEffo2llve19hT6Wr1+7l5hmhRBaqXE5P3Gdlf0PG0/tQCYHkSPtQw4r0RDb4VLG4pUOWYcIB69yCTd9xQF4tlWNlkNCY0Cx6UsGz7+IBWRhXAJxqrcR3BTDYiZLmo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4495.namprd10.prod.outlook.com (2603:10b6:a03:2d6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:45:33 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:33 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 06/37] xfsprogs: Check for extent overflow when removing dir entries
Date:   Thu, 18 Feb 2021 09:44:41 -0700
Message-Id: <20210218164512.4659-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a14a1a27-49f8-431b-f6eb-08d8d42c9bb5
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4495:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44950A81CAD58F2466C128D395859@SJ0PR10MB4495.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WlDWvtxN85t/z3PM9u/ptb7tJQqnp6iPoWAs5CQMyu/fYOzxh3YFFj0a3u90b0uPM0YSy1m6+DbxqF7TRr/GJG9IkugpqRjtrIzV2vtnlbu1PMN5wc3dgGF5ruSuL5p3zcunqRwo54EJWaPTWecq8oThrqba8Yq2Q7pwPT8dCeuG+/DSBRWLIFwKTMir4/yN5kJ7T/udmdoRC7N3rAMHd8tWhGFCH2bST8zbwnJRul52oNaPTac6aNKYpEPe478FavcrEzC89TcDatZNAeJL4LsbE0nb7buSX905fuP+z9l1y4QF/RXy7NnlwpHHuJaj7oX2iWzc/6foD0r4EFLjVbx0UmbPKlyblXZbOkMHaUOwelXzuhh2yKcnKsAuZqo99vnx8rOgcxDEITnhAbwiK5Lu+fR1RMwLx/ODCjmFbm2VrcpHXuiE/mSK74LyNHG7UjRotl7D8aDp48BmFD7xSgNXd/6BocuKWjKQs89KnoOnaoHYMWElRl01TFesBExI17K15uXo6Tbtn7FaO8g9LYfxpVkyWt5z8+IXVcslsLGabj16dJ4Y/mhJyq6IEG2vqZIZxQbxNmI0+8f9Dvg7Mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(346002)(396003)(136003)(478600001)(86362001)(6506007)(44832011)(2616005)(956004)(83380400001)(16526019)(52116002)(26005)(6916009)(186003)(2906002)(6486002)(8676002)(6666004)(316002)(6512007)(1076003)(36756003)(8936002)(5660300002)(69590400012)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?j+ueJ6j28znGakJXpJR03Nc2J5r8w+EWHrw5ap490wobQp9xu6OXdz5x+vgb?=
 =?us-ascii?Q?WgKcnFE0VLWiK0hCtDJonqekMc/bjSVoeh21hRokg8o3I9f4XcVASphCOu2j?=
 =?us-ascii?Q?6lK0j1REREm5T3Pj7wCRFFihygHnHrZZVLF7YBvWBES27XpiCKx7CGfoeXgh?=
 =?us-ascii?Q?6x6n/AuCVwbROF0gQRHXueIlwo1zhdIJUAg7DhA3ixOa7ck4uvw37th6+POn?=
 =?us-ascii?Q?DPHhcDlcbD+FHfyqH8vRrLsfraMgHdwSAGIoINgTNmLBYtSngEGsdK0ZZCs/?=
 =?us-ascii?Q?2JDbC5USO9ZKkGizULJpCpea7bUTsw2v4Aj1S3bBbM/QNzB3pnhCndGuurh7?=
 =?us-ascii?Q?oTfk0tPH8jBLlPDmGoVxIjp9riQ1rYxkKztgjncDbOUMWwpRZPqG5YUYRE3c?=
 =?us-ascii?Q?sL6+Ddyal5xkpY4yfS/APaflu+k1axl930ClMInzRKSweOTXotDGMzUK06ko?=
 =?us-ascii?Q?LrkE6qXT+3+wYa6OkMtZohqsmQ7DageadmnpmFO+zelcP/01GZHZTadRCvLK?=
 =?us-ascii?Q?3F7V3zFujZzh72EGj680VlVlIY1zdG4ox5HWQ+0yZogZAO58WY3cZVYZWQHk?=
 =?us-ascii?Q?K4nT8wfdxnCtgiQo4fJlwC9v7UP3G2NMaxXz7tCe/BdtpkULQnubfK4Ljhmm?=
 =?us-ascii?Q?5kOqXQEMyFnQA1hUzCBuYMZMcVobI+bSr94X31UA29PZ4mi4HRbqqP6gsVwU?=
 =?us-ascii?Q?/DapPqxoncFjA8h2M1FakkBcbN3VkTuUc6lP91NXAzkIm6Bh10UP7d9Spi7J?=
 =?us-ascii?Q?PRy3hZQcfBkJ/izcgHgLqjN/tvy6ZfK50LfTgaERU1/E+mXqqikA3/XuTiK0?=
 =?us-ascii?Q?Jm+dqBSk8DWQ8ptAGW87Y+BtLaCrUkYCISBZCWg8FYz09W0IKPHXFX4RWGJ2?=
 =?us-ascii?Q?LAsnTpMvxuuaXdL8omk0oUL+XpxZi+UspDVfhwY6XW8qvz8OSgEgX/UXzc0b?=
 =?us-ascii?Q?R1C3RPpf4091StAm2HLMvZoMtl8qWHmScVXFEBCFCcZWLAlefs5lzF22nSk7?=
 =?us-ascii?Q?F8OIMbeb6EU2XlPqaRsVVoRKoxq5FyssE0zQDF1a0DQcAmM7ZM/2cmgawN8c?=
 =?us-ascii?Q?6rspXJDctT8YSJsclJ0TeUSgPSVXyGma3PAj3fMtUdYzkabvuFMs0U0O2Zoi?=
 =?us-ascii?Q?hOoPk7CByqKQBrFxpy3x365sRMJxu5CbxqBQn5fzcXDRxT3zw8raXeaHAyx8?=
 =?us-ascii?Q?J2CQPgyxucu1SGDxVC+FcFZbrT5BeerRP7TydpLNNIWaB60B2gv4PbyPVfKl?=
 =?us-ascii?Q?3/6ZIpzuHrmZWswlgMfLS0+bqVzi+J+6IqFmB9pYA4+tSz9OCn/ax7BO4gAs?=
 =?us-ascii?Q?Jia1dNV7TWQbhRECCNgYab/L?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a14a1a27-49f8-431b-f6eb-08d8d42c9bb5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:33.0810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YibSoX9vt701wrM0ZCpaS2/8XEKL6FD0oKm8oFjXxWZWORzctNRog1smrKFzGKX77Fw4WMAPQi47+5qX0TZZpAm/M3yctzjtCVdWNICY7eQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4495
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: 0dbc5cb1a91cc8c44b1c75429f5b9351837114fd

Directory entry removal must always succeed; Hence XFS does the
following during low disk space scenario:
1. Data/Free blocks linger until a future remove operation.
2. Dabtree blocks would be swapped with the last block in the leaf space
and then the new last block will be unmapped.

This facility is reused during low inode extent count scenario i.e. this
that the above mentioned behaviour is exercised causing no change to the
directory's extent count.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_bmap.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 336c6d6..e3c6b0b 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5144,6 +5144,24 @@ xfs_bmap_del_extent_real(
 		/*
 		 * Deleting the middle of the extent.
 		 */
+
+		/*
+		 * For directories, -ENOSPC is returned since a directory entry
+		 * remove operation must not fail due to low extent count
+		 * availability. -ENOSPC will be handled by higher layers of XFS
+		 * by letting the corresponding empty Data/Free blocks to linger
+		 * until a future remove operation. Dabtree blocks would be
+		 * swapped with the last block in the leaf space and then the
+		 * new last block will be unmapped.
+		 */
+		error = xfs_iext_count_may_overflow(ip, whichfork, 1);
+		if (error) {
+			ASSERT(S_ISDIR(VFS_I(ip)->i_mode) &&
+				whichfork == XFS_DATA_FORK);
+			error = -ENOSPC;
+			goto done;
+		}
+
 		old = got;
 
 		got.br_blockcount = del->br_startoff - got.br_startoff;
-- 
2.7.4

