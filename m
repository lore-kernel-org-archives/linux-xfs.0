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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977DEC43460
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6439561107
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhDBJr1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:47:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36878 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234275AbhDBJr1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 05:47:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329W3Om090473;
        Fri, 2 Apr 2021 09:47:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=JJBW5RvM42ysg8MA7Dlb14BHAqA1y4X517xGsrjj+Rg=;
 b=NrZSlZA/D1KQgbZqmHHwvUqAXUjR4ISeUwEzbqHwM4pUeKPhT5gC3nZnekw7ZqZ7W4pS
 a79UtjVcs+VR+fgyP+kSeDy2SHcVdIjJNWaCTU8Qc++wYHAhFFMCN0CuUatYqPKOBJhL
 oxjL2dV5Wnpqrq7T3HX4atsx2OIkaoXWl26nv76cV939eOs/nQnjXuqoxpHgJrSoqNzG
 IWJ8E5IykD3+oOrLbUf5UPtnD5BlEFzUw2FdgUJ68IDxN4GNTO5bPieoJLGjiZxiVZ5h
 7bupSIkaq8ait3yDRvy0AKPEUgjrQUls8C8YGYoPeueqVyA/YuMtZMTo+EcG8bFJmeZN Wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37n30sc803-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:47:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329il1k091419;
        Fri, 2 Apr 2021 09:47:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by userp3020.oracle.com with ESMTP id 37n2pbkytd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:47:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUhJG333jqKOwgwNHqmdGOFy7Zcm+kP6TaVcgX0fVJSmt1gZcP42g+b9A01erQIFE6husicODySRjXzewvrSXjhnLLVcA+vaU/JSObU+agKQ2w7A0CGogQbIQ/mS5Uujwbjeg4cwWeIj3B4yedPrhydrSbaMTkzxgjtxOcyqa/C9zUX/58FRCGmplpcjQrKB8vAUAIFbyLl9bQnl5WXAZ/VRGB/a7nBoeQ/4QjGCKw4hhgyGw1dm8BmvWVvCKv7xApXsDvuaLwcYj/R5eTIgCrtd6Z3sbkH2mTNNSjR0Q88m8P8oWfo8cH/D0wVRnRudqFdnqsa1zSzpz/nISdpzYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJBW5RvM42ysg8MA7Dlb14BHAqA1y4X517xGsrjj+Rg=;
 b=DCe1J7mkRwbpWkZib4PlyLKi8GwpbAlgzO44huWXhC2ZLLJhcwDmjC5j43MW5YOWL3LrD5dfnIloc9RcrrMs758rlcMrLBYbQ3uV7+AH9ow1+i0nZKbV8Il0MxVV4m6ozv5IMuAdosCkODUF1Hys0EaScCLzvceHh6QFchhrGIN+JvRndkZYATnuJxc3cIMIjGmanUzme33QHXLnpvxDIdnZjAXr3vyG7j0atJHEkWXgg9OjCoOChHZpew0eg881WAHlZw+IqzJHX0tDERBi5LGY8UEtdQ57Klkm9qq/8HDXmVNnEGPeHMXZ9ZE32waw6LfJ0SSARSSuxtgPsH4D+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJBW5RvM42ysg8MA7Dlb14BHAqA1y4X517xGsrjj+Rg=;
 b=Lv9yANi6aYLr/8pmW6DiD5knCNb74ufnmvqEGetnN4ebLD7t496M++0qWqgeJyza/LizUArqi3Mu5+RLc6dD8+nSVHEKqOTaayYmvsYo0qOjfRZT9K8YtIea6XdPve+FoX4RYlxZofM0w4OrIwEtggMF93P/vtsFTH9O+QkwunI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4813.namprd10.prod.outlook.com (2603:10b6:a03:2d2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 09:47:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.3999.032; Fri, 2 Apr 2021
 09:47:22 +0000
Subject: Re: [PATCH v16 03/11] xfs: Hoist xfs_attr_set_shortform
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210326003308.32753-1-allison.henderson@oracle.com>
 <20210326003308.32753-4-allison.henderson@oracle.com> <87im5ab9ip.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <9d1600e7-9aff-90c2-d5d2-f822388a0ca8@oracle.com>
Date:   Fri, 2 Apr 2021 02:47:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <87im5ab9ip.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BY3PR10CA0019.namprd10.prod.outlook.com
 (2603:10b6:a03:255::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BY3PR10CA0019.namprd10.prod.outlook.com (2603:10b6:a03:255::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Fri, 2 Apr 2021 09:47:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 099f0ac1-7934-43e4-362e-08d8f5bc509c
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4813:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4813EBE4FAEC59C00F3B2B3F957A9@SJ0PR10MB4813.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GSYqlOcpARw/moZml8NnZNFXAlKQC3jpc63f12BoDfIKOKuj7xG2+qcaNUQiqmkW1ufHTrK/Ez3xR/jWtxtfUU6bbDAkZqNki4KUS6QgsSa7etbb0LI7pyre+vpem+lwj/qxNs7zV++KT0y40xKxU7OEGivfWZzFaqoXAZbsjaU7vpxoUq5OKjFN4lC+59FZ6go6K6RlywAzk9foTO2ZkTLXGvR6WLxsxIR6c0AXlF54fr8QrabAM8jDv71HDvtfN0TdXKBTQvXYtDke4oNfzNHfF/mjnBBC7zyf0ZxRqmHch5pPnlefDOS/coj7tYpYZdiXYmek0LCk9jov9DhMK26RpGVMD194VYR4onlO56CRL/u0y/NoU17oChWvFUk1LhbDny1hKg0gbnAcqPkNiQw4oogMaeTRe9dkjbuAOmHK0R93JlxwS9/1IBwrHuqTy4Psdhna4cLwQZGA5mAwsFaIxSHqK+ucD91T3Av5sDWlt9dd0SISesGD0X7wtfRspoR7kRUEvixg1Xsan8hFEFNqDvdIfDTK/JbHhfcjP/4hdtiZLGbLh8aA4/PqL70wD//x1HlgX0glkn9GwozNjcr+fb+6UzR7/205Xoa5J96NpF/LkLTQ+7MXO+lJZx/Ckd8A4DHpm0Awu/Yc2P5vPUGKgBTj7tRDeUR15OBz00eI1xPs8lpQiZff1mAQDfPUPXDGCFXoijmWUnxW8tYX0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(376002)(366004)(346002)(38100700001)(86362001)(956004)(2616005)(16526019)(8936002)(26005)(2906002)(31686004)(186003)(8676002)(31696002)(36756003)(83380400001)(44832011)(53546011)(316002)(6916009)(478600001)(16576012)(5660300002)(4326008)(66476007)(66556008)(66946007)(52116002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aUxmT0ExQmhIQ1lTNVo0VnJvb2ppRzIxY0duM3piVkRpRW1neWIxN0FKRzh6?=
 =?utf-8?B?UjJrS2NvMCs0MFNQMHFBTkdNQ1hxWFl4Y3ZuNURDVUx4Rm1XVXlHelVjZ3pq?=
 =?utf-8?B?aC9oSHJXM1lyMFhNMzcwbVVXRmRZbFFCTHlhMTA0elBqYUZ2YW0rU2RuaXhq?=
 =?utf-8?B?OGZQRTV3blk3MTJJb24ydFpoY3Vnb0dXcW1mYk13TStFYmF4TkxiNlhxRTNG?=
 =?utf-8?B?NktMQzNhSmppeUlRNStjQkd4cUx6Wm1XbmFTQ29ud2ZrZE54TnV1YjV6Nm43?=
 =?utf-8?B?TENNU2tFVGIvOW9DZHJQd1pvY0VieFhSUWlkTHR2STFCci9ja2lnSWNNY2wx?=
 =?utf-8?B?bFc3YzRsZ3ZLcnFjYzBNVUdpN3cyZkc3K2lCWExTYUs3TzRnZ0pCWng3NUY3?=
 =?utf-8?B?V244V3NDYWFVQm5SamdYRFlzVEZiWExaWFRnQlBRN0thVWhvVFZWSEh1Nm9P?=
 =?utf-8?B?N0dPUmFIK3B1NHc3YWloNXBzZURYaDRPSndxbCtudEhJVUdieWhhSC9nazU2?=
 =?utf-8?B?dGt0dmQvNjMvTmZsYmxKcXNjK1BIZEJxYndGZVdIeGJrd2ZsRkF5ZGV6d1RG?=
 =?utf-8?B?ZEpOajIwT21oNlhsNEVzT0xQR2pCdDlOUGtBVVAraDRJd3N3OE1Jc3lrMXlX?=
 =?utf-8?B?Nzg0UE0wK0hIY3BDQjcycGZBeWt4N1czU1FDNytPVmltV1crWWg1ck0ySVlM?=
 =?utf-8?B?Ympid1pUSW5LdVFXbEJHVGlLa3dGTTFBcEJ4NE9qZUUvbG1VMGhSb0NiQmsx?=
 =?utf-8?B?eXREcE9pRVlkK0dHSFoybDQvZjIxbUE0SUhSWU05a1NkYWFSdkE0cmJqYXVZ?=
 =?utf-8?B?UFI2OU1GR0tZRVc1bE5VVlZKU2NPNmxIRHBrRVJ5L0ZKOXRBSUhBb0NqUm9L?=
 =?utf-8?B?VmRuMVdRdlhITkhYeUp0YVRrREJlM2xvVVdPZVNvb2NKa2c2VmJibndoU1lG?=
 =?utf-8?B?MXc0YmZOdjUyeXByV21vQWVwR0F4b0pVLzJDa0o2Ty9wdFRna0xTQ1F2SHZj?=
 =?utf-8?B?b2dzV09ISGUvcklncXJrTmNneXQzUHhLUkhsamNpSEJmR2RzNFpLaTR4Q1dH?=
 =?utf-8?B?UjVkcnM4WGt6dm10QWJndzg4U2lXdUIvTW53LzVUMmlXeXFDaFVTaHZaYldC?=
 =?utf-8?B?OUlVQTZUdGxyd0NkcU5GS0R6NTZGaEhHZjBrSFIzSktLdmJUb25SSUdxMW9F?=
 =?utf-8?B?eVpia0NpV0ZpTTNMeFZYV21lNTBKUC9zNnY5M0hFc0Q1dU9iVVF3aTlVazJj?=
 =?utf-8?B?UE5BVi8wa2tkTDJ2bUZ4ZmFQTzA2QnVZcjlTRExBeWFURE1FblNGeE9yZWdR?=
 =?utf-8?B?ODMxZE9nWWJselpCYTZpU3hRbmlLeFAydVV6MU5EQ3hNV012UWIrWUdqNFI2?=
 =?utf-8?B?SXUvOFJmYmJLQjZLTHlYMG8yejk3L1hWV3FWdXgzY0hDQXdYYlN6ZHp2b0U2?=
 =?utf-8?B?T3BPYUNKU2ZiRUsxdDMwVXhIVlNobjZVL1JYVVdERzZEL0tEbEMxeWVtT211?=
 =?utf-8?B?QXNpNXl1N1dWYUlOWnR4amZmSzNZOVY3N0JtOHhqdmF1ZkhUUWxjNSsyN2pP?=
 =?utf-8?B?ZU4zazJVYWw2aitkWHhOODVBeW5nbitVdGhnZHA1dkRlSWRwZFBrVUY0OExr?=
 =?utf-8?B?UmlSWEtrdG5FdmN0d2N2NnBWSmtiRnlCZExRQmt0UjhHbFdWWGxDNkRqSnZQ?=
 =?utf-8?B?emN5TzRzbXdUU1NGd1ZYL1h0cW53bkpHVXFJeExwYm9kNmpzNGdVOGRMYzg1?=
 =?utf-8?Q?KcxPFnOYSovd+GjiklvCikhnY8Anj0cFLrdLEiv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 099f0ac1-7934-43e4-362e-08d8f5bc509c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 09:47:22.9012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d7vr+HzTJ3ktZfEmOcOu/JCB6b3aXGl719RScWmAVsujxTXiVK35BSqTSepJU9UqY7pn65Qo4uHgH0d6NY/bddJjPFJBDJTviwpSmgltrWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4813
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104020068
X-Proofpoint-GUID: LxGE04T_d6gBWC1je_DqEMF83TyIhe6W
X-Proofpoint-ORIG-GUID: LxGE04T_d6gBWC1je_DqEMF83TyIhe6W
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0
 clxscore=1015 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020067
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/29/21 2:21 AM, Chandan Babu R wrote:
> On 26 Mar 2021 at 06:03, Allison Henderson wrote:
>> This patch hoists xfs_attr_set_shortform into the calling function. This
>> will help keep all state management code in the same scope.
>>
> 
> That looks simple enough.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Thanks!
Allison

> 
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 81 ++++++++++++++++--------------------------------
>>   1 file changed, 27 insertions(+), 54 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 32c7447..5216f67 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -217,53 +217,6 @@ xfs_attr_is_shortform(
>>   }
>>   
>>   /*
>> - * Attempts to set an attr in shortform, or converts short form to leaf form if
>> - * there is not enough room.  If the attr is set, the transaction is committed
>> - * and set to NULL.
>> - */
>> -STATIC int
>> -xfs_attr_set_shortform(
>> -	struct xfs_da_args	*args,
>> -	struct xfs_buf		**leaf_bp)
>> -{
>> -	struct xfs_inode	*dp = args->dp;
>> -	int			error, error2 = 0;
>> -
>> -	/*
>> -	 * Try to add the attr to the attribute list in the inode.
>> -	 */
>> -	error = xfs_attr_try_sf_addname(dp, args);
>> -	if (error != -ENOSPC) {
>> -		error2 = xfs_trans_commit(args->trans);
>> -		args->trans = NULL;
>> -		return error ? error : error2;
>> -	}
>> -	/*
>> -	 * It won't fit in the shortform, transform to a leaf block.  GROT:
>> -	 * another possible req'mt for a double-split btree op.
>> -	 */
>> -	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>> -	if (error)
>> -		return error;
>> -
>> -	/*
>> -	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
>> -	 * push cannot grab the half-baked leaf buffer and run into problems
>> -	 * with the write verifier. Once we're done rolling the transaction we
>> -	 * can release the hold and add the attr to the leaf.
>> -	 */
>> -	xfs_trans_bhold(args->trans, *leaf_bp);
>> -	error = xfs_defer_finish(&args->trans);
>> -	xfs_trans_bhold_release(args->trans, *leaf_bp);
>> -	if (error) {
>> -		xfs_trans_brelse(args->trans, *leaf_bp);
>> -		return error;
>> -	}
>> -
>> -	return 0;
>> -}
>> -
>> -/*
>>    * Set the attribute specified in @args.
>>    */
>>   int
>> @@ -272,7 +225,7 @@ xfs_attr_set_args(
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>>   	struct xfs_buf          *leaf_bp = NULL;
>> -	int			error = 0;
>> +	int			error2, error = 0;
>>   
>>   	/*
>>   	 * If the attribute list is already in leaf format, jump straight to
>> @@ -281,16 +234,36 @@ xfs_attr_set_args(
>>   	 * again.
>>   	 */
>>   	if (xfs_attr_is_shortform(dp)) {
>> +		/*
>> +		 * Try to add the attr to the attribute list in the inode.
>> +		 */
>> +		error = xfs_attr_try_sf_addname(dp, args);
>> +		if (error != -ENOSPC) {
>> +			error2 = xfs_trans_commit(args->trans);
>> +			args->trans = NULL;
>> +			return error ? error : error2;
>> +		}
>> +
>> +		/*
>> +		 * It won't fit in the shortform, transform to a leaf block.
>> +		 * GROT: another possible req'mt for a double-split btree op.
>> +		 */
>> +		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>> +		if (error)
>> +			return error;
>>   
>>   		/*
>> -		 * If the attr was successfully set in shortform, the
>> -		 * transaction is committed and set to NULL.  Otherwise, is it
>> -		 * converted from shortform to leaf, and the transaction is
>> -		 * retained.
>> +		 * Prevent the leaf buffer from being unlocked so that a
>> +		 * concurrent AIL push cannot grab the half-baked leaf buffer
>> +		 * and run into problems with the write verifier.
>>   		 */
>> -		error = xfs_attr_set_shortform(args, &leaf_bp);
>> -		if (error || !args->trans)
>> +		xfs_trans_bhold(args->trans, leaf_bp);
>> +		error = xfs_defer_finish(&args->trans);
>> +		xfs_trans_bhold_release(args->trans, leaf_bp);
>> +		if (error) {
>> +			xfs_trans_brelse(args->trans, leaf_bp);
>>   			return error;
>> +		}
>>   	}
>>   
>>   	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> 
> 
