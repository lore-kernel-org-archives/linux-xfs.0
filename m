Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80431C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 10:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355157AbiCPKgV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 06:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237750AbiCPKgV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 06:36:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6285523C
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 03:35:06 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22G88uat011457;
        Wed, 16 Mar 2022 10:35:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1GqSyuiAsDBqG0YvXQoKtbogI/pCJnqKIuJ5bqOP4v0=;
 b=F8g/2yivmP0jfGu+Qow/on9cCh0TxJupsr+/D7ePbaxndDbGtHBcXKAQitAyU2/9bGzH
 lnow/VKnA3edVOwyq+7EiPEzZBpShoDDQ+8Uh11n3f4135cG8Y6zeSOXJPXSNEqCL26F
 d/dMUJ69lzmXXb6LpJhru71Jme2udhOtaZ2t+OTg+okUmYUYK2elHeWrOSPzCBpksyXC
 YtR2nab+mCuPaeBMIskfc0q0Kr5UrnCw5ymK8S3P77U4JwH/wpimRD080Qimv1z8HSdS
 iIEset9BcnkRwKyy+o7Ck27zfygcjnLI/LEfpy+c1FKUUXMzOEsGlHsDknPnt2OsjRyc /w== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5s6nrwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Mar 2022 10:35:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22GAUXoE077427;
        Wed, 16 Mar 2022 10:35:04 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by aserp3030.oracle.com with ESMTP id 3et64twugs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Mar 2022 10:35:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZALwdtrJFCg5bBJaRbXDTv+yaURPjxeZqsqHw7BtEkhyOZTBAT7TNmE+F+4smadzPssYyOwGRGAVmDdridWQKha+Dl8CrsndLeKuzhM7KgYdCqZC7u9YV96TgD81iknWeSmKvDu673DHmT63p/PiWy7bvCppSEwVnfHUzGlCItt1cc9bi11KgJzkgzZvVcczsBTD89+uxN0lnsMXADIg7+LQsZwPxu+hoO3QqadZyrgQevSPYo40nIj1II66C1I4zMGHeTYjlVB2VL0zs/losKkvpWIW+fWdXd4Asap9kg5il9QhHn2mWZ3I1T5D6DUolxY3z1g5B3n80q+hLnGjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1GqSyuiAsDBqG0YvXQoKtbogI/pCJnqKIuJ5bqOP4v0=;
 b=LMVaGd2wlSC4pmZzv1HP8Pr6ZPelWeMACuCl1BUClDee83og9I1SIg8AfWxn+eEJRlZZTLiNsS6rqa8i9m16VZ5L6jXo9LFfTrKTxTdLpTNZ6NCeO7BAM+5aKoBGRp4xO/CM7J3cY1S+QYiUpv0nEl1uN0NOaVbSNc2vAOrtpkx++89MSfSYfA2yomrxbhyetUW57dXhwDdw/f2ttH/y0rse3ZajUi4fNyOVVjEULBOpjkaCnmTuck1mp7XyQgWfONwEh7O1DFrQV/ENq/kMEflx8IEeGXw61vA6rh8TN5aGEeaOGVa+YUjChoAgDTAkCc3pYmopr/CyAbzVdi41KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1GqSyuiAsDBqG0YvXQoKtbogI/pCJnqKIuJ5bqOP4v0=;
 b=0B6a/7+fpTaK4IvfdIz6uaJY0GGJp/9E2KGD3lrZ41f6tm99KF7E21BJhqKGW7NnBpLxgtgmFjCgyMt7mk6BVygKA8b4+7liPeLzU3pZljCn4aOrwV8cPZtxqLCeZSc5VPLr8VhVhJK2Ag1x4yszpQ6P6I4N2wlxmf36p3h6j0Q=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB3477.namprd10.prod.outlook.com (2603:10b6:a03:128::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Wed, 16 Mar
 2022 10:35:02 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.015; Wed, 16 Mar 2022
 10:35:02 +0000
References: <20220315064241.3133751-1-david@fromorbit.com>
 <20220315064241.3133751-5-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: async CIL flushes need pending pushes to be
 made stable
In-reply-to: <20220315064241.3133751-5-david@fromorbit.com>
Message-ID: <871qz2dw34.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 16 Mar 2022 16:04:55 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:194::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47caf427-5692-4255-25ea-08da0738a0c5
X-MS-TrafficTypeDiagnostic: BYAPR10MB3477:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB347796EAE39D872756A4C747F6119@BYAPR10MB3477.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6DFaafscQ4spD0rey4YwBJvdBQHJ5dDHBZShAlZlqDo/c8icfowkH2m4eCpzvkbnx2zzI/dBTwvmjmpT/E2VkbyI/MHTxzBBTrm6y5mPxi4TWAQPCmNYOuQfA2ouqJPslZerM2SVUhZjU7hV/uPLeLbh+0OnhMAbxKxqwyxumPTB1GuxKkSVhoUTTFQDfjSbdjGxyDji0JKOb7MN5OTFJKezbmSLRq3W0AvH6/N6De1v24A8mi53l8vshtf/5x8vL709eeCCMozL0dkbtaknFRGdkoFkoZvu/vTkeKHWoBETepFfA2hV3kfvBj44ik3za6Woe7zlH2nXljW2+aYAsxQy5xISxwLMsGU7vaR0HVkhT0vutFyvpCvwrbM6Q4Ko6ZzajNUD/IHks7yOZO2jzy1jhQZ0ZzH2C85VgIuSWZrEzNmmLO54IIvcXSK/d8drbZNoFK6bCwBGHCaoTouwjJKmg/2gDqYNB52jwW+YNth0SGwh0wr58vPB/p2xXKpwX0eQ2agQ9qJS7nLO06nyVHf/DKA2I5RUN7Rc3smEATJ4d2C2xTpB+ayLfl4Cs2UITLo/naA9x51aoozAtz5GU863FV1Raf7H1RpGpzgRCKg8yDEPpi3xdCeHBAajUO49nvT4mjeI04gqbQ9xLXCXiEHDBx2sU3znjSQGqwF8Ayfj/AA9lCguV8zChyJ9Mc//B7YM3k80P1fOE8tCsECRmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33716001)(9686003)(83380400001)(52116002)(53546011)(6666004)(6506007)(6512007)(186003)(26005)(86362001)(5660300002)(8936002)(2906002)(6916009)(316002)(66476007)(66556008)(66946007)(4326008)(8676002)(6486002)(38350700002)(38100700002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JsIA3S8yXUiX4707oVZllxx+LzdevllswcpWJCkBqx8QYGF5g7WvTIVJcWxL?=
 =?us-ascii?Q?2qdNfBpLY3yWblucksjaKYIF7clqJKrjwpKEhxEXsbEVFP1PgjG5JLUeZmSG?=
 =?us-ascii?Q?iGXCSYMgh9RsJHPPNtVgY9KwKF2mWZFX0LZY0fOdSfbEaMQuooCqyJOl5NKK?=
 =?us-ascii?Q?3qfRXYJgwoNJfEt0+NJR1kuZJ+dtteSfmYt0BiMpnBY/BUyt3/dc7DzB+9VY?=
 =?us-ascii?Q?iN/R9Y37iCWxEy9Z/1ozOGyOQeMqd8y7LI8EWamNlKXK0qhSaLAxunI+PMxA?=
 =?us-ascii?Q?6/9WZLEpvaDauisKzsKYyYiT3QUF2dSfqce82ocRB8PMuRKEx5fEN+GTD6Cr?=
 =?us-ascii?Q?JDA+NhFSjjfe4lm+O1E9g886JjxZ4eMBI+Bzak6//Cd6ucQe08FQrrMt/dSY?=
 =?us-ascii?Q?hE4fjdKGH4RViTRqFoE848IlVg//0rwba6dDwRMuoQFbprGbzPn99rVYCr02?=
 =?us-ascii?Q?H5kV7WpPj7s05cOQvr8LNFivn97sccxIBqzRIlrKWAtThWu9AOYaTOmKOd4b?=
 =?us-ascii?Q?PRd2K3wazrB2aAd156Ip6NF192wU2Xle3CLry23JBy4tOsFdtSqfBdJLUVeq?=
 =?us-ascii?Q?JmfKauzUw5FMII1hk3AYDrZbwwcZ0l2czvJoAdmsZFflMz6iU/65IaiCFo3X?=
 =?us-ascii?Q?PZk70lUsUdRWo4upir6gfr9zmEb7+EmAVEfwNj/jI55+UXO6ysNEXYQFC6AW?=
 =?us-ascii?Q?GqEzOz7HhgJzLhYNOvzGds+GsDbHdXTQS2zUnDM0IiYkMZcZ+vFtZbOgw8Mz?=
 =?us-ascii?Q?aG+CtR3OTyt2yNkEs8Ku1txwljH96aFRf3io+XISy1RS9lQDT5O0/KCNot14?=
 =?us-ascii?Q?pLEv8tX75YQw6Js4EGAfpWxnxCBxjG1LN7h7XvTKh2YB7V3ugdyFNguLzcLZ?=
 =?us-ascii?Q?v7QTCGE0Kax5+y3nPqRK0F3BlgK3JGd4k3M9K7ciH6Ls3vBt5u5H4OcpF0Xy?=
 =?us-ascii?Q?KbZrmYSkW+tjxSSp0eG2f5TeQdsATujYOXozEie+pfFUEHqAu7O2Fxr99PZ4?=
 =?us-ascii?Q?OqYGU0dw2IN/CY3GZdlXt6cWYWCVv7Zc43VvOJKhlt1jBGpZu4Ws51NTZ70h?=
 =?us-ascii?Q?iSD0Zo7AYEOTPeRiX/SbVUdHPgGtXhNXjZop+k4ILLlNqr5xU9qrqaSnFQvh?=
 =?us-ascii?Q?3KK4Lfi5aM+EKW/GhQcSesmdhdLYlDuArqmAue9mrUBabwSs1L+gg5diE5pP?=
 =?us-ascii?Q?TGqXvQYcXAcvF++Oc/nhlSwtbIstV//CMISWCDHUTN7oPMaBB+cvyC2R3tFy?=
 =?us-ascii?Q?bCldD4tpaCfS2/HwvhDFEW+XVEoEySpRoEEFaMCneBvQULYHc6KvV5g5eCQi?=
 =?us-ascii?Q?/tU8GBQFQsa6LxoorwyId8v1RvnVlVTW3CMAOAP1qotIpFuZNybt+EZyvyr/?=
 =?us-ascii?Q?qNcgRPt+2OVh2G/bmqNKfGIiYmOMuSomjZT8VHrHe53QLtWvyfbr354mgGsM?=
 =?us-ascii?Q?alQnYRxI2pR9fEoMyd97bh9CEmdsMzdJzvGAkBOHa1RnjzrqetvcBg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47caf427-5692-4255-25ea-08da0738a0c5
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 10:35:02.6308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6qwtvQcf3lbGVNWZ5I+rELpvNceXP10V0gGRXSMyHJT53Mmfl7FfIiXi+fnhxXzP9RCBslpWJkKMP/ktuRtj+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3477
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10287 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203160064
X-Proofpoint-GUID: q5xjpRWOvmJ93BDd0NKZDh5jeh_l2g1t
X-Proofpoint-ORIG-GUID: q5xjpRWOvmJ93BDd0NKZDh5jeh_l2g1t
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 15 Mar 2022 at 12:12, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> When the AIL tries to flush the CIL, it relies on the CIL push
> ending up on stable storage without having to wait for and
> manipulate iclog state directly. However, if there is already a
> pending CIL push when the AIL tries to flush the CIL, it won't set
> the cil->xc_push_commit_stable flag and so the CIL push will not
> actively flush the commit record iclog.

I think the above sentence maps to the following snippet from
xlog_cil_push_now(),

	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
		spin_unlock(&cil->xc_push_lock);
		return;
	}

