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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3361C433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 18:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9BAB64FF1
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 18:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhCKSgh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 13:36:37 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48198 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhCKSgP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 13:36:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12BITKLS102162;
        Thu, 11 Mar 2021 18:36:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=E07rapv+qp42WxcbXYa0GoqEQLZO/SgQxtGmCxcz6Yc=;
 b=kmY7yOjB5sNBzg8Svje/FRenw4+eb6UAxpC2ONPnQvZhbgWzbXLXbUlIWu3QA4Zs9S2H
 eAau/1VyG3xbxQcuLPPh6xNh1igaXe7d4mRdi3bmpBu3EyAzG5zsJG9B2R3UiX9UblY0
 UQVHRSmFwPlgTVbgFLPh1P33b5T7lA75kpY9ygDBzoLvs6xNHIKHufzsT7nn3IGFfu/v
 QEFOPMCQv0nM7sgnUjajaGmMsRfMHVoGwoTG+tELINvtg6IT+gY5HUACgxQ6fUERxKji
 +pQVsBThozR4W5wVhJMCpm36EyEYeNhCsG380do04cOJs5MzicMwJ+kOA43G4BUMib5N qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3742cnfjpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 18:36:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12BIVX13040452;
        Thu, 11 Mar 2021 18:36:12 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3030.oracle.com with ESMTP id 374kp1d0p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 18:36:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKv6w2qEtyH0nCJMOY89DAfozHRiIgRX3WtiSRdLgyXEvuq456IFqG0PcIacfvRmfrdyUQ/8L1STPyUBpTfDT2yWUVgi9+jUeXUnysY0FpCj5ToXTVPgwsxL7/0g4MJojz42iU8G9hp6nUZkjSRxFJaRp4Vl2exFsheZvqTmUwErgmJ2pJYMKVvpXOG/nYV043ehdtF9zQIMwjulzXKE1jy4NGFSj7rj9v1NQkqdoavCX1lVit8aTCAfWZ+rOiv073nqNZGqqkeut3iZgjDrA7lH6jcl3/2OKl13lWNC6P6eYuGoC1KGke8hRnbyape5MjKpb2WVMRdyeLxzeuPJlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E07rapv+qp42WxcbXYa0GoqEQLZO/SgQxtGmCxcz6Yc=;
 b=BmFoEc0xe2cQRHyHtlze1/L7Pxp2gcJqXhc/PCxd05I7KKbZpBrs2hH6pj5/k6Gj8BgDMU/kOssaXqFy40FBax+Cw3KrznclhXE8Ugbal5+/yXPtLrhPVan3QTOrLw9j8du2sqtaPblVBNws9EzWDnRpP7pp+iaa4t8Pbc8mq5iV7sFtbdoBSdLiEq4L4EK5HwhSoiw3kCMDp4CykH6zzkN7TieP45KEoShOT+zrKjPVZQS+dw2YNrUIC0X5FSlBswl+WIMVlW8FVNl29kWlU+eeUYVXW+Za93AXkzEqhUGdAAhgNEpQLf2A3iMBBOVUHx78W2mxIgbHcdNJqrYa1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E07rapv+qp42WxcbXYa0GoqEQLZO/SgQxtGmCxcz6Yc=;
 b=oUEbnCNi/mz1uPtnAwJS0iFyQCx3ERkvgpqQqFHTnxSZGqVWo1TU/YrTerluibd+PMvHhhUJV8Lg02Th0O/qfSnMsIt/PX999OY/gsSaaWmpCVR5foZYEZR2a+V4CT7HRvrVfixK1QT/nUxrIhoAy2Nk+nQNI5bL05smgJMA/Qw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH2PR10MB4167.namprd10.prod.outlook.com (2603:10b6:610:ac::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 18:36:10 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::ac22:3fb8:8492:3aa6]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::ac22:3fb8:8492:3aa6%6]) with mapi id 15.20.3933.031; Thu, 11 Mar 2021
 18:36:10 +0000
Subject: Re: [PATCH V6.1] common/xfs: Add helper to obtain fsxattr field value
To:     Chandan Babu R <chandanrlinux@gmail.com>, fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20210309050124.23797-4-chandanrlinux@gmail.com>
 <20210311085205.14881-1-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <60f53a40-4161-0387-67f9-845e9c8a3e62@oracle.com>
