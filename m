Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E2C5C433E9
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F93661A4F
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhCZAcC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33242 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhCZAbu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0P2ea040604
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Ps/fKlwvvhXS8EiYS4hPANWhJ4FP/hAgCAKy2ydTz+s=;
 b=cxE7w8cfvky8858od3J0VLVbhoprA8btFVmHR4iaYfwY+6GyFzkPpUDIFvrAC/ewVxL0
 fW4Mv7xSrqEiRXqtbC88X9NOEFzpZIdhw2Ttk09Ts3muUtSRDbFD9Pp5amyCcE18Xn9h
 yLpySTuuzDdhxyaB1lgzAl3DBy6k0LNXXlUdIGUU8nLyOVKOILXmROHhV2Rm/KZa63G4
 DNJUhJVvpInPqWZvDrHvJU48X1Agb9pXGerhFyurZHsWjf+WCSKQsXJaPYb7JwaK1W1P
 0oglG1eO68VeEhwQ1XNssX6PGGDRc2+dZZBrg76o3l9RYUv7/d/SAxm/v++6LzI1RZPr SA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37h13rrh8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PK6S155451
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:49 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 37h13x0454-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DP8AGVB0ePBKvdQgyinSQ24Dtr30DVCocpQ6BkEfDuDvW0fohROPp/QrMm3xabAk73CPVmTatnHWinqAjjse2fSPVeXaLgK2ZYCDSHnLlMy0aGalx+lMUBZ6sUDJfQBowI2omZi920cKdXcgRNDBPvW7c9duLO99jCXdURmcVTZeRjCY3JLM/m0DteM4tJl2Eimt2hdxt8VX6Mviar1EijQyMtY7VGG/ZuwnqgyX7zFKmM1TvWRJExvpSgr5j6piFvV2rrVu8oGnis+9XXQMCTBevY5B2vb/4vOa3xkffXrBd1EeVVLjFt0K6u/8LIxyPUc/6E/pkrr5x1QYxZgxVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ps/fKlwvvhXS8EiYS4hPANWhJ4FP/hAgCAKy2ydTz+s=;
 b=fq+Qg1EeJBOThG4+5r17FMYfEqfkttGzhKU2m2Gruc8cJvsN52jK11jKG6t3myzuP/OpyA1fo8ORWEf9S2hjT4YQJ0F54YmOL/+QJIciGkkUlT2VsOOUjRY6TASMdCOLuKziNzeoz1Zc/Gdi0KRPUH2Ptn/RpDDBNd5x5blml5ba+4nlKBLNnYSy8Yacdwhx3BRuFVrgDw9cbMMJ1Ocjzxh0oEaSAmwrgDmJqzGortct9NOhgzIuXyMgnVA/ROcg7uWVilnTGnfpcEpILamV4JegQW6Mlh0JaEAFjUWujMCKOYJ4P2WQCwg2+i/HyJY8N1S2jI9Ex/KaYldIg7qV0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ps/fKlwvvhXS8EiYS4hPANWhJ4FP/hAgCAKy2ydTz+s=;
 b=o5wsbhPxX+yekr/BMphpZuwoocjn+VYs4yNr6QWGXNyaqP8/wZy2PDwFWfgek2SJ0wG/7ZhM7Er0Vgl9hAJhVr/Z+fFX+6qtBtedWK+bEvPNPGmFLJHKXF1QilhZ7l5TOAQKw613k6j7AsT9zhoXW6wqq5MTnbFKZ4wmBKd0a0c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2758.namprd10.prod.outlook.com (2603:10b6:a02:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 00:31:46 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:46 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 11/28] xfsprogs: Check for extent overflow when swapping extents
