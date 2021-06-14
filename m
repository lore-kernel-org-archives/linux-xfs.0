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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E51C48BE6
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 19:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6BF961246
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 19:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbhFNTl7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 15:41:59 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1678 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234280AbhFNTl6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Jun 2021 15:41:58 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15EJWEWP002808;
        Mon, 14 Jun 2021 19:39:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4w/UlsikRsSW9Vpa6kyTqvTFxXNW/zFrRD8O+rQFeEU=;
 b=ZTsYEhXwvSk50WGCZDsgVu9DPilCqOYK4prXHaY03ZvQB4lYN3HRHBZDb0qulR0NE5qQ
 DnVDoj8ZMIr3M6OjFFn6AT/B3223p0NcXLX1zzmNxEwd2ooVCmZ/lwbeh+fM6mb3n7Pw
 ChBRSqPgBg1k10r9ESQ3kBoDQe2aVX8JZ28AlANvA0IAqmOY6LsMll1zoqWp4mgP5dQF
 lNtLZab3pRue7uF4+4814tDGGKiYAz/o+1SA89w+M/i0SFC+zzS5VZDZCQagn25GvaHu
 TxmAc3e9MWUIDXOhbTYRBrG166DKP9D4RnKMbfXIfIt6koDEOCNlgInJld88UsWgDA/K kA== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 395x06g9v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 19:39:52 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15EJWJXu156717;
        Mon, 14 Jun 2021 19:39:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3030.oracle.com with ESMTP id 394j1tgrdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 19:39:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KsNTztcjxhYxR8fBZyK+SyN1r7HWe/2MCfw1JjiyGcvgEUXRQzDMT+1KerhNVrhaV9T8zRKVIR4vKrQV1cnqqefwb898JBh52rfue4MU00WP5GAqOIZNknOuy8cRfXeBBymL+K+GplWWj2GZ6Ja7gCUw2+xVGGuZv36IbaqtTwrGRgELr8QtuokNJbVJFoq+Hgt1roOFO/mTHCSevl6qQxH0i+kTeu+RFTPaOZv2gC6tN37c/qUkxXX6/AjUZ7fLk6OtrINUBXz8Byh0MVs//MkFlzxsZ+fMQuxk3nO+ApAS6AtZuqYf5YsFICr+klpTkk5qFVZ2nkxq6jMoLEgxog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4w/UlsikRsSW9Vpa6kyTqvTFxXNW/zFrRD8O+rQFeEU=;
 b=dFHGGzaYMGxHp23GXQg4Sbr5Z8tgFhR3v7nTOOrBZqUlV/GJdmbuV3Yz4KJCxhYqCST8RHkSQnU86q4mJ/9cM5TzzFzR3biFhcE3gldnBStbHwf5eYZzHnrLsUr4GisJP6Zw1nklOVES+r6p/ZRnqagyl0T6kMCAwClrEbHABeWwCb+X3Nni1tQRemYXzAVJEh36dValXZGD4fLeOHfRxPaaBSLpOf+rBhxgm30Sv/02SV5QPPoAjGXIkb5pr23os0qziMzaPj3FjeBT6kkXybtApDDsXzZI8SsrH9bQfSFRD/ApLafLP3QpQjC+8wnAS21AIXT6DZrydI76CYmfnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4w/UlsikRsSW9Vpa6kyTqvTFxXNW/zFrRD8O+rQFeEU=;
 b=lewtlHfQPHuP74edtLZZ2NlBw60wJYK89T76FFtyg8+42VQ8lq/0mqSJKuQ3+ume8Gm6pJv7j32n+zMgRvcFO1GqmNmhwuI4k2pq/a6dmAtwo6jCu52E/QatxW0JFfoJr7qrdCWbr5yzlirG/EBhAHPqGt5Em89ajUPCqdJV5f4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2568.namprd10.prod.outlook.com (2603:10b6:a02:b1::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Mon, 14 Jun
 2021 19:39:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%6]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 19:39:48 +0000
