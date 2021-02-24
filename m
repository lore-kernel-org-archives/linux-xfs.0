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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC181C433E9
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 05:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C162564EBB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 05:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbhBXFkp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 00:40:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49116 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234023AbhBXFkg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 00:40:36 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11O5dGNg070554;
        Wed, 24 Feb 2021 05:39:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=50mfxPHIxMaqndm+qZt5HSyDs7XtQZGCfAXyZMIBU5A=;
 b=GpK76cc7Jly/CoIq75zVliD4qodo8kI7VZVq/nMHb3pvVQOOKhmnTE5HB2UuPFmx96rc
 Ic9niuPr4XfUV/5C5vRS4/tXxWKCbieNEackIcOB/z2t6FPJKgCOaLeD1SaUaeRtsnyy
 QM8pVXqdnKl4/Co073iZzeFFOm/8KFt3vLgc1laVtjdP8sapdyDwSJaQwjdZqKZ5w1nr
 V+8mupw/hyYijtS79ZTkQQktx4DPydTWy4M/0IEb2BYtRiMOonFgQnFPve+0wzeKVCCU
 ttheGBjsHxzsM3cPQZm5UM8Kc6Q4sa2VJVxMsOCef4FGgUhbXidDt/nYZZx7swZ7bimZ 8Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36tsur1ps4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 05:39:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11O5aTe3040635;
        Wed, 24 Feb 2021 05:39:48 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by aserp3030.oracle.com with ESMTP id 36v9m5gghk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 05:39:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJ1y/T0pVc+s8jCJDQpx69urfBdMePaQExjjLzDCfNKaGjzH3qyiaR2BiftrLXNPRiFkinBWC5JXQM0kV+r55qtI2AuxfJVVZGq7fhQMVPilA1q7l4a13pxpajwXK+vFNnDN6HhmuSmSFepvwhLkKPnNxYqVAZPHUys5J3SEP0XqBP6wQbI0uzT1GUDbBUrA3KfNtZr0nuhpfhKIDDSveMIWx0dwjc5BeBS9Ym7kYlDe6Mw5HlNy2d8FJqQcKnbRHBaiSE5zsWHeFjpXJQD4A00oINbXxVXetS4DfnTA2BL2exzIT8Ak82TDkogMDSIQlyvuaVoxk1xqG2lunTMIKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50mfxPHIxMaqndm+qZt5HSyDs7XtQZGCfAXyZMIBU5A=;
 b=jh4/QeQXbrh3DKC1ZS39afZ4n8mWt6Sj4f2qdq7HZBMmZQF/gcp37ZTG9RCXopI8FwZMeKN2kRsqE4zBIPR8L7hKsbK+Pxet3r6huP6lizmywjvuZZUnmIQOc0xjVcM0PuM+qXMvrzu4kC+w+/Oti5t8J1l160M9U7L+awxYajjYgvUPL7qF8C91Jnjs6/nkHn5tQhZ26xsZ/jTDAYsNQAx+BnW0tkBSs+cRQI8knRjb6uSBki90uJgRuzA/mT3PSVQhqyGWRIa3CvErCBNQas/3qdPuOhkKbYsDeebotTBKqI3K10mmjZtAja49iSn3A2DRrjsazRNICYiPWCgnmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50mfxPHIxMaqndm+qZt5HSyDs7XtQZGCfAXyZMIBU5A=;
 b=RYLEg2PpwTEvX8yosr4U91PJRxnxNROQk1+ITlpkXzAuGcMu8MI4i3BxeJEg7xyoTqkbNlxH3+FD02tdv40lkhetojWDpeBZTql4WtB4Fly5ayafns13Dbc6VNyW3WrlTEI3ap5amhGU9by+0lYr7lZ4s8nKjNNg/V9NCBLc5r4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2437.namprd10.prod.outlook.com (2603:10b6:a02:b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Wed, 24 Feb
 2021 05:39:46 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.019; Wed, 24 Feb 2021
 05:39:46 +0000
Subject: Re: [PATCH 4/4] xfs_repair: add post-phase error injection points
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <161404926046.425602.766097344183886137.stgit@magnolia>
 <161404928343.425602.4302650863642276667.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <83feeca7-f016-fa30-3caf-bf7f4fe1711d@oracle.com>
Date:   Tue, 23 Feb 2021 22:39:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <161404928343.425602.4302650863642276667.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0072.namprd03.prod.outlook.com
 (2603:10b6:a03:331::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR03CA0072.namprd03.prod.outlook.com (2603:10b6:a03:331::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 24 Feb 2021 05:39:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e0a21e3-a243-4742-0bd2-08d8d88697e2
X-MS-TrafficTypeDiagnostic: BYAPR10MB2437:
X-Microsoft-Antispam-PRVS: <BYAPR10MB243739B7B8FDF94863B73956959F9@BYAPR10MB2437.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:22;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TQAeWhIoBe6OCNrYibYDBAMk1JCS2xDRpI+tecpWULF2bXPGdSZ+UiCqPMgHAEebUcLr4UvEI63YNOFlBWw9jS8oU2fxM2vbqb2ocPjkxZkkWz3UVMRGRNW3TgE6iz76z0is2JqY1uW+o7kx7koP7oA7Zgv0uDTlAxX6pdE6ViSkGFfWqr+CSwWhumSbB3yLmxKb1GvEok+0Qz52uwJgp16wjyHhSa29CRFQ/ZX/cqO63YeDOxDyllCzkf7x7Ks0gxCWhRZluuZdL9h4GqIIbwBORhM9rCmZIf/1rIhr5h7j20ljYBjjOX3exVNOTsipq+OXHYjqqeozTfM37awhkwya48OUxMQeNnQKQsZ0blDGP+0F77iQYsEh+QWufYt0Kn5p4hHsGvAJFJyo11y39sPp5j/SZpN0bbYQSQ5hguGyHQ5xWFX2ZwF9nSyhKC2hE55760YatWPYENIfBJq4pGboz8cswTQGZTNXreKb6UFj9AfX79hWh0bNHVJ2z3ujpQM8+EU2H2PUGaU/5/PLHp2hPpq2NrEvG+UPBJtt9IZi/MS+WUSt8Cy78EilRVSqvlc8ezfz5b51abxb6Zd/ovq2vERaw/PeS79JLHS0F3Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(396003)(376002)(8676002)(316002)(26005)(66476007)(2906002)(4326008)(478600001)(8936002)(16526019)(186003)(5660300002)(53546011)(52116002)(956004)(44832011)(54906003)(66556008)(83380400001)(2616005)(36756003)(66946007)(16576012)(6486002)(31696002)(31686004)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UnZjS1NBUnVJSlpVWDVNK3FEQk9KT3F4OEg0SG56eWJYaGhlMWtWZlZGRFAx?=
 =?utf-8?B?N3hRbytXb2txdkpJUXlkV1NLMG5BTE9oZkxHSGIyNkM3cFEyalBWZDUzbHR4?=
 =?utf-8?B?VlJUcFMxVlRHR1lyK2Y0bnhYdzB0c0hKWWJtV29xUXZISjR4SWZIazZncWNv?=
 =?utf-8?B?QUpoL213TzUwWmc3anVObWM2ZHFRR3Z5RDNaRVNhNVdWME9QRWFQaktMTnNs?=
 =?utf-8?B?MUQzb2xNWVFaN2pERTQ3WW1lWnl0K3hlYWx6bGprOHhUdVlXUFJnb2xMUGhk?=
 =?utf-8?B?bTM1VEl2dmo1WTJsZFdObWhJcTlTTGN4amVoSlQvcThyOUowNG0rS1VaODda?=
 =?utf-8?B?c1kyYUthaERqQk53U3dyaXB5Z295SjNWSE5BRzNiRC8wVnNuQ2JSeW9LSE43?=
 =?utf-8?B?R1plWi9WMjJnWU4ycThVZzh5MGYrbEZCb1l0cGFLc0kxTmZyc3RaVGVkMTE3?=
 =?utf-8?B?dmMwNVRCR1VtWTVjVGxWbll0bFplOXphT0FINEppVnBwVldES3plSyt3MnRz?=
 =?utf-8?B?L3hKb1B3d1AzZi9HOXFEZ3Eza05tdmREZmJTa3hpbnFuQ2xsczJodS9jaTZM?=
 =?utf-8?B?NExNdVNVeFRPWStJZUZoaHdKWEhIdFpOajZmSzFpUGxZcnI0V2J5UVZFUnM5?=
 =?utf-8?B?RmNIandQLzlBbFlPbVBQdTlvM3B0TzVNYWtDUVNtY1RMZ0xQcTJEL2FhYXFS?=
 =?utf-8?B?N2crbDV1a0F6MVRwUGNlcTB3RzBBUUlJT2t1VDd5c01KbEhIdUhuanBYVkNv?=
 =?utf-8?B?U21iL1JLNUQ1STQ3SHc2QVFZQk14U3hZcjBSMkNERXoxL0lQcEJoanRKQ1Z5?=
 =?utf-8?B?Z3hIS1F3ZS9wUkQ4R09KWHBuVVdFdDNZd0hCWlUxb0drcUd3Nnc3ZHZTOHA1?=
 =?utf-8?B?c3lKUGJLaGp6NEsvN3VtWXcwQTBCc1Vxc2hKNHBCMk5NcEtua050bDdNZ3dF?=
 =?utf-8?B?V3UzMWcrQmFrVkZNeWs1Nm5KV2UwSUZCTWdyNXN3WVNMQjNraW1CcTJZWGNz?=
 =?utf-8?B?SldmaTB5MFJiQmVwenJMbHZsZ1N0WWl1NVFvYmwyQnZ3TzRQMG01VkQ4OExB?=
 =?utf-8?B?SGRHMzNWMkgzc1VWWFA4VCszenRvQzkxMFlJNEgraFFvQkptcmJveDcrWVRa?=
 =?utf-8?B?RHVKQWJaVmNkN1ROOWZWTnUvdVZkSFpKRTRScUpDc1luTGhJQy9TN2lmMFlz?=
 =?utf-8?B?RFZZWHMxRzMrZUNrd1l0aHZHRFdnY0NsWXg0eWJFZ1YzT2xBVWVJYzNHeXgz?=
 =?utf-8?B?OHNIMXRqSDBwNUhjMDE2bENoK0VPUGZUd1F4NU1aTk9wYUZSYUJTN3hnZzI0?=
 =?utf-8?B?WnNTYVVkZW1lMGhha01yYzh0dUtJSHNzUnpRZFpScmtEaGgwUk9admJmbGta?=
 =?utf-8?B?REJKZ3M0Vkx5SDNHR1dWUG9nWW5YWDl4ZXdwc3NyM1J0Yi82WEJGYmRkdFZM?=
 =?utf-8?B?TEp1Z0RMV29HeWdLWUg5VVdRWnMxRERvei9oRVUyR2w5cWRSSmFWdWVXRUYr?=
 =?utf-8?B?b3B5U0twem5HMysxd0VxUHpZTlV1Q2VVcEZxSE41QVo3ZXBFRnBkdHF3SEdO?=
 =?utf-8?B?MkJWTGRpUlZUS3NXd0F0VVBlZ3NQQ1RMS2oxMzE1d2M0U3JISjVCbmVtSkZz?=
 =?utf-8?B?eTlML0hnV21uWHpFZkYzcENpcHJYeXd3cEtObk01dDdjcVNVT1hsQ29oeFBv?=
 =?utf-8?B?QVA4VTdmMGJSQ1Z4Q3pMdld6WVE4TTRDNnlYem45elhqNDBTRTFXVXRkYVFH?=
 =?utf-8?Q?4vnaYPRX8Ao7O+Zcz9Y4GhQEd/hvx6JsnCscnU9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e0a21e3-a243-4742-0bd2-08d8d88697e2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 05:39:45.9869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GTC3gYlcI8TsWaAEJcO9fPrwfVd/fRnm4YJBTic+wcZLS9omhg4l27nNlN08QQJ4CXjRWBTdfGJnhCSjd5undz81nW+rxhUFSSkmdOIzDNg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2437
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240045
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
> Create an error injection point so that we can simulate repair failing
> after a certain phase.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Looks fine
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   repair/globals.c    |    3 +++
>   repair/globals.h    |    3 +++
>   repair/xfs_repair.c |    8 ++++++++
>   3 files changed, 14 insertions(+)
> 
> 
> diff --git a/repair/globals.c b/repair/globals.c
> index 110d98b6..537d068b 100644
> --- a/repair/globals.c
> +++ b/repair/globals.c
> @@ -117,3 +117,6 @@ uint64_t	*prog_rpt_done;
>   
>   int		ag_stride;
>   int		thread_count;
> +
> +/* If nonzero, simulate failure after this phase. */
> +int		fail_after_phase;
> diff --git a/repair/globals.h b/repair/globals.h
> index 1d397b35..a9287320 100644
> --- a/repair/globals.h
> +++ b/repair/globals.h
> @@ -162,4 +162,7 @@ extern uint64_t		*prog_rpt_done;
>   extern int		ag_stride;
>   extern int		thread_count;
>   
> +/* If nonzero, simulate failure after this phase. */
> +extern int		fail_after_phase;
> +
>   #endif /* _XFS_REPAIR_GLOBAL_H */
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index a9236bb7..64d7607f 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -362,6 +362,10 @@ process_args(int argc, char **argv)
>   
>   	if (report_corrected && no_modify)
>   		usage();
> +
> +	p = getenv("XFS_REPAIR_FAIL_AFTER_PHASE");
> +	if (p)
> +		fail_after_phase = (int)strtol(p, NULL, 0);
>   }
>   
>   void __attribute__((noreturn))
> @@ -853,6 +857,10 @@ static inline void
>   phase_end(int phase)
>   {
>   	timestamp(PHASE_END, phase, NULL);
> +
> +	/* Fail if someone injected an post-phase error. */
> +	if (fail_after_phase && phase == fail_after_phase)
> +		platform_crash();
>   }
>   
>   int
> 
