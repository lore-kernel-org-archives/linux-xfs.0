Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 594EDC4167B
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbjKGHJN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbjKGHJM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:09:12 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A7211C
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:09:09 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72NoKu031640
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:09:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=yuUbVJdFw+H8H16hakY3mw8W8115W9Nt7DeDCcpLW14=;
 b=KUcThev5T2PokcGwKAg3XP9HSQNHBXsXGM+P8u1A54HrHnRA9d5gbLSqP6owafsNw9y+
 qOmw1wukDs/e7a5ihjr9zjLVGxxk0NJyriu5ur5J6jy2jgxnNgdRNowbLZ/tUE94XvBW
 rIXgtKw7TCQgJuuqUrbVRQKX07tlU2kdFtm/KUxmoa2Ev60YdlHRHFFQXWJ0Sy5iK1Dp
 Uzdd1SX57EEOl6JwqlWSmWGROIrkyZmAjs0Sb9DJDUsOWS6CbGXxN8bFnrqw8esHdUvz
 N6AUk1iEGQUusmvXC1lreNucWiY5TWdcwA6ywbWxDkzSfrR78N5Q88Q2yNyV/ZtbbIXE Kw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cx159rm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:09:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A75xKn0024790
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:09:07 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdd1m5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:09:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hvk4cILkVlkJCR1QZv7WqG89jQEhzw/ChWwnDuh8RApHHbvsg06ylXL9B2DjDt3uayvHAL177+zsxMC/0bIkvacrzny5nycX+Mx6M8TM58gg6rYozIYQqYHG1QzdqAOiBk3LXe+KqsqA6jr1nVmeeiDdXkLawae4+xZG821kdg4Eh6YyVuZc3bPwHBDyAmxRl4tEE1LZxZKwLKwT8s1tdK4xI66rvbahgHb8eydq+CDrcrBmHB1qsHW6ThzDN6PQy7rhP5ayI8e5XaIBTk+o0A2hiiGhq2XFs1VEieCvFKdquqb1hNEjDHhtl2u9LbnZ5GBVS7skfng+La239k7nrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yuUbVJdFw+H8H16hakY3mw8W8115W9Nt7DeDCcpLW14=;
 b=Rs78suiCkfiCMoQVfLhdzpiVw+LC3FA6XckAtLmr/bz5mF1cqgQvgD7Z60CMobCFIQ4jXQm23KE9q5KpXWCFYa561PQgRK8YRyE9qg2a/s7iJk1uIPAhaZDPm9RlwEeSZkOTAbRXRgtQR33x3ngIolldnveND4b4Vw6lMTF/3jH42R3TX/ytedCynh30YZxyzWMRC/kyjPE3F+sq4+vFWymomka2As04du16vpFJOMVr3cwZgaoHXVF78PKR5Q15In+YxinoL78NPw5Kp333JhBK+y0baSmVZx9ACxKX7uIqwXdrCqqwu0AZ4/ClTUIzW4PHAIsZgohaf5YNY1ZOpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yuUbVJdFw+H8H16hakY3mw8W8115W9Nt7DeDCcpLW14=;
 b=o3Z0GYgMBkkwEiVW5ynwg5ikfzZOBISwWZ2Amde6MhgMoeyYD5drXI+l8HRwzTCrtub9sSxZlPOEiLWaUqYMeX0NwuiN9urvmbJQVcXWacJmNIMLDyWLj9CQSd+fAgwbv2vzu0JMkRK7BHoOmzhbHOSAB+v/jkBGu9p4RB8CcRg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Tue, 7 Nov
 2023 07:09:05 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:09:05 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 18/21] mdrestore: Introduce mdrestore v1 operations