Subject: Re: [PATCH 13/13] misc: update documentation to reflect
 auto-generated group files
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317283324.653489.9381968524443830077.stgit@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <6638e618-3d97-a403-311c-941de3db6320@oracle.com>
Date:   Mon, 14 Jun 2021 12:39:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <162317283324.653489.9381968524443830077.stgit@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR13CA0090.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by SJ0PR13CA0090.namprd13.prod.outlook.com (2603:10b6:a03:2c4::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Mon, 14 Jun 2021 19:39:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 180e9f8c-8575-49f8-a3b8-08d92f6c2bc3
X-MS-TrafficTypeDiagnostic: BYAPR10MB2568:
X-Microsoft-Antispam-PRVS: <BYAPR10MB256834A02897B61AD42D2AE195319@BYAPR10MB2568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:568;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q1RL4gQG+HJwcVyP5tJ5PKbTxScXa4NbIH/KfvBIIK/YfEgdcXyMhc0ylyVKfZHP0aGav3niRTBpNU1F7x98inBOk7qtlYoAJVYUmCurHqf6i+kqSCTUOyPgLooUuGOc/YPADNqGOWkvL2CQEaZ6gM5DbemLxeAxIAfLRqhq0c7m9VSNIgMsUD5seET/95XlhswFCZ7DUcSrCmx6hD64IJDhJFlIOqZsHmWy4ZwQxvSruxvXt8LWOZsr21hmRfJBEteKGXIzvRr0aZCYxt1y+zA4a/Y55L2beXEcHESBPEwejY9Up9GfeUexrbqlfvlGH5eaQk2cyslCkNoYIbWf8ujvWoJs4lgvBp8p63pSZNXUwlCteMB7cuw7bTkvnsEZ9kY6rsNfQsvUqVJNbhCWpJzZUbKGWcjZ8XXa35ElJJG2Ud6YzVrgEG80S+pgejFxhOGh1J1FFZz6tmIm8KFPGfpl5dxg2ET4/5O/L2d08v1obRb5lT4wThKTQg+c2dHYToqRWcNxIiWkSXc9q2zX8NVh//eRZ4zNjrFGFgVdKBImj3VV6bv3DY3SM3/eMMp1IgdHJ1La9bQzZqtCSArwjYhy7Pzr4brcqah6x1ln9ZstGQT31KCStS18YrE3gFdYt+MqOUhuHMmNTwBZWRm+OZB7p5yqi+djLME+J5Hwg7/kTUcQ9kfLfjIzi22IJHSkoPA9lIHW4QZFQuT+tAj7gA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39860400002)(136003)(376002)(86362001)(36756003)(16576012)(316002)(52116002)(8936002)(478600001)(8676002)(83380400001)(31686004)(66556008)(66476007)(66946007)(31696002)(6486002)(4326008)(2906002)(5660300002)(15650500001)(186003)(16526019)(53546011)(956004)(38350700002)(26005)(2616005)(38100700002)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFMvMk5Udk9FVDBIZlB2OGRnRzM3M0V5U3ZyWnZPTmt2VnpCM3JzYUsweTVP?=
 =?utf-8?B?Wlg0cVh5VkRtUlhVcnZvd0xNRy9IcmpaTFphVVhOcmJNT3BGS0EzSHc4dlJ0?=
 =?utf-8?B?ZnBRZ09XTFpaWEV1QWtFRml4SU9tem5heHcySDdVUGtPUGlqUDI4OFh1QzFO?=
 =?utf-8?B?YW4vQzBJWG1zVG1uUURWaG9jL2VpUGdVNzhDcXlXM2d2ZlUxbzJsSXdlOFEr?=
 =?utf-8?B?N1NFekxxblkvU3hDd1kvbkIvczNLZGc1QXRDMVc3OXpRSCt0NEN2RWtyWTRr?=
 =?utf-8?B?cVN5OEFqQ1FoZC8wRldURXNOYk1qWDFKRk05R0gydzdpU1dNN0JzejZ2dnBK?=
 =?utf-8?B?QjVYcHMrR0NTdDVpY2p2QVJJODZaMzBtc004V3JXOGQzYzAxa09pdkgvN3Yw?=
 =?utf-8?B?SDN6YkdNd3h0S2hiWUFKbkRPSFFnUTRmaG5wQ1A1N2dQL2xEOHNyL3BMc0dT?=
 =?utf-8?B?aDdrRjh5cGV6VUt2TW9RMXlzYkdjS1dpaVhhZ25mNWpydUFQZi9LWHRLVi94?=
 =?utf-8?B?SFcrQjJpb2Y0d1ptOXAvUlV5ZHB6Zm9ocFNsZlVFTWx6QTlpWTlXblVaTVF1?=
 =?utf-8?B?Qnh0Mm1pWmp1bkYwTjU4TzBzdGlzcEJ5V25VQ213bG5DWGFTR1VXYTc5Sng5?=
 =?utf-8?B?UTQ5QnhDYy9aTG5FZjlZaDhlRS9NM1M5Mk5DQisySUN6WnhrRVFkR1ViVDVW?=
 =?utf-8?B?K05nMVRGL2J1Z1pIYnF4SnBKeGFWdHFiWXRQTmViTkxWR3kxRkNuQ0twWUFu?=
 =?utf-8?B?TVhaZWhDOUViT29KRTJrNGFFSFdyaVB1R0xBcDRmeVVkS2VPb0F1dmZ3dmxh?=
 =?utf-8?B?T3llMGs1UkErZE9aM0k3OUNBVGVlMGJvdG5FQ3IzUnBWUVdDR2UzemFuYW5t?=
 =?utf-8?B?MDNuMG9aZk9CQUw0UkgzaFdibDdIVHdNN1dPdlkySzVBRlNha05zU0Ezcysr?=
 =?utf-8?B?MndJTTlpT2FoWXNhM3Mza1pQUDVaSU1nNjVuSTJxOW1QMFhkUU5GWTd2RkdG?=
 =?utf-8?B?RURtdWNKcUU0K2ZnMmY1M3ZJTDVaOWdacXA2YkRzQW5QWmNreE1lVHNBMTF0?=
 =?utf-8?B?bkRIUW82VHZkS1BnUVN3OEpzenRRZ1N0blRnc3ZMZEhyemVQVm5wdWFyL1lt?=
 =?utf-8?B?MFhqSzJ2ZkVkeWtKQ2twS3lTWmd1T3NnYnI0VHpocElNNCttQWtsbExqTnZT?=
 =?utf-8?B?NjNuYnZEVGFDeS9zcyt1NjlCZmwzYkpDZWxIYjhUdk1ZekRiRjVJdUhOcHZY?=
 =?utf-8?B?VW9ncWdGNjVLUDhBSDY5NUg1Umpaa0U0SGFZVFltdkRlM0psOW1aWElXcDQy?=
 =?utf-8?B?MVVVQ0NVK0p1NjBnWnB6SWczd3lCVDJDazlqVEVaNUhEdVBvT0Z6STNrYmkz?=
 =?utf-8?B?SW85YVVKcnI5Z3RMZFl4TVZpSjR1QVBlbWdkcXpucGpJMkI1dW1wYytqZnFJ?=
 =?utf-8?B?cXU1OUFNLzRJVFZldzVUbTRZRzlCWWxXMmQ4YTVaWjEvTVJOdTVWbU4rSFpS?=
 =?utf-8?B?ZFF3ODlTcG42alJBUWZneDd6UHNqYmFrQUVRZ1JpWDgwSERLa0Q0NnlzbUVV?=
 =?utf-8?B?N3doak1wWG1LQThxY1NEemlGTlU5aEEycjhxeEg0ZWtvaUxNdy9zbUduZ0Ry?=
 =?utf-8?B?ajFMR05nNHQyenhqMS90NWV4cWZDbTdpNkcyOGVIaS9jN3dqMTdPWEVPV1BY?=
 =?utf-8?B?M3p6MXVSd1pxR0d5aVdHSGZlbWJuS2FNWDBIVmVoWWJyMVQ1a1prMVRQVlBl?=
 =?utf-8?Q?qFtQotd6w33g7m8WwBzCzRgaXXeReMf1E6y2jd2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 180e9f8c-8575-49f8-a3b8-08d92f6c2bc3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 19:39:48.8692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WiCDf7XJd1v22KfnY4kbQM98GmwaBvb5sAXd3sS5HiCDG9K+cVmndUhXGdGBaZPXV+7JiDXfO756LHqUiUbz5jQ3xlXHiW3HEnBeSpaPLEQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2568
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10015 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106140123
X-Proofpoint-ORIG-GUID: jonFHye37h7bH4ZaGlnws_2sANFuefQd
X-Proofpoint-GUID: jonFHye37h7bH4ZaGlnws_2sANFuefQd
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/8/21 10:20 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Update the documentation to outline the new requirements for test files
> so that we can generate group files during build.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Ok, that sounds about right
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   README |   19 ++++++++++++++++---
>   1 file changed, 16 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/README b/README
> index 048491a6..ab298ca9 100644
> --- a/README
> +++ b/README
> @@ -140,7 +140,8 @@ Running tests:
>       - ./check '*/001' '*/002' '*/003'
>       - ./check '*/06?'
>       - Groups of tests maybe ran by: ./check -g [group(s)]
> -      See the 'group' file for details on groups
> +      See the tests/*/group.list files after building xfstests to learn about
> +      each test's group memberships.
>       - If you want to run all tests regardless of what group they are in
>         (including dangerous tests), use the "all" group: ./check -g all
>       - To randomize test order: ./check -r [test(s)]
> @@ -174,8 +175,8 @@ Test script environment:
>   
>       When developing a new test script keep the following things in
>       mind.  All of the environment variables and shell procedures are
> -    available to the script once the "common/rc" file has been
> -    sourced.
> +    available to the script once the "common/preamble" file has been
> +    sourced and the "_begin_fstest" function has been called.
>   
>        1. The tests are run from an arbitrary directory.  If you want to
>   	do operations on an XFS filesystem (good idea, eh?), then do
> @@ -249,6 +250,18 @@ Test script environment:
>   	  in the ./new script. It can contain only alphanumeric characters
>   	  and dash. Note the "NNN-" part is added automatically.
>   
> +     6. Test group membership: Each test can be associated with any number
> +	of groups for convenient selection of subsets of tests.  Test names
> +	can be any sequence of non-whitespace characters.  Test authors
> +	associate a test with groups by passing the names of those groups as
> +	arguments to the _begin_fstest function:
> +
> +	_begin_fstest auto quick subvol snapshot
> +
> +	The build process scans test files for _begin_fstest invocations and
> +	compiles the group list from that information.  In other words, test
> +	files must call _begin_fstest or they will not be run.
> +
>   Verified output:
>   
>       Each test script has a name, e.g. 007, and an associated
> 
