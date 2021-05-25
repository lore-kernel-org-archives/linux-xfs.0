Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5AEC4707F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7425461417
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbhEYT5K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 15:57:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37928 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbhEYT5G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 15:57:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJnOxO034959
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=aLt3wXn0qkd5LzANTH9fN2pSM8LdVlKxuTnBF5QjBbU=;
 b=mDtrTFEiUbC4vjiWSYmmbCvRGm80mlRusFcQa8PLVGOApM107yY3EB78eIHbWMB/dwI4
 4VLIQSxthgA9p6EUxmTp7p0I55COwhYsf7x6rfS2iX7RzJhjykPigTU7lcYp/rmmdGaG
 b96LyFMB46bvfqcrrSu0K+viRT9sK/2nWRftbNw9ogYsqzneJuBfwq/tC2ouPYsW1XTd
 EQtNZdkoYBjpwaH8bCIb3ENMjlZrDdjvmEfJpGIyeuKAtJwjY4Ykw4z45i44oo22vlGB
 bI2SHOQjFLv6QwW4ryqOY1TShgOJ/w+Ii22HJxGEYdvIIC/vo2VHPXjYbNRIzAGtQS2s Ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38q3q8xkk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJoDik188864
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:35 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3020.oracle.com with ESMTP id 38qbqsjk0g-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXTK8E+xkMH7QtMHZrjV5uiZIPPr/jeUaER+/GR2hB6stPnfEWa06oWWX8MOm5DtbTDUFVTqSkNqGZIgMXMIVZj5mzy0TVDRVq+1VUdT42yy4JJiBgxyYa5RKExHv3d3pqpm6uBY4iF4CWiQsZVuP/oJvIonfvk5CmalZbJ7lwNy/QA5Y/cotMORCqnRyU8+MHzw2UiH/SyGCoSpaKLnTS9AdHfWJsMXsfbPv6EdQb+Y8mEkDvhYjBIQhG59cwTIvEz6fRgOOLrZqwqCmW4rNeejUT6v2cqBjNcVKHOiWpaK0T5Fa34IaCKi72kZo9GDQylRJL2z19TTwEptupJT+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLt3wXn0qkd5LzANTH9fN2pSM8LdVlKxuTnBF5QjBbU=;
 b=V9emXuLBXtabosbZqHdDFdmuq2CqI7CusPEF0iLK6OVsbzCzh42VEHWnijzSNFmNAwYaJrJ1vo/KfR0CrhHshSXv/PPnb/KsTlODXdErQHa45ViLdjA6akFTe10HhSFXBiNMuaigNK0oMHE9o9y1i/YNgzomAMQxifJHAn0WXw38jBXG0gK2h0WJKtkQ1zhacO1/Ak6m+IiDb/H5lSISdTNjV35M2L93iXnX/K1nF0NBUuWoSdtXls/WJ6dUUobN1x4hcsnwBeFIW12qFNtYW5TZSzv8G7QCctiw/aGzJ1KUX+cH9CX0TH5B4L6ZGI0YCqAMTBaA+FQJ59joTMLZfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLt3wXn0qkd5LzANTH9fN2pSM8LdVlKxuTnBF5QjBbU=;
 b=zM1SlRP8GVRhExA/nbBiHLWjFJsT5/U5OXQnOclW0MSSjIcfSYLelupgxDy7oioDjcxBhDhLBThb+1htOHn5eObLlETPIdyLH6bpNLa5jq1bXwqDQZ+N2zYwfq41M3v/0wM1uozhvI0oqPu8PrwWGZCD5NhHAZs2WuVp/QqbXYk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4544.namprd10.prod.outlook.com (2603:10b6:a03:2ad::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Tue, 25 May
 2021 19:55:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 19:55:31 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v19 13/14] xfs: Remove default ASSERT in xfs_attr_set_iter
