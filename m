Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07178C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAF8C64EDB
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhB0A55 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 19:57:57 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:59012 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhB0A5y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Feb 2021 19:57:54 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0j5Zu105586;
        Sat, 27 Feb 2021 00:57:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=FST245kd+tuk++sP7NKVeznaPhPq9aDZgYLamWys3K0=;
 b=TUpNjxNWgRnO+QeoJ/fLBjXBrtJtCh/a8v1+RWXtF4C75lUGLQB8s+qYy65dFYWWOm3D
 R9uuFTR1Cf8yvFPr31MtWEjMbhaoICqm6b0WL75KGxYybxHwbDjyte5hy2ERU0n/Pb95
 +B63MMbGF9Nr6697U2c1RZ+vERItXl8JxJYdt7X0ri/MPxW7tgYD+5glpU/hnu4U1rA7
 urXwvg8qJBdsfnB3QDnEjflvhRVIqTLOwRCyslmGqgcVz+X/DHkF7qs3GOnyhvGAZof1
 nBcDNBThB+CaFUkAoKK9m1wkeVHQgbmXzBZ+fAyScml9wg46DyLH9ABEMh2npJFOZ3Hc eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36ybkb00p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:57:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0isqt174950;
        Sat, 27 Feb 2021 00:57:09 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3030.oracle.com with ESMTP id 36yb6rs2k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:57:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UViI2eKJHxwWTroDNBH2zH8Ds2at7TzXp/bzHNzsWdGyv1okeV79J3TYh0GzB3+p278g3v2d8634z6XOO8tFteC3aXI/OW4IjKIRcCDLw7AcQcGZYTaLlzrFXPamLNmzC37JnjgdoQeD+uvUSHLnHpxFsn4Dhz06NbQEcDKvpBiKz2b3PhkrM0g4lc3PTexa7+88E91cLhP/gkLky3gmrRUB6A2oqNJaeJvcClXYgu98Yy2RQqdl/6iL6T1zx92PvoDjzqAtzikgAJjWo1pvA+zSD+1i8c1fMUucU0KLL4XaAvAz9KOwcXLC4ZHyKsL4OS22zPmD520sr5d0+qVVig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FST245kd+tuk++sP7NKVeznaPhPq9aDZgYLamWys3K0=;
 b=XTIjGgFMsSu0WWBUe93deOMJs31m7wr/kJchPByC7umBr4cPZhPMQTW9BXqI69xnB/mlixyPb93mosqucPLdyRiauHlqOZ0hWik9yu9ozmOpMX7Qsn0Tc3a+Q3pY81TiiJu2Z/QNTJnsFPPdZ5VsfUvnSlPUeO7hRbjG5ep/s0SasQL3A0gl8KUDVFgUxsOn1HVf5mve5RlGkKmm+xhVwNROBinOpecvpi2mY2xeefdxDgoDuPFOOIq6OGRJl7kyjY5wE5FS5nyc314OLT6cCL8yMcXAFXI7Byu36Ls/Enjd5gMrgpCiNBpmB5zSYpMkjuD0fPe+ZuAxbZvZ8ojXow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FST245kd+tuk++sP7NKVeznaPhPq9aDZgYLamWys3K0=;
 b=d+wEGQh/kFNxMZL32fiH4DrNG87M/LZbOpzqXuhAb7K0a2cO2WQ9yqB11G6y1Ama7nhGct6RSkK5b5d8//uZ/lG/ZbiUGJ7fEc0CuC/WLS8f8sdMEQC01gw39lok4ecUZcI8s734CkVx2IL9HlZuZb/jXRhq41TmawP6QSEhQqc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3858.namprd10.prod.outlook.com (2603:10b6:a03:1b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Sat, 27 Feb
 2021 00:57:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.020; Sat, 27 Feb 2021
 00:57:07 +0000
Subject: Re: [PATCH v15 19/22] xfs: Remove unused xfs_attr_*_args
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-20-allison.henderson@oracle.com>
 <20210226045855.GX7272@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <e9a5308e-9a1b-bbb7-a971-16406692dad7@oracle.com>
