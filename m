Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C82C25B07
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 03:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiHJDJa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiHJDJA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 23:09:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8EC7E315
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 20:08:59 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0EajO008869;
        Wed, 10 Aug 2022 03:08:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ZBYF17kMoQKC5dSBIB+TGzD1AY92ugmpwq833zf+oyQ=;
 b=yZA3JrmMva5uzJBEOtscemVaPkDxfKquUjlmB+5Uo6QlsenEWrGN6vjHoVHbVAaegZTo
 JglAQvnk8X3sovKtAVdeCcqBZ+eGQmagav6Km6b+Zl9AQpMqKgEiaQl9RIK1mebJr4cH
 5Zep0AK7pr7YRZXwxoFcB7b1f2FmYiL/JarIBV7EZ/C95I5fP+hdBnORSMb6APZVHMq3
 PgOUARhwF9BjMs+AnnPgcR8UuzpEDemM2dphlLEbs76W675LSqeZv1ZectJxLoUDYfqT
 awnBSiL3tGrl1L/vz0PYCvFBTkxyRHRo90oGDqdC3h+P0/F0+l3uGnMBXetUV6n6RCL8 YA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqdrp86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:08:55 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0Baqi005212;
        Wed, 10 Aug 2022 03:08:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqhrhj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:08:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBYLjF7/wO2Vy/KzMViEM/2+jM5aFC5EgJwU04zK2XLClI4D+qVFx0u/CQ9f7pgAdtRw7/GsSu4/uzuhJj0ORLRHR97JhzaBEMLZavt0Jslu5rC2cben77dkLE3yc1Rfy0u0vpH//ZrsfQHocia7c0Nwb7Gogy3IOLdVoWEZeW0vwCWnAdb/z+Xh6lav3Y2pPjFWaS595eRp95Mqu9O3g/sSTq3HXZSRrj0HbCBwZoEPTuQ0UcxxbmkbWrYsHz5vXzcNLUIfOqo5jjj6AoHulhyRjxLxocYUt2uBQgO6kS/NH0Nmwr27+X993N+grGhTlKEK2D2mkDhIS/KDDD4wfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZBYF17kMoQKC5dSBIB+TGzD1AY92ugmpwq833zf+oyQ=;
 b=CR5EEgRWlL4os0xG1gX4Vbbmld6SqtPrfCnoo5MF1m+dsLu+F1qAlAsaPkPESd975BaSPaKtO7TqZ7lkJyJI3yGafINwkacqQNL1sMNowCBvnkZdfgKiIXm/c3IfwdxePXjd1D9kdxSMoyVFS1nMavM+2JpxgTWszL2gAkEZTLdFyEXjvT5tE7JAtJ0uPM6s2E323eS/xqaQy7dQzOOqhcz1UoxcWCif5JhWiwc2W5/0oeB+69f2Oj0T+ERSPfJgRNiQQO49YaqoEpzcfJfrZiAnfxS8ASbbENzvsWqzzqcYGqgdxJntMtKwGmdi8dbZy7F9Wi+iR3okIDNg6juPzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBYF17kMoQKC5dSBIB+TGzD1AY92ugmpwq833zf+oyQ=;
 b=jyGVPgS5qTd5gB90B+5+qma0a3p55qmHcqOlXXm8pjhghH6UAQV+Z11VbV+anU14LEFxcf/EtXyitHSYIvRMgIZAlbVVXphN79GqVd8o1tCMfdfjeTTo1BuvhwvgesErrAiu6oQs3YrXO+mC8NgE4rIkOr2iM2guZtbRV/14W0w=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4545.namprd10.prod.outlook.com (2603:10b6:303:9a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 10 Aug
 2022 03:08:51 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:08:51 +0000
Message-ID: <3715d2d05a97e3174e48648f9228d0824dcff95f.camel@oracle.com>
Subject: Re: [PATCH RESEND v2 11/18] xfs: extend transaction reservations
 for parent attributes
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 09 Aug 2022 20:08:49 -0700
In-Reply-To: <YvKd/eEXN0GYJSYa@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
         <20220804194013.99237-12-allison.henderson@oracle.com>
         <YvKd/eEXN0GYJSYa@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0042.namprd17.prod.outlook.com
 (2603:10b6:a03:167::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ad19b0b-13a4-4a5e-ab6e-08da7a7da6a0
X-MS-TrafficTypeDiagnostic: CO1PR10MB4545:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vZrRQXC7uey+YVF8iz/VTbiHbzBjHIp1QhCH92gsaMmweZRBU0kWJF+879SQsXTBwxK4ek+GP8vxmPlmqMpmjLWTJmcHkJ1+icQfuKz2wv948UNU1tbz9Ss/9eJFsdE+ZIy0yycKKlDy+U1ViLPNQ8meuNbcJEIN1HsFCxQXxYD5OEPBDPdtX0BTspHpWwuGl2EK+Bv8z8RIZcQEj033IWXIxuH9zrXxSPGWUOt8MYudEeS1HEZRPCPz+ehKooBW2z1tRebX+1YDqsY9vnDcxYp70AnrAS9YS+/4sGxFnsh/Nmee3SuNfsyOKBL46j6Qe6XBYIq5Iib/A98WO+DwVSFPxy8fcTx/dMMNq8ulaFNhZ4CGEciHLL6P/xB7en9P8mnrxikKXkOzGoPLeXUwhA9qLRtU0Aqy09bIAkaLinm+sb7gX8ULur8dHCqokDmuufYl3FSK/v/g4fFc1wvH6BIXGs7fe1rZsbxQa1tEw9JiIylRv6YLemsegYeYoxU/CTHg20zo7A95QQRmKAl6UZ8xpNTRJZE2Brfl1CxjXiil+4atgKX36qU/hhD8t+V6MCVQYZaDczCeY8A8e1qJCoe3jjD0xVBLQ8AeYo6iJ6n7aMfq2FQ/wDld/drRc+IV1YPrVcfSIw0Dw57rG2ZB8MjgH1HgQaoGe2WOW2zPhSUkRYcIehdK6dPI8afd87DfGxNJGyF7EvZmshUidgqMWl47tmGaB7ZzvtPESOKOG7eOPcL00dzqfIduDw/sBWxNemngEgppEr3PYZg+IWYulFzPzRinxn5aGJNV4Ytl0NU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(39860400002)(396003)(366004)(38350700002)(38100700002)(26005)(66946007)(8676002)(4326008)(6512007)(66476007)(66556008)(36756003)(6916009)(316002)(478600001)(2616005)(86362001)(6486002)(5660300002)(2906002)(8936002)(30864003)(186003)(41300700001)(6506007)(83380400001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHRteGZDSnBXZElVVVFyWld6ekVoZXlGWDBRY0ptKzJKcjJRamtCTXJQai81?=
 =?utf-8?B?R0tTUXlEMHRuVlZBWjNPSEhLdVo3aGZ6OVN2Rko1SXJ4R09JKzRiZHUxbmZl?=
 =?utf-8?B?dmRlQzI4SXFueXAwZkdGU2pIWUd2ZWRzZkYwSHE0b1RQN3B4RjIwTGV3Wlp1?=
 =?utf-8?B?L0FZcVk3N1ZxSGErM3hZdnVSeG5wZjJXMlVLMjd2alRSTFVKQUtQUnFabWVt?=
 =?utf-8?B?ZTh6RndLeitod3BweVRZQUltLzdYeldhNkRPNlowbGRzV3M0bTdZN2p3TTc1?=
 =?utf-8?B?Q3pLOTFZWTBjUjFhclZEd0x2TmIvSlloeEhyeE9qdkFwMkZBaDMxMWp1ZXRo?=
 =?utf-8?B?WHNjWEdGaHhsWEJaYXZqSk10Zlg2a2V6cEJEMlRWSWg3NjkxVlZpQVlqSmg0?=
 =?utf-8?B?SjVwSUdjTi96dGFOKzNJcTYwR1d2cTBOUDhPQ2REWGV4K2NtenVtbUw2YUdv?=
 =?utf-8?B?OHJhODdjOXpYU2FQc1lWU0c2ZEliMXJHOFVCMXBqRnFWU0VENDhiZXRuUjVJ?=
 =?utf-8?B?MTNaRFBLTnUzbVpVS0pIcUZQVlVkZnpmMVovSFg0Z2xrNlo0bm1JbFA2U2V2?=
 =?utf-8?B?QWJZMHhodFBVM0xhUmpFNXFqNUVyZ3R4Vnppc1M2QWVBN1FxQnRlSExMRlVW?=
 =?utf-8?B?ckVKVm56NXJFTDBxcDNxTzVMSWxVTFF5WFlYUW81VVBmOHFzTGZQbWNBdHdL?=
 =?utf-8?B?cm1vKzErVGxTdFdvNy80Njhnd2VtSGdUSXVMemtZN3RGYnlvYmFOODJnTDNa?=
 =?utf-8?B?V3czazlEeExVUG1BeGRhVTdROFF3U1E1MURvWmtVT3ZVcmpUZEpwWHBpdVg4?=
 =?utf-8?B?QWJ1V0wzVzNoRW1BQzliUzE1TmFCenI5RGNrZU5QVXIvLzIzdWVRVWxwaEFv?=
 =?utf-8?B?aE55c1VMcG1HN1NQanFidExLNjU2NHhCUys4MHQxRzVnbDVCeTRXejhjWVdE?=
 =?utf-8?B?c3pWWTRkRGNwSW01am5XdHp3QUhvejBKMlREL3FyQUxrT1p3ZjgwVVBzNlVR?=
 =?utf-8?B?OTlXZ25veWNYZS9rYmZ0dVQrMkVhRFdJRmg0RTdsdVp3MytXVldpdW5TRDFi?=
 =?utf-8?B?OW9sdGVtdUVNVlZyZmNUOHpDNlpnUGxucnljN2JrVDZRZWQvZk9wZXFVbmVM?=
 =?utf-8?B?NHhDRXZONDdETTNndFpnRE1DUjUyNmI2M3BVRitOajhPTGJUMEN1TDY5NDVQ?=
 =?utf-8?B?WENXRTdPWVlPZEEySXY4VGtCSWROUXNUTW13RmlFTC9NVjBTNUtPSGZYRTRi?=
 =?utf-8?B?bGZKbTU1MXdyNkhlcXdIRzBERWZvRGd2TjVsSE4rRGdldk1nTWErejdlaXpk?=
 =?utf-8?B?NWFuUjYxWW9yUm9tbTNHSkFzMTlPZnAwaUkyVXdieDgzTjRLOU40RXl2WTF5?=
 =?utf-8?B?cjhLK2s4bStlWHhDZFVxeVRxRHlJclVvM2h0NTlUQk9kck1HY1V3OUkwWU1L?=
 =?utf-8?B?VVVKTFhCNE1oRFVPTE5HbkU4dFBXMXBLbkc4WnR1amdPeFU0dnBvSGx3U21m?=
 =?utf-8?B?YmZWZ3FMZ003Y2lwOXpUMXVxNG9JR1RYc1pQd25GbEdlb01xR2k0Zkh1TG1u?=
 =?utf-8?B?L28xb0RLa1ptYTFLTVcyRG5nQ2VsSUF6czJDSXNwdnIvVXpTVnA4Wm02cHkr?=
 =?utf-8?B?SFZhaVlmVGNqcTdaME5SeWJMclF0VFFLVU9GTk95QlE1c1FXVnZVK0tEMEMz?=
 =?utf-8?B?MWpoaHM0RUJhc1M2a1Q1Vnk5RnhSTWxISFlucFdOaDFJT3RQTHYvSWxINGth?=
 =?utf-8?B?bjRzL2lpTXRIcGlUSk1ZQlQxb3ljZU1mb2dvSlRqQXdpYVhMNkRkOEVaeUNJ?=
 =?utf-8?B?M0toaWRJbHhiQ1pHMFpBWDRMUUt1VmVNMVFkaFhQaitsSHRMYVlQaWFrMkxu?=
 =?utf-8?B?K0pBSEp4UGYwZFdqejRTWHNVdXFndXgrTWZVK1dnWW8yZXo3N2Q5aG5PTXpq?=
 =?utf-8?B?c2JRZ3EwTWJMdUUzZmhPdXFwRnJKRGt6RTJscC9qNm5xWFp6cUNoWjJBcDVH?=
 =?utf-8?B?d0JudXhTUUo5UElRMVJFM2ZrOCtTK3pSWW1uanRoMTlpLytJaytKZzZqWjh4?=
 =?utf-8?B?TDduN3B3WjRmOWFFSGtNaEdRbHp4NGFVMGhDdVR1T1A1QUNBdW55NFhlRy8x?=
 =?utf-8?B?YWdsTU00L3Qzc0Q1dURaanJ1RVlHTUhmektNdEQ2UGNXa092czdDQjJPRWVD?=
 =?utf-8?B?d3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: DOS3NYd32ptFfmHiV12vXC1yaTRVS3wXWaE045eyXPpiVPCwf4vIet7D0xoC3JHx+Z0zVM3S2VGcO2/agHPiXd/+QPM3qQ1Q4gSA+94T9v4o7nwWwfCDmS4vUGSb6uf6sgnkr/cQT16Is4fwp66TcyGgy8XRpSXgLN9d5PW9PUWFhIqpmPz0YEI+lmotKPQ6ItCzDoHL+bD/tZ5ph1XoOa1FhsmIxAUJs8rTk5ghZvwUtBJ32v7/gC8p15HmCF4DkrwW3EgjqkwI9wkZWZ4XelzXjtI+pHbjxoJhM/nUuDcUI13Ospwegqj6cAOesB2X1f5HGPNY0FPIKxXUi+GLnHDFYBsGVbhyO48s4gF2SilR7qowEjynoEIsWxuj2pf3UwSidtgZ3BNY2fNx+FzxLj4Xxy1+j16itjAoGzrQJxKWNvoYtyfmibjwdxx8kOYWB4vPbH/DmfvAxcsrEAP3n9AoclZ42XRtciMg5cjPIvfLRZxdvC2ZflXA1JunqUsAB2y1xyHXRGdLq3W8D9BE9A4RaGtC5z5Gq5S8AX6TblgygpfmUJwZgybhvfS8sKn4Y55MvpLcnlUFeXLf9zetKsDmO4u2LFxkZ0WeTkmWYygP2Am/Bfe3nG1YJOUqWhy37RibsBmFLtZs/l9o9BXNNvStb4zMbo5PVSpX2vBKonmS3cXdR6NNTPHz4MbQ5yu5DRaw+w2CI5C12iVxKtdvDTFLj2Cz8QPSwezmqW71vj6f3t75J5RWfrtjBq8G7JhVDjzp5SfV+ZMEZjjYin6Bzw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ad19b0b-13a4-4a5e-ab6e-08da7a7da6a0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:08:51.2800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hUvJoqBYrmWugOk0CdKI471COMEuUVygZ9HNqgKiZxaFgqYQQvLltjBEApocCmfHynAUmmRUwyOlCLWKoa6B+Dnkb2JDRCei7H7G77JjJU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4545
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208100008
X-Proofpoint-GUID: 1_c6UeGx9eXMEz9HHaseihX58oYxIIm0
X-Proofpoint-ORIG-GUID: 1_c6UeGx9eXMEz9HHaseihX58oYxIIm0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-08-09 at 10:48 -0700, Darrick J. Wong wrote:
> On Thu, Aug 04, 2022 at 12:40:06PM -0700, Allison Henderson wrote:
> > We need to add, remove or modify parent pointer attributes during
> > create/link/unlink/rename operations atomically with the dirents in
> > the
> > parent directories being modified. This means they need to be
> > modified
> > in the same transaction as the parent directories, and so we need
> > to add
> > the required space for the attribute modifications to the
> > transaction
> > reservations.
> 
> While we're on the topic of log reservations ... Dave and I noticed
> during the 5.19 cycle that xfs_log_calc_max_attrsetm_res has a unit
> conversion problem when it's trying to compute the minimum log size:
> 
> STATIC int
> xfs_log_calc_max_attrsetm_res(
> 	struct xfs_mount	*mp)
> {
> 	int			size;
> 	int			nblks;
> 
> 	size = xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize) 
> -
> 	       MAXNAMELEN - 1;
> 
> Notice here that @size is the maximum amount of space that a local
> format attribute can use in an xattr leaf block.  The computation is
> in
> units of bytes.
> 
> 	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> 	nblks += XFS_B_TO_FSB(mp, size);
> 
> ...and here we convert bytes to fs blocks for the block count
> computation...
> 
> 	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
> 
> ...but here we pass the byte count into a macro that takes a block
> count
> as its second parameter and returns the number of bmbt blocks needed
> to
> add that many blocks to an attribute fork.  Oops!
> 
> I would like to fix this incorrect code, but it's never a good idea
> to
> adjust downwards the min log size calculation for existing
> filesystems,
> because this can result in the situation where new mkfs formats a
> filesystem with a small enough log that an old kernel won't mount it.
> 
> Therefore, the corrected logic would have to be gated on whatever
> happens to be the next new ondisk feature.  It's probably too late to
> do
> this for large extent counts, but fixing the calculation would be (I
> think) appropriate for parent pointers, since it's still undergoing
> review and won't be an easy upgrade, which eliminates the legacy
> problem.
> 
> I'll attach the patches that I've written as patches 19 and 20 to
> this
> patchset, if you don't 
Sure, I will keep an eye out for them then.

> 
> 	return  M_RES(mp)->tr_attrsetm.tr_logres +
> 		M_RES(mp)->tr_attrsetrt.tr_logres * nblks;
> }
> 
> 
> > [achender: rebased]
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_trans_resv.c | 105 +++++++++++++++++++++++++++
> > ------
> >  1 file changed, 86 insertions(+), 19 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c
> > b/fs/xfs/libxfs/xfs_trans_resv.c
> > index e9913c2c5a24..b43ac4be7564 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > @@ -909,24 +909,67 @@ xfs_calc_sb_reservation(
> >  	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
> >  }
> >  
> > -void
> > -xfs_trans_resv_calc(
> > -	struct xfs_mount	*mp,
> > -	struct xfs_trans_resv	*resp)
> > +STATIC void
> > +xfs_calc_parent_ptr_reservations(
> > +	struct xfs_mount     *mp)
> >  {
> > -	int			logcount_adj = 0;
> > +	struct xfs_trans_resv   *resp = M_RES(mp);
> >  
> > -	/*
> > -	 * The following transactions are logged in physical format and
> > -	 * require a permanent reservation on space.
> > -	 */
> > -	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp,
> > false);
> > -	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
> > -	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > +	/* Calculate extra space needed for parent pointer attributes
> > */
> 
> This might be better expressed as a comment just prior to the
> function
> declaration above.
Alrighty, will move upwards

> 
> > +	if (!xfs_has_parent(mp))
> > +		return;
> >  
> > -	resp->tr_itruncate.tr_logres =
> > xfs_calc_itruncate_reservation(mp, false);
> > -	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> > -	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > +	/* rename can add/remove/modify 4 parent attributes */
> > +	resp->tr_rename.tr_logres += 4 * max(resp-
> > >tr_attrsetm.tr_logres,
> > +					 resp->tr_attrrm.tr_logres);
> 
> Why does the per-transaction reservation increase by 4x the amount of
> space needed to set (or delete) an xattr?  The pptr patchset now uses
> logged xattrs, which means that each xattr update needed to commit
> the
> rename operation will happen in a separate transaction.  IOWs, each
> transaction in the chain does not have to handle *every* update that
> must be made during the entire chain, it only has to handle one step
> of
> the full process.
Oh, I think initially this might have been pre-larp code, so probably
we  can just drop it now

> 
> Doesn't that mean that the size of tr_rename.tr_logres only needs to
> increase by the amount of space needed to log the four(?) xattr items
> to
> the first transaction in the chain?  AFAICT, it also can't be smaller
> than max(resp->tr_attrsetm.tr_logres, resp->tr_attrrm.tr_logres);
I think so, probably we can just leave it as max

> 
> (I'm also not sure why four -- the patch for xfs_rename only creates
> three xfs_parent_defer objects.)
Hrmm, well initially I think it was for 4 inodes, but then we
remembered wip in the last review, so now it's 5 right? That's why we
expanded XFS_DEFER_OPS_NR_INODES in patch 1.  So probably the 4 inodes
needs to turn into a 5 in this patch too.


> 
> I also think that adjusting tr_rename to account for parent pointers
> is
> something that should be done in xfs_calc_rename_reservation, not a
> separate function:
> 
> /*
>  * In renaming a files we can modify (t1):
>  *    the four inodes involved: 4 * inode size
5?

>  *    the two directory btrees: 2 * (max depth + v2) * dir block size
>  *    the two directory bmap btrees: 2 * max depth * block size
>  * And the bmap_finish transaction can free dir and bmap blocks (two
> sets
>  *	of bmap blocks) giving (t2):
>  *    the agf for the ags in which the blocks live: 3 * sector size
>  *    the agfl for the ags in which the blocks live: 3 * sector size
>  *    the superblock for the free block count: sector size
>  *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) *
> block size
>  * If parent pointers are enabled (t3), then each transaction in the
> chain
>  *    must be capable of setting or removing the extended attribute
>  *    containing the parent information.  It must also be able to
> handle
>  *    the three xattr intent items that track the progress of the
> parent
>  *    pointer update.
>  */
> STATIC uint
> xfs_calc_rename_reservation(
> 	struct xfs_mount	*mp)
> {
> 	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
> 	unsigned int		t1, t2, t3 = 0;
> 
> 	t1 = xfs_calc_inode_res(mp, 4) +
and then the same 5 goes in here too...

> 	     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
> 			XFS_FSB_TO_B(mp, 1));
> 
> 	t2 = xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
> 	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
> 			XFS_FSB_TO_B(mp, 1))));
> 
> 	if (xfs_has_parent(mp)) {
> 		t3 = max(resp->tr_attrsetm.tr_logres,
> 				resp->tr_attrrm.tr_logres);
> 		overhead += 3 * (size of a pptr xattr intent item);
> 	}
> 
> 	return overhead + max3(t1, t2, t3);
> }
> 
> > +	resp->tr_rename.tr_logcount += 4 * max(resp-
> > >tr_attrsetm.tr_logcount,
> > +					   resp-
> > >tr_attrrm.tr_logcount);
> 
> Looks correct, module the 4 vs. 3 thing.
> 
I think that looks right?  5 inodes 3 pptrs?


