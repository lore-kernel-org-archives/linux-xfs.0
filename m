Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A4EC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 11:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbiCPLII (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 07:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355261AbiCPLIE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 07:08:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624F963BCF
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 04:06:50 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22G8FCVi017359;
        Wed, 16 Mar 2022 11:06:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=y8peawFo2PtkINlg7Srj44z1Oke2ZtFKE02VgK9MS/0=;
 b=T5qkC3FdIeSimr8VuaILCrg+f1E/2qJrUfU1e3D/lw9sR/WlqFT90MvGsrh1pxwycUnt
 sklG8WJ5BRo8fb5uNGb68ZHcrbe0ugcBcf6m5zGCiaM+tPn7SRQ2ajShKeVBUTAencJ8
 JPrNMZ+++1O9gk1D85ybhQXUoA2HXlKxdNek/8BfOdLg4JPax6VHFqXm6Ejf5627Yqv0
 wMtDf7BxsuDbuR4+H0Mz0XYCRmlPDW2Adz2QsZikAcz2wXLkdIxqNRPXpL0v380uVBIU
 QaoMPTOp195U+8+0hCMhdlD/ub57CMWhpuLAHWKyfZwhI1TTu7eNTK+vwBAbyfQTDHK4 vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et60rdn0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Mar 2022 11:06:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22GB23JA082181;
        Wed, 16 Mar 2022 11:06:48 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by aserp3020.oracle.com with ESMTP id 3et64kkht6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Mar 2022 11:06:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hE/dK0D3U4kpon8XGyj0go6cqtr+A0X4xNMIY87aZ+ezrVQKi03BS/4QEAyxKXKf8cj66ZadN8lRmOnOxzpIszXl3gPWDf3nrOuUIt+NlTgiVi8tm6np7aKpO1H9gZ2XCJ6YlBZtgJp4tvUTOvVDRWhkq4lEr4BFhTAtDb/MsZ6+I5grA7/qCg7WbwjennXO54xR+MubOMjGPUF7YSy8QmoOh5R2qsNH99TMxHBnm8CW788r9Xda2hRxZLwZcWaa7CMdvGicgCOzNlwkHebANhdzg7qWcRCYBD6deFEuFwsG77ojJgS+cJNUO3TyKmuGB0YNkbsPl2vk9CyT53Pkdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y8peawFo2PtkINlg7Srj44z1Oke2ZtFKE02VgK9MS/0=;
 b=iE9KUPN+SHuSvixLwGIcJZQdOIAnCupcRGDkqrZ3hr/GecggTEygTBKNXi2PgYRnD2L/hLcY+36MxQjjWlE/UgYwHDHG9BQMt9bUstj0Bfg2g17CiBJkF/d67+JuBcAlYGjuCp6AnybVrbLkt4uAbF56oMVawReEA0+D5ghVGxRbCPKjtNQ0gCEHodyBLMWXAXDaFvOstUSrHJ0Vyz3ffzC+q3FgErcmPozLd48uMMEptBBzLt0vWOp6CuidcLamXl4aUovCBjEtBop/5oWvF1xwHEGVnRJlsp9gjDPcSLitTjCEughSjUmFNHWAiIKHCnphdTV8eYCg2gUTzZN6ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8peawFo2PtkINlg7Srj44z1Oke2ZtFKE02VgK9MS/0=;
 b=eP8wSqTkzDqiBl0+dCXpOdX/xXc2h1DG06TJUZYX+XCYJos+g2PvnvRSYB10GegJWTolpC2A2J3Yzb0R77ijvr+D9ZA/s268EXGczJxCUAdRcrngo9Fp/UNuxqKzDZpYfVg+Z5J0F+IbKR6tnwvGM/vH5fcWLy6671Fb1K1L2WU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BY5PR10MB4036.namprd10.prod.outlook.com (2603:10b6:a03:1b0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Wed, 16 Mar
 2022 11:06:46 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.015; Wed, 16 Mar 2022
 11:06:46 +0000
References: <20220315064241.3133751-1-david@fromorbit.com>
 <20220315064241.3133751-6-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: log items should have a xlog pointer, not a mount
In-reply-to: <20220315064241.3133751-6-david@fromorbit.com>
Message-ID: <87y21acg1u.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 16 Mar 2022 16:36:37 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0234.apcprd06.prod.outlook.com
 (2603:1096:4:ac::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18d7d0e3-557a-434b-7fa5-08da073d0f55
X-MS-TrafficTypeDiagnostic: BY5PR10MB4036:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB40369470E28B2CCC5686627BF6119@BY5PR10MB4036.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0WVebl69pHdnqgXPRrkvWI6ORfn9JQIQPixEIEXz4rTFiWboLi+q+xCDZwQSSCp7OyeCsAuAWXImEYZzckOJL0Tz+gMtqLbsA7V7igXj8FMS3l1CCI7X7WAxqyFO2JupmlEO8gzG8BWZWr3chyTrvu1HnBo/SCxj5PcdertOksHy9h7eJpCgJh+PQ4cOuo5UcD25P656+NZDHwTuZU/74A0rpo1e0PUF34g4tQQK/ByGreBUMcTwKlgJ2P9DXvg5EyiSqHQDcixTtQ92T80f17t21R2KwX2JEbEAk1sRzmGyXGw9hv2Cvm0ZWoXkO/DFU7I1tCEoyfBl7as50faUtBfq7daQ5KYqDODs35mg2a+y7vxqIT/Lbt2+ogi+aIRtjFH82uriF7/FLVGeqaw1swiAJlHupGJNnwsauTxeDw2BGbgX73t2MC+6uxDCtm1a+1Xd2BXNwK4sHEMVg0w4dRhtQQpLSuqKyX9WciFTYJmwp5B3fueo5LFHA+bPf6XLanFqE4o97/ZTGkAj8xuZq6pyobvnAJPvAfT0kFO0ydLt94zwz/bKjRBklRFgq505UGStrJRqqlxvj+9XYDYCv+O8DFg1z8HJq7BICuTJnWhIX6W0Y5p2HKOKp16KxC/uCKM/WMQHr+YiUzJOTyhQY3pGpLmuN9i+3F5HKU1HM3137rF9eFbwCwH4b8JofYIkth7UtcKP7gg/tQvJlitc6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6486002)(508600001)(6506007)(6512007)(6666004)(9686003)(86362001)(8676002)(66946007)(66556008)(66476007)(6916009)(316002)(83380400001)(53546011)(38100700002)(52116002)(38350700002)(186003)(26005)(2906002)(4326008)(33716001)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6Lw4Bt/vRed8T5+Zir4WukKKuR/3DKeEI/OqNxSpH+nDTzOXbukoM2EgwVfD?=
 =?us-ascii?Q?LitcJqia6dakAYiMRlyaTKxXEEAIUCZtMJidSbMONJi+pEyUJGEzMEiTZSzB?=
 =?us-ascii?Q?7ZkqAIU1Xh2bTgnRuHXmlWWo39kRZB6iJU3kSdV5Ozc5z/kidKttJOWY+7Yd?=
 =?us-ascii?Q?0m0VD9s8/W7zC545aHDGvjiAT2pLQ6MJUFoJVk2UyM1WiJ6JoHVb+APDdoe3?=
 =?us-ascii?Q?pOK39kf3CiqQ/XMe0zLJvw3Vw/RaOOQgg270RPcqSpjFHYtH4FzTCX0lT12e?=
 =?us-ascii?Q?nCiljpZAfy4yQ/QWS7wnIeMN9dEBZUz/o5rmjpFLWHcEQyDARHdOANLV/jaE?=
 =?us-ascii?Q?/8NMxyFz6oZonjz/L8hOe71yvihP9c1D3UmivwW7Za/Rxtzct/UAR3zKwvpY?=
 =?us-ascii?Q?3Y4S+tLfNqVaczTStqUOEvRmFTLJ5hlB1mARb3QCbvFijPvyiasSj4NV/TL/?=
 =?us-ascii?Q?6ByygZ5KP/4JunTLOGg3Dc9t/yDRhRiJrasmKCwhafS5XIvt6zzAERtalozt?=
 =?us-ascii?Q?C0pZbzFvrWN8WyzgTkpqCPb0cR1Qa0LhdB85G5RH9UhRZbtbscWCYi9fpOjU?=
 =?us-ascii?Q?O3x2Q3Ia4L3Sk8OvQ8dLURDpWCqeOz6nJ0RGAl0XG9IIw67HFoXg3+VORpEM?=
 =?us-ascii?Q?a4Xr3oq+yMbI+3wEajbvCgzqNKHiA97VNakODH2Xt0SwWMX1Wtn10nq7nBkV?=
 =?us-ascii?Q?xTogYuIxxAOhRJAlKpcj8rOjbKoC4ncpNVai0X6VgmsSZaG++0ULsbspb1Sw?=
 =?us-ascii?Q?fS6ZI9ACEvWlaW7FSC5fHfN/bsVq0oHtGHFIKWkwcl0esXyJs7rovfBgkWcC?=
 =?us-ascii?Q?tzW36JBguXoY+5zbs5G01HJfYil8dngMcyBWo7YWTe3qPGLTiTS5rZYrHOA+?=
 =?us-ascii?Q?GMXITz8mWOOilIWu9MznaeKJ2Hgz+vWkpTwIbgaGfBpXcv91+DhAQPioubmM?=
 =?us-ascii?Q?yd6LLoneLOZ3o64HXj0yckT2kzMKDBNuB7i/mBCIitRCo9BOUsaRguc9RwZC?=
 =?us-ascii?Q?4WZQqc3P3SRVCbMjPHto82mi21mhyO+NkjOXJ0yNeUn6y5+q6lrJb822u7hz?=
 =?us-ascii?Q?oerBDESKHyYBIVbP0h+S7XmkAVy/4DsX9S1406MDDKx1nlp4OEEtc3IWmLNN?=
 =?us-ascii?Q?SF6uyWD5/TKrssvH13EioxIAiX/H4xpYQrLrNljx3wNxO+GtWZarvpwcCeAZ?=
 =?us-ascii?Q?YPGuTHJApmG6sC5/fEq6b6LHIJJh+GCOFagCbPedaPqEordqNb6rkIjnzrZH?=
 =?us-ascii?Q?UfkbhA023J8SX1lHVYEVllT7MmrP5erGjlYbtzr49sUstQA6p2uV11FSmRnI?=
 =?us-ascii?Q?B+57YaRYY0DXVAnN7v/6QTVX5L2s6Pl8mu2GYB5wMLmaC9q+dega2lOsQ6ro?=
 =?us-ascii?Q?9tKujlToHOQykBtarImtUYBjj2kPZrZfmyC5fXZtpEf/001jMP9dQ7gaN/Lc?=
 =?us-ascii?Q?GQvG1VgPFwMjz/ibTZAZKKY5AD0qkcZ1h/i56a0D+w4NBx9zDRiPmQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18d7d0e3-557a-434b-7fa5-08da073d0f55
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 11:06:46.0831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MnSMla54pwfxXPGz3nS2Pnja0J5BygtKi/QfO1xlU0sKxDkCI/oCliPqAK+Ojg0Ses/S8TNFC8xNGYYZX8zL4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4036
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10287 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203160068
X-Proofpoint-GUID: VHGi5xWavbnbOpnz4eEEC37CJPq5oOG_
X-Proofpoint-ORIG-GUID: VHGi5xWavbnbOpnz4eEEC37CJPq5oOG_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 15 Mar 2022 at 12:12, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Log items belong to the log, not the xfs_mount. Convert the mount
> pointer in the log item to a xlog pointer in preparation for
> upcoming log centric changes to the log items.
>

This patch didn't cleanly apply on top of v5.17-rc8 + Previous 4 patches. But
the changes look to be quite simple.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_bmap_item.c     | 2 +-
>  fs/xfs/xfs_buf_item.c      | 5 +++--
>  fs/xfs/xfs_extfree_item.c  | 2 +-
>  fs/xfs/xfs_log.c           | 2 +-
>  fs/xfs/xfs_log_cil.c       | 2 +-
>  fs/xfs/xfs_refcount_item.c | 2 +-
>  fs/xfs/xfs_rmap_item.c     | 2 +-
>  fs/xfs/xfs_trace.h         | 4 ++--
>  fs/xfs/xfs_trans.c         | 2 +-
>  fs/xfs/xfs_trans.h         | 3 ++-
>  10 files changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index fa710067aac2..65ac261b3b28 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -476,7 +476,7 @@ xfs_bui_item_recover(
>  	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
>  	struct xfs_trans		*tp;
>  	struct xfs_inode		*ip = NULL;
> -	struct xfs_mount		*mp = lip->li_mountp;
> +	struct xfs_mount		*mp = lip->li_log->l_mp;
>  	struct xfs_map_extent		*bmap;
>  	struct xfs_bud_log_item		*budp;
>  	xfs_filblks_t			count;
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index a7a8e4528881..522d450a94b1 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -21,6 +21,7 @@
>  #include "xfs_dquot.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
> +#include "xfs_log_priv.h"
>  
>  
>  struct kmem_cache	*xfs_buf_item_cache;
> @@ -428,7 +429,7 @@ xfs_buf_item_format(
>  	 * occurs during recovery.
>  	 */
>  	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
> -		if (xfs_has_v3inodes(lip->li_mountp) ||
> +		if (xfs_has_v3inodes(lip->li_log->l_mp) ||
>  		    !((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
>  		      xfs_log_item_in_current_chkpt(lip)))
>  			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
> @@ -616,7 +617,7 @@ xfs_buf_item_put(
>  	 * that case, the bli is freed on buffer writeback completion.
>  	 */
>  	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
> -		  xfs_is_shutdown(lip->li_mountp);
> +			xlog_is_shutdown(lip->li_log);
>  	dirty = bip->bli_flags & XFS_BLI_DIRTY;
>  	if (dirty && !aborted)
>  		return false;
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 36eeac9413f5..893a7dd15cbb 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -615,7 +615,7 @@ xfs_efi_item_recover(
>  	struct list_head		*capture_list)
>  {
>  	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
> -	struct xfs_mount		*mp = lip->li_mountp;
> +	struct xfs_mount		*mp = lip->li_log->l_mp;
>  	struct xfs_efd_log_item		*efdp;
>  	struct xfs_trans		*tp;
>  	struct xfs_extent		*extp;
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index b0e05fa902d4..5c4ef45f42d2 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1136,7 +1136,7 @@ xfs_log_item_init(
>  	int			type,
>  	const struct xfs_item_ops *ops)
>  {
> -	item->li_mountp = mp;
> +	item->li_log = mp->m_log;
>  	item->li_ailp = mp->m_ail;
>  	item->li_type = type;
>  	item->li_ops = ops;
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 48b16a5feb27..e9b80036268a 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -76,7 +76,7 @@ bool
>  xfs_log_item_in_current_chkpt(
>  	struct xfs_log_item *lip)
>  {
> -	return xlog_item_in_current_chkpt(lip->li_mountp->m_log->l_cilp, lip);
> +	return xlog_item_in_current_chkpt(lip->li_log->l_cilp, lip);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index d4632f2ceb89..1b82b818f515 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -468,7 +468,7 @@ xfs_cui_item_recover(
>  	struct xfs_cud_log_item		*cudp;
>  	struct xfs_trans		*tp;
>  	struct xfs_btree_cur		*rcur = NULL;
> -	struct xfs_mount		*mp = lip->li_mountp;
> +	struct xfs_mount		*mp = lip->li_log->l_mp;
>  	xfs_fsblock_t			new_fsb;
>  	xfs_extlen_t			new_len;
>  	unsigned int			refc_type;
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index cb0490919b2c..546bd824cdf7 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -523,7 +523,7 @@ xfs_rui_item_recover(
>  	struct xfs_rud_log_item		*rudp;
>  	struct xfs_trans		*tp;
>  	struct xfs_btree_cur		*rcur = NULL;
> -	struct xfs_mount		*mp = lip->li_mountp;
> +	struct xfs_mount		*mp = lip->li_log->l_mp;
>  	enum xfs_rmap_intent_type	type;
>  	xfs_exntst_t			state;
>  	int				i;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 585bd9853b6b..cc69b7c066e8 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1308,7 +1308,7 @@ DECLARE_EVENT_CLASS(xfs_log_item_class,
>  		__field(xfs_lsn_t, lsn)
>  	),
>  	TP_fast_assign(
> -		__entry->dev = lip->li_mountp->m_super->s_dev;
> +		__entry->dev = lip->li_log->l_mp->m_super->s_dev;
>  		__entry->lip = lip;
>  		__entry->type = lip->li_type;
>  		__entry->flags = lip->li_flags;
> @@ -1364,7 +1364,7 @@ DECLARE_EVENT_CLASS(xfs_ail_class,
>  		__field(xfs_lsn_t, new_lsn)
>  	),
>  	TP_fast_assign(
> -		__entry->dev = lip->li_mountp->m_super->s_dev;
> +		__entry->dev = lip->li_log->l_mp->m_super->s_dev;
>  		__entry->lip = lip;
>  		__entry->type = lip->li_type;
>  		__entry->flags = lip->li_flags;
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 82590007e6c5..de87fb136b51 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -646,7 +646,7 @@ xfs_trans_add_item(
>  	struct xfs_trans	*tp,
>  	struct xfs_log_item	*lip)
>  {
> -	ASSERT(lip->li_mountp == tp->t_mountp);
> +	ASSERT(lip->li_log == tp->t_mountp->m_log);
>  	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
>  	ASSERT(list_empty(&lip->li_trans));
>  	ASSERT(!test_bit(XFS_LI_DIRTY, &lip->li_flags));
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 85dca2c9b559..1c5c5d7f522f 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -8,6 +8,7 @@
>  
>  /* kernel only transaction subsystem defines */
>  
> +struct xlog;
>  struct xfs_buf;
>  struct xfs_buftarg;
>  struct xfs_efd_log_item;
> @@ -31,7 +32,7 @@ struct xfs_log_item {
>  	struct list_head		li_ail;		/* AIL pointers */
>  	struct list_head		li_trans;	/* transaction list */
>  	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
> -	struct xfs_mount		*li_mountp;	/* ptr to fs mount */
> +	struct xlog			*li_log;
>  	struct xfs_ail			*li_ailp;	/* ptr to AIL */
>  	uint				li_type;	/* item type */
>  	unsigned long			li_flags;	/* misc flags */


-- 
chandan
