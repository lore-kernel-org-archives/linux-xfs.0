Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 260D6C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiJUWaY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiJUWaW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:30:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9562608DD
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:30:20 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDx2U019533
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=q7IY9TJb67x9DpeUO/yaNdJiidpbzeMN7GhQkS4p9N8=;
 b=mC9sUv18GbtpVlPhPmU2Y9OZWGHHpUQJMfGGUIwLiuW4+NNjQGsC/4QNVJEj/8NbNs/w
 rvS3DzOj+UrR7OKpzcXINN1T5yosOYQOICb3cNZsr3fUUs8Qz/k+pv3HHuJsvkxXyRWk
 GjOnS4ONHCaJ0AiJXosM/KPILpg8p3IVx0K9I2SaYPcJOf6gG7G1ueCJkqlvBed0y8IG
 SKkz4u+9t2/AojFnAnQ1J0wnnDVoov2WSiKCNz62IU6DfrG74ezUbQ7OUnzAs4vSRGQO
 YAX5XHsnZzoElQxAb8aGqzCqzjn3ZeZIQCZ7DFm1UeTi6YoGAVXem7/DWek7arEl5eMU DA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k9b7swa1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LKGXSK018192
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8j0uc852-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQLtyoqZ3nxtXYgyR8coo8w8qfTYTImgGKNrnl2vUBoCEJttLWEYzaDSFQPgj81zQSGwsRBycjsBbZDoDIHaDHe90dDew+oiR6+UVwhv4pkxfP9R/LaGT0wi+ARLUpq+5OEfwM9cld37rmHLQEbb/6LHZGJQMRMBnKWPwUWiCzolnmb4fSv9PCLbGwM48VWMvwNaLFeHJvloyC4iQ7FciE9G72qgi2ABtgR6F3MNcnMWUFwm0kJSBLZ5ZV1Mun7SxRsNui2OskKBcTF+1vwwLpXNr9bBblLrEAQo+MVHMzn4hkE/CkVikmEb/6cuaYFvVqcZe3Y9VLJXdbHEQFpagA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q7IY9TJb67x9DpeUO/yaNdJiidpbzeMN7GhQkS4p9N8=;
 b=gq8V0Xqn/uo+Y5ZijLBjcyh1b/fJdbwYYotLE0zYIKDHivvQqOehddl1UMkCmuKrWrR+rD/S8kT6pO2G4tVU3gc8Lg9/FRET+XaMGSZEwwVHrHBWHsiB5ZLnNrIcP182wEQAYOFrzjRxUILk0O9snMWWu5kJS4acC1hnaJkAyeFSMCPr1XtJL9gVsv5TY9fkXq+sMglpDjqNhaELgmsvCGLvJFxzFgBishKO/S5roPgmgl7LHWQaYoq5UyrS1U8DZGeSPJwW6ZQFRCYO+XgcZMB1MNLib9Gz/uepL7b/TSmVMbIJLmxI7omnEHzW1oGKMhwMVt7E1Dmnkp/cC2mv4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7IY9TJb67x9DpeUO/yaNdJiidpbzeMN7GhQkS4p9N8=;
 b=II7EZb53pbCnJ9A8BVo3zH5G75JMDvrk8m13YOVsB0vOBzVTD6LqGr0n9Vi6KK3x55yWp/4/vw2uamM599Rk4UMk6K18MTFYslBpU4lD+gDvTEHNzQNgvUOwDGfljIpavrV7cEwt2sZxWh7nm1/Guh87YShVa9Yj5TIEZjsOrXA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 22:30:17 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:30:17 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 23/27] xfs: Add helper function xfs_attr_list_context_init
