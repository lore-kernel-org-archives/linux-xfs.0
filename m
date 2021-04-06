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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC493C433ED
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 20:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9531F613C4
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 20:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347152AbhDFUHw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 16:07:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55546 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237478AbhDFUHw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Apr 2021 16:07:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 136K46x6112207;
        Tue, 6 Apr 2021 20:07:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=WY/aEBVBSUEDuoTZqTeWDz+bnYrknGCPk0ZNLeC9vow=;
 b=cMNq3M8ewtn+Zujpnv5Us7ApQav67ObzUOFh21fNbUMwkeajmDgDNDUV3kOw+iD2qfC9
 ampT204hPV7Ac2v/0jBVqLGry9kaKdvRgtZW5q2tHsqOE8MhQ37sijtzKXD/tjUiT9RY
 i7+Kz+rQ+1ZJ0CHS7bhB70LAsu8aer1NjgQBlv3EbCGLblvHgA62hMTN7Jt7CN2ORgd4
 8L9n0cP3AceDhmHPY0VTWno0j56xjBd13ZoXk10R+0lQbpt4srfvD0pNlHRYXD2RtZTq
 adFYNJwm6IuTWhAHfkp76jCA3MnUlLK2D1xGLaLumSZSYEIdeYNHKi2xjgBokAfWHsdz OQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37rvag8d0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 20:07:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 136K13WP149341;
        Tue, 6 Apr 2021 20:07:42 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3020.oracle.com with ESMTP id 37rvaxn7eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 20:07:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3SShvUA5DclNGFIH2Y6HOerLqbs1cnmdNqM7SBu+AWj5fnDcTLccxqpNZeELlU97LgJIslqDly4OX7cbAd/v9mVPRy7JxfPBJs3jpFXb2AvEvY0B3uux+RgQzI8/rd3KQlz4il+HzetZH7aag1KBDjV/0YTEpoJeLF0Akcx78/VE2RIMgG3hvdQDTq1NIgoMbXs7CRjZFh1hA2ynEMjHSJc0c+CHHyvmBoPUijBWkGpRqm4tdNPwrYRmyBexc+7rFtSj/ZEvGyGHW4UsupJEup3aZxtA7B94arFZj9WsoJgYCe/sep5Pmnh+boUXW7QPHIeOZQfO7b06Y7lT6VK5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WY/aEBVBSUEDuoTZqTeWDz+bnYrknGCPk0ZNLeC9vow=;
 b=nXk8WXzqPz//9QABM9+ON+GTS4Ts2SUtQd/ZzvYa0rMu5hWXB1/tH5SM5gtmSV74xgrWSxxKVEYpod4Zp/izAiYb2Z67J+7X6TqJ9c4PEsnVg3+DdPD/9HY3NNHqN4FVAyNoVMLlk69YYTMQE911FasMRpkpgCrmTyT5Oe3VWKsdaNGIYM76r1kTU5OPkmVSQDhejUZwolOI6mYEb4FrNVFgMRR6s3rzEwk+am3YtaAQQNMoRCcOe6RyObHMPlxAIBnTMi7XTVm46uFt+2wc27S4f+yg99t55t9D4ORL9ld7Vf05rUTFxwCfFjQTqRV4tDBTuPcuzb+7yOLfCiuoXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WY/aEBVBSUEDuoTZqTeWDz+bnYrknGCPk0ZNLeC9vow=;
 b=kbhs/N66UvqMwMtyGWE8IqDIyMGUTZRLNbIyDtULePGAyJgQEMIRgOtEqEpf86FAEGZtFLgsSkwtoJSPs6nnfDm7SRjaVdbPho9AhmTuThIcIs58DqplOhS2GuXPwMjNU9BJomxoqJ7ZNJ/rs64mfYNHiSU1AXHz+9KEQoR+7y4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4051.namprd10.prod.outlook.com (2603:10b6:a03:1b1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Tue, 6 Apr
 2021 20:07:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4020.016; Tue, 6 Apr 2021
 20:07:40 +0000
Subject: Re: [PATCH 2/4] xfs: inode fork allocation depends on XFS_IFEXTENT
 flag
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210406115923.1738753-1-david@fromorbit.com>
 <20210406115923.1738753-3-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <5764c126-3cb2-2aab-9acc-f91298faa24f@oracle.com>
Date:   Tue, 6 Apr 2021 13:07:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210406115923.1738753-3-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0153.namprd05.prod.outlook.com
 (2603:10b6:a03:339::8) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0153.namprd05.prod.outlook.com (2603:10b6:a03:339::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Tue, 6 Apr 2021 20:07:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a08977b1-3e26-45a5-9675-08d8f937a192
X-MS-TrafficTypeDiagnostic: BY5PR10MB4051:
X-Microsoft-Antispam-PRVS: <BY5PR10MB40512962A0C1F4FF523F0D5595769@BY5PR10MB4051.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XtoHK5vpLfuqiI8V+OR/jLQ9bCCDSH/Mgj/4SxVK3UwH+BhI/yV1vDJi+UFWgwczI0BFBNS0nSMYBEPGAvP2MmCp93zEOCGX9QIyACQ80Tb6w10hvg/WR4VkY4RM3RTOWhKbp2A/pVxLySgxp2DT4xX4clWPu9GhMjWnj/l+vl3FK3pWv1uxyJXQ1sxkn2KHi4R2pUuYjDvInFb/wgX72BUGq0eQ0Ycj47u+JKavSUOlBPsF5gF9JAoNNOxs+GSNzFqi56Ebex+VoRQqx4To0Em5ryptwPudEkcIP6CQpu1g3K+TFJBT6JDRGjOKa9qFbSkquSVbXUuTjsgTFPfhi/XtjMFr2bp0AHjQeVhJJQzocW6+hPU/ueSR903kmFpEa6Tw/nUZW8wz36vtuSnH5ckPnQ2AD1z1scWQND8leg8UCj1DkCAeLZn+6n3/q1yhw90+XIIbxV7yjjOHkBxYSVqnmcNDJC2/o3DwynxshQv+4r37fRxxfmXmUffM5T/RgjH1r/teg3tZWKECpEBAsL9+vSXUkhoDjpfJXvM+Rfcbo1WNUpSsmT/skS9WncXL/5RK+vZB0My6zJavCi6rcSb6lrfVRWA3gbvHvxSXBjQ5PRreUx30ADQXoLAhoSo1+lNHFX5isdwLwJVr/D82pFaSLbkVRbZLK4OE4Y2i9w8eCSM4V8h4dVOEqBjn/TM0xLpZxv3DqYcvi6TjHXP/+pcS3+xQsc68NtUIlOCCOHQl9v1ds1pcBPnHk4wDaDN4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(136003)(396003)(376002)(53546011)(6486002)(31696002)(66476007)(66946007)(66556008)(5660300002)(31686004)(38350700001)(8936002)(478600001)(52116002)(36756003)(8676002)(38100700001)(16576012)(316002)(2616005)(2906002)(956004)(86362001)(16526019)(186003)(26005)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eGxsTWdzM0wzTDlQZElhNVA3T0pkV0hENFVyczR1ZnNJSGpOa0p0a1VFVmt6?=
 =?utf-8?B?M09jQnRiUzVCOExjVVBLZjFuNy9oenlMMkQzbzltMXZaNVZlWk1wUm9nSmhq?=
 =?utf-8?B?dHQrVm8wWVp1dkZVcDRnYlpRc1dEczdYeW5OQitpRHpXeU84d2FMeXpMZUlH?=
 =?utf-8?B?MW9PbjVQbzZZNHJrWXc1c0k4SnJDT2s4UU5aWGhYSEZ0QXpyWUIxSThtcWdv?=
 =?utf-8?B?S0V3VHlrbnVPcnZoVi9VRkE1Y1kxTXZpaTB3M0N1eVhtSmU4eGNVeDNKUEdy?=
 =?utf-8?B?NDZNalEraG9xN0E3RGs5d0pBQWI3enhVSWFKUUdzY3FudHBldGxqalVsRzRM?=
 =?utf-8?B?T3A1b2NESEpLcjdGTnBRbDhvcDFFWDNJTFZ4WDFWeEJHQU5YNWFpSGJhSFp6?=
 =?utf-8?B?SDdjcGgxM2Ewc2V2UXFPRFZ5c0kvYVBUVWdqR2QyaHpUTVFoVUlScXQ2SlRt?=
 =?utf-8?B?Sk1RRnM3VEpmVG9Yd0hBTmdBbWJqYmpLWGljS3N4TVRFVkduS3cxelN0dHF2?=
 =?utf-8?B?Sk5JT0N0Ni8wNUx1OVlHcVEyRElLTTI1V1JuaWZKU2ZlRWlYNVZCd1YxR3NB?=
 =?utf-8?B?TWJrcVdweHpwUzdML1dkQ0svT0NhY3FGMkluYlY2ZFNRd2tqR3JHTWhuTnN6?=
 =?utf-8?B?N2YxMUNMSnQ0dEJCbTBYNzVnSm90YkV0M2JsR004cFA4Qm9yT2ZudHp0STBH?=
 =?utf-8?B?elkvUEN6REdvZ3lDT0hLNW5PMUNIWGx6U3NjbzNFQndzcUpRbGs0SUdram4x?=
 =?utf-8?B?ZnJzVXVZVFVLNkRNdTl1SXFzdGVSNkM4WVpjQm5SWmZkWFU0aVdhR3dCUUlN?=
 =?utf-8?B?REVUTGEwbm4vWHU5L1FLN1BJR1FGWFRmZVJNTDRFSEZUVWc0V2t0L2UwVjVO?=
 =?utf-8?B?NUlnaDc4Nkt3YTNsYW5aTWl3YlczQXdIU1pVM0wrVkk2ekR0SlZtK05rQllY?=
 =?utf-8?B?cTFyaUtEVi9QMGx6UjF2YzZMWVdLUXZNT3BVcWluVHhQc1paTklqWlVDMU9w?=
 =?utf-8?B?bkV0SS9RYVFKVzBGUnM1N1M0c0dGenE1RWFNTTA3V25ycFFvVmlLYURVNlZ4?=
 =?utf-8?B?YVF3T1V5b2RwQ0Q5V1lFNUxNUmRqdVhldUZhSWxISks3NWZaclY4aXNZallE?=
 =?utf-8?B?bXA1Y3p1dVF4OXhKWE5BZUZybUs1UHNIaDRlZ1lVNFp0TlpyZzRvbDdoZTlH?=
 =?utf-8?B?VzBxRGVTRGZ0NEFWc3NsS0ZtdTJSM2V2SGZMUzdwR1RTaXdJWVQzYkw4Z25i?=
 =?utf-8?B?Tkp4TDBheHFwbXluNFVXYnFieFFvRE0zQlM2Yk1NNHpIclFBN2VZSlg3U3Z3?=
 =?utf-8?B?YVpCK0RhWnZyWmNVc0gyK09pdDhwVGdtWU9meDJVOGREVVdMRkpZWmgrcC9t?=
 =?utf-8?B?Nzk5VnZqVGV5WFB2enhZSjBFMmkyekRES0dyei9DbDRWR0VBZHA4U0xGNFZI?=
 =?utf-8?B?UGwreHo0YkZpYVZDcHJhYmMycFd3Z0pXOTdnV2d5U0tRV0NDcXcxT2lLQlU2?=
 =?utf-8?B?Tksxd1RUajJrZVF2MzQ3cmRxblh2VDdsMXVxVmlQdXBMVk1tZ1FvdXY4LzJm?=
 =?utf-8?B?YVlEZWdUT2dySUcra0p0Wm40b0Uwb0xoY1kyMURjY0d0VzlFc1Y5akdzem9j?=
 =?utf-8?B?TGlLSWRrMnpUeEpWeUZOZzMvY0pkYmxOcGpjbkM5V2lSaGhnN0JTVTBGKzNO?=
 =?utf-8?B?ZFY3K3gyeTlOUDZRQ28vaVpKYmdvUUE3cHMwQWp1djN0VEdrY0dYaFJwQ3JL?=
 =?utf-8?Q?xkuWwVeFFVmG/pOUe1OQLXD4TAjY07jAdh+fS/i?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a08977b1-3e26-45a5-9675-08d8f937a192
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 20:07:40.4212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k8zk/N2/WFsOYQDOZf7TbEy9FE8mt9DXbrT6pIA0IL/upjhuwqIJpCy3hNOC7U+6UrMdg31nmdNMSwldsn7WQDLIyzhcvdJUiuIO1pqRsio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4051
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9946 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104060136
X-Proofpoint-GUID: GdSsG0mrGAsgPsfo7h3Lkw-knOTRHGjc
X-Proofpoint-ORIG-GUID: GdSsG0mrGAsgPsfo7h3Lkw-knOTRHGjc
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9946 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 spamscore=0 phishscore=0 clxscore=1015 bulkscore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104060136
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/6/21 4:59 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Due to confusion on when the XFS_IFEXTENT needs to be set, the
> changes in e6a688c33238 ("xfs: initialise attr fork on inode
> create") failed to set the flag when initialising the empty
> attribute fork at inode creation. Set this flag the same way
> xfs_bmap_add_attrfork() does after attry fork allocation.
> 
> Fixes: e6a688c33238 ("xfs: initialise attr fork on inode create")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, looks good
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_inode.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 3b516ab7f22b..6e3fbe25ef57 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -890,6 +890,7 @@ xfs_init_new_inode(
>   	if (init_xattrs && xfs_sb_version_hasattr(&mp->m_sb)) {
>   		ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
>   		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
> +		ip->i_afp->if_flags = XFS_IFEXTENTS;
>   	}
>   
>   	/*
> 
