Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17216C4167B
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbjKGHIb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbjKGHIa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:08:30 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A2311A
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:08:27 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72OhNo015138
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:08:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=dXWGwBKOi/IjEjIn3QLJ0Qfk0SqwnjsNke14A7fAt0Q=;
 b=Im6oY5BkS8neg+YsVJD76Mu6g/v6qmcLL2OpnGCQqSPKaKMDBCFRX8LOwk8k7MeJ/wjv
 aR2iw6HSovqqjyWLa+8YHK3XCJ9PVcrX5+B1N5eq+MWhkjIlhtIf6RIoW39GDr2zGOT6
 9hmo7M491L1yCUjKJ1dtHTk4MQSOBpKN+w2ht8DRnancNuvcrGLvxw3RUigkVXya1oiS
 E+yS8hdtnGJp+xYAWLdBr5Nhbbe+j2GVbWUVQ9TDosXs7yD2pL7ePQom5mek2a8hivtI
 pEn5bWwjB0DM2hv6xTG4lE9lY2iR6knRKnV6ikkteGaVPlOplab44m4nwibYdDpIXcVQ Ug== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5dub576v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A76hKAS023587
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:08:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd63cd4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHueMKBk40i+Ij6Z1moXdVBAh9OsHfkXvT6TZTsaaxAu0zIqYpySbKOEAOYZLs1IYGBFkuftU/88iJRNEKSp5GKIvw7Tj3eWif2JR4QJEiUXWb/dJXgz4cUi0VIx3zxjOcERHITdPfZQ0AB9SCvdkA6noTbPdnn2KjAPcsJKpiBe0/Suj6hn3q2HW0uGAS7crOjIukcIQK+cv2o4NidwasqPVURia3nTDmOwX9WhuZX1+bXIdln1Nkp1xPrLvTEDv1ygkR10ceTUX2Yx5i7OomiXpHFApB+Et5v3oySQV6KP/fOFnILhR15J/U/4zJvgaKJZRqPFygiJaiunG7Ot9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXWGwBKOi/IjEjIn3QLJ0Qfk0SqwnjsNke14A7fAt0Q=;
 b=W0jBk0zmVAsKsEggO3vu6Q6WBqn+xoDLRtMRbbcnv50+zzHCI2XScZUgMiK+3/mhXz9lWZrLDyxgc3qePQyFKmyx6OuZzM9L/vgi7wzNb93UrP35UptiMKVaRVnyk1gR0UTH8Khaeok01oFRgmNHTW8aM7S4QjrSD3HDdM48WMC1IFfTkiVorEnCN0D8rQoU5yX/sv16bwJF1FV+FS/Hf9Y0MwDNq4yBjsnv5EUDNW3gULe4VP/fpphc7VujNJvin3DSuXyndZL/gjTTsUWKC6IIkm6qNiwpwk6LR1zoQZuINtMoOAm7b1OFJzzdc6vuyzElTfDB5mrzUCJOe9xuMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXWGwBKOi/IjEjIn3QLJ0Qfk0SqwnjsNke14A7fAt0Q=;
 b=F9K6ym0qUAZo9+7bQ40kv3peGgQ44j7h7Raco7BMqdQ6l0bB1dYvZViYtt1xykHVUHN5ffHOFQy6AzIaUYiqm0yL1ti4+U1V21CLNrRWeTtX1hbf+WsijpjAUb/FnwsSFCxeSANcVTj0RECOyb015DAN86u7eFTXy3BdIb139lQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by CO1PR10MB4770.namprd10.prod.outlook.com (2603:10b6:303:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Tue, 7 Nov
 2023 07:08:23 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:08:23 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 10/21] metadump: Define metadump v2 ondisk format structures and macros
