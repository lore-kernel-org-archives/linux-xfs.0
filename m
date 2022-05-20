Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C247C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 19:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353102AbiETTBJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 15:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353145AbiETTAz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 15:00:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29623151F
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 12:00:53 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KIsoLu004418
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=/8jB2jJzkYTL0I1kYVEYl51kOAJ0C9Uw9omrLsepjRc=;
 b=RGOOWFJlA4MWTvQRTDA98muY4LN/6anzdn5I3IPMXu/68lOrBIzsMngKRu2KsORRsp42
 P+T/AlBNoOc/G7VEKdzIrwkS0Lu3km1IHh1oFkPGPNXcDBZ1aDI0tul9n2bFvj3V/x33
 B6d3aB2TXWY4AHPs+LhrFtDagRvZ4eyPMdrkp/4Lr/4STKOslEKSqxMnHTeF0k1TZ6fA
 tMv2fvKxnrJnzKl4KFpg4N9MoeO1uUoUWNtJO31/RSFpZTOLOP88Z/xiZO/e2adokRRE
 Iq2K8iJ3ZEx5KHZDx1gEqWQEnmOzoJa1kjrauUi11jP3/ojlDGYCBCoTobvPa6SPJEgo bg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22ucfe44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:52 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KIq2qJ001842
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:51 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v6a3ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TunF2oqHtDERkVrC1q1mLhNgLpPK04K7cJdD+PyN4zRuy56/WcZUcso0YuOZeymoYk2nDr/El3eIPMd66av6w83KpUJscK1TceyEh/lEpoxJZ3Na5308bGj9h2vnD20zedRJ8DKR/tuU9P6EEf2Hbgdtg9Lnad13vLFARKw6iJVnZzyo+MzoQmpJblbE/juAq8Ix9MllOsGIoQ84ZZ0Gce5BE5+9vi4Hp+cEOkQXkhKNyyqjhAn6H5p6N1ZAmq4syBVLbb++oD3KJwJ2zfsaajqj0BicIWRhIkTl/hAHLQPBzZf6RdN7YFLDnVZtOg7HIDx5Xu44eI7nwHKWcxXOLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/8jB2jJzkYTL0I1kYVEYl51kOAJ0C9Uw9omrLsepjRc=;
 b=er0yD75GA3IfBqqptqGHbZocsuzie3drB22Cnxx1g0w1Fk8eHu8GknGtiQFak1YzRp1ZI5mdm7d0Hq4/P/OlaJdFQQ+ZAZ4C9ccCM3BgIuFxHVaVXevBrnps61lFvrgJxUl+5LyYnIhfvAWg4yvUjzWOiNWS/orQbvKURzPWdIdnblXt6LOwCO3YHK6kafpdKEock/vYWmh357HBp/1fPvrVZbKXmnMsOjPrw6aSGgOa5hN3LFpC0ksCYiEDToBAdhS5a6WgfTPxgUg7jTJVNt9SYYD++EL0CKmMc+KUnImA+bYIXYl7gMfRBD6JbmKPvN027hmNMfRjgJWGt7KMMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8jB2jJzkYTL0I1kYVEYl51kOAJ0C9Uw9omrLsepjRc=;
 b=GF4QfpvVH8Z+fODyEy18ShIjaMGMXbTDZdUDowREByX8DytbtironiJ3ISOtoPrmRuLYQzcRjMNVctCmk5/R9OssPyIxJGsvELKV0TeR30nmdkP5bhPo95zeKKoAbqYVpIwmhd9jzq2QFDHHoiug1+QnNpJrE3Qo9BE+PjrbEwg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM6PR10MB3658.namprd10.prod.outlook.com (2603:10b6:5:152::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 19:00:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 19:00:49 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 18/18] xfs_logprint: Add log item printing for ATTRI and ATTRD
