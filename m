Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A725C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 20:20:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F388664E89
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 20:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbhBWUUF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 15:20:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46852 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234217AbhBWUTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 15:19:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKE0c1111184;
        Tue, 23 Feb 2021 20:18:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=sbRkUMXqGlWFLcfssY+M5SPnTOQmwagDgxleLTipxlw=;
 b=OZNZMoylKRjhS8fC12rLGxzOodUWKDrt/IGFQsRXJqxku0511T6JF9UlZiIK5D/kBL9I
 wjM3Eok0VJhcUKkPCG+/WtMfKYmT/aELBdfWRe8pILFCKYmPezNXzFZkzIZu+pCSlCmU
 2sSLrXHbfm8uHY3eMVFfgyMmneFxjvBK/dQ11xrZfaEZQ9lTvYAmv11Zs7b5I0w3faTf
 ZYJYmep4J4uO69jPu3PTnKFEP0CGkOzS0XgW89ynLNBOeegzKZEtXJoqvbU3O4WN6edN
 FSArak9PfVnVM+K2e5ix4+PJs7uD6Tz9YhfEIDsOUMiGLHTAgKBWfUXovSLFEmky9JYS 9w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36ttcm8qew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:18:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKAbi4092540;
        Tue, 23 Feb 2021 20:18:59 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2054.outbound.protection.outlook.com [104.47.37.54])
        by aserp3020.oracle.com with ESMTP id 36ucayv8bc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:18:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HM4yv8sAJFwcQpAotuRqjfRwzjQk2MccPQ2CruCc6YoPsTiA0Pz0jMG4OrQnYwUrbSLt7wv+pIL9g+LjBBgXh/qGsPnbNFtMeUybxrlh79DyFD0roctl7B20keu3Zp/nuiNRHa1QN0fS9UvheYDuamWQcvegc7jF32xCkIz5Aph8YD1HXVzmTt+FdKgvzb6Zs3AxHli0Qliik+z1FfpqkYEGmsZqbDGF7vXzM1vX+Qzh7Ce2DilmefsAI4yjCyn7O/cv0o0KKUleJfZ3tvKFqrBEXwTwQ+CQZIsia/MaZIxsbrmQSbJR+YMFOnHroo5HbXnNKFfgU4M9NR9EnnpnFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sbRkUMXqGlWFLcfssY+M5SPnTOQmwagDgxleLTipxlw=;
 b=ZOFrr3foyXO8Fh2Hl0fjRsaXaKtk1JVA1FDjg9J2bix05uebGBLzbTEodAFsXfiZ6OZzitCMVUGhO1z4yq/cOFW/r9vRPzCVYsT2TssFo5DAFJjVGRLYVXQrfgzPytyR3TnVchtl4JYNlfok/BmoJ35C6lh/OAM2PAEbCkP+ieJ1eONaT2bnx0rbIZtOmLWtEQmdjKYHwTXhdSzmHDe0ndWeEyFYIpzY4yD0Fi8i25t6u44+aRs8BgbzL9lVnZiS004kZOFEp6o1AUbB2qIQvhPje2qTKQZ7OcfWFwxAU6OMmFq/5/qgkd8F5hGlm+CdZ67aJ3bgzsci2Tv35EL60Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sbRkUMXqGlWFLcfssY+M5SPnTOQmwagDgxleLTipxlw=;
 b=oBS5HncevKYqmhwNp6dXyX5SeaMT9jZxrzImO9TSIAf7+TFxiU79j/Q7KoCJa8jZF2VHGC0Q81RrVYhCNIOgtmNTd7eSMq4ZQtsbO+KlgAA/ZIs39dfjmzYG12E5NJCTK4c1t+CzZVDqk2qnP6m7Qx60OQKq1Fwrl0wFXaL3Me4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH0PR10MB4876.namprd10.prod.outlook.com (2603:10b6:610:c9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31; Tue, 23 Feb
 2021 20:18:57 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::ac22:3fb8:8492:3aa6]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::ac22:3fb8:8492:3aa6%8]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 20:18:57 +0000
Subject: Re: [PATCH 7/7] xfs_repair: clear the needsrepair flag
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
References: <161404921827.425352.18151735716678009691.stgit@magnolia>
 <161404925861.425352.15560707043185552680.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <856b5717-6451-4f66-7dd1-0854f810f828@oracle.com>
