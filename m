Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78EE7C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbjKGHIa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbjKGHI3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:08:29 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3556BFC
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:08:27 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72O5wJ014497
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:08:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=I5o91/g7roOyr9+XK0T/OumcpM6f4JRfXcBVBgZT7j4=;
 b=UXHMv748MjZ/DvsoA/LRHAnmC755DOPKe8TNNDdAVjdwYXk8+qLepeEyknuOqT3mNheS
 adJOFxdfGEL2TiKpEzB63R9qtcqNKILsKZNtSPsNij8ATSwts+x98pcE23+EEtbrqfti
 /ZIycR9+6q8RL7KI7K/SJK+vJGTr8z97Jw92DYmtzp846zagqzTeZ1XmtzyDGR2bTTrp
 j79E7HrmNgOvq2tbYBgFMq/AmohVHhCn//MfMOZ9B8jtCyADK/WHMPBTsdSpGiWZSSop
 gyEA9TogqNlgE+oF0fXd839h0ouU+lzY1R8XCrfoypQTL8D4kMjleeNkJn+vA8EL9tMz sQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5dub576t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:26 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A76hKAQ023587
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:08:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd63cd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eTCWcuo1AswiZu2Bcs1+xh9wMcPUF6BDNPhaRMNAocjOiH792qgwpzBN5uL2vQxpGTzBd3zpk5CDvmOdyvcLV9fOYWOaau1FA3l1cacNmRIcumcd5pAYeriWcJstXOkYv7/kz6ivZ4NyK4UG/efYn2XEahEWMv/SeA2YtUXLRU8XgD/Wstzws7c0qgcjp1ELmUcEa99lbz5Exd6eK7ATYmLWRh/P3spgOlzowbdoaXdCoy53KQZLL+2+BcApj+mvn44vw8zthadIzUfQDplcldLxHQAIeWTguVP71q1CFUMPbKpj2WRI6B0B3l5QnjFWDV5HxpDy5R2PnLZ3F/AO9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I5o91/g7roOyr9+XK0T/OumcpM6f4JRfXcBVBgZT7j4=;
 b=n5BAug+HStjQeMAnbH5v3o3akK3YvVQcuWnRvob/06Ofpoy3bZqFOlCeQyH/AvQBsUhjDmV9X/i+Mxmyjo14jW7XsjHOFgv1MJG+lE7FU3QtWxRMZSJJuiqi89yt/9r4DN+4AYgvIfSjJTIzctuk5S7bLAkr47DLCOPZLh8yD5P3wtU8NHE+mhgPQfugp+oseCWdFFaxl8fWzQhvkRI0JaQP8Vy+QijKyfuhtjHmTmtkVre1W7Suh5aiMrJeh/r8ayerdSv14qV/JR3k0VDKZQPRaYa3hEmM9Dk1MfjC7lPW2NFL5S770ZYRym0PQG0ZPf23lvIORo8CtN1s9dGKHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I5o91/g7roOyr9+XK0T/OumcpM6f4JRfXcBVBgZT7j4=;
 b=yTZ6WmmZf4O8kjxt8l4qa29DZ3xwOBwKeRFqdrFy+HSA9w/LdLuw1ylaNNtHMmM1MHsDaiHMU61m0hD8i/uAxqHbX6H0/HeMdlRF54dNJfsgLkitzyBuP8LozOJLDoiRSxetK8tATOEN9QOgN3WmiWxZ7sWQhus8FjNy0DD4Sb4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by CO1PR10MB4770.namprd10.prod.outlook.com (2603:10b6:303:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Tue, 7 Nov
 2023 07:08:18 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:08:18 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 09/21] metadump: Rename XFS_MD_MAGIC to XFS_MD_MAGIC_V1
