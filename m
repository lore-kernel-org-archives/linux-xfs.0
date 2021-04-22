Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32F0C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 00:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B28666101E
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 00:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235144AbhDVA36 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 20:29:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:17772 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234764AbhDVA34 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Apr 2021 20:29:56 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13M0S1jk007614;
        Thu, 22 Apr 2021 00:29:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=SBsNFEJYF8JmHNU7vQH8fMz6u8Y7t8rSQK/zUl+60k8=;
 b=LtmfLtxzSliEyE7s3KOcL/mB2OiZ+UrJD37RDbyhsLQ5QjAec9kv4ZC/AbiK8J5PCXL9
 Jmx44qxqvXzoh4UBPfCpdsMdHpgn776sH7gi2ZoPF6JqfIKQ+bzVNkJjB88cNf2uve4Z
 ouDFBbWC4NRQTn2/8928Q14crQUCdqtX54rBztQfC+ArRS4CbTtImoHJsa3XPwA/+A8v
 lOpO7LvpielVyf1hFLJxavBomTMMCzYjsP89PAMNkdl5MuWHtgEcQ3hIgh/omvFRMMkp
 zg6t5K2f9RP0dARvKEz4IIe4vXnWp01mvsJT3VEOzWP86905hZ+/rxagxIRIk5rVQ1mi xA== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 381bjn8x86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 00:29:15 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 13M0TDaE171591;
        Thu, 22 Apr 2021 00:29:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3030.oracle.com with ESMTP id 38098see62-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 00:29:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MSvIl2KnYCk2edFivxfvCaiuunvY6nP3FpD4horfFUH4J5JEJpuheJl32OHRHLRV7b7vbi7sFko845ZEUBM2mMyVLdVZwi+skMyvkpPD4wrSe/E0VT4uyU/ADOrZEvrUvMXf/5qEJrpx/j5DfCSG5cZjfRdhC9TarFGEJIXfPJ638uKIg/bgUpjx2c+j2GOJfSLzGmMNDeJC9IDF3QaM1FENzoGOvQYXkhLJmXCqa9r1H3UWCxAHB+GedusQfMxnckyqkY2EfSJem/YQGWeFqjca+IraMa7z3F1oAQTYZjt4WwySqTv1HjXX8Dd+EeQiNcBI7gV7r73aBAN/f0LFQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBsNFEJYF8JmHNU7vQH8fMz6u8Y7t8rSQK/zUl+60k8=;
 b=BSzYhM35sal7ZoH0j1luOlrCQefOxlGvvzVjnD/nX1OfCGvR8ZsmvkeFpmXlcxNlpxVPwh38cfd8sLaYGjbgN5vVHHmzgbByudpUIKZ1IzbUww+IDhhGzkzKKwPpZf37WBlDVbrfxq4zxc7nz4Vtk/K5lbonID69GjaYgQnl258MH5ZP4ndNgO/mhOuh8uBxV9VEYegzhpmUIp3WAXE6PN85Vq59ThhtyrBDZwkUeVRJZ+dmHk+69DBKZtvmzwuoEaY7CJBl+QW+jUI1jsB3B2uBv4UdUiUely1ZeYSt9izLSPrj81ai77ohG40slBaoyeKmxJ0QpwfLHihojh5gaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBsNFEJYF8JmHNU7vQH8fMz6u8Y7t8rSQK/zUl+60k8=;
 b=dIdJ8IhOASaEDzWh3cREawGxaGKnnJhLOsAM/qAT3/AB9r1op+uKexE3b+GXPxx/pJH9ZRWpRgGTrtA/mlqCKCeg8YvygGxrmhu1W8yy7VfPQrALWNATU7u9y/zrzS/MmmKpviI1aePUp5y1QzVJMmgIxMzhpErd/ZT7IZnuDf4=
