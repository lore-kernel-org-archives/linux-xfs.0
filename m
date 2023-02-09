Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2744FC05027
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBIIC1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjBIICU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:20 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6942CFE4
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:19 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197PjsL011365
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=/hWCYAx1t6DfdQn5Xdy+zxzq9asIGmH4jM4dOZNlpP0=;
 b=Iy+tBVU/JFGpu7JPLJUo7EKwtfbRX7FZoFROO6JLO5P8qtLumGCmTps5YIG4dQndgnjp
 vepQ/OebzlCHYRNk2hIBwL0Msn/uOmN4aAei83e13nOuJPkLGOv4EwnSA/qibwnldeeb
 K/hC9AMswngz8Vwli+vNe81kYxBBa6TGDWnyRHWhxEVSsA/WWD/lSVr2kgsJCJA11iJr
 +vRkltnFTzFxierDYEzcazNXc2SWoOieZTTg0j0YXPba/IhOcd2TZlJ/aT8F4CFSTn5U
 PIANxk1XIRe5aLvwfqhNja9TxbuR1LHVOJLWg3Oct8o4Y3xz1gCmLE+bR3g1U8ScObsN EA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy1a76a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196eBvJ021294
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt8dv71-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CyklEXgu0PXpP1EDF4HcEtqpFIQKbUsSYcG8+dAGbwWLqlfXzAyotf02MUrli7LKIIEkn35csMPqik5kOjHsDZCdAZMz2m9561khPp03QXecVJCADA5tSnJeeOah6fz+93ziFa3IpRY7BIAufAtogTtjde+EaF7cVtQalanW1XSL29LGbWGIyYYgynPCsErCEN0CjsPwSTdwr3sdZNISYpLbi3VxE3yWcEtQgc/7RQy8kOnyzXjlGZy7l6gHNzvg0rdl2BmfJ6lnq5rmfdTNo+kEQr5FYKZKuHkt6+n60Z9AN0MyeWdugv3c0nPoHHuTnHH3XPdy9WcXbwbyVW264w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/hWCYAx1t6DfdQn5Xdy+zxzq9asIGmH4jM4dOZNlpP0=;
 b=aXGXAV6KXRE7DX6nEsvrIzLYvU8AA59GidDOt7JuoNcZ6Kq2NvE7lgnywDA0yZ4YnHE/1ipwJN/X4WXLmhUwCsZ34gbH800VNrvj+kdn6L9WYJLcc+LmwCD8wVPv8fLeVPm7ieNFt1SN9lwNNHAe0jF4snBiCGGZMizcEow6xzhRzZnDhT0F82QaFWMIuRWsy55ZGn9ABdBCpxYURCKk2r2DfDcKvPP17lRfLscCq9Hib8wzju6eoRCcHhQ/AJDNFD1dvE8q/7hr9fUHAm9oc3g9VYPK9sEAomPcrds4ULeZoCdjGz/Hqus4clhECNnSth4E9rSIw2xRTKuv0TrmtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/hWCYAx1t6DfdQn5Xdy+zxzq9asIGmH4jM4dOZNlpP0=;
 b=qsRSjfDMR/VYoMQlr0StV/kzNgusrG7a8nNbtLkLozFE++ZTCx6DnkVHCF5cdWVOpyRfcFOkhUV6v9NNizlzhv/9GVMJWfEICKB8+rrdV+YmatiJgiAI9XG95xWzhVfiC4aAI+CSh5woPN5qHEyfEs3bQ3PC9Fe68vU1w9ZQCa0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:02:16 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:16 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 16/28] xfs: add parent attributes to link
