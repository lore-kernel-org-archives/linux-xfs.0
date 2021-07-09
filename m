Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED990C07E9C
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 23:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D34B9613C3
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 23:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhGIXl3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 19:41:29 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46238 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230130AbhGIXl2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jul 2021 19:41:28 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 169NUe4c005756;
        Fri, 9 Jul 2021 23:38:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=eSZ6etavOrFQhJdLPOknxs6aJS0Z1mFuLZkgDeOvx1g=;
 b=ZoKX69JLmCUBJYRARvBGqxfSKIZkV+uNmZseM4VFJBjOv09qtZevK7KLfqerjKLWb9IH
 Fqo9+NLKZOvq4yaqwglqs0KLNeaRsEezgbjtxcbhlqH8lEPzAzGCeLQoboOtWioTa5cy
 auwWMhYU4ndXQ4iTi7Zwik+2g0HYm0OVPHTqOFi2wIXpvMTVCKIaUeKZqnJKaqf7043V
 +mx7YTAIwZnlvlGbJ76fNkyvMI9SrU4YEkl2hrHTu47YSvmVFveXlNP1n2Z6ZhP2aZ/8
 V+cZZJsHAWOxHfZRD9T6ndW1LyWZD0Dg2WQi+4KPJOg/LZi3XF8eTAungT11qDCJBi9T aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39pte5ghse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 23:38:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 169NUi2L043143;
        Fri, 9 Jul 2021 23:38:40 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2042.outbound.protection.outlook.com [104.47.74.42])
        by userp3020.oracle.com with ESMTP id 39k1p703hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 23:38:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EnJMVPsE5YOVQSUzwI/0E6EH2r2liBkI8pxoiQhff2ZEhUfPDeB2SX+D1/RYqE9ohHq2nFTsXgV6jWoEerxlmvcrga3/q0vEV1LitBSNxsiPd0zsznuWMzWj8WzvoyT21MKNnOUNNt2hHNy2gOxqEfV+YoP1B1DdFn4bZvN2NWHIYuprTC8yZXXdoIOec1fBwRDrrhfZEt2YSi3/UCNlWf+J/d4tvt9Yx4ijs5pz1/1fJvH9i1WxCOZ7GjLp843CSBeh6amdiHHtjisOdRuPX2m60ZMGv4EStWM28EYX62MHT3LHTMgCrddQw6aFONK1A0X5GTzsIwRpeLE84/nIyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSZ6etavOrFQhJdLPOknxs6aJS0Z1mFuLZkgDeOvx1g=;
 b=d/6B9v/5rbedneJUEkhp+hIWdK780NtalRtuTLv67Wbp4o4P7p08H+7neBtI0n6ZYyIBgGGXhkF2qVmxb3AAb7GoLZsxtKHiYJL+2R39v9G05Z/BtpfrzhxUt9cOR20hUtQDrr1yFK9k14ma4JbmsU31tJ3oPrAoCS2asKyJvxg+CTF+gfYnT8DjcBXjG4f7xwoMb7SWJ5TcUYMJCB8YuxQRsCdfCq+qDcIrQ1VkOcowq1WOMfVXVxAMUaZ9oDCvwfgSyp8Eo+6Jj56pvwFGnBfzFkY1wChsF6AZ6krtlyOwtK9hQdQrTBvIdTk28mRXc1JRQKX/MW2fi5hrg6vmRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSZ6etavOrFQhJdLPOknxs6aJS0Z1mFuLZkgDeOvx1g=;
 b=Mt72BHIEDLfKWpnZj9i4wOzjXSS2lF8amaoOdk8uboC+RDile1C363eNOPdb/z9cfpnggqjbLk+mA7uRKvdyuSEdBZylb+edZFZPPWiRz6Q0UXlS4kE+toVlCMXXsd8CmXpCJIC7OdbBQowxp0rScFlGv6/Nf9QRLKEHXoPbQzY=
