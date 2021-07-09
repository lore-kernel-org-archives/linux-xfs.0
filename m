Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98C23C07E9C
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 23:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E7FA60FD8
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 23:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhGIXmI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 19:42:08 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23846 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231244AbhGIXmI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jul 2021 19:42:08 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 169NUgLQ005583;
        Fri, 9 Jul 2021 23:39:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=zs/vkRDwPJWuuTKSyuqGTxkCu1801lnHVEAnrPk5+ug=;
 b=zx8UmvXXIJOoz1XdIe4opmFgjkWRL+FToVwuG1LSbOTmUnW9e1mvGahMu278p7RnByDk
 3XYiOtAkZcy1TA+R/ko4a+rutvIDatoPx/z3yGoAiMDEP4JJLayp/1OTeAI0BMZK6nys
 XTkdSeRn8URHD0ieoMIJlmOsHRmt/ZMb6KBC23X80yGyWBmlq6v8jSmCuANKgoAU15Os
 ZH9+IgmWO9m/tVsm7A8g8WIxiYf+vr0/e+Zx2jOf2smEUWsR0xJgWAdlpEmdXYNsDs6f
 vb3P7CrIRKNVwu0pc7BZLXkW9Aw28AtXmi91HTsX3DMZ8WvD8zjeBA5y82xET4uFpgJg 1g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39nphgmk7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 23:39:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 169NUKDJ030358;
        Fri, 9 Jul 2021 23:39:19 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by userp3030.oracle.com with ESMTP id 39jd1c8221-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 23:39:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SA+bv+4jy3V4WkkGrs83g2Y3SAT/0GJoJa6PXrQxYs1EiViRkyOFlv55HY76OkIuAGFCkLZumNBES39sMhoaOs2u/fvAiDg5lXv6chuEkqX2aDAounfo1k8tevfH9SHV1wEyazuqV/6s5eANeWJ/FZC7f/iGtDJYZrYry7iunfgqDerR5xkGmLClYc7Glp1ZJG57wnq6be6KySDc70EvF8ruxYrlgc1WD6TqSurl+z3FtbXht+CRmGuZFT8QLfZqlwbyAXeYUemyzry1gpgq8Hgq9jTFPT9Qnpmq5jjz/gd1BIm70ju0XzpKMDldo2CYrPrmj4YWYNYWs0jtaO7szA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zs/vkRDwPJWuuTKSyuqGTxkCu1801lnHVEAnrPk5+ug=;
 b=i04OPJ2incLi+ycxCBy5lMUPNm70jrggIMyLdgwgG3R7iwgv6isxFguxOx3igcvjS/1rOoHU1fnUeA+Hbxswn0S2I6VFtJxm7HnkBdvdh0u/7s7gDu9xhl0bR2XjCvIgxGGC+TPzrDsXfdlhDm9E4PvAzPECtkshh4oLsQDSewNp0xw2ekhq6V6T4EICQaaImZ/GM9oD4Kj5Sn8plUylcS16WriM1V0gp8PMFrY4x9l3rJf5pyzSwox31pGo3Dqyd+x2GrYNVKr1qHN/Emish6sC2WLxWHAbH1ibTt8AX3cQ/Ni1EHgJVggAKD7svEuoGc5++oxYFdtlpdK1eVI8kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zs/vkRDwPJWuuTKSyuqGTxkCu1801lnHVEAnrPk5+ug=;
 b=uWakM01uf+Qbu+RHfkmOWoKrM4T/QXkd0S+mahyHltM5QH14RBHbu2AmUj9VCURTs/H7MkF4N+Zkl0t5ZqHEVA8LZ6p4Vd9B3pIyUXodcOv0SV1ysGoPfVTgClVSDSZcvgYoBh09VfRk1TzfJsojlj2/81UPcutpBtTt+GzAHVg=
Authentication-Results: eryu.me; dkim=none (message not signed)
 header.d=none;eryu.me; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH0PR10MB5100.namprd10.prod.outlook.com (2603:10b6:610:df::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Fri, 9 Jul
 2021 23:39:18 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::807e:3386:573c:ad06]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::807e:3386:573c:ad06%5]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 23:39:18 +0000
Subject: Re: [PATCH 8/8] generic/019: don't dump cores when fio/fsstress hit
 io errors
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <162561726690.543423.15033740972304281407.stgit@locust>
 <162561731092.543423.12382027169225482171.stgit@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <39efd786-7b82-b4fe-a934-71db11193b30@oracle.com>
