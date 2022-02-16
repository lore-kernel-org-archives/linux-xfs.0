Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F526C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 14:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbiBPOr4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Feb 2022 09:47:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235200AbiBPOrz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Feb 2022 09:47:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9741F1C89FD
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 06:47:43 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21GEifMH025581
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 14:47:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=OxfMcyoaICeSaycyjJhllVFPMmK88dacJg462Xflx70=;
 b=nSe4zVqdWWowdt7/4UXUdpAve/rJex+FXetfJtGxoj5WzK9GHxWHuxv9Dk0tjhDfbD1t
 SVBz394jIOlUnuwJO04VPmOUjw4Xa79ir1CopDW7pu+5wVi9ymF4sO7VpIBHJwvE57IF
 Sj2SAs3TYCONU8Qf7Msv3Q3WdURsCSzXtK+9QFg+Kbity5FXJ0gUjolnC0PvFMTdnGph
 RnEN6qss6NUWbzGdav9+WXu3cBhruSyi+IfhWGQjEF/W/JuJNc/pcMvki6ITyyEmb4mn
 BORhPfRkdvqVOiWTNHuRoExlub4CgnEP3plsrtyQJ8lkLqRYP6bKFP2XA78nfpYVabeb 3g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8nr92cfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 14:47:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21GEjFhA043111
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 14:47:40 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3030.oracle.com with ESMTP id 3e8nky4e12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 14:47:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NV6Kj4ec9ybDAfvrEZAOgPRtBvrioHk+Z7vFlwhUeG5+7h0L7apIZRlsiRe5wT4qsxefBv3u4coUTNWTKvWT640nIc6pYiWvz6yaNtrT0BxxZ/rUq4j73tRNGYUM8YmU8u3/JIK6mtYFbh3KPDsp1BUZEQiixBx7k0BNtvQmZmAfeJpQU+v/jcie1UWc5zXUuAzaXkkDZ2jktcBTB9ujDKZJS9gMUov+1jw2ikuWclqbR0IZ0mTz/vuuEv1WMeXtu4MNPEK2W7h1XtCozZpgMRagA0GpSTaosvBJZaJZHJNhD1FMQjx1jKQ/J26499luWLk97zK+EEB0SL1egAHVQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OxfMcyoaICeSaycyjJhllVFPMmK88dacJg462Xflx70=;
 b=lJWYfzbX75ejZ13Cymp2dYIdm1BVFLJoYDtaCm4V7ehJ/bVsIRbroy6J3u2sGZ63u2W6d/Bjvc5hlLxZ34ek3tszxzGILOEoFX1+Ba5ycwzrsE0j0dqkPjcjpKRzaHvs8gjEiOdjOaH3iISbTWrh9tQBpSsKylBXWhCfJ/fNVUqguIJe/5SuWcXfeClat9WRclk7aIOwyzCN+hOPN5kGSYnS7syC7x8Kl12USGdD8BAciNtcqX7nF9e90cA8WOyQtyKcfjf+vNPginm1jzXBloGWhSxImi5M2UICzrkUmzfaJ+nDEirn/ARi85qTJr1naT85JniqoXePqXH6XgUkVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OxfMcyoaICeSaycyjJhllVFPMmK88dacJg462Xflx70=;
 b=XE/fvnkMiZjn4kd9EI5YvR43JVbypXHUjXhZhTBfUbfK4NIn13QF6FzTptoHpCBzx9pRxIDRDTRTmoJd+w5FwhGTenI/oKE6ER7MMgNzpKcKUD/ReQK44Tz+foF0BOXoqn33XkdECQm0/kiBzjvkK0l9uvDP6sEDZudNULmvz5Y=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR10MB1737.namprd10.prod.outlook.com (2603:10b6:4:11::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.15; Wed, 16 Feb 2022 14:47:38 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%5]) with mapi id 15.20.4995.016; Wed, 16 Feb 2022
 14:47:37 +0000
References: <20220216013713.1191082-1-allison.henderson@oracle.com>
 <20220216013713.1191082-2-allison.henderson@oracle.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v27 01/15] xfs: Fix double unlock in defer capture code