Date:   Fri, 26 Feb 2021 17:57:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210226045855.GX7272@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0198.namprd05.prod.outlook.com
 (2603:10b6:a03:330::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0198.namprd05.prod.outlook.com (2603:10b6:a03:330::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.11 via Frontend Transport; Sat, 27 Feb 2021 00:57:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f5e7ded-4936-430d-f3ed-08d8daba9b2d
X-MS-TrafficTypeDiagnostic: BY5PR10MB3858:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3858A653E5823E0E9AECD1E8959C9@BY5PR10MB3858.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mw8/gSLK/6IhP5OPqB47GSEgzlQ7Dt8enbWxnT9fvZ/rGhvhbjULszrVg0kHCj8gZV7KG4hIKK7XXBcCMX8N+KECiiNLD2j9CcarAQO436NJki2VyfJGyTSA8GBnCqd97G4AgJEj8H9ORwWhIdRTmQqfJM5c/Umfdr/2Zj5kPn8n2JzpDNNIhxmfAQXy7oulGxb6eKDFH0ToPRAnN6HTYgjMK87Zt5aScZUEBlGiLsJlkLLzUz9aXEJnDuK2qhRYpuilqbVdib464CNyuS954YswPhCT3D3aLjljFhLqPSCEi/XIbPdULFLRSLH501nLcNqyKscg+0fYsbOeanTAenV38Fk/d7ak8kxSZD/kv33bc+G4JpST5MmNxJAUaRy7el197kuS7jhJCkVccAlwySy17hCogV5HhrxUEEkTz96lg9jKZ7upmB3DGxZhNmNMKqBmEgQADd7hNCt3ZyUIEwnuSOUNK6c6LXfryenh3myASb0lw6LSix/evXjjsKwyeR+2RC9byswK+H8PjrlS8iimkQAGMMDNwHCYLLALaKYuh8EsRgwA0OaUsID8v/NmBOIZqtQrerOi7lx3bKpA6caAYP8bhKGSN4jwSQJAObE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(346002)(376002)(52116002)(478600001)(6916009)(86362001)(4326008)(2906002)(31696002)(83380400001)(5660300002)(6486002)(316002)(66556008)(66476007)(36756003)(16576012)(186003)(8676002)(26005)(16526019)(956004)(2616005)(44832011)(31686004)(53546011)(8936002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YUdUWHBjU1FDTmtMckZZZUlZTFJBb0NKcW1oc1RwM3k2TE55Z3ZBK0JHcm5J?=
 =?utf-8?B?UHFYWDhpMEhHRzltQzZ3eWpid1NnMEp5UVprRFMvNEpnQThQclE2WHdHL3No?=
 =?utf-8?B?MWpRS2RCOTdheVhKUlZ4WnZWRGVzTTZXQmtvOXl5eDZQc3NoeEFGYWxSa0tW?=
 =?utf-8?B?YkFrZE9nSG43bzI4TnBKbTlYeGRDYlpoR1BiOVlJb1F0dzFDbzV4aTRhN2Jt?=
 =?utf-8?B?SE1rUzcyWlphV2ZGcXk4K3NqNzFGdkdueWwzbjVsZnk2Tk14RjloR0ppaWVV?=
 =?utf-8?B?SHMvR2x1bEJidzhtMjZCOWlqYzdBaSthb0dwVkw3SFoyZHpYUXN5QTJBZGJs?=
 =?utf-8?B?cnNPZ1VETW9LSWM4V1hyc3ZIMnNwTGxTeHJCdjZZZGt1Rm9KYUNycjZzOWFK?=
 =?utf-8?B?NjJINVlLa1ltbVVvcEVmeEZqb2ZiRExsdmltTjZxYkJuSSs4djBzU2hUeTZn?=
 =?utf-8?B?Ky9laTRJRi9pRDQ0N0RtZUd6ODlBNlFRQXgxTjh2V2xCdUpZMTV5Z0hXcXJ1?=
 =?utf-8?B?UHVlR0RNeEpIZDM1WDRSd3hHWWJDbVZoeFN6Vm1OMk9TMU96TnMzYk9XRWc1?=
 =?utf-8?B?M2dwZXpoTzFvUnoxUExCaGJOSW9wb0g4SjVwSkFqS0d6QUZ5YjRlZlJJZE9F?=
 =?utf-8?B?TkMyaUNxNFZHUnh2dUFUMkxESndnSVFlNG42THZIdkZTcW5TRmdkbEhwekhy?=
 =?utf-8?B?K29DS01tWHFCdEVDa1BzMXQ0aDJTREVoZGNJR01QSGw4NFpzWFJYaVhwVGpL?=
 =?utf-8?B?Y3VMQzVseitxV0MyYTBaYTdLMGVhODZXSmN1OXlpUXo5aTV6dnA0MHNLZHJl?=
 =?utf-8?B?cVBsdlMvQlNlcU5FTENtL2EyWWhoVzg5SlZMdWRsSk1kdGs0aHZBekpYWERN?=
 =?utf-8?B?SHZiS0h3M0JPbjVXOVBRU3Z1bHBSOEt0MXFEeGduREQ0NWFGT2RCalRlWmhu?=
 =?utf-8?B?Mko3bExiWVI5MVUwNWJCc1pha1dTQkpLT1RLM3ZQSDh1Rk93T3B5SG03L1Qv?=
 =?utf-8?B?b3NGMmV6Y0ZpOXJPNHJ6VlpIR1FUUkw4djMyVDlPbXNxa2NCY2FQaFRLaCtm?=
 =?utf-8?B?Um81UXpKR2NaS1Z6Nko0aEErcTNvY2ZpdGVOeTE2dE0zMmVSWkJvT0Y3bEZT?=
 =?utf-8?B?Slc2bGhaNUpGWkIrMDBYdEhFRHRuRnJYbGlPbVg5cklqbWhaWDBqQ0Zta3V2?=
 =?utf-8?B?NnpaSDNkRmFsWmljVnpkRzlIME1HbVdua1NBTEhvclZhK2JmaVQ5eXFaN0Q3?=
 =?utf-8?B?d0loMVJVWHJQWW1DNEtsbWZwclA5OExxbmtwQzhtanVHbEtMVTUyeE9pSGtM?=
 =?utf-8?B?enl6NU16U28wMGpTY1RJTFZjMjNPWkdMc21nWHBBVHNBRDJTK09uRDk1NlNI?=
 =?utf-8?B?cmJHVHphSCtReUlOQVNvOXV2YkxnUXFQR2ZJVFdldytIZXBEQm8yT3hocHpp?=
 =?utf-8?B?R1ZYRGx4VHpjZTNTcFFCQ0RLeTQxMEZNWkNvTmExaFJOcnlGR1NMdUNYeHhx?=
 =?utf-8?B?WTk4QlNOSXBzMjB2bDFXaHdpbnFzNWZNUXFXOW1OUStwdTh4clpNUmN4SXlU?=
 =?utf-8?B?S2ZDTGE5cGxVNmlqRWgrTFlaQlN4d1d0UXAwZk40WXIxcm9sdDhJenlKM0pF?=
 =?utf-8?B?WERIUU9HamVtVk5oNThDRWlnaHgzWU1JL1FWMmpBWnJtQmc0U21HdlVybXFi?=
 =?utf-8?B?SThjWURSdExjclRlMm91MTA5SHd5cm9haldwVmxXcmJEWW0vQ3FESVNWSHcr?=
 =?utf-8?Q?bS6Gs15ZAoA3czvF+5MuK5OswIkL7ec1DW0rjVa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f5e7ded-4936-430d-f3ed-08d8daba9b2d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 00:57:07.6053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GUhbzjSxzk36yqyf6ZnpknkXcMkZl2rtgxh+rQcrFfRs2jEWOBZzTReoQ5sRW8p2zRhIslB5s/IVXVd/7dPz2oBrPbksHkdmAZB4YaoRTzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3858
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270001
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/21 9:58 PM, Darrick J. Wong wrote:
> On Thu, Feb 18, 2021 at 09:53:45AM -0700, Allison Henderson wrote:
>> Remove xfs_attr_set_args, xfs_attr_remove_args, and xfs_attr_trans_roll.
>> These high level loops are now driven by the delayed operations code,
>> and can be removed.
>>
>> Additionally collapse in the leaf_bp parameter of xfs_attr_set_iter
>> since we only have one caller that passes dac->leaf_bp
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> 
> Looks good to me,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
Great, thanks!
Allison

> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 97 +++--------------------------------------
>>   fs/xfs/libxfs/xfs_attr.h        | 10 ++---
>>   fs/xfs/libxfs/xfs_attr_remote.c |  1 -
>>   fs/xfs/xfs_attr_item.c          |  8 ++--
>>   4 files changed, 11 insertions(+), 105 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index cec861e..8b62447 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -63,8 +63,6 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>> -int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>> -		      struct xfs_buf **leaf_bp);
>>   
>>   int
>>   xfs_inode_hasattr(
>> @@ -223,67 +221,13 @@ xfs_attr_is_shortform(
>>   		ip->i_afp->if_nextents == 0);
>>   }
>>   
>> -/*
>> - * Checks to see if a delayed attribute transaction should be rolled.  If so,
>> - * also checks for a defer finish.  Transaction is finished and rolled as
>> - * needed, and returns true of false if the delayed operation should continue.
>> - */
>> -STATIC int
>> -xfs_attr_trans_roll(
>> -	struct xfs_delattr_context	*dac)
>> -{
>> -	struct xfs_da_args		*args = dac->da_args;
>> -	int				error;
>> -
>> -	if (dac->flags & XFS_DAC_DEFER_FINISH) {
>> -		/*
>> -		 * The caller wants us to finish all the deferred ops so that we
>> -		 * avoid pinning the log tail with a large number of deferred
>> -		 * ops.
>> -		 */
>> -		dac->flags &= ~XFS_DAC_DEFER_FINISH;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>> -	} else
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -
>> -	return error;
>> -}
>> -
>> -/*
>> - * Set the attribute specified in @args.
>> - */
>> -int
>> -xfs_attr_set_args(
>> -	struct xfs_da_args		*args)
>> -{
>> -	struct xfs_buf			*leaf_bp = NULL;
>> -	int				error = 0;
>> -	struct xfs_delattr_context	dac = {
>> -		.da_args	= args,
>> -	};
>> -
>> -	do {
>> -		error = xfs_attr_set_iter(&dac, &leaf_bp);
>> -		if (error != -EAGAIN)
>> -			break;
>> -
>> -		error = xfs_attr_trans_roll(&dac);
>> -		if (error)
>> -			return error;
>> -	} while (true);
>> -
>> -	return error;
>> -}
>> -
>>   STATIC int
>>   xfs_attr_set_fmt(
>> -	struct xfs_delattr_context	*dac,
>> -	struct xfs_buf			**leaf_bp)
>> +	struct xfs_delattr_context	*dac)
>>   {
>>   	struct xfs_da_args		*args = dac->da_args;
>>   	struct xfs_inode		*dp = args->dp;
>> +	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
>>   	int				error = 0;
>>   
>>   	/*
>> @@ -316,7 +260,6 @@ xfs_attr_set_fmt(
>>   	 * add.
>>   	 */
>>   	trace_xfs_attr_set_fmt_return(XFS_DAS_UNINIT, args->dp);
>> -	dac->flags |= XFS_DAC_DEFER_FINISH;
>>   	return -EAGAIN;
>>   }
>>   
>> @@ -329,10 +272,10 @@ xfs_attr_set_fmt(
>>    */
>>   int
>>   xfs_attr_set_iter(
>> -	struct xfs_delattr_context	*dac,
>> -	struct xfs_buf			**leaf_bp)
>> +	struct xfs_delattr_context	*dac)
>>   {
>>   	struct xfs_da_args              *args = dac->da_args;
>> +	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
>>   	struct xfs_inode		*dp = args->dp;
>>   	struct xfs_buf			*bp = NULL;
>>   	struct xfs_da_state		*state = NULL;
>> @@ -344,7 +287,7 @@ xfs_attr_set_iter(
>>   	switch (dac->dela_state) {
>>   	case XFS_DAS_UNINIT:
>>   		if (xfs_attr_is_shortform(dp))
>> -			return xfs_attr_set_fmt(dac, leaf_bp);
>> +			return xfs_attr_set_fmt(dac);
>>   
>>   		/*
>>   		 * After a shortform to leaf conversion, we need to hold the
>> @@ -381,7 +324,6 @@ xfs_attr_set_iter(
>>   				 * be a node, so we'll fall down into the node
>>   				 * handling code below
>>   				 */
>> -				dac->flags |= XFS_DAC_DEFER_FINISH;
>>   				trace_xfs_attr_set_iter_return(
>>   					dac->dela_state, args->dp);
>>   				return -EAGAIN;
>> @@ -687,32 +629,6 @@ xfs_has_attr(
>>   
>>   /*
>>    * Remove the attribute specified in @args.
>> - */
>> -int
>> -xfs_attr_remove_args(
>> -	struct xfs_da_args	*args)
>> -{
>> -	int				error;
>> -	struct xfs_delattr_context	dac = {
>> -		.da_args	= args,
>> -	};
>> -
>> -	do {
>> -		error = xfs_attr_remove_iter(&dac);
>> -		if (error != -EAGAIN)
>> -			break;
>> -
>> -		error = xfs_attr_trans_roll(&dac);
>> -		if (error)
>> -			return error;
>> -
>> -	} while (true);
>> -
>> -	return error;
>> -}
>> -
>> -/*
>> - * Remove the attribute specified in @args.
>>    *
>>    * This function may return -EAGAIN to signal that the transaction needs to be
>>    * rolled.  Callers should continue calling this function until they receive a
>> @@ -1297,7 +1213,6 @@ xfs_attr_node_addname(
>>   			 * this. dela_state is still unset by this function at
>>   			 * this point.
>>   			 */
>> -			dac->flags |= XFS_DAC_DEFER_FINISH;
>>   			trace_xfs_attr_node_addname_return(
>>   					dac->dela_state, args->dp);
>>   			return -EAGAIN;
>> @@ -1312,7 +1227,6 @@ xfs_attr_node_addname(
>>   		error = xfs_da3_split(state);
>>   		if (error)
>>   			goto out;
>> -		dac->flags |= XFS_DAC_DEFER_FINISH;
>>   	} else {
>>   		/*
>>   		 * Addition succeeded, update Btree hashvals.
>> @@ -1599,7 +1513,6 @@ xfs_attr_node_removename_iter(
>>   			if (error)
>>   				goto out;
>>   
>> -			dac->flags |= XFS_DAC_DEFER_FINISH;
>>   			dac->dela_state = XFS_DAS_RM_SHRINK;
>>   			trace_xfs_attr_node_removename_iter_return(
>>   					dac->dela_state, args->dp);
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 4abf02c..f82c0b1 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -393,9 +393,8 @@ enum xfs_delattr_state {
>>   /*
>>    * Defines for xfs_delattr_context.flags
>>    */
>> -#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
>> -#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
>> -#define XFS_DAC_DELAYED_OP_INIT		0x04 /* delayed operations init*/
>> +#define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
>> +#define XFS_DAC_DELAYED_OP_INIT		0x02 /* delayed operations init*/
>>   
>>   /*
>>    * Context used for keeping track of delayed attribute operations
>> @@ -452,11 +451,8 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
>>   int xfs_attr_get_ilocked(struct xfs_da_args *args);
>>   int xfs_attr_get(struct xfs_da_args *args);
>>   int xfs_attr_set(struct xfs_da_args *args);
>> -int xfs_attr_set_args(struct xfs_da_args *args);
>> -int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>> -		      struct xfs_buf **leaf_bp);
>> +int xfs_attr_set_iter(struct xfs_delattr_context *dac);
>>   int xfs_has_attr(struct xfs_da_args *args);
>> -int xfs_attr_remove_args(struct xfs_da_args *args);
>>   int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>>   bool xfs_attr_namecheck(const void *name, size_t length);
>>   void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index b6554a3..78bb552 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -762,7 +762,6 @@ xfs_attr_rmtval_remove(
>>   	 * by the parent
>>   	 */
>>   	if (!done) {
>> -		dac->flags |= XFS_DAC_DEFER_FINISH;
>>   		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
>>   		return -EAGAIN;
>>   	}
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> index 8c8f72d..13b289b 100644
>> --- a/fs/xfs/xfs_attr_item.c
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -291,7 +291,6 @@ int
>>   xfs_trans_attr(
>>   	struct xfs_delattr_context	*dac,
>>   	struct xfs_attrd_log_item	*attrdp,
>> -	struct xfs_buf			**leaf_bp,
>>   	uint32_t			op_flags)
>>   {
>>   	struct xfs_da_args		*args = dac->da_args;
>> @@ -304,7 +303,7 @@ xfs_trans_attr(
>>   	switch (op_flags) {
>>   	case XFS_ATTR_OP_FLAGS_SET:
>>   		args->op_flags |= XFS_DA_OP_ADDNAME;
>> -		error = xfs_attr_set_iter(dac, leaf_bp);
>> +		error = xfs_attr_set_iter(dac);
>>   		break;
>>   	case XFS_ATTR_OP_FLAGS_REMOVE:
>>   		ASSERT(XFS_IFORK_Q(args->dp));
>> @@ -428,8 +427,7 @@ xfs_attr_finish_item(
>>   	 */
>>   	dac->da_args->trans = tp;
>>   
>> -	error = xfs_trans_attr(dac, done_item, &dac->leaf_bp,
>> -			       attr->xattri_op_flags);
>> +	error = xfs_trans_attr(dac, done_item, attr->xattri_op_flags);
>>   	if (error != -EAGAIN)
>>   		kmem_free(attr);
>>   
>> @@ -625,7 +623,7 @@ xfs_attri_item_recover(
>>   	xfs_trans_ijoin(args.trans, ip, 0);
>>   
>>   	error = xfs_trans_attr(&attr.xattri_dac, done_item,
>> -			       &attr.xattri_dac.leaf_bp, attrp->alfi_op_flags);
>> +			       attrp->alfi_op_flags);
>>   	if (error == -EAGAIN) {
>>   		/*
>>   		 * There's more work to do, so make a new xfs_attr_item and add
>> -- 
>> 2.7.4
>>
