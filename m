Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A44C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB02D61185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbhIPKI5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:08:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:62878 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236175AbhIPKIv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:08:51 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xk6u012704;
        Thu, 16 Sep 2021 10:07:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=+eKbjNfecgfE6lE5U6NJp/4EAkQ61Sp09t4UGZzCwzA=;
 b=alBinjOTxJEKBfi8b6qtQk5UOgMRi1SLF97aGOlR5GyWnqYXnrbVogtD5oIi4ZQU/0hs
 TImcfr5JN6d3WlJHUvF+pD0dzw2rjtF2j5ypg7GHU2g45JDPDxyoz40VBbJmHuGS0RnG
 PRIEBsFoeUPiGD8cUcBnCaQypXexXxnFtezVnP/iBETDTwa27Zm6m8lfIXfEVHNLAsn3
 3r3SUmJRNezsRXfUawqck/upm6mpLtc/nJtMkx6TAzvHlIPygmzJapYdZGpAFiMBNuGj
 XhC2lD9lMYu2KxXo0vjTjkU+qDJIRgEtUWMR+wMDK2TJ372AYVNCf8QcjC8IdAhayzUe ig== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=+eKbjNfecgfE6lE5U6NJp/4EAkQ61Sp09t4UGZzCwzA=;
 b=PLTLaZCE+T9u3ZR0DZR3tqgO5YWVkA93wTB9GoHEgFsOhJceWyGR8CcE5rqG+R1IqwDG
 0JUOw3h1X8VlPAAG/+Rv0Xr/Pacyb0VpUA5J5ZQrXh1LZ4BgXqb+3h35byfMv3zcl+C7
 S86telK75tld9kg8yGOQ55Fuq1Et/qjSrHFcUmlXtwhPqS+zT9X/KhHYb9+MQLRGVbPG
 rsLxZHi0qXF6pwZfCkoWZ2RpdDPBnvj+fpv1PEzxh8OrGIp7otXwwkvh3qJqde30CkDx
 wCDTyK/IL4GxSZOonDbg8pxVJxcrrYmSKHFC4/PnleT5dXx4DH7Zoj3Pzt2rq+vmhkFY FQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3s74hgk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA6cIW160382;
        Thu, 16 Sep 2021 10:07:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3030.oracle.com with ESMTP id 3b0jgfv4cs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LHF29aRzY5Wn0/k2xpZxQQpV7FHzPDA2dJa3dFzxn2oU/7o4sJgDAQbqDhvw7cyq//LeriCccccuUgovc6FpWhvr3ObVkL3qZlgu9asjsNb9wTyHIA3SloyRynAsbCjUYbFDfmCpU7bDh1UA/hGjukijoLQqjBW3gI8q7ywJ6o63C3sczr+9CscKVu3+RCuuP+T7ruzEPah7pszkU6hPFA4foThJ7N3mRpc2c9jkOnuctw6g8e7xCohq/UcmG6w+wQLvfoMGoiAQ11Xaor8Bvp7E2CHONlpGihIAMJXeCwOMzJ1WbHo6zRRkX/xDfOpVSVE55uZQtAtFx6iBibrzpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+eKbjNfecgfE6lE5U6NJp/4EAkQ61Sp09t4UGZzCwzA=;
 b=AxgxMFMTmiEqwr/NR5f26Fj6mKa1RXf9vSAUJw4VkLhZgwbKSkOsHVtLqBdZvESqkLhru3JX0qidb0GacInTFAosSPY1EtG1pVRLNuS0O2guDZhttp5jVJMWZxLbultMI5SteiJC8pXmz3wJKmVKIyzusBkUDvZ3/V3JA5N3wJO4JIlvVLtOUbtw1TF8dC+yURwkQYgQ6YA7gi9YYddZmuJZxQZDiE/0K2FRKELjmDOo92cznJ6lAvJH4hlxTfy1Jvg//e4ersQT4JPHDhjf2Lw4JQWs7aJg7Zw5OAeWy5EGXdKFbwNU2Ct99Cpm9NCbCfD+jtXgwN03M/vcFYnRzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+eKbjNfecgfE6lE5U6NJp/4EAkQ61Sp09t4UGZzCwzA=;
 b=mshJVMr51SKFZnnSBp11qRynI5S7pnB2dPaRwpBvMh8PZn2lBK4rwVwohcdr+oEdVwP6zS2gvQvISYzqT1R14i/SSHJe3K9dY23dKNxIPVSgeIvz+8xfdOtpgxqOITVlOqSus9QOJy3lvqM0fzxAcgwzYz6QCt2mQoFJji/5S6o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2878.namprd10.prod.outlook.com (2603:10b6:805:d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 16 Sep
 2021 10:07:25 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:07:25 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 05/12] xfs: Introduce xfs_dfork_nextents() helper
