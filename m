Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED68C3DA7B
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiLRKDc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiLRKD3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:29 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BB455A8
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:27 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI4pQni021611
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=O88cT0U2Qrx+GbX6YnlzcfyhNWca/HKq0gKxoNasJDU=;
 b=hu/FsMYRd3pYuMHX7pSKxJ3SiWqYpPeWzgB0dwjgzW/3dWx+OFhJ/tVEWfzs3w7uTJMn
 nyrM4JP1IBqNS0Tw+cf4B7mI2F4WhxFeKo14tROFCm450de6kLGFtIvl2rOvJ+Q03lyp
 Zc9jJKNJHo37lVqxWc3M0ds63tffinOefL6TNx/lD4aHFXihtUp1ZWb9IWUeVMQnv2+a
 Uo8Nrj9277Lt82RdJtjFv4CpgLP2rJZWSBN6ochIWeT1El42wo6UYxKK/pHnWbw9LATZ
 fAnGiCChOarYkq+r5/ntX49N4+340LUdGUbnEziktbzveGw6wxGJMQR+mqA7zFwNifZL Jg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tqs95t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI7UHic007458
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh479cbn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iyUCPmMtyEnjvwwMg2O9565nRSV8Qbz93a8/MgGZ4/I3zi/cLXgVjXPyedK+3A7tP5eigH1EgJXI3bX8NPtEJW5AKvVpk40Eld3xr22J00HzV2PeEVxNHr2qblcWg9x/dPu1+pLtupK24tzoM0onsM3dIVHpM6e4KrNgimxorjR/VNUNkpx8eT973dDEvuNa2LjG4i3/1nrmFPLWeIRPKPF/OQQnIVj2Joe0M4sIDCll8ezRlMxDrhIKx7A0mifkFIl5gc6aqpT1ebsCfLKkGxQS14pEhFFGR8uBfp933aRkoF7+IIie0Sok6J/cb5Qxg0T1B6u6cNpL9VSag+KQwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O88cT0U2Qrx+GbX6YnlzcfyhNWca/HKq0gKxoNasJDU=;
 b=VITGUeCaYMWCdOh5jebigcJwRF3djG3pH86xbkuve2GGT5nzFJmpbRD+4Jg+mRCcd2M4ZLj9tnF9nUpmhDEz8HVJnBa1czhpiLIHiRXRxD30w8e4T4uqU28I8FlL3ulrHkIgzulCgCtNKk9FTO5lr2z8A3XPo3Fal4CogIzNE1LlwTCkZG7D1hIPC8uxG57I1Kbagok8u2VLovL3egIlfZhuX807sGjIsXURxJ/IhD91xFv1EsAufOSlZFuXRzO/uHCbRaqs4Rd0cm8O05X2ovZedXGyQsBC/wrBR9wvqT6IdbLAEqVlcKeS0lO/MPvcGfKmTP6lxjs6olCcjJ+9Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O88cT0U2Qrx+GbX6YnlzcfyhNWca/HKq0gKxoNasJDU=;
 b=r4iwEEo61nq7Oj9AQRLtgzfDq2MtPWh/HmyoYDV112ASeicmXfbxDUm/pG8xRdtBF2L8MXfuuRKE/ZS2UwTsTgbouJV/4gh7nlsz8uaTowjuvEjxsXRamJwH8ft5Cstr3wmLSMVFhM5QnB8in/SZzaJNR0dGOWFd8rxWSECCpDw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:24 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 10/27] xfs: get directory offset when replacing a directory name
