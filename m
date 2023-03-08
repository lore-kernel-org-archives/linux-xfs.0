Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D4BC6FD19
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjCHWiy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjCHWix (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:53 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2189A62FE7
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:52 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JxoOm009767
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=QnZjoGgIcEUP40CqmQBJYUuAmBfobRJOlbitbtUwDrQ=;
 b=p7wNHHtIZ6iIbr7THThQOdm/+O8hfvRf1n2WwIrdvNEhYf2j5eB3JskrVu2ivbD97Z9q
 VMTaG+Cmh62UJ8Fobs3FPVPm69KFJeBLCJ2aP786yL6LbI1tMnhhL+lTHI1PnFZbqTse
 YMbo5innJ/rT8Eut7IGJJk3eVFCAw8Zma2Tc0xZahtYlajOX6qwr6XilbnW3VD1SEo52
 vFarKB5VUeD441bDpTrQkxHscaIZPeqdUh5UPDRYeDGaTUZHqgeAP7lYXVaEtsCpYj+D
 K2L0TUC3s8FQOudzLf7gbwde3QoSpm3zW+ev3K9n6vBXtttud3nrSy1dZgZyHLWoz+J0 jw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p41621a5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:51 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328LRn5A022428
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:50 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2049.outbound.protection.outlook.com [104.47.51.49])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fr9dx77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dE6aSVPqfDIfwEm1bnwZ53HB4g8IKq95qHf4kfrqaHGQLXJbXc+aupTXNyaIcHGAJefZDqRdhdCMOE+ylc1U0DS1AvWh9Nx9w4EmjmVqEp94tDoU/9uTyY7GyCCZjM+3mL0EheUaBZEY4Xdv4r5ZV47mS2rw2M0lGePd/aA8Fwz+MlyatO4FsSzPFT2dixdiyAfLOwtAV8Bg0tSzyYGITWPjFvJ9H1Hj5RMFkxeVhLx2I83GXac9UdpeoYwRCW49x370RAK7t23UYoW2mNnf3D0AQdIzc/zsU+R/FY6rn6Any7ex6f0ZrxTlw9Zbd+UoqccYNemMk+0pDhUbgb8ReQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QnZjoGgIcEUP40CqmQBJYUuAmBfobRJOlbitbtUwDrQ=;
 b=lJkUV77i+kjKg7+7DpzD4bL5+wZtWYIFrHQXI+Mq9whVSkS/9XNWjSUWxwQSGl/9KzxRdWxA9584Dq1GSzvDV6bNMUO5yaLmpdlqPcayTMMvF6FlezYqFlqPbq6W7Bq3sroOc6RhHEMr+YY620b/ezcCw7TC5PjZF8HqZns7Z2uXwwV9aydbKr6ch20yvN/IAjN9QBOD5t1lkznVLb8vefEtD2Jm0GgvfqeRppq0ainpWluSIKlDk+DQf5EeJKLl29FU79tmhnMALefqEY1oxKGo0tyuZ/I/6j0eI91+g8snECiLqki2R4qEXaq+slVc3mNXlaeKqJRTgqtSjAz3fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QnZjoGgIcEUP40CqmQBJYUuAmBfobRJOlbitbtUwDrQ=;
 b=DQEQ0+41NMNFKt0qSEz77N6Ztyso7RLV8Wlf/4tyO+IjaEBQKmhSvUzjPoChctOgKK+HVCRr9Nh6S91+WJTp+fJOhwY1C5XKQH9mTxHpMHAnNflE2yZJXKhIThQ0e+GG0J0zlGRTuARXo8ie+vShqwB6k+SbRo9kad2wqlQ3rAc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4162.namprd10.prod.outlook.com (2603:10b6:a03:20c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 22:38:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:49 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 28/32] xfs: drop compatibility minimum log size computations for reflink
