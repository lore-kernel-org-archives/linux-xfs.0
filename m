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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D4EC48BE0
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 21:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCCA9613C3
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 21:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhFKV5c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 17:57:32 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:58258 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229777AbhFKV5b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Jun 2021 17:57:31 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15BLl3Wd019872;
        Fri, 11 Jun 2021 21:55:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=qp0F6isBXa/nqMkPfppjueAb4qHaFNvjP+36YkiN65s=;
 b=nFSEapU6NGEyWIGEUHgUZ7a4svTIhISAfB3aVrQ1pSYzkcEMZ/rAWHmE2HpZKxxSl1zT
 g3jFsixT2JrQyRQZiUVKLUM9WyDEYSFswd6hsQ1loFTCpLV7Q2LjiOulDOdvcWaL7E+k
 hWKHIbEFCtVUWoEft9WvMW4H2gCrmaCThdc+YL4sHG06pa6RHY4+/qo0OXeXZaiH7Trq
 3HW5wP84ZFcwC4xFLZHj4RE72OBnZiAfdzvIbF/mT9xb1gqejUfqRVAhHBFYe+VA2Jk3
 OI62Pu4umCXZ5rVPgvp9nnBcHy180I3h89VVR7hkmF9/vB3Vs1AH8m7PmZfNfyzb1jiC vw== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 394a04r41s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 21:55:29 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15BLtSY9005069;
        Fri, 11 Jun 2021 21:55:28 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3030.oracle.com with ESMTP id 3949cwchay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 21:55:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StKY8fsZCMRHzGEWDQJPmWKrlQj7vlNTYvsKp8eJuJYsqZBeZRr6HuTT+uxOmyUsYZvnPtlvjxrmkHvid4DVq9dM5IgnTfc7mVKGuz8/FeWVY9XluXJ/i8UcYKd6R3aGqSg+BNkYSIiAwdH/tcSIL+5nRr6i3Z7JUl3I3ZzwaE9DpLevw4eCzsVjIZFDKNQZhInfisa9uwhNwjSgvU//AgJmQC4Gpe5uDxzapmihdH6F8VNXAjxB93h4TiuoSmnshmDu/kz0fPfll+XIPQnBOJyGx6JRTmUFgx7jZTSYeefJIIONzmcuGsTDt7qsgLk8Ey+Bq+VTC19Tc/RgZtRpkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qp0F6isBXa/nqMkPfppjueAb4qHaFNvjP+36YkiN65s=;
 b=c1KHK9a+fSlse8Xx+d+9tPYALedHCxYpt3kvmP1ksYIcNmBv6DsP41O3SQesgJGVXLAZwODmQEn3BP7yaU/dxrsREQ6/bzujzoIzS5WORfBVN+Y1y/SEm/ZZgagRymRWYnBAcmw67woaEDrPPg59Z7hMSNFD/+Pdzlk6XyY1CjeRY1tCkSKDnz34tXeaWlIBlj7P0rZ08NHHh5a0JTyxt4voMU1/KQBcu90Pgdhlkb/ucFhyaarVkfzUKk0evEJl/hn9k2NBMThkFImISMkz8gnPhPCgeH/M3hNud6nmzRoOzxZwBzEkDLYbMk8i2tRMDHKChZ+vLn/fPIV2ICNVFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qp0F6isBXa/nqMkPfppjueAb4qHaFNvjP+36YkiN65s=;
 b=P3GtGquSNswQpA6ulEI3mLhqMNoMjKQGOZRyXaqhrUi9D3H2BZtU5bJoTd1p2guxMyKN+4q//EkzipYQA1r6ZgMS95VksG7WHUEGJQI7pktIhlaacDHDRYEFVoYm2+BeghrQBxQRzA0u0YMyWRi8fd4K7AYj3UhvItB5rneip6M=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3955.namprd10.prod.outlook.com (2603:10b6:a03:1f7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Fri, 11 Jun
 2021 21:55:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.032; Fri, 11 Jun 2021
 21:55:26 +0000