Date:   Sun, 18 Dec 2022 03:02:49 -0700
Message-Id: <20221218100306.76408-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0049.prod.exchangelabs.com (2603:10b6:a03:94::26)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e4a8194-8f38-4395-13bd-08dae0df198e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XqXXLle7AD+766t5rjA12FlAi33TP1EnlpI7Ta+/D7R28QK2lU2/3LyAlrg5w1iu6ZGD0Y8h/3bbgwuR2/oHWb0otljhj/szsOK6EYqMZ9mgHDeCaubzoF7FdA43nyHgX0iPAg0w37iHJD/P4A10D3yvdORBX/CqRG5/IFuuQFNF6iR4yu5r0ZQM+bip4EHIrjbQmYljiStXiahDutWEH6qMyuDm96BPoz0lxYBRP7/3W0fH2rRE9KV4P3nI/2fBlGW0lTH24bejj4jxjkUqMIs5ZZnuS5ENRSj/ogrZAgrCgjNU3uDTn6oK372nMiI2BoC+wKBV9pT8UTnHOyR/AxtXUlikumIDPqa7aQcZzJ9OLUWW1JkcKN+IPU7FWwon608DGs1k3p10XJy1G3ZMRnKRrwJ2JIS/N7KfV/AqrgRYMivjmY4+WgZYlMMx37f7muFEBPdaG0uwKZfA4tvsJpIeUfcWIiejt0NGMtuWGp7XSvQuA2k0e3yRo4Zbva6mlgmGYMnBmqCeYOt1nm+yne1PowW80Mi2ygRkWNP8+5fmpKO0cwLKLKAysSiIMFhB3ZsMApUC1Ua7aQ8hhdMRT1mzzObHA8E2MN8dTlfMAFa/09k3nyVQsfOCTzlbE7hM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y2GxlVAWUPsyQRh3CxJgc5/hmfAJ0ZVjiIIE3tczpdvkW2yG+wEDkoDNezLo?=
 =?us-ascii?Q?oR/XGc1gstWkutB46skKNKOkiF6SbV6mI9I0qHCpXc8TgvxVwgcPLAKwg3CI?=
 =?us-ascii?Q?P5h2qbqFHpPwvnUHWAKdRiwX5vPjG40ocv4fDyHcmL/WQNjyLDHz8yS7d9qy?=
 =?us-ascii?Q?Gjm+vZ+QoDThnXIAubq+Qn199EJXBZz8OmdPnvxCpW1Hj0LnD200gT0OYcX+?=
 =?us-ascii?Q?zjUbNcNr6+gpAwDCcmV6ejbVyyq5SlgrjJ1iYtGVPjuKDLqkd02nsTc8b9Bp?=
 =?us-ascii?Q?68Vu6awF4qIK7L/jEijNZgqtrlofnkQ+V+KQIRJoV+YH+TTfJidRHKu8VUu5?=
 =?us-ascii?Q?y0UeVgvhPI2Cs7LpOFjFX4tFEioyJUWr1GUU2FHNgqk4VeWiT3x+corXFGkD?=
 =?us-ascii?Q?DunghvQLpGk0imWDrP0q34Hfi/JEIVxWmJuIUeXFBboqcdO2Seyz8KKiCoq6?=
 =?us-ascii?Q?Kg8KFY13oFaOnEHj4sfgwRYQXJdDVVZLPqGSX2WyIwd3kSsDfTKVAlRCQELj?=
 =?us-ascii?Q?W3KciTTWBeeH9YrYDo/Xpo271SyZXGv+IbRIUl9NCJmjQdhAJvTF8tRpW2II?=
 =?us-ascii?Q?WrauFCC1v3sDR4R0S6T2fY8xQZBLPi6Fi8cKufqgpc03xqegqDuWXzqYN2AH?=
 =?us-ascii?Q?+5nkWuNhZd9LONRbyRDP/65sVA2DKVyJXJF8xdPmTxjU37HdLfZuFmDWQ1TP?=
 =?us-ascii?Q?u9PPQD7PA6dqwa/kXzrbwvdI78P2X3hstnX725zGKZHP391gqOjkZOydjaxL?=
 =?us-ascii?Q?49BlNdWtSZTFDmgPesNd4L7qKyOHg7IbatMpdv8On651p1EuJQIVrXCnFd/h?=
 =?us-ascii?Q?F7bhvQmGaDyOAKQBxTXtgGznXoMAmzEaUvM80YP69qe5szFGI7aoWggPGysI?=
 =?us-ascii?Q?+m6qJe5/P2tg+Na/dO9Lgfnlb5kas34uLJEflBn0Qh0PKGQjWRLif5cwEm9+?=
 =?us-ascii?Q?+T801tgjr90VppESZjqhIA9uqrqUyDmMZHAxwMGu6IlFSmF1lxz2mo4IfcI1?=
 =?us-ascii?Q?DwGKncPDythSwyxXhV4ZawGN58Z+rMZA03WiRNN3UfeB0btJ59ajIz4YuF0r?=
 =?us-ascii?Q?hJSgaZGxs/Y3okdFCDHzbUmY15SfSegfXgYr9SAdWcpRuneFCzcjVf/X9fwa?=
 =?us-ascii?Q?yNjysBQh5MU+ajKZEp10yrDDDBwDjI6UdqcV7yemu1PhHcZJba5f3MAeT6tz?=
 =?us-ascii?Q?rb83+t9ZONSgUYF3pYcNsGDEdfWLZBMnTm9OvacSVb7UV8Cmte9oRYPqzvCw?=
 =?us-ascii?Q?VFR8cYFf06nbXzPD/6t4j4OocEvVcPJXv+fNQpfbCGHhDprHo/Mhz6pKfoTl?=
 =?us-ascii?Q?rRJlyOVmreaTWR2T11AUCuE08TVkzgWFpKHHEEDLTnumynSVeTI/RTbset6f?=
 =?us-ascii?Q?sW0Ko00jaUd39TTg/ZXuZBVi1E1hZm8Tk1pCr8SBjlnf7imW/4wkBLmVcVNs?=
 =?us-ascii?Q?siX7GsLiwSrKN51/L1RfvxdyNVYGMwbIHw+jN/o05lYwySXdmpfZ99BARsfT?=
 =?us-ascii?Q?LvzX5gzLboLs0nvnvgaxiSLCrEWldGTCxOmeByccj/J4Fhc74SAO5TvUPl5X?=
 =?us-ascii?Q?ve4v3cLkNwCQOpBWmxBp8ji8aMhQwOmOPuOWVbljlstjvJ63vtdio+CUPmmP?=
 =?us-ascii?Q?Gg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e4a8194-8f38-4395-13bd-08dae0df198e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:23.8353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rHjO6aBN3/pEMthCdrUL19cXQ8lQI8RtJNYG215MxkU73S91Yfr33uZJwN3/0KhGDWGU+i0rzMgKi23dDq7mAjmi3SvQivSXp4jucju7bAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=950 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212180095