Authentication-Results: eryu.me; dkim=none (message not signed)
 header.d=none;eryu.me; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2517.namprd10.prod.outlook.com (2603:10b6:a02:b4::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Thu, 22 Apr
 2021 00:29:13 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 00:29:13 +0000
Subject: Re: [PATCH 1/2] xfs: functional testing of V5-relevant options
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <161896456467.776366.1514131340097986327.stgit@magnolia>
 <161896457076.776366.1740320523459442249.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <b63d7a0c-b036-3a18-fed6-7e62d032481b@oracle.com>
Date:   Wed, 21 Apr 2021 17:29:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <161896457076.776366.1740320523459442249.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR07CA0007.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::20) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by BYAPR07CA0007.namprd07.prod.outlook.com (2603:10b6:a02:bc::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 00:29:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b011dfc5-6ad4-462d-a111-08d90525a744
X-MS-TrafficTypeDiagnostic: BYAPR10MB2517:
X-Microsoft-Antispam-PRVS: <BYAPR10MB25174BEC4E88555BD8BBE7C695469@BYAPR10MB2517.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wqR4hmfHfh4W3Fs0NWWSjQ5DLFhiwYIpFFsnj22tYdTiF11sABBO/cbKNiNILTHhs+Y/vgko4QSEm7gBnqDTnWGeRjWNIfwaSYXdfSubWDWMHRX3nSdf+vlqV6NMiSicotw+NNjSqDzW0M1Ll+edtVIMIP6+Ja/Hqt/IZPzwELSuhGOt8XkGf0V2bmDpR3kmG8MCZgjsoODbJEk28tZ/9IS6pO6M5KCvirv9eM4ShAsy7fg+zMUhqhxPv0CfWv2KV7T2nHEBPXCPlwgzTgT83FT2ofGFzafs2opcaPMofnCtUqTDOq103lP+dlcR/iP02lxRbImWWQ+eKYE8cAVjaAzcSf4aqJZpuONLPrtsccGQlWbTZwVQV8xUSgzmDmz2RMfDGPL/RAbjbE7yxFiwCUwhcZuJ7s8hkh/+s1LOwvR+bRa1snWFQ/K5LNRtFKy7HAJYK703pT8GJ+y6RJiZlkjA1Vf7JvsAGeuYRdJNCLH3JfpOozA0cfLuBu+z6Xtnyv3Um5fCB5y1Hdz1vjN5w8761xzf+uWsEvaPRs3a6rzDJS0EKi9r1BhXgZNz8nPZKz22EFfCNdSYWmDopgKP0VdRq3xYJAcWJ92GPyTYrw3UeHUIPE9EMfD3Skm8cbc5KNqP/Ns2H7kvEM0K8FmSMpgNzP2z5sMhFegB604d3rtZuN+Pg9PJBAcPRMd+BBZEjE6Z5IBf7xin8FaO48eDPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(6486002)(5660300002)(478600001)(2616005)(4326008)(38100700002)(30864003)(16526019)(38350700002)(83380400001)(86362001)(31696002)(52116002)(66556008)(53546011)(66476007)(956004)(36756003)(316002)(8676002)(44832011)(31686004)(2906002)(186003)(16576012)(8936002)(66946007)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dmxPaExKaE85UTBVVDJRZDlyYWFFOHRyWExjYnlGRUhNekZoL29GY3pWV0dw?=
 =?utf-8?B?YTRpYjF5WXJ0RW0weCtvVUFyRmJySm9yM29TSWRBMVltb1hXMit1dzVlcEh6?=
 =?utf-8?B?SlNwbmllQXVBQ1N1SkhVdWJEMmVlaVBLTzVPTlp0dlFIL01VbVhYaitYN1p3?=
 =?utf-8?B?dG00NW5ZeVNKYW9Nc01QbUdqWFZWL2ZEU3FjYjgzR1M4U1pSeFZhSmFLVVNh?=
 =?utf-8?B?c1BKSklrOVBMbisxY09wSm9BT1pkK1k1WVV3Mzc2aEFId0JqNURFeG0wd3RX?=
 =?utf-8?B?MVFVY2NUT1A2dktBazRXNWFYdmY3OE5vb1BEcExxM2NobEdMM1F6MFVyb0hK?=
 =?utf-8?B?aFcvMlhRREkwczdjYXZWMnJFdGpwb3ZURHpBYjlwRjlETy9wY1poK0VWQ3BC?=
 =?utf-8?B?SXFaYWNuejJkR0k0N1VjOEo1cFhiUEx3dUs0Um9IdlZvYXA5TTdDREhjbm9L?=
 =?utf-8?B?bUlnemZZVXFsZFRrNHVwWlI3S3ZsazFUclk1QjNBR21zbml4S3ZOMzJwbC9E?=
 =?utf-8?B?U3hsZE1sMDI5UjZaalllaFUzbndTTC9IWmpLR2FYdXJyTGNIZDNSSXY2Y3pv?=
 =?utf-8?B?RDd3TWI5STZobEZTWnhXY3gyTHJXMXpTV0xZeDcrdkRlcUMwZlcrK2Fkbzky?=
 =?utf-8?B?OXpGRm5iczVZZlNsSGtXMEhKTTlLV21OWGwvN3QwYkEvc3ZWVUV3TUROSmo4?=
 =?utf-8?B?NEFlenJuUnZRamI4dFNTSzgzWkgxZ0ZuenQ5aVg5Y3p2SnJZTit6eCtaSnd1?=
 =?utf-8?B?a1J6WXdtV1B0YXNrU0xFdkwvanc0WGkxSkUwMmJLRGFXMGVZTHlmUW84OXhS?=
 =?utf-8?B?b21rVkswWUdXdTRNSmlqUkNCOHpuSzVpSjJpQ2VEdVVOUDJPYVBUUkdKRit5?=
 =?utf-8?B?eXNQSkpFM2h4NUphbnR3VklOM3hNNDNvMTdIVkxPbmFlSUlXcGwzeHg5Ykgz?=
 =?utf-8?B?dElhMkNlWWhtekJwYjJEemlwUE54clNCNjZtSmhoSCtvVjlNK2FobW0vc2Ft?=
 =?utf-8?B?bXM3QVBxUWY2ckQvQ0Y4RVZKUnozYlg3Ykw2NmNsRXlKZitZVHJSNm5zUlJB?=
 =?utf-8?B?MzI4WlhOOWg1d2puL2VaN0R3MVE4L2tIMHZmbGxCUE5Ld0d2NmRHUDhKR3pL?=
 =?utf-8?B?ZldOU0ZYQTNLWDZ1MitSS1UzNnBXUGllTXRNT09DVDI0L0cvbFpobzlkVE85?=
 =?utf-8?B?S3NYSTBhd3NYWEwxMmZpOUluZWFWVEpjRFlpTGdsM2RyL0htakdmL1B1SnZO?=
 =?utf-8?B?SzZaekVaMlNUQVpQbURlSVlreGE4ZWxVK2cwNmJteUl4SjZ0R3BJU3F0OTlD?=
 =?utf-8?B?SktSQzdydjl3NE9jZnA3V1Z1UUlaTVk0N2NGaXp2TFBmWUlNS0pVUFY4M09L?=
 =?utf-8?B?citaV0dyVUkxUTBxaXQwL3Q3OEF5bEhKeUdTV1ZnN3VCUEoySnB3ZWJ1N29z?=
 =?utf-8?B?WkdHZXB4UGREcm50Z0hrMnZFU3hYMTl2MWhEZGF1cE1aQ0FrbHFCWFRpcEJn?=
 =?utf-8?B?czQ2ZHVKaDYrMTN1RTdSbWtvblY4b2pKc2F0R0NOd1BVSkIzR3h2Szd4cUV0?=
 =?utf-8?B?cG1VRWlnZ25TR1dNVE9QbGtlb3FFK3c0dlJUNkxtOU80LzRCQUVCVEJnU1Ba?=
 =?utf-8?B?TkNOcWpBTGNpL1c0MllQQnFaWjVzbm1IK0N0aUkwOGpwU0FGY2RiT09lMWpI?=
 =?utf-8?B?d3FMYmJXOG4vbFpSN3pBVWF3bE5WbitqVDUvWFE5UHlpWlVMNUg1NjZPNU5U?=
 =?utf-8?Q?QHPZyvNUYIDLDoLIj/MrdTkbIzxFqTFoD5hO0QD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b011dfc5-6ad4-462d-a111-08d90525a744
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 00:29:12.9430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MjaeKqnMG1mw6LbgMSOjx9dDz+a8NWfYuyy9i9NhgoTFhmPLA0DQRfzpMTT9hbebvTQXBSCvZUFVxZFQtbmB79srU0/HnZWwsNQFKELY3gU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2517
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220002
X-Proofpoint-GUID: IIEkS9gUrhA0bGvL4GfU1b7crEbEiawU
X-Proofpoint-ORIG-GUID: IIEkS9gUrhA0bGvL4GfU1b7crEbEiawU
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/20/21 5:22 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, the only functional testing for xfs_admin is xfs/287, which
> checks that one can add 32-bit project ids to a V4 filesystem.  This
> obviously isn't an exhaustive test of all the CLI arguments, and
> historically there have been xfs configurations that don't even work.
> 
> Therefore, introduce a couple of new tests -- one that will test the
> simple options with the default configuration, and a second test that
> steps a bit outside of the test run configuration to make sure that we
> do the right thing for external devices.  The second test already caught
> a nasty bug in xfsprogs 5.11.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Ok, I followed it through and I think it makes sense.  With Brians 
comments fixed:
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   common/xfs        |   21 ++++++++++
>   tests/xfs/764     |   93 +++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/764.out |   17 ++++++++
>   tests/xfs/773     |  114 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/773.out |   19 +++++++++
>   tests/xfs/group   |    2 +
>   6 files changed, 266 insertions(+)
>   create mode 100755 tests/xfs/764
>   create mode 100644 tests/xfs/764.out
>   create mode 100755 tests/xfs/773
>   create mode 100644 tests/xfs/773.out
> 
> 
> diff --git a/common/xfs b/common/xfs
> index c2384146..5abc7034 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1142,3 +1142,24 @@ _check_scratch_xfs_features()
>   	echo "${output[@]}"
>   	test "${found}" -eq "$#"
>   }
> +
> +# Decide if xfs_repair knows how to set (or clear) a filesystem feature.
> +_require_xfs_repair_upgrade()
> +{
> +	local type="$1"
> +
> +	$XFS_REPAIR_PROG -c "$type=garbagevalue" 2>&1 | \
> +		grep -q 'unknown option' && \
> +		_notrun "xfs_repair does not support upgrading fs with $type"
> +}
> +
> +_require_xfs_scratch_inobtcount()
> +{
> +	_require_scratch
> +
> +	_scratch_mkfs -m inobtcount=1 &> /dev/null || \
> +		_notrun "mkfs.xfs doesn't have inobtcount feature"
> +	_try_scratch_mount || \
> +		_notrun "inobtcount not supported by scratch filesystem type: $FSTYP"
> +	_scratch_unmount
> +}
> diff --git a/tests/xfs/764 b/tests/xfs/764
> new file mode 100755
> index 00000000..ebdf8883
> --- /dev/null
> +++ b/tests/xfs/764
> @@ -0,0 +1,93 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 764
> +#
> +# Functional testing for xfs_admin to make sure that it handles option parsing
> +# correctly for functionality that's relevant to V5 filesystems.  It doesn't
> +# test the options that apply only to V4 filesystems because that disk format
> +# is deprecated.
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
> +_require_scratch
> +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> +
> +rm -f $seqres.full
> +
> +note() {
> +	echo "$@" | tee -a $seqres.full
> +}
> +
> +note "S0: Initialize filesystem"
> +_scratch_mkfs -L origlabel -m uuid=babababa-baba-baba-baba-babababababa >> $seqres.full
> +_scratch_xfs_db -c label -c uuid
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +
> +note "S1: Set a filesystem label"
> +_scratch_xfs_admin -L newlabel >> $seqres.full
> +_scratch_xfs_db -c label
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +
> +note "S2: Clear filesystem label"
> +_scratch_xfs_admin -L -- >> $seqres.full
> +_scratch_xfs_db -c label
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +
> +note "S3: Try to set oversized label"
> +_scratch_xfs_admin -L thisismuchtoolongforxfstohandle >> $seqres.full
> +_scratch_xfs_db -c label
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +
> +note "S4: Set filesystem UUID"
> +_scratch_xfs_admin -U deaddead-dead-dead-dead-deaddeaddead >> $seqres.full
> +_scratch_xfs_db -c uuid
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +
> +note "S5: Zero out filesystem UUID"
> +_scratch_xfs_admin -U nil >> $seqres.full
> +_scratch_xfs_db -c uuid
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +
> +note "S6: Randomize filesystem UUID"
> +old_uuid="$(_scratch_xfs_db -c uuid)"
> +_scratch_xfs_admin -U generate >> $seqres.full
> +new_uuid="$(_scratch_xfs_db -c uuid)"
> +if [ "$new_uuid" = "$old_uuid" ]; then
> +	echo "UUID randomization failed? $old_uuid == $new_uuid"
> +fi
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +
> +note "S7: Restore original filesystem UUID"
> +if _check_scratch_xfs_features V5 >/dev/null; then
> +	# Only V5 supports the metauuid feature that enables us to restore the
> +	# original UUID after a change.
> +	_scratch_xfs_admin -U restore >> $seqres.full
> +	_scratch_xfs_db -c uuid
> +else
> +	echo "UUID = babababa-baba-baba-baba-babababababa"
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/764.out b/tests/xfs/764.out
> new file mode 100644
> index 00000000..8da929ec
> --- /dev/null
> +++ b/tests/xfs/764.out
> @@ -0,0 +1,17 @@
> +QA output created by 764
> +S0: Initialize filesystem
> +label = "origlabel"
> +UUID = babababa-baba-baba-baba-babababababa
> +S1: Set a filesystem label
> +label = "newlabel"
> +S2: Clear filesystem label
> +label = ""
> +S3: Try to set oversized label
> +label = "thisismuchto"
> +S4: Set filesystem UUID
> +UUID = deaddead-dead-dead-dead-deaddeaddead
> +S5: Zero out filesystem UUID
> +UUID = 00000000-0000-0000-0000-000000000000
> +S6: Randomize filesystem UUID
> +S7: Restore original filesystem UUID
> +UUID = babababa-baba-baba-baba-babababababa
> diff --git a/tests/xfs/773 b/tests/xfs/773
> new file mode 100755
> index 00000000..f184962a
> --- /dev/null
> +++ b/tests/xfs/773
> @@ -0,0 +1,114 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 773
> +#
> +# Functional testing for xfs_admin to ensure that it parses arguments correctly
> +# with regards to data devices that are files, external logs, and realtime
> +# devices.
> +#
> +# Because this test synthesizes log and rt devices (by modifying the test run
> +# configuration), it does /not/ require the ability to mount the scratch
> +# filesystem.  This increases test coverage while isolating the weird bits to a
> +# single test.
> +#
> +# This is partially a regression test for "xfs_admin: pick up log arguments
> +# correctly", insofar as the issue fixed by that patch was discovered with an
> +# earlier revision of this test.
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
> +	rm -f $tmp.* $fake_logfile $fake_rtfile $fake_datafile
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_test
> +_require_scratch_nocheck
> +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> +
> +rm -f $seqres.full
> +
> +# Create some fake sparse files for testing external devices and whatnot
> +fake_datafile=$TEST_DIR/scratch.data
> +rm -f $fake_datafile
> +truncate -s 500m $fake_datafile
> +
> +fake_logfile=$TEST_DIR/scratch.log
> +rm -f $fake_logfile
> +truncate -s 500m $fake_logfile
> +
> +fake_rtfile=$TEST_DIR/scratch.rt
> +rm -f $fake_rtfile
> +truncate -s 500m $fake_rtfile
> +
> +# Save the original variables
> +orig_ddev=$SCRATCH_DEV
> +orig_external=$USE_EXTERNAL
> +orig_logdev=$SCRATCH_LOGDEV
> +orig_rtdev=$SCRATCH_RTDEV
> +
> +scenario() {
> +	echo "$@" | tee -a $seqres.full
> +
> +	SCRATCH_DEV=$orig_ddev
> +	USE_EXTERNAL=$orig_external
> +	SCRATCH_LOGDEV=$orig_logdev
> +	SCRATCH_RTDEV=$orig_rtdev
> +}
> +
> +check_label() {
> +	_scratch_mkfs -L oldlabel >> $seqres.full
> +	_scratch_xfs_db -c label
> +	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
> +	_scratch_xfs_db -c label
> +	_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +}
> +
> +scenario "S1: Check that label setting with file image"
> +SCRATCH_DEV=$fake_datafile
> +check_label -f
> +
> +scenario "S2: Check that setting with logdev works"
> +USE_EXTERNAL=yes
> +SCRATCH_LOGDEV=$fake_logfile
> +check_label
> +
> +scenario "S3: Check that setting with rtdev works"
> +USE_EXTERNAL=yes
> +SCRATCH_RTDEV=$fake_rtfile
> +check_label
> +
> +scenario "S4: Check that setting with rtdev + logdev works"
> +USE_EXTERNAL=yes
> +SCRATCH_LOGDEV=$fake_logfile
> +SCRATCH_RTDEV=$fake_rtfile
> +check_label
> +
> +scenario "S5: Check that setting with nortdev + nologdev works"
> +USE_EXTERNAL=
> +SCRATCH_LOGDEV=
> +SCRATCH_RTDEV=
> +check_label
> +
> +scenario "S6: Check that setting with bdev incorrectly flagged as file works"
> +check_label -f
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/773.out b/tests/xfs/773.out
> new file mode 100644
> index 00000000..954bfb85
> --- /dev/null
> +++ b/tests/xfs/773.out
> @@ -0,0 +1,19 @@
> +QA output created by 773
> +S1: Check that label setting with file image
> +label = "oldlabel"
> +label = "newlabel"
> +S2: Check that setting with logdev works
> +label = "oldlabel"
> +label = "newlabel"
> +S3: Check that setting with rtdev works
> +label = "oldlabel"
> +label = "newlabel"
> +S4: Check that setting with rtdev + logdev works
> +label = "oldlabel"
> +label = "newlabel"
> +S5: Check that setting with nortdev + nologdev works
> +label = "oldlabel"
> +label = "newlabel"
> +S6: Check that setting with bdev incorrectly flagged as file works
> +label = "oldlabel"
> +label = "newlabel"
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 461ae2b2..a2309465 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -522,5 +522,7 @@
>   537 auto quick
>   538 auto stress
>   539 auto quick mount
> +764 auto quick repair
>   768 auto quick repair
>   770 auto repair
> +773 auto quick repair
> 
