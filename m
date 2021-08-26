Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E4AC4320E
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 01:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA3446102A
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 01:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbhHZBGi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Aug 2021 21:06:38 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:6418 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235318AbhHZBGh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Aug 2021 21:06:37 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17PLwb6g010057;
        Thu, 26 Aug 2021 01:05:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=LeS3/BE7ObOlsMjooodoEd0fa0SUucW0fDTAngt+W3U=;
 b=lbNlmesA0IalXfltlOckSsECKDL1O9tw8Xq8iODavs7JAJGYjvzNd1tHKwnM9V7epBGe
 GJhk67etGuZt2oXtLH8YGHxG9lwRw5bIKQq9U6ca3ITVb5cjoxUF2n75JX1LkLMxZKzY
 jLSalKW/PJ/7LqgtNXGr1jRGTS7sh3GPbsFQAQm6DI0cSksAQIjs6opOyuO11dz+XKT7
 Wcj3JdBXf2BcMnvKp3hY1orOuI/7qcfjjy9uqilSXfaXyY9S2kDkwdxB+b8GS+TYH2cT
 Q/d+eA78lYKq4MGEB74qxitvCoAFLjklMTNcLmcG2F5peLX/d5sF+I83pylGwFEmv3eW 7A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LeS3/BE7ObOlsMjooodoEd0fa0SUucW0fDTAngt+W3U=;
 b=TP1utTyqwqEr4z/cYPHdFuXT/prLSLyFn4oe6sTklBV8Accu46SiqkA1LxJX5A0yerNk
 9KFCK3BgFxtnI19s79E5XaG0K/dPs2SN5y7Ds+TAvC+AIQc0dXeA7/hJJj39BZ7DxqHx
 1Sax6baSWc+s3NNE/TafyUdgI58gn5sS38PTpRoijsOXmIGXsW6NmeSe8P2QQROf0U60
 Kq/WluqeN9U+M52rp+ejb/g5/WVylESsAS5bNEzoPy5D208OrXvrkxnIBGDV1oW8bWOo
 KJrtmkcVqx78DRLRvUDBnztL4AN4mxaRmEU90pkQS5oryY6fJW8IqNdzFIkKW7FTqCyt uQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amv67d7ft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Aug 2021 01:05:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17Q11bDH111910;
        Thu, 26 Aug 2021 01:05:48 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by userp3030.oracle.com with ESMTP id 3ajpm1juyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Aug 2021 01:05:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZV1fuO6FDPVo503lgg96byv04xKhtSD47bFgoBJAvsTteVFwA9oVdOCF3l4UPe/8lOwNKKmq2bu8rjaM6y/W5NY5P2pIeFW4WNEJm48O2N9HkxYjolXiKv4eDhrRXZKDWAvka5ypzA0GGcj+PHhhqecKwe2Il9HLxPLT5KuVlXmYeboHAzJ0ukQ4DmnwlMiBOdTU6rUlSagzdLXhVXQQfis6+TR43aLV6zO++BeVU8myXB+hV/tgZ04YxZ/azFyvAnSaFIBjg5yDAovQXdnrjGx4jr9C0jxPTmtpCyxpDj3nSolknjMlaSICCREfVmxHqwd6ek6XY4Unc0XsjaAyjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LeS3/BE7ObOlsMjooodoEd0fa0SUucW0fDTAngt+W3U=;
 b=dspEQ5zOZEjehIpSCVGY+f1G+9CNWOsbnx8/d97J6eHsQ8blWpfFolgHCPpvvaS7+VdLeFspmIhf04RqFuSwgdAwPC+uai79gnRzfnevdyc+xMzFOyAQb+pGmQMsVvQRbqjLucPjirfxvRdzjuoo45eR5JhaOkGbKwP8cZYakf4LMrfy75UcoW9dvyvNvBxUsrEyL3DhHVmi4PRC1LWDg+ma45K5/ND89QNuAwUHOjYrwQM2/nWZubOax95NzT0UQMN5UaoD1BIW/f0A2eNqYKeCx3x1OaIT/fydALxHQt4821MRNL6ufmLWoYeOGPrUq4mkBG4ezcUmzuQugJliew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LeS3/BE7ObOlsMjooodoEd0fa0SUucW0fDTAngt+W3U=;
 b=S8M9ziQw7MQX6UCBzBV2LHfu8UpirTQwo29Eb22PKFUcLjCydd3BvrnvFSTxoBMnAPZ0lzAt9lYAW9V9kjJ0CwIpMASDjR0LiqZiBEm1PfoBBVwdAh9mfu0iFqVnuEjG4btLtBieFnAzYW7k1EUkBLq1zH6G0QRW7nCIAnyr+Rg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3463.namprd10.prod.outlook.com (2603:10b6:a03:118::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.24; Thu, 26 Aug
 2021 01:05:45 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 01:05:45 +0000
Subject: Re: [PATCH 1/1] xfstests: Add Log Attribute Replay test
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20210825195144.2283-1-catherine.hoang@oracle.com>
 <20210825195144.2283-2-catherine.hoang@oracle.com>
 <20210825222807.GG12640@magnolia>
 <02e9685b-b6e3-2fc7-9233-e9e540c0d3a6@oracle.com>
 <20210826010255.GJ12640@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <61f5f9ba-3951-f2d0-3905-29be7e4a7687@oracle.com>
Date:   Wed, 25 Aug 2021 18:05:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210826010255.GJ12640@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0284.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by SJ0PR03CA0284.namprd03.prod.outlook.com (2603:10b6:a03:39e::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 26 Aug 2021 01:05:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b0f4a3a-d0a0-4f48-653e-08d9682da213
X-MS-TrafficTypeDiagnostic: BYAPR10MB3463:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB34633EBA657FCC1FB7744D5295C79@BYAPR10MB3463.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kx5ds1tnRCnmKUeEK1onignTtVW0MLzj5mg12Nxn4nmnRPIai0dg6iW2BH+JfXJ14u56ngNvCJ35hsy6HInBVtzEge9z+Wl6hJASIJzmI8QgeBxPPKsoqKf2XmESpL0VZbp+/JFkZJmJgVZSZPAiy5c7ho4qZ+w9Md72UUP0mfi0PS7cVc4fKF37+ExM1huHUAEbtoa5tjBKCiklfw8jNeknZiVaoBw9mvvEJxax0H4aRv08DLiuH0wMCr3P6I8Pe1H4X/xpjZ1l7Ny7I+3wIR8nC+sbC0DZ1MytWNsI0zAsmNHbnluC7rPuG5gENAeONGWHxCyFbdR5mi8YT45s3zLNppuXcSQsrfwdjYhBX7jCsQyK1HZW5UCiszt5uqgtXXmSz6UiWvfV6iqboU1ESf59ytWYUm/C5Wv7vTg0E8tQnyHKFgaoV9LhEFxV9xnclqZLFGneARc6+aG0lCtTFGOv31hZlHqiy67PCTMDH1dmbe5m2tZ1/u2PWMZNOK3Lu7wr2CXCC1Oyfgi02K/gv36SmCw7yffbexfUlmoBFgDM7iuV0YLboiBNpT9NEUvBs9l4897uCZZOTLVbrvLV9yjGjig8u5o6x7VE/vvluFljTTPpyxX3j6O96D0QAGJUOsY5HpoQ7k5k7AYFBZj90q0314SSdjBs17i72XzK4a3dKEeQDl+0do/YYqlMtnUbqysV7lBvLWDOg5X+OgAybnFH8VZZwVmlRbMmRBScU9I1cdIyroza01LBFxPXp+fTN7/NPf5+H0vKMUw4BvTaLKcdGcHSIq8EZiTLNnYP1aM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(136003)(396003)(39860400002)(66946007)(86362001)(16576012)(478600001)(83380400001)(2616005)(66556008)(66476007)(6916009)(53546011)(2906002)(44832011)(8936002)(8676002)(31696002)(6486002)(186003)(4326008)(31686004)(316002)(5660300002)(26005)(956004)(52116002)(38350700002)(36756003)(38100700002)(45980500001)(43740500002)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anM3dVl2ZlNHYjFHWEgzVUVmTHl1MXdMRE1wRUJ2M2p0dDlLSCtjeHVkZm82?=
 =?utf-8?B?L3pYMU5INUgrbzNiOEFNdGNhdkxCVlhIbG9ZQ2xla0VTdDUrNE9UZ2V3RWNq?=
 =?utf-8?B?MjY0c3d2ZDRMWEVZZ3JtSFVha2lyUWl1UnI5UXgyY3hId3lTVjFXSE9vdUNT?=
 =?utf-8?B?VjhVLzBkN3prdHY3M3NFZXV0OWt2TUlvZEdVcmZBdGJPcTNXWXFObnhlRi9y?=
 =?utf-8?B?N3ZPb0RGUVZCUGtLQWJubTYvazJEUkVGNVVJd0JCMk5jbWRpK0podVdtSEdY?=
 =?utf-8?B?bXpGRnpsZ2grMVlZQVYxR1dhR3FZT0JIa0NWY2wvcm9VVmRnY1FWVzRMeFdE?=
 =?utf-8?B?TlYyeUtoUHFnRUtUOVdwQUN0RStyUmxobCtDN29BbFVKcEhLa3h3cS85Y2VS?=
 =?utf-8?B?UGMyZDE5aWtsU3dYT1FqazU1cDdWc2hua3NMVnluazRKZlFIdkw1RmRad0hU?=
 =?utf-8?B?MVM0VmVYRWlUKzZ5V3JZbUg5VUM2NCtJRDFMb0w4WE1rLzI2TjVWVkxrSm56?=
 =?utf-8?B?Y29acGJBZm1WNGVaM0ord1RvTkdQKzE5YkkwdUprTHQvdE5GZXppenhES2Jo?=
 =?utf-8?B?WnBJU0JIZHIxdmtzRjBWYXNoWFpNSWN4RmZmeStwOGtxTWtlZkQralVRSkxY?=
 =?utf-8?B?NHpsUER4MCtTb2MwSCtqdllXRWtoakUvTGpWYXNyTHg5dTZaVks5Q09TMzRS?=
 =?utf-8?B?azNrZ0FVUnp0dTkwaFBUbGlYaHVZLzFIeGRUdm1VbURaMjRmb1ZzWEV2d2Ey?=
 =?utf-8?B?MzFrbE1ydzF2YTMyQkNsVlJ0RksxNGhxZmdoVHd5QkxRNDA4ZStrOUF2cVRv?=
 =?utf-8?B?Umc2QzBJOEVFYUxMUWt2QWRqOTdyOVJCdlB0cWRCblZFclhRTmtLdXBVUm00?=
 =?utf-8?B?ZmNzQjJ2cnozWGRTU3VacFZUSEt3UjluckpIV0pkZ1QxWmN5WDFWYTFlK3pr?=
 =?utf-8?B?NVQrUXpZMEZTNlkxNG8vZS9XUnR6UHNmU3NxTjFxZlRESjRtVWFwellmTExN?=
 =?utf-8?B?MVpGTGE1VlZUMmkzN214R1dZY3VVMzdPcVdwaVlMRXBuZlViQzJQVVVPWDhy?=
 =?utf-8?B?S1NWZjJXWXZvd2xhYjAzWVYzb2tsakRwSmx1Z09LbE1LdllPVkVLZGV0eGp0?=
 =?utf-8?B?WlpSbzBCOWlGSmR5WWh2Yk9ZOFhzNGZjVnJFZG1XVnRkSll5UkhFenF3YkZ2?=
 =?utf-8?B?aTdnYVZtM0puRnB4cG9FQ2Vrc3FCeDhVWFFzbVdWYkVOTC81Y0tlZWNFQ09s?=
 =?utf-8?B?WTFxM0h1RndVMWRwWFRxU3JvYjZZUmNOY29uZU1Na2NuVCtjZzFRTkZEQXB6?=
 =?utf-8?B?REM0NUdDTVRZem40S3ZEcm13MHB6cUtOVmV0eG9CUW0wMEJLaHRFOUg0MDJp?=
 =?utf-8?B?eWNmS05vam0zRlQ3RU8xMW5xTlBDekJWb0ptSGlBZ0pOTTljVlZkODhCOXBy?=
 =?utf-8?B?SXFJVmZjUmlzN0ZjTFhIWkgrbEJxWTQrbHBzRGt5QXJrSWZ0dW53MnpuQzF4?=
 =?utf-8?B?cmtOemd3akFja3VJdnZCN284MVdsSGpLZzZDNng4T2U0OFcrQ3o0S0JGc2Vq?=
 =?utf-8?B?a3RsWVhsaXBhK1FPU1VoQ010L3pteXhYU2tjcmg5V2dUamRHclYrMkFodnB2?=
 =?utf-8?B?UFVlcHdlQlpieU5vU2hacWVkd1NwSjlUNmxtK0NGZXh6RzdySUNEZ1NaR2Er?=
 =?utf-8?B?U3VUMFc4S0tQMlVSRDA2OVl6VVRnZ0FmNE8wdWhiYmY4R0VFVFNkcjg4Q2s3?=
 =?utf-8?Q?tRq36U7SUWDRGtf26dviPIAi7rFkSs10E3xmrE+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0f4a3a-d0a0-4f48-653e-08d9682da213
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 01:05:45.2290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y9e4Z4oekFvEZAUxWj3Lnm84rILQXZziQQwlOrEPWlZ5eZY5+lwjyJMcaEqF2+fu2F+tKORIzB/x8RubuAAAbCbiYnQDbyNo2HszCuIzhT8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3463
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108260005
X-Proofpoint-ORIG-GUID: fKvBSrFj26dPqa9tgT3GSNAR2OD_zCS6
X-Proofpoint-GUID: fKvBSrFj26dPqa9tgT3GSNAR2OD_zCS6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/25/21 6:02 PM, Darrick J. Wong wrote:
> On Wed, Aug 25, 2021 at 05:58:14PM -0700, Allison Henderson wrote:
>>
>>
>> On 8/25/21 3:28 PM, Darrick J. Wong wrote:
>>> On Wed, Aug 25, 2021 at 12:51:44PM -0700, Catherine Hoang wrote:
>>>> From: Allison Henderson <allison.henderson@oracle.com>
>>>>
>>>> This patch adds a test to exercise the log attribute error
>>>> inject and log replay.  Attributes are added in increaseing
>>>> sizes up to 64k, and the error inject is used to replay them
>>>> from the log
>>>>
>>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>>> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
>>>
>>> Yay, [your] first post! :D
>>>
>>>> ---
>>>>    tests/xfs/540     |  96 ++++++++++++++++++++++++++++++++++
>>>>    tests/xfs/540.out | 130 ++++++++++++++++++++++++++++++++++++++++++++++
>>>>    2 files changed, 226 insertions(+)
>>>>    create mode 100755 tests/xfs/540
>>>>    create mode 100644 tests/xfs/540.out
>>>>
>>>> diff --git a/tests/xfs/540 b/tests/xfs/540
>>>> new file mode 100755
>>>> index 00000000..3b05b38b
>>>> --- /dev/null
>>>> +++ b/tests/xfs/540
>>>> @@ -0,0 +1,96 @@
>>>> +#! /bin/bash
>>>> +# SPDX-License-Identifier: GPL-2.0
>>>> +# Copyright (c) 2021, Oracle and/or its affiliates.  All Rights Reserved.
>>>> +#
>>>> +# FS QA Test 540
>>>> +#
>>>> +# Log attribute replay test
>>>> +#
>>>> +. ./common/preamble
>>>> +_begin_fstest auto quick attr
>>>> +
>>>> +# get standard environment, filters and checks
>>>> +. ./common/filter
>>>> +. ./common/attr
>>>> +. ./common/inject
>>>> +
>>>> +_cleanup()
>>>> +{
>>>> +	echo "*** unmount"
>>>> +	_scratch_unmount 2>/dev/null
>>>> +	rm -f $tmp.*
>>>> +	echo 0 > /sys/fs/xfs/debug/larp
>>>> +}
>>>> +
>>>> +_test_attr_replay()
>>>> +{
>>>> +	attr_name=$1
>>>> +	attr_value=$2
>>>> +	touch $testfile.1
>>>> +
>>>> +	echo "Inject error"
>>>> +	_scratch_inject_error "larp"
>>>> +
>>>> +	echo "Set attribute"
>>>> +	echo "$attr_value" | ${ATTR_PROG} -s "$attr_name" $testfile.1 | \
>>>> +			    _filter_scratch
>>>> +
>>>> +	echo "FS should be shut down, touch will fail"
>>>> +	touch $testfile.1
>>>> +
>>>> +	echo "Remount to replay log"
>>>> +	_scratch_inject_logprint >> $seqres.full
>>>> +
>>>> +	echo "FS should be online, touch should succeed"
>>>> +	touch $testfile.1
>>>> +
>>>> +	echo "Verify attr recovery"
>>>> +	_getfattr --absolute-names $testfile.1 | _filter_scratch
>>>
>>> Shouldn't we check the value of the extended attrs too?
>> I think the first time I did this years ago, I questioned if people would
>> really want to see a 110k .out file, and stopped with just the names.
>>
>> Looking back at it now, maybe we could drop the value and the expected value
>> in separate files, and diff the files, and then the test case could just
>> check to make sure the diff output comes back clean?
> 
> $ATTR_PROG -g attr_nameX fubar.1 | md5sum
> 
> would be a more compact way of encoding exact byte sequence output in
> the .out file.
> 
> --D
Ok, that sounds good then

Allison

> 
>>>
>>>> +}
>>>> +
>>>> +
>>>> +# real QA test starts here
>>>> +_supported_fs xfs
>>>> +
>>>> +_require_scratch
>>>> +_require_attrs
>>>> +_require_xfs_io_error_injection "larp"
>>>> +_require_xfs_sysfs debug/larp
>>>> +
>>>> +# turn on log attributes
>>>> +echo 1 > /sys/fs/xfs/debug/larp
>>>> +
>>>> +rm -f $seqres.full
>>>
>>> No need to do this anymore; _begin_fstest takes care of this now.
>>>
>>>> +_scratch_unmount >/dev/null 2>&1
>>>> +
>>>> +#attributes of increaseing sizes
>>>> +attr16="0123456789ABCDEFG"
>> Yes, we need to drop the G off this line :-)
>>
>>>
>>> "attr16" is seventeen bytes long.
>>>
>>>> +attr64="$attr16$attr16$attr16$attr16"
>>>> +attr256="$attr64$attr64$attr64$attr64"
>>>> +attr1k="$attr256$attr256$attr256$attr256"
>>>> +attr4k="$attr1k$attr1k$attr1k$attr1k"
>>>> +attr8k="$attr4k$attr4k$attr4k$attr4k"
>> I think I must have meant to do a 16k in here. Lets replace attr8k and
>> attr32k with:
>>
>> attr8k="$attr4k$attr4k"
>> attr16k="$attr8k$attr8k"
>> attr32k="$attr16k$attr16k"
>>
>> I think that's easier to look at too.  Then we can add another replay test
>> for the attr16k as well.
>>
>>>
>>> This is 17k long...
>>>
>>>> +attr32k="$attr8k$attr8k$attr8k$attr8k"
>>>
>>> ...which makes this 68k long...
>>>
>>>> +attr64k="$attr32k$attr32k"
>>>
>>> ...and this 136K long?
>>>
>>> I'm curious, what are the contents of user.attr_name8?
>>>
>>> OH, I see, attr clamps the value length to 64k, so I guess the oversize
>>> buffers don't matter.
>>>
>>> --D
>>>
>>>> +
>>>> +echo "*** mkfs"
>>>> +_scratch_mkfs_xfs >/dev/null
>>>> +
>>>> +echo "*** mount FS"
>>>> +_scratch_mount
>>>> +
>>>> +testfile=$SCRATCH_MNT/testfile
>>>> +echo "*** make test file 1"
>>>> +
>>>> +_test_attr_replay "attr_name1" $attr16
>>>> +_test_attr_replay "attr_name2" $attr64
>>>> +_test_attr_replay "attr_name3" $attr256
>>>> +_test_attr_replay "attr_name4" $attr1k
>>>> +_test_attr_replay "attr_name5" $attr4k
>>>> +_test_attr_replay "attr_name6" $attr8k
>>>> +_test_attr_replay "attr_name7" $attr32k
>>>> +_test_attr_replay "attr_name8" $attr64k
>>>> +
>>>> +echo "*** done"
>>>> +status=0
>>>> +exit
>>>> diff --git a/tests/xfs/540.out b/tests/xfs/540.out
>>>> new file mode 100644
>>>> index 00000000..c1b178a0
>>>> --- /dev/null
>>>> +++ b/tests/xfs/540.out
>>>> @@ -0,0 +1,130 @@
>>>> +QA output created by 540
>>>> +*** mkfs
>>>> +*** mount FS
>>>> +*** make test file 1
>>>> +Inject error
>>>> +Set attribute
>>>> +attr_set: Input/output error
>>>> +Could not set "attr_name1" for /mnt/scratch/testfile.1
>>>> +FS should be shut down, touch will fail
>>>> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
>>>
>>> The error messages need to be filtered too, because SCRATCH_MNT is
>>> definitely not /mnt/scratch here. ;)
>> Ok, so we need to add "| _filter_scratch" to all the touch commands in
>> _test_attr_replay
>>
>> Thanks for the reviews!
>> Allison
>>
>>>
>>> --D
>>>
>>>> +Remount to replay log
>>>> +FS should be online, touch should succeed
>>>> +Verify attr recovery
>>>> +# file: SCRATCH_MNT/testfile.1
>>>> +user.attr_name1
>>>> +
>>>> +Inject error
>>>> +Set attribute
>>>> +attr_set: Input/output error
>>>> +Could not set "attr_name2" for /mnt/scratch/testfile.1
>>>> +FS should be shut down, touch will fail
>>>> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
>>>> +Remount to replay log
>>>> +FS should be online, touch should succeed
>>>> +Verify attr recovery
>>>> +# file: SCRATCH_MNT/testfile.1
>>>> +user.attr_name1
>>>> +user.attr_name2
>>>> +
>>>> +Inject error
>>>> +Set attribute
>>>> +attr_set: Input/output error
>>>> +Could not set "attr_name3" for /mnt/scratch/testfile.1
>>>> +FS should be shut down, touch will fail
>>>> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
>>>> +Remount to replay log
>>>> +FS should be online, touch should succeed
>>>> +Verify attr recovery
>>>> +# file: SCRATCH_MNT/testfile.1
>>>> +user.attr_name1
>>>> +user.attr_name2
>>>> +user.attr_name3
>>>> +
>>>> +Inject error
>>>> +Set attribute
>>>> +attr_set: Input/output error
>>>> +Could not set "attr_name4" for /mnt/scratch/testfile.1
>>>> +FS should be shut down, touch will fail
>>>> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
>>>> +Remount to replay log
>>>> +FS should be online, touch should succeed
>>>> +Verify attr recovery
>>>> +# file: SCRATCH_MNT/testfile.1
>>>> +user.attr_name1
>>>> +user.attr_name2
>>>> +user.attr_name3
>>>> +user.attr_name4
>>>> +
>>>> +Inject error
>>>> +Set attribute
>>>> +attr_set: Input/output error
>>>> +Could not set "attr_name5" for /mnt/scratch/testfile.1
>>>> +FS should be shut down, touch will fail
>>>> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
>>>> +Remount to replay log
>>>> +FS should be online, touch should succeed
>>>> +Verify attr recovery
>>>> +# file: SCRATCH_MNT/testfile.1
>>>> +user.attr_name1
>>>> +user.attr_name2
>>>> +user.attr_name3
>>>> +user.attr_name4
>>>> +user.attr_name5
>>>> +
>>>> +Inject error
>>>> +Set attribute
>>>> +attr_set: Input/output error
>>>> +Could not set "attr_name6" for /mnt/scratch/testfile.1
>>>> +FS should be shut down, touch will fail
>>>> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
>>>> +Remount to replay log
>>>> +FS should be online, touch should succeed
>>>> +Verify attr recovery
>>>> +# file: SCRATCH_MNT/testfile.1
>>>> +user.attr_name1
>>>> +user.attr_name2
>>>> +user.attr_name3
>>>> +user.attr_name4
>>>> +user.attr_name5
>>>> +user.attr_name6
>>>> +
>>>> +Inject error
>>>> +Set attribute
>>>> +attr_set: Input/output error
>>>> +Could not set "attr_name7" for /mnt/scratch/testfile.1
>>>> +FS should be shut down, touch will fail
>>>> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
>>>> +Remount to replay log
>>>> +FS should be online, touch should succeed
>>>> +Verify attr recovery
>>>> +# file: SCRATCH_MNT/testfile.1
>>>> +user.attr_name1
>>>> +user.attr_name2
>>>> +user.attr_name3
>>>> +user.attr_name4
>>>> +user.attr_name5
>>>> +user.attr_name6
>>>> +user.attr_name7
>>>> +
>>>> +Inject error
>>>> +Set attribute
>>>> +attr_set: Input/output error
>>>> +Could not set "attr_name8" for /mnt/scratch/testfile.1
>>>> +FS should be shut down, touch will fail
>>>> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
>>>> +Remount to replay log
>>>> +FS should be online, touch should succeed
>>>> +Verify attr recovery
>>>> +# file: SCRATCH_MNT/testfile.1
>>>> +user.attr_name1
>>>> +user.attr_name2
>>>> +user.attr_name3
>>>> +user.attr_name4
>>>> +user.attr_name5
>>>> +user.attr_name6
>>>> +user.attr_name7
>>>> +user.attr_name8
>>>> +
>>>> +*** done
>>>> +*** unmount
>>>> -- 
>>>> 2.25.1
>>>>