Date:   Fri, 21 Oct 2022 15:29:32 -0700
Message-Id: <20221021222936.934426-24-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0239.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::34) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: 52f2359a-679d-4297-ef03-08dab3b3d453
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S7e5y+K1ZzJa5rgKEk8/49FnlqFzlk9aMF9j8uZgw42RteIs8Sbiif3pPurq/6/6bfWA0S6IXYcvWVsMqk5T68VIsF+zxt8fTIexQ2+SIA9/GKsmk7ZcgueVykrhoAU1L3wFuEr1zrtpslWECtpBlp3WhSR3/SFbuxn704VqI//IxUQ19LJ+bo+0PKkTExDLYenYoBso/3CkYnFDyfytLQnf/64WOVwiCiV3WMQb3AoFvSTOIKWClpW+Lr4cjrxj5m8hpJ57CBdD7Lt7IVm2zB/AKYR8FmtaRWr8uMBmbEOC8+ubUuco5nAqU2EMp0nzgu+1Nc1LO+FMlW9h0JF/9zZx5mbj+11wzUum3JbTTDIftWFueHhLunDh2io4wwfQe5KM7GNGSQ+t+BFIao+yqs72+Ln5sDgTI0D/PBB1Lgb4GTUOr6amJe6ZGLhieed9I8cNENIVbJW2LkZHUy0VyjHbk7XHVBgzwZ8ZjtHtKCff8nl12ejX5rYPCwxfznrFWMHuzDKm/Nb+JjOi3p/yHW7mqZZGKYGGyAvk+KZ7uJpp911FvFp8Cfq9AvNrn6bBIL7QW8huxkgmbr9eeaVuvQm0Cshr7gvE34bR1p1OGRI9IjFRFVXT5Vb8gmDtMlQeQ++xawXbAujsudwXsrkrTgWwrCnQW8BTvCphRmKzNpRzP1g/tBW+4WO8rE+ZrMx82WejgdqnskF1D6t8AHKY8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66556008)(8676002)(6916009)(66946007)(316002)(2906002)(66476007)(8936002)(36756003)(41300700001)(6506007)(6666004)(6486002)(38100700002)(1076003)(186003)(9686003)(6512007)(26005)(2616005)(83380400001)(86362001)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N6NZo7mXAdOl60imklZoBtMSyMFYiLuBoZzbj5WEY7tynSu719Pyo55b6lDg?=
 =?us-ascii?Q?0t5/ann57zx/vnV3kU+DNcXAgUJec3SAj3VaNNVAOf4dkCCeKVFFr3SFTb1M?=
 =?us-ascii?Q?MFCqmY411t8DhIHbCMeypLCenx+VJseGIMobhs9q84wThHQJt/11n5VS257R?=
 =?us-ascii?Q?VigPdNj+V2oeJAUPl1vgpmEP6XwXEsa1u0VQV3KXiC8xirH/+MsoBUH7RJUc?=
 =?us-ascii?Q?ONInDkHa7gjM60oFzDk59K0f+G2b9ed9W2nEK+0ZUjUh9Uzh4W0WwarvTJgR?=
 =?us-ascii?Q?oon2ipOEAQ4Z0nrutb6uiAkWxe7KwgDuAB0qtGITAPW0ExD5nWYzyKPnKnZn?=
 =?us-ascii?Q?yqiI4FFoeLDnAH+uwv5yIJT//w85VJE3elGe3Dem65BoJG4zfJohP2VKogyN?=
 =?us-ascii?Q?BTvTzoanem1vJ9WbvTDlqemrd9btfWgQy0e9/BLzmEvATlYWe19TBj1npVBQ?=
 =?us-ascii?Q?hp4XQL/qIVihTLWdcFr+zvzYXl2t2Diz8xNL/fqXkFsA03PfHEc3RYo7osX/?=
 =?us-ascii?Q?Raker8b9rzt7y9apiUhFyQ1gPLpS8RfI6kYN5/XfMc45TsMLVpX4DkkJOab6?=
 =?us-ascii?Q?hyIxXUVaMNndIQ4pNBPxYvFvWrsEJ7I2ACt6vZU2fXa4V2bki6qbeC0BdRe7?=
 =?us-ascii?Q?vXCWOu4gFa+nllysfzkd2/JuD3+jvwG0a4Dn5yr2/Chgt+PrBkxvyOSww27y?=
 =?us-ascii?Q?t1LKhYm6vN+vSPKMXSa3iJYaceKmvWXhDrME+rjN/oG+xb7DpL9l6ZFsZ98w?=
 =?us-ascii?Q?Y39DVtw8BMiSzVKDQoflec4J5u3R/6gSi2ogIxQrir1pQEb0lV77+tXDdtKz?=
 =?us-ascii?Q?fkp/sXCNfOXQvWQe9CqGhM1VPdYJbT4wci4AA3zcmL3+G4xAElq9H02lnA66?=
 =?us-ascii?Q?G8/1QZzq3vBXqED/mhgx8sM747oWjIKOFaCWsIPAPQb4B0bJvN3BvMJjBXnR?=
 =?us-ascii?Q?yZ1CAoxX+R35gzKpXnjM9NjmslasbAI9vDpl/dnUO6PU/f5KA8s20eAq+uCD?=
 =?us-ascii?Q?Vb89hbyVDUrxAu2fL84SmioNEXqV+iYO8el7jLABg1cZnMwiU4Nac5ug0jvR?=
 =?us-ascii?Q?l4SkHkmJOKGtmXP1EXswMV0OWpnTaP4F9XT0jS6kLbbL0AJdzUmxi8Dj2GQI?=
 =?us-ascii?Q?89his0o7iscwL2Z8470YyQWXwOWubDaTHpzeAh0XSxD8sTkvJbPGnLMtg6xN?=
 =?us-ascii?Q?Ls6QiEuaEnG7twXUiRIUv30MdIGDNe13stzIxw2GDKJKGAv6QBiHhuTqVNwh?=
 =?us-ascii?Q?i5jEFS4KNZTAZNlb6JwfLi3V7Ln2EYB61JZ84WYw2/Xnkz5Rc12fECveB5NW?=
 =?us-ascii?Q?hYSzQiFcuMRb48GwD3RZQtDzRdL7Q4AKIPFY7/H17D8sRJxzbbagYiYZQl4L?=
 =?us-ascii?Q?26FcBgbbdr8K9O2hZkWO8tuvmwsujJPJ3b4htZnN5+koZKezegkCHtAhDx3j?=
 =?us-ascii?Q?ok+9UY1FibsDnu8kvYPCJdO3fJt5CHniPMendQiskW0zj2nPJKm0qz/SKEM+?=
 =?us-ascii?Q?mJHAI+GC3gZVbMUgYk12kR3nkYbnUEcnXpMbWUuTT/kOXZmdhMOJYG0wFnfw?=
 =?us-ascii?Q?cHCdCC9NvrZrnSnmJvA0QXo90eiwbml1qno+H5fuChOHPTtcsNNBNLVTV3Gn?=
 =?us-ascii?Q?+g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52f2359a-679d-4297-ef03-08dab3b3d453
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:30:17.1009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GBC6p0DoKPKC6Y3vj4UmW9/AZNtLveGhNjn9q+VrSoWfJ7pO78UrPNkOE2JPe+VHTYRsQZWdLoDCNWgM/tqmQhaH3aIcoqEt7XaY1vIl5Hs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210131
X-Proofpoint-GUID: AooGT2bLnwJyYibA68uePYaFYutvfhUN
X-Proofpoint-ORIG-GUID: AooGT2bLnwJyYibA68uePYaFYutvfhUN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a helper function xfs_attr_list_context_init used by
xfs_attr_list. This function initializes the xfs_attr_list_context
structure passed to xfs_attr_list_int. We will need this later to call
xfs_attr_list_int_ilocked when the node is already locked.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  |  1 +
 fs/xfs/xfs_ioctl.c | 54 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_ioctl.h |  2 ++
 3 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c6c80265c0b2..cb456fd92b72 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -17,6 +17,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_attr.h"
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1f783e979629..5b600d3f7981 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -369,6 +369,40 @@ xfs_attr_flags(
 	return 0;
 }
 
