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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 257D8C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 21:17:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E60E761406
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 21:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238922AbhDVVRg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Apr 2021 17:17:36 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:7314 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236851AbhDVVRf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Apr 2021 17:17:35 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13MLCvuF031289;
        Thu, 22 Apr 2021 21:16:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Dyh3TpyuDPKLOcZ9vEtOp07wTGKVQ+Rjr4Ypgn6bphs=;
 b=v5Y7dORjgKMouhoeMfqgikZ0Bz+2fKFQZdbAEykXGAu2GRMql9MqeUDCLlPWLVju4D6D
 gQ3mmcqN3PhcqPKpp+oCBOb1d2iKNCfvLzOGK9Okjd3DdcPGKWCFZosGNtSomcb8P9ym
 tsOUOwkR9+Wzjj0bEv+MoniFqdTR25/5pADLk+qXfZS50P+dcxSrENS8dwTqikTWYOEj
 +riTPBeu8EGMBttMPNvMcP5gZlmVK5O9/b9QCl6/QKMEFB8z0teBjgB3FwU9y25V92Hv
 mB9cVCUdVJRlvS3BxYRMBAOITUyp1Jdvde3tunWO7F/ARbPlgEq+/M4cbGgxVwzIkdtc kQ== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 382yqs8cvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 21:16:55 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 13MLEdkD079384;
        Thu, 22 Apr 2021 21:16:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by userp3030.oracle.com with ESMTP id 383cds4rp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 21:16:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bOlN54B1HolDH/KKUCSUtB1NLV/6rQunyXaETHdIWSwh46qc1S10iMb1PMpqyIuDeL9Q/lMJlJqdEs314B6ZgYZI145PK9tIVYMHH5RkhfLGGjYshf5qxtFmyNYCbzzdMcuPvU5OPE8TmzHL4uXUcnKz/I6pzn+2RxFxxZl11PlxQG5ITb+A6hxSO2yrx96QPpWneQdD0PP9yvyHbB7FezimL0UjsX7bwnbSAf1uyKeGSJ4TIA9un3k0amxkovnUTPa6XbDOHn4EqioLBS2zIIKKST8uWe9d9GGNBglq1D5pfMemTX5wKLMel0v4/fRbjaths1u6XvAckRrmIdvXSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dyh3TpyuDPKLOcZ9vEtOp07wTGKVQ+Rjr4Ypgn6bphs=;
 b=Xq9YwjQkhQxxn62XTqNiJb8qYZqMyBwqaMU7Q5Ne1x9JNhzEvAfMG2StiXJTcvjSjYCa57XUliiUbt4nKex0659YAGVwoAnxsA+cOo6cHFN62tkX2W3ctw/ynVGfH77TOXePUcS4VrRM/gv1FHJpkSHuza4AEhQIZ38xQiZWBoBmxOh5MCBxijsB1zsf6Wv10X4QMOkbPkP+n0HE+JnyNG+eSOa77ppY3auzT/buNl5DVJKis1J9LiER5BhwDG66JcTVqqNGtc0EWqoZ+0axsRnIgfJ2nMLaaImpd5MeIwZh7ORBCatqQoV9iWccSaNpGsuXVekHkt71ve826Lukvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dyh3TpyuDPKLOcZ9vEtOp07wTGKVQ+Rjr4Ypgn6bphs=;
 b=JJJNbpywb2Q+wWUYj+P+u7kpbpp4KDYjozmmeGz0R6Vn/9lFezzAyqU2aD6sXCTJhygpwlFqfimnjfhE2VJF6J7jdzQCfa1MGqMccI/qCVDF+0lrRXalMWeb5hSoc+aYlwPWtcGL9afzbww/5p+mrxUa4uz00pk2Szx0kyCeBmM=