Date:   Tue, 25 May 2021 12:55:03 -0700
Message-Id: <20210525195504.7332-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210525195504.7332-1-allison.henderson@oracle.com>
References: <20210525195504.7332-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Tue, 25 May 2021 19:55:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c30921d-c75f-4bf2-9936-08d91fb70d1e
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4544:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB45446DA3230D59E43E69FD1995259@SJ0PR10MB4544.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VGasIcKFtzICajR16ND8iDeP9poxjwry4Ji1VjiF/GlxQgCl4uejTQlUm8kBZGQxZDdgiOrb2SHmlvDIk8OZrERhlQNF3jjrMH4QG8InyIx9OC34VaLycvqHBaRH+k86tAjCujFWxr8WeA46fZC3M+7C/iJ3gmdiSUBKLhCXWpmAGv4mqXy6Y1dB+u7HAkpD9yqHXd3shJVNeLHh04yJNAMDIInZ7zthDkTBJIRTHIs3GKw4BbiKc8edhpftvZuJyrg0EWl7u7kNs12m0+3cmKSrpD900TGtInO83fnBRp/PM7FTCwbUD8Ha9UUJVp8gGrOX9P2S8yDNTTNeWSlbHFvO1y0/QlhEzL2u5JyUg0TVwQs5LMBuNi0bkYij8qZQFdEE/OlvlIcm3XxzLJAl69ZnL3e/Kdtd0jU97RzXHFIluP2hn+0ySTzQ7EfjbkRJTAdqfPQPE2kf/xfqhL9ie0LNJ6NNHviRvdNoqG3FdpERalNcuW/F99zFHldgOqPh9k28mnCeLyZi98QB/+mYUnpfLYlmPsKTUsJESxw+hJafasXaBY6SMvEF+HGxYWadJoQVrHxM7Crj5t+6C4k8WKKPLcARhgi7WxL/KPEZH3QfxNN/BN2gCrYbBfm7lqUFl3mlsLuZjwSehKix1C8YPNst8i59piAxA9J2tNbUJRxNBOQsCWVa88hB6BVj1kLJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(366004)(346002)(396003)(136003)(376002)(2616005)(52116002)(5660300002)(956004)(478600001)(186003)(83380400001)(6486002)(66476007)(36756003)(2906002)(44832011)(38350700002)(66556008)(66946007)(26005)(6916009)(86362001)(38100700002)(1076003)(16526019)(4744005)(6506007)(6666004)(8676002)(8936002)(6512007)(316002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XOQs46Iz3syxQ/34tZb0k03IQwpTSkqJAnPlgY1jpViPysaoQmEGLpHpFDEN?=
 =?us-ascii?Q?MaIeUiHkqpYvh1G9ZvxSBbRqGpGAHCsYE0xlX1Dz5Z5ADrVpyn7phIjYPoNP?=
 =?us-ascii?Q?4myh+u7e3rQTonY211A2uSV3ssEXAyw5jBMLoNuYa3xpvFou4QcCH9QnoTVa?=
 =?us-ascii?Q?gMxLPepy5auHkMaOIZjbz04v5JG8JZA43mX+zjJm3o4YuBPMt+alkdzvyic7?=
 =?us-ascii?Q?BLDubaV4pCLZoHsBA7I/XdATTiMOZeGKgCd/lLMQT+hJ7GckaSA0ujQKuGt5?=
 =?us-ascii?Q?5m4FSgox6IZC9Fgd3gTwZgOWMuFVkolq6KaJgtOI6+orF2MEYxZXpTcbyomi?=
 =?us-ascii?Q?IQqYWcU9b/ID6v9mZmuZsSpsTs4dehonx4IrS8B2dJjmDYuHEUf6XJKiwns/?=
 =?us-ascii?Q?O2opIi2WqoQhS2s9M0zQ/yjO0hoPcbp9cfOo4Swuv26B26FUxLA1Gx2YkMkQ?=
 =?us-ascii?Q?5W8qjDo3oNOdyRwLKm5aDR4vCB80o4ZSo7y6q75F45qIsDD0lWOkKcUq6bVD?=
 =?us-ascii?Q?dtUg8heA+5mfV6NZqwqUosiMzpVQcYfECNdvYVfzh6ZBda+BM6S+3T7X6xXD?=
 =?us-ascii?Q?vVjmzCNvrlvysZJ6p7fq5B8TWnjtmwRulrMXkiGYe5iLAYZoiD3/KT0ZE6SI?=
 =?us-ascii?Q?m4HZCi0NfrH+WBT9wGXTV2+X2+3KmhcRiaMyEw10uz2gQCNweQVLFDXnXa6K?=
 =?us-ascii?Q?NKsNHGxn7rg1OObn8DVIL4O93mO7/DGyJ4HnOutRra4io9390pHXSext4Nc3?=
 =?us-ascii?Q?NwSMPycgXIEZ11IJJhTZMn6ubt6+ORh/iDRFGZzpIzVZoRKOtB2gqL9UX7/r?=
 =?us-ascii?Q?LbWUQ4/ChsCacLCBLCboE6vtk9cdjJg3J4tzln0GFnCnejippxIa/ffvs9+6?=
 =?us-ascii?Q?yn5wGSlSeNUiRMl2EDJumiPvuedeZRmqoZQHFfBsvpkF30tDtLY8cI7hx69C?=
 =?us-ascii?Q?+lp5tubEj1v15yhh7SJFv1uvRzCAFjRgfaYDriRbrMvrlGY/xWgoRZVFD78b?=
 =?us-ascii?Q?VwFZVRttRMB4X7pB9U9v7+4M3GN0wC1QhmwHSNAY16SPvFcnyXdSFxbEqzX4?=
 =?us-ascii?Q?6mFriCO01/8J9GnLfSCjEB5ppr0hzmjOpo4UAXfp/HRBKYGeLp7SR470eHVv?=
 =?us-ascii?Q?Rac/HtN7XL/Epu+XKmVivvy0a26A1VzhItXcs5clA0fTQQg7YGFk+J3nhzjI?=
 =?us-ascii?Q?oNFhoiObZjQotXIBJa770zMChK6J/KS1i88SIM1jrNIK+WDRVBdwYtB/3lI1?=
 =?us-ascii?Q?GiR6YzCe1PAXmlsuya+adTvM0T8b9bF9kDnLxKUY5JESsTNJI9gM48Zj/Ny0?=
 =?us-ascii?Q?hmwb0q0ayNToE2RH/e5Qaq3n?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c30921d-c75f-4bf2-9936-08d91fb70d1e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:55:31.0331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eMveKpVMxT4c+S3RPYUktlusQghiANJmbyGJdoc0Ih3fbQ/baSbyjDrudT0F5Q3wyXvuhj93C/5eq5sUBsx70GxWi9SZxSW6pVXn3Q0WO74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4544
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
X-Proofpoint-GUID: YcAGu-VNlvUHzQ5eJjsWoAqj5eKFcbM2
X-Proofpoint-ORIG-GUID: YcAGu-VNlvUHzQ5eJjsWoAqj5eKFcbM2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This ASSERT checks for the state value of RM_SHRINK in the set path.
Which would be invalid, and should never happen.  This change is being
set aside from the rest of the set for further discussion

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 32d451b..7294a2e 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -612,7 +612,6 @@ xfs_attr_set_iter(
 		error = xfs_attr_node_addname_clear_incomplete(dac);
 		break;
 	default:
-		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
 		break;
 	}
 out:
-- 
2.7.4

