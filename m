Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5334EC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ABDC61B64
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhKQETX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:19:23 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:31760 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230227AbhKQETV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:19:21 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH2FTYE003522
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=Abil+H42oh2NZMS3A9EcgiYlGmXNOaH1mTC2GKsdTJk=;
 b=xkIajCzIhFPfbmIl5Wewqjx41pKVOMu38M16xkcd5xelmZncHgyBo6kpeJciipWJE6HE
 7e+lBivt8wHGxi53pwnZsft8lG6kR30R/yvo6+RSTjuAUJxmpgaFGrnEl3fMeDPWBlCp
 jkRhfb/IRUUYKTpAikd7QvKoyMT3ngH/f8D5AdtsIec+o2hA3ZOiCcEPactOiOXwd2hK
 prlkuogqrhAVqYa38KSgneLchAQS73DC9CvKyUJiYjz86YlxKMF5BVFwKSXLYuPWh1V6
 QfIjhjN0ZPfaVLYxJrxf/+8E7UplC6YR3Fd47/nwSbRcVMvyB6C2ULL62jaakuSXdwY3 Ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhv5dru0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4AEiZ180637
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by userp3030.oracle.com with ESMTP id 3ca2fx6ayx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TuRi6yESJPJu6qHl5X+d/QHiDueTgNdFOpcjlWqvkrKK5652q0d/CwnPcqj8Nh5JtJiEIr98lfK8SLA1jjHZWxrmipAN97SpunYdgsYQEW6WUUkyvKHhVNWzinB4gQk6sqI6B9J+3zB1LU2O6HwcQ/FF4MaWs3wZZev3nEHAx+mgZahesfS9ZAtY7p9cfkwGPCqzkKLKQEx8eThJFZMwEbnSb7fay5wlUG4l5yj+RhyIOZ9yk5psY2HsG7H2uxpbax4n7YCZHwoiDvsIdRs+eZUSVOhqdr3CVB9MqtC1OhpAJfH9HJ2nOmDBRavdffJRfXLQ+yeyI+8W/0BBmqWS7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Abil+H42oh2NZMS3A9EcgiYlGmXNOaH1mTC2GKsdTJk=;
 b=QgoqReYKCyD6F4YZYKWJERt+GERBZUWQV3NP4rPWboGhEhKdS6VbcqK+ZQ8ZM+ygWiI378fT9Klf6HVCASZgIej+sKJRytgRVX798Q1ZlNiJD4dI1z8CqBnwC5e+OxHYIb4GtrvUUeFndRyeV5Nmex1AY1P9pdQ8PyqJyqVo1q2tFbgnVcFoQsXwEJtW7P/bufRXb2CQ+i8PPHIXIqKH2UclsMvxawKqcw9NLwwsGFpu60ZU+3lpRliixUex+V0QKO+8xdxWXLALIWy06Ci6sslk3p1AIPpL9ALGiy83e+CZ1xlAq+p53rrVLfGSxGDeH7xYAcqsCmAFKP4Y9ST0tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Abil+H42oh2NZMS3A9EcgiYlGmXNOaH1mTC2GKsdTJk=;
 b=JvG+s/A9iNNo6EVLIdWv/qZ+Qctage/ydqcgnDHTeyVIqU/PjuoCo1D10eeh0mqd7sHTLlMZyi5kzfhm2G5gaxa7plB9WwrYK60NacBl+163Lx7SWmHhdVI8OUjB/Udt7l23aLtgWQXtZ2i5asFq+dzsRsyMr1TI/EXiovOq+Bo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4446.namprd10.prod.outlook.com (2603:10b6:a03:2d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 17 Nov
 2021 04:16:20 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:16:20 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 01/14] xfs: allow setting and clearing of log incompat feature flags