Date:   Thu, 25 Mar 2021 17:31:14 -0700
Message-Id: <20210326003131.32642-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003131.32642-1-allison.henderson@oracle.com>
References: <20210326003131.32642-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efe0db66-5e0c-4848-6e2c-08d8efee8939
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:
X-Microsoft-Antispam-PRVS: <BYAPR10MB27584786ED3490A9DFC0D45295619@BYAPR10MB2758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:221;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DQSIqU44tAkqQ/zcmmUnJVDrkOKdC1pSEDnTHKpzSApxgvrPeVHsOgmk3PrWissmHwlfQRBaRdZ3NkFqNIfZOPaT8d/46G/DPYUvtoJxWZOt134kFBgZZWqTXnPTK02Gp1pzNeIJxCxdiBKSDYZWvTixlHmJfdSyfDnNQKKISTCTi56lxfv4dShMHgulEX8ySxd5C9soPBP49pYNcTBRzb5VCwH9te1fNjHBAFWK/DwRVUiEkPXzHVKHHbpAGbyMrZWl86eR8yWtwC02SN2QK36BavfkBwDV+pU0uLh8J/eS3ZEt6aZL7recWq56iALiz+ZaSk0evYYErnFlFg7bVr76UFWdpM48KIUN5ZM/Spcvlp8uz3d2Z+XS1Utx/yQSiO+nkGsH7PQEkG6lEksvRabcf9C7RpNGCXIBY0aJh7VdN//JLmghsoP4PjYZMyuDYGhit7GrBRgW94DN8as6uXGrgNzlE3nCoJbDsi1ebLXkN0LF4jsyQgaqq/3y4av4RxCSwEhs5Grth0EATmWi9aeuxZdoaXAHmH97+yK0CCIh9SpNQFmvk0fqygB8MckRbOCiwRTqKGegocP++TCJbS6ozm9XqCRb+zDYxRXfWE+K/t7jKu4f2OcSaddhOeuW3VzEQafbolS5ZfTQOyvL3gf5KA3pUKnaULBG1wy+4wX0vBFU8jiKDGoBMcnWWe67
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(316002)(6666004)(5660300002)(6486002)(16526019)(478600001)(52116002)(8676002)(186003)(44832011)(1076003)(8936002)(956004)(2616005)(66556008)(38100700001)(6506007)(2906002)(66476007)(86362001)(6916009)(66946007)(26005)(69590400012)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?x7nO70aUZb606809Oq13PkXOZR1A4nHnuER31q9SmGGnWK7h25TlT3gwOZ4J?=
 =?us-ascii?Q?hne50IKJbtjtjHEXmPO9Y8TL0fsS0BpWsu1mL2XHi6cPlGmo5G9UnLS7qH20?=
 =?us-ascii?Q?g4046mmsZTvh4/bOBixY5IVIpAZWWIE17qH9QOaVZveADoax9dCEfkJF5wmd?=
 =?us-ascii?Q?gVX5hX2HzY2/HUTKqOWV+ubN2UqQZPdy8MuxoM6sM0kNF8hjtFvswWdOxQ6n?=
 =?us-ascii?Q?QhJIuPt4sxjlh9584E5KbuBehv10UKc7xdPiTjusvj0DBS4cInhe5NbeB0dQ?=
 =?us-ascii?Q?ZplTIifcD0LfuZHFMl3V2usmT8yl0ImQaObiDrcNPr0VaGzu81iiP0VgJRZD?=
 =?us-ascii?Q?0b0+4PjqH4Uc7gT4LnilEp6PeTxlSv9sWpFNhrj/a+aWqYOA+6+xyylp0obP?=
 =?us-ascii?Q?ET6cLIpKhqxPY6/5k8DmN1PuW3ih7Iu34jj7E1VkO+FJwT9LWEbUhGfkIqh1?=
 =?us-ascii?Q?Lqhwp4aVy4rFImEdMAZIyyStSyzHo1y0GzlwfINSIx+s5VYNbc6SKSvs1uKj?=
 =?us-ascii?Q?OMlFOAd5U763uWU18qr4hKmm67ICXN6kKCYBYkNkNWzwYP5//40ZbzHikboD?=
 =?us-ascii?Q?ybgjo0L5zYOzC0fxU39ld6y80ebsMHREWD5CEu3QryIIOmYATTlFNEKIWfO1?=
 =?us-ascii?Q?eW5Lw402vu9pCBVVPnMmRIrxZelFstAgWV/IZ9Aa3RCN23dYCeB/yH1D6KTS?=
 =?us-ascii?Q?sPCjShiyTGQ06R7LekC5Zt7bTx+rNVipXvQ3SKEbaqc8q3Amafq88RpBrdX4?=
 =?us-ascii?Q?GvK2tY3p1CNytFPZa9j7y9UFEDiUR9JHc3SJpGnE+6v+63hn4NCQNCkLue9D?=
 =?us-ascii?Q?vJ5Xy+ZOEg3tj6unw4mWItKZpWxlkE3lSjgLJsyX3P5hRd8etdn/gP6Tf4FZ?=
 =?us-ascii?Q?uoxse2Oob4W0bP1yHzWVKzpcJN8gsSV6qFvF2E8Lhkbq0DEFyiK6w/RgyFQQ?=
 =?us-ascii?Q?qDdueqE04msM6HOjGMSYwdcIrhHFX4IUrtg+Rkw6nZLDU02dR/fjQXqHNZEZ?=
 =?us-ascii?Q?YBKchz4D/xQkHeVHXyALWQVYhnx/rMkjy6/0RSC9U76jEK31X++LBHYP4IgN?=
 =?us-ascii?Q?0bBbfidN/Jlm02Q5uFA2A+suOkiFLAam8/z2fA/QpJX3/XaYT/2l/IMrwIsk?=
 =?us-ascii?Q?th3pAxKybUWuDgsJYpjBx6fUIURZ77viUHT/dz171H+mDHinptt6EHrG1Qyv?=
 =?us-ascii?Q?EWuC1kKDRMfp5Kl86aWBmjUU0aBkd1FaYIlIyULX1gYrHUU81tUydr28y2/v?=
 =?us-ascii?Q?rxIwQwdWwcfNak1/SUl3EVuPpu0oPoKF0xUfocGBdF+2oWVYOzaH5h1cWDti?=
 =?us-ascii?Q?XPQ8+HX9SIjklZQU3AM0mQVh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efe0db66-5e0c-4848-6e2c-08d8efee8939
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:45.7676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0/aH/X42swwRptlQVFlGyp4v/bWnAP/TJR/y9EONZc3HBqLlkSQFIlQcNRgQJjVXrH3iNarX9hw8jOnZKrp7mE3hgr0cnjmXtjYq44Nnvxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: qPebwzYQCpEBpjhj_Xk8ISvIdDzM63_e
X-Proofpoint-GUID: qPebwzYQCpEBpjhj_Xk8ISvIdDzM63_e
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: bcc561f21f115437a010307420fc43d91be91c66

Removing an initial range of source/donor file's extent and adding a new
extent (from donor/source file) in its place will cause extent count to
increase by 1.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_inode_fork.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index c8f279e..9e2137c 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -89,6 +89,13 @@ struct xfs_ifork {
 #define XFS_IEXT_REFLINK_END_COW_CNT	(2)
 
 /*
+ * Removing an initial range of source/donor file's extent and adding a new
+ * extent (from donor/source file) in its place will cause extent count to
+ * increase by 1.
+ */
+#define XFS_IEXT_SWAP_RMAP_CNT		(1)
+
+/*
  * Fork handling.
  */
 
-- 
2.7.4

