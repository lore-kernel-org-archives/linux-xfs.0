Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A659DC0018A
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbjKFNNz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbjKFNNx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:13:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CF3D6A
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:13:48 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6Cx4JA005779;
        Mon, 6 Nov 2023 13:13:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=EEm7+mmfslog3GKIhxsY3ArZni03JxPlBAnllghLzng=;
 b=poPWiHG2IUcxwkBD6ktnQVa7WYLkmSGjc42VAhzZ/LS5cW5nv2DkngTWb1Y0u3ToNMRw
 16N9sNKIoYyrwRKNT/WeiKc2xVoe+7pXT1psbR+WTUhOV6JSitS1c7Kp68DUe8EYdqGe
 j8iNEJLKYqLvX72iXI/z3ztXfq15k7WkcU1CyKoXmqSBX7/yDnHIj4mcNDTS2mzV8fzT
 CGHuUB7EuqDe4wxKb8X0lkcETzmF0iih4xMRv2UxngAURr6jfSw+D5Hw75ph+5xi+yNv
 cFtERI7LEFJeyQxUnIAQ0qhR/SIh2wNNhHnAwsJJu/atZrdz3Y6T8z+6eNBzBgu2d5ol hA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5e0dtwey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:13:45 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D8Rkg023535;
        Mon, 6 Nov 2023 13:13:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd4tcfa-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:13:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b91HODliWt5ifkZOYjgatQj/I4sqLPLThXR1QqY3+tQNYzkldwg2pEHo8pxLPMNrXNyuTvq4Vzcp3uOPgvhpohYtoLBg5/nJ4ZZfIYrgCHBskdXTjxhiDdiliN+PVBcAWtY25L6TGvi1l1idlYHH2vtLhG7qpyN+nckuiMERRpBy23nUU3lT4Q3bOIJcqKgcttk9KKDh6gpmT4HL+km4kb3rjJwtTwADv6Vqq2eVU193kfEPmq5rWEjuaKB4KQg3VAd1Uva6U9McmGzW4Jc0J4vzkLNyzsQWa7HA1C68D0E+OO49Epd7lZAFizkE+FkupCaIHsluIW7y5tm+WrPYIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEm7+mmfslog3GKIhxsY3ArZni03JxPlBAnllghLzng=;
 b=Uv+W294Q8ZFo4Og6VYEvDl8DLRxuMkVVzoHA3u1J5GQnF5EP1JJe2sm9T4DMuj4wEu8haesz4Tta0SWBgAjEA39cMKspDe6cZqeewME3vo0EEsR/S2/2tLIHpjQS4NRti7Xc27TO9kkBUzAQ+qYBgYMMNwHHgP79QSk4bXJEU4sF5fhIeMDwQF4Hwm5cWlNm8mlHf7k+y25WQML0Vem2fAm4z3pRSGRfo6Opd1ty7A2yFU43Cg8Fg2zFXL0pe1Ev8tRgF4NlnM/Lq+O3aNKSFUbDL1jwFjqNfbdFdfk6Q8D5ek3Ev0mfAMtD0pQF4uoCXw/bstscPE0mFJsEBUkUaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEm7+mmfslog3GKIhxsY3ArZni03JxPlBAnllghLzng=;
 b=moGHhyIwsuVK5UZYI5S4WideMdgNH51PedsM7n5Sc5SS8+44zqD9auhCpQ/a2AA/Lng60Y0jixmWVmsSssPh+gxl/AAGPmt/7YGvzGRaBO9YBR1BhLP6+wNE0yWMvdyTSvx8+F1/vxkUYaPVYUxnGCbIbIX4z4YjlNgOC7xXhLM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by CO1PR10MB4513.namprd10.prod.outlook.com (2603:10b6:303:93::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:12:46 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:12:46 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanbabu@kernel.org>, chandan.babu@oracle.com,
        djwong@kernel.org, cem@kernel.org
Subject: [PATCH V4 17/21] mdrestore: Replace metadump header pointer argument with a union pointer
Date:   Mon,  6 Nov 2023 18:40:50 +0530
Message-Id: <20231106131054.143419-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0004.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::16)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4513:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a680747-f3b7-4084-3cd3-08dbdeca118f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TihIrhhwts+X2+wAglKw8kwBqDd4pIyT3RR37x+tdXKXwKkpiX+6s7dabyO9Dbej7NY/rp6BMSLfQ3vidW3HdjT6yqj4WgMZ5V5pq4BIRFkrK3hlannKoX8FsHkqQUgJEw4JFh1FhPP2JTAsPNARtekHqe39R8JXW6TYB5BcIqE3euHG/2aZhmBEzu4AIgzPDBUiSwg+qAqX0RwkTaWXsJD7a+kKCJcvRY9BAXx8g0ihhiB43nUFbOCCOyvSucG7pHMnKpP8lEnfWkpcnKjUPhoZpvq5+1hXvCzsR7au6ldr4ekbh11nzpy5fS7Z3DE3dL+cVplbKln5ol3RlLfeZz79lZnefmUk9QMn7zqLWjzeUzC0U2vqGlP7yq/aqg9ZioEuqAVK77xuiGZaR4jUYxOlnt8JuaRVMPKP0fRrcs2eqUvlLDZgPVkR+v8oCi9C1ek2pguRlqZud79tSdYh5DqaO/XzMGdYmOGSpiNl7nNngDMSzw45LdYV4XDO0LvCbu3M6DcRSMVStgBudrv86LYPI34O7eBgsrcGDK5VglK5VezIHhX+KrSpkmK/RfcCL3ddHhiRNSyBhpbrRoPp9bYSjRUwfecVlNsDrEFToLFzYyyeUWiaokzOMSvBJOYO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(39860400002)(366004)(396003)(230273577357003)(230922051799003)(230173577357003)(186009)(1800799009)(64100799003)(451199024)(6512007)(41300700001)(6486002)(66476007)(66946007)(66556008)(6666004)(478600001)(5660300002)(6506007)(1076003)(4326008)(8676002)(6916009)(8936002)(316002)(2616005)(26005)(2906002)(83380400001)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UeDH5hlKCOpRDxelwkZb/dcoJpMf6cadgYtcGWf08WhCEeIsMz/3gXieu03D?=
 =?us-ascii?Q?COqMwMQ40ppVyDtjQ8xb8wvWlKnoBAfJ2SuYbunMwcui1iGPi57WUsMuOtW3?=
 =?us-ascii?Q?YPoC31DVISlL1wm8/N+v/8Y6DWCTJ6gff+xqEsW+l/L/16HQC+iVjqarCgtQ?=
 =?us-ascii?Q?T929St8YoMc3pUyeRS9P4MCwN26+NyqVoBfrj8LRd1XzseA1g+nVt0ET2emP?=
 =?us-ascii?Q?NOQQe4LFGm/UXsPz98ehn2MSgUthu/yl77WhPKRK9AbFjoumwqYLUoJ4XP0X?=
 =?us-ascii?Q?CAgqSfxfusNqPhYEZ1uVpk+qjeQm0EnAwag7JZ/jAyikfRz4r4kWbv9qkwEw?=
 =?us-ascii?Q?/218qBMw2kYX9guqkzb61J15oYsFfC7lMa4AcvufGWu9deQbUjeyzedZq6Q9?=
 =?us-ascii?Q?LR2cyDmEHgn8yXbB9szy1KwbaFeMPeURJVcPd3iIonvhqooovvmkNX4fvM5Z?=
 =?us-ascii?Q?iZM5S2I/Ad1IElmeNrY3cWD7SkAo383dwrwb/He7je5+stfJr0RxVXqx7FPH?=
 =?us-ascii?Q?mXQQfsebKGiUHxssToj0du9Sp1WFUUYCTR7z8X5HokaOvgmoYk4WwC1sTlOe?=
 =?us-ascii?Q?gp3QbkRruAFuTx6+UbruzH6vgJVQ9eXQwezaUFFjB83NEJ6uwhYAqVWP0fPs?=
 =?us-ascii?Q?F2OWait3h5nQWmQ9dAub1iStnyoi7Ph+rVpsnoFxO6oCbR9AndfOJF/WWpgC?=
 =?us-ascii?Q?5Ma0A6MojqxWYVEnVTMosNXCiB6VJ6OVhZb6++LLPS9W32AU4EPZI9w1BHWF?=
 =?us-ascii?Q?cEFzNKL1Wy1ZKmXSZqMIOjtm+K4PH2feywPfKRpvXvqt1PwMxWzk5V3xTh2q?=
 =?us-ascii?Q?ljS0SDXQHVbaFw/nA+z5Tz85NLSVR5go0lkuxrX8wz0tAqpPYE8GqXJxKYcL?=
 =?us-ascii?Q?4KApZf4fYUqCECoIKT7RHHWVYcoQOeIr1F2qDMtWi7wPcpK2FOo+uk+aTUIL?=
 =?us-ascii?Q?bFTGhOWhPn0dnAtuCfGrbd8Nj+BbtvBPUXAE0IcrDW40gDXh4diWp+qdqWjV?=
 =?us-ascii?Q?uEhstQD95lgDRCvGBW9KqDoJm/fMA6neTkWEFRisZvV6OofxG9/snvLVFNAX?=
 =?us-ascii?Q?KDiPANPTAGpZZa1oO+eFClW8vE3qAiuOO2JmvrKeF2DbHd5+abDEAsOQksaO?=
 =?us-ascii?Q?zlYv1SSPcn73tt5M8YW8Ra4Rc/TQid1hUqCxx4mVku0Wr2uXqxQcFtIcTF4f?=
 =?us-ascii?Q?fo284bq0zj6g8r90iquZXtOZBpyCJ5Ky49e6tEkxYiva+qIZ8KFrTwwfxvmm?=
 =?us-ascii?Q?mjuTsQ91IKy8lj9vcBDxRMyW5ovHA7lvxwOyhfaaD6/w4ALJP12rT6gJa3z8?=
 =?us-ascii?Q?g17nNcgCInt8dDk9vK2e8i7QloCMBDTOhZT3PGgVc9TdiQm0dEh5YLTscvj6?=
 =?us-ascii?Q?4O5foEsJCpaemELiBzyRMuVHnMagkUEILAMQkStlX7BM6WNjIb+dzglDKc0o?=
 =?us-ascii?Q?6nrsEQyNt1F3MLETOAKDap7owyzXTL3ueL3eptdRd+sz606Crq+u1CejXKhb?=
 =?us-ascii?Q?IZDWlOesr5MzFw93r0LI2mEum65gEFfoXVp+0oEYPijewKhRnj77l65heH5C?=
 =?us-ascii?Q?a6RtjAjKahS1ADhCjFS5hqJKDMsW2em+kBmEirGTcQd2BV7p3uF2CEXQUUjt?=
 =?us-ascii?Q?pA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: iyFEh5CENd2M6L/4p/Xyc4vY9asazL/NyB4c/CIO22FpTbgKT8zSVO3sOdZKq3xVXLvkNfxMbtmNMst0UtAAlopZLfJCrm7SRBVI6yQqY3xTTqy7qPNVGyHBx8W7wt7BJv9eUBBcHak1MUy7Tf36MNoOrVX4EjMiJr19+Zwb4oaM9ybN+cRKMHAhmm2hC0yQqfI2zKLjcSlofFl5PgfX7GamYLMEedJCPi+qkXcGVHa1kwPO7kWMMIfA43Ju8mijHkDL4iRzIxz7QC2aZVKRyn1skh4w7i1W1hirgpkMVL3UQedg6CTGrLGrOB/GbfmelxnJ2tWBFf8AI7Jv5gpALe5N7xXp8wZ8CDbRyxKq6xsg88eiP1pujEyeSPmWd3bXyucV4GCyubldGxwFUXPLxlXPjzO/8etSYnuEqB8yakL1vA8nXQKFEiIV7Fpft8H/3/gp9tgvvZdlw4+9JOUOsvRh22tp0i8zPgotTqJFWntLk8HX7yjjTGTFBHMs/UF13oRN/3cN1KWTwPxLgEi4QZM+grtNJWDQOgOefgTwCRsBgTNt6r/UghmO3fg+V0cuylghxmKwgdvttb3Xsg8P71p7tHXVAvhwlPyXZOkJ0ehs2VqNxUulUKi/UjyntG48qPcjVdh/qs7Zu0vHCPE6GFh0tm15ar4Y2INbSwq0MrBrtXcw3z7kRqf29BztbsS9ywwTmar3oaLDHl9OPgPOseL52xsB4Qhz10IMiuBa6Xm7H984nwsQAs3uE9xHAvkEfRJVQ5yJYZPZ3bGp9UaRz+rJ2H0w7AEvQDgvK7v43v4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a680747-f3b7-4084-3cd3-08dbdeca118f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:12:46.3615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1vXBu/ZqX/zzzHmEuwE46bVU99bXgbk86OgV0yeNCkmS4al5514a9BUVAS+GnST5VIMsU5HMH79Zpa372fAf9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4513
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060107
X-Proofpoint-GUID: X36CD7ImpRoPT9TP3frUqMHHwxtXWBRT
X-Proofpoint-ORIG-GUID: X36CD7ImpRoPT9TP3frUqMHHwxtXWBRT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanbabu@kernel.org>

