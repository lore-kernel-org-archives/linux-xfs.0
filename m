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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E35C49360
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 05:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CDF360BBB
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 05:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhFNFlB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 01:41:01 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41320 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229696AbhFNFlA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Jun 2021 01:41:00 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15E5aHQO008492;
        Mon, 14 Jun 2021 05:38:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=CQy4CDDCWvYjj0NnZpwf3uPUZ53sUycYBCJBrkJt+5s=;
 b=ty8kDxO30AZ7S3Ip2DsZ4TFPGPtomSgduf0XTEyQwEYPhFF/gUlKXagRpEITpQ/zs9TW
 03g9M4yetQU6k6G0b2sf/oD6oY5KNCLwAfRftusTGYSURVRk3bb26arTVLLeNxgZWVJj
 A3SmePabLHt/XCm9SOL66So7Y0B2+jSGIbxzJblfZDBj5DAT2csYoHVQqtTGdEv5jU2f
 37Xq4spBQmU8J9SJqBFcDVarVU1ldjwUgooKjE64u4KKCTu38VEjlZEB2X6syZpCYSHD
 4qy15B4sku2JfwRN/42c/mqkBJf9lWhNJJHCVB2056qMqrdY19n3EQlzuKYzURUserMS 8g== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 395nsar4xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 05:38:52 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15E5cp24030721;
        Mon, 14 Jun 2021 05:38:51 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by userp3020.oracle.com with ESMTP id 395hk1sdf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 05:38:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Or9DenxxOCU0IGDi6NripE/px+SD86mzUXbg4JDRY2wCPTjtgZF3LH4F4AdkBsp1cnb9oTQeeQM+AQCZi/mBgPNK6aGLlLcU1W36UASl35+ezgM50gmsU0iIRzudbHwWuOt2eioVdQDPAZgTwGlqloQMeSUm52fKeo+slodCG7gppjHl1w1w2eld/vszKjjfDsy4RGlINO0QyDFAxhTOwBItHdE8Nby0gQ+A66XGvaVr4EggzOK2DtIONi//kEtkY4VuUkMxOx+6dtyXY/YKd87rsNOIWRbiDPnRvnC6V86MTnBhh5/rhsGSQy9uvL5fTZ7+HrDfMfhUZnLIHPVZEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQy4CDDCWvYjj0NnZpwf3uPUZ53sUycYBCJBrkJt+5s=;
 b=MLWidyW7cbanucF5PQElSHfAT5ibDKx8+E3Bt45c5zzp/+R1HuHmaA6D96O1XobyXp+/s+jmyCHBoqptcit55SjObSqhrfehHs0Nmjg6anzhqoxw8GqaifbGAwP7+hoMsmWJ03S2+/urwBpr2dXGcQlb+Ey4iR5wbpy2cIA49DXWpRAF+5c8Fk2PvdvNI7WBOaRXqrWPiBmkrVZ0rafa05N3LdKSW/xvk3CsjYiy41MVQETxUkxDQsmQHZ0MEbUkrKwCHksNvLDGi6p//7Bi89Z/XLnj4LY32IovcCAg4zko3KdmodZE3dd1BN3KigbpGW0XpM66b3/zEfxeq9OM7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQy4CDDCWvYjj0NnZpwf3uPUZ53sUycYBCJBrkJt+5s=;
 b=ORSF6dF+QDnMtofUgiLJiqSny1OAitg/arp5f2CdkrBELsmZYjwaiKDgDQSbQ9+W7O09mHyKVeC2/H+kWMef7FsXy+I5es7ZT8vaYqzK8YNIpTV1uhyaqgj3cIXOfAM0kg0cjCif3YWyNLUiCKv5uOT+Lub2zIJ0Ybsnkr8Q2A4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2485.namprd10.prod.outlook.com (2603:10b6:a02:b2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Mon, 14 Jun
 2021 05:38:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%6]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 05:38:49 +0000