Date:   Tue,  7 Nov 2023 12:37:10 +0530
Message-Id: <20231107070722.748636-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0025.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::12) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4770:EE_
X-MS-Office365-Filtering-Correlation-Id: 243da1f6-f5cb-418e-8f3f-08dbdf605155
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VU3DFAegh7Gge4aU2EkqNvI9n+A3KHvOvESG5XDK58z2NR+PvEci6PW0VNJXNo6j25ItNnVeSFhZHrVs8wDoBaWIlOO58C6DSP1XIdJarEw38n1R99hMXWOPSQYd0Y3dtGf0SNYlT+nvtHpQr3BCWdgM6jMSnrMvtBZXT+NWx4rZ83Z4l4ZaTzQ/G4FfCy7T++E3vrsm7miw8Jak4cuFy6jJ8+XFRS9VjeiMc4+8Lr6G7RQBFUzhH5wlyPOZc3B9EhB1582KsxeaYOf+GNM4/POQLXzPDXCTY6lL2cnw+UciLyfNnAhyTYFok7VAznVCeCYmQTsnVdLItjIzXZmt+JRbW7gQHxEkmBg9MWY3JvQEY4pKJRaLKsS5hI9f1LITuFF6NczdAI7bKHkCDw56zYamlGMWSyxR5cjC87tXAMaQex9lax7Hr1deSzlupBdgamDfJG/R67pdrK472ZfXN1SIovppuc8GPSNVWi0FEfhPe9BV1s4qyvPAHTU8GscwIRRUBY85jSr3SYEUHxlMdhpTFxcVLRRdfujWJqKoHS2wQBGDFS/Ih1i7BBly4Jil
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(366004)(376002)(136003)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(6486002)(478600001)(6666004)(66946007)(66556008)(66476007)(6916009)(316002)(26005)(1076003)(2616005)(6506007)(6512007)(8676002)(8936002)(5660300002)(2906002)(41300700001)(36756003)(86362001)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YtzpLOo7c7ZWUOeJMegsjFN+lmy1n1pZKL0ngrDOqOakJATrAP09fCPrDYxf?=
 =?us-ascii?Q?EfmCFeI9PVw5phOucNmkYpdJTemaXKwQA1yXxP+bZRYf0QJe00AM8MJUn9Ap?=
 =?us-ascii?Q?H29cG9rBx4xAfWeOicyCWkKD5cMomhwx2TatzKGN7Z6Eukjp0cwZHUuFa7Hm?=
 =?us-ascii?Q?uDCQ92PanC4R7eA4uqO+0nYaacHwWP3nNF0vXUpaum4TtHZHrQmNSUaw2noH?=
 =?us-ascii?Q?C1DOF5C+nIjYYQlxwIiB78gU/3F5YsNvKXLH9wDUEtc+ngKSm9EPxtGt9Bsw?=
 =?us-ascii?Q?/HoCi3nWxrTOiH1gOyv2tjie5tj4VYS7GO0XgY387rQkJr6N1eFcCE7Sm4t3?=
 =?us-ascii?Q?0KzA98T8by2Z+2QZ/pGyWgZmAOHgCNYu7u8NI5f4kqNBiA1hB563b2IgSt6S?=
 =?us-ascii?Q?pDBi4y2ETiTEOjaKYh3lTNBOx45xdra9giN6axPcF9v5vXvlHDy418vRmft2?=
 =?us-ascii?Q?WopjIDtKhKy+7QVD6Hyj8SMy99RD1o0J/TtJxVQO1d4pJostHB8Tj0MTUrU6?=
 =?us-ascii?Q?uWK0SW1kWWVP2OGkEVor4dlQcONsLt7VtATCMu/UQgu6VghU57eOaXs2Gz67?=
 =?us-ascii?Q?m+g6Si1cN+nwgXWhkV+4O+RUHSEd5hG/phgo3NcNyBqpy23IymdoJbPuvjdz?=
 =?us-ascii?Q?rgd2MW+2+eTnQ9aHx8LH+wWE0BpU530W6VbsygZwFPkFootqVswsAK/+/55c?=
 =?us-ascii?Q?KeveAgIKzaToNIxradrtPbPaHVfvneeHY4okQDsvMNMkqstGkW8cERTF3TiI?=
 =?us-ascii?Q?PefOgKwCNt9Ed1dQE+vS3mw2hUstgewSRamAYhKdnWxg8Yvrdt1PBauFtyVA?=
 =?us-ascii?Q?Iy1g0zV2LyB68SQE9bvdTtEn0SD0iWLL8pYYwmfjhWGM4GR0c/bmuFpqGJvq?=
 =?us-ascii?Q?Bi0maUJETbrXQTehbdLoXvEr3XeATavdP9wCIENSr3S8ti0sHEQ4d9hU6P6v?=
 =?us-ascii?Q?aHMw+r6Nro7ykwZpHGOEJ1jk1slb3lddgs52fqFVODJuNNhWSAgtxrIY5Qzy?=
 =?us-ascii?Q?JDVb/goT22yUjOJADzSrstGS9+VDCqzmCLgmsV1w5LghxvNEQqkmwdHT3Z+i?=
 =?us-ascii?Q?Ofj5ulHd4vMYct6VSaEjO2DefO5a3AmnsDijnSvZG3jdBV+/P9nKIABjV7qS?=
 =?us-ascii?Q?TG9PBE4KnWE52zmjwhQ2hi7imLMEw0MysCZaAz/xrVX8oYwr8r6mZLkjvOF5?=
 =?us-ascii?Q?WYLcRvfyt5Yd8UsZUh0zWt67tCE2wi2ew/GDX6YZq1m5HYuXPXfloKXjsrFc?=
 =?us-ascii?Q?f7eGXdZ26MQP/PZd/N5Oc3a7IR4Uq1VWU9SlMITAXAtsCcCatEAnVzwyYQAd?=
 =?us-ascii?Q?iffYfJjmULOo8os5KcYWOuCbnulWDMxSWClxl/7uqCeTUkBt9oYH5AT++ADC?=
 =?us-ascii?Q?1uw+r2I0Bs60Btbzeot0VQQQgwPooyEAgCo5BYhvL51SU8ri/rCGxSaFT+cL?=
 =?us-ascii?Q?cIqTpNjGwZ6Vf5aIesVQymSea9o3YkoYqtr70k++vxiB/8QaUF0E7/nHmh0i?=
 =?us-ascii?Q?UzOqPJXy/Ac8f3mDXgln6S2xv26Zp9BAulUQp/LoJFFnPB9gsioNfTBw49mA?=
 =?us-ascii?Q?PGf1MbwpSm8eKXR9lUjXOVikQKdJdr+4soD8VA2gu843hEF1xjmYpITDk+xy?=
 =?us-ascii?Q?9Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qMhEZ9/ZlakLLoHrQu7orXUwTdmBgoItqDs50QvQ4otF27yEt4Zk/O2LWmoqF4g6PMTOJ059hYFAFSI4shQigCsFXJV+7W0jfw4V/O4M0YfTbxM2xU8/dsMqZc5oiBol6tbS0fPM94S3Tz664OD2YSn6KzcU35TpGu37FmeRcwuz0LWi3O7213sb3xUnsolepB1go1ALKfs8BdShZZ1XKJAiGb0ytaF+Mf78m6knh1m9BUBPbx52wxdSFbZXlj5hbwbnQ2eVh/c/7sgTuEThQ3KbhJbrTLYMMiv7mz7YRCAeaf/9BCH8z2Faf4V7cgHLxb569ERyXXw9T3Ak0FwHe4Hq3Ql2BZZscto76EcqGNtr8Ib+YLJoXpsgvIIMItT/E0lKiw1rgRN1mRNa+pT5x6/y2ZWRKj7Jv4Xp8ODF9wcsn4M4FTy+ZWd411wG1xS1zdmfe3QzsXtE/819jbTjZ5cDd7OaG+wHK7b1q6p4WNzSiqx81xgnZjxy1cnzfTyHimuQVAUitVf3oe6ToN2z26OG1xobPIW5Dubp57SaDbT8Hl9ed92nO3OfqA6KLGm+5bzn+xMuBMLRbFksJWQE8wn74cONkmtwmxtge7tL3TXEVhhOUj1gqWeZOZsVdOT4rXjjsF/HslAKslRa3p8CRTP57eP9mRi4JK1TLW8jSsAB8+Uus0NRFppVas6G5f/uc/idZgm9K8NBqZDAcfd7P6PUve5NoXRZXT14MQMAt5xiMGx3xM/mNBaZpZC8C/RE+MPWCqTSAtc5juAAPTtZsg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 243da1f6-f5cb-418e-8f3f-08dbdf605155
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:08:18.0132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LpBVgcyPPL4cr0RTAdRve6jKiAmMghjUorbXkoM56mj6/kD6Bko1BLfWC3N24jN2mEjWJDqi1ePA1Qk7CUf1ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=993 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070058
X-Proofpoint-GUID: jZCAT1H48AqVn9uLZ5zo1mUPYnGS__wo
X-Proofpoint-ORIG-GUID: jZCAT1H48AqVn9uLZ5zo1mUPYnGS__wo
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c             | 2 +-
 include/xfs_metadump.h    | 2 +-
 mdrestore/xfs_mdrestore.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index c11503c7..bc203893 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2648,7 +2648,7 @@ init_metadump_v1(void)
 		return -1;
 	}
 	metadump.metablock->mb_blocklog = BBSHIFT;
-	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
+	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
 
 	/* Set flags about state of metadump */
 	metadump.metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
index fbd99023..a4dca25c 100644
--- a/include/xfs_metadump.h
+++ b/include/xfs_metadump.h
@@ -7,7 +7,7 @@
 #ifndef _XFS_METADUMP_H_
 #define _XFS_METADUMP_H_
 
-#define	XFS_MD_MAGIC		0x5846534d	/* 'XFSM' */
+#define	XFS_MD_MAGIC_V1		0x5846534d	/* 'XFSM' */
 
 typedef struct xfs_metablock {
 	__be32		mb_magic;
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 333282ed..481dd00c 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -240,7 +240,7 @@ main(
 
 	if (fread(&mb, sizeof(mb), 1, src_f) != 1)
 		fatal("error reading from metadump file\n");
-	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC))
+	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
 		fatal("specified file is not a metadata dump\n");
 
 	if (show_info) {
-- 
2.39.1

