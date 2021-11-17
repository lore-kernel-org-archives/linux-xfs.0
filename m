Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9768BC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79B3261B6F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhKQETc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:19:32 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:37678 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233035AbhKQET0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:19:26 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH253cB003491
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=GR4XCYXvLgbL1fxPmTvIzDj3iT8+SxOiNbFMIA5Wbo0=;
 b=EUK6KHTBVYLb1XnbZbbo7ov4PnFEwy8lS3/xe+QLBW7aEvxHui6kpVbhEQUIT+JH37Dj
 7QRWSVrrTX7kpLAK1x4Q5DlCU49lU9xV2SDxWLuLKuJbE5nZAgJS0kM5PaeWIkckA5Jj
 8vhYTLk1dq8kSu1tuM6PqGMAD+lQfX/iCdEipk0jCsixSFXe0bSoZDhzJT7LTNGMw5ig
 YsnmUucNrjP2ziM2e22KkefGCe9X5arvYdsFhXoFsvnYL6YRf9nQv01KXdX0QR+PytCs
 hY8ptTl8ePCvesDaaR+y4qStjMIB8Ev8ddU47M5KrsH3G20DLq7LfBC8uhlWhvJymObD PA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhv5dru8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4Aehh037362
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3020.oracle.com with ESMTP id 3ca566dagu-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=la0xolBa5z8Us1yMsMliQku35DHNZ8nifOiMjcEBYNDRBaybvLYJTwffBtTuhCcIynqGtgs19XzPYn4BHyjMDdDVy/mbMWNW9T8KMEzheGOjgNt32jKV0jLXAiu+ihCsyqBEJUpP2yqw3IOcmY8mp5oFAma1eAeGBPPHsxVFCsQfFhTU/LDFc+/i5A+vhpMO36JD9+WLJyKb4oixHzNLkqV6vwwpaia8fwltpQXK0E0qLHz4hT9Ash/gKtX6eavT570yPQxqZURA953hc0rNMGUGik4cTqtUz/H06n7olEGeRx2uLF4IrCowusqxQU51ep7XtP5I1h22sm7CN4ldEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GR4XCYXvLgbL1fxPmTvIzDj3iT8+SxOiNbFMIA5Wbo0=;
 b=DxtgLBHiomxSBCY5pAt+xE4/+JbJvUylnbALTZ7voAOHH7oFMW0yjH+IMRkZD9w5l3t4qWQ5irehx8dW5vo2dIhRmfVMetvicCM8vCMRi39Y4oki/oGQeMKRmx5LjkRaJGj+zbm/Unl/oIoaYbe9fBbwNkHt55hSrrJfvBrPSVlO97wptJWBEfUqGgRxLSM4psyABSLoAOG19dOou7g8fISRzUkuaWymd1y9+oSm12n6TMINwvgmzLWhyQAMKC2N72Z3Xxgr+MWQuvF6onbDTzWvIiEO3s8a/OTuTH4J/kt1jKn02JhVdDSWIVw55g4TyykOfXPxutDFM1u83TcbjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GR4XCYXvLgbL1fxPmTvIzDj3iT8+SxOiNbFMIA5Wbo0=;
 b=ttbpUNkRaUiXKj3Gc5XRVKzkh9yJ3RVEESJu5vUUqjw+0PwpJJFrRuf//hFHwk7mx5uDFy/forLjsggQTt9VsPRIRFjMIIjMjSDovkSNkeLjrgBQTEsLFMljZicYIXzcEpwsXhCZU0QLD7OXoKHPPnG5hVmNKiQKgtpjkJpKPC0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4446.namprd10.prod.outlook.com (2603:10b6:a03:2d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 17 Nov
 2021 04:16:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:16:24 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 14/14] xfsprogs: Add log item printing for ATTRI and ATTRD
