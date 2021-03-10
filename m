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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A173CC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 06:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EE4864FE7
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 06:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbhCJGMy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 01:12:54 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33356 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhCJGMo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 01:12:44 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A69SkN048756;
        Wed, 10 Mar 2021 06:12:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=6nfQ8/GUlJfn5DzfYzdyE4FDPJJBufBMgGeg+XRE8ws=;
 b=fkhh3Ile6ARx/j+EMtRRpDSRwyihOlwlMokfZBSonBZBShm2URVYHaIL1OtklYhILu/4
 UsPDVmcNd5Ftv2kBxNGjhoxvLy3M2MWQiPGcFLmaGxdXf9msZz4WKFmx8t72jWSD7x1q
 Sc3XBkbLjK8Ausz8bgYHBRILnoSD05VF73ypQA2aeKnoCyitj71pQNTT0Rnz4lfASLYU
 ZGVDaF5EcvtADixUOQbTQ0RPLzItZbHq1UBxj7KA+H09RrFZIT0uGZmocUF1hTsACaqx
 tT4qIkYTp3Uw5tDLCjzN+9inayxQvOHYQL1/P8mlSd5jjBtIB1MKxP3gXfF6t278VQwk Pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 373y8bsy0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 06:12:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A69W7j006405;
        Wed, 10 Mar 2021 06:12:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3020.oracle.com with ESMTP id 374kn0g2js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 06:12:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VU32KdnHjkdZ4cBJaT6JMo89NVNyV+rwO14gV3T6eaaP0koRk5h0qIs/IM3DJugKntwU87/Rd8+3acKb52nrbVHUEL1TQfOr4WelmnTbue8Bj57awySG0/jgQ6KTyvuSumEWRHHYWQ8Anqnzt+R8bGgbn01Nd9yVRCCm55CQMLw0CF6P4htHSxnOEsCskPu02065pTy9Bjxb4CYs/kMGh+R7BljpUjVWrD8nSKtd4B1hSA4f9lLTSjGcFHMWSOks8Rj2jR0k9tsDtrZ+DEE09Z8JLAeidr7FZsAiGgIIZfR4lpfbr44rHTa7iQ5kU5t8hRNeUwcBy1u6EiSXXrVmLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nfQ8/GUlJfn5DzfYzdyE4FDPJJBufBMgGeg+XRE8ws=;
 b=CtRwq0WF9ThMFWujXkdafsVE2S+o9DkS7JctYozp9HeHaRi8ngRiob8KHY1CtKBXuvtc7/B1josCMKMzkvWcfHNeAg/rLRt4PGp8Jyb5Ll63V+zUO0QEGjqdI5sOxljb/0YVj8k9AwB1qpGfeoDkGcKpM2cvEIr2Psmyw2xH79Da9HivwE6aRAhmVGnv+cks2wZqvnwzdW/6uoaKt8aiXl3b+OYhKg3obzs3KHfIN/csG60weFE6LO2bhr2gpDevOVRRcvzg5mTMlckCmXrYp2OhDAPtEe2Ubq5dnkzOOb3DljOHbouSY4pm9ad8UQAZ9pCHggOgwIiSOeSNDOXS/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nfQ8/GUlJfn5DzfYzdyE4FDPJJBufBMgGeg+XRE8ws=;
 b=v/Dy336wnsi1DqNPAWAmO2pjKG/KNaVpcG/ZO9ghXfbUiyfaQS8sRntDL4A0qpzoeiHMVcHFm3If2IsMBu2/HkXeYmQ/O32nl4HQakuTTrPux7FDYmuxVE3AI0F2qpQb98RTEjR5xcUdARQE3YcK71xceTrq4HR3R7DicqWkdWg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2518.namprd10.prod.outlook.com (2603:10b6:a02:b8::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Wed, 10 Mar
 2021 06:12:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 06:12:39 +0000
Subject: Re: [PATCH V6 02/13] common/xfs: Add a helper to get an inode fork's
 extent count
To:     Chandan Babu R <chandanrlinux@gmail.com>, fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-3-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <187f9100-06e7-6f53-9192-fcb51818a423@oracle.com>
Date:   Tue, 9 Mar 2021 23:12:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210309050124.23797-3-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0195.namprd05.prod.outlook.com
 (2603:10b6:a03:330::20) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0195.namprd05.prod.outlook.com (2603:10b6:a03:330::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.16 via Frontend Transport; Wed, 10 Mar 2021 06:12:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b4b5225-6cef-4d03-b0c1-08d8e38b8212
X-MS-TrafficTypeDiagnostic: BYAPR10MB2518:
X-Microsoft-Antispam-PRVS: <BYAPR10MB25182B4BD1288B11A0C2755E95919@BYAPR10MB2518.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:328;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HhLCimFzwVCIbiA1Gjxp6SU+G0B4PK7bRGwISn7ITteF53hl0iI+gsTAHg8j/VS3UBwwgc6FxVoLq7rrBG1+qKOZea4VXHh3DdnRG3t5PPTyEDFryU135NNTKNzwUb0lxjBc6PuOl9hr3ALjV9U9HSwv44xzsQevRJqRZcKlal5/Je7HZ8Tn02b8KkxF6zFYarrXoKoCEZW+5GAFuTKBzLIiqIJ6/m6rBWKNHa/gNxgKd1SJ5bVIhNkdBNzGjWDHtpMwjSoSBJxGQl2Iu21IG3xwnh79TcDYASBfJe2q6E6oe5N7McArY2Y5diOq7S375MgOBhMY3kqN1Fevc5HOuRkOMOSJxMDY0EZWa3188WSkVcjEHCwjr6jt4lLE/t4pe7iAkf+yrMLFQDx6jvyrQLAZApo4wzfOHgX3bl7i/Y35cxx7zdV3uw9LyIUe2AVLiM/3iRPufEIlkWQOypVZ43RVmbjiy707YGAUH0F7LqBM9k1hpk5W3Qg/B/igPqM4lEHXavd2+xCdmzx1LzeVzteNKH0uFvCE+QMoUhHVGh4Ss7FcsuNuoqoNTQSg7Dr9NMLrfKBMGPJT3b1lGDPL0EGCjSkyDfAGVocZV+RDlbw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(396003)(366004)(346002)(8676002)(8936002)(53546011)(31686004)(4744005)(52116002)(6486002)(4326008)(186003)(26005)(16526019)(44832011)(956004)(86362001)(478600001)(2906002)(2616005)(31696002)(66556008)(16576012)(316002)(66476007)(5660300002)(66946007)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aDZmSHpoSStLSDRDb091R0k5VlZJQmRaZDNCZndTcFVOMUR1SVBBK21uck1T?=
 =?utf-8?B?SFhvV2Jtb0hwWFlncGtiSjB3bnNCemhZVlJzcS93ZjFMUnJ2TDVhR25tdWw2?=
 =?utf-8?B?Z1hZN3phR2NzZWFoUSt4enh6L3BQQXNJYUtNam5iRXY1TzVFT2ZsRXB3RGZK?=
 =?utf-8?B?VHJqUFQrT25xd0V5aXVvUVFGVzlvaEtUeDRBa3pBWW4xeVVoQXBISFdvTjV6?=
 =?utf-8?B?WHR0b1E3NGVZV2RzU2RXOW1qWHNXUmxjbjF4VGtCWWtjbnhRdUVkZk8wZ3VO?=
 =?utf-8?B?Y3VGZXpuTmdZNk10OHNURURQNEcwQU1GaFVZOXJhTktIdC90WDlZcHdFeEhU?=
 =?utf-8?B?WUtiQlAwZ0dlM1NLQXZtK0dheEpOMEVEcG1rNVA4SXYvNjFUVmZqei9sTkhi?=
 =?utf-8?B?OWd0eGRxV1IwbVVISjhhUmRHUytIYldkQm9aM2lMMkhoVlRGQTZPQXFRaXZH?=
 =?utf-8?B?c2F2NFdsL25VNFc3TjQzN1QvaTc5amFBQXQyNmJndGhsQmw4SXh6bVRxOEJ1?=
 =?utf-8?B?M0NZNUdyUVlKTElnMHNyb2VCS0hBRjhkWTZsU2MxVW8zNFpsVmVkaklxV21a?=
 =?utf-8?B?RW1OcEdkdEJmbHZ4NEIwZXZhMVV6Zm82cHBPVGFJUjdPUkcyY1hyZkxqZHVL?=
 =?utf-8?B?emQzNytmS3ZLazlLZFJNeVFXMEk5dG0yaEV0VGwwWTBIV0V2V0NEbHI1Sjhu?=
 =?utf-8?B?dzFCMW9BYlZqeU5MTEw2RW50S3FYNjVlb2Y4aEVHaWRBSWp1d0NpT1g2SG5C?=
 =?utf-8?B?bDN2bUttTlJpdTMyM3pyYzNpVFV6MHBqbDFQVVhVQW1VTXVwWE5XOC9KR2RN?=
 =?utf-8?B?UWl1SkpwNTY4QS9lcVlLdytJUWhFMEo0azc2V3E5eFJ1UUwzQTFIWTViVGov?=
 =?utf-8?B?cUY5a2txdjRxSFNmbk5RY1hObXNLbHlXY3FJbVFUTktWbFJuZndHWFpDR1Na?=
 =?utf-8?B?akZBQ01hZDFKNmZrcVBveUxRY2dkV1dnc25CM0JEM0d5eHcrL09GclFEL1Bn?=
 =?utf-8?B?aTcwd25oWHVGdXpkWDZxdElVeHZ3OGlTR3BUT2lYaXYwZDJBZHhLc1MrMVp2?=
 =?utf-8?B?aTQrbjIvN3duaWRERzVObFZLQTR0UzFGNXBnQ0FkMUZGcU96cTNQTGd5UjlF?=
 =?utf-8?B?ZXFuNkVBTmUzbFFyWGoxQk9Cb1dqRElQeWdRZFhOamtacEpiR3NkY0xRSU5D?=
 =?utf-8?B?elY0UTUvRzREVUF1NjdWY3BSb2I3cFlFckJ1UWwxMjFiNExCWU8valQyY2lX?=
 =?utf-8?B?RkNKMGp6REtIaHk2K1J5WEhOUnU3Y0ppd1MydG1sNWF0SlZKVHhmeDlTN1pp?=
 =?utf-8?B?ZldvaWRsc29lWUtZaGE1K1ZxNVhWQzIray94WW10aDdMZ3NNTi9VOEEzWXJX?=
 =?utf-8?B?Q3lBRUtWOTRPa3BEL2dpUHJRMzhTWk5sWTdIeVBEbDhOUm4weHoyY0U4b1JL?=
 =?utf-8?B?MkdXbkVLU29SR256S293ZHE3UFJDVFFmYm5jQ2FtMmlDWkNrTzVBY01rMUhk?=
 =?utf-8?B?UTNZL2ttZ2t4YmdSRytBdUtMd0lvR21YUXJNNXFrNVlzSkJ6QzgycityMmVS?=
 =?utf-8?B?eFprd1YwbTgwK0J2TE1COWZvYng1NjhoZkVxU213ZUxjMG5VVDF2SUk0U1hB?=
 =?utf-8?B?QWZDMy9lSmZPQTVjNnhwTjFDenNpOTY4b253cWNneDlIalBVaFBLcHJQSmVO?=
 =?utf-8?B?N2IydDB5Smtzamo5N0NJdlowNE0wUkZxZWcyZSttNTN6VlF3RjVmT011MWdO?=
 =?utf-8?Q?ztHKP4tT7iPnWJ2ISl0rBDO9IvEkpqTEmuL0tu6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b4b5225-6cef-4d03-b0c1-08d8e38b8212
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 06:12:39.7805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uPMNNtgPssSWOmw7d8OlYsUjwzod1L0KWUTt19A1izN/Gyd6Z93cr/PpNFWy++iKgW46NOmQXNDC25BwdOsM8uYXieODcP69PoOHkgY3ODI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2518
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100031
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 mlxscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100031
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/8/21 10:01 PM, Chandan Babu R wrote:
> This commit adds the helper _scratch_get_iext_count() which returns an
> inode fork's extent count.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   common/xfs | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 41dd8676..26ae21b9 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -924,6 +924,26 @@ _scratch_get_bmx_prefix() {
>   	return 1
>   }
>   
> +_scratch_get_iext_count()
> +{
> +	local ino=$1
> +	local whichfork=$2
> +	local field=""
> +
> +	case $whichfork in
> +		"attr")
> +			field=core.naextents
> +			;;
> +		"data")
> +			field=core.nextents
> +			;;
> +		*)
> +			return 1
> +	esac
> +
> +	_scratch_xfs_get_metadata_field $field "inode $ino"
> +}
> +
>   #
>   # Ensures that we don't pass any mount options incompatible with XFS v4
>   #
> 
