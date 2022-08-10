Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4032C25B0D
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 03:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiHJDJe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiHJDJY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 23:09:24 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC417E330
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 20:09:23 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0EKQ2027263;
        Wed, 10 Aug 2022 03:09:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=txezUX1VVDqN0JLxk8+U3AbEPQS6cjcdLcrM0cYvp8U=;
 b=o/tHxkxzqCtozjXAmNt6hJJnfwCAJnbh0Fsv6fvaNX9+NQsNMeRKRJ8QR70+YnBLSAoc
 rc86VXutsxzG8a4IXp1490SyHBnUHx4JMJ4Zy/3m9abN++w4kwHKc2Stsod3127D4iN3
 mILrL6QpkzLfQa99MjJazfXC57fiJqj3Kc48ryzOvhW8Incx30KCxl7jmk1J52pzetqd
 48xYn82nV0H2jwPLe2PJ/RUgEq9Sa4VMtR1aUm41UlojWJFdfvT0aLKj5MGQIdTiHmp4
 XEnU0anVVnlPgCzo9fYk+iuZWdQ6yhL5r6WuDzeVPfSnjzdC9jel8f/NLIzskQS++1NG NQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwq90pxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:09:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27A05xOU019808;
        Wed, 10 Aug 2022 03:09:19 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqhrf63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:09:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFAlaoMmAtn+pIK7+Y5rCpgNH1Qj1IqddIHZrFviA3a9uKQB6JWP3OkEVBAZV1IkhAFkZnIshN2B2YE1d0qIDQSLEHc3E2fS+V8qoawipJ0MT3cuqF6OY05zf4n6+nLljpT/rG4POcWgf+TgjsZPHEjjFl10czNXNZxwaD38Vi8jyGUkMgDGgRlcAAsRPO22QI+2ZuxfMMB8fDFcCWaOn5oDQuehxSHWl4pQOv5in1Jlwcmi5ihE6wSCxM1oewOtmjFz93m3eMW4LsNgjG+K45rESBT1kmLul9QYfg8dTSVxmC1Aj1YyxipUSPam9Or52ez88wrdykTz2FIWD5mkfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txezUX1VVDqN0JLxk8+U3AbEPQS6cjcdLcrM0cYvp8U=;
 b=bu3Bye2XhwbuxfR050+teqsF7X6womFx7TfHssTBQVOConJhbSAuEMIP64g5j3hfxA6YyxOX3Z3MxKhvxOu86QNO8JWXcTKYUiO767UWf6Cn8iz1pNFD9g62ChgAXnbm0TB2hga1rYRV0gJnrPskAkttnbzofGJCptnDlOm56vDAOlesh9bTH3yHC5a6bcdwMqBvFKTVt3sPaFwMqDJ/zsO7fZ7CaF+GBMjGxtNzZVZAEJjO39mi0Bmof16tTKvrYUL0KLunxXy1G93vwaBXkwVyhBe4+hlW7uAven4Q7CT0AwdecUySKb5BBZLCOdJj2OJdt/vBUTMxyvgfuWYIPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txezUX1VVDqN0JLxk8+U3AbEPQS6cjcdLcrM0cYvp8U=;
 b=Ch7H60OV/5/bMFjRGdYD8LEwoQt8obNsabdyNuWmULLKWVKHuCJ+KOPblOiV00Ia07OtHKxnGcBB8O9lxhRVny/uWs04ow6y4TKWHgc/YxoR+SB4RCdgi8Vi+t0ZhqnmVA3r32uD4LRKjZD523cZJSBDhjGQExT7ylMqY/qUlDo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4545.namprd10.prod.outlook.com (2603:10b6:303:9a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 10 Aug
 2022 03:09:17 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:09:17 +0000
Message-ID: <6c9b64f2e3b3f3d99c0964321d83a109da9b2583.camel@oracle.com>
Subject: Re: [PATCH RESEND v2 13/18] xfs: add parent attributes to link
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 09 Aug 2022 20:09:15 -0700
In-Reply-To: <YvKqzD3vmXSZqdr8@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
         <20220804194013.99237-14-allison.henderson@oracle.com>
         <YvKqzD3vmXSZqdr8@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:a03:40::37) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d58b117-c535-4492-0ea1-08da7a7db5e8
