Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B2D9C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 18:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B66A60FC3
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 18:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbhHaS2u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 14:28:50 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:58334 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232236AbhHaS2u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Aug 2021 14:28:50 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17VFp1eB009253;
        Tue, 31 Aug 2021 18:27:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=oVB3fzpL+Rhe2jtuS40wV+ybWZ8XaQmvLRXH47h2Usg=;
 b=at+M7PeMopa1lHUhWpFbv/KmlPY0w6PpwPIGIQbSVYOUemWpJL6uAPHQhGMBIWz7kTRZ
 9J6XcjY6FLmxY7vzu/6KK+HeW3aBT6wsCoID7OtEAgRIT8umxnTHiSDQcYxhbSNlzec8
 xdrmkOsrFFE0mXkSInKLCFMaEj2gDRF0Ck4izVUgcdlOxu8K2ybbERhIkrOt1uR/CEqu
 orLziHx7Tih97JazJbkkv8Elp9lsW1m2simlA3PdJ7lJddkxmfxwD5duMC6jhPVi7szi
 qL9NDJOIQIxK4JlCZpR31gmZcMPTwvRbU9vUyBL7gcjbGS5rVnyKtcF5HqtZVAyScDAu BQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=oVB3fzpL+Rhe2jtuS40wV+ybWZ8XaQmvLRXH47h2Usg=;
 b=e3FTNUW/KaPyhY0f9G9yXdyKkTVGf3C0isucYp8O244/MKxzgu2hs9Yr8lO0h+uh/y7a
 s5x+NUssEKuFvYGaa2IHZGMp3lN3zCsSvIMKGzvBEV81Wd0YWIY8tGesCC/2EH1oPf0W
 xkImAXO5FKIzy052OPV2tlTdxBg5wdDHSpaYLgPU/hk2GL0QOT1zlpZrqhJG57ZmrWrw
 GcR5YsSS0goDG4hMz7LDJ7Sqk5gnroEFLfuHB3nrYubJ8jdxFeaMbvKcFxx9fnjH/ak7
 w0oQWOM5RYfPP1OoGMaXyEVRBtc0CbLzxf7m/lx3LCXvWszxJdStkz/1XEohYcH8zW+h AQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3asf2mhwtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 18:27:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17VI9qtE092422;
        Tue, 31 Aug 2021 18:27:52 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2041.outbound.protection.outlook.com [104.47.73.41])
        by userp3020.oracle.com with ESMTP id 3aqxwu1efc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 18:27:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVtR/5VIgAQTJqnUZgIQNzdYJoAZ8FewQ8/umQv9qnKHWB8mP+SeX0DOWA7+OYY74Kue3zOs5qUm26lgyaOsawRog9TWj9FBalHcS63Mobh2HR0ghquShRjk6V5o7iei5+xIWwb8UxGsFjazcJrA3K2lLkeVath4y99OM8f4CDFnLRwUTtciDg42Oe0mnKK2qB4blf+7rjXNvt4ciJ/RZ8WLTKim9HdYys2YtLeTUS1ffdKp1OzvRoRbc8NS6DW4C43Gm6KUCn2Yb2mAfFFzPpEohtzE+ZMWHgtq7tqpbIgqEBcMhUkgqsUBw8jnBIClcpdr/L/XS8g3DLqDJF+SwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oVB3fzpL+Rhe2jtuS40wV+ybWZ8XaQmvLRXH47h2Usg=;
 b=fzPDs9qoi8Q285CH/MhbGmTaFqvE/kzMCW8sxCgJC2BDpvamst+biQ/fy5QOqBAL+tW6iiRO8pEpm7GKPiQTGHsiMzoSrs2XwbhgdkxBnxFm6BB6U+Jr0e1b4NdD1txTDFxyRmDelPpMzZsAgmeZxJgiyX5h/d9RT6OOWzOo62mt9KgQbHHfyfCyGuLqA9OXY7QEMJMeyfSwkHp5uVNbk9lxjBTHnulYOnAWeCzTdy6BaicPXeidap5NdD67JgdVofyOHIXTZmnRChEQVq1TnaZH6oaHcQobcpH5vY86meH9rcOb0PXUi4XOWZJRZFpRMIL5Sfa9atvvWERbdv8VXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oVB3fzpL+Rhe2jtuS40wV+ybWZ8XaQmvLRXH47h2Usg=;
 b=byuuOos8nYUPoWipKBNCSiLd/TyjkLnCVeQX+ltjFs/yQaRYX3pnae8jInpq1+rJxpMqQtDK1SYPnwc5djqacQ86YIH7htsmBbfuEB6XIUiUvunrQhItkIUC4N0IxwcdmYaOfk15yHCha+FgHI3YorLp8/rqBFgxc2Iegg/Iogc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2965.namprd10.prod.outlook.com (2603:10b6:a03:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Tue, 31 Aug
 2021 18:27:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4478.019; Tue, 31 Aug 2021
 18:27:50 +0000
Subject: Re: [PATCH v24 00/11] Log Attribute Replay
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210831002010.GS3657114@dread.disaster.area>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <2b6b0478-b0df-7e35-b0ac-f02298ccf727@oracle.com>
Date:   Tue, 31 Aug 2021 11:27:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210831002010.GS3657114@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0091.namprd07.prod.outlook.com
 (2603:10b6:510:4::6) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by PH0PR07CA0091.namprd07.prod.outlook.com (2603:10b6:510:4::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Tue, 31 Aug 2021 18:27:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd56e4b2-7406-4385-9d8c-08d96cad0a00
X-MS-TrafficTypeDiagnostic: BYAPR10MB2965:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2965FC4347AC07F96904B2B695CC9@BYAPR10MB2965.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NBHkH+OsfI2q54iTWlhEzIxPP/k+4alfb4i+RDkfq0JSyy6FkrlPr+oUdh0BHIV+zZpNS07qC7NjtjXwx8gvQrGJ2xicksT5iPvh5tAgeAk+Y2oyCNaNN1vHdeWly3TH4lLVPtxeV+wUSAFrsQd19ruv409B9fOg6gIOwZnZuAK2oefsUaywWkV6OaeuaH58JfAW29Gq/xaFxxnaaQbcgraZ02JylwSXDnvBInd4uxsVsjczMIT4s6d893ztNgsGmD//iXQupmA2yuBhFBGeyHEluPFGrd2L1ReaJPTNIHOzHvsJwRKTl+8H1tioZMu7pAnqPc/z3ClDcEE/wODeK1CtAqYxF7zMkm5LuRmsc/8OTVoZyHMRt+StFgPu9WdodX7UmaCDyXavcc7e0aJvuONEPA46UysQnPB3V1ou5PF+lOmXFX3/0/vAZ/IIyWBSLvZ1p7YZXX5AXVurXdNDbv7+XZkmtrzBOX1w6msVpN+YTCmmqRTZiTQ8GzBT89LlXBD2+ZPvP22KPDDoWCXgNJUXXANxSB8AvTgvNTYzmID+rB+Hd6cV7uHRfNoDNVUL1QifAOhqsfjs0iZUa1O6xu6aYA5ssNvlStAzqXupDfvdb+dSNJl+Pu5wI8+o//xTvYDoY8q257bWbXBv4jTwtR2gv7VV/H+tuE31+Nnlo02LJZxfBFsaPzVTH1d29RdU5wsyGF5hfseih1ekDSnJNsSnJJX5zcijS7pyuA9MIHvgOrXa25SeL1d0IcHxD0Vak7tThq0VIOtQEVZ//mbKoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(376002)(396003)(366004)(30864003)(86362001)(5660300002)(53546011)(186003)(4326008)(956004)(2906002)(66556008)(6486002)(2616005)(478600001)(16576012)(8676002)(316002)(66476007)(8936002)(31696002)(44832011)(38100700002)(52116002)(6916009)(66946007)(38350700002)(26005)(31686004)(83380400001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFZHMW9WanJ3SjJTZnd3Y2NYZ2tSa3hPdXJyakhwLzJOcElzR0RlSWJXSGFr?=
 =?utf-8?B?Z21TKy9RRWdCbTVWcUpHNW5rNVBSVmp6RjdUeFFGUFB1ekZjQ3M3M3hDR0xD?=
 =?utf-8?B?bTcvTHNZZ1ZzU255bE5Hak9EVEJPbUN2RnNVUVNpRFcrS1haZDE3MXUwRmJR?=
 =?utf-8?B?STg0L1F5NlNvdmFqRjZWVmFJYzVobC83TlF4b1pzYnNXM0E1K0ZpVmFLYzlM?=
 =?utf-8?B?anQ3M21mQ1lrYm9JNndSa3hITHVNNlBwcGF4SEhpN1FDUjU2R0VLdVBxaTRu?=
 =?utf-8?B?enp3M1A0SjY5QVVJakZnYnpyWkFzMUFZcUtSQjNBUWMyaUJibmJnR3RjOWV1?=
 =?utf-8?B?MjRVMmhGN2xzaUV2TDc3SUlDa2lpN295VVVtM2xERzdCRTMzdFFuVVpvMUxE?=
 =?utf-8?B?ZnpmQzBheEorSC9saEQwSHZwTHJnTGZaUU54Ni9MZXZXaGhpTGdCeFh5WTls?=
 =?utf-8?B?cDRDZUlra0pUakhNWUF4OFh2a2k2MXZvOEwzdE5JbVZtdmZMMERaMkhDcklQ?=
 =?utf-8?B?Z3puTW9HZzRTY1VoZ2N4U0VWZkJDZUhxdTNPTU8xQTl0U1BydlIvM21FY1dt?=
 =?utf-8?B?NnBaRFQ1S2FjYkRpQS9kVWxObm9aTnhsZDYxV0IvZTN5K0lqZUV2R3ZNc0Q0?=
 =?utf-8?B?d2lmYmlHMDIwb0F1N3REUGw5akREcE1ieUIrSW9pV3VhSy9Yd1hOYWhVelIv?=
 =?utf-8?B?NzA2VjE2Y1hkeW1ISkRvUDF3SUt6ZFBXUEpjYzY3cWRIOW42T1Y3cUdYMFk4?=
 =?utf-8?B?UnNkUXNjZnZRaU1nZUljUERtYzhDa0Z6bmpjdmZYWEt3bmxNRTZ6TURQa29I?=
 =?utf-8?B?Z09CMU9LY0tTVXdTZmNqZHdXOGF3QjVSZHl6b3JBYzVzUFFQTldYa3lUTWRC?=
 =?utf-8?B?TU9iMkRvd0RRdkZpcTgyR0VKMzRKRnBkNlBvU3gvR2hNTnRKejArcGZHNUhs?=
 =?utf-8?B?MDJXUkdyd2Y3anAwNVJKdHhHZXlZZTNtUWltdDg2NTd2c1RtWHlWQXNFaXZx?=
 =?utf-8?B?bmgvZjF1dEpycEhnUFZCcnJMTlpwUkFUbGZqZ0M2YVVsNTlOeDlSdWJDRmNn?=
 =?utf-8?B?Q0d2UFIwRXFZcXVQZ1RpYmpCM0dQUi9EdmVjM21SSU5zYlN6aHhyZytBeXBz?=
 =?utf-8?B?b2ZSVnRQZ3pVRExyRHA0MEdoNC8vdGw5WWwxTUFpN1JJSEQ0dVV2RGpTVytx?=
 =?utf-8?B?c0hOT3ZwaFhRNmpYemdzcjliOUN5VDh5V2c4NDQwU2dodHk4QzNZd0JmaVMz?=
 =?utf-8?B?NzNsM1RSR1hPcGtkNURGdHBUM2hGU3RSVnVQZzZXOGQya3ovNWhGanNtanZQ?=
 =?utf-8?B?N01EWjVjRlZXN3Y3Y08zcXV0dHRUWlVtLzBLTHYrbnI1OCtlTklqRjVGMTBV?=
 =?utf-8?B?bmt6b3VFdGVYL1lxbDhMWGt0MHlIMVIydDQ3Q25vR3ZJRlFGWWlvTGU2dlZj?=
 =?utf-8?B?dFhseHBPWUFUUGZET1QweUwyUnZQcmhsS1o1ZW80V2ZMZURyZVB1aU50ME9N?=
 =?utf-8?B?REIzTzZNNC8wdEE5UHlSSXhSTXIrVHp5TXQ2ZHI5Q0U5d2ptRzUyUmVva2xS?=
 =?utf-8?B?REozSGErdWMvQllYV1lwalBSK1FRZmtyVGNrY0F6S2FYTlVVNUpCRUtzdHFv?=
 =?utf-8?B?RCtpT2N0UzJnaEMzODUvQjdFTVNMcXk0OFYzS3d1ck05WVhLNHkwT3lVdktI?=
 =?utf-8?B?dDgvVWpPRyt3eEJqLy8rd2p1elh5UzNPQzE5ZFdlYW5zVXJRRE9xR01qYVlS?=
 =?utf-8?Q?ET+TKkEA0gmUcPo7nIwkExI2eyLneHjn2exXmVk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd56e4b2-7406-4385-9d8c-08d96cad0a00
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 18:27:50.4163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Tpi8QaI1TlH8LSufad0BXLDENdY1YZ97qguNvShnVinOxrmOH0KQxur0x7E+7LR5CZk3ycKCnTrPVSBxDd2XE0cxaCMCDJoXSv5vxJHZbc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2965
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10093 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108310101
X-Proofpoint-GUID: dxBub5RXWS2TMgzaXJ6nYQYkgEqPlM5K
X-Proofpoint-ORIG-GUID: dxBub5RXWS2TMgzaXJ6nYQYkgEqPlM5K
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/30/21 5:20 PM, Dave Chinner wrote:
> On Tue, Aug 24, 2021 at 03:44:23PM -0700, Allison Henderson wrote:
>> Hi all,
>>
>> This set is a subset of a larger series parent pointers. Delayed attributes allow
>> attribute operations (set and remove) to be logged and committed in the same
>> way that other delayed operations do. This allows more complex operations (like
>> parent pointers) to be broken up into multiple smaller transactions. To do
>> this, the existing attr operations must be modified to operate as a delayed
>> operation.  This means that they cannot roll, commit, or finish transactions.
>> Instead, they return -EAGAIN to allow the calling function to handle the
>> transaction.  In this series, we focus on only the delayed attribute portion.
>> We will introduce parent pointers in a later set.
>>
>> The set as a whole is a bit much to digest at once, so I usually send out the
>> smaller sub series to reduce reviewer burn out.  But the entire extended series
>> is visible through the included github links.

Some of this we worked out in the chat last night, but I will echo it 
here for the archives

> 
> Ok, so like I did with Darrick's deferred inactivation series, the
> first thing I'm doing here is throwing this patchset at
> scalability/performance worklaods and finding out what is different.
> 
> I've merged this series with 5.14 + xfs/for-next + xfs-cil-scale and
> then run some tests on it. First up is fsmark creating zero length
> files w/ 64 byte xattrs. This should stress only shortform attribute
> manipulations.
> 
> I have not enabled delayed attributes yet (i.e.
> /sys/fs/xfs/debug/larp = 0)
> 
> First thing I notice is the transaction commit rate during create is
> up around 900k/s, so we are doing 3 transactions per inode - 1 for
> create, 2 for attributes. That looks like a regression - existing
> shortform attribute creation only takes a single transaction commit,
> so this workload prior to this patchset only ran at 600k commits/s.
> 
> Note that hte only reason I'm getting 900k transactions/s is the
> CIL scalability patchset - without that the system tops out at ~800k
> transactions/s and so this would be a significant performance
> regression (20%) vs the current xfs/for-next code.
> 
> Essentially, this looks like we are doing an extra transaction
> commit to defer the creation of the attribute, then doing another
> transaction to actually modify the attribute. i.e.:
> 
>   - 11.04% xfs_attr_set
>      - 8.70% xfs_trans_commit
>         - 8.69% __xfs_trans_commit
> 	  - 5.10% xfs_defer_finish_noroll
> 	     - 3.74% xfs_defer_trans_roll
> 		- 3.57% xfs_trans_roll
> 		   - 3.13% __xfs_trans_commit
> 		      - 3.01% xlog_cil_commit
> 			   0.66% down_read
> 			   0.63% xfs_log_ticket_regrant
> 	     - 1.16% xfs_attr_finish_item
> 		- 1.06% xfs_trans_attr_finish_update
> 		   - 1.03% xfs_attr_set_iter
> 		      - 1.01% xfs_attr_sf_addname
> 			 - 0.99% xfs_attr_try_sf_addname
> 			    - 0.61% xfs_attr_shortform_addname
> 				 0.55% xfs_attr_shortform_add
> 
> 
> AFAICT, for non-delayed attributes, this first transaction commit
> logs the inode but does not create intent or intent done items
> (returns NULL for both operations), so just rolls and runs the
> ->finish_item. So it would seem that the first transaction just
> changes the inode timestamps and does nothing else.
> 
> Firstly, this means the inode timestamp change is not atomic w.r.t.
> the attribute change the timestamp change relates to and it's
> essentially new overhead for the non-delayed path.
> 
> Looking at the unlink path, I see the same thing - there's an extra
> transaction for the attr remove path, the same as the attr set path.
> This drives the unlink path to 1.1 million transaction commits/sec
> instead of 800k/s, so it's likely that there's a substantial
> performance regression here on a kernel without the CIL scalability
> patchset.
> 
> IOWs, there's significant behavioural changes with the non-delayed
> logging version of this patchset, both in terms of performance and
> the atomicity of changes that appear in the journal and hence
> recovery behaviour.
> 
> At this point I have to ask: why are we trying to retain the "old"
> way of doing things (even for testing) if it is substantially
> changing behaviour and on-disk journal contents for attribute
> modifications?
Per the chat discussion, we have to keep both methods since sb v4 would 
not use the new log entries.

> 
> So, lets turn on delayed logging:
> 
> $ sudo sh -c 'echo 1 > /sys/fs/xfs/debug/larp'
> $ ~/tests/fsmark-50-test-xfs.sh -t 16 -X 64 -d /dev/mapper/fast -- -l size=2000m -d agcount=67
> QUOTA=
> MKFSOPTS= -l size=2000m -d agcount=67
> DEV=/dev/mapper/fast
> THREADS=16
> .....
> 
> Message from syslogd@test4 at Aug 31 09:12:55 ...
>   kernel:[ 2342.737931] XFS: Assertion failed: !test_bit(XFS_LI_DIRTY, &lip->li_flags), file: fs/xfs/xfs_trans.c, line: 652
> 
> Instant assert fail and the machine locks up hard.
> 
> Actually, now that I reproduce it with a full console trace (which
> is terribly interleaved and almost impossible to read) there's
> bad stuff all over the place. Null pointer dereferences in
> xlog_cil_commit, "sleeping in atomic" failures, and the assert
> failure above.
> 
> Ok, run a single thread, and...
> 
> [   84.119162] BUG: kernel NULL pointer dereference, address: 000000000000000d
> [   84.123541] #PF: supervisor write access in kernel mode
> [   84.126028] #PF: error_code(0x0002) - not-present page
> [   84.127312] PGD 0 P4D 0
> [   84.127966] Oops: 0002 [#1] PREEMPT SMP
> [   84.128960] CPU: 8 PID: 5139 Comm: fs_mark Not tainted 5.14.0-dgc+ #552
> [   84.130632] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1 04/01/2014
> [   84.132723] RIP: 0010:xlog_prepare_iovec+0x59/0xe0
> [   84.133951] Code: 4c 89 f8 4c 29 e0 48 c1 f8 04 48 39 d0 7d 76 4d 8d 67 10 8b 43 34 8d 50 0c 83 e2 07 74 0c 83 c0 0b 83 c8 07 83 e8 0b 89 43 34 <45> 89 74 24 0c 48 63 43 34 48 03 43 28 49 89 04 24 c7 40 08 69 00
> [   84.137980] RSP: 0018:ffffc900021d7838 EFLAGS: 00010202
> [   84.138968] RAX: 0000000000000004 RBX: ffff888140f3e100 RCX: 0000000000000006
> [   84.140321] RDX: 0000000000000004 RSI: ffffc900021d7880 RDI: ffff888140f3e100
> [   84.141671] RBP: ffffc900021d7868 R08: ffffffff82a8fb88 R09: 000000000000494e
> [   84.143069] R10: ffff88823ffd5000 R11: 00000000000319c8 R12: 0000000000000001
> [   84.144447] R13: ffffc900021d7880 R14: 000000000000001b R15: 0000000000000000
> [   84.145825] FS:  00007f51fb33c740(0000) GS:ffff88823bc00000(0000) knlGS:0000000000000000
> [   84.147413] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   84.148535] CR2: 000000000000000d CR3: 00000001473b1003 CR4: 0000000000770ee0
> [   84.149927] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   84.151291] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   84.152331] PKRU: 55555554
> [   84.152732] Call Trace:
> [   84.153106]  xfs_attri_item_format+0x87/0x230
> [   84.153748]  xlog_cil_commit+0x253/0xa00
> [   84.154329]  ? kvmalloc_node+0x79/0x80
> [   84.154881]  __xfs_trans_commit+0xc1/0x330
> [   84.155490]  xfs_trans_roll+0x53/0xe0
> [   84.156027]  xfs_defer_trans_roll+0x10d/0x2b0
> [   84.156659]  xfs_defer_finish_noroll+0xb1/0x650
> [   84.157312]  __xfs_trans_commit+0x143/0x330
> [   84.157918]  xfs_trans_commit+0x10/0x20
> [   84.158498]  xfs_attr_set+0x41a/0x4e0
> [   84.159030]  xfs_xattr_set+0x8d/0xe0
> [   84.159554]  __vfs_setxattr+0x6b/0x90
> [   84.160090]  __vfs_setxattr_noperm+0x7d/0x1f0
> [   84.160718]  __vfs_setxattr_locked+0xdf/0x100
> [   84.161346]  vfs_setxattr+0x9b/0x170
> [   84.161862]  setxattr+0x110/0x200
> [   84.162346]  ? _raw_spin_unlock+0xe/0x20
> [   84.162914]  ? __handle_mm_fault+0xc1b/0x16d0
> [   84.163556]  ? __might_sleep+0x49/0x80
> [   84.164132]  __x64_sys_fsetxattr+0xb1/0xe0
> [   84.164782]  do_syscall_64+0x35/0x80
> 
> Ok, there's the first failure.
> 
> This looks like it's a problem with xfs_attri_item_{size,format} in
> calculating the number of bytes to log. They use ATTR_NVEC_SIZE() to
> calculate the number of bytes of copy from the attribute item which
> rounds up the length to copy to 4 byte aligned values. I'm not sure
> what this function is calculating:
> 
> /* iovec length must be 32-bit aligned */
> static inline size_t ATTR_NVEC_SIZE(size_t size)
> {
>          return size == sizeof(int32_t) ? size :
> 	               sizeof(int32_t) + round_up(size, sizeof(int32_t));
> }
> 
> It appears to be saying if the size == 4, then return 4, otherwise
> return 4 + roundup(size)... which leads me to struct
> xfs_attri_log_format:
> 
> struct xfs_attri_log_format {
>          uint16_t        alfi_type;      /* attri log item type */
>          uint16_t        alfi_size;      /* size of this item */
>          uint32_t        __pad;          /* pad to 64 bit aligned */
>          uint64_t        alfi_id;        /* attri identifier */
>          uint64_t        alfi_ino;       /* the inode for this attr operation */
>          uint32_t        alfi_op_flags;  /* marks the op as a set or remove */
>          uint32_t        alfi_name_len;  /* attr name length */
>          uint32_t        alfi_value_len; /* attr value length */
>          uint32_t        alfi_attr_flags;/* attr flags */
> };
> 
> I don't see where the extra 4 bytes for the attribute vector size
> comes from. It's not needed to store the length, so this could
> oversize the amount of data to be copied from the source
> buffer by up to 7 bytes?
> 
> I can see that it might need rounding with the existing
> log code (because the formatter is responsible for 32 bit alignment
> of log vectors), but that goes away with the CIL scalability
> patchset that always aligns iovecs to 4 byte alignment so the
> formatters do not need to do that.

