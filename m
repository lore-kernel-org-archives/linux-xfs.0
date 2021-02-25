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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4467AC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 22:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E177D64E83
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 22:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhBYW2w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 17:28:52 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44058 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbhBYW2v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 17:28:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11PMO3Cf179671;
        Thu, 25 Feb 2021 22:28:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Sh1El82CeAKT7hUjoZey9cJnbisah3b6m8QHsENi6Ro=;
 b=NHnX5NHGzP48MGtso0ArLKKbge3eynku8/ixuOMI45PjE/x8mj74rv4GGUS/c4xADVJ/
 40XF9KFQDppWDt/pSPDoxePJCi5cgfwILTbeAn+NOW1OoMEHx+L0oqTTyfcwr39xz79M
 P7p63mQ+835B0maaW0nkLEveb3j25vUwxpJD3aQyoTYMJXNwOUCuv2Kdol/vBYjOgN8b
 /dpfiPOevPXyYWd43gE7qtjHJqmFjWKeRUrLTNrRw3esK9MBP9tx/4oXR6laZGwTKenN
 7JyUeTpPkGCJN+8CQC44uskZCNEamzvd9rVLfraC3Bc8/OZ6pRh7Q6ZuAGlzGdwSRlxM +w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36ttcmg4bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 22:28:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11PMOko8138057;
        Thu, 25 Feb 2021 22:28:06 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by aserp3020.oracle.com with ESMTP id 36ucb2n51b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 22:28:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GwBCZ0PrxxAP1KHVG+RBchT6l1iayCUBKty8KsHDL/K8vOjMToUI/cFpNLehHpmFOgXyqcyiip+ZsAsOHtLJH/dsLoK8/NkFlqtITtVs3qUDRxCQ+yjAjGPpaTminy+a+piMcnKriKiAiI4aIgBQvQ2NVyf5AHgGCGGvqAxj22KKrD6Vn+8J9WGRF4uXfmYVaXF+lTPGfyZYuQhPiWOlVaeGj7nQ2RdMTgfGr7H+Ru9af2meTNPB53n10bvds57JCLAf16+am5ScAVWiPzFtWDYnf9Ku3mPnMxabD2WgAoow1i5M62pHZpysiRvhEMmYa1XHapAstLsOyMPRnR7qgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sh1El82CeAKT7hUjoZey9cJnbisah3b6m8QHsENi6Ro=;
 b=i1E+TnxbgBYx03E9HE2L80+us5UGwSJ5mfPn+/6RJt8eUzNdcK+9WR6b1dM12wr+DwlFhLmB/62TqD5s1ULaNWImZSrM5D+fHMpn8pGHivwYHbs098ceBTTS8qiuZIntjiIzbF28vQvKukLSFwOxdDY/m145pELkZkyZNjsW/svxCCYz90JGRxMXouADL6jcyPplrjUKB8G+V2Zi7YEgkfAG2lHerhNRaEoaSR/KEW6L0YuKKnqFNMsOiI5F5o5d9jTKbF28TuDwSfmkHWqD5H/8/e8ns85YjmJZ2pp8pJdlTAuAXHMUbvK4q+IyFYu8ilXKvv/ImeAc/PLSdmBgUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sh1El82CeAKT7hUjoZey9cJnbisah3b6m8QHsENi6Ro=;
 b=u2UdAhl8v3SNqOzHn38sVFLOf7dfofirgzKLQmwvwuHRtQ7ZBWlKh8Pz3PUBSLVis/CXeylGthI0JQNemXBkLamxDqzt5oH0x3KC1JYu1WpYy2dwczCunvRg0JDx5nzy/c55OHOWaByEc6CrLX7vgCRVl/TDr9JDZ9qckVBfiFs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4034.namprd10.prod.outlook.com (2603:10b6:a03:1b1::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31; Thu, 25 Feb
 2021 22:28:03 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.020; Thu, 25 Feb 2021
 22:28:03 +0000
Subject: Re: [PATCH v15 11/22] xfs: Add delay ready attr remove routines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-12-allison.henderson@oracle.com>
 <20210224184546.GL981777@bfoster>
 <b3639b95-9817-675b-909a-27f04eb46c11@oracle.com> <YDeynHGXcL9XdQPR@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <6606af4d-66ba-af9b-65c6-106f00d1d854@oracle.com>
Date:   Thu, 25 Feb 2021 15:28:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <YDeynHGXcL9XdQPR@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BY5PR17CA0002.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BY5PR17CA0002.namprd17.prod.outlook.com (2603:10b6:a03:1b8::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 22:28:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22bf4436-8089-4a72-cfd5-08d8d9dc9d77
X-MS-TrafficTypeDiagnostic: BY5PR10MB4034:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4034A97D1E1AE1C325B5CC6B959E9@BY5PR10MB4034.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4kPmQRZHq7iH/1owdyck7q4ABPfFBluS5pejyh58Kv72G004E5kxLL7/wjN9NChVCID2Ec28wx86tmWsTs9My14DzUsepSUg82cpgGLG3WXE4WjjI92+RG4hMg/QFxX5TI/jsKlhOOq94DBdtnkj79ePBmVOd/O4rq6DBh8TzDqGpMe2DCsDGhcNH4VlzTEF7yV8w3T8vmJE4YXNMkYnn/woVkw8bCXItzih3uDnATo35kbaEFMLI+13qmUVmAdtjE784DjnZWiLXac2hHCOCM2m3RduKCFAGU4nIormFlRc7WOwbDhOd36zgH662yEAwNuExLhyEB6c3cbC6ZJB9s2uq/lrRQ/YsllgSCOxJNi5sBgCLTpQe+aollgHZrPe8pH8TCtUSDFgjkg618ywXmDjcSVIrwKwp7huOTdnIHR5dMEP1L/4p8ww2lsj4FQob2xj/URtoSZxORyvp4J/qhRBYC5vpTwxJc1BCao3kaIOcQBi2KUTLnY9I/LuOEn70sQMB9l0fPZu8utpxA986D+XEP9mavQ8giSjsBnokUKbdkMauXoFK+Ob1o3FlkTTKXMTxl/DdyGkwEhhY5Ltwi2IzLteyC5WGlbPGeYE/dM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(366004)(376002)(396003)(956004)(30864003)(2616005)(44832011)(8936002)(26005)(8676002)(2906002)(16526019)(316002)(16576012)(4326008)(66556008)(36756003)(5660300002)(86362001)(66476007)(31696002)(31686004)(52116002)(66946007)(6916009)(186003)(478600001)(83380400001)(53546011)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WUNCeG5ScEVhY0ZYQWo2aUJJRnM3WVYrQUN6RXBJWU9BbUhKSXNDZTFtSkVv?=
 =?utf-8?B?OEN5Uk1NcTZjcUo5YitNdmJ4S25HRTNaNlphTkFQY0E0eE13L090bUQzd3V5?=
 =?utf-8?B?OHJQNkp4blprYUd3REhCSWxrL1lTelVQTUZmUVdlaFM4aHBEQWQ0SVVIcWRx?=
 =?utf-8?B?YlZtQlZYcThKa3FHYVloT2djQjlRdnRuN25IS1lSOE9kUnpidEUzR0wya0VI?=
 =?utf-8?B?V0o1Y0x0L3ErVjc3d2lRRFRHb1pESE93NHFRQS9sQjNWOHd1WTgybUxSK2ty?=
 =?utf-8?B?SWU5SzhUcktXSzRiRXZ6R3JuSDBlQVREWFNLa1pmOGYrNk95bktuSUJNNzZh?=
 =?utf-8?B?WXZGV2s0UCthcytxNk81cm5rYS8xTUJpN3ZTbUhYRWl3NkFSZjBvcmVkSURy?=
 =?utf-8?B?Y2RBOHNwMHhPVGNjVXlrdGtyOUdyOW9JM05kLzlQeE1FMnFFZVNoQVp6KzRn?=
 =?utf-8?B?ZWw2VStIYmhQeHA0Z3UwMk5JaFJFZ0lFQmZTVWpBV3F4eEo0MnpOaVgwQ1Zi?=
 =?utf-8?B?Q3NRZitpWmZNU0NDNkh0N3o4M1lOY2lwSk1nUzRkRGsrZjBNdEdvK29Sb2Y3?=
 =?utf-8?B?SnFTUUwwbnJNeWVXcjVQSzJYc3p3SGZURkc2R1RpaUw2Zm5NNG9aeVVocEFm?=
 =?utf-8?B?ZEtJRko3czBqSmpQNFYzLzNETTVURHppcEh4WGY4dVk5ZUFxTStQbDB2SDVH?=
 =?utf-8?B?b2lFQmJDbkQ5OUFBUGR1NG1TZnNtampwaGlBSkpaazE0a0tXTVJycHFoY2FD?=
 =?utf-8?B?SWJtY21jUlNPcklHYzloWnNNSE9CRlpwSU5CaWV0QmVWR012VGdZTkc0OXND?=
 =?utf-8?B?SGpPZ1dJeWdSVHU5TFJVRlZuZlRDaWVEdjhHTTFNeCtQY3RERm1hK0ozN3VR?=
 =?utf-8?B?L1hrVGJORUNJbXZyWU01anNtOWQ2bkplQWVPQUVSclY1RFhlc3hZdkhiakR1?=
 =?utf-8?B?dTRFTXhmNXpNdUoxRHo3RFZ4bHM0TXN3VzFFUWs0ZXk4N3JJZVhGUVE1N3BF?=
 =?utf-8?B?VlU5bWRqWUVQdU5MaWpjVnErKy84OVpCS2hlMXcrQjhpWTNMUjIvQUwyS2sz?=
 =?utf-8?B?L0JsZ01FUXpRMmpvb3hrdGQyZGtjdDQ1Ky9XWGhieGJaKzJCTWFuZURVV2k4?=
 =?utf-8?B?b0ZKRXlWLy9ENEU4bzFLU1RNOEtXaG80aUViWTE3TklYQWp6SWhKNVp2ZS9K?=
 =?utf-8?B?WFJBS2svZnlBM2QyTHRCM3VBV3ZFdVExYUVSc3Z2WVpyZmphTFJrZFRZN1Qy?=
 =?utf-8?B?OGZkK2kzUDVCV2VsanBVcmptYUR5VHlhYVl0dEVkLytxN2FPa25QUnpNdTk0?=
 =?utf-8?B?MmwxZVR6KzJVYWFFNkhCWnJueGxydUpMYWUzOTBuTzJaMDJHWHNIeEMwZWc2?=
 =?utf-8?B?YVd1OVBORHJ0dFd6d3JiTlpnclZpVEZpcXBBK2dGd0ttbnNTR3R4U2lxcVds?=
 =?utf-8?B?bXYzaTJJSTdFTnB0NU9jRlVTOFpaRjdJbVVZQzBPVUI3NzhmYzJ3cmJXR0ZR?=
 =?utf-8?B?UUJuNExjdmFqckJqcU44OU1YQlVBb296am9MMVE2ejNyUmc5eUJaVkV2RFRK?=
 =?utf-8?B?dXNvaXZXbmNTdC96TEhmbFJBWG9BUGJrdmpuSTBpZVNYMWMwS09UL1JoUS9U?=
 =?utf-8?B?QVZiK2prbHdyT0VLbzlmakY2TXNrYW1LMDdpQW5kdFphK0ZwVVM2RDBmWUxj?=
 =?utf-8?B?cFNKREtDNTVGSzNwYUw2Y1lsRHNEMzRnUSsxSzNEVzVocXBLb0h1WU5RVTJE?=
 =?utf-8?Q?SNdTb2kG/jfS71Kn3hP+Hw1rHoGHFqgbkZ21dJl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22bf4436-8089-4a72-cfd5-08d8d9dc9d77
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 22:28:03.1758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k3vnQKE5l13cf0df7XiWSy9L7iPFoV0Jk+wtkzYzn1Jsk9RJ/kBKfsFevfy6l2ZnCpA8FdH1Qvh3Jqfe2kNOBgxeHT5usoAM6JYvQjDwCP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4034
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250168
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250168
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/21 7:22 AM, Brian Foster wrote:
> On Thu, Feb 25, 2021 at 12:01:10AM -0700, Allison Henderson wrote:
>>
>>
>> On 2/24/21 11:45 AM, Brian Foster wrote:
>>> On Thu, Feb 18, 2021 at 09:53:37AM -0700, Allison Henderson wrote:
>>>> This patch modifies the attr remove routines to be delay ready. This
>>>> means they no longer roll or commit transactions, but instead return
>>>> -EAGAIN to have the calling routine roll and refresh the transaction. In
>>>> this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
>>>> uses a sort of state machine like switch to keep track of where it was
>>>> when EAGAIN was returned. xfs_attr_node_removename has also been
>>>> modified to use the switch, and a new version of xfs_attr_remove_args
>>>> consists of a simple loop to refresh the transaction until the operation
>>>> is completed. A new XFS_DAC_DEFER_FINISH flag is used to finish the
>>>> transaction where ever the existing code used to.
>>>>
>>>> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
>>>> version __xfs_attr_rmtval_remove. We will rename
>>>> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
>>>> done.
>>>>
>>>> xfs_attr_rmtval_remove itself is still in use by the set routines (used
>>>> during a rename).  For reasons of preserving existing function, we
>>>> modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
>>>> set.  Similar to how xfs_attr_remove_args does here.  Once we transition
>>>> the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
>>>> used and will be removed.
>>>>
>>>> This patch also adds a new struct xfs_delattr_context, which we will use
>>>> to keep track of the current state of an attribute operation. The new
>>>> xfs_delattr_state enum is used to track various operations that are in
>>>> progress so that we know not to repeat them, and resume where we left
>>>> off before EAGAIN was returned to cycle out the transaction. Other
>>>> members take the place of local variables that need to retain their
>>>> values across multiple function recalls.  See xfs_attr.h for a more
>>>> detailed diagram of the states.
>>>>
>>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>>> ---
>>>>    fs/xfs/libxfs/xfs_attr.c        | 223 +++++++++++++++++++++++++++++-----------
>>>>    fs/xfs/libxfs/xfs_attr.h        | 100 ++++++++++++++++++
>>>>    fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>>>>    fs/xfs/libxfs/xfs_attr_remote.c |  48 +++++----
>>>>    fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
>>>>    fs/xfs/xfs_attr_inactive.c      |   2 +-
>>>>    6 files changed, 294 insertions(+), 83 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>>> index 56d4b56..d46b92a 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>>>> @@ -1285,51 +1365,74 @@ xfs_attr_node_remove_step(
>>>>     *
>>>>     * This routine will find the blocks of the name to remove, remove them and
>>>>     * shrink the tree if needed.
>>>> + *
>>>> + * This routine is meant to function as either an inline or delayed operation,
>>>> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
>>>> + * functions will need to handle this, and recall the function until a
>>>> + * successful error code is returned.
>>>>     */
>>>>    STATIC int
>>>> -xfs_attr_node_removename(
>>>> -	struct xfs_da_args	*args)
>>>> +xfs_attr_node_removename_iter(
>>>> +	struct xfs_delattr_context	*dac)
>>>>    {
>>>> -	struct xfs_da_state	*state = NULL;
>>>> -	int			retval, error;
>>>> -	struct xfs_inode	*dp = args->dp;
>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>> +	struct xfs_da_state		*state = NULL;
>>>> +	int				retval, error;
>>>> +	struct xfs_inode		*dp = args->dp;
>>>>    	trace_xfs_attr_node_removename(args);
>>>> -	error = xfs_attr_node_removename_setup(args, &state);
>>>> -	if (error)
>>>> -		goto out;
>>>> -
>>>> -	error = xfs_attr_node_remove_step(args, state);
>>>> -	if (error)
>>>> -		goto out;
>>>> -
>>>> -	retval = xfs_attr_node_remove_cleanup(args, state);
>>>> -
>>>> -	/*
>>>> -	 * Check to see if the tree needs to be collapsed.
>>>> -	 */
>>>> -	if (retval && (state->path.active > 1)) {
>>>> -		error = xfs_da3_join(state);
>>>> -		if (error)
>>>> -			goto out;
>>>> -		error = xfs_defer_finish(&args->trans);
>>>> +	if (!dac->da_state) {
>>>> +		error = xfs_attr_node_removename_setup(dac);
>>>>    		if (error)
>>>>    			goto out;
>>>> +	}
>>>> +	state = dac->da_state;
>>>> +
>>>> +	switch (dac->dela_state) {
>>>> +	case XFS_DAS_UNINIT:
>>>>    		/*
>>>> -		 * Commit the Btree join operation and start a new trans.
>>>> +		 * repeatedly remove remote blocks, remove the entry and join.
>>>> +		 * returns -EAGAIN or 0 for completion of the step.
>>>>    		 */
>>>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>>>> +		error = xfs_attr_node_remove_step(dac);
>>>>    		if (error)
>>>> -			goto out;
>>>> -	}
>>>> +			break;
>>>
>>> Hmm.. so re: my comment further down on xfs_attr_rmtval_remove(),
>>> wouldn't that change semantics here? I.e., once remote blocks are
>>> removed this would previously carry on with a clean transaction. Now it
>>> looks like we'd carry on with the dirty transaction that removed the
>>> last remote extent. This suggests that perhaps we should return once
>>> more and fall into a new state to remove the name..?
>> I suspect the diff might be making this a bit difficult to see.  The roll
>> that you see being removed here belongs to the transaction we hoisted up  in
>> patch 3 which happens after the clean up below, and we have the
>> corresponding EAGAIN fot that one.  I think the diff gets things a little
>> interlaced here because the switch adds another level of indentation.
>>
> 
> Hmm.. the roll in patch 3 appears to be related to the _cleanup()
> helper. What I'm referring to here is the state of the transaction after
> the final remote block is removed from the attr. I'm not sure we're
> talking about the same thing here..
> 
>> some times i do like to I use a graphical diffviewer like diffuse when
>> patches get weird like this.  Something like this:
>>
>> git config --global diff.tool  diffuse
>> git difftool 3c53e49 e201c09
>>
>> You'd need to download the branch and also the diffuse tool, but sometimes i
>> think it makes some of these diffs a bit easier to see
>>
> 
> I think it's easier just to refer to the code directly. The current
> upstream code flows down into:
> 
> ...
> xfs_attr_node_removename()
>   xfs_attr_node_remove_rmt()
>    xfs_attr_rmtval_remove()
> 
> ... which then implements the following loop:
> 
>          do {
>                  retval = __xfs_attr_rmtval_remove(args);
>                  if (retval && retval != -EAGAIN)
>                          return retval;
> 
>                  /*
>                   * Close out trans and start the next one in the chain.
>                   */
>                  error = xfs_trans_roll_inode(&args->trans, args->dp);
>                  if (error)
>                          return error;
>          } while (retval == -EAGAIN);
> 
> This rolls the transaction when retval == -EAGAIN or retval == 0, thus
> always returns with a clean transaction after the remote block removal
> completes.
> 
> The code as of this patch does:
> 
> ...
> xfs_attr_node_removename_iter()
>   xfs_attr_node_remove_step()
>    xfs_attr_node_remove_rmt()
>     __xfs_attr_rmtval_remove()
> 
> ... which either returns -EAGAIN (since the roll is now implemented at
> the very top) or 0 when done == true. The transaction might be dirty in
> the latter case, but xfs_attr_node_removename_iter() moves right on to
> xfs_attr_node_remove_cleanup() which can now do more work in that same
> transaction. Am I following that correctly?
> 
>> Also, it would be
>>> nice to remove the several seemingly unnecessary layers of indirection
>>> here. For example, something like the following (also considering my
>>> comment above wrt to xfs_attr_remove_iter() and UNINIT):
>>>
>>> 	case UNINIT:
>>> 		...
>>> 		/* fallthrough */
>>> 	case RMTBLK:
>>> 		if (args->rmtblkno > 0) {
>>> 			dac->dela_state = RMTBLK;
>>> 			error = __xfs_attr_rmtval_remove(dac);
>>> 			if (error)
>>> 				break;
>>>
>>> 			ASSERT(args->rmtblkno == 0);
>>> 			xfs_attr_refillstate(state);
>>> 			dac->flags |= XFS_DAC_DEFER_FINISH;
>>> 			dac->dela_state = RMNAME;
>>> 			return -EAGAIN;
>>> 		}
>> Ok, this looks to me like we've hoisted both xfs_attr_node_remove_rmt and
>> xfs_attr_node_remove_step into this scope, but I still think this adds an
>> extra roll where non previously was.  With out that extra EAGAIN, I think we
>> are fine to have all that just under the UNINIT case.  I also think it's
>> also worth noteing here that this is kind of a reverse of patch 1, which I
>> think we put in for reasons of trying to modularize the higher level
>> functions as much as possible.
>>
>> I suspect some of where you were going with this may have been influenced by
>> the earlier diff confusion too.  Maybe take a second look there before we go
>> too much down this change....
>>
> 
> I can certainly be getting lost somewhere in all the refactoring. If so,
> can you point out where in the flow described above?
Ok, I think see it.  So basically I think this means we cant have the 
helpers because it's ambiguos as to if the transaction is dirty or not. 
  I dont see that there's anything in the review history where we 
rationalized that away, so I think we just overlooked it.  So I think 
what this means is that we need to reverse apply commit 72b97ea40d 
(which is where we added xfs_attr_node_remove_rmt), then drop patch 1 
which leaves no need for patch 3, since the transaction will have not 
moved.  Then add state RMTBLK?  I think that arrives at what you have here.

Allison

> 
> Brian
> 
>>
>>> 		/* fallthrough */
>>> 	case RMNAME:
>>> 		...
>>> 	...
>>>
>>>> -	/*
>>>> -	 * If the result is small enough, push it all into the inode.
>>>> -	 */
>>>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>>>> -		error = xfs_attr_node_shrink(args, state);
>>>> +		retval = xfs_attr_node_remove_cleanup(args, state);
>>> ...
>> I think the overlooked EAGAIN was in this area that got clipped out.....
>>
>>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>>>> index 48d8e9c..f09820c 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>>> ...
>>>> @@ -685,31 +687,29 @@ c(
>>>>    	 * Keep de-allocating extents until the remote-value region is gone.
>>>>    	 */
>>>>    	do {
>>>> -		retval = __xfs_attr_rmtval_remove(args);
>>>> -		if (retval && retval != -EAGAIN)
>>>> -			return retval;
>>>> +		error = __xfs_attr_rmtval_remove(&dac);
>>>> +		if (error != -EAGAIN)
>>>> +			break;
>>>
>>> Previously this would roll once and exit the loop on retval == 0. Now it
>>> looks like we break out of the loop immediately. Why the change?
>>
>> Gosh, I think sometime in reviewing v9, we had come up with a
>> "xfs_attr_roll_again" helper that took the error code as a paramater and
>> decided whether or not to roll.  And then in v10 i think people thought that
>> was weird and we turned it into xfs_attr_trans_roll.  I think I likley
>> forgot to restore the orginal retval handling here.  This whole function
>> disappears in the next patch, but the original error handling should be
>> restored to keep things consistent. Thx for the catch!
>>
>>
>> Thx for the reviews!!  I know it's complicated!  I've chased my tail many
>> times with it myself :-)
>>
>> Allison
>>
>>
>>
>>
>>>
>>> Brian
>>>
>>>> -		/*
>>>> -		 * Close out trans and start the next one in the chain.
>>>> -		 */
>>>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>>> +		error = xfs_attr_trans_roll(&dac);
>>>>    		if (error)
>>>>    			return error;
>>>> -	} while (retval == -EAGAIN);
>>>> +	} while (true);
>>>> -	return 0;
>>>> +	return error;
>>>>    }
>>>>    /*
>>>>     * Remove the value associated with an attribute by deleting the out-of-line
>>>> - * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
>>>> + * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
>>>>     * transaction and re-call the function
>>>>     */
>>>>    int
>>>>    __xfs_attr_rmtval_remove(
>>>> -	struct xfs_da_args	*args)
>>>> +	struct xfs_delattr_context	*dac)
>>>>    {
>>>> -	int			error, done;
>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>> +	int				error, done;
>>>>    	/*
>>>>    	 * Unmap value blocks for this attr.
>>>> @@ -719,12 +719,20 @@ __xfs_attr_rmtval_remove(
>>>>    	if (error)
>>>>    		return error;
>>>> -	error = xfs_defer_finish(&args->trans);
>>>> -	if (error)
>>>> -		return error;
>>>> -
>>>> -	if (!done)
>>>> +	/*
>>>> +	 * We dont need an explicit state here to pick up where we left off.  We
>>>> +	 * can figure it out using the !done return code.  Calling function only
>>>> +	 * needs to keep recalling this routine until we indicate to stop by
>>>> +	 * returning anything other than -EAGAIN. The actual value of
>>>> +	 * attr->xattri_dela_state may be some value reminicent of the calling
>>>> +	 * function, but it's value is irrelevant with in the context of this
>>>> +	 * function.  Once we are done here, the next state is set as needed
>>>> +	 * by the parent
>>>> +	 */
>>>> +	if (!done) {
>>>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>>>    		return -EAGAIN;
>>>> +	}
>>>>    	return error;
>>>>    }
>>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>>>> index 9eee615..002fd30 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>>>> @@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>>>    int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>>>    		xfs_buf_flags_t incore_flags);
>>>>    int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>>>> -int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>>> +int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>>>>    #endif /* __XFS_ATTR_REMOTE_H__ */
>>>> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
>>>> index bfad669..aaa7e66 100644
>>>> --- a/fs/xfs/xfs_attr_inactive.c
>>>> +++ b/fs/xfs/xfs_attr_inactive.c
>>>> @@ -15,10 +15,10 @@
>>>>    #include "xfs_da_format.h"
>>>>    #include "xfs_da_btree.h"
>>>>    #include "xfs_inode.h"
>>>> +#include "xfs_attr.h"
>>>>    #include "xfs_attr_remote.h"
>>>>    #include "xfs_trans.h"
>>>>    #include "xfs_bmap.h"
>>>> -#include "xfs_attr.h"
>>>>    #include "xfs_attr_leaf.h"
>>>>    #include "xfs_quota.h"
>>>>    #include "xfs_dir2.h"
>>>> -- 
>>>> 2.7.4
>>>>
>>>
>>
> 
