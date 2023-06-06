Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B70AC7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbjFFJ3P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbjFFJ3M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:29:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629E4E62
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:29:11 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35668M5u014864;
        Tue, 6 Jun 2023 09:29:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=YkXznlCTOEZa0oSUo3/RPQeSMEnPj3y4gKdf2Dx6IRs=;
 b=qbwkmt5J/LlIxqI9vUKES01xEpgrR4cPhzulskJlRfzAvG+RxZi7F6hL6y0qsvMVu+M2
 CXHznQL8v9bSdk/UrnQHqkCIAuF2982xdF5VMSjVXuamokx3qY+oiQatZmZthvcUVWeS
 gR4aU6gj3dRjJQun5fskhQpNpblXakPXNq5K+76lw3HHzG1UO97SwR9HNsECBiL2KWIU
 IYBtKWgH1fLML0MNWUI7xlbSe0z9DDz+LmjMB6uvAtNVbqDTRuWgQV7ogDmCRwt6YzYN
 Mx0iNqw6iDAJIXmNX/Bb8TAvoX696BWv2cWN1sUOC+Ga7CG/tySvLy712Dz6Eu28vPM6 YA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx2n4vpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:29:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3567J4dF024063;
        Tue, 6 Jun 2023 09:29:07 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tq8wkkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:29:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiCLAI6i+PDnM/sMgvDcCIEoQS9YJk+mW62hICX2/ia9boarudYDPzNilX+NtBuX6PcO5Ncmo+Ek8o2cA9EJ1wxEKZuvF5DBmZtoJjxtAiDkGuGa/hUhT/4/8w/vAGiuB7SgxLfnkgfY6koqAOXgLqD+4Ie26lG62FSpRayheoTcOiJXFeJHkwWFWzObNRIbQodBMj1BuFytJyE/b++TCU2efJl3W6ButT0Hvror2Y7sB/RVsR/4DetB1x2yurvV441qCFNxSighhQGQ1Zftndq7q9ri9VF2yuOsg+9KR6l4722o24LjF6WWYRn1LmNcTk3EYVh32eJCor1oVKBHNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YkXznlCTOEZa0oSUo3/RPQeSMEnPj3y4gKdf2Dx6IRs=;
 b=E38E0f9ESL3YyMWbL+JeRfrhAT3UWmwEAFxBhwC6H6zl4gBpwWZ3O6k7wUn3ACcU9iv1OWlHqUsRLO0WkU3x8+joUSWODzYpUNNAFwxAc6ttvhUhhqfd4rb9ykv6HjEjNYCfJiHW2JjtFC6wBYAxYwmF2bPBkJ6/LGc1gVV3QcInpkHY6nr9FZHCMBLkEXyZULUymB1m7K50dxWj41WvDT8HcOnXdpY+8bOCtpINWkP7SpYoyQlyirFK7nlxRiUT1lqueI5cy7ibxT/HLsQiYVaP1is6xvNfsJRIWW2rdCt0TepPL6lCA33lTMUpf9et8bViov1AvhyExvir4qimLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YkXznlCTOEZa0oSUo3/RPQeSMEnPj3y4gKdf2Dx6IRs=;
 b=gax08a5dofb2OeDEVNVaBFAcy6QpPPGL3+f7p28et9qH2f9WLidu5kg3XU4dQ0CB2llXrBaNbOpIrrQ5w2nJKCzahUHyIMxZwRmPDmVLICdV1xcxMbwCf1VzEkWAyBYrawbwrzdrFdcCCOe8rEkKV9gsfZSVacKR7u3lld1JVgY=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4562.namprd10.prod.outlook.com (2603:10b6:303:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:29:05 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:29:05 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 06/23] metadump: Postpone invocation of init_metadump()
Date:   Tue,  6 Jun 2023 14:57:49 +0530
Message-Id: <20230606092806.1604491-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0229.jpnprd01.prod.outlook.com
 (2603:1096:404:11e::25) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4562:EE_