> > +
> > +	/* create will add 1 parent attribute */
> > +	resp->tr_create.tr_logres += resp->tr_attrsetm.tr_logres;
> > +	resp->tr_create.tr_logcount += resp->tr_attrsetm.tr_logcount;
> > +
> > +	/* mkdir will add 1 parent attribute */
> > +	resp->tr_mkdir.tr_logres += resp->tr_attrsetm.tr_logres;
> > +	resp->tr_mkdir.tr_logcount += resp->tr_attrsetm.tr_logcount;
> > +
> > +	/* link will add 1 parent attribute */
> > +	resp->tr_link.tr_logres += resp->tr_attrsetm.tr_logres;
> > +	resp->tr_link.tr_logcount += resp->tr_attrsetm.tr_logcount;
> > +
> > +	/* symlink will add 1 parent attribute */
> > +	resp->tr_symlink.tr_logres += resp->tr_attrsetm.tr_logres;
> > +	resp->tr_symlink.tr_logcount += resp->tr_attrsetm.tr_logcount;
> > +
> > +	/* remove will remove 1 parent attribute */
> > +	resp->tr_remove.tr_logres += resp->tr_attrrm.tr_logres;
> > +	resp->tr_remove.tr_logcount += resp->tr_attrrm.tr_logcount;
> > +}
> > +
> > +/*
> > + * Namespace reservations.
> > + *
> > + * These get tricky when parent pointers are enabled as we have
> > attribute
> > + * modifications occurring from within these transactions. Rather
> > than confuse
> > + * each of these reservation calculations with the conditional
> > attribute
> > + * reservations, add them here in a clear and concise manner. This
> > assumes that
> > + * the attribute reservations have already been calculated.
> > + *
> > + * Note that we only include the static attribute reservation
> > here; the runtime
> > + * reservation will have to be modified by the size of the
> > attributes being
> > + * added/removed/modified. See the comments on the attribute
> > reservation
> > + * calculations for more details.
> > + *
> > + * Note for rename: rename will vastly overestimate requirements.
> > This will be
> > + * addressed later when modifications are made to ensure parent
> > attribute
> 
> Later?  I took a look at the rename patch, and it looks like we're
> using
> logged xattrs from the start.
I think it's a stale comment.  Will remove.  Thanks for the reviews!

Allison

> 
> --D
> 
> > + * modifications can be done atomically with the rename operation.
> > + */
> > +STATIC void
> > +xfs_calc_namespace_reservations(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_trans_resv	*resp)
> > +{
> > +	ASSERT(resp->tr_attrsetm.tr_logres > 0);
> >  
> >  	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
> >  	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
> > @@ -948,15 +991,37 @@ xfs_trans_resv_calc(
> >  	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
> >  	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> >  
> > +	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
> > +	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
> > +	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > +
> > +	xfs_calc_parent_ptr_reservations(mp);
> > +}
> > +
> > +void
> > +xfs_trans_resv_calc(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_trans_resv	*resp)
> > +{
> > +	int			logcount_adj = 0;
> > +
> > +	/*
> > +	 * The following transactions are logged in physical format and
> > +	 * require a permanent reservation on space.
> > +	 */
> > +	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp,
> > false);
> > +	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
> > +	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > +
> > +	resp->tr_itruncate.tr_logres =
> > xfs_calc_itruncate_reservation(mp, false);
> > +	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> > +	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > +
> >  	resp->tr_create_tmpfile.tr_logres =
> >  			xfs_calc_create_tmpfile_reservation(mp);
> >  	resp->tr_create_tmpfile.tr_logcount =
> > XFS_CREATE_TMPFILE_LOG_COUNT;
> >  	resp->tr_create_tmpfile.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> >  
> > -	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
> > -	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
> > -	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > -
> >  	resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
> >  	resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
> >  	resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > @@ -986,6 +1051,8 @@ xfs_trans_resv_calc(
> >  	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
> >  	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> >  
> > +	xfs_calc_namespace_reservations(mp, resp);
> > +
> >  	/*
> >  	 * The following transactions are logged in logical format with
> >  	 * a default log count.
> > -- 
> > 2.25.1
> > 

