Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A98C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 06:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDD1C64FE8
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 06:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhCJGN6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 01:13:58 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57936 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhCJGNZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 01:13:25 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A698v0098243;
        Wed, 10 Mar 2021 06:13:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=IHM+4EsOSnfrfK2oy8LBn0idaEXHxhrAix1yAl2FaTE=;
 b=jkSg8BLhG+z9XN6rQpEwSXQDtBuJzr15nrRkB+6TbhxJU7FAgRsUd6tXIIFQK9jFGdVD
 UowZewbp4FFWMlQ17Fm5WY3dI3Kf1MSflDCsorPiCDPhYXhLG1snNYxOmhMd5ZgJN36I
 DOMkuvkQslRb73YDhtvfTbTtLZiU2dXHe1cB8Ua57Z0Zho/S4sHe9Ly39HiPb8raQedz
 42lW2gXdzUELxh5d0ZgYMRn7g1cY5UfJW3Iis2+sZIzWfaBCtR86nDAoj5RtJkFOxySl
 wsu10SSLiTXLsbK3NQhvZsXWuqbsMQCUTk0/NByasY1Noysmz4laOrV9K8MnZ5RhS+sg DA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3741pmhtde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 06:13:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A69VIw006234;
        Wed, 10 Mar 2021 06:13:23 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 374kn0g38d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 06:13:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnbF9l+FJzOhxlZiPzI14lPUjp1iJFdDeg613fdJA4yy8HyRu7X/IsuFmxoWyIBV2VCZJjToejPKXZzBTnlHTaenUY9KPR61oJY9QPFUcpIfPzPgpwCU0cBU7UWYk9GtMYnr3Kk0vRziU2zIbFb5yUXdzdSRiPa6EGzLdWrLTiitfdK8yZvnO5y9okICohLknaj2gS4xb8oiqiZLlZm9qjIkwUu2t04aZNS6XZ6Sf46dq4XZbEdpVv19YIzpBXe1RbWSpdmuj0NNa6uCkRk26WlS/isnUlqZ9moJooh+u3do8icYCvJ5ur+Y2Qk/4aCfXuY4x4n9Usyse7To8KKSiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHM+4EsOSnfrfK2oy8LBn0idaEXHxhrAix1yAl2FaTE=;
 b=dAl2sUfdftzVRynsv6YSgJ5xR7QeuWykXKCSWZVxUkZo1sPHCUkbbuwGcpoT9wiHwrp+l2nS0Ilnn1AH5W6+8q8MD2C2H8kmde7TWvYMBoeks/NeePE5UOOqIPxX5WQC/FG0Xn3xfDIG3Q4OW6CpB+U2qJ30F/Trr+Z7xf1C8ij4e/meJOHYRcfReGpdPA6tKXh2ZzLL/2dzE9M3tfZIFly7QsqJXwLR8bEBPGatUzLvOz1x5NLUbjenfJMXzA2A0yCD62wHAnDGNkyTCtzkzXUpTbnrzumMq6tiLXDcm/A0L8lPv0bwQ7qPBx0PF7Zdc9YXmxoyWcqMzohrtbl8xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHM+4EsOSnfrfK2oy8LBn0idaEXHxhrAix1yAl2FaTE=;
 b=qyqeVe5i0Bov7xwly85p5Hb12aJhKCHeym3xhvhVlVt043XHNMObKPl/uwxi+XKUex4afGNzXCpDv6S3f/3bJTZVfhjexiAF1MdHkfrQ/3aFIou2qab9WK59cLgrlx/ofIgigT3IxCh8emUcz1ZThIX9Lwf3JdambheVcffEYfM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3860.namprd10.prod.outlook.com (2603:10b6:a03:1fe::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 06:13:20 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 06:13:20 +0000
Subject: Re: [PATCH V6 03/13] common/xfs: Add helper to obtain fsxattr field
 value
To:     Chandan Babu R <chandanrlinux@gmail.com>, fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-4-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <148ab249-be7a-2686-7995-a256e34f292a@oracle.com>
Date:   Tue, 9 Mar 2021 23:13:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210309050124.23797-4-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0210.namprd05.prod.outlook.com
 (2603:10b6:a03:330::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0210.namprd05.prod.outlook.com (2603:10b6:a03:330::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.13 via Frontend Transport; Wed, 10 Mar 2021 06:13:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 789ab3b3-a865-4c07-d625-08d8e38b9a19
X-MS-TrafficTypeDiagnostic: BY5PR10MB3860:
X-Microsoft-Antispam-PRVS: <BY5PR10MB38601261FB51F491C7CDDFFA95919@BY5PR10MB3860.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XNovFJZ2CI4ceXthBJXIKpUQZc1B0v33E/6GGUfVTfJimM2lhfY2VmEasB95r4yL+JWaNlCP8XVPmVudxEq5LgC0DeOl/B5fAcGxDRjaYAcZh+lX8LdrpiNnYUGjBUQlow+Gy5SrqcjvmPv0QlJTMuYKxjgkkGa8lmVJiedLscvwtow6pDpn5cuuUtGXmpKqr5ED7ENEqfC5+ECU9RozzfeNv8GhAk4YvoMRhcbMm0VFZm+aw0P7FmOTmkVbfBvq+fvyvV8fTAZwDCCCx+yRy0H4bGqKJVRRkekQtttM0JYXSWWIvWyOIm9Chw2Ka7WzalY4CmtWBf8ePpYVBtBzp63ru8VD7YGMtqyk/JZITgQP+gG8hgmE7rqXnu0BZE5BFUvP0sIKqFtDUwBJ7CDDYKz9/XjhVGdeoArdkBfcOlYe/2m1d/xsA/syg/BXW2NMkW+ie0pHERtfx/i7Ak7kqn5bJA0mYlPThFvGOBncH9yKyZqprfc8ca7gKmbd9JVS8PCSaNi1EDAGOfttaI62ZjDq+qfo4tEX5mHyGCP1EzQnteMQl5bJU/xKZ3iiYpFzIQmWk/zPANc/JEHwNCdJPIvs+rO1P2GgUU7ay9mYeTU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(346002)(39860400002)(86362001)(2906002)(16526019)(8676002)(956004)(4326008)(2616005)(66556008)(8936002)(66476007)(26005)(66946007)(31696002)(316002)(83380400001)(16576012)(478600001)(31686004)(5660300002)(186003)(44832011)(6486002)(53546011)(36756003)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Z3VqRmJzUWErNjVKZlVSM3Z4Y2hkcTdnSWlSUDcxUWRVcHg2OHhtY09nVXho?=
 =?utf-8?B?YU9pazM5LzJTTFozdEwydHFlVnBkd3ZrSStyeUpqWXFaM25IZDVkc0UzT0t2?=
 =?utf-8?B?b0JTYzErMXRHOSsvOVRGMllUbWJnU251cTFSYmcxVVFoREQvOUJxbXZFZjY0?=
 =?utf-8?B?VWlVUGE0V1ZVekYzV0pjQ2Zqd09GLytSSnpqV0RsNTl2WExDUkZtYkJJaUV1?=
 =?utf-8?B?STFBandWUkZzajdFZFgxN0kzVUltVW1TMzJxWVNIUmM3MmZkNVhCQTlvbEJX?=
 =?utf-8?B?eFRTTWgvS0hrd29BeHorU29yMEw3emFyM3ZURVpSdmxjejIyaGJWYjJqRXBU?=
 =?utf-8?B?a3lXK0g2Uy84UjBzVzZKaExWQUd4bzc4UUZNcVJjZHF5NnZVcU1tc28xaVd6?=
 =?utf-8?B?ZnlPWGlBS2RNelRiNFVYbzc3R1BWMTNxM3ZJNlFhL0VjWWp5RlJsbk8yRFA0?=
 =?utf-8?B?M1ZJSWtZeFZkd05JWHRNanlDc1diV25rNFdCVmREd2JzRUN4TkM1djYveno1?=
 =?utf-8?B?eVFQSjArU2QzZGl4a3JDNjNuTzM2UjUvbXltbHJnYnJaV3BYTXM4ZGd5YUZW?=
 =?utf-8?B?UkdoUXNROHkvSUtOODYyb3JubWhqZTJjamN5cUtaekVhYWhsV2dvQ2RQMFNZ?=
 =?utf-8?B?dWdiL1d4YURGeFNTSkNsZ1NEYWpQMDFiUHd3ZzBGeXF1UllyUjRnU240RDBP?=
 =?utf-8?B?cDl4cURoc05NSjhVaFJKVWI4cjNQdkRNYzFiRWxZM2MzbndGVjFHVENVT3la?=
 =?utf-8?B?MkZIVnA0ZFF4RFhPK2xHV1VENE80Lzhlb1VOWWlyRnYxL1RhelovekpOTGFF?=
 =?utf-8?B?aTAwUGkyclhyS080MFBnRVBrNmszNGk1L3VrNisrZnA0TkNCbStFVldKeWRx?=
 =?utf-8?B?Ym5SVTlNQXc3MnFscWFpbGN5bjBQMWpKZ2pDY3B4K2E0b1RTQ0Q3d1dZL1RU?=
 =?utf-8?B?Q1hNMllJUC9DUDhtYm5iZHltTkFra0NhSnBmV0tvR3ZiQktXZGpNUEF4QWhw?=
 =?utf-8?B?S0Q1alBBTzR4WlYwSEkwRGNjV3Y1d2RJbkFzeXIzTXZYdXNCSXg4WE5vMnJn?=
 =?utf-8?B?VlZqK3FNcXJtUHQ4eDFPdkUxeS8rVzNYUjFsS3laamJZSUEwK05TMlZsVkE3?=
 =?utf-8?B?aEJPbDFVSnRGbVVFWFg2dloyRnI2SVdDSUJXNnRjeFFaR1hIVWdMa2ptY3Qw?=
 =?utf-8?B?UEhZOXFLaDRzV1pVMnZJUE9ROThHWmNsUEhCNzlRVm9PYlFzQXNyekN3ZFov?=
 =?utf-8?B?eWQ3ZUI4QVJuNTdXRkNEY0NFYlN5L0xVUTFoSWd5b3FHK0RxbHkycmxIKzdP?=
 =?utf-8?B?SnhvM1V3OGlEUkFoV2xVdjh0RC9GakN1QmwybHhYalF2eTR5ZW1oclVNYjlS?=
 =?utf-8?B?Q3FML1lUU05IbGM2a2d2M25VU1R4ZlJoTXV3MENIaDRNRjdNN1RwUUd2Z0sw?=
 =?utf-8?B?Z1d5UGZ0OU9TQnlWWGZKZ01Zc3NDclRjRHA4MVY1eWZBNlJXbUU1Z2xwWkFn?=
 =?utf-8?B?MWE3VmovVVBlZ08wbEdHM0Q4a1VNYlpVTXZFOVBoQ1VKVy84Um9PNDdsQXdh?=
 =?utf-8?B?VTFwV2pNUURXMEU0VUJwZzVwVFlRaGYvT0phM0lJOHUwNEZGU2F0YWlXbDZn?=
 =?utf-8?B?Q0JHbGc5RkQwWGxoMm9LeUswRXI3Ni9YM01xaTNydWZGUGwzNHFwcWRwMDFh?=
 =?utf-8?B?a0NxYnF4ZENNQUdjL2xmZjJWb3VLanh2SGl5VmJTYjVsMDZmZ1pyNGNxbkRk?=
 =?utf-8?Q?ks0XjDuFIjHCM5vEJpo0EVdWwcxvVCtZQSYAmqV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 789ab3b3-a865-4c07-d625-08d8e38b9a19
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 06:13:19.9732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dQhOuYN09n4H5+9yskOLBojJVD9nI5uR5zLPASKBol9px0cFNLW7NEF6CTXizR4ig2ygzaDz5yWPBw8gjydRVniOiqEI3TERwKAfBKdImXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3860
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100031
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100031
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/8/21 10:01 PM, Chandan Babu R wrote:
> This commit adds a helper function to obtain the value of a particular field
> of an inode's fsxattr fields.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>   common/xfs | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 26ae21b9..130b3232 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -194,6 +194,15 @@ _xfs_get_file_block_size()
>   	$XFS_INFO_PROG "$path" | grep realtime | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
>   }
>   
> +_xfs_get_fsxattr()
> +{
> +	local field="$1"
> +	local path="$2"
> +
> +	local value=$($XFS_IO_PROG -c "stat" "$path" | grep "$field")
> +	echo ${value##fsxattr.${field} = }
> +}
> +
In fiddling with the commands here, I think I may have noticed a bug.  I 
think you want to grep whole words only, or you may mistakenly match sub 
words. Example:

root@garnet:/home/achender/work_area# field="extsize "
root@garnet:/home/achender/work_area# xfs_io -c "stat" /mnt/scratch/test 
| grep "$field"
fsxattr.extsize = 0
fsxattr.cowextsize = 0

I think if you add the -w to the grep that fixes it:
root@garnet:/home/achender/work_area# xfs_io -c "stat" /mnt/scratch/test 
| grep -w "$field"
fsxattr.extsize = 0

I think that's what you meant to do right?

Allison

>   # xfs_check script is planned to be deprecated. But, we want to
>   # be able to invoke "xfs_check" behavior in xfstests in order to
>   # maintain the current verification levels.
> 