Subject: Re: [PATCH 08/13] fstests: convert nextid to use automatic group
 generation
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317280590.653489.10114638028601363399.stgit@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <13f77f99-f306-70f9-54f0-0b77a9c37ea0@oracle.com>
Date:   Sun, 13 Jun 2021 22:38:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <162317280590.653489.10114638028601363399.stgit@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR13CA0061.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::6) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by SJ0PR13CA0061.namprd13.prod.outlook.com (2603:10b6:a03:2c4::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Mon, 14 Jun 2021 05:38:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 792c0e42-f239-48e5-d5bd-08d92ef6af56
X-MS-TrafficTypeDiagnostic: BYAPR10MB2485:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2485BC655E6FA183CE16580495319@BYAPR10MB2485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ywteqtp62qEvYAwWaaCE8cLfNcV7zE8tjxU9xWPQqSyaQYGYZ0c610SShIc55Vppyb2LKJlFvSuxc7YISw3qnOftoe8QS/nGzYp+CSaNo7mJVYsLUXv9MkS5sqns0dbaosyt9OkvcZbeq3STvpUm8VYOBVQWreKtqls+qTRI091DXPyrPIkmieuL7r7nXLTvvGFWIf5KNa5LeB2VkS1uKgDREjP83+kqNDqWFWkNhsg2tSUolXvnJaSeoBEJ4KEvuSmuBNY46ffLFw1J3G2ju+47fo7cKUef3AfZ1TwUyXaZaoV1jMeWO45fgJzEKogMbt2sEwxlyMadDG+SQxrKQL33D3gyMrN0K4urGqlK+9eizLrtxIsC+FTNMiVhrEisxXvLuE54LiNaS1rlVO2/HSDOHEkVpjTXoKEdsYpxbzpKKS553uloMLXmpi+FTWyE0nGY/FaG9sNO3fUqQJkbSwmok58EJXEcHJ+oXXJfeMoYf76wTQvriXgwa5S8IwGdpgR/JMKv9Ua1tLjT89LM7GV2AVzh6CFaA+bDTbi7Tz3SqYOSNYllgGrfgmz8eGsqaIeHvhyr/wXC11cSluqiR1HivgnGnsCtHS5yUAOabIzRMZML3Bu1WdOq67JKd1Rthj0F+u6nzNochv8JbovAQk/XtCZjFBod8n7GWZ2wJ3qEG6RtiNm0/GKHJa4T0RowJfuLKlriGcCWwf48MpSCQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(346002)(366004)(39860400002)(186003)(16526019)(5660300002)(31686004)(83380400001)(8676002)(53546011)(44832011)(478600001)(2906002)(316002)(86362001)(8936002)(66946007)(4326008)(38100700002)(38350700002)(66556008)(52116002)(66476007)(956004)(31696002)(16576012)(26005)(6486002)(36756003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFNRbEVCZlZYVHE0OXpwZ2VLcFdOcjVmdUgrT0dQakhzVDdsNzkvYi9xQUJl?=
 =?utf-8?B?LytHUDlrVE9DOEE0b0UrSnBtZnYxZ2ZMWFlLSnRSSTloNVcwZ1ptR2RLM0Na?=
 =?utf-8?B?NTN6dG9KTGdadFI1dXNQSm4vaVZFTzFrWjZOcFJYbnVKN3I2bGtoa0d2c2Nr?=
 =?utf-8?B?ekkvcTU5ODVWVmdSRWVoYVlWSUxKQ3c0RGd5blFkZkFkTnlPVjNyOGJCMzBY?=
 =?utf-8?B?dlIyQjFpM3ZtcHowKzJGWFNvVFJzWmhQUXEwd09yTnRibm9Yek1iYmNKMnlr?=
 =?utf-8?B?a29FQVpaN25JSTBSNG1Ia2VmQXpLSURHUVpUSTZkQWNFSU9uWkxaalg1S3Ev?=
 =?utf-8?B?VDNUb29OdGttdThiQ294ejQrbisyWXo1dDJoWnJMcytnTCsrOWdBdzFObnZp?=
 =?utf-8?B?dHBTZFljOC82d3hJS3ZPWUdGQVVMOHJVRnNBTFROVVYrNDd0Wmd5TER6SDVo?=
 =?utf-8?B?RzhlNFgzNzNiRk9lc2wwSS82OFRlUmI4NnhDQkloOWhPK1F5YTQrZHVkczdB?=
 =?utf-8?B?R3ZyUzRqWlAzSzdWeW0xT1Z4T2hzMSs4TW9BcVE3SkpxT0tESVpmZ2QvT1Qx?=
 =?utf-8?B?QjBwcmlKaVk4djF1dU41NkZaRHVvaCt2NTFoaU4vSVRYUGE4dEZQbUE2L000?=
 =?utf-8?B?YjNhdFk3QVpWY3JlSzc4dU9IcUpmUVhLS1l2S0VYUFFqUENTbWdmMVdkVGZp?=
 =?utf-8?B?cEZKSkl1c1d0eUdhOFNGOGlMeHd1byswNENrc1k5MytuNk54Z3dpS09PTjFy?=
 =?utf-8?B?bHhkZXN4UlBNdEQ4aFdiQnl2TGxGdzVoUWVVam4vbXJLQjRTMVFvRXlLa29i?=
 =?utf-8?B?VnQrbTBaaXNWY2RSNkJSUlJ3TC8vQlZONzB1N2czWDcrRDVIdU1vZklZbnBu?=
 =?utf-8?B?Q1FVTVNGNjRVdTRHOUVXRGM0YXAwL04wMUFHNXZ5MnpSZllxOU5YWU5MUWFB?=
 =?utf-8?B?SDR6ZnNqQW8xR0FFR3FxRE5TVkp3WFBwUDh4NEhwSWhlSzJud1U4WStrUjRN?=
 =?utf-8?B?QzZGaUtnUEN6VHJabWhkZDVqOXhyYVd4cmtqQmRoZ2x0Qm5lME5QakdnM054?=
 =?utf-8?B?TVU5bHEza0Jra3BwSmszL1BqZzNLcS8veEIwdnN1MFFCUTdhV3N2cWp4cktG?=
 =?utf-8?B?c0VWR2hjUC9EdFFoZDk1MkpEMk5xTjNVTnZYMTdrbnU2RmxzakxsTFBpSEZD?=
 =?utf-8?B?M21iQXRGK2o1OTQ2MGFDTExud2pDd2kvKzh2cENTKzRpTEpkMUVTVmpWVm0w?=
 =?utf-8?B?YmtCYVZYZUVVeUFkREtaMHQvR1Rkc0dQVzFPVVpEVkJGdjhLUURuNVY4N2Mw?=
 =?utf-8?B?dFRMWndXaFFBL0c3SWhGZjgyTzVIQTJKSTYyaDQwNXliZDF1Qkt5RHNCaEp0?=
 =?utf-8?B?NitidmNqZU5SLzdLSlNyUHFLWitIcnY4ZEpseVYwOC9zUEFZbVQ0eVdJOGNV?=
 =?utf-8?B?NTRRb2pvaDBjRUtOQzhoL0IrRS9kYUY4U0dkQU9iOUtWdDdROEgzOUtuMEZP?=
 =?utf-8?B?WEcyRmJmdmIraVN3UE4rN2c5RE0xNWJyOWRva1JHNDRwaktlZFA1ZHJ4b3dE?=
 =?utf-8?B?SXkvN3lXWXVUNDFBYjc0UmIvd1V1VzluSnlyQXdMQnBCajRsekIvSVJ0YkZw?=
 =?utf-8?B?bWxXTytZQStSbWZwdkNRbGVXSGlRQ080MWkva3FNU0JwQXhZRmwzY3RVWFd0?=
 =?utf-8?B?NjdYK3B2bWZMVU50ZmYzdlBXS3pqZmVuZ2JxT1Z0dXNkelUyRy91cXR2aEts?=
 =?utf-8?Q?iE6zBYFcgPpT//MWP20TAIPDq5L8T/jZv9CAB1C?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 792c0e42-f239-48e5-d5bd-08d92ef6af56
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 05:38:48.9675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5oA5YjlDGs0dpxoToa6x2M9QQtAg5Y7xwLf4L4Fd0aJlq09gi5dDuLHCvqtFudPF6pBNY0rQ2WnRxDLgaUu8mTc+FCcNSB7YyClYbDriqsc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10014 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106140041
X-Proofpoint-GUID: jq5XLt_TWCV70DXvByjGj3TCyfu3cAkw
X-Proofpoint-ORIG-GUID: jq5XLt_TWCV70DXvByjGj3TCyfu3cAkw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/8/21 10:20 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Convert the nextid script to use the automatic group file generation to
> figure out the next available test id.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
With other review nits addressed
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   tools/nextid |    1 -
>   tools/nextid |   39 +++++++++++++++++++++++++++++++++++++++
>   2 files changed, 39 insertions(+), 1 deletion(-)
>   delete mode 120000 tools/nextid
>   create mode 100755 tools/nextid
> 
> 
> diff --git a/tools/nextid b/tools/nextid
> deleted file mode 120000
> index 5c31d602..00000000
> --- a/tools/nextid
> +++ /dev/null
> @@ -1 +0,0 @@
> -sort-group
> \ No newline at end of file
> diff --git a/tools/nextid b/tools/nextid
> new file mode 100755
> index 00000000..a65348e8
> --- /dev/null
> +++ b/tools/nextid
> @@ -0,0 +1,39 @@
> +#!/bin/bash
> +
> +# Compute the next available test id in a given test directory.
> +
> +if [ -z "$1" ] || [ "$1" = "--help" ] || [ -n "$2" ] || [ ! -d "tests/$1/" ]; then
> +	echo "Usage: $0 test_dir"
> +	exit 1
> +fi
> +
> +. ./common/test_names
> +
> +line=0
> +i=0
> +eof=1
> +
> +while read found other_junk;
> +do
> +	line=$((line+1))
> +	if [ -z "$found" ] || [ "$found" == "#" ]; then
> +		continue
> +	elif ! echo "$found" | grep -q "^$VALID_TEST_NAME$"; then
> +		# this one is for tests not named by a number
> +		continue
> +	fi
> +	i=$((i+1))
> +	id=`printf "%03d" $i`
> +	if [ "$id" != "$found" ]; then
> +		eof=0
> +		break
> +	fi
> +done < <(cd "tests/$1/" ; ../../tools/mkgroupfile | tr - ' ')
> +
> +if [ $eof -eq 1 ]; then
> +   line=$((line+1))
> +   i=$((i+1))
> +   id=`printf "%03d" $i`
> +fi
> +
> +echo "$1/$id"
> 
