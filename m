Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5345C47094
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 19:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B85D36124B
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 19:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhFNTlq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 15:41:46 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:60882 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233865AbhFNTlp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Jun 2021 15:41:45 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15EJVQhI028027;
        Mon, 14 Jun 2021 19:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=dwGQkPPIx+vpxqEzfU+yLAjeck7DOHn9IB9pDR3ZS/U=;
 b=0ZXHKBUwAvVPnzRvQPRxaO1dXPWy9XndlMTRUqY2wdLwIoz9EDS48NghyCgKOK7USYO8
 d4WIqj9+bKaEAcjYMLC/1Rj/TZUZnfoMa564D/M1OrevzB4o3OsmVdibNY54PyYBGdyg
 ewUsADWUiAN7a9xa2rAfMA0Gg+T6srZ86FcnB/xINkOFYHAZ+MUaxfgjQK3ga+9BC9AW
 ZdGuhWPdIRI0EDZUElHVZn+6L/THSYf5fbpOiNDWqX9BqIeCulaj5zgomYp+sFxybQRL
 thKQqLEfKbBfUoLkOfMHNqKPJRBx+lSrLginBG3chdJ2azX8fMgle6US1fd5CCI9Fpix Ww== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 395t6drbgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 19:39:37 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15EJdaiP055650;
        Mon, 14 Jun 2021 19:39:36 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2047.outbound.protection.outlook.com [104.47.74.47])
        by userp3020.oracle.com with ESMTP id 395hk2nvem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 19:39:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7yLyyaa8Mt3rXzPeyaZW+nmJC48qEn3xcoGCgnGBbDOHepaXsVluFtVTvxphWfD64F1L7ngSizHxzTUU8822klmqNsHLxY7Ry/sa6Rj1VYNDvaYNgZBPF0lcYSpXHR8CAIC6hRdFkVLI+R4PpKmA+KEvY+2Wul1BsGu9uc8BOoBf/pxRzgh+MKWcYkuB2k2Vjw6IfQ/wcsnY/B8btOMRqlJh6RHYsUkZOt/KLZSNhmziTjIBqbGuKiXzMyLHjXCt6Q7VJadRAIhGMowb/9YgTyIFEJUxtYBEto3i2+Xy0mddD7nVbZ7BQbPqiYll6NncpJY32Ot33Kn8lAgxNR2WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwGQkPPIx+vpxqEzfU+yLAjeck7DOHn9IB9pDR3ZS/U=;
 b=RjrjmjC6JiaDfPMHJuMMHMFUNE1rPK/531EdQYKxMoRy4IMDdG4ZGyeZJGeIIKTVodG0+Snk7if0m7t1GkYZk4D2f2TwOQ7YJWGhpP9PTALeEGXIE9R+Ix5fHUd1kCnStzYtErPd/e6OLkgm9/K3fi+Q0p9NKQnd42yQc+63bgIaKtiNJocw5EyTD3eW13DhqIQx+DAHU3/FuokOpDwQb7UntKZDGsoYXPhwAx6z750LlnAfGfa7Qf+K4dz0MWwU2M+I4VKpZuSgdkm70r4WOqdOB7ILrcU0o5xXHGyguVz3jOjTfeW+0ogHMnhPuyzZwVV4M3IeLWuNMKYUlogDPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwGQkPPIx+vpxqEzfU+yLAjeck7DOHn9IB9pDR3ZS/U=;
 b=wIZkeeLkhbzbNBZeXmlVy283BYwRkD1jXFLt7H4cRgjhySPE0N7577pgRvrk8imA30MCnh6iwlpQObK+aI0EH6nYF4aASNYWD3rkmEDIfmEXawzqLeZSS3FYdO9A+hI+Jzr4Yyeq39Qgbenm3G7VzWkzvEbCtguxG2YJ3f+JPXk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3143.namprd10.prod.outlook.com (2603:10b6:a03:158::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24; Mon, 14 Jun
 2021 19:39:33 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%6]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 19:39:33 +0000