Date:   Tue,  7 Nov 2023 12:37:11 +0530
Message-Id: <20231107070722.748636-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:4:196::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4770:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f7260e3-c349-4ca3-e033-08dbdf605490
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZApblFiej1HaWMTgkYY1cLLAAXstBpsbQt6Y8NwLbA7l1X2YANEdpktFiCjiNhFS67bqve0xMxWBCb+3b1xqSXYIHRTwvj5a0QSvyqhjBa3WMZz6f4HpyMN+YpKP4Sd6f7ZNK0cJc9HxM3WAwPkPMdl933b7/t/qDR/1U8GFUakyGq+F1AiTeHcg09YrImA9EPOhqc0n8BnsjV1otra1kqiksm/EdYACglqSj/tqOdrE4gR6QtX/GtxVIrkgJvqQE4xqB/90p1hQ1Z3haXbRoPMgAPXPzRagbeaDJ5HiAvqIaQlj1sIK7RhNKLMwYlIPo7wBlgfPoJmjlzlgXYV1SCBpdFRU6NSvblBqETSgH6kxD09+gyZd6R3pg1cci251Cnh5iQ93C6Pw4jYJ0u0lOYPS2zC5EcAPzHhswoMff5IXCMaUIIz0/UNORTsdUjArOxl//KNDDBc4O8/7VFfxOI1hgJlAFfsZUhYueHJpHaHQUmivseuXMEaOeZVCwLh7xhgfnMOdXlGgncDv/xFmocN7NqFy5IEkhCtzi3bw2rriIQmRiIDFQecma0N2DbkoLUGziGnWB2gQgZL1ZqzmYXPngJ478MFXxrNiuM6ziv5STE3YaMqTVmsokILW4wG3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(366004)(376002)(136003)(230922051799003)(230173577357003)(230273577357003)(186009)(1800799009)(64100799003)(451199024)(6486002)(478600001)(6666004)(66946007)(66556008)(66476007)(6916009)(316002)(26005)(1076003)(2616005)(6506007)(6512007)(8676002)(8936002)(5660300002)(2906002)(41300700001)(36756003)(86362001)(83380400001)(38100700002)(66899024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MMgSSe3vx0MuOGzAosuO5RChadGG8b7s20spis5zuUsaIc5NfOLEXNpPpM01?=
 =?us-ascii?Q?eCBIpWMNjEjYY/LrjmYBTdtWR4YlwnYnlIVAmHDhY/b+nFTB/R0n6bEv1+Ub?=
 =?us-ascii?Q?G1kUphCuEa5g1QidCCEFvNzNSQO19DBVCfrceJtzfypCALzrM8IV4pj67UG6?=
 =?us-ascii?Q?FhhKz0C+9gMobkl3vauBKC6KUOYDbX/Mxs8XwVwx83aLhyR9qAB5TgcvnGXk?=
 =?us-ascii?Q?BeYxZGTahdG91SjWAUSylAKn0u/Otebe5h/rn+uUccwWfm4+PfhxKDF1WzPQ?=
 =?us-ascii?Q?AEtk3Y6AQxtUPX3Okeeb/kSJQaEpPDsdvJykeiYygZhoJyNvyYjTMWjzc1WB?=
 =?us-ascii?Q?fRKSYUecojDQWkw3RfeEvBXp6E+cKO77cdD2jcm4Pvb7lk1eNKM/rtT0oTOO?=
 =?us-ascii?Q?BG1qtvqVPoPxVl7+BMk3wgaJfKGfwqD7Huh2vuxUsPClBCUwLZSa+8X9BICv?=
 =?us-ascii?Q?6Z2MQIvHRtg6VRHUrQFStKrdDuhdtDEYV1F3eYxg1QjDZHLXSfOnvLU6ZqqE?=
 =?us-ascii?Q?3lOKaEhMfmEZpgg+2h+Q4MB0QXwCJVY48hKl4QPqp0GW84JBR5ltd26//G6C?=
 =?us-ascii?Q?dufp+pK4zTbv7GJM+UHkema8rAR+JcxATUhDKJTbX8+w0GpgHXy5uQJUv2TY?=
 =?us-ascii?Q?xFDuF+qEyqF6dRCToWzvv2xITeHNzU/lNO8po3X3zEpTnZk3a0ndFZC8Mp6T?=
 =?us-ascii?Q?wcHYfG9K78sCLkyg4wOXzyf7koOWYOmKwJviIOheD9QVNIxgYp96nijD4dPP?=
 =?us-ascii?Q?BnWqfZegqT1HvWDsIW41BN1TNPVYkkqawBAW3w/nnX1QdE73Dmxb4IT2djxT?=
 =?us-ascii?Q?BbMgIexNhv50kohEdJqeCgqmr3dgYSy3EPythq/gI4/MDlBP+aogBe7pJmxW?=
 =?us-ascii?Q?GZZxM/mV8l9iJ3rSFySjxGzPeURBKlBPV78n6EfxuyxGoeNDGCRg/x1Q0I+8?=
 =?us-ascii?Q?PJtrCVRNmdRmFXKiRyLycezlY/VQeTwWsKxZ/UmG5RxMVEpbkPUY2OayW7Bh?=
 =?us-ascii?Q?7hsOjV23XK1PAKo+9QwisXC8EnAtYRt+D0oZPw/CaffiY9XJOU3VxSUaCaiV?=
 =?us-ascii?Q?OTRIQfi4kVgSvQCWO/A368TocXjHrJo7468SGUm3sYAvtMOC6eqWxwVpfguK?=
 =?us-ascii?Q?5umUAQeME8VsyGKQpXz1xih6X4yBmAw1LrQfjLXNoxy/wixubEuQaKrjw9it?=
 =?us-ascii?Q?Ohl28jSvyoHtV3aSHsDgREyk9XX298a6loix+fDL9IopTm3Bws7RoHnBHYXp?=
 =?us-ascii?Q?bxfwWU5Q6KdRTd3T+98fZV+jYYwGBiWE9kEKNYbaNkVdQTHtR9hkBuj0/leN?=
 =?us-ascii?Q?NhkGPfk1iTmIdb6TPxe5Hvs87WZCj+IEWWPn92hJDLUtsD/DSDyfkL9fvz2k?=
 =?us-ascii?Q?lmcPa+ulq+28E4+Ervchc05LTNTvtlh5SVVrvFucd5v7RFDPHeBJF5W4U7xh?=
 =?us-ascii?Q?dg7iPnS8p6tS6C2NQ9jQ+y89/TWdNCsXICGsB4MHkGlpQr/KRuc+HZjlbJDn?=
 =?us-ascii?Q?NDliNIS3pp5jyqO66H9VoOkfmnEzbr/NO8/eMHUZ4nYiQ9RCzyuNrO/hB5ed?=
 =?us-ascii?Q?tj2ccbaHVcxJUIik8ym2o2LzgSWYbiOIs1iRRjfDsz7qzxQrekvQ6aujmVHp?=
 =?us-ascii?Q?9Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: n2PAT2TTfO+Fryz2jTId1bK6evjDwvD9lb4Pn0aEZLIY+BXibIB0hmqnmJQuOGcXkGIIRxpbITKSou3PQkdJPAWPwSdfCn/V2oLIPvnNmluJT5Wy63nL2tiQfDHoBudqwowPNw/36DOFVEZryBjAOTC9PYvSy2ph1Q6zuxpUPwXYu8SBGOB13DIQeV4exN8oIBqK8Y3aITJw8vydwmCh6TGQuyPPvCMpnn04D4gaJOnwww5w4DXLd5qj+MpRTD6YZeB51DnWzKkBP2vUGzAKUZPBhC7WSpmX2DTRN+LFfOx1B446xzD13SDUXAl+1nXAdav+wQLiICWN+v9gswzkBGQfKZMlW7wzQxbi1pvOApTQMY8Oyo2Hi0jPEDuT8W6Ho/5plcLz1ufY9fBSPXTlV0cuoL8Vb5tUBAxCBZCNFhAhRkosELE/AIjf6SQNA9e8IMLsX8LgmCWqSsiR7B5nsVZsnVU5cHzqPV1o/L3BWsEfyYqjVU+A3ytnB9laHT6ANact8oCHkDZrmQOYq5f2lh0y6Lecssp4jbUVok7DJRhWpDMO7zZrJFLISa2muM3fRNPKPw/niZoAP6/ofAv6q0qFBFs/yQ3LA6NQm8+QYHLO1JKDPGgQmPcIyP1CwoqhcHC1B0MbjyLrNZm7ATyAHCmi59brHc2Cy+0jDPCupcyaBwBq+j2hxcaIMQWGWcSaBlOf7lfH4nmJHnk7pebug9RWtcnwzXXHN37OU/w5u8LEUkP120iVxVlfJ02lxBS4SLa1u+NYaQYhRV2ET3s5LA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f7260e3-c349-4ca3-e033-08dbdf605490
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:08:23.2486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ol8/ROMFtcJUUO4das5SwlXrN+3wyrZgBRB/DLMf4BiKh2R2hd7aqGABHKBJOXITChgzWgoIFHZShvfFxUbj+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070058
X-Proofpoint-GUID: gT3ZRnvHCrVPxt1jOjGF772FONwx-jtb
X-Proofpoint-ORIG-GUID: gT3ZRnvHCrVPxt1jOjGF772FONwx-jtb
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The corresponding metadump file's disk layout is as shown below,

     |------------------------------|
     | struct xfs_metadump_header   |
     |------------------------------|
     | struct xfs_meta_extent 0     |
     | Extent 0's data              |
     | struct xfs_meta_extent 1     |
     | Extent 1's data              |
     | ...                          |
     | struct xfs_meta_extent (n-1) |
     | Extent (n-1)'s data          |
     |------------------------------|

