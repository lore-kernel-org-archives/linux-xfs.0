Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A394C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 10:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1410161260
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 10:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhJTKso (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 06:48:44 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:44958 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229702AbhJTKsn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Oct 2021 06:48:43 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K9x6vK032214;
        Wed, 20 Oct 2021 10:46:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=4UHIaLUzqWwDaT3tk4k0x4z2yDzaqIb4Wdg6ImFg844=;
 b=1B9D1nWCFDgEYsREPg7nXQynQvy/WFqhDJM+Ei97JH+J8T7YQOxXsCnvzWcFJyROoFNc
 HSGx41sk6I/Os9JdeH3hmoyO/y+iVGcKR9SteDpA7IFPfw+wn+yWpfwT0uzKfcEJLSht
 7Hp7Diu8vAFCiO5BLS14JWyAsdTerdUzUOo9LFHra+sLjPos3cOvBulMMlMQiX+TwfIs
 ciZ7hEQe0Gi/qCBx0HeLqB4F3WILCaFkOynYbgdXPg+HRjc8QBdJ8TFNduYgzie+4JoJ
 KVZl9bTGpxZL3kaGbfuq0gMXz45jiREODuScxBtMGsGduNzEpWs/ovwcgzYt/9IQnqJk uA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bsr4587hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 10:46:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KAarBR093850;
        Wed, 20 Oct 2021 10:46:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3030.oracle.com with ESMTP id 3bqmsg8f2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 10:46:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hMqR+14QzzJQavLAUElHohX5LMGMeheoKUT5IqekdsELJ+UOvrTH9HgqDdjHAe8UnqcEE945eyS9bmC2HP7Cqi11IBnoWiGLnys0pY47yL2hhyfU6JH0Utz7bSMSfW/BaiN1tLI3/gGXYWiVFLh8AjvzORouI7NTdxDKHaZl19/t+UyY2f5QQLFydUUFq9uyMym/jz4onIz7SivsMwY9qDqBUA3z7zrmSEETKFVhvkEgdSLppIljX5RHIWybCQjR2MxwY1lcIjkybtzdjsdKl55YjzgZok6pV00yuIDmEi481TeZ9NKEG3fI7GwxZXsClNV2PHv4T3LG31aLMdGFlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UHIaLUzqWwDaT3tk4k0x4z2yDzaqIb4Wdg6ImFg844=;
 b=XOjh+PFPkdwoVAZRaFzsICUaoF8CoPJbZqIo4m8d85ppOi7hie4wCT2UHmPcu81mmWMSyreX6wZQb8aX6cspsVKwCj8V2vh0n/PJMSdSep7m7otwCcgI80VO00+lSwA0C3K19s4mB5mgGHP1UhcK7EjqYpsR+NT9lFYq0qgS26JIQS+FX4mbcFwwdHRPk9N2EBkUP7EnH85GNub9OZgLTNQqAa1i3rZNzr5tvsADwD4wBx6pOb4DEw6y3rRyvxKcJRlu5pJ+znJPGSos0NyiI/1zL0UevBPoS7+ojy0DZ4kt/sl9ZtBvrF+3jrmXhVzC3tQy8VNSlTj0zuiCkGMLbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UHIaLUzqWwDaT3tk4k0x4z2yDzaqIb4Wdg6ImFg844=;
 b=ngAJLCyni7C8hyHQlZdcRWIYjJJdQw0BIu97QSqaRhgHVISJ8d8JznQQRTSVOrqnP12q4E7UE3b7bEiW7f0UEwkKHU8K9r/G0ZS2xMmG16tU5L/wwtxdWEDD+Zn8oL37kM/aLVo4sv6FUOlYSjJDBt2OSeJs4X1Q+F+z6X0mH1Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4731.namprd10.prod.outlook.com (2603:10b6:806:11e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 10:46:25 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f%7]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 10:46:25 +0000
References: <163466952709.2235671.6966476326124447013.stgit@magnolia>
 <163466954919.2235671.801665171595051864.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: reduce the size of struct xfs_extent_free_item
In-reply-to: <163466954919.2235671.801665171595051864.stgit@magnolia>
Message-ID: <87y26ogeiz.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 20 Oct 2021 16:16:12 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0044.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::8) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.50) by SI2PR01CA0044.apcprd01.prod.exchangelabs.com (2603:1096:4:193::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 20 Oct 2021 10:46:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6953bb7e-6d0e-4e4b-7b48-08d993b6dd17
X-MS-TrafficTypeDiagnostic: SA2PR10MB4731:
X-Microsoft-Antispam-PRVS: <SA2PR10MB47317BA44131F1E26CC8DCCDF6BE9@SA2PR10MB4731.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iZzPH60MxHHxFd/MPJ6YG1+4lKTsQPWrbuhDZryZDfBkouvjeSuIA8FM0r38v4mjrEORrsgKoiCxVqWMtaNEtl3VGJ+QwS7mwKHcKYWMdc6d+S4PIcsWCBJh4dxvfUTe24xwiWsAp9zyXQLj8OPb87dx/TekaesTWy/fjpGk5pQvDcJDQLMl49Dz8HJajp9Nggi1P31SEeWVO1P+VrxpWNU6N6oHxNbRGnk7M305A1sNa3/pAEnK/QGdH4CBpY4BvU6Qx8LQvAIIf321dv0VLNHiXiyZY1dLD85vSup1U+liAyf5QBt0LGLy993uSRp6OfvURvxpTVT7ciVqbMP2areUITwmF6QBbh3ddItYDJruzN+SEfT6SEncU55oaSUtc5E+MRcAiYVj28Ucw1JMXnq1gliKKl0U+VU000TCX5s2xKBD1ETjI+WvrSQWLeWsCbQ3JVbn4QOk9M8yR8IvXFs6vQYAICOzDuGQ0PR5jD7c0PQgs4HBWXst/dwF9B8LJkPSDNlUCKPyp6bVudbqPPsrco0m0J7nBTSGiRx5bTh5yR66xMHHis8u4ZE36YT/F6VZqf8GD9nRDOz5Q3vWvDs4iwEv1mZ1WKDXmmKZEU74sMPO8hbW3i7amvup/3fQX3AgrShgliFLHweqVtgQtA/xnauZ/nVmcuSSKPTU16nYeh5rCounrBBZul7ruzTaoBx7anpq4pXtrkZ8/pT1Gw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8936002)(2906002)(8676002)(6496006)(66476007)(66556008)(4326008)(83380400001)(5660300002)(52116002)(6666004)(66946007)(6916009)(38350700002)(38100700002)(26005)(33716001)(6486002)(186003)(53546011)(956004)(86362001)(9686003)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oolF13mc71VAKXON17vRHV+zqAM2qOeMJDOgokiAb+NqshbOhO3DdKNKMVS+?=
 =?us-ascii?Q?MkirLtts3J8zF7oQrKQ890JE2fwC2ye4pvkovM5MLlRBNbjLQ00Xx5uH/l1g?=
 =?us-ascii?Q?NkedgSy7t95IiNhltyMNxibsplsy9o8AlCOzYy6c+STykVllxdkidsAUfR2N?=
 =?us-ascii?Q?qpwY7ar58haKzLKnSQLXz/J/fQag40W9p1byxGMMBaGpFDqa0SXAyczK+ddQ?=
 =?us-ascii?Q?ZP+KEOKeVfOMNXF6mQhc1gbBoJ6jdl08s0RnGuPusaHwPhFuuZVyFl/jlwwL?=
 =?us-ascii?Q?CjZfN+F9tDmKg6VW3/A3tQswQwOW+tRgZd1hYdGXBbz6a47GwHcAC1H3C7us?=
 =?us-ascii?Q?r6bpyt0C4OiVEuYiPln/cjWbOS4KRxHnQHRQDQJ5p+tgdUZ0Vm9wr6TkyMmr?=
 =?us-ascii?Q?0anKdEHFFAz8HU+T0m2WPOtWuXBd18Y/lGhZhJce0OG/bLiJ/XxNDck6+Emh?=
 =?us-ascii?Q?2QAgLavqrpu6mjqC4EhMZ4XnomdULmxXYNuHFHNB+1CjpvmpV+GV4Vnjsgd3?=
 =?us-ascii?Q?wWMuF/e6OFWGQDSOu2IjnrDFF5ecouaE2t8yFPbGXHk+In4ktvOEMxB5NtIM?=
 =?us-ascii?Q?6xXv9xHwLUInILBXABDH8BICnkt9Ozm5I07d4j5o5lqPcclU+yOQTiHY/4n+?=
 =?us-ascii?Q?H1OM3U3YdcEX//0qseHPo+LSJ20QNK9VJtPenJ+7yRGQaRRqbBaa6Q/Muqmw?=
 =?us-ascii?Q?zotpkL/yJDLJ6dNEK85NIodWm0b0QhA10i5NJUlfCGOtv/4avKaZ+P7HrDGS?=
 =?us-ascii?Q?S3pkXG1I8X5neH1dYOlZZJc7FRubowZ7JYbRD04GOGtue7lExWVA42zNRVFA?=
 =?us-ascii?Q?VU7Ur3Y6AUOrN5Tp7PUHq5/DfslUri7ScyoUMshZOc7pxNJw+D/VmrL6l4vC?=
 =?us-ascii?Q?0RxTPVH5aWigj9MOU+nAe9VvwKWtewXr23yf+eDya26og/f03+izkbm6pNDk?=
 =?us-ascii?Q?GfjeeFHNFNaYOu2+8p/K7IogFACXGZ3zSGLA1B21EC10b9Eu/LQtwdWL7rwe?=
 =?us-ascii?Q?MNYLtIbJRyn9B/DHiSq8AeO3e+kYwCN3gyHWjq5MKeva826xJKn3vAnoHMeR?=
 =?us-ascii?Q?IIrrKApSoZaOJhrKQCs4wCpMGA8S0MtT0I2rm3rPEYyyV2UPtcEIPDk8AqF1?=
 =?us-ascii?Q?faBqOoqVZYq74P+bf+onFRZhkVaQlMe+4J4lW+UFpSp8M08a9OHp8ANwPSvt?=
 =?us-ascii?Q?L8qyKLpkijOsxYglLxHP02cAila5B0xm9W8Vh4pPMt+/0eK9Ee0GDJb4HQot?=
 =?us-ascii?Q?fkv1sa5xSha4Dp6efinbU1psg9gRShWM5oBjLDlpT3mTpD/Gt7Bir9A6LQz9?=
 =?us-ascii?Q?UrTsGXftPLZimhLNXNG6DxtKQ1kvcEp2kqnzB98CVckYFcq9MoMNq/xp4SuK?=
 =?us-ascii?Q?h3PWRwcajSliCjTcYsHQPaWaz+VZ9nmCCXlhkKYcJqbYVIPHEVZEqbZ7o7Ur?=
 =?us-ascii?Q?I6A4Kc+ZPBFgW8mcCd9n8jwN4FnT3s5CjeB0U0JDmMUnypzD08Tpg6sX9Trm?=
 =?us-ascii?Q?nwGT0yTwprHxUt6hnE1EmMI06hleT8C1vFsDqqZVlfWSp4aVnrdijAXLGuAd?=
 =?us-ascii?Q?PbeC3daiC4d8U8VHCnrDXTHBf6vXPmuo2sfSCadl0Upe+vMfEWOHNXDUi6Qq?=
 =?us-ascii?Q?xi+2/O188BOPeWYrL8tQ5hg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6953bb7e-6d0e-4e4b-7b48-08d993b6dd17
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 10:46:25.5625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L1cJzDB2oYudHmwFL2vF+PNTjXza2eiLTT0nrLAuqltxFAr8lQGWKwh97mIVdVFA05ILXMDbSTOR2CaoEIgT8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4731
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110200060
X-Proofpoint-ORIG-GUID: lZNTOWWKXBLakP7YjPOuR4j1A-jEc_uR
X-Proofpoint-GUID: lZNTOWWKXBLakP7YjPOuR4j1A-jEc_uR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 20 Oct 2021 at 00:22, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> We only use EFIs to free metadata blocks -- not regular data/attr fork
> extents.  Remove all the fields that we never use, for a net reduction
> of 16 bytes.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |   25 ++++++++++++++++---------
>  fs/xfs/libxfs/xfs_alloc.h |    8 ++++++--
>  fs/xfs/xfs_extfree_item.c |   13 ++++++++++---
>  3 files changed, 32 insertions(+), 14 deletions(-)
>
>
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 9bc1a03a8167..353e53b892e6 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2462,12 +2462,11 @@ xfs_defer_agfl_block(
>  	ASSERT(xfs_extfree_item_cache != NULL);
>  	ASSERT(oinfo != NULL);
>  
> -	new = kmem_cache_alloc(xfs_extfree_item_cache,
> +	new = kmem_cache_zalloc(xfs_extfree_item_cache,
>  			       GFP_KERNEL | __GFP_NOFAIL);
>  	new->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
>  	new->xefi_blockcount = 1;
> -	new->xefi_oinfo = *oinfo;
> -	new->xefi_skip_discard = false;
> +	new->xefi_owner = oinfo->oi_owner;
>  
>  	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
>  
> @@ -2505,15 +2504,23 @@ __xfs_free_extent_later(
>  #endif
>  	ASSERT(xfs_extfree_item_cache != NULL);
>  
> -	new = kmem_cache_alloc(xfs_extfree_item_cache,
> +	new = kmem_cache_zalloc(xfs_extfree_item_cache,
>  			       GFP_KERNEL | __GFP_NOFAIL);
>  	new->xefi_startblock = bno;
>  	new->xefi_blockcount = (xfs_extlen_t)len;
> -	if (oinfo)
> -		new->xefi_oinfo = *oinfo;
> -	else
> -		new->xefi_oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
> -	new->xefi_skip_discard = skip_discard;
> +	if (skip_discard)
> +		new->xefi_flags |= XFS_EFI_SKIP_DISCARD;
> +	if (oinfo) {
> +		ASSERT(oinfo->oi_offset == 0);
> +
> +		if (oinfo->oi_flags & XFS_OWNER_INFO_ATTR_FORK)
> +			new->xefi_flags |= XFS_EFI_ATTR_FORK;
> +		if (oinfo->oi_flags & XFS_OWNER_INFO_BMBT_BLOCK)
> +			new->xefi_flags |= XFS_EFI_BMBT_BLOCK;
> +		new->xefi_owner = oinfo->oi_owner;
> +	} else {
> +		new->xefi_owner = XFS_RMAP_OWN_NULL;
> +	}
>  	trace_xfs_bmap_free_defer(tp->t_mountp,
>  			XFS_FSB_TO_AGNO(tp->t_mountp, bno), 0,
>  			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index b61aeb6fbe32..1c14a0b1abea 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -258,12 +258,16 @@ void __xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
>   */
>  struct xfs_extent_free_item {
>  	struct list_head	xefi_list;
> +	uint64_t		xefi_owner;
>  	xfs_fsblock_t		xefi_startblock;/* starting fs block number */
>  	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
> -	bool			xefi_skip_discard;
> -	struct xfs_owner_info	xefi_oinfo;	/* extent owner */
> +	unsigned int		xefi_flags;
>  };
>  
> +#define XFS_EFI_SKIP_DISCARD	(1U << 0) /* don't issue discard */
> +#define XFS_EFI_ATTR_FORK	(1U << 1) /* freeing attr fork block */
> +#define XFS_EFI_BMBT_BLOCK	(1U << 2) /* freeing bmap btree block */
> +
>  static inline void
>  xfs_free_extent_later(
>  	struct xfs_trans		*tp,
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index eb378e345f13..47ef9c9c5c17 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -474,14 +474,20 @@ xfs_extent_free_finish_item(
>  	struct list_head		*item,
>  	struct xfs_btree_cur		**state)
>  {
> +	struct xfs_owner_info		oinfo = { };
>  	struct xfs_extent_free_item	*free;
>  	int				error;
>  
>  	free = container_of(item, struct xfs_extent_free_item, xefi_list);
> +	oinfo.oi_owner = free->xefi_owner;
> +	if (free->xefi_flags & XFS_EFI_ATTR_FORK)
> +		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
> +	if (free->xefi_flags & XFS_EFI_BMBT_BLOCK)
> +		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
>  	error = xfs_trans_free_extent(tp, EFD_ITEM(done),
>  			free->xefi_startblock,
>  			free->xefi_blockcount,
> -			&free->xefi_oinfo, free->xefi_skip_discard);
> +			&oinfo, free->xefi_flags & XFS_EFI_SKIP_DISCARD);
>  	kmem_cache_free(xfs_extfree_item_cache, free);
>  	return error;
>  }
> @@ -525,6 +531,7 @@ xfs_agfl_free_finish_item(
>  	struct list_head		*item,
>  	struct xfs_btree_cur		**state)
>  {
> +	struct xfs_owner_info		oinfo = { };
>  	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
>  	struct xfs_extent_free_item	*free;
> @@ -539,13 +546,13 @@ xfs_agfl_free_finish_item(
>  	ASSERT(free->xefi_blockcount == 1);
>  	agno = XFS_FSB_TO_AGNO(mp, free->xefi_startblock);
>  	agbno = XFS_FSB_TO_AGBNO(mp, free->xefi_startblock);
> +	oinfo.oi_owner = free->xefi_owner;
>  
>  	trace_xfs_agfl_free_deferred(mp, agno, 0, agbno, free->xefi_blockcount);
>  
>  	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
>  	if (!error)
> -		error = xfs_free_agfl_block(tp, agno, agbno, agbp,
> -					    &free->xefi_oinfo);
> +		error = xfs_free_agfl_block(tp, agno, agbno, agbp, &oinfo);
>  
>  	/*
>  	 * Mark the transaction dirty, even on error. This ensures the


-- 
chandan