Subject: Re: [PATCH 10/13] check: use generated group files
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317281679.653489.1178774292862746443.stgit@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <a67b9b15-25ef-194a-9c03-c15a4a6fa00c@oracle.com>
Date:   Mon, 14 Jun 2021 12:39:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <162317281679.653489.1178774292862746443.stgit@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR13CA0086.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by SJ0PR13CA0086.namprd13.prod.outlook.com (2603:10b6:a03:2c4::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Mon, 14 Jun 2021 19:39:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4c1afdf-e127-462e-75ce-08d92f6c22c8
X-MS-TrafficTypeDiagnostic: BYAPR10MB3143:
X-Microsoft-Antispam-PRVS: <BYAPR10MB314348B2DCA827B3857B177A95319@BYAPR10MB3143.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bY+d5rDUXJlCCgmkJ4YT3pMSlx6b+eqix/WdIhCiJfbR4+cAxqN0NsxjpJJMGQgih3l3/Scjmn/6dnZGU6bcWSb0RVsRnal20f0c/rMXemYz62lT81hTrUrfetY6ZwObfMqOeOLQjW253CU+Nt+zJdzUqFzPfcErziwDnNCJ8IofnVJ+Uki4dNCBYYuiBUY6W/bwfHB+k6qABJYsPw+i6N0yQzqd7WsLToFyXjhtgX88DtLtg4TpAiWJXuPiMvv9NU1q9Rz48FrnAWvJy2T+y5pSzwIlJxB8mv1+aVSDDmjnz0o0hB+FqKgEIdJR6h60erZrfFJvv6nsrP9uF+mLS72vZl0s67RTybeFeAraBmtwlxlWCOCCs1cqqmyfojfQC7pqwFCMRqoSaPV3k+ApFopDMJGni4qUONVKd5eSyG6K235vsEymRJqUhDBEqVi3bghGAY2xmCaGteG12a8/1N3T1/aUtaECl1wP0K5CeGe9McFx8+fXChl/WEnAD27yrLP5HGxGMEwnrlQh4kGUQqYFXIc3BMaRnoYL87FufKOwR0bK4odlQA72LqsiSYkj13CP9M7+v7vJsB7G9tXpg15K9S/bWSDNzPU/ZTwY1vmPBagdiMaIVyxHm1V0Ym4B+wA3M04GDSCqYnuNZzDmOEcp2rSj2unZowLUqEx7oR+YsVWz8xG/oRiDmH/xtq0x7RTlIJTtbGuzKSTq4G/Qbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(136003)(376002)(53546011)(956004)(2616005)(66556008)(31696002)(4326008)(2906002)(44832011)(66476007)(478600001)(66946007)(52116002)(38100700002)(8936002)(38350700002)(16576012)(36756003)(31686004)(83380400001)(86362001)(186003)(8676002)(16526019)(6486002)(5660300002)(26005)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aE9TOWtBVFA1WFo2SW1tYmhkK3ZyZWVqVC92MEJjKzNDalVhQXg1MkJvdXNI?=
 =?utf-8?B?aWdhbWdrNFY1NjdyanY3d2lZUUdENGVwVksxcmF4MDRLV011MlRFT3dHTGlq?=
 =?utf-8?B?K1pxd1R4Wnl2ZFlzZ1JhYVlSZTVuUjVvdDk2UFlnWi9FM0RnS0V0MEs3YUQx?=
 =?utf-8?B?UHJ0azVKTnRQMlRjLzRWUjErUDl0Z3RqZzArZUprN215eEE5SC9MVUFmUjJ2?=
 =?utf-8?B?N0VtejhEaW1xMGJYamdwVW90NkRvblVGY3NnNHBoWFBPTVE4ZHJ4VHhWTGNM?=
 =?utf-8?B?Q1F6Z3pFTmhKeXZBLzZZa3MxelU4azdXZTMya0sxWHZKcjRLVUM0ZlJHYmpY?=
 =?utf-8?B?OFJTNkI5NjcwV2VqSWtWWkYzSTdvckVHcnV0ZVROU3paK0RoTzBZVG51YnJ4?=
 =?utf-8?B?cllhY0ZQYWJ5RDZEYnBIV3hnRkI5VjFON0k4VmFoNlZQZDdkYjc2MnVOVHd5?=
 =?utf-8?B?dnlkU0lJSGZOM1U2WjBGZW5QYzRkb3F3T1FPRTIxQnFQOEpFcVVLdVFKU3NG?=
 =?utf-8?B?QmpyQ3NvLzhjekl3Njd4bEZnUnpGN0Q5d1VqKy9WWmlZUU9QQXlpSnBVbWJx?=
 =?utf-8?B?MWNaQWdlRXp0UENScmNTRXR0bzFFTXE3ZXNOZ29RNkF0alBRN0xqN2hQQVBS?=
 =?utf-8?B?UkRuQU4vWkNNUW1nbmJDbyt0SkRvQ0U1OVBFODRFVkFQTzc2QmluLzdLQ1Zq?=
 =?utf-8?B?a0RPeEpCOFhhWHNCaHRiUStCWSsrWGR5WDM3YldES2RjaDBzb2FUcVpOUzBq?=
 =?utf-8?B?WmVwMnk1WE0wV3lzd1hoUnFnQ1hFQXVidVJPd2UrTDZTMnh6Y2F3cnBvOVNT?=
 =?utf-8?B?YWRYTzVYOG1UVmprdlMzNlR1MjRIeTBlZTFDOHBJSEVZWllqKzZ3TDNXczRC?=
 =?utf-8?B?UldOb1AwczBTTlZPRFRLZHA4MHh1TnpQaXdUWG5SVXUwZytiZW81NW55V1Zw?=
 =?utf-8?B?M2RySWExVnFBenZpQmJpTE1IK2lsOUNsSFhNc0VRMUU3dE96NVFlMjBYTk5i?=
 =?utf-8?B?L25RRC9QbXZrVVgvSW1XT2RHTVZsTkx4V2FaRnQ1NXVXSnZ5NHc1bEk1emxj?=
 =?utf-8?B?aThUYVZUaW1sQkRsamlScjQxRUl5d2tJUlRzaGtqSXo4WWdWSDNoWEg4Yit0?=
 =?utf-8?B?RXJqM1h0VzlpekVZT0QzMmc4YWsxNndVNzFGcjBUaUplSk1qLzJoUUduSUlV?=
 =?utf-8?B?ZzlMTVBsZ3k4YnI2aWl5VnVOSWhpVzB1MCtvWDd4VExVTERLSjdkQ3ZCTUJq?=
 =?utf-8?B?VHM4UjgvU2tpdWQwWStFUEpHU05MRmN6c2g1amUrTVRZaWlxVDY1cWNZZnYv?=
 =?utf-8?B?M2pBbXo3ZVR5Y2U0aGQ5V09GZlhwZHVhT3E0YmRJNHR5dlBFdE03SGdENU43?=
 =?utf-8?B?ZndldWwva2t5dWxmRzFtMjhDM1htWGRicjAzTUtDMU5KNGFMcm44YXdJdkV1?=
 =?utf-8?B?VFUwd1RiYWxFS0Y5N0xXR3U0TEc4T1lXbHBKQnVVK2hWc3JxbnNZN3liTWU3?=
 =?utf-8?B?N0w2aDRTVEJvVFhFNWhGZXl6RDdnS0FOUGxPZ21YbFc5YkVhcDRCTDFtOHRo?=
 =?utf-8?B?TnM2S3dCSFAxV3UwbU1uTm8xT3FMMXg4UzEvNWtIZ0c4V3hES0NUYkVLK3l3?=
 =?utf-8?B?emhtSHJLbnhWQlZjVmRYYjdvSkxtSlBRenFObWZuQXJWVEk5Z1dLdWdQZGI0?=
 =?utf-8?B?UmVXdHJhWWhvVlR3czJuRHRPUHIvR21hVDU2WXlGTmNoRys5ZXV3SEV0aGt1?=
 =?utf-8?Q?WNblPstjQrFHYfXQMEsI8T6KcwGtv7z/r3vcbQU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4c1afdf-e127-462e-75ce-08d92f6c22c8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 19:39:33.7824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0zIvpceT1JtwFIBfmYZcfWvaDUHmaBODPzJJkTFP8iS8rM3KjbiZEQVmoeEUcvVSXFyuKOfOsba0zdKSVmkgE+q+4V5S1FLPa6i2SB5SXhQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3143
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10015 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106140123
X-Proofpoint-ORIG-GUID: bLUljz1kTbMzYRKr_v3snDY3cpjQ3G9B
X-Proofpoint-GUID: bLUljz1kTbMzYRKr_v3snDY3cpjQ3G9B
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/8/21 10:20 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Convert the ./check script to use the automatically generated group list
> membership files, as the transition is now complete.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   check |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/check b/check
> index ba192042..3dab7630 100755
> --- a/check
> +++ b/check
> @@ -124,9 +124,9 @@ get_sub_group_list()
>   	local d=$1
>   	local grp=$2
>   
> -	test -s "$SRC_DIR/$d/group" || return 1
> +	test -s "$SRC_DIR/$d/group.list" || return 1
>   
> -	local grpl=$(sed -n < $SRC_DIR/$d/group \
> +	local grpl=$(sed -n < $SRC_DIR/$d/group.list \
>   		-e 's/#.*//' \
>   		-e 's/$/ /' \
>   		-e "s;^\($VALID_TEST_NAME\).* $grp .*;$SRC_DIR/$d/\1;p")
> @@ -384,7 +384,7 @@ if $have_test_arg; then
>   				test_dir=`dirname $t`
>   				test_dir=${test_dir#$SRC_DIR/*}
>   				test_name=`basename $t`
> -				group_file=$SRC_DIR/$test_dir/group
> +				group_file=$SRC_DIR/$test_dir/group.list
>   
>   				if egrep -q "^$test_name" $group_file; then
>   					# in group file ... OK
> 
