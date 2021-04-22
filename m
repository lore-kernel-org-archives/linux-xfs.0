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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65BCBC433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 00:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2381961452
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 00:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343892AbhDVA3s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 20:29:48 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:58844 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235144AbhDVA3r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Apr 2021 20:29:47 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13M0QoUO023135;
        Thu, 22 Apr 2021 00:29:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=PP5yW32Gpw1X4v6wg6d/JKMaLclegzzSPcx492IIiHI=;
 b=LkG7by6rRxLh14Wj387G00DN9xTmNTzJLDH48/zLR7TdM8gmPoF6EU2CgG5FCGyn8SDe
 AXI1xiIuNsA4aRlG32SF2sn9FKc4qZWrKWnJ4K0jrsiC3/h7ryA74EDpfwMX2cPX+eGv
 0OWphJCSsdsCGoWo/gyU/ql7a8VpU6B4wy6DHuUAP0CxyLS4w0yEzhRaM//ACmFx3OsJ
 SJwhVHIVpgB/81EmNZIIlRfPJ4l26lHsLwyefJbPaXD2ESO3vpyHkQ7ZI4HbzeOsJntU
 jKQyl0bHOpThNUaAoTytHIKieyxzcJpDCUQ3IttZ73mIiF+QMNkPkZKizOg/4X+x7GrO Nw== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 382unxg1xa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 00:29:09 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 13M0T8fT171380;
        Thu, 22 Apr 2021 00:29:08 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2055.outbound.protection.outlook.com [104.47.37.55])
        by aserp3030.oracle.com with ESMTP id 38098see1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 00:29:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bN61MePbDrvoUN+SDJ+UJBXglPhUR1SCoRXTnzGyh+D5+fw+5/EnSRORXZVHx2QekXy4WtDnDETd00NyG2TrGxqUgem1DZvYpukYtHdiWz12ZLjVydEnPXOfa+aTH04sNnEDPmZ+0rL383VWKaG44mNjfOmKBHhyx+S/8i4am2wYeqGPJQU74xoCIcncXM7yG3IeV5FLpO43fHTV7r1pg3va2WxYG8SOYmCQrYzo8GTOQ1YRDhaA4+zlBzlgA8cfraxh2jlFM7/h4GCedWO8vC/3aCl85gwqrmt52EfxgEybUe5LmPq4AQ1L1CsMlVpU7FYoKEPtHXd+fOcjP8M/fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PP5yW32Gpw1X4v6wg6d/JKMaLclegzzSPcx492IIiHI=;
 b=M1bMkUaIt9lCNh0+Lc0EQJF9F+TV16pjylbhihi6pQ0B71S0FOYhNg6vsKq/d4MPY/9hPdwN0QjA0oDp3MQ1zyORE3QvBage80I0kuNb7WWf5O2XwfxyMB+dYGBHcfQ0Ub8P6N96uL5RwmCP1o6LBArCfW6eGVyZ6glG5jNUOkfNmRbrs0CTlUE8+woW0WOwMls6fx/HmIJFCWhL+wZT6WXW45EldJGkvVF49QbgzVdwd94lC6aX9s5T3MO5oI6WpPg7lgwLK6C+986P4tYCllLmMIBSPFa/2kRsPNClLabcaU5UrdOA36tdb05txgyubF8miTeHR35B9lXPYFcloA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PP5yW32Gpw1X4v6wg6d/JKMaLclegzzSPcx492IIiHI=;
 b=PhgoLwphtyo9QiHC8C2afw4xUS7ZmLnRYpbQOPGt4zSswtvwSh5wgeUbyc4hsXXGG05T0e9oOfUBRUv5hAyrwsA23xZV/qFOfTRHJLr0XXxkPzPlXdO/wbj00ran+nI/NoAzikmAO4mMynNcw0pYhNefOwQru/++AIUyoM1DEC4=