Date:   Thu, 16 Sep 2021 15:36:40 +0530
Message-Id: <20210916100647.176018-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100647.176018-1-chandan.babu@oracle.com>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::11) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:07:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 558971f4-a977-450f-c7ec-08d978f9c798
X-MS-TrafficTypeDiagnostic: SN6PR10MB2878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB28782A3883E8D5C691C2E24AF6DC9@SN6PR10MB2878.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yZu7SOKXCNwGeZmls+y6EN3t8Erxd35EtYf8HkMJOVLgH4UhGbsLcEOt765GPy4MiIo4IxEVrErv1GTRqgL72fCRTExf6EiNOHirQ5jr9bi4vf1dixJq+WE054EoYw/dNyQ/pyuF/CTWLq5KE0zs76YoZoRlIv97xyxrgu0H7+K4NzXVIbb6tUM/oqBJW8tzpzQm06VTrfeTME0uH+qi3xywa9NQyYMcOqdkvBadLdJO7XpzLw5Cc6F4F1JHbqEGOODAbnM50VAfsJNAa3Ctoy5SgaCzU5dyz67zw9FTf5e1W5f3HqFe95DMCL/LN1hLeGfVRTSsHPKvPTIARIAejR+eUO4T95eVVXFb4GMaAv5HOc6yOYznt2C4C/5+d/k4R2Z0p0pXJV4h0EnE8X7vj3asJXkC7PLkRLVNovIYJ6o36ckRjYNpwvisAwqnHpnBHAVOQRF6wsWZWErhkgR1esqJhhFRgXt6MKLze57dDWJ9eV0yefYbB3UB8WMWkUf6PaFMwyWEOUeQq5Z/+zIc4JDf5hfAQCra1Q8V2mnkMrw1KNOrLUeuViYQlEx+zSg1FqendSncqcSSvvdzwa2lglSXrIVvyCE2AjWpjh9/BPqCkN6vvADRto7QN/5h2dXb1j92MgdWILcLiUC5uaAaQ1nDgyW58kZhj7BLsGa2kLEj9MZqvaYGk3sDY89qSYL+rARzjhKCeeVm0TkV84ygdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(478600001)(5660300002)(186003)(66946007)(86362001)(66476007)(66556008)(38100700002)(2616005)(83380400001)(6512007)(8676002)(956004)(4326008)(26005)(6916009)(52116002)(38350700002)(6666004)(6506007)(1076003)(36756003)(8936002)(6486002)(30864003)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/4tGcOwmt5jiXSRI8Qzo3/3PpeSyIbk4NTKr3uLTnED+zLB4/2bcJyUSxu5c?=
 =?us-ascii?Q?xanfZ0bV+qJFbGn98xaAtVa7YIuK+My8CwMzjw+mdY+zu+cttnoEV0+Dob4b?=
 =?us-ascii?Q?6l/mdh36hW1qvHjjsWml/yy0zjLkQMDf+2OnoUbPpfr2fSHvnQo9vjq+YeTp?=
 =?us-ascii?Q?T9yhNVrR957mYpIPry9Lqqfqfw2bv5NHuoMOOnC8bF7S1ULdpZk0Nv7QnNKh?=
 =?us-ascii?Q?oG3UbrOUYncmjV35BtqFqhd6OJjQ+BHXRcyEuIBIB+8wJrOL8B8zy5xpQE+b?=
 =?us-ascii?Q?Pv3jWJPyGXicwm0aNaeInExQbx+IBDRWkeMhsIljoQ0z7M+j9H/m5H4rSKcc?=
 =?us-ascii?Q?5EJ8cMzKaTUfhC13/wjxzhAWjfrjTIwTcZcO4t7kPEnHmaVeDT+ief406AV+?=
 =?us-ascii?Q?Rn+4W8P8vBYxSbmO4EEGJO7Jk2OvsUY3TjROApZo6K3MQ/BNjqdcMIrySNlR?=
 =?us-ascii?Q?lRP/AZZqI12v9FjM3Almyd6TTcUkoAbCQrcmeFBbSK6CQ8Wr+a0/X14dOalS?=
 =?us-ascii?Q?6/M/oXQ8USEvWT0ywh7a3PAUSRfQli29ehap8L/c8RI5+CmjMbm0gmNryBEu?=
 =?us-ascii?Q?IdXlyTSTKKhUi93hcl1d6fBD3EBx+RCadJC85xHABnBaO2xTKdu9pJbTPc/c?=
 =?us-ascii?Q?iWPdws7Kw4+9VI1OQ56ry0KVB05moT6TlxNkCNdWoooWUdSlRzGN2WWodU3R?=
 =?us-ascii?Q?klfYBRjq/c706YcnCH9QbgJyvzAVwDV5xXU1rRVcKHc1vcqRWI8UDS2WhEOj?=
 =?us-ascii?Q?zl22oar7zLoQ6tdlETjwCCWe1hMXCD4z3nhwdf1Uhr1hdpgbeap9G2nAjVWt?=
 =?us-ascii?Q?DbxGP3GnidMwZYVPIycq2eZ3nMDyzW6i8GgoR1NXtH38ApaC+wU4JxW1Eewk?=
 =?us-ascii?Q?BQH5UbMQgC1U1ALTZ8aR5nOf2DD/BHZg54oP7USL9hwuDJa6jVCdbq7q4DGH?=
 =?us-ascii?Q?g7ulo/U9kElM6eHaCZz52OVn7zIci3A12u7zSIuNa6ayXZXWIfnPUYOPnHN7?=
 =?us-ascii?Q?1L7bH6BjUyzVcyYqRpO7+TBD2jiBSuXx0JVzzw/4nR1XbxAUMrP59EvS8lWc?=
 =?us-ascii?Q?2lkGz+SSEmMSuwmaAOdxdbFJadgxS8qIrtGovs5rQyUvWHXOvnavyWQiX/un?=
 =?us-ascii?Q?dw5fC4Qy/dbUDGabSJIH2gatn30t4o8wf6mqzThiasgz3WqV3feQKCXlhrsJ?=
 =?us-ascii?Q?JYNqVhfzMfhk4tngHstNlI3K1DneeK92gUy6LHLeBh2GetBDOnk7b+dal3iO?=
 =?us-ascii?Q?KdSRKe5UV16+IqqoccNz6FWqKl4SNu3jiu6c+QFlcV/1SaTgdStwNQUU+j7j?=
 =?us-ascii?Q?JcOjRN9N3qBy9gdE6IHaAe58?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 558971f4-a977-450f-c7ec-08d978f9c798
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:07:25.2929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FykcTZ9Z6GqWMuLRc/yoZP26ZoYlOZD97RZ1cOYrnLZsgd16vtjDR4bgQiza14Oy+AuMvWugKBXjocZuC7lK/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2878
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109160064
X-Proofpoint-ORIG-GUID: eeXOXKYSGai0XKkbLUVg_wZYPWx1xJ_I
X-Proofpoint-GUID: eeXOXKYSGai0XKkbLUVg_wZYPWx1xJ_I
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper function
xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents() returns the same
value as XFS_DFORK_NEXTENTS(). A future commit which extends inode's extent
counter fields will add more logic to this helper.

