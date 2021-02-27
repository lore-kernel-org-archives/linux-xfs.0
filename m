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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7E5C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32C4464EE7
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhB0AuC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 19:50:02 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42814 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhB0AuB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Feb 2021 19:50:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0j8xn112300;
        Sat, 27 Feb 2021 00:49:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4nde6XSMI09dtoLS6aK3XwsB81tPeRzXBVuBLzq3AH4=;
 b=A8D1S4Ev76BHiPQmMNhHZvXfkOJAnP8tZLRysIeD5pO9O2uEBv6SLAMiCm1mdMNL2XwX
 LSqVCrLqLTAtsUnISGVqa/cGpVU0oKyG+/xRAB6oMkr2rMJNLHQG9iwFFioVEx2+gCVi
 LOMH/xrIK4CMaA4DVJfU08GgDbAk+SIBoLYKs+CC2HA2IwEs65+yENFofczliFcvt3Yk
 fw+gmlNUxv04+wixm8rBtdVFbBy9Ri8QW1sktP10gop9BrInBGgHsHTy4zW/gaQaUisB
 BeSsTz1kVLz+rMkLC/tIJNRB3ievN89AFgpDDzrIN0rTNjbEOZCVSnOm2s7N8n+bIcWF uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36tsurbph5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:49:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0j3sD005862;
        Sat, 27 Feb 2021 00:49:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 36ucb41u4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:49:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSScX9ibrws3fllELrqieFkMUYpj4hZeJJpMxbG2eFh91zp8Os81S1jVn6u7ElNkfPdJIUjBZuy5xy/RNlK2Rz/z/pmwntk5euFysjCJhT6kmQzQXCSF18aX8mFa7zTXSdWMZmXBYPS22DqRr7m8m72WCiDpPHS/ThclGSp60e8arcOSspx+9GaDRqxMslS4sNaZO9vRiDFiFs10IuN9zMvn+DaCC4QJKh2Evydbfk94TAUu5FhMBTUh5zVlUo/lEQcU2cYFEaFBIFbfikufKGStjyN8vTCOUNSjzkxyDstzyz5BBCUqG0puNqVApsIzlliwHmX8N19wzffbAnv3mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nde6XSMI09dtoLS6aK3XwsB81tPeRzXBVuBLzq3AH4=;
 b=NYUvLv5GqEo91hdq4GBmBGQfs8YA+v/WVSAfnMvaBwBqlKQ+nfPG2xF8BDGHICI/OygRfL3zQxLOliyCGgOnpX+riTSsS8/t8VrDIq6yzChc4chb8Yy1v/KxEolURvnGJvuJzN9PmIoAzHnzQ7TOcSz/Cztb47owt+3cz6unOdhSKSNu0uy4jqoVdKu49iLYy2oiLsHSq65luFv6uaSi918VMX+Ht4RouCnmpklJrHRJhJWZhHGsdGY5SnPTI+/sjnyj7sZId5/SuIlV2S5Q5KJ23fihpnBbnSgxON4amVeQPpj2KOWHR4LlUBVbJCURf83SPnzQd9UHzFQQqtP6kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nde6XSMI09dtoLS6aK3XwsB81tPeRzXBVuBLzq3AH4=;
 b=INRK+czIof3SM6cppJAuxDWu7QEjKJ2f8WElZ94WI5d8WNqmBwp+aomtBFdmaL33994vRKzPcfw32unpk0c7tTl4xNBTiXMarznzq3waqjWVQnNI3ksfyzd7mcFeWjsbYufiF5zuUwRI581slGbSSdla4eMKUeAM0CdxtPrMEl8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4446.namprd10.prod.outlook.com (2603:10b6:a03:2d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Sat, 27 Feb
 2021 00:49:14 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.020; Sat, 27 Feb 2021
 00:49:14 +0000
Subject: Re: [PATCH v15 05/22] xfs: Add helper xfs_attr_set_fmt
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-6-allison.henderson@oracle.com>
 <20210226030719.GS7272@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c919b643-4ba5-4b40-6696-60a06bfd2265@oracle.com>
Date:   Fri, 26 Feb 2021 17:49:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210226030719.GS7272@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR13CA0167.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR13CA0167.namprd13.prod.outlook.com (2603:10b6:a03:2c7::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Sat, 27 Feb 2021 00:49:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3b0a54b-bada-40e0-b45c-08d8dab9813c
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4446:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB444604098AD0FCD1E21C1CA7959C9@SJ0PR10MB4446.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4MyebpKb7diRJa/v/A56JoBXAs+srSZ69pDYvbRKnETLnWv9p2DOYcafks0Nod+vrj3Nr+JFdbt4CPVqMxeGZAXazpLFnEiT1rjVzJ06qzSQN8g/mkTTk9t2OYmpSFp8xBgja9dBuok8jMspolcvkwuE0TxqR9uh7Ak0evp6SdMslVevPbLr7nnAILNKaeLNhOvdmlJWMk0raMNtJhwO6hHfS8WIyA+RE26/2c62qGjJMQSyatocVGD6ksbMOHAHwZ0RRrmS0X2/tnW4D1qqKTxoXVY+Sn2zfItnq9Y16bCT8nyL7gs6CHkpDGzsUGryJ2fG1m30t2SkSMl8TH9SdUTweAJ9ANfr7ckk5DqMjgJ8wqH1DD9QUoDZ4MQozcQO8GcaA7YgPF4XIsAgMDy/YmK3YaWsNaEJFdQweKnmXolGl+fxK4jzjd73uzkLSZdFbQnyO7PvVxPqG29gIxY0AlovVA7gBP7xLQPQvjtCNoBiBYsWW4LqFA99G4liPDO5chdpY71OJqHyN3SdW7KKgac4+z8Zl4OSf6RrDEmVbJlj3jwFPTWQDcDTgqE8CPKD72HsMakQoOhwoMvPkQHeJ+g60QnfrGesRACvZyJmIVI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(136003)(346002)(376002)(2616005)(6916009)(31686004)(4326008)(16526019)(66476007)(83380400001)(26005)(478600001)(86362001)(66556008)(66946007)(316002)(186003)(52116002)(53546011)(31696002)(5660300002)(44832011)(956004)(16576012)(6486002)(8936002)(36756003)(2906002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TWhaR2cvNng1NVg2NU5wRHphY25iOTVEMkVESXNTMFc2RmZCcFJrUHloMGNN?=
 =?utf-8?B?M0l1RTc5U2RPcklnaXZNSlJPa20wUk1SeHlFS3lsb3NLOTcwQmxwanNwNlRm?=
 =?utf-8?B?clgwUEFxQXB5c0pSejFWMVdKN3JoWmhtbXI4VmJlL2VJVThkNEFya1NFeEM5?=
 =?utf-8?B?RTRyNTNxU2lqL2dZd0VhdG53ODVlMjg4OWV5VUZKeWh6YS9zcENwc2NGRDlQ?=
 =?utf-8?B?dk1jZUlsMjdBV2Rsc0RwM2l3YjJMVGdFWXJCMXdYdEpNVXl1UFJBcE0vbXd3?=
 =?utf-8?B?V3J3VFYvVWJDT1lpNG1UN29tZ1lsUzNVQ1oraWpTcHg0QVd2czlISERMZlVj?=
 =?utf-8?B?T1VWR3BwZ3BteENxK2VqREgyUzNhQjVjZVYyQm0xKzF5Nm5RWjAra2tQci9k?=
 =?utf-8?B?bGJXcXhNRnRDT0NiNktDUkRuZWpyZCtYNGU2bWsrWkNaL0U0V0lCQ3phU1Jq?=
 =?utf-8?B?NFZXVWJ5T2FmSG1LRTBmU0p2cnVab2UxbFM5KzJEaDcxSmMxNTk5TzNNY1Nn?=
 =?utf-8?B?SjVSeVVSNTEvN09SMlM2bDlXM1JzUnNGMk4zcVpNNStidERsSXVPY1BKUU1B?=
 =?utf-8?B?UmJFTkt4UVZKWHRqVUNmN2QrNEN0WXVqalNCdk14MGluZGtQN0p2WEt1Rlor?=
 =?utf-8?B?VEUrR20wR2c4ZHNyeXIxYzd3UVF1aVk2Qm00WXJzeGtDZmV0ZEdiVlJmeDFE?=
 =?utf-8?B?cGdIbXVNcDdkN1I1bE9CblpPQnIzcEpwTm5nWTA0NG5vY04zN3ZTeXR6UG9W?=
 =?utf-8?B?RjNIeXo1ellZbGJtbTdyUUliZTY0OXR0QzRzNzBsc3RYSG1Wa2pLdzFqekNN?=
 =?utf-8?B?M0l1SzlTcnkrR2trK2tsVlBjRjdzakdlVXdHRE05TDhDeHc0TzZ3SE9QSDJz?=
 =?utf-8?B?eWRHdnlVcXJSTWNjM3ZWRWdERENjajQ0QlVHd0pCUW5QMGVROW5NVVBjb1E0?=
 =?utf-8?B?bnY3VnhLSEo3L3ZrUHhOSmM2OUhaTHNUajN1VGJTb2hjOGVWQnpNM0RncGxG?=
 =?utf-8?B?SnkwcStqL3JUcTFwYXZVMEQzZER5U29VazVnbzl4SmFSTCtUb3NtcnZtMFpV?=
 =?utf-8?B?TWIrZjRuamN2aGFGS3FxcGFEUmhxa1JId1RTY29jMWRRNFZvS0JvY0dLbVEz?=
 =?utf-8?B?cFVnek1kdUo3bHBidVY3VTFHOW02MC9YZEFOcDdIWFNxU0NkREZ4UjJmbnc1?=
 =?utf-8?B?OXdYVUx3NHZVYk9jb1RReE9hTGVqWjYreEtHaTdLbmtkM2NMNThKRWtuem0v?=
 =?utf-8?B?SEVrUkFONkdmcDBRelY2dFc5V0NLNjJmWUZxdkZZaXNlMjBxR2xqRUdHTDJj?=
 =?utf-8?B?a2ZYb1R5cERKSkI0NWhhbGpBRS94aW5KdmRwYVlYaldUVHVaNnVqekl0MU0r?=
 =?utf-8?B?Vjc3Vm1YdXR5aW9JWEZxVW53dlRzS2dCL01PSndoK2pQNCtmT3JWN1dVM21E?=
 =?utf-8?B?QXZxUDBUV2RqbHpocG81Q0U0V3Zub3NaUjd0VmlFdjUrbFBLMERHSHF2MXlp?=
 =?utf-8?B?NURyT1liMkIxQnNidjIzS1R1ZTRHa0dvdjRwekgwcks4Z00zZ1N0RWd4UHZq?=
 =?utf-8?B?YmJvK2ZLa0xGd3MvWjBabDdOQU94UEtPaU00YjR3WkFQSHBYZXdhd3IvUjlm?=
 =?utf-8?B?UzcwSjErcnJlb2dselpyOTQzZHpKTExvZXY1emdGeTRSbXJJZGdVZ3RNSG51?=
 =?utf-8?B?b3VjRlp0Njk2NmlhbDVGL0NNTTJYenRHQnZ4aWxsa2s1QisvTjI3NEV5MlNK?=
 =?utf-8?Q?km3qfOyIeehlRHMUSFRDgQF58Zi0ed3e1gMwb4S?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3b0a54b-bada-40e0-b45c-08d8dab9813c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 00:49:14.6462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3RGBj0IOHC9GJFon1+s7S/afzXxziLmer5CRTuoE25Zh8I3nLjfdkZeieyBxwkk6yLdNKfRmyxxUYd/HdMVV3xS9PHMSQ6REYJG5TohMxHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4446
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270001
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/21 8:07 PM, Darrick J. Wong wrote:
> On Thu, Feb 18, 2021 at 09:53:31AM -0700, Allison Henderson wrote:
>> This patch adds a helper function xfs_attr_set_fmt.  This will help
>> isolate the code that will require state management from the portions
>> that do not.  xfs_attr_set_fmt returns 0 when the attr has been set and
>> no further action is needed.  It returns -EAGAIN when shortform has been
>> transformed to leaf, and the calling function should proceed the set the
>> attr in leaf form.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 77 +++++++++++++++++++++++++++---------------------
>>   1 file changed, 44 insertions(+), 33 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index a064c5b..205ad26 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -216,6 +216,46 @@ xfs_attr_is_shortform(
>>   		ip->i_afp->if_nextents == 0);
>>   }
>>   
>> +STATIC int
>> +xfs_attr_set_fmt(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_buf          *leaf_bp = NULL;
>> +	struct xfs_inode	*dp = args->dp;
>> +	int			error2, error = 0;
>> +
>> +	/*
>> +	 * Try to add the attr to the attribute list in the inode.
>> +	 */
>> +	error = xfs_attr_try_sf_addname(dp, args);
>> +	if (error != -ENOSPC) {
>> +		error2 = xfs_trans_commit(args->trans);
>> +		args->trans = NULL;
>> +		return error ? error : error2;
>> +	}
>> +
>> +	/*
>> +	 * It won't fit in the shortform, transform to a leaf block.
>> +	 * GROT: another possible req'mt for a double-split btree op.
>> +	 */
>> +	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>> +	if (error)
>> +		return error;
>> +
>> +	/*
>> +	 * Prevent the leaf buffer from being unlocked so that a
>> +	 * concurrent AIL push cannot grab the half-baked leaf buffer
>> +	 * and run into problems with the write verifier.
>> +	 */
>> +	xfs_trans_bhold(args->trans, leaf_bp);
>> +	error = xfs_defer_finish(&args->trans);
>> +	xfs_trans_bhold_release(args->trans, leaf_bp);
>> +	if (error)
>> +		xfs_trans_brelse(args->trans, leaf_bp);
> 
> Shouldn't this pass the error back to the caller?
> 
> --D
Yes, I must of have missed it in this temporary phase of this function. 
  It quickly gets pulled back out when the defer_finishes go away, but 
will fix for this phase in the series.  Thanks for the catch!

Allison

> 
>> +
>> +	return -EAGAIN;
>> +}
>> +
>>   /*
>>    * Set the attribute specified in @args.
>>    */
>> @@ -224,8 +264,7 @@ xfs_attr_set_args(
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>> -	struct xfs_buf          *leaf_bp = NULL;
>> -	int			error2, error = 0;
>> +	int			error;
>>   
>>   	/*
>>   	 * If the attribute list is already in leaf format, jump straight to
>> @@ -234,36 +273,9 @@ xfs_attr_set_args(
>>   	 * again.
>>   	 */
>>   	if (xfs_attr_is_shortform(dp)) {
>> -		/*
>> -		 * Try to add the attr to the attribute list in the inode.
>> -		 */
>> -		error = xfs_attr_try_sf_addname(dp, args);
>> -		if (error != -ENOSPC) {
>> -			error2 = xfs_trans_commit(args->trans);
>> -			args->trans = NULL;
>> -			return error ? error : error2;
>> -		}
>> -
>> -		/*
>> -		 * It won't fit in the shortform, transform to a leaf block.
>> -		 * GROT: another possible req'mt for a double-split btree op.
>> -		 */
>> -		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>> -		if (error)
>> +		error = xfs_attr_set_fmt(args);
>> +		if (error != -EAGAIN)
>>   			return error;
>> -
>> -		/*
>> -		 * Prevent the leaf buffer from being unlocked so that a
>> -		 * concurrent AIL push cannot grab the half-baked leaf buffer
>> -		 * and run into problems with the write verifier.
>> -		 */
>> -		xfs_trans_bhold(args->trans, leaf_bp);
>> -		error = xfs_defer_finish(&args->trans);
>> -		xfs_trans_bhold_release(args->trans, leaf_bp);
>> -		if (error) {
>> -			xfs_trans_brelse(args->trans, leaf_bp);
>> -			return error;
>> -		}
>>   	}
>>   
>>   	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> @@ -297,8 +309,7 @@ xfs_attr_set_args(
>>   			return error;
>>   	}
>>   
>> -	error = xfs_attr_node_addname(args);
>> -	return error;
>> +	return xfs_attr_node_addname(args);
>>   }
>>   
>>   /*
>> -- 
>> 2.7.4
>>