Date:   Tue,  7 Nov 2023 12:37:19 +0530
Message-Id: <20231107070722.748636-19-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::6) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: a0902609-e86d-4b3f-36f6-08dbdf606d97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mx/d43cC/Bo+PIPJLGnobdxuznFFG1jajGPfJ80KXhy97Ziigb5K31IpciGFb6eak1meJNX4EEYwOLjbjD9EkTQJ3piycRun36FKDof5NH642SwIKHI2gyKqJxWQdC41ebPn4+yfTRVhVDTYcg4tVooyrNX1jaEkohP12n08SGqlLLOqF42QpqWP546e+3ltS+c2cePF4Bo1IKAGtqwHfkdBk+9b5PMCFBn7DFqH6Djez+dR6+ikMQJe/SGRPcHlPmOPAunTJSaalPINiKbtUM2l70i300eRIXPpUppS+mB/ATl8MLKi2Xbeccf8sfe21yozOge5+/xB/C9AagkFx9lhlOXxVve9xvjc5dF/hR1beQoxPrwngzuqmsifv5ajdhVqMp3l25JjrCdy1nLfhiqcJRVWvAXDrulgXcYNxMC3W4vSaDl/d22+URow3t+b4DWArSejusbSF4B3BSW3tow+iAF3BTtsCWZnHJw4wEwVTIQAaNs3376VoiLexKd5XypKFR+olR/RQZ1h7/ujw+FLyydXzsz9xjRF2+gCJmPHukvH6K8kEawynzH87h3VayNf26ne724iJ3qZMG8UcUpr0Vr2d+86I4X9My/DTYehgewssKwahIISgtwLdamW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(136003)(39860400002)(396003)(230273577357003)(230173577357003)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(2616005)(41300700001)(6512007)(1076003)(8676002)(26005)(478600001)(6486002)(8936002)(5660300002)(36756003)(86362001)(2906002)(66946007)(66556008)(6916009)(316002)(66476007)(6666004)(6506007)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yody4murA+nPbuI9fz7f6sMEwOzabILcy437tD0TfvEU+sxXOfu2vwlfsXIU?=
 =?us-ascii?Q?VyQdcZ4k8kii7muUSS37DQVX2axhdiT0eHNYPsiR6BOl3/RSyWR/HARoR/qQ?=
 =?us-ascii?Q?E0JLSebkLsL4u5aK7uvC1K8whQYzDnY1w4FcDgcXLyHc/S6WYMEAQQ/kf2Od?=
 =?us-ascii?Q?2+EmwdRZEkZNJjxe5q/n9UZONNlnbHO6FjUTRBuOhoeakJ1SAnAEx4TtC3jv?=
 =?us-ascii?Q?ZD7hH1NKCfU1mvfzCzYzxfWxSPIqvxtLXIf4ceY/HDQN6N4f2+ImrdLuvz08?=
 =?us-ascii?Q?EtFP6ZR1amuTLpRjl0TXaOyHtfSwByEXf2w1Y0tiXqB+6Lnmw+AQAgzzpEB9?=
 =?us-ascii?Q?cvrDTHjsn6ifFH7yT46cTkpChzKS/xabmm8SeCrZzu8o9PKg1/jABEhQiUIb?=
 =?us-ascii?Q?e3Nwx8n0dRh82m40Fjz77/8FbpD6/6BtIn5MEaVW+FZn8zLwrX+wtfBYdBYw?=
 =?us-ascii?Q?T2qGnZJhLIgN8KjVlBrPRYqT3ql21aSnsGbCQ6wF47KVuI/fAwQq369TEW18?=
 =?us-ascii?Q?sBAAZbcaPyNhy2bodVK5wQWvOF652kkD0HKKSm6IyV/i9cn73MUdUoFbdocB?=
 =?us-ascii?Q?Ug62vLObEZmq/A8X3rJUIVywyPF9iTTOO4FDZoinE9tBYzd2JPQ5HUdOQh2k?=
 =?us-ascii?Q?aejOh39iVSz91IZIxqw1IaAB3A03LSQC0IkLo+Nz1U26GfpEt0k2d1/6cz2s?=
 =?us-ascii?Q?PblAaN9JMtIghnQyJC1LJKOxmlMG8DPtYXmA+/q0cTOs5lHS4IhBy+LtVBO6?=
 =?us-ascii?Q?Y9axl/twPpKyhoCukzJ3sX9FwGCY6fOZYvhQS+OFP3pwo1sfuPNLcNfPCcRu?=
 =?us-ascii?Q?tkrNiLGxv2O4dm1Shky2pkICmWA8LI6sMVCi4DTZD/q5xAW7UFFPtoQ9+n6J?=
 =?us-ascii?Q?g3W6JcxpftiuUSfV7dlydtNB0zSNiYLH1QsLBGNneJr0o2IkFYU541kmHMJk?=
 =?us-ascii?Q?/b9V+GC39DGtiR5QB+zTrZH6xoYx7elzqHDn/j2wRPZuVD7VI56w+ANOTPt+?=
 =?us-ascii?Q?+myG4B35XDzMEIqz0jg/V/bxRemXUKgFPXDBciQdgIrrrajRLFksehqtLqix?=
 =?us-ascii?Q?2/zTFboHVSZ4yX9KBmMA3kvCNdzL3Bb9MSXlH9ypRLmR4VJm8xeBbPR86ZNC?=
 =?us-ascii?Q?rvdrkWtJH2fUACGzQnupRIYA50TG/HHHSaLbpKc3IDAc/6o0EsDJFoNyWldr?=
 =?us-ascii?Q?wqSTQu1RGN8cuy5q3bjG87ESrlbcgAmf+cjgWAwRvhsd0e33UadT/uO0lrQs?=
 =?us-ascii?Q?S9voEaE6MhE59e+n6q/aBCCLoCwuxvMlfPKQepq2GzEa1o228siR7mTPq+CK?=
 =?us-ascii?Q?5G+wgij8lr7n13t89eR5WXMcbWt0uuB/P9EjIkvq5MYO/6MalzHa2+iI42UX?=
 =?us-ascii?Q?2YlHqKSypKqKd4KecgPYfy7GRTPwL02tmcwMioTGDmh8GVZBpzXhUKuz6b8Q?=
 =?us-ascii?Q?K8x6//s3bVezRo5OLCV0yso8hi0r9Ox8FOgXtxcSsgcs9hl1/xP23ZaemL7l?=
 =?us-ascii?Q?j2JUR1UMwb8tBChFqE+KvqqQsVrXOUzsMijw1MGTv5aazRyyTIQie128MxWI?=
 =?us-ascii?Q?VKe81EuQ3L4hSX34L30JDRPApv8HxBuAjSEKpDIeiDIe4jDIQ/v+vi5zqmCZ?=
 =?us-ascii?Q?DQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XBv3OTUDJkD8zxdlUpb2VO779Yq0fTqmyWPT3+DiSoJR/TXQPi32nJz1yDDLZs+TaTrTzcqiuNbiN2+5d9Am8yoBOwBEwAbiaLLHyWdKRHihmMLus9bP5JMLoR072iEctRqITrgw+Aj4ucuv+k39XJZeD3vyETaQ0jOR9meHdFs4YAce9RwgQhXeC1Ik25NnYtg4xwiJV9eJZb3wLpiKFQX+T6fiIvNKdq4q09u5rSh3YAPFwo/6DzUdUt/YU5Hajz+wNbHiRh+6G/UYYCDmrtICdWexPHL3yJYxr7B2qRwXjGLkPmaRBQ3pubhKi5+WNngPJS38nK3DziH6IWqbstmXh6ypttALl6i+YeUnL0gur82SJAw0ADT4qW7xu5tUBKqFZtrV/+aZ4B2lgiW/RpPyeS2UegGLJkcDH1FqQiTwSLVESPDWiiAV3UfJbKYPNur6u72RO5AT+4AKaAmZXTm/jCbcm3QsfFg7sX0GqzF8uDO0gdhGnqiTTDkylZ9BokM73EHsQP+ao6mpdEY4Lq7z53gyl9wqmPyFUYNVgabiP1zDgl8o4GcgF2pKbMQ7s9SUXuQCxoJlpDd8+FqZGEzJFDlol7Ygs8Ks8plG1Zqg5Yc8hAuJ/bMA49tlHwZal83AZbTslnuoXjJge8wzzKBuSn8/hdMcYjtOM6021BgygdAraORJvGh3TCXYmhWqkWqJm9J2RgCY5/8czSih9oNk9oGVeGkLWj1eA3hCD3OjJbghdRgrQ406VWGp8BtIUFDkpYFbMVmTncmRLQ02IQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0902609-e86d-4b3f-36f6-08dbdf606d97
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:09:05.4121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PoQiTiLAwcozZU1q+LUoV2KrJofn4n16YIaKuHZfcl9o+vRHElxCzvo6Ym3qM6yD0Sf5J9sdH95vj1sV7tUDUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311070058
X-Proofpoint-GUID: wwnGtUWxkBbpyHB1qXqlsmDFle4gPDi8
X-Proofpoint-ORIG-GUID: wwnGtUWxkBbpyHB1qXqlsmDFle4gPDi8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order to indicate the version of metadump files that they can work with,
this commit renames read_header(), show_info() and restore() functions to
read_header_v1(), show_info_v1() and restore_v1() respectively.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 51 +++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 40de0d1e..b247a4bf 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -13,10 +13,18 @@ union mdrestore_headers {
 	struct xfs_metablock	v1;
 };
 