Date:   Fri, 9 Jul 2021 16:39:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <162561731092.543423.12382027169225482171.stgit@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0016.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::29) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by BY5PR16CA0016.namprd16.prod.outlook.com (2603:10b6:a03:1a0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Fri, 9 Jul 2021 23:39:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd871cb4-574e-41e6-c258-08d94332c4ce
X-MS-TrafficTypeDiagnostic: CH0PR10MB5100:
X-Microsoft-Antispam-PRVS: <CH0PR10MB5100B45319DF913E6FB2FE3F95189@CH0PR10MB5100.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:669;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uXsnwdCJvMhdHLMB/CIC45fOGaY2hYYpwAVU8c/0l3LaCK186Evc2h6NnNX58di9Ed4aHNRQYKPHbXBoJ5twDlOGyLcSJIxa7qFt4IE4hAKaGdhnjdVJo+8pkG0V78CLfpn8SloGgm718WV3YuKUHGMP4QtxIF+xLumNqMHRSI5kCMV81T7XOjvudkGzJvaR4z50cwUhyL2g3AjhqBc0zXYRT8hfjp4s2QX8Ljy1BVwTDCC/3cInBY7GDl71jMr5XOLFcabynMzEp86RDLf2z3JveDVHWPkRTisWvNzOpVS0f2DdgASUFLnoQANd/vgaVsucW2TSwa5Nj1+GbBa7oICEXFDmAm55BaGDBUx54RLgqgEhm9hA0IkI1qGplVfFKcdWQpCqyaJahgYqKWvnIZ67c1TsyeVd18WTdCKPrIY257OuQhAskXv9wFBIGK5NTMcV8iPuEPtD/W7jPuPYEtYtd3Q1brzakVzMGd7Wg51wbewQ0Jfl0p7V6tQooQzgqkkqV6NMveNvbgRKrw2FgAlyqlZt0r4s6IMzZKNXnS5EWzEhsjtxNx7AwGdm27dUhU0OkJl4MqRM6DfF6NF9q2n5a450lUUxw3U1GMlGRxDhIqGjO2r7xg9TwMYmMHTRvcJxSxpBBcD74sDczyETC1tPvnXpQk9pVdOIp8OPnWauIjxR8/+dKoQYtECdx2PbJXl8aruAwcXHANafjw0QLZrOEQkvKOJW7va0XvdD+17nCa2SzLtWfxhB3XMi5N5eIRYeelptfpz4OguDjPLSVT4FRT5sH8eMnDAzG/pciYI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(39860400002)(376002)(396003)(4744005)(83380400001)(316002)(31696002)(8676002)(44832011)(26005)(186003)(86362001)(16576012)(31686004)(36756003)(52116002)(478600001)(66476007)(66556008)(4326008)(956004)(53546011)(6486002)(2616005)(66946007)(38100700002)(38350700002)(5660300002)(2906002)(8936002)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTJKbHRLOWFlYkFRYjlJUk1PamY1dWVLWExwYVB6aEVicEZFaFo2UWNDSVB4?=
 =?utf-8?B?dDhWcUNLaWNEck9YMFZaLytUMUN0WThFTkVHa1NMd0RTNmVYRTZFdUJ5OWFi?=
 =?utf-8?B?eS9sOW9BVTc5TkpTVmg1V1hYRzFBOHZYQkFQeWx3T1FMZ3hUeHRENXE3MGZE?=
 =?utf-8?B?azhrQUYwM2Z4c3RFR2NvR1F2YnI2ZGNYaHpTTVRjcUk5OXM1SzhyT1dvVnRw?=
 =?utf-8?B?UHh5RG5VWEFXSTR1aVJsTDJ0b1V5dy9aZHcwVWR0a0YrVGhSR3BvQnRuNXli?=
 =?utf-8?B?dVYwb2lWdWpVSzdCaXpZQWxHcC9ha21Bd01ma2QvUU5zRnV2TUFTYkE4dGpm?=
 =?utf-8?B?OGZNQ0pmcitnZmZFRGdoSFp4TTJ6Y01rT0NTYS90WXNiVFFIM3JicGxyQncx?=
 =?utf-8?B?UXpEWUNiL2RwenBOcXRqdE1SNHE5b01CTUgxenRqNnBVM2Q4Sng4TjR4TVRk?=
 =?utf-8?B?VnVjTGY3RmlPZnlhUGJpTSswR25XVC9PMkxhSHVVRFZxa1JjTmc4ZDBOdXkr?=
 =?utf-8?B?TkFHdHk2N1VQWTRrWEFla2hKTFQ1akhSSWhpNFM4VlFqNUcxelgxcnVYTGw2?=
 =?utf-8?B?WGJEbTFOd3pkeHlreWxRUXRqL3Y1Ylh3K2JjYzRYMDhjV0tHcGxESGpVUTBz?=
 =?utf-8?B?RDNCL2djYmJTaWFIZWtObXRGZmZlNWVtRVB5Z0RSczdsZ2dVdEU0SFR1NWhp?=
 =?utf-8?B?NWpNK1V1cEliODhhRE40MjlvYlIwY3N2d2RaeVRkSmV3RmtMTDUvODBOcFBz?=
 =?utf-8?B?VmZzblpnR0diMmhQVGw1aU90eFdxVi9XallpRjlmMVJZbW05c3hnVHAxSlEy?=
 =?utf-8?B?dXNxUVk0ZVZPYUF2eUJjbFo5blhDSis2clBBWXg5Qk5LZzZ6UFlSK2JHYi9o?=
 =?utf-8?B?ZmNuVmtvN0d5clY3eU81OURUOFhDcU13L252UlZiSER6VndsMTZ0S0RKUDNY?=
 =?utf-8?B?Tm9rNUVjNVV3aDdqZnR0aFgveG81cjhUbFJNanJrS3kxUDRWMGN2L1E4ZjEy?=
 =?utf-8?B?TTNEcWVXdXVaQnA4UHgybndHQVQ4Zzg1K2dMZUFtLzZVeGtJZ0ZzajZmWWpx?=
 =?utf-8?B?UzZQaThKWklmbk91UUl0bFRQQk5KNnRjSiszaUtVMWpRaE85bEsvKzFvWGpi?=
 =?utf-8?B?ZFFWTU90MXRuZ3pONEpCQjBkck9TamZpRWYvQ29vZVlLOTQ2ckFHbnJsdlBx?=
 =?utf-8?B?S3lFQ3NtMWN5YnhXSXpzT0hYZzZWYXRyL1h1eUdRREEvUjVtR2VCRndLK2Zt?=
 =?utf-8?B?VUliMWxWN3hLSVJNbHhLYTZKNHZNa01wTm9aWTU0ZkNtL2FUNW9GaWlYWWFp?=
 =?utf-8?B?ZVN4ZVdFc3ErcklHcDZDVlVtRFI1ZlJnMlRtR1VadTVWMGdYcUplMmFIbHJD?=
 =?utf-8?B?YUJUM0hoWGpRV1ZRZmliaFJORFJZQXdBOG1pT3ZQWWU0b2c0OUR6WFJmWUk4?=
 =?utf-8?B?WWNaTWFya0JvaFpVUUdCbThpZmlUV2w2bzVKbTZLcUlYYVpkWHg3S2pwM1Bw?=
 =?utf-8?B?VjVIUUtBWXVUTEdLRHBxUnoyQUExMDJJbHdZempIT3Zta1NNalFodXIweHky?=
 =?utf-8?B?aXZMdGlsZmY0b2RtVHMvbFlqbDM5N1NWQzJUNXVocTc2d0Y1VDZZanlJeTI4?=
 =?utf-8?B?UFRISzJZWHZpeUFUdUVTVFFFaXA3NmJGK0pVa0s5NGs4Umo3MUlmS0pxTlIx?=
 =?utf-8?B?Q29TeW9tcnowdFJHdXYvQkFZU1cxb0sxOVN6WUdDY3gzUmNEWUlsYjYvNjV5?=
 =?utf-8?Q?DO9AGI3rUlmYCKLWN/QKAxVo6a8JeUVHGevrSCr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd871cb4-574e-41e6-c258-08d94332c4ce
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 23:39:18.0618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bxvGyduv9U/w+aJtK5Hq5uwdRQmgg4FBZxTRQVJT0ati7JUQAlN9wOPfbkIiUsCeO6EBYGLUUOJguCzktENVY/M9K6oWmVLFItFhguuqOdc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5100
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10040 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107090122
X-Proofpoint-GUID: lcH-ZI_n8ilxf9hVdfWtRG8j8dX5x4os
X-Proofpoint-ORIG-GUID: lcH-ZI_n8ilxf9hVdfWtRG8j8dX5x4os
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/6/21 5:21 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Disable coredumps so that fstests won't mark the test failed when the
> EIO injector causes an mmap write to abort with SIGBUS.
> 
Looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   tests/generic/019 |    3 +++
>   1 file changed, 3 insertions(+)
> 
> 
> diff --git a/tests/generic/019 b/tests/generic/019
> index bd234815..b8d025d6 100755
> --- a/tests/generic/019
> +++ b/tests/generic/019
> @@ -62,6 +62,9 @@ NUM_JOBS=$((4*LOAD_FACTOR))
>   BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
>   FILE_SIZE=$((BLK_DEV_SIZE * 512))
>   
> +# Don't fail the test just because fio or fsstress dump cores
> +ulimit -c 0
> +
>   cat >$fio_config <<EOF
>   ###########
>   # $seq test's fio activity
> 