Date:   Thu, 11 Mar 2021 11:36:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210311085205.14881-1-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0104.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::45) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BYAPR11CA0104.namprd11.prod.outlook.com (2603:10b6:a03:f4::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 18:36:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87dcc1e1-386f-42de-2f16-08d8e4bc8a71
X-MS-TrafficTypeDiagnostic: CH2PR10MB4167:
X-Microsoft-Antispam-PRVS: <CH2PR10MB4167B80A4674FDD214DDEA8395909@CH2PR10MB4167.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:747;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oUcz+bNot31ruTomQgStvtQQ9jhUAH9jzSva8rvRLxPBwyUvhnvfBlpw72i2j1X6P7v3mLWXgg6NVy/+7KtPotRsI/BzicEmn5poRHy8GWNwYysT9zlSbcbLzsfZMkZuyJfTAeMTnkMoglEG6RdDRpoV0yD8woBIrA0S4wc0ToyMRKBiGuTm4UhxAoO5Se6zS5++SvvkbqHdSJenWoUuI3fxs0CmVuMmlOkjUjb5GDDV70kFRN+8iMGtga3IvjVlyzgGYNXee5TnnDWw+Ss8sj/Hi2BG3p0t//aMCPvqJKaTqndt35y6yCW2QBEv4LURLZs8BJrGj++RmC6unCyhKmAZGsit4fnl6w1NM1qyJmlwtQlf2LlrVvEiQ5eRA7cByYtzqmgBHiGMqukHb3jRDymWFRjYDP3Gp4gy3drQ+y+CpYhmYhk1jjvtNEILzfsVMbJOXO5BLJnxvtRML3MdaWM3o7PZ4X2L+Hib7Np3nvUeHSdSYuri4rSWnN+NP+Xokw+O2xzg15bo2Ge8/7BDUziTAXed4zrbcnIT+htt0jjUJCaEWhLj0J+xxeZJBEmZZri5GIENPR6cFW4eZN1yBuhcu0UVqswm2G30oGHQnj8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(376002)(39860400002)(136003)(2906002)(316002)(36756003)(478600001)(16526019)(4326008)(44832011)(53546011)(26005)(8676002)(16576012)(31686004)(5660300002)(66476007)(6486002)(66946007)(52116002)(186003)(86362001)(956004)(31696002)(2616005)(8936002)(66556008)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NTliUjlCWFFMcTROcWZTNE5rMlgwcS9DUEdKbmlVdm9VZ084NHUwemZodTJ3?=
 =?utf-8?B?a09MNFJkMnB6Q2R6eEJVb2x5M0lnSGtNVjFiZ01ZMEFVaFluN2xKMWZrRjdv?=
 =?utf-8?B?dTJWREhSY0t3OVNDT0MzNzRLN1JXODlOM1BsdXY5VGIzcXVSaFBwNTYzWml5?=
 =?utf-8?B?aWU0RUloNXpCZFF6WWU4NFJHaHN2dWVuU1dVNDFIbDdKcUN0b252MmlHdWdR?=
 =?utf-8?B?TGVVSHpqcWdHN2ovQWMrL1ZwNGhWQVRzZGEyVWZMT0tzbE5ndDM4MXcreW0w?=
 =?utf-8?B?a3Y1MTJQSjhUd01wTFFwRzlRMHdIQ2ErdGZVMVZ2VVFCVlNWUzArMjlURC9D?=
 =?utf-8?B?OE9RTnJuMXJuaHpncFhxOFkydXRJcmkyUFZ0bGZEMU9ISlhVMFJoV1RVMi90?=
 =?utf-8?B?eitEOWFJdU5kUDhlTXczSU16U1gzRmpzcEwyUUNFQUdxTDYrQTFOVFFJeVNm?=
 =?utf-8?B?eWZNcTZmeDVuc0JLcDQ1QUZRMWovOWtLMmNmSkRqRnJXUWkybzBIemdoOEMw?=
 =?utf-8?B?QWVCUFBRYUpERmlHcko3OHoveVBkL003WXJCWkNnMU42QlF2WGFLR2I2MmVF?=
 =?utf-8?B?c2hiblZjbVFkc0RpMEZ2NTZWRDlTdW9QWU50ZmplNHU2Y0pGeThEQkQ3SUZJ?=
 =?utf-8?B?UGNDUjg3Q2JZNWdWTHZTYmh1eEdFVlYzbmd2b0wrNkZYc1VyZG9tdmtWRDI0?=
 =?utf-8?B?WmpqMXRQZDE1TnZ6QUtXWk11bHYxYkx0c1NGYzQ4NFZxMDRORkJUMzVIUmFo?=
 =?utf-8?B?NkpLZXJIY2Y5aFBFRkdqalpLNDNWVUJiSUUzMUFzTVQ2cjJtN3MvQWlqRUFZ?=
 =?utf-8?B?RytucUkwLzUzNU1UVHBtd0RUU016ZmsyS1ZxNTBaYkliZVdYeVM4SERjNEtP?=
 =?utf-8?B?NTRqcFMrdTBobkE0ZU5VaGhtYzNNR1p2WVM0S0RFWDhMSXppWHp5a25ja0p1?=
 =?utf-8?B?MDBONDU1eXdZY3RmUU9BTUIrYWhHemZEcW11U0Z0aW9WVVYyc1VUa2ZxMTYx?=
 =?utf-8?B?bGVLR2FzVlNBY093UWtqT2h4TW0yZS93TlluOU1jbHEzQUhMbWpqODlnMlpp?=
 =?utf-8?B?RG9icVlGSXFwbVlXbHVPMmZjM1VRcDFWR3I1Qko4YWY0VmVCZFNiZkhZRHha?=
 =?utf-8?B?T2picE1POFh1NzgxakpxUGFFRFZGU0VvVTFqb3FpUk9SN3B6U0N1b2dsK1Js?=
 =?utf-8?B?Y2I0RmthcXFWNjBtMlRNWWlrM3BNRHM5SXA3SnhsR3FqQmsrSDR3UXpEd2tX?=
 =?utf-8?B?RllUdGJoVHVLbGUySFI3NzRwekxJVit6NW5pcGx1ZFhTN0Yzb2duZWVwZUFG?=
 =?utf-8?B?ek4xeDJNQmI0RnBNaDZZUVlNbGM0c0dMM3JYWWh2ajUza0NieEQ0d2pXc09y?=
 =?utf-8?B?WE9GczdVVjR5aVdURUt2RmZPOEZVODZlQVJlZi9wNWF3OEtYTG0rT0ZGaWxU?=
 =?utf-8?B?dTg4eFd5aGxXYWhPaWtSNWg3VHZ0Um9yWGlLK3oxV1JtbjgxenVnaFNRa243?=
 =?utf-8?B?YmV4YUpVVk5zMWRKQkNuQUhYYnVUN0x0c2FnRTFXSmxnUHRyZFUzbUlVNmxQ?=
 =?utf-8?B?aVR6KzlKeFI1M0ZFN2JCUmRFUVpDRGpuNEgvQTdORGEyTG5PYnZaUytaMW1K?=
 =?utf-8?B?TG9XK0VRb1paWVJkOTNqd2oyRWVxeTFpVWtocU9WKzVidVZESWFFRE1wU3FK?=
 =?utf-8?B?dlJkK2k5d3ZhTmE0dmtHUWgyYUU1d3lJc1Znd1I2NkV2K3RtMVBRVG9mc1hG?=
 =?utf-8?Q?GQCo+1M3dysjwXrFKj4vlmmkHqVyu872D6zfSvA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87dcc1e1-386f-42de-2f16-08d8e4bc8a71
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 18:36:10.2454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V/Kg2Klk/utrXZYo3fwIzwC46NOKlIdfX3q8IuENmL39Hat1+Q/zdYA6yeQ3C0cmMct1JHsUODQvRQDAQfSsDiitFLJAUsaFkc1vvwMenFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4167
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110095
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 clxscore=1015 phishscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110095
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/11/21 1:52 AM, Chandan Babu R wrote:
> This commit adds a helper function to obtain the value of a particular field
> of an inode's fsxattr fields.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Ok, looks good!
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
> V6 -> V6.1
> 1. Pass '-w' flag to grep to limit searches that match whole words.
> 
>   common/xfs | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 26ae21b9..aec2cea6 100644
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
> +	local value=$($XFS_IO_PROG -c "stat" "$path" | grep -w "$field")
> +	echo ${value##fsxattr.${field} = }
> +}
> +
>   # xfs_check script is planned to be deprecated. But, we want to
>   # be able to invoke "xfs_check" behavior in xfstests in order to
>   # maintain the current verification levels.
> 