Subject: Re: [PATCH 04/13] fstests: add tool migrate group membership data to
 test files
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317278412.653489.8220326541398463657.stgit@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <31a49d5c-608e-764a-56a6-bc5ffbc4b7b1@oracle.com>
Date:   Fri, 11 Jun 2021 14:55:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <162317278412.653489.8220326541398463657.stgit@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::30) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by BYAPR03CA0017.namprd03.prod.outlook.com (2603:10b6:a02:a8::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 21:55:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eacaa4ce-a826-42cc-a9af-08d92d239ee0
X-MS-TrafficTypeDiagnostic: BY5PR10MB3955:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3955D860DCD66025B65AADC595349@BY5PR10MB3955.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:220;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KpznIkrqdCn33E+cPLddkckDjXjGzgyF31DAMt3K/3FBnVyH0FYtwbDSlr56Hv9xrtiYTq9WSg8iPXBrDMVzn71Mq3TiqoGpqIFheOrCqgzukvTrr0QXkhIaLR+S+wih90uJo8QJm6tiQ/4BpA1JXJsf+dvyM3qx0y/u3bGuTGV5ElbsFc0kZ0gp7FvkX+phy8H8RSufh4eXrmEPEOYL/skZ+fkmnqp6D9x/pM4k2j3s6sEsqOGUu2v+cJMQbGBhWwGDRDMx6iOWivFhBoUbGJlvYE6Z5m6r55n7vCdpzK5oG1AXmFhISdmJ8WpIzcpdGTohQkI37g5Q+EMZXZkXoe6J98Y/SOxqzaONhNdRj1Hubf3YBtCoTpRQhkUZENv8n90f8qZjdqq7R7CU5JskIUXKGG7r5jZ64rPkWK7bYnEOpClc34D+K1KGyTGOebv+wYAep14jnxlwkXW/3s8yHUsqY5PzTrEKnIIhr+BZ5nM2rbAD+zI48ZFwidwLSNcsKfAvbZASy1Occ9kHdRJpr2H6Xlisy6BUeM4dgUnZybHuUXypmjPijNyo3wi8sjJVzqNEzlJ/A7nJS0It6Jt1XYCFpi/yVoes+pncc7gSovwxAoQ+yPFp4W5c6CnuVNHaQBjWbkUpRSKg7iPrhukWPfzT7uIPt41yMaRLVv7KBbtsp7qFdzVmYSyptKQ8jVRinZs6IorUPBg2DpjoLyBrCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(39860400002)(366004)(396003)(44832011)(31686004)(478600001)(8936002)(4326008)(6486002)(66556008)(66476007)(5660300002)(86362001)(38100700002)(38350700002)(2616005)(956004)(16526019)(8676002)(53546011)(316002)(52116002)(31696002)(83380400001)(186003)(36756003)(16576012)(26005)(66946007)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ylc5Y0xaRkFhamJTa2dKeUtGamJnQjMwRGowWm0ycmpPbjRmdVAvcWNGL1FI?=
 =?utf-8?B?eXArN2ZTOW1NNXhtc2o5cUx4M2UrZUdEMkFYcHZaNE1yUEdacjVBNjY2dzU1?=
 =?utf-8?B?RDd1dFJUSDk5dEl4Q2FVKzVqMnpVbm1RZmdxMU93SzlrV2RjQ09aREtlQXU1?=
 =?utf-8?B?TlpEenBGcyt6WU8zL3dmV3FpUmR2UWlDZTMrOG8xRHh0cnkxR0tFV0lxNmJI?=
 =?utf-8?B?SW1weWN5NGJpN3E0QVFFK2xlRDdqVTRxYk1VY00vaXNQd2R6RTJvcjBIS1hh?=
 =?utf-8?B?amlYQmZMZ0I0ZGJLM3lTc2xYTWQ3SDhkYVNBVGdPTXpUd2UwdnVYSGFGLzE4?=
 =?utf-8?B?QkNnd25ET0M4K1p3STd3OEZYSnpQWmNET21TT3RJdE4wVUc0SmFLeGw5ZFdk?=
 =?utf-8?B?b05UV0d6UVFDYVZJOEVVckhlT0prWm12aHRzdFFWMEo0enhCOVEzQkM3RkpQ?=
 =?utf-8?B?WGxXMXV5VGFNTGo3VkF2cGpHMEZ1ZEM1L0xuOHRydmg2WStLVVVNYldHR2I1?=
 =?utf-8?B?cUJWNnhTS1F1NXpreHkveTY3blRZUzBnVlo0TU85ZDd2T3ZVdStNUUg4bkdj?=
 =?utf-8?B?eU5tbS9pUTNtUHlWWlJKR1dFajgxWTVDSUFOc0Z4TmF1cTQ5Y1U5cmhYZGFk?=
 =?utf-8?B?Z2Y5VmJjcHRoMEF1TlQ2c3Z6U0M2a1dlZGJYdE5vYkdUL2xhSklyNDVxYUlS?=
 =?utf-8?B?Sm1iOHgwcnhCaFB2cmFxTnJkUTNEa2FlUWZFdVFoeW1aZ2ZKNjhkZEcrdm9D?=
 =?utf-8?B?b2hlWWdJOHpOMW9GaEoweExQbE5iRWlEY05UNGtBQVdsVHBFZHROcUVtZGNW?=
 =?utf-8?B?WWRPT1pBd0JXNE10eHcyVGxvcjhOclBxMWd6OTlNYnoxZDNVVEVwbzI3cGZo?=
 =?utf-8?B?QWFkL1ZnRVJ2ZVVwN05ZN2VmYXZuTS9qOXp5ZFhGYWlzZUVhZUlGS3VCRVV1?=
 =?utf-8?B?cnRDcUc5NTRCVUU3cWNQbnZMQlFiMlJpOTFHam1QTUppQkQxN2N2cWV1eEVv?=
 =?utf-8?B?RU51RVk5Q1pYY2l5RlVHVEJRdmxjMHAxZnNQbnR2NTlYOXVEL0Q2QmpnRlE4?=
 =?utf-8?B?SmVaVEF6VXh3R0FIL2pIREZubzJoV2xVZ2c0MFloWW9IK2c2eS9kWFJrdHd3?=
 =?utf-8?B?cW1OckkyVExvdEhuWERINGQ1eUZqREpwZVp1eldXVTc1eWdJaWVEbk9TQUhr?=
 =?utf-8?B?RnRPRVl2WGh2Ulgya3pOakMzd1c5anpxLzhiRkh1ZVRjZWIxcEVmekx0Umpx?=
 =?utf-8?B?Qmw1Qmc5UlhvQTdyTlpLS1JuSzg4dGRTWDlKUDExRnpvTU5IZ2ZILzFBb2U5?=
 =?utf-8?B?SmZELzMzMGRmRG1NWkRZWFhkczg2NDJkY0NzbEFucWt3YkhzUG9aOE1mL2RR?=
 =?utf-8?B?T0ZUbXpLWVliUHNsWkFsbzN0R21PSUs4b3pSTExKYmR6bG1KZWU1YU81QVdi?=
 =?utf-8?B?bGJ5bjhRSUo0aVliUUVKWmI4MGhoSXBiQ3RzN2JxdDB0dC9zcW9xTGxmemF4?=
 =?utf-8?B?eVpvSElYdGpSakVxYjlVeGpDbE11akRJSWVqVWlKZ3dTT0VuMWZJSXlGS3VI?=
 =?utf-8?B?MFJDMmdHam5MYmx6WmZwZmkrbHdOWjR1dE81K2NwamtRL1pQMzZHTkY3cGxv?=
 =?utf-8?B?UFVzNkRBZ3EvamlSOHlGZSthWFlINnJVay9jaUpLdXNwMzdMaVdDZ213czRW?=
 =?utf-8?B?T0xVWGdZdFJvY2RySjZCTkZUQmQ4SEFJTTdjN2lEM2xWb1BKQXUvendjS2JN?=
 =?utf-8?Q?zo2jBhxIR6ffsYPIxJZq9pFw22uLePIUB0kIrcn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eacaa4ce-a826-42cc-a9af-08d92d239ee0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 21:55:26.3549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CxDLKugqdON21kwYlaLQIS/8N2lbBNixSoMcMT4Po3SRL2dI6Z/lPzhxW/M/MHehHK6nvuPa+/5kBxEHHWM5R/uRa0Bat2652pYHXde9dsw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3955
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10012 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106110136
X-Proofpoint-ORIG-GUID: OvPhRzMVXe8srRhocMxSd3jMoQYaoW6e
X-Proofpoint-GUID: OvPhRzMVXe8srRhocMxSd3jMoQYaoW6e
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/8/21 10:19 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a tool to migrate the mapping of tests <-> groups out of the
> group file and into the individual test file as a _begin_fstest
> call.  In the next patches we'll rewrite all the test files and auto
> generate the group files from the tests.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Applied the patch and gave the output a quick look over.  I think it 
looks good.
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   tools/convert-group |  131 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 131 insertions(+)
>   create mode 100755 tools/convert-group
> 
> 
> diff --git a/tools/convert-group b/tools/convert-group
> new file mode 100755
> index 00000000..42a99fe5
> --- /dev/null
> +++ b/tools/convert-group
> @@ -0,0 +1,131 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +
> +# Move group tags from the groups file into the test files themselves.
> +
> +if [ -z "$1" ] || [ "$1" = "--help" ]; then
> +	echo "Usage: $0 test_dir [test_dirs...]"
> +	exit 1
> +fi
> +
> +obliterate_group_file() {
> +	sed -e 's/^#.*$//g' < group | while read test groups; do
> +		if [ -z "$test" ]; then
> +			continue;
> +		elif [ ! -e "$test" ]; then
> +			echo "Ignoring unknown test file \"$test\"."
> +			continue
> +		fi
> +
> +		# Replace all the open-coded test preparation code with a
> +		# single call to _begin_fstest.
> +		sed -e '/^seqres=\$RESULT_DIR\/\$seq$/d' \
> +		    -e '/^seqres=\"\$RESULT_DIR\/\$seq\"$/d' \
> +		    -e '/^echo "QA output created by \$seq"$/d' \
> +		    -e '/^here=`pwd`$/d' \
> +		    -e '/^here=\$(pwd)$/d' \
> +		    -e '/^here=\$PWD$/d' \
> +		    -e '/^here=\"`pwd`\"$/d' \
> +		    -e '/^tmp=\/tmp\/\$\$$/d' \
> +		    -e '/^status=1.*failure.*is.*the.*default/d' \
> +		    -e '/^status=1.*FAILure.*is.*the.*default/d' \
> +		    -e '/^status=1.*success.*is.*the.*default/d' \
> +		    -e '/^status=1.*default.*failure/d' \
> +		    -e '/^echo.*QA output created by.*seq/d' \
> +		    -e '/^# remove previous \$seqres.full before test/d' \
> +		    -e '/^rm -f \$seqres.full/d' \
> +		    -e 's|^# get standard environment, filters and checks|# Import common functions.|g' \
> +		    -e '/^\. \.\/common\/rc/d' \
> +		    -e '/^\. common\/rc/d' \
> +		    -e 's|^seq=.*$|. ./common/preamble\n_begin_fstest '"$groups"'|g' \
> +		    -i "$test"
> +
> +		# Replace the open-coded trap calls that register cleanup code
> +		# with a call to _register_cleanup.
> +		#
> +		# For tests that registered empty-string cleanups or open-coded
> +		# calls to remove $tmp files, remove the _register_cleanup
> +		# calls entirely because the default _cleanup does that for us.
> +		#
> +		# For tests that now have a _register_cleanup call for the
> +		# _cleanup function, remove the explicit call because
> +		# _begin_fstest already registers that for us.
> +		#
> +		# For tests that override _cleanup, insert a comment noting
> +		# that it is overriding the default, to match the ./new
> +		# template.
> +		sed -e 's|^trap "exit \\\$status" 0 1 2 3 15|_register_cleanup ""|g' \
> +		    -e 's|^trap "\(.*\)[[:space:]]*; exit \\\$status" 0 1 2 3 15|_register_cleanup "\1"|g' \
> +		    -e 's|^trap "\(.*\)[[:space:]]*; exit \\\$status" 1 2 3 15|_register_cleanup "\1"|g' \
> +		    -e 's|^trap '"'"'\(.*\)[[:space:]]*; exit \$status'"'"' 0 1 2 3 15|_register_cleanup "\1"|g' \
> +		    -e 's|^trap "\(.*\)[[:space:]]*; exit \\\$status" 0 1 2 3 7 15|_register_cleanup "\1" BUS|g' \
> +		    -e 's|^_register_cleanup "[[:space:]]*\([^[:space:]]*\)[[:space:]]*"|_register_cleanup "\1"|g' \
> +		    -e '/^_register_cleanup ""$/d' \
> +		    -e '/^_register_cleanup "rm -f \$tmp.*"$/d' \
> +		    -e '/^_register_cleanup "_cleanup"$/d' \
> +		    -e 's|^_cleanup()|# Override the default cleanup function.\n_cleanup()|g' \
> +		    -i "$test"
> +
> +		# If the test doesn't import any common functionality,
> +		# get rid of the pointless comment.
> +		if ! grep -q '^\. .*common' "$test"; then
> +			sed -e '/^# Import common functions.$/d' -i "$test"
> +		fi
> +
> +		# Replace the "status=1" lines that don't have the usual
> +		# "failure is the default" message if there's no other code
> +		# between _begin_fstest and status=1.
> +		if grep -q '^status=1$' "$test"; then
> +			awk '
> +BEGIN {
> +	saw_groupinfo = 0;
> +}
> +{
> +	if ($0 ~ /^_begin_fstest/) {
> +		saw_groupinfo = 1;
> +		printf("%s\n", $0);
> +	} else if ($0 ~ /^status=1$/) {
> +		if (saw_groupinfo == 0) {
> +			printf("%s\n", $0);
> +		}
> +	} else if ($0 == "") {
> +		printf("\n");
> +	} else {
> +		saw_groupinfo = 0;
> +		printf("%s\n", $0);
> +	}
> +}
> +' < "$test" > "$test.new"
> +			cat "$test.new" > "$test"
> +			rm -f "$test.new"
> +		fi
> +
> +		# Collapse sequences of blank lines to a single blank line.
> +		awk '
> +BEGIN {
> +	saw_blank = 0;
> +}
> +{
> +	if ($0 ~ /^$/) {
> +		if (saw_blank == 0) {
> +			printf("\n");
> +			saw_blank = 1;
> +		}
> +	} else {
> +		printf("%s\n", $0);
> +		saw_blank = 0;
> +	}
> +}
> +' < "$test" > "$test.new"
> +		cat "$test.new" > "$test"
> +		rm -f "$test.new"
> +	done
> +}
> +
> +curr_dir="$PWD"
> +for tdir in "$@"; do
> +	cd "tests/$tdir"
> +	obliterate_group_file
> +	cd "$curr_dir"
> +done
> 