This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
with calls to xfs_dfork_nextents().

No functional changes have been made.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h     | 28 +++++++++++++++++++++----
 fs/xfs/libxfs/xfs_inode_buf.c  | 16 +++++++++-----
 fs/xfs/libxfs/xfs_inode_fork.c | 10 +++++----
 fs/xfs/scrub/inode.c           | 18 +++++++++-------
 fs/xfs/scrub/inode_repair.c    | 38 +++++++++++++++++++++-------------
 5 files changed, 75 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index ed8a5354bcbf..b4638052801f 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -930,10 +930,30 @@ enum xfs_dinode_fmt {
 	((w) == XFS_DATA_FORK ? \
 		(dip)->di_format : \
 		(dip)->di_aformat)
-#define XFS_DFORK_NEXTENTS(dip,w) \
-	((w) == XFS_DATA_FORK ? \
-		be32_to_cpu((dip)->di_nextents) : \
-		be16_to_cpu((dip)->di_anextents))
+
+static inline xfs_extnum_t
+xfs_dfork_nextents(
+	struct xfs_dinode	*dip,
+	int			whichfork)
+{
+	xfs_extnum_t		nextents = 0;
+
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		nextents = be32_to_cpu(dip->di_nextents);
+		break;
+
+	case XFS_ATTR_FORK:
+		nextents = be16_to_cpu(dip->di_anextents);
+		break;
+
+	default:
+		ASSERT(0);
+		break;
+	}
+
+	return nextents;
+}
 
 /*
  * For block and character special files the 32bit dev_t is stored at the
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index ea4469b5114e..176c98798aa4 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -342,9 +342,11 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents;
 	xfs_extnum_t		max_extents;
 
+	di_nextents = xfs_dfork_nextents(dip, whichfork);
+
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
 		/*
@@ -474,6 +476,8 @@ xfs_dinode_verify(
 	uint16_t		flags;
 	uint64_t		flags2;
 	uint64_t		di_size;
+	xfs_extnum_t            nextents;
+	xfs_rfsblock_t		nblocks;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return __this_address;
@@ -504,10 +508,12 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	nextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
+	nextents += xfs_dfork_nextents(dip, XFS_ATTR_FORK);
+	nblocks = be64_to_cpu(dip->di_nblocks);
+
 	/* Fork checks carried over from xfs_iformat_fork */
