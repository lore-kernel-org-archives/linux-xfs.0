Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38386C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbjKGHIG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbjKGHIF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:08:05 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9DC11C
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:08:01 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72OMBr021377
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:08:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=LHYflDpEN0btakiKojmMMe9NTsjNlUmSe9C6hc0DdVM=;
 b=kUjGFGApv9TnsYefqDPgpYsuOPuY7XLvO+BAORE4s7ydJ+Bn6hCgFYaIq80BVVfdQurP
 /fcFHlwnzLOvO1m5b/bhNDqEQDl/nVUhdjRcMzRGNjM6rdWv2jUW5MLiqw66W5Q5qyO7
 qcarGsyV/BRMopF6gGPYt69S5VspHtrXEQAiPtFVn3DWW6vwL0Ng0bFd7r/GXA0WS6ds
 o7s66B29OIzCKuZCXmBiHPcHPvqtxQF/lxIOlkHGiZA2U6t3GjRa9npM/MqJ/Kn4vZqz
 mK00hL+MsJV+T6qK2j093PfqfXZfnRNUD286KgU0KC4d76Aac3Y0MpdDK+pQbA3AYSlo rA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5egvd8kq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:00 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A75BLrY038278
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:07:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdda3f6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:07:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WOO0kZb1tsW3VPjb7CBAU9bDM6b9vQrVcjCHELqQeWlvwxJU8NSRYhm6hogyVLbtAXbdmBm0Onr8neopMXy2BY6pW51/kLTSdk3sRygQDc/8gCQBelNPwMh9uZkvcq5RJ8HWvGha3wj5uhptxrnsTFOmxJmysOFYwtNm59UtgDs2tUOt7GDdIXQv7WJIZC890JGMpfK4EClzoos1fRGao1ZGiUU/Aa8SAj1DwticRprdS10oIYjgTRbx9+G+YjEcuiwH9A11L5xK4/TI5X8YCuSMYXcNizVmC16wMMB193AWapkLNz2nXfh5EuLHHv/MNUbP//F+H68IFc+55UBXpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LHYflDpEN0btakiKojmMMe9NTsjNlUmSe9C6hc0DdVM=;
 b=SylYmLAMYpDGaP2V7pMYmmT/nJvRzr2/AzuBHWyGpiOUFvI+ZW8Pk8hqTSdrBpG0VPFnqUf1xs18eEwOT7SXWndaWgVo1NqbYtwObFhyfRMBT8Q0ju6DZLDxNzNr1d8/1RKPxx+ZHCkA3RaXBVNALoa21QFt182xJ95hL20rXXzseY+Co8t422n4jrkP2JR9qYmQGOOdx1AZVJT3oMijggkr/5gOZOkG354SO1mXQbl9yzKT3zbUBbfJ6T5/b3sKC4aVwuc0TUs1HEXtIJbH5NLcX50/LWUGb1nqwXIiY3xWcfFTPriOgoiXG8nUIOA9Yx0Iz/X3pdBh0dKWiTA+mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LHYflDpEN0btakiKojmMMe9NTsjNlUmSe9C6hc0DdVM=;
 b=ibCxsICXZ+quIPEGBPK00wscp8mB5RYazYiCtlftz7CzHNhgKicZfzTrm64RaOB6Bg43zKAddozzYRlaE4rMGhp4b3Syci09I+ZTd++z9agctZItvSOyaQ33q0a9dIGHsztb78AK1jEt/bvzvoGzvIXlxvTtgyCecpl8CMixXag=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by IA1PR10MB7263.namprd10.prod.outlook.com (2603:10b6:208:3f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Tue, 7 Nov
 2023 07:07:56 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:07:56 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 05/21] metadump: Add initialization and release functions
