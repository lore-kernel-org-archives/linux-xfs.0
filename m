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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAAB5C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 03:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6723A23888
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 03:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbhAVDOF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 22:14:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50142 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbhAVDOD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 22:14:03 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M3B0LT079211;
        Fri, 22 Jan 2021 03:13:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7c+Vkwwq+9NTwDKMQTZ3HUlYYSEh4OGNirdtOYtYN/Q=;
 b=dgSleeMl6wgujfLuQ1BfxLxJkFF7tiYTCMPRlYAoODsxGv5SDGHVjGCznB98daBK1Pww
 eZsu4D3XRX+OjYMt/J+A4besqlwamH2boU8Ha/jQUdtT8txPIzT+LVzhtZaQUFOL+hh2
 jIvetAU5DnyC1R+12TEQH8biB09rNBdqG/YjG1WQC+FFm0WL7V2B9qXtmx/1C3p8sWb+
 uqdKsFiCIObk7U6n6M2SfmYI9I1VK0IUfOJVguXiEXBx1vvQQ90WpPAW5Is2BIMSc9y5
 p+bGoH6IV3NFJ0U3E8WPfOwobK3kCX4Ciwts23NywvnasTclLBrKPSy0p9Amh2xqYHfz Jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3668qn2679-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 03:13:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M3AtFJ101239;
        Fri, 22 Jan 2021 03:13:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3020.oracle.com with ESMTP id 3668r07jnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 03:13:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n23bzvA3n41q0ozI2XXWwXIpmrWTmjB6gsrBMqN6kuxlFf7VDRUnfAbzlDS6I4EPhPeT84qP+hmYSdYx5VzmdZlj1wdhrtIgkDvOgaZZDRlBV6KeDO9M/i3X6e2fptM87mwHy/CggKFGWI02sW/zF03PMQWGM9lOMhAfKw25OHCuU9YAex5bh4sV6/TZ+DKRB0DEUdmRU+CsRDb4m0keZM2OtRU/ek7DY2UnMpwRVQPnnx7KtdqHTQEW8iRKanWUWDRhlq4zyBVUU4pXl8zB4SVjVuium8LeivqsVwKSJfliw3DF67fXTS45proMJlHZf/SRPsQMFGOu2DBrBDVmFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7c+Vkwwq+9NTwDKMQTZ3HUlYYSEh4OGNirdtOYtYN/Q=;
 b=KlU0C8snizWS+Bo2tmAEFGn/Aw4BfwZjRg4Odo3Q8Vua+XahA9dhYqrNyofjl8K7Mh3WpvlYP49P3by1FNk9C/JKsBRhcOArAIYcetEc9u7tHIWCABNRU6pKSlwsksm5LEN4+mum6cB7sVbkg68xdHIs/Nk91YMiW/uUYmKImrdF+S20TnmKvNfYmsWrlP66dMiCJPwXXV0u9CtJ5M5MCgUYv3lABllJoCtrNUhOpDC4Gbyq9wJ9AgpYkGWCZwZZo6ZymaHd9wtuzR+uFWQRUcKLcsJjpnLG0AYzp1eEUD8nSZqNaBRsvsXcK0czVgeGntj74DWAHKFiUUBcCnTV9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7c+Vkwwq+9NTwDKMQTZ3HUlYYSEh4OGNirdtOYtYN/Q=;
 b=x/Cw0fC0eCvQXGQlAPfbN69MIHa1tz+vbgHG2JZ4wcj08lgPBhNQgsk1xjMDp/SDO64xV8/1vIQDaIEjymDxFLwJB6tdEXpSnT/iwJMnfhZPuQOhfv4OFk9zI+2u0Ygle1YMzHY95t21EB13tWO/eHMKIZi6VFJhOxelD1v1Rac=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3045.namprd10.prod.outlook.com (2603:10b6:a03:86::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 22 Jan
 2021 03:13:15 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::9105:a68f:48fc:5d09]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::9105:a68f:48fc:5d09%6]) with mapi id 15.20.3763.014; Fri, 22 Jan 2021
 03:13:15 +0000