I think we figured this out last night, initially this was here for an 
assertion check in the log code, but I think just the round up will 
suffice for the check.

> 
> Hiding it in a "macro" is not necessary, either - look at how
> xfs_inode_item_{data,attr}_fork_size handle the rounding up of the
> local format fork size. They round up the fork byte count to 4
> directly, and the format code copies those bytes because
> xfs_idata_realloc() allocates those bytes.
> 
> However, for the attribute buffers, this isn't guaranteed. Look at
> xfs_xattr_set():
> 
>          struct xfs_da_args      args = {
>                  .dp             = XFS_I(inode),
>                  .attr_filter    = handler->flags,
>                  .attr_flags     = flags,
>                  .name           = name,
>                  .namelen        = strlen(name),
>                  .value          = (void *)value,
>                  .valuelen       = size,
>          };
> 
> There is no rounding up of the name or value lengths, and these end
> up directly referenced by the deferred logging via xfs_attr_log_item()
> and attrip->da_args->...
> 
>          attrip->attri_name = (void *)attr->xattri_da_args->name;
>          attrip->attri_value = attr->xattri_da_args->value;
>          attrip->attri_name_len = attr->xattri_da_args->namelen;
>          attrip->attri_value_len = attr->xattri_da_args->valuelen;
> 
> We then pass those pointers directly to xlog_iovec_copy() but with a
> rounded up length that is longer than the source buffer:
> 
>          xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
>                          attrip->attri_name,
>                          ATTR_NVEC_SIZE(attrip->attri_name_len));
>          if (attrip->attri_value_len > 0)
>                  xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
>                                  attrip->attri_value,
>                                  ATTR_NVEC_SIZE(attrip->attri_value_len));
> 
> So while this might not be the source of the above crash, it's
> certainly a bug that needs fixing.
> 
> At this point, I'm just going to hack on the code to make it work,
> and we can go from there...

I think when we left off last night, we are more concerned with the 
extra transaction overhead in the perf captures.  I will see if I can 
replicate what you are seeing with perf and maybe we can work out some 
short cuts.  Thank for your help here!

Allison

> 
> Cheers,
> 
> Dave.
> 
