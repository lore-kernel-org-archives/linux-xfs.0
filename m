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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0BA0C48BE8
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 05:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B55A260BBB
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 05:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhFNFlB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 01:41:01 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41940 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231939AbhFNFlB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Jun 2021 01:41:01 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15E5br4v029290;
        Mon, 14 Jun 2021 05:38:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=nNAR/y9j9U/9DZv3809gZ7f4l3sVieMNOPSeUXJFQFU=;
 b=vVf7t5GrZ57wT89Y7k9tMwfV+8SN1nb02NpQWixNV51FbL1pxceVcjYJtc3FVGhfORFm
 Ji60jQnTclSBjpwjd9Omaw8Ryo5Tub/9BAfWy0XRe5ojXLswpeuyae88W5U7dVCH4xrA
 nruzXFom3wZDtOqemdxJgHAWJFy/5V6GC5cLePT/Wau8J3H3DiEF/ZxD5qOu9GD849Mz
 2UdSH8Xpp5f6hES0w8M0E8BdO8YOX6/qkCfRR5tuvX2Gjedl1OsPftCkuJBJq+uLccPG
 pMRR5E8za+VgWxkXsQrq6+GQOOW6j8S+lvhqWbgQpnULXhpn6/qHqwSVfJqqUTs7DGi4 KA== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 395t6ug33j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 05:38:54 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15E5cIYB157841;
        Mon, 14 Jun 2021 05:38:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3030.oracle.com with ESMTP id 394j1spf8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 05:38:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gzkNHC2qfG1gDS3D0SvJmBym69ssYYwsnY8xR4pRUvGB5Gly68uNJp3S8WtrFuKBJ35CNNMTNKGH1HvqXrwjmKAkndf+GkThhnGa5RWMpqP7sm0onNpEXl0T2Qy8MLvklQjrQUS7d09ckHbpODqLTnZxeyIGRVluYyrHNsCfcqLgFLngFLQEYhYp7PUwfgJ2e1d0E6u6PZcKHwUt5x/3gkt2A5LCcepDR+eXPZAOSFi5K+wXPkhBliuksAvPM6ZFS8C4msZEnShaZ2PHcL3F0BLSLX4Br7POVo+8vYmAL4OYxGUd3Lcb2yjdFVfCuRB5fzCUWyBrLUzGoh19+G1mIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNAR/y9j9U/9DZv3809gZ7f4l3sVieMNOPSeUXJFQFU=;
 b=Ws5RxGHbs1u2LgKDZhRQdO2P8t8h8fk0uRXLLYDE0TlE01njpke+FAZSWy+GrFraqzZA5biGWQm9Gy1n2guKJSuvehynN9ye+WITLr8QdxtdivdBGIA68o7RB2C8cyMUm/e0HxrdaP0kNS15hWKOYbPeziLlPXLqUM2YHIeij4wlh6Cq5QQge3AG2Wcpcw/v2k+amTHXdi1GEomVUEt3++NYqYDjbry/Dy4gLLNMuyaSKAZtM5aRVryhL3a2iRmcvmUyUMcZeoI/6y4Qhd/fFezNhKcFZL/T0ABbLzPI48t7SLHLDTzD5OftDXIQ4bxMqjffN4dsO6YT3jvvrGBfcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNAR/y9j9U/9DZv3809gZ7f4l3sVieMNOPSeUXJFQFU=;
 b=YHNWnqkYbYnpwB3WHSxyHJFig4ib3hFvNb7+Ez1f8mJLZPZRna5EyMC5ABRB4bMG2p47vzwNuakTChFPCte0D4Sk5wok3zccEq5jMDsDSNzh7GTYLoKGbWWCPlf+i9A5ew7++OzffQzrXuvbJ3QqFvaDTBaNd8+/2krNqR1O9cI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2485.namprd10.prod.outlook.com (2603:10b6:a02:b2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Mon, 14 Jun
 2021 05:38:51 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%6]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 05:38:51 +0000