Date:   Tue,  7 Nov 2023 12:37:06 +0530
Message-Id: <20231107070722.748636-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::18) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|IA1PR10MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: 14a4b3aa-fa95-4efa-c025-08dbdf60447d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aw+OTfCBQV8de4YDVM07DjT+KvZevEn+9E94kTmlzdEdRcsNMWn4+PhixB7ZeFTaddpOcYtoq5USfGjJ6bOoXLeuL2asBqnxxGRwpWMIOXsYysuzczroP3c9zR7Cks/Z9ZjnpgH3JLxUFrTeWfQdsAK8ET95DiaKKORLlSW9sPTMO2SM90QmYnC0OeQE9c0n3y+IvSuh2y5Hsyk/m111pzFxNfeEXuqc6JkixajtwvUXSXOS+CqilBD8YLqrJ2ia0FoHvgwn0yRabRepwMJmY6z4y/iuwXOxWT8bdsDdiCVuVA1wBw7ClUaw46YeKOtpoLDDDAkVbCMG209BpfBkAx8IaQAdJpDbZp+RxuAF+DRY6Vs1S3AinjMYTU1EXMO6XJ55KyIIZwtKpU1WNHClot7pSymkgqog3+tVMstSOTbAwKBCrRn19AXf5gazmklgr5dMiK4ekD26D6lqr4okBekNirNGg5d1d+9wLIctSQ4B4Ppbz8UlZzCGDvuza6PZc3gtGlgSusZ65fsgno3TjQBjEympatw0AZfDRXMmCJqJ9zcHRDp4OwigZFP7Hgm9CGUlENY938J7qm4IFiwJB0EeQ4G8bKys6yTm4d7uLldZuEwnVSFvZYfftswNFLiz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(396003)(366004)(136003)(230273577357003)(230173577357003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(26005)(1076003)(38100700002)(83380400001)(5660300002)(2616005)(6486002)(6506007)(6666004)(478600001)(6512007)(36756003)(316002)(6916009)(66946007)(66476007)(66556008)(8936002)(8676002)(86362001)(41300700001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SdgjGXij4Jnvk58MI/SCgwpE53HNyYDKXtTGo9SPTDWF0vYwckAXX9oLeRLk?=
 =?us-ascii?Q?FQiZmk54bruBGNNCP/uzK9F5n4vKQ/vAHkzrTd/dFqT7poWy2ToPvGDbBo2k?=
 =?us-ascii?Q?cYBoPMdfrLypUBO8zvyCwpK1VVzIWl74LZymW7SYH0Ga23E7XJ8SyjAKZ+aG?=
 =?us-ascii?Q?DAO4Pgvd7NLlpxcHSrClR76omSAfdH7V5C+iIYE4xMphy0wAkPY1Vl/GQaJo?=
 =?us-ascii?Q?cwUpVTiZJEGf8haEvou0IU8oRXcntfGPXfxcXTf2aPagTppF6YIKAByc03lq?=
 =?us-ascii?Q?pL5rVgrqsRsKw9A34xoP88EDq19PmuMnaqr+/IKiBw0+IRDd99KIJ6oTnSbL?=
 =?us-ascii?Q?8PRNfxlSBR9xIIjnkgTVrpPzyPX7ii/+LzZvheV8bJ4XB/a6jEAZcf3KyLY2?=
 =?us-ascii?Q?faLHBe2NzFGheef/Nrbmz8g9Z41SzSdVfNb8MkTVeo6lX/oH8RIz/FobA9rM?=
 =?us-ascii?Q?dp6Zz6rlB+ygHZr5J9vZz1Ogn133slC3RLo7LW5FQKrTZUOI2Pq60SnP4uRa?=
 =?us-ascii?Q?aH8dokSc5Bb+vD4exklT4Q4rK50J7mfY+tMXniPMDfP87IioceA15sJ3XhMy?=
 =?us-ascii?Q?zY+4HyBZpswjw+qm/E+Ba4UC+KQ6ueDNpLzautcysa0YPbNKdeMJv4p6C20m?=
 =?us-ascii?Q?/cupYn9HgyTxnz7FpH3DPzsF31/lBf4wv8SY+2oPRsMzWVl6DNdBALKeY8jp?=
 =?us-ascii?Q?4ij3UpXgc9JV0NgO/0NHlBEFB/kzlH60Ogh0GzBGLHLGD16FEvJg70c4eyie?=
 =?us-ascii?Q?+ZZCx+/+nRbnhoJR5PnbcMJMNucHdpPjltA0nTSDlWYyPfzH0XIEUf7m9egZ?=
 =?us-ascii?Q?QV+S/wm4yKNTZd7VaT87OQR0siZze4IuCnDV+C8e7GFP0a/3PScYHTgXOhdd?=
 =?us-ascii?Q?8J1cuL66Sa9SskDcGr25OPEpgXqOaYlzjXLI6RU2Ru48MItNEhseTWZXSAt/?=
 =?us-ascii?Q?kUKAFkmyBjy0AyWOmA4Ml+1GojyJmHlczqwTnmyK73fDxnrSoBYal+rNZmNl?=
 =?us-ascii?Q?wpVf4nw9zUfoUzLoWuthNiBuilD7LSUZsxpmwcvYSgTJfodgnuJR2QICtLjS?=
 =?us-ascii?Q?wygMvGEM5rKfhzF+mZt/kfb5zBLQ6yPLli83VK9arlXR0uoolhykRsMeHpAf?=
 =?us-ascii?Q?zJXjG+SN9nqsmiKAXCc2UB7nfAyX0FMERb3UmISmzKFd7TpiRPq2RRiHFDhs?=
 =?us-ascii?Q?JgqKdxtzgMf2mmvlorENHRV8MDT69G4+qYYXA//qGADw2R2kxiuxQzc1roNP?=
 =?us-ascii?Q?BE+q8OUbpHcROujDglv/w+BNiWFozUVahsEgEuXBh76deEr+5ueInrfdTKbL?=
 =?us-ascii?Q?GuYJoSbux5FXxzjBBfbaDnEz3F8l7hO4A1xq3KpOi7RYwwyXQ4sn5AzK+Xyg?=
 =?us-ascii?Q?9l9McPgqkI3VgPxk5ZEvKxruyA9Lw3jL/0fajj+lOYjBOb20HusxJwEYDZ+c?=
 =?us-ascii?Q?AV7Je/72kqAaAadVfQEjCllWE/L4m6Jz014EXRd5y0VQFRZtfyDBiwr98Qeg?=
 =?us-ascii?Q?1iI5NmC8My4y7F2mvL+Fud7Y3AAGs9mfXbn4zzhrW/hOBBhmlis7aKMsknM3?=
 =?us-ascii?Q?ns2VBJUk54sJI5wkg6mxpDxFo875S35g0dKdVxBmR3uUQX55eWicwbURMByq?=
 =?us-ascii?Q?TA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vvh5hOu5NM/J7IYBov+OMqae55kUBqlzpEzR/UoiQkT3GfzjTZ0/1jrL6wbN+2xR158IV3u2yUqCZfuZcUlFObAhFo2XGI1Ov4EFeLAhzA+dT5bRkcME6NEhO/nxeZpqKaDzy9/v1i3iAQEPAru2Gwb212P4Rew+h7PvPEyPN007ogsODm5feuKro/nrfu8ERKpMOyXTJIGzyT+CX8hlgsT3l6jLmbE25KIvrCtiFBuwGZD1RihaXBnCkPhPmcP7v56izOYqIFL/BBy/drnlj7d/kvvNxLOEVqIUleL3SBGkFPLS6UpsDshs19tBHD89zBLrxRixodgmoD/O+RgdS6XnxtOfltqh7CyODvEhGKuqjeXXVUa2BkyQVpQ/vrJAvyYYB1eVnhNOFyrtjKknGcCL4GKr+JH0CciAF5OE5Qqup3J3CIDMnsj5P1d4+1q0NhDx9yShJ7PBJDjj2WECubWbiuTFx0gjrPQW2odQ4n4UA1Lj86wLGCxM5/lFDZ7jFpp5y73nbv7/kBd0fSk9l+XR8L4Wb8H7I4iLVaOKoxIR7kQ3Z54km4GhFp0WhbVd+qjdbl44SpdqXLcAT2jwKE/cB7JAbS2XR1naMEmSiP9jWUYZ/usvohtC1Sfls907/2+s7rg0qo4HsjyeoS/4F0p4XsfV7hVOPOToOmKOfTZXpmJ1YzFe4/9VEagskP0wMvY+tAdBVWsn30WOxHhG28CcN6++4NTyhnOSvDS2F/9bxFZyi9qFqVQqtoktJEDmlRuiezJMBjzd4ENmJjvnWg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14a4b3aa-fa95-4efa-c025-08dbdf60447d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:07:56.4543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /TbX4BjOp+w/QsbiKQoV9zxx7gg2O1aqcDCKGHbgCCKXlD0h7z+KvmP10qTJD8LsYkKId2R9nbFNDl2astJVOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 mlxlogscore=861 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070057
X-Proofpoint-GUID: Bc_CzkukT77wIlJgrfcPSbKOGqol7Jul
X-Proofpoint-ORIG-GUID: Bc_CzkukT77wIlJgrfcPSbKOGqol7Jul
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move metadump initialization and release functionality into corresponding
functions. There are no functional changes made in this commit.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 88 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 52 insertions(+), 36 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index da91000c..8d921500 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2665,6 +2665,54 @@ done:
 	return !write_buf(iocur_top);
 }
 
+static int
+init_metadump(void)
+{
+	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
+	if (metadump.metablock == NULL) {
+		print_warning("memory allocation failure");
+		return -1;
+	}
+	metadump.metablock->mb_blocklog = BBSHIFT;
+	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
+
+	/* Set flags about state of metadump */
+	metadump.metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
+	if (metadump.obfuscate)
+		metadump.metablock->mb_info |= XFS_METADUMP_OBFUSCATED;
+	if (!metadump.zero_stale_data)
+		metadump.metablock->mb_info |= XFS_METADUMP_FULLBLOCKS;
+	if (metadump.dirty_log)
+		metadump.metablock->mb_info |= XFS_METADUMP_DIRTYLOG;
+
+	metadump.block_index = (__be64 *)((char *)metadump.metablock +
+				sizeof(xfs_metablock_t));
+	metadump.block_buffer = (char *)(metadump.metablock) + BBSIZE;
+	metadump.num_indices = (BBSIZE - sizeof(xfs_metablock_t)) / sizeof(__be64);
+
+	/*
+	 * A metadump block can hold at most num_indices of BBSIZE sectors;
+	 * do not try to dump a filesystem with a sector size which does not
+	 * fit within num_indices (i.e. within a single metablock).
+	 */
+	if (mp->m_sb.sb_sectsize > metadump.num_indices * BBSIZE) {
+		print_warning("Cannot dump filesystem with sector size %u",
+			      mp->m_sb.sb_sectsize);
+		free(metadump.metablock);
+		return -1;
+	}
+
+	metadump.cur_index = 0;
+
+	return 0;
+}
+
+static void
+release_metadump(void)
+{
+	free(metadump.metablock);
+}
+
 static int
 metadump_f(
 	int 		argc,
@@ -2757,48 +2805,16 @@ metadump_f(
 		pop_cur();
 	}
 
-	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
-	if (metadump.metablock == NULL) {
-		print_warning("memory allocation failure");
-		return -1;
-	}
-	metadump.metablock->mb_blocklog = BBSHIFT;
-	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
-
-	/* Set flags about state of metadump */
-	metadump.metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
-	if (metadump.obfuscate)
-		metadump.metablock->mb_info |= XFS_METADUMP_OBFUSCATED;
-	if (!metadump.zero_stale_data)
-		metadump.metablock->mb_info |= XFS_METADUMP_FULLBLOCKS;
-	if (metadump.dirty_log)
-		metadump.metablock->mb_info |= XFS_METADUMP_DIRTYLOG;
-
-	metadump.block_index = (__be64 *)((char *)metadump.metablock +
-					sizeof(xfs_metablock_t));
-	metadump.block_buffer = (char *)metadump.metablock + BBSIZE;
-	metadump.num_indices = (BBSIZE - sizeof(xfs_metablock_t)) /
-		sizeof(__be64);
-
-	/*
-	 * A metadump block can hold at most num_indices of BBSIZE sectors;
-	 * do not try to dump a filesystem with a sector size which does not
-	 * fit within num_indices (i.e. within a single metablock).
-	 */
-	if (mp->m_sb.sb_sectsize > metadump.num_indices * BBSIZE) {
-		print_warning("Cannot dump filesystem with sector size %u",
-			      mp->m_sb.sb_sectsize);
-		free(metadump.metablock);
+	ret = init_metadump();
+	if (ret)
 		return 0;
-	}
 
 	start_iocur_sp = iocur_sp;
 
 	if (strcmp(argv[optind], "-") == 0) {
 		if (isatty(fileno(stdout))) {
 			print_warning("cannot write to a terminal");
-			free(metadump.metablock);
-			return 0;
+			goto out;
 		}
 		/*
 		 * Redirect stdout to stderr for the duration of the
@@ -2875,7 +2891,7 @@ metadump_f(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 out:
-	free(metadump.metablock);
+	release_metadump();
 
 	return 0;
 }
-- 
2.39.1

