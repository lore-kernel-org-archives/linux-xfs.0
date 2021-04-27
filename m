Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D996EC433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 21:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A782561090
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 21:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbhD0ViM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 17:38:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34380 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237009AbhD0ViM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Apr 2021 17:38:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13RLavH3102767;
        Tue, 27 Apr 2021 21:37:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7jen6fW2ihewlSLXRpI3VAq/0tNSgneg45C08YX+1iI=;
 b=QgRIlPl7QFhLUr6NxUz/je2bBNMc/zqNKpoorsE43v8TRdD+NReuvrgC8GQQNgRsBbcD
 hXueCCvwaDN7kbJmcJcAvhmkEmwT3zEQrZxCKfDf7JrNAUgUcunTwJ+s5jdvu2dXaCiL
 BCUln5MtRyaDHSRKlzGfhd4aH4lH6RhoJzE2SqUjcVm5TD++8roRA1ktEOUp0zYFFSbA
 qKHot3YhrypaNrvbtQRsCluarIRmB4CYDeiXXECn9qGMDsP7CYO1MHBIfgyI86sbXKR+
 u2JJOJD2YkjWH0z/oRp6TN/wWIxcT3nKtgub5Jar+FL+JUnX/fLxR9IknevgqFPu1wCP nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 385aepy0kp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 21:37:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13RLTm8t041033;
        Tue, 27 Apr 2021 21:37:24 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by aserp3020.oracle.com with ESMTP id 384b57aqpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 21:37:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9B0h+tc1uiQp6GfNW6IgIRc2bR+eHRRf8eknB7crbrGxZMQcTyR0rDgIRB9U93Qmo5i08BZ8BN3XNawPIorGxFTgU+T8xPPSZCOGUGvfkazYrbd0PRlt0h4ofsnCdz8hJ/fc0T+sOmJxslH8DkelrRjG6rnq6vLZZME71sd/YADGose9iNEMAzajpGMXSCZg/yX+APTyri0Fvd7fteACVqDr2WGhOGZyZm/mC2KrGsLucXl6c29MwDkv5u1j25Bxuzen5vV2F8AvuKcpdB6xjRUvD7yZVOoB+mVBTKjRKRw5I3ExJLijIRO7pLJgkfoGyTCVoGY0QSshyyzjC9q6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jen6fW2ihewlSLXRpI3VAq/0tNSgneg45C08YX+1iI=;
 b=VyGPuQue7oCDo5PIXy219Ygx5ftq0UOiA6CW/S1ECwc8JkxTuxnZw13LR1VDrjMoVgblb2/zdaMTgxdheObWEwQq0vpcWoUDHRuI+EF99nGps81rPmSJb4yQac4psyW+hIDuaHr2S/cTGljanOENBAU6o6POF/AigwwM6XLjWP5mrnfZRata9kv9uMNYFkiPvemKAB5853oZ97wlQf38i7IKASXgYouvKEhLskmAwGhx05bIe2PTMYujtZj1QzydbNk9dNMjIJl+/MSUxbFS9kk4OmnVVl+NIGRPJyd/63sAAIKhPfOvljVT/V01NpKrwy29btOk0BQNYwv5GptxKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jen6fW2ihewlSLXRpI3VAq/0tNSgneg45C08YX+1iI=;
 b=OXWFX79TvhI+6aZDCxFG/fwdeo/SqKqwNHxsoA9Y0EQH+1cjkUC3tnxkS7JAwBPLxYtGYdCIlDUDRjhM/xFtXR0qVZQxBuLMPjgzchhgORRzwPYxvrN+C9LDAWoSLrTSbMaKEighKtRrVp1RKqvmYVCc1qOB4h+gLo6JToNOxto=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4637.namprd10.prod.outlook.com (2603:10b6:a03:2d6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.26; Tue, 27 Apr
 2021 21:37:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Tue, 27 Apr 2021
 21:37:23 +0000
Subject: Re: [PATCH v4 3/3] xfs: set aside allocation btree blocks from block
 reservation
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20210423131050.141140-1-bfoster@redhat.com>
 <20210423131050.141140-4-bfoster@redhat.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <ede8e754-df8b-ddc9-3c01-66110e7c6217@oracle.com>
Date:   Tue, 27 Apr 2021 14:37:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210423131050.141140-4-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by BYAPR02CA0016.namprd02.prod.outlook.com (2603:10b6:a02:ee::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Tue, 27 Apr 2021 21:37:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b400737a-99de-4195-20f4-08d909c4a48e
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4637:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB463789576642A5C5159DA0E795419@SJ0PR10MB4637.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OF9PHeOhIZ6P9/tWojUPaHvseKkyHJAa0S+6Fd0hRbO76hKLN5yleog5J1PrreaKP/WYsHMkPkqKTtgu66TrhqYDJIqenEkp6eMovplM6HRnfYj7+imwGJ4rga0xIYH4812OCFvsRrILWNi0TMCFwqmJKgFKPSrRn55zA3c/6oFwYVIUIpC5QpA7973OKb38uvPAcmEF5bMGnH/Ga7AjZZk5KkG74do/OJTVpyeQfw8hXzEUIeDuNEE0RH4jjYFV1eKIf6b23zvi93W1QdUfswqbcLsct7gSO0mmiBEgZN0zhdFmOt1ne38uXm2YDgon2JN4zaEIgtGUJEq411EX5rJpHeETUgctoNNJiljTuGjwLEyw6GJn5mcPas12JWReJF6Rq1yhnV7rkdF9hH8qSyLayv6yWvrHHO3S2JTV2ESsyh8ZagtFV3CGveYDY7GnEci0YGufKxLztelkLY9Rf9gDxNiBdse5RTGElhkNa/MiSHEZ2n6MCQdBB+JHwOftZZOzxt0S05xVZC9YOAtqOTiWGYQWrGl4tRyOLPz6FdXFs/YWPDIqAlDEptkWzhRG0hrLjqhIt1CNu7KpOjNMasIhkY955vdv9u01H19fIzmIEPOw5SbN4iJD4Rn6W1F8tWgGFA1wQmaug0/yPqfakKMEzO0Yg2YxYvWCcEfU+qbXdf39puzWu5LnVqIcoZxCwTyTSx/Pkza54QGX8cCmyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(366004)(396003)(346002)(36756003)(2906002)(52116002)(16576012)(53546011)(478600001)(316002)(31686004)(86362001)(16526019)(38100700002)(31696002)(38350700002)(44832011)(6486002)(186003)(83380400001)(26005)(8676002)(66946007)(5660300002)(956004)(2616005)(8936002)(66556008)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dDFZV2pXeTFJbkhSQjdoM1ROSkVPT0trQ3dmaUlFdTRZR1ZlV3VmUVNFWktH?=
 =?utf-8?B?V0wvQmdBb2Y0Q3g5NDMvRDRhSzF3cDkzNWlDa0VNUXNmV3FoVkFYNTQzMUpQ?=
 =?utf-8?B?NVhqQ21rUDBLaXZqTHMrbjVuazU2bXFnSk1Ia0hGdStlTHpwUVpaMk52ZWMz?=
 =?utf-8?B?ZVoyQkU5aDZsb2gvanREV1J0cEhILzZaZ2pHeWdIYWplQmo4cDgvYmFESk1m?=
 =?utf-8?B?NUovKzFlZ0hNVklGeXROT29LQ25oRDNVeUllaUxuMmRVMEgxV3BTRlBMN3RP?=
 =?utf-8?B?Qy8wTE9rejE4S0xQd05NNHVHNFg1Z1NPMkw2NG1WNDNVTXIxSTdybGdZRUZw?=
 =?utf-8?B?R0FiRDFiUzlrZ2YwL3I3RkZpa2JDeUJ2OFc4TUhoK2t1RzUwL0dSM0gvWmkz?=
 =?utf-8?B?T0JzdFc3VTdyZnZmNHU5K0pRUkVWRXl4NngwQ1M2cHBRWDZVcms5S1lueEVO?=
 =?utf-8?B?aXZwcWVqSDViZjY0QXUzZS8yblU3QTRxQnZSVFRvZHZEMEtjRkh6cUdVb1Fi?=
 =?utf-8?B?ZmlDRWN6cFR5UmREUnVyYWFTQmYxNitSQ3ByMjQvWmNxMEI4Yyt0UFlTMlJj?=
 =?utf-8?B?T3h4Yjd3bjNtUjRpenhtWjc3eTZVVlBhU2NVVHM5blFIVjQxcVNFSlAwcEVD?=
 =?utf-8?B?ai9JbTRXYkM2T2w1SUhpRFlXQUpWc2NLNEFXbEFiKzRVUzlHWFQwUEoxOWcw?=
 =?utf-8?B?MEJEN0JUZmRQTkdTYyt4bFU0M2I3c1pkNFZ4d0RmeEk4VEx0OFN6OFo4aEVq?=
 =?utf-8?B?emg2aHI2QytPUzNBdzBrQUdWdnZncWcwMUVXczl0bWc5VmdyQUpyemdBY09I?=
 =?utf-8?B?enQzenB0WmRzekZhY29yWmVVNWYrWG9UZHMxUm0rWTVuS3d3VTFXVGk0ZGNW?=
 =?utf-8?B?WnlRaEE4RE42WDgvT0Ywa0R4MmY3aXhvQ1dTckkwSzZ3a3h5cTBIelBKR0dV?=
 =?utf-8?B?Q2l6SlVOdUpKc2NzYVVEUUZ3aENyQkxxeGVQZXoya2FZclJOSjdNaHdua1A2?=
 =?utf-8?B?WElQUXZ6cU1hYU9HcVViNmtObDZoM0JhMkJ5dE5aRzd4Skl1cU8yME5KdWFq?=
 =?utf-8?B?anZZZENaY3plZmR0aG9yMnZjSmFZaWVwVUxNZlQxSk45Y1kxOEN1c2hnRXNO?=
 =?utf-8?B?U2J1N2haYm1aTkphYzU3VklUOXZnMzF6VXNka05mT3VsdXBsd3Fnay96YmJ6?=
 =?utf-8?B?WTdVZGdUZTl6ZE1HSENncjdmbVpKU2Q1RnIzZXN6Q3NucTdVY0szUlBwMDNS?=
 =?utf-8?B?UzdyYSt2OEQwVzFjOHQ2THFVd2NYYmlTdkNtQmd1alVmcExGUG95V0hMR3k5?=
 =?utf-8?B?Y0tqUkthK0xweGxTLzBpTEtWdDc5YkVpZzBCZEtJMndrM2dXRFQ1RGc1dEpa?=
 =?utf-8?B?SWRja08yczRmVDEyRXgxOE9xVWVRbm1GV2dDYVpabUdKc29VeWhtekZBTVBk?=
 =?utf-8?B?UTNsSTFJUnRMVFBkdTAyQlZPcCtGcE9Qa24zV3RxTUViSkxoYWJLWVk2a0t4?=
 =?utf-8?B?VUhNR3FzTWJ2cEJXYmlpV1JRd2l3UU43UlhINzBYa0Q4aFo1cnpuZGdVYXFL?=
 =?utf-8?B?U3BjRTVROUplTU15V2NYSmk0bkY5RkhEMHVXdkgxRlB4ZE42UitSNDJua3Zk?=
 =?utf-8?B?UDNKZXFtWlcwWmg3K3pCcjNFaENWNUdrZnYrTUpOYVdKOFBtZmNOUXNjVkFY?=
 =?utf-8?B?Q1phMGcwSlFXQUN2N0wxZXpXN2RxRXp4UFBVUVZ6bDVmVTZZRUYyMndPM1Az?=
 =?utf-8?Q?Z/+pyxwd71m8gMseKXvmxdvNx10md+ODOyH1Tu3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b400737a-99de-4195-20f4-08d909c4a48e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 21:37:23.0615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mFo5xCEHycL5wkvur6uiK5cprKzF2zZAW5uLy/gw94tDwWXuNVf5OJL4/VXiAZIGa00lBChuLEh/D917WMd2ASfOaiyb9JiREgiUeG5luq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4637
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104270144
X-Proofpoint-ORIG-GUID: OKP_Bx2KcxtroEmrtZNvx-gWh_S9zrwD
X-Proofpoint-GUID: OKP_Bx2KcxtroEmrtZNvx-gWh_S9zrwD
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104270144
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/23/21 6:10 AM, Brian Foster wrote:
> The blocks used for allocation btrees (bnobt and countbt) are
> technically considered free space. This is because as free space is
> used, allocbt blocks are removed and naturally become available for
> traditional allocation. However, this means that a significant
> portion of free space may consist of in-use btree blocks if free
> space is severely fragmented.
> 
> On large filesystems with large perag reservations, this can lead to
> a rare but nasty condition where a significant amount of physical
> free space is available, but the majority of actual usable blocks
> consist of in-use allocbt blocks. We have a record of a (~12TB, 32
> AG) filesystem with multiple AGs in a state with ~2.5GB or so free
> blocks tracked across ~300 total allocbt blocks, but effectively at
> 100% full because the the free space is entirely consumed by
> refcountbt perag reservation.
> 
> Such a large perag reservation is by design on large filesystems.
> The problem is that because the free space is so fragmented, this AG
> contributes the 300 or so allocbt blocks to the global counters as
> free space. If this pattern repeats across enough AGs, the
> filesystem lands in a state where global block reservation can
> outrun physical block availability. For example, a streaming
> buffered write on the affected filesystem continues to allow delayed
> allocation beyond the point where writeback starts to fail due to
> physical block allocation failures. The expected behavior is for the
> delalloc block reservation to fail gracefully with -ENOSPC before
> physical block allocation failure is a possibility.
> 
> To address this problem, set aside in-use allocbt blocks at
> reservation time and thus ensure they cannot be reserved until truly
> available for physical allocation. This allows alloc btree metadata
> to continue to reside in free space, but dynamically adjusts
> reservation availability based on internal state. Note that the
> logic requires that the allocbt counter is fully populated at
> reservation time before it is fully effective. We currently rely on
> the mount time AGF scan in the perag reservation initialization code
> for this dependency on filesystems where it's most important (i.e.
> with active perag reservations).
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
OK, makes sense, thanks for the comments!
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/xfs_mount.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index cb1e2c4702c3..bdfee1943796 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1188,6 +1188,7 @@ xfs_mod_fdblocks(
>   	int64_t			lcounter;
>   	long long		res_used;
>   	s32			batch;
> +	uint64_t		set_aside;
>   
>   	if (delta > 0) {
>   		/*
> @@ -1227,8 +1228,20 @@ xfs_mod_fdblocks(
>   	else
>   		batch = XFS_FDBLOCKS_BATCH;
>   
> +	/*
> +	 * Set aside allocbt blocks because these blocks are tracked as free
> +	 * space but not available for allocation. Technically this means that a
> +	 * single reservation cannot consume all remaining free space, but the
> +	 * ratio of allocbt blocks to usable free blocks should be rather small.
> +	 * The tradeoff without this is that filesystems that maintain high
> +	 * perag block reservations can over reserve physical block availability
> +	 * and fail physical allocation, which leads to much more serious
> +	 * problems (i.e. transaction abort, pagecache discards, etc.) than
> +	 * slightly premature -ENOSPC.
> +	 */
> +	set_aside = mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
>   	percpu_counter_add_batch(&mp->m_fdblocks, delta, batch);
> -	if (__percpu_counter_compare(&mp->m_fdblocks, mp->m_alloc_set_aside,
> +	if (__percpu_counter_compare(&mp->m_fdblocks, set_aside,
>   				     XFS_FDBLOCKS_BATCH) >= 0) {
>   		/* we had space! */
>   		return 0;
> 
