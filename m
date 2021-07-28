Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38BE6C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 09:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A74C60FD8
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 09:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbhG1JFO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 05:05:14 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:15986 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231287AbhG1JFO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 05:05:14 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16S92cQa006875;
        Wed, 28 Jul 2021 09:05:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=QgcNmYOka6QaNofBCu6gLDEGcjv73QTFv7AnzdMnlEA=;
 b=Wh8Qje+Yst623BaKvxcjiNLBGOf9+gmB++J34N1fTSzJH4l8fwWL9znLsm2RXJ4VP+Ij
 5VPOScxA9kw6hsIskIheqCYzt8fSfEivVj577W1mpOLijIfc2XM6+xqUhxmpY4SbrZwk
 TTAQKwDG4SYT78CRVGiO75IeESF9hbtv88ECT/BMYaNYsFZKVZaB1fVa5syAWrZoZRMe
 g2fed4zmzgNn7E3fcd/UOjG20Xms8OrSLPk01IoxTlIwvw16UpN8mJT/6TzJ93U8B1Y1
 jMLW77Qm99c3pArNt2pD0iSjllpQqj1JATIYUwneRU/K3VFcytxWWrciD0W1fhN6OxMs Kw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=QgcNmYOka6QaNofBCu6gLDEGcjv73QTFv7AnzdMnlEA=;
 b=FEY9kDyWT7tfnSBjhWtPxGKmwMnb5zB8p91i2oj8ygufW1q/Dn1wA51+T7LHkIdsg4uA
 2ePH0NUIaQepBZNe7Xx/FI0VoyuhgBaA9mCFAyWCBrHfMlsvJx8vOmI1Fm+6hHThcP6H
 T1jtlQCnz+LMU2nimbKooK2C6WCiskT6UNku72TUgNOupqGQRw5qJaXzzsGVR9cQPsm5
 2dfFKOSRE/nOZK2ZFawWAx+17WL/1i1uuq3kK8eI2HvyNR7RB17b4Ycu0n/t/27q5ylv
 IbxanxprvrAEw0czG7WBPI8/rQChpknk88gnBwmnw1uhfRhL7AkCoU1oL6zuAODdiCdA wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2358by4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:05:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16S90uQv167274;
        Wed, 28 Jul 2021 09:05:10 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3030.oracle.com with ESMTP id 3a2354rs96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:05:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4WmEij0vcIuKnRGGabUlcvRDLaqx9XdIvEF1Gc3NsmAH+KUt/PdHeQ2bdfRWkZ4+LE53EDJck5MW9bvE9S3VbSZ2CCtPcvqQcK27m1OcR070ai2STC9YTomtgaMdb/xdvQUokCmRDdr9RvUw9r+gIgY6d2KLVv2lRhjRPYyt3I5bWPn+Oa0dxbw6f8rD7reDi4E6gJnxDbrt19LgIkhth9Kh4PcFDt7hTT67wAOp9g8VXfJKeXRaooHYGQpkVPCRtlzJeS2bRetaorLQaDCDTHQ8upYDEsMVQdzrPgnw1lyoDqSYMnvo1N7AsR2sOlEDF/WO8OdfS9hmbxnnd3KBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgcNmYOka6QaNofBCu6gLDEGcjv73QTFv7AnzdMnlEA=;
 b=aReULt+KHBtBkhKO9IjKYXMJIyxjRapZx8LcVAAQtPxZ9l+vuHcGB06h+STJpeV43JQJj+6Nfw3L0siQJ9UlwVk69hcxzcSrV3VStvl9VLL+fovuaQx/Ch4eXlSLDZS2KlLSnlU4s+AqwpIrwhNvYWCNunukos/r3JFAyW2vUaDiLLdu7AAoU/dtpm6pmaisujYf1if650kXPBcZ0U/q/dQewoVpK3I1WmHcyh9qUNg0PFCOlTKUJhmKTw2ytOL0ZnGqYr6tLrqSIOwtvRTTJ8Sobwb2ImyGKpXTVNz7lcyNXXYbHxLDXlccz15we05OVsUiTvT9NVVhpmWSC7ydoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgcNmYOka6QaNofBCu6gLDEGcjv73QTFv7AnzdMnlEA=;
 b=XN1gxMLQweQlgQBSIXODpdpLzy3wfv5dbtwoNCtEVwYxLFCLaQcMIGgF1hePMFhC9bjIWOzUakElBVp6mDirj59q/p6ORwRrPWVZSfAe1tLtz7ZVrnsjhqlndFYmgF0oiVhCvAgW1uu6ufjkW1TxteXI5lpse1ToQ9dYhxi6eDc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2966.namprd10.prod.outlook.com (2603:10b6:a03:8c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Wed, 28 Jul
 2021 09:05:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.019; Wed, 28 Jul 2021
 09:05:08 +0000
Subject: Re: [PATCH v22 09/16] xfs: Implement attr logging and replay
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-10-allison.henderson@oracle.com>
 <20210728003946.GF559142@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <67ab32ab-9088-3b95-bfc4-cf42561e5423@oracle.com>
Date:   Wed, 28 Jul 2021 02:05:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210728003946.GF559142@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0246.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.166] (67.1.112.125) by SJ0PR03CA0246.namprd03.prod.outlook.com (2603:10b6:a03:3a0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 09:05:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e6d9e94-fe22-4525-f20a-08d951a6cc1a
X-MS-TrafficTypeDiagnostic: BYAPR10MB2966:
X-Microsoft-Antispam-PRVS: <BYAPR10MB29668EF46F8B37CED950762695EA9@BYAPR10MB2966.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:741;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ByY3RmPlP7IGKcTkODRwThDgYUtraFM/1tVIQ4h9Pb+7fKNaz41D8sXFEXlpd0zuIn/rHFiI1T+5gzkoTP285XaN6Iae3slpoh///KeApsAUcVQeqogKOrRZhOZh6QLOdmtJBIRRcGbdCbTRqw5mSr6ZhI7AgHb5BMLMbXpjiLJ8BufgemQ827q3Lqbn6K8K4GOeorchLvBqGkfqt4c6KVjsR7Tq0V35UNH8CPLoz8wPltZXy5Hp0NfTc6lQO3Zz4q6MY1JeJBCNRTnazUiUII4sgfRcEvrBS+O+Oz4NMAEcfx422aumP8s38Wb+tsguaoNSROiifskHa2VAkk+/Qndj5ROTUUwpSKq/ZmHKk4PCK7uaaYkFKzcjvxLudvo8BMCSMqyvcIvsFxN/Ehcd1eC72YA5XtQvLNMcwafd0o+jWE3ekRqtpsXAav2lEymdY/7Z5Kev8XP/MWQwxL3FQZyr3FUdiRQMhOeQo3QMQcUpL1LYUYXEaWMDrBMsxfiMAI5OhMbNKsjAgWSgtbqvj2vuKXkmjM7MRSdMhpA3m1ALNSfmhZWJiJIUi8J9vB4s1nYdZv6V2CDJP1+3mlQGAFzKKTK8kc2t1c69CPENpjyijXR6an0Z/RtDZHskyAugKtB8VI6CVCQ7z1GXrjlgxHUjy/I4crpSHUcs6AtopMoIBOIBmgQnQRG0W6aZ9obQlBFg4P5RZi7r07RLu8EfoXSb/pRb38s0khDu3HSyLRA7Nh7G41lQWrnIecIFi88ys+QJ2ysq4LOThInd5qFbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(6916009)(38100700002)(26005)(6486002)(52116002)(2616005)(38350700002)(316002)(66946007)(66476007)(66556008)(83380400001)(5660300002)(2906002)(508600001)(956004)(36756003)(30864003)(186003)(16576012)(44832011)(4326008)(8676002)(8936002)(53546011)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEgzc2tYYmxpRjkwNk9GVldpOXMrR3dRUzBrcnFya3plaExHdmZ1bFN3UUVO?=
 =?utf-8?B?WW05U3NqRk9sNFFQbzA0dHFYNGVWeURiVVNrQTJ0SUJyRjBRUnV5dUsweGRx?=
 =?utf-8?B?VjFSNzRPTmhkZUd2d2U5cTF2NDM3dVM3MFVEVzB4RW9ZTGJNelZYckw5bCtF?=
 =?utf-8?B?NEFpMFI3NFZXNG9zVmhKRFFhaVllMi9sbUdTY04yeHU5Q0pvVHRTUjZ1ZlFT?=
 =?utf-8?B?M1ZtSUQvcWRWNkdYeXExeEJ2dytqdnhpRzc0blY4TkhCS0lsTjkxaFdzRjl3?=
 =?utf-8?B?RWNmVUxUZ0tHUkd6cDFrSWxxRWQxS0xKUU9IK2NiSlV0WlNuMkYzaVZFQUp6?=
 =?utf-8?B?U1RERmdKamYyVi9aMFlSbDd4QXBOVmE1QThXL0xvb0EwWmQxS0ZEZnc0b28r?=
 =?utf-8?B?dGpUalBCTElmUWZWN2ZGMGFVbDB3djkzWXBLVG1zb0FFcCtmSWlzM01yTkRv?=
 =?utf-8?B?Qmx4ZStBbXpmb0hySnJFakdMb3NjTG8vYWpQOG9uQnR3cExudVl4NTV5U1RS?=
 =?utf-8?B?QUZNRjd5NHo2UjhVNDI4UzVWV3NpUUg0WmdOeGRTT2hWMmZ4bFJEc2JWRHRt?=
 =?utf-8?B?ZXY4WjVKQmdEWXFjQ1RHZnc4U2xpMGNQK1JkZjdqYnAvKzgyRTY5TG1HMlE3?=
 =?utf-8?B?SFBYeFVKN1dCSmdvbVZLb2Y5TCsyQTNmMjhuL2JhdFQ5SzhHMmozM1F6Y043?=
 =?utf-8?B?ZDVNaXJPUnV1djh1azcrM0ZQTnllKzQ4Zktsa3NMeVBGK09nWU5XdmUxa0py?=
 =?utf-8?B?dzgxT09SQWgrQWNRbUVTV3o5UG1Qcjg3bzVOSzZlWTgwQmw5Mk1ERTYwQkN6?=
 =?utf-8?B?bFB2dVZuWlhVTTBRa3dVeEE0U0tyMkdRUTZrMWxMYkw2a0NiTjY5K0g2YXcr?=
 =?utf-8?B?M2thL0ZiZmwzUTNRcnliNklFUHJ4ZHN5ZncwOGFlZEpEdzZEcU5WNExMQnVh?=
 =?utf-8?B?UElBK2V1cXFRVFZwSXlWR1Z4bUVtQm0rc1UwOEtoVWQ4UitYSW5ET0tpTG5M?=
 =?utf-8?B?Q0J6a1l4b3dqN2dCTmM3YW1HazZ4V0RXZjYwSEZOU0psUSt5Tm1RTWhzTThR?=
 =?utf-8?B?K0dNY3o5OWpvbkJveGVJZGhvemxhd2JzdjdDTEVjY3V6ZVl1UE9kUk1ldDFW?=
 =?utf-8?B?a3MzMENyM080ODhIbVRFTnBGWmN1aHo3S20vWTFZWStQRFVaMjRPNXFjdUU2?=
 =?utf-8?B?MkZwYnpUaEl4UnYyMXo4RXhsVlFFQkRkVFpTa1RFSEx6WDFXT1FmN2VxY00w?=
 =?utf-8?B?NXh0ellkV0hpbU8xV1BWMzI5L3VaNFMxQ1h4Rklzem05SVRGTmVnU3laOGVJ?=
 =?utf-8?B?b3JCTFV1SzdIWkh6YjZ4dVpMbkhJZ0NqcVZUMDduL2RSM2dFWXZjdFNkQnVz?=
 =?utf-8?B?T1VHeTBRYmZ3ZXlsdXVvNTczb3N4UExuSDdRVkJ2MmttMUdNb3JRa2t6bFVH?=
 =?utf-8?B?M1lURE1SSkFkSjcwZ25QQktpdklEVVJGSEtQK3NkQ01WbzNZeU1Ua1R5dzdq?=
 =?utf-8?B?QU5oRVMwekltd1hUUjl1Uyt1UkdyL1kvM1N3OEw4UCs0RVlqNG9XWVF4MXJJ?=
 =?utf-8?B?RlBPa2dlZlRiMk01QlhvWWRUMUdZdmw4TWpIVEJ4Uk53Mnd0LytIVGFTRmE3?=
 =?utf-8?B?WGl4eEE5aXR0YzJaVURGdk1KMGZpVVZyVHBTYWw5Q09XRGY4YVBzTlNNdHJB?=
 =?utf-8?B?bjdXYVJiVzN3aHdBQUJrdjhHWFk0Skh0SmpUK3hRek5tRXp5TldDUnU3eCs0?=
 =?utf-8?Q?qrmZOtJjTDYr1LV7XlU0VVrc/5Zd6WrneJmGjMH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e6d9e94-fe22-4525-f20a-08d951a6cc1a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 09:05:08.1131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4CWMCBlX/gpMwrM4jRbyQpUwqMWaxvMHBPoH5czoE604TGSScH5zPBtYHo4vidkA9cvRcy+WcKsW9w3y1T1bAiA5iShchd3mAZ644yREQkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2966
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10058 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280051
X-Proofpoint-GUID: pOlTyfI3IpTvlkZNMvezfvXVr3VVV2z5
X-Proofpoint-ORIG-GUID: pOlTyfI3IpTvlkZNMvezfvXVr3VVV2z5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/27/21 5:39 PM, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 11:20:46PM -0700, Allison Henderson wrote:
>> This patch adds the needed routines to create, log and recover logged
>> extended attribute intents.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_defer.c  |   1 +
>>   fs/xfs/libxfs/xfs_defer.h  |   1 +
>>   fs/xfs/libxfs/xfs_format.h |  10 +-
>>   fs/xfs/xfs_attr_item.c     | 377 +++++++++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 388 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
>> index eff4a12..e9caff7 100644
>> --- a/fs/xfs/libxfs/xfs_defer.c
>> +++ b/fs/xfs/libxfs/xfs_defer.c
>> @@ -178,6 +178,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>>   	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
>>   	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
>>   	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
>> +	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
>>   };
>>   
>>   static void
>> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
>> index 0ed9dfa..72a5789 100644
>> --- a/fs/xfs/libxfs/xfs_defer.h
>> +++ b/fs/xfs/libxfs/xfs_defer.h
>> @@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
>>   	XFS_DEFER_OPS_TYPE_RMAP,
>>   	XFS_DEFER_OPS_TYPE_FREE,
>>   	XFS_DEFER_OPS_TYPE_AGFL_FREE,
>> +	XFS_DEFER_OPS_TYPE_ATTR,
>>   	XFS_DEFER_OPS_TYPE_MAX,
>>   };
>>   
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index 3a4da111..93c1263 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -485,7 +485,9 @@ xfs_sb_has_incompat_feature(
>>   	return (sbp->sb_features_incompat & feature) != 0;
>>   }
>>   
>> -#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
>> +#define XFS_SB_FEAT_INCOMPAT_LOG_DELATTR   (1 << 0)	/* Delayed Attributes */
> 
> Echoing the conversation going on in IRC, can we change the name of this
> feature bit/flag/function?  What we're really describing here is using
> log-intent-based extended attribute updates.
> 
> IOWS, how about XFS_SB_FEAT_INCOMPAT_LOG_XATTRS?
Sure, that's fine.

