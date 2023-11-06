Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D0D8C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjKFNMM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjKFNMK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:12:10 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D922100
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:12:07 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D1uM2024913;
        Mon, 6 Nov 2023 13:12:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=I5o91/g7roOyr9+XK0T/OumcpM6f4JRfXcBVBgZT7j4=;
 b=eIsabf0KRHPXM5h5xuGG0e4RUYm3q0AYVkCHzLcTCW/ncqlMmPv4XCg1/ABBfm9uUjdZ
 S2iUbXZeEJfiz/UedrRZV4+bQnPzWBfVwqohpd2pEWyOUtIfVVwrkQwHoVDyDowSQdpE
 ylGJ0Op74C7HgL3cLmVEsJUfDFbtWrG4Jv+ueF5bgWHEJyOUcE4yK3K5tXUdRL6z0MqA
 hluB1ReC1BR2JzD55dOQKiK4WAseeyf+up57IhLDC1Cv3i8z7RpZvXPJpFKWKml5RDYE
 W6LNqiyzBUcTpbzIFHTmIsL/R6HBSUQPizWIslBdy0Y47raOAHyzr5OdbDFKtyTAND5w jw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5ccdty1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:12:04 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6C3kJN024830;
        Mon, 6 Nov 2023 13:12:03 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdba5gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:12:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RFm0VBekzPZW/M44njuO9UdLaoj2xoFZhTXGziDlxVu83waDoaWPw8/JOaz+1j8iTMkoJ7yC2kjnvqZsIdhPxhuUrhzKCytIhhqWxoMHyrDGTRvDnAwyHAr9v5pL7oQQe8P85nlvEifSr7h6SXsAqp+yzkYz6OswnCu1qfT0WjvY1aZ2KRolC4JewsROz7ZKHtL32GPPyRYo3j6TM3I0gQKtYNS6mvGFti3URjNRKokxKkr7hRjuvSAbIZB29lynnte/uowZ0i5iKNJNHRWJQcep0HZQh25QsRGmJMnwZ4ZIhkQ6rRKcsV541B1m18UfO7JDVTj98hPl4wGt0HZN9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I5o91/g7roOyr9+XK0T/OumcpM6f4JRfXcBVBgZT7j4=;
 b=HR777c1FyUs2c4nRor8+Mn25KFgrj+M9rM2nf4YaP+SUBd5h+JfzNNwNMP3r0hiHmPjbsBqPz6aJD3bhJTw1/UK/RhUF1f/1lN0qrR3QdSa2o8+sGJCo2JGUPE9x1TPDqBFyJsEBbPWFUJOc3jomNzLmePEVOJxouroIKGod7SfJbpWYDAn7IQ4nEWPgsXv9Z/lAfgZv5NT1As3ZOGLzFpszvN9/F9nMAZJwl1vXgtwb7CM3l9U4EQCZq+4Q0+TemJbAxrQ5rv7B/NQgAztkiQRp+7tuglxGf2YnhMsSwgQVWB42lT9J0qzI4qH2WfgDwBOpi6A1cm0uxdNojyH5AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I5o91/g7roOyr9+XK0T/OumcpM6f4JRfXcBVBgZT7j4=;
 b=X9YDXw1F1KMLARF4iLbA3DlbNBhlQJJwEA0OwUnyCPK53dVDQefzgj4wBOEAF054qK15fNI7NeQWNUovPN9VdJDKZt+YuVF81NoG3C7ZGqUBn5xGXpfl0NLyhETQo+Z0N4UaRXbhYecrmDYoKrQ4FveNBoQweVXicMdbX9Y//Fo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by MW4PR10MB6534.namprd10.prod.outlook.com (2603:10b6:303:224::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:12:01 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:12:01 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 09/21] metadump: Rename XFS_MD_MAGIC to XFS_MD_MAGIC_V1
