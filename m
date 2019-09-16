Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 013F0C49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 16:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C54F92184D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 16:33:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="INaRnygc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389987AbfIPQdb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 12:33:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41994 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727950AbfIPQdb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 12:33:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GGE33K116551;
        Mon, 16 Sep 2019 16:33:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=w256vaTjaS/SvlN0tlK/1UviB06Tg6aDpBcJSnjWwug=;
 b=INaRnygcloyiMy8qjfP6Tqu0Ro5+1ap8kTAej6wEscLbLWazskygnbzdG8faep4Oyyjc
 M7YBrJTDLdFUcY/B+BuD1SuSvJ+gPzIX50QYbHJ4WF/C9ADK+H7CS5ePUqmqNErX/i3F
 5OrrWfh6jnG2NJQAFzeLfM6Sl7/Q5AB7xoPj8Nn/pxaZG3YHd5qDj5xjbbjA9zvGShzf
 5RVs/ZlzoXq/lZR85CYOBbfj7psVX2x30vk4SZhoO/3mdSA0EVHPKFhwIvX1FbAUFpNK
 DXD10VONoUrhDQcpSYb7ca9K/6qJ7XnyS9+Ag1FQIsKenWr0OX0vZMm2Y+zbmF5TpuOv jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v0r5p8qxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 16:33:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GGCq8u124497;
        Mon, 16 Sep 2019 16:33:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2v0r1gr6dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 16:33:28 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8GGXQ43019109;
        Mon, 16 Sep 2019 16:33:28 GMT
Received: from localhost (/10.159.225.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Sep 2019 09:33:26 -0700
Date:   Mon, 16 Sep 2019 09:33:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: Lower CIL flush limit for large logs
Message-ID: <20190916163325.GZ2229799@magnolia>
References: <20190909015159.19662-1-david@fromorbit.com>
 <20190909015159.19662-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909015159.19662-2-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909160167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909160167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 09, 2019 at 11:51:58AM +1000, Dave Chinner wrote:
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

It would be nice to capture at least some of this reasoning in the
already lengthy comment preceeding the #define....

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
> ---
>  fs/xfs/xfs_log_priv.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index b880c23cb6e4..187a43ffeaf7 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -329,7 +329,8 @@ struct xfs_cil {
>   * enforced to ensure we stay within our maximum checkpoint size bounds.
>   * threshold, yet give us plenty of space for aggregation on large logs.

...also, does XLOG_CIL_SPACE_LIMIT correspond to "a lower threshold at
which background pushing is attempted", or "a separate, higher bound"?
I think it's the first (????) but ... I don't know.  The name made me
think it was the second, but the single use of the symbol suggests the
first. :)

--D

>   */
> -#define XLOG_CIL_SPACE_LIMIT(log)	(log->l_logsize >> 3)
> +#define XLOG_CIL_SPACE_LIMIT(log)	\
> +	min_t(int, (log)->l_logsize >> 3, BBTOB(XLOG_TOTAL_REC_SHIFT(log)) << 4)
>  
>  /*
>   * ticket grant locks, queues and accounting have their own cachlines
> -- 
> 2.23.0.rc1
> 
