Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F35F7C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbiERANA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbiERAMs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:12:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B564832E
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:12:47 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKaJY7023098
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=7aETQSeovQWVVKiqh91yu2tm9ZS0HN77VRS3OfTBMOU=;
 b=BsOByFhtemLS1Ui34b88jO0tO6PO3MXiMwt4ESQhSFhS/q8WtR35pD9bAs0K7EjoyqSE
 rdZmsAtG7KndFdcLgwTNVjEqx0UrHF5/3L2khc7bKvEtK3Op1gBfqmzcKl66IZH145ee
 RwWonr2/v+mX8SDwtCWOv2ugXlL5S5Mk6Z0lD7Cyh6s9B0o4XGDcLc/lnwWyfwOJky5F
 EqOe+1fK+tK1hdWiGuA9REBwSOQQXc56ZQUwEQYT94YKye8r7+maGFqeKvCdFciqDTY2
 x8aORV/oGc/PwjW8bIhJHj/IrfMzpkliSoFn8pkvA7Q2+RSCVL5KolsaWLjvOXjfgXDM Kw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241s7ss5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:46 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I0BXpl017045
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v3ebar-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XcZgt6EdVUd/1gkdOqUsCetXPideoIry4zOVKvpNSkq+JTP7EbFq/R0TOL8IaqVH/P0s0hvDyqDAmBVu3bjI8lgGxil3VIojUVZpULDlb4RFS3xZfeMvkcToj+0xX2u1Y4RyQW9kGKOmexJ3z9Q/bJRT7EaP0spu0EFlR4xMKV1bCQtfKy6YG4oQB9pUeQRojMLB9Sp8ifbmD5Un3tHiX/aXICNG9Kcol6l7sYMFfqBDsUwDlhEdrQhGXs7Z+7weWrk0Zy9tUiNfuyM0yLNediNq8xY+eps2q4M0saZnaSYp5J2rHzC5fKnYx2ldlOjLWBGpUuPrT7A2wf8wvzO3/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7aETQSeovQWVVKiqh91yu2tm9ZS0HN77VRS3OfTBMOU=;
 b=jCOpJ53uvb4kraYX8zEZurdb40d9oJVdIqiY2Uh3xBuJ+tpOqZTob36Bd+QDJDYLyCWb5TD16Te+A4P7YHqJ2HNkkAMKxE+Ht0C6r3B5TZ3rJEllCn3a7JSbMjZEYZEOo72jCySCU49zVzCejSnlM/XMG4BfDQQGDVS1WSCVhQ55qL4M6yJmcqjL0glrZt0kf8FVMq3g5z22g9mJJKHOsd2hXDJqlQxzUo2UbYze9XXBtiUIQrvmBLR/9Kjto7zk/rHS5PvkMd68WkhpJikEREHLIE18Alq0FA2gXziK+KSkOH+FyN86QP5Iv62OP9XFRmLC+5vvxPd/alxKXFDpcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7aETQSeovQWVVKiqh91yu2tm9ZS0HN77VRS3OfTBMOU=;
 b=CTtowxNqNYHkun3ui/uUcZAqCMRWk+OpzuB7rvW3x4fkTPE+ZpgBHLV1C66Z4KcF2QSHKl5mBohV34OgF9X6xfPbgFH8z0McVwbvAnTa6sJQZz6LWMTWQ/A5KBVoJAvzt3qjJ/DEw1AKqaYsRwPqDD2DEAxCoYFI65GevxKAl7k=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1528.namprd10.prod.outlook.com (2603:10b6:903:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 00:12:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 00:12:43 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 18/18] xfsprogs: Add log item printing for ATTRI and ATTRD