Subject: Re: [PATCH 09/13] fstests: adapt the new test script to our new group
 tagging scheme
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317281137.653489.16228043613270527911.stgit@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <aa5d4ffe-7409-147d-4cc1-0975f926a8b7@oracle.com>
Date:   Sun, 13 Jun 2021 22:38:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <162317281137.653489.16228043613270527911.stgit@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR13CA0076.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by SJ0PR13CA0076.namprd13.prod.outlook.com (2603:10b6:a03:2c4::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Mon, 14 Jun 2021 05:38:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ea1cd4c-0a26-47e5-6c68-08d92ef6b0d1
X-MS-TrafficTypeDiagnostic: BYAPR10MB2485:
X-Microsoft-Antispam-PRVS: <BYAPR10MB248558704ED064895108619995319@BYAPR10MB2485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:129;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eLxG9XZWd3U63aqupzeLZZlft7R83dKW44Z/EUezK4yR78hcK+RjnEVJBfMQDLb5DDlKfEYOXIA148kVx6n9A2FIg52puWGu5PvHBYCUcqYRHQy+pOcdPpdzrG28kzzZ2PAOvOPrWYvZUtxMeDBGaBg5ErTY4Qlx8gDWIu3YckQ6wnywOWILYjYFTQ4gb7QhwhUbl2Fd6KAVSFrRwhp54YhT8wWTtxME9WzYarZUlZl7ZkoBziEtYS0YkbU8Ag2K3ivzGPJ77jVi6kUckj9FNcQv5Cqe66QgSSfjVyEqATGaZWhFWYCx7eDgt5+boH88SDoMuvuGF5Llyy+h1injHuMzZNn3H4qGh7r+57caDM46AeVV8MJLKjlzP2Zg/iiJYOZGwetLMlefAZG+B/Eszj4TpL5rKRfmfnvy5MzGz25aKPp9j0KUVUqbVY94IWAaDiL+KsRP0XlxZWdNJWENN1JMHWEyWzz1gEnFseVAR9ZJVstXcBhojkJ/sL/Es2DUP+aqfPHvntr8lwJyxGDiSdoFl6QAH5hbK24X6bnLBEDVZfqvKGDw897z+adrtErAbSkkOjNU7sIes18LP8yHUk57k79zgK7wydjZRqKteQjYw8473MP7CLdNRDPlWV3qqOdb4BTv/h++6Elgx/IHp/UyTHov5h3h8SqSTpkIct0V4ccCEcvTamJsm2iRwvN7Cz7y5t0KF21PGtZD7Kbnlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(346002)(366004)(39860400002)(186003)(16526019)(5660300002)(31686004)(83380400001)(8676002)(53546011)(44832011)(478600001)(2906002)(316002)(86362001)(8936002)(66946007)(4326008)(38100700002)(38350700002)(66556008)(52116002)(66476007)(956004)(31696002)(16576012)(26005)(6486002)(36756003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QkFTRVEyOFVTUmxsbnVOc25pUEtRc3Z2U09pcy9hVkFGRUFobEpuWCtXOG5D?=
 =?utf-8?B?OVV1ekU4QU5aMElSMjFlcVU5M3RGdEszKzBVcGtmTlN6c0UwdXpEWGJ3L1d1?=
 =?utf-8?B?cUpWejZvNlZPcVlSZ0hleFMwL1IxOExEcE1OY2NrWWNHTG1YZ083ZlZmWWZt?=
 =?utf-8?B?aXVmcktxWlExMjNoK0t6bE5DaFplemdsS3FKWHFLa0U0cVJlV1BhWExaa0dn?=
 =?utf-8?B?OWl1Y0dHdDdnUElLbTdlRjYzd01KZm9ZcFZKU3hla0ZjdjRKTldvSU5INHVl?=
 =?utf-8?B?SWtZM0k0WjJHUVAycWtmU0U5d3d2RWQvUzBpM1Q0ak42SEt3MmRGd0FBU2tD?=
 =?utf-8?B?UFJBWEtCRjd6cDdtUFdoTHFaZHVjQkR6RUZDSUlHWUdvTzFKeGp0cDg0RW5W?=
 =?utf-8?B?QjNOaHhTYUlhVjZMN2M2NDhQV1gyeGZrTStkL3ZyL0l5V1ZZOUkvSm9GdUVH?=
 =?utf-8?B?S2c0Y2ViUGFHeGg4a0Y0MTg3RDZmcm96UGpoOWRUN1p1azZzTGZNbkhGMWdp?=
 =?utf-8?B?cllYY2RaYktmcTRxTlB2bkpOUytENEk4QWVlam9Cd3YwR2JkZWpVbi92d2R3?=
 =?utf-8?B?aUxNT1dHMkR3NnNwVXRqSW1jMFRETFlXc0c0RzQzUmRzQjY5b1pBcVI5aTlU?=
 =?utf-8?B?YmJINDBIRVNadW5zR2xqQ1NSb1ZnTFkrOUoyUHhQT2VSK29uMjZwNnJpZVVP?=
 =?utf-8?B?MlJoeUNmNVp2UjA5dVNJVlFzL09RblM2OUxHekU1V3ZzOThaa0c3WlNYaGdF?=
 =?utf-8?B?MFdVeG9ZQ2pMOTd1dmNpdFJoTllSVVJtN2Z2L0VSMjZHTHJ5T1p3U04yNUVK?=
 =?utf-8?B?WlJTUkJ5NVpHeHl2MmxOY0xoUXd1M09NMmczSklkWjJ5dHdoZFc1Y214ZENp?=
 =?utf-8?B?aTdsMlV4MU9UbXU2bWNJSGpaVmtWWGhpVHYxbVJqRDlmM0JXV1J2MCtEd2sz?=
 =?utf-8?B?SFcrNFNhdGU5VTI0QUtzeEJBR0RYditjZWZxWTZvdGh5UlREcUQ2S0hnZU1M?=
 =?utf-8?B?MEg5VHlycWRsL04vMDdHZ2xZUE9Pc0lSK2NsRkJCejZrRW9jVHArNEFYT2xK?=
 =?utf-8?B?SkNHaUhBUVRkT0RnbGZlSDBjM0xJUW5pemVRQzczNlh1Wk96N1FVbm82RWVz?=
 =?utf-8?B?anRhOWhLTTRKbUQvZHRSVzdPUEV3Q2RqVDgwYjZVcnA4UG40T0FVc1pmV2Fz?=
 =?utf-8?B?V09MZ0hTR2x5V3FHSFRxS2dHQy9LOFp6dE04VUtvdHB6MnFCNTRLRXNwR3dm?=
 =?utf-8?B?Z2JJRkJYRGZLRGNlVzNaUUVERGQyZENGbTVuVjZmM3lDR0MvQ2VHVFJ6UDlS?=
 =?utf-8?B?eG50NUluRXN3endadFN4YWM3L1ArZ0l6aU1xc0NKY0x2YzdJdnRLSG5xTnhv?=
 =?utf-8?B?ZG10cmJ6M3Q4V0R5WmoxcXNEeURCRzg1NWNoYkRScTJTNGlVaWRsbUJxdjlK?=
 =?utf-8?B?ZmpKVFBvQWhWdUNTOHNwUTZtWjU3R3ZZVkVoazJrZ3NsV1g5eFJJSmJJUXkz?=
 =?utf-8?B?Q3RPYjIzblJ6WVpNQm44ZmRBNCs0S3B5OXNyWEoxSU9CZFhSaXJ0VDFKS3Z0?=
 =?utf-8?B?YVZnempWT0FKTDB3Y2d6ZmR1a09rVXJtVDgrV2ZPQ2dWTnZYTlBRdGtDWUhj?=
 =?utf-8?B?OGZtYVJSMVNBeExobDRPVEVwZFo4MTJpdFZqR2VUN0FKalVRYlZWOG1zaEF4?=
 =?utf-8?B?Nk9HOGtsMEM2eUk4NWJ5Z2E1WmZrenMwS1R1V2t6ZGhuZmJJRjdTSUZNWEFC?=
 =?utf-8?Q?OyL+JU1g4wSOgVHs3KOCatWvsmpsHOGrSfzxZPd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ea1cd4c-0a26-47e5-6c68-08d92ef6b0d1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 05:38:51.4456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QbW4d9RdEkroe5WrgLkRJMxcsuNzOnk5iT3/8ow30Y1icrT0K3eXGGZbPnqxd4Z16Km+b96NfPVcW+OtNnK9EV46Kmm1vIi1uauwzCVMh/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10014 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106140041
X-Proofpoint-ORIG-GUID: 11TDyVg7AH23O8PPTHWNPoJMy8lvAJU7
X-Proofpoint-GUID: 11TDyVg7AH23O8PPTHWNPoJMy8lvAJU7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/8/21 10:20 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we autogenerate group files, adapt the new test creation script
> to use autogenerated group files and to set the group data in the new
> test.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Other than the sed nit, looks ok to me
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   new |  179 ++++++++++++++++++++-----------------------------------------------
>   1 file changed, 54 insertions(+), 125 deletions(-)
> 
> 
> diff --git a/new b/new
> index 16e7c782..cdd909ad 100755
> --- a/new
> +++ b/new
> @@ -9,7 +9,8 @@
>   iam=new
>   . ./common/test_names
>   
> -trap "rm -f /tmp/$$.; exit" 0 1 2 3 15
> +tmpfile="/tmp/$$."
> +trap "rm -f $tmpfile; exit" 0 1 2 3 15
>   
>   _cleanup()
>   {
> @@ -26,71 +27,18 @@ usage()
>   
>   [ $# -eq 0 ] && usage
>   tdir=tests/$1
> -shift
> -
> -if [ ! -f $tdir/group ]
> -then
> -    echo "Creating the $tdir/group index ..."
> -    cat <<'End-of-File' >$tdir/group
> -# QA groups control
> -#
> -# define groups and default group owners
> -# do not start group name with a digit
> -#
> -
> -# catch-all
> -#
> -other		some-user-login
> -
> -# test-group association ... one line per test
> -#
> -End-of-File
> -fi
> -
> -if [ ! -w $tdir/group ]
> -then
> -    chmod u+w $tdir/group
> -    echo "Warning: making the index file \"$tdir/group\" writeable"
> -fi
> -
> -if make
> -then
> -    :
> -else
> -    echo "Warning: make failed -- some tests may be missing"
> -fi
>   
>   i=0
>   line=0
>   eof=1
> -[ -f "$tdir/group" ] || usage
> +[ -d "$tdir/" ] || usage
>   
>   export AWK_PROG="$(type -P awk)"
>   [ "$AWK_PROG" = "" ] && { echo "awk not found"; exit; }
>   
> -for found in `cat $tdir/group | tr - ' ' | $AWK_PROG '{ print $1 }'`
> -do
> -    line=$((line+1))
> -    if [ -z "$found" ] || [ "$found" == "#" ]; then
> -        continue
> -    elif ! echo "$found" | grep -q "^$VALID_TEST_NAME$"; then
> -        # this one is for tests not named by a number
> -        continue
> -    fi
> -    i=$((i+1))
> -    id=`printf "%03d" $i`
> -    if [ "$id" != "$found" ];then
> -	eof=0
> -	break
> -    fi
> -done
> -if [ $eof -eq 1 ]; then
> -   line=$((line+1))
> -   i=$((i+1))
> -   id=`printf "%03d" $i`
> -fi
> -
> +id="$(basename "$(./tools/nextid "$1")")"
>   echo "Next test id is $id"
> +shift
>   
>   read -p "Append a name to the ID? Test name will be $id-\$name. y,[n]: " -r
>   if [[ $REPLY = [Yy] ]]; then
> @@ -113,24 +61,9 @@ if [[ $REPLY = [Yy] ]]; then
>   		fi
>   	done
>   
> -	# now find where to insert this name
> -	eof=1
> -	for found in `tail -n +$line $tdir/group | $AWK_PROG '{ print $1 }'`; do
> -		found_id=$(echo "$found" | cut -d "-" -f 1 - )
> -		line=$((line+1))
> -		if [ -z "$found" ] || [ "$found" == "#" ]; then
> -			continue
> -		elif [ $found_id -gt $id ]; then
> -			eof=0
> -			break
> -		fi
> -	done
> -	if [ $eof -eq 0 ]; then
> -		# If place wasn't found, let $line be the end of the file
> -		line=$((line-1))
> -	fi
>   	id="$id-$name"
>   fi
> +
>   echo "Creating test file '$id'"
>   
>   if [ -f $tdir/$id ]
> @@ -140,6 +73,53 @@ then
>       exit 1
>   fi
>   
> +if [ $# -eq 0 ]
> +then
> +
> +    while true
> +    do
> +	echo -n "Add to group(s) [other] (separate by space, ? for list): "
> +	read ans
> +	[ -z "$ans" ] && ans=other
> +	if [ "X$ans" = "X?" ]
> +	then
> +	    for d in $SRC_GROUPS; do
> +		(cd "tests/$d/" ; ../../tools/mkgroupfile "$tmpfile")
> +		l=$(set -n < "$tmpfile" \
> +		    -e 's/#.*//' \
> +		    -e 's/$/ /' \
> +		    -e 's;\(^[0-9][0-9][0-9]\)\(.*$\);\2;p')
> +		grpl="$grpl $l"
> +	    done
> +	    lst=`for word in $grpl; do echo $word; done | sort| uniq `
> +	    echo $lst
> +	else
> +	    # only allow lower cases, spaces, digits and underscore in group
> +	    inval=`echo $ans | tr -d '[:lower:][:space:][:digit:]_'`
> +	    if [ "$inval" != "" ]; then
> +		echo "Invalid characters in group(s): $inval"
> +		echo "Only lower cases, digits and underscore are allowed in groups, separated by space"
> +		continue
> +	    else
> +		# remove redundant spaces/tabs
> +		ans=`echo "$ans" | sed 's/\s\+/ /g'`
> +		break
> +	    fi
> +	fi
> +    done
> +else
> +    # expert mode, groups are on the command line
> +    #
> +    (cd "$tdir" ; ../../tools/mkgroupfile "$tmpfile")
> +    for g in $*
> +    do
> +	if ! grep -q "[[:space:]]$g" "$tmpfile"; then
> +	    echo "Warning: group \"$g\" not defined in $tdir tests"
> +	fi
> +    done
> +    ans="$*"
> +fi
> +
>   echo -n "Creating skeletal script for you to edit ..."
>   
>   year=`date +%Y`
> @@ -154,7 +134,7 @@ cat <<End-of-File >$tdir/$id
>   # what am I here for?
>   #
>   . ./common/preamble
> -_begin_fstest group list here
> +_begin_fstest $ans
>   
>   # Override the default cleanup function.
>   # _cleanup()
> @@ -196,56 +176,5 @@ QA output created by $id
>   Silence is golden
>   End-of-File
>   
> -if [ $# -eq 0 ]
> -then
> -
> -    while true
> -    do
> -	echo -n "Add to group(s) [other] (separate by space, ? for list): "
> -	read ans
> -	[ -z "$ans" ] && ans=other
> -	if [ "X$ans" = "X?" ]
> -	then
> -	    for d in $SRC_GROUPS; do
> -		l=$(sed -n < tests/$d/group \
> -		    -e 's/#.*//' \
> -		    -e 's/$/ /' \
> -		    -e 's;\(^[0-9][0-9][0-9]\)\(.*$\);\2;p')
> -		grpl="$grpl $l"
> -	    done
> -	    lst=`for word in $grpl; do echo $word; done | sort| uniq `
> -	    echo $lst
> -	else
> -	    # only allow lower cases, spaces, digits and underscore in group
> -	    inval=`echo $ans | tr -d '[:lower:][:space:][:digit:]_'`
> -	    if [ "$inval" != "" ]; then
> -		echo "Invalid characters in group(s): $inval"
> -		echo "Only lower cases, digits and underscore are allowed in groups, separated by space"
> -		continue
> -	    else
> -		# remove redundant spaces/tabs
> -		ans=`echo "$ans" | sed 's/\s\+/ /g'`
> -		break
> -	    fi
> -	fi
> -    done
> -else
> -    # expert mode, groups are on the command line
> -    #
> -    for g in $*
> -    do
> -	if ! grep -q "[[:space:]]$g" "$tdir/group"; then
> -	    echo "Warning: group \"$g\" not defined in $tdir/group"
> -	fi
> -    done
> -    ans="$*"
> -fi
> -
> -echo -n "Adding $id to group index ..."
> -head -n $(($line-1)) $tdir/group > /tmp/$$.group
> -echo "$id $ans" >> /tmp/$$.group
> -tail -n +$((line)) $tdir/group >> /tmp/$$.group
> -mv /tmp/$$.group $tdir/group
>   echo " done."
> -
>   exit 0
> 
