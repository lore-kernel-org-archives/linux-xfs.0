Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74411EB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjGXEhK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjGXEhJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:37:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431FD1A2
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:37:08 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NMRLFH003455;
        Mon, 24 Jul 2023 04:37:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=M1Fykt9drEa1+zTcVi1eSPiP+NLoBkqrG8TxDFiEwz4=;
 b=c/uIrYu8li+YrxwKIIWbJmtqu9GJ9S+s7kR1KFRgOCR0FPRisQQXGFWepgQ6E5Hn6w9M
 ZH9xS/2y7hbYBAHtUXaZBK3s4Trneux1rlRRN88Y4sb3HMuawR7269J81xV7RuUez+Ht
 aS9VLSU47YZpghO3xdH7QEm7XlP72lqQ+MFm3S9scPVCAVb30HFcQzbLl9MsxXYQmIlN
 Htut81wUoumhaoDKGsWfQZz5trjc0GQnlMa9IA/fc8xeKPvGP/3kG2SqsCqcC4Fd1aCS
 IXZjOyqtocAcV7IALNpm4Mvvyc0yyS5fKtaYtcZcLoEEn3QJhlsm2e36/61cn7EQkhxB lQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s061c1ve8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:37:03 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O0sJi9028878;
        Mon, 24 Jul 2023 04:37:01 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j35xx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:37:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cx4oNqnsyzfRydiLXZ83oagII9uBfx0CIifGjnHiIV5E8vratFk+OgopccFpbTsyAGTnXOMoE/ayPjUVDjOk0Lr7SIXJPzcKmlmzGXFBTi88rXfoqq9pjwxn8ZZeQqx4xFBWddwfO6xMYhaJ9qbCpmysxCgh9o7NBHl14FTwgILSnmo/ftFrGYTog/m/6mhGYoO5cQwBQFvkGcYf1QfdbPJE7KuwAGOVYqVxQcngXvvLuSu6m3v/QfstRemaeM9EkJd2xoK5SnAB8m0nvtFE/vSilASNKg7dEkrV3olYPe0Ng6aMMh0lhTWKvqggX3kxUl6tjVO4MT7/9dqDkyCaOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M1Fykt9drEa1+zTcVi1eSPiP+NLoBkqrG8TxDFiEwz4=;
 b=Bj2zxgn92B2xa10n0FPfQBhjDnTHzQEApWV75PFU0Hsz1rFFBShJNetm8k+QVFvhCKlxhKhGHE9pqkrB8w7g0UO2x9fN1It3dFT0sUL5Mg8hYutB80EmJuIa1gWrklPFt1ePlIdSSsCAw5szngLHw3e6sYB+88tD4D/CDHZT6maG0UtntnrAll1YFUbgZ9M5lnkw/Tpdve8Jbn0AKbwOTQ8gadct9HMYsrZuFyxZHxWmutV6ac/inVoy+7ikqOaj+d2EbPPFfDJxZ7seyHzmVOxejzEaj5smvLJzsZV+NhKHXnDUOsxLmA4A3RxoHS98WzDy27/G2oQ13JpYTrlq3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M1Fykt9drEa1+zTcVi1eSPiP+NLoBkqrG8TxDFiEwz4=;
 b=DRbw7qFbX+K68ulkU/uj55XgVsyAOu9cB7CbPlXo6ukBUEALAq8yL5F+OqKXGiB5YYoG8OKH5VS2nUbKhiUs1z1t8ue5d9Dj2mJsN0kibfQLB50Ax+aeISu0XkwUphloq9eOj2Fhyy7xrvK4zlcq9iz/a3cTKKJGihBdtORAucc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:36:59 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:36:59 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 06/23] metadump: Postpone invocation of init_metadump()