Date:   Thu,  9 Feb 2023 01:01:34 -0700
Message-Id: <20230209080146.378973-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:254::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 249ffa53-16af-41e9-9161-08db0a73f5cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o0tzxrQOoXhnr3uK7wDlqo48dX5gK83m+s+bobe4l26Borsdx3ruVitC7Kc4w9Z1wsN1Zcmm9VAt0FGP1TFmI+f/wValsfYFf4Y23wq5N5MLq+foQcyo9d1bZLsYbszaAxqwaOrH7AqY/mZtPLhk/EtG2LCJ/UwHXpUcaiKE4KvM9M4u4q3pX6g9vBxyGvvv34Zl+WUF7APIx81CDFyNAPkmZFrCaEsmYiw23SXEIuB57ctCyAyLWuARHRPMyzfq+mVgxo8bEXNMOO42NyCY4daDOmMGs+dG0DOhLqVSNoW9zZXl7uHFoIoaWr57ONuZWN+MF6984Z2yRonwhRNE3dVA61ATbW6fLP9MuGnu9kWuvIHVlVOgkKS/HCK36vMck+a1iQKQjMmxXxmO04f0j+5hUo3Oqiauis/d+5Xeg02iv+DbDHSKz8BmU4RA5q+qXn/slJiqhrh3EBBdG3ONh9raQqOXOchVEIVSK4QHeYSgjBBGu5ic0A4YaaBa9bJmXnEFBMPxdPE2SGgYMW8Jxv5hO9KUhAljEvepOfR7fSNMMZ24F0OPMoLx4zrvct0wrHdaUtRXyGH5zln5OlKJyo9HjDf8PR9FlL2t27iyvvn/uhtoQfjbR+RBpBwpRJWX+9MnlJ2PU4At8spQ3xdUBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CUEEZ3FUjebS3ODKOv5EiQp1A1VHnCNYE7DsonSsxtNvjCdHaZ0YLezrgzqq?=
 =?us-ascii?Q?nMRi7/egpeuxu5CR59SBRYXc4mi2eHPjloM2LMKCjbixk2hntY0AfWoBuNDC?=
 =?us-ascii?Q?uIqIhGZKPD+Sd6gNM7akAEAFloiUSm6wP23F1/wHz1Pq3UNU9s1wYjovoh0A?=
 =?us-ascii?Q?2QmZRW7ZmUMcz+GXV4gskw3Rr1Y8WtcTY+rEq7fnsmFZYqHeWdQWf1iYYlvl?=
 =?us-ascii?Q?X/vMJLrOY7BtZux0uw/GioRU7TcnFmhqo3a1ueuxqv3tHLiozxMCxjUxiTp9?=
 =?us-ascii?Q?8G8OYeU1o2Dfn2UTjwnXOT0hmkuzBdcxnHrFm6yws2PJZMzp/2JMYVT6m9ZE?=
 =?us-ascii?Q?j0YSyELphYF6emEMmNEmsvLzqTk+oI10p0j0aP6JQxkM33LssG22P5OyJc+y?=
 =?us-ascii?Q?6Si7oxtTSRNJqmYXFu5Cb5udn9kMTyR0pGr+R+iD5kymGasF08eCir41JktT?=
 =?us-ascii?Q?wQtLzP3iEsypfsu+R5BrRXQ9Ak4MF2L++L1uug9buQQ7uTsz3sUQG4kcrUlK?=
 =?us-ascii?Q?LNNXh1AmgNpaNU+dWQurWjxfVJoVWEig1OuuKoBLqXGi+vmH9cbMe1l6QggP?=
 =?us-ascii?Q?B9AQG4+po3FVB0WviOv2decQhdTLF/6sNYF83e2A1KML9pU3sxSXDoY8Ns5I?=
 =?us-ascii?Q?fO5LEWLTRGNEcZqdDXpxZl1oroSNBlgI+J1yUgLVwpzcIXgORWv2EbkTIhjz?=
 =?us-ascii?Q?WTXX3FSCYNfMdGy4UUplur/rPtXX9ig9LMCfNPoFIV3CvIyYNZehLUKzvngs?=
 =?us-ascii?Q?wthyepRXcOFCRNCwZvs5i8v66KiZETD6nxgmV4sd7QKGGheMW10qFaKYMrJT?=
 =?us-ascii?Q?XZPse3VYXv/VfrqTESqcEM4P9cv2Lu8yOhplt0II94GjCRwwITLu5LaocQxS?=
 =?us-ascii?Q?hnfNhWKk8FYIgmzA1MjosaEh6KS/UCQDJYlr7wOU+oU8wHY8OL2sgpkQYX9F?=
 =?us-ascii?Q?U1SF+x2J9YJSBDgt+3gRcEt+opcpGIx36SA2JbfepWL0ajgUmdEpYc720nu/?=
 =?us-ascii?Q?nQWxP2oIx+ZW6T6OPudecapXDQDvQqswcnuzNvGyo2O6UNx13/qQYfwuDYju?=
 =?us-ascii?Q?DJT88oddn4swpWJ0tLqm3bxp2EBhhbvK5zAzWdWZfAxBvZv4lmDYCLUM3SWf?=
 =?us-ascii?Q?ZWZy1aYA8Sa4pJSYGZAZI2Vb/0jdHbc2UGyjbNMIYqgqmTdlcbhAFAkDrBqB?=
 =?us-ascii?Q?z+4sZH5J5v9oDaA7oPqy8O51YQcknVUcxxGHvsm3qVWlgCIShQ3M2RrjleUj?=
 =?us-ascii?Q?0AL5pIKVJqBDIIglJnUt/mkmm731WCyjlpY2a3EmAdDdgrOhC0Wk+G0c6jdC?=
 =?us-ascii?Q?rWwD/mp1Jfa28+mJIac6bSzJsid/WFnGO3nNwBKjenYTQqlF6v2FZr+BKj8/?=
 =?us-ascii?Q?QyQGPDDvEjSrYZcAmGKMZo0UPPacX9GTM8gEW3iha2+pmdXrSu5H138hSUUJ?=
 =?us-ascii?Q?A+uyXgRJ05b0oobe9brY/nF2W8y0GpkvA3rm6U4xVXa3jQkeu/JxW8WTWT4w?=
 =?us-ascii?Q?8aXAVj29emy5++yEZOg7DMszo0tyhyceWZDrcpFU+vi2aUu/mY4O7Cx10uvs?=
 =?us-ascii?Q?NwCUCB9VWa/KIoi4OWfQ3rURBoFC7VmXJ/7R7cBawWmJ7Bdvt2JyNndIOBU/?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: edbK9/QXyJ9/Cmm+8ijwHujbR98+NsOI9ZbyyqD1lqRtNJ7OC+j6lIddKXRearfm+d1Xk4rKLzeaiRXZBfNaJbmAkzRxPB1gEQN0ytHsG9lLvAnUyb3xSmM6AaPmHZctqv49xZz1EtaPgdQwXvKKWhbqVZ2E4Zsfqz/2VhZvBOg4PgGNMmO3dcMOOBZasMhm3CUSArl3zXKoacAHOoyFMOTQGfXXZZNMmDmMPS0G69Rd+IErdu8NfsY9HESWD9Txf5QQOjR094a1vbH3P1x9oM4x85fj5IyCIUuMsWceTWcAuJp5bABzmGS9E/XXFEs+xmCGRe8ljkHO0vmUy3dQzLNHD+QXV9SACk68IbR9mwKDMb7O3dXUMTwNijmNc0lLjNoBfb2ildAK17GpSu3C2YzVDTV8MKmhaJueg1kmp4jRHnYTF+MXfCtWT2MmutXHyzgcPHale5r7G4YZm7PJuJ4kaKowoZlpvX/JXe/jQ/exXcEaNUMqtQBkOI/5Yc83RCFEkC57nNUI0nvWMHoIggmTDeSxw0R5agP1z4Bjm64SXRBa41Kmy/Zjl/P/vWd70d7l0VzDMSe07dcQgKGB0Jd9pzhBbwaIaeg2Tno70IEjm5Nb04DlnjlxoBq3+832V1DkPXzQxgnwZ5LGqgW7gqvAHj2GmBBU9V2zf5s6e/IBqBQBAFPd3/YXWZOrzYdFpRDoIG3dXIr6oYvrn3bVlSVj2FbtpL0gPIvGhmUZJWkrmvcWA5/GRPLil4XNvAE7
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 249ffa53-16af-41e9-9161-08db0a73f5cb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:16.6363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5EktTAbzIB1gb5A+Othy4/FFrtWH9FPBj0lbuMcIdqJ7JHdZH2/6+OXH9JDA6nPqjW9dE1IoayfE0KPmfcb5ch0oIuE9O+yfWFpNTjJrBao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-GUID: IDYIaXsAc9AWCuN7C0XrM5Uhycmw6VTe
X-Proofpoint-ORIG-GUID: IDYIaXsAc9AWCuN7C0XrM5Uhycmw6VTe
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_link to add a parent pointer to the inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_space.h |  2 --
 fs/xfs/xfs_inode.c              | 60 +++++++++++++++++++++++++++++----
 2 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 87b31c69a773..f72207923ec2 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -84,8 +84,6 @@
 	(2 * (mp)->m_alloc_maxlevels)
 #define	XFS_GROWFSRT_SPACE_RES(mp,b)	\
 	((b) + XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK))
