Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119B1C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Sep 2021 21:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9D4161100
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Sep 2021 21:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbhICVKP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:10:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:39314 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235936AbhICVKN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Sep 2021 17:10:13 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 183IxdRk016547;
        Fri, 3 Sep 2021 21:09:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3hVf0Cq0vHgFXk5iM+wbhxKfcrNoByrScA1hLyzEHyk=;
 b=qCse7A3ohIYxDfBqDyBcWQMy/IfdpQRvZNnnwp6/C1ClJ7QLZ9SPosuwGt6rQiYZnH3F
 VpCYlX0ayAN/cH8yXV0TaOoHslLTbPreysj2BhFGWzHVcsaI0toK8akHTHIGJwJEL+wJ
 r9mEztfTOdmvY7kD+zMj4bPpjCz/0U72dKqe0uDtY5NO+S+w3ol0MK1D4K8N4F7Miper
 YcPOQPT8cRNzSrCY0Hm5wyxfZR1n0lbvVBWvwzFyc8AeLyfEo5ZfFjnuUSJX5WK4/pwX
 w2t7FCYxPQnYskt+XT6k4xIwsz/x6k0BOQcvixFbudpWAkrTIrFaBIisjRZzhl/JFmpQ 0g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=3hVf0Cq0vHgFXk5iM+wbhxKfcrNoByrScA1hLyzEHyk=;
 b=Bgfb5vWai+GD4axHUi1mekI1gsjzm2Iz/8ZYCSNx+Qoma9HFTOlV+GLRX/HGseH9wGXb
 U9uGdS6HvvEpErT2c3xzPifjgcD/JezNwvZnGZr/k1e4gIzbl9gNiw8dGpWm7lbSMGIE
 Pg+Y8tim0DSDdodnnW9f+IoeVtSK8DWegQNA828rY+ojjCVk0zKGpEVLc9wSy5pQ8aFe
 tfGTOafBChzqpRfm0SSxbPJMlqQc4JpCb21V0AOOZe4odASQW3p30R8fLT6dNWjBRrJs
 UQ6+/RfkY87IdpHF7l6C9/RzQvVqfCYzn9McfP+g/csOu8wiDekhvhccJATwbsmxcAh1 Cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3auh1r1nwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 21:09:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 183L5w5l037964;
        Fri, 3 Sep 2021 21:09:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3030.oracle.com with ESMTP id 3atdyyyf31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 21:09:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBOQ4iFFnjUVZ1RfCSYl+L5bLtwzX0buYXhxe0ds5Wuo+Bql5GvoJBD8vTDtUSnPiJZGehPSnzLDT65qRi7Es+Mw6ZyXJhNdOMZdf5Tqs1uq52po4zDOdvYiEQUjTOO4wbqv39oCKdREOoGW8OCuhSFpWho98SB5chE5qCRbKX2giAs2o7Q2td+StMMSpnEv5geq54mp962RzhNALhIyNpTVfcrLNr9dlTt2H77DWEuM/YWcKfBbcqpkKsGlqSQlcwV+nUXHthfhAmMasHYmoHNCeN+1Y20JJ4a+YSxyyg8JyrbjIakLIVXFUc7t269ldcY2c8QVQd5HhAWf3hg5zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3hVf0Cq0vHgFXk5iM+wbhxKfcrNoByrScA1hLyzEHyk=;
 b=gjYbz+6Q/FtY1WDM9w7cotbq5Heh2RHTEKJ+z02jJws+AMCU1taTYAsAguu9pnyBJ2DzWGNpyiwuDjqwNu8496cdQF/Q27WS4QUV4h1H4IhlxYUy74fTaA0mqrd6/tGzjptrhUYxeveag+H71l33ruFcA4xzscjt0PCZ/R2oTChIJpn89diZye4Xh5OmBxLQ7eXbYJZtjfrHLUN5CdIWU8tLXKcULd83QFiehS/YZ6g8rrJC4DHlliyiZOy94sTEMtM2fnORWyiqT6+anBWPc+a1KpoTDWRDp2HVyzf+v75IVcyBOvSPAsE4N7HoN7FjHLs4kW59nG3o42FVA2nifw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hVf0Cq0vHgFXk5iM+wbhxKfcrNoByrScA1hLyzEHyk=;
 b=hcHhBaxYgALzJUD6ANfxXU/FjNrUFFWJh3p+E7K4z1HRaUJmInHqSUVLM2hQZjaxgHAfKuBN3QbP8Fl3sIU7lzcfBbL9CR8TdmeVJ6zYj6A+Lwdoz/7Gc+G6ZS1QU8kdKV0yFl50f6Q4/DdbI/l+T3H86Xihkw4BPDKZ+xNQynM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4765.namprd10.prod.outlook.com (2603:10b6:a03:2af::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Fri, 3 Sep
 2021 21:09:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%8]) with mapi id 15.20.4478.023; Fri, 3 Sep 2021
 21:09:09 +0000
