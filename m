Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E8FC433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Sep 2021 10:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C91F600CC
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Sep 2021 10:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242130AbhIYK2R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Sep 2021 06:28:17 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:28298 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234922AbhIYK2R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Sep 2021 06:28:17 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18P9826R019096;
        Sat, 25 Sep 2021 10:26:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=bxWxNYI74bTD1wqklihPFmiKyv0bqKkD98tjcnOcIE4=;
 b=fcReLQwMQL2ycSb06JlajuR8dYCkOky4WjNqpTQtMu+8YcBV0rO065rZisN3kzdFO403
 6eUJhEe7SdB46DyHH29cSdvds/alG6CpDqmC/OWvQ/d5BCozMk21JN/bUk+aYYtxuxPv
 EsQlAQaT6dY8iITeHWEWYw4ssooo823cw0JZSDcP0lQxXkFSaFm0qwufCFuqFclT4Xik
 flQa3IvJ+S0anS1RXnsrzU00II+3h0fAxDRrfS66hQeAXbff5zPpAD04+LkLjwdcKGWs
 BlPapCAlmtXuAbNOzXE0ZBGCmJXw/tqMpUaDrdjUtapqzzpAyj+czHsLJ5CSbBVc82NB Gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b9vatrkfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Sep 2021 10:26:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18PA9jNm094718;
        Sat, 25 Sep 2021 10:26:36 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2040.outbound.protection.outlook.com [104.47.74.40])
        by userp3030.oracle.com with ESMTP id 3b9rvrtv0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Sep 2021 10:26:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5pQ5rG4TuBKH+0IOsvUu7eicWa52miKI/s75TXLTWnbXDaPhlOxDHFvv7xYUUo7NxJja9tuNOOLyMEZvTF7TgxuD6C3Y5f0hT1V4sIsxPSZ7mSU6cAbN61jvVWwIZqV+kbg3dis20HVxFrUFPQRILvgz53YWvLakfRti6Y+hTYttamF8qYScoeyJKuVaYOivEsyAIquizjzOlrHRY6zH9DgR7GUpEF+rAdlW28MFjIKxilTbeY6uyuACmd/ncqk2gzEjGj947k7SYxKKV/K6dhz2zVHYwfSAzjtOw9u/NeFA873Abw8pXy5ArLtd9NZepKDY7HTbSd/BEWRHlYu2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=bxWxNYI74bTD1wqklihPFmiKyv0bqKkD98tjcnOcIE4=;
 b=AK+RNt1NbxTMAupYfLYUjzLvV6QyGp7NOvJEPlGfKezahNFgdhGFczY6dS1RFuo3zKRqgoqNCh3ibxGSqE9ZjUjfWOLMjdddfi28Jm4LAa8UOarTAstxr3xEZGL4YzeodI1aVnOj4jCsQg63q/ih4Ui2IZ9rP6+HMxUr/SZyBMeoVVw9KfNU8gzVsxrbHYWEIlXqHqm7Y9lL/8LVCwLEuQaHuouRf+5TBHZAbDUFT615OmMKwIit6APStLp/gs8rA9O0Uu4wh5eQUnoO73ZJ4prFLjsx6G9IZmIYbOXlIvCM2OObDXJS8Uryv50bShQs7esdEyAARxsdcnb+Pq+MYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxWxNYI74bTD1wqklihPFmiKyv0bqKkD98tjcnOcIE4=;
 b=nvH4Fzk2v0YebfjaAsr5KoMepCwbKLc8wh9rrzPLV6QBiwDOTfk4HNdD0jdwdGzd5V6g1gynijNVZQY+5lJ5i1WlSu4rwcwphWjvY4/1kLird5CzuFfqknt34r0boOfL04Kf/OSgucH1JMfdRDeochb5ZngL/odj67qpWvcO1M4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2543.namprd10.prod.outlook.com (2603:10b6:805:45::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Sat, 25 Sep
 2021 10:26:34 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%8]) with mapi id 15.20.4544.020; Sat, 25 Sep 2021
 10:26:34 +0000
References: <20210924140912.201481-1-chandan.babu@oracle.com>
 <20210924140912.201481-4-chandan.babu@oracle.com>
 <80546d48-9018-e374-2a0b-caf84e521ebd@sandeen.net>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        david@fromorbit.com, djwong@kernel.org
