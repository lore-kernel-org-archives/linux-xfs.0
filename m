Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C86B7C1975A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 04:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8317520719
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 04:42:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GgXglL6E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgCYEm3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 00:42:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39928 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgCYEm3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 00:42:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P4d9Fa067095;
        Wed, 25 Mar 2020 04:42:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GQTKimrHYdom8t5g4NVqTlODutWGw+onTzgcq+o5jqw=;
 b=GgXglL6EzNzbc1feP0QkZTzhCIdqfSi/pPfin/1W2ipYaVIe7lwB3A1ZKz+G092SfoFx
 Qb+E5mDCHAxm3/2iSt0XcJ1PzewpXcrqxkUE9qP6P9amCXWlLDlg+OoJKLwUSV6EPZTn
 IhwmZ3OnYq8UCo66Ek70Egi5iwhIFfy9FHcuTq9WeQpzZgSNrdvcRUWkoRSjhoBeNjPO
 Bl7Lru2U5VPKnBQmglLk2d9dTaxJpr4HihbZb2lG5VG/NSO5AslaCrrjoJxoR6bHz/68
 iHwEYWrssr8ayZHhBrZnAhfw62SDyE/Ml5bAPtrOoodJmxNTN6WEq6/fJGgrsUYEwdG1 5w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ywavm7r6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 04:42:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P4SNft040324;
        Wed, 25 Mar 2020 04:42:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2yxw93vr76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 04:42:26 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02P4gP87005553;
        Wed, 25 Mar 2020 04:42:26 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 21:42:25 -0700
Subject: Re: [PATCH 1/8] xfs: Lower CIL flush limit for large logs
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20200325014205.11843-1-david@fromorbit.com>
 <20200325014205.11843-2-david@fromorbit.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <84d89df0-284c-0194-ff31-e8c8cbc4ac21@oracle.com>
Date:   Tue, 24 Mar 2020 21:42:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200325014205.11843-2-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003250038
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=2 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003250038
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/24/20 6:41 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The current CIL size aggregation limit is 1/8th the log size. This
> means for large logs we might be aggregating at least 250MB of dirty objects
> in memory before the CIL is flushed to the journal. With CIL shadow
> buffers sitting around, this means the CIL is often consuming >500MB
> of temporary memory that is all allocated under GFP_NOFS conditions.
> 
> Flushing the CIL can take some time to do if there is other IO
> ongoing, and can introduce substantial log force latency by itself.
> It also pins the memory until the objects are in the AIL and can be
> written back and reclaimed by shrinkers. Hence this threshold also
> tends to determine the minimum amount of memory XFS can operate in
> under heavy modification without triggering the OOM killer.
> 
> Modify the CIL space limit to prevent such huge amounts of pinned
> metadata from aggregating. We can have 2MB of log IO in flight at
> once, so limit aggregation to 16x this size. This threshold was
> chosen as it little impact on performance (on 16-way fsmark) or log
> traffic but pins a lot less memory on large logs especially under
> heavy memory pressure.  An aggregation limit of 8x had 5-10%
> performance degradation and a 50% increase in log throughput for
> the same workload, so clearly that was too small for highly
> concurrent workloads on large logs.
> 
> This was found via trace analysis of AIL behaviour. e.g. insertion
> from a single CIL flush:
> 
> xfs_ail_insert: old lsn 0/0 new lsn 1/3033090 type XFS_LI_INODE flags IN_AIL
> 
> $ grep xfs_ail_insert /mnt/scratch/s.t |grep "new lsn 1/3033090" |wc -l
> 1721823
> $
> 
> So there were 1.7 million objects inserted into the AIL from this
> CIL checkpoint, the first at 2323.392108, the last at 2325.667566 which
> was the end of the trace (i.e. it hadn't finished). Clearly a major
> problem.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Looks ok to me
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_log_priv.h | 29 +++++++++++++++++++++++------
>   1 file changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index cfcf3f02e30a3..8c4be91f62d0d 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -316,13 +316,30 @@ struct xfs_cil {
>    * tries to keep 25% of the log free, so we need to keep below that limit or we
>    * risk running out of free log space to start any new transactions.
>    *
> - * In order to keep background CIL push efficient, we will set a lower
> - * threshold at which background pushing is attempted without blocking current
> - * transaction commits.  A separate, higher bound defines when CIL pushes are
> - * enforced to ensure we stay within our maximum checkpoint size bounds.
> - * threshold, yet give us plenty of space for aggregation on large logs.
> + * In order to keep background CIL push efficient, we only need to ensure the
> + * CIL is large enough to maintain sufficient in-memory relogging to avoid
> + * repeated physical writes of frequently modified metadata. If we allow the CIL
> + * to grow to a substantial fraction of the log, then we may be pinning hundreds
> + * of megabytes of metadata in memory until the CIL flushes. This can cause
> + * issues when we are running low on memory - pinned memory cannot be reclaimed,
> + * and the CIL consumes a lot of memory. Hence we need to set an upper physical
> + * size limit for the CIL that limits the maximum amount of memory pinned by the
> + * CIL but does not limit performance by reducing relogging efficiency
> + * significantly.
> + *
> + * As such, the CIL push threshold ends up being the smaller of two thresholds:
> + * - a threshold large enough that it allows CIL to be pushed and progress to be
> + *   made without excessive blocking of incoming transaction commits. This is
> + *   defined to be 12.5% of the log space - half the 25% push threshold of the
> + *   AIL.
> + * - small enough that it doesn't pin excessive amounts of memory but maintains
> + *   close to peak relogging efficiency. This is defined to be 16x the iclog
> + *   buffer window (32MB) as measurements have shown this to be roughly the
> + *   point of diminishing performance increases under highly concurrent
> + *   modification workloads.
>    */
> -#define XLOG_CIL_SPACE_LIMIT(log)	(log->l_logsize >> 3)
> +#define XLOG_CIL_SPACE_LIMIT(log)	\
> +	min_t(int, (log)->l_logsize >> 3, BBTOB(XLOG_TOTAL_REC_SHIFT(log)) << 4)
>   
>   /*
>    * ticket grant locks, queues and accounting have their own cachlines
> 