Date:   Tue, 23 Feb 2021 13:18:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <161404925861.425352.15560707043185552680.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BY5PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::35) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BY5PR03CA0025.namprd03.prod.outlook.com (2603:10b6:a03:1e0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend Transport; Tue, 23 Feb 2021 20:18:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b47a4403-7c63-4326-5a85-08d8d8383fcc
X-MS-TrafficTypeDiagnostic: CH0PR10MB4876:
X-Microsoft-Antispam-PRVS: <CH0PR10MB487612AC1C2F884609D39A6D95809@CH0PR10MB4876.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:91;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: byc2YojmplAjOsGABfn8oe1VL/BIeaHZHPY/ixW48mU3a64ay8NyAoA1J4AxO8+/QcWXqLdBboxPmkjiJBp11dauoSZML1Zv47q/BTu8i0c+TZISJ0WlaDPCAF4NNPm/qc+sKdForop/DkjCCBuLAPa4dbEqqE4j4YrZllZ+6oRjd7uZah/ORewcQ0+4GMZXIe3HBYBtwFE2Hq0V3Y5UPJDV++I5hjX1Z1q9pSmfpf01VVx/ItSt84LdcbLMkHSMwl46+Re/dkWCwpl9l1RtC/z7/QsJipl6qQXGFt3sejpOXIH04Cr5kbdorab2919H5pDrsWHNVumnpfzLKb6VF+c/QpcKo48q70ujI5b4efl6dildvfHlsdi0GJeOz00LUbvveImyUkmdnLizNn7t3F+t5P9rxGEKDem/Pd/6GgNyxzBDGFt1pgoIlqLWh8OtXe7NaU4kvzmWq3EAd1ACBapuoPUwOcKHVjz9A53wvCSVVoVQRgnh+QPGSh/IjecPRyWjMfrtxVA6/vSWJTFkFU25xB6UAUcFM8vj4LTKDc8Cs8f0WKDCObUj4ZnOmtVwe4tIQvN1GspWpm0hG4xSQ8ISi33c0XmsUysXHeRv/uw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(396003)(39860400002)(86362001)(4326008)(6486002)(83380400001)(2906002)(478600001)(31696002)(31686004)(44832011)(66556008)(5660300002)(16576012)(316002)(66476007)(66946007)(36756003)(54906003)(8676002)(53546011)(16526019)(8936002)(186003)(26005)(956004)(52116002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OVp2dlpnaSt1b3RJT2RYK29KSlVyWnJxNjFldU5mbTd2bmJPRDB5Ykw0MFB0?=
 =?utf-8?B?aUZvNEQrSnFuM3BGaU5ac1RieU9EOHQ1OEpDR2hVZElUK3EwcmJBRWtZNXh5?=
 =?utf-8?B?aGxZd3BtSVdoczRNeDNHMHJ5L1pKVkdqemNNVHErbTJlcmdQYmN5VnFPYmt2?=
 =?utf-8?B?eXIrZGRrYVQyTElyN0lzUis4ODBpeWJiUUN6akhNY0NzNUhFWlBHL1gzSlJR?=
 =?utf-8?B?QzJaenJUcGFWV1pYN0RwWUxpSFMzaWxPZjl6TUZtTmhrSzdIcnFEbVJ3K0Zz?=
 =?utf-8?B?TkFQWXJJU09CZEI1czEzeXoxcE01Y01DVG9EeW1rWkFnVVQ3NWR6YmV5eUl4?=
 =?utf-8?B?eEJzK3FpRmlTdWNDUHRiSnNrNnM4UUJZS1hlVEVlNUVnV1JFZU9WWnFoRHBR?=
 =?utf-8?B?OUltU3lqRzZwWU5jdWwzRkJmaEVuOVZYSjRVUGNsM21ZVXI5TUlSSllHcEtN?=
 =?utf-8?B?L1FiUHN1eGI3a0VUOWFWd1IvaW5WeGd4WGZOZ1VxMkVhZmJaY1BkVmpjMGZh?=
 =?utf-8?B?MnpwclgvemoyVzZVQVQyRXZydXRKTTVrRkZOWkJGMEh5SEZESnlKdEVoWmsx?=
 =?utf-8?B?cmc1T1UreDBaaVJQQlVTQk90QnZRdkJyOG8zY1MySjY0NVNCOHY1cUFVSEhU?=
 =?utf-8?B?Y2hkakdZaElhcVVRWUo3V3UrT0ZEby9nci9yVjkwQmJYNGdpZmhBZENnUGxq?=
 =?utf-8?B?cDB0WVppU3QwSk1lQU5lNHRjVHVHV0lRVGN5bkZIRzVIYUdNaW9IVUdsR0p6?=
 =?utf-8?B?ekk5UW8zMWVZVjlJNkRpZ3Nvb3F1KzFZeCtsM20xTWUwMW9XdEM4bWlvSWJ4?=
 =?utf-8?B?c0NnMFhOSEEvM1hwU25TS1RlR0NVcmVKYjgxSDdiVkdMRVZMaXUxZHlQWCt4?=
 =?utf-8?B?aEoyY203elJMbmRQaTNvM0thVHFEbGRiVXdCQlJ3QVhyZ0grSmIxOHBHa2VR?=
 =?utf-8?B?SXFwRE1rUEJJU2hrTDVqSEtpNkZ4OEN1a0duaXRSM29PK3JyeGwvOU1xdENH?=
 =?utf-8?B?ckgzMXJpNDBXT1Z5SitGTmVqcUVFcS84TEhsVFdIMVh1eS9MK1JNZTRCdFFa?=
 =?utf-8?B?QjhYQ1VrZHJBUitxODlIa00za1BwdGpheTdYTUVQZEU0S2c5U2dWcUo4VExL?=
 =?utf-8?B?d1pIN3l6SS9IQSthL3lLaHo4S2FIQXlML21FMHRIaDdvU1JudmpiWUFuWk9C?=
 =?utf-8?B?UDhCT21POXFSanROQjRpbzdGcUdHbmJHcmdNRnZBc1JwVG1KYUpucnl4ZzZo?=
 =?utf-8?B?SjI1bk9YeWdPUXFmWWhIMWhBeXYzKzIxOTUwUmNXM1dlNktGWWNNU0R3T2kv?=
 =?utf-8?B?VDBtVVczRzQ0c3pIbW14Z0t2dEZRZTAvQmd5ZWc1L0xVVVVQKzdyL1V1NC9a?=
 =?utf-8?B?akFaTnVKakVoMmZZQWNQbWpNQkxONjRtVHJZMTVoRkJVcGQ4QXhoMEVFYUxs?=
 =?utf-8?B?cXNUelBTOExmNmMxeGdhb2o4dlVuOHh0b2VFakRiMWt4MG8yeFlxbjFXNmgw?=
 =?utf-8?B?b1NWMUdvZk1EdGRYSjlocFU2UFBMRWNlajd0TEs3ais2eGdBWUJ5RWM0VDMz?=
 =?utf-8?B?VEVrQ1RzVS9aS0Y3WEtuNldLeTNLY1pDYkE3cTVGdThkQ2dSaDZ2c0xEWnho?=
 =?utf-8?B?SGVRQ1RHblJyVzVna0NwVi93NVNkdC96V2ZXNDBoOElSeHlMcExHUFI0U0tF?=
 =?utf-8?B?N1RxTGI4TmZkb0dTeVZSdjI4bi9oR2FvWFdRNUtOUlE2UEpvTnpnTDJpdVh3?=
 =?utf-8?Q?dfa0cURkNNlXqpRDMfcNyXI9zUgH2TcRduNMzMP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b47a4403-7c63-4326-5a85-08d8d8383fcc
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 20:18:57.4304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: swxthF/CbnRWDfblO64t9efcCDZU4LkfYoIcg++bf3MNjeiibOTL3SVv1z5zGJguilAei0vvnBIJ+/W1FKZdG7N3qS4vFigXxa8DAQdJh8c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4876
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230170
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230170
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/22/21 8:00 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Clear the needsrepair flag, since it's used to prevent mounting of an
> inconsistent filesystem.  We only do this if we make it to the end of
> repair with a non-zero error code, and all the rebuilt indices and
> corrected metadata are persisted correctly.
> 
> Note that we cannot combine clearing needsrepair with clearing the quota
> checked flags because we need to clear the quota flags even if
> reformatting the log fails, whereas we can't clear needsrepair if the
> log reformat fails.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   include/xfs_mount.h |    1 +
>   libxfs/init.c       |   20 +++++++++++++-------
>   repair/agheader.c   |   21 +++++++++++++++++++++
>   repair/xfs_repair.c |   42 ++++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 77 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index 36594643..75230ca5 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -181,6 +181,7 @@ xfs_perag_resv(
>   
>   extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
>   				dev_t, dev_t, dev_t, int);
> +int libxfs_flush_mount(struct xfs_mount *mp);
>   int		libxfs_umount(struct xfs_mount *mp);
>   extern void	libxfs_rtmount_destroy (xfs_mount_t *);
>   
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 9fe13b8d..8a8ce3c4 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -870,7 +870,7 @@ _("%s: Flushing the %s failed, err=%d!\n"),
>    * Flush all dirty buffers to stable storage and report on writes that didn't
>    * make it to stable storage.
>    */
> -static int
> +int
>   libxfs_flush_mount(
>   	struct xfs_mount	*mp)
>   {
> @@ -878,13 +878,13 @@ libxfs_flush_mount(
>   	int			err2;
>   
>   	/*
> -	 * Purge the buffer cache to write all dirty buffers to disk and free
> -	 * all incore buffers.  Buffers that fail write verification will cause
> -	 * the CORRUPT_WRITE flag to be set in the buftarg.  Buffers that
> -	 * cannot be written will cause the LOST_WRITE flag to be set in the
> -	 * buftarg.
> +	 * Flush the buffer cache to write all dirty buffers to disk.  Buffers
> +	 * that fail write verification will cause the CORRUPT_WRITE flag to be
> +	 * set in the buftarg.  Buffers that cannot be written will cause the
> +	 * LOST_WRITE flag to be set in the buftarg.  Once that's done,
> +	 * instruct the disks to persist their write caches.
>   	 */
> -	libxfs_bcache_purge();
> +	libxfs_bcache_flush();
>   
>   	/* Flush all kernel and disk write caches, and report failures. */
>   	if (mp->m_ddev_targp) {
> @@ -923,6 +923,12 @@ libxfs_umount(
>   
>   	libxfs_rtmount_destroy(mp);
>   
> +	/*
> +	 * Purge the buffer cache to write all dirty buffers to disk and free
> +	 * all incore buffers, then pick up the outcome when we tell the disks
> +	 * to persist their write caches.
> +	 */
> +	libxfs_bcache_purge();
>   	error = libxfs_flush_mount(mp);
>   
>   	for (agno = 0; agno < mp->m_maxagi; agno++) {
> diff --git a/repair/agheader.c b/repair/agheader.c
> index 8bb99489..2af24106 100644
> --- a/repair/agheader.c
> +++ b/repair/agheader.c
> @@ -452,6 +452,27 @@ secondary_sb_whack(
>   			rval |= XR_AG_SB_SEC;
>   	}
>   
> +	if (xfs_sb_version_needsrepair(sb)) {
> +		if (i == 0) {
> +			if (!no_modify)
> +				do_warn(
> +	_("clearing needsrepair flag and regenerating metadata\n"));
> +			else
> +				do_warn(
> +	_("would clear needsrepair flag and regenerate metadata\n"));
> +		} else {
> +			/*
> +			 * Quietly clear needsrepair on the secondary supers as
> +			 * part of ensuring them.  If needsrepair is set on the
> +			 * primary, it will be cleared at the end of repair
> +			 * once we've flushed all other dirty blocks to disk.
> +			 */
> +			sb->sb_features_incompat &=
> +					~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> +			rval |= XR_AG_SB_SEC;
> +		}
> +	}
> +
>   	return(rval);
>   }
>   
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 40352458..e2e99b21 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -712,6 +712,45 @@ check_fs_vs_host_sectsize(
>   	}
>   }
>   
> +/* Clear needsrepair after a successful repair run. */
> +void
> +clear_needsrepair(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_buf		*bp;
> +	int			error;
> +
> +	/*
> +	 * If we're going to clear NEEDSREPAIR, we need to make absolutely sure
> +	 * that everything is ok with the ondisk filesystem.  Make sure any
> +	 * dirty buffers are sent to disk and that the disks have persisted
> +	 * writes to stable storage.  If that fails, leave NEEDSREPAIR in
> +	 * place.
> +	 */
> +	error = -libxfs_flush_mount(mp);
> +	if (error) {
> +		do_warn(
> +	_("Cannot clear needsrepair due to flush failure, err=%d.\n"),
> +			error);
> +		return;
> +	}
> +
> +	/* Clear needsrepair from the superblock. */
> +	bp = libxfs_getsb(mp);
> +	if (!bp || bp->b_error) {
> +		do_warn(
> +	_("Cannot clear needsrepair from primary super, err=%d.\n"),
> +			bp ? bp->b_error : ENOMEM);
> +	} else {
> +		mp->m_sb.sb_features_incompat &=
> +				~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> +		libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> +		libxfs_buf_mark_dirty(bp);
> +	}
> +	if (bp)
> +		libxfs_buf_relse(bp);
> +}
> +
>   int
>   main(int argc, char **argv)
>   {
> @@ -1128,6 +1167,9 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
>   	libxfs_bcache_flush();
>   	format_log_max_lsn(mp);
>   
> +	if (xfs_sb_version_needsrepair(&mp->m_sb))
> +		clear_needsrepair(mp);
> +
>   	/* Report failure if anything failed to get written to our fs. */
>   	error = -libxfs_umount(mp);
>   	if (error)
> 
