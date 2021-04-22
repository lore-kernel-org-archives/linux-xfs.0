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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF22EC433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 00:29:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A97A66144D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 00:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343912AbhDVA3v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 20:29:51 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61358 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235010AbhDVA3v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Apr 2021 20:29:51 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13M0R0R3010865;
        Thu, 22 Apr 2021 00:29:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=pXa4Kmvvoaz/ohVOF/G4zPzTo4FOWwp6p0oc+81eAlo=;
 b=ECoLA0tMTlrwaAFdWS0ALm+A/lvVsovtarNwXdhG+XNcjsb2RtniGGXqqaVKFYPQyENb
 Eqvo0ExouJMQD4tKzq3XLlBGjJ7t+L5fcseZ07PyeJxcmW0qwf500LjZQWDclSI3glsq
 BWjMiidxOEjr7qR7tobD+bqk792KpNPub5tHU8NoYxTI2e4E+dp04pzgsaFLqKYYbYMb
 87pV1RXK7AvsTnLeVrwdJPSktf2taecSynpvkVWVw9vnIheb6s8lTOD9f23D9xcKUagq
 fi2Ecwscd73UPJ7E/gNtSshTtvWzE3tem9/3uR9fh0Zu8Q2GcEZIu1zDvrkJW74OE5H5 sw== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 381dum8wg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 00:29:14 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 13M0TDaD171591;
        Thu, 22 Apr 2021 00:29:13 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3030.oracle.com with ESMTP id 38098see62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 00:29:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TovasSZ3PYONXUo5pzRR9Mwazj4gDAc8KuzksgMTjwx9QFZs2vlxcX+p8J03Gi0DCZ+4oPrDeBUiW7cki6jbs0wRo9deXKFWvX4L+PgRdX72Te1fdr5p5cPyWZmsnT/aQ5OF3jTz5C50BgINQADY98MhrLCcy19CgQP1OrZDi3N+hSV5xWEbZ2CH3cUukZTex3p1AHaN74jWI/tBVoXWUqQLaRwokrFLyXjmfocIvmxAot/1OV8p+ft3TAxvTW+hN5tGL4MwEehbeEAuiGTHITpWvaCH2QZ8+oUxyQpUB3v39GuXkcJYtoaI+RZ6Gw4l+dKoSfK2kXfV9yaXg/+j6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXa4Kmvvoaz/ohVOF/G4zPzTo4FOWwp6p0oc+81eAlo=;
 b=DaaR7sS7k3EAz7sqpIbV9PEn4+vL6Eh5JDiBzYipl/A6dawjnzDYxosPMv8hYE/9lm4J9NBWQbSeskANRNUkdiKZbWerNUr9R/ubhCoXCRkhCvKFU0d9Xi5yA16araASTYgBltxG/ArYZ7jvm6MZnzsgZiYMRJzVSenvmWBfcy/kysOl87Q1lK7c2YxMsw+gr/jH7RviHnTatnUwlksMWo15/qMjK4/9HintuomfLd2sCXbatiNTPhqDn09sZwlUIFSeA1K8sPM6/si5GNZ923fZ3CHYG2MF16Wd0QsZXkI5nlqFhhOIaANN5W7Rdh+ziRcVf9G1SrqrR0lS77F1bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXa4Kmvvoaz/ohVOF/G4zPzTo4FOWwp6p0oc+81eAlo=;
 b=DAk48iUknEq61rTIGBuf++Np0EXNrtHPCmlykI7056e00aVMA0H/5ov7tFw7/k4dhSGEwTIMm2s0jZYL56hk23yohJv6F+WX5tk6IlW2CN+GzI13N3/4FN8xJzgYB4wGcajJ6L6NHzmrXeW4Yw7T1LMoMeCndfpt9EB/0VCZ03I=
