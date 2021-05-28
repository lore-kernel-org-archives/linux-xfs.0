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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79627C4708B
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 00:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D41C613BF
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 00:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236110AbhE1A4Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 20:56:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50902 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236077AbhE1A4M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 20:56:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14S0sbhm097237;
        Fri, 28 May 2021 00:54:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Ae544I6qWwisasSt3E+w4kBoU63ifWKz2lNEAzBZsjA=;
 b=ajWrzIbX9yl+SwzwtUWV7ThjcTmp7WKvQEe/qGovPAR5mC7bCOTwUgMpHvf1LxEpsdAA
 lvNQuKULu056zY5ruIJOcKh3+tNPIoNRHgqVw4Q/sLpa/NUNOcL/gxlwoEriKi087smT
 NmgcSpncbw0d+nwMgk7IICdt0k8qpdjJHXFvq6u1HqTbDEBkSMaZF+C1qUyCNYy/oNsJ
 i/Hfe8Gob6HW+5ypkCtqSxjjg9Oy4sp3xC8eJ22k/TIf6VFMmD5AkJ8k9mxHe1GXF+NF
 R2bimuXvTsdAgYZdiOdR+xBjmagS9LvbqeOFk9RYmbhBEJxNLvbgT+h7xHhqhnLObPBG ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 38q3q9555h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 May 2021 00:54:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14S0kAhp173827;
        Fri, 28 May 2021 00:54:36 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by aserp3030.oracle.com with ESMTP id 38pr0e34hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 May 2021 00:54:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfU+phwGltjlUyKUq3jdFx8mNJBqpA34aGUn9wSVYanYr7+jqul/nLUjDYFnSv8H9QpIIfp+pmYw7BiMoIIV8zb60KS+rpXfIYV/M8iKh7WAjQ8xsvdtahMNrLIOs83eDx9QMGv0pPf+vJya1EUxtvZi5yMORhixA+CRPg/ZSHYd+EnRCVuZ9UhPfFhT5diaPEMsHLxxOKiaxTdfrnxO5rDRTZrusYjR5qsVbNdYwK44ZHIpgcN5KSLB+V3a6ne0L8kYWAT8O9QAIgNV0uwCsg5rPj+wUqqr1UuSxvFrJXAEiKoEfDhvcLwysLMdS60AGuDURyGyz7uFPpAQYJnebQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ae544I6qWwisasSt3E+w4kBoU63ifWKz2lNEAzBZsjA=;
 b=O5Mvl7MRwZ+hO3OcVTnBdkeAK58brkJWD85vdpNKEkr1C5WCLC4wQ8asTnl0ij5dlZOc1cv5sTdojeYpWAjKbL5jpast5V3hrMjRQtPImXcZ1QjOLtqikep1uXaxJOWKXrwX3oZ7OLMMPta6YfnFlXdy1rLosAnHj3JF38GtDJ2q4ows1SM32boJNZDYOC/WAFnIBpfAZbDVPHtpH+gAjAN2KLe/t8C7lIqbNG8XxgU1i/RJye6/JvgtvEERUzD5Jraz0pE9vcvvqHYMWhYDv0Ooq1eAUHA52I1dp679+S1cESLxvLqVapcZ80LnhxQ4GSK/e+wAt9K9c6liTlLV2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ae544I6qWwisasSt3E+w4kBoU63ifWKz2lNEAzBZsjA=;
 b=I37CqvWTsSzRrz07HVj+3qiZ0JO3IvR85cehJuuv0W9Lx9f7bvd2hwfHXGNzG+IyQN1mY+tYvfE6U5ejo25/Eu1AxeblTsTTyP2LXf/WLbb3/LNsahl19OUVF8NzY/uPEi/YTcrlT4hcaAvI6Zm+gwXk195U4CfEUvuO30npVNs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4510.namprd10.prod.outlook.com (2603:10b6:a03:2d6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Fri, 28 May
 2021 00:54:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4173.022; Fri, 28 May 2021
 00:54:34 +0000
Subject: Re: [PATCH 04/39] xfs: async blkdev cache flush
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-5-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <44df4f59-2b84-380a-e840-b4345a08e90c@oracle.com>
Date:   Thu, 27 May 2021 17:54:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210519121317.585244-5-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR03CA0207.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by SJ0PR03CA0207.namprd03.prod.outlook.com (2603:10b6:a03:2ef::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22 via Frontend Transport; Fri, 28 May 2021 00:54:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ecad4bd-ea3c-45d5-0c3c-08d9217328ce
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4510:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4510FB1D0411D29965AFD79D95229@SJ0PR10MB4510.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6qQY4zIN9qpQx/ZlX6QffXF4FgapB65mMfNXSxUPl4ZCv2I/yAkCmINF9O0PQbT6JBIvUX2R4JfcDp8fab3N/hoEaPVHoTl0Um6k9Oc+Kpf31Q9nmCqMTpiFJGGJxzX+cebbc4SAuDxMrS+4cOWh3sLS5L6EKlrXY3pxPKLibJkj4fVCU7K2CvPPKOnTIUFIyo6cM/RTeguSBQSZnjYkZ+8eYEGHwTi/+jYJ8tpGCQ8smE+X7JSjTjYGTIZxLrOUtkE8u6elQ4eujmC4erHPusDexUl1bUSOGCATk70lPIw7O9fQupFlAsoEUFh4mwdUebRo5vKcz4asZUtBSr/j0NSuo2ponwWTV29a+I3DGdl81SRezipjD86HdcWGsa2EnjQfRSTHGjxdsfZ32RvUnZbQganLvzl7CLc2xtpaYYb577jbBtIoWtgEhLsEKE9uEgBKRv4ZK1W2ZGmT0VSWcnPRl82uvrmkYTR82f0KjgcVUX3KqV5gSizA1+AfMTM80ltj0kyf2Y1ukbseIX1DrSre2ZRC3Zttnnno3k/cgeeMnm4aAIqW2+rOiQG59VH7mDRopkoCtgl3MzkbB5ek9QmCLZaCzZ1TZTNs+JTygdUQy+aEqM8IwBzPmZze9IYV6t8sZE+NHhxsNvlLe90C6mHCh8DIjqElv0ipNC8g/taCNTe3FW4auDfSsLmdGtJ6RNyYie45e0b22nCYgqHCCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(39860400002)(396003)(5660300002)(26005)(44832011)(31686004)(36756003)(316002)(478600001)(2616005)(16576012)(956004)(16526019)(2906002)(83380400001)(38100700002)(38350700002)(52116002)(86362001)(8936002)(31696002)(6486002)(8676002)(66556008)(66946007)(53546011)(186003)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MFFGOGc2TGtlN01ZTVMwUDNCWXd5eFZCT1I5dlJhQ3FGZlpkckVXMnkwT0dW?=
 =?utf-8?B?Z0E1M2JnQ29jdVZ4ZjJJWTVkYSsxcVlZZDJ0ZjlXeE1RYTdOV3BqMTBLc1I0?=
 =?utf-8?B?Sy9OY1d4ZVNEbkpvS0d3Q1hlSmFudWpsUmR0UmQ1OWdtclN0bjVobjQ4N0ls?=
 =?utf-8?B?T0pMOXhpR2pBNC9hTDBXM2J3azcrVjZ4QytGVW13NE00Rkd3c3FTUTQwUTdy?=
 =?utf-8?B?TlZYSERmWGJ3SVo1OXpiNkdsMk1GeUpTRW9wUUp4b1ZaaU84MTZodU4vcVhz?=
 =?utf-8?B?WCs3d1lGbzlrNWpVcFo2c2lCUmk1aWZjZHZySEtRYTZ2c0pJMW9rdVhENDdU?=
 =?utf-8?B?S3JMUVhsdG5rVTd5a1ZwcE1CNDlsUUJlSWk1S2VnamNQaWY3WmRLM0FSYlVn?=
 =?utf-8?B?bWZiZ3JjSnpFOHF6T0l5aGM1eHM4eTlFbEErYzBMbExFcnRPMDJBZjg0SFdw?=
 =?utf-8?B?TE1XS2dYR0I0eGpGSlhkUWpYa1Qrc29xK2VMZ1puNlh4TUp2cGR6N00vbFVy?=
 =?utf-8?B?bTFpWmpmTnJGUUZkUXc5ckVNWVdNUWQ3RitncUlEQi9adFVCN0traldoQmtR?=
 =?utf-8?B?ZnYzekRUdUpTWm0zWU40ZWJ4NFdTeW9VMkNiNGtkSnQ0Q1ZxWjVlQmM5UXVE?=
 =?utf-8?B?UUZja0lOaUxHUWU4UDE1bkg4dEhnODVwekpNc2lOdGtYWnYvcTI4UzZVb3JM?=
 =?utf-8?B?WURZcjh6Nk9TNUxwWURuUnRVeHBJdUgyWGdIalV2RktpZW5GYzZGSEhVVzR6?=
 =?utf-8?B?TFFPZEUra3hlanBaRTJDaUk3c0ZtSWNteXFmcnVCMDRxam8zeGdYSG12aE5Y?=
 =?utf-8?B?bkRubnV2dUlKZVBDUnpDSjgrekJIWGF0a3NrNDh0VCtyQW14Sld2OFdMTmNE?=
 =?utf-8?B?UVVJQ0lkbFdGQjFIbmdZT2VBVHlWNkxpMHB5WDROUS9DTHRHTFU3LzhoRVJm?=
 =?utf-8?B?amRmd2JpejZJYlpwV2t6dUdnYzlrdGYxTXVSKzdOd1l5U0VUSVU3THBXOUww?=
 =?utf-8?B?SUJWZm5XQ041RGpFSGs4RU9mRTAxbnhsTFAwaXR4dWN2eXk2N01jN3FGM0Za?=
 =?utf-8?B?YmRIc0VhOGU0MEhPTi9HSDdHMFppQ1U0aCtEOHh6M3JmeHNRRU1Yb2t6ZlVP?=
 =?utf-8?B?cGVWZDZyWllobXMycDN2ZTcyc1dxZXR3QnZ2ZytQT3NuNVRocU44eWJaY2lG?=
 =?utf-8?B?MXpiR0hCdFpUTlFJZXFSN2k5Y00rdTk0S2c5OG1GWFhqL09DY09KdWgrdUNx?=
 =?utf-8?B?dEdVcnJzU1pBeXc5aGtDRnhWNlZVUXRmcXdqNHpyblJmd2lJNDhteUo2U0pS?=
 =?utf-8?B?RElPazY0STFJb29TelR2MTAzdHF0TlN3MklWTHJJblhhVExoaXd4UzI0b25S?=
 =?utf-8?B?UWhzcUNPek0vbFV0R3lHcmNUS2lDaytvOUpQR1JEbTgvSjVpbTV1SHRxQ3JP?=
 =?utf-8?B?SVpKWFBQc3kyMnhTRStjQngyeU1hMVhJOWJRR3FkOEptZ3hIRzJxemhSY0lE?=
 =?utf-8?B?eE5DZm9Qb3hRcGNjRjNsak56c0RPajBFZ2VROVFScG1ETCthMGxBN3dpRnd0?=
 =?utf-8?B?bGxGWEpQL2FmUGg0Uk5PL1dDSTBpbFcrVmpvOWtwNndCSGFxTkJTYVZ6SnY3?=
 =?utf-8?B?NGFza1dLNzdpSEhCVFhXV3dRMkt6SWJwakcvSHFIZllvK0xtNTZUMnBIcGhR?=
 =?utf-8?B?QkxqMHFrckxKOHRMN2pQQkNwZkZrMUVWYW9LdWFKYldYWUZxd2pFNS9wSjQ1?=
 =?utf-8?Q?ruTTiqzVAb4aIHged6FAG8hlD9RHkThRcKTXNQi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ecad4bd-ea3c-45d5-0c3c-08d9217328ce
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 00:54:34.0547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gB5Nsy0WYjnjIQF3yFu1TC7eR/XdGpE/9sMvu7TKUomJDM0dX1AMJERb4I0Q2qfjeIq5dqjXY2AAtrUPIMXUEu4vC7pkbcM4F6/4QlI5StA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4510
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9997 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105280003
X-Proofpoint-GUID: _7eQ6BfVOxpzPenAHxvDgttUPC99GqWl
X-Proofpoint-ORIG-GUID: _7eQ6BfVOxpzPenAHxvDgttUPC99GqWl
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9997 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105280004
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/19/21 5:12 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The new checkpoint cache flush mechanism requires us to issue an
> unconditional cache flush before we start a new checkpoint. We don't
> want to block for this if we can help it, and we have a fair chunk
> of CPU work to do between starting the checkpoint and issuing the
> first journal IO.
> 
> Hence it makes sense to amortise the latency cost of the cache flush
> by issuing it asynchronously and then waiting for it only when we
> need to issue the first IO in the transaction.
> 
> To do this, we need async cache flush primitives to submit the cache
> flush bio and to wait on it. The block layer has no such primitives
> for filesystems, so roll our own for the moment.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>   fs/xfs/xfs_bio_io.c | 35 +++++++++++++++++++++++++++++++++++
>   fs/xfs/xfs_linux.h  |  2 ++
>   2 files changed, 37 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> index 17f36db2f792..de727532e137 100644
> --- a/fs/xfs/xfs_bio_io.c
> +++ b/fs/xfs/xfs_bio_io.c
> @@ -9,6 +9,41 @@ static inline unsigned int bio_max_vecs(unsigned int count)
>   	return bio_max_segs(howmany(count, PAGE_SIZE));
>   }
>   
> +static void
> +xfs_flush_bdev_async_endio(
> +	struct bio	*bio)
> +{
> +	complete(bio->bi_private);
> +}
> +
> +/*
> + * Submit a request for an async cache flush to run. If the request queue does
> + * not require flush operations, just skip it altogether. If the caller needsi
typo nit: needs
Otherwise looks fine
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> + * to wait for the flush completion at a later point in time, they must supply a
> + * valid completion. This will be signalled when the flush completes.  The
> + * caller never sees the bio that is issued here.
> + */
> +void
> +xfs_flush_bdev_async(
> +	struct bio		*bio,
> +	struct block_device	*bdev,
> +	struct completion	*done)
> +{
> +	struct request_queue	*q = bdev->bd_disk->queue;
> +
> +	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags)) {
> +		complete(done);
> +		return;
> +	}
> +
> +	bio_init(bio, NULL, 0);
> +	bio_set_dev(bio, bdev);
> +	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
> +	bio->bi_private = done;
> +	bio->bi_end_io = xfs_flush_bdev_async_endio;
> +
> +	submit_bio(bio);
> +}
>   int
>   xfs_rw_bdev(
>   	struct block_device	*bdev,
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 7688663b9773..c174262a074e 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -196,6 +196,8 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
>   
>   int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
>   		char *data, unsigned int op);
> +void xfs_flush_bdev_async(struct bio *bio, struct block_device *bdev,
> +		struct completion *done);
>   
>   #define ASSERT_ALWAYS(expr)	\
>   	(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))
> 