Subject: Re: [PATCH V2 3/5] atomic: convert to uatomic
In-reply-to: <80546d48-9018-e374-2a0b-caf84e521ebd@sandeen.net>
Message-ID: <877df52bow.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Sat, 25 Sep 2021 15:56:23 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0124.apcprd06.prod.outlook.com
 (2603:1096:1:1d::26) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.21) by SG2PR06CA0124.apcprd06.prod.outlook.com (2603:1096:1:1d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Sat, 25 Sep 2021 10:26:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a9b905b-d6ed-4cc7-6ccc-08d9800ef25b
X-MS-TrafficTypeDiagnostic: SN6PR10MB2543:
X-Microsoft-Antispam-PRVS: <SN6PR10MB25437FC82CD02AB503AD62D1F6A59@SN6PR10MB2543.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bGauJPe3NjyTaAA4wGo1EuJLrIE4MIqT6cYSaShe6gO0Rzs9hYdSq7jq3Ck0u/LmhqAADar6IypAo+CuA4E+oiQYaeXk6CKXFlEKStH8OXwVAdr1eUzIwmRa4SAROOsAT2pd/hQ4/j/pcM6Jfl1fJJP2ktqpYS9h/UYHQ2L87cLDTjiGufQein/lbPShlkOZrHNaX62MEP/H10+QBhWnMSAK7pVcscq9jd72AlJIsOxwNkg5/C25iCD2SdEOsqLMnkiajVedvmoizSlmVgUYhW5Xu0nxk9qnATPjtkdqzxkAR6haW9QD1Yxb7MOC/dDe0sl+MTfZPN8R9Vb7NxSXKU0AyKv/RT+29MLoVdQ5sE971s1TJOvL1xX2EN4SVztPY2P01+B02PXI1JbyWOf+gItjEAViqrs1HwMWyDKJtmcWjb6x022XLCTJHQ6M0CnbrOsSJeOG/ey0GSjXFqEyAe2lLPjs1sva+IC8SivizdselFqZurH2vKSMGITFxYd0IkW+7U0bBikcS+YRAiwYykbKJ5Obl2pLGU5tHktJ1CYVCbXXb9gugl+V4fXJzPd1r1+1XscwQgEgrXNEt0fRIg+vb3MFjyQQP/0roj3b/FtaOBRPCSdMTK3MOSE1JrBGosK5wuo+si8vvdxSdHSm15uh5lDz6jLleCxVXX2VdDh+WDIuxNSzNBdn1Pb6rYNybcmDofj8IbBAlKA/O5+Tm7yAfrXgKgIcnfGiG+tjkF4AdtXUxgz3xTBW84/unVavVJUuBR5w/Cpd/YxAXsYIWngleo44SfRMkzpJTn25ajc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(26005)(66476007)(66946007)(66556008)(6496006)(5660300002)(966005)(6666004)(956004)(8936002)(53546011)(52116002)(9686003)(38350700002)(38100700002)(83380400001)(33716001)(186003)(86362001)(2906002)(6916009)(316002)(8676002)(4326008)(508600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UrIL+XjanDmKhrqi9tAjOLp5lnJTRe+rSjjaZ5sh914+2Q3URxaKd7LnZavt?=
 =?us-ascii?Q?B7UTVHPhNKn6qlMx3OxULQDy/l0sCPku82HTr4MWRGER8BKwCY8WD0UVgOpg?=
 =?us-ascii?Q?vrZIF/NvB1IDP+6wj7kiFOEjB+jPmkeX/JLfWQxmDrofA8TUVNqnRMgaZW4a?=
 =?us-ascii?Q?463f+Ei9Ey26FNl5LCzoZsZK7LcOSKYC828YfV6KBSnDqiwGACU/V9uaGdxH?=
 =?us-ascii?Q?czvDjY5cu648pYfiVCYUw+G4Y/vYHwbYYYBtz4VrqJj2Or6UGPGffCBQKoUv?=
 =?us-ascii?Q?92d020Dd6TJHMesz3y0OpNGiedMnOr217N4FnE+xyccyQB3fxPX+45mp+MWq?=
 =?us-ascii?Q?M19NuC8XZOcvJjJgJU/VGuNxh5EIYNkHTqV5ZcFpcM5X7rDp7ZGJASjUyZzT?=
 =?us-ascii?Q?uLWZPmiG3XZh60wmJwMFLdjimB8lpmVtcLrN/tpVl4Yp2RBq7Jl8DAFz7n0u?=
 =?us-ascii?Q?avYBczbJqNwvHnb4ssDamkIMXv0GIl9BJ4n/0FraOm8sQh1IuspvhKhAhphE?=
 =?us-ascii?Q?P7vB/90lBbxcv0rqd5KtwH7m3h1egTQlhFUP9nvxmq50x+Qvo/9usmtx98KG?=
 =?us-ascii?Q?CCazJcxeSWtV5sbdywMtLjiUkcqvEoIWfWHbiMz9GFVFVLidMTn3ReGdA7Fc?=
 =?us-ascii?Q?v6CxEsYMMMRKWVZCurwFhPxNGU6MkNqxiNOqI82R0i4rOF7HCRn+3llwjn+s?=
 =?us-ascii?Q?/k8D8/oLTLqIl1J17/qxr+X28WrmBPZfCB9FbYulwX062M03vtv8CGNs6AW3?=
 =?us-ascii?Q?GyQhITAizYKTZDTGfrpivCp+kN1X1mPBzhsMd0GCbe3YcQKK1lSx/4jN4SMf?=
 =?us-ascii?Q?cqCUHUDu3fpiO2JKAfIoIUjf00cIzXOUkISrjogVkG0n/MFUcI39PeSop/mE?=
 =?us-ascii?Q?BlW2JtCJiVZoLH4AnSkuTLrQBGhcppV+UOHPpR5dLzRYa1GFR029B3SZoNgA?=
 =?us-ascii?Q?1z885l3RAQ8YUAPmINw7gFTQ+N0CG8VmpHgPEorjzWVvwZA9LS5d443vriq7?=
 =?us-ascii?Q?GNJnXkvrDtYnUJtYGfYWtmwlxu7NrTXbW6i4RlzB2Ng6jtYew0LPsfGaOExa?=
 =?us-ascii?Q?8MVujKjF0d9P1IwHkhC4ERemJkqXFKKXLsn3CNX5fNoGYL/A7bcFkrnjf03v?=
 =?us-ascii?Q?87e1mu89C6Rw/axDDiqbN80K9GqkVAh8XRHVCwsqyQVRPBygXuDx22An4gBh?=
 =?us-ascii?Q?u2N7uqOiiuLrur8NplCwp3M/UG1kVGoEypg6pZ5vWi/dEtpbYpfRuX9mTghs?=
 =?us-ascii?Q?IQAonZ2edrPPFzTazqyQO3Qw/6QJ3zd6Zjn1FBAl8/KOtHRAiQNLHBORoSTT?=
 =?us-ascii?Q?5EJdaqqA8nGx0MOelBxVXJlV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a9b905b-d6ed-4cc7-6ccc-08d9800ef25b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2021 10:26:34.0451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A7yGwJJ3pdK/NRZyY4tmVFGVJ9pKfZoditilunKScNq4aJtZlLd6/n4IKpj0FQw09FmQvXuNeOeHPmd14azXMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2543
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10117 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0 mlxscore=0
 spamscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109250076
X-Proofpoint-ORIG-GUID: sOiMTu7PhlTI8xmmz0ksYYI5B0clN6P-
X-Proofpoint-GUID: sOiMTu7PhlTI8xmmz0ksYYI5B0clN6P-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 25 Sep 2021 at 03:43, Eric Sandeen wrote:
> On 9/24/21 9:09 AM, Chandan Babu R wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>> Now we have liburcu, we can make use of it's atomic variable
>> implementation. It is almost identical to the kernel API - it's just
>> got a "uatomic" prefix. liburcu also provides all the same aomtic
>> variable memory barriers as the kernel, so if we pull memory barrier
>> dependent kernel code across, it will just work with the right
>> barrier wrappers.
>> This is preparation the addition of more extensive atomic operations
>> the that kernel buffer cache requires to function correctly.
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> [chandan.babu@oracle.com: Swap order of arguments provided to atomic[64]_[add|sub]()]
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>   include/atomic.h | 65 ++++++++++++++++++++++++++++++++++++++++--------
>>   1 file changed, 54 insertions(+), 11 deletions(-)
>> diff --git a/include/atomic.h b/include/atomic.h
>> index e0e1ba84..99cb85d3 100644
>> --- a/include/atomic.h
>> +++ b/include/atomic.h
>> @@ -7,21 +7,64 @@
>>   #define __ATOMIC_H__
>>     /*
>> - * Warning: These are not really atomic at all. They are wrappers around the
>> - * kernel atomic variable interface. If we do need these variables to be atomic
>> - * (due to multithreading of the code that uses them) we need to add some
>> - * pthreads magic here.
>> + * Atomics are provided by liburcu.
>> + *
>> + * API and guidelines for which operations provide memory barriers is here:
>> + *
>> + * https://github.com/urcu/userspace-rcu/blob/master/doc/uatomic-api.md
>> + *
>> + * Unlike the kernel, the same interface supports 32 and 64 bit atomic integers.
>
> Given this, anyone have any objection to putting the #defines together at the
> top, rather than hiding the 64 variants at the end of the file?
>

I don't see any issue in doing that.

>>    */
>> +#include <urcu/uatomic.h>
>> +#include "spinlock.h"
>> +
>>   typedef	int32_t	atomic_t;
>>   typedef	int64_t	atomic64_t;
>>   -#define atomic_inc_return(x)	(++(*(x)))
>> -#define atomic_dec_return(x)	(--(*(x)))
>> +#define atomic_read(a)		uatomic_read(a)
>> +#define atomic_set(a, v)	uatomic_set(a, v)
>> +#define atomic_add(v, a)	uatomic_add(a, v)
>> +#define atomic_sub(v, a)	uatomic_sub(a, v)
>> +#define atomic_inc(a)		uatomic_inc(a)
>> +#define atomic_dec(a)		uatomic_dec(a)
>> +#define atomic_inc_return(a)	uatomic_add_return(a, 1)
>> +#define atomic_dec_return(a)	uatomic_sub_return(a, 1)
>> +#define atomic_dec_and_test(a)	(atomic_dec_return(a) == 0)
>> +#define cmpxchg(a, o, n)        uatomic_cmpxchg(a, o, n);
>
> and I'll fix this whitespace.
>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks for the reviews.

-- 
chandan