Date:   Tue, 17 May 2022 17:12:27 -0700
Message-Id: <20220518001227.1779324-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518001227.1779324-1-allison.henderson@oracle.com>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34a2beff-d448-46c9-825b-08da38632042
X-MS-TrafficTypeDiagnostic: CY4PR10MB1528:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB15287BCF9AD8479546323FBE95D19@CY4PR10MB1528.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BcogxE/FoXX84YF1dehcmuTT+t0SHGR7ve3VfrLY1dawOqL0OdZlSriniV7KJU9PzylGeKhm+gTljYqANdjuUdEU6YaINlq+mXbEGVj5PKUCaxIzX1aQzQEXc4FBeNdhBjij+ff0fggym6MK/qxWchcI/Jmw/LnYfEom3AWg8J8myVyHvDkUUzLM4jtT3e0LyGWgzUJl4js0mWHsIYE4miiLA4FzSgpbFPmlV5rmWXZXsQhxc4xLTRb+0dWqEnQBmYRGfcigswZfGLopkDmQERIFbiZHI6BC+D4ijOnITWQ8t27dKafcCgUeC/eTVK4O4z6H3dn2j5dULAoadf8Jgc7bUqB8gbbonEaIq+njjQRifLNhH1W4uR4R+HSVA22vimo43B75VGczYH9HYsqN2abHl/lZ0iOyB3rBUuQO0KbZHU63/rW0Jdnlia1F8YlXy3OLpU22iPrgt+zuy3TvlCGWSddjZxP6cZ865c9/j4UpdbvH9AuUU7lCjEyzkROkKxiPuEJwrkETKrfOO5DkvG5ez0PcWq/Gbd7hhUCDXyFJ/gd/qUhh2v8Izcdtu2gkduKOuRYd75QtnCPFFoEo/Yz23S2xEUfjaunrc8kE9v9/qRYX4BxHmoIEJJsKYJEemIn1670hJmh3XLr9W0ur+W4kF9YGrgZX9FSbJ2lfHylo9KtmcPS8o1o3cD18WJ/zdmNeF1cVdBYb8MUxWNXjnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(38350700002)(38100700002)(6506007)(26005)(6666004)(6916009)(66946007)(44832011)(2616005)(2906002)(5660300002)(52116002)(316002)(66556008)(8676002)(66476007)(6512007)(6486002)(186003)(86362001)(1076003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FeWTuY+jkTCMr2NTKfDFhTnBCa56HPo2kBJTZuN1JVTCJSFZxGFB7wigOxGL?=
 =?us-ascii?Q?5HwYkGJp1wVASOdPPapN11U0fL/edYI89wNqkCiF4BIt41FHhmN1Yn8Q5ABW?=
 =?us-ascii?Q?B8OqjRw0mj3Mc460RKTfWei1KmVB25pg51dUkkE3JOYn3M3bopAxUtxObO+b?=
 =?us-ascii?Q?4lezPEY4u9vBoaOUZUSLYAoGeFbNxespfd8yhnyenX4rRJqDXDYWOq6pkLg6?=
 =?us-ascii?Q?JhprSDl8PihtIH5Z8kwrNCu2Ll4XVbJmQ/mOYMdjvJOjHPikZbZg2v87TI0Z?=
 =?us-ascii?Q?P0qtnUJ3Z35uw4WuzoOo4+NHTVMmREsoJQW2D1FDk6oJ+CTDXolKOoa5hq40?=
 =?us-ascii?Q?BBydUti6APfgJEWSClL01V2vE9lhkE3uYtnn+j6P8luZvmqKd9CG2InJstbP?=
 =?us-ascii?Q?1jXBwbwCLUOTSf5UdA5wRnbYi+lAgRX0vieRnd1ZciC/ZMzPmMsxD3BoiKKc?=
 =?us-ascii?Q?otP6tSkf7nihR6C2psECo6ylswIBTtyujbfeElRUfZ2hsNPSdvYpKNW59O0o?=
 =?us-ascii?Q?WjyS7cnrJft3EoBTjPMPj5K4RahuP9K4CLJPIt84wS/Nk6AfjoZA/Bgtycv2?=
 =?us-ascii?Q?pJDHMxZuWDUYFGOrFcRtdGsTIrEkqZ65dOB1Q5CKuyur5FszYGYrAjvwi+EI?=
 =?us-ascii?Q?4XbHgl+/KIE12OVhUMEkc4rrKTrnIEWpt0v/TZNABKBhujSh5D7nznmmvfHg?=
 =?us-ascii?Q?ghgVWcTEuGGmlFxQs+EppTbDkbBIeVqnDK3j24r9lFxbMs8OKm6gyyFcAQSK?=
 =?us-ascii?Q?w8SamtoPvnzl0xcMAD/Srxp2JuMbFOlSkdNZOrCu5c04PpIz0J8jsm6Ealpl?=
 =?us-ascii?Q?YMnoV0CPxblPv3BzIKMWmnnIUrsHRA5pdl6AWCUZqoFd4aB0E2do/XZ+y7s+?=
 =?us-ascii?Q?KUeOfOqoG78fWwclPZYV2zp7cYxmJDPcMbLqpQ76quMxqDFRlKD87F+4FOOf?=
 =?us-ascii?Q?92q0jfBpHYDO5dR0b0oabBcc9t1FRHfkcXMqggV1asbJ4nkfsKE3eJovnFof?=
 =?us-ascii?Q?swVE2eVNqZMQWMYCAv9bSykpo7lvCmDLpq827hNxd4K534KufVUTvytFhVy5?=
 =?us-ascii?Q?eV8QxMqvq71yYaaVTz4ZtKvtWXgKLOPQdhzlhT7kTa7Ukdr8+N/gAKrz3DKQ?=
 =?us-ascii?Q?pWXiJMWHjibckf9hHYLGA9dFifs2UaisC1CmNRoCjtOQsQQAzLY0DDJ8A58j?=
 =?us-ascii?Q?6WQgy9Ad/PKuX6+q/Z3B2UUy1QcWWHuJoT1C/q4SawsYWEpIAsnrMo5GXfe5?=
 =?us-ascii?Q?uvxsr0m/xiGLg70VOGfFuqLps9kVowvxt72tR/YmOh6tZpXLJ2RMrHBRX4D7?=
 =?us-ascii?Q?2C/XVE5n1VUBRKyIM1l2tZCqzO2Pk6ctEVf1oYTnUVm7v5NTjQPE7+/Q4D9e?=
 =?us-ascii?Q?p4mUjtb5rLD/0AQva0+xommNQZcHSy8yvjmYhBPKRKYggkqdt/LdXjKV4hNv?=
 =?us-ascii?Q?W+sSRdO3tslo51o9Li6ZMM87iBjZTstn0y9cgy7He/wt+YG7r5v0KzhcmDB3?=
 =?us-ascii?Q?RPm2X3KXfXDAyqtn7XV2oG9mJ+0E+Fytp2ggep9mRomVDS0XLdqs6IMGqVFw?=
 =?us-ascii?Q?lwiexo/ewyKHuDPMfyhC7wRKYftEDwyf0GRhwDORhv/4YFmW+xRYUcCrinu8?=
 =?us-ascii?Q?bRJFRbH6MeqyGFeSh7a96iJQiWmlj0IDdvzlzCGtu9JgjBOexi8Gq/dezN2E?=
 =?us-ascii?Q?4GS3OmxvXLqlIcJ7SgBE+sLp9fZdBcnhGgdcKbCLtXoWn7sTYrzE4d9xn++T?=
 =?us-ascii?Q?DM6Jr4PqJy+uF4m3H5Qfsuci4Qxsq6I=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a2beff-d448-46c9-825b-08da38632042
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 00:12:42.2681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gz/URojOchkXYkt804bPXbmwzWHrjUDkEJU+QTg6dx5WEwIIRT6mwR+zXLQgcTHVTwMjLbW0re/bUyXrnEJRTrJngMnZsAT0WgIqHU063Bk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170143
X-Proofpoint-GUID: 1RSgEKkJ1tzG0klcJjU3NJFfepgF-iJQ
X-Proofpoint-ORIG-GUID: 1RSgEKkJ1tzG0klcJjU3NJFfepgF-iJQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch implements a new set of log printing functions to print the
ATTRI and ATTRD items and vectors in the log.  These will be used during
log dump and log recover operations.

RFC: Though most attributes are strings, the attribute operations accept
any binary payload, so we should not assume them printable.  This was
done intentionally in preparation for parent pointers.  Until parent
pointers get here, attributes have no discernible format.  So the print
routines are just a simple print or hex dump for now.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 logprint/log_misc.c      |  48 +++++++++-
 logprint/log_print_all.c |  12 +++
 logprint/log_redo.c      | 197 +++++++++++++++++++++++++++++++++++++++
 logprint/logprint.h      |  12 +++
 4 files changed, 268 insertions(+), 1 deletion(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 35e926a3baec..d8c60388375b 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -54,11 +54,46 @@ print_stars(void)
 	   "***********************************\n");
 }	/* print_stars */
 