> 
>> +#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
>> +	(XFS_SB_FEAT_INCOMPAT_LOG_DELATTR)
>>   #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
>>   static inline bool
>>   xfs_sb_has_incompat_log_feature(
>> @@ -590,6 +592,12 @@ static inline bool xfs_sb_version_hasbigtime(struct xfs_sb *sbp)
>>   		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_BIGTIME);
>>   }
>>   
>> +static inline bool xfs_sb_version_hasdelattr(struct xfs_sb *sbp)
> 
> sb_version_haslogxattrs?
Ok, will update

> 
>> +{
>> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
>> +		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_LOG_DELATTR);
> 
> sb_features_log_incompat, as Chandan pointed out.
Yep, will fix

> 
>> +}
>> +
>>   /*
>>    * Inode btree block counter.  We record the number of inobt and finobt blocks
>>    * in the AGI header so that we can skip the finobt walk at mount time when
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> index a810c2a..44c44d9 100644
>> --- a/fs/xfs/xfs_attr_item.c
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -275,6 +275,182 @@ xfs_attrd_item_release(
>>   	xfs_attrd_item_free(attrdp);
>>   }
>>   
>> +/*
>> + * Performs one step of an attribute update intent and marks the attrd item
>> + * dirty..  An attr operation may be a set or a remove.  Note that the
>> + * transaction is marked dirty regardless of whether the operation succeeds or
>> + * fails to support the ATTRI/ATTRD lifecycle rules.
>> + */
>> +STATIC int
>> +xfs_trans_attr_finish_update(
>> +	struct xfs_delattr_context	*dac,
>> +	struct xfs_attrd_log_item	*attrdp,
>> +	struct xfs_buf			**leaf_bp,
>> +	uint32_t			op_flags)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	unsigned int			op = op_flags &
>> +					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
>> +	int				error;
>> +
>> +	error = xfs_qm_dqattach_locked(args->dp, 0);
>> +	if (error)
>> +		return error;
> 
> We already attached dquots in xlog_recover_iget, so you can remove this
> entirely.
I see, ok then, will clean out

