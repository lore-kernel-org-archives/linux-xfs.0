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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B13C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 21:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D229613E0
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 21:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbhDVVRY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Apr 2021 17:17:24 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:60360 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236851AbhDVVRX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Apr 2021 17:17:23 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13MLFBHC000627;
        Thu, 22 Apr 2021 21:16:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Qh5yHJGT6nitNx6MpfBw0/hRjn8UJFc0PocHYrtJ2KI=;
 b=OV+6/m9fUUPsJTLRbk37y1QacNd1tv/sLSA138msLsGQxDZjHCyFIiW56FGssPkQhYW1
 WTzIzlCnAdlQsCZGyfpawIhQKXYzjlO3bmwjhgvsE9kQk7Ne6IFAb/TslFlfyfBgafJ+
 23ydK+cu5PnQteVSmI45NJc1v5Nr5dYFpCLPwMVMdt9Kb9CRKgF44jcMemnhZT3ScK0b
 uF5e+t3KRiBsnUehZTFIzTzViZ+F35W5VC6GySKlQKx2NA+NiOfA6EvQKlIFQVmGRt/M
 uk2a6pME79QJalwrmnSt7UWQ0BrJrmi0jAeofPuoz1d1PT/L/sYbKtmli79QjjgEQa5H 6A== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 382yqs8cvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 21:16:43 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 13MLGgbm085394;
        Thu, 22 Apr 2021 21:16:42 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by userp3030.oracle.com with ESMTP id 383cds4rgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 21:16:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KBqcnNOpiAdMA0EBdCbR+4iw6mJkfsCADDHnIU9GBAcj51WLuJIIvyZsz3uijzJJpoBjkMf9sPrpNly1xtdIBhSgQIVIix02y9fXuAEbjgFPg9GJuDK4PZ5lhlV4dwn6lCn43gxloZs92XchtVgg3jA9t8kEakx3rgCKKiuXVp5ADrS2RSkdEgUCRNY+sdPOR4cDiAE85QG0cvmS83bH6oU3VbFLOTRMzr0iHBl1oVn5JHIBERUinK88O4zvLb6Qa5aCUAVR7kYl5QoVum7O6c6EX+YfY1nms14r3n6F1ph+JYmAOhTRlY4Sfb6uP4xqq+nw86TT+r2irSsZ8JhubQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qh5yHJGT6nitNx6MpfBw0/hRjn8UJFc0PocHYrtJ2KI=;
 b=kGMGB7aVJfs05GUc0pyfKbPYhYoe4jccH+0RC80rTmF6Jkl4jHIvtNos4L05TAimFRR6Bovg5rmqoR7oNfIrnIwWdDvIvYc+xBbEYrbvhQtI+WBS9vy/5LEwsFcuQTTpy0Cvk7JrDDqjeDhLDwQ3B111ANieW6QLl+GDRuwdWLU8DmKmbQ62pvvh9yrvWiwR5H7a7xQLrGSoNQTzhd4GzAkvAxg/kL0awyAXTmk3pxA7orzMvEme/vFl6ZcXnaYO/jANUJCsaTmDVmtEx1yHDcgGoRCSbNo0t6TZkEDhN5kHiTZd0t2zaku7AXzquEarvOtH4IfOHrf2cNikHfSJKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qh5yHJGT6nitNx6MpfBw0/hRjn8UJFc0PocHYrtJ2KI=;
 b=ru0UyehCFnSsAayBGFO8rxisT9tYLeeEVY6As+1rKu5AYLbTQzymoyBfS8yM9iBHT1/MwzeYk7JZl1J3UumP2kVOHPplGz29g4mwyeL/fLHIuQcl2ax7mwZqsoRaKWDNpnuCUxXyum1ZYCl3ih6msjAOT8j5G3b0kAyKY8uuOiI=