-#define	XFS_LINK_SPACE_RES(mp,nl)	\
-	XFS_DIRENTER_SPACE_RES(mp,nl)
 #define	XFS_MKDIR_SPACE_RES(mp,nl)	\
 	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define	XFS_QM_DQALLOC_SPACE_RES(mp)	\
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ba488310ea9c..b4318df03b5c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1247,16 +1247,32 @@ xfs_create_tmpfile(
 	return error;
 }
 
+static unsigned int
+xfs_link_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret;
+
+	ret = XFS_DIRENTER_SPACE_RES(mp, namelen);
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
 int
 xfs_link(
-	xfs_inode_t		*tdp,
-	xfs_inode_t		*sip,
+	struct xfs_inode	*tdp,
+	struct xfs_inode	*sip,
 	struct xfs_name		*target_name)
 {
-	xfs_mount_t		*mp = tdp->i_mount;
-	xfs_trans_t		*tp;
+	struct xfs_mount	*mp = tdp->i_mount;
+	struct xfs_trans	*tp;
 	int			error, nospace_error = 0;
 	int			resblks;
+	xfs_dir2_dataptr_t	diroffset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_link(tdp, target_name);
 
@@ -1273,11 +1289,25 @@ xfs_link(
 	if (error)
 		goto std_return;
 
-	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
+	error = xfs_parent_start(mp, &parent);
+	if (error)
+		goto std_return;
+
+	resblks = xfs_link_space_res(mp, target_name->len);
 	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
 			&tp, &nospace_error);
 	if (error)
-		goto std_return;
+		goto out_parent;
+
+	/*
+	 * We don't allow reservationless or quotaless hardlinking when parent
+	 * pointers are enabled because we can't back out if the xattrs must
+	 * grow.
+	 */
+	if (parent && nospace_error) {
+		error = nospace_error;
+		goto error_return;
+	}
 
 	/*
 	 * If we are using project inheritance, we only allow hard link
@@ -1310,7 +1340,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks, NULL);
+				   resblks, &diroffset);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -1318,6 +1348,19 @@ xfs_link(
 
 	xfs_bumplink(tp, sip);
 
+	/*
+	 * If we have parent pointers, we now need to add the parent record to
+	 * the attribute fork of the inode. If this is the initial parent
+	 * attribute, we need to create it correctly, otherwise we can just add
+	 * the parent to the inode.
+	 */
+	if (parent) {
+		error = xfs_parent_defer_add(tp, parent, tdp, target_name,
+					     diroffset, sip);
+		if (error)
+			goto error_return;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * link transaction goes to disk before returning to
@@ -1329,12 +1372,15 @@ xfs_link(
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, parent);
 	return error;
 
  error_return:
 	xfs_trans_cancel(tp);
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+ out_parent:
+	xfs_parent_finish(mp, parent);
  std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
-- 
2.25.1