Date:   Tue, 16 Nov 2021 21:16:13 -0700
Message-Id: <20211117041613.3050252-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041613.3050252-1-allison.henderson@oracle.com>
References: <20211117041613.3050252-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:217::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY3PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:217::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Wed, 17 Nov 2021 04:16:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcd6377d-ca3e-4a87-7088-08d9a981048b
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4446:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44463B0EE5655637899AC0C5959A9@SJ0PR10MB4446.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:311;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SG3uMHt6CJqDjmqtn3cDFuoSKHrGZqjOLNqHXq4b+zJ82aSKvX0djUkOixKozUY2wcOxc9oA8Q9Fihb0M86PSkwQi9orWSN9kIFKacirm/ghmXyszv6JFqfHTvhnEVSBJwB1blN5S8KN4Qtp3fJGa2AEFIIn9FQu5OCOZdQNcxct/tSrZne42HkgASusClBkX6SlABwmTmET35hOdSy66Z8pnb5/Mv8XltdmTZl9k3wiUfe1jweAmM2Rkxs4Tr3p8gzxsKNtDxpbcHj+fLQQTyWURISwaRm9ajul7lC6LY3Bd8i0Ut4JkbM1QPfOW35PjPqneFltQkNiP/F/UfREirp99F/djAFA48jC135kixDKww2LX3ThnbV6aKRR6DNyUuoOiNP3xkWgT+8rZDpeToqVT0+pj/6n2qR37sFdzoeyvSkKq/XTorZvJRz5Sga5UEbFjdy77pIfkMMEBNOw2cxn8krAWiMJksjMiO6yeIw9q6WwAVyHkpa+amcaCGEbCtCabB9paubYntTPqePab0017ypNWEjNH9UD+veXg6H6Nq5T6GQOgLw5We+lXZGICH49Dmp6xNKQQ5MYyGWQs2yZ+eM0H46I5T5r+lChfl1aEA5eiAYvkrMifZfWRAPA2FrLW+dAZfzo4BnhXgrqgPpO3SIHEEfFzO7iAgtgsq+suuSX8LWjwTL0KITRA2IDU26EqNxltzf8T0zf/EIyEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(2906002)(956004)(2616005)(83380400001)(38350700002)(38100700002)(26005)(52116002)(5660300002)(316002)(6486002)(6512007)(44832011)(6666004)(8676002)(8936002)(1076003)(66946007)(66476007)(66556008)(6916009)(186003)(508600001)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MJkefEkVq1vxyc/yiHGlyuv32pNuR4PbxT7HMbcF48TmoH3GJkAg6shhhMe/?=
 =?us-ascii?Q?JeaTCzbb/wtcuR87drjAG6fsx05YXrJ2FXCSykGFY4BVW/Tibw/ATJ/Skd8M?=
 =?us-ascii?Q?cTYfjOQycMGBkUi2sYUwx4Io0V4j7IrNKAy+OF2/zhzm0igJXGDTMhvwhONE?=
 =?us-ascii?Q?DkSlVaUR9+cjRW8UuwvMlpmNLu/t0tyAwfJnCsjXgyNgVzMygQ9q0gC9OBSc?=
 =?us-ascii?Q?B9sovGVsFjGoAnGf2ilJ5Z+VTWOBaxyT/40Sw+K6n+FsuiSRlq56BrgH0QRH?=
 =?us-ascii?Q?2ehhR8HdEqFMp8/80MwPskjK+yx+Y/hlZQxDs6JimhjRIQ8lRv6VCUNA7b8B?=
 =?us-ascii?Q?koN7rsyF9qeFr5NCEpfoMar28TOE6hl9ZAtkvD+Na5o8QMjrvFnjy0/8AmJP?=
 =?us-ascii?Q?8sZNTzQVcuVbiEq8zYsRWIR0NrTdelzgl5FruVTsZD5IhrhCFMMcU19VE5QY?=
 =?us-ascii?Q?5+hVr+bNALv9n8kgPNZtTWEFTa9yMSAi9cgwf/fmixGsBPSGV/FjALTtUqev?=
 =?us-ascii?Q?8kobnIRclTVSf3CYwAI+qft1ucuac0nz77itoeoVnH88xX8LvjAPN/u5ijT1?=
 =?us-ascii?Q?b3AfOn+KkQzoyPcCmpiGJ62275TQ8ZvbA9V35FCTLpx/kr8nxO0hqjSE1pPa?=
 =?us-ascii?Q?G7lk/n6hvoHjzafD69AzCxApLbs6ASopISTPPEAlyoX3MMSTcJL+iREZxpH7?=
 =?us-ascii?Q?ic3d2M7XGKY1N88c5apE2o+yIdaQFsLq8D3byNgtKo1u5tf/AUtYWEIJdU2E?=
 =?us-ascii?Q?i5z+McVrlssNaJh48Ma4o03cA4SfKSxHDiHZcX7ow3QYjr/1jTjpwMbsroXJ?=
 =?us-ascii?Q?SCbZ9jek4LuCKSS2/Qw/1S1RXmFMLGyP4dRHMRxIOVgFmbLIAPhXqeJvRRxz?=
 =?us-ascii?Q?McyqDntXtqYJbBp+bBdmxJ8MJAWq6kJfZHxNE1m9KmYiuloAs0nf5ZoChqoL?=
 =?us-ascii?Q?gLOg14Ut4hNNieIefyG6UIIN+9qpKWsnpNS0m5WcCIsnDCMZTtn1x53ycxXG?=
 =?us-ascii?Q?Ug5G7Px9mmnUjwBMx5yvqhTNr1AmfhVkmzZH7dkTSOj6KpeeE64dNjaikMCU?=
 =?us-ascii?Q?tZdNTnPNUDdi3ziXYRsaJFmGXA+PrDyoa4llKzb3INEgpc9ebk0ldxymiA7f?=
 =?us-ascii?Q?z00p3scIgIR59LS3Mf2CgSLqnduJyqr89r3Fgn97dYH5NgJsLuU6Z6li+tD3?=
 =?us-ascii?Q?NahyvXB6EP5xJ9ebagecYhRFIu5BGVwNCl2cI2lDHa2I0vOPmAlo5hvg/MY/?=
 =?us-ascii?Q?eIG5qHbGE1m8YPSsfiNQCU3DQY6XfQVPBBNRkXBEzNJxfDM7Ti5PFe5pS9MW?=
 =?us-ascii?Q?tEfmR1mn4IWmfSgKyEYnX8OpAK26AUNL9TZhCQL0vUip3OXyL2WNVyrxP6Sw?=
 =?us-ascii?Q?4SkCWQBaFFlzkyYeCCfnc2LrVfK527z88VfCZvzqmCiT/WFpcvIWZL4yuKRl?=
 =?us-ascii?Q?gDl4vP/NddQomwfHd1FRFxBN6Gm0oOjQVh2TvQ/5Rwm6jFWole9sEFcmTRMh?=
 =?us-ascii?Q?RZHyBH8OyQ+RKp3QTMTgtp/IncZkiUl/Km3yAlaazoGnbKC9PPoXN/rW4MEU?=
 =?us-ascii?Q?KSIdbn/wApVQdRVeq8BbXblvqGUTEmxsfZvHX/j7DY5KR/lYpVBGr0ZDG0F7?=
 =?us-ascii?Q?WQRm/n0lnm+JhKSDpj/nYTcYykHHgPxxtrYGxfZUexXE6owGMOmittgKqorP?=
 =?us-ascii?Q?29eXhQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcd6377d-ca3e-4a87-7088-08d9a981048b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:16:24.2654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QECuBe5yiKZkRA4UAto9tBruAdLX78r6rVVuedidtlpyhVwwv9FI/ti3iZFzcjcWLAO0T6BVFy//E4athfG18auGY98xcQ7PFsl/+IAiFDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4446
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-ORIG-GUID: 4AlXXZMyJqkRkNpnRRGMe_MQZrTCnD7t
X-Proofpoint-GUID: 4AlXXZMyJqkRkNpnRRGMe_MQZrTCnD7t
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch implements a new set of log printing functions to print the
ATTRI and ATTRD items and vectors in the log.  These will be used during
log dump and log recover operations.

RFC: Though most attributes are strings, the attribute operations accept
any binary payload, so we cannot assume them printable.  This was done
intentionally in preparation for parent pointers.  And until parent
pointers get here, attributes have no discernible format.  So the print
routines are just a simple hex dump for now.  It's not pretty, but works
for now.

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
index c9c453f6086d..89cb6492d027 100644
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