i.e. if the CIL sequence that we are trying to push is already being pushed
then xlog_cil_push_now() returns without queuing work on cil->xc_push_wq.

However, the push_seq could have been previously pushed by,
1. xfsaild_push()
   In this case, cil->xc_push_commit_stable is set to true. Hence,
   xlog_cil_push_work() will definitely make sure to submit the commit record
   iclog for write I/O.
2. xfs_log_force_seq() => xlog_cil_force_seq()
   xfs_log_force_seq() invokes xlog_force_lsn() after executing
   xlog_cil_force_seq(). Here, A partially filled iclog will be in
   XLOG_STATE_ACTIVE state. This will cause xlog_force_and_check_iclog() to be
   invoked and hence the iclog is submitted for write I/O.

In both the cases listed above, iclog is guaranteed to be submitted for I/O
without any help from the log worker task.

Looks like I am missing something obvious here.

>
> generic/530 when run on a single CPU test VM can trigger this fairly
> reliably. This test exercises unlinked inode recovery, and can
> result in inodes being pinned in memory by ongoing modifications to
> the inode cluster buffer to record unlinked list modifications. As a
> result, the first inode unlinked in a buffer can pin the tail of the
> log whilst the inode cluster buffer is pinned by the current
> checkpoint that has been pushed but isn't on stable storage because
> because the cil->xc_push_commit_stable was not set. This results in
> the log/AIL effectively deadlocking until something triggers the
> commit record iclog to be pushed to stable storage (i.e. the
> periodic log worker calling xfs_log_force()).
>
> The fix is two-fold - first we should always set the
> cil->xc_push_commit_stable when xlog_cil_flush() is called,
> regardless of whether there is already a pending push or not.
>
> Second, if the CIL is empty, we should trigger an iclog flush to
> ensure that the iclogs of the last checkpoint have actually been
> submitted to disk as that checkpoint may not have been run under
> stable completion constraints.
>
> Reported-and-tested-by: Matthew Wilcox <willy@infradead.org>
> Fixes: 0020a190cf3e ("xfs: AIL needs asynchronous CIL forcing")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 3d8ebf2a1e55..48b16a5feb27 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1369,18 +1369,27 @@ xlog_cil_push_now(
>  	if (!async)
>  		flush_workqueue(cil->xc_push_wq);
>  
> +	spin_lock(&cil->xc_push_lock);
> +
> +	/*
> +	 * If this is an async flush request, we always need to set the
> +	 * xc_push_commit_stable flag even if something else has already queued
> +	 * a push. The flush caller is asking for the CIL to be on stable
> +	 * storage when the next push completes, so regardless of who has queued
> +	 * the push, the flush requires stable semantics from it.
> +	 */
> +	cil->xc_push_commit_stable = async;
> +
>  	/*
>  	 * If the CIL is empty or we've already pushed the sequence then
> -	 * there's no work we need to do.
> +	 * there's no more work that we need to do.
>  	 */
> -	spin_lock(&cil->xc_push_lock);
>  	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
>  		spin_unlock(&cil->xc_push_lock);
>  		return;
>  	}
>  
>  	cil->xc_push_seq = push_seq;
> -	cil->xc_push_commit_stable = async;
>  	queue_work(cil->xc_push_wq, &cil->xc_ctx->push_work);
>  	spin_unlock(&cil->xc_push_lock);
>  }
> @@ -1520,6 +1529,13 @@ xlog_cil_flush(
>  
>  	trace_xfs_log_force(log->l_mp, seq, _RET_IP_);
>  	xlog_cil_push_now(log, seq, true);
> +
> +	/*
> +	 * If the CIL is empty, make sure that any previous checkpoint that may
> +	 * still be in an active iclog is pushed to stable storage.
> +	 */
> +	if (list_empty(&log->l_cilp->xc_cil))
> +		xfs_log_force(log->l_mp, 0);
>  }
>  
>  /*

-- 
chandan
