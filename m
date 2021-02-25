Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC2F0C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 07:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3725D64EDC
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 07:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhBYHCG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 02:02:06 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41428 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhBYHCB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 02:02:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6jdGg166914;
        Thu, 25 Feb 2021 07:01:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=snPMdFCU0fQcgX59Vrf+VNx2DRrb2huRRbaAFucOpiA=;
 b=aSuVSyN3bH612he+iD8GIICxZ+rQd6HGQZcFMTuIACAsbLujOL0jfEhCwcqQjDYsElqO
 XI28ygDqPV2P5EOh9RjNWsounFTOgpRs11t9ZbLrC4fTXy3vke+v7HO1FUDplKYGEmWn
 umC7/5L1hWeXgFAc561LKfiMwdWuNTFWRZMHdmN1BpRiEX4ZBeDJRtjLZ5XgeID5bXNJ
 gBPc4RBiVAbp3O1E5WQXMGR1bJPt2UCDMHI4XpPPWRQFAYO3rMX32YNvq7uBHenPtXoN
 51V4Zh8Uqt1wTc7WBcmxqW1T7Ql6zVHxSzClUOw+AZdPNevFnUsI6ITArLvORFgMKwL/ aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36tsur5ed8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 07:01:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6iaC5083949;
        Thu, 25 Feb 2021 07:01:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by userp3030.oracle.com with ESMTP id 36ucc0udxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 07:01:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7hd69MKs0EuWD+42HOMO0eTwp6KVBYF/obNiHLevTdhBB2BMB5xBeTqrTw3b2fdnqmnD1epvvQRhWlK3wNelr0iakKVL7gHYl7q+80RfgiitokVI/sNlB/jeL8K4Fldo3DMrqU7cA5ePD0/X63cNS+8lnNQJtWLxiHrqgCf2lu6F8oBPDcqQRa/KI6XY9TPTh+GOfBZZuU1GNCbfMfLl/I1Hs6ZIuY7t9YKez/gPvsMGen8qc3uYtX6zSDohzSK4jb6mmYF6eNsFxTFBr9g0ILcTmmt/ZKxKRqxUoQ3JbYpcfC+k6KJYsEnnUDH0Rwlqz4xQFqWIAFQ4T3iaIwDjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snPMdFCU0fQcgX59Vrf+VNx2DRrb2huRRbaAFucOpiA=;
 b=LoL64QvaU4zSuqNUuo88YH0+HFJkAsZ9eGY8XDnLkjjV11inH4V5+nZ7j+2LfX0xPTcofaRmSxUxQ6PJfQhD00CZQQN9DlhkzWKaXkIL5eexcF9BvoR4gM1WrwAT1SmDfXj2UKTfqzs2bJj+49op/HRFq40HbJmKtulNK7FUJfjDh9ch8V7WCralhkHhFAz1uYmvNNfYLFLjkRIGvbwLAEjkQOH9iu9Ukjp+jvCsUIxH0Oihl/xOvZjtB1OqJA7HyNtdJUrfNz8raUkUuwYav2IbEJv2fgrlefxL6W+9A/UjZZr0XT2nZNjRvtB9mWMN3HUfEU9LV5HXQPAEHBpZ2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snPMdFCU0fQcgX59Vrf+VNx2DRrb2huRRbaAFucOpiA=;
 b=QotV+tyPjXg/jwrJ2ZfU8eqxYcaeC1mtDp3ep1Hzh8zg5Chb9g4ss82V2ozxyz6f6jfvkjJox86hq5s5b6s9Plx0mXYete1hvGkR6DkuzsYwnqEt/yJVAOPYkD2754q36OJHwlTyWYEWH6GPSXI3xChziL+iZfyQqOlN5730N0g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2486.namprd10.prod.outlook.com (2603:10b6:a02:b8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Thu, 25 Feb
 2021 07:01:12 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.019; Thu, 25 Feb 2021
 07:01:11 +0000
Subject: Re: [PATCH v15 11/22] xfs: Add delay ready attr remove routines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-12-allison.henderson@oracle.com>
 <20210224184546.GL981777@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <b3639b95-9817-675b-909a-27f04eb46c11@oracle.com>
Date:   Thu, 25 Feb 2021 00:01:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210224184546.GL981777@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0202.namprd05.prod.outlook.com
 (2603:10b6:a03:330::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0202.namprd05.prod.outlook.com (2603:10b6:a03:330::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Thu, 25 Feb 2021 07:01:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ef28718-3a0a-4a91-644d-08d8d95b2277
X-MS-TrafficTypeDiagnostic: BYAPR10MB2486:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2486E67C493DD9A30F109E5B959E9@BYAPR10MB2486.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RA6sveuwm0mEi3/R1zTikjTRoH1KckNbKgYkSbPH8gbVdDtiVJHEbprVmNyCLSYvljrdswY1RYR8lD3tfm+u6OfqjWY1b/ZUyEjuldCFaeKSfdi+jeg1yX+iXw4yyrBCTC/y4lY/RsOrNnZ+URabcQIF3ImesLwp0Hrh7kMxzXNC+6fIILx+xHoHkDUZTzg9RKveZuaa7vDdJ8RyuDObtfBOnYPLm8/rGMAFqvbJ9xlJOiO/yediZQiFie5e9Zol81BoOEgyetQhNUTvKHAMpggv5t0OReigSyogaZLVK2LJc5Fcy7hC5EFwSOxgQSyfW6XEErmJ2sd/unboKtoyT3jDy9A9lz8bQ/TqVLRZ7WqZaVB0mkWAcU3mCSOOUJnfJ8TRnzAoXnVDpUxCoCZYHLB/hC+TpqXZFsCtGpfpyWPyT6V8+x9DK16faiYsHz5HI8equBZYorinRwZBM19i7M3A3uyqKfb10NKfu6w736HIHsnw++LCX6rLVOCoSGNfEI73dNZ+79w8v59bYAFNKJsRK8iPmiosu4JKBprYgV9e3ksyMsCExWaVN175cRdK1L6jKntKbnkVD6OuYN4GfXkWRNn1mUKDBFCjiFchrIY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(346002)(376002)(136003)(8936002)(5660300002)(44832011)(86362001)(36756003)(31686004)(16526019)(30864003)(8676002)(316002)(31696002)(186003)(66946007)(52116002)(66476007)(66556008)(478600001)(4326008)(83380400001)(53546011)(26005)(16576012)(6916009)(956004)(2906002)(2616005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Ly9BcjlRSnhNT1g3NzYvNFVDL0lzZ1VHRHBzSFllT1lFazNEYm01akVpWmZF?=
 =?utf-8?B?WGt3V2EvYnhkOHdUVWgvSjA2ZERYbkN1UGZOblU4WGIycXBJOHJoTmZ0bG8r?=
 =?utf-8?B?Ly9sZWpPRVdZc003eEF2cE9aUGFqY0VjNEptdEJ2UVBRZFlNb3gvWlI2T0pu?=
 =?utf-8?B?LzdlM0dzTGUrZllkR1FsNkVQWnVNUXlVRjcvL2xZUEY1akRaTkxtRzFOWHFv?=
 =?utf-8?B?VHFXRFQxZ0JHbXdoZ25uQjRGZHdGZTFmMmV6TzgzV1pXeERuS3VYWjF4aEZ6?=
 =?utf-8?B?N0lDOHNWTEdYMHJjcUhtYjVUU0NQcE1SbnZuZHNlT25ESDhSM29BVmtjWTRQ?=
 =?utf-8?B?S05yVmsxeW5CWUNSSWszdFNXRWlyUDVqSklnWnYyWHcwK0dTTEc0NXZ5ZmNa?=
 =?utf-8?B?YzVuOGlEb0x1Q3J0TFZRZHQ1UWVOUUNiSmp0OFNzU3lhU3JPdjJ0UDlxbkhP?=
 =?utf-8?B?WkJkd0Z3b04yTzFMK2VZMmJvR29SZUlJbVQrQW5PTnErUko4RXRLRCs5RDZU?=
 =?utf-8?B?d0tmMGd1cFJYOE9abWUwT05YRlkyMFFDYStFcWpTcDd6T012THAwVHo0YnF4?=
 =?utf-8?B?dStGdVZZQ1VQb0RMblc4cXF4aDFPK3FVTTJvaXdsRGkweGZrT3cwbURraHlS?=
 =?utf-8?B?TUJucTdhWDRxalpmUXphZEI1VjFyUUpMQlZYdjRlL3R3R2RRRmMwSmljU3JF?=
 =?utf-8?B?YXFnY0hUY24rditFM2hYSDcyVGo2WEZiZVpMcHN2ZXRldGJseHhLTmFLR2Vn?=
 =?utf-8?B?cXBFRUk1U2N6SURkaTZvN0xsYWFLOWtRTENiSVdnWmZhbzh5em0yOHhqOEhB?=
 =?utf-8?B?UU1RVlJ1Ky8wSXNWVlVIb01NOGFOS3hGeUNxKzVrbms0cjA3SWdjSEUzU1Ir?=
 =?utf-8?B?azR5ZVhnd3owZTYvK1BsUUIvU0ptc3p3c2c5U0JXY2Y1K3lqZHN2ZlBDQ0lF?=
 =?utf-8?B?OGhueFh3dmN2MnloaDdiWVVoa3kwbEErOWtnWVJLWFJDSzNQd2tpNCtocVZl?=
 =?utf-8?B?WGpPQUJFazlqNmhGb2trYis5VGFleW55WHN0bWc5N3h0ek5JMmJ4MlhGV2tM?=
 =?utf-8?B?OG0yRXpQUHVFZjA5RFVFMnJXTHZVRlg3NDltZGVqTTRqUEFsU3ZTM3UxMTVN?=
 =?utf-8?B?UTJ2SGJ1bGgrSzA1WitqY2JyRGF4MlIzVDBFRmJ2S1dtYnVsYVBVSnV3Z3FM?=
 =?utf-8?B?cThMV2V5aUxvVGpGU00zeS9XendsaGRiNCtITGpWMGdjbHR0S3A4N0pDaXZp?=
 =?utf-8?B?QUlxdFprZUs5OTkxYlFiVGhlWHpFVmhTYnZiRTRvYk5aaTJJSmJNdzhRdkww?=
 =?utf-8?B?WTZtZ1B6Nk5lK0FSdFhSOHkwaFJqcnBTTkoyYVlSZlZ5K1ZiSndWd1RScmls?=
 =?utf-8?B?dFFkQytqSitBRVBlanJNeWhjWDIzYkJZRWRBODFFNENId1hZRTNqVzdtbWFp?=
 =?utf-8?B?SUErdm4rRk93Q05IWE9yQ0NKYlN5VFB1TjdMVHAzMktJUGdEK0xrSnA2ejRY?=
 =?utf-8?B?Rk40K1ROOHhFOE9QbUJMWVdoN1VhT2d6UWtJQlBiUjROM3dIVTZFUndPdVRx?=
 =?utf-8?B?Yk8vNCs4b1FLdkxwOC9pZVJrcGorTnR4ZW1TWGQ2M0ZrNjZ1SVdGS24wNEd0?=
 =?utf-8?B?eHFVYmVEVHJJbGMyVnpscE1qbDZETUpDNVZ1TFliYlV1MldhZStMNjBYRUN2?=
 =?utf-8?B?UTNJbGZ6c2w4akkwU3lrdHVUQnl4alhnVnpHd0tMWndQUE5pZGtEb3R4aFlm?=
 =?utf-8?Q?SKYc2ZU+nToDPA/zV7v6kyvtSeOMZpgKbc0lv5k?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ef28718-3a0a-4a91-644d-08d8d95b2277
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 07:01:11.8188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iStFflL2+YwDNYLdft63NW/xUjXoXlzYR9B4m401VuD8+duXPsMlk4hjLfk5QxYuESJbTeiWvbFz7tp/f44xmJI6e6sXz6XOKJwrWVkVs8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2486
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250056
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250056
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/24/21 11:45 AM, Brian Foster wrote:
> On Thu, Feb 18, 2021 at 09:53:37AM -0700, Allison Henderson wrote:
>> This patch modifies the attr remove routines to be delay ready. This
>> means they no longer roll or commit transactions, but instead return
>> -EAGAIN to have the calling routine roll and refresh the transaction. In
>> this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
>> uses a sort of state machine like switch to keep track of where it was
>> when EAGAIN was returned. xfs_attr_node_removename has also been
>> modified to use the switch, and a new version of xfs_attr_remove_args
>> consists of a simple loop to refresh the transaction until the operation
>> is completed. A new XFS_DAC_DEFER_FINISH flag is used to finish the
>> transaction where ever the existing code used to.
>>
>> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
>> version __xfs_attr_rmtval_remove. We will rename
>> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
>> done.
>>
>> xfs_attr_rmtval_remove itself is still in use by the set routines (used
>> during a rename).  For reasons of preserving existing function, we
>> modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
>> set.  Similar to how xfs_attr_remove_args does here.  Once we transition
>> the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
>> used and will be removed.
>>
>> This patch also adds a new struct xfs_delattr_context, which we will use
>> to keep track of the current state of an attribute operation. The new
>> xfs_delattr_state enum is used to track various operations that are in
>> progress so that we know not to repeat them, and resume where we left
>> off before EAGAIN was returned to cycle out the transaction. Other
>> members take the place of local variables that need to retain their
>> values across multiple function recalls.  See xfs_attr.h for a more
>> detailed diagram of the states.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 223 +++++++++++++++++++++++++++++-----------
>>   fs/xfs/libxfs/xfs_attr.h        | 100 ++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>>   fs/xfs/libxfs/xfs_attr_remote.c |  48 +++++----
>>   fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
>>   fs/xfs/xfs_attr_inactive.c      |   2 +-
>>   6 files changed, 294 insertions(+), 83 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 56d4b56..d46b92a 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>> @@ -221,6 +221,34 @@ xfs_attr_is_shortform(
>>   		ip->i_afp->if_nextents == 0);
>>   }
>>   
>> +/*
>> + * Checks to see if a delayed attribute transaction should be rolled.  If so,
>> + * also checks for a defer finish.  Transaction is finished and rolled as
>> + * needed, and returns true of false if the delayed operation should continue.
>> + */
>> +int
>> +xfs_attr_trans_roll(
>> +	struct xfs_delattr_context	*dac)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	int				error;
>> +
>> +	if (dac->flags & XFS_DAC_DEFER_FINISH) {
>> +		/*
>> +		 * The caller wants us to finish all the deferred ops so that we
>> +		 * avoid pinning the log tail with a large number of deferred
>> +		 * ops.
>> +		 */
>> +		dac->flags &= ~XFS_DAC_DEFER_FINISH;
>> +		error = xfs_defer_finish(&args->trans);
>> +		if (error)
>> +			return error;
> 
> No need for the error check here.
Sure, will clean up

> 
>> +	} else
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +
>> +	return error;
>> +}
>> +
>>   STATIC int
>>   xfs_attr_set_fmt(
>>   	struct xfs_da_args	*args)
>> @@ -531,23 +559,58 @@ xfs_has_attr(
>>    */
>>   int
>>   xfs_attr_remove_args(
>> -	struct xfs_da_args      *args)
>> +	struct xfs_da_args	*args)
>>   {
>> -	struct xfs_inode	*dp = args->dp;
>> -	int			error;
>> +	int				error;
>> +	struct xfs_delattr_context	dac = {
>> +		.da_args	= args,
>> +	};
>> +
>> +	do {
>> +		error = xfs_attr_remove_iter(&dac);
>> +		if (error != -EAGAIN)
>> +			break;
>> +
>> +		error = xfs_attr_trans_roll(&dac);
>> +		if (error)
>> +			return error;
>> +
>> +	} while (true);
>> +
>> +	return error;
>> +}
>> +
>> +/*
>> + * Remove the attribute specified in @args.
>> + *
>> + * This function may return -EAGAIN to signal that the transaction needs to be
>> + * rolled.  Callers should continue calling this function until they receive a
>> + * return value other than -EAGAIN.
>> + */
>> +int
>> +xfs_attr_remove_iter(
>> +	struct xfs_delattr_context	*dac)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_inode		*dp = args->dp;
>>   
>> -	if (!xfs_inode_hasattr(dp)) {
>> -		error = -ENOATTR;
>> -	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
>> +	/* If we are shrinking a node, resume shrink */
>> +	if (dac->dela_state == XFS_DAS_RM_SHRINK)
>> +		goto node;
>> +
>> +	if (!xfs_inode_hasattr(dp))
>> +		return -ENOATTR;
>> +
>> +	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
>>   		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>> -		error = xfs_attr_shortform_remove(args);
>> -	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> -		error = xfs_attr_leaf_removename(args);
>> -	} else {
>> -		error = xfs_attr_node_removename(args);
>> +		return xfs_attr_shortform_remove(args);
>>   	}
>>   
>> -	return error;
>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +		return xfs_attr_leaf_removename(args);
>> +node:
>> +	/* If we are not short form or leaf, then proceed to remove node */
>> +	return  xfs_attr_node_removename_iter(dac);
> 
> Extra whitespace before the function name;
Ok, will fix

> 
> Also, can we lift xfs_attr_node_removename_iter() into this function,
> form the current implementation of xfs_attr_remove_iter() into the
> UNINIT state, and move the current UNINIT state into a new RMT_BLK state
> to support reentry? ISTM that would condense everything to a single
> switch statement that can live inside xfs_attr_remove_iter(). IOW, we
> can kill off the 'node:' level and multi-layer state management here.
> Hm?
Sure, I think the lift should be fine, though I dont think we'll need 
the extra state.  See below....

> 
>>   }
>>   
>>   /*
> ...
>> @@ -1207,22 +1272,28 @@ int xfs_attr_node_removename_setup(
>>   	if (args->rmtblkno > 0) {
>>   		error = xfs_attr_leaf_mark_incomplete(args, *state);
>>   		if (error)
>> -			return error;
>> +			goto out;
>>   
>> -		return xfs_attr_rmtval_invalidate(args);
>> +		error = xfs_attr_rmtval_invalidate(args);
>>   	}
>> +out:
>> +	if (error)
>> +		xfs_da_state_free(*state);
>>   
>>   	return 0;
>>   }
>>   
>>   STATIC int
>> -xfs_attr_node_remove_rmt(
>> -	struct xfs_da_args	*args,
>> -	struct xfs_da_state	*state)
>> +xfs_attr_node_remove_rmt (
> 
> Extra whitespace before the opening brace.
ok, will fix

> 
>> +	struct xfs_delattr_context	*dac,
>> +	struct xfs_da_state		*state)
>>   {
>> -	int			error = 0;
>> +	int				error = 0;
>>   
>> -	error = xfs_attr_rmtval_remove(args);
>> +	/*
>> +	 * May return -EAGAIN to request that the caller recall this function
>> +	 */
>> +	error = __xfs_attr_rmtval_remove(dac);
>>   	if (error)
>>   		return error;
>>   
> ...
>> @@ -1285,51 +1365,74 @@ xfs_attr_node_remove_step(
>>    *
>>    * This routine will find the blocks of the name to remove, remove them and
>>    * shrink the tree if needed.
>> + *
>> + * This routine is meant to function as either an inline or delayed operation,
>> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
>> + * functions will need to handle this, and recall the function until a
>> + * successful error code is returned.
>>    */
>>   STATIC int
>> -xfs_attr_node_removename(
>> -	struct xfs_da_args	*args)
>> +xfs_attr_node_removename_iter(
>> +	struct xfs_delattr_context	*dac)
>>   {
>> -	struct xfs_da_state	*state = NULL;
>> -	int			retval, error;
>> -	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_state		*state = NULL;
>> +	int				retval, error;
>> +	struct xfs_inode		*dp = args->dp;
>>   
>>   	trace_xfs_attr_node_removename(args);
>>   
>> -	error = xfs_attr_node_removename_setup(args, &state);
>> -	if (error)
>> -		goto out;
>> -
>> -	error = xfs_attr_node_remove_step(args, state);
>> -	if (error)
>> -		goto out;
>> -
>> -	retval = xfs_attr_node_remove_cleanup(args, state);
>> -
>> -	/*
>> -	 * Check to see if the tree needs to be collapsed.
>> -	 */
>> -	if (retval && (state->path.active > 1)) {
>> -		error = xfs_da3_join(state);
>> -		if (error)
>> -			goto out;
>> -		error = xfs_defer_finish(&args->trans);
>> +	if (!dac->da_state) {
>> +		error = xfs_attr_node_removename_setup(dac);
>>   		if (error)
>>   			goto out;
>> +	}
>> +	state = dac->da_state;
>> +
>> +	switch (dac->dela_state) {
>> +	case XFS_DAS_UNINIT:
>>   		/*
>> -		 * Commit the Btree join operation and start a new trans.
>> +		 * repeatedly remove remote blocks, remove the entry and join.
>> +		 * returns -EAGAIN or 0 for completion of the step.
>>   		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> +		error = xfs_attr_node_remove_step(dac);
>>   		if (error)
>> -			goto out;
>> -	}
>> +			break;
> 
> Hmm.. so re: my comment further down on xfs_attr_rmtval_remove(),
> wouldn't that change semantics here? I.e., once remote blocks are
> removed this would previously carry on with a clean transaction. Now it
> looks like we'd carry on with the dirty transaction that removed the
> last remote extent. This suggests that perhaps we should return once
> more and fall into a new state to remove the name..? 
I suspect the diff might be making this a bit difficult to see.  The 
roll that you see being removed here belongs to the transaction we 
hoisted up  in patch 3 which happens after the clean up below, and we 
have the corresponding EAGAIN fot that one.  I think the diff gets 
things a little interlaced here because the switch adds another level of 
indentation.

some times i do like to I use a graphical diffviewer like diffuse when 
patches get weird like this.  Something like this:

git config --global diff.tool  diffuse
git difftool 3c53e49 e201c09

You'd need to download the branch and also the diffuse tool, but 
sometimes i think it makes some of these diffs a bit easier to see

Also, it would be
> nice to remove the several seemingly unnecessary layers of indirection
> here. For example, something like the following (also considering my
> comment above wrt to xfs_attr_remove_iter() and UNINIT):
> 
> 	case UNINIT:
> 		...
> 		/* fallthrough */
> 	case RMTBLK:
> 		if (args->rmtblkno > 0) {
> 			dac->dela_state = RMTBLK;
> 			error = __xfs_attr_rmtval_remove(dac);
> 			if (error)
> 				break;
> 
> 			ASSERT(args->rmtblkno == 0);
> 			xfs_attr_refillstate(state);
> 			dac->flags |= XFS_DAC_DEFER_FINISH;
> 			dac->dela_state = RMNAME;
> 			return -EAGAIN;
> 		}
Ok, this looks to me like we've hoisted both xfs_attr_node_remove_rmt 
and xfs_attr_node_remove_step into this scope, but I still think this 
adds an extra roll where non previously was.  With out that extra 
EAGAIN, I think we are fine to have all that just under the UNINIT case. 
  I also think it's also worth noteing here that this is kind of a 
reverse of patch 1, which I think we put in for reasons of trying to 
modularize the higher level functions as much as possible.

I suspect some of where you were going with this may have been 
influenced by the earlier diff confusion too.  Maybe take a second look 
there before we go too much down this change....


> 		/* fallthrough */
> 	case RMNAME:
> 		...
> 	...
> 
>>   
>> -	/*
>> -	 * If the result is small enough, push it all into the inode.
>> -	 */
>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> -		error = xfs_attr_node_shrink(args, state);
>> +		retval = xfs_attr_node_remove_cleanup(args, state);
>>   
> ...
I think the overlooked EAGAIN was in this area that got clipped out.....

>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 48d8e9c..f09820c 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> ...
>> @@ -685,31 +687,29 @@ c(
>>   	 * Keep de-allocating extents until the remote-value region is gone.
>>   	 */
>>   	do {
>> -		retval = __xfs_attr_rmtval_remove(args);
>> -		if (retval && retval != -EAGAIN)
>> -			return retval;
>> +		error = __xfs_attr_rmtval_remove(&dac);
>> +		if (error != -EAGAIN)
>> +			break;
> 
> Previously this would roll once and exit the loop on retval == 0. Now it
> looks like we break out of the loop immediately. Why the change?

Gosh, I think sometime in reviewing v9, we had come up with a 
"xfs_attr_roll_again" helper that took the error code as a paramater and 
decided whether or not to roll.  And then in v10 i think people thought 
that was weird and we turned it into xfs_attr_trans_roll.  I think I 
likley forgot to restore the orginal retval handling here.  This whole 
function disappears in the next patch, but the original error handling 
should be restored to keep things consistent. Thx for the catch!


Thx for the reviews!!  I know it's complicated!  I've chased my tail 
many times with it myself :-)

Allison




> 
> Brian
> 
>>   
>> -		/*
>> -		 * Close out trans and start the next one in the chain.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		error = xfs_attr_trans_roll(&dac);
>>   		if (error)
>>   			return error;
>> -	} while (retval == -EAGAIN);
>> +	} while (true);
>>   
>> -	return 0;
>> +	return error;
>>   }
>>   
>>   /*
>>    * Remove the value associated with an attribute by deleting the out-of-line
>> - * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
>> + * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
>>    * transaction and re-call the function
>>    */
>>   int
>>   __xfs_attr_rmtval_remove(
>> -	struct xfs_da_args	*args)
>> +	struct xfs_delattr_context	*dac)
>>   {
>> -	int			error, done;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	int				error, done;
>>   
>>   	/*
>>   	 * Unmap value blocks for this attr.
>> @@ -719,12 +719,20 @@ __xfs_attr_rmtval_remove(
>>   	if (error)
>>   		return error;
>>   
>> -	error = xfs_defer_finish(&args->trans);
>> -	if (error)
>> -		return error;
>> -
>> -	if (!done)
>> +	/*
>> +	 * We dont need an explicit state here to pick up where we left off.  We
>> +	 * can figure it out using the !done return code.  Calling function only
>> +	 * needs to keep recalling this routine until we indicate to stop by
>> +	 * returning anything other than -EAGAIN. The actual value of
>> +	 * attr->xattri_dela_state may be some value reminicent of the calling
>> +	 * function, but it's value is irrelevant with in the context of this
>> +	 * function.  Once we are done here, the next state is set as needed
>> +	 * by the parent
>> +	 */
>> +	if (!done) {
>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>   		return -EAGAIN;
>> +	}
>>   
>>   	return error;
>>   }
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index 9eee615..002fd30 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>   		xfs_buf_flags_t incore_flags);
>>   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>> -int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
>> +int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>>   #endif /* __XFS_ATTR_REMOTE_H__ */
>> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
>> index bfad669..aaa7e66 100644
>> --- a/fs/xfs/xfs_attr_inactive.c
>> +++ b/fs/xfs/xfs_attr_inactive.c
>> @@ -15,10 +15,10 @@
>>   #include "xfs_da_format.h"
>>   #include "xfs_da_btree.h"
>>   #include "xfs_inode.h"
>> +#include "xfs_attr.h"
>>   #include "xfs_attr_remote.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_bmap.h"
>> -#include "xfs_attr.h"
>>   #include "xfs_attr_leaf.h"
>>   #include "xfs_quota.h"
>>   #include "xfs_dir2.h"
>> -- 
>> 2.7.4
>>
> 