Date:   Wed,  8 Mar 2023 15:37:50 -0700
Message-Id: <20230308223754.1455051-29-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0044.namprd07.prod.outlook.com
 (2603:10b6:510:e::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BY5PR10MB4162:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d0e4733-d075-46a1-f457-08db2025e278
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8QUUMEy/VjDzX1+mx+AydjRP5eQg4/pGYn74wbkMEgjGP1ewHA7IV/Y5wp1xGV3MOcF1ssRFQrOnborKyulhE4flzxitZ29gtfN43bwQxGWKhr2pPbjZgehJTfgbyxL6dInRAyCtZA9OeHR0+GhHRnScqdZI3jgxy8+aS4CNNzVCebVPRaR5kbBOU9QNiAz4YZbsGZvhKmBx1iR8rqPFMT4MSUtrjEVQnAgzztyyJFy/FvYwE9rWBhMDn3GOY6iFQfNHY/WNl83JB5ajWmnjr2duXC+zKOGI51bPciyao463/OaiFx0g0cH8ZhVCHbKzdkOFRV7c6lyssPqMQk6JR50qfhSqCjJlHWG+e6KwxUANEB0KNWY7JQTKDbsNTpKMabVachQecnymI8cnCUEjDfzq1NE/RCrtmOB8lX9sMruFGgubpSB0YqtImlgboZszhartPHlM9Ry6p3f5EWz9ciQjwu1lVTnvI500U9+el7bc3k5b3y7XV16azzqFiJUrXU1mqAnpGr+hxkUZzi9DFKcip103wz6mjpH9//TibbMjGcP4ilWb6ViJIxY2swgcCQPwjUF/Pzf1pCetx2L76zU0sqbGimvKk6qgqSm2AUu+6Mgk37WDfk/u5H8lW6Cdv+puRgONbXEoDDGG6Cf9ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199018)(6666004)(5660300002)(8936002)(8676002)(66946007)(66556008)(86362001)(66476007)(36756003)(478600001)(83380400001)(316002)(41300700001)(6486002)(6916009)(2906002)(186003)(38100700002)(6512007)(26005)(9686003)(6506007)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?73WiuEEzOVBWKhYUs0k0mivw8uks+q2Ef4NsOM2VUNq+AChV5juWs/yxzr3T?=
 =?us-ascii?Q?lQ8oOHL2UAr2FYZ2WJNew4jHgoyDIatlHmi7tjAJe5lM6A573kNJek0nOipw?=
 =?us-ascii?Q?6ppNPgSj6GhSDgIedpGiPSq25zad8v0nDZxdafzmN5hT+z3WQ+4XM4KoIJ9d?=
 =?us-ascii?Q?+TEuYg5Ui/OjeVyB7bjzE3t7Wy/cDfnRTWdmvy7Mr54wdixAExm1yI8QjGX8?=
 =?us-ascii?Q?j41U+hrnnrVAo5mFT29W2/lMWUqfOqA+tK79WLggOEaKLTeQ6f+8ll0Q+5S9?=
 =?us-ascii?Q?Mc5SJbsA9XH4kh/yv5N8LiDcf+/nzYS4IrONDdmqCGICl2YtMVYEGSFthx9R?=
 =?us-ascii?Q?JrrMbn2Yo4/BnnwpJrKA8WLqqucJ/yggvuFSt+v3K7YP/3LJ1qOxRqWTVLlU?=
 =?us-ascii?Q?d5tLnErAk6UjjYfOVDZi2sU/Ydtrxh/1N8P2iddJHDR/Ugj3Kd+iwIP9DoBg?=
 =?us-ascii?Q?0WmusS6op0ZyoMFueOvk3R1WExcl/prrBV+u4zuP3Sb0aoxXsdQJfTivavvj?=
 =?us-ascii?Q?vK0i4FduwZdv3LAs3Twjb6IxKEgllupVwPe2z00qc5TRtRamcZT4hqLzdbUl?=
 =?us-ascii?Q?J0YvYY7Iv/XtKDY12BwE1mpxyZ8R6M32jB1COX034K56CXZqxiVOvq5sg+j8?=
 =?us-ascii?Q?NKcWpaelNeT/Ghschon3B00NpptdCTA3xKfmwF6nCBqtY04OCKEJY+Z30Yfk?=
 =?us-ascii?Q?3QNpt/7R90Ps8NyeLdARAXqKchFukb/Gra3zn4O8OVLqXfifbuKUVHIwcmnq?=
 =?us-ascii?Q?QEB9dlLSySav7GDrayFo/aJRdAFxXf+8DCJeIEeAx991TUs3L1+h/32kTZiC?=
 =?us-ascii?Q?K0e6BEBqYVAnL1lELCyqwp+G6QfaaYmept8JEPkkphAB8zGJwgb3s1NIfEDH?=
 =?us-ascii?Q?HCyJK2LYiJ1cW0AQOUO4Q73kabuGyh4ozViPp+Y6MkiLyBOnAoAKmAShkoFp?=
 =?us-ascii?Q?v3JZRTZbeVB6JA+PKAEYMQvt3x+W+AtCdQIvlVS5ew4mdF0FXXxb3ACaNsCX?=
 =?us-ascii?Q?r6RZahh4xpPtOX4D0cGAoowjZmyFahrc9ualZvRHKRLmTOnkKamBGe1tMAGB?=
 =?us-ascii?Q?aP50bwkNohVz40yuvH5Wjuv41kPLwuqWx/hlnFfvZqQdAx/fVV09n687G6ix?=
 =?us-ascii?Q?kJI2m6Y4k3MQPUo1Z0bngjfTW+bg857Wp8nxpu9qz3kbCCw1Cw3lGdaLfRuf?=
 =?us-ascii?Q?agPNiBxI+wWvo2+CeJ3fwvnZ6zZIQRYv1zSGMElAdvMQEy8tFna+zABoHHTR?=
 =?us-ascii?Q?tfgJkt8iV132uPLksph/ifLdTinI7XvpaDvyjuvJ/W1If1c0QbnNv6RCmXG3?=
 =?us-ascii?Q?AMzdhtdYoLctkEq7VHGhOW2bLFdyXFbaYTdQY+qJQwUnMj+ULdU+A5FrLE1E?=
 =?us-ascii?Q?+inR6etjY35fcL2DKV2TFF2PhVB6zsy+MHcPFNHlveBneSuWsxuPP0YRWtNn?=
 =?us-ascii?Q?hUDr9eVZY0dqdXSgpRaJzY1QxafDR9RlJRg/U9pY7nmbVCHSEMy6WfimXqXy?=
 =?us-ascii?Q?VxarJILTtm4hobKgUv49/57qV1SL7wBpMpC5g99RrNIXw5rrchgDpYtjyIiY?=
 =?us-ascii?Q?/1VMze8TwC3Ak/g5eh/uxVo+YNt5LTf0i6t6hAP0TmtXwMdhhOLb/6Zfs6gM?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: z4RuLFNUUPi3QpbllCjPaWbwhfQ08ke7EbxOJ/X76KWtW8k0HUj5oUcaZh7ZxOd4QmlMGy4O5zRBcZ6Q20M9HWLCx1RnXntyqjq0YdXSr17vKgvsB6ff9IzUlr5wZQD7LjedFNw2ITjW6cwxzC+S2QSNlDRsLTwOoz95UjCto1dTmRgnUzW5MaDmfukIzLWkViq1z8i7b//QfvD76KobNmTGwLS85sn8dlBmbN3AsUTSSjCHXLXoo6btWzDA0L56oMPFfYw9qSgs8L6SmiJVzGalnbn0gPmwIS22X1oB79re9B3UWmzPjun15bF+iPtlsh6477Z8ETAtidpxpjTdJR0wMXzuEUSty1B46/fF6xbAsttQcJgWuVk9G2pBHkT2fDsuitXd5/WfY+4gnKh2++715HYMy4k12eEuiSZUBjKMPSJQWDAYDtaxs8Ye+ufB4Dhof62rimzLka5TEp7xOw98N6bXWFJ5FgaynL59abXP+KP8mASrAiNU4qUcmWVmbfLQq2YmU7RaFX2XsA20wvLmfOS2zNwqzOW3DSuK8JAfImT0n7HQWVNlAwfCu3ZfoH1XHNROTD2UjzYomDh7Xrv6H0bCvmIIYOQkrBGgmiO1SfwLnw4tUXfCxdMrkqRBYe5QReFpbTQ5G8PA1WJFc/4OSZLDnS92RN00E2g/2stijUk3XWpWFrN+BFvBC87REFEq5o5SFe3S40K6XVJKmYQorUHvKbn+9k7WEuptem3pJJtOeqTH6ybTnz0wQTktZyqPl9cPdAeYZ35MH8Jz9A==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d0e4733-d075-46a1-f457-08db2025e278
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:48.9919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ulwZqHRLlq9PVa9NvUKBF0XoNwa60rWmgiUSg7m0S5+bsPXnXgEEr+weemQxVCKPMegn7nyLTpeQ510sEgMGyyynfaRTTQNiUim6ycffGjA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4162
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: HjN7crxr_T8cj8C3dJvwAlOOkkicHMcE
X-Proofpoint-ORIG-GUID: HjN7crxr_T8cj8C3dJvwAlOOkkicHMcE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Having established that we can reduce the minimum log size computation
for filesystems with parent pointers or any newer feature, we should
also drop the compat minlogsize code that we added when we reduced the
transaction reservation size for rmap and reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index e5c606fb7a6a..74821c7fd0cc 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -91,6 +91,16 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 {
 	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
 
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * drops the oversized minimum log size computation introduced by the
+	 * original reflink code.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp)) {
+		xfs_trans_resv_calc(mp, resv);
+		return;
+	}
+
 	/*
 	 * In the early days of rmap+reflink, we always set the rmap maxlevels
 	 * to 9 even if the AG was small enough that it would never grow to
-- 
2.25.1

