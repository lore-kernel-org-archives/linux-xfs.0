Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590BDC47082
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 22:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 418BA61404
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 22:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhFCWbp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 18:31:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53126 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbhFCWbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 18:31:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153MJvUZ181313;
        Thu, 3 Jun 2021 22:29:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=+dbRXwGTFsE5033H3t/7yUa8DC/XJlg9r60yD3F6EqY=;
 b=KSinYo/sp9I4AM12fjfZWdjNsB2B/AyVhPEP4qXpr4ZNBW8shaRmfRbnWtK1VlaHe/Vj
 zuYrPEs3jpZuqXC02je5fxshmOCBPPwFrk0154tnjSCKO7rXwVyNOZjAVgJAqU+v67BD
 8mCz+ecBMaAciPsLqg6KG94HhALjSLS24e4JwIjVMwnIL9TOgShuMIantF7qlnhPT5Fz
 NlJjxgtOwhfXqZ5pBXaaeTU5htVztq+lEe3H0m+KOQ5jdVOwWgmZLxBDcVcqriOuDozX
 AiMyi6/i91EN3sWO4WqXN28Pwh0czBRZDe3XSopqwqxG1obQJ9u4/UoIRNv+Dp0UEafb 0A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38ue8pmj55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 22:29:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153MK7lX031472;
        Thu, 3 Jun 2021 22:29:58 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by userp3030.oracle.com with ESMTP id 38uaqypcur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 22:29:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVWijhH+lz/ISKHz69DmjcEtMbboRnBKbICPbjxPSyV59cklpIA13ilY1HOg2wDDFYfiUiivXpy/+EF/BjVQtSXhUjYi4JTpYSlfQ+SfyttGavFZbQby4omM10jQRSSpCoEuL/ywib9Bmj25IMA04elpuNa2/jxpKofv1M57hv4Bqf7VCoJmDJTRPlGN19e4FxDTYRvidaTG+rWozaVBboTPKoNsF5CV5n9Y2boKCj2/fONIvm1glIPD1Ok3D74LuMZSVl9jlzM93kOOBdf9oA4AuDGV+iuieYHe8aIfbjDdzeD7KGiD7ctEtit00DUIxPIHxhxDJk8Tk12VDoTE8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dbRXwGTFsE5033H3t/7yUa8DC/XJlg9r60yD3F6EqY=;
 b=gCScOSfQekU7PoHr0KCj2dD81HmJu19qnDYPyZIsU2KSlkfx0OylyI5nD7wwtSzkmweSjFZu6aIjAIyPR8cpxdyaJZMS70lhsGPtERVwZcFG7SXk+B0yf35c0jV/H75tYQ9e2bcfiHjHP+ZDq6UT1EPLwwBjnsOXExWEJ5wrR3UWlmfLC1pYYvBxz+F0Wdp/Fmp5f4ZeNlzf2qaKZXGlP038AaNsvMmoZ4SYsGMOVG/eD1zfu/CDWTe6xN6mAN/TCKRi1Hh7Mg8BABX5Qnx5lmsPacCF398gg9zALeh/jw9BGRBNULBd5+wiob7daNaR2EJF+jS9+LApM2V9HBcLGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dbRXwGTFsE5033H3t/7yUa8DC/XJlg9r60yD3F6EqY=;
 b=y7MoivME5ax+rCkZOpsr+HMI44Itl22YptoUDfDo1eqtT3mPSrzF6Vfi+xbWrRz6fUbYkUxB4PTbObpwvCbSMDvqYaDXDcufLvIkB+NYmfd1cA6bvSbaxcZn0Jw/qFkt5eEGRY9nWQPIHFFz7QRDpbw851ap3snNk9+ccnvLs1U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2712.namprd10.prod.outlook.com (2603:10b6:a02:b3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Thu, 3 Jun
 2021 22:29:56 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.023; Thu, 3 Jun 2021
 22:29:56 +0000
Subject: Re: [PATCH 09/39] xfs: xfs_log_force_lsn isn't passed a LSN
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210603052240.171998-1-david@fromorbit.com>
 <20210603052240.171998-10-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <f6c1155b-5294-117a-3f4a-b75a8ed31e96@oracle.com>
Date:   Thu, 3 Jun 2021 15:29:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210603052240.171998-10-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BY5PR17CA0062.namprd17.prod.outlook.com
 (2603:10b6:a03:167::39) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by BY5PR17CA0062.namprd17.prod.outlook.com (2603:10b6:a03:167::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 22:29:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a0f73bf-637f-40b9-aafa-08d926df1d30
X-MS-TrafficTypeDiagnostic: BYAPR10MB2712:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2712B35665751ADF6CD7997E953C9@BYAPR10MB2712.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xbfYJCBA8KEiQF73BPc91kU63vDFAFHD8RgTaCrpigzWTbjs1jchk6fE4vzC4rp/fnw0T0Y8FcQGM53DlY8iKNhmS0Vj0pOeU54wJL78ecUVm/kC9HrSCzYZxUeBaqVStshIhwC93Rh91THDSfEMtPCxCgaTs/rjVjsrZQGni6JCgtirtfhE6yJpjjgPBd5BgCFf3lwhbYL8dQTD9f2g006oRXYCbPsUJsfN7kteF042hbjYL2kCxmAp1bwGtOYKyYh6LO0IQ/BzyptEOEkINjv0FAss3GabAshFvQEQ/V2Ie3Bm+u7AQ8Wi3zknKLrxDFschmdUY2FQiWVguYEe0pwfgNIEQp7MOz4cIA9c8AY+i5Cv3OKPsYP3s+yXu4iezvWRYxsSHljFmEDS7ZkPgb/T8Ypm3B8rin2gT+cjaAHJHeUv7fMtxZwWIKqMsfP17HebP2n0mvKlUB0iCI9E29wUi1DmujOYpKAKSChPFT/zj0XCuphwxidgS4VJebUWvOHJRAtj3MCSl39gEfbVjrmJ81FWxN9jaqf6KNNzwhuQvNWjAFrHZX4vFdKwJe4LPgxALC3gxJcp5RzMQHmKCdAn5+dDSjC+JpMp3QewHYRYLxkANsiZZ8qUaKrYt6n5V9B6Zr28uJwzwToreKM3mTpM0yEkc86bTHqCGomptx0ihP/skA2sns2pXNUlIfJycSH8GX6JnsekDRr5CYlN5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(366004)(136003)(346002)(16576012)(316002)(30864003)(66946007)(36756003)(44832011)(8676002)(31686004)(83380400001)(66476007)(5660300002)(66556008)(186003)(26005)(16526019)(38100700002)(38350700002)(956004)(86362001)(31696002)(2616005)(8936002)(478600001)(2906002)(6486002)(52116002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y0pzZy9PQzZaUnRKS2RGN1NubzRwb1FvUVlqalVjdkRzLzdYYjRCUUVpTWRT?=
 =?utf-8?B?anJuL283cXVVNkI3akZpd2JBM2dyVlVaTFFKbmV4dmI0MzNsUkxqQ2p6SG5n?=
 =?utf-8?B?Ym02RVUvUlVnalVVL1JQMGw0dXlCTzN5WEVadHZpV05yUk9wWk4zMmdKTGhT?=
 =?utf-8?B?K3A1dkZKSnhPcE0wZ25IeUEvZXk4M1ZmL0k3K1NZQVp5YnlwQW1DTGY4bjRX?=
 =?utf-8?B?U3krcjVyWkdLVm9wMTZ1SERTc1RuVjdYaVhTdHdIVytqTXErajNxOFlYSTY2?=
 =?utf-8?B?YkxGQVJDOEF4QVAwbEhSWTRoOFB6VjBHY2ZZSUZORkx2MTVmQWZxdWpzUVI3?=
 =?utf-8?B?SmZqcjBSa1k2VFdKS0F6OFF1b0lZTGFvL2RDZlN4YlBYN0V1YlpObjVmYVpH?=
 =?utf-8?B?cnBBbHBFemtkK0FMSVJVNW9LK1lqTU9RYmJHMHR1YmN6VzVjcEN3K0haRlpr?=
 =?utf-8?B?dFJjVkNWd1NWdFRjK3BuTTJrV0FiU3RoemlXUkxyYytIWnIybnJnZlB6T0dU?=
 =?utf-8?B?UFBzTmlyVUxtb2Q3MGtyZnhJN1FFdlZUZXRoQk9KRjI3c3ZqaU5SaWhSVGxU?=
 =?utf-8?B?Wm9tZ0JNajNsVHdFWmtOSnpZaUJCZHhDb3pYYkJGMVlWbUpxaTBrNGd4c3hT?=
 =?utf-8?B?bzhuWG1CQUhqQ3ZWRGhPVXljRm1rb2NNWTFyWWJoVTkvODg5R2tRZlNFNTlx?=
 =?utf-8?B?TmRCdFkydW8wRWRIbDJubGZMbkhYNXhSQUJsTit1RVJsSUZxd25ON0NRMm44?=
 =?utf-8?B?NTNPOUZ1dHN5TDNGRC9SV01mRmgwNkE5VlJLM1M0U3lxMXVKNW52NXUyRTFx?=
 =?utf-8?B?SkszelpGV1ExU3ZkaUREd3Btcm1SREttWVRDdURTd01FWXkyMmtzL21HVWJX?=
 =?utf-8?B?ZUc5Q1hFM1Frb2lTdUN2bnJ4VGhLSXRTQVNBRW5QdWZRSnVVWW4ybmNUZERk?=
 =?utf-8?B?Y0JnOWExTWtFbWVRQS9MUEpRdDRjeGdCTW95Q3FaODJmV3NOZk5jRGJKKzhF?=
 =?utf-8?B?V3hTOEw1N1NEWURDNjhteWRKaVZBd1ZaSHR4MmNiNTFCb1B6M2k4aG9MaW1H?=
 =?utf-8?B?RHF4K25CMUxTaC95ak9jT1dIR3NiWWN2OHRqcW41cEF1REh0aUplZEJSM05U?=
 =?utf-8?B?WWRlV1IxNWpZNHY4S1p2TlhxOSthV1J5czhEMWdQc0RuOXVkZ2JPMG9wQnpk?=
 =?utf-8?B?dzh3MzJmOFd6alYvcUg4NEpxUnpzQiszL1lmd3NtUmxUanp5dUdEUGYxZ3Y0?=
 =?utf-8?B?bnFsby9GTjJVMjZkazNZM2tKVXcvMmluZzdGYkRIMXljbnQ1Mng4dXgzczFm?=
 =?utf-8?B?bEUvVmFaTUQ1V0piMjN4NVAycXJyWDhqVCtXb2FwOERIYTJnSEtQUXNlZStv?=
 =?utf-8?B?Y051bFl5cUF3S3NqeVhNbEhrd1plKzFGcU1MUFFZVTkwNC9mWHU0NjVmRzZ5?=
 =?utf-8?B?cEliU2F0Qmg5dGJIQS8rdDFDTXAvVjB4Z0lQaHhhdXV6SmhGQklqblhwYmtY?=
 =?utf-8?B?RXFiK05CQTduUFBtYkdJT1JOUE5KR1JmY0hNYUJaV2orQUpoRDNhbVM4Y1NO?=
 =?utf-8?B?STFhRWNsV25aeGkvQzhqWmIwUnpuQyszcVRCMlRnbllBdm55THRyUCtsWkwz?=
 =?utf-8?B?OWt6TDJJUEVxMFQ4THQzai85YWJiaUh1alhCYUdaT1pGb01ERThSZ0FLMksr?=
 =?utf-8?B?QkZtUlZTaGF4bFhTNGtGOGxuL04yaGVnY2g4RVhxN1hBdzZZQ29oZEYzazlI?=
 =?utf-8?Q?hs3+WVZzfx7NKP7UAzNzK2IHv+x4OcwYweiJi7f?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a0f73bf-637f-40b9-aafa-08d926df1d30
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 22:29:55.9663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 80ppdJnC+YKTmMraSWM6USxYpRKYJQK75GT4IrNAelFkB8d83ZxlybdlCANvXN6tYblteLKOdyH8lmh2Pz/iHjG5wagwnubE9skmXSBp08A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2712
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030148
X-Proofpoint-GUID: MiAJ7WJ5wYCI12gm2krzwhh8LRO-gooN
X-Proofpoint-ORIG-GUID: MiAJ7WJ5wYCI12gm2krzwhh8LRO-gooN
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106030148
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/2/21 10:22 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In doing an investigation into AIL push stalls, I was looking at the
> log force code to see if an async CIL push could be done instead.
> This lead me to xfs_log_force_lsn() and looking at how it works.
> 
> xfs_log_force_lsn() is only called from inode synchronisation
> contexts such as fsync(), and it takes the ip->i_itemp->ili_last_lsn
> value as the LSN to sync the log to. This gets passed to
> xlog_cil_force_lsn() via xfs_log_force_lsn() to flush the CIL to the
> journal, and then used by xfs_log_force_lsn() to flush the iclogs to
> the journal.
> 
> The problem is that ip->i_itemp->ili_last_lsn does not store a
> log sequence number. What it stores is passed to it from the
> ->iop_committing method, which is called by xfs_log_commit_cil().
> The value this passes to the iop_committing method is the CIL
> context sequence number that the item was committed to.
> 
> As it turns out, xlog_cil_force_lsn() converts the sequence to an
> actual commit LSN for the related context and returns that to
> xfs_log_force_lsn(). xfs_log_force_lsn() overwrites it's "lsn"
> variable that contained a sequence with an actual LSN and then uses
> that to sync the iclogs.
> 
> This caused me some confusion for a while, even though I originally
> wrote all this code a decade ago. ->iop_committing is only used by
> a couple of log item types, and only inode items use the sequence
> number it is passed.
> 
> Let's clean up the API, CIL structures and inode log item to call it
> a sequence number, and make it clear that the high level code is
> using CIL sequence numbers and not on-disk LSNs for integrity
> synchronisation purposes.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Ok, looks like a nice clean up
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_types.h |  1 +
>   fs/xfs/xfs_buf_item.c     |  2 +-
>   fs/xfs/xfs_dquot_item.c   |  2 +-
>   fs/xfs/xfs_file.c         | 14 +++++++-------
>   fs/xfs/xfs_inode.c        | 10 +++++-----
>   fs/xfs/xfs_inode_item.c   |  4 ++--
>   fs/xfs/xfs_inode_item.h   |  2 +-
>   fs/xfs/xfs_log.c          | 27 ++++++++++++++-------------
>   fs/xfs/xfs_log.h          |  4 +---
>   fs/xfs/xfs_log_cil.c      | 30 +++++++++++-------------------
>   fs/xfs/xfs_log_priv.h     | 15 +++++++--------
>   fs/xfs/xfs_trans.c        |  6 +++---
>   fs/xfs/xfs_trans.h        |  4 ++--
>   13 files changed, 56 insertions(+), 65 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 064bd6e8c922..0870ef6f933d 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -21,6 +21,7 @@ typedef int32_t		xfs_suminfo_t;	/* type of bitmap summary info */
>   typedef uint32_t	xfs_rtword_t;	/* word type for bitmap manipulations */
>   
>   typedef int64_t		xfs_lsn_t;	/* log sequence number */
> +typedef int64_t		xfs_csn_t;	/* CIL sequence number */
>   
>   typedef uint32_t	xfs_dablk_t;	/* dir/attr block number (in file) */
>   typedef uint32_t	xfs_dahash_t;	/* dir/attr hash value */
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 14d1fefcbf4c..1cb087b320b1 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -713,7 +713,7 @@ xfs_buf_item_release(
>   STATIC void
>   xfs_buf_item_committing(
>   	struct xfs_log_item	*lip,
> -	xfs_lsn_t		commit_lsn)
> +	xfs_csn_t		seq)
>   {
>   	return xfs_buf_item_release(lip);
>   }
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 8c1fdf37ee8f..8ed47b739b6c 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -188,7 +188,7 @@ xfs_qm_dquot_logitem_release(
>   STATIC void
>   xfs_qm_dquot_logitem_committing(
>   	struct xfs_log_item	*lip,
> -	xfs_lsn_t		commit_lsn)
> +	xfs_csn_t		seq)
>   {
>   	return xfs_qm_dquot_logitem_release(lip);
>   }
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index f3e834563a56..a607f0024070 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -119,8 +119,8 @@ xfs_dir_fsync(
>   	return xfs_log_force_inode(ip);
>   }
>   
> -static xfs_lsn_t
> -xfs_fsync_lsn(
> +static xfs_csn_t
> +xfs_fsync_seq(
>   	struct xfs_inode	*ip,
>   	bool			datasync)
>   {
> @@ -128,7 +128,7 @@ xfs_fsync_lsn(
>   		return 0;
>   	if (datasync && !(ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
>   		return 0;
> -	return ip->i_itemp->ili_last_lsn;
> +	return ip->i_itemp->ili_commit_seq;
>   }
>   
>   /*
> @@ -151,12 +151,12 @@ xfs_fsync_flush_log(
>   	int			*log_flushed)
>   {
>   	int			error = 0;
> -	xfs_lsn_t		lsn;
> +	xfs_csn_t		seq;
>   
>   	xfs_ilock(ip, XFS_ILOCK_SHARED);
> -	lsn = xfs_fsync_lsn(ip, datasync);
> -	if (lsn) {
> -		error = xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC,
> +	seq = xfs_fsync_seq(ip, datasync);
> +	if (seq) {
> +		error = xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
>   					  log_flushed);
>   
>   		spin_lock(&ip->i_itemp->ili_lock);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 0369eb22c1bb..bffaec06bb0f 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2635,7 +2635,7 @@ xfs_iunpin(
>   	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
>   
>   	/* Give the log a push to start the unpinning I/O */
> -	xfs_log_force_lsn(ip->i_mount, ip->i_itemp->ili_last_lsn, 0, NULL);
> +	xfs_log_force_seq(ip->i_mount, ip->i_itemp->ili_commit_seq, 0, NULL);
>   
>   }
>   
> @@ -3644,16 +3644,16 @@ int
>   xfs_log_force_inode(
>   	struct xfs_inode	*ip)
>   {
> -	xfs_lsn_t		lsn = 0;
> +	xfs_csn_t		seq = 0;
>   
>   	xfs_ilock(ip, XFS_ILOCK_SHARED);
>   	if (xfs_ipincount(ip))
> -		lsn = ip->i_itemp->ili_last_lsn;
> +		seq = ip->i_itemp->ili_commit_seq;
>   	xfs_iunlock(ip, XFS_ILOCK_SHARED);
>   
> -	if (!lsn)
> +	if (!seq)
>   		return 0;
> -	return xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC, NULL);
> +	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC, NULL);
>   }
>   
>   /*
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 5a2dd33020e2..35de30849fcc 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -643,9 +643,9 @@ xfs_inode_item_committed(
>   STATIC void
>   xfs_inode_item_committing(
>   	struct xfs_log_item	*lip,
> -	xfs_lsn_t		commit_lsn)
> +	xfs_csn_t		seq)
>   {
> -	INODE_ITEM(lip)->ili_last_lsn = commit_lsn;
> +	INODE_ITEM(lip)->ili_commit_seq = seq;
>   	return xfs_inode_item_release(lip);
>   }
>   
> diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> index 4b926e32831c..403b45ab9aa2 100644
> --- a/fs/xfs/xfs_inode_item.h
> +++ b/fs/xfs/xfs_inode_item.h
> @@ -33,7 +33,7 @@ struct xfs_inode_log_item {
>   	unsigned int		ili_fields;	   /* fields to be logged */
>   	unsigned int		ili_fsync_fields;  /* logged since last fsync */
>   	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
> -	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
> +	xfs_csn_t		ili_commit_seq;	   /* last transaction commit */
>   };
>   
>   static inline int xfs_inode_clean(struct xfs_inode *ip)
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index b6145e4cb7bc..aa37f4319052 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3252,14 +3252,13 @@ xfs_log_force(
>   }
>   
>   static int
> -__xfs_log_force_lsn(
> -	struct xfs_mount	*mp,
> +xlog_force_lsn(
> +	struct xlog		*log,
>   	xfs_lsn_t		lsn,
>   	uint			flags,
>   	int			*log_flushed,
>   	bool			already_slept)
>   {
> -	struct xlog		*log = mp->m_log;
>   	struct xlog_in_core	*iclog;
>   
>   	spin_lock(&log->l_icloglock);
> @@ -3292,8 +3291,6 @@ __xfs_log_force_lsn(
>   		if (!already_slept &&
>   		    (iclog->ic_prev->ic_state == XLOG_STATE_WANT_SYNC ||
>   		     iclog->ic_prev->ic_state == XLOG_STATE_SYNCING)) {
> -			XFS_STATS_INC(mp, xs_log_force_sleep);
> -
>   			xlog_wait(&iclog->ic_prev->ic_write_wait,
>   					&log->l_icloglock);
>   			return -EAGAIN;
> @@ -3331,25 +3328,29 @@ __xfs_log_force_lsn(
>    * to disk, that thread will wake up all threads waiting on the queue.
>    */
>   int
> -xfs_log_force_lsn(
> +xfs_log_force_seq(
>   	struct xfs_mount	*mp,
> -	xfs_lsn_t		lsn,
> +	xfs_csn_t		seq,
>   	uint			flags,
>   	int			*log_flushed)
>   {
> +	struct xlog		*log = mp->m_log;
> +	xfs_lsn_t		lsn;
>   	int			ret;
> -	ASSERT(lsn != 0);
> +	ASSERT(seq != 0);
>   
>   	XFS_STATS_INC(mp, xs_log_force);
> -	trace_xfs_log_force(mp, lsn, _RET_IP_);
> +	trace_xfs_log_force(mp, seq, _RET_IP_);
>   
> -	lsn = xlog_cil_force_lsn(mp->m_log, lsn);
> +	lsn = xlog_cil_force_seq(log, seq);
>   	if (lsn == NULLCOMMITLSN)
>   		return 0;
>   
> -	ret = __xfs_log_force_lsn(mp, lsn, flags, log_flushed, false);
> -	if (ret == -EAGAIN)
> -		ret = __xfs_log_force_lsn(mp, lsn, flags, log_flushed, true);
> +	ret = xlog_force_lsn(log, lsn, flags, log_flushed, false);
> +	if (ret == -EAGAIN) {
> +		XFS_STATS_INC(mp, xs_log_force_sleep);
> +		ret = xlog_force_lsn(log, lsn, flags, log_flushed, true);
> +	}
>   	return ret;
>   }
>   
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 99f9d6ed9598..813b972e9788 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -106,7 +106,7 @@ struct xfs_item_ops;
>   struct xfs_trans;
>   
>   int	  xfs_log_force(struct xfs_mount *mp, uint flags);
> -int	  xfs_log_force_lsn(struct xfs_mount *mp, xfs_lsn_t lsn, uint flags,
> +int	  xfs_log_force_seq(struct xfs_mount *mp, xfs_csn_t seq, uint flags,
>   		int *log_forced);
>   int	  xfs_log_mount(struct xfs_mount	*mp,
>   			struct xfs_buftarg	*log_target,
> @@ -131,8 +131,6 @@ bool	xfs_log_writable(struct xfs_mount *mp);
>   struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
>   void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
>   
> -void	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
> -				xfs_lsn_t *commit_lsn, bool regrant);
>   void	xlog_cil_process_committed(struct list_head *list);
>   bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
>   
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 903617e6d054..3c2b1205944d 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -788,7 +788,7 @@ xlog_cil_push_work(
>   	 * that higher sequences will wait for us to write out a commit record
>   	 * before they do.
>   	 *
> -	 * xfs_log_force_lsn requires us to mirror the new sequence into the cil
> +	 * xfs_log_force_seq requires us to mirror the new sequence into the cil
>   	 * structure atomically with the addition of this sequence to the
>   	 * committing list. This also ensures that we can do unlocked checks
>   	 * against the current sequence in log forces without risking
> @@ -1057,16 +1057,14 @@ xlog_cil_empty(
>    * allowed again.
>    */
>   void
> -xfs_log_commit_cil(
> -	struct xfs_mount	*mp,
> +xlog_cil_commit(
> +	struct xlog		*log,
>   	struct xfs_trans	*tp,
> -	xfs_lsn_t		*commit_lsn,
> +	xfs_csn_t		*commit_seq,
>   	bool			regrant)
>   {
> -	struct xlog		*log = mp->m_log;
>   	struct xfs_cil		*cil = log->l_cilp;
>   	struct xfs_log_item	*lip, *next;
> -	xfs_lsn_t		xc_commit_lsn;
>   
>   	/*
>   	 * Do all necessary memory allocation before we lock the CIL.
> @@ -1080,10 +1078,6 @@ xfs_log_commit_cil(
>   
>   	xlog_cil_insert_items(log, tp);
>   
> -	xc_commit_lsn = cil->xc_ctx->sequence;
> -	if (commit_lsn)
> -		*commit_lsn = xc_commit_lsn;
> -
>   	if (regrant && !XLOG_FORCED_SHUTDOWN(log))
>   		xfs_log_ticket_regrant(log, tp->t_ticket);
>   	else
> @@ -1106,8 +1100,10 @@ xfs_log_commit_cil(
>   	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
>   		xfs_trans_del_item(lip);
>   		if (lip->li_ops->iop_committing)
> -			lip->li_ops->iop_committing(lip, xc_commit_lsn);
> +			lip->li_ops->iop_committing(lip, cil->xc_ctx->sequence);
>   	}
> +	if (commit_seq)
> +		*commit_seq = cil->xc_ctx->sequence;
>   
>   	/* xlog_cil_push_background() releases cil->xc_ctx_lock */
>   	xlog_cil_push_background(log);
> @@ -1124,9 +1120,9 @@ xfs_log_commit_cil(
>    * iclog flush is necessary following this call.
>    */
>   xfs_lsn_t
> -xlog_cil_force_lsn(
> +xlog_cil_force_seq(
>   	struct xlog	*log,
> -	xfs_lsn_t	sequence)
> +	xfs_csn_t	sequence)
>   {
>   	struct xfs_cil		*cil = log->l_cilp;
>   	struct xfs_cil_ctx	*ctx;
> @@ -1222,21 +1218,17 @@ bool
>   xfs_log_item_in_current_chkpt(
>   	struct xfs_log_item *lip)
>   {
> -	struct xfs_cil_ctx *ctx;
> +	struct xfs_cil_ctx *ctx = lip->li_mountp->m_log->l_cilp->xc_ctx;
>   
>   	if (list_empty(&lip->li_cil))
>   		return false;
>   
> -	ctx = lip->li_mountp->m_log->l_cilp->xc_ctx;
> -
>   	/*
>   	 * li_seq is written on the first commit of a log item to record the
>   	 * first checkpoint it is written to. Hence if it is different to the
>   	 * current sequence, we're in a new checkpoint.
>   	 */
> -	if (XFS_LSN_CMP(lip->li_seq, ctx->sequence) != 0)
> -		return false;
> -	return true;
> +	return lip->li_seq == ctx->sequence;
>   }
>   
>   /*
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 2203ccecafb6..2d7e7cbee8b7 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -234,7 +234,7 @@ struct xfs_cil;
>   
>   struct xfs_cil_ctx {
>   	struct xfs_cil		*cil;
> -	xfs_lsn_t		sequence;	/* chkpt sequence # */
> +	xfs_csn_t		sequence;	/* chkpt sequence # */
>   	xfs_lsn_t		start_lsn;	/* first LSN of chkpt commit */
>   	xfs_lsn_t		commit_lsn;	/* chkpt commit record lsn */
>   	struct xlog_ticket	*ticket;	/* chkpt ticket */
> @@ -272,10 +272,10 @@ struct xfs_cil {
>   	struct xfs_cil_ctx	*xc_ctx;
>   
>   	spinlock_t		xc_push_lock ____cacheline_aligned_in_smp;
> -	xfs_lsn_t		xc_push_seq;
> +	xfs_csn_t		xc_push_seq;
>   	struct list_head	xc_committing;
>   	wait_queue_head_t	xc_commit_wait;
> -	xfs_lsn_t		xc_current_sequence;
> +	xfs_csn_t		xc_current_sequence;
>   	struct work_struct	xc_push_work;
>   	wait_queue_head_t	xc_push_wait;	/* background push throttle */
>   } ____cacheline_aligned_in_smp;
> @@ -554,19 +554,18 @@ int	xlog_cil_init(struct xlog *log);
>   void	xlog_cil_init_post_recovery(struct xlog *log);
>   void	xlog_cil_destroy(struct xlog *log);
>   bool	xlog_cil_empty(struct xlog *log);
> +void	xlog_cil_commit(struct xlog *log, struct xfs_trans *tp,
> +			xfs_csn_t *commit_seq, bool regrant);
>   
>   /*
>    * CIL force routines
>    */
> -xfs_lsn_t
> -xlog_cil_force_lsn(
> -	struct xlog *log,
> -	xfs_lsn_t sequence);
> +xfs_lsn_t xlog_cil_force_seq(struct xlog *log, xfs_csn_t sequence);
>   
>   static inline void
>   xlog_cil_force(struct xlog *log)
>   {
> -	xlog_cil_force_lsn(log, log->l_cilp->xc_current_sequence);
> +	xlog_cil_force_seq(log, log->l_cilp->xc_current_sequence);
>   }
>   
>   /*
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 586f2992b789..87bffd12c20c 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -839,7 +839,7 @@ __xfs_trans_commit(
>   	bool			regrant)
>   {
>   	struct xfs_mount	*mp = tp->t_mountp;
> -	xfs_lsn_t		commit_lsn = -1;
> +	xfs_csn_t		commit_seq = 0;
>   	int			error = 0;
>   	int			sync = tp->t_flags & XFS_TRANS_SYNC;
>   
> @@ -881,7 +881,7 @@ __xfs_trans_commit(
>   		xfs_trans_apply_sb_deltas(tp);
>   	xfs_trans_apply_dquot_deltas(tp);
>   
> -	xfs_log_commit_cil(mp, tp, &commit_lsn, regrant);
> +	xlog_cil_commit(mp->m_log, tp, &commit_seq, regrant);
>   
>   	xfs_trans_free(tp);
>   
> @@ -890,7 +890,7 @@ __xfs_trans_commit(
>   	 * log out now and wait for it.
>   	 */
>   	if (sync) {
> -		error = xfs_log_force_lsn(mp, commit_lsn, XFS_LOG_SYNC, NULL);
> +		error = xfs_log_force_seq(mp, commit_seq, XFS_LOG_SYNC, NULL);
>   		XFS_STATS_INC(mp, xs_trans_sync);
>   	} else {
>   		XFS_STATS_INC(mp, xs_trans_async);
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index ee42d98d9011..50da47f23a07 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -43,7 +43,7 @@ struct xfs_log_item {
>   	struct list_head		li_cil;		/* CIL pointers */
>   	struct xfs_log_vec		*li_lv;		/* active log vector */
>   	struct xfs_log_vec		*li_lv_shadow;	/* standby vector */
> -	xfs_lsn_t			li_seq;		/* CIL commit seq */
> +	xfs_csn_t			li_seq;		/* CIL commit seq */
>   };
>   
>   /*
> @@ -69,7 +69,7 @@ struct xfs_item_ops {
>   	void (*iop_pin)(struct xfs_log_item *);
>   	void (*iop_unpin)(struct xfs_log_item *, int remove);
>   	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
> -	void (*iop_committing)(struct xfs_log_item *, xfs_lsn_t commit_lsn);
> +	void (*iop_committing)(struct xfs_log_item *lip, xfs_csn_t seq);
>   	void (*iop_release)(struct xfs_log_item *);
>   	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
>   	int (*iop_recover)(struct xfs_log_item *lip,
> 
