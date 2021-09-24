Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6B0C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 14:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 613DF610FD
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 14:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbhIXOMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Sep 2021 10:12:05 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:34298 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346740AbhIXOL5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Sep 2021 10:11:57 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18ODQEEZ017543;
        Fri, 24 Sep 2021 14:10:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=8ZJZUdC2v//MYD+HfQuhEBo3FUgNJ3MYid4nfhqWfoM=;
 b=ciW97h8SxPdZvtzolqLepLGeS29sp04eY74ULk5gOCYj8DhADUlAzMv/isyQ48TeYOxh
 x4RJBoHFT/VpaQl04rhpTtRvrmiWlPiVaEf+6UQ45nEUNHJHo9D0te5je+i5II4qX9ga
 X1xxmvOo1S5X5Z3MGJ7hVoIQ3UFxCsFvxzFIIj7v6k6A3mAUcobm+G8bd7TE3KK2V2oy
 AhRlqXs2cDHJbXm8IPjCaqpejYN/uBaSbejrgdiPOHp9dS2zoA/0lrvvZvYvNSAtzkM6
 VZcML1dhUNV8GLd9XnYRVZKic2gnP0hcpZo9lhFtwua4UBi9NXfD9JXBajm8T/8ARanw Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b93eqkq3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 14:10:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18OE0wF8121938;
        Fri, 24 Sep 2021 14:10:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by aserp3020.oracle.com with ESMTP id 3b93fqsqpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 14:10:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5uLP6xi8u+ynZcmiPpDo7KJOR9ezx4dhLsRDaFWqohlE6moRhJvGyyvXM2edxVMt8rBoladiWt11+GX7iA+Yk0JxIW7iNicgsrZpI1zD4GWDlUNVE/u8bSJGrfqcl1xJS5hU9kKFDxAXel1r4bQcFf4SLJnTJWAjAeYulNf4cdM2VuOwBqUWRPzPTyWQ02xKKw+ndDquvKHUmjPSfYexLZFJePesXLC39D46Cm50U+lKwTxnM8P7xrL6VRejtCy34WZ+f78K8Q/kOPwelMgfjbN3VfE7nC2Y+fFnK2BeBFKFpxSKZkiByCmDL48IDMAUAwUV9U/oikzScf84lRPVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=8ZJZUdC2v//MYD+HfQuhEBo3FUgNJ3MYid4nfhqWfoM=;
 b=VbU55/rgCYHMCywTG6LiesmRPTVVe4wMiL+nalk1RCTcpfixGdhNN6aJG9C+uYgm3xHv/nx9NVOyufw15zf3Zkrsf7yMraFe41CtCMjQOlQLB+SR3yrh+GZ/KoNamHqkVahsSFR2YcJF84oR2BX7o3JghQKy7qYVwK2lLsLMMYIkODDLP29cDu7o1CsjWBNl4Ai5JzwqnVh0JXAQybsAZDz3Z1FNOdH4FTJVnn8OhEn41E/9SEuioITRftTUr63QEhurq0rpTKRH0unirfNuRq7vbdLtYc7UxmDPRuaXlRLktKK/FR15NpSkghDG/mol72xzlkvVC+pUCklrEUlwAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ZJZUdC2v//MYD+HfQuhEBo3FUgNJ3MYid4nfhqWfoM=;
 b=K5pjIPNopkQLgk65tg+VPILY4LXKGgboSvp9oHByHT9OpD9Zt9vSx272ny+dDH51mgLXeyXW7LSO+g1G26PNucyRpRc/EBhrW5Wray7UPbCLQ8PbrcZr8OpsK4hi17qhOVGiMx6ejUAtjxZF+wamGh5fgPspT3uEvi/o/dSnaq4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4650.namprd10.prod.outlook.com (2603:10b6:806:f9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Fri, 24 Sep
 2021 14:10:12 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%8]) with mapi id 15.20.4544.018; Fri, 24 Sep 2021
 14:10:12 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, david@fromorbit.com,
        sandeen@sandeen.net, djwong@kernel.org,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH V2 3/5] atomic: convert to uatomic
