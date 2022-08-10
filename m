Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF83C19F2D
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 03:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiHJDJu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiHJDJs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 23:09:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9987FE6C
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 20:09:47 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0E8SZ026805;
        Wed, 10 Aug 2022 03:09:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=e0ZdVgEZdAjBYmpleYUDqKDDZHRTcVc8yVG7Gj/W0iE=;
 b=RM91iafOod4MVwMjAN4gkJC7BfPhMgEmN/uxqkZCrPwRGwcXdE1MAht7NHnedSJ0hKzR
 kU6fACs6JNCUCEbKE4f044Yt9tF85oTKvmXK9Lm+YNTz8sqdsa0gk4ComOPvbpRFAZED
 NryQbwM2TFqKcLxsWpwPmoePK2/ECpiFpZssibIWcLvHmectM8d/UDacoQ6oQ07D2EX3
 DickofKDdHYlla6URiGKmDOJPoUReMTPlu+XYLjeiLziE+AcZDBMp2eblve4G+Va6O/h
 MyTJIvToVTPuC/qSCxb/3H4uuW6FiVLXtmVPetLkJ+/XbuPxAWa42sJ0ZVXDfcYVRGLh Dw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqbgpy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:09:43 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 279Nfwfp038442;
        Wed, 10 Aug 2022 03:09:42 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2049.outbound.protection.outlook.com [104.47.73.49])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqh8gex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:09:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBDIYtf61EcZOZJEyjgenbp+lbUc0EJ64k5s2oi+ojllHiE0PWiX0/gZxnfsssDll77obkAJ+rYvQd74Vx7NTF724JeUGiRKDqAK8Z9wKM2oRiAEr2dXNzXAlHq0xXCfe17YTzNBQvlLbjHzjjkvo0ssCeRZ/VOtVCImciV6UpQVD7RJsRU5wUR2b/TkWHsNk1AyKqE/OTGsSEn5wtUzzoxrz/dxN3geq9nreaXC+nqj9K7D8zUJrVbs8zMGjZhnOIFuTHXEblpofBNyxNaGs/hD768bsbIJIPVjjFGf1xQ+4fAgTcL30wH/kZ7kNxt9gbiUCzjmShxjn6ZYGw9Yzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e0ZdVgEZdAjBYmpleYUDqKDDZHRTcVc8yVG7Gj/W0iE=;
 b=Yb1Lxv5HPBgU5FnVzbwd9STCemR7dm6lCCJGgSOIqPgy6izqw60zZMdwIu0qxgvLmQ/ypKzvJMY9KCASdvHwdVbowb9XKzjjaIXNS/MESHhvmg+EvxqYZtfju4kXL2d5JacYsbaYXzuZ1PS7AlDvaJxAhftkcP2CfPnmEj3JoSntUd10wZQE9BqhqCnhsqW9F8WVJn+JUNIAPnVV3oqhzP9172/HSjSbdCt4e9e5Ety753dMulGZ+cYmFRl7nB1ORldzz7czW2d8611fcaBcA6bA+0DxdfDyJ1mNfptsCCmezw6EVXY6cjDSXzVlpPGg5MjKb0lFP+wqFDYauWoadg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e0ZdVgEZdAjBYmpleYUDqKDDZHRTcVc8yVG7Gj/W0iE=;
 b=pX/La6QgeAU4j4Dcl/V3cePuIRv0WGjjaA1gEigULyOUmpz9ReS5inq5FYPtES1UtbpZ1P53SJ/W5TJ8c76ncWmEKuFdJMjkVk22/wH4Ui0CnrIQJiYzdmE9x0G7J/wdtrWqsI6CR+jCKX6eYyu3hFfdLWADI8mSsYRhkJHtw5I=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4545.namprd10.prod.outlook.com (2603:10b6:303:9a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 10 Aug
 2022 03:09:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:09:40 +0000
Message-ID: <cb63b99d315290df68e86f7e9ed1febbc348b67d.camel@oracle.com>
Subject: Re: [PATCH RESEND v2 15/18] xfs: Add parent pointers to rename
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 09 Aug 2022 20:09:39 -0700
In-Reply-To: <YvKsUyj3Ob9lqFYh@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
         <20220804194013.99237-16-allison.henderson@oracle.com>
         <YvKsUyj3Ob9lqFYh@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0029.namprd13.prod.outlook.com
 (2603:10b6:a03:180::42) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4754ea9-4e4d-40b8-ab8d-08da7a7dc41d
X-MS-TrafficTypeDiagnostic: CO1PR10MB4545:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5uWIAf7CwS1uFxiqclonoPOxkskwCjX4ri75FvQsKGCCuLtxqRfG3+didTuzAVO51LMfTE6LBEoGI1GcPPHi3nqk6s8dLfLx8MJDxDfgGja2xhOJ9NlK9VbdMH8hnZqWtxIlWhEia7RCydDK1FBhOOB7TUNOIfXO4g+WgW1sQOrgWbsK1QHmYaBTDdA93bzzYZNNbflqK76QgRQMvSLljB3i4LRe7i22Kp0cAlP0FKENdGPv05wDtooVCLjU+BzAebQ47V84++BV/noac3E7pnOaNdxhrEyHzTlIpFKkvPjb64ZdfqWAPhoQeqirbBSaGkcl5d9Wi+FMtlDsgGwCi9enhESO2/ITiWrkJKGqj37TyDRI1bL+TssIMaQr5Ui+upNHYeZRC2kukCIiokHBEWiA/PBqRzKsJRyAT5pU3XriRs6KOB8GUeCrb3HhAqmmG5s0HapC3gy+9QXfpLR9UJb1FEwBwiENPEUcTheauRTuWVdkFSaDDlolziUvsRTPQswTxphwgwjsTzGgrxZxdteq/cpvBtaGUQdFSbcyLPCr1YzpwVClza2v9RfSjbsmZHMt+Mrg9ORQre5RfHtqwqWHnZwfmWb3Xbj4j/SlLrGskZF35L9eVWeteAWGUUBASqfTgg9mYoCAV/5T+kDXL/HQG5Bpi+wDoWuPkY98sg+V05Sqy+huVYQRrFfYV3DncYtt5FTfi71yp3DzslDyWrpMQQG4p/I/UkIx80chrpI/5U0s1KMudRoff+44d+N+iconCQTqfTDf6EKM4t/L7BrOpCiFW6Jm7ueXniE9Avg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(39860400002)(396003)(366004)(38350700002)(38100700002)(26005)(66946007)(8676002)(4326008)(6512007)(66476007)(66556008)(36756003)(6916009)(316002)(478600001)(2616005)(86362001)(6486002)(5660300002)(2906002)(8936002)(186003)(41300700001)(6506007)(83380400001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkd0VGIxVzRGdEZiZFZZOTBCUmdidStnaGFNbUM0Q3ZjN1Z3b2NENG92QjhW?=
 =?utf-8?B?Q1c0ZnRYTG9uQ1crbGRzcjlCM1hzUWRMcUR4ZkZxc0ZITHM4eXlQODZvWDF0?=
 =?utf-8?B?WWU1NHU4Z0pVcCtycUZwemFQeTkvTzRIOC9wb0tSTWI2RVFCeDhoT2hDZnpn?=
 =?utf-8?B?ZjFhSk5BSXZFRWU2eHd5TGFmWlFXZ3plVUNRNWlFdGZuVEdUdmFNYlY1ZEdF?=
 =?utf-8?B?QVlFandMVFlic3Rub0JhYzQwR0dncmlQWisvSy96L0w0TnNHdHpBY25IdXpv?=
 =?utf-8?B?Sk90LzNkYzhNQ1NXd042cVhkOXkwQWZXMytPZW91Ymt3ajhIeUN4REp2d2ZR?=
 =?utf-8?B?cHFKZ1BhZjR4UFhjVlpUbHp6cWtIZHQ1aUU2dE9hUWk3dWtEajVQZ3dMYm11?=
 =?utf-8?B?ZDZOTWlQcitnb2xWMmtvZFJ4T2FtZTA0T25Qd0dKMDVxUng0V0svTndDM2tD?=
 =?utf-8?B?L21OK2pTSXRjVXltOGlvTUZVOEV2QUd2YXhicC9CM0hORUNnYWFtS3orSytK?=
 =?utf-8?B?a3VWWTlFUU8xbWpteUxzRUNpd1VuV3dxT2g4WlV4dDViQll0T09oUHFwMTJR?=
 =?utf-8?B?bTB1eU40VnI2L2laQ2l2Q0t5UktFaUNodnFSVlVuYldnUDVkSWtZQXMzSE5x?=
 =?utf-8?B?WG1aUVNXZW5uNWl2d0ZaL3M4cGdFd2JkVlFMLzFFQVRyVy9LU3NhamFIWFRJ?=
 =?utf-8?B?WjAybjFKeVB1RlY2MEFwenhwcmRmU1A0dGNNUlBjbzNyVTl3VWNYYkZxaWd0?=
 =?utf-8?B?YjRPTC9iT1Y3L1dPRzdWNzdIaVhuSjM4MUUvWkNLR2YyRlovYUVCQVlOQTll?=
 =?utf-8?B?emJES1MzcjdVWnF2SDZFM3RXdXl5L1VNb1l4djdmQmYyUHRlaHRhY0srVkh2?=
 =?utf-8?B?V3NKN05GWlZqMVFRNFR1T3hhbDAwU1VrSnNWM1JZTHZ1TUdoSUFCdTJCb2Ri?=
 =?utf-8?B?OXFicy9ZOEppempDdGVzcWM2SzNLM21RUHUxSWxWN3pqNzM4QjRicG0wTE0x?=
 =?utf-8?B?eUppQzJKaEY4U2VvempNWnk3MTc4MSt5Y2xNSW5JdXdnUDBIbXo1TG9zY1Za?=
 =?utf-8?B?MXdUSGo3cW12Y01PNW5uZlFlTVJaRGZxWjE3TEdxTGdIVnFrbHdVQ0kzV1Np?=
 =?utf-8?B?eUZRMHJKYWJ4a1JQaDB1VW1IaC9pRHN0Y1c2bzZGMklqa0xHUEVKNDM5NDNO?=
 =?utf-8?B?VUx2c3A4QytBNWZEUnZQL2JVcEN2Q1hCTjE2RWpueDR3V2ExWDh4MTlsNlM2?=
 =?utf-8?B?RWx3VkhnYmFUSWIzZ29lUU45VithY2VGeXlHcytGZGM5NmlPcnFDSmF1MWtZ?=
 =?utf-8?B?Q2Ridm1NSzI4aFl3cGQ5SzdSWVJTc00rS3RTRXJsN3E4WUs0bjY0L1pWK3h6?=
 =?utf-8?B?SlYzRXRRaENncVExdE50UmwxeGJRcHVBMTZaR2xvRHljYVJvSUN0OUJ6Zjdt?=
 =?utf-8?B?bmgwVXBlNHN3MVVMcHJVNUdvQ1pDRGdIYjVINml6a0dqTktUWkxlTmt4NjhC?=
 =?utf-8?B?aVBpdStJMHVzbVVnMjlsaFkxVitLMHhleW5oSCtSSWU2UHMxdm1IUWpqUjlx?=
 =?utf-8?B?MmY2UExBR1ZMYTZJaXo5R0hKbVA5dHZqU2ZyWHlZYkQyUFRyVEg1N1hUMFpr?=
 =?utf-8?B?Yk4ya2ZGQWs1THh1WDhiY0tQdlJ3clMzZk9xN1R5QUtZTE03ZkM4VVNlYTdC?=
 =?utf-8?B?aU1Oa0N1My9kdmdYRExQUWZTN05CZUJTYlpkOW0zZjQ3TFAwd2NWYmNSOHJt?=
 =?utf-8?B?YW9zTTFWeDBQVm5VcUNiSzdyZUIwWU13WUxLVUNJa0N0dGJRWFhUU2MwQnc2?=
 =?utf-8?B?VVA4Ny9tcE1sSVlaOUw5WmZFcTNzeHY4bmJEbzBjQ3MrUEdzNDJWV0FUWmF2?=
 =?utf-8?B?N3BweEw2L3N0YnlSUFEzUGRUWTBmbFErUi9teHBYc0lXWTFvQ3Rxd0RadWlU?=
 =?utf-8?B?Rnk2NGREenNqMStPeS9PZjNEazhRUlI0cW94ekFEWmtnVGVTR3NoY213MUdy?=
 =?utf-8?B?aHBiMHFhc21hQjd0dDZWZytUQTBveG4zZHNtNHBuSzBZWnFEWWRhN2JIQUtp?=
 =?utf-8?B?UjExOGhiMmZEcFY3L1Y0RnI3czN3ZU45Rmt5aGRxUXFWTGdoakR2MWJsTEpw?=
 =?utf-8?B?QXZQbnl1UUMxbVNUdkoramwxdU1TUUZBMFljWklMSTNpaGtrT2NrQTRKYmxB?=
 =?utf-8?B?c3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 959ooEbYcfZmEbL+4fDK5aXojWV7YGyjU2s3k5lDbVk1jl9H8bcbv/OfHV3SNYMj47uwRaT1FPEETg5/nLzpiwe8kiYor1npo0rZMNpn2v7euHMJoeRTwlaURuAJ1S4RSL2E7ZzpAaS4e0AiOtTf6c0ZEpSqiKSUqpZbg9ABtHaZAPxPO1SFV9jIXf/CJe4LXf6+/NlBhLqupwYr+eh6U9W0tvf07czEqC4XQBhKrdsa6Xaln98t+l65jwIDv8+AuOQPuNrjHwuQrDVxpO+9krzPfo1n6DUyjUb8yDvkybdSZoq7QGCVVqfVplvxJK1tCfk51wT75b0FFfbc1O4RpluI9ev/7QKVMFzLEiWyaWJ0RUxbsso7iSZjuTw4M5YOKnJXWdBtg36UmvosGSrgIj53BhhQsL129AfvT9Zn6M6Lytvra92Jw4eozV/GfXKsTn3RJicOZN8irFo1E9Nky2U07qj8uMwph2QXNkGsOirJ2oGeEWckcfWk3mtM4+dhknsC0k6JgNAeMUbbR0g88yIz2dADTsdz8lJSh0M4XiMmSfmktlpJysdqD0Ngl596sJC7FrSvyDOGbuq7E1vaCsS/32cq82FJIVwRDvGKtTYkZBumE2gaoRJsu+JvuR1MHZowdfwO3CHp7iEVqPJls20wQGWZf1bHlyiku1nLGgXvp3VJpLQXXfnd4m6dNZE/JZUjFdB+Btxf6Px7DGsmXVTk6Ye/0CBKRdH9xGs/sGIX8FnNhOFTHvfoWEFAeeHWx4a/n75J5VAl+mZX+3UO8A==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4754ea9-4e4d-40b8-ab8d-08da7a7dc41d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:09:40.7063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /P4JkdUzRUjzi8rQO8S6Zz7XWl98myoAQ5unH0ZHa+DAC7bKdU6pz2pn6VUehAMZUU2MKqYtuAb2wE2arbnacMIFkdaWQZnouN+ji+WS8Pw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4545
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100008
X-Proofpoint-GUID: 6eeOHSYI3zDjpqQhBKS2nl3W7mKQdaNU
X-Proofpoint-ORIG-GUID: 6eeOHSYI3zDjpqQhBKS2nl3W7mKQdaNU
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-08-09 at 11:49 -0700, Darrick J. Wong wrote:
> On Thu, Aug 04, 2022 at 12:40:10PM -0700, Allison Henderson wrote:
> > This patch removes the old parent pointer attribute during the
> > rename
> > operation, and re-adds the updated parent pointer.  In the case of
> > xfs_cross_rename, we modify the routine not to roll the transaction
> > just
> > yet.  We will do this after the parent pointer is added in the
> > calling
> > xfs_rename function.
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/xfs_inode.c | 128 +++++++++++++++++++++++++++++++++------
> > ------
> >  1 file changed, 94 insertions(+), 34 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 69bb67f2a252..8a81b78b6dd7 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -2776,7 +2776,7 @@ xfs_cross_rename(
> >  	}
> >  	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD |
> > XFS_ICHGTIME_CHG);
> >  	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
> > -	return xfs_finish_rename(tp);
> > +	return 0;
> >  
> >  out_trans_abort:
> >  	xfs_trans_cancel(tp);
> > @@ -2834,26 +2834,31 @@ xfs_rename_alloc_whiteout(
> >   */
> >  int
> >  xfs_rename(
> > -	struct user_namespace	*mnt_userns,
> > -	struct xfs_inode	*src_dp,
> > -	struct xfs_name		*src_name,
> > -	struct xfs_inode	*src_ip,
> > -	struct xfs_inode	*target_dp,
> > -	struct xfs_name		*target_name,
> > -	struct xfs_inode	*target_ip,
> > -	unsigned int		flags)
> > +	struct user_namespace		*mnt_userns,
> > +	struct xfs_inode		*src_dp,
> > +	struct xfs_name			*src_name,
> > +	struct xfs_inode		*src_ip,
> > +	struct xfs_inode		*target_dp,
> > +	struct xfs_name			*target_name,
> > +	struct xfs_inode		*target_ip,
> > +	unsigned int			flags)
> >  {
> > -	struct xfs_mount	*mp = src_dp->i_mount;
> > -	struct xfs_trans	*tp;
> > -	struct xfs_inode	*wip = NULL;		/* whiteout inode
> > */
> > -	struct xfs_inode	*inodes[__XFS_SORT_INODES];
> > -	int			i;
> > -	int			num_inodes = __XFS_SORT_INODES;
> > -	bool			new_parent = (src_dp != target_dp);
> > -	bool			src_is_directory =
> > S_ISDIR(VFS_I(src_ip)->i_mode);
> > -	int			spaceres;
> > -	bool			retried = false;
> > -	int			error, nospace_error = 0;
> > +	struct xfs_mount		*mp = src_dp->i_mount;
> > +	struct xfs_trans		*tp;
> > +	struct xfs_inode		*wip = NULL;		/* whiteout
> > inode */
> > +	struct xfs_inode		*inodes[__XFS_SORT_INODES];
> > +	int				i;
> > +	int				num_inodes = __XFS_SORT_INODES;
> > +	bool				new_parent = (src_dp !=
> > target_dp);
> > +	bool				src_is_directory =
> > S_ISDIR(VFS_I(src_ip)->i_mode);
> > +	int				spaceres;
> > +	bool				retried = false;
> > +	int				error, nospace_error = 0;
> > +	xfs_dir2_dataptr_t		new_diroffset;
> > +	xfs_dir2_dataptr_t		old_diroffset;
> > +	struct xfs_parent_defer		*old_parent_ptr = NULL;
> > +	struct xfs_parent_defer		*new_parent_ptr = NULL;
> > +	struct xfs_parent_defer		*target_parent_ptr = NULL;
> >  
> >  	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
> >  
> > @@ -2877,6 +2882,15 @@ xfs_rename(
> >  
> >  	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
> >  				inodes, &num_inodes);
> > +	if (xfs_has_parent(mp)) {
> > +		error = xfs_parent_init(mp, src_ip, NULL,
> > &old_parent_ptr);
> > +		if (error)
> > +			goto out_release_wip;
> > +		error = xfs_parent_init(mp, src_ip, target_name,
> > +					&new_parent_ptr);
> > +		if (error)
> > +			goto out_release_wip;
> > +	}
> >  
> >  retry:
> >  	nospace_error = 0;
> > @@ -2889,7 +2903,7 @@ xfs_rename(
> >  				&tp);
> >  	}
> >  	if (error)
> > -		goto out_release_wip;
> > +		goto drop_incompat;
> >  
> >  	/*
> >  	 * Attach the dquots to the inodes
> > @@ -2911,14 +2925,14 @@ xfs_rename(
> >  	 * we can rely on either trans_commit or trans_cancel to unlock
> >  	 * them.
> >  	 */
> > -	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
> > +	xfs_trans_ijoin(tp, src_dp, 0);
> >  	if (new_parent)
> > -		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
> > -	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
> > +		xfs_trans_ijoin(tp, target_dp, 0);
> > +	xfs_trans_ijoin(tp, src_ip, 0);
> >  	if (target_ip)
> > -		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
> > +		xfs_trans_ijoin(tp, target_ip, 0);
> >  	if (wip)
> > -		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
> > +		xfs_trans_ijoin(tp, wip, 0);
> >  
> >  	/*
> >  	 * If we are using project inheritance, we only allow renames
> > @@ -2928,15 +2942,16 @@ xfs_rename(
> >  	if (unlikely((target_dp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
> >  		     target_dp->i_projid != src_ip->i_projid)) {
> >  		error = -EXDEV;
> > -		goto out_trans_cancel;
> > +		goto out_unlock;
> >  	}
> >  
> >  	/* RENAME_EXCHANGE is unique from here on. */
> > -	if (flags & RENAME_EXCHANGE)
> > -		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
> > +	if (flags & RENAME_EXCHANGE) {
> > +		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
> >  					target_dp, target_name,
> > target_ip,
> >  					spaceres);
> > -
> > +		goto out_pptr;
> > +	}
> >  	/*
> >  	 * Try to reserve quota to handle an expansion of the target
> > directory.
> >  	 * We'll allow the rename to continue in reservationless mode
> > if we hit
> > @@ -3052,7 +3067,7 @@ xfs_rename(
> >  		 * to account for the ".." reference from the new
> > entry.
> >  		 */
> >  		error = xfs_dir_createname(tp, target_dp, target_name,
> > -					   src_ip->i_ino, spaceres,
> > NULL);
> > +					   src_ip->i_ino, spaceres,
> > &new_diroffset);
> >  		if (error)
> >  			goto out_trans_cancel;
> >  
> > @@ -3073,10 +3088,14 @@ xfs_rename(
> >  		 * name at the destination directory, remove it first.
> >  		 */
> >  		error = xfs_dir_replace(tp, target_dp, target_name,
> > -					src_ip->i_ino, spaceres, NULL);
> > +					src_ip->i_ino, spaceres,
> > &new_diroffset);
> >  		if (error)
> >  			goto out_trans_cancel;
> >  
> > +		if (xfs_has_parent(mp))
> > +			error = xfs_parent_init(mp, target_ip, NULL,
> > +						&target_parent_ptr);
> > +
> >  		xfs_trans_ichgtime(tp, target_dp,
> >  					XFS_ICHGTIME_MOD |
> > XFS_ICHGTIME_CHG);
> >  
> > @@ -3146,26 +3165,67 @@ xfs_rename(
> >  	 */
> >  	if (wip)
> >  		error = xfs_dir_replace(tp, src_dp, src_name, wip-
> > >i_ino,
> > -					spaceres, NULL);
> > +					spaceres, &old_diroffset);
> >  	else
> >  		error = xfs_dir_removename(tp, src_dp, src_name,
> > src_ip->i_ino,
> > -					   spaceres, NULL);
> > +					   spaceres, &old_diroffset);
> >  
> >  	if (error)
> >  		goto out_trans_cancel;
> >  
> > +out_pptr:
> > +	if (new_parent_ptr) {
> > +		error = xfs_parent_defer_add(tp, target_dp,
> > new_parent_ptr,
> > +					     new_diroffset);
> > +		if (error)
> > +			goto out_trans_cancel;
> > +	}
> > +
> > +	if (old_parent_ptr) {
> > +		error = xfs_parent_defer_remove(tp, src_dp,
> > old_parent_ptr,
> > +						old_diroffset);
> > +		if (error)
> > +			goto out_trans_cancel;
> > +	}
> > +
> > +	if (target_parent_ptr) {
> > +		error = xfs_parent_defer_remove(tp, target_dp,
> > +						target_parent_ptr,
> > +						new_diroffset);
> > +		if (error)
> > +			goto out_trans_cancel;
> > +	}
> > +
> >  	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD |
> > XFS_ICHGTIME_CHG);
> >  	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
> >  	if (new_parent)
> >  		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
> >  
> >  	error = xfs_finish_rename(tp);
> > +
> > +out_unlock:
> >  	if (wip)
> >  		xfs_irele(wip);
> > +	if (wip)
> > +		xfs_iunlock(wip, XFS_ILOCK_EXCL);
> > +	if (target_ip)
> > +		xfs_iunlock(target_ip, XFS_ILOCK_EXCL);
> > +	xfs_iunlock(src_ip, XFS_ILOCK_EXCL);
> > +	if (new_parent)
> > +		xfs_iunlock(target_dp, XFS_ILOCK_EXCL);
> > +	xfs_iunlock(src_dp, XFS_ILOCK_EXCL);
> 
> Sorry to be fussy, but could you separate the ILOCK unlocking changes
> (and maybe the variable indentation part too) into a separate prep
> patch, please?
Sure, that should be fine.

> 
> Also, who frees the xfs_parent_defer objects?
> 
its the xfs_parent_cancel() calls below

> --D
> 
> > +
> >  	return error;
> >  
> >  out_trans_cancel:
> >  	xfs_trans_cancel(tp);
> > +drop_incompat:
> > +	if (new_parent_ptr)
> > +		xfs_parent_cancel(mp, new_parent_ptr);
> > +	if (old_parent_ptr)
> > +		xfs_parent_cancel(mp, old_parent_ptr);
> > +	if (target_parent_ptr)
> > +		xfs_parent_cancel(mp, target_parent_ptr);
> >  out_release_wip:
> >  	if (wip)
> >  		xfs_irele(wip);
> > -- 
> > 2.25.1
> > 