-	if (mode &&
-	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
-			be64_to_cpu(dip->di_nblocks))
+	if (mode && nextents > nblocks)
 		return __this_address;
 
 	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
@@ -564,7 +570,7 @@ xfs_dinode_verify(
 		default:
 			return __this_address;
 		}
-		if (dip->di_anextents)
+		if (xfs_dfork_nextents(dip, XFS_ATTR_FORK))
 			return __this_address;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index e7bb3ba22912..7d1efccfea59 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -107,7 +107,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
@@ -234,7 +234,7 @@ xfs_iformat_data_fork(
 	 * depend on it.
 	 */
 	ip->i_df.if_format = dip->di_format;
-	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
+	ip->i_df.if_nextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -301,14 +301,16 @@ xfs_iformat_attr_fork(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*dip)
 {
+	xfs_extnum_t		naextents;
 	int			error = 0;
 
+	naextents = xfs_dfork_nextents(dip, XFS_ATTR_FORK);
+
 	/*
 	 * Initialize the extent count early, as the per-format routines may
 	 * depend on it.
 	 */
-	ip->i_afp = xfs_ifork_alloc(dip->di_aformat,
-				be16_to_cpu(dip->di_anextents));
+	ip->i_afp = xfs_ifork_alloc(dip->di_aformat, naextents);
 
 	switch (ip->i_afp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 87925761e174..4177b85c941d 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -233,6 +233,7 @@ xchk_dinode(
 	unsigned long long	isize;
 	uint64_t		flags2;
 	xfs_extnum_t		nextents;
+	xfs_extnum_t		naextents;
 	prid_t			prid;
 	uint16_t		flags;
 	uint16_t		mode;
@@ -391,7 +392,7 @@ xchk_dinode(
 	xchk_inode_extsize(sc, dip, ino, mode, flags);
 
 	/* di_nextents */
-	nextents = be32_to_cpu(dip->di_nextents);
+	nextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
 	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
 	switch (dip->di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
@@ -408,10 +409,12 @@ xchk_dinode(
 		break;
 	}
 
+	naextents = xfs_dfork_nextents(dip, XFS_ATTR_FORK);
+
 	/* di_forkoff */
 	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
 		xchk_ino_set_corrupt(sc, ino);
-	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
+	if (naextents != 0 && dip->di_forkoff == 0)
 		xchk_ino_set_corrupt(sc, ino);
 	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
 		xchk_ino_set_corrupt(sc, ino);
@@ -423,19 +426,18 @@ xchk_dinode(
 		xchk_ino_set_corrupt(sc, ino);
 
 	/* di_anextents */
-	nextents = be16_to_cpu(dip->di_anextents);
 	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
 	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
-		if (nextents > fork_recs)
+		if (naextents > fork_recs)
 			xchk_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		if (nextents <= fork_recs)
+		if (naextents <= fork_recs)
 			xchk_ino_set_corrupt(sc, ino);
 		break;
 	default:
-		if (nextents != 0)
+		if (naextents != 0)
 			xchk_ino_set_corrupt(sc, ino);
 	}
 
@@ -513,14 +515,14 @@ xchk_inode_xref_bmap(
 			&nextents, &count);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents < be32_to_cpu(dip->di_nextents))
+	if (nextents < xfs_dfork_nextents(dip, XFS_DATA_FORK))
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
 			&nextents, &acount);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents != be16_to_cpu(dip->di_anextents))
+	if (nextents != xfs_dfork_nextents(dip, XFS_ATTR_FORK))
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	/* Check nblocks against the inode. */
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index bebc1fd33667..ec8360b3b13b 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -606,7 +606,7 @@ xrep_dinode_bad_extents_fork(
 	xfs_extnum_t		nex;
 	int			fork_size;
 
-	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	nex = xfs_dfork_nextents(dip, whichfork);
 	fork_size = nex * sizeof(struct xfs_bmbt_rec);
 	if (fork_size < 0 || fork_size > dfork_size)
 		return true;
@@ -640,7 +640,7 @@ xrep_dinode_bad_btree_fork(
 	int			nrecs;
 	int			level;
 
-	if (XFS_DFORK_NEXTENTS(dip, whichfork) <=
+	if (xfs_dfork_nextents(dip, whichfork) <=
 			dfork_size / sizeof(struct xfs_bmbt_rec))
 		return true;
 
@@ -835,12 +835,16 @@ xrep_dinode_ensure_forkoff(
 	struct xrep_dinode_stats	*dis)
 {
 	struct xfs_bmdr_block		*bmdr;
+	xfs_extnum_t			anextents, dnextents;
 	size_t				bmdr_minsz = xfs_bmdr_space_calc(1);
 	unsigned int			lit_sz = XFS_LITINO(sc->mp);
 	unsigned int			afork_min, dfork_min;
 
 	trace_xrep_dinode_ensure_forkoff(sc, dip);
 
+	dnextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
+	anextents = xfs_dfork_nextents(dip, XFS_ATTR_FORK);
+
 	/*
 	 * Before calling this function, xrep_dinode_core ensured that both
 	 * forks actually fit inside their respective literal areas.  If this
@@ -861,15 +865,14 @@ xrep_dinode_ensure_forkoff(
 		afork_min = XFS_DFORK_SIZE(dip, sc->mp, XFS_ATTR_FORK);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
-		if (dip->di_anextents) {
+		if (anextents) {
 			/*
 			 * We must maintain sufficient space to hold the entire
 			 * extent map array in the data fork.  Note that we
 			 * previously zapped the fork if it had no chance of
 			 * fitting in the inode.
 			 */
-			afork_min = sizeof(struct xfs_bmbt_rec) *
-						be16_to_cpu(dip->di_anextents);
+			afork_min = sizeof(struct xfs_bmbt_rec) * anextents;
 		} else if (dis->attr_extents > 0) {
 			/*
 			 * The attr fork thinks it has zero extents, but we
@@ -912,15 +915,14 @@ xrep_dinode_ensure_forkoff(
 		dfork_min = be64_to_cpu(dip->di_size);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
-		if (dip->di_nextents) {
+		if (dnextents) {
 			/*
 			 * We must maintain sufficient space to hold the entire
 			 * extent map array in the data fork.  Note that we
 			 * previously zapped the fork if it had no chance of
 			 * fitting in the inode.
 			 */
-			dfork_min = sizeof(struct xfs_bmbt_rec) *
-						be32_to_cpu(dip->di_nextents);
+			dfork_min = sizeof(struct xfs_bmbt_rec) * dnextents;
 		} else if (dis->data_extents > 0 || dis->rt_extents > 0) {
 			/*
 			 * The data fork thinks it has zero extents, but we
@@ -960,7 +962,7 @@ xrep_dinode_ensure_forkoff(
 	 * recovery fork, move the attr fork up.
 	 */
 	if (dip->di_format == XFS_DINODE_FMT_EXTENTS &&
-	    dip->di_nextents == 0 &&
+	    dnextents == 0 &&
 	    (dis->data_extents > 0 || dis->rt_extents > 0) &&
 	    bmdr_minsz > XFS_DFORK_DSIZE(dip, sc->mp)) {
 		if (bmdr_minsz + afork_min > lit_sz) {
@@ -986,7 +988,7 @@ xrep_dinode_ensure_forkoff(
 	 * recovery fork, move the attr fork down.
 	 */
 	if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
-	    dip->di_anextents == 0 &&
+	    anextents == 0 &&
 	    dis->attr_extents > 0 &&
 	    bmdr_minsz > XFS_DFORK_ASIZE(dip, sc->mp)) {
 		if (dip->di_format == XFS_DINODE_FMT_BTREE) {
@@ -1023,6 +1025,9 @@ xrep_dinode_zap_forks(
 	struct xfs_dinode		*dip,
 	struct xrep_dinode_stats	*dis)
 {
+	xfs_rfsblock_t			nblocks;
+	xfs_extnum_t			nextents;
+	xfs_extnum_t			naextents;
 	uint16_t			mode;
 	bool				zap_datafork = false;
 	bool				zap_attrfork = false;
@@ -1032,12 +1037,17 @@ xrep_dinode_zap_forks(
 	mode = be16_to_cpu(dip->di_mode);
 
 	/* Inode counters don't make sense? */
-	if (be32_to_cpu(dip->di_nextents) > be64_to_cpu(dip->di_nblocks))
+	nblocks = be64_to_cpu(dip->di_nblocks);
+
+	nextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
+	if (nextents > nblocks)
 		zap_datafork = true;
-	if (be16_to_cpu(dip->di_anextents) > be64_to_cpu(dip->di_nblocks))
+
+	naextents = xfs_dfork_nextents(dip, XFS_ATTR_FORK);
+	if (naextents > nblocks)
 		zap_attrfork = true;
-	if (be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
-			be64_to_cpu(dip->di_nblocks))
+
+	if (nextents + naextents > nblocks)
 		zap_datafork = zap_attrfork = true;
 
 	if (!zap_datafork)
-- 
2.30.2