X-Proofpoint-GUID: aPZDAMaaZPSLpDBBj7bcVcCekoZQrbqv
X-Proofpoint-ORIG-GUID: aPZDAMaaZPSLpDBBj7bcVcCekoZQrbqv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when replacing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_rename.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c       |  8 ++++++--
 fs/xfs/libxfs/xfs_dir2.h       |  2 +-
 fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_node.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_sf.c    |  2 ++
 fs/xfs/xfs_inode.c             | 16 ++++++++--------
 7 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 891c1f701f53..c1a9394d7478 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -482,7 +482,7 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
-	if (offset)
+	if (!rval && offset)
 		*offset = args->offset;
 
 	kmem_free(args);
@@ -498,7 +498,8 @@ xfs_dir_replace(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t		inum,		/* new inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -546,6 +547,9 @@ xfs_dir_replace(
 	else
 		rval = xfs_dir2_node_replace(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 0c2d7c0af78f..ff59f009d1fd 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -50,7 +50,7 @@ extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index d36f3f1491da..0f3a03e87278 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -885,9 +885,9 @@ xfs_dir2_block_replace(
 	/*
 	 * Point to the data entry we need to change.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
 	/*
 	 * Change the inode number to the new value.
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index b4a066259d97..fe75ffadace9 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1523,6 +1523,7 @@ xfs_dir2_leaf_replace(
 	/*
 	 * Point to the data entry.
 	 */
+	args->offset = be32_to_cpu(lep->address);
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->b_addr +
 	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 39cbdeafa0f6..53cd0d5d94f7 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -2242,6 +2242,7 @@ xfs_dir2_node_replace(
 		hdr = state->extrablk.bp->b_addr;
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+		args->offset = be32_to_cpu(leafhdr.ents[blk->index].address);
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(args->geo,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index b49578a547b3..032c65804610 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1107,6 +1107,8 @@ xfs_dir2_sf_replace(
 				xfs_dir2_sf_put_ino(mp, sfp, sfep,
 						args->inumber);
 				xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+				args->offset = xfs_dir2_byte_to_dataptr(
+						  xfs_dir2_sf_get_offset(sfep));
 				break;
 			}
 		}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6877266f6d7a..f65085645942 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2489,7 +2489,7 @@ xfs_remove(
 		 */
 		if (dp->i_ino != tp->t_mountp->m_sb.sb_rootino) {
 			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
-					tp->t_mountp->m_sb.sb_rootino, 0);
+					tp->t_mountp->m_sb.sb_rootino, 0, NULL);
 			if (error)
 				goto out_trans_cancel;
 		}
@@ -2644,12 +2644,12 @@ xfs_cross_rename(
 	int		dp2_flags = 0;
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
@@ -2663,7 +2663,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
 			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, spaceres);
+						dp1->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -2687,7 +2687,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
 			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, spaceres);
+						dp2->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -3021,7 +3021,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres);
+					src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3055,7 +3055,7 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres);
+					target_dp->i_ino, spaceres, NULL);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_trans_cancel;
@@ -3094,7 +3094,7 @@ xfs_rename(
 	 */
 	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres);
+					spaceres, NULL);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
 					   spaceres, NULL);
-- 
2.25.1