X-MS-TrafficTypeDiagnostic: CO1PR10MB4545:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vKSFp8v/fFN/zVGuYkYuzwi6AXyXOBr++eC1ujUV+KXXwcS/kindj8Wq51yAkPydxTcN6d20PUGok5CYT3rUblhv1qbI/cYCi2a82qLrFIZIC4y4bN0ip6Y6vXfDw+20kMZ804yO+x53bEsjkhiwVgluS52hJTNDhpsL/64i3FBHIsfDbREocOs8VSt8XzNeFIPQyHusPN9WIA2p7utKhHHJPXcVk7NIJg3j38JgoZEYeTwmR1TiZPx6gJKYZagnEjPWoycazPevgw7Jz+Scn8SeAIvmhbTz73l20N5lkW2cgRBtuTrZ2LOzd6UDuHfyu83YUBCZcGYPj9u62JE3Gj9zU0iQndydZde018yB73kDCkr/CQv6uQgV5SmpawJ88thVcnbEGvciB/2vMeMm0fLopLv49umsgWOO8+MJTnHBEli+IbyKFrV+dwRyTI/06lk81vUEn/y5RiWlOhA7qaVz5sEeWN2yxxv93MlqZfAOVtGH/pJmsqysp2ojCzJ+Buw/7Hy9uFpONriMIJdcyQm4jZRflyP61VHS+X+p/PO62db+DXyWLJ+0dxoFbrtrzG62renFbR7PhNV0hcqlPGTsoor+9u/4YoZuxXR+/jzNb7E2riUWllmcfK8Xv7p9Sy17JwApT2SPa4dc8CikyqREBnBBYkpx9+dJoGZapZC/YUweGtnR/yF/E2JwT2hg+a/+WMbKuH6vjyI0RHxK5yZhhYguHyaz0oglmWZGDhNIpRX6wwbIrADTYoYv/zgUyAgK7RXfwP9bf36CKvGSV6lKFJ2C0EANC3JMYbwulPM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(39860400002)(396003)(366004)(38350700002)(38100700002)(26005)(66946007)(8676002)(4326008)(6512007)(66476007)(66556008)(36756003)(6916009)(316002)(478600001)(2616005)(86362001)(6486002)(5660300002)(2906002)(8936002)(186003)(41300700001)(6506007)(83380400001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDVhRHpYd29PcHI1SXBnYThrZ3k2cTFlbzlYam13Vi9zSUlpZ3F6S1RERVJH?=
 =?utf-8?B?QkF5VEhoSVpIN2FaN0g2UHJiYlUzZzNITm95cWJNdXlSRE9TYjZWWXp5N0xH?=
 =?utf-8?B?VUZaUzROOEs0YzVUc0M0ZjRvSzVzTjFpcDFEQXczSTNzNGRWb0wvUTcwMDdH?=
 =?utf-8?B?cEtZdGxCSTUwbWUrRloxTytaZWNLMXJNcDU1WU9hN1luL0xtY2FEL2ZUSWdR?=
 =?utf-8?B?RGNXWnFFSnYxc2FLaEUxU1FHMXdHdGhJZlIxWTdYM3JhMi9tWXVqdnpmYkxz?=
 =?utf-8?B?bnpjL29LcFVHWEVvbUdRWldlZWVRRk9jUUlqUEQ1TEdYdTFCSXhZa0h4cWxI?=
 =?utf-8?B?eGlZdzk5UUlsL29UVjMyajZrOEQ5STVueFN0bDhjeE1EcjhTZTl2cnhLNzMv?=
 =?utf-8?B?UEpJVWtRdlg0ZFFQNkFDWkI2UktObmROdGdaby8xVTIrSmgxeHdiVHdUVlZR?=
 =?utf-8?B?VFQyNEJjOEFsSFZmcWZCVVlHRVlCT2lCeUluQXd0dld5aXl5NlpLbWhMemYv?=
 =?utf-8?B?YTdwNnNMVmtLWnVQQld2K1AzVlJkOGUrQXYybHJSVkkzYmtxcXhqSlZLdnJW?=
 =?utf-8?B?SVpkV0U5dlBQU1lQM2pFN3c4UG4vQ3V4LzJEWUZYdk9jblo1Mzh5Y2dMUTFj?=
 =?utf-8?B?NUMza1ZTN2oxMlVCSmZodHRtSUNJS1VOMjN5amtFdGFVQ2RHZnRlb1RqWWNh?=
 =?utf-8?B?UkpMdlF2aTlLUUI5alNoUWpVcW11NVo5ck5HdFA0QzIrSXR1ZzlSTnNUYmdD?=
 =?utf-8?B?dHhwSGk2L0NnSXoxbVpTWjhLUWhwR1lnWFFLV3JXbWkrYlF0MGY2YXF6Y083?=
 =?utf-8?B?T0Roa0NLbEhHTEl6MVRMTFBjNWxyaUozMDVocGtocHZRM0o5ZURENVBWSDYv?=
 =?utf-8?B?cEkyb0hBd0p5TG9PSE1VN3FEejJvNm55QWxkUTN6RFExaW43blI3NnJsVFA1?=
 =?utf-8?B?VmYybnR5T25lSGI5emJuY0llUVQ3dWVWWk9CVFl6MlU5bGxyMVBpb0RUVDc3?=
 =?utf-8?B?MVk3ZFBPb29ndGhSK2JIazVab0lTSWNwclNENDRteElzVExZZklpa3lXdTUr?=
 =?utf-8?B?T1I5T1Jqb0E3bVFyRjlXY0MyUC9vZTMrd3Z0TzYyRXhQdGtDME9sVnZnR3Ri?=
 =?utf-8?B?V08wU2NRczhoR2RXZi9ueDV0dFJRSCtWR0l3cFNiTmhuNUlUVi9INFlRaVhU?=
 =?utf-8?B?amFwNGFlOG4vS2twbUlmSVBLUFVCTS9QWGNDTzRPeVlmanJMQnB5ZUhvMkUy?=
 =?utf-8?B?VUZOUklFTm9qcEFyZXVGMGZ2UUE4clVIWHlWb3VJZm5HWkRMV3dwanlUZU4r?=
 =?utf-8?B?WTJ1MHMzNTZGY296Z2MzYVNMNTZuRGhDUnExcXBiWUtadjQxV0ZpQVlsNk9N?=
 =?utf-8?B?eHh1WUNaVjFJYUp6dVcxVjJ1YkZ4MlNCSkhSTUc1b3I2MEV0R0l6ZktEays3?=
 =?utf-8?B?Zk9tMWxVTytNa1oraFlIWk16OWd6NWhKcG5kSEUwVU4wQzBlQ1RZR1plWHR0?=
 =?utf-8?B?WEFiVkljRldCaDFHSVpCd29Cbk5Bdk9IMFZKYkdEOUtOTEV1c3VqdDlHQk56?=
 =?utf-8?B?UlRuMmsxVEFYcThjM2NjdklRUHhBQThzamZnT0NWUlZxUklMZ1BZMmxRU1dE?=
 =?utf-8?B?Ri9ZWCtVYU80RGN2WmkxN0tTMmlWckltUmYyeEtpQXhKZko4QnNWQ1hMSUZM?=
 =?utf-8?B?aXFwUnFPMERlaEp4cDJYV0tZVGFENjJoRkVjTzVKeHptaXJqeE9jNUdkR0hG?=
 =?utf-8?B?bUYvSUZpYmR3TWJVRmxjSEN2TkswcFZhcnpaeUpLZ0V0VEkzZElacFFib1pn?=
 =?utf-8?B?Ynh3US9uM0RINzZUM0dYYTFTYUgrb2g4SVJpZGFYam5ieWswYXhmczZTbW5o?=
 =?utf-8?B?ZzZVRWNiL3BjcDljSXFoV2xaemxxQWt5R2pkQ2dMc29nU0YweVA1QnExS3dK?=
 =?utf-8?B?aVdINGpTbWJBSXJoYm5neEplV0x6cC9OTm82Vkl6NGFYY2hGdnRLb0hQZHMy?=
 =?utf-8?B?bmZEd2hGSjdXUHBYVnZ6S0dzM09ZR3Q4NzZycXlHTVllNGNIOWZCNDVhUTAr?=
 =?utf-8?B?Q0I2QWZIRXdSWGo0dVVWZDZrVTFDNnVRNmNzbDhlNlBiWUNEbzNtTGxqSCtv?=
 =?utf-8?B?R0F4TUpzUUZVM3cydFFlT2F0UVRkbWJTVy9Nb3pQL1ZzU2xUazFkMUtUaGpP?=
 =?utf-8?B?NGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: esrXXcNcXDsBy1UchaGn1ZHM/BKJ36AbLubF13NxqXeBDsHR1ltlBcx1hmYJ9762gp2fSbkQ6a5XwwTcW3XhrNx6zpa3U/gih9WSq28TFST2FO+Sf4aifknXeaPp3aozpqRyWh4GlGHZ5+mwOgIkjMh1FAeIkO4Iq8kxj9jrwOGz7FGIO+DQDAIfwanqmwGCHvFgSYVa46nZ35frKD98T0lDGg+7uNu2Aeg3glxbeiTNaZf63svTnfCM+3jK8TMSsnTrCryZ+xcL2Lq5SAHsTgdFmA7oydYqK+7mB2ST0rl0rXRZ+47khKe2xFY4uuByIYaershBjuyUIZan4FzAhY27YP4d42gl7gVHL4+9NRV8Am4kn3oAF4Yp/88hvFPJzQqPIL1lG+0Vnw0PGrmOWpxcPmrVsrSEudNiSWZtXY3qnpnZcrN5by1skaHw+As4o18jWzEaz1U0d2sJtsu3yZodGkw67vk08F+XE1CuH2ayVnsZX6L+/+uCu2jZrPVAIkebveO0if6NMctNtYuMLP5ILwPUXgOm8Ris0AdgGKgSMI85fywGG2XKXFRoUL4Xq97oA6UEW7dqiNMrDySBnJjedmPmSclqdNqGGWz+QnId9lLM2xzVGrr43YYUbEVdUbZMkNJRypn33+BYFs4zwFYV3m77HtyZ4/3svdvRbY4Jy86jHcNafssnmL05TFCfSxkprVBniszbzNMpbx/VBDJKfoRsMNYPz5dZ3d6Y+31OOIuiN5XRX/F8+q5d+tH5yvSoc+PnE74FV34yPFqfGA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d58b117-c535-4492-0ea1-08da7a7db5e8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:09:16.8669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0lagCsC+YFsC05NeRroXqTYpdWrRfihKXtOL76I5pdmPxGF0WshlEgmbW4ZYpZlglI7hXmRNcKtb8I/vtBpRNHysfiET3DWV8LfnexPbIJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4545
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100008
X-Proofpoint-GUID: -UBf0gmWbagjuG-faO1sMyNMFC1bjpaV
X-Proofpoint-ORIG-GUID: -UBf0gmWbagjuG-faO1sMyNMFC1bjpaV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-08-09 at 11:43 -0700, Darrick J. Wong wrote:
> On Thu, Aug 04, 2022 at 12:40:08PM -0700, Allison Henderson wrote:
> > This patch modifies xfs_link to add a parent pointer to the inode.
> > 
> > [bfoster: rebase, use VFS inode fields, fix xfs_bmap_finish()
> > usage]
> > [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
> >            fixed null pointer bugs]
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/xfs_inode.c | 43 ++++++++++++++++++++++++++++++++++------
> > ---
> >  1 file changed, 34 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index ef993c3a8963..6e5deb0d42c4 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1228,14 +1228,16 @@ xfs_create_tmpfile(
> >  
> >  int
> >  xfs_link(
> > -	xfs_inode_t		*tdp,
> > -	xfs_inode_t		*sip,
> > +	struct xfs_inode	*tdp,
> > +	struct xfs_inode	*sip,
> >  	struct xfs_name		*target_name)
> >  {
> > -	xfs_mount_t		*mp = tdp->i_mount;
> > -	xfs_trans_t		*tp;
> > +	struct xfs_mount	*mp = tdp->i_mount;
> > +	struct xfs_trans	*tp;
> >  	int			error, nospace_error = 0;
> >  	int			resblks;
> > +	xfs_dir2_dataptr_t	diroffset;
> > +	struct xfs_parent_defer	*parent = NULL;
> >  
> >  	trace_xfs_link(tdp, target_name);
> >  
> > @@ -1252,11 +1254,17 @@ xfs_link(
> >  	if (error)
> >  		goto std_return;
> >  
> > +	if (xfs_has_parent(mp)) {
> > +		error = xfs_parent_init(mp, sip, target_name, &parent);
> 
> Why does xfs_parent_init check xfs_has_parent if the callers already
> do
> that?
It was part of the solution outlined in the last review.  It is
redundant, but not an inappropriate sanity check for that function
either. I can remove it from the helper if it bothers folks. 


> 
> > +		if (error)
> > +			goto std_return;
> > +	}
> > +
> >  	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
> 
> Same comment about increasing XFS_LINK_SPACE_RES to accomodate xattr
> expansion as I had for the last patch.
So we do use XFS_LINK_SPACE_RES here, but didnt we update the tr_link
below in patch 11 to accommodate for the extra space?  Maybe I'm not
understanding why we would need both?

> 
> >  	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip,
> > &resblks,
> >  			&tp, &nospace_error);
> >  	if (error)
> > -		goto std_return;
> > +		goto drop_incompat;
> >  
> >  	/*
> >  	 * If we are using project inheritance, we only allow hard link
> > @@ -1289,14 +1297,26 @@ xfs_link(
> >  	}
> >  
> >  	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
> > -				   resblks, NULL);
> > +				   resblks, &diroffset);
> >  	if (error)
> > -		goto error_return;
> > +		goto out_defer_cancel;
> >  	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD |
> > XFS_ICHGTIME_CHG);
> >  	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
> >  
> >  	xfs_bumplink(tp, sip);
> >  
> > +	/*
> > +	 * If we have parent pointers, we now need to add the parent
> > record to
> > +	 * the attribute fork of the inode. If this is the initial
> > parent
> > +	 * attribute, we need to create it correctly, otherwise we can
> > just add
> > +	 * the parent to the inode.
> > +	 */
> > +	if (parent) {
> > +		error = xfs_parent_defer_add(tp, tdp, parent,
> > diroffset);
> 
> A followup to the comments I made to the previous patch about
> parent->args.dp --
> 
> Since you're partially initializing the xfs_defer_parent structure
> before you even have the dir offset, why not delay initializing the
> parent and child pointers until the xfs_parent_defer_add step?
> 
> int
> xfs_parent_init(
> 	struct xfs_mount		*mp,
> 	struct xfs_parent_defer		**parentp)
> {
> 	struct xfs_parent_defer		*parent;
> 	int				error;
> 
> 	if (!xfs_has_parent(mp))
> 		return 0;
> 
> 	error = xfs_attr_grab_log_assist(mp);
> 	if (error)
> 		return error;
> 
> 	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
> 	if (!parent)
> 		return -ENOMEM;
> 
> 	/* init parent da_args */
> 	parent->args.geo = mp->m_attr_geo;
> 	parent->args.whichfork = XFS_ATTR_FORK;
> 	parent->args.attr_filter = XFS_ATTR_PARENT;
> 	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
> 	parent->args.name = (const uint8_t *)&parent->rec;
> 	parent->args.namelen = sizeof(struct xfs_parent_name_rec);
> 
> 	*parentp = parent;
> 	return 0;
> }
> 
> int
> xfs_parent_defer_add(
> 	struct xfs_trans	*tp,
> 	struct xfs_parent_defer	*parent,
> 	struct xfs_inode	*dp,
> 	struct xfs_name		*parent_name,
> 	xfs_dir2_dataptr_t	parent_offset,
> 	struct xfs_inode	*child)
> {
> 	struct xfs_da_args	*args = &parent->args;
> 
> 	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
> 	args->hashval = xfs_da_hashname(args->name, args->namelen);
> 
> 	args->trans = tp;
> 	args->dp = child;
> 	if (parent_name) {
> 		args->name = parent_name->name;
> 		args->valuelen = parent_name->len;
> 	}
> 	return xfs_attr_defer_add(args);
> }
> 
> And then the callsites become:
> 
> 	/*
> 	 * If we have parent pointers, we now need to add the parent
> record to
> 	 * the attribute fork of the inode. If this is the initial
> parent
> 	 * attribute, we need to create it correctly, otherwise we can
> just add
> 	 * the parent to the inode.
> 	 */
> 	if (parent) {
> 		error = xfs_parent_defer_add(tp, parent, tdp,
> 				target_name, diroffset, sip);
> 		if (error)
> 			goto out_defer_cancel;
> 	}
Sure, I can scoot that part down to the defer_add helper. Thanks for
the reviews!

Allison
> 
> Aside from the API suggestions, the rest looks good to me.
> 
> --D
> 
> > +		if (error)
> > +			goto out_defer_cancel;
> > +	}
> > +
> >  	/*
> >  	 * If this is a synchronous mount, make sure that the
> >  	 * link transaction goes to disk before returning to
> > @@ -1310,11 +1330,16 @@ xfs_link(
> >  	xfs_iunlock(sip, XFS_ILOCK_EXCL);
> >  	return error;
> >  
> > - error_return:
> > +out_defer_cancel:
> > +	xfs_defer_cancel(tp);
> > +error_return:
> >  	xfs_trans_cancel(tp);
> >  	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
> >  	xfs_iunlock(sip, XFS_ILOCK_EXCL);
> > - std_return:
> > +drop_incompat:
> > +	if (parent)
> > +		xfs_parent_cancel(mp, parent);
> > +std_return:
> >  	if (error == -ENOSPC && nospace_error)
> >  		error = nospace_error;
> >  	return error;
> > -- 
> > 2.25.1
> > 