Subject: Re: [PATCH 3/7] xfs: factor a move some code in xfs_log_cil.c
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210902095927.911100-1-david@fromorbit.com>
 <20210902095927.911100-4-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <05fc44e8-28c0-61c0-1b90-68a0c1f7b73c@oracle.com>
Date:   Fri, 3 Sep 2021 14:09:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210902095927.911100-4-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::39) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by BYAPR03CA0026.namprd03.prod.outlook.com (2603:10b6:a02:a8::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Fri, 3 Sep 2021 21:09:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4839b2b8-bfb8-4f15-fb9b-08d96f1f1292
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4765:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB47655C69F2862BF0B07C7E7695CF9@SJ0PR10MB4765.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:132;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6tR+v87nAK/L96+RU1RGOArVphoxKI6KWeGjEm0YiSvd3SsOpptDCvzFQVAiy2OtfiriyZV/cLKxhANdZeYw12YHCtBTKx1o1nBW5rX+9hJzhneKK3jbfkypn/dVgAoXpWztsylSaxJ4eiKP/ry1ezdD47bZ+aMvB6JqZ0FZxsPfkA9uuoUVWpZcd5KR9ZC7HJ8fFfPSgN35vyPBBSaeoNYzuRV9+ejlTPGPRCzclM305u6yLsiNxu/hyoaBxvf+xaLy2Bg1/2TPlFF20PHVYfiUcIVzQber7ubOiPnrH9EHv23VaarYPtf+9vXpKzc7JDXwVoSo6F7aSRRakJLt4mHJCl2e9e2sEdQLAb6/jlR7C6Wyq4+AW4hk0p7V1bzffox+j6d3WyWhKYcrPq0R5vmuNE8EoUgwhCp3SdoQ7i21kWgfyh6q9asACfA7gt6QeziyzqUOQk/IOTSQnDBahZwlOkWYIb6TRs/OJbbvrnLjKylBUkglroWOgfAAVBZpk/zhUUmEzoyI79Q6iUI1eh8saUYR9WDlRfFLpcuq1lRssKwsQP5IgbXcmMsYO1cZpLupQex7xkLfCoPo/jA3Pb4fnPN713PqCnx7o7VJ+LX87ZViMkse0d7WDr5RZ4jo14/xO6goOUOvKFBq5knsk0pdcQHHIYgRKWEm6iITAxaVdhPTa5QmCm7Toy/nCDaD/bWx58zrH7cKkYTN64JDF5Y8csP5zLu8D1j6zQ6wNLzlo1Pl9tGa0xH1u9QcJs622OEP//gHrrlWoQdV+fGaNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(2616005)(5660300002)(66946007)(66476007)(86362001)(6486002)(44832011)(52116002)(36756003)(38350700002)(38100700002)(316002)(16576012)(53546011)(956004)(26005)(83380400001)(8676002)(31696002)(2906002)(31686004)(8936002)(66556008)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFRhZnRoN0JNNEF1dUFydkMyMGVwSG8yWDE0dHY2OXRQYTR1U3Q4c3pIeXdW?=
 =?utf-8?B?QXQwc1NCUCttNjhtNDMwS3BOYy93OFZEY3l2S2krWjhSVk5GaDNCZ0liTWc3?=
 =?utf-8?B?VExpNmt2QkZpMXZWNUJUcFNRZDBIRnBFanVRU3lIOGFXY2hwckg0ekFGRDZm?=
 =?utf-8?B?TDBoKzRvdTg0YktqMGtlMldYVHpJK3RVOTNqZEFOUlhPY3NlN1FjdG5tRGdN?=
 =?utf-8?B?WVo4SUtkMXpjRU5IK2tXVDhYWWVtRXppSXBwTnRVM2VlenBTb3gxejdWKzI2?=
 =?utf-8?B?aWJMUFdNZGtVNkhzN2U4dDJUZUlwTWY3enpLeTVyLytvdUN2R1crWVhCRGU3?=
 =?utf-8?B?SUdld2txLzNWOUh1cjVVdVNVMHU3WUNLeFhEV3dPMi9YbS9rK1ZveVBVTmtl?=
 =?utf-8?B?L1YreE9Qd0MvZEJuT004L0xlV0xRK21Ddk8wMzZpd05qMlMvSStQTFJlOEha?=
 =?utf-8?B?NnlZdTJEMnBGYXcvbkR0U1lIZGQ4WWZFcDNYR1FPZEc4amY0emZBQnQ2a3R3?=
 =?utf-8?B?N0tzOFNFSVcrUk9qUnpHNXpjY1ArUDJYalhMZ2wyVXJFNG5DT2krTjJmZnQ0?=
 =?utf-8?B?dXlhQnBqU1VBekZiY2RFY28rWGs5ZFh4bWlCMjZndlI4ZEJEMjFic2E4WXUv?=
 =?utf-8?B?bUhOUnNUcTE1QjJDRkNSRlVvWVJvc2YxVkNHYmx3eE9PL0djaU9TMFZpaTRH?=
 =?utf-8?B?M2RGTUhKTzA3WnRYZmJNamlTZVEyNkJYU250a2x2S3dQOFRtcGpaNDd1TTVZ?=
 =?utf-8?B?ZTY0Zm9Rb3NKaXZKS0Y2czFXUFJGaHRDc2E4dFRCa0hqUWZsczlxdXc5ZDBz?=
 =?utf-8?B?dHBxTnhPTENMMktVSTJvekxjMUVDNGhSbUsrYXBhRk84c3diWjFWOHVxcElz?=
 =?utf-8?B?U2N3SW5TQ0dtVGl2L3d6ZHpOOGRQQkJsN1E3Wi9QYkE2emNDNjk3dTYzTmdp?=
 =?utf-8?B?cXVwK1R0ak5KTXBiMmNqWC90QXhZS3IyeWJhOERzN1hXK0QrSHM2aXpqYzhU?=
 =?utf-8?B?ZCtBMElXNjY4MkdQaUFvRzZjcGNDMHFNdHNTSThkYmdrc0x5R3lDREw3Nngz?=
 =?utf-8?B?MzZHWkNyVWNkbk82WnZRMEJTQnRLMDFCS1lKVjJYVHFZY1F6Vy9vdk5GN3Rz?=
 =?utf-8?B?ZktjbmJoQVArbFZjb3o2Z3JQcEhTRkEzdUVxNjVESXJ6ZjRjWEl5NUEzL3Z4?=
 =?utf-8?B?VGVCZVg1OWUvM3Y1N3JDUmRqNnR5c0hJNkI0Z3pYU0xseVFOR2o1Q0NKSUNa?=
 =?utf-8?B?Q2R3Y2E1V2dhR2hMNzhQcWthbE00cVlXNVk0K3hQd2JRbEp6QUgrYTBpd3Nl?=
 =?utf-8?B?V2IrSGMzc2FRN05yOEFKMWhSLzk0YTVaSGFGc2N1TmhZeXV1cXppZDM0TWdM?=
 =?utf-8?B?TDdFMFJ2Ly9uTm1senNaSkpJSWtPNlR6cC82THZkb28xZUswWnphbmlrM0oy?=
 =?utf-8?B?amhORTNNMmduOHRjUE45eXZZSTNwUUJUZTlSUlhSVWs5c1ZjVFpGUm04aGhJ?=
 =?utf-8?B?dVJraVdvOWE1VDhsZ3BUcTBvWHR1SEhKak9sM2t5ZTExVnh3MThHUUpLU1hu?=
 =?utf-8?B?TFlxdGdFcjVDNWl1RTNNcHloOWlNbXRYZHBOb1g0eTZ5RDY0c0VKdE02VG9o?=
 =?utf-8?B?SEVWMmhHN2hSdzdDZUg3REJvOTF5aHlmUXFUWVFjZXVvd2IycWdlZDFFRjRq?=
 =?utf-8?B?YkViQkhHTnpDZ3ZhdkFCelZObTM5QS9yeThETW9vMlE2ejEwejZDUzE4NEJP?=
 =?utf-8?Q?IQQiiUN21IwAZyB5RRiy/zbQ+MPUUm27b/9M6/e?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4839b2b8-bfb8-4f15-fb9b-08d96f1f1292
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 21:09:09.6744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4tG+7CoGOx2xdN8fkrFzXNNe7q1Ys8/LJ3pjUhnZYuOTdQDmgooQWFfodmJw9RBURPFiYyRemBntW9Lt7Uc1yizeDPyIuv5WP1VdD1yhBZo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4765
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10096 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109030123
X-Proofpoint-GUID: 7pOOqDuOVw-j3jB9IG79sEuy_MQtsRwz
X-Proofpoint-ORIG-GUID: 7pOOqDuOVw-j3jB9IG79sEuy_MQtsRwz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/2/21 2:59 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In preparation for adding support for intent item whiteouts.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Looks like a straight forward hoist
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_log_cil.c | 109 +++++++++++++++++++++++++------------------
>   1 file changed, 64 insertions(+), 45 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 9488db6c6b21..bd2c8178255e 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -58,6 +58,38 @@ xlog_cil_set_iclog_hdr_count(struct xfs_cil *cil)
>   			(log->l_iclog_size - log->l_iclog_hsize)));
>   }
>   
> +/*
> + * Check if the current log item was first committed in this sequence.
> + * We can't rely on just the log item being in the CIL, we have to check
> + * the recorded commit sequence number.
> + *
> + * Note: for this to be used in a non-racy manner, it has to be called with
> + * CIL flushing locked out. As a result, it should only be used during the
> + * transaction commit process when deciding what to format into the item.
> + */
> +static bool
> +xlog_item_in_current_chkpt(
> +	struct xfs_cil		*cil,
> +	struct xfs_log_item	*lip)
> +{
> +	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags))
> +		return false;
> +
> +	/*
> +	 * li_seq is written on the first commit of a log item to record the
> +	 * first checkpoint it is written to. Hence if it is different to the
> +	 * current sequence, we're in a new checkpoint.
> +	 */
> +	return lip->li_seq == cil->xc_ctx->sequence;
> +}
> +
> +bool
> +xfs_log_item_in_current_chkpt(
> +	struct xfs_log_item *lip)
> +{
> +	return xlog_item_in_current_chkpt(lip->li_mountp->m_log->l_cilp, lip);
> +}
> +
>   /*
>    * Unavoidable forward declaration - xlog_cil_push_work() calls
>    * xlog_cil_ctx_alloc() itself.
> @@ -995,6 +1027,37 @@ xlog_cil_order_cmp(
>   	return l1->lv_order_id > l2->lv_order_id;
>   }
>   
> +/*
> + * Build a log vector chain from the current CIL.
> + */
> +static void
> +xlog_cil_build_lv_chain(
> +	struct xfs_cil_ctx	*ctx,
> +	uint32_t		*num_iovecs,
> +	uint32_t		*num_bytes)
> +{
> +
> +	while (!list_empty(&ctx->log_items)) {
> +		struct xfs_log_item	*item;
> +		struct xfs_log_vec	*lv;
> +
> +		item = list_first_entry(&ctx->log_items,
> +					struct xfs_log_item, li_cil);
> +
> +		lv = item->li_lv;
> +		lv->lv_order_id = item->li_order_id;
> +		*num_iovecs += lv->lv_niovecs;
> +		/* we don't write ordered log vectors */
> +		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
> +			*num_bytes += lv->lv_bytes;
> +
> +		list_add_tail(&lv->lv_list, &ctx->lv_chain);
> +		list_del_init(&item->li_cil);
> +		item->li_order_id = 0;
> +		item->li_lv = NULL;
> +	}
> +}
> +
>   /*
>    * Push the Committed Item List to the log.
>    *
> @@ -1017,7 +1080,6 @@ xlog_cil_push_work(
>   		container_of(work, struct xfs_cil_ctx, push_work);
>   	struct xfs_cil		*cil = ctx->cil;
>   	struct xlog		*log = cil->xc_log;
> -	struct xfs_log_vec	*lv;
>   	struct xfs_cil_ctx	*new_ctx;
>   	int			num_iovecs = 0;
>   	int			num_bytes = 0;
> @@ -1116,24 +1178,7 @@ xlog_cil_push_work(
>   				&bdev_flush);
>   
>   	xlog_cil_pcp_aggregate(cil, ctx);
> -
> -	while (!list_empty(&ctx->log_items)) {
> -		struct xfs_log_item	*item;
> -
> -		item = list_first_entry(&ctx->log_items,
> -					struct xfs_log_item, li_cil);
> -		lv = item->li_lv;
> -		lv->lv_order_id = item->li_order_id;
> -		num_iovecs += lv->lv_niovecs;
> -		/* we don't write ordered log vectors */
> -		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
> -			num_bytes += lv->lv_bytes;
> -
> -		list_add_tail(&lv->lv_list, &ctx->lv_chain);
> -		list_del_init(&item->li_cil);
> -		item->li_order_id = 0;
> -		item->li_lv = NULL;
> -	}
> +	xlog_cil_build_lv_chain(ctx, &num_iovecs, &num_bytes);
>   
>   	/*
>   	 * Switch the contexts so we can drop the context lock and move out
> @@ -1612,32 +1657,6 @@ xlog_cil_force_seq(
>   	return 0;
>   }
>   
> -/*
> - * Check if the current log item was first committed in this sequence.
> - * We can't rely on just the log item being in the CIL, we have to check
> - * the recorded commit sequence number.
> - *
> - * Note: for this to be used in a non-racy manner, it has to be called with
> - * CIL flushing locked out. As a result, it should only be used during the
> - * transaction commit process when deciding what to format into the item.
> - */
> -bool
> -xfs_log_item_in_current_chkpt(
> -	struct xfs_log_item *lip)
> -{
> -	struct xfs_cil		*cil = lip->li_mountp->m_log->l_cilp;
> -
> -	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags))
> -		return false;
> -
> -	/*
> -	 * li_seq is written on the first commit of a log item to record the
> -	 * first checkpoint it is written to. Hence if it is different to the
> -	 * current sequence, we're in a new checkpoint.
> -	 */
> -	return lip->li_seq == cil->xc_ctx->sequence;
> -}
> -
>   /*
>    * Move dead percpu state to the relevant CIL context structures.
>    *
> 