We will need two variants of read_header(), show_info() and restore() helper
functions to support two versions of metadump formats. To this end, A future
commit will introduce a vector of function pointers to work with the two
metadump formats. To have a common function signature for the function
pointers, this commit replaces the first argument of the previously listed
function pointers from "struct xfs_metablock *" with "union
mdrestore_headers *".

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 66 ++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 32 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index d67a0629..40de0d1e 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -8,6 +8,11 @@
 #include "xfs_metadump.h"
 #include <libfrog/platform.h>
 
+union mdrestore_headers {
+	__be32			magic;
+	struct xfs_metablock	v1;
+};
+
 static struct mdrestore {
 	bool	show_progress;
 	bool	show_info;
@@ -78,27 +83,25 @@ open_device(
 
 static void
 read_header(
-	struct xfs_metablock	*mb,
+	union mdrestore_headers	*h,
 	FILE			*md_fp)
 {
-	mb->mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
-
-	if (fread((uint8_t *)mb + sizeof(mb->mb_magic),
-			sizeof(*mb) - sizeof(mb->mb_magic), 1, md_fp) != 1)
+	if (fread((uint8_t *)&(h->v1.mb_count),
+			sizeof(h->v1) - sizeof(h->magic), 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
 }
 
 static void
 show_info(
-	struct xfs_metablock	*mb,
+	union mdrestore_headers	*h,
 	const char		*md_file)
 {
-	if (mb->mb_info & XFS_METADUMP_INFO_FLAGS) {
+	if (h->v1.mb_info & XFS_METADUMP_INFO_FLAGS) {
 		printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
 			md_file,
-			mb->mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
-			mb->mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
-			mb->mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
+			h->v1.mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
+			h->v1.mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
+			h->v1.mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
 	} else {
 		printf("%s: no informational flags present\n", md_file);
 	}
@@ -116,10 +119,10 @@ show_info(
  */
 static void
 restore(
+	union mdrestore_headers *h,
 	FILE			*md_fp,
 	int			ddev_fd,
-	int			is_target_file,
-	const struct xfs_metablock	*mbp)
+	int			is_target_file)
 {
 	struct xfs_metablock	*metablock;	/* header + index + blocks */
 	__be64			*block_index;
@@ -131,14 +134,14 @@ restore(
 	xfs_sb_t		sb;
 	int64_t			bytes_read;
 
-	block_size = 1 << mbp->mb_blocklog;
+	block_size = 1 << h->v1.mb_blocklog;
 	max_indices = (block_size - sizeof(xfs_metablock_t)) / sizeof(__be64);
 
 	metablock = (xfs_metablock_t *)calloc(max_indices + 1, block_size);
 	if (metablock == NULL)
 		fatal("memory allocation failure\n");
 
-	mb_count = be16_to_cpu(mbp->mb_count);
+	mb_count = be16_to_cpu(h->v1.mb_count);
 	if (mb_count == 0 || mb_count > max_indices)
 		fatal("bad block count: %u\n", mb_count);
 
@@ -152,8 +155,7 @@ restore(
 	if (block_index[0] != 0)
 		fatal("first block is not the primary superblock\n");
 
-
-	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, md_fp) != 1)
+	if (fread(block_buffer, mb_count << h->v1.mb_blocklog, 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
 
 	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
@@ -200,7 +202,7 @@ restore(
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
 			if (pwrite(ddev_fd, &block_buffer[cur_index <<
-					mbp->mb_blocklog], block_size,
+					h->v1.mb_blocklog], block_size,
 					be64_to_cpu(block_index[cur_index]) <<
 						BBSHIFT) < 0)
 				fatal("error writing block %llu: %s\n",
@@ -219,11 +221,11 @@ restore(
 		if (mb_count > max_indices)
 			fatal("bad block count: %u\n", mb_count);
 
-		if (fread(block_buffer, mb_count << mbp->mb_blocklog,
+		if (fread(block_buffer, mb_count << h->v1.mb_blocklog,
 				1, md_fp) != 1)
 			fatal("error reading from metadump file\n");
 
-		bytes_read += block_size + (mb_count << mbp->mb_blocklog);
+		bytes_read += block_size + (mb_count << h->v1.mb_blocklog);
 	}
 
 	if (mdrestore.progress_since_warning)
@@ -252,15 +254,14 @@ usage(void)
 
 int
 main(
-	int 		argc,
-	char 		**argv)
+	int			argc,
+	char			**argv)
 {
-	FILE		*src_f;
-	int		dst_fd;
-	int		c;
-	bool		is_target_file;
-	uint32_t	magic;
-	struct xfs_metablock	mb;
+	union mdrestore_headers headers;
+	FILE			*src_f;
+	int			dst_fd;
+	int			c;
+	bool			is_target_file;
 
 	mdrestore.show_progress = false;
 	mdrestore.show_info = false;
@@ -307,20 +308,21 @@ main(
 			fatal("cannot open source dump file\n");
 	}
 
-	if (fread(&magic, sizeof(magic), 1, src_f) != 1)
+	if (fread(&headers.magic, sizeof(headers.magic), 1, src_f) != 1)
 		fatal("Unable to read metadump magic from metadump file\n");
 
-	switch (be32_to_cpu(magic)) {
+	switch (be32_to_cpu(headers.magic)) {
 	case XFS_MD_MAGIC_V1:
-		read_header(&mb, src_f);
 		break;
 	default:
 		fatal("specified file is not a metadata dump\n");
 		break;
 	}
 
+	read_header(&headers, src_f);
+
 	if (mdrestore.show_info) {
-		show_info(&mb, argv[optind]);
+		show_info(&headers, argv[optind]);
 
 		if (argc - optind == 1)
 			exit(0);
@@ -331,7 +333,7 @@ main(
 	/* check and open target */
 	dst_fd = open_device(argv[optind], &is_target_file);
 
-	restore(src_f, dst_fd, is_target_file, &mb);
+	restore(&headers, src_f, dst_fd, is_target_file);
 
 	close(dst_fd);
 	if (src_f != stdin)
-- 
2.39.1