Date:   Mon, 24 Jul 2023 10:05:10 +0530
Message-Id: <20230724043527.238600-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0227.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c7::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4774:EE_
X-MS-Office365-Filtering-Correlation-Id: 57f3e3fa-f371-45c6-aeae-08db8bff9e51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N3vTBPM+Rn7X8+dMZvC5CBT/wDWHQV4ugvmDsvj5DIShE+o9f/HiNk2zJV9cvSkxXV3yS0obw0DSo1lluD8v47xEq/cN29r8XOdjPN6hnxEWLqiNx+lAXa16INtchJWwSzObIaUTIO6rZk5jI2PywTmsOH5CwRK4h3e5laF/vEMc3nk3YFXzEJcGOqS/jH4NjrdNWc9KDmrXKUhykRpLUlO8jQAsZ2xXcVRgFa3mhLrRhlLMcQyUtv8arDNNDal7KfKoziM6RDgjD0pJ+tgAkEoKmi/SIbiqQE6ETlQu3GcKsVRC3QMWLIqug5b6NJhpjODTS5IlkX2OwsW2M4mcmpXtJmt0BdoGhqzpSanj2DrZhdh1qFNj0MFUbv5wT2SecP49PSDVWj8wvNM4J/5wc2VJTC0ayhIf71PSeXAHBr6C4kg4xtZICNdoKePhvB8rcChoQ24bER4w1y9QJrc2QkX5ZVb7gBlHN2j0WbH2QRQAeiGbf3e89mDTQCpjhmWCih/xN22r68w4IXqEyxjOqUFKru/99xvWVIUeZUBdwKbF1dxneOo5jhkN+deJocKU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d6OGt3uZk/ZMKipt+dTawPTla3VGaVxgSCaxJpk87lOfnSI5UT//2sMoeRaS?=
 =?us-ascii?Q?keA8QluBM1CYtReF1KJ78PWTRqR4eL6VPCz8XMNHYVyCsNJgYMeLNUW2Aiz/?=
 =?us-ascii?Q?QrrGASk7XtRky+Gd2sTZ6JYGsiShHl09xCQS/mM00BJmDful91tM+TIcK3Mt?=
 =?us-ascii?Q?7Q2RJ/+/eOl5GPKljCc/fOgKgvNYtADwucWLZthbBb1p2BKM0Wm5IjeC8Fvk?=
 =?us-ascii?Q?o7ZQ81RboGHZKRq8NOl0bwd3wzjvpbHj01mysjea50LTAhU4EkgIz+SyH+/q?=
 =?us-ascii?Q?jRWQrOZ2x7/txmhijRcETTG+uKQ5tEDKzPJrrs2+ehN6vr0Ej8BaAWGNiuTN?=
 =?us-ascii?Q?WzhA7i6kpk4Wk13+eRhTyMwAgJK+4e03nMWlldhihwiEQddEd6Uc4iFWWJ/3?=
 =?us-ascii?Q?f6N2scM3U2s0tW9UijtsT7aMIxhzrcv73zt1yOjkm137oqOAeuKZrsSXSZLB?=
 =?us-ascii?Q?zxcDbmL1Xy4YT/fcYOwlhrTz96h5BIwFyJUbmnLAxjwe6DON8zx6O6NaT1RC?=
 =?us-ascii?Q?I0xfMYvKuFxxIMxs9LRw7KlL6ZpFOmn8Ccr0wQ+WgOXAl8FqOyHXCCk0OB5Q?=
 =?us-ascii?Q?JII2uvRuR2/mRSxkml9qdCxD0tXH/Nz2w6FttxOAqrlP18GmWu9njWQIA5fG?=
 =?us-ascii?Q?1vFG5/5bqJFxJN7VKX7tamluJ0RdIn1GHWVNpu+oSZepxU/z03C9dHADCNXj?=
 =?us-ascii?Q?lbeVCJSVnoKuXuOJXcmaVCMOWjsqpOVlAaJeiwfJ4IJfq5Q7B/2/ECfd76cs?=
 =?us-ascii?Q?7RgnsvfkkTRK2LDaMoFPZLZV9oWuwycWkPjbAsVrb5/zp53etwET7ck5OcHk?=
 =?us-ascii?Q?wFhu0Uu09vX5cU67Jzp3jg5f/Ot73UcHkd6AQN9bWUKGVUSag2QNGDZkQOR6?=
 =?us-ascii?Q?0yMUbEvJjX+uNscYqgpBnisZVzKCdu47A4arz5IU+VBLWS4hxABz1faqiPNk?=
 =?us-ascii?Q?HjLfWtc+zuom+R/E3DtdztvCoR8hFoKiMqQzwL/kB7Scv1Tl5nvNVQfDNgJN?=
 =?us-ascii?Q?eW/Fd6RjCFzlaCvk4mdwReJ0y6zZ9YsgBq3kRt3tZSwNLDRYqNB7n+4V2bE0?=
 =?us-ascii?Q?MUSJy3wlrb1TwvotAIDExomC1LJCUk/sVYqfMJJSAzwT68BZVw7R5QIHlEKZ?=
 =?us-ascii?Q?ImL7Cw092Y5ONjwCUxGMho0ZjRHtYdPegOZmiYPgNqndpmPU+SQne9McyaH+?=
 =?us-ascii?Q?hVZlUndWaGSKGV3Licn63I1d6ugUrpTf+zHYKmxjVehb0dZvsgTXfGOEBqIy?=
 =?us-ascii?Q?7wiBPdYU+TNkUljvHeF4MIGQTxQSiUcWaT5WV0WejI7u6W7A9JXl1LBpM6bh?=
 =?us-ascii?Q?voZgiY611a6B4Nrl4JPLV5lpy5tUUo76vU2jcp86ZM38juljWpngCotbFlQQ?=
 =?us-ascii?Q?5S9If1n1S2C55mSsCy7DSyY478A73IlN4MQvE1xs6tnzO8snskq07kAH1PIu?=
 =?us-ascii?Q?vff9HmPiTu9vM7p/2F7Nr4XMMDWI/dE14sioKxbFD0Ypo7VvhbAaaFEwURxL?=
 =?us-ascii?Q?LJ0XdZfn/PYVdC/udyfUTyKS34enxMWCa1itYwNyB/CGWp2fLWAcfHlfRej/?=
 =?us-ascii?Q?E4pmLOxuQD7q8sz2tD8gGUJ23RFx2s9hVQ0ZiPpuS5uTdVqe2URaYh2mOwlR?=
 =?us-ascii?Q?AQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: r8ccu+c392WKybf9BhiSw4Ei7JiD+2lDyf3IcU5xrBMJnnSc7FXXAOy33Wtx1sgm/wu1Z+QMtF6GsigfzAAwwTUs0PEWSQ+gm5v7LzbuyFxLAc1Su/hM+IP8PD1jPhNNaHGhZ8uQzY4aLb2fuRqhXkBEGJFzUBlmJytWYJBYZtCrUa1/rVs5RMtjrUD//LGeyg45IdPKTEDjmib6HXL9y6fRPTIT3YFMQSE9muslV6wK9dqO76GQgBq8rlP++/2TLsLJO8YnvE0T+M81d86gCZXmQZky6FTAnuGlD1aS6K4KeBehKwLhCVOgGqxDZU9elTVAMVsifD845nGOOYRphQAXSpVdn3mW8RYYOliaP4aeF3BIXONW4INX/w0vAC5hLUVh8mnLXSULJjxE9ZgEMwqeIXkMBTzkj6S3BUM1fXKPPDfZSA1xCx+Km+Tv05ZwzKp0g2P2VJAO+L0gN1fhSiaw4s5aYPhHROqHAV+wj1/9SepmpmPqggWQU2sQP8cW01IYbdskM9r4XQ9hNl1BkP4j9CcDKmmTuyMoriE3VvGb1ix6aO8mm5DkzOj1Sh06bwQIPY2ehoZWhpgI8Im3K10/XpmMIWiVelCUmIcOVosxCefzgDCahkkXuAShdF5Q95hAwzIxMakWwBBYQpq3kwQZapvvvma095RT6vQ8EkJxS2n/3PnlWQevdPSc4XOMZ4lSwsM2y6EHhEp4mz0l8dMEP79a/TCjXyHMFfxFGOb1iASYT2tKcUs78DaxHgRqjigRTew+u7PZ0wA3XiydLfX33uN1+v/Ipn0KCO/JijA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57f3e3fa-f371-45c6-aeae-08db8bff9e51
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:36:59.4050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OgPyjB7MA99Xstum0OBA0t0lgIywsN2e/opA/6rLpHQEVXCeGGKGYUooza1Y6p4iSqEL7N6WvljdveIYYRzSQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240041
X-Proofpoint-ORIG-GUID: A8hZcU_zH-KCg_GkMe4-ff7qGY7HO3_q
X-Proofpoint-GUID: A8hZcU_zH-KCg_GkMe4-ff7qGY7HO3_q
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The metadump v2 initialization function (introduced in a later commit) writes
the header structure into the metadump file. This will require the program to
open the metadump file before the initialization function has been invoked.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 8bc97a6c..aa30483b 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -3125,10 +3125,6 @@ metadump_f(
 		pop_cur();
 	}
 
-	ret = init_metadump();
-	if (ret)
-		return 0;
-
 	start_iocur_sp = iocur_sp;
 
 	if (strcmp(argv[optind], "-") == 0) {
@@ -3173,6 +3169,10 @@ metadump_f(
 		}
 	}
 
+	ret = init_metadump();
+	if (ret)
+		goto out;
+
 	exitcode = 0;
 
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
@@ -3210,8 +3210,9 @@ metadump_f(
 	/* cleanup iocur stack */
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
-out:
+
 	release_metadump();
 
+out:
 	return 0;
 }
-- 
2.39.1

