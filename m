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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E282BC47094
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 19:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE50060FE5
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 19:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234436AbhFNTlx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 15:41:53 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:57166 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234248AbhFNTlw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Jun 2021 15:41:52 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15EJWAJG002786;
        Mon, 14 Jun 2021 19:39:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=xZX9HyvnxLvHf6pOY2384nMYi4Q+j7d9r7DWNl+I/gE=;
 b=JGSINhc8ytxxERqrx/xag09egdlyxfcZL9S4NbgFMGXqSysfKZrM+kKuVZHq5h5WfQ0b
 NEypBj2VLo5bs8b0kT6Q05nOUn0z6uzZ9HMvbkDcEtIFPm07Z9IM4jb47mbk92fYCvVi
 j8fOMegYz6W/Mc6OLuUFNtGxouqXGPsl76IWUwus+CX8mL+jzonc/aHXs93hqudwbebB
 eEb9abdrO0FouPXHmAuTeV4m+Nig8qgliOBqOPJPeJZ4BF7yx/LTICuU5Xa+rLet+TKA
 wtcApxNMZvU/4JzIAxfVfSxe6jBvD2JbTPt1vUcjxELXWMIbekNxC1LtC8RBlKgI4ZSt BQ== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 395x06g9v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 19:39:46 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15EJV6UD178627;
        Mon, 14 Jun 2021 19:39:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3020.oracle.com with ESMTP id 394mr76jfw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 19:39:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aCfHty1HNjHWi8t+D+f1qoa6Fn+ihoRQ8eycTJ7YkV8IIyR8AMQOmO46lGpc8m0dF6axSTHE0i4m+st+p6drsfciILS6Fdsga2q7itsIq3NYTqGMPjw2eM+jpMbewikXdCGdPdGJmb8IIQIoQzulbknZvAoyBquHtPpR9guCEfsOjfj83bzPUxOVnLKdyvnvlDZ7i/4LC0vSrq8eynEAgwZM+gcfup5Lr4GRflZTgat9e/cxDHDjxfPJsgonbGc0YHI+Qk4JQHKEjMKCSCMg19FfXV3JB3iMkbmA5Sg4yQ+bnpAcxLgtcGbAq3b6FbcYgv1HYpdfScMsmxXrJo318A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZX9HyvnxLvHf6pOY2384nMYi4Q+j7d9r7DWNl+I/gE=;
 b=S9IoLylg2a7rrUtb5oBos6djPlkGt/JLtbPD3MTeHg4EW+VFlAxu2E8sDCW/yEH8DPjqd+X8462PD+taSB+RR9R/ifivDH6dCQnXj4hZetSAempjQr97XYZkYis1TX7vcw/2iu/E34NQT+bIjFB/ceTWtnUEZrRCpMniMB2TNUUy+hfXF7MJ3v3gaCz4f/DsRFpkZupEGx9wViUiH7zgfTPpws1a6rVPpwaQFK3tlGcPultZuVLiEmLgCy6OzZrKo7QBVjEAXim8gUG4VfVHF4oxmt4YQQ0iSHGERUvBVRgIYo96OkLy8Ko8YBtWXbBlU5DJRiDYCXMksvZj+o3Amw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZX9HyvnxLvHf6pOY2384nMYi4Q+j7d9r7DWNl+I/gE=;
 b=W0x78B6+ET2GahHbFUyTpydQtR75GE2f5ml0PQZwn9G/ha+ki2ybxg+AVVOibegb3KZArvN3O4/AjAJj+ylTyfqSMXbmQUEDeo9gd1zRH6l4y+Fof6MPs069ctrBUPuQcq716eErdyFKmEiintPKTaQceB2esKMJNLi0OAXufHc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2568.namprd10.prod.outlook.com (2603:10b6:a02:b1::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Mon, 14 Jun
 2021 19:39:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%6]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 19:39:43 +0000
