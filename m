Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68EE1C4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 09:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D84D6103B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 09:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhG3JRw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Jul 2021 05:17:52 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:14568 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238105AbhG3JRw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jul 2021 05:17:52 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16U9B03G025604;
        Fri, 30 Jul 2021 09:17:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=RqhOs376h7lTNQDNBt/aJgxOlASQIjHXk3Jy1k22T9k=;
 b=s2bfI2pjHPhalkSwCzxAPBLduoCKpiBBjLU020WOZavb9DGwoG921J6fKJjoBUmX5CcI
 B+zAca1oUXuPFNobUGGl0O3NXWTo7Fukv3vm5n6AEeHQ0AFUpyf8Vme28mfX7niAzMpz
 7uuDKbkILBhpjPNTor/K8MMxjMXRWETiH1BHN0zXMdGPSJLwkcds3Oxj3TchPKUeQW0g
 ibEZM5/3vHqE2bta0CRG0YkksPDMfGZj6whbU5ondqDmGO5YgoU9L7NJrtf7QxvekKry
 VxvY1+kbui/jl0rRopqlV5pN/jB6V+U0iPlRiZzfAtmGVWyl6b4jj4FyawQjJvqkRXYj OA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=RqhOs376h7lTNQDNBt/aJgxOlASQIjHXk3Jy1k22T9k=;
 b=iuRNmV0eZFOOgEAJGNaRbK7nmzwwQqRNveIae4uqyKFl/h/Xhjx+c1W3CfdIy3B2SfqC
 B2IviheFsZHKdH76Pyk1/NZzmDnQQGZy3z51FyetR81iI88DMga6Kfepmc2vZ6rVe2rB
 eTitywcA0/wfH9arhPBmAHYw4L4cy13Tml+gpSXW6j0fqO94M68WzNb+0pd/l3Zw/hPp
 yFFrVw65tG0h8RUP8nuUBgytSprKcZr+4BqB2DwcwxoPGKG0UajN2zA/gxelqYYRCJIB
 gRVpD6l0IhLgRJHMSou9+O6MOpSmphc+YOsyPsc5kJLn9CEeHJgoKL7NZRvnjur8D6d0 pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a3rukjqw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jul 2021 09:17:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16U9FeuY169529;
        Fri, 30 Jul 2021 09:17:46 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by aserp3020.oracle.com with ESMTP id 3a234dx1cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jul 2021 09:17:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fyYwFCNFcLrNgP674gI5c9ospj+IGCkhtN++QSmqRIKXC4K+X5mTwGxsuqo4yPPwU7X0JCWe61et+Gt/rzTCGlq4838hlStHeW817FOqYQnNRhy1d25M/j05WV8VpjTMNaLaGNy65Q7F0KilqAYs+igaMn6l1t5rPKqc4FCRBWESJdKZEHQRrxGy1HlleTTBIfBNzni5VUYUA5K2GcemzyMT0d2cr3PXQFoWyPchbSLNDmbJEM3BaJ6UX8d5w/riEfVEObZgyr+9Z+3bV8PS4MhHRoMK5MwwLdCXbIKDE0sGQPaDCYsmcoCU2clvEdB6N+py6M8gMKvGmRNX/l2hiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqhOs376h7lTNQDNBt/aJgxOlASQIjHXk3Jy1k22T9k=;
 b=WzwpgjLXFmZHgn4yyPAD3yIz6YQScqCFlhjt0LoJ42Gwa5zhgSFONg7CIfVYNayluUuxlrDV71L0CLxM599d9xEhfSblN2p1AuWJZ+NC+1ZfsWLSXVBakzy39046yUqPC1rNdkx6Hbr8hcIc+8cw0XRkwt/LQYygjprMc0Xal4EJKPR23cqSXOnBcKE0iOyD9odiHJVWaBT/1YipVUTBvtj/8usI8MIAZA+MNe/c3p3uvgKaTzzk94Fz8gd/A1YKuTmlhdF2cfg8CLL68QCU0ZBc6tM1E7qan8FRa4B1V2Pg4ErR2zLvS+gHzkxugo9ITCy6fBFTrPdAohH6VudXfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqhOs376h7lTNQDNBt/aJgxOlASQIjHXk3Jy1k22T9k=;
 b=eTjMfVrdzapNN8RWYKrh8wwlyEDM9bPpB1hxFvrvCgWkfXpjsr94ezajgqOq88CSiB3WPwMvWdxpNkVam7ABTW3rJmhhejuGSkRuR+KGQPDtHiOSk18t78+YSz2J2RCBf3f9Mg8wsoxHxifhD8toiLcMVsIfCUPpq/LI5nxsWP0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3384.namprd10.prod.outlook.com (2603:10b6:a03:14e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Fri, 30 Jul
 2021 09:17:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 09:17:44 +0000
Subject: Re: [PATCH v22 07/16] xfs: Handle krealloc errors in
 xlog_recover_add_to_cont_trans
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-8-allison.henderson@oracle.com> <874kcdfrt8.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <1ecdcd3b-9825-6afc-1b08-18ef8646a629@oracle.com>
Date:   Fri, 30 Jul 2021 02:17:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <874kcdfrt8.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0064.namprd08.prod.outlook.com
 (2603:10b6:a03:117::41) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.166] (67.1.112.125) by BYAPR08CA0064.namprd08.prod.outlook.com (2603:10b6:a03:117::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 09:17:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed64b4ec-2f57-4bf8-6df8-08d9533ae38e
X-MS-TrafficTypeDiagnostic: BYAPR10MB3384:
X-Microsoft-Antispam-PRVS: <BYAPR10MB33843C6E1552577F5C6B030795EC9@BYAPR10MB3384.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lJqQREZhTsOIbBzis2j2ti6fKRTy+pwowxFNo8g203HL4tPHSn298P1evmsr/1wN2FswcJyJa5ikZIaKjyNeFUn/XSbHS9Z695ULwIjr8is10Dmf+dXLKPHvveSHMKHnJgJOmFqzrxfcqG9hjOechAxPPOuFb6Nj1eTvGo63oYzBTIzCD35u+uXdC/LC/Mcwta91uC0xQcpl8uLCXh5CA+ztd9QrnTsr/P/TjpL6pihknr5AntTiulFBQQkt+o3Qv9hieDbl8p6jndaRdvipCjHZb0JLpv3ZZS/MV9JrzaRICt07bDfnXdmLmIWm+JC1ovaSe3pW67Hnc68WIchxK3lsSFlnySSSLR73Hi1HZpwVDliO3t2E9MBSdQVLg2Mtplp2hYxtaMx1IeTZxPKRishQFEN6A+ktWolbI+T6qMzDAGsLbrw5U9mr6pPrWAaj9+uSFQviicd0eZgprLOnHZAnSTDPDfb1MiBd0Kl8ptkvQOdmuWM9EEfZH6mfoOlD2yRKq2+vAr+9EBvuHpoOeE2rmJy5JiSPH9+POxT8Lhz8KZn8fs1p3hVRqB4wmHAzZFT5fCgqgLrN42p4vyJOPhTU/A9m67QRCRMxsOYdmFz6hSdb86wah8l6jd3UYtQzPqlyc7gev2UG+GAazdeNBFrUBHkZceRv6E32P/wk/CSoaBbSDTKFRtdG0+ybxAkt4PL+0kja3Fz04QCw8lHLERpPwbAGHo3KH+/oAN3pAgiZLbZVTR+jMUr+qJB8Xcqf3K0FgVK6Bf6V/sd8AW4NIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(376002)(136003)(396003)(316002)(36756003)(4326008)(16576012)(8676002)(186003)(31696002)(66476007)(31686004)(478600001)(26005)(66556008)(8936002)(52116002)(66946007)(86362001)(44832011)(5660300002)(2906002)(6916009)(53546011)(38350700002)(38100700002)(2616005)(83380400001)(956004)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXUrRU45Tm5xVVdpU21sTEM4K09aS2RHRUtIVGRsakVXZUpKdHQ2MnI0VURD?=
 =?utf-8?B?YTZYZTJLUzk5TFV3L3BtdzRTZmNjTDZCd296WlNialVXQlNXQXVEMnhjSUxI?=
 =?utf-8?B?S05PR3N6SlJaay8rK2l3bVVCUWpYV25UMUdKZ20yb3MxZ0FhMUM3UzNwalJE?=
 =?utf-8?B?Mk1zMUhEQ0hCc1QwdGNMbENzZTArT1k5aXhWMy9Zc1dWaDRNTVRjc1FKcGcx?=
 =?utf-8?B?MmNTempKcHgwdGNrWDRtaHdxdjE5VCtxS3czenJHODZpV3R6MDlrcjlhb3FI?=
 =?utf-8?B?b0x1RWFpMWN1N0wraDlvYS9uZ29yL2dpUzdGNHl2dGdPN1orM3dGNjAxbk9r?=
 =?utf-8?B?WmxnelVOeDVLVDY2ZS9mai9xRk5kNU4yWHVNVGVTcWwyZllqS0hRMVlnOWFZ?=
 =?utf-8?B?VEFobjlLTHBpWjZzSTg2QkxsV21HNDdURm55NkxNNHZlSGJGZVlRQjNlTFlz?=
 =?utf-8?B?TGV3blJnTytqM0ZYOEFndWRoUmFKV3hiVGd1L1ZrVmNwVXpVc2VRVjA0SzNN?=
 =?utf-8?B?dkZMTTdQd3N5b3FoNWl6RWlqNGEwdEQ5ekoxQm85c3hOZkY2dzhwc0xtRG14?=
 =?utf-8?B?dlVYZk1nYzJxZExnL1cxbktudVFwZG9MKzgwTzU0WjdabC9hdlNOZGFPS1Q2?=
 =?utf-8?B?cThwYUtYNXBaRmlPeU9VZVlabWlQY3dqMzFFczJCU1hhd3VFMXJ3cjdkVmtX?=
 =?utf-8?B?T3dkV2NOVS9mUUJCRGJCWEdaMW9IL3ZOZnNPaWF5QkQ3UEFCL2dUQmJUNy84?=
 =?utf-8?B?NkU3cHpmNkRlZFVTM3BWR2toQW9UTXkra1RSd0tSVExIbWJDM2RLcGMrR1ps?=
 =?utf-8?B?eXlDclR4bmdobVZEb3ZaTEJIWkgzOGxGTThuR1FRVU0xRmUzcm9wT2x0VkFw?=
 =?utf-8?B?bmk1SE9MSDBta3Jnd21zcEx0OG1GaFNzWHYvQUVyTHoyV2FIaURqNkFSMlBy?=
 =?utf-8?B?SGcwNlVuM0I3VU5LVWhxdFIwaDB5MGU1MGd5QlhzcXlUTFlPV21NVXlBVnh2?=
 =?utf-8?B?bXR3MUtrc2JPWitGRmVCQk0zWlM0VzFpNmh0OFNCU1B4Y0pjYjladHVPSEd2?=
 =?utf-8?B?S2tiRFp1eWgyTXVRYXlrNUlYWEZMdlB3VUNKTmpocERDTVFDdzQ5WU5YZksr?=
 =?utf-8?B?VTd2VmFieWkvdFJ1S20rZTkzeXpETTh6SVZmTE5Gb3VpdXdvS0lpSG40RGYx?=
 =?utf-8?B?d0FBZXUvcVNhOFlZWFl4TFphTHZKMUJPd1FMRE9iRzFRZ2lWMk9kWUw0dGlv?=
 =?utf-8?B?eG1PNDVEZy8zS2VXUG1kQzBmcTNFdnhCTGxQbnQxb1N0RUdpdnlta1BzYzJG?=
 =?utf-8?B?dGVPTlFlQVBxRE5OR3czdms4cm9kbXQ5QWxIRGI4ekFZdUZCcG9JdVNITUxS?=
 =?utf-8?B?dXVSQVc4V09Iam9iQVlDMFg3VG9ac2tyUjlXajRxeFVEMHFwNTdUSE96eXRX?=
 =?utf-8?B?UkpWamlENHhkenZXSkVrVFkyRW9xajYvem91NlpmbGs4VFRUa1FabHVKeEJ3?=
 =?utf-8?B?TFV5MjY1cUVpQVVkVDBrZ3l0NHpJZTZEbDVFZkRPWTZWTlVidFAxQ0NiRW9J?=
 =?utf-8?B?WnFvVWVhdXJ1SUFJT09SeXU2dHRaV05rMHdDUDkrVUdaVjBZeEY1djRLOXVR?=
 =?utf-8?B?dGIwUGxFcHJUVXVQUS9kTmFqSytETEU3YTUxVXN2ZVlQaFc4KzJWNTNkYVJ4?=
 =?utf-8?B?MmEwbWFBZE1TcjN3aE1JQVhpRzZjU2lmTmFHRGpWSjBEM0NwaGdLaDIyZ1gr?=
 =?utf-8?Q?RXMbRuh7UhWpxZR1yhkdPoWQpIsNByLRw62IAhi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed64b4ec-2f57-4bf8-6df8-08d9533ae38e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 09:17:44.1293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JHgDiP+GtyxMpTMq7+3F6vbuoIRWto+yu+OY9xs8zNFK/e5KjFFJKtqSzQL/fKHcrSn7uHZsqbvtK1/Q3nD6TIydWYvqa/xrSNHCQ4f2wDY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3384
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10060 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107300056
X-Proofpoint-GUID: 0VQ-7-FzDRKq-lBOZfqZcJ-5sbd-3H0i
X-Proofpoint-ORIG-GUID: 0VQ-7-FzDRKq-lBOZfqZcJ-5sbd-3H0i
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/29/21 1:27 AM, Chandan Babu R wrote:
> On 27 Jul 2021 at 11:50, Allison Henderson wrote:
>> Because xattrs can be over a page in size, we need to handle possible
>> krealloc errors to avoid warnings.  If the allocation does fail, fall
>> back to kmem_alloc_large, with a memcpy.
>>
>> The warning:
>>     WARNING: CPU: 1 PID: 20255 at mm/page_alloc.c:3446
>>                   get_page_from_freelist+0x100b/0x1690
>>
>> is caused when sizes larger that a page are allocated with the
>> __GFP_NOFAIL flag option.  We encounter this error now because attr
>> values can be up to 64k in size.  So we cannot use __GFP_NOFAIL, and
>> we need to handle the error code if the allocation fails.
>>
> 
> Looks good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Alrighty, thanks!

Allison

> 
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   fs/xfs/xfs_log_recover.c | 10 +++++++++-
>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>> index 12118d5..1212fa1 100644
>> --- a/fs/xfs/xfs_log_recover.c
>> +++ b/fs/xfs/xfs_log_recover.c
>> @@ -2088,7 +2088,15 @@ xlog_recover_add_to_cont_trans(
>>   	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
>>   	old_len = item->ri_buf[item->ri_cnt-1].i_len;
>>   
>> -	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
>> +	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL);
>> +	if (ptr == NULL) {
>> +		ptr = kmem_alloc_large(len + old_len, KM_ZERO);
>> +		if (ptr == NULL)
>> +			return -ENOMEM;
>> +
>> +		memcpy(ptr, old_ptr, old_len);
>> +	}
>> +
>>   	memcpy(&ptr[old_len], dp, len);
>>   	item->ri_buf[item->ri_cnt-1].i_len += len;
>>   	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
> 
> 