Subject: Re: [PATCH v2 6/9] xfs: fold sbcount quiesce logging into log
 covering
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20210121154526.1852176-1-bfoster@redhat.com>
 <20210121154526.1852176-7-bfoster@redhat.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <4e30532c-e734-8a00-158f-9c2d20e32c6a@oracle.com>
Date:   Thu, 21 Jan 2021 20:13:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210121154526.1852176-7-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.214.41]
X-ClientProxiedBy: BY3PR10CA0019.namprd10.prod.outlook.com
 (2603:10b6:a03:255::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.214.41) by BY3PR10CA0019.namprd10.prod.outlook.com (2603:10b6:a03:255::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 03:13:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b524f6f3-b9d4-4568-28b5-08d8be83a89e
X-MS-TrafficTypeDiagnostic: BYAPR10MB3045:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3045722CE24560725936C11695A00@BYAPR10MB3045.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eIpT/M4Oj9jx0BagZyGa7Y/lDI81rdkQTGbjw1+UER2CB3yHqo47aJiXQW35+W5JcE6nBaw3foh9szEKtZimKNIyYEzKAT0XfPTKTp/XShS458L6nEN/7ieSgqe4T5Etwua4x2U6+vgYywiRXaKHvgG/YL/GSY6lq36pucTTFTZMUU5upo3Rf8MWIV8ny3Z4e/qiV/JnuYXabscKNaN1b4ZeCXcoHBIzUM4F4wC8hXbxym03M/NklCTXz9MhPcFkI0n8IoLkYHxkaH33wYl/znGJO/gFr+3hvA/Q8L16GMyMSsIUWD4KhjzA5irFkHT+O8Ao4ZCeanpREtYDdS3qL10VTTYz6U+uRtDJeLrdZ96a/5ZnXKvIDM6/i3J7dRvNiSB24fcSMwJdrbe1iqVD5yixzCcgPruLKKHVaY/nFWnm+t7QAhzZgYZciEUls+2RzFAcm5JsQLfLkOht4rVKFT6dyWcvZ3+4fsD+8wxudAI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(346002)(39860400002)(136003)(66946007)(83380400001)(44832011)(5660300002)(66476007)(66556008)(52116002)(2906002)(31686004)(8936002)(316002)(16576012)(36756003)(2616005)(26005)(508600001)(53546011)(16526019)(6666004)(956004)(6486002)(186003)(86362001)(8676002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bmM2TEZFQlhOcWQ0aU1VVFlOTDVhdTFLRXdSYlRWVy9ydjZnQWVjZHZYUkZQ?=
 =?utf-8?B?ZDhDVm4yTXQ2Z3pzWEdtU24ycXNEV3F1bHdsWEJGRWNJeWt3a01pWS9kczEr?=
 =?utf-8?B?emVmakdXZm5FRE80VHdvNDFLZFcwSitQT3pLbnpENjlSWGRLZjlqeWorVXcy?=
 =?utf-8?B?eXlGdEJjVzNBWTB1WXc1QjNMSUJwMGQ4elllTFZBU2d4R2J4b0NOZnM1bTZm?=
 =?utf-8?B?QmxvdGpUSWdzcUFtcjFEMHc0MTJhMWxDd245VHl2R1M2RFRkRkhpb3hFODRt?=
 =?utf-8?B?YzVac09PMG5mcVFjY2trYTBBMDVWNmMxdi9Rb3hCdkN4SzcwUHRnMzJCeWtr?=
 =?utf-8?B?QUNScFNrRHlCckI0N3V4dlZpUkdhdDU3Mk5LdU1aLzVaWWthWmNNLzRYZHlS?=
 =?utf-8?B?RG1uY3drZjZFL2x0VG01djFObEx0S2pnTTBLL29VMFhUbjZYeW56OWlmbjkx?=
 =?utf-8?B?THlham53RzFOVGVFd0JoNGFWWDRRSGNvcjBhK2pUTXpyUVIwZjFKNUVrN3Jy?=
 =?utf-8?B?Sml4ZTh2M1NqZlozUEVteTFjcDQzcU1tSjIxd2daR1VFL1FsdkdiYlBhZUtN?=
 =?utf-8?B?dkQxdjZZR0x6ZGwweGRaaWl4RnZrbGs1cHlGTDRsbzNrNjgwWXh0RVJFY2My?=
 =?utf-8?B?M1hIejhyRENCeDJZWXRraTd2MUJ3ejVPdUMzNzEwM2dOVFdES2xETFlaQmFK?=
 =?utf-8?B?aHVaNitRajNlTVJlNGN0VERJZDlRcGdqM0RjNklzNWI5enc1SVdZZnpsZ2NR?=
 =?utf-8?B?ODVyRUNPaC8rYXFsWDFXbzM1czdsUDF5UzZzVE5TTzJaSE5BR3lZOW10cCth?=
 =?utf-8?B?QVF5cExKYWJYUzIwVGl1MVI0NnNJMGc4UnEzYlhHLzNPa2VoY1hqR3VWMjBz?=
 =?utf-8?B?bm5LTUhSZ1JXYzlNSUJCQXJsa3l2WEwvOVQvSDAvZTErelpibHBsNXc0TFdV?=
 =?utf-8?B?R1F0NFJZVWdOQkR4QlMyOElpTnlDcEpRSFVXWkVKM3hDVi9TZEg1UkwyTE9T?=
 =?utf-8?B?clJOelFxYU11YkQ1bHBLWDNhZHllY1M1aEVYTUhwcVBGM0hIZHkwbFdkZDNT?=
 =?utf-8?B?YUlGNzZFOU5ZcWtKV2J6Z1ZqS3VlL0dEWU45Qm1GM0VhOXFvM2U5emxRczFQ?=
 =?utf-8?B?VW4yVWdtVGV1WXNPUnNjREU1TXl3SHc2blZJTzdHRnpVRS9UVWVkdlBIZkMz?=
 =?utf-8?B?WDBzZm1xQ2NmODJiWmRPdDZ2bmgwSUFpT1VKRkpLVHkvb0tXMDFIQUFZRGk2?=
 =?utf-8?B?ditISmRjVjdvSHdDQ3BocUlqV01xWnJiS29CdW5QM0xEaXIrV3haNzRvZXBD?=
 =?utf-8?Q?tu4hpzkegi7Hs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b524f6f3-b9d4-4568-28b5-08d8be83a89e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 03:13:15.3747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wknTi0P7sz/anyeipPvdFPxIvAuilJbi6SSZtxlyqapBVjN7Rf/fy/26XMkhCBkzrvAt/fS4wsamcaT735jhB2Iyys253Alf/utFQWmkteg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3045
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220015
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220015
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/21/21 8:45 AM, Brian Foster wrote:
> xfs_log_sbcount() calls xfs_sync_sb() to sync superblock counters to
> disk when lazy superblock accounting is enabled. This occurs on
> unmount, freeze, and read-only (re)mount and ensures the final
> values are calculated and persisted to disk before each form of
> quiesce completes.
> 
> Now that log covering occurs in all of these contexts and uses the
> same xfs_sync_sb() mechanism to update log state, there is no need
> to log the superblock separately for any reason. Update the log
> quiesce path to sync the superblock at least once for any mount
> where lazy superblock accounting is enabled. If the log is already
> covered, it will remain in the covered state. Otherwise, the next
> sync as part of the normal covering sequence will carry the
> associated superblock update with it. Remove xfs_log_sbcount() now
> that it is no longer needed.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok, looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/xfs_log.c   | 20 ++++++++++++++++++--
>   fs/xfs/xfs_mount.c | 31 -------------------------------
>   fs/xfs/xfs_mount.h |  1 -
>   fs/xfs/xfs_super.c |  8 --------
>   4 files changed, 18 insertions(+), 42 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 6db65a4513a6..9479a5d0d785 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1108,6 +1108,7 @@ xfs_log_cover(
>   {
>   	struct xlog		*log = mp->m_log;
>   	int			error = 0;
> +	bool			need_covered;
>   
>   	ASSERT((xlog_cil_empty(log) && xlog_iclogs_empty(log) &&
>   	        !xfs_ail_min_lsn(log->l_ailp)) ||
> @@ -1116,6 +1117,21 @@ xfs_log_cover(
>   	if (!xfs_log_writable(mp))
>   		return 0;
>   
> +	/*
> +	 * xfs_log_need_covered() is not idempotent because it progresses the
> +	 * state machine if the log requires covering. Therefore, we must call
> +	 * this function once and use the result until we've issued an sb sync.
> +	 * Do so first to make that abundantly clear.
> +	 *
> +	 * Fall into the covering sequence if the log needs covering or the
> +	 * mount has lazy superblock accounting to sync to disk. The sb sync
> +	 * used for covering accumulates the in-core counters, so covering
> +	 * handles this for us.
> +	 */
> +	need_covered = xfs_log_need_covered(mp);
> +	if (!need_covered && !xfs_sb_version_haslazysbcount(&mp->m_sb))
> +		return 0;
> +
>   	/*
>   	 * To cover the log, commit the superblock twice (at most) in
>   	 * independent checkpoints. The first serves as a reference for the
> @@ -1125,12 +1141,12 @@ xfs_log_cover(
>   	 * covering the log. Push the AIL one more time to leave it empty, as
>   	 * we found it.
>   	 */
> -	while (xfs_log_need_covered(mp)) {
> +	do {
>   		error = xfs_sync_sb(mp, true);
>   		if (error)
>   			break;
>   		xfs_ail_push_all_sync(mp->m_ail);
> -	}
> +	} while (xfs_log_need_covered(mp));
>   
>   	return error;
>   }
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index a62b8a574409..f97b82d0e30f 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1124,12 +1124,6 @@ xfs_unmountfs(
>   		xfs_warn(mp, "Unable to free reserved block pool. "
>   				"Freespace may not be correct on next mount.");
>   
> -	error = xfs_log_sbcount(mp);
> -	if (error)
> -		xfs_warn(mp, "Unable to update superblock counters. "
> -				"Freespace may not be correct on next mount.");
> -
> -
>   	xfs_log_unmount(mp);
>   	xfs_da_unmount(mp);
>   	xfs_uuid_unmount(mp);
> @@ -1164,31 +1158,6 @@ xfs_fs_writable(
>   	return true;
>   }
>   
> -/*
> - * xfs_log_sbcount
> - *
> - * Sync the superblock counters to disk.
> - *
> - * Note this code can be called during the process of freezing, so we use the
> - * transaction allocator that does not block when the transaction subsystem is
> - * in its frozen state.
> - */
> -int
> -xfs_log_sbcount(xfs_mount_t *mp)
> -{
> -	if (!xfs_log_writable(mp))
> -		return 0;
> -
> -	/*
> -	 * we don't need to do this if we are updating the superblock
> -	 * counters on every modification.
> -	 */
> -	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
> -		return 0;
> -
> -	return xfs_sync_sb(mp, true);
> -}
> -
>   /*
>    * Deltas for the block count can vary from 1 to very large, but lock contention
>    * only occurs on frequent small block count updates such as in the delayed
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index dfa429b77ee2..452ca7654dc5 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -399,7 +399,6 @@ int xfs_buf_hash_init(xfs_perag_t *pag);
>   void xfs_buf_hash_destroy(xfs_perag_t *pag);
>   
>   extern void	xfs_uuid_table_free(void);
> -extern int	xfs_log_sbcount(xfs_mount_t *);
>   extern uint64_t xfs_default_resblks(xfs_mount_t *mp);
>   extern int	xfs_mountfs(xfs_mount_t *mp);
>   extern int	xfs_initialize_perag(xfs_mount_t *mp, xfs_agnumber_t agcount,
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 09d956e30fd8..75ada867c665 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -884,19 +884,11 @@ void
>   xfs_quiesce_attr(
>   	struct xfs_mount	*mp)
>   {
> -	int	error = 0;
> -
>   	cancel_delayed_work_sync(&mp->m_log->l_work);
>   
>   	/* force the log to unpin objects from the now complete transactions */
>   	xfs_log_force(mp, XFS_LOG_SYNC);
>   
> -
> -	/* Push the superblock and write an unmount record */
> -	error = xfs_log_sbcount(mp);
> -	if (error)
> -		xfs_warn(mp, "xfs_attr_quiesce: failed to log sb changes. "
> -				"Frozen image may not be consistent.");
>   	xfs_log_clean(mp);
>   }
>   
> 
