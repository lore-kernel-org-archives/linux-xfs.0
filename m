Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A68C9C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93B286112D
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235773AbhG0GUI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:20:08 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:28258 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235719AbhG0GTx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:53 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6I7sd006844
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=A1QCuZONH/wxheI4TXSZhgKF/ClCJfzztQYwoR5vny0=;
 b=TU0xy5LhyFwm4IA6/HxL9oMNfu4W/PeCUOu7MJQyPU9zixmoO4FMILsxAiQV+AFXLKny
 KQQOS3s60eTGlh18sbB8Pc1lXVGhwT8IYafYrge4EyxK5/Q+wCwrhSIHGLtAyHnzATod
 WoYB8GcNCeEV0H2sV3AIPBcV6svglCuIWCqyqUSYyPiIhzf+uAO6ZarLsYzRF2NUuySc
 ErH/scFm2B+q/Pyro/AA9mXBhWCnc5+HM7WAS2MOQUrOj9+Q55zbzoeNdSfaaD+wC4yT
 Wg7bGtRn5TmwzP978SGsRVTtoDB6D6GzLFZqID8ADDCM63kTgLtCEHkdS01/eAJ0Q6L+ WA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=A1QCuZONH/wxheI4TXSZhgKF/ClCJfzztQYwoR5vny0=;
 b=xLUMXmgpDwmHnv/ShCLiSSqTBG3aLmhpHKAKjkpROkqOCj/ZwKlWEbULcQP8mg77OoBl
 0K9NkRZqlWUbC0eoiHVyCLIr6xEZ07AU/U1fbRTMBBE+V/Bil84ySKAwW7hob9ur2ffu
 KS2jgdQ2lN3tzPlQY3GUUii/XKPH02M1owr3YW3KK7cZVR4DDT4LMl/JPrixS+blQMVK
 5WhVxz50rMAKDh9O76sKsUAQHO1BTgIjjVwl4MJy5fuS2KtG2jLlrmeK+o1L6cd+mK3+
 M7ctCkf3dg4NZF8hiUfbl4w3hU7bv951FrFErCJNkIEKpryZSLlcZr/Pm0iqhl7B5zkw SQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2356gua4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6Eifr064983
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by userp3020.oracle.com with ESMTP id 3a234uvp04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1DuscTHRlR8MwRw9D/ER3wFbiHFZwxIrB67WvdOhjvz0ELuo2OuYWQKvreePsUoyr8qLqwtGef+5xUSRqXvFOqGXfK0cfgLKozs/cy/kklxfbbHiwmC74xyIpXYES6UzNwW9EFcJvEiKtWJl125isuJfuYYXTUwum6Ph29rtY06+OxFqR9bymi1Isx41zRy457xSCDlfjNurbpOrp0xHkcUpJ1n+/MgezeAoC4at+sv+fP8ave87VXQeN8Mi52OtriECfEAXpn/Iz4QIBd+VcAAThg0u7Hd1zq2i50EEXm+S9MmHg3758SKc/ceDmAEnNpau/W2pCyfNpk92eg9Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A1QCuZONH/wxheI4TXSZhgKF/ClCJfzztQYwoR5vny0=;
 b=YXQmf7+KBxyoMsMDbDdvf3ZL+nK+M7GkQWfKa4fwME/f4NQPR3NjySI0GO919+moYDI9OjcEtNh7YzSNK/QVlf9cwZMC88L19jX2kjm/82NpV8cKaO9Y73lP3O1owX/+F/rZKJFfDmw6D7Z8QFJ5qi6iS/cIKa8jEZHzeOpq528tHZ8E5twjsY2QDCWVRGDI3rcc27dxYtl2QNMBctAAidbV4SBz7XHa7cjn0Ia3wlG62i38R9gbV0Qnph8hOutXJeSJm5hPyPslebiCKSSQJaMivnyq4oneiXKcpZ85U9XuLg/whDfROQAK0PmYpgVzLs9KXqI+w53JyQWTeYC+6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A1QCuZONH/wxheI4TXSZhgKF/ClCJfzztQYwoR5vny0=;
 b=x4TzitfNfEpJvv2myPP7KB/fThIl7+lKNbl3Sko4/8Or67r3MlJVOUS2rEFTr6W2qRfVHvSQ4P3VtczVhLlr8r1iGkag0T2cJExhYPuoXGhkpPc/i5n8J1Zrshhq5CU43fcdwnvKQnR0chtkH/C0s2oN4SAjbRf9c4O/rmXpKr4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2791.namprd10.prod.outlook.com (2603:10b6:a03:83::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:19:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:49 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 27/27] xfsprogs: Add log item printing for ATTRI and ATTRD
