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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EEF2C48BE0
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 21:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 834BD613C3
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 21:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhFKV5U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 17:57:20 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4724 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229548AbhFKV5Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Jun 2021 17:57:16 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15BLmjwt026251;
        Fri, 11 Jun 2021 21:55:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/rvtfzKxu+2XYXR+85IdYR+rMYRD2+FQ2uRlAsWlFJ4=;
 b=SEYebIM8CdBgAMseqxBRauc2rTwsZBWBkStAlfWgtI27sMrrvYx/7CopHOoRqbf2YTL8
 0xvn8iVP3rfe0CxNfHHMknsCeTLCx0VP7qmB3kjKWkS9OVmgymKjO0ISWYOXFzKT+U7z
 In7qg76/MUvwRhpADvvjQckjrYuB80chhjlvixoYVWNdrD0osrvG5EZOs6/VIZObQ7Lv
 aGOpXxBP8i9snk2zuANr7wtUHM/P1Vtt56pnZSgK4BwfTgweGnJToRWBfz33lVKnTd5P
 uSBMrwZdhf1R3PhFu2CM8qm5XixiHtaIZW9R7mDQ+HsLffO1Gp0QMOXl3y3c2Bh/KXj7 wA== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3944hn07aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 21:55:13 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15BLtC55013495;
        Fri, 11 Jun 2021 21:55:12 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3030.oracle.com with ESMTP id 38yyadt7mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 21:55:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCDfTaamrWfMMaNb4FVzVZBNvViEXno/FcLQ1V7ZVFIgRW7cGSxawwI8egFF2C1txDJhRFDP+JhCpDVgPfdIi8iCUwlvGIbijCDXcMZWcbmWe8KdqmJxfk50+GQL30RQOOTCI3e23V949Aw6OjHLkDL23gDU8X3jsT4LqpkvTyYyYuDaBUQdOTU6qUdDMIRb3p79Qo9bN4cjYgK+RyWJdzBxKm0XX/wVxLgnIROZgMzbCz5GE6+8EP7r+HaKNO53iLizZ3rQJJhCVARIBWvTc4FUlLAZ3Do0pReWOO9o4yhlLw2F29lDXGMOzz3PhkESvDJqeWkGsXUfGgL0zi1n7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/rvtfzKxu+2XYXR+85IdYR+rMYRD2+FQ2uRlAsWlFJ4=;
 b=bItfJNzGwO7HTveJWxk8vELYVqA0TWZyWfx059uHakjOA1kQULZfmVP+KRPNU6h62KkU0RviB+T2LNxE4EVCUGq9JzQKX5taqX+uG9ZgyHjRNuNoONKJtBZ960CvQp9IaFPaDBBHGEaSFilhihPtUxSR1S5XFiMFjv4CBliiIrtAS23uIIB88OxRqs3RNtY6FJ4Y0tuwZBrwI+4WiUHppYY6SKSL3ISwMiy8jK4cV+/4tErtf9EgYT2fD92K02ZK4JektrzFpO3snjn+TPVKHZ6IAYv7gSo4nKx3HzGK5IxEzeY6qDda6njjkzT48WWDyxtk5JBGH/uqmEnCPfct4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/rvtfzKxu+2XYXR+85IdYR+rMYRD2+FQ2uRlAsWlFJ4=;
 b=gyoOBbBctswX8U4VmkNeh0tl16o/xWh0XiR/ak8BXQeDccBArEbt+A96WI47twWO897hb8tJoFIztg5IG1AvFP3dpelbBrMnGR93orKjI4ssiGB9GbKS8k3cc88VEOyyLyudVFeD8dRQ/AfPV2vh8WoUPPYxej05B6qXKjQ9VPs=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3955.namprd10.prod.outlook.com (2603:10b6:a03:1f7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Fri, 11 Jun
 2021 21:55:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.032; Fri, 11 Jun 2021
 21:55:10 +0000
Subject: Re: [PATCH 03/13] fstests: refactor test boilerplate code
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317277866.653489.1612159248973350500.stgit@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <d124adb9-7e45-c471-8a5d-6b2c266a6b8c@oracle.com>
Date:   Fri, 11 Jun 2021 14:55:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <162317277866.653489.1612159248973350500.stgit@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by BYAPR03CA0014.namprd03.prod.outlook.com (2603:10b6:a02:a8::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 21:55:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b66cce8-7d57-47ac-2e45-08d92d239547
X-MS-TrafficTypeDiagnostic: BY5PR10MB3955:
X-Microsoft-Antispam-PRVS: <BY5PR10MB39550887CA48AD54E0CF89B695349@BY5PR10MB3955.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iDwiFVH7BXU74ppJ0t9BAPXrlxaD0vJL7wBp1d0zKkESsBRv/TBNS/4t2OYx0upf0a1FFoHtRq6bl3dfbYGEMEvSKgj6H6Ide6VDxyYvmsiqDIzlFtBEEDztpnAWcTt2qH95l4lezg/y7doAuXl5Y1trTPPGqWe49Tcixz3itGByRs+VVbnOsbrJU4yJOTODo+k2h8AmmiDpL+UIR9+vbj8g2FZC1dLBnlKY4ZktSJsY0D9qyNt+iQQyVCXvGme4+9TiT9kfBUzG9B1UhigUWhGiXsdYMHe9SHf/hiQafzp+hCEqu2EWLCCbCGe/LfTw26uZ3vfrMYir7lxcMgm95zJYS0Eoi2JLHKppN9J9ZHX7xD2UyywDYLpfRKlq9/QnsELik64nfc88DuWVphq24HKRjQUZ26JVVUE4nv4cnN0gJez2d6QSHHnLeEnCWqDsjelzZAVUEbKqaqWhmis8K47Knj/FB9FuyD+/qRkc/dqsvPKeOo53rd7UPFkHhehajVFw7rvn4XIqmunQiO4Tl+F2guL9RFhEsO44TpVpDU9zFb05tyiA/2T5rzAK9E5ptulmgx19QQ9+lAwKKnkzpBP7TiXRlkoXqmYdS5dPwDt/ozzxnNDBchvWrv0t8PEnSRdeVR8gO15dX/Jgw0N7uN9YQLThdUaFgg+jIiRQTDdUcvUVNiPuCUMAR5XTx5GG/eCbKVGC2JesdXItpKmULg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(39860400002)(366004)(396003)(44832011)(31686004)(478600001)(8936002)(4326008)(6486002)(66556008)(66476007)(5660300002)(86362001)(38100700002)(38350700002)(2616005)(956004)(16526019)(8676002)(53546011)(316002)(52116002)(31696002)(83380400001)(186003)(36756003)(16576012)(26005)(66946007)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXY4eWZoSGVORGNCem9lMFVuc0RIYmwyWVFacEhrZEcvT2loRXU4dUZON2k2?=
 =?utf-8?B?TDI1cmNMNlNjZWQxclBUc09QREt0TGZXSE1pbllUcStqZndjbTRCVlNWOGFB?=
 =?utf-8?B?aVl4TFFnWThoZE9KNk03akR3UmFxUzNQcDJLeVYrRnUwLzR0NlRwTlIrRm1Z?=
 =?utf-8?B?RWkrRGd5WlFIRStxcTN4RlVJWUxNOCtyMzhkdXFhY1RZVWdmamdNajBoeDlo?=
 =?utf-8?B?Ry9SZVZOM3VjVFZ4MncyZ3FmL0grUTBlQ2pRSWpPUmxpS3B6WUhMekJOeTVl?=
 =?utf-8?B?Mk5zSDc1UGY0UFVzdE9Kc2MzRkt2UW9PT0VORWVhTDk0N0xkcE9QS3dkNVQx?=
 =?utf-8?B?NHlxOTg1WTVTZ2cvNFc3VStSU2pjd3dpNHBnUFZ2RVl1VEczZHUycmQ5QUo3?=
 =?utf-8?B?bGJwTlF6SHlMMjNsTTNuMS8rb0VQZzNiSkVFZEc1V0pKWmdrNUJsaERQcXhZ?=
 =?utf-8?B?NE9uQnI2TGYyajYrSmdQWFVzUmlSWnNUS0ZESy85dXhjWmRHaFBJU21YREJN?=
 =?utf-8?B?MkZ2VHRIcjZzUmdlVnl0bWhYcUxVNWl0MUNjUTlyWVZtN2p6SFl1OHZRb1k0?=
 =?utf-8?B?MTVXTWhSdkkzRGxiZTlZMWdrclBkcGVNYWpNTWp2bFF3R1RQaTFDV3hEcitt?=
 =?utf-8?B?T2EvNWY1M0dwbVk0V0pWSll5OStmSlFIcVY5T2VQU2tTSDFlQ0swWEd2Sytv?=
 =?utf-8?B?aVMzVDFJaXNwQ05va2tNM3pKMHM2Y3V1dTBYWmFHL0xacWlSU0hCRXFIOXRH?=
 =?utf-8?B?U0J0UnJ3UFNFdlF6N3MrTmZYNG1jcFppU3pCczNVQUdoSENab0VGSVl0YkVT?=
 =?utf-8?B?UHQ0VHllQzJGNmJ4bFUzTnluZ1FtNzgwVFVNb1JVbzBsNENVRlFnR054TE5F?=
 =?utf-8?B?L3NGMDNDN0NpVm40K3M4eEx2dXY4eCtleXVGWElyM09PN3FtSGVDZCt4ZFdv?=
 =?utf-8?B?TC8vUzlkZEtGcS9rYmNlbG4wck4xQ3MveVp0Uy9wT0FldzBGWHJEcHIrcjVS?=
 =?utf-8?B?a2c5ZDdwbVlob082NVp3d2ZzczE0R2hRS2hnMHFjcEdJOGU4OTljZEN0L1pS?=
 =?utf-8?B?V3R3RWxRVHNWdXJDNnd6Vll5dE5pRjhnZnJRY1I3c0ZEZkYvWXR1N1ViRUVK?=
 =?utf-8?B?T2QxQ2tzVlg5TytZUm14Kzh5MnBRZDVIcUk2LzRZWE5ENFZ2cjQxcG5PdFRJ?=
 =?utf-8?B?TkVlT2g4L05BU1R0ZUt5VE9FeGM0WDU2RUNHS3ZNeDFwRlRzbDlrUVR6NitC?=
 =?utf-8?B?QmRzb1BNd1B0eEpqR20vL3h1OEczT0IxSGpBNHErTU9LZlFlT1AwUDRZNElU?=
 =?utf-8?B?L2IyR0hTNlAxa3hJbTRHQ05tcXMyV0I0c25mWlhKdEVZUjBZRnc4THdjU0Y0?=
 =?utf-8?B?YlJaTk1FQmY0bGFOWkkveHFLak5WdXpuME9xa052OUVTTDM4UERQdzkzMU5Z?=
 =?utf-8?B?T2NlRnZYbzE1N2JHTVZZaDFROGh2NHk5Ykg5K3lvb01yR3lUL3ZWSXErS0Q5?=
 =?utf-8?B?NXRDeG5xK1NqOCtEcmNabmtHL01iUlk3MWNHNzhrSkIrNWZzNVF1bWNuaEpo?=
 =?utf-8?B?ZHp4SWRja0p5bDZhY2RvblFoMEhDdis5R0k1cWVPaWtCZGc0ekVzUVIzc25I?=
 =?utf-8?B?Z2lSMkczSXpSb1pDTHp1UDUwa0l0YmhOUG9JenY4TU9OVmJ4WDZwemhuQkxp?=
 =?utf-8?B?SzRJYmtacytVNG1kRlJzUFdOZFp1SENKOElUWWk2VE5uQi9oeWQxT0JrdEdD?=
 =?utf-8?Q?2j6cQKiQ27FK2FKETCEMWIq+9ZaRtimIt2nezsc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b66cce8-7d57-47ac-2e45-08d92d239547
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 21:55:10.2525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5v7JQx3jB2j/y3jO8R+truvTlBLOkS3jDgYkhC+wZPuNzLjNyJkHnX5qWp5bHGiXjQ4OCnSpK3sn6L39fIOSBXyX7vzv1DQ1BkDpmlXQAvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3955
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10012 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106110137
X-Proofpoint-ORIG-GUID: Iuds_cM5N482MLbiOTrEKSlHGA8o9SAg
X-Proofpoint-GUID: Iuds_cM5N482MLbiOTrEKSlHGA8o9SAg
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/8/21 10:19 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create two new helper functions to deal with boilerplate test code:
> 
> A helper function to set the seq and seqnum variables.  We will expand
> on this in the next patch so that fstests can autogenerate group files
> from now on.
> 
> A helper function to register cleanup code that will run if the test
> exits or trips over a standard range of signals.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Looks straight forward
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   common/preamble |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
>   new             |   33 ++++++++++++---------------------
>   2 files changed, 61 insertions(+), 21 deletions(-)
>   create mode 100644 common/preamble
> 
> 
> diff --git a/common/preamble b/common/preamble
> new file mode 100644
> index 00000000..63f66957
> --- /dev/null
> +++ b/common/preamble
> @@ -0,0 +1,49 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +
> +# Boilerplate fstests functionality
> +
> +# Standard cleanup function.  Individual tests should override this.
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# Install the supplied cleanup code as a signal handler for HUP, INT, QUIT,
> +# TERM, or when the test exits.  Extra signals can be specified as subsequent
> +# parameters.
> +_register_cleanup()
> +{
> +	local cleanup="$1"
> +	shift
> +
> +	test -n "$cleanup" && cleanup="${cleanup}; "
> +	trap "${cleanup}exit \$status" EXIT HUP INT QUIT TERM $*
> +}
> +# Initialize the global seq, seqres, here, tmp, and status variables to their
> +# defaults.  Group memberships are the only arguments to this helper.
> +_begin_fstest()
> +{
> +	if [ -n "$seq" ]; then
> +		echo "_begin_fstest can only be called once!"
> +		exit 1
> +	fi
> +
> +	seq=`basename $0`
> +	seqres=$RESULT_DIR/$seq
> +	echo "QA output created by $seq"
> +
> +	here=`pwd`
> +	tmp=/tmp/$$
> +	status=1	# failure is the default!
> +
> +	_register_cleanup _cleanup
> +
> +	. ./common/rc
> +
> +	# remove previous $seqres.full before test
> +	rm -f $seqres.full
> +
> +}
> diff --git a/new b/new
> index 357983d9..16e7c782 100755
> --- a/new
> +++ b/new
> @@ -153,27 +153,18 @@ cat <<End-of-File >$tdir/$id
>   #
>   # what am I here for?
>   #
> -seq=\`basename \$0\`
> -seqres=\$RESULT_DIR/\$seq
> -echo "QA output created by \$seq"
> -
> -here=\`pwd\`
> -tmp=/tmp/\$\$
> -status=1	# failure is the default!
> -trap "_cleanup; exit \\\$status" 0 1 2 3 15
> -
> -_cleanup()
> -{
> -	cd /
> -	rm -f \$tmp.*
> -}
> -
> -# get standard environment, filters and checks
> -. ./common/rc
> -. ./common/filter
> -
> -# remove previous \$seqres.full before test
> -rm -f \$seqres.full
> +. ./common/preamble
> +_begin_fstest group list here
> +
> +# Override the default cleanup function.
> +# _cleanup()
> +# {
> +# 	cd /
> +# 	rm -f \$tmp.*
> +# }
> +
> +# Import common functions.
> +# . ./common/filter
>   
>   # real QA test starts here
>   
> 