+void
+print_hex_dump(char *ptr, int len) {
+	int i = 0;
+
+	for (i = 0; i < len; i++) {
+		if (i % 16 == 0)
+			printf("%08x ", i);
+
+		printf("%02x", ptr[i]);
+
+		if ((i+1)%16 == 0)
+			printf("\n");
+		else if ((i+1)%2 == 0)
+			printf(" ");
+	}
+	printf("\n");
+}
+
+bool
+is_printable(char *ptr, int len) {
+	int i = 0;
+
+	for (i = 0; i < len; i++)
+		if (!isprint(ptr[i]) )
+			return false;
+	return true;
+}
+
+void print_or_dump(char *ptr, int len) {
+	if (is_printable(ptr, len))
+		printf("%.*s\n", len, ptr);
+	else
+		print_hex_dump(ptr, len);
+}
+
 /*
  * Given a pointer to a data segment, print out the data as if it were
  * a log operation header.
  */
-static void
+void
 xlog_print_op_header(xlog_op_header_t	*op_head,
 		     int		i,
 		     char		**ptr)
@@ -961,6 +996,17 @@ xlog_print_record(
 					be32_to_cpu(op_head->oh_len));
 			break;
 		    }
+		    case XFS_LI_ATTRI: {
+			skip = xlog_print_trans_attri(&ptr,
+					be32_to_cpu(op_head->oh_len),
+					&i);
+			break;
+		    }
+		    case XFS_LI_ATTRD: {
+			skip = xlog_print_trans_attrd(&ptr,
+					be32_to_cpu(op_head->oh_len));
+			break;
+		    }
 		    case XFS_LI_RUI: {
 			skip = xlog_print_trans_rui(&ptr,
 					be32_to_cpu(op_head->oh_len),
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 182b9d53aaaa..79d37a2d28b7 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -404,6 +404,12 @@ xlog_recover_print_logitem(
 	case XFS_LI_EFI:
 		xlog_recover_print_efi(item);
 		break;
+	case XFS_LI_ATTRD:
+		xlog_recover_print_attrd(item);
+		break;
+	case XFS_LI_ATTRI:
+		xlog_recover_print_attri(item);
+		break;
 	case XFS_LI_RUD:
 		xlog_recover_print_rud(item);
 		break;
@@ -456,6 +462,12 @@ xlog_recover_print_item(
 	case XFS_LI_EFI:
 		printf("EFI");
 		break;
+	case XFS_LI_ATTRD:
+		printf("ATTRD");
+		break;
+	case XFS_LI_ATTRI:
+		printf("ATTRI");
+		break;
 	case XFS_LI_RUD:
 		printf("RUD");
 		break;
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 297e203d0976..502345d1a842 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -653,3 +653,200 @@ xlog_recover_print_bud(
 	f = item->ri_buf[0].i_addr;
 	xlog_print_trans_bud(&f, sizeof(struct xfs_bud_log_format));
 }
+
+/* Attr Items */
+
+static int
+xfs_attri_copy_log_format(
+	char				*buf,
+	uint				len,
+	struct xfs_attri_log_format	*dst_attri_fmt)
+{
+	uint dst_len = sizeof(struct xfs_attri_log_format);
+
+	if (len == dst_len) {
+		memcpy((char *)dst_attri_fmt, buf, len);
+		return 0;
+	}
+
+	fprintf(stderr, _("%s: bad size of attri format: %u; expected %u\n"),
+		progname, len, dst_len);
+	return 1;
+}
+
+int
+xlog_print_trans_attri(
+	char				**ptr,
+	uint				src_len,
+	int				*i)
+{
+	struct xfs_attri_log_format	*src_f = NULL;
+	xlog_op_header_t		*head = NULL;
+	uint				dst_len;
+	int				error = 0;
+
+	dst_len = sizeof(struct xfs_attri_log_format);
+	if (src_len != dst_len) {
+		fprintf(stderr, _("%s: bad size of attri format: %u; expected %u\n"),
+				progname, src_len, dst_len);
+		return 1;
+	}
+
+	/*
+	 * memmove to ensure 8-byte alignment for the long longs in
+	 * xfs_attri_log_format_t structure
+	 */
+	src_f = malloc(src_len);
+	if (!src_f) {
+		fprintf(stderr, _("%s: xlog_print_trans_attri: malloc failed\n"),
+				progname);
+		exit(1);
+	}
+	memmove((char*)src_f, *ptr, src_len);
+	*ptr += src_len;
+
+	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id: 0x%llx\n"),
+		src_f->alfi_size, src_f->alfi_name_len, src_f->alfi_value_len,
+				(unsigned long long)src_f->alfi_id);
+
+	if (src_f->alfi_name_len > 0) {
+		printf(_("\n"));
+		(*i)++;
+		head = (xlog_op_header_t *)*ptr;
+		xlog_print_op_header(head, *i, ptr);
+		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len));
+		if (error)
+			goto error;
+	}
+
+	if (src_f->alfi_value_len > 0) {
+		printf(_("\n"));
+		(*i)++;
+		head = (xlog_op_header_t *)*ptr;
+		xlog_print_op_header(head, *i, ptr);
+		error = xlog_print_trans_attri_value(ptr, be32_to_cpu(head->oh_len),
+				src_f->alfi_value_len);
+	}
+error:
+	free(src_f);
+
+	return error;
+}	/* xlog_print_trans_attri */
+
+int
+xlog_print_trans_attri_name(
+	char				**ptr,
+	uint				src_len)
+{
+	printf(_("ATTRI:  name len:%u\n"), src_len);
+	print_or_dump(*ptr, src_len);
+
+	*ptr += src_len;
+
+	return 0;
+}	/* xlog_print_trans_attri */
+
+int
+xlog_print_trans_attri_value(
+	char				**ptr,
+	uint				src_len,
+	int				value_len)
+{
+	int len = value_len;
+
+	if (len > MAX_ATTR_VAL_PRINT)
+		len = MAX_ATTR_VAL_PRINT;
+
+	printf(_("ATTRI:  value len:%u\n"), value_len);
+	print_or_dump(*ptr, len);
+
+	*ptr += src_len;
+
+	return 0;
+}	/* xlog_print_trans_attri_value */
+
+void
+xlog_recover_print_attri(
+	struct xlog_recover_item	*item)
+{
+	struct xfs_attri_log_format	*f, *src_f = NULL;
+	uint				src_len, dst_len;
+
+	int				region = 0;
+
+	src_f = (struct xfs_attri_log_format *)item->ri_buf[0].i_addr;
+	src_len = item->ri_buf[region].i_len;
+
+	/*
+	 * An xfs_attri_log_format structure contains a attribute name and
+	 * variable length value  as the last field.
+	 */
+	dst_len = sizeof(struct xfs_attri_log_format);
+
+	if ((f = ((struct xfs_attri_log_format *)malloc(dst_len))) == NULL) {
+		fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
+			progname);
+		exit(1);
+	}
+	if (xfs_attri_copy_log_format((char*)src_f, src_len, f))
+		goto out;
+
+	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id: 0x%llx\n"),
+		f->alfi_size, f->alfi_name_len, f->alfi_value_len, (unsigned long long)f->alfi_id);
+
+	if (f->alfi_name_len > 0) {
+		region++;
+		printf(_("ATTRI:  name len:%u\n"), f->alfi_name_len);
+		print_or_dump((char *)item->ri_buf[region].i_addr,
+			       f->alfi_name_len);
+	}
+
+	if (f->alfi_value_len > 0) {
+		int len = f->alfi_value_len;
+
+		if (len > MAX_ATTR_VAL_PRINT)
+			len = MAX_ATTR_VAL_PRINT;
+
+		region++;
+		printf(_("ATTRI:  value len:%u\n"), f->alfi_value_len);
+		print_or_dump((char *)item->ri_buf[region].i_addr, len);
+	}
+
+out:
+	free(f);
+
+}
+
+int
+xlog_print_trans_attrd(char **ptr, uint len)
+{
+	struct xfs_attrd_log_format *f;
+	struct xfs_attrd_log_format lbuf;
+	uint core_size = sizeof(struct xfs_attrd_log_format);
+
+	memcpy(&lbuf, *ptr, MIN(core_size, len));
+	f = &lbuf;
+	*ptr += len;
+	if (len >= core_size) {
+		printf(_("ATTRD:  #regs: %d	id: 0x%llx\n"),
+			f->alfd_size,
+			(unsigned long long)f->alfd_alf_id);
+		return 0;
+	} else {
+		printf(_("ATTRD: Not enough data to decode further\n"));
+		return 1;
+	}
+}	/* xlog_print_trans_attrd */
+
+void
+xlog_recover_print_attrd(
+	struct xlog_recover_item		*item)
+{
+	struct xfs_attrd_log_format	*f;
+
+	f = (struct xfs_attrd_log_format *)item->ri_buf[0].i_addr;
+
+	printf(_("	ATTRD:  #regs: %d	id: 0x%llx\n"),
+		f->alfd_size,
+		(unsigned long long)f->alfd_alf_id);
+}
diff --git a/logprint/logprint.h b/logprint/logprint.h
index 38a7d3fa80a9..b4479c240d94 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -29,6 +29,9 @@ extern void xfs_log_print_trans(struct xlog *, int);
 extern void print_xlog_record_line(void);
 extern void print_xlog_op_line(void);
 extern void print_stars(void);
+extern void print_hex_dump(char* ptr, int len);
+extern bool is_printable(char* ptr, int len);
+extern void print_or_dump(char* ptr, int len);
 
 extern struct xfs_inode_log_format *
 	xfs_inode_item_format_convert(char *, uint, struct xfs_inode_log_format *);
@@ -53,4 +56,13 @@ extern void xlog_recover_print_bui(struct xlog_recover_item *item);
 extern int xlog_print_trans_bud(char **ptr, uint len);
 extern void xlog_recover_print_bud(struct xlog_recover_item *item);
 
+#define MAX_ATTR_VAL_PRINT	128
+
+extern int xlog_print_trans_attri(char **ptr, uint src_len, int *i);
+extern int xlog_print_trans_attri_name(char **ptr, uint src_len);
+extern int xlog_print_trans_attri_value(char **ptr, uint src_len, int value_len);
+extern void xlog_recover_print_attri(struct xlog_recover_item *item);
+extern int xlog_print_trans_attrd(char **ptr, uint len);
+extern void xlog_recover_print_attrd(struct xlog_recover_item *item);
+extern void xlog_print_op_header(xlog_op_header_t *op_head, int i, char **ptr);
 #endif	/* LOGPRINT_H */
-- 
2.25.1