In-reply-to: <20220216013713.1191082-2-allison.henderson@oracle.com>
Message-ID: <87leyaj2bk.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 16 Feb 2022 20:17:27 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0187.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::31) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e10763a-6cac-45a4-52aa-08d9f15b4667
X-MS-TrafficTypeDiagnostic: DM5PR10MB1737:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB17371030BE974531688B553EF6359@DM5PR10MB1737.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:227;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0mN9hTSICMkX3uRqp54Mk2DVZ+ZbssD3t5zCgM+yB66lPBom+obhx060oHywCigBNEAyaDZE3X7XXpNU7h3dM9huxNS/Ju3VNzklvxp2SBcgiSwN9xMRdGqaoHyeVr/n42jtHz1GkRv+TBz1SXXDAfFnmE5QGWdt11q8f1Aa3l8c6gPlg/C2YFcbjdRm1HgUypqMk6QilEe6JqOmM+044aoklfxG44MZX3DbOXuYlXzQSRw/01+RdgVgzJH3/5Cj5oSeHJwz1FreEY8/8rrcY0WICKtL6FQnXH3k5lRnCWIdWkQcUUxeif7nlqsx6Q664F1vsK0XFT3kD7di+Mpxkuhp/3q0f/ZF3Rn+HMgphA7LgxX53hivbjwDeyBYuEzVnnxhLSMNthPc0m5S9VXPWvd9jpXn2CVGHtpCP9sCo4rTMmnu/rzZ0snnwO+FrEzInSzsnu/c1ExjEZhtD+4KwCSYEdKMgrry7Aa2JfMrGrERetZ+tXwjRNndYSgrnhNlR7jxTxpUkU6CX0KErI3tEyvpSG8dIJgR+zIvoLRvfGOiPmKFxJyd9D/8ENqDQuF8Ybw83yzPK2cuKbi45NQMAm2DAZtqy3sp/BwUh720QDri4kWA39iQVEJt5WNdUzhsAHJFW6oUQUMAmDahm4KFQJ84fUiYWLBShSG88OpFIo0YyNDjZ6akMsPzGRz1DVot5SOAu4FdxW1+VjLFbv0wn9E1b4BqbPlGk2gxPelVVqQMQmkjGGST6P+xGXc6DK3i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(316002)(66946007)(4326008)(86362001)(186003)(6506007)(2906002)(8676002)(508600001)(6862004)(9686003)(66476007)(5660300002)(66556008)(6636002)(6512007)(6486002)(83380400001)(26005)(33716001)(38350700002)(38100700002)(6666004)(8936002)(52116002)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+/mAeQ9mlpYDSND1tIOWDDWMZHtR0hHuCLpTLW7HE6/4rx0wk0honBsFfuh9?=
 =?us-ascii?Q?Z2ywYOIgf6SszUQtNUuvNyHiijhsl6+3q4B4gW88XaI9ESBuIhnsD6qW1BKn?=
 =?us-ascii?Q?p4AZmYvqphSBNmfAEcXt3/lBa6gLjiLujQM8mpmBImoTSYmLkySqRJwgMMdc?=
 =?us-ascii?Q?hvEdY1Ip+0EMjiWtmFd+7oQa4YK6iGaFG8DMZqiYtSNQqDkHCxAfCGhBnPvR?=
 =?us-ascii?Q?ZXmr+oF/Jb9c2uhc7sNB6YJT5cN8+g4WLLFYA+7RVL7J45s8yl46tuq+DoZQ?=
 =?us-ascii?Q?LNROW5Em+sWvgk/85yNpYkyKD+RR84O3Z2zdbuq2dutGBeDf1FXkwRT6OCA4?=
 =?us-ascii?Q?0WUNMgifaKVmBZQru3ruY/iWQekpib52Y7TOpJd8lMfGRy4LUwlV0O6qEj5C?=
 =?us-ascii?Q?2kZRKKE6+wA8vTvwBBkE0EfedvyO1Se1czZW6Eh4WGc9ej8mYpnSbQKXNaMo?=
 =?us-ascii?Q?pdp2hD4oEXAlDNggLYHbQ5ClBjanXKJOU8mwmD6uXapUNcsrdu4UOGdJvWB6?=
 =?us-ascii?Q?+G1oHiqJ/Ieo3+JKgpD9wmxyIQEieXZsVbxZzX/vUr1zVihjgx7Wrp2U8L74?=
 =?us-ascii?Q?rDsXCCySFNuBRggFLdjNWhfGlYL1wtseLfZNPgwrpqBbb362GU8DQLToESY2?=
 =?us-ascii?Q?AnGHxp2f9/NWBxQgbrvrtUQJR7U4oHH8VM+ljexHLhZtzwsiduxWO/jTtIG9?=
 =?us-ascii?Q?OJC9jIBv9ZkG4KBIhwD81RigBDM+9bt7vw2FRx4UqLrUEv10tpO/OJEgF0GA?=
 =?us-ascii?Q?5AHJKVM0Cqy8puPP38n/7cHdUovVafBRQnwCvawuUk008TP31kvvUT/VUyI0?=
 =?us-ascii?Q?94XbEmFdqQpeY2ixnxIBVKPUGdrLnuvSzX46uOkZ4jHttdXhevCU2kTHS0SF?=
 =?us-ascii?Q?0zX4QlgOvXMew2bBQBDwqAenGd1yuD7z7EPzZAfXsamVQSIvKNrWTLZeeAoK?=
 =?us-ascii?Q?1iJ9Cx1WqCNbP5HNzC6I8LBrRgeJIonEXHiuvJu7vuaUeMOs1AABfyHBkbyk?=
 =?us-ascii?Q?wheYXdHD5kPPqyBUrc9R7neDMsUx9KN43Lzp4eDXUZikvwPAl1cd7r/LjWGR?=
 =?us-ascii?Q?MzFrSJYxtTbUyBripAdamr24HqDgWk3D0UpJ1bW+Ru1rEPxRHemc0FEVgXLV?=
 =?us-ascii?Q?dKrEDbmwwpCqEefxWgo/8mXg/Z1Lb0nOQCrdz8LMt13TJeo2WMBASGeE+zn0?=
 =?us-ascii?Q?LaK8rtJTeiU9VD2BU8xyuEoVnq7j6r6J1edTFQTpcmDqPtmQ87Twt2QBW3p8?=
 =?us-ascii?Q?4y2MAVR6TH/mIAAdM0NXU2+7+xLkBa+th3vSo8i7Kps7+vtZCetI91TZFCBQ?=
 =?us-ascii?Q?ZhBRrDZcYD9o3nPQSWwzlTnXamcjY/DuIonxK6JCX+biN6CxLCpjkgL/+ot0?=
 =?us-ascii?Q?57DcjelbgHyKCaFmE6hHAc4VgDKzKk+SYoiC2CI2ByQnWCGYkqxv9k+e4/Z0?=
 =?us-ascii?Q?DQcLwZCB2ahFLy7X3XAySV9dhwkYeCBBrujkkfHfK9zsyJOkVsnjDTI/mqYj?=
 =?us-ascii?Q?Di0cV2fInTD47eHNasAqLxIxEnW+JkEKXlWndEYLWFQxkFsoiMbqfDKD6nSJ?=
 =?us-ascii?Q?35EMU/B60AqMg4QN/5G6TgcxosqUF6M5hc/nzjgZlJgT99LQvDT0nkf6IhNl?=
 =?us-ascii?Q?6O9MIfO78LVhOuBIcISKDbc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e10763a-6cac-45a4-52aa-08d9f15b4667
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:47:37.8098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EGgSJqbRQnEu5Hi4o0fkySCNVir5FqpfEttSzXuRG7rBS44p++mXzTJrS9IY1G+JtnEF2ZPNWj4ob4sQvy/SKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1737
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160086
X-Proofpoint-GUID: Oif6YBUCyiPNP9XGdaQaJ3TX-kVONWQj
X-Proofpoint-ORIG-GUID: Oif6YBUCyiPNP9XGdaQaJ3TX-kVONWQj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 16 Feb 2022 at 07:06, Allison Henderson wrote:
> The new deferred attr patch set uncovered a double unlock in the
> recent port of the defer ops capture and continue code.  During log
> recovery, we're allowed to hold buffers to a transaction that's being
> used to replay an intent item.  When we capture the resources as part
> of scheduling a continuation of an intent chain, we call xfs_buf_hold
> to retain our reference to the buffer beyond the transaction commit,
> but we do /not/ call xfs_trans_bhold to maintain the buffer lock.
> This means that xfs_defer_ops_continue needs to relock the buffers
> before xfs_defer_restore_resources joins then tothe new transaction.
>
> Additionally, the buffers should not be passed back via the dres
> structure since they need to remain locked unlike the inodes.  So
> simply set dr_bufs to zero after populating the dres structure.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 0805ade2d300..6dac8d6b8c21 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -22,6 +22,7 @@
>  #include "xfs_refcount.h"
>  #include "xfs_bmap.h"
>  #include "xfs_alloc.h"
> +#include "xfs_buf.h"
>  
>  static struct kmem_cache	*xfs_defer_pending_cache;
>  
> @@ -774,17 +775,25 @@ xfs_defer_ops_continue(
>  	struct xfs_trans		*tp,
>  	struct xfs_defer_resources	*dres)
>  {
> +	unsigned int			i;
> +
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>  	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
>  
> -	/* Lock and join the captured inode to the new transaction. */
> +	/* Lock the captured resources to the new transaction. */
>  	if (dfc->dfc_held.dr_inos == 2)
>  		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
>  				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
>  	else if (dfc->dfc_held.dr_inos == 1)
>  		xfs_ilock(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL);
> +
> +	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
> +		xfs_buf_lock(dfc->dfc_held.dr_bp[i]);
> +
> +	/* Join the captured resources to the new transaction. */
>  	xfs_defer_restore_resources(tp, &dfc->dfc_held);
>  	memcpy(dres, &dfc->dfc_held, sizeof(struct xfs_defer_resources));
> +	dres->dr_bufs = 0;
>  
>  	/* Move captured dfops chain and state to the transaction. */
>  	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);


-- 
chandan
