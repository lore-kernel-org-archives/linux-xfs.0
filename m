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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA731C433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75AB061103
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhDBJpq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:45:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52110 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhDBJpq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 05:45:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329UFsK030104;
        Fri, 2 Apr 2021 09:45:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=lqlGpIXqPnKVR1d6/MwtiHSy0AcFNkPqS/1VsqBjink=;
 b=tgLlt36Mh+lijPlRWDZDJ0DJKBSBV/arB4ReQJmTm3zsEt+Z5R441Wz8QjB+e/zD6j0e
 r4Xmr93OCfgbNbcgcZNJo+j0+KTjwpD2SLyD6iB42xII+gJHh2/VD1F135Gr1HPzTGAJ
 j4TT4dO+dVdPBmFgbh1zGmqzr6I+2EOGqxjsceDr+vqdqOQ4uGgF1yxFyMddw1SPLb8N
 dBUqwmhQfYgpW8bVoCM91eRq06Zcfdtu22ewOKVdbsngwl6ni+CQhlq3t+P/9Se3Bkw8
 jvM1j/2cAI19jayGCE4gm53mBN974cbWWj/frLfcQEpKSPR5RykdUxaaxKNEK0kut8X3 Sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37n2akmb0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:45:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329ilvc091486;
        Fri, 2 Apr 2021 09:45:43 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3020.oracle.com with ESMTP id 37n2pbkxts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:45:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jg7C1aWStaFLuVaCNGE4Dy/oc0lXF2lJfNq+vtH5ggYi4S0p/vb9Q9el6kH1w2S1hDkSGW9Y5eHXpgiL4Vbs84F/KnTVwyP60TaplCRR/ZhoFaj0gEm15AN7Djx0WfOn8Yxs5iO7MNUwqQnL5L07+F07ffqqTzwFTMKfTWNAL5wyFKzcfchEzVs33O0E+CEVbKgl4KR27AkbU7BzPj0Oc8hPu/DR68mnpLAAZ8LL1S5+8zYK5Nps1R77jfcjftpS8Xaw85Od8lSjxjIUHBTYDlvWN9Z6xARvnfcgor8JLHRRMVpJy0NhhcPXIcQR6S93SGg/fb5tfFzo50k/EMdZpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lqlGpIXqPnKVR1d6/MwtiHSy0AcFNkPqS/1VsqBjink=;
 b=ViiLQC5UcPBJimJRA8rK1R9vjdRYmTqSRlSVEwHoIEgsCOUoXInuoCBr3cs2BQ9DzCGdI/OiEzahQtXUjISKhJJ2OrLN3XjBISR5VrrTvLm7JVyCmiwMS0PTRUzrfvY4Imft+d21H6cC1Jxi4Y8iIWwF1jwEqSNbYlNi45lCaVEwSvJ95qW/KPTtV/0M6j/vV8I72E+0Ofu8XDzAZn/dJVKbZd7HfexQHFGPhPXD6H6Q6EMTPMqgKupRd7qBBUcl8HqLnejAZDWddotd6TCyqjqJjMvDAZivX6WqFeFSg6EY5r7oq0nnAPRMdNgiJA988V+MbLup4hjyZ606dBp9Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lqlGpIXqPnKVR1d6/MwtiHSy0AcFNkPqS/1VsqBjink=;
 b=yKOOELe6yGQX/UQCCHOTK8Lt/jtqoE6XBEhmlUyh3OlvGZlvm2pEAZVLMuqVNrSgY7LgTZFQi1svXpmlDBgrfcF+IOgaGM5gfxYUJOVNL+SoPb9d6yovN5tMs+ZM8nsAiUC/WFZ7AkzXL4we9RfC+k+Jy8wbuVBxupm5zbAH3oY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4813.namprd10.prod.outlook.com (2603:10b6:a03:2d2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 09:45:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.3999.032; Fri, 2 Apr 2021
 09:45:39 +0000
Subject: Re: [PATCH v16 10/11] xfs: Add delay ready attr remove routines
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210326003308.32753-1-allison.henderson@oracle.com>
 <20210326003308.32753-11-allison.henderson@oracle.com>
 <87o8ex6rr9.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <da826494-b075-d6af-44f1-b3947e718e5b@oracle.com>
Date:   Fri, 2 Apr 2021 02:45:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <87o8ex6rr9.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: PH0PR07CA0052.namprd07.prod.outlook.com
 (2603:10b6:510:e::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by PH0PR07CA0052.namprd07.prod.outlook.com (2603:10b6:510:e::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Fri, 2 Apr 2021 09:45:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 078f4dca-2c89-4903-33b3-08d8f5bc131d
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4813:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB481302195A031EF9EF0272EA957A9@SJ0PR10MB4813.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S16Ovb/4wIAqyExhP4J/HEgIJMpFBLVXfXC91TvSNR69esMx4Q4EWxWxF4m6nWcSncEX56YCfDr6DMHkFCtlgur9cvbUgEG+87rGoYmV/kJtWDLTuxMkAd5djHnbktWlgs2Q8kVeVmFt1HuHcQ0nTec+v9kwrKgW2tf/PmKq0Ga0ECLhecJsuNkNZpa2sn/asa0QU88nCkjkbUyvuxK517MrdBTLxg6J0WcTucx/ntZbZVTaP7NpVzrmzIa239xQ3q1nX3SpMlzufRIzf8IN6O9AHT06vFp18axmGa4c38a5bariOTdBGxgL2lQVVSiTj4JkMQLtYraetblNnfCI6ozrvAWU/sQcYFtjDxrnEYxs/CIr/jbQxSmq9lkAsNxhrVUlS825l6agvOQawrIKnTR6kgkNXxQANfxQO0oYaQ3Q6Tn18QqYIFSrJMlH+Bcy2D1ND3Msy+iYnKp0vsa3tIU0IOHuIYOngix6RjBgKroJysmkKjccwq+/BO4n68lWxmwSmBbglnjtvWKlzjLW1Yp2gZlpHUxKz195H5McRkyKQLDokvY2hf7pBF4ENbk2McHHoHI/pQHTsm3WAeAVyzb9NCpDitusLQ16I4T3Tm5kHSd++UWy+WYqOexL90U7nP+1NmyYqW0rWNH5dByky6PZ42SX4Im52rzVgXPrW69136HyYj8beoQSJC+iys6BjmvKPHjznI2CmqhuyWZ8hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(376002)(366004)(346002)(38100700001)(86362001)(956004)(2616005)(16526019)(8936002)(26005)(2906002)(31686004)(186003)(8676002)(31696002)(36756003)(83380400001)(44832011)(53546011)(316002)(6916009)(478600001)(16576012)(5660300002)(4326008)(66476007)(66556008)(66946007)(52116002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cVpMajBwS29hNEJhUEJnVHZBU28wNSt0MVhCaWp0dGNtcWpvTEdyb3ZVTm1z?=
 =?utf-8?B?ZzFrUXZpN0QwbzJ5UlVNSHpIa3U2Tm9EQk5BQmhvY3NEL1MxNGtCTitqcGd0?=
 =?utf-8?B?cVRENFF6OWtyeFJXR1RDZ0RDUm1rU1lsTjRKQXgxOE9PMXVsUjU2RHkwekw5?=
 =?utf-8?B?ZzVZS1pJWmVuclNHN0F1UXlvM09KSloreE1pYlNvR0dRN1NtcXZiQjR4Tm8r?=
 =?utf-8?B?TTVkWHMvL3hHNTE0bzZPdE1rT3plbUtQRUR6cnIrSmdGRENTRVl6VEgwZXJz?=
 =?utf-8?B?SWMyZVF2aTY3UXlxL3JyY0J2UWRMNzdFeDFBSTlZSlJCSXE1NDlraTJlK3VT?=
 =?utf-8?B?MVpRRU5hbGhMdlJ4bHFVcUhINCsraWZyTlRwVUJ5ckpnd1AzV2ZhMnhXcDBu?=
 =?utf-8?B?allTaW8zeW1GcUFGOS9HL0JxK2NGcFN0bElIcFY5RldrdERvWGc0VG8yTlFp?=
 =?utf-8?B?R2JwdXk3UVVVUnZZS0plNGtkNEFWQzhzUnZSMUhLblBYL0xFVDR6Mk1aUnJr?=
 =?utf-8?B?Nkx3WXNrZVB6RWZoNjFIVGxoQldncm5JcGVxNWtMOGRNK0VJaXF6KzluWURy?=
 =?utf-8?B?eVFqQnJSclFiZFdXTWtaSmh6REZPSVdzdXBQRnc0QXg2Nm85bldpZEc5QnE1?=
 =?utf-8?B?UjNNM0pnc0NhNnFKYlFDeVJ0eCs2RGFOaHF0N08vQ0hWRGN5WnRHRGViQTly?=
 =?utf-8?B?MERrd25oM1J2UUIrRTIzLzB4b1IvUndUd3c5d1RjQTQ3VVlmaXVTZytpWjBF?=
 =?utf-8?B?Tk9nNU9Mc3JWQi81UTI3QklPRVF1TlYxelpqT3ZVRWx3M3U0RE94c2RmL2NX?=
 =?utf-8?B?YnlobStMRkFrejJlTUhPWldHRmRBc0ovMWdzR25oREhWZ2p3SlNtSGROTFRi?=
 =?utf-8?B?L04vNFlrdXBGblFRZjVmUUlzUFdHWGk4WGUxeTA1T2pEWWNjUE1qeXYzSlRH?=
 =?utf-8?B?WU5wRS9TU1FEZVo0dzYrT3lEWGlQK0tMU3MvckFDZndjV2hqVUNBaEFNR0Q0?=
 =?utf-8?B?OEhNSTVEb0oxelZkUUo4b0JranpWSklmaUNmc3o4SE9WQU9hK1FQNVVodjJH?=
 =?utf-8?B?NlpNaSthd2VLOG1nVGZXaEEzNXpCNi9rVUZna3dwNjAxYmxqa3pEUFg3Q2dV?=
 =?utf-8?B?aUROYlhHemVBVENMYWlkUExBbWE4ZVVGMXAzYVNJc05qRXU1TmRpK0xKeTIw?=
 =?utf-8?B?WGU2S3dxcS9Nem45SU5tbXl0RmxyZUl2b1JIVkxiSVdXQVZYNnFZd3licmFm?=
 =?utf-8?B?RTlUS3JPaFczMUd4RW1NZ21pdmpxUlptbkZPQSszZUJwUzBscDVMVnk4cHhI?=
 =?utf-8?B?OG5KbjByeHdDcHJpa3RNSXpyK2NoQndtN3huZE1LbHlEZmcydytmZFFLalNq?=
 =?utf-8?B?NC93NjM5ZXovTTRlWEtNU2xoaHRITWMxaUdrSHVwVURoWW4zNStCc1dIZFJQ?=
 =?utf-8?B?NGk4b1RBK2dMUCt4S09GRi9xeUloa2x0ekJhRmhvWlcyRlh3ZEZTRmNlSVJ5?=
 =?utf-8?B?bXp5OHJCTXNGNHhpYlVvM1gxTkpsQ1V1N2lwa04xZC9PY1I1UHNWY2wvZlpY?=
 =?utf-8?B?Z0lMTHl4ekdZeTZoRHNJNE9JSm1zZWlNbkF5NmlFV1l2akZkU0phb29KZU4v?=
 =?utf-8?B?YS9TdTErYXNNdGZwNVVQYkhmOGFxcnJ5MW5CWW1tT1BFN2Q2Q2RzSGt5aE1B?=
 =?utf-8?B?Wjc5bHV5MmdNV1lvdTVhaHhwb2JhZHBvY2h3a3k5WGcrOTk5S21GTExFNFpD?=
 =?utf-8?Q?Kh4S2DRArxHwXuB2k/+dWNcJ2fbZoZTgbAogiwL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 078f4dca-2c89-4903-33b3-08d8f5bc131d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 09:45:39.7348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cFRDCsHSJjX/b1tvCTPX+JhV26zw7lA+Awv9i1SIaS/mCoUwtEIql3lU0oihfjPlihWZS83jv/BOm4xPZZgsPzZW9c5gWccEBVqR6nnlNk8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4813
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104020068
X-Proofpoint-ORIG-GUID: GNd-0B-vYdPABSy6P3aXjP8tcjNFDei2
X-Proofpoint-GUID: GNd-0B-vYdPABSy6P3aXjP8tcjNFDei2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 phishscore=0
 bulkscore=0 adultscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 suspectscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020067
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/2/21 12:59 AM, Chandan Babu R wrote:
> On 26 Mar 2021 at 06:03, Allison Henderson wrote:
>> This patch modifies the attr remove routines to be delay ready. This
>> means they no longer roll or commit transactions, but instead return
>> -EAGAIN to have the calling routine roll and refresh the transaction. In
>> this series, xfs_attr_remove_args is merged with
>> xfs_attr_node_removename become a new function, xfs_attr_remove_iter.
>> This new version uses a sort of state machine like switch to keep track
>> of where it was when EAGAIN was returned. A new version of
>> xfs_attr_remove_args consists of a simple loop to refresh the
>> transaction until the operation is completed. A new XFS_DAC_DEFER_FINISH
>> flag is used to finish the transaction where ever the existing code used
>> to.
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
>>   fs/xfs/libxfs/xfs_attr.c        | 206 +++++++++++++++++++++++++++-------------
>>   fs/xfs/libxfs/xfs_attr.h        | 125 ++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>>   fs/xfs/libxfs/xfs_attr_remote.c |  48 ++++++----
>>   fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
> 
> [...]
> 
>>   STATIC
>>   int xfs_attr_node_removename_setup(
>> -	struct xfs_da_args	*args,
>> -	struct xfs_da_state	**state)
>> +	struct xfs_delattr_context	*dac)
>>   {
>> -	int			error;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_state		**state = &dac->da_state;
>> +	int				error;
>>
>>   	error = xfs_attr_node_hasname(args, state);
>>   	if (error != -EEXIST)
>>   		return error;
>> +	error = 0;
>>
>>   	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
>>   	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
>> @@ -1204,10 +1233,13 @@ int xfs_attr_node_removename_setup(
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
> 
> If the call to xfs_attr_rmtval_invalidate() returned a non-zero value, the
> above change would cause xfs_attr_node_removename_setup() to incorrectly
> return success.
Ok, will update the return.  Thx for the catch!

Allison

> 
>>   }
>> @@ -1232,70 +1264,114 @@ xfs_attr_node_remove_cleanup(
>>   }
>>
> 
> --
> chandan
> 
