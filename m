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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E628C07E9C
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 23:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECCDE613BE
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 23:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhGIXxt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 19:53:49 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:52434 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229854AbhGIXxt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jul 2021 19:53:49 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 169Nkkj7026774;
        Fri, 9 Jul 2021 23:51:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=y+NOxcpQ84mksh+u91wjhj9rYvBpT6MbFj5zAMrN5ec=;
 b=lF8zkB1cZ/6RLQ3LO6CuFjLUXxcZZVh8sYzBTKN6HWTn8HF4amUIpfZjqVcIRqTN0DQm
 v4zZC+60ZGx4KgVIkRHY5u8cM/PGcRHD+WH/glnCMaN/oi7DSV6Uh5qA+T+5OKr2lXSW
 v+Ij5ZxHLboSxcrn3VnR+MNY2wTHD8nO4mmGWIXG4XTELRapYsdHTUxconvHptwbEaZH
 a8d4BeTcEfWXatpv4MZCuhmP1AXkiNyfd6ZuM/h+FNGQbAIrbfGdGemFniD7j5iZBDUs
 RTEvYon8PmhmVUJTJmPuW1BWCpZNd52Ns5IM5guysk3a7935gAVvuBHcHxqkiQwFyfwO NA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39pte5gj0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 23:51:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 169NoGfA074276;
        Fri, 9 Jul 2021 23:51:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by userp3030.oracle.com with ESMTP id 39jd1c922y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 23:51:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcmg0LUK3PB6qBpY5QqN4XuBlrJekqZmGpiKF4Xd/TOjnwpDdOECm1q+p6/09dr5We115ezJxFJixgsEn/9NYMgjge3swtS3F8ZJUe9z4yRjnUDP3KM8x53HbN0/BwUxgORkTmVLaVw7Tpug4vx2tQCqMQtcKRjRfaoTzl7zWgr9fTeHAevlhl3PCGGO953RfZcDE2InwDUEVqlF7bIBxLUzwei+aJ2dim8e7hZKbuyIa6SQJ4Y/nFvD0o5Og7vyL5h8jiLQfhRnBbKkKJQlw7SkhEdk5RWatqqN7UnRfj5/A+u3Lgp68KwDIK6pYexaPzPOdy5zOmgmma59kYnVOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+NOxcpQ84mksh+u91wjhj9rYvBpT6MbFj5zAMrN5ec=;
 b=RWiIt1ppGG++PeShepRKqvWBP4inAhA5V0JRy0cKYgI07yFxgv3KDvhwBKuYPSkDv0oct9M+o0hfalZwYrW0HwKcDyfVsCdqPscpLkE3DJQQ71yspfo7sXv8M/YzfGEBXi2tivRSyIYLNPI7Tiy/dN0kTvZLx2hBtMyGOf9djiGR5DQpbH12QW/fDG74r7SeHPf1xvc7WfCi87thapVVFZWoGu9CZdGzAl0fyCvF8JPK3rn9rTICqDa/4f6n7DzhwDBA1mmG5gCwVfgJRQfMy+DfEhE/pUouOhg/KiczQI/cNxRAPHmmFJKU/IVW8YZU78sKzccEyPpNmNX+SAEqJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+NOxcpQ84mksh+u91wjhj9rYvBpT6MbFj5zAMrN5ec=;
 b=qSnad2gf3rKfM2aXfq5quPAUM2o91bVo8cIRpQBiZZjrOwUEeGnDlZwa2mHOj+vDrcFGS+tcXuTuVkOSfS9UdyrAe2BD8pYx+uX4pou6VKnijHWysm0FONHpN/vfWcC79iukZ3/5IYb5CNzsuQU3hHanRvbYpXROJZY6u1e1E54=
Authentication-Results: eryu.me; dkim=none (message not signed)
 header.d=none;eryu.me; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH0PR10MB5177.namprd10.prod.outlook.com (2603:10b6:610:df::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Fri, 9 Jul
 2021 23:50:55 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::807e:3386:573c:ad06]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::807e:3386:573c:ad06%5]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 23:50:55 +0000
Subject: Re: [PATCH 7/8] generic/371: disable speculative preallocation
 regressions on XFS
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <162561726690.543423.15033740972304281407.stgit@locust>
 <162561730547.543423.5029188797370208051.stgit@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <068bec25-cd8e-7682-3c40-b5f6e38b4ec0@oracle.com>
