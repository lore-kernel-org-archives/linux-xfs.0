Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4646DC6FA8E
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 12:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiITMuQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiITMuO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 08:50:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844014A80D
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 05:50:13 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAP0YH011935;
        Tue, 20 Sep 2022 12:50:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=X2hIn8hIg8jFE5HDmceLaFBOEW83D+l7MamMUjjcmD0=;
 b=Cr5w+nYG+3Xo7/kiopxcanHKxAP+aqZyA+1MHFDSDvQvKUBPzPmClMw3McltSrGZy015
 7ku6CKGxHWtCEKSN2F7uAxK7vQmYPouHDRPjf8TsHMynQ3klcaqY6zvPqpjsWV1zWpf5
 g8fnHi0LqXvlbh4qB+9j5be9tNIflUY467CPeE4Elcf+Qcqj2H4C2pcT5cpk0YpzMMT/
 Q+ss9ZwcZbgULBsNMIrXrj0bjfHR9p3NiI9Wj6+GkEkMgKd4o1ckmQ4CdV4gCkG0ABFh
 GlQbr6oaCVqwNKEYca8/r9fWRVcx8rn2A4boq7nL9gAI140jA+YkFLbQXHwiJIlY+qKu rg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68m6syr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:50:09 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAro2O008003;
        Tue, 20 Sep 2022 12:50:08 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39k9ssw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:50:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJ81Ya0JgqswyD/vIi1qqM4dRyDta3GOJqIgGFZ08cnpHxj2d3IrPaJbqrN/i49+K53XPFGLmcQ7Jn0ArXzYL1cPkl7RI3y/4G9B0sRzpBbEWEL6glg1ckbIMcEeKKGxhcW4PY34ykpDbeFrWaIhS8IquE7icww8/MepdWHqU1Gst2ltU5jz4CqSo+WS/ZkumELsfFp7NQj3jWP6pUcbqOxL0YNFW2CHgyD8NJN41eMrpHrCRc73VocXQG8lVrqtVi6LdVId91QWCcHYTmXGm4p1oJIjRQY1JRiC6VpziETrLvYz95iGT2Yzz0I21mn/zsT5NXD3S1JSLNDPmy/O0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X2hIn8hIg8jFE5HDmceLaFBOEW83D+l7MamMUjjcmD0=;
 b=My3l1ZFHmxPq4AxeFlJUCg9+NVE9MZe6qjKu+kKZYK9EYtU65qwi31npENTJuU05i658N9Wv3GPJP6l4ik/ZbSRqCxsyJntXAEZODI73+LK+P6BdlLvUvWVeLnSUXF/l2Ht6gOq/n8Ry9afSMoo0rla6nSDHwQHiAMPGKUy+3jYsm50mRZSEnKvETjKM+NyLMZO3p38kP7XLXybWvQj2vyClBXAXGQF3sLScz4BX/Rhq4miUEURnRTudUe8hvYRWgycr8wjsT5XelRq/xnuUKMlLbM+TpQoMN1UF5FLBU5D7vNTp3QJIDX6oCBQ8MrKQsv/K1rIS2BQsG3ekP1Xv7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X2hIn8hIg8jFE5HDmceLaFBOEW83D+l7MamMUjjcmD0=;
 b=Q1f3TSueUHPFW3cd6KEVkwkulysKxztsZCeGzIA92p6ejbK3HkuFMWkr20Usi0Q2DQ3Q+XvyQKR+jQfBrQDHZ0cjZKa+zJInRUsMUglZMWvt4EXcaPhll7M2g4NSXOasiYVYCSiJMEQoQz1K/T5joytWVG2rX7KanKbTB7yCoHc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SJ0PR10MB6304.namprd10.prod.outlook.com (2603:10b6:a03:478::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 12:50:04 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 12:50:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2 12/17] xfs: fix some memory leaks in log recovery
Date:   Tue, 20 Sep 2022 18:18:31 +0530
Message-Id: <20220920124836.1914918-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920124836.1914918-1-chandan.babu@oracle.com>
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYXPR01CA0056.jpnprd01.prod.outlook.com
 (2603:1096:403:a::26) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ0PR10MB6304:EE_