Date:   Mon, 26 Jul 2021 23:19:04 -0700
Message-Id: <20210727061904.11084-28-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aabc2527-f4cf-40bb-32e8-08d950c689d6
X-MS-TrafficTypeDiagnostic: BYAPR10MB2791:
X-Microsoft-Antispam-PRVS: <BYAPR10MB279166B0E64F4C203DBF136D95E99@BYAPR10MB2791.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:138;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oo/Oq7cfYjCBNtTffbO1gAOlnqqQegHQikIUy65hW6BpjmYTMEAQCIe5tpu5XxT9FMwBPEbQH9kg8ssOIVgx8OtJEjJ5obgdbcZwLAyN/TOrM6Vk1zjJT3O9ScbxqRUR+nxE7a1cBhhOuT8bnkJw+qTm+0IsgJaKfH8IxrrQqdgc/APHI3rjNvhbHI2K8KYc149wPgs5Es4ud84zqxty0ESI0RrAHhFto2BkKUXleWWL8TV9/JoZX3OKqAU36LWLHmPjX8WSaZGQa0iHkfAJjGILC/euVmt+krdRplEg4DTbZ4o+PF4sp+BCsnn7kSm3/YEaERhi6kM9YRAP+Pj1LIpcqvaEMaJQJZtgIlwIi2jeCHPtRxbbnwBAlXvp6YF/EkCh8FOxaQtca+1fm6hRFcC+ALfhELA07MKP2c58UK5HixqOHjcanQU+W/Qfidl3wNed5A4ilhKFm8n090tnaZphZIPDqv5pjx5cpXPXFPwRIKYxT8b1UL/ySYBh+Vo1teoZETbyAJY87CmLqyKfLGeqy7P4taLz/yZ4pPXQhdRTyoX1FpeQncwdCq1yYKxSIp9LxJP0dDBaH3cMXK6eVmG/zInbxhrt8X0qSVmjXub02j6YOnJH6+QsbHmNGAj8Logvvk9UCRltBZ+UY1vrYjSeQghWQMNUhf07smn9c84Vu3J/0COX0+vCcoUuSRP/KxVLrdpICrNDBkGknDeaXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(44832011)(2906002)(36756003)(52116002)(86362001)(6916009)(83380400001)(8936002)(478600001)(956004)(1076003)(38350700002)(66476007)(6512007)(66946007)(38100700002)(66556008)(316002)(6506007)(6666004)(6486002)(26005)(5660300002)(8676002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NgJHCpe0UB2xPE1OigWFfjgYdOHqSC3e3Z70qAkTzJlwHUtwKc8nn+5TE//z?=
 =?us-ascii?Q?E3x90M6ngNb9D1bzIwJdZoWojVaB/l8cA47bWB/Pka/U2KKxR5vkzWDDrmck?=
 =?us-ascii?Q?b7lEBdrFA1Pcph/fpf93mW1bSxIuDu2ZAI5GRmfea6O5RTloQEo8Uy5ELnqj?=
 =?us-ascii?Q?G/cN521RHJU5RfZyICfiiAx96XqSPimeHMuenuraGNdXKNvirJ9oCig542LE?=
 =?us-ascii?Q?UBFurwdEmVMGRpIXuS2Dv0fLBATmuX95WetovRmwtZ8ZYaVbSHwEwE2EIz9R?=
 =?us-ascii?Q?E5TYIGf+zpGF1Wtidf25XCy/lm7aX3m2t6Z+H92/jplE41E/0hFEt/WIL5Yh?=
 =?us-ascii?Q?2YH+RMoRAZ2CA9O8hehKHnlBPyFckAxsArzQZfnIDYPByu7qtj1A2Pc2qrkE?=
 =?us-ascii?Q?J23K5YNXvMeffzKaDTnG6n2zkbI3nJ9MfQgguz344j0v4e/1XBSrxZhpgMU+?=
 =?us-ascii?Q?rfYVozv6/gvcwIl2ELgRYSf9Mhzowdq287P8hMM+Xm0A4WlqcQVSYpN4mzKw?=
 =?us-ascii?Q?IZKg2iAO52jxa/QgfTL6u0dT+D8BAdxXJmPJqM+RTg+VMH2BRAji72/pdNmP?=
 =?us-ascii?Q?SxrMcwEW8KNvK8I9/goG2rRM4FHNK0xu4NdwpIGf6Ia2l9Vnf39pjCWcXrcj?=
 =?us-ascii?Q?19kVYiOYZvIrXH3uf/wjVzZiUmlnDMHztq06mdvnfV9xG+BnWkZOUVBwumUx?=
 =?us-ascii?Q?sNXrJ2d2Saegemq+OprFfdDLOnvc4qQ83OXylZREbhxmbOAFIS8puYQobCdZ?=
 =?us-ascii?Q?1+BajWjsiKkus/KQd70/YbXppZVIrjs3MR1Rza8P/+7pFj55bg2+jFYUfZxQ?=
 =?us-ascii?Q?JEQVe1/NQGawBU47UYTuADjQGnp2JeOAUi6n2mA/e+i2jIIQAME4K0EWgcT3?=
 =?us-ascii?Q?eiQiq3croi8mtvi8y1lq5J6/d5NFTT+K5ns/+aEtIEB/Q+LQ1XVVRWDaRZUp?=
 =?us-ascii?Q?g5RQ/llamDA/J0RIxoyqaYwjDtrQB+PkAmVA/46rk6ku1FpYQlVr5KqA/7jK?=
 =?us-ascii?Q?HSGQTHj2nfZOaDPbZqMzm0j1M3wpIFmj1lQflkook3e2pR3jRr11iK5Auj8/?=
 =?us-ascii?Q?hUCIJdlx3JGpXsQAR5BNeL7kpO4CXi4FWtYqI3nzqQyUOQWvOnv6loh6Yx9Y?=
 =?us-ascii?Q?9H9zXodHxtFyRDGWDbkmxYtXjCIKK3LGjrn0tfwf35FtKxLukR+pGIe66E2o?=
 =?us-ascii?Q?+dUwYTio4HKK4pAbi2fhuyDwEWSq5diwqVKU2/OB6AiG6iq3PJwFGhVxddtO?=
 =?us-ascii?Q?DSyOsHdsL688BUiOnMI1yagGf6Y22EapBeUeUKWwgEPxAAjF9PrjSG6kLyzD?=
 =?us-ascii?Q?ilj+2HB67xvDXlMh/QcW0xKx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aabc2527-f4cf-40bb-32e8-08d950c689d6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:49.7750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B0DePv/93JA6YnGEPexFUsZVstf77PpBJuDkqcjwaO+3fkWOQmTD95jrBpoDUSM58gl848Owi0aEEu9UN+IXt1ngp0ZL6bKHIKVP5/KGuAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2791
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: ZjfAjy0nKkeKwA5kH_MhjduC4DBIxUa4
X-Proofpoint-GUID: ZjfAjy0nKkeKwA5kH_MhjduC4DBIxUa4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch implements a new set of log printing functions to print the
ATTRI and ATTRD items and vectors in the log.  These will be used during
log dump and log recover operations.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 logprint/log_misc.c      |  48 +++++++++++-
 logprint/log_print_all.c |  12 +++
 logprint/log_redo.c      | 197 +++++++++++++++++++++++++++++++++++++++++++++++
 logprint/logprint.h      |  12 +++
 4 files changed, 268 insertions(+), 1 deletion(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 35e926a..d8c6038 100644
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
index c9c453f..89cb649 100644
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
index 297e203..502345d 100644
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
index 38a7d3f..b4479c2 100644
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
2.7.4