Date:   Fri, 24 Sep 2021 19:39:10 +0530
Message-Id: <20210924140912.201481-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924140912.201481-1-chandan.babu@oracle.com>
References: <20210924140912.201481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0143.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::13) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.179.80.2) by MA1PR01CA0143.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 14:10:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30776ef7-ac1a-4024-b678-08d97f65064a
X-MS-TrafficTypeDiagnostic: SA2PR10MB4650:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4650EDE45689B965F105BBA5F6A49@SA2PR10MB4650.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RMCca5U3q/kRUSNyZscllVXDt3AQDaQ2xKaO6sGlnw+etHBWWqEPUbOmBVC562Ep94C34pVkisX6wQO0LBRcIcYv70CYpjniizfrIYmoiX8ss5E6p67o08Xf9Ba264LhUVlHFE87gGR/9EGb5InhZGnmEnFT5t/LO2b7ZTNA9K1TIz76uWEaywfApW5uhItCPjo17s7aPnn+9vNsRzCHv+3gQWk1ammKQLjTBlA1+t8LIBJ+tsEDKHxIsyl5JXcu5f/gXPJTd8dnPlrvOOJu0AYVdeaeKNybrKroiivDCQLGXcRka5sadN2X2f+M3grwO7c43uags14aWPlUrZi1sfAVUGubvMsDX1MO6PAFKFXMCrC/v0PVOPMcRMdADYgbXdt8S1FShDjHEw7rFHtJY7r2vZLsiVQgZQk2avMTomky/AXanWxUh863eSC3K4sjG7BFdQgqqfmPic+F926Dsqs8Rx9qqChI2sePbPent092ubuJzFJhUvI3dNNm399LMrdotYFqyqtVozDtdDD3J7ISNL99hRQC5hENOQ7xofMAjf3r/hvvkTqBE2P5xrrHvR7DprgFDJuTYc3O828cxvU2llOZcnRrvC3FlOPpI3fim3eyAlEfeJ21h69GJVc8kAJVfo7w3cPATbJzuRePfCA7cCZeSBrsfzu2RXhdoLmEXCwUh/6+ATT09p+CGGfCJLvvuk7yctu+E8BKV1LwvWOLCNxcwkHtRYBZHp4oxbNfqixc7S0H7lqA+667ve3vVX0epH93LKgSc1nwMUA/cqHJaL2lmaWPFG2p98PNsQw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(966005)(86362001)(2616005)(956004)(508600001)(1076003)(38100700002)(6506007)(26005)(38350700002)(186003)(83380400001)(66946007)(8676002)(6916009)(6486002)(316002)(8936002)(54906003)(2906002)(66556008)(6512007)(4326008)(5660300002)(66476007)(52116002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g8jYJx/WYCaK/p9o1EX4nYvT00r8cI9Lb9YkuDHQGuTNBQcW+Xbu/GpViUv+?=
 =?us-ascii?Q?Pns+G2XF1nWOIl+Sktk2byMkqQdsm5T470QjEBK//TOMo1JbQ6SncZhre3ly?=
 =?us-ascii?Q?RNCtisoK+Si/Dg6/+G5A4CvU60FXOJAKB4eCeQ1SrL/Vcw3fWBuaZmis//Bd?=
 =?us-ascii?Q?q7+809HtODkuM6KP2+ghtw62rwAuyLzM2FlZYdizToB3DhDkAwnpzb46VCna?=
 =?us-ascii?Q?TXPFikNIJJRQP/DOIUZEIV3yO5U6nZAg8qjCzh43Ymec2f1QzzFvym9/QAmN?=
 =?us-ascii?Q?h9jm1u4AaPqjhg2IAg6kHRJ4eRWKcpK03zysGYuuvZnyTBvKk1kDZEcPDhbP?=
 =?us-ascii?Q?zWsLsrC4gIbusPtmPoLeP/1mt//2Hw0CkHW7mfZCbd1gbdkMDgFOIU5TCved?=
 =?us-ascii?Q?M/kKYxlcQ2gsrNBsSCEcd8d7VpI871ES45CyQ2V4Ai/klYnZlLwrSXKGDZcU?=
 =?us-ascii?Q?p+NRe9eCwC6JllVqh6iVjZIx1YkfYYeCZIOgNXA9CGlV2LNrC99ghKFs9E6k?=
 =?us-ascii?Q?IwHQ96aR7y5B8dY45qrgK1nwo3DK7mzZ1b3ml4PsR8tJsCHmpmQWTyzZfLix?=
 =?us-ascii?Q?9vND5qz9eDkW0IG1UImIOvTDg/GSkg3ZshCdVMqR4hJkNWtOjT+hBDuiKFOm?=
 =?us-ascii?Q?xwwdLLBpxdQMHxWpiSTmUONEepMYcBg9L/Lz6A3Hz7qRFYmY82gd+piqa58r?=
 =?us-ascii?Q?8s42pQdtNAlDUMSRiFBs0UDMGCwq5K1AXxhGLxnAjp+N8zH48Ya9hdyKdFnW?=
 =?us-ascii?Q?dY0o1cH1qlHlgb/aQK6QdxxHnAQZ96ChG4oHAh0UD8B3Uvr/GdZLi7HMMqNU?=
 =?us-ascii?Q?uBjyFju6mlJq96VhmPzHOI0kCJIJsqvXXsjFKs9qH6gYurcxxECAZO852UOK?=
 =?us-ascii?Q?pzOTQCE9VPfU+LvB/SYvZoHSBIiURgzpR43Pylo01/01jS5GPY7NdVYlMqU0?=
 =?us-ascii?Q?PoU+UCKuj7x8ttyU5cjN43z+utwStQZM5LVGUcOpNmMJdRQCdPXNSMRiKjGv?=
 =?us-ascii?Q?hdms7XTOr7zWXgY14vA1KhZejFuX1HmibtFa4r2Mr+2Vg0MJlhPAnlcgp+kh?=
 =?us-ascii?Q?ZkdxB6Kky4RnuadaHCRYlN42VUZuUK6EsB6ChfZDtn8wc9bW6B5DKJy9u30m?=
 =?us-ascii?Q?fqES4qq9zkV7PD7xnHl8vSFznhlpsxuDE4A8LoZ0LQne+yrfY0M8geiTCcDw?=
 =?us-ascii?Q?P0nunCNbPzIWJyHX8UqvjIwwABJoPCCAtmuGj7E+mIvSMxfAOu1YDCj72OCG?=
 =?us-ascii?Q?xjCGPwfGkZ72qQ4CJlyaEMB2mw1wWsHKzV6uKjdVUneK7OaHh4X+mdzRDmLq?=
 =?us-ascii?Q?OcRCuBucmkjPTpK81eWbZuhH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30776ef7-ac1a-4024-b678-08d97f65064a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 14:10:12.7054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AC7kWbCs3pJVbiOuHnEDJ7OJeizAjse+Qzv1b9tG5nWvWvOm3PtRSayIZfmABwnCxG1/JB9dX+F6K8bpTZRVCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4650
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10116 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109240088
X-Proofpoint-ORIG-GUID: CqpGKIM7SiP0hVscHpbzbF5pEXxZSdFK
X-Proofpoint-GUID: CqpGKIM7SiP0hVscHpbzbF5pEXxZSdFK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now we have liburcu, we can make use of it's atomic variable
implementation. It is almost identical to the kernel API - it's just
got a "uatomic" prefix. liburcu also provides all the same aomtic
variable memory barriers as the kernel, so if we pull memory barrier
dependent kernel code across, it will just work with the right
barrier wrappers.

This is preparation the addition of more extensive atomic operations
the that kernel buffer cache requires to function correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[chandan.babu@oracle.com: Swap order of arguments provided to atomic[64]_[add|sub]()]
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 include/atomic.h | 65 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 54 insertions(+), 11 deletions(-)

diff --git a/include/atomic.h b/include/atomic.h
index e0e1ba84..99cb85d3 100644
--- a/include/atomic.h
+++ b/include/atomic.h
@@ -7,21 +7,64 @@
 #define __ATOMIC_H__
 
 /*
- * Warning: These are not really atomic at all. They are wrappers around the
- * kernel atomic variable interface. If we do need these variables to be atomic
- * (due to multithreading of the code that uses them) we need to add some
- * pthreads magic here.
+ * Atomics are provided by liburcu.
+ *
+ * API and guidelines for which operations provide memory barriers is here:
+ *
+ * https://github.com/urcu/userspace-rcu/blob/master/doc/uatomic-api.md
+ *
+ * Unlike the kernel, the same interface supports 32 and 64 bit atomic integers.
  */
+#include <urcu/uatomic.h>
+#include "spinlock.h"
+
 typedef	int32_t	atomic_t;
 typedef	int64_t	atomic64_t;
 
-#define atomic_inc_return(x)	(++(*(x)))
-#define atomic_dec_return(x)	(--(*(x)))
+#define atomic_read(a)		uatomic_read(a)
+#define atomic_set(a, v)	uatomic_set(a, v)
+#define atomic_add(v, a)	uatomic_add(a, v)
+#define atomic_sub(v, a)	uatomic_sub(a, v)
+#define atomic_inc(a)		uatomic_inc(a)
+#define atomic_dec(a)		uatomic_dec(a)
+#define atomic_inc_return(a)	uatomic_add_return(a, 1)
+#define atomic_dec_return(a)	uatomic_sub_return(a, 1)
+#define atomic_dec_and_test(a)	(atomic_dec_return(a) == 0)
+#define cmpxchg(a, o, n)        uatomic_cmpxchg(a, o, n);
+
+static inline bool atomic_add_unless(atomic_t *a, int v, int u)
+{
+	int r = atomic_read(a);
+	int n, o;
+
+	do {
+		o = r;
+		if (o == u)
+			break;
+		n = o + v;
+		r = uatomic_cmpxchg(a, o, n);
+	} while (r != o);
+
+	return o != u;
+}
+
+static inline bool atomic_dec_and_lock(atomic_t *a, spinlock_t *lock)
+{
+	if (atomic_add_unless(a, -1, 1))
+		return 0;
+
+	spin_lock(lock);
+	if (atomic_dec_and_test(a))
+		return 1;
+	spin_unlock(lock);
+	return 0;
+}
 
-#define atomic64_read(x)	*(x)
-#define atomic64_set(x, v)	(*(x) = v)
-#define atomic64_add(v, x)	(*(x) += v)
-#define atomic64_inc(x)		((*(x))++)
-#define atomic64_dec(x)		((*(x))--)
+#define atomic64_read(x)	uatomic_read(x)
+#define atomic64_set(x, v)	uatomic_set(x, v)
+#define atomic64_add(v, a)	uatomic_add(a, v)
+#define atomic64_sub(v, a)	uatomic_sub(a, v)
+#define atomic64_inc(a)		uatomic_inc(a)
+#define atomic64_dec(a)		uatomic_dec(a)
 
 #endif /* __ATOMIC_H__ */
-- 
2.30.2

