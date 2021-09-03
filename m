Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A32C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Sep 2021 21:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68EC161101
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Sep 2021 21:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235320AbhICVKX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:10:23 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:52270 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235926AbhICVKW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Sep 2021 17:10:22 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 183Ix8r3026099;
        Fri, 3 Sep 2021 21:09:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=xOOvyrnIo4SjNczISSkXooKfDTkuxE+aYRNM9V3ZlKE=;
 b=v3stRFxru0skXxC4DdOnUBuqi06xtZiAiIH3QXGmYVwQmIgCrlZ9T8oEhFyV+HN64kFh
 RS1JZ0jGtXDhMWSUlBy1DCM2JPoweZ1Rdd6h4Iehx7reUCSKGqhyiTSgE+N4oQlyTd1+
 TsXRqHH2etsAEgAotoBWrXBOMDxOZTD1iv3s76ZdnqVJnAGZY963G7mWzW3F/mbI30Xh
 dKLkVYOEGi7LnPYeY7M5JLaUtBUBmPqbFp9OI/MvL++eeEro+GkXTmPTOpjG+9YyUmVi
 L7ZB6VlvuX3AUg+1NMAWDPa2pRy3K9c2Xc6j8vakC3aPk5b+C1lY+hVcRhj5GpwWdwNG rQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=xOOvyrnIo4SjNczISSkXooKfDTkuxE+aYRNM9V3ZlKE=;
 b=JED4gF9OYrLr8+hUjiNjSEk6fD7/ZXe1hkSz1DLvVOX2HB9CD7QLMXUZtVIrDzMSFfLr
 gQnbOe5hXDpsoeqJPLyeUOOL8K4vY6VhpPwF8gYOod1oAryft2gKTjmKdAjPAf4D56RD
 j/vaF+B1WVkeYi7Yn5Ri/uQGIev5J3WpDtuH/MLKEhj7Pm1ScDdsNVlKFbLN0hPP8Og9
 4AmygxSEZ3GdW6RFjFa7qWG+pKNy+LmgR7VdfCFS9XyJ59RO4lQYt0UVPMx7aKXD6g4x
 1mswl+jluD8Yu1lbeWKtdQ7i6LQuxzr9CP5eBpSKPNMCkHKfP0aqMYa2VbuBuryodk/M rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aug2pt1jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 21:09:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 183L616E097849;
        Fri, 3 Sep 2021 21:09:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3020.oracle.com with ESMTP id 3ate022qsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 21:09:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWdkmud2vrJ/GjFByUtvfQOtD8kwUmceGgNUTTLrt8xvlluMbf/MAT1b29zyyCKWLuqx4HBxBi9skCPDdNWuxQWRn5hfOxKK8Pj3nl92zKzYbla3nyUjIE35ZiRwwGlGALFMDd2rHCeh97NufdQG+6C64jg5iuJW8OYnzUy8CxBQa5xw3++7HHOvQleiUrXLPZXSxX+EI8IoYG5u+tnmYj+kTbZykl8xfhob++4ChF3/e2QZL8ISn9vN8isYirwfuu/+C/F6REB6uk/X/7RmPoD/5OgWANrqbwY4+G9XMZwV6SRVhSYBZ/RLYkoS8wyjAxzacUE6kZFOji0qra978A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=xOOvyrnIo4SjNczISSkXooKfDTkuxE+aYRNM9V3ZlKE=;
 b=K1Z9u4qsWPxy3bsYklA3weOZPaiSaQatT6TrrAsSRboCrrkMma2DESy9gJ1KXIWAq/REU6zcYRtEXnlOkGexOVIO3gv/TOJHyXVIrLA/c2X4Tyo9on651nnnL9wqX2Sok7E3hdNt2y4wEg1Mg7EX7GR/yoMIWGlRrwp2V2+bmpBMDKgaTNL6uTH4bi/+sOKa+1R0OO5WBpifMIc3MEk3yBe0ZVN+UQOB5Qjq04SsgPJeD4DDuqFMTW469VXJSv5BGXPu1OJ+5qQxSjofrGUyYT3MQ88fXNjSEnhm8KJ0PUusthoGXW96zL/RnLs/DCkrjClF+yRUXwq75SxOhZ6wxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xOOvyrnIo4SjNczISSkXooKfDTkuxE+aYRNM9V3ZlKE=;
 b=ElXs0df/vGe3t/LqIhwX5ERJum1PPPoOcSOZchLoByuTKPmjLRriCchlYQbYcXKsfoD4XjbrQ+aGx3HqBZ0SoA93vVS6Hn+M29rkP4KM00J4APPntbp1ENjxjsqPLeXBLTx+zhD2o4ovz+4NPvDq+MfM40076zaOQTZcHfABvE4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4765.namprd10.prod.outlook.com (2603:10b6:a03:2af::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Fri, 3 Sep
 2021 21:09:17 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%8]) with mapi id 15.20.4478.023; Fri, 3 Sep 2021
 21:09:17 +0000
