Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ECC3C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 05:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21BB864EBB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 05:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhBXFkl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 00:40:41 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48882 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbhBXFk2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 00:40:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11O5dcsY070664;
        Wed, 24 Feb 2021 05:39:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=B/08PUJQhBvOa2kRxImsWIQecxmDdqdqK/xvLFt9dVs=;
 b=baGpt05O1c7WvL2mT/rLBOIjzA1LumISl0hQ0yIlA0not12MlMTNhWAlPbB6tZ95OtQ/
 Vau2q/JI31Y7Ab9KWqWSnMlwbwv1vES13o/Mjot5AVqMt8Fs8e3P07BbTMGDwC3tDHvv
 mIHuaN2vrzaXMPxZMwVrRki52ytL/hBqrhqSg0x4cy7e5YwXcuQbPsFizR46obbkhoY4
 veBDs0MHfXqB4/87QaOcGYzNtxgRuPlCZl1BrTNv5/IXVefq5ldUgFP7DURLSaz4Wk4u
 eWOqNsBJ8NGNxDlKK0LUmRwk+jnXluTsX2K5lxxfVHxDAMAbHrsQERoWjLDCJbEwkx6k fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36tsur1prt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 05:39:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11O5a9Lx031749;
        Wed, 24 Feb 2021 05:39:37 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by userp3020.oracle.com with ESMTP id 36uc6sp3ev-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 05:39:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y8V0S3q6xiuNDADkbwY9wSOZbk1q/WNozajIt4rniVcClqnDU49YksJHc/I0OjR4ZeDsB+3SyVaFD3jPCx7SXsKrfSf74uVS7PrzFRnbnXCW+HF4cUw1+vhfmEYm7CTmtWxNkguZ4bZOsb6RlrDYnT0tWinF04bbM2bJWpq/sYRgLBrZdK2sbP0IPjfJD9JT/UYm+sIRu75zaUytWAwXo6/mszuEOPlyh4IOm+0Zreo4b2vVaAwH7wbl/waDsqqyPML1p5oKTHLVMha/S4PFpp5GVuHV/83ALGFki8mci8WJfvG4Bu0oV1DgTRgbA/QK5wpvsp69IgHgCM1mbmAg5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/08PUJQhBvOa2kRxImsWIQecxmDdqdqK/xvLFt9dVs=;
 b=B3+Lss8mKCqmJOXpMBJUmJaMKOWiIBZr1YETm11/qInz8SUThIw9BIGgFsCo8f5c80au14z0m26sMt7YMsCvKJCGkMcSsQ72k1Sguhzj0CT0z4eFgISiwaVbTNeiignXuPuA8DMNXrX+YeJSPAvilflSp1TmEq7tmpPKFe6wpNrtEWAiaLWwuC2YBXLc3HVUo6Y5r+m/tDLUFllMme8EGpu3DOqkDtCMwMC4Cce7W5xyDaP+F1gtwMQ1Kt6TVxSqlTHKRMQBIbEfYQblZzPhLILZ13O8dhOKOPF3IebhFWUKd/EQFZo3iiUliTjMF+4TkjEOXWEb0W7AbP9SDoEeXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/08PUJQhBvOa2kRxImsWIQecxmDdqdqK/xvLFt9dVs=;
 b=vzDDzFtzqnNwLbQxSIZk6c2q6Cv1kTd8MPmnmGJKTe2Fvq6h2w2n8Q7zAH3YoOn6LTvoLXE49E/eprVuBFj3z8fDSLTcgV5QxRtltY4XPpOKeSu5FWfwxXqUyvvHJf+1SiQavr59GBgIhjuu2mslhZR/3khhIE5FNc7CIoM27Wc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2437.namprd10.prod.outlook.com (2603:10b6:a02:b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Wed, 24 Feb
 2021 05:39:36 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.019; Wed, 24 Feb 2021
 05:39:36 +0000
Subject: Re: [PATCH 2/4] libxfs: simulate system failure after a certain
 number of writes
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <161404926046.425602.766097344183886137.stgit@magnolia>
 <161404927196.425602.4393417228179099132.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <f03d8e66-efe9-f8f1-42ec-81ef67e1f9b0@oracle.com>
Date:   Tue, 23 Feb 2021 22:39:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <161404927196.425602.4393417228179099132.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0088.namprd03.prod.outlook.com
 (2603:10b6:a03:331::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR03CA0088.namprd03.prod.outlook.com (2603:10b6:a03:331::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend Transport; Wed, 24 Feb 2021 05:39:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14e343ef-d853-48f9-3312-08d8d8869241
X-MS-TrafficTypeDiagnostic: BYAPR10MB2437:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2437BD8CAE3A36E92D0AFDBF959F9@BYAPR10MB2437.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:69;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CLa1UMgPAflhZMOl4JCrG513jee6lyB0fVRBAcOo9bKxebPTKtFVD8IrXqR2RNhYn2L711MzNz/1HoF+oifdb3QaOzfraiKWkdBGIYXznjDai3mmRlmgZkuqPmQXiqLbECpvsG8rQPKtuXgyyJg+/WJv91EVRd9yCkD2+NX9rqI/WbPgEpGQvIkOWvVkHH4BJOAF78ltuDJpG8J9kHfc8LuMFwk3sqgg0HlUD2pHx7l0p59CBze9KUxzOz3NbjsED3F56ctADWROJf3JmrVaH+zk9vXo4qwXgz11j5YL8I6KcuE7zfzyaArTBZzJWMT8N+xdSbwdFn8NAa1ARjeLxZQH6IqaFLZtJz/OcnyHP+uar2Fik+cyARR+m8ECoT6RGlGoXMeChRyRWwnN/QQbJMJ+WGS0UTSOto/4AyWHRy/1SZptiAyo9eTUP3jB469l+JUZ/GNX/BsHUChLNeFwnqcFT5XRZJs4kNkR38e+sKPsfQXWiqEBFhkWtdJH0kd3TEkm/vvFl1Aw6kvXlN7X/keK2V4jjSrpBmpIuNlQytaap2310iNR1f/nximTrNq+7FJpubxUJabuZen8e6q5K7ztdzghtbTURgSMPQNtYKA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(396003)(376002)(8676002)(316002)(26005)(66476007)(2906002)(4326008)(478600001)(8936002)(16526019)(186003)(5660300002)(53546011)(52116002)(956004)(44832011)(66556008)(83380400001)(2616005)(36756003)(66946007)(16576012)(6486002)(31696002)(31686004)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OStHbHBxMTE0QmhXN2FYSU1HbWlYdFhVOVRwdEtTcCtGZUo4M1ZTYTk4dGZh?=
 =?utf-8?B?WGdPZDlUcFZQSFNybk93WHFyWWVTVjd3NTYxdUM4ZTF2bzlyMFZOUUd3MGNk?=
 =?utf-8?B?eWdkWDFhQjZMRUxsbmhHdEpqZkNkYUt3VFZoOXB5Wkg1NENLVTF6WmdzbDBM?=
 =?utf-8?B?V0V5RkRFQk1uK1JUWkE5NWRlMFV3SnR4dVc5Z0hiemFEZHlKajBnYkp2eHli?=
 =?utf-8?B?V1IzLzVJcG5vMTVPOGZKLyt1c0tQSjFNVG9YNUtXcjNXZ0ZYR3VQaTB4NzRt?=
 =?utf-8?B?bThRVHA4bTBxN0xCQ092b1Y0U2srMEE1VGxNczFqWHg3WVhVWXZxdU91clpi?=
 =?utf-8?B?cWdRbGo1L2hxMnVWU2p0T1NieGVVRzJEajRMQjhiTWp0N0xoSkx5M0hLUFBY?=
 =?utf-8?B?ZGlPMnhBRVZmZnJyaDhnd0tUek1jTVdvRVpGVHhGMnZ2UG9TVkppYVYvSStU?=
 =?utf-8?B?UkN4Z3ZnTDVncFk0a3dCcFFBRDVOajBIYUZ0QTUvT3JOWmtzVkxtcjJRZUp3?=
 =?utf-8?B?bHVRdEcrOUwwS01YTGVQSnRmZjVPSkpMdDZETTNLdmVoV0xndXRXVUxvV1hM?=
 =?utf-8?B?WUdHZCtlSWJiWFBPVk42Sng3UlhHdGJDL1p5M0ZvQzRuV2N5NVpXWU04V0o1?=
 =?utf-8?B?VldMOFJyOHpPNWlEZHdwK0hocXdzZ2paZjlsY2lGdDNnZzlsQVZwcWNHZVJ4?=
 =?utf-8?B?T1VmUTROaWpvSTYxR1FaZUNML3laUm1NZk94VVhyODQyUStQM3c5T1MvSHE0?=
 =?utf-8?B?aSthYzhTcHFrTW9ITndISFdhemEzRG84Q0hCc3RXaHlOQkdBOXExZWEwNzFq?=
 =?utf-8?B?S0JzM0lIYXVZZ0Zpck9TdHdndUYwQytTYlJJRlVMOUU2OEU2S0dKRkxDUUYw?=
 =?utf-8?B?UVJyZXR3VmdMNWNLV0luZGRxakVsdG0xQWQxWjVkSUFLNTdBWldNbUFaTUxE?=
 =?utf-8?B?SkxFMVE0eUpEc3lYRXMrNEFTekVQT3AvYVE1dURlbE02ek04N2VWaDk4QmdX?=
 =?utf-8?B?eVFUTEg3NW1jUnhkTkxOOGhoRm4wQWRoU2crY0wvRWFxYkF2U2tsSSszanJC?=
 =?utf-8?B?TGdMTi9GQkFtV1o3QWJHd3J2blRRNWJFdnJZcHFMa2hodk1UMUE2Skw4V0tP?=
 =?utf-8?B?RFp4Uk5FZWMyWStUbzlpVHJYd0wrSzA4dmNyUjFGS1pWNGN2VEU5UlJlVm42?=
 =?utf-8?B?eEhid09FZHZaYUovNnBRY0NUdWszWEtXWkVGZng5YTRRYVI3bFRGWllneUNr?=
 =?utf-8?B?VEU4SGd5eFdPL291VjVyR0VLTEdEWXBBeHplZzMyNW9TWWZOZ0Q5MDlYazQ0?=
 =?utf-8?B?eTRyR0U2bzhQM2xETGoxSmFSaHN1bFhIZGZRZVJCeExnUmQ4SlNFWnF5VndX?=
 =?utf-8?B?VGo0WHRvL2IwUERpNG1Fb2FaMGpFbVhLQzZ2TWlHSVlvSHNkYVdhK3ZvUDNY?=
 =?utf-8?B?T3VxUUFlQ3doSnBBK2tvZXFaY1FqWmV3OXFLUG9hNGc3d1VUVGRYYU9PM2RB?=
 =?utf-8?B?My9pQUFGelNXRmZvS1UvTjVCZmZNeWlObmFjc2FqczZaSU9sVy9jLzF0MVB5?=
 =?utf-8?B?SlNzRGVpeUJrMGxvT0ZWVzBiM0s0N3hYcW1rTG1ETG1XUzQ4SVJPaUFOYnIz?=
 =?utf-8?B?QUZlT25jQ3RlSnBhN2J0SGhMUlBsTzQ0SmJuWlF1Q3lHWXRkTExNa2x4aWZM?=
 =?utf-8?B?ak5COW15WmdjMDF1RjcwZnNsMTFNMzlpc2NISC8vTTlyeTBQOFVOWmlDWllJ?=
 =?utf-8?Q?xu+46JKpzp8Fp//12IGz9USbVorYz9NqS9lT/Ci?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14e343ef-d853-48f9-3312-08d8d8869241
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 05:39:36.5561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Azok+EPZww0OGyvCaO1oBf+mhcVyxj0uoeZWlmV/F+3kTvsXPCiaM/yLLka1O02zj4ykWHaH2jFYyqdyX1FSp1F0As4+/C/XQsmDuAw2HPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2437
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102240045
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102240046
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/22/21 8:01 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add an error injection knob so that we can simulate system failure after
> a certain number of disk writes.  This knob is being added so that we
> can check repair's behavior after an arbitrary number of tests.
> 
> Set LIBXFS_DEBUG_WRITE_CRASH={ddev,logdev,rtdev}=nn in the environment
> to make libxfs SIGKILL itself after nn writes to the data, log, or rt
> devices.  Note that this only applies to xfs_buf writes and zero_range.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   include/linux.h    |   13 ++++++++++
>   libxfs/init.c      |   68 +++++++++++++++++++++++++++++++++++++++++++++++++---
>   libxfs/libxfs_io.h |   19 +++++++++++++++
>   libxfs/rdwr.c      |    6 ++++-
>   4 files changed, 101 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/include/linux.h b/include/linux.h
> index 03b3278b..7bf59e07 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -31,6 +31,8 @@
>   #ifdef OVERRIDE_SYSTEM_FSXATTR
>   # undef fsxattr
>   #endif
> +#include <unistd.h>
> +#include <assert.h>
>   
>   static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
>   {
> @@ -186,6 +188,17 @@ platform_zero_range(
>   #define platform_zero_range(fd, s, l)	(-EOPNOTSUPP)
>   #endif
>   
> +/*
> + * Use SIGKILL to simulate an immediate program crash, without a chance to run
> + * atexit handlers.
> + */
> +static inline void
> +platform_crash(void)
> +{
> +	kill(getpid(), SIGKILL);
> +	assert(0);
> +}
> +
>   /*
>    * Check whether we have to define FS_IOC_FS[GS]ETXATTR ourselves. These
>    * are a copy of the definitions moved to linux/uapi/fs.h in the 4.5 kernel,
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 8a8ce3c4..1ec83791 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -590,7 +590,8 @@ libxfs_initialize_perag(
>   static struct xfs_buftarg *
>   libxfs_buftarg_alloc(
>   	struct xfs_mount	*mp,
> -	dev_t			dev)
> +	dev_t			dev,
> +	unsigned long		write_fails)
>   {
>   	struct xfs_buftarg	*btp;
>   
> @@ -603,10 +604,29 @@ libxfs_buftarg_alloc(
>   	btp->bt_mount = mp;
>   	btp->bt_bdev = dev;
>   	btp->flags = 0;
> +	if (write_fails) {
> +		btp->writes_left = write_fails;
> +		btp->flags |= XFS_BUFTARG_INJECT_WRITE_FAIL;
> +	}
> +	pthread_mutex_init(&btp->lock, NULL);
>   
>   	return btp;
>   }
>   
> +enum libxfs_write_failure_nums {
> +	WF_DATA = 0,
> +	WF_LOG,
> +	WF_RT,
> +	WF_MAX_OPTS,
> +};
> +
> +static char *wf_opts[] = {
> +	[WF_DATA]		= "ddev",
> +	[WF_LOG]		= "logdev",
> +	[WF_RT]			= "rtdev",
> +	[WF_MAX_OPTS]		= NULL,
> +};
> +
>   void
>   libxfs_buftarg_init(
>   	struct xfs_mount	*mp,
> @@ -614,6 +634,46 @@ libxfs_buftarg_init(
>   	dev_t			logdev,
>   	dev_t			rtdev)
>   {
> +	char			*p = getenv("LIBXFS_DEBUG_WRITE_CRASH");
> +	unsigned long		dfail = 0, lfail = 0, rfail = 0;
> +
> +	/* Simulate utility crash after a certain number of writes. */
> +	while (p && *p) {
> +		char *val;
> +
> +		switch (getsubopt(&p, wf_opts, &val)) {
> +		case WF_DATA:
> +			if (!val) {
> +				fprintf(stderr,
> +		_("ddev write fail requires a parameter\n"));
> +				exit(1);
> +			}
> +			dfail = strtoul(val, NULL, 0);
> +			break;
> +		case WF_LOG:
> +			if (!val) {
> +				fprintf(stderr,
> +		_("logdev write fail requires a parameter\n"));
> +				exit(1);
> +			}
> +			lfail = strtoul(val, NULL, 0);
> +			break;
> +		case WF_RT:
> +			if (!val) {
> +				fprintf(stderr,
> +		_("rtdev write fail requires a parameter\n"));
> +				exit(1);
> +			}
> +			rfail = strtoul(val, NULL, 0);
> +			break;
> +		default:
> +			fprintf(stderr, _("unknown write fail type %s\n"),
> +					val);
> +			exit(1);
> +			break;
> +		}
> +	}
> +
>   	if (mp->m_ddev_targp) {
>   		/* should already have all buftargs initialised */
>   		if (mp->m_ddev_targp->bt_bdev != dev ||
> @@ -647,12 +707,12 @@ libxfs_buftarg_init(
>   		return;
>   	}
>   
> -	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, dev);
> +	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, dev, dfail);
>   	if (!logdev || logdev == dev)
>   		mp->m_logdev_targp = mp->m_ddev_targp;
>   	else
> -		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, logdev);
> -	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, rtdev);
> +		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, logdev, lfail);
> +	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, rtdev, rfail);
>   }
>   
>   /*
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index c80e2d59..3cc4f4ee 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -22,6 +22,8 @@ struct xfs_perag;
>    */
>   struct xfs_buftarg {
>   	struct xfs_mount	*bt_mount;
> +	pthread_mutex_t		lock;
> +	unsigned long		writes_left;
>   	dev_t			bt_bdev;
>   	unsigned int		flags;
>   };
> @@ -30,6 +32,23 @@ struct xfs_buftarg {
>   #define XFS_BUFTARG_LOST_WRITE		(1 << 0)
>   /* A dirty buffer failed the write verifier. */
>   #define XFS_BUFTARG_CORRUPT_WRITE	(1 << 1)
> +/* Simulate failure after a certain number of writes. */
> +#define XFS_BUFTARG_INJECT_WRITE_FAIL	(1 << 2)
> +
> +/* Simulate the system crashing after a certain number of writes. */
> +static inline void
> +xfs_buftarg_trip_write(
> +	struct xfs_buftarg	*btp)
> +{
> +	if (!(btp->flags & XFS_BUFTARG_INJECT_WRITE_FAIL))
> +		return;
> +
> +	pthread_mutex_lock(&btp->lock);
> +	btp->writes_left--;
> +	if (!btp->writes_left)
> +		platform_crash();
> +	pthread_mutex_unlock(&btp->lock);
> +}
>   
>   extern void	libxfs_buftarg_init(struct xfs_mount *mp, dev_t ddev,
>   				    dev_t logdev, dev_t rtdev);
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index ca272387..fd456d6b 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -74,8 +74,10 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
>   	/* try to use special zeroing methods, fall back to writes if needed */
>   	len_bytes = LIBXFS_BBTOOFF64(len);
>   	error = platform_zero_range(fd, start_offset, len_bytes);
> -	if (!error)
> +	if (!error) {
> +		xfs_buftarg_trip_write(btp);
>   		return 0;
> +	}
>   
>   	zsize = min(BDSTRAT_SIZE, BBTOB(len));
>   	if ((z = memalign(libxfs_device_alignment(), zsize)) == NULL) {
> @@ -105,6 +107,7 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
>   				progname, __FUNCTION__);
>   			exit(1);
>   		}
> +		xfs_buftarg_trip_write(btp);
>   		offset += bytes;
>   	}
>   	free(z);
> @@ -860,6 +863,7 @@ libxfs_bwrite(
>   	} else {
>   		bp->b_flags |= LIBXFS_B_UPTODATE;
>   		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_UNCHECKED);
> +		xfs_buftarg_trip_write(bp->b_target);
>   	}
>   	return bp->b_error;
>   }
> 
