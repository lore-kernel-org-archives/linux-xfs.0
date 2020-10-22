Return-Path: <SRS0=jqsF=D5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10409C388F7
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 06:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F8222245F
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 06:11:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kqk6zocO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503354AbgJVGLE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 02:11:04 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:41460 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437316AbgJVGLD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Oct 2020 02:11:03 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M68uNi049039;
        Thu, 22 Oct 2020 06:11:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=dQ8oZb2DItrYI55ShlKQ5fpPI532xNIpvspnte16NFM=;
 b=Kqk6zocOMqTh42Dx48lD/56ApomUKd7Z+LFytCY56654Mcv2R4+XAYYcbkNCyq6HCen3
 5sl3ZP/uPDVfj50IvluzVDT+Bcv5krOIKTtPNNj88N6LuoRo1JWTlWGIuvYUccNNWIBb
 3G78YBJVHgLboSDw5rvBvkxioTwkAhAwMaZXx3Yp+ixTQrTRe1lsoRw5EWW5qiXT0y+a
 0+DQmsV5G8yM10haDq1/90s0JcmEYmg8oSRB0H7UrObrvVu13aQ9w0MxHIVt2074ufjb
 1GWGtF2bdprBUg2qCuQIJkKn9RkOkE2wMW2eZq1Yhccdjr+mJDTchQDbmUaIedICEDXT dA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 347p4b448c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 06:11:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M65gPK124993;
        Thu, 22 Oct 2020 06:11:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 348ah0fgks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 06:11:02 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09M6B1xG017830;
        Thu, 22 Oct 2020 06:11:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 23:11:01 -0700
Date:   Wed, 21 Oct 2020 23:11:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] repair: parallelise phase 6
Message-ID: <20201022061100.GP9832@magnolia>
References: <20201022051537.2286402-1-david@fromorbit.com>
 <20201022051537.2286402-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022051537.2286402-5-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=5 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220041
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 22, 2020 at 04:15:34PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> A recent metadump provided to us caused repair to take hours in
> phase6. It wasn't IO bound - it was fully CPU bound the entire time.
> The only way to speed it up is to make phase 6 run multiple
> concurrent processing threads.
> 
> The obvious way to do this is to spread the concurrency across AGs,
> like the other phases, and while this works it is not optimal. When
> a processing thread hits a really large directory, it essentially
> sits CPU bound until that directory is processed. IF an AG has lots
> of large directories, we end up with a really long single threaded
> tail that limits concurrency.
> 
> Hence we also need to have concurrency /within/ the AG. This is
> realtively easy, as the inode chunk records allow for a simple
> concurrency mechanism within an AG. We can simply feed each chunk
> record to a workqueue, and we get concurrency within the AG for
> free. However, this allows prefetch to run way ahead of processing
> and this blows out the buffer cache size and can cause OOM.
> 
> However, we can use the new workqueue depth limiting to limit the
> number of inode chunks queued, and this then backs up the inode
> prefetching to it's maximum queue depth.

I'm interested in (some day) hooking up xfs_scrub to max_queued, since
it has the same concurrency problem when one of the AGs has a number of
hugely fragmented files.

> Hence we prevent having the
> prefetch code queue the entire AG's inode chunks on the workqueue
> blowing out memory by throttling the prefetch consumer.
> 
> This takes phase 6 from taking many, many hours down to:
> 
> Phase 6:        10/30 21:12:58  10/30 21:40:48  27 minutes, 50 seconds
> 
> And burning 20-30 cpus that entire time on my test rig.

Yay!

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  repair/phase6.c | 43 +++++++++++++++++++++++++++++++++++--------
>  1 file changed, 35 insertions(+), 8 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 70d32089bb57..bf0719c186fb 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -6,6 +6,7 @@
>  
>  #include "libxfs.h"
>  #include "threads.h"
> +#include "threads.h"
>  #include "prefetch.h"
>  #include "avl.h"
>  #include "globals.h"
> @@ -3109,20 +3110,45 @@ check_for_orphaned_inodes(
>  }
>  
>  static void
> -traverse_function(
> +do_dir_inode(
>  	struct workqueue	*wq,
> -	xfs_agnumber_t 		agno,
> +	xfs_agnumber_t		agno,
>  	void			*arg)
>  {
> -	ino_tree_node_t 	*irec;
> +	struct ino_tree_node	*irec = arg;
>  	int			i;
> +
> +	for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
> +		if (inode_isadir(irec, i))
> +			process_dir_inode(wq->wq_ctx, agno, irec, i);
> +	}
> +}
> +
> +static void
> +traverse_function(
> +	struct workqueue	*wq,
> +	xfs_agnumber_t		agno,
> +	void			*arg)
> +{
> +	struct ino_tree_node	*irec;
>  	prefetch_args_t		*pf_args = arg;
> +	struct workqueue	lwq;
> +	struct xfs_mount	*mp = wq->wq_ctx;
> +
>  
>  	wait_for_inode_prefetch(pf_args);
>  
>  	if (verbose)
>  		do_log(_("        - agno = %d\n"), agno);
>  
> +	/*
> +	 * The more AGs we have in flight at once, the fewer processing threads
> +	 * per AG. This means we don't overwhelm the machine with hundreds of
> +	 * threads when we start acting on lots of AGs at once. We just want
> +	 * enough that we can keep multiple CPUs busy across multiple AGs.
> +	 */
> +	workqueue_create_bound(&lwq, mp, ag_stride, 1000);

Eeeeee, magic number! :)

/me tosses in obligatory hand-wringing about 2000 CPU systems running
out of work.  How about ag_stride * 50 or something? :P

(Aside from that this all looks ok to me)

--D

> +
>  	for (irec = findfirst_inode_rec(agno); irec; irec = next_ino_rec(irec)) {
>  		if (irec->ino_isa_dir == 0)
>  			continue;
> @@ -3130,18 +3156,19 @@ traverse_function(
>  		if (pf_args) {
>  			sem_post(&pf_args->ra_count);
>  #ifdef XR_PF_TRACE
> +			{
> +			int	i;
>  			sem_getvalue(&pf_args->ra_count, &i);
>  			pftrace(
>  		"processing inode chunk %p in AG %d (sem count = %d)",
>  				irec, agno, i);
> +			}
>  #endif
>  		}
>  
> -		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
> -			if (inode_isadir(irec, i))
> -				process_dir_inode(wq->wq_ctx, agno, irec, i);
> -		}
> +		queue_work(&lwq, do_dir_inode, agno, irec);
>  	}
> +	destroy_work_queue(&lwq);
>  	cleanup_inode_prefetch(pf_args);
>  }
>  
> @@ -3169,7 +3196,7 @@ static void
>  traverse_ags(
>  	struct xfs_mount	*mp)
>  {
> -	do_inode_prefetch(mp, 0, traverse_function, false, true);
> +	do_inode_prefetch(mp, ag_stride, traverse_function, false, true);
>  }
>  
>  void
> -- 
> 2.28.0
> 