Date:   Fri, 9 Jul 2021 16:50:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <162561730547.543423.5029188797370208051.stgit@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0095.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::36) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by BYAPR05CA0095.namprd05.prod.outlook.com (2603:10b6:a03:e0::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.10 via Frontend Transport; Fri, 9 Jul 2021 23:50:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d3525c2-360a-4f4a-6443-08d943346475
X-MS-TrafficTypeDiagnostic: CH0PR10MB5177:
X-Microsoft-Antispam-PRVS: <CH0PR10MB5177A341553881F515C5BD2F95189@CH0PR10MB5177.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xb1puSFGgxIKINqV10Z9mEektKknSwmz6USMcGDxUulqCOsr20I90xlQ/2RlVRRu9wyb2y7Yn8u13U9xq3RYb9o9QJKgEgoqWI+yHzq2AQBmFxLGlw0g1k5v779Q0debmjiJjm0EoS36nBl0dnIHssQinPqXJ8ctsagkCI0Y5IvS61ksHrpebYUaMRohv4LU8SJDYnQb71J7YFE+EitNhF+7RzQAEuBSopG7wha+qvFJJ9An9lln/ies7auNR76pqnd2Xif0moooUecsBEG6xzStEaGbcCjwfyjemwtY+mKFh0sub7qkQjVIc1lEqbQaVr6oz021HnGguyi3/EQN+TK2lSL156kP5oNEXj6RLcIn0k9leuRd7KlTCoMIXN/V3C+PPMf1AMSCCW9CUqt3GzUbpx4HIrk/qPQev1zdLZfGp9rv6ghUbKrx5ec2Og2UWGIyAmzsv+O6k6jeVGSn2P1dy/CHzhG1VKt786XMrRjGgQtABdRC9JuZlqHBy06GkdIkd+Bpl0o8I3TMd5x1MR4nvlF8uNYSjtHqA2cTNY/R7HlCeZxeD7KVSCEw1YNQYrV3b26H0PCpHTvZ3M/Ratru9PBDXUa7Dp84eLy77bnjQUooR8u/Kqdfx0WJ/mndT3WDmitc9ezTxW/LJwqeoCYv57O7J2dD/EEuHtO8Z4EFdbjdgFJnoZorFaCSnbFt62f7mCUDPJVxB4OJtdKymONSEFyXR4JHMd+aOJNJSqTmnt9i12CRIpUAE/aiCp0xHyVYvxBMgKa+ME1CdYUFZe/BTkaK9C4PXrSDtIqDsPU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(39860400002)(346002)(366004)(52116002)(2616005)(8676002)(44832011)(38100700002)(38350700002)(6486002)(86362001)(31686004)(66946007)(4326008)(83380400001)(16576012)(478600001)(2906002)(316002)(31696002)(36756003)(66476007)(53546011)(956004)(186003)(26005)(8936002)(5660300002)(66556008)(41533002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUM0WmVnM09Rb0hLS05DdTJQUUNpbTNqT01YOWRxU1EvdnQrQ3QzSHM0OWxM?=
 =?utf-8?B?RHpvZTZBK29sQzEzZnhldHd2bXI5Z3RNNmt0WWtnRnUxZmZWanF1b0lQZmV2?=
 =?utf-8?B?dnNvMlhjMk1qcUc4aXpKOUQ5eERrc1pGcGFOK1RuRDhVMW1YQkwvRXB4UDBl?=
 =?utf-8?B?SHdwZ0wwV0VGNzBad3JocjVRRHRvaUQ3b2xiZFFIZTl6N1ZOOGV2Q1BEd2I3?=
 =?utf-8?B?VXJyZFRHeEk0eGJtczlDaVFkRmNyL3czNDN6d2FDb09qVEtOdy9MU1VWandX?=
 =?utf-8?B?RmQ4UkJQU2RKM29WMVdKWGM5WnpReDQraWNLY0h2a05wQVZCNXg3dFNVeWFz?=
 =?utf-8?B?WFdvTHltelF4U0t3N05wWGsxMWdCQmtBRGpGSFJhRk9OYTJ4MkpaVzVscktN?=
 =?utf-8?B?bGl2b1lFYXRqZzMreXNoMDRwdVNvSTIyeVZ3bk5XQ0VTY3lUbGRUY3RLN2d1?=
 =?utf-8?B?UTRScmcrbzdXY3h1aWt3TjI5VkJpa09WUDlrZzlzUWlLQ3dDdTV2b3RZNVU4?=
 =?utf-8?B?Wld2S1lpeG4vUld3eUFlZG9SbTZFWlc2N0hSSnlQUlZPY0REQUl5WWlpck50?=
 =?utf-8?B?Z1ZmMGl6dXY4anJkcHpkanFYa1VHWWNuNTZIZm5HZGJDdlU0R0w2dVhwQjYv?=
 =?utf-8?B?Y3FxaEVnM1hXUTQ5cTRBRng4MSt0NjVlRGhsdkRJRVp4bWU4eUtJbGxtVHVr?=
 =?utf-8?B?bDNYTTBYRXdpMFpHK3BobWpjeHUzRDJsTUczMGZ1TmtqbUYxL09iVjkyb09h?=
 =?utf-8?B?ajAyd04xR3RjSTU0cGpJM0I1dXVWaVd1eUd1OVBEL28xWm1Hck1EdlRycG5q?=
 =?utf-8?B?VkxxY1NvRXVkQU9pWU9yQ3hFRlM3S0JzTVVIRERoR0hhNnQ1cHRtbmVHNDJQ?=
 =?utf-8?B?WHBTMXcrKzdCaGxvWFc3LzFubTU2dm5uUWhYWVRyWkh5bG9ZeEQ2Y2ZwbGVq?=
 =?utf-8?B?OWVBeFhaYU15ZklUeVNoNmNCYXBybVQ5T1NBdmlKWXIzNFc4YmhDMkJoaUtr?=
 =?utf-8?B?UTQva0xTcnczQXoyejl3R1RMUkN5eXMwWEFUcHo3UlF1SnNyZ0p3cEl2Sno3?=
 =?utf-8?B?d0RjV2IvODhnVXlkM3JhYVlaaFN6NmxaZDFBSno5bGFjNS8rRVV2ZW5yaUVj?=
 =?utf-8?B?NjV0cW5MSElTTGlDN1hTeWtMZ0tsSlgxNThodXhDZ0hjT2wrdFREN2FBVkhn?=
 =?utf-8?B?VzNDdXRsbnNad0I0WGE1bVh6akFwQTFOQTJydGw5eEpyVHZWaDhlT0dTT3N1?=
 =?utf-8?B?TGtYU1VlcFRjTlF5disvY3lvR2dvV0h0NWV0SUZ0Vm94Q21xZUdYRkUramQr?=
 =?utf-8?B?eUpnUGN0MGt2am8wV0ZGQWZxb3BJSmR4SjNIN2tSOEcybUdTUUprTG9tbzcy?=
 =?utf-8?B?MzhuZmM5SjJkenp6amVGSVkvdnBDL1pwMmh4K1dRNzU4THVxMlZhS1E5blhz?=
 =?utf-8?B?eXNvdUc3aU5COC9wREFRdjBaOXE4dXdjeTdqYmV1TCtCQmo3cEludWJZY0xp?=
 =?utf-8?B?ZjA1a1JpeVorUzFjbkdWR0xadCs2NE9Ha2UxMFBLNndQN05hN1lRUzZDZGhN?=
 =?utf-8?B?bHJNT2RtU2FaNmloVVIwZjd4VGlGbnBYYWp4akkxNmtjS3B0d0RORmlCVjZy?=
 =?utf-8?B?ck56YlR2akRwaDdVZUErWGVMc1VkTDREMWZjRk5sUlUyeC9CT1NmY3hWdzNk?=
 =?utf-8?B?WXR0WTBlRi81ZWpSNmNzSGFxQlErblBRYUc3UUdtZHI5RGl3Nk9nRXkzNlNN?=
 =?utf-8?Q?eRVXL5wy/9S47JX8NTeXienUzFJYeJJCoCur+KW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d3525c2-360a-4f4a-6443-08d943346475
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 23:50:55.4641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kO7xQiKoO/IcUS1KD03krxXQ3K1SP51NePXxp1ny2n8Gx+Jc6QR3iUs8YZl+IPl+5LF/qrqtPjGH7tDisxSjTokVChPKlKhlGOBX3RONc3g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5177
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10040 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107090124
X-Proofpoint-GUID: d05kM4n6W5FxxCZXprCIgpN2N8JTDA78
X-Proofpoint-ORIG-GUID: d05kM4n6W5FxxCZXprCIgpN2N8JTDA78
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/6/21 5:21 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Once in a very long while, the fallocate calls in this test will fail
> due to ENOSPC conditions.  While in theory this test is careful only to
> allocate at most 160M of space from a 256M filesystem, there's a twist
> on XFS: speculative preallocation.
> 
> The first loop in this test is an 80M appending write done in units of
> 4k.  Once the file size hits 64k, XFS will begin speculatively
> preallocating blocks past the end of the file; as the file grows larger,
> so will the speculative preallocation.
> 
> Since the pwrite/rm loop races with the fallocate/rm loop, it's possible
> that the fallocate loop will free that file just before the buffered
> write extends the speculative preallocation out to 160MB.  With fs and
> log overhead, that doesn't leave enough free space to start the 80MB
> fallocate request, which tries to avoid disappointing the caller by
> freeing all speculative preallocations.  That fails if the pwriter
> thread owns the IOLOCK on $testfile1, so fallocate returns ENOSPC and
> the test fails.
> 
> The simple solution here is to disable speculative preallocation by
> setting an extent size hint if the fs is XFS.
> 
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   tests/generic/371 |    8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> 
> diff --git a/tests/generic/371 b/tests/generic/371
> index c94fa85e..a2fdaf7b 100755
> --- a/tests/generic/371
> +++ b/tests/generic/371
> @@ -18,10 +18,18 @@ _begin_fstest auto quick enospc prealloc
>   _supported_fs generic
>   _require_scratch
>   _require_xfs_io_command "falloc"
> +test "$FSTYP" = "xfs" && _require_xfs_io_command "extsize"
>   
>   _scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
>   _scratch_mount
>   
> +# Disable speculative post-EOF preallocation on XFS, which can grow fast enough
> +# that a racing fallocate then fails.
> +if [ "$FSTYP" = "xfs" ]; then
> +	alloc_sz="$(_get_file_block_size $SCRATCH_MNT)"
> +	$XFS_IO_PROG -c "extsize $alloc_sz" $SCRATCH_MNT >> $seqres.full
> +fi
> +
>   testfile1=$SCRATCH_MNT/testfile1
>   testfile2=$SCRATCH_MNT/testfile2
>   
> 