Authentication-Results: eryu.me; dkim=none (message not signed)
 header.d=none;eryu.me; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2517.namprd10.prod.outlook.com (2603:10b6:a02:b4::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Thu, 22 Apr
 2021 00:29:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 00:29:09 +0000
Subject: Re: [PATCH 2/2] common/dmthin: make this work with external log
 devices
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <161896453944.776190.2831340458112794975.stgit@magnolia>
 <161896455168.776190.4208955976933964610.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <85471e6f-c42d-bc03-b765-99e67b7891d6@oracle.com>
Date:   Wed, 21 Apr 2021 17:29:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <161896455168.776190.4208955976933964610.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR07CA0025.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::38) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by BYAPR07CA0025.namprd07.prod.outlook.com (2603:10b6:a02:bc::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Thu, 22 Apr 2021 00:29:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cbc425fa-b51e-432d-bc42-08d90525a56e
X-MS-TrafficTypeDiagnostic: BYAPR10MB2517:
X-Microsoft-Antispam-PRVS: <BYAPR10MB251722AC49AC18941E0314FF95469@BYAPR10MB2517.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EZG+BCQQegBFVy2NPpeMf+YLjML2UXtv8FKuOGIGs8pUolziPsjbanUicspY+x7LUgiksEIJQvxv+6Ys5WdNUiXD+LlgbkCcQHCW8XFRzNzZJTFy6RAajoG9lvy7k9KTnRL3UyR9P7Z/fzoJ96fryWomwfcREJm0+/n+yUePRApAjgmBg6LT2dtH6I+R9R5vs39d2VL8oZYP8tHCvxMbYhYrhpHFPJFmFKyUw2ThbU1tTnaJfSGWH6ri65vzUDB/Nplqpp/tL8tMs+TekRD8V756quWKCFf2/iDeDx5k5oRLMQk1IFd8iA38z+BVZILrhI+p4UGQKJe2tDcFfX5tEy4nRZBs10dDs6gc0lq7E1PoNa7ZHuzwYTfFSDLgzOHvD7B0DdR4BgWjTeYxEiPeb9cIhdI75rXWMtoW2uMWedFKbG1N3kHfw5Wovmk77WxUrKE1ExNdBwD2Ot57WGae3LrXQJm1hZ9ShPqpJ3VUAcK3qFw5myE8ddt9ftUJoDNYxHHHT+RWpWHVq/WLebg7f8zURGKqPSMdyoKymOuXttuy3EdQ2+kpabnJZFtvohV89XuybM9L4XSmRY4xEWNRWSAZnS2ATQ9SlLbJrhKCxskuIvPO9nHKGIOf+zp7+vSkKAUXqkAkAWaCAaXo6aQQZSAL+gkTjjFyaUzdydjiTButmJ2evG0NlYHhm/S0wTmPZAynbz+ysA6SA8Q8VnGbDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(6486002)(5660300002)(478600001)(2616005)(4326008)(38100700002)(16526019)(38350700002)(83380400001)(86362001)(31696002)(52116002)(66556008)(53546011)(66476007)(956004)(36756003)(316002)(8676002)(44832011)(31686004)(2906002)(186003)(16576012)(8936002)(66946007)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K3NVaU9zcHhEVWxyYkdwOG1zcnJiV1N2K25ncXhBdG9tOUJncTJJTGtoMFBx?=
 =?utf-8?B?M2kraUZpQisxMmRZSHNPU3RzUzA3QXMydnZMQndvUmZ3cFY5dUttRDJqNzJu?=
 =?utf-8?B?OXF3SjV0N096T1NzamkyK2JKUnlnQXMrd2w4aGNrblZmaGpUdFVNbGwwc3cz?=
 =?utf-8?B?T0o5Y0VVemhJdkpJcmcrdWRKUFNsWFVGVU9JeUQzUlpOYzhkaStwV3dwZGw0?=
 =?utf-8?B?cWtUU0xRSTkrcWR4U0o5OXB3K05QeXBuSlR1Y2FZaHBXaE0wR29DWG51c1li?=
 =?utf-8?B?WFgrWDNOQzcxQ05ZYUt3eUlXYjgwRnBVSG0waWhRTjdMUzJHSnZ2Rmwrd2RO?=
 =?utf-8?B?cjhpVjZ6dVR1YXJYd1hueTgrYmJrakJiOW9NWTRqL29lS2RKOElLTFU5enRF?=
 =?utf-8?B?QXMramJDVHh4RlhKYzJOM3ljUUlmSzdDY0Z6aHp5ajFaSksvcmpkMjd1bHda?=
 =?utf-8?B?RlZVaEdhWEpTdDYzdEgvbE95Q2tSRjhBcnFiVC96RFNReGxINXREc1AzN2s5?=
 =?utf-8?B?TGYxRTFNUTcvVmpNNWw0U1hETTZrTFNzTUROTDU0S0VzWmRvTkFxd2NJWklP?=
 =?utf-8?B?a0lya09KbWV5R0ZrYXJLWGVQWmFwcmkyU0xSUTlzSVhVWEpERGVERHBQVEd5?=
 =?utf-8?B?VUwrRmNKQTdIcm0ycVVadXlYTXZGdXI3aWxHRWZHUmJSNjRHYlQ1SHBKVmhX?=
 =?utf-8?B?aDdUNU4wcEdQMVJWYm1IWHZuMHg2bTQ0eXdEWnNqNC9VLy9uaUZiVlJITTl0?=
 =?utf-8?B?ZTVGaWI4Y2U5TEVHa29XdjhFU0hicFlOdy9WVHhZSDExZy9kbUluTC9VRWdR?=
 =?utf-8?B?ZFBaKzRTT0tJMjJKZmJsaERKSUU3SVpKUXN2ZlJpamNsNUZublZXVDZheVdL?=
 =?utf-8?B?WUFaTEc1RTZDVjEwRmp6OStnemtUdEE2aW5ncmpGNVNuWlNkWjhDVnRSclpQ?=
 =?utf-8?B?TnpOQlZITGJ5MzNnRnpNdzJ3NWJ0MXdBay9hZnJVRFByRkpveWxIQW5LaHdh?=
 =?utf-8?B?a21kKzExWXlsVTdSNlB5aGNHRnY5dHJCOEJsb1ZMVkw0YTRvRlBBN1cxYjR4?=
 =?utf-8?B?aExHdTZwZDZmTTAzVFJkMGlsSHdGcXE5WEJtY0dWaXVzZVBDbmpuNTVQeTFX?=
 =?utf-8?B?K1RrbCtFcjBNaTdZbENOVVJBRGpHTEU1YUpLS2UyZ2JwZ3p4OUE1aGJQZHpZ?=
 =?utf-8?B?eVNwZUdkSUNSbVpvbGRqdjllZUJNNmF0cjdEOC9yT0NZZ2N4eWxCWk1MMTFk?=
 =?utf-8?B?MDRPa1FoNy9tTXljcEZnWXVpMHg3Vkoza1lUemp4K3I1Mlc3K21RZTBYS3pS?=
 =?utf-8?B?aFZtNnhTNmVzUmR1ZmszeHFUUGV2c08zRWJBcUo2VWI2clVubVhRTWFFbC9u?=
 =?utf-8?B?NytSTzhtRmt0M3lia3JzOVRpTEk0RE92Z3V2RnJTazI3YnVDeHlqbU83Mm1Y?=
 =?utf-8?B?c0hpWnM4dW5vd0tJR1lXZmt6M2FXbmdBVTh4VjZPWW82QnpXbnZrQkE5YWd1?=
 =?utf-8?B?d3ViVGpBM0dhanVPdjRWOVBNZnZtNk8yemtZTFU2THVSd0R5VXZMVXNWQjF1?=
 =?utf-8?B?V3pkay9JckdnZGJ5V0VONnpCQkh1RGdSV0x1OVlqc05tWjhNUVkrb256TXFp?=
 =?utf-8?B?U1kyeTA1cWh6bWl5d3VqYXRKd0NVcHZIQ3BqajN4TEdFTER6Qy9zOUFPTjQv?=
 =?utf-8?B?MHdhOWV5WWVpa014QW1JWFEvZE14Y3BqVTArMkIvSmRYcVAyUTVGYnM2MTNI?=
 =?utf-8?Q?ZyeQEZPY98EMsuKSlDXxQmRP6jEGyWeMZ7izBPF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbc425fa-b51e-432d-bc42-08d90525a56e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 00:29:09.8725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RaQkb4XwK0wpi9NzAj5azdeIGKMVR8twJ/cSntiqUZ2Et5Uk0lWIU7i72o9oODRGd/tDl+LZ8aqLlSoOcYHrXRE+F4J4SSrFc2EAedlkn74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2517
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220002
X-Proofpoint-ORIG-GUID: 92PU4Q7ES1C5AfpyoURJtZ7aAS4l-EbO
X-Proofpoint-GUID: 92PU4Q7ES1C5AfpyoURJtZ7aAS4l-EbO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/20/21 5:22 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Provide a mkfs helper to format the dm thin device when external devices
> are in use, and fix the dmthin mount helper to support them.  This fixes
> regressions in generic/347 and generic/500 when external logs are in
> use.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
ok, looks good
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   common/dmthin     |    9 ++++++++-
>   tests/generic/347 |    2 +-
>   tests/generic/500 |    2 +-
>   3 files changed, 10 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/common/dmthin b/common/dmthin
> index c58c3948..3b1c7d45 100644
> --- a/common/dmthin
> +++ b/common/dmthin
> @@ -218,10 +218,17 @@ _dmthin_set_fail()
>   
>   _dmthin_mount_options()
>   {
> -	echo `_common_dev_mount_options $*` $DMTHIN_VOL_DEV $SCRATCH_MNT
> +	_scratch_options mount
> +	echo `_common_dev_mount_options $*` $SCRATCH_OPTIONS $DMTHIN_VOL_DEV $SCRATCH_MNT
>   }
>   
>   _dmthin_mount()
>   {
>   	_mount -t $FSTYP `_dmthin_mount_options $*`
>   }
> +
> +_dmthin_mkfs()
> +{
> +	_scratch_options mkfs
> +	_mkfs_dev $SCRATCH_OPTIONS $@ $DMTHIN_VOL_DEV
> +}
> diff --git a/tests/generic/347 b/tests/generic/347
> index cbc5150a..e970ac10 100755
> --- a/tests/generic/347
> +++ b/tests/generic/347
> @@ -31,7 +31,7 @@ _setup_thin()
>   {
>   	_dmthin_init $BACKING_SIZE $VIRTUAL_SIZE
>   	_dmthin_set_queue
> -	_mkfs_dev $DMTHIN_VOL_DEV
> +	_dmthin_mkfs
>   	_dmthin_mount
>   }
>   
> diff --git a/tests/generic/500 b/tests/generic/500
> index 085ddbf3..5ab2f78c 100755
> --- a/tests/generic/500
> +++ b/tests/generic/500
> @@ -68,7 +68,7 @@ CLUSTER_SIZE=$((64 * 1024 / 512))		# 64K
>   
>   _dmthin_init $BACKING_SIZE $VIRTUAL_SIZE $CLUSTER_SIZE 0
>   _dmthin_set_fail
> -_mkfs_dev $DMTHIN_VOL_DEV
> +_dmthin_mkfs
>   _dmthin_mount
>   
>   # There're two bugs at here, one is dm-thin bug, the other is filesystem
> 