Date:   Tue, 16 Nov 2021 21:16:00 -0700
Message-Id: <20211117041613.3050252-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041613.3050252-1-allison.henderson@oracle.com>
References: <20211117041613.3050252-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:217::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY3PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:217::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Wed, 17 Nov 2021 04:16:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6448c82b-144b-4c75-362b-08d9a9810201
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4446:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4446678E0E78FB27670F8ECD959A9@SJ0PR10MB4446.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: um/cfChlw9tWBnrICkqx2UPO+xm9PqdM27Yh3V7iDPW5aXggmJYBO3mRAHyRyR4Ej5ZDsv/W1ckOnGgFZqP8fy83K/k9W4kw9HSWRbbUr1TvUS2zEtQpULWyOHfz/8TWQCaQRXnFXVBHhKh87o3fA7Yz1yzBO4zsDxmKIDjgiR/4rbMsC2jcZzJJz4P72X3+hztiz1j1u9g4Yjg1in+uXIuKbinlWa9tVzKuYPWJFyJv0GbbmAJGJntFTXtLk5rXtG0nn1/Q8GEA0h+aal6IzwWQs/36RE87cXd4kRDrtAczK8LDfy0QDbXKUPvuPpBkICEP7TcAcUTmCIeeyjGM7z+LaRQxifSpZRN7ktOQStokzx3eX3oIovieADExLiqjDp5N2A2j17Bm3tGM4WB1qyaWUxORNoNknv2w/4u0hkEQE3PHyGs9XhkygYaIWkaUu0w73dBHUcJ/e6WiCQLUNNNIjcOdXh2m003CLmVfRuCWhViRwYgx+ZQQegHUD+O+JvkBepvaAII2pqZ8yVmlcGQvEW92CdQonYiurH7n52UIOwEgoAt3yevMVttBnFlni/r5OIsyIn5PzLBjcq+YK1U4cDGtRBDP4cl14xnN0Wp0uHSMH+/S5phYrDLFMRxRgVsA32RmRjiGOsO0irv6oepUS2TZfeUzwd+XPx5rbbRTD0DnXchpZYrL+wwT8teUVAGwGJmD0a8tznjEeNnwNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(2906002)(956004)(2616005)(83380400001)(38350700002)(38100700002)(26005)(52116002)(5660300002)(316002)(6486002)(6512007)(44832011)(6666004)(8676002)(8936002)(1076003)(66946007)(66476007)(66556008)(6916009)(186003)(508600001)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1gf94gQd6x5GblwP1TJzAPR1rwKiODGWMqC3tjJwq4cWogdqvMyzwKGX9OjR?=
 =?us-ascii?Q?rcPvp0sGc9Gl5TlTapCwG0OI8GBe64oOOaGkPPNcS9ZZbtln6AyvHquC+LQu?=
 =?us-ascii?Q?xbVVveGoCBnmbEf3DVyMvN54L5YQ1COXQfny51aJ9DRxlUmeS303pxelMA9S?=
 =?us-ascii?Q?7y6TLDPbUnuMQII0tCh98bGqOvsbCcukt9AS3H1VVS4N+M/ONy9WdA9nzVtj?=
 =?us-ascii?Q?CPij4dYMGz54XnmxQ5T7IGgAYchNlLy3bo6PvC+kAPt9WOLcUEIQ/o5Xeayj?=
 =?us-ascii?Q?8sOStjtmoMo38xqUnQFNSVUxvEXN3GxVAoD8OTjvw4hn6fH+lEZgK2kmStuV?=
 =?us-ascii?Q?NuKBmR0yUCOhfPjdTaZRG325mDvCzWFCJ9xlzTqaPVJPRY/SKvYITGL3ypve?=
 =?us-ascii?Q?BCNmYSO6zCc3HUq8obLxmyr4LtKFu8LiMdc58mGPg6qi3h0VJgGdZv/iI3x3?=
 =?us-ascii?Q?90KXryCu0QQnmcXijljdU7PoC4YR7kvfO9iheCpu2Agdh+4Hvhu+7FhRxp7V?=
 =?us-ascii?Q?b/2jOiKvfR9E69IFifB2y5tQATJNdz5IGgdw7Oe2Mkzb8H40fiZB1DtKRSGc?=
 =?us-ascii?Q?DmFKRXLosdiHbxVegLwqaaal80QkxQTqlZMydnraL/blfC/pbd8EJSHouAQW?=
 =?us-ascii?Q?hD2agpfZ4N6RCTEj1Tz48ebwPe5W+kyBiV8F0tbme1ttB1xj0xVSgf0j+mki?=
 =?us-ascii?Q?OlMp0j/MaMOxGC+WA+RatFpOuA47H0DlL5c16fqsBiGnBZR1Gi1bWz59K19e?=
 =?us-ascii?Q?9fc5G75X+w0nztzLaVmsaEECKY9g0NSki42+5jhSGgtIRFlBKWMvcN3Szopa?=
 =?us-ascii?Q?GsAljP+UGOg3/m5gNFadMi1SL3zBO9EZdbg9ahKNK9DEJkMAatRMthOXveeI?=
 =?us-ascii?Q?jGQaZdbNle2HsLOePaglmueIqnnjvfqS5ty59QTNaZombz3hQbytwAylAewa?=
 =?us-ascii?Q?BMEZL1FMiJ26fu2qXxvg3+UMycAQY/sIUA87ooumGb5+590q/ZVxMF2CeggP?=
 =?us-ascii?Q?HzTNcKLT+dAIG+oDS7TMI9jOWaZDVe46wEcwvrq4fC78DbtBasE5/loVgppz?=
 =?us-ascii?Q?18JEnCjsS1YfOn0jyt/kEVVsUsqw1CNByCwIleV99zvc+isUUoDLSyzrXdLx?=
 =?us-ascii?Q?886Nbk7nicRLT+sIqOl6zYCM/vGaOXVSg8SMdnJEBlWf+oJz1QbJKBDnnnm9?=
 =?us-ascii?Q?MKxFz2jCzkZYdEPXPnnm+ao/mWPN1O3yxJmXlgm6xQNg4ixYinrIBH8u16BT?=
 =?us-ascii?Q?Y3Bv3YPcfgBqsH2fkUDgb9GXeDsLagOW/k/BzRGmabOH99HQl/JTfh4vfO8h?=
 =?us-ascii?Q?ITTCIbUuRbkX5yOQDJVxLF0y5SEs0xBpt78AKQb8TZyIs7YHhDXqrSfLBzsX?=
 =?us-ascii?Q?LGqbx5EqW9n6bRnQ+Dt78O8saYL/2UAvGY3u6PiJRdoFWvItdSktqlEfMi/2?=
 =?us-ascii?Q?w8zMpWAgTsxG8HL7CwlSOzUuCRZvGtYlTyG152ulr+Wl+2SYvQ1c65rETdgD?=
 =?us-ascii?Q?UmlZGq5pEKvVyMBGj9lzLA8mOF/iRqJQjKZHq5wkQp78s/QWMeLVNBgCKVQu?=
 =?us-ascii?Q?ZHqZzlnon0xXaDA6RPJklQleHeFpYvyiqLFGx45BT1UCofGQMb6rgu2ssYxg?=
 =?us-ascii?Q?hq9NtcZwbfzZYRcUc6R9EZPqEheeoBZxKo1KhCYXABzsk24HQE0lPirL8Gcb?=
 =?us-ascii?Q?nDN4mQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6448c82b-144b-4c75-362b-08d9a9810201
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:16:20.0528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uZ7Ctwab10fKGFQfujMDtkAdBF9vm6RuSMQ+lsHlif8ZEIyvIbBvDrgmLmYxjXsotYqCcPj+iA+IfAzk2cYMOq0/YHb7lgJ0JwhBjcBPaVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4446
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-ORIG-GUID: k63zoavJuPEBzHEL3T-3GHuczFb09Kht
X-Proofpoint-GUID: k63zoavJuPEBzHEL3T-3GHuczFb09Kht
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: a9642049d91105c676526817b527a1a62940888f

Log incompat feature flags in the superblock exist for one purpose: to
protect the contents of a dirty log from replay on a kernel that isn't
prepared to handle those dirty contents.  This means that they can be
cleared if (a) we know the log is clean and (b) we know that there
aren't any other threads in the system that might be setting or relying
upon a log incompat flag.

Therefore, clear the log incompat flags when we've finished recovering
the log, when we're unmounting cleanly, remounting read-only, or
freezing; and provide a function so that subsequent patches can start
using this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_format.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 37570cf0537e..5d8a129150d5 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -495,6 +495,21 @@ xfs_sb_has_incompat_log_feature(
 	return (sbp->sb_features_log_incompat & feature) != 0;
 }
 
+static inline void
+xfs_sb_remove_incompat_log_features(
+	struct xfs_sb	*sbp)
+{
+	sbp->sb_features_log_incompat &= ~XFS_SB_FEAT_INCOMPAT_LOG_ALL;
+}
+
+static inline void
+xfs_sb_add_incompat_log_features(
+	struct xfs_sb	*sbp,
+	unsigned int	features)
+{
+	sbp->sb_features_log_incompat |= features;
+}
+
 /*
  * V5 superblock specific feature checks
  */
-- 
2.25.1