Date:   Mon,  6 Nov 2023 18:40:42 +0530
Message-Id: <20231106131054.143419-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0030.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::17)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: 87214041-0641-47d8-9a30-08dbdec9f696
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ymng6xBBtMc2qZkLKFeurU9WSas4036RP8RXJ2/ayimpUFPHy13Fyp8U7WLmSOs9ehfwWGnwxsJ/RFFSlE/HBMPMICcC6s9WRK5sdObeJg6eMqEqWr0Sn5P7AkutRO6AgQjrfurs6UZAEd3n2lYZXjAhUndo1S6V+2bH5WmeWmSauSqXvHhevaNKYj8qHFBchqAF7glpaMtBSzERjMkMpSaTz21gpMUgQlHOUjnofN5PI+Wu9i/ZK6BCn/fFjgr1/dpRn6gFsFQETyEwvRySMSxEWHCEgOPKB9rR+LFavcLZ0j15ZXrNlrGFN6KrTma46ASGx9l/Hi0bltAEpZvedrhxPsNPlPUHFmAYlKQryfXK+W+MZBDehaQYHimqVezGEPsmdNod3tHQXwLkRrE4RPddtpDJyVzYgphOEkXyiuOOv9B7hK+XLmw1vDV50xg/oRESEpf8yFKo4yhBMt+t6mQ5uGbT7DVnVR9E2knTUb/SPltEVgyEzDwOslhUjgEOjkdkz/P+M5jHFtTBR3SAtfbJrFqvafk/sudtCXbit0eR2Y+aZM2mVSZkHNN4JHuv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(39860400002)(376002)(366004)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(2616005)(6512007)(1076003)(26005)(478600001)(6486002)(5660300002)(8936002)(36756003)(4326008)(8676002)(41300700001)(86362001)(2906002)(66556008)(66476007)(6916009)(66946007)(316002)(6666004)(6506007)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a4m14aR95tx9RVSQX24UJCXFOlNPKDzDXi+eExT6byqgQDsl4KttGlFswb4V?=
 =?us-ascii?Q?mj6Pwh72hdnDuXbjNdCojT6R0KSQ5cVtM2AkmJop7N9/km9vw1onw2uHtR8q?=
 =?us-ascii?Q?UrkDCdi5VCUezQfSn3mbzuBMlg/i9cSwOsEboZmDaGrCgz7Q0KedsAwE5/a0?=
 =?us-ascii?Q?pC9Iruya30j9DYTUXv4yKOMvPnwuG++1gz785JlZlmdofCAHT/jiDPxh04Wk?=
 =?us-ascii?Q?aI9/U5Koe8U0BYVNt3LZvPW6jmD50uAytOoRu9ucBhY2Xzph0d1iEOUr9Mso?=
 =?us-ascii?Q?U4nK9bojc0gOsI0uhb1zjkYa3Hy17VCLPELlV3puMXfoCQ299VfNhQnxTv5G?=
 =?us-ascii?Q?hc2rib5btNSqnkwESkFv2iuirZnLMWJuijlSLGqWE5tYcYRBpt8JSEJybNp4?=
 =?us-ascii?Q?1Gxi+QAe6NqmqKWi46bAooQ04lwGD72pcUX2KJPBiLiYYw7qk+Y7Tg7Dee4x?=
 =?us-ascii?Q?G4933hLd3iuhXASuuTbL/6sSVzZtuWjBc8WJr/OzSasUA+qOmNsTeLCXarrs?=
 =?us-ascii?Q?vXqU/ouv8SIPspBx/PgJ83hv7H3j7r/CVNi3Jab+/C/dnmAdCyqk/xgsiSXd?=
 =?us-ascii?Q?XAPirUiSbPqiAAsr3NKKluHVjrnfS02rusdTESWU+Sz5s8tItFUeFqSRZJ1R?=
 =?us-ascii?Q?tot1A8MN2axGP8hdg6Y7YuPbcyaqmFQTzVGb/z4hVaDIN1CnQ5wgV5fOFHh1?=
 =?us-ascii?Q?T2GVMIJB/qhm+50l9XjAkYC/IIvhVAkeQCqSn4JhiA8JXEeVFz55FA6isqmT?=
 =?us-ascii?Q?nDI/boq6bExfXKUlCONEiCerYa4GFZ5AatJL+wyDhliksgpER3q6rvgthe4z?=
 =?us-ascii?Q?hK98QHYhw4RcAPWPObgIjmdSVVTMPneAx3qCmfQZzXqZfX06Bsrl64sZ9OkN?=
 =?us-ascii?Q?JqWUncpfvu7Hl2mdFow2jp2URCQhNdbdRx/K87NY2fuOUAGClMN4i+IcsaUc?=
 =?us-ascii?Q?ltVOKXI5EwWkUIl8KAL6IZF6D9hJsd9OjTRPOOSxMcwhFSCv4paVajb1+Os8?=
 =?us-ascii?Q?t8I9PwHaIeg8xOe0H3nQQew4GXeku1CPNpMylnMbDGLDsy3Z7ckFhNDXh5Kq?=
 =?us-ascii?Q?IwtqdVYVSH02Qww7hZRH5MH1uHRHR/2VnAP9gkmkeAJAtslBcKn79Jwxm2KN?=
 =?us-ascii?Q?qHP69JmSOn+yb7HlUk2rKg1V3IWr9DQb/OOvMxdjSKY703r9IO6yAQYAh/lO?=
 =?us-ascii?Q?Fk/499r48G6DaXaOxY6X8tyi7MgF4lokZPXuAYRivu3CNNQWf2kah1N6DeWk?=
 =?us-ascii?Q?zZvvq/A4pcnPNcVm5OZ+uJwIyceO3Xi6lceou6Fhk+Ip8xB/rL90PFAHlhxL?=
 =?us-ascii?Q?REkYSa2KNdIKCPlqr9XDtJ3KT0E/lVY30twlrA7X/0bKyEmAKIgImNFU5PHx?=
 =?us-ascii?Q?noBXY9xSvmxX+SYUZmcsDYLfCniK87X1vMzyv7SllLUnqh2S4fr3nPhPi1en?=
 =?us-ascii?Q?dbxVJIsEDbRKXFf2DjkEBnIfQRnjK3QqemlmMO9bXDC385WupDWoGbyHZSBl?=
 =?us-ascii?Q?YnlSi5j9qJTOfssfSVeoRTaWwJTSAPl/fN7nS9DyawHteWQtnCL8mC9sMo0N?=
 =?us-ascii?Q?OjiywJ1ce4dib7f2GHVq4ibOJ687WXy+V/mS7dXB?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: FDVPZ5P9pnTVy0K4Ip/rd3vA+ELcWts0+lbMbT+OS6pA/Nk7ZlrE0qjJP9+ewbE4RSx6XFpE9xWRkZEgNKIcGeokTgu8hPpDRBZr5uT8Y+ik5UgN1E64hdcJ89PJBQbhQApbHu5PNyoufFI1mYL1eJc0jYjqva44shkqfdg/Kl5a72Hi8kmmbGHY4w99HA6OYZ9nE4pkeDdZRF/X1XOfbcL1jc9Z0l4VaB9XgPuiHDsWwWWdM6JhdQwXYw0nVKe759mNLLfXUpopiQEoqmliYg6FiKEk/BC2gdIvaw7pTz3cLdD93v9fzdjElQto8xs5HK2bdEhaU+2OplSiOfFUUI+Gbq3ZM0QjDtwbpDBXgdESogq+fcnO8OaIDLpen4BrQL/JbLBX9Y/TTJS4YhL3FjNwtQOpovOJdCJoeTYxwNbfOBYf0FpQbdhkkdIGXRfO4lT0Mv9JKz6EEfmvSUeb5u2p9uFw6uATWzGx+ue0PhCZB9BFV/kv4qO019cOCpX0WScPvxtv2yanZF/JWKDk6HctoxVrgzAE9YOyWzZL5vsjh2xlaxzHiIVjcj97MzGsP2lsKZ0f7J9sVosJ7Fr7aX07UrM3IEwGT9ziYadU556DFpwADEyIJBz/KUOefz0O9T3PTbykFSuEfFdeywR7UeD+72OovBbIPCY8DLTUuImESSGpNEBJpsQYHnbFwxYbTqtRo6PTmmZCR5OQXam1XntYAZsSS2brFxkQ3lVR58D/O0d3jaQMkeIdJ2mCBoTfsCq41JJDqFWqU7QlOx0+Q4mnI7PY1H2wV9cDw3mk+RI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87214041-0641-47d8-9a30-08dbdec9f696
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:12:01.2840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VKtDltdX5xUdRwTVsyDjOBufBTAtRpYo2Hv/1EVU8zJnR0jDZ/3Ot9TLUA2yStMugqC1Y1KpnlgGVcqtalEPEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6534
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060106
X-Proofpoint-ORIG-GUID: TnZhfvW1NGZXS_1SuCfMeiN5LZ3SMpDi
X-Proofpoint-GUID: TnZhfvW1NGZXS_1SuCfMeiN5LZ3SMpDi
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