Authentication-Results: eryu.me; dkim=none (message not signed)
 header.d=none;eryu.me; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH2PR10MB4360.namprd10.prod.outlook.com (2603:10b6:610:ac::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Fri, 9 Jul
 2021 23:38:38 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::807e:3386:573c:ad06]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::807e:3386:573c:ad06%5]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 23:38:37 +0000
Subject: Re: [PATCH 1/8] xfs/172: disable test when file writes don't use
 delayed allocation
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <162561726690.543423.15033740972304281407.stgit@locust>
 <162561727244.543423.13321546742830675478.stgit@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <1174710a-d9cb-54a0-993f-e1ed410305be@oracle.com>
Date:   Fri, 9 Jul 2021 16:38:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <162561727244.543423.13321546742830675478.stgit@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0018.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::31) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by BY5PR16CA0018.namprd16.prod.outlook.com (2603:10b6:a03:1a0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 23:38:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e7e5bc8-2798-46e4-2d5d-08d94332acc0
X-MS-TrafficTypeDiagnostic: CH2PR10MB4360:
X-Microsoft-Antispam-PRVS: <CH2PR10MB43604CABBBFB552E232EB91195189@CH2PR10MB4360.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Pu4hZskQ8jq6uXdPFaFPpqdMhchZBM6E0YGvYYS16Cgftmm57LvVgopFEv2oMfXARyLf2fbZGuLm0iKJbF5PtyOODMOvN/GoUWBdD/u2/sBFO8ZdXXRUk0gfUg+O43Wd7wzXSilFtZOiO8Jb0BiPhIrv90rCvXgNM1FnQe4/vhfQUHe/MpcNVNevxwgljoZ5BC1siAD2AZRGCytPBnRA0RyaqFo763EwSAn8Q6xoSSPF731omZnVNRah+w5Ypt/gPmwcGUEnmT4mESBBxwBMAeLVengcD01AY/ajGQoe5hylFDMiJB8Eh0dIXbDCpndd7o7SHNvlXjYUxk0GjfLud5txCQiawXtwj3T4rRXNdO8lq7ncOuy9sojXOWjNDYY9X7RYJBlUuIUlxbGEwz53HATmJkhZXQpwmxnrC69rrB487MtuRsbR3qCb03xpDFE2PsyWqdyO1YdtWePXKvKFTPPVJnU1MP6DMog+jzchmxLXwENQ2Jw44TWV4v3UvoOcdAgaPVirxchTxVnQpeKdnaLOimpHeuYbOMyPgPDf3/icZtsbcph8w8UngOCL/6pGhF7aDYV/EoYkBvkrBehoKU6GxshFRoF+m8BL7nxXkrawjyxAmInUuqAsVxLVCuEa4+uQmSX0FcwmfmhZYfsZJdmMYUy8RuM0bCjpYRgpdVWvHCA4lpd/ejUPOLizvCwG03b8/ughe6ydGRG09vxFEcNV48IN6UUNpyGEvV/WzR0kD9F4cYae6XFO6/M+D62q9IrFiX3mZ/4WTic2HOqdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(39860400002)(396003)(31696002)(86362001)(52116002)(186003)(38100700002)(5660300002)(4326008)(316002)(16576012)(83380400001)(26005)(53546011)(2906002)(38350700002)(66946007)(478600001)(956004)(66556008)(66476007)(36756003)(8676002)(31686004)(44832011)(8936002)(6486002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Uy9ISExCMktLWFpvaEdJTGdzc0pnVUh4WGk5d3F1QXBGMFRrN21obU5OM3F0?=
 =?utf-8?B?RS82Mmt4T2RJUFRHUmo1aWRvZ21qWDhndUkycGFseGpHdHVuWUN2ZG8xRHNv?=
 =?utf-8?B?TEZhWTI0WVVYTVl0M2FkWVh6Q1lTcE55cm4rN1I1UldYeUI2a3NBNUNSMkUr?=
 =?utf-8?B?MGhCQ1ZSTmFkbE83SnBHK1VXYzVWM3J0b1kyV25NWjhOQ01XWFBxZzl6dnZr?=
 =?utf-8?B?QlRWc3g4N3JXcHoyTzdRNTQ0MUxzVWozb3FjN3lrVmNJdGtPZ0d4MHIrMllE?=
 =?utf-8?B?ZUJvQjZIdnlWWFR6WGMxSHNIY0RqT3JzUDM3Vjc4cmlPYXd3L3FnZVRvWjJ3?=
 =?utf-8?B?K3BrVHUrMVNnRE1TUGR5eVBxd0U0bmRhOVlvMlpGOW80ak5sbW9UbnhuTHJ1?=
 =?utf-8?B?SGhaZ0tRbUVTTlRlT0diMDFJTktYUXpvSWtxSEpMbU9IMVR5cWFqRGFzaVVG?=
 =?utf-8?B?cWQwQkR3ZllueEtrUnRzWXZLVWh2b08vM1BLTmdlRG9lSHRndlFkbmlSZHk3?=
 =?utf-8?B?S21EM294TVRzUW96NTc4UHRwRVZWV3JqV2d1ZUhHR1ZyZGtHZW4yRVlydUox?=
 =?utf-8?B?VkdJYmVTMld2TW4zTE9iUUlJOEM2VUFBNE5SZ2lGODZIQ1BDdTN2VWpYY2pt?=
 =?utf-8?B?OERwN2dHb20wWVdaNDE1L3FuY1hFR3c5eWEwS3RjcFAwVE5QRksrbHdZdGFw?=
 =?utf-8?B?b0I3clNYUlZtNjdMci9hRXlKQm1MMjViZnRnQzk4Ym1TY2NaTkVyZFlPUTR1?=
 =?utf-8?B?S3RBVnI1RTJhUzRERGh3cXFtMC9MTlRhUFFMWmVwOXU4akFKWGdPSVNLSjFs?=
 =?utf-8?B?WFZEUWJzUGgvbGpWeFdZb1NWMm8wSitraHBiZGdQY2Z3NzZlbmQ5Nk9GRWxU?=
 =?utf-8?B?Um4rSllzTzMwaXpyTXg4NWlkcmx5U3dLaGJlYzUyaXU2OFBsUmxXZEM2K0ZF?=
 =?utf-8?B?eEhnOW9Lb3gvelNYVnhMRXRJazdnM2ppaWJCbjdLd0t5Tm4wZmJFZFIrZ1pH?=
 =?utf-8?B?Y0c5R2Qxai9qdjlTSjFlVlhFUVVkMFpYOWVSOGxWR3N2OE9BdndQL1krVWh4?=
 =?utf-8?B?SXZieEE3VnFPejZCRHJ0SWgxQWljcVlTeUhGSWoyTy9vVjM0MnlORXQyRHEr?=
 =?utf-8?B?ZVI2RjNxTWpUMVpLcGFNNkpGellSc3hiUm8rUHRtMURva0tJdi9uWlNxa0c2?=
 =?utf-8?B?VXhkUi9rbDZ4c29MMmJsYXBkTFFLdXlGMDkxSVhlczJZakhOMjUwdmdJcUhV?=
 =?utf-8?B?eDV2S1Z0WTJaYlo0M1EvRjJZbGx5T1dyMEpOY2Z3T2cwcklpT2lZUmxXQzNC?=
 =?utf-8?B?TDM0ZUI5alRKaW5QVE51cDk0TVRWMU9sVHhXUnUvUUdWaWQ0bmk3ZW5uKzJM?=
 =?utf-8?B?OTQ5em5zZHFBQWpYSDhEaUp1eGs2ZnFYZERxUndPZHdqZSs2STlJVFMyT0k5?=
 =?utf-8?B?c2orNncveEtIUG8ydzhIK3FYRFNsWEVjajRLdFRwL0gwa1NaYlgyNEtEMHRq?=
 =?utf-8?B?Lzk1TWNxWjUyaHltRVVPMDNya2hVS0FkQUdSdGZYSm44WUtMeVhSa2kwOXFm?=
 =?utf-8?B?NWNWRUJoWlZNUUtlVTlUb21zWGY4WndmM0NEcURLTEpZS0V3M3lVVUpHK2pw?=
 =?utf-8?B?Qm1SdlRXRzAzMlM0NDVMOUY3RmoyeXRGZFRwTU4vdU8wVTVzME56dk1IK04x?=
 =?utf-8?B?TU9Vd0tROTZjcE9MS0NjNk9mVGRka2NRS1JxVUFjVVdnYWdyYkFMdkw3V1pB?=
 =?utf-8?Q?gyvwl8DzQGh36LatpaUPU7gMVAiAxaEdAwn3q8E?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e7e5bc8-2798-46e4-2d5d-08d94332acc0
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 23:38:37.8722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0mymHt+zrP2KtUhkTkBIfyDs+WlxKzxvJGfk81JQUrHLLXCdKFEgr29Hogs7CxXDJ4koAixJtw/LefSCK77gfSvnUk8eQUORcuLnm0aBxOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4360
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10040 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107090122
X-Proofpoint-GUID: RI24_ZFqqW0v7elA7niu-0J1zQ29tDSJ
X-Proofpoint-ORIG-GUID: RI24_ZFqqW0v7elA7niu-0J1zQ29tDSJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/6/21 5:21 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test tries to exploit an interaction between delayed allocation and
> writeback on full filesystems to see if it can trip up the filestreams
> allocator.  The behaviors do not present if the filesystem allocates
> space at write time, so disable it under these scenarios.
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   tests/xfs/172 |   30 +++++++++++++++++++++++++++++-
>   1 file changed, 29 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/172 b/tests/xfs/172
> index 0d1b441e..c0495305 100755
> --- a/tests/xfs/172
> +++ b/tests/xfs/172
> @@ -16,9 +16,37 @@ _begin_fstest rw filestreams
>   
>   # real QA test starts here
>   _supported_fs xfs
> -
> +_require_command "$FILEFRAG_PROG" filefrag
>   _require_scratch
>   
> +# The first _test_streams call sets up the filestreams allocator to fail and
> +# then checks that it actually failed.  It does this by creating a very small
> +# filesystem, writing a lot of data in parallel to separate streams, and then
> +# flushes the dirty data, also in parallel.  To trip the allocator, the test
> +# relies on writeback combining adjacent dirty ranges into large allocation
> +# requests which eventually bleed across AGs.  This happens either because the
> +# big writes are slow enough that filestreams contexts expire between
> +# allocation requests, or because the AGs are so full at allocation time that
> +# the bmapi allocator decides to scan for a less full AG.  Either way, stream
> +# directories share AGs, which is what the test considers a success.
> +#
> +# However, this only happens if writes use the delayed allocation code paths.
> +# If the kernel allocates small amounts of space at the time of each write()
> +# call, the successive small allocations never trip the bmapi allocator's
> +# rescan thresholds and will keep pushing out the expiration time, with the
> +# result that the filestreams allocator succeeds in maintaining the streams.
> +# The test considers this a failure.
> +#
> +# Make sure that a regular buffered write produces delalloc reservations.
> +# This effectively disables the test for files with extent size hints or DAX
> +# mode set.
> +_scratch_mkfs > $seqres.full
> +_scratch_mount
> +$XFS_IO_PROG -f -c 'pwrite 0 64k' $SCRATCH_MNT/testy &> /dev/null
> +$FILEFRAG_PROG -v $SCRATCH_MNT/testy 2>&1 | grep -q delalloc || \
> +	_notrun "test requires delayed allocation buffered writes"
> +_scratch_unmount
> +
>   _check_filestreams_support || _notrun "filestreams not available"
>   
>   # test reaper works by setting timeout low. Expected to fail
> 