+struct mdrestore_ops {
+	void (*read_header)(union mdrestore_headers *header, FILE *md_fp);
+	void (*show_info)(union mdrestore_headers *header, const char *md_file);
+	void (*restore)(union mdrestore_headers *header, FILE *md_fp,
+			int ddev_fd, bool is_target_file);
+};
+
 static struct mdrestore {
-	bool	show_progress;
-	bool	show_info;
-	bool	progress_since_warning;
+	struct mdrestore_ops	*mdrops;
+	bool			show_progress;
+	bool			show_info;
+	bool			progress_since_warning;
 } mdrestore;
 
 static void
@@ -82,7 +90,7 @@ open_device(
 }
 
 static void
-read_header(
+read_header_v1(
 	union mdrestore_headers	*h,
 	FILE			*md_fp)
 {
@@ -92,7 +100,7 @@ read_header(
 }
 
 static void
-show_info(
+show_info_v1(
 	union mdrestore_headers	*h,
 	const char		*md_file)
 {
@@ -107,22 +115,12 @@ show_info(
 	}
 }
 
-/*
- * restore() -- do the actual work to restore the metadump
- *
- * @src_f: A FILE pointer to the source metadump
- * @dst_fd: the file descriptor for the target file
- * @is_target_file: designates whether the target is a regular file
- * @mbp: pointer to metadump's first xfs_metablock, read and verified by the caller
- *
- * src_f should be positioned just past a read the previously validated metablock
- */
 static void
-restore(
+restore_v1(
 	union mdrestore_headers *h,
 	FILE			*md_fp,
 	int			ddev_fd,
-	int			is_target_file)
+	bool			is_target_file)
 {
 	struct xfs_metablock	*metablock;	/* header + index + blocks */
 	__be64			*block_index;
@@ -245,6 +243,12 @@ restore(
 	free(metablock);
 }
 
+static struct mdrestore_ops mdrestore_ops_v1 = {
+	.read_header	= read_header_v1,
+	.show_info	= show_info_v1,
+	.restore	= restore_v1,
+};
+
 static void
 usage(void)
 {
@@ -294,9 +298,9 @@ main(
 
 	/*
 	 * open source and test if this really is a dump. The first metadump
-	 * block will be passed to restore() which will continue to read the
-	 * file from this point. This avoids rewind the stream, which causes
-	 * restore to fail when source was being read from stdin.
+	 * block will be passed to mdrestore_ops->restore() which will continue
+	 * to read the file from this point. This avoids rewind the stream,
+	 * which causes restore to fail when source was being read from stdin.
  	 */
 	if (strcmp(argv[optind], "-") == 0) {
 		src_f = stdin;
@@ -313,16 +317,17 @@ main(
 
 	switch (be32_to_cpu(headers.magic)) {
 	case XFS_MD_MAGIC_V1:
+		mdrestore.mdrops = &mdrestore_ops_v1;
 		break;
 	default:
 		fatal("specified file is not a metadata dump\n");
 		break;
 	}
 
-	read_header(&headers, src_f);
+	mdrestore.mdrops->read_header(&headers, src_f);
 
 	if (mdrestore.show_info) {
-		show_info(&headers, argv[optind]);
+		mdrestore.mdrops->show_info(&headers, argv[optind]);
 
 		if (argc - optind == 1)
 			exit(0);
@@ -333,7 +338,7 @@ main(
 	/* check and open target */
 	dst_fd = open_device(argv[optind], &is_target_file);
 
-	restore(&headers, src_f, dst_fd, is_target_file);
+	mdrestore.mdrops->restore(&headers, src_f, dst_fd, is_target_file);
 
 	close(dst_fd);
 	if (src_f != stdin)
-- 
2.39.1

