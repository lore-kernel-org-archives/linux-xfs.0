Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734FDC433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2CF161477
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbhCCDJv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:09:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57410 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837947AbhCBJPs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 04:15:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1228Lvl5173781;
        Tue, 2 Mar 2021 08:26:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=GHqGQ6bkpeWRYYmIeaGm3RIxq2zi/6S7rCu/PHnysCY=;
 b=pnBwv8dZWFS+DhE87OESWP5aNgSQ7P/RqL7mxf3arOmGYv1iMBNB8dGZSQUOmQkfFqx0
 jPGkqxw5FgVffvBNBID6OzL4WBYnom2ZsV/5zDS9y2+WOTH0ZBmmXw5ABiAfVLHgBVZO
 vGgEDyYlnIAFr8uz+w/6+tR75YIfEPqEbzzNdknAeR93cb/9so813P8coid5o31AtC1P
 jAxFgLgzU4SKJejJ7oKIHQ7g/NRm8JkC1IsUS9GK28hU9bSn9HWuj1/Txx/dFRIsGPEC
 QJXNM0Otu0f3snmOiN1ZmLqheyo8Kf7as26HF5Uo3VUJAvU81cNncYtN/lm5stghYWux kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36ye1m6kp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 08:26:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1228Otnv044119;
        Tue, 2 Mar 2021 08:26:09 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by userp3030.oracle.com with ESMTP id 37000wnkkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 08:26:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcFXMUgbK3B44em7VoBkLIZYBsdmhd750OZ1rVjzMVAmKwe8mNnEj335Ad0NwIrecDAs4C3BiHBZLLPjuNnMMYokxYe2IuUwp854j21qpXKdjFaxp90enjfX8g5Pue+rwjR36ntq6bAwqwq+OzpyDoDv+yMxvHsShSu/1DunS2rWKCBmQwIb4n+akUhnK2GTZEv7wvJVbXJ56oj3MQ16LWRlcPGjisOcO8Dnywa6IBxWNQWk33tYxZb9iSPLnsUloA3AFe7QucRA06ykS/g3L2rnkwA2ZBD8KSgq73Gh75lSChUEXB95C0AoUgvo0TDW3Hk9JIo/8U/nUAJ22u8fQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GHqGQ6bkpeWRYYmIeaGm3RIxq2zi/6S7rCu/PHnysCY=;
 b=JC49Ca1TX+4QDRJbnIrDcpz8f+4hUDWbe1TXgILcKvOsEae4Zjpi0V1G6m2h3DA9XXBzlQC/IMs5Gqr8ndhUUe33tV3Zlo59ugckSwyhnyQgA1CHZM+O+1WCgMXrtRYkaWiZ3oZIgqDj4ecJTD/seriaEbN/UqCjf7HBLha92by86Qw9mw/YIc78fHJ1kPJhhkXG92+o2FQxIsKelyz8JiKV8sAJovfmse7bwAlwCbYc1r30Okj8m4x1tHH4I9tncjoDyIbwGY3kaBlEYP1VRi1yszxTE4jXsU+9atprdp/9sjLunA7g7nGK/b4p2o/U1zY2eL0nXnszbIhaIWDIdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GHqGQ6bkpeWRYYmIeaGm3RIxq2zi/6S7rCu/PHnysCY=;
 b=x4z2Mw1am503z5mrYmcDmwiEgUHmouVr5Sl0k9v38lyIpIQlfPsXvZ/ezR95wrjswfZKbkT6AH+uVPLdVnuHBdcx94oWBVFzwHQZw34OunBBAMZrHlHWL4/BrWUxX1FJDvCn2/GgyPg/OB1qxo4d+x6B1QWCuFgaY0TWA4JzRGY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3144.namprd10.prod.outlook.com (2603:10b6:a03:15c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Tue, 2 Mar
 2021 08:26:06 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.029; Tue, 2 Mar 2021
 08:26:06 +0000
Subject: Re: [PATCH v15 11/22] xfs: Add delay ready attr remove routines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-12-allison.henderson@oracle.com>
 <20210224184546.GL981777@bfoster>
 <b3639b95-9817-675b-909a-27f04eb46c11@oracle.com> <YDeynHGXcL9XdQPR@bfoster>
 <6606af4d-66ba-af9b-65c6-106f00d1d854@oracle.com> <YDu5K+M43oyM4LIG@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <3f82db7d-b8b3-c490-da9a-7100c47eca47@oracle.com>
Date:   Tue, 2 Mar 2021 01:26:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <YDu5K+M43oyM4LIG@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0307.namprd03.prod.outlook.com
 (2603:10b6:a03:39d::12) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR03CA0307.namprd03.prod.outlook.com (2603:10b6:a03:39d::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Tue, 2 Mar 2021 08:26:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 047a54d4-999e-416b-97a2-08d8dd54d347
X-MS-TrafficTypeDiagnostic: BYAPR10MB3144:
X-Microsoft-Antispam-PRVS: <BYAPR10MB31443B8BCA53AF50BC301B2E95999@BYAPR10MB3144.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4FOHLiPmrUF5KkDl/kMnL8Mx8lRXs8+54m7T9bHk/ZpYYf42CHUHpFfhiMMOXJXzbIEIUWRwJdWx6w4WugwhVmjFwEJ8D4lowtMkkLxpylXzX8A3GPI2AjNYaz2/5+GTOELQntcHhg4DbMe0rQ9P6ADeIspHzcEq33kAdHkxoxzZyr+Ze7Xdo15bPljhVdOGlq6nQp2+Jkxkv8ppxhct5Nrur9p+5rwUt9OArjqbPnOZsHnsob9d9rAz1C/jG9FaVde0ReeYV5vd68x7slEqorcLM4LoOFZAERoBzsiKQpogvYlZJrHopyvRZv9mCDVD5eCnBqfees+EjNnVRTxRuDsupGUTxx4lo9IzfhQw4NNHD6qjVUI9zDc6y3cjcQXRjg3tOgLdgFDwCwyRvQCkM2KE28ME/9+ZS/zqC+G8B11DDPuQ2ihyrOxM7MaylF2PWHW+oSjOXc227BhWmq1G23YPWwLJIU4lqCZa3z8sRH/MNw9gcpJDQWSmtPH5kg42F/D1Ygq6zR5LNdivgWXacr3SlCag2DOblhKAplUeBM+BQ9XvqAZZAzv8ZgOnqzGMBoNOsueViXabnGHdfPgMBUjIByvaLyHuXvuxKwT4oyc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(136003)(346002)(66476007)(30864003)(66556008)(52116002)(4326008)(66946007)(2616005)(6916009)(53546011)(44832011)(31696002)(16576012)(316002)(6486002)(956004)(86362001)(16526019)(8676002)(31686004)(83380400001)(8936002)(2906002)(478600001)(186003)(5660300002)(26005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Ull2RGcxRXY5Um42Wlp4VEN2c1ZURTZ0L3VzeVNOZm83SmtIcWMweFhIZUlW?=
 =?utf-8?B?K0RYTG9KOFpSU25MTDNPRDhlWjl1SEdpalNlUTZySzRQbm1wUVZSWUF2WUNO?=
 =?utf-8?B?VXdvMWxRK052c1RCKzEyMktaVzRoL2QzUVlLS0pOZytRL2ZiOVN1bnhHY3Jv?=
 =?utf-8?B?MkdIYXQ4N05UNlJ1OE9MY1hzVU9kYUFMRk9waDBiTm9YbzJUVXlLK1NCWktz?=
 =?utf-8?B?U3B6alBQeDZBclc1U0hOL0JRaHowbExsLzRIanVpYjBEeUhiUW56MjFBeGRZ?=
 =?utf-8?B?b3dXb1dMRGJKUHlCS2tCR1hNdk16cFVEZVk5ejNzVjAwRDVtcFkrVzViMTE4?=
 =?utf-8?B?T1BZOEd0SlNabFNldnZXSVBXeHlFenhZdnIwN1dzZ2hteGpwZTZRMjkvZndH?=
 =?utf-8?B?N204T25mYkNOekVQZG1XOWFsYVp4UGNJS2NPQkZ3ZG9qeEhod2dwMWtvRFBX?=
 =?utf-8?B?RDVkbkN5eHY4bm5WNE9id2trdHh1WjBJbVZ1R1hDa1JBN0FVOVRTZTE3MWg3?=
 =?utf-8?B?eS9Qb0JxaVVqa0wrbGVUNEZNS0NCSXBYK3oySHBPTUtUS2NQVlBHUDhaZmFJ?=
 =?utf-8?B?WVZtMTgxajVrNlA0UEJIeTVCUEUrWmwwR2pCNlVjSERoazdMaTc0RXY0VDFT?=
 =?utf-8?B?TXpyb25VZi9KbjRVeGJVOXNLM0taQmdJT0lFcFRsMTYreGFvWGIvN3FqUTNO?=
 =?utf-8?B?clRaQjVOK3JDd2VkbWpzUldadi9uNCtYUFZTMzNsMWpOeXFwaDYrcWpmQmxN?=
 =?utf-8?B?SkJqeVFua3ZoSWZvaGV3NzhLVytFK3l5TUdWb0VLSFVPVUxsWU9pN2ZvUmkw?=
 =?utf-8?B?ZjRqN3FrMkxrZ1JnWkwrNjFsc0pYanhwR0JsNzZRNVRYT0hETW8rL3BROURr?=
 =?utf-8?B?K25OZnlOVkFOL3JXcWM3SUtrYlpRYUswWTg1MzFWc3puWk16NExHK3lqSTAy?=
 =?utf-8?B?RlNNNDdVeXdVZUoxRUk5YVRvSHgzYjNlaHhkdDdvSCtoZUszVjRlOFgwMWpM?=
 =?utf-8?B?a2VUV2EwbWt6TFpHWmtvL1FzOFJERnI1Z1p1OVE3UWU5cVZ0bHBiZm5VUWoy?=
 =?utf-8?B?RS8rTjlpOGlLVW9wUHIyWHVuQ2VORzBSamlDbDUvOVZEOCtVeWt6ZzJ1RGtM?=
 =?utf-8?B?aklSYmVyRmpXMzZIanVYVmpWQkdUOWpXZUpWRWZHQXB6djdZRENSak1jaHNN?=
 =?utf-8?B?QzZKNFYxRUVZZFovSW1xU0FBc1JFbGZFYVZHb1FYQ3Z5c3BoeDZ6bDVKSjhs?=
 =?utf-8?B?bk54RXEzajlnTG5SSjhxRFlQZC9hMGt4a1AzWXpHSnBIZUJpWTkwS3AxalRV?=
 =?utf-8?B?UElJYlFVbGlYdzE3Mm4rdWZxVFhySlU5azlWd3RXQUtwTk41WEZYVmxSV0tF?=
 =?utf-8?B?RGJma2F1YUZOaXhYd01uclVTVmIzRGsyWGZUTDZqUlRXSGs2bGZhTU9OQVFU?=
 =?utf-8?B?dktqTm5FT25NRkcvQW0rRWJoNXpIWHdNY3BsUHp6Tzh2T015ZFVJbWJ0TVMy?=
 =?utf-8?B?WVdYK0t2SmEzaHROVERuWTNuaHBmNHVxWkl5QlhYM0JNbkF2SUlzQUovRzB1?=
 =?utf-8?B?VEM3VmVmZEh4cnNHTXBpR2RLVkxLUkxoWW1RbWNDenc4Tjl1dXFvakxpTlVJ?=
 =?utf-8?B?QlNUOXFMWWxXOFpGb2ZRbUF0Umo4RjBXb1RWZ0xlY0VpU1d2K2QxMXRqVDZC?=
 =?utf-8?B?TWJEakdhYWVFbU0ydUx1bzBIYzVsU2lwcEZNWWNwdUwwZXl6MkE5bEVJZ3Jz?=
 =?utf-8?Q?mjLPvrueNdutK9As825m+D7Wy3M4PuXKpSLONAX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 047a54d4-999e-416b-97a2-08d8dd54d347
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 08:26:06.6184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kra7EpkiGZ1YAViJ4y23wYk3VXbtg0N9DhmUl4YNLl7COqEr8S5+AkAnp/Ay5V+zgz3XwpN/UVqsVrd1Vuot6FsyheXkgclzx75s5813vSA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3144
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020070
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020069
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/28/21 8:39 AM, Brian Foster wrote:
> On Thu, Feb 25, 2021 at 03:28:00PM -0700, Allison Henderson wrote:
>>
>>
>> On 2/25/21 7:22 AM, Brian Foster wrote:
>>> On Thu, Feb 25, 2021 at 12:01:10AM -0700, Allison Henderson wrote:
>>>>
>>>>
>>>> On 2/24/21 11:45 AM, Brian Foster wrote:
>>>>> On Thu, Feb 18, 2021 at 09:53:37AM -0700, Allison Henderson wrote:
>>>>>> This patch modifies the attr remove routines to be delay ready. This
>>>>>> means they no longer roll or commit transactions, but instead return
>>>>>> -EAGAIN to have the calling routine roll and refresh the transaction. In
>>>>>> this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
>>>>>> uses a sort of state machine like switch to keep track of where it was
>>>>>> when EAGAIN was returned. xfs_attr_node_removename has also been
>>>>>> modified to use the switch, and a new version of xfs_attr_remove_args
>>>>>> consists of a simple loop to refresh the transaction until the operation
>>>>>> is completed. A new XFS_DAC_DEFER_FINISH flag is used to finish the
>>>>>> transaction where ever the existing code used to.
>>>>>>
>>>>>> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
>>>>>> version __xfs_attr_rmtval_remove. We will rename
>>>>>> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
>>>>>> done.
>>>>>>
>>>>>> xfs_attr_rmtval_remove itself is still in use by the set routines (used
>>>>>> during a rename).  For reasons of preserving existing function, we
>>>>>> modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
>>>>>> set.  Similar to how xfs_attr_remove_args does here.  Once we transition
>>>>>> the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
>>>>>> used and will be removed.
>>>>>>
>>>>>> This patch also adds a new struct xfs_delattr_context, which we will use
>>>>>> to keep track of the current state of an attribute operation. The new
>>>>>> xfs_delattr_state enum is used to track various operations that are in
>>>>>> progress so that we know not to repeat them, and resume where we left
>>>>>> off before EAGAIN was returned to cycle out the transaction. Other
>>>>>> members take the place of local variables that need to retain their
>>>>>> values across multiple function recalls.  See xfs_attr.h for a more
>>>>>> detailed diagram of the states.
>>>>>>
>>>>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>>>>> ---
>>>>>>     fs/xfs/libxfs/xfs_attr.c        | 223 +++++++++++++++++++++++++++++-----------
>>>>>>     fs/xfs/libxfs/xfs_attr.h        | 100 ++++++++++++++++++
>>>>>>     fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>>>>>>     fs/xfs/libxfs/xfs_attr_remote.c |  48 +++++----
>>>>>>     fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
>>>>>>     fs/xfs/xfs_attr_inactive.c      |   2 +-
>>>>>>     6 files changed, 294 insertions(+), 83 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>>>>> index 56d4b56..d46b92a 100644
>>>>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>>>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>> ...
>>>>>> @@ -1285,51 +1365,74 @@ xfs_attr_node_remove_step(
>>>>>>      *
>>>>>>      * This routine will find the blocks of the name to remove, remove them and
>>>>>>      * shrink the tree if needed.
>>>>>> + *
>>>>>> + * This routine is meant to function as either an inline or delayed operation,
>>>>>> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
>>>>>> + * functions will need to handle this, and recall the function until a
>>>>>> + * successful error code is returned.
>>>>>>      */
>>>>>>     STATIC int
>>>>>> -xfs_attr_node_removename(
>>>>>> -	struct xfs_da_args	*args)
>>>>>> +xfs_attr_node_removename_iter(
>>>>>> +	struct xfs_delattr_context	*dac)
>>>>>>     {
>>>>>> -	struct xfs_da_state	*state = NULL;
>>>>>> -	int			retval, error;
>>>>>> -	struct xfs_inode	*dp = args->dp;
>>>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>>>> +	struct xfs_da_state		*state = NULL;
>>>>>> +	int				retval, error;
>>>>>> +	struct xfs_inode		*dp = args->dp;
>>>>>>     	trace_xfs_attr_node_removename(args);
>>>>>> -	error = xfs_attr_node_removename_setup(args, &state);
>>>>>> -	if (error)
>>>>>> -		goto out;
>>>>>> -
>>>>>> -	error = xfs_attr_node_remove_step(args, state);
>>>>>> -	if (error)
>>>>>> -		goto out;
>>>>>> -
>>>>>> -	retval = xfs_attr_node_remove_cleanup(args, state);
>>>>>> -
>>>>>> -	/*
>>>>>> -	 * Check to see if the tree needs to be collapsed.
>>>>>> -	 */
>>>>>> -	if (retval && (state->path.active > 1)) {
>>>>>> -		error = xfs_da3_join(state);
>>>>>> -		if (error)
>>>>>> -			goto out;
>>>>>> -		error = xfs_defer_finish(&args->trans);
>>>>>> +	if (!dac->da_state) {
>>>>>> +		error = xfs_attr_node_removename_setup(dac);
>>>>>>     		if (error)
>>>>>>     			goto out;
>>>>>> +	}
>>>>>> +	state = dac->da_state;
>>>>>> +
>>>>>> +	switch (dac->dela_state) {
>>>>>> +	case XFS_DAS_UNINIT:
>>>>>>     		/*
>>>>>> -		 * Commit the Btree join operation and start a new trans.
>>>>>> +		 * repeatedly remove remote blocks, remove the entry and join.
>>>>>> +		 * returns -EAGAIN or 0 for completion of the step.
>>>>>>     		 */
>>>>>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>>>>>> +		error = xfs_attr_node_remove_step(dac);
>>>>>>     		if (error)
>>>>>> -			goto out;
>>>>>> -	}
>>>>>> +			break;
>>>>>
>>>>> Hmm.. so re: my comment further down on xfs_attr_rmtval_remove(),
>>>>> wouldn't that change semantics here? I.e., once remote blocks are
>>>>> removed this would previously carry on with a clean transaction. Now it
>>>>> looks like we'd carry on with the dirty transaction that removed the
>>>>> last remote extent. This suggests that perhaps we should return once
>>>>> more and fall into a new state to remove the name..?
>>>> I suspect the diff might be making this a bit difficult to see.  The roll
>>>> that you see being removed here belongs to the transaction we hoisted up  in
>>>> patch 3 which happens after the clean up below, and we have the
>>>> corresponding EAGAIN fot that one.  I think the diff gets things a little
>>>> interlaced here because the switch adds another level of indentation.
>>>>
>>>
>>> Hmm.. the roll in patch 3 appears to be related to the _cleanup()
>>> helper. What I'm referring to here is the state of the transaction after
>>> the final remote block is removed from the attr. I'm not sure we're
>>> talking about the same thing here..
>>>
>>>> some times i do like to I use a graphical diffviewer like diffuse when
>>>> patches get weird like this.  Something like this:
>>>>
>>>> git config --global diff.tool  diffuse
>>>> git difftool 3c53e49 e201c09
>>>>
>>>> You'd need to download the branch and also the diffuse tool, but sometimes i
>>>> think it makes some of these diffs a bit easier to see
>>>>
>>>
>>> I think it's easier just to refer to the code directly. The current
>>> upstream code flows down into:
>>>
>>> ...
>>> xfs_attr_node_removename()
>>>    xfs_attr_node_remove_rmt()
>>>     xfs_attr_rmtval_remove()
>>>
>>> ... which then implements the following loop:
>>>
>>>           do {
>>>                   retval = __xfs_attr_rmtval_remove(args);
>>>                   if (retval && retval != -EAGAIN)
>>>                           return retval;
>>>
>>>                   /*
>>>                    * Close out trans and start the next one in the chain.
>>>                    */
>>>                   error = xfs_trans_roll_inode(&args->trans, args->dp);
>>>                   if (error)
>>>                           return error;
>>>           } while (retval == -EAGAIN);
>>>
>>> This rolls the transaction when retval == -EAGAIN or retval == 0, thus
>>> always returns with a clean transaction after the remote block removal
>>> completes.
>>>
>>> The code as of this patch does:
>>>
>>> ...
>>> xfs_attr_node_removename_iter()
>>>    xfs_attr_node_remove_step()
>>>     xfs_attr_node_remove_rmt()
>>>      __xfs_attr_rmtval_remove()
>>>
>>> ... which either returns -EAGAIN (since the roll is now implemented at
>>> the very top) or 0 when done == true. The transaction might be dirty in
>>> the latter case, but xfs_attr_node_removename_iter() moves right on to
>>> xfs_attr_node_remove_cleanup() which can now do more work in that same
>>> transaction. Am I following that correctly?
>>>
>>>> Also, it would be
>>>>> nice to remove the several seemingly unnecessary layers of indirection
>>>>> here. For example, something like the following (also considering my
>>>>> comment above wrt to xfs_attr_remove_iter() and UNINIT):
>>>>>
>>>>> 	case UNINIT:
>>>>> 		...
>>>>> 		/* fallthrough */
>>>>> 	case RMTBLK:
>>>>> 		if (args->rmtblkno > 0) {
>>>>> 			dac->dela_state = RMTBLK;
>>>>> 			error = __xfs_attr_rmtval_remove(dac);
>>>>> 			if (error)
>>>>> 				break;
>>>>>
>>>>> 			ASSERT(args->rmtblkno == 0);
>>>>> 			xfs_attr_refillstate(state);
>>>>> 			dac->flags |= XFS_DAC_DEFER_FINISH;
>>>>> 			dac->dela_state = RMNAME;
>>>>> 			return -EAGAIN;
>>>>> 		}
>>>> Ok, this looks to me like we've hoisted both xfs_attr_node_remove_rmt and
>>>> xfs_attr_node_remove_step into this scope, but I still think this adds an
>>>> extra roll where non previously was.  With out that extra EAGAIN, I think we
>>>> are fine to have all that just under the UNINIT case.  I also think it's
>>>> also worth noteing here that this is kind of a reverse of patch 1, which I
>>>> think we put in for reasons of trying to modularize the higher level
>>>> functions as much as possible.
>>>>
>>>> I suspect some of where you were going with this may have been influenced by
>>>> the earlier diff confusion too.  Maybe take a second look there before we go
>>>> too much down this change....
>>>>
>>>
>>> I can certainly be getting lost somewhere in all the refactoring. If so,
>>> can you point out where in the flow described above?
>> Ok, I think see it.  So basically I think this means we cant have the
>> helpers because it's ambiguos as to if the transaction is dirty or not.  I
>> dont see that there's anything in the review history where we rationalized
>> that away, so I think we just overlooked it.  So I think what this means is
>> that we need to reverse apply commit 72b97ea40d (which is where we added
>> xfs_attr_node_remove_rmt), then drop patch 1 which leaves no need for patch
>> 3, since the transaction will have not moved.  Then add state RMTBLK?  I
>> think that arrives at what you have here.
>>
> 
> It's not clear to me if anything needs to change before this patch or
> the changes can just fold into this patch itself. You probably have a
> better sense of that than I do atm. 
I can unfold it here in this patch too if people prefer. I'm getting the 
impression that others are having a hard time keeping up with the 
refactoring, so maybe that might be better.


 From my perspective, I think we want
> that transaction to roll after the final remote extent removal unless we
> had some reason to explicitly change existing behavior. This used to be
> handled by the old loop that rolled the transaction down in the remote
> block removal code. ISTM that the proper way to maintain the same
> behavior in the new state machine code is to unconditionally fall out of
> a RMTBLKREMOVE state with an -EAGAIN from _iter().
Sure, I think that describes what you have up there

> 
> IOW, __xfs_attr_rmtval_remove() returns -EAGAIN when it has more work to
> do. _iter() returns -EAGAIN when __xfs_attr_rmtval_remove() was called,
> finished its work, but we need to roll the transaction before the next
> step of the operation..
Right, ok, will make those modifcations here then.  Thanks for the 
reviews!  I know it's a lot.

Allison

> 
> Brian
> 
>> Allison
>>
>>>
>>> Brian
>>>
>>>>
>>>>> 		/* fallthrough */
>>>>> 	case RMNAME:
>>>>> 		...
>>>>> 	...
>>>>>
>>>>>> -	/*
>>>>>> -	 * If the result is small enough, push it all into the inode.
>>>>>> -	 */
>>>>>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>>>>>> -		error = xfs_attr_node_shrink(args, state);
>>>>>> +		retval = xfs_attr_node_remove_cleanup(args, state);
>>>>> ...
>>>> I think the overlooked EAGAIN was in this area that got clipped out.....
>>>>
>>>>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>>>>>> index 48d8e9c..f09820c 100644
>>>>>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>>>>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>>>>> ...
>>>>>> @@ -685,31 +687,29 @@ c(
>>>>>>     	 * Keep de-allocating extents until the remote-value region is gone.
>>>>>>     	 */
>>>>>>     	do {
>>>>>> -		retval = __xfs_attr_rmtval_remove(args);
>>>>>> -		if (retval && retval != -EAGAIN)
>>>>>> -			return retval;
>>>>>> +		error = __xfs_attr_rmtval_remove(&dac);
>>>>>> +		if (error != -EAGAIN)
>>>>>> +			break;
>>>>>
>>>>> Previously this would roll once and exit the loop on retval == 0. Now it
>>>>> looks like we break out of the loop immediately. Why the change?
>>>>
>>>> Gosh, I think sometime in reviewing v9, we had come up with a
>>>> "xfs_attr_roll_again" helper that took the error code as a paramater and
>>>> decided whether or not to roll.  And then in v10 i think people thought that
>>>> was weird and we turned it into xfs_attr_trans_roll.  I think I likley
>>>> forgot to restore the orginal retval handling here.  This whole function
>>>> disappears in the next patch, but the original error handling should be
>>>> restored to keep things consistent. Thx for the catch!
>>>>
>>>>
>>>> Thx for the reviews!!  I know it's complicated!  I've chased my tail many
>>>> times with it myself :-)
>>>>
>>>> Allison
>>>>
>>>>
>>>>
>>>>
>>>>>
>>>>> Brian
>>>>>
>>>>>> -		/*
>>>>>> -		 * Close out trans and start the next one in the chain.
>>>>>> -		 */
>>>>>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>>>>> +		error = xfs_attr_trans_roll(&dac);
>>>>>>     		if (error)
>>>>>>     			return error;
>>>>>> -	} while (retval == -EAGAIN);
>>>>>> +	} while (true);
>>>>>> -	return 0;
>>>>>> +	return error;
>>>>>>     }
>>>>>>     /*
>>>>>>      * Remove the value associated with an attribute by deleting the out-of-line
>>>>>> - * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
>>>>>> + * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
>>>>>>      * transaction and re-call the function
>>>>>>      */
>>>>>>     int
>>>>>>     __xfs_attr_rmtval_remove(
>>>>>> -	struct xfs_da_args	*args)
>>>>>> +	struct xfs_delattr_context	*dac)
>>>>>>     {
>>>>>> -	int			error, done;
>>>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>>>> +	int				error, done;
>>>>>>     	/*
>>>>>>     	 * Unmap value blocks for this attr.
>>>>>> @@ -719,12 +719,20 @@ __xfs_attr_rmtval_remove(
>>>>>>     	if (error)
>>>>>>     		return error;
>>>>>> -	error = xfs_defer_finish(&args->trans);
>>>>>> -	if (error)
>>>>>> -		return error;
>>>>>> -
>>>>>> -	if (!done)
>>>>>> +	/*
>>>>>> +	 * We dont need an explicit state here to pick up where we left off.  We
>>>>>> +	 * can figure it out using the !done return code.  Calling function only
>>>>>> +	 * needs to keep recalling this routine until we indicate to stop by
>>>>>> +	 * returning anything other than -EAGAIN. The actual value of
>>>>>> +	 * attr->xattri_dela_state may be some value reminicent of the calling
>>>>>> +	 * function, but it's value is irrelevant with in the context of this
>>>>>> +	 * function.  Once we are done here, the next state is set as needed
>>>>>> +	 * by the parent
>>>>>> +	 */
>>>>>> +	if (!done) {
>>>>>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>>>>>     		return -EAGAIN;
>>>>>> +	}
>>>>>>     	return error;
>>>>>>     }
>>>>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>>>>>> index 9eee615..002fd30 100644
>>>>>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>>>>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>>>>>> @@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>>>>>     int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>>>>>     		xfs_buf_flags_t incore_flags);
>>>>>>     int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>>>>>> -int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>>>>> +int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>>>>>>     #endif /* __XFS_ATTR_REMOTE_H__ */
>>>>>> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
>>>>>> index bfad669..aaa7e66 100644
>>>>>> --- a/fs/xfs/xfs_attr_inactive.c
>>>>>> +++ b/fs/xfs/xfs_attr_inactive.c
>>>>>> @@ -15,10 +15,10 @@
>>>>>>     #include "xfs_da_format.h"
>>>>>>     #include "xfs_da_btree.h"
>>>>>>     #include "xfs_inode.h"
>>>>>> +#include "xfs_attr.h"
>>>>>>     #include "xfs_attr_remote.h"
>>>>>>     #include "xfs_trans.h"
>>>>>>     #include "xfs_bmap.h"
>>>>>> -#include "xfs_attr.h"
>>>>>>     #include "xfs_attr_leaf.h"
>>>>>>     #include "xfs_quota.h"
>>>>>>     #include "xfs_dir2.h"
>>>>>> -- 
>>>>>> 2.7.4
>>>>>>
>>>>>
>>>>
>>>
>>
> 