Authentication-Results: eryu.me; dkim=none (message not signed)
 header.d=none;eryu.me; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2870.namprd10.prod.outlook.com (2603:10b6:a03:8d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.21; Thu, 22 Apr
 2021 21:16:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 21:16:40 +0000
Subject: Re: [PATCH 3/4] xfs: detect time limits from filesystem
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
References: <161896458140.776452.9583732658582318883.stgit@magnolia>
 <161896460011.776452.12958363566736119178.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <eb4e5a15-c73f-1864-cd20-813a57b50ce7@oracle.com>
Date:   Thu, 22 Apr 2021 14:16:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <161896460011.776452.12958363566736119178.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR02CA0057.namprd02.prod.outlook.com
 (2603:10b6:a03:54::34) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by BYAPR02CA0057.namprd02.prod.outlook.com (2603:10b6:a03:54::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Thu, 22 Apr 2021 21:16:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e04b137e-7421-4b9b-b08f-08d905d3ebbd
X-MS-TrafficTypeDiagnostic: BYAPR10MB2870:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2870799BC7D81498D06CEC5C95469@BYAPR10MB2870.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XofztrtSrfSoUzK2p/dsQaGZ3909A0aqR9oXPcdbyXBHRs6P9iBKfttEZOtKCTc6FQr4Yed1hj6+HD2xHL9QxtAtk6Zc2B29u9Ub8uc0CRzQF/e7v4e6gU45CWxqtmB0onBFGTwWjJIr9uX24xEQxJwuY4e67hbpjd2rYdhN1MLk+lWnoqtihr7aFDLRALbHV+Cjp3yLkBnEgz8ZBClVumez5iikkFKWlHb5kQ2Co/fUDGApsakytSj0+epGZV2ZWTmnXdoZup/w1BJBHKKXJuGb7Hj28BqbOMyXGC6O0COixBcacTboAkb8eDvnMU2f+hA7HhssDtufc7L6srGaJHmEeyFMGHNYMHeVhRKyyieDCdf3oEDS7oDImRsAbBS2mx90u5HTVx65dwrOllXdoyaL4MrJJbDXCQesFJ1CzW6YPMOFxqQSFTOorNwZrye4EGsPY+Kp0NgRECiS0kuLobci++r7FJ7JYNUYXXraJOo+mMAmbFwDU02z88aPCSWltWLKK6vhSP+IpRTnmsXKAm5pdG2lt42J1vRUSTJycvHT9lt45CqGc+9QqEex+rwP+/7mgUN5kmj7mE5FAnv98/W/MR48KWYZN7b4DZWJ1aFai7REaNi29BJgBw3feZXPcy8sDG+B6YtCeqoYyY91xpDLCnjSQNKPScLurtqcIDro9udKZtlg+YcFBh3DUnWZkljfiUfZ/du7ZdymOJBviA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39860400002)(396003)(136003)(66476007)(44832011)(66946007)(31696002)(316002)(52116002)(6486002)(38350700002)(16576012)(83380400001)(86362001)(31686004)(66556008)(956004)(53546011)(38100700002)(36756003)(478600001)(16526019)(8936002)(5660300002)(2906002)(2616005)(26005)(4326008)(8676002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TlkzNlpWOE5wejZremFQZlhYM2ZtSVZrcHYzWWFsQXlwdWxoRlg5Q3Yxc00z?=
 =?utf-8?B?TmZpU1ZlZ2NvVVYzVnZ5M3lUUnA0ZEovUC9rKzBiNnpZM3RVNWZhYU5aUGhB?=
 =?utf-8?B?NTE2bFhvcE1FU05UVk84RG1jL2xKN24zZzRDMlZMQWFZTUs4S1Z2WWtacDFs?=
 =?utf-8?B?QnBnYy95dkV0c0R6WGZ0Q2JmdGZEc0JKM09zdHFpd3ZOYWplK0UxWHhDTWRR?=
 =?utf-8?B?VksvWlltTXhpU01SUVlIeFg1eDdBSzk1bFFocFdxNUNld0owUGplY1F6WEw4?=
 =?utf-8?B?NXV1ekZwQzd1RWJsdStYeTgwQXIzRGxjNFArZHo0MU92Z2pRYXNnZ0JXWWJu?=
 =?utf-8?B?czkvTE4xWkc2VjU2bGtTUHM4TmlRRXQ2YmJoTjhhSTZEUW5mbEo5S3Baa0lr?=
 =?utf-8?B?YjVZZWJhdk41bXJvQVlBUU1pN25NVlpEOG1YYTF2d3I3elhja2NVNkczdi9k?=
 =?utf-8?B?VmYvWFZnOHloN0hnODZCZFAxaWQ3Z2NMTzhqWWlNK2Rrb1BkR2ZKYTYvN005?=
 =?utf-8?B?ajNLMm5FTWtaZW1xUkJ6Ui9xSFZTK1hVVFIrRjFudjJjUjFHK2FmMTRQMHAy?=
 =?utf-8?B?S1NJS3BEUDJsVyt2K0plUWxkejJUY1AyTm1KeGtINVNHMlVGQ3BUc29FQ1JN?=
 =?utf-8?B?QXdxRUpXa0k1UkJOelcrYWJ2YXRPYThGU3pyUnk2S3o5dmpNYk1jbzh0VFM2?=
 =?utf-8?B?RE0yMUxkUi9SWXJTZVFnVkdBMmswRXJ5VVVRelVFc3FUM1I2V1k0bDhkSk5O?=
 =?utf-8?B?U0dGVWxKeUUxb1BydXI4UFgycnAvYjVGUzRSVDZXQ2d3d0VQVWJLYkpYelRv?=
 =?utf-8?B?QS9sN0JmalhjK0lXTlhaR0ZGbXVjZnV1cE55UExMYmpndXdlNWZtVjF0eXdP?=
 =?utf-8?B?aUo3WWJZMDJSU01lWXRvWk0reHBLdDZ6amMrM3N5Mmx6bU5GR0Vhci9RaEJQ?=
 =?utf-8?B?Q3B2REU1Uk1wK0NEbHdzL1lNSVdHUlFjbkc1Tnp0TXBZL2FTS0ZHN1FlRVpR?=
 =?utf-8?B?clJxR05ISGNOVS9SKzZ0YldwTVJUL0ZIc28ySlpiamZhdFA1WFpaaVdZMEJy?=
 =?utf-8?B?d2JYOGlNZFVrTHpvN2FjUGpWWE9YMDlHZm5TMjhMU2l1SG9KQXgyZmdjYk1r?=
 =?utf-8?B?SlJjQ084RW5ZZzYxWjFNMlFZb1BheStHVjlWaUNKeHhVSW1RbU5NZE9XeUt3?=
 =?utf-8?B?Z3NuKzhxeGNjeVFhWVBaWTh0cVZnM2Q3WFY4WEZGVmZjQzlEVk5QUUN4ekh3?=
 =?utf-8?B?eWltd3NtbVlQN3YybU5pM05Mblgrbjh3MUVDRmJjbDdWNzFFMVNQTVBZQmNL?=
 =?utf-8?B?R1ZZYjNtNDkzYmc0UVFOajdQcDhtMmdndk9ZRGRnS3BpNnhqUzRrNmZwQXpI?=
 =?utf-8?B?cDNIMElPRUtlU3lNSEdtUUNZUTl0eGtCQlVaeDFoRjR1RDdycytLdkR1YlhD?=
 =?utf-8?B?aVFwa2s2REdhaG40ODRLUk1aS0tEOHhxUEF6ODhRWjdBVzkxSUN0Z1RRSEo0?=
 =?utf-8?B?eFlTWG14d2V0c1VqMTBIdEFmSUxtTzhMekJTdDFEMmY3Sjd6VVkxQ1pnTnFF?=
 =?utf-8?B?Ulhwc3ZRb0JueThXMnpOZnQ3T1g0Q0U2VUNPWExHRUFqVGpadHFTaVFJck9O?=
 =?utf-8?B?RzVCWXFibXBNMlRYUjc1cmUwdFVSY1Q4SW9DNEdQTElrOXYvbDV3clpLMlFu?=
 =?utf-8?B?ZUZ3K3ZyUjEzQ0Q5OVBIajVzZEU2QWt6dWJNTlNQMkdZSGV2aTJqc2Fub2JZ?=
 =?utf-8?Q?oCo5/hBt2E1o7hzxPZreKMRp/48WC4NwSX/j1zG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e04b137e-7421-4b9b-b08f-08d905d3ebbd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 21:16:40.2673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wmIIAn+kuMYb6n4/UujR8VkhIZnGpfDWVWe/Jql1b8MHsPpJz6fWJxf7/1IACQl9XRytiE0Fd6aruQBkW2C0R/axUnzVGCDAc472W9WSW4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2870
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220158
X-Proofpoint-ORIG-GUID: C2HfYsmiPTEvcyGrMAI-U3RDwFPK4caV
X-Proofpoint-GUID: C2HfYsmiPTEvcyGrMAI-U3RDwFPK4caV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/20/21 5:23 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Teach fstests to extract timestamp limits of a filesystem using the new
> xfs_db timelimit command.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   common/rc         |    2 +-
>   common/xfs        |   19 +++++++++++++++++++
>   tests/xfs/911     |   44 ++++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/911.out |   15 +++++++++++++++
>   tests/xfs/group   |    1 +
>   5 files changed, 80 insertions(+), 1 deletion(-)
>   create mode 100755 tests/xfs/911
>   create mode 100644 tests/xfs/911.out
> 
> 
> diff --git a/common/rc b/common/rc
> index 11ff7635..116d7b20 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2124,7 +2124,7 @@ _filesystem_timestamp_range()
>   		echo "0 $u32max"
>   		;;
>   	xfs)
> -		echo "$s32min $s32max"
> +		_xfs_timestamp_range "$device"
>   		;;
>   	btrfs)
>   		echo "$s64min $s64max"
> diff --git a/common/xfs b/common/xfs
> index 3d660858..cb6a1978 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1165,3 +1165,22 @@ _require_scratch_xfs_inobtcount()
>   		_notrun "kernel doesn't support xfs inobtcount feature"
>   	_scratch_unmount
>   }
> +
> +_xfs_timestamp_range()
> +{
> +	local device="$1"
> +	local use_db=0
> +	local dbprog="$XFS_DB_PROG $device"
> +	test "$device" = "$SCRATCH_DEV" && dbprog=_scratch_xfs_db
> +
> +	$dbprog -f -c 'help timelimit' | grep -v -q 'not found' && use_db=1
> +	if [ $use_db -eq 0 ]; then
> +		# The "timelimit" command was added to xfs_db at the same time
> +		# that bigtime was added to xfsprogs.  Therefore, we can assume
> +		# the old timestamp range if the command isn't present.
> +		echo "-$((1<<31)) $(((1<<31)-1))"
> +	else
> +		$dbprog -f -c 'timelimit --compact' | \
> +			awk '{printf("%s %s", $1, $2);}'
> +	fi
> +}
> diff --git a/tests/xfs/911 b/tests/xfs/911
> new file mode 100755
> index 00000000..01ddb856
> --- /dev/null
> +++ b/tests/xfs/911
> @@ -0,0 +1,44 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 911
> +#
> +# Check that the xfs_db timelimit command prints the ranges that we expect.
> +# This in combination with an xfs_ondisk.h build time check in the kernel
> +# ensures that the kernel agrees with userspace.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_db_command timelimit
> +
> +rm -f $seqres.full
> +
> +# Format filesystem without bigtime support and populate it
> +_scratch_mkfs > $seqres.full
> +echo classic xfs timelimits
> +_scratch_xfs_db -c 'timelimit --classic'
> +echo bigtime xfs timelimits
> +_scratch_xfs_db -c 'timelimit --bigtime'
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/911.out b/tests/xfs/911.out
> new file mode 100644
> index 00000000..84dc475b
> --- /dev/null
> +++ b/tests/xfs/911.out
> @@ -0,0 +1,15 @@
> +QA output created by 911
> +classic xfs timelimits
> +time.min = -2147483648
> +time.max = 2147483647
> +dqtimer.min = 1
> +dqtimer.max = 4294967295
> +dqgrace.min = 0
> +dqgrace.min = 4294967295
> +bigtime xfs timelimits
> +time.min = -2147483648
> +time.max = 16299260424
> +dqtimer.min = 4
> +dqtimer.max = 16299260424
> +dqgrace.min = 0
> +dqgrace.min = 4294967295
> diff --git a/tests/xfs/group b/tests/xfs/group
> index bd47333c..b4e29bab 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -527,3 +527,4 @@
>   770 auto repair
>   773 auto quick repair
>   910 auto quick inobtcount
> +911 auto quick bigtime
> 