Subject: Re: [PATCH 12/13] fstests: remove test group management code
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317282778.653489.13112698258806159936.stgit@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <fac2e9c2-4380-bd3b-07b1-9ab47e0c32d6@oracle.com>
Date:   Mon, 14 Jun 2021 12:39:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <162317282778.653489.13112698258806159936.stgit@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR13CA0086.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by SJ0PR13CA0086.namprd13.prod.outlook.com (2603:10b6:a03:2c4::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Mon, 14 Jun 2021 19:39:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81bcf658-2989-4efb-430d-08d92f6c2883
X-MS-TrafficTypeDiagnostic: BYAPR10MB2568:
X-Microsoft-Antispam-PRVS: <BYAPR10MB25687486B90D32C67F9F184995319@BYAPR10MB2568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:483;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OnmJENd6ElJLP1RBh+1vbqwg9Ys2/Es76UQpNTDfmtQv28dza5ed3pNzoOVgcnVJuPzPtv41MMCml8nreO2vuk/qs4/oBv7rBshWvC6t8Xa5NOwp4TT1vXzgufAhen0G7ViGemLx6OqsUrivBywoUqU5teqdveDplf1uOoqb2BROVuzf9jL0tLp3C93kC1KXPpRqTmjpzNev/Ok/cOh87Wm6bZOzsjpByiFYOKwbEz1bYOgBzwne+4liuSEMbyPY+ahbH3ctdgnZ74Lw7ufcK930Zup7y5lbWUYgHive9k10pcjL3nm9ud6EOpEwOIO7Tw271DNTy8py7Oiz1buwFNy33xS+/hD82qiapCmOCf48n5JN2YF83E+30lx5MyruraMA73w6g8kURro9ZTneodRa2mny0OA7+P/T5xnK2g5piAXImZ5yhXTz+bHHeQAFfJEssoowNtnFzEuu7UNEUZ9Pkjq+qyQffBguR7tu6+nQh0hrdHTORh1Y7/I81AZOfP85TbrWcSS0wz3o2aniVzk7Wgl0bHFyJDlsyIQfKYoQi6bPLwtIwPmjGb1RUaFx+FfNHO3yYDMOUudLEBZWOS9e5Cub6BlaM9M0ihpj6sXA9GNagBSgNB+DOC+zksV1aB9F8GEh3OcZ/Yg1w578BnEtb04oi1Che6A41jL1TIY+wUwTUQdY3wsgSYCBWkhKa1CJdC0ouboZ0mzbyw0DlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39860400002)(136003)(376002)(86362001)(36756003)(16576012)(316002)(52116002)(8936002)(478600001)(8676002)(83380400001)(31686004)(66556008)(66476007)(66946007)(31696002)(6486002)(4326008)(2906002)(5660300002)(186003)(16526019)(53546011)(956004)(38350700002)(26005)(2616005)(38100700002)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dU85YTQ5WjUrb2wyQThaSkN3UFMwVVBKVjFkbEk3ZXZFN0VobU1IbUdPWkVw?=
 =?utf-8?B?YXdBSklhT2lLNzUwN1FnUDlQeEJJQ1ErUE5ZaVlwd2l2TkRLMm5BdExPenU1?=
 =?utf-8?B?WkhiVHpJY09jcTU5bjNDYXRuaG4wWEx0ZnhmeDV3QmIwODRlSWRSZ1BxK2o4?=
 =?utf-8?B?Y254Sit0dFdVanJzblZuNkNQL2MwNlc3SXVDRkFMWVdRTWtuYjEwZzZBQzJi?=
 =?utf-8?B?ZlNDR1FGcGRtQnc4UiswWTRIQmVobTIyRUJxVFQzdGZqcGFjYkw0YVlDY214?=
 =?utf-8?B?OS95M051SFVsUThYb2dFeWRBUS93THRIYVg5WnFHb1Ixb0swYXRabmVjcGY3?=
 =?utf-8?B?OTJZdUJOaUJLbVVHb2tCUlhROEZWM3NEbWQ0SUJKMzhhTHloNDVvNjhrd0Ny?=
 =?utf-8?B?VSt6NjhWWnZGN0JBRU1aN2dKc0l2eHJSWDE0Q3Bta2VxbDZXeUJWcnVueVJR?=
 =?utf-8?B?eEozWVAyTE1SMWwvQndlQ2dacWNUV0x6S0F1VXZ3VldWL1hKczBlb2VaSFlw?=
 =?utf-8?B?Q2RabEpKWWl5NXBwRXBjRmNzL205K3EzMjhyOHJYMHhxWDUyWnhQNzJhMHlx?=
 =?utf-8?B?MEZ5aitUalZwaWNGOXA0cmJuaU53WlpINGRkcmM2SVhDdERvTmpqZ0sxekRF?=
 =?utf-8?B?b3RSdG42VklaK1NqNnoyL2hSdjBKZjNEWmZ5OUs5bWQxODRkNWQyNEtMR29p?=
 =?utf-8?B?RkN6bVh6YkZxTVl3WVpDMVRjVnh5Q3pqZTRJYkk3TmphbzU0Y1k2L2JHY0dQ?=
 =?utf-8?B?b1ZhQStCUzYyME1lZ3N4Rk1veXJKcGp2eG9TVzY0OCtxcDZtZEpYMzFPK1Vh?=
 =?utf-8?B?WDVvUmFFWmJ2V1B2L2FjWDhSQjlFb0dpMXBoMDE1bENUcnR3amlQWVNsTEx0?=
 =?utf-8?B?YWZuSHR2R0VXeStlTUtnSkFHdmtROWdLRUZ4YTVvY2RsRjFCWHdTL09sc2lw?=
 =?utf-8?B?b0s0VW03aHdRaHM5QldNYkVHNExPb2FWMTdNYXppb21LdEpOdDdJODNlOEJy?=
 =?utf-8?B?WWZ3M2JPY2FIeWNvY2pLc3FkMC9DMVYvYmxOU2NUNE92NnNIeDRLcWpONkEz?=
 =?utf-8?B?Zjl6dk1pbkptSEJ1bEh6NHlmdE9VOTRuY2orOUo4cmlBNkxCbDlPVmJWVTVs?=
 =?utf-8?B?NnczL2dXazlNdTRQT1ltSno0Z3JvRTdaNzNleW1rMUdxZW5KRkZPR21HSEpz?=
 =?utf-8?B?UzVFUzFpNHFHTDZTUTlES1V2VXRWRWtFK0pjaWM0NkVrQVI5NnR5UWNXckxk?=
 =?utf-8?B?VjFBRmkwaWdQOHNIek96Szl4RWVmcUlYZU5rTmdsdUx3Slo0UXhaOTFKSm1p?=
 =?utf-8?B?ejhjNndSOHdvc01xd1dXa2pVcjRrbjF5WEs0OG1TckZUbHlBWVEvcnZmUk9R?=
 =?utf-8?B?a1QzU2QyYTY2UnVRSUVYd2NTV0FMR1R0RXZvbG9vOEhhVllsTDVLb2w5blRv?=
 =?utf-8?B?RzJKNm1oMEl4QmZQRWwwSGNxbkJPVlVITjNGV3N4RVlFSlhYL0U3aDVteTAv?=
 =?utf-8?B?b3o4YTF3eDgzdFlMdlplSkJYRWFyak0xY2xYUmRkU01TQUtZTXFZNDNFeHV0?=
 =?utf-8?B?Y0lsOUpGWnJYcmNmUTYvTnowVXdYTXBHY3hIcGFxSG5Icis4ejFvc3d5S2NQ?=
 =?utf-8?B?Ujk0c0JmQWUyWXlOSG9PYmtVZENZdTFuYURwUVNLQ0NNZlJxakxCdUdiZW84?=
 =?utf-8?B?dkVoRlBKRlpUSkhvRFlhbThGcktzU1AwVkpOa1QycWlNREpkMm5iY01rbFVp?=
 =?utf-8?Q?x7uW44Dnzrvw+RGoJXPXi28tzs5gLnZ59AvTXY/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81bcf658-2989-4efb-430d-08d92f6c2883
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 19:39:43.3843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RUaskw1ztOos30LJPcEDiyVJvPqti75TjuXkWCksFffFPUy5S5CMsPsxCato2yR6AM3kzPdC9iNyY0teMDJ6w9ecWWgD8hdEa0SxLnXXHwQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2568
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10015 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106140123
X-Proofpoint-ORIG-GUID: rV-_Vl2pBRd93PLdniHIfPln06_htUKO
X-Proofpoint-GUID: rV-_Vl2pBRd93PLdniHIfPln06_htUKO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/8/21 10:20 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Remove all the code that manages group files, since we now generate
> them at build time.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Ok, looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   tools/mvtest     |   12 ------
>   tools/sort-group |  112 ------------------------------------------------------
>   2 files changed, 124 deletions(-)
>   delete mode 100755 tools/sort-group
> 
> 
> diff --git a/tools/mvtest b/tools/mvtest
> index 572ae14e..fa967832 100755
> --- a/tools/mvtest
> +++ b/tools/mvtest
> @@ -32,24 +32,12 @@ did="$(basename "${dest}")"
>   sgroup="$(basename "$(dirname "tests/${src}")")"
>   dgroup="$(basename "$(dirname "tests/${dest}")")"
>   
> -sgroupfile="tests/${sgroup}/group"
> -dgroupfile="tests/${dgroup}/group"
> -
>   git mv "tests/${src}" "tests/${dest}"
>   git mv "tests/${src}.out" "tests/${dest}.out"
>   sed -e "s/^# FS[[:space:]]*QA.*Test.*[0-9]\+$/# FS QA Test No. ${did}/g" -i "tests/${dest}"
>   sed -e "s/^QA output created by ${sid}$/QA output created by ${did}/g" -i "tests/${dest}.out"
>   sed -e "s/test-${sid}/test-${did}/g" -i "tests/${dest}.out"
>   
> -grpline="$(grep "^${sid} " "${sgroupfile}")"
> -newgrpline="$(echo "${grpline}" | sed -e "s/^${sid} /${did} /g")"
> -
> -sed -e "/^${sid} .*$/d" -i "${sgroupfile}"
> -cp "${dgroupfile}" "${dgroupfile}.new"
> -append "${dgroupfile}.new" "${newgrpline}"
> -"${dir}/sort-group" "${dgroupfile}.new"
> -mv "${dgroupfile}.new" "${dgroupfile}"
> -
>   echo "Moved \"${src}\" to \"${dest}\"."
>   
>   exit 0
> diff --git a/tools/sort-group b/tools/sort-group
> deleted file mode 100755
> index 6fcaad77..00000000
> --- a/tools/sort-group
> +++ /dev/null
> @@ -1,112 +0,0 @@
> -#!/usr/bin/env python
> -import sys
> -
> -# Sort a group list, carefully preserving comments.
> -
> -def xfstest_key(key):
> -	'''Extract the numeric part of a test name if possible.'''
> -	k = 0
> -
> -	assert type(key) == str
> -
> -	# No test number at all...
> -	if not key[0].isdigit():
> -		return key
> -
> -	# ...otherwise extract as much number as we can.
> -	for digit in key:
> -		if digit.isdigit():
> -			k = k * 10 + int(digit)
> -		else:
> -			return k
> -	return k
> -
> -def read_group(fd):
> -	'''Read the group list, carefully attaching comments to the next test.'''
> -	tests = {}
> -	comments = None
> -
> -	for line in fd:
> -		sline = line.strip()
> -		tokens = sline.split()
> -		if len(tokens) == 0 or tokens[0] == '#':
> -			if comments == None:
> -				comments = []
> -			comments.append(sline)
> -		else:
> -			tests[tokens[0]] = (comments, tokens[1:])
> -			comments = None
> -	return tests
> -
> -def sort_keys(keys):
> -	'''Separate keys into integer and non-integer tests.'''
> -	int_keys = []
> -	int_xkeys = []
> -	str_keys = []
> -
> -	# Sort keys into integer(ish) tests and other
> -	for key in keys:
> -		xkey = xfstest_key(key)
> -		if type(xkey) == int:
> -			int_keys.append(key)
> -			int_xkeys.append(xkey)
> -		else:
> -			str_keys.append(key)
> -	return (int_keys, int_xkeys, str_keys)
> -
> -def write_sorted(tests, fd):
> -	def dump_xkey(xkey):
> -		(comments, tokens) = tests[key]
> -		if comments:
> -			for c in comments:
> -				fd.write('%s\n' % c)
> -		fd.write('%s %s\n' % (key, ' '.join(tokens)))
> -	'''Print tests (and comments) in number order.'''
> -
> -	(int_keys, ignored, str_keys) = sort_keys(tests.keys())
> -	for key in sorted(int_keys, key = xfstest_key):
> -		dump_xkey(key)
> -	for key in sorted(str_keys):
> -		dump_xkey(key)
> -
> -def sort_main():
> -	if '--help' in sys.argv[1:]:
> -		print('Usage: %s groupfiles' % sys.argv[0])
> -		sys.exit(0)
> -
> -	for arg in sys.argv[1:]:
> -		with open(arg, 'r+') as fd:
> -			x = read_group(fd)
> -			fd.seek(0, 0)
> -			write_sorted(x, fd)
> -
> -def nextid_main():
> -	if '--help' in sys.argv[1:]:
> -		print('Usage: %s group[/startid] ' % sys.argv[0])
> -		sys.exit(0)
> -
> -	if len(sys.argv) != 2:
> -		print('Specify exactly one group name.')
> -		sys.exit(1)
> -
> -	c = sys.argv[1].split('/')
> -	if len(c) > 1:
> -		startid = int(c[1])
> -	else:
> -		startid = 1
> -	group = c[0]
> -
> -	with open('tests/%s/group' % group, 'r') as fd:
> -		x = read_group(fd)
> -		xkeys = {int(x) for x in sort_keys(x.keys())[1]}
> -
> -		xid = startid
> -		while xid in xkeys:
> -			xid += 1
> -		print('%s/%03d' % (group, xid))
> -
> -if __name__ == '__main__':
> -	if 'nextid' in sys.argv[0]:
> -		nextid_main()
> -	else:
> -		sort_main()
> 