Authentication-Results: eryu.me; dkim=none (message not signed)
 header.d=none;eryu.me; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2870.namprd10.prod.outlook.com (2603:10b6:a03:8d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.21; Thu, 22 Apr
 2021 21:16:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 21:16:51 +0000
Subject: Re: [PATCH 4/4] xfs: test upgrading filesystem to bigtime
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <161896458140.776452.9583732658582318883.stgit@magnolia>
 <161896460627.776452.15178871770338402214.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <829f9a06-1474-12b1-7d33-23d434c5f94c@oracle.com>
Date:   Thu, 22 Apr 2021 14:16:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <161896460627.776452.15178871770338402214.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR02CA0048.namprd02.prod.outlook.com
 (2603:10b6:a03:54::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by BYAPR02CA0048.namprd02.prod.outlook.com (2603:10b6:a03:54::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Thu, 22 Apr 2021 21:16:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14bfcb91-85b3-4246-21a5-08d905d3f2ac
X-MS-TrafficTypeDiagnostic: BYAPR10MB2870:
X-Microsoft-Antispam-PRVS: <BYAPR10MB287060AF1AC862DED98A52F795469@BYAPR10MB2870.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iH0k72SMu7Qcf2FZxO7b98xv5PJUC672w19hGHxGC68z/PzwQ7xjEtEHHjjmJ4bVTKUUVxHKGaWlI7qd4iVnFDRjNmFVOrKIeCq3+c5uS3TBBl7VWrXvIVEae2w32YGkvnsh/Y6mx7f9EaElp5wbIeUp2uQaSsMLM9cQXH/ZWBrKHCOb4LY2Wj6s479h8gH3gz0ftflH9a3blPEs8OCYOppG0JIaaNYFFrRW/SzKweT5lYO950StldJTMbh4RWWM+VRlL076XczVmqfnKz2lEjkbE4vvzlC5kQBSYfrV+yd6Noy6QczZ0Iq0oB+6nMZPebAefi48VXoSf/EZd6QgpokwtNEo9MKlhYwNRx5SQVnwfXfl8YuhByd3s4QsHM0KvmnVSKKmE6n0s3ZI026aeFsOK2LJxTS0Yggm34ASVdP4dQuaFv0s0W9vyIewzS/dCbfZazo2cIbpRIxYKLD6r1ikdKm+8R21GQFBAgKrKqped3CMn2oQXF7lv4bIEl4A9FH7bN2HYHHofGooeNNHHbDwVYZf1u3Uncl3JkHmV3bNY4GpNUuU+O0R5ywVB+XWFju7+ptcFbmSoDUpH2TVuWxTwuhTdsfKMEyFtDjUtQSiHa8CTyarEnKYSLyeuwhtcryBSKznJtO3o2Rm/MGGtmpM5Pxd4hfBSQbBqmpb+PKb1dIwhIIRL4lJfwlTt8ou1dIlGe6mtR4ckFwaPziYMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39860400002)(396003)(136003)(66476007)(44832011)(66946007)(31696002)(316002)(52116002)(6486002)(34290500002)(38350700002)(16576012)(83380400001)(86362001)(31686004)(66556008)(956004)(53546011)(38100700002)(36756003)(478600001)(16526019)(8936002)(5660300002)(2906002)(2616005)(26005)(30864003)(4326008)(8676002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L2FDMmFEQ1QrYlVkK1FEdHVQQnVVcHowNkZoUncvTFBsUjdFc3V2L3VJUUZn?=
 =?utf-8?B?dVRHbktnZ3YybW1GYWk3eERQTExLdCttMDNXaEUzbEQ3cFlWaVhqb0VkRDBl?=
 =?utf-8?B?NnRSc2ZPK3NpTC9yajRnTUN1SnJBcXFybWFwMmFEbjJ5bE5xQVlZbkhwWlQ4?=
 =?utf-8?B?QmYwYm9UTlcvQlV6V0FOREtVQktYKzNOak5DZkxwNHhESFJIY1pyL1puemdP?=
 =?utf-8?B?RXF3SWRsNjk0UDRlbFZueHd6bk9DRU9mb0NsQUVzRDJ4ZkNWdlFvRzhvMk5R?=
 =?utf-8?B?aUJlcEpBK1gyQUpuNEgvZVZJZEFwN3FKb3BGQndMWSttWmNSZklDRDNmVjVF?=
 =?utf-8?B?dUNjUEpqeGVPSkN5THhGbVBMd1VjZ2d3RDZjTHRZdWJ5dWdhWU9BT3ZBVlRN?=
 =?utf-8?B?ZnY0MUJLWXBTSysxaHRzZ1Vza0RkcWVvY2Fidm5CRTRZU3l3bWZTdjVPZTVu?=
 =?utf-8?B?QnU1ZlBEQWJVa2IzTmZnNWhXSlZaaWZmemxxMWdURnp6NU5Xc01VTGNManVz?=
 =?utf-8?B?bTltc3AzOXlIQVd1b0pSeUpkdWZndWlydmNkaU5JbU9JZGtqUEZua28zdUhG?=
 =?utf-8?B?SGppazZna1ptbmFlVmx0U0cyMytRZ0Y5SmNkOW5jSndLSHAvZnFQNE1pU1Aw?=
 =?utf-8?B?czJ6ZEx0d0p0VUtWa2pWR28yVEdzaFFjUFZtdlZhelVVNENxOWdMOG5kRXFm?=
 =?utf-8?B?eXljN1JuNnVpTmh1a0NFbW5Ec2xFanI5WDBPMXU5V0lEVitIZE1pSzlxUG9s?=
 =?utf-8?B?YVcrMVZaVW1jSSsrZ2RIVDRpMVlyd2lGYWlCb2FJUXZ6aExOa05WdE9lVEhD?=
 =?utf-8?B?Z2RKSGE5T3U1MWF0azhWMFV6YVVrSjVDWHRGeUc3aE02WVJZZDFXckN3eGQv?=
 =?utf-8?B?SFNlTXh2NVlpMnNMT3pJUDVWTnNldG8yZ05CRVQzNFZiMVpidXVlS3huYUNr?=
 =?utf-8?B?T00rNk9KeU9SdFkrZWJVNkFiWlFuNjVPQnRYL0d0bzFrYXpaV0xKRmkzWUxz?=
 =?utf-8?B?Qmg4NisrMGZsd3dYdXMwS284YWd0VTZjaGNnMDlGSFEwTmVKclQ0TW5iTlRm?=
 =?utf-8?B?cC9pbTJtMjFXSlZpbHZmcVVFcE1KNHh6bzE0eXdDR1hyZ1NZOElNcDRrZzRy?=
 =?utf-8?B?Qm9mdy80bWUvV0h2bnE2ZEd3S3BkbTFIam0zdkFnMDRzeTZleW8yYUhOcTcw?=
 =?utf-8?B?NlcwZW1hVGdkMEdHemZCU2VGWlQxZnZpemNJcGNXaExMRkNISzJYQjBNZU5Q?=
 =?utf-8?B?M3NMZk1EMmZLZHlpNXM0VGxiVjBGR0k3M0NZZVA3RHRIaXN6VlAvclM3aTVE?=
 =?utf-8?B?UkhEc3ZHSEpaR3A2SmdtcVNwVDBZNFhPblQvbklqU3YvMjhTSkNTV1RTUFlz?=
 =?utf-8?B?ZmM3cHNkaDZVaERFYW9MOStnQ0JtaWs3VUxTQXlmT3QxNFJmR21JWE5JRGVB?=
 =?utf-8?B?ZTdKSHNRU054ZmFOcHpWYWxXRDg2bW5pQ0h2dDZSV2FLTmxlUVV6Ymd2UnJT?=
 =?utf-8?B?Y1R4WjQ5WE5JbEs4VVVWQUE2bmFRQjU4dGpEMy9CZjlOaUt4cGdlcURUVjBQ?=
 =?utf-8?B?b21oZktpWWgwd1JhcU9oajJnMStlNU9IdlFoTzhvelNOcG9DQ0ZrSXYxTTJW?=
 =?utf-8?B?L003THlBMWpvYzZHQll1VXFIbE91YWpvRExDUm16QU4yYUVrQVJGSE1RekZk?=
 =?utf-8?B?WlRCbWFSMFVwdDFzc0dLTktxM2ZreTZWN0VvQWc1TUhBSmZnU2VkRmVITjh5?=
 =?utf-8?Q?IXyJGwvJojYdCNllUk+Ail0cQr9ZTJHLz0E7gZf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14bfcb91-85b3-4246-21a5-08d905d3f2ac
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 21:16:51.8744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KbDq0mCydPH9WBGTVRkGOUfPn2DaSxPfjHHjQoxc8x7qF5IRTTVNwpdsw5i+zMzkUfNHlI9F7kgieiAuPDR4O7kRYaag0F/l//q4zdlWZvA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2870
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220158
X-Proofpoint-ORIG-GUID: CFoZz05uQKfhCu5bx0po14O1HPpDuojQ
X-Proofpoint-GUID: CFoZz05uQKfhCu5bx0po14O1HPpDuojQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/20/21 5:23 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Test that we can upgrade an existing filesystem to use bigtime.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Ok, I think it looks good.  The comments help a lot
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   common/xfs        |   16 ++++++
>   tests/xfs/908     |  117 ++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/908.out |   29 ++++++++++
>   tests/xfs/909     |  149 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/909.out |    6 ++
>   tests/xfs/group   |    2 +
>   6 files changed, 319 insertions(+)
>   create mode 100755 tests/xfs/908
>   create mode 100644 tests/xfs/908.out
>   create mode 100755 tests/xfs/909
>   create mode 100644 tests/xfs/909.out
> 
> 
> diff --git a/common/xfs b/common/xfs
> index cb6a1978..253a31e5 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1184,3 +1184,19 @@ _xfs_timestamp_range()
>   			awk '{printf("%s %s", $1, $2);}'
>   	fi
>   }
> +
> +# Require that the scratch device exists, that mkfs can format with bigtime
> +# enabled, that the kernel can mount such a filesystem, and that xfs_info
> +# advertises the presence of that feature.
> +_require_scratch_xfs_bigtime()
> +{
> +	_require_scratch
> +
> +	_scratch_mkfs -m bigtime=1 &>/dev/null || \
> +		_notrun "mkfs.xfs doesn't support bigtime feature"
> +	_try_scratch_mount || \
> +		_notrun "kernel doesn't support xfs bigtime feature"
> +	$XFS_INFO_PROG "$SCRATCH_MNT" | grep -q -w "bigtime=1" || \
> +		_notrun "bigtime feature not advertised on mount?"
> +	_scratch_unmount
> +}
> diff --git a/tests/xfs/908 b/tests/xfs/908
> new file mode 100755
> index 00000000..004a8563
> --- /dev/null
> +++ b/tests/xfs/908
> @@ -0,0 +1,117 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 908
> +#
> +# Check that we can upgrade a filesystem to support bigtime and that inode
> +# timestamps work properly after the upgrade.
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
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> +_require_scratch_xfs_bigtime
> +_require_xfs_repair_upgrade bigtime
> +
> +date --date='Jan 1 00:00:00 UTC 2040' > /dev/null 2>&1 || \
> +	_notrun "Userspace does not support dates past 2038."
> +
> +rm -f $seqres.full
> +
> +# Make sure we can't upgrade a V4 filesystem
> +_scratch_mkfs -m crc=0 >> $seqres.full
> +_scratch_xfs_admin -O bigtime=1 2>> $seqres.full
> +_check_scratch_xfs_features BIGTIME
> +
> +# Make sure we're required to specify a feature status
> +_scratch_mkfs -m crc=1,bigtime=0,inobtcount=0 >> $seqres.full
> +_scratch_xfs_admin -O bigtime 2>> $seqres.full
> +
> +# Can we add bigtime and inobtcount at the same time?
> +_scratch_mkfs -m crc=1,bigtime=0,inobtcount=0 >> $seqres.full
> +_scratch_xfs_admin -O bigtime=1,inobtcount=1 2>> $seqres.full
> +
> +# Format V5 filesystem without bigtime support and populate it
> +_scratch_mkfs -m crc=1,bigtime=0 >> $seqres.full
> +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +touch -d 'Jan 9 19:19:19 UTC 1999' $SCRATCH_MNT/a
> +touch -d 'Jan 9 19:19:19 UTC 1999' $SCRATCH_MNT/b
> +ls -la $SCRATCH_MNT/* >> $seqres.full
> +
> +echo before upgrade:
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> +
> +_scratch_unmount
> +_check_scratch_fs
> +
> +# Now upgrade to bigtime support
> +_scratch_xfs_admin -O bigtime=1 2>> $seqres.full
> +_check_scratch_xfs_features BIGTIME
> +_check_scratch_fs
> +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> +
> +# Mount again, look at our files
> +_scratch_mount >> $seqres.full
> +ls -la $SCRATCH_MNT/* >> $seqres.full
> +
> +echo after upgrade:
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> +
> +# Bump one of the timestamps but stay under 2038
> +touch -d 'Jan 10 19:19:19 UTC 1999' $SCRATCH_MNT/a
> +
> +echo after upgrade and bump:
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> +
> +_scratch_cycle_mount
> +
> +# Did the bumped timestamp survive the remount?
> +ls -la $SCRATCH_MNT/* >> $seqres.full
> +
> +echo after upgrade, bump, and remount:
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> +
> +# Modify the other timestamp to stretch beyond 2038
> +touch -d 'Feb 22 22:22:22 UTC 2222' $SCRATCH_MNT/b
> +
> +echo after upgrade and extension:
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> +
> +_scratch_cycle_mount
> +
> +# Did the timestamp survive the remount?
> +ls -la $SCRATCH_MNT/* >> $seqres.full
> +
> +echo after upgrade, extension, and remount:
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/908.out b/tests/xfs/908.out
> new file mode 100644
> index 00000000..5e05854d
> --- /dev/null
> +++ b/tests/xfs/908.out
> @@ -0,0 +1,29 @@
> +QA output created by 908
> +Running xfs_repair to upgrade filesystem.
> +Large timestamp feature only supported on V5 filesystems.
> +FEATURES: BIGTIME:NO
> +Running xfs_repair to upgrade filesystem.
> +Running xfs_repair to upgrade filesystem.
> +Adding inode btree counts to filesystem.
> +Adding large timestamp support to filesystem.
> +before upgrade:
> +915909559
> +915909559
> +Running xfs_repair to upgrade filesystem.
> +Adding large timestamp support to filesystem.
> +FEATURES: BIGTIME:YES
> +after upgrade:
> +915909559
> +915909559
> +after upgrade and bump:
> +915995959
> +915909559
> +after upgrade, bump, and remount:
> +915995959
> +915909559
> +after upgrade and extension:
> +915995959
> +7956915742
> +after upgrade, extension, and remount:
> +915995959
> +7956915742
> diff --git a/tests/xfs/909 b/tests/xfs/909
> new file mode 100755
> index 00000000..66587aa7
> --- /dev/null
> +++ b/tests/xfs/909
> @@ -0,0 +1,149 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 909
> +#
> +# Check that we can upgrade a filesystem to support bigtime and that quota
> +# timers work properly after the upgrade.
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
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> +_require_quota
> +_require_scratch_xfs_bigtime
> +_require_xfs_repair_upgrade bigtime
> +
> +date --date='Jan 1 00:00:00 UTC 2040' > /dev/null 2>&1 || \
> +	_notrun "Userspace does not support dates past 2038."
> +
> +rm -f $seqres.full
> +
> +# Format V5 filesystem without bigtime support and populate it
> +_scratch_mkfs -m crc=1,bigtime=0 >> $seqres.full
> +_qmount_option "usrquota"
> +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +# Force the block counters for uid 1 and 2 above zero
> +_pwrite_byte 0x61 0 64k $SCRATCH_MNT/a >> $seqres.full
> +_pwrite_byte 0x61 0 64k $SCRATCH_MNT/b >> $seqres.full
> +sync
> +chown 1 $SCRATCH_MNT/a
> +chown 2 $SCRATCH_MNT/b
> +
> +# Set quota limits on uid 1 before upgrading
> +$XFS_QUOTA_PROG -x -c 'limit -u bsoft=12k bhard=1m 1' $SCRATCH_MNT
> +
> +# Make sure the grace period is at /some/ point in the future.  We have to
> +# use bc because not all bashes can handle integer comparisons with 64-bit
> +# numbers.
> +repquota -upn $SCRATCH_MNT > $tmp.repquota
> +cat $tmp.repquota >> $seqres.full
> +grace="$(cat $tmp.repquota | grep '^#1' | awk '{print $6}')"
> +now="$(date +%s)"
> +res="$(echo "${grace} > ${now}" | $BC_PROG)"
> +test $res -eq 1 || echo "Expected timer expiry (${grace}) to be after now (${now})."
> +
> +_scratch_unmount
> +
> +# Now upgrade to bigtime support
> +_scratch_xfs_admin -O bigtime=1 2>> $seqres.full
> +_check_scratch_xfs_features BIGTIME
> +_check_scratch_fs
> +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> +
> +# Mount again, see if our quota timer survived
> +_scratch_mount
> +
> +# Set a very generous grace period and quota limits on uid 2 after upgrading
> +$XFS_QUOTA_PROG -x -c 'timer -u -b -d 2147483647' $SCRATCH_MNT
> +$XFS_QUOTA_PROG -x -c 'limit -u bsoft=10000 bhard=150000 2' $SCRATCH_MNT
> +
> +# Query the grace periods to see if they got set properly after the upgrade.
> +repquota -upn $SCRATCH_MNT > $tmp.repquota
> +cat $tmp.repquota >> $seqres.full
> +grace1="$(repquota -upn $SCRATCH_MNT | grep '^#1' | awk '{print $6}')"
> +grace2="$(repquota -upn $SCRATCH_MNT | grep '^#2' | awk '{print $6}')"
> +now="$(date +%s)"
> +
> +# Make sure that uid 1's expiration is in the future...
> +res1="$(echo "${grace} > ${now}" | $BC_PROG)"
> +test "${res1}" -eq 1 || echo "Expected uid 1 expiry (${grace1}) to be after now (${now})."
> +
> +# ...and that uid 2's expiration is after uid 1's...
> +res2="$(echo "${grace2} > ${grace1}" | $BC_PROG)"
> +test "${res2}" -eq 1 || echo "Expected uid 2 expiry (${grace2}) to be after uid 1 (${grace1})."
> +
> +# ...and that uid 2's expiration is after 2038 if right now is far enough
> +# past 1970 that our generous grace period would provide for that.
> +res3="$(echo "(${now} < 100) || (${grace2} > 2147483648)" | $BC_PROG)"
> +test "${res3}" -eq 1 || echo "Expected uid 2 expiry (${grace2}) to be after 2038."
> +
> +_scratch_cycle_mount
> +
> +# Query the grace periods to see if they survived a remount.
> +repquota -upn $SCRATCH_MNT > $tmp.repquota
> +cat $tmp.repquota >> $seqres.full
> +grace1="$(repquota -upn $SCRATCH_MNT | grep '^#1' | awk '{print $6}')"
> +grace2="$(repquota -upn $SCRATCH_MNT | grep '^#2' | awk '{print $6}')"
> +now="$(date +%s)"
> +
> +# Make sure that uid 1's expiration is in the future...
> +res1="$(echo "${grace} > ${now}" | $BC_PROG)"
> +test "${res1}" -eq 1 || echo "Expected uid 1 expiry (${grace1}) to be after now (${now})."
> +
> +# ...and that uid 2's expiration is after uid 1's...
> +res2="$(echo "${grace2} > ${grace1}" | $BC_PROG)"
> +test "${res2}" -eq 1 || echo "Expected uid 2 expiry (${grace2}) to be after uid 1 (${grace1})."
> +
> +# ...and that uid 2's expiration is after 2038 if right now is far enough
> +# past 1970 that our generous grace period would provide for that.
> +res3="$(echo "(${now} < 100) || (${grace2} > 2147483648)" | $BC_PROG)"
> +test "${res3}" -eq 1 || echo "Expected uid 2 expiry (${grace2}) to be after 2038."
> +
> +# Now try setting uid 2's expiration to Feb 22 22:22:22 UTC 2222
> +new_expiry=$(date -d 'Feb 22 22:22:22 UTC 2222' +%s)
> +now=$(date +%s)
> +test $now -ge $new_expiry && \
> +	echo "Now is after February 2222?  Expect problems."
> +expiry_delta=$((new_expiry - now))
> +
> +echo "setting expiration to $new_expiry - $now = $expiry_delta" >> $seqres.full
> +$XFS_QUOTA_PROG -x -c "timer -u $expiry_delta 2" -c 'report' $SCRATCH_MNT >> $seqres.full
> +
> +# Did we get an expiration within 5s of the target range?
> +grace2="$(repquota -upn $SCRATCH_MNT | grep '^#2' | awk '{print $6}')"
> +echo "grace2 is $grace2" >> $seqres.full
> +_within_tolerance "grace2 expiry" $grace2 $new_expiry 5 -v
> +
> +_scratch_cycle_mount
> +
> +# ...and is it still within 5s after a remount?
> +grace2="$(repquota -upn $SCRATCH_MNT | grep '^#2' | awk '{print $6}')"
> +echo "grace2 is $grace2" >> $seqres.full
> +_within_tolerance "grace2 expiry after remount" $grace2 $new_expiry 5 -v
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/909.out b/tests/xfs/909.out
> new file mode 100644
> index 00000000..72bf2416
> --- /dev/null
> +++ b/tests/xfs/909.out
> @@ -0,0 +1,6 @@
> +QA output created by 909
> +Running xfs_repair to upgrade filesystem.
> +Adding large timestamp support to filesystem.
> +FEATURES: BIGTIME:YES
> +grace2 expiry is in range
> +grace2 expiry after remount is in range
> diff --git a/tests/xfs/group b/tests/xfs/group
> index b4e29bab..49bc4016 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -526,5 +526,7 @@
>   768 auto quick repair
>   770 auto repair
>   773 auto quick repair
> +908 auto quick bigtime
> +909 auto quick bigtime quota
>   910 auto quick inobtcount
>   911 auto quick bigtime
> 