> 
>> +
>> +	switch (op) {
>> +	case XFS_ATTR_OP_FLAGS_SET:
>> +		args->op_flags |= XFS_DA_OP_ADDNAME;
>> +		error = xfs_attr_set_iter(dac, leaf_bp);
>> +		break;
>> +	case XFS_ATTR_OP_FLAGS_REMOVE:
>> +		ASSERT(XFS_IFORK_Q(args->dp));
>> +		error = xfs_attr_remove_iter(dac);
>> +		break;
>> +	default:
>> +		error = -EFSCORRUPTED;
>> +		break;
>> +	}
>> +
>> +	/*
>> +	 * Mark the transaction dirty, even on error. This ensures the
>> +	 * transaction is aborted, which:
>> +	 *
>> +	 * 1.) releases the ATTRI and frees the ATTRD
>> +	 * 2.) shuts down the filesystem
>> +	 */
>> +	args->trans->t_flags |= XFS_TRANS_DIRTY;
>> +
>> +	/*
>> +	 * attr intent/done items are null when delayed attributes are disabled
>> +	 */
>> +	if (attrdp)
>> +		set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
>> +
>> +	return error;
>> +}
>> +
>> +/* Log an attr to the intent item. */
>> +STATIC void
>> +xfs_attr_log_item(
>> +	struct xfs_trans		*tp,
>> +	struct xfs_attri_log_item	*attrip,
>> +	struct xfs_attr_item		*attr)
>> +{
>> +	struct xfs_attri_log_format	*attrp;
>> +
>> +	tp->t_flags |= XFS_TRANS_DIRTY;
>> +	set_bit(XFS_LI_DIRTY, &attrip->attri_item.li_flags);
>> +
>> +	/*
>> +	 * At this point the xfs_attr_item has been constructed, and we've
>> +	 * created the log intent. Fill in the attri log item and log format
>> +	 * structure with fields from this xfs_attr_item
>> +	 */
>> +	attrp = &attrip->attri_format;
>> +	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
>> +	attrp->alfi_op_flags = attr->xattri_op_flags;
>> +	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
>> +	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
>> +	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
>> +
>> +	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
>> +	attrip->attri_value = attr->xattri_dac.da_args->value;
>> +	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
>> +	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
>> +}
>> +
>> +/* Get an ATTRI. */
>> +static struct xfs_log_item *
>> +xfs_attr_create_intent(
>> +	struct xfs_trans		*tp,
>> +	struct list_head		*items,
>> +	unsigned int			count,
>> +	bool				sort)
>> +{
>> +	struct xfs_mount		*mp = tp->t_mountp;
>> +	struct xfs_attri_log_item	*attrip;
>> +	struct xfs_attr_item		*attr;
>> +
>> +	ASSERT(count == 1);
>> +
>> +	if (!xfs_hasdelattr(mp))
> 
> At this point we should already have turned on the log incompat feature
> bit if the sysadmin used the secret mount option, correct?  In that
> case, I think this check should be
> 
> 	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
> 		return NULL;
Sure, that should be fine

> 
>> +		return NULL;
>> +
>> +	attrip = xfs_attri_init(mp, 0);
>> +	if (attrip == NULL)
>> +		return NULL;
>> +
>> +	xfs_trans_add_item(tp, &attrip->attri_item);
>> +	list_for_each_entry(attr, items, xattri_list)
>> +		xfs_attr_log_item(tp, attrip, attr);
>> +	return &attrip->attri_item;
>> +}
>> +
>> +/* Process an attr. */
>> +STATIC int
>> +xfs_attr_finish_item(
>> +	struct xfs_trans		*tp,
>> +	struct xfs_log_item		*done,
>> +	struct list_head		*item,
>> +	struct xfs_btree_cur		**state)
>> +{
>> +	struct xfs_attr_item		*attr;
>> +	struct xfs_attrd_log_item	*done_item = NULL;
>> +	int				error;
>> +	struct xfs_delattr_context	*dac;
>> +
>> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
>> +	dac = &attr->xattri_dac;
>> +	if (done)
>> +		done_item = ATTRD_ITEM(done);
>> +
>> +	/*
>> +	 * Corner case that can happen during a recovery.  Because the first
>> +	 * iteration of a multi part delay op happens in xfs_attri_item_recover
>> +	 * to maintain the order of the log replay items.  But the new
>> +	 * transactions do not automatically rejoin during a recovery as they do
>> +	 * in a standard delay op, so we need to catch this here and rejoin the
>> +	 * leaf to the new transaction
>> +	 */
>> +	if (attr->xattri_dac.leaf_bp &&
>> +	    attr->xattri_dac.leaf_bp->b_transp != tp) {
>> +		xfs_trans_bjoin(tp, attr->xattri_dac.leaf_bp);
>> +		xfs_trans_bhold(tp, attr->xattri_dac.leaf_bp);
>> +	}
> 
> This is subtle.  The attri recovery function makes a direct call to
> xfs_trans_attr_finish_update before doing the capture-and-commit dance.
> When the captured items get replayed (separately) the defer ops
> mechanism calls this function, and that's the point at which we end up
> here needing to join and hold the leaf_bp to the transaction.
> 
> Do we have a reference to leaf_bp at this point?  When we return from
> xfs_trans_attr_finish_update in xfs_attri_item_recover, the leaf_bp (if
> any) is joined and held to the transaction that is committed in the
> "commit and capture".  Following the transaction commit I /think/ it's
> the case that we still have a reference to the leaf_bp?
> 
> So we have a reference to the leaf_bp and eventually we need to join it
> to the transaction that's used to continue the recovery.  What if the
> capture and commit function detected buffers that are bheld to the
> transaction and recorded them in the capture structure so that
> xlog_finish_defer_ops could do this part for you?
I see, I think what you are describeing should work, I will poke around 
in the capture commit routines and see if I can get that to work.

> 
>> +
>> +	/*
>> +	 * Always reset trans after EAGAIN cycle
>> +	 * since the transaction is new
>> +	 */
>> +	dac->da_args->trans = tp;
>> +
>> +	error = xfs_trans_attr_finish_update(dac, done_item, &dac->leaf_bp,
>> +					     attr->xattri_op_flags);
>> +	if (error != -EAGAIN)
>> +		kmem_free(attr);
>> +
>> +	return error;
>> +}
>> +
>> +/* Abort all pending ATTRs. */
>> +STATIC void
>> +xfs_attr_abort_intent(
>> +	struct xfs_log_item		*intent)
>> +{
>> +	xfs_attri_release(ATTRI_ITEM(intent));
>> +}
>> +
>> +/* Cancel an attr */
>> +STATIC void
>> +xfs_attr_cancel_item(
>> +	struct list_head		*item)
>> +{
>> +	struct xfs_attr_item		*attr;
>> +
>> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
>> +	kmem_free(attr);
>> +}
>> +
>>   STATIC xfs_lsn_t
>>   xfs_attri_item_committed(
>>   	struct xfs_log_item		*lip,
>> @@ -306,6 +482,30 @@ xfs_attri_item_match(
>>   	return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
>>   }
>>   
>> +/*
>> + * This routine is called to allocate an "attr free done" log item.
>> + */
>> +static struct xfs_attrd_log_item *
>> +xfs_trans_get_attrd(struct xfs_trans		*tp,
>> +		  struct xfs_attri_log_item	*attrip)
>> +{
>> +	struct xfs_attrd_log_item		*attrdp;
>> +	uint					size;
>> +
>> +	ASSERT(tp != NULL);
>> +
>> +	size = sizeof(struct xfs_attrd_log_item);
>> +	attrdp = kmem_zalloc(size, 0);
>> +
>> +	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
>> +			  &xfs_attrd_item_ops);
>> +	attrdp->attrd_attrip = attrip;
>> +	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
>> +
>> +	xfs_trans_add_item(tp, &attrdp->attrd_item);
>> +	return attrdp;
>> +}
>> +
>>   static const struct xfs_item_ops xfs_attrd_item_ops = {
>>   	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>>   	.iop_size	= xfs_attrd_item_size,
>> @@ -313,6 +513,29 @@ static const struct xfs_item_ops xfs_attrd_item_ops = {
>>   	.iop_release    = xfs_attrd_item_release,
>>   };
>>   
>> +
>> +/* Get an ATTRD so we can process all the attrs. */
>> +static struct xfs_log_item *
>> +xfs_attr_create_done(
>> +	struct xfs_trans		*tp,
>> +	struct xfs_log_item		*intent,
>> +	unsigned int			count)
>> +{
>> +	if (!intent)
>> +		return NULL;
>> +
>> +	return &xfs_trans_get_attrd(tp, ATTRI_ITEM(intent))->attrd_item;
>> +}
>> +
>> +const struct xfs_defer_op_type xfs_attr_defer_type = {
>> +	.max_items	= 1,
>> +	.create_intent	= xfs_attr_create_intent,
>> +	.abort_intent	= xfs_attr_abort_intent,
>> +	.create_done	= xfs_attr_create_done,
>> +	.finish_item	= xfs_attr_finish_item,
>> +	.cancel_item	= xfs_attr_cancel_item,
>> +};
>> +
>>   /* Is this recovered ATTRI ok? */
>>   static inline bool
>>   xfs_attri_validate(
>> @@ -340,13 +563,167 @@ xfs_attri_validate(
>>   	return xfs_hasdelattr(mp);
>>   }
>>   
>> +/*
>> + * Process an attr intent item that was recovered from the log.  We need to
>> + * delete the attr that it describes.
>> + */
>> +STATIC int
>> +xfs_attri_item_recover(
>> +	struct xfs_log_item		*lip,
>> +	struct list_head		*capture_list)
>> +{
>> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
>> +	struct xfs_attr_item		*attr;
>> +	struct xfs_mount		*mp = lip->li_mountp;
>> +	struct xfs_inode		*ip;
>> +	struct xfs_da_args		*args;
>> +	struct xfs_trans		*tp;
>> +	struct xfs_trans_res		tres;
>> +	struct xfs_attri_log_format	*attrp;
>> +	int				error, ret = 0;
>> +	int				total;
>> +	int				local;
>> +	struct xfs_attrd_log_item	*done_item = NULL;
>> +
>> +	/*
>> +	 * First check the validity of the attr described by the ATTRI.  If any
>> +	 * are bad, then assume that all are bad and just toss the ATTRI.
>> +	 */
>> +	attrp = &attrip->attri_format;
>> +	if (!xfs_attri_validate(mp, attrip))
>> +		return -EFSCORRUPTED;
>> +
>> +	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
>> +	if (error)
>> +		return error;
>> +
>> +	attr = kmem_zalloc(sizeof(struct xfs_attr_item) +
>> +			   sizeof(struct xfs_da_args), KM_NOFS);
>> +	args = (struct xfs_da_args *)((char *)attr +
>> +		   sizeof(struct xfs_attr_item));
> 
> 	args = (struct xfs_da_args *)(attr + 1); ?
Sure, should be fine.  Thanks for the reviews!
Allison

> 
> --D
> 
>> +
>> +	attr->xattri_dac.da_args = args;
>> +	attr->xattri_op_flags = attrp->alfi_op_flags;
>> +
>> +	args->dp = ip;
>> +	args->geo = mp->m_attr_geo;
>> +	args->op_flags = attrp->alfi_op_flags;
>> +	args->whichfork = XFS_ATTR_FORK;
>> +	args->name = attrip->attri_name;
>> +	args->namelen = attrp->alfi_name_len;
>> +	args->hashval = xfs_da_hashname(args->name, args->namelen);
>> +	args->attr_filter = attrp->alfi_attr_flags;
>> +
>> +	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
>> +		args->value = attrip->attri_value;
>> +		args->valuelen = attrp->alfi_value_len;
>> +		args->total = xfs_attr_calc_size(args, &local);
>> +
>> +		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
>> +				 M_RES(mp)->tr_attrsetrt.tr_logres *
>> +					args->total;
>> +		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>> +		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>> +		total = args->total;
>> +	} else {
>> +		tres = M_RES(mp)->tr_attrrm;
>> +		total = XFS_ATTRRM_SPACE_RES(mp);
>> +	}
>> +	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
>> +	if (error)
>> +		goto out;
>> +
>> +	args->trans = tp;
>> +	done_item = xfs_trans_get_attrd(tp, attrip);
>> +
>> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +	xfs_trans_ijoin(tp, ip, 0);
>> +
>> +	ret = xfs_trans_attr_finish_update(&attr->xattri_dac, done_item,
>> +					   &attr->xattri_dac.leaf_bp,
>> +					   attrp->alfi_op_flags);
>> +	if (ret == -EAGAIN) {
>> +		/* There's more work to do, so add it to this transaction */
>> +		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
>> +	} else
>> +		error = ret;
>> +
>> +	if (error) {
>> +		xfs_trans_cancel(tp);
>> +		goto out_unlock;
>> +	}
>> +
>> +	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list);
>> +
>> +out_unlock:
>> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> +	xfs_irele(ip);
>> +out:
>> +	if (ret != -EAGAIN)
>> +		kmem_free(attr);
>> +	return error;
>> +}
>> +
>> +/* Re-log an intent item to push the log tail forward. */
>> +static struct xfs_log_item *
>> +xfs_attri_item_relog(
>> +	struct xfs_log_item		*intent,
>> +	struct xfs_trans		*tp)
>> +{
>> +	struct xfs_attrd_log_item	*attrdp;
>> +	struct xfs_attri_log_item	*old_attrip;
>> +	struct xfs_attri_log_item	*new_attrip;
>> +	struct xfs_attri_log_format	*new_attrp;
>> +	struct xfs_attri_log_format	*old_attrp;
>> +	int				buffer_size;
>> +
>> +	old_attrip = ATTRI_ITEM(intent);
>> +	old_attrp = &old_attrip->attri_format;
>> +	buffer_size = old_attrp->alfi_value_len + old_attrp->alfi_name_len;
>> +
>> +	tp->t_flags |= XFS_TRANS_DIRTY;
>> +	attrdp = xfs_trans_get_attrd(tp, old_attrip);
>> +	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
>> +
>> +	new_attrip = xfs_attri_init(tp->t_mountp, buffer_size);
>> +	new_attrp = &new_attrip->attri_format;
>> +
>> +	new_attrp->alfi_ino = old_attrp->alfi_ino;
>> +	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
>> +	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
>> +	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
>> +	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
>> +
>> +	new_attrip->attri_name_len = old_attrip->attri_name_len;
>> +	new_attrip->attri_name = ((char *)new_attrip) +
>> +				 sizeof(struct xfs_attri_log_item);
>> +	memcpy(new_attrip->attri_name, old_attrip->attri_name,
>> +		new_attrip->attri_name_len);
>> +
>> +	new_attrip->attri_value_len = old_attrip->attri_value_len;
>> +	if (new_attrip->attri_value_len > 0) {
>> +		new_attrip->attri_value = new_attrip->attri_name +
>> +					  new_attrip->attri_name_len;
>> +
>> +		memcpy(new_attrip->attri_value, old_attrip->attri_value,
>> +		       new_attrip->attri_value_len);
>> +	}
>> +
>> +	xfs_trans_add_item(tp, &new_attrip->attri_item);
>> +	set_bit(XFS_LI_DIRTY, &new_attrip->attri_item.li_flags);
>> +
>> +	return &new_attrip->attri_item;
>> +}
>> +
>>   static const struct xfs_item_ops xfs_attri_item_ops = {
>>   	.iop_size	= xfs_attri_item_size,
>>   	.iop_format	= xfs_attri_item_format,
>>   	.iop_unpin	= xfs_attri_item_unpin,
>>   	.iop_committed	= xfs_attri_item_committed,
>>   	.iop_release    = xfs_attri_item_release,
>> +	.iop_recover	= xfs_attri_item_recover,
>>   	.iop_match	= xfs_attri_item_match,
>> +	.iop_relog	= xfs_attri_item_relog,
>>   };
>>   
>>   
>> -- 
>> 2.7.4
>>