Date:   Fri, 20 May 2022 12:00:31 -0700
Message-Id: <20220520190031.2198236-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220520190031.2198236-1-allison.henderson@oracle.com>
References: <20220520190031.2198236-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 122eecd2-ba51-4eb8-4cc6-08da3a930a00
X-MS-TrafficTypeDiagnostic: DM6PR10MB3658:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3658C44799E5F376C9F88CA195D39@DM6PR10MB3658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A1N6/xnMR+Ke7pc2htPnvcLuZxKeeWNAYLHRm6LIlbZ3CSlNkI+feXGEGfr0xatcHUPAike0XhWoQTkabntUOrsN0NPSTiOm4bom8kWLTZvlv1uaNSMU7wwXKFKl7d3X8CCPLPgtC3QQEeYCs/AiVoJumVAAVO+ug+cAj+MFZrEsGExBF/TMrPvMqrVvaxWOH77uCsSSQLlpelwHYTHE3ieNzacK4LRS9sEB5YZWL/ZBWClO/Z74MeOiLuNh1NdRGdiPiM0mrWIVULbEXOL5a0QVWEIWAaUZSpbVBEsZl1bkT5djDhEtqXPcgSrF0dbq4ZNuTu0GrhbVrOWnGFWfw0KeL3XK3irwkvEOK50ITUsNrjuAZY983atuQvymZ6j/k+/Z2DOR9aMiAnFeDqQ343BFAQ/TcVljWLWT4+vTI44J4envuBTWIw+lp9rMYOC0JXWWm0aDtN8n5buAgl2jdWngB9OGu/Z4O/a4sTieJj9NQbctyCowxVZh8+KWQn3i26c8UU3t2WTBt+AlXMKY1hDdMOUZ03fdyGz8HJm4Dq3uasSpM7WKYdbHi8jdnw4bnGEL0TJECd+a4/5Uw1lKJ4aCHKA41UefviLp8KU8CkRsO8WvFOaJr3CyqX8GQ9CwHzCFyiNxQ9Hrgx76czVaDm+EXkTbsy7l/cXh3Li7IYOEisl+fzUU67NojNr7dS0KNyap5mbNORJIJC2d0dk+CA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(86362001)(316002)(66946007)(2906002)(38100700002)(6916009)(8676002)(66556008)(66476007)(5660300002)(8936002)(44832011)(1076003)(508600001)(26005)(52116002)(6506007)(36756003)(83380400001)(6666004)(186003)(6486002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x8Gr/Z+27oTAQjcDmC4v5uEHuiybalX5+cfNtcasCg2UR3OKdrFGvgONDf6l?=
 =?us-ascii?Q?ppfVaQcYXmJxSnaBkUukdvdEHfUFKWN6/oX1gG/EOAuv/F/U/H61E0Z0u88Q?=
 =?us-ascii?Q?Ze/qixQf/cxLMQIkbH/mEDovvOHvvd+rkSB9la0Ob5/Yk2d0MjBgVbEuEhB7?=
 =?us-ascii?Q?pV0gRFVb9kWq+bsXE86M5BvlnjNjRNzF/E7flmDjvjhh9BCiLKBqHMaCE1n2?=
 =?us-ascii?Q?z/4owU93QRkto4EffgB89Dj6oh5ljWPRhEtVoRrTP0WnTHfcIueQnU+b23/h?=
 =?us-ascii?Q?8Aurch+k+DKVddzF9JLRIrti5HLLWIe+dS0lpxmNPyUFeIbT1wHPnaFT0enY?=
 =?us-ascii?Q?HXlHYuiTXj1HW6MuyMCKxJy+iz3nqW9r++x/yOdBR4DOK6Rvs1ZkRnHmToIP?=
 =?us-ascii?Q?tMaVqjS6GKzlN1kTvxJnhoIEFs5DgcO3PzY9RImQE7syU4jA1Am42wRBrTZB?=
 =?us-ascii?Q?m/MQEOF7/g8yc0Ik2CA2kMg13f/booKBKyjPsxgi1MxS76O93x70DAYe320c?=
 =?us-ascii?Q?5ILmMRVSenQmt9b4KSzZe1kFJVBERtxpRcNaQk0Hysqx/zC8o0ysKN8kT57a?=
 =?us-ascii?Q?VeTsJ7xGdBxoMUdcvyIjHDnvxig/e9EGd4NXjzu84CJO1Zjlfpk34Vl+zzQR?=
 =?us-ascii?Q?k4hsDkFcRn+xfcSHoYqI+J5w0AqGouwGPmZTlBhI/St3Uyk1AfZJisWbVP8s?=
 =?us-ascii?Q?m7G+eDcyzr8VWvoUCZhzvjxUNbq/Q7adtxplt6cYBLoVZlIhpweJ8nS3BTcm?=
 =?us-ascii?Q?qSOjyQOTYlAU1yItFIKpDUls94vxVuOqOuwUbKOFxyHaeg23GG828ek1sr0h?=
 =?us-ascii?Q?0cwK/eq6XOzzo5BteAjp5hZrssJgDDvI/SzaQQy6M22SMMH+LzLrO4E5WhXS?=
 =?us-ascii?Q?QOb88G1pQL5+qiBPkLwk7wZg0VH6UEEEl3s5AIwEX6RUZykpgrESAPaWXcTs?=
 =?us-ascii?Q?NYlr0Jm55TjnThay4hEEANwZ/xtx/5AZwiZy5S9u8R/2ERaZ67/n87iR8T/f?=
 =?us-ascii?Q?aL8QKIGrskbGarSGCJbRY2ltIhBg3aJcGjSHZ7o3GPiGIEO3V8UohasWoecS?=
 =?us-ascii?Q?chZU4oiAWbvmo3RkA1j0pKzmEPfC0qgcjVrOyds/yXFrgoKOE7vz00rOapiy?=
 =?us-ascii?Q?uvWdiEtrY41uQQ5diR9ixoi5D0Hbm8HGNO1tb8H5dNqUfJ38ppKlTl9GsHjT?=
 =?us-ascii?Q?jrpVWIuB4Udbi4AIE8QUsYDH1uEQki0QA3WPM/bceY+2p4h9FXDgrbaFwDOV?=
 =?us-ascii?Q?kKScp7nkyxVXY10tNBF8b0tuSlR/rxufskXI4OZsHbD0ibc+xE96Pch+2W/z?=
 =?us-ascii?Q?3mVkcbypJYsaq18riD/H+371dzKgltDTrsbEWXQpCutDVr77urgXbqXUtjY6?=
 =?us-ascii?Q?lUaOiKWBa6fgXvwcdy7dzkMhaRnAGobTp6erAaJ9ywht+HvByEviKHiu1Ncf?=
 =?us-ascii?Q?4Veq44Bl1UdANd0Ns6u7UYwb1O5dRmg8q1/LV6kOx1AgOjLyMeAB1sAfYLMN?=
 =?us-ascii?Q?0WR4SnRXUUFxp7otmOv10EAuM8ApeUapXi3qCWv78BFZC3FCNma8jVxPUfAR?=
 =?us-ascii?Q?EEHfJbyam+zudhMmiP16hO2zutnvlACHDoG3spyJJm2ab1kQlQ0K8y5ji+jq?=
 =?us-ascii?Q?STVdZb1K4n9lvAEzwK+SBIMep0btadv58YAP+9Z2kY8rEOZSsdp4j3wgENhs?=
 =?us-ascii?Q?3bhKoL6RK5S6QQQhnwdwMsTTAxmlgcPBZtt8TdARBvwRbShZehb9NPv6i2tS?=
 =?us-ascii?Q?Jo6rj+xDRmL16MW8CS2SDrMQd2fbDM8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 122eecd2-ba51-4eb8-4cc6-08da3a930a00
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:00:42.9835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xJ1Xz4HN0IQmjEfO7eSMHEecMq1Muv1Ot00GNGft39+wsdm7/UQTsH1xIFeiFOWdwhScDTyed2EbK65WUuxzA8imzoouhFAavZOP1OkUQiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3658
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200119
X-Proofpoint-GUID: 67cQc5cP3hyLmHXCzLWG3PCMe4qpSPBe
X-Proofpoint-ORIG-GUID: 67cQc5cP3hyLmHXCzLWG3PCMe4qpSPBe
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch implements a new set of log printing functions to print the
ATTRI and ATTRD items and vectors in the log.  These will be used during
log dump and log recover operations.

Though most attributes are strings, the attribute operations accept
any binary payload, so we should not assume them printable.  This was
done intentionally in preparation for parent pointers.  Until parent
pointers get here, attributes have no discernible format.  So the print
routines are just a simple print or hex dump for now.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 logprint/log_misc.c      |  49 +++++++++-
 logprint/log_print_all.c |  12 +++
 logprint/log_redo.c      | 194 +++++++++++++++++++++++++++++++++++++++
 logprint/logprint.h      |  12 +++
 4 files changed, 266 insertions(+), 1 deletion(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 35e926a3baec..a4372a67a811 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -54,11 +54,47 @@ print_stars(void)
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
+void
+print_or_dump(char *ptr, int len) {
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
@@ -961,6 +997,17 @@ xlog_print_record(
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
index 297e203d0976..66d6e9b76eb3 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -653,3 +653,197 @@ xlog_recover_print_bud(
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
+	int len = max(value_len, MAX_ATTR_VAL_PRINT);
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