Authentication-Results: eryu.me; dkim=none (message not signed)
 header.d=none;eryu.me; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4496.namprd10.prod.outlook.com (2603:10b6:a03:2d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 00:29:05 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 00:29:05 +0000
Subject: Re: [PATCH 1/2] generic/223: make sure all files get created on the
 data device
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <161896453944.776190.2831340458112794975.stgit@magnolia>
 <161896454559.776190.1857804198421552259.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <6297a049-a6fc-f368-864d-77d53b813f80@oracle.com>
Date:   Wed, 21 Apr 2021 17:29:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <161896454559.776190.1857804198421552259.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR07CA0003.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by BYAPR07CA0003.namprd07.prod.outlook.com (2603:10b6:a02:bc::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 00:29:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d08dccf-6462-4a08-3338-08d90525a265
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4496:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4496F98C6C668887BC23C74595469@SJ0PR10MB4496.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ikTbMXyK+udJS4Z8z2NogU0OdnpF7lP9V/RCJyVH4QPMJ279tuJIu3PNEQa/H9cfxn/9+Qim7eXQDBUAVbsgrLdGSzLoIsvUMLzDQW706Ed/gFp5yTWyZl9BKs3haECT803GBGmbPGFFG+qo0J95QEo4tz/kLQjOyNbG8gpw6c4xTJzeQ4GmoEHn0HczdVF54GxTGef51CkMmWNMOeUBGNIBDdgn3wr6WCDi2yHU1VpeeJX1AIsKQI/C2VHyicwXpJWTR9bYA97kDoW/hBiQItdoaYXllDFBM20zfjmlBawd0fuxmFqNAAU6dLfoYaTQI3QQAXvYAyrL7jg1mwjvZdkgAlPTDITFtC2q2gPVcUhvvvrzWmgDmuSkGig46h6dEJEVMjwKQpyEKA0N5vUPtjJqXF3qpzBgbwdC7J6ns+ctJFNg2RpEmChQKQSn7kJA+9/3REqDrGses62vLQRyvvc2y5O3qjl2/xHLpbJj2szDoRyP7db29GHFUx69WkF1CS2CQxtesseuv/L/ZQqJazQt69E58GACBfekx98xmqhkKdHPvdhbf6+0p/2ozQtXJzdfg7oUSwCZHFbB6zim7CeHH09LkD0507tVjFoLXYBwTUHVF5ZptCiiURVUgr3ZJZ42Fw5v5h7Ni/eHXu4b6GhlyFRVbJgueN3zSI7CkE9yqXjPEVqQxHf+Mu5DJuBW3yktHlUL1ILF3SKrgGSlOH2T/dbIQhJAaS1Ybxg9TE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(53546011)(16526019)(4326008)(38100700002)(38350700002)(2906002)(83380400001)(16576012)(31686004)(6486002)(5660300002)(8676002)(8936002)(186003)(36756003)(2616005)(44832011)(66946007)(956004)(498600001)(86362001)(52116002)(31696002)(26005)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?blZNek5lMU1obkpmMEFkeXl0RGFBTnZqSTFYek02RUxHUkw4RDRJdnNWdC9J?=
 =?utf-8?B?Uzc3SGZyZVJVQzNEbjR6NVlhM1ZEOTNNVE9VVFJUZzViVS9qMmU1M0dZekdW?=
 =?utf-8?B?c2hyVzErQkZNV2VEbFc0VVZBL2dzbkhkNWo3elRpejQzbFovR0FZS1pudDhn?=
 =?utf-8?B?aHBvaTdmZE9oTkJaUTJ6SjlJMEpuSkxsRnU0S1IybGUwT0dkd1VsSHJGNWlV?=
 =?utf-8?B?enFoeU5aVXhOaG5jYk9UZHZYMVNKUHh0ako5cUVuTlpqVTdRcnk5OVhTV3dO?=
 =?utf-8?B?VWZGdWllaVpKMTdLUU5zMTZKS0trYk1PVHViREVaQWZIUGF0Z29nVVBzZWhE?=
 =?utf-8?B?RGVzTDNvNE1ybFIzeWNwMW1SeTRiNmtEa2M3Y1Z0RmhuTnMyUi9MSzlQQWIy?=
 =?utf-8?B?cjFZd3A0TG5mR0dNd29OQXNPczdDVHg4WXdFVjNqcG5zUGppT1F5R0cwdXF4?=
 =?utf-8?B?OTFQR2N4RUVPM0lYRFlPc3dZSk11UmRBdC93UkdlcUxCMEh3cUZEVWQ5WlJp?=
 =?utf-8?B?YTVPMlRud1NYc3M0RmVodG1YMzdnc04yL0Z0UGNWZlB6akRtMWUxdHF3a2Vh?=
 =?utf-8?B?aG50T2NUaFpiQnZOTmtoK2Q1SWcrdnRKMUI1aG1mSmxjMk9QczF4ZndqakVy?=
 =?utf-8?B?dUVpVmwzZ3UwUjN6eTFkUngrR2Y4RksxNDQ3UFlqVDN3NEEwUzk1WlA3ZXlh?=
 =?utf-8?B?MzZ6dzg2Y1A1b2tKNHZCUmVZYkNEZ1NwOFdIUTJ1Qk0xZS90S1JQU2xjOVFD?=
 =?utf-8?B?TjR3MUNqd0p3OHBpUVdNbU9kbjVEZWRJd0EvUTZESHUvNnBteWVibUtPY1d6?=
 =?utf-8?B?R2oyalhjSGZjZmc3NUR4U1NYdTJIeUQxUmJBS3UvcEZmOHhZSFBxQTNjUlpN?=
 =?utf-8?B?MkJaMWxTRkJ3eEtRaDNteldJaVBhSG1uWHZtOFdDemVoaS9welAzR2dBN21m?=
 =?utf-8?B?dE0wT0VlY1plMElLOFU3Qm4yeTJxSmxzL1RGU2dxUmtzSW1ScnhsdkJtUkln?=
 =?utf-8?B?WmtkRmlnaWRFVG9TdnNqbTF1RTd4alZQNEFsWkgxSjRNS05xNGlLZlhROVIy?=
 =?utf-8?B?U2JvWklqdWpWdzBNd0VqQlpKRENHYWRLbVQwZ0VDT0x1ZEpEZWpQeURYWVJF?=
 =?utf-8?B?eHRiODRvRjdmK2lFU3VVNE1tOWQwN0RRQXNNa1hxYlYyZG1Ha0VKQ3JUZTR3?=
 =?utf-8?B?blpHYVFVVU9uUTFjZkhxOXlYRFBrZVhnNjQzeHR1WjFEemR1KzlTMWxVdGdB?=
 =?utf-8?B?NDBLL2VDVjY0NzNkME1tVENIblJSbER0UmZEQjRWdjVFUVlhQjhUVmgycHZw?=
 =?utf-8?B?eVlnTzhTaG9VZUpWVy9qUE1salFiZy9wYlJXUDZhMitCQWJjcUl1U3RyclVx?=
 =?utf-8?B?TDRSaDBwZ3ROOU9oZkgydmVoU2ZnYmI3UzJtUUZzQWFGYWJqdzlYUXpzQlk1?=
 =?utf-8?B?YWowKzJpRmJVeWNnelk5eTZBSXZyazJ0Zm1McENvSFg2VFc0TzNMdS9FSGtZ?=
 =?utf-8?B?K082aGU2S0x1K0F1Z0ZxbERhS0dZR1FQSlpmTjE3NmJKaGhYVlBhVC9vQmJB?=
 =?utf-8?B?d2dYVnIzcS9DTXdNRGNWQk9xZ2lPak40UUc3aVR1ak14RUhJdHJvSWpwbE9G?=
 =?utf-8?B?Zkx6SnhraVMyZzRPUHBWZHZpKzU2N1UyVnRDRFlkV3R1S0V2ekpBalhiV0pN?=
 =?utf-8?B?dmZGTm1NMUh3WmhPY1FQcDNxTEJDSmJ2Tm00VVJHSkZXT1VFb0ZqbmJWWHRQ?=
 =?utf-8?Q?XtAB798/L1A0H1UuHeQf9kt7vAsb7pI72FoeAkK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d08dccf-6462-4a08-3338-08d90525a265
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 00:29:04.9152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +uVhO6P9lSIZxLEFHxRCLKbl5D9Sme7KhRkcrUi9UiGvikClbT0kqaAC7SwvScwOjplCLVJuqbcinEXdXHoKsyLBXml7QuzaNXJiVbaxguQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4496
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220002
X-Proofpoint-GUID: u_WzdJSE2mI1qE78ig12FbC7aDVBZt7v
X-Proofpoint-ORIG-GUID: u_WzdJSE2mI1qE78ig12FbC7aDVBZt7v
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/20/21 5:22 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test formats filesystems with various stripe alignments, then
> checks that data file allocations are actually aligned to those stripe
> geometries.  If this test is run on an XFS filesystem with a realtime
> volume and RTINHERIT is set on the root dir, the test will fail because
> all new files will be created as realtime files, and realtime
> allocations are not subject to data device stripe alignments.  Fix this
> by clearing rtinherit on the root dir.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
ok, makes sense

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   tests/generic/223 |    5 +++++
>   1 file changed, 5 insertions(+)
> 
> 
> diff --git a/tests/generic/223 b/tests/generic/223
> index 1f85efe5..f6393293 100755
> --- a/tests/generic/223
> +++ b/tests/generic/223
> @@ -43,6 +43,11 @@ for SUNIT_K in 8 16 32 64 128; do
>   	_scratch_mkfs_geom $SUNIT_BYTES 4 $BLOCKSIZE >> $seqres.full 2>&1
>   	_scratch_mount
>   
> +	# This test checks for stripe alignments of space allocations on the
> +	# filesystem.  Make sure all files get created on the main device,
> +	# which for XFS means no rt files.
> +	test "$FSTYP" = "xfs" && $XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> +
>   	for SIZE_MULT in 1 2 8 64 256; do
>   		let SIZE=$SIZE_MULT*$SUNIT_BYTES
>   
> 
