Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70CFEC19F2D
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 03:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiHJDKD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiHJDKC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 23:10:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A2981B15
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 20:10:00 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0DrZo020613;
        Wed, 10 Aug 2022 03:09:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=S50zVa7k2Yn3J9r2ytm5KN0DdnQp853YTBi3hayakDk=;
 b=GAHy/v6WIuGoEQTKygpHyKe0pZ9r33Ke0/tmpwKq9TrZwYDlgyBI4VCi9WxZh3pO1lNn
 olLYgNrphhTxnSA7BO0RiHsFUs9GDIAuaDFZyuaTSNjSBFMGEALkXnz4GDfogM5Bnaf6
 cqt8iSytYD7DaiMY8Qm8xVyTaVfYsteiP73IxN/HdZ/FUuQ2IwdrhEQkRFLsL23LZ67B
 jvjuA7uL86MeG0onkdYUXmdZyFuMm4CIMMl/u581Xqn6BXWKz4N2MwmyyfmiAsWeVUti
 7cZL+zhIJkluou3rSi4isCCy4XO+nedd7WWRfXdZyF1pvCuZXceiDEqoxCf8frAN6fsD Xw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwq9gp4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:09:55 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0AstT024110;
        Wed, 10 Aug 2022 03:09:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqfrg23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:09:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRtkGtlMqajbjWohBF6qf/9jFoj/j076Rrp0m0ycVrWsv+SCzDkIwdvtPtlWjRXFD7eHirfdBy+q9Ur8v0QEScS0dRd/aJf/IOsbKnAGgfISAJ2QJFNCjuecRgoZPCp5+syxotELtCO7FKPa6Stib52jw1fXaBQ3UfCdnMt6u8y4eJeB8lYYSoa7RNtENgOu3hPFv+RksQ0a8bqiyveSqt+MIr358uNO2/3qd3TTDX8kj3WuCchnqaMPJEHmpjF2G8RDlwj1r8OvhZnkgFMgygGz/qFXdu5EzeK711RPG1zcLi6IvsxA9ScgmgerdEleE6Mqn4jpmjTg5bwHIky8Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S50zVa7k2Yn3J9r2ytm5KN0DdnQp853YTBi3hayakDk=;
 b=O+M5FX3FG7njJvU+OSSpw4Rfk/VIiYLhMKl5ifsGHtrJsJjxFFZE+29sNmI7ylawPcFcnyInY34kJ7xPLIt7CHLoImIVND4lmgclMX/sPMWWq0NJ+OSr1/zylGbCyi0XzlNrzSquzIPWRQXCK+1BYoaqc9RuLZX0hfASe5hcbT6Q9RbGUq+mwUpbb6dwTOuDmV4i+2gMBkIVEuWmz4V4GUKZP7klleXpT8uZAxIXTQcKtu1Lil/gdotpvoNSbRRk4ml0HwvOxRS7XGeMrF5uUkLCYwDMl+ShruZLonS57s8VChh2AvcSp3m1ri1pN95fmKIvI9Ls6Eu1Ah/KhtBjgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S50zVa7k2Yn3J9r2ytm5KN0DdnQp853YTBi3hayakDk=;
 b=gylSjnqEAWqgp19+O0a16rMyc7pkGK2bDqYfn8buJ9Aw7nrE0qf30Kj1auMvS2W++7mAoj6m7ZB/jEqDTi+qi4bXXtpey5F9eJS8ADGpcYdxz+JOoazhqZT/CIVpzwvZOiK/AtwGTwEIZtRiW8YPFfvNgnF2g1KqFsq7xLST428=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4545.namprd10.prod.outlook.com (2603:10b6:303:9a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 10 Aug
 2022 03:09:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:09:52 +0000
Message-ID: <a4dc88d719e7c7240de3bf6695eeaa2d4ed59db2.camel@oracle.com>
Subject: Re: [PATCH RESEND v2 18/18] xfs: Add parent pointer ioctl
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 09 Aug 2022 20:09:51 -0700
In-Reply-To: <YvK06Xy2T7TgQcm0@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
         <20220804194013.99237-19-allison.henderson@oracle.com>
         <YvK06Xy2T7TgQcm0@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0027.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dabefaba-b896-41ef-3c98-08da7a7dcb21
X-MS-TrafficTypeDiagnostic: CO1PR10MB4545:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0zYL8ISddGpVK8Tx6B+cevSBDXtrfuyl12x6MQCXhXhh0nzke557IMvu1FsGtDyyPJoMlO6f11vWL9PxqCX2ihZ5l8Li1HqAxA/3Tq8pSuNqsLsK3EQouCJMpaAtcxo76QVd0IvS3L22ty8AVr/1OPszJXnorDRJm24ltOkxj5UEtXV30lhkRFtbSSpatFLTATLTDhnu9KKiS7dEFG9zRibF5q6lIbN1Mzt6DOacrRGTnt46NxS+FwfhMA0aO+8nSrrIyeO/yH4mEc1mPMRo7wu17WCb2NcXRLJP6csdTqvLWQLGmLiIsrojbxMVLrZdgc3sH4SBYxGLfDoaWynzLNuVhF3VCW1tYv0FYxnmOEtY10KAceWz46R3GbnAIPAU+mXfCWEegCRCg6gyRZEppKnpyfdci565TED0vsCipf7K8r4ccN1lZ/n0Lr5JPzycfvAKhVClN45guoiIaYcA9WuPLPePYxEKkKKFp/0AQ3rwn4fSCjSjESyCP71AfHz44IMUOZvPh0CrJ88mOK+d/W8yQQf1kBeGqDgOQwoFm06T10KN0ZnrV5OBoSevybg2rum2UeNcV4/239RvwObvU9aHdToP2XejJQlNY2fCZnr6ng6Yhn+1T3+uK0DmRZ7JQZOC5GjArOKO+ubnL/tidN7bNE5piz1m1B0cgcMMXrT8E7yGghb+RNxBJLAd8oTCo0gX9SMjzsW3shH0bK6yXe0Qv8WBB7RUS+1ZFL6aKIuncIhe52P0eBmw26FZ+rmPWf0Ugyjl98cgs5kS/Afl8FUfB2gf2k5LPnTsJBo/YC9hL3O1EiaXv70o+aZfWAtibnyw0Oj7Owih/QqULS+kJOWU1ARg12Xn3C2Z+BR3y40=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(39860400002)(396003)(366004)(38350700002)(38100700002)(26005)(66946007)(8676002)(4326008)(6512007)(66476007)(66556008)(36756003)(6916009)(316002)(478600001)(2616005)(86362001)(6486002)(5660300002)(2906002)(8936002)(30864003)(186003)(41300700001)(6506007)(83380400001)(966005)(52116002)(2004002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFcwVkhIU3dRN3BBeTByMGx4QmExbEJuUUJldkFmR1VNSFgyWnY1UHRIZm9y?=
 =?utf-8?B?ZGJpQk5mSEFMNnpmZGVjQjgyejQvS2hPZHNBb1V4SmVVNzdCL0pxNGF3MzBW?=
 =?utf-8?B?T2tHUVo3MEJKeGZtcmtlelcweHpOQzBEYWRUemMxNUYxU0I5cUxRcVplRW96?=
 =?utf-8?B?UWtJYlptbTArYXdUc0JUWmFXVXpubDZSS1E1WUEwTW0rZXZLYU4zVkF2RmRK?=
 =?utf-8?B?bURtWmVGazVnb2h0bWprSUdKZXEweGJpN2Z2V3hYcUFhbHMreFlyYzREMkND?=
 =?utf-8?B?UGFyK0RHQktmZkhlNW5ETUUxWk9vVTV2K2Q1S3JkM0VQZjA5R2ZpVklLYlRx?=
 =?utf-8?B?R1RMd0pyY29ucmNOaXNKODZOUjVJWU1rMWdER3RXWWNDdE1Lb0ttTmM5c1RP?=
 =?utf-8?B?Mk04d0F6Z1hqV21qRG9UTjhlWndEWDFOMXFXWVdoN00vMnhaZnZIYndCOW9v?=
 =?utf-8?B?NEcyRTBiNjI1YldvRFZnYnNzNE4yOG1nWXdQT2wvbUJlYy9BWkZtcUJ4Y3l6?=
 =?utf-8?B?K2pJelcwR1loNHlmeXM4aVV4TTNRL3E5a2lVbjk0UENUV0lpNWE3WjQwV1By?=
 =?utf-8?B?Y3R4L3A2UW0waHBQOHJZWmR4SnowYnJPY3NjK3NGOHphQlpIWjVwcC9abGZa?=
 =?utf-8?B?T1QwUHY3dlUxY041RFMvYTh6N2ZiWE5EazdxT3FpN2NBdUlyNXNPVllIRXZn?=
 =?utf-8?B?cW5iaW5SQTlwOXJ6NkE4M1h0UmQwZlQ1Wm9JY2hneFhhanM0b3dVRW9TYWox?=
 =?utf-8?B?d3A3cGZQSnRjVEsyZUFKdzZzZnphcFJMeEZYaDYrclBjY0NKUlF0T0VjREZP?=
 =?utf-8?B?RzVKMlR6U0hYRi9tTWg2akl3Y0dndkZkTjZDT0VGWFg1YlN4NWZEUG4vMjRW?=
 =?utf-8?B?c1d2RVpmQTZSTkE0dWtnMmpGVklSY3ZSTk5hMWY4VS8ybVlUOEdlZVFmZm9o?=
 =?utf-8?B?b1JydXVBbGhTUFJ2cWRYa20yQkdMc2JSUE5DMCtUdlBFVDkrdSswQ3VORXBL?=
 =?utf-8?B?MTNLODVoT29Qd042NE1lTXdOWGxZbmdSbmNvVmE4MjlkT1RpWHRJdlR1K0pH?=
 =?utf-8?B?ZXR2VlRRMXQ4Q2JJaXkxUmhkM0E1KzNwRnFITFlDcnpPOExwMnJHS3duYTNn?=
 =?utf-8?B?U3VRTkdBQTJ3MHpsc0I0SGNOekR0eUFyMTVNRHB4bU1iOVpPbDE2a0xvbXZB?=
 =?utf-8?B?ZHZGZitEb2hkSXM0NXJRQzd1RVlLMmJTdERLVFJrbVNVcE80U2doZVc3WHA1?=
 =?utf-8?B?a3lBVkgvTDNvRkJlV21TQjhxb0xjSGV3ZzE2SlNKM08xaCtLUnUyK0hWcDlj?=
 =?utf-8?B?MkdCakxscGRnbDZLbWhUNHFPbEFIbVZwbWFTSjhPa0hWSlcxdmJqWmo2dE5n?=
 =?utf-8?B?V1pYc3dXK3ZHUVJkYXhZcHN2QVNXZUdzVktUS2pGQzJtanNpNmJLUGQ2cjZX?=
 =?utf-8?B?RTdxVlNKeGg2NGFmN2JJZDJmTnhXNWVGaFZPbDNKL3IrcWhaY0J6MHhHSzh4?=
 =?utf-8?B?SlovZ1k1ZGR1dnN2dW1zSFRicm1jTGJOL05UU0FoVllFZ3BNaVJqdjBjTzNy?=
 =?utf-8?B?dzZCbWVSVkhtQUsvb01kOU03OEV0YmlKNjZYaGFBOGd5NUZvZ2kwZXZCZk1K?=
 =?utf-8?B?eVpiMlBUMzBaRExPRVNjR1ZublpNWi81RUg0NVliM2FoaHZBMFBoTUhTekMw?=
 =?utf-8?B?NXZQVTlpSTY5L2x4ZlZGYUtTcjI3czc3Slhpb2JsNFZuL0VnN2NnVlUxNVJw?=
 =?utf-8?B?NG0vblRKQjZhRy9DTkkrOUFqUjJXamtqRVZwbzBBYXZ4eU91WE5IcnoyMlMy?=
 =?utf-8?B?S3E5NGZ6bis1bkM2Q1E1MmdOdTRLNStRd1hFSmN1TXNyK1ZNcnhudVc4bUxy?=
 =?utf-8?B?SXpJZ2Rqb0NQVFB5eWlyeFpFeDNZR1JRYUpWbnRVYmxSSzlyMy9CbVlOYTF6?=
 =?utf-8?B?NTdvN3JubkM1UitOd2dkODVJWW40RHNHbUh3V2lGTDZkTVgwQm9mcWdnVFds?=
 =?utf-8?B?SWpOb3JGV29OcTZBeXQrQXo3SGpYY0gvYTBuQ1N0RHlQZzR6dmI1T1RaNHVE?=
 =?utf-8?B?ZTZVT3V0MG95b0pWTThQY0dVUERJK0dkL0dldWh1OWxGTWVkMzVoNEd5NFZD?=
 =?utf-8?B?N1hBYjRTSUZEaXc2WUFldmtaUi9tQ0tCNUdoYXIzendSZmZneWYxanNMRVpQ?=
 =?utf-8?B?a1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NbnpyrchUnJ+PP13SZWiMcKC35aSMiePUNjLKuXc6Mc2C+ustVfkTW9Fb8RDjmcCVzZShfLCyuX8yTKmyOwvZ0/UZuT8jcx4VuoSNQADX6PSZTCIExyLGzR6SOX8GseME0ygE5BaIvTZP+zTlXJ+v1J4g7GbxhsFA1GGtWCd6ba84QruJYH1x0fkqA2BRJl+XCG4fwlJ1CqMzhrUWu/A4jViEzWELSx7bZ9ux+kOwZSJx9Ty2dMLPvdSv85rpuw49aEKeeZnZVMJIs5SbAoaosG6zo/ZER/1N05PwqqcsgysXHEgEer95DYR1SwqRbU0C6tFc7y87GTan9F/wBolCuOLAj1vBLpbF63ShNo0Gi4GBB1EiJSyGsoR6Xbu6NlhRZu/i9Sb9HzV7WPRRaZ8y7cxa7Tiy/fNdCqtHxOyhH0Ulocih2UhC7q8mQ+SMd3+2dETJhHpzF2V6yWrt+hELfF/SVFUdzfsjmswm9b4h1jCP6ClBdcgOiP2jNxUNXyRiK/KMZQq6nzmhSJmJbDu5zWfRq4chkHF2ZlHkZsEWnTrkc1hqTHI57YJarM+UDKGq9rHqWaBBnMPj0hzoG4fu6cCEwjde/TcAlwTJEOxEHnzikRgqdJXcyrkUKi9RaPMEAcq/3ZybX7uwM6jPTXuA3HkLKH89It05bdYaez4MZyNbQcEXOJcmqjSmBzaJAgHiD1TKIqyFRAr36pch79Bo3ym7bkOVPfHHs3e1IZdjpJZ4M0T898ramf7H2IPdTZDUoiTzaK0uYdgWHvD+86ttg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dabefaba-b896-41ef-3c98-08da7a7dcb21
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:09:52.4893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C/lMY97z2NP123qe8xmGlBPXFAHoFFXumzLTyu2QPBEqQoMkIOqzjShVAC64dhcLcoWQ6zFVRjMDmdstyk4U+J0q8eOL/svQdTX0733Y9Qc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4545
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100008
X-Proofpoint-ORIG-GUID: qsQ0FT8Tk4medodP69CgDxPK7kQIfKqV
X-Proofpoint-GUID: qsQ0FT8Tk4medodP69CgDxPK7kQIfKqV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-08-09 at 12:26 -0700, Darrick J. Wong wrote:
> On Thu, Aug 04, 2022 at 12:40:13PM -0700, Allison Henderson wrote:
> > This patch adds a new file ioctl to retrieve the parent pointer of
> > a
> > given inode
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/Makefile            |   1 +
> >  fs/xfs/libxfs/xfs_fs.h     |  57 ++++++++++++++++
> >  fs/xfs/libxfs/xfs_parent.c |  10 +++
> >  fs/xfs/libxfs/xfs_parent.h |   2 +
> >  fs/xfs/xfs_ioctl.c         |  95 +++++++++++++++++++++++++-
> >  fs/xfs/xfs_ondisk.h        |   4 ++
> >  fs/xfs/xfs_parent_utils.c  | 134
> > +++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_parent_utils.h  |  22 ++++++
> >  8 files changed, 323 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > index caeea8d968ba..998658e40ab4 100644
> > --- a/fs/xfs/Makefile
> > +++ b/fs/xfs/Makefile
> > @@ -86,6 +86,7 @@ xfs-y				+= xfs_aops.o \
> >  				   xfs_mount.o \
> >  				   xfs_mru_cache.o \
> >  				   xfs_pwork.o \
> > +				   xfs_parent_utils.o \
> >  				   xfs_reflink.o \
> >  				   xfs_stats.o \
> >  				   xfs_super.o \
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index b0b4d7a3aa15..ba6ec82a0272 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -574,6 +574,7 @@ typedef struct xfs_fsop_handlereq {
> >  #define XFS_IOC_ATTR_SECURE	0x0008	/* use attrs in
> > security namespace */
> >  #define XFS_IOC_ATTR_CREATE	0x0010	/* fail if attr
> > already exists */
> >  #define XFS_IOC_ATTR_REPLACE	0x0020	/* fail if attr
> > does not exist */
> > +#define XFS_IOC_ATTR_PARENT	0x0040  /* use attrs in parent
> > namespace */
> 
> This is the userspace API header, so I wonder -- should we allow
> XFS_IOC_ATTRLIST_BY_HANDLE and XFS_IOC_ATTRMULTI_BY_HANDLE to access
> parent pointers?
Well, the ioc is how the test cases get the pptrs back out in order to
verify parent pointers are working.  So we need to keep at least that,
but then I think it makes worrying about other forms of access feel
sort of silly since we're not really hiding anything.  They would have
to pass in the parent filter flag which wasnt allowable until now, so
it's not like having pptrs appear in the list when asked for is
inappropriate.

> 
> I think it's *definitely* incorrect to let ATTR_OP_REMOVE or
> ATTR_OP_SET
> (attrmulti subcommands) to mess with parent pointers.
Ok, I can see if I can add some sanity checking there.

> 
> I don't think attrlist or ATTR_OP_GET should be touching them either,
> particularly since you're defining a new ioctl to extract *only* the
> parent pointers.
> 
> If there wasn't XFS_IOC_GETPPOINTER then perhaps it would be ok to
> allow
> reads via ATTRLIST/ATTRMULTI.  But even then, I don't think we want
> things like xfsdump to think that it has to preserve those attributes
> since xfsrestore will reconstruct the directory tree (and hence the
> pptrs) for us.
Hrmm, not sure I follow this part, the point of pptrs are to
reconstruct the tree, so wouldnt we want them preserved?

> 
> >  
> >  typedef struct xfs_attrlist_cursor {
> >  	__u32		opaque[4];
> > @@ -752,6 +753,61 @@ struct xfs_scrub_metadata {
> >  				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
> >  #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN |
> > XFS_SCRUB_FLAGS_OUT)
> >  
> > +#define XFS_PPTR_MAXNAMELEN				256
> > +
> > +/* return parents of the handle, not the open fd */
> > +#define XFS_PPTR_IFLAG_HANDLE  (1U << 0)
> > +
> > +/* target was the root directory */
> > +#define XFS_PPTR_OFLAG_ROOT    (1U << 1)
> > +
> > +/* Cursor is done iterating pptrs */
> > +#define XFS_PPTR_OFLAG_DONE    (1U << 2)
> > +
> > +/* Get an inode parent pointer through ioctl */
> > +struct xfs_parent_ptr {
> > +	__u64		xpp_ino;			/* Inode */
> > +	__u32		xpp_gen;			/* Inode
> > generation */
> > +	__u32		xpp_diroffset;			/*
> > Directory offset */
> > +	__u32		xpp_namelen;			/* File
> > name length */
> > +	__u32		xpp_pad;
> > +	__u8		xpp_name[XFS_PPTR_MAXNAMELEN];	/* File
> > name */
> 
> Since xpp_name is a fixed-length array that is long enough to ensure
> that there's a null at the end of the name, we don't need
> xpp_namelen.
> 
> I wonder if xpp_namelen and xpp_pad should simply turn into a u64
> field
> that's defined zero for future expansion?
Sure, I'll see if I can remove it and add a reserved field

> 
> > +};
> > +
> > +/* Iterate through an inodes parent pointers */
> > +struct xfs_pptr_info {
> > +	struct xfs_handle		pi_handle;
> > +	struct xfs_attrlist_cursor	pi_cursor;
> > +	__u32				pi_flags;
> > +	__u32				pi_reserved;
> > +	__u32				pi_ptrs_size;
> 
> Is this the number of elements in pi_parents[]?
Yes, it's the number parent pointers in the array

> 
> > +	__u32				pi_ptrs_used;
> > +	__u64				pi_reserved2[6];
> > +
> > +	/*
> > +	 * An array of struct xfs_parent_ptr follows the header
> > +	 * information. Use XFS_PPINFO_TO_PP() to access the
> > +	 * parent pointer array entries.
> > +	 */
> > +	struct xfs_parent_ptr		pi_parents[];
> > +};
> > +
> > +static inline size_t
> > +xfs_pptr_info_sizeof(int nr_ptrs)
> > +{
> > +	return sizeof(struct xfs_pptr_info) +
> > +	       (nr_ptrs * sizeof(struct xfs_parent_ptr));
> > +}
> > +
> > +static inline struct xfs_parent_ptr*
> > +xfs_ppinfo_to_pp(
> > +	struct xfs_pptr_info	*info,
> > +	int			idx)
> > +{
> > +
> 
> Nit: extra space.
Will fix

> 
> > +	return &info->pi_parents[idx];
> > +}
> > +
> >  /*
> >   * ioctl limits
> >   */
> > @@ -797,6 +853,7 @@ struct xfs_scrub_metadata {
> >  /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
> >  #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct
> > xfs_scrub_metadata)
> >  #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct
> > xfs_ag_geometry)
> > +#define XFS_IOC_GETPPOINTER	_IOR ('X', 62, struct
> > xfs_parent_ptr)
> 
> I wonder if this name should more strongly emphasize that it's for
> reading
> the parents of a file?
> 
> #define XFS_IOC_GETPARENTS	_IOWR(...)
Sure, that sounds fine i think

> 
> Also, the ioctl reads and writes its parameter, so this is _IOWR, not
> _IOR.
> 
> BTW, is there a sample manpage somewhere?
The userspace branch adds some new flags to xfsprogs and some usage
help to explain how to use them.  See the last patch in the branch:
https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrsv2

But it's just for printing the parent pointers out, it doesn't have a
man page for how to write your own ioctl.  I suppose we could add it
though.

> 
> >  
> >  /*
> >   * ioctl commands that replace IRIX syssgi()'s
> > diff --git a/fs/xfs/libxfs/xfs_parent.c
> > b/fs/xfs/libxfs/xfs_parent.c
> > index 03f03f731d02..d9c922a78617 100644
> > --- a/fs/xfs/libxfs/xfs_parent.c
> > +++ b/fs/xfs/libxfs/xfs_parent.c
> > @@ -26,6 +26,16 @@
> >  #include "xfs_xattr.h"
> >  #include "xfs_parent.h"
> >  
> > +/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
> > +void
> > +xfs_init_parent_ptr(struct xfs_parent_ptr	*xpp,
> > +		    struct xfs_parent_name_rec	*rec)
> 
> The second parameter ought to be const struct xfs_parent_name_rec
> *rec
> to make it unambiguous to readers which is the source and which is
> the
> destination argument.
Ok, will update

> 
> > +{
> > +	xpp->xpp_ino = be64_to_cpu(rec->p_ino);
> > +	xpp->xpp_gen = be32_to_cpu(rec->p_gen);
> > +	xpp->xpp_diroffset = be32_to_cpu(rec->p_diroffset);
> > +}
> > +
> >  /*
> >   * Parent pointer attribute handling.
> >   *
> > diff --git a/fs/xfs/libxfs/xfs_parent.h
> > b/fs/xfs/libxfs/xfs_parent.h
> > index 67948f4b3834..53161b79d1e2 100644
> > --- a/fs/xfs/libxfs/xfs_parent.h
> > +++ b/fs/xfs/libxfs/xfs_parent.h
> > @@ -23,6 +23,8 @@ void xfs_init_parent_name_rec(struct
> > xfs_parent_name_rec *rec,
> >  			      uint32_t p_diroffset);
> >  void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
> >  			       struct xfs_parent_name_rec *rec);
> > +void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
> > +			 struct xfs_parent_name_rec *rec);
> >  int xfs_parent_init(xfs_mount_t *mp, xfs_inode_t *ip,
> >  		    struct xfs_name *target_name,
> >  		    struct xfs_parent_defer **parentp);
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 5b600d3f7981..8a9530588ef4 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -37,6 +37,7 @@
> >  #include "xfs_health.h"
> >  #include "xfs_reflink.h"
> >  #include "xfs_ioctl.h"
> > +#include "xfs_parent_utils.h"
> >  #include "xfs_xattr.h"
> >  
> >  #include <linux/mount.h>
> > @@ -355,6 +356,8 @@ xfs_attr_filter(
> >  		return XFS_ATTR_ROOT;
> >  	if (ioc_flags & XFS_IOC_ATTR_SECURE)
> >  		return XFS_ATTR_SECURE;
> > +	if (ioc_flags & XFS_IOC_ATTR_PARENT)
> > +		return XFS_ATTR_PARENT;
> >  	return 0;
> >  }
> >  
> > @@ -422,7 +425,8 @@ xfs_ioc_attr_list(
> >  	/*
> >  	 * Reject flags, only allow namespaces.
> >  	 */
> > -	if (flags & ~(XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
> > +	if (flags & ~(XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE |
> > +		      XFS_IOC_ATTR_PARENT))
> >  		return -EINVAL;
> 
> I think xfs_ioc_attrmulti_one needs filtering for
> XFS_IOC_ATTR_PARENT,
> if we're still going to allow attrlist/attrmulti to return parent
> pointers.
Ok, will update that one as well then

> 
> >  	if (flags == (XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
> >  		return -EINVAL;
> > @@ -1679,6 +1683,92 @@ xfs_ioc_scrub_metadata(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * IOCTL routine to get the parent pointers of an inode and return
> > it to user
> > + * space.  Caller must pass a buffer space containing a struct
> > xfs_pptr_info,
> > + * followed by a region large enough to contain an array of struct
> > + * xfs_parent_ptr of a size specified in pi_ptrs_size.  If the
> > inode contains
> > + * more parent pointers than can fit in the buffer space, caller
> > may re-call
> > + * the function using the returned pi_cursor to resume
> > iteration.  The
> > + * number of xfs_parent_ptr returned will be stored in
> > pi_ptrs_used.
> > + *
> > + * Returns 0 on success or non-zero on failure
> > + */
> > +STATIC int
> > +xfs_ioc_get_parent_pointer(
> > +	struct file			*filp,
> > +	void				__user *arg)
> > +{
> > +	struct xfs_pptr_info		*ppi = NULL;
> > +	int				error = 0;
> > +	struct xfs_inode		*ip = XFS_I(file_inode(filp));
> > +	struct xfs_mount		*mp = ip->i_mount;
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EPERM;
> > +
> > +	/* Allocate an xfs_pptr_info to put the user data */
> > +	ppi = kmem_alloc(sizeof(struct xfs_pptr_info), 0);
> 
> New code should call kmalloc instead of the old kmem_alloc wrapper.
> 
Ok, will update

> > +	if (!ppi)
> > +		return -ENOMEM;
> > +
> > +	/* Copy the data from the user */
> > +	error = copy_from_user(ppi, arg, sizeof(struct xfs_pptr_info));
> 
> Note: copy_from_user returns the number of bytes *not* copied.  If
> you
> receive a nonzero return value, error usually gets set to EFAULT.
ooooh. ok, will fix that then.

> 
> > +	if (error)
> > +		goto out;
> > +
> > +	/* Check size of buffer requested by user */
> > +	if (xfs_pptr_info_sizeof(ppi->pi_ptrs_size) >
> > XFS_XATTR_LIST_MAX) {
> > +		error = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> > +	if (ppi->pi_flags != 0 && ppi->pi_flags !=
> > XFS_PPTR_IFLAG_HANDLE) {
> 
> 	if (ppi->pi_flags & ~XFS_PPTR_IFLAG_HANDLE) ?
> 
> (If we really want to be pedantic, this really ought to be:
> 
> #define XFS_PPTR_IFLAG_ALL	(XFS_PPTR_IFLAG_HANDLE)
> 
> 	if (ppi->pi_flags & ~XFS_PPTR_IFLAG_ALL)
> 		return -EINVAL;
> 
> Or you could be more flexible, since the kernel could just set the
> OFLAGs appropriately and not care about their value on input:
> 
> #define XFS_PPTR_FLAG_ALL	(XFS_PPTR_IFLAG_HANDLE |
> XFS_PPTR_OFLAG...)
> 
> 	if (ppi->pi_flags & ~XFS_PPTR_FLAG_ALL)
> 		return -EINVAL;
> 
> 	ppi->pi_flags &= ~(XFS_PPTR_OFLAG_ROOT | XFS_PPTR_OFLAG_DONE);

Oh, I see, sure that makes sense.
> 
> > +		error = -EINVAL;
> > +		goto out;
> > +	}
> > +
> > +	/*
> > +	 * Now that we know how big the trailing buffer is, expand
> > +	 * our kernel xfs_pptr_info to be the same size
> > +	 */
> > +	ppi = krealloc(ppi, xfs_pptr_info_sizeof(ppi->pi_ptrs_size),
> > +		       GFP_NOFS | __GFP_NOFAIL);
> > +	if (!ppi)
> > +		return -ENOMEM;
> 
> Why NOFS and NOFAIL?  We don't have any writeback resources locked
> (transactions and ILOCKs) so we can hit ourselves up for memory.
Ok, will update

> 
> > +
> > +	if (ppi->pi_flags == XFS_PPTR_IFLAG_HANDLE) {
> 
> 	if (ppi->pi_flags & XFS_PPTR_IFLAG_HANDLE) {
ok, will fix

> 
> > +		error = xfs_iget(mp, NULL, ppi-
> > >pi_handle.ha_fid.fid_ino,
> > +				0, 0, &ip);
> > +		if (error)
> > +			goto out;
> > +
> > +		if (VFS_I(ip)->i_generation != ppi-
> > >pi_handle.ha_fid.fid_gen) {
> > +			error = -EINVAL;
> > +			goto out;
> > +		}
> > +	}
> > +
> > +	if (ip->i_ino == mp->m_sb.sb_rootino)
> > +		ppi->pi_flags |= XFS_PPTR_OFLAG_ROOT;
> > +
> > +	/* Get the parent pointers */
> > +	error = xfs_attr_get_parent_pointer(ip, ppi);
> > +
> > +	if (error)
> > +		goto out;
> > +
> > +	/* Copy the parent pointers back to the user */
> > +	error = copy_to_user(arg, ppi,
> > +			xfs_pptr_info_sizeof(ppi->pi_ptrs_size));
> 
> Same note as the one I made for copy_from_user.
> 
Will update

> > +	if (error)
> > +		goto out;
> > +
> > +out:
> > +	kmem_free(ppi);
> > +	return error;
> > +}
> > +
> >  int
> >  xfs_ioc_swapext(
> >  	xfs_swapext_t	*sxp)
> > @@ -1968,7 +2058,8 @@ xfs_file_ioctl(
> >  
> >  	case XFS_IOC_FSGETXATTRA:
> >  		return xfs_ioc_fsgetxattra(ip, arg);
> > -
> > +	case XFS_IOC_GETPPOINTER:
> > +		return xfs_ioc_get_parent_pointer(filp, arg);
> >  	case XFS_IOC_GETBMAP:
> >  	case XFS_IOC_GETBMAPA:
> >  	case XFS_IOC_GETBMAPX:
> > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > index 758702b9495f..765eb514a917 100644
> > --- a/fs/xfs/xfs_ondisk.h
> > +++ b/fs/xfs/xfs_ondisk.h
> > @@ -135,6 +135,10 @@ xfs_check_ondisk_structs(void)
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
> >  
> > +	/* parent pointer ioctls */
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_ptr,            280);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_pptr_info,             104);
> > +
> >  	/*
> >  	 * The v5 superblock format extended several v4 header
> > structures with
> >  	 * additional data. While new fields are only accessible on v5
> > diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
> > new file mode 100644
> > index 000000000000..3351ce173075
> > --- /dev/null
> > +++ b/fs/xfs/xfs_parent_utils.c
> > @@ -0,0 +1,134 @@
> > +/*
> > + * Copyright (c) 2015 Red Hat, Inc.
> > + * All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it would be
> > useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public
> > License
> > + * along with this program; if not, write the Free Software
> > Foundation
> > + */
> 
> Please condense this boilerplate down to a SPDX tag and a copyright
> statement.
Sure, will do

> 
> > +#include "xfs.h"
> > +#include "xfs_fs.h"
> > +#include "xfs_format.h"
> > +#include "xfs_log_format.h"
> > +#include "xfs_shared.h"
> > +#include "xfs_trans_resv.h"
> > +#include "xfs_mount.h"
> > +#include "xfs_bmap_btree.h"
> > +#include "xfs_inode.h"
> > +#include "xfs_error.h"
> > +#include "xfs_trace.h"
> > +#include "xfs_trans.h"
> > +#include "xfs_da_format.h"
> > +#include "xfs_da_btree.h"
> > +#include "xfs_attr.h"
> > +#include "xfs_ioctl.h"
> > +#include "xfs_parent.h"
> > +#include "xfs_da_btree.h"
> > +
> > +/*
> > + * Get the parent pointers for a given inode
> > + *
> > + * Returns 0 on success and non zero on error
> > + */
> > +int
> > +xfs_attr_get_parent_pointer(struct xfs_inode		*ip,
> > +			    struct xfs_pptr_info	*ppi)
> > +
> > +{
> > +
> > +	struct xfs_attrlist		*alist;
> 
> int
> xfs_attr_get_parent_pointer(
> 	struct xfs_inode		*ip,
> 	struct xfs_pptr_info		*ppi)
> {
> 	struct xfs_attrlist		*alist;
will fix

> 
> 
> > +	struct xfs_attrlist_ent		*aent;
> > +	struct xfs_parent_ptr		*xpp;
> > +	struct xfs_parent_name_rec	*xpnr;
> > +	char				*namebuf;
> > +	unsigned int			namebuf_size;
> > +	int				name_len;
> > +	int				error = 0;
> > +	unsigned int			ioc_flags =
> > XFS_IOC_ATTR_PARENT;
> > +	unsigned int			flags = XFS_ATTR_PARENT;
> > +	int				i;
> > +	struct xfs_attr_list_context	context;
> > +
> > +	/* Allocate a buffer to store the attribute names */
> > +	namebuf_size = sizeof(struct xfs_attrlist) +
> > +		       (ppi->pi_ptrs_size) * sizeof(struct
> > xfs_attrlist_ent);
> > +	namebuf = kvzalloc(namebuf_size, GFP_KERNEL);
> > +	if (!namebuf)
> > +		return -ENOMEM;
> 
> Do we need the buffer to be zeroed if xfs_attr_list is just going to
> set
> its contents?
I think i might have initially done this out of habit, but I think it's
safe to remove.

> 
> > +
> > +	memset(&context, 0, sizeof(struct xfs_attr_list_context));
> > +	error = xfs_ioc_attr_list_context_init(ip, namebuf,
> > namebuf_size,
> > +			ioc_flags, &context);
> 
> Aha, so the internal implementation has access to
> xfs_attr_list_context
> before it calls into the attr list code.  Ok, in that case, xfs_fs.h
> doesn't need the XFS_IOC_ATTR_PARENT flag, and you can set
> context.attr_filter = XFS_ATTR_PARENT here.  Then we don't have to
> worry
> about the existing xattr bulk ioctls returning parent pointers.Oh ok.
>  I'll see if I can take it out
Oh ok, I'll take a look and see it it can come out.

> 
> > +
> > +	/* Copy the cursor provided by caller */
> > +	memcpy(&context.cursor, &ppi->pi_cursor,
> > +	       sizeof(struct xfs_attrlist_cursor));
> > +
> > +	if (error)
> > +		goto out_kfree;
> 
> Why does the error check come after copying the cursor into the
> onstack
> variable?
Hmm, there might have been a reason at one point, but I
think xfs_ioc_attr_list_context_init could actually just be a void
return now.

> 
> > +
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> 
> xfs_ilock_attr_map_shared() ?
Ok, will update

> 
> > +
> > +	error = xfs_attr_list_ilocked(&context);
> > +	if (error)
> > +		goto out_kfree;
> > +
> > +	alist = (struct xfs_attrlist *)namebuf;
> > +	for (i = 0; i < alist->al_count; i++) {
> > +		struct xfs_da_args args = {
> > +			.geo = ip->i_mount->m_attr_geo,
> > +			.whichfork = XFS_ATTR_FORK,
> > +			.dp = ip,
> > +			.namelen = sizeof(struct xfs_parent_name_rec),
> > +			.attr_filter = flags,
> > +			.op_flags = XFS_DA_OP_OKNOENT,
> > +		};
> > +
> > +		xpp = xfs_ppinfo_to_pp(ppi, i);
> > +		memset(xpp, 0, sizeof(struct xfs_parent_ptr));
> > +		aent = (struct xfs_attrlist_ent *)
> > +			&namebuf[alist->al_offset[i]];
> > +		xpnr = (struct xfs_parent_name_rec *)(aent->a_name);
> > +
> > +		if (aent->a_valuelen > XFS_PPTR_MAXNAMELEN) {
> > +			error = -ERANGE;
> > +			goto out_kfree;
> 
> If a parent pointer has a name longer than MAXNAMELEN then isn't that
> a
> corruption?  And in that case, -EFSCORRUPTED would be more
> appropriate
> here, right?
I think so, will fix

> 
> > +		}
> > +		name_len = aent->a_valuelen;
> > +
> > +		args.name = (char *)xpnr;
> > +		args.hashval = xfs_da_hashname(args.name,
> > args.namelen),
> > +		args.value = (unsigned char *)(xpp->xpp_name);
> > +		args.valuelen = name_len;
> > +
> > +		error = xfs_attr_get_ilocked(&args);
> 
> If error is ENOENT (or ENOATTR or whatever the return value is when
> the
> attr doesn't exist) then shouldn't that be treated as a corruption
> too?
> We still hold the ILOCK from earlier.  I don't think OKNOENT is
> correct
> either.
Hmm, I think I likely borrowed this from similar code else where, but
if the inode is locked in this case probably any error is grounds for
corruption.  will update

> 
> > +		error = (error == -EEXIST ? 0 : error);
> > +		if (error)
> > +			goto out_kfree;
> > +
> > +		xpp->xpp_namelen = name_len;
> > +		xfs_init_parent_ptr(xpp, xpnr);
> 
> Also, should we validate xpnr before copying it out to userspace?
> If, say, the inode number is bogus, that should generate an
> EFSCORRUPTED.
I suppose we could validate the inode while we have it here.

> 
> > +	}
> > +	ppi->pi_ptrs_used = alist->al_count;
> > +	if (!alist->al_more)
> > +		ppi->pi_flags |= XFS_PPTR_OFLAG_DONE;
> > +
> > +	/* Update the caller with the current cursor position */
> > +	memcpy(&ppi->pi_cursor, &context.cursor,
> > +		sizeof(struct xfs_attrlist_cursor));
> 
> Glad you remembered to do this; attrmulti forgot to do this for a
> long
> time. :)
:-)  I do recall running into it some time ago

> 
> > +
> > +out_kfree:
> > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +	kmem_free(namebuf);
> 
> kvfree, since you got namebuf from kvzalloc.
Alrighty

> 
> > +
> > +	return error;
> > +}
> > +
> > diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
> > new file mode 100644
> > index 000000000000..0e952b2ebd4a
> > --- /dev/null
> > +++ b/fs/xfs/xfs_parent_utils.h
> > @@ -0,0 +1,22 @@
> > +/*
> > + * Copyright (c) 2017 Oracle, Inc.
> 
> 2022?
Sure, will update date

> 
> > + * All Rights Reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it would be
> > useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public
> > License
> > + * along with this program; if not, write the Free Software
> > Foundation Inc.
> 
> This also needs to be condensed to a SPDX header and a copyright
> statement.
Right, will clean that up too

Thanks for the reviews!
Allison

> 
> > + */
> > +#ifndef	__XFS_PARENT_UTILS_H__
> > +#define	__XFS_PARENT_UTILS_H__
> > +
> > +int xfs_attr_get_parent_pointer(struct xfs_inode *ip,
> > +				struct xfs_pptr_info *ppi);
> > +#endif	/* __XFS_PARENT_UTILS_H__ */
> > -- 
> > 2.25.1
> > 