X-MS-Office365-Filtering-Correlation-Id: a11d5dcd-f22c-4414-9931-08da9b06a307
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +0zlQEKHbH11roxOZiL7T51wVFkXQdIQh/cz1Xe/z06P1NPwZg6b9bhod6BKQ1XNWKb4bzNHAwak+uru3xU+EcIXqVzatht+Wg00DJjDYiAHGEeB3tf11XdiIAL3N1MibKVZDr8Iy8D9AOV+6GSrIh5eG1aS8Nef1To3VvwZ3cctm8DV+ojfGgyEBVsW2DUxH63jocXAiW5bgQgoRYkrcsdsd/HhjNSGlaj85iYJiKMxc/UhUM1wpojwf/d/WU3H14shYsoe5oj9xw8AtRIX3TFt/avHCKGqqP7h+axpJv7TOqiyLyuAi+CK6Mym+nl63O3BC4hdnS8EHh7vXx/v5EVVX3NygGKlYyY8ATP3YESXYV5X9xnN337Kcdn9fu/QyHrEJSGU7HpSrKw0CERIwc3x1eHZ8ASODWDz4Qh+G38SZ/KWR+TlR/fbjHEelDhzS7EJs4OYnumBq/zFspfR14cyXfIrW/ne/Myf/BhrEQs5fzVp3Tw5S7Mm4N5D7DskMK+a2tgIU5yfrZRf0fh/SoAg9Zfi6WMtdwpXScpMIPg2wn9hWMmoNYc176gjxHYQsqp22xLDeyovmMeX7pK5FaSMrN5esWQDORbcPn+UZz9U3bB1vPfh/nbu/F/GlSMTreHyiv+OAf1EbAcWM2Xb72+KCKI97aIgzetTNUoL0/+ODqOST/t+PSyD5tsqltW9tXjVXxjupDZqCNJ1FhL8zg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199015)(26005)(6506007)(6512007)(36756003)(6916009)(5660300002)(66476007)(66556008)(38100700002)(86362001)(186003)(2906002)(6666004)(1076003)(83380400001)(2616005)(4326008)(41300700001)(478600001)(6486002)(66946007)(8936002)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ftD9SSob7FmOEeHEU5D/PsT8ceWSdxQdJlmZNUmR+3A+dm4wSRzIsMcd4f8E?=
 =?us-ascii?Q?Mq2GZTXld1XBLcJz2Lw/8hU870iw53XkaqTOe8LW/TrlpsXAxAV4zYI+Biur?=
 =?us-ascii?Q?aOQWKBZdgR5EX+elkl08zJgPybG6IlT08P2V2dfEcVMR1H/BO4fS2JL8Zhk6?=
 =?us-ascii?Q?krKv7MzabL9qL65qL06ThFnsnA3RuhexPXESxEzl6kgEOyn5I9FVi/l/E8by?=
 =?us-ascii?Q?2L35+zeWGGgpyS9+54ulEZtzqLsrntmI6eArl6QhVis6imFsKZsAy/Cc/Luh?=
 =?us-ascii?Q?5KWRNYDEbjP2tq+1tNoI00k/bqDuR1Y59Do+uaqwhpAcoEbqh8z4W/FaYrB9?=
 =?us-ascii?Q?G/IpVid3ECQrqp2EMyAUyqcP0Qv1KIYCBCVgcdI38MykMW62A61srsQFt0Lr?=
 =?us-ascii?Q?njfBw2ZiMgQK4QPwfBJ2P8fTJi11LT3suVYmk+rwsnNcTj3tUWQUWzcN3nrE?=
 =?us-ascii?Q?7KVumdg2ROboduPOSlGAY2/mUx3eUy6Tlv0Cpp8VmQA13UsbteIzPT41hTTq?=
 =?us-ascii?Q?snBBb1CQomfMvnwjWZS6qHtOfoWTcJ3UCBcBLdLn6A6It25KXw9lRxBRsYqL?=
 =?us-ascii?Q?/9F8PgwSUztB7YS4o1rFI5ntnjoUDIP2reLnFNMDw1xlXbGWK83rNlvmJb+5?=
 =?us-ascii?Q?66qa5wpPtC3xBn8cc+kC2VKQf8S2uas6dz++eznQlY22+jxLoMJEnkRZK7GQ?=
 =?us-ascii?Q?1oRB63ggijgpAHVyUr5YisOfXIeCAD5I8XWYKPs+9S7QvH/6kfCP38fXspY5?=
 =?us-ascii?Q?4t7OzuR9MoI3sApDpyOZj4xqiN+J8d+7v3cOKpl9cW5jPeBO/mN0MAJJaLLF?=
 =?us-ascii?Q?VvYyW87P813RWB/sxoeU0PKSvaPWblWwlJPx0pf5b+1BaLNMhWTZ9KmBWy45?=
 =?us-ascii?Q?HE/sv2qy4/oIeL8jmmGkj+ZPLwfH1bfbEDYCDM7T50ML4XqVmVkfkieo+SrE?=
 =?us-ascii?Q?6UWeFAYOdp/PjEdqxUpe5BNgntXempyEQkRgJop6vlItf+DpSoy9h3Ek/uMR?=
 =?us-ascii?Q?X1PIAqJjCcCpK7+SVQDS6FvoaBzEic+ezt8K6MA9D2OiI+djtAMhs+2vt0i9?=
 =?us-ascii?Q?EmtEDJj2s+6efPfyqNluw8jOYGowX3WR80dwuPKLZxTclIXrDk8t3Shi2ESU?=
 =?us-ascii?Q?u6MGS4fdLxI71KmpfKGjFsr1kepIeqiaGZyIcS13uisEaKmSF4kyaF6d1z9K?=
 =?us-ascii?Q?Gd7HCu+XaaXrtD4aUcXRTrxPho9ht/DttEQBV7NNGyP+wTZPz//A5GUkDYS2?=
 =?us-ascii?Q?biUgm3xLQ61xrfUswK6C9SYxojkwJESpK7P8Xba3E/R9ttCwmtRkfx+tytBX?=
 =?us-ascii?Q?lSbhiaYuQF9f3X34SJjYcrglX4UZzDklfLyDddJ+vjZltI9kk1q1tIUHbK8n?=
 =?us-ascii?Q?MRTWZoGKNNGjmQtsH7kI4KEhkcFj99n4VmM7AEtzFYsIPvnFk0nfWvGnHkis?=
 =?us-ascii?Q?ZFRcE4oTCxAvLHaeLiWJUHTxiDAAVbWteXH1JwNytyXqEJFctqAScduzlfm6?=
 =?us-ascii?Q?IpNo2SaykC1C6mgaIuS2z0HsSRCawVuL2xzhtyXmvuiKqO1P9syMQPK3L0eP?=
 =?us-ascii?Q?TGV5mylGOZwRZelli+R3OPUIYMWkEiADQGjNqq/29xVzcHgjfqWfSEjL4L1k?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a11d5dcd-f22c-4414-9931-08da9b06a307
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 12:50:03.5826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D+aUTSf3Gaa4SRBsvU7UKZE2H4Gkwd2zTHkDIs7So/No7LwRjBKhPBob96Uep8uf7LfQxIUXKTCvCsbUsjr/Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6304
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209200076
X-Proofpoint-ORIG-GUID: MtmvdK05vElgX2ds7IMWDz5PTGcj4BjD
X-Proofpoint-GUID: MtmvdK05vElgX2ds7IMWDz5PTGcj4BjD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 050552cbe06a3a9c3f977dcf11ff998ae1d5c2d5 upstream.

Fix a few places where we xlog_alloc_buffer a buffer, hit an error, and
then bail out without freeing the buffer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log_recover.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 02f2147952b3..248101876e1e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1347,10 +1347,11 @@ xlog_find_tail(
 	error = xlog_rseek_logrec_hdr(log, *head_blk, *head_blk, 1, buffer,
 				      &rhead_blk, &rhead, &wrapped);
 	if (error < 0)
-		return error;
+		goto done;
 	if (!error) {
 		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
-		return -EFSCORRUPTED;
+		error = -EFSCORRUPTED;
+		goto done;
 	}
 	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
 
@@ -5318,7 +5319,8 @@ xlog_do_recovery_pass(
 			} else {
 				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
 						log->l_mp);
-				return -EFSCORRUPTED;
+				error = -EFSCORRUPTED;
+				goto bread_err1;
 			}
 		}
 
-- 
2.35.1