X-MS-Office365-Filtering-Correlation-Id: dc8ed328-dab2-47c1-584e-08db667078e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ERSEsOpePCIsyQdSGYyHRuht3Y2DcSoN1rM+iYNXbsOWKNw/E4EYyk+HfrxYiLVr1TgYOgvdTDYSOpLq/Ogbz+8xi9iyVSszV1mXsqSv66Cqf13OdMejf6orWZ5q/rR04GihO047e6bF6xQqgy0Ry/IzY0x291Yp8+HjwwRSCJQDmI90nunjFMLjYq+CAx+Go5IyhLEeIUjJSmwC09duchsPVbHZR375sUpuZAvJ129yie+dxeZvVx/xpqrhMvRkmqnaxjYiA+6jaXscf6cIfIgd8nsVO41tFuyyqfojiUSR+Cvn4L/DuFxEgVAwXeejKxVhDn9gHOJ9CFle5ZCoxF7UebfSxoyp2//WENumGFUOxW8vVE9bgpv7h9ZWRqkVnizGPvVuNQVFZmWlp6Tey5Lyf/knG6qZlpVNkz+PuPrqo+SKOgy1XMGRIdv6p9nI/VDnrFG4NF+1ZlSVgxqLUz877cuaz0WlcXGzbw64vw5pA/gJjs3sXinAMkPU9HywkOFFQEVRTlyXHBf9ASFdIMVOlOHX1dMOkZ16gx+0c0itb1twYCRJ5wXoLYn+qEAz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199021)(8676002)(4326008)(66556008)(6916009)(66476007)(66946007)(8936002)(5660300002)(316002)(41300700001)(4744005)(2906002)(478600001)(38100700002)(6512007)(1076003)(6506007)(26005)(86362001)(186003)(36756003)(6486002)(2616005)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cnMDpSJryty44mYRt3CqaPcPtpmRWqDM5RDZ/3moa9mOQZZ6gOyQFElVQob7?=
 =?us-ascii?Q?bNR87YSdIZ5lnQM4dUJvUolLd/xuzYFB8txCQKSt/iGeUP9KZ0JrsSdn0LoN?=
 =?us-ascii?Q?B/7Y6q4NuMwR0IwpKliHmrhlYxuyRmGcdV8bpedkBpqB0j6sJNb+PLgeIWHh?=
 =?us-ascii?Q?2oOeAcpNHRzYPeBKYxpuvOsT6WoAmRTloNiGp9iVhqBUVHnkBJvyhVM9JYaz?=
 =?us-ascii?Q?Oz++zELOSfb6K4MHKJWv0pwv1Qga89kdQILQEn9jooB8erSA+p2zEfGh1ufu?=
 =?us-ascii?Q?W2tLKYz4w11J3w7xZkSPtUJ4gVgPOzF5X7jF/i4HfhPshlhcr1h93B8L4pH2?=
 =?us-ascii?Q?DRMyEqR7xwvIPb5u7857mY3lnTJDBRJSi6ixf+AgTis80VPU2lF48FkhB0Rz?=
 =?us-ascii?Q?vR7kjAzxPOKFnVOWtKo4Q7BS9a6EPcQJCWahZS71c8q+OwkHmkQHHZO6rw/L?=
 =?us-ascii?Q?hXvhEpx+l/EifqfiGdQ3vsjARCtluJWPlaxcktx8Fbgy+fNWVYefa+wcTnNX?=
 =?us-ascii?Q?XIoiILx/ICi0AZ8De9qCUdp+EAaD9wffxC5qZN8AtHR7YSviPW0Ns1YXIpad?=
 =?us-ascii?Q?uhQ1s52o0kBXo6kDemGHnXrJOmbTuBuckoikHoWHsQHSDZy95SdzMDpBXGvZ?=
 =?us-ascii?Q?bm83uPCIBnC7c7VVjQYrYkEVG+Da4dH+sQ8I234PgIUdKhPETPv1nqdGPQOL?=
 =?us-ascii?Q?riKHJ3morZ2BF+YWmaZ25uxZdYLictsrh39fKHYdE+UfjOI/h0W0W9doIGOE?=
 =?us-ascii?Q?Nr9lVfg5t9xMfJNBGwoX4VToVci6wwivfGXYW397ZvawBX/LLEcLvwM0lpLR?=
 =?us-ascii?Q?fvKaNf4GcypkIHyjvQ9S7L7q93nyZV3YCCDu/fCmFqwCuPzZVNFRHjcFLIVq?=
 =?us-ascii?Q?wKmvrpLlyr0WIIwSI/08+9Fb5A/QBRjeHY+CpscYgc0xoCBx/bULc9pRC8en?=
 =?us-ascii?Q?th0DI+B6WlD37utauL6ilCzjLCJkcfba49txSmldwmAPEj/W1m2lQ+6bqC9K?=
 =?us-ascii?Q?l8g43RA9LK+4YIYyT4k+U8607Qwhy1v5DlXo2OEEi1oK97MBkUhWLqNlnV/1?=
 =?us-ascii?Q?0kbIHvK9Yw056HNXnHnlA7+i5HhYSStWIb+SNj+0s6HHtVjxlN8HSIGQt6CB?=
 =?us-ascii?Q?JDRlfmjTHL6aralrwnHm3RoOx+EaFENmgkPyjZpfVM3EHsFbADUJu6H4gRQT?=
 =?us-ascii?Q?C+Ma+2IVgZbx/uAyXIpVAA5o/ZYde9AwcTffKZ5ikOjBX954I13Qyfn0Bqai?=
 =?us-ascii?Q?Dw2j7HVr1gdKv1ancMjBWbudyOYT9lG+16714TOAzM+cFImYQDdNyD94iOc/?=
 =?us-ascii?Q?yoZgmqisQCGsJeK7xWgyo47VoVDKcUpp2F4Z4GbvXqlXMq4igktQKQUv63hy?=
 =?us-ascii?Q?g1ml1NmF7e3M8qfaNEHQog7q2Irq2gswTFCfF0lSI5p4XTuEMlHAGdqLKTY+?=
 =?us-ascii?Q?+nzbABcQieSikDgtBmpyontSbVIm+LdaXdvB6/EBEnteVDKtDS4isn/rjrA6?=
 =?us-ascii?Q?Er8MeMpqe68V/yDkqc/U5XXqwF7ATPFJVRMsA5RWSi0uBA+S96C2wT9Aia2v?=
 =?us-ascii?Q?XAADXR5JDSxFeiONtbdoDa5VkxHi+v/qwgVBEbEgu7tUNcWZbpRAFl2I5Hq3?=
 =?us-ascii?Q?Ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NlQXkj9OVlKw4wurEtuPC0VcTHIWo6zCrgqqW3EhVN9y4Bl+TRHWwicT5Xeu2Bz1+7c/QhBu55TDqPBy1J0px+tmGgh2l62pl+q/jYxv5Jsucw8bjqkO+v96GDw76EbGobXtwvXZD6uTCJqGJmHqxso56+ithYeicwwYHNvWCzAPfmL3q9rg29SJ6Ga/Sopmab33NHxp2yxSZIU43lgIC6C0uvoryDe6frET6LQUXE7bdISbeZFyZyL1KJZCl38r2y8UKMabqCTpZpxrRWlQbOM5cEIfWhlxqAXsiFuuIKVbbu9RoJK0EDMEK6dapJjyz3zv95cybrcprQZ/LbyCl53Ot+RRW/qP7nf9XCalhT8QhLrxCvc4XkaWkdfkq0M85W4RMEx074BKrh6fCHrb5QmAsre28SNw+TbbXMH2ZYFGvd7IprU5+XjlV8jG5IuyVsoCEb/d+LzI0EZKoB6hPkW0GbMpLUukcKH2UA+MNHqmB/dneEy9rgSUu9A0hBFJExyrowHb6Lhi4x6m1V06nEUII0rA4PYSepHLGOeoHsj9sZIPVNk3dxooTaLUA7VLiA5SpWD3PK3i7JJzGObmjwTKo6L83KRPSXzIb7i11Mf/jYMmxaTfUpQ+17gcgfabUnlQTcVhbWllIm680gs1DMKRkqra27Z38PIaJihJTWTVfKzb/OKKwk8fXWZmG9TLqb72VvqwQD3BP+tBBgywCyO8ZKS6IcwhWiY3D0aHaeJ3+Vpjgcl+5WGLjQrBx+cxiC06Vx2UGdsMZmjW5nU5jbEEMgMQ9RbaV+s1UH8TVdw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc8ed328-dab2-47c1-584e-08db667078e5
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:29:05.5793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a28MRSQK/omZPVAu+HJ/ng5PwmbV7d9TyBSUFqygbP3dF2jRizytAK5k4Z+q/Za9dyE3KLDwAvHCd3+XqxNC8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306060080
X-Proofpoint-GUID: LqaoiDK7XwN0dv1BWd479Vv1vvL6W3dw
X-Proofpoint-ORIG-GUID: LqaoiDK7XwN0dv1BWd479Vv1vvL6W3dw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The metadump v2 initialization function (introduced in a later commit) writes
the header structure into the metadump file. This will require the program to
open the metadump file before the initialization function has been invoked.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index ddb5c622..91150664 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -3124,10 +3124,6 @@ metadump_f(
 		pop_cur();
 	}
 
-	ret = init_metadump();
-	if (ret)
-		return 0;
-
 	start_iocur_sp = iocur_sp;
 
 	if (strcmp(argv[optind], "-") == 0) {
@@ -3172,6 +3168,10 @@ metadump_f(
 		}
 	}
 
+	ret = init_metadump();
+	if (ret)
+		goto out;
+
 	exitcode = 0;
 
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
@@ -3209,8 +3209,9 @@ metadump_f(
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