Subject: Re: [PATCH 4/7] xfs: add log item method to return related intents
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210902095927.911100-1-david@fromorbit.com>
 <20210902095927.911100-5-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c609c974-7a11-e108-0431-b7e4795af9f1@oracle.com>
Date:   Fri, 3 Sep 2021 14:09:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210902095927.911100-5-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by BYAPR03CA0019.namprd03.prod.outlook.com (2603:10b6:a02:a8::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Fri, 3 Sep 2021 21:09:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8a78917-ce35-44b5-f8e6-08d96f1f1727
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4765:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB476518691F8DFB756A49A68E95CF9@SJ0PR10MB4765.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LuPq4jvey4b0NJvTC+FRU2ztuhBixCxUWEjzS4nOaKvbVyJxZDTQD+pobQH/c1dmcWQ+HPDsmV/NJ5vwR8OfkhSFciNzJSfWSfHEOglGvt14Cp+toLT19frJ8skUEdRF4CwHhOg17y381AcUhZH185Wv4TGkjQs41i7gOQLeLDPw3BzVQ+cRhDW2RMfRkk1AhneP5vPFx/h2jNSOOl6NGhKa/TOg7cg5DJaSqDg7t+IRbNZZkdM0dLlpXdwf8RO66h+/GX5XOsZJbf1lPMS6lu07FH5HKXJDohz9x0X/ESD11NcHI997lbmA1bnlHCutffzKmuCVdBi+3A2aaNTEKCQ/2AHJ1KC8hbofUBMt2+PUsszGn69DhGPjXYIRD8NpnJ0iC/Tn/MJSwR1GEWZCR3zeH+uI6DYRb7bTRPzrsxJRJXyXVedkqhN51H6Oqs4CwvVaIrdooBbzVOrMtLfygXzB+JDfjrngS5WSS/l2c0lwKd9E2VnDm0syJpdJmfl0z+Rv03ShoxlU1HA+sDIdUiAnifkfXjxhnRul5Pe6hafcacUDalskHyL1p61bBKiKCNunLJOfARl2t8OsE72/1zOxC69C82GVcaavYlADPpEwOLaepwL4bDfzcMpGK6/b58vQAf4yXzId9Erc9TR8v9QGoB5MFSNRqpFHXPqccea5DSa64rWcDwrf78WSQX9U6cOY+07Nz9xlkyNEpAtK2Hnqq4eZNLqko9O5s4u3o/NjLcXBD0QIQ05D1c+jC/UW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(2616005)(5660300002)(66946007)(66476007)(86362001)(6486002)(44832011)(52116002)(36756003)(38350700002)(38100700002)(316002)(16576012)(53546011)(956004)(26005)(8676002)(31696002)(2906002)(31686004)(8936002)(66556008)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEM5K2xEVTJVd0xZOHZQUjZWb3RMRElTd1AvN0s1bFAwVXhXNTZJOXZSbloy?=
 =?utf-8?B?YTROWFpiY1NKUjRPTW5md1U3ZTZWK3VaNE43QXF3TWZtcUtSUXp3ek1aUFNM?=
 =?utf-8?B?bnBtK1l6Y3czcWl3MnpmOGJrR2ZjZkJYV3NvZDFEK25DcjZkdFBWbTNSdEM2?=
 =?utf-8?B?U1pOSXNaWXR5NW9lUTl5ZEw0Zm9tOVVnNUJlQWFOOGUyQ2FkcmUvTXk2VDU0?=
 =?utf-8?B?SytQMWhIRnF6ZXRjcGFrNmp2TFlMd01RT01xVkNlS3dQREVQazlES0pUaVpu?=
 =?utf-8?B?WjRscS8rNGF2T0RJSjZVUkFBUUJmYWtXcTNFOEx5Y0t6VzlRWFNBOUpFUFEr?=
 =?utf-8?B?TWQ4TG9ZUjN4UE1ZOG1FSHVmRHdIMHdzY0d6Z3JMZUVDWkZ5NEVHTHhMNURr?=
 =?utf-8?B?OW9weHR5QzlTbUFhWGw0VWtFc0ZEUG1Ebk8vZjVZYlJaMjNYMUJXYUJCNXlw?=
 =?utf-8?B?WENlOGRUYXZqd0ljdEY3aUxuQVlsd21HSklZd2VqQzdDcDlicTRsMG1XbkxV?=
 =?utf-8?B?OGpoN3RWUEE4dnFiTGVyb25vTDhaYm9LaFNhRkVoSnYwRVJITVMrZnBQS3B3?=
 =?utf-8?B?UExEM0krNm1paFVOdFVIQnZxS3VzcEZleHVuVDhMOGFoeWpYN3pyUEJXck9F?=
 =?utf-8?B?bjlaZEUrV2RzbVBjcGVsekpaQXFoNzMyT0phL215VTd0bzNsRkJiTWlrQndH?=
 =?utf-8?B?dDZlbEcrUDZJZ3ZseXNTc2NGRUFLbitpSm5DWHE2YW4yWWIxdy90WHBYcVND?=
 =?utf-8?B?T2pBMmVWTnd1UE5PTEtHam5HdG11a2RTYVBad2dLOENsaFg3K3c3bzNwaWdV?=
 =?utf-8?B?aFlheGIrbGdCUnE2dVArcTJGeEFveTRoMThVZ0RlMTNXQlVDVEN4REJieEVl?=
 =?utf-8?B?ZFpQVU11ZnhOa0VSbU1MYXFnY0pyNlZGeVVJdGxSbm5KbklGaFdKZjRWcnRO?=
 =?utf-8?B?WThqek5aRUxtT3dXZUlVUDg2K296K1d6ZFhQNGNHSXc0SUI4Zm9lWWRXaUVL?=
 =?utf-8?B?S0wzRnQycXhQQmFOZ24wandxVEc0YjFLTEtjQU1GVjRzb01jMnNGTktSUGlB?=
 =?utf-8?B?aEk5NXBCeUZ5U2JoVHJyeU1PM3VmWEFhOUhPODh2elFmOHZGSHo5bm5JNW5L?=
 =?utf-8?B?Um9BSFUzS0tWY3JXV09MZGV0VUUyVFFqZXlxeHNIR1ZHZy9Ja3J6SmhGK0Mv?=
 =?utf-8?B?RXVHVHhxeWxPZ3JtbnJ0UmJIT3hROHAwMDJZaHdaN1FnaWJ2c0Z1dVpUZkJW?=
 =?utf-8?B?REVORGNHbjdocitadnI0bWovQ2pQYk1ydklrWkloNEROOHBvM1lVVHMzNWhE?=
 =?utf-8?B?dUpLR1hQMitLc3ZpanJWNHpjK3lmb3pMMlZYR2JGRk5GbFpyV3JFMDJTRG4r?=
 =?utf-8?B?cU9aU1pGdnh0QjlnY3laWlRZbDkrN0ZaVW1ieGtvRllaLzRTbkFMbUwwWFZq?=
 =?utf-8?B?UFdLVXhzcExKa0VBdW5SSnFlVEhqbjVwWHZVRzVGNERNU0ZSVGh4ckhROXFy?=
 =?utf-8?B?U09BL3Jwd1NzOVhWWEVGTFpGUjlQUGExK3Nxc1d3VGZjajNKYzEvdy9XU0VG?=
 =?utf-8?B?eUFjYm5DWmt5TWFYTFZKOTl6bktFNHlBWnV5YzVMTWFzcTVqUTllVmthK05C?=
 =?utf-8?B?WjNTL3Z5RkFzamFCRWJpemZGNVhIaHRUaGgvaDZiTzBpcDl0VkFESE1rYTRI?=
 =?utf-8?B?NXdqZTJHRUpXUlJqZk40VzA5UHh3NFZ2UzRuY2c1NTRSbnh2RWY0Y0VQWWYz?=
 =?utf-8?Q?WXihHZDQGh8uvEIg6irnoKrPvveqfMXUsKFegWk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8a78917-ce35-44b5-f8e6-08d96f1f1727
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 21:09:17.3447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0D9sPY7VpZfB0TJpcmqGyt/qrsWd2dorwrxpNmt7IfRB8CQ+RLEAMruIzF/CFKVd2hOjvAlOeHW+MPiXT3PvyrJE2EpK+FTNPS8VNz8yLl8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4765
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10096 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109030123
X-Proofpoint-ORIG-GUID: OwX-3owpr7zr4CsBo8k9nhvmCHcRwesA
X-Proofpoint-GUID: OwX-3owpr7zr4CsBo8k9nhvmCHcRwesA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/2/21 2:59 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To apply a whiteout to an intent item when an intent done item is
> committed, we need to be able to retrieve the intent item from the
> the intent done item. Add a log item op method for doing this, and
> wire all the intent done items up to it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
OK, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_attr_item.c     | 8 ++++++++
>   fs/xfs/xfs_bmap_item.c     | 8 ++++++++
>   fs/xfs/xfs_extfree_item.c  | 8 ++++++++
>   fs/xfs/xfs_refcount_item.c | 8 ++++++++
>   fs/xfs/xfs_rmap_item.c     | 8 ++++++++
>   fs/xfs/xfs_trans.h         | 1 +
>   6 files changed, 41 insertions(+)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 572edb7fb2cd..86c8d5d08176 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -480,12 +480,20 @@ xfs_trans_get_attrd(struct xfs_trans		*tp,
>   	return attrdp;
>   }
>   
> +static struct xfs_log_item *
> +xfs_attrd_item_intent(
> +	struct xfs_log_item	*lip)
> +{
> +	return &ATTRD_ITEM(lip)->attrd_attrip->attri_item;
> +}
> +
>   static const struct xfs_item_ops xfs_attrd_item_ops = {
>   	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
>   			  XFS_ITEM_INTENT_DONE,
>   	.iop_size	= xfs_attrd_item_size,
>   	.iop_format	= xfs_attrd_item_format,
>   	.iop_release    = xfs_attrd_item_release,
> +	.iop_intent	= xfs_attrd_item_intent,
>   };
>   
>   
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 5244d85b1ba4..0b06159cfd1b 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -201,12 +201,20 @@ xfs_bud_item_release(
>   	kmem_cache_free(xfs_bud_zone, budp);
>   }
>   
> +static struct xfs_log_item *
> +xfs_bud_item_intent(
> +	struct xfs_log_item	*lip)
> +{
> +	return &BUD_ITEM(lip)->bud_buip->bui_item;
> +}
> +
>   static const struct xfs_item_ops xfs_bud_item_ops = {
>   	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
>   			  XFS_ITEM_INTENT_DONE,
>   	.iop_size	= xfs_bud_item_size,
>   	.iop_format	= xfs_bud_item_format,
>   	.iop_release	= xfs_bud_item_release,
> +	.iop_intent	= xfs_bud_item_intent,
>   };
>   
>   static struct xfs_bud_log_item *
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index f689530aaa75..87cba4a71883 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -306,12 +306,20 @@ xfs_efd_item_release(
>   	xfs_efd_item_free(efdp);
>   }
>   
> +static struct xfs_log_item *
> +xfs_efd_item_intent(
> +	struct xfs_log_item	*lip)
> +{
> +	return &EFD_ITEM(lip)->efd_efip->efi_item;
> +}
> +
>   static const struct xfs_item_ops xfs_efd_item_ops = {
>   	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
>   			  XFS_ITEM_INTENT_DONE,
>   	.iop_size	= xfs_efd_item_size,
>   	.iop_format	= xfs_efd_item_format,
>   	.iop_release	= xfs_efd_item_release,
> +	.iop_intent	= xfs_efd_item_intent,
>   };
>   
>   /*
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index b426e98d7f4f..de739884e857 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -207,12 +207,20 @@ xfs_cud_item_release(
>   	kmem_cache_free(xfs_cud_zone, cudp);
>   }
>   
> +static struct xfs_log_item *
> +xfs_cud_item_intent(
> +	struct xfs_log_item	*lip)
> +{
> +	return &CUD_ITEM(lip)->cud_cuip->cui_item;
> +}
> +
>   static const struct xfs_item_ops xfs_cud_item_ops = {
>   	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
>   			  XFS_ITEM_INTENT_DONE,
>   	.iop_size	= xfs_cud_item_size,
>   	.iop_format	= xfs_cud_item_format,
>   	.iop_release	= xfs_cud_item_release,
> +	.iop_intent	= xfs_cud_item_intent,
>   };
>   
>   static struct xfs_cud_log_item *
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index df3e61c1bf69..8d57529d9ddd 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -230,12 +230,20 @@ xfs_rud_item_release(
>   	kmem_cache_free(xfs_rud_zone, rudp);
>   }
>   
> +static struct xfs_log_item *
> +xfs_rud_item_intent(
> +	struct xfs_log_item	*lip)
> +{
> +	return &RUD_ITEM(lip)->rud_ruip->rui_item;
> +}
> +
>   static const struct xfs_item_ops xfs_rud_item_ops = {
>   	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
>   			  XFS_ITEM_INTENT_DONE,
>   	.iop_size	= xfs_rud_item_size,
>   	.iop_format	= xfs_rud_item_format,
>   	.iop_release	= xfs_rud_item_release,
> +	.iop_intent	= xfs_rud_item_intent,
>   };
>   
>   static struct xfs_rud_log_item *
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index ab6e0bc1df1a..a6d7b3309bd7 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -78,6 +78,7 @@ struct xfs_item_ops {
>   	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
>   	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,
>   			struct xfs_trans *tp);
> +	struct xfs_log_item *(*iop_intent)(struct xfs_log_item *intent_done);
>   };
>   
>   /*
> 