+/*
+ * Initializes an xfs_attr_list_context suitable for
+ * use by xfs_attr_list
+ */
+int
+xfs_ioc_attr_list_context_init(
+	struct xfs_inode		*dp,
+	char				*buffer,
+	int				bufsize,
+	int				flags,
+	struct xfs_attr_list_context	*context)
+{
+	struct xfs_attrlist		*alist;
+
+	/*
+	 * Initialize the output buffer.
+	 */
+	context->dp = dp;
+	context->resynch = 1;
+	context->attr_filter = xfs_attr_filter(flags);
+	context->buffer = buffer;
+	context->bufsize = round_down(bufsize, sizeof(uint32_t));
+	context->firstu = context->bufsize;
+	context->put_listent = xfs_ioc_attr_put_listent;
+
+	alist = context->buffer;
+	alist->al_count = 0;
+	alist->al_more = 0;
+	alist->al_offset[0] = context->bufsize;
+
+	return 0;
+}
+
+
 int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
@@ -378,7 +412,6 @@ xfs_ioc_attr_list(
 	struct xfs_attrlist_cursor __user *ucursor)
 {
 	struct xfs_attr_list_context	context = { };
-	struct xfs_attrlist		*alist;
 	void				*buffer;
 	int				error;
 
@@ -410,21 +443,10 @@ xfs_ioc_attr_list(
 	if (!buffer)
 		return -ENOMEM;
 
-	/*
-	 * Initialize the output buffer.
-	 */
-	context.dp = dp;
-	context.resynch = 1;
-	context.attr_filter = xfs_attr_filter(flags);
-	context.buffer = buffer;
-	context.bufsize = round_down(bufsize, sizeof(uint32_t));
-	context.firstu = context.bufsize;
-	context.put_listent = xfs_ioc_attr_put_listent;
-
-	alist = context.buffer;
-	alist->al_count = 0;
-	alist->al_more = 0;
-	alist->al_offset[0] = context.bufsize;
+	error = xfs_ioc_attr_list_context_init(dp, buffer, bufsize, flags,
+			&context);
+	if (error)
+		return error;
 
 	error = xfs_attr_list(&context);
 	if (error)
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index d4abba2c13c1..ca60e1c427a3 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -35,6 +35,8 @@ int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
 		      size_t bufsize, int flags,
 		      struct xfs_attrlist_cursor __user *ucursor);
+int xfs_ioc_attr_list_context_init(struct xfs_inode *dp, char *buffer,
+		int bufsize, int flags, struct xfs_attr_list_context *context);
 
 extern struct dentry *
 xfs_handle_to_dentry(
-- 
2.25.1

