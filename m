Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE06C432BE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 21:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4922960041
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 21:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbhIAVob (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 17:44:31 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51108 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232085AbhIAVob (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 17:44:31 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 181I46BU005715;
        Wed, 1 Sep 2021 21:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ksLe9kIe4onDvDVNmRQBrFHzOJl5Es94FputmRLdFXs=;
 b=YGlBWY2f0A9jVDDWj/5mNQRkd66KoyITMKOHDXz4FUnzFmFyXYZxz+5vvj8UKRbD88rG
 qm/AR5dxHdfbuH4eyi4hIA2kvYpls030YKXIlZP6JAjfBVro9RYqCZ+ivfOHcKKM2r+5
 8GoH7Qq3Nk35AsoO1gs7mqu2yE4yrI6Sq4yUFnzVDABAb5tngaS59t62NVdX4vrjkzQj
 Azb+quH3+SdTKWXQiwXvEg8uoj1W2h1uDCbuC9mKjaY7WoCxTiVJu4Cu+t5GvVqUPijo
 YobQcdtfVq2RfiVC4i9Tt/QiX5DXpwCvkoorFX/dr6kzUbBHW3PDg6Lh7lPd4DspsvQh Aw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ksLe9kIe4onDvDVNmRQBrFHzOJl5Es94FputmRLdFXs=;
 b=egNUQ2arHNQHmgfro+81OOwOMnp7vJKUzURyh9nHf/87TajLwT+TifR8DzPSk/Hw/+kD
 Q/R0/wOk7ydc/y0EetDDBQmIlkae5eSy4JyyE3RD760bk+XVImWor7zHUT0Y2aCR9P3Y
 tlNmPAyHVYcM1aVMTy8CLk9mY2KsXkBzKxZmu5SqvffPfZPDqNEogEHMdFkwTrO/W0nL
 HHWAGjzt1GBrqE8tZuoIZh7lIJrxOsTW1MS1lS7pydINmIdX71Qdm+RaQlZXkb3kRSOP
 /hr5xZPQ34+tcppqECjZLSvEVZOHzxRoBXJlGG81bXFpc3jTzk1KxrqVa4yO4Lu6jbz9 Lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3atdw0gmtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Sep 2021 21:43:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 181LdrO8093691;
        Wed, 1 Sep 2021 21:43:32 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3020.oracle.com with ESMTP id 3atdyxtbx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Sep 2021 21:43:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3iRP5aNheUwHHxQMrQC/1Uh1Qt3gLKprgzvL/hH5i5d5stACJluq76heHD25Y+w7e08qlTSpSlgWqGu+z3KnAVP3ktwyan92OAExaITQjNTj4r1rn3ZK02y4HXXAJuvBA4BVhH+U5hkCpBmhxBpSlfHJiByyktl0kDidFqGXsN4vjrOYSudkrjee1imHGmTG9Yw4eYzGMO+AkzOy71wZUVkhPi75FTWkU46W+FydZXOxJlgb2wrvAlr5nRVJ/dv1Pv8ObCHy5u8ggAxsdHpuZ2CCXsVVNG8Q7fYYfaov8TcCQBLdIJiDc4XevrYCeca1Y2ImSHH4ZELASm6fZojRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ksLe9kIe4onDvDVNmRQBrFHzOJl5Es94FputmRLdFXs=;
 b=J8jiGlKp3sFmy+XQAVEAiiEKgOLhOelFm+NTa4sHZjO7CPXJ0w27qM36dJmMvN6cP74iar1Gh9Ar0R+ScX/6MdLbmKyst8Lxyy/I64lFEEdH9tKTfnC04Em1EQv+zUubqCU2JwcAA66YA/cGvDujRrGqnHi+tfeT7W6KdCX2+xVVTZDiEfEtGkrECkJPp0jdrWon4bSbJD1V4mXwwnwysDQbh4n8LDqLEj5srPzpPy4BMRmXh/MxJ00B2QR59HTVYjQ2LG/Mire8U82pGSTTyjX2g08ivu6GLrlZoKbHkt1nvpJsU4UVxJXPm4r/terLlngOawBALgvVoQTMv5VvmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ksLe9kIe4onDvDVNmRQBrFHzOJl5Es94FputmRLdFXs=;
 b=cfgFbn8YzQPCwOiRoCqLOAKQvMTniDrstztX30yg+wZoV9FWF61ntObaEBljRzZlmBWga2GGhnSV3KVAK60Hcpm/0bBVntOtx+4xPS2HlQB4jZOJl2svaghGlah8uoviPu+vkoG1JQBiYq1bupUVseh35gVk2lcGFb/Wby3XgkA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3142.namprd10.prod.outlook.com (2603:10b6:a03:14e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Wed, 1 Sep
 2021 21:43:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4478.019; Wed, 1 Sep 2021
 21:43:30 +0000
Subject: Re: [PATCH 0/5] xfs: various logged attribute fixes
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210901073039.844617-1-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <32cd4828-0ad5-ef5c-63e8-442c76614afa@oracle.com>
Date:   Wed, 1 Sep 2021 14:43:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210901073039.844617-1-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0207.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by SJ0PR03CA0207.namprd03.prod.outlook.com (2603:10b6:a03:2ef::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.20 via Frontend Transport; Wed, 1 Sep 2021 21:43:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cafec3a-2c92-4f94-d5ef-08d96d9189dc
X-MS-TrafficTypeDiagnostic: BYAPR10MB3142:
X-Microsoft-Antispam-PRVS: <BYAPR10MB314206E64E0BD5E047CA0F1A95CD9@BYAPR10MB3142.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: suB3Oi/wH/a1WB8kRf7FbYQ19RFHwQD0hQX5LT2YOShUznhCm2RzuedQGM0eZdYgt2OQWVzpWyvsl36m5HWkX/kgyYVFx0nP7Z+XJWX1HwOrqeQipQUvdXzg4T/fCOL0j37cMvIZcmF6hrElEOlUsJ8OMoWSrB2YNijKVsNsjb8hheekxFeJh3E/tUe2V7eBRHSrTDGHJLeX7mvcu8Ynb2H994A8uM+qLPvahVQnVt2Wc8inEa6WbM+ihkCu8t+OrQx5ltHe69wvpvzo0W0ctaAYGpSRErfVqF7XVBaZh+TXY5ppC4I+ynuQ74xvVulJavRx3K6aWBIsRSdE9sEtoLq9ffQG/TWyCZm1e55b9fT+RY0gq+WHZTS5VhPc8ZZ3yE6SBmEImXSG3aj6L/Se6MHMxyA7AddrLPvvf8LNM1Nie1V4I5VcjM9S2QQNmTVi104Db3fPhIbDIWOcdsSjmNsJ12fEYwMgGrmkfPQ5Be5ECfTpOqBTTeun15tm3FBKwo62FtnwNsKjwmybm1Ww7r/T4b4kJTYZ9WO+msz/kRR7Oijom8kc4ca4V2Omt4YorV9hUJL/28P1HYUb28m1PhsNTDvYhMrk/4Pi2ROiIMZOFvJWzm9D3u184/iLeHWKecHo6Rig7b1q95SCPVukECjTrw6UaudWWmSEz5NbjTIInGGJ3bMj04p38briFvqhWVFvZkRFaUOx+eWi1Y/qpnvFBw0XzP9ZnDRGQBmzLKDTfhs23JvusErVAuY2oOC0G2p2CCldZR3wiiChUjAIPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(346002)(39860400002)(38350700002)(26005)(8936002)(16576012)(38100700002)(4744005)(316002)(2906002)(5660300002)(44832011)(31696002)(478600001)(2616005)(956004)(66556008)(66946007)(186003)(6486002)(66476007)(86362001)(31686004)(53546011)(52116002)(8676002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3VrT3dWKytod1NCZFpYUU5QZEU2SEJTVHp0Q3Y2VDlNUkZNMDJuemdHSk1m?=
 =?utf-8?B?alBWNlNEZ0R3K1R3T0h5U1FnZnMzMkEyK1F2T2VEVFkzWTJrbk5ZZSs2eXh4?=
 =?utf-8?B?emkyYnNKZTduTmJ0WWJ6cU16MW11OTlzUG11Z1Y4SlY1STYwbjJVTzhYaTVP?=
 =?utf-8?B?NFVwanBvU2kvVHIxbnRDK29oRjVyM1hCMit1UXhHbEZOQWxJaEdtMTR2L0pl?=
 =?utf-8?B?QzBNNEdJaHo2UmJhSjRUYVJrazRzWGZKajZGa3pNU1FyMVJXN25QcXY4ZTZQ?=
 =?utf-8?B?L29qN1VJS09QRVVyR2lyMzJVU043ckk1VXc1T3Z1ME82dVppMmNhYXFIUVpl?=
 =?utf-8?B?enRQTTNTSUorM0lTYmFob3JVdTY1REFyVDRaRmZzSWkrQVFDOS9GbWV5TzZw?=
 =?utf-8?B?QVM4R0Q4alJvbXJKdzY1WVhoT3Y1N0xDRER0ZWpyQ1lpcEEvdkttK0xrS29L?=
 =?utf-8?B?ZTVxZGx4WmhiUGZ5TlBqNzFhMHppbnpjYTVNeXVmYnFsVnFOdytLTmpkK2JN?=
 =?utf-8?B?STZ2cG9uOCtQZVIxMFJJUWxHK1NrUDFjdVkwVEhGQktROGtOMUJlUVdrdkNv?=
 =?utf-8?B?WnRhdmpWTlJOdlJ3VVhOWVFZaEttREExZEpoQVEyOFJwL2JNYlhVbVZ6ZVE3?=
 =?utf-8?B?QmJSOE9UMitaTEFnM3BaZURObEFPY2Qra3dCbU9UZzB0VGJ6MUM5WW1QRjYr?=
 =?utf-8?B?T3lod3B5b2FKOUliT0dEUzczT1BaVlA5QVF3MXVUTDlEbzJ3bG9KVTIvdE9i?=
 =?utf-8?B?OTBNR1A0T3p0NnJONGFBM3pXTlBTVFVQeXZ0WGUzWktDOFdpaE9NTy9sN2pT?=
 =?utf-8?B?Q1Q1VmxHUndZWmQ5YlRnRkhVMVY1bVpDL3JiYnpiVEdHVFFGRjE2R3JIQ25N?=
 =?utf-8?B?RzJveTBLazRocUFzd0tWTko3d1pWQkhGVFhMZ2RGbmRJUDJUVWpnYjdEdGFs?=
 =?utf-8?B?eksvTWJaRW8ra093SWxUdUtPaXlSN1dFMW1DcjRnMmtKZVJpNitIN2h3Z2tt?=
 =?utf-8?B?dzBTWE9yNFAvYThtUkhvUzlrV29GcnA1K2Q1aW1HRTUwSEhuVHlmY2RubVh0?=
 =?utf-8?B?eEFpcWpPenpHSmswTFllVTgxWDdoMkpqcEViby9QT2IrWlljOUVNL3ozM0ZH?=
 =?utf-8?B?VzNnYW81K3NYLzVidVNCTkJla28zUmZHVm1BS0dhdm8zakExWXJaSmtMM3ZF?=
 =?utf-8?B?QkFkaTNqUDQ1elVXbVlVSjVnQ2pxK2dXOW5DeTlrdnZ1WUlVUk4vcDV1L1VL?=
 =?utf-8?B?T0dTb1FGWDF0bkxpMU1uYXZPT3V2NGxIUHM5RWNqUFdITEE1Y2pUb3BaVFRD?=
 =?utf-8?B?aWZWNloxaXRqS2tJcDFHVjhkRWZLTmQxU1hIaEhzSXczQ0VHZlUva0tncjY0?=
 =?utf-8?B?Z3JDZjFvRFhLYnRLcVlvNmJjQmFIM0hwb1JtSzJ5T2YyM2xaUjQyaGMyZFdp?=
 =?utf-8?B?ei80WWRWdzBkWVJlNWpEMHFDSU9DK1Evc1BsSmxOQUxPdmN6MlAraEJDU1Ns?=
 =?utf-8?B?NEhMUEQ1M1QxWmlPTDJvV2dIb0hWVk9UaEhvVUxZS1MyaGNwWVU4NUdpV0FK?=
 =?utf-8?B?OTcyWFZSVlMyWkRpckIxaUJTT1F2Z29mSlpmam1lWG1XVnYwbys1YUZ3MVZE?=
 =?utf-8?B?OVAwWFU0dHVDa1g1REtRc0wyR1ovZXFMR0FvQk44a084VEZzYUNVaG5xYi8v?=
 =?utf-8?B?ejFSaSsrZitoaUYzZ1VpUS9WeWlHOGlFSlc5blVMMzNPRHE0NmZCV085U0Jw?=
 =?utf-8?Q?iPNbjaxpP+WLAQgELy4TXDr8koDlbrtTnHOJxie?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cafec3a-2c92-4f94-d5ef-08d96d9189dc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 21:43:30.2005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i6V61HrFVNAf2eEtTY52NkSf/lQBIIavB55Qa8Rby8JvUaKrm9lTTre+4HJfbM+Ao8SkdCsa63jMjof8NyaATqVeFnVpzLS6I5ZI+kGTg58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3142
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10094 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109010126
X-Proofpoint-GUID: B1QvXfYgWteq4KLOSkB9NWtzTY1totVA
X-Proofpoint-ORIG-GUID: B1QvXfYgWteq4KLOSkB9NWtzTY1totVA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Alrighty, thanks for all your help on this.  These changes make sense to 
me, I can add patches 3 and 5 to the set, and the rest looks like they 
can be amended into their respective patches in the series.

I will keep an eye out for the whiteout set you are working on then.
Thank you!!

Allison

On 9/1/21 12:30 AM, Dave Chinner wrote:
> Hi Allison,
> 
> Here are the first set of fixups I've made while testing this
> series. The intent whiteouts are generic so I'm keeping that
> separate, even though it's the change that fixes most of the
> performance regressions for small xattr sizes that result from
> enabling logged attributes.
> 
> Cheers,
> 
> Dave.
> 