The "struct xfs_metadump_header" is followed by alternating series of "struct
xfs_meta_extent" and the extent itself.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 include/xfs_metadump.h | 68 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
index a4dca25c..e9c3dcb8 100644
--- a/include/xfs_metadump.h
+++ b/include/xfs_metadump.h
@@ -8,7 +8,9 @@
 #define _XFS_METADUMP_H_
 
 #define	XFS_MD_MAGIC_V1		0x5846534d	/* 'XFSM' */
+#define	XFS_MD_MAGIC_V2		0x584D4432	/* 'XMD2' */
 
+/* Metadump v1 */
 typedef struct xfs_metablock {
 	__be32		mb_magic;
 	__be16		mb_count;
@@ -23,4 +25,70 @@ typedef struct xfs_metablock {
 #define XFS_METADUMP_FULLBLOCKS	(1 << 2)
 #define XFS_METADUMP_DIRTYLOG	(1 << 3)
 
+/*
+ * Metadump v2
+ *
+ * The following diagram depicts the ondisk layout of the metadump v2 format.
+ *
+ * |------------------------------|
+ * | struct xfs_metadump_header   |
+ * |------------------------------|
+ * | struct xfs_meta_extent 0     |
+ * | Extent 0's data              |
+ * | struct xfs_meta_extent 1     |
+ * | Extent 1's data              |
+ * | ...                          |
+ * | struct xfs_meta_extent (n-1) |
+ * | Extent (n-1)'s data          |
+ * |------------------------------|
+ *
+ * The "struct xfs_metadump_header" is followed by alternating series of "struct
+ * xfs_meta_extent" and the extent itself.
+ */
+struct xfs_metadump_header {
+	__be32		xmh_magic;
+	__be32		xmh_version;
+	__be32		xmh_compat_flags;
+	__be32		xmh_incompat_flags;
+	__be64		xmh_reserved;
+} __packed;
+
+/*
+ * User-supplied directory entry and extended attribute names have been
+ * obscured, and extended attribute values are zeroed to protect privacy.
+ */
+#define XFS_MD2_COMPAT_OBFUSCATED	(1 << 0)
+
+/* Full blocks have been dumped. */
+#define XFS_MD2_COMPAT_FULLBLOCKS	(1 << 1)
+
+/* Log was dirty. */
+#define XFS_MD2_COMPAT_DIRTYLOG		(1 << 2)
+
+/* Dump contains external log contents. */
+#define XFS_MD2_COMPAT_EXTERNALLOG	(1 << 3)
+
+struct xfs_meta_extent {
+	/*
+	 * Lowest 54 bits are used to store 512 byte addresses.
+	 * Next 2 bits is used for indicating the device.
+	 * 00 - Data device
+	 * 01 - External log
+	 */
+	__be64 xme_addr;
+	/* In units of 512 byte blocks */
+	__be32 xme_len;
+} __packed;
+
+#define XME_ADDR_DEVICE_SHIFT	54
+
+#define XME_ADDR_DADDR_MASK	((1ULL << XME_ADDR_DEVICE_SHIFT) - 1)
+
+/* Extent was copied from the data device */
+#define XME_ADDR_DATA_DEVICE	(0ULL << XME_ADDR_DEVICE_SHIFT)
+/* Extent was copied from the log device */
+#define XME_ADDR_LOG_DEVICE	(1ULL << XME_ADDR_DEVICE_SHIFT)
+
+#define XME_ADDR_DEVICE_MASK	(3ULL << XME_ADDR_DEVICE_SHIFT)
+
 #endif /* _XFS_METADUMP_H_ */
-- 
2.39.1

