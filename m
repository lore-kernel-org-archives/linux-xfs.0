Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D097DC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 22:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A98D7204EA
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 22:48:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nph26Ruy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731175AbgEVWsL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 18:48:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52852 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731029AbgEVWsL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 18:48:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMlwvf073004;
        Fri, 22 May 2020 22:48:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=V+ft6aSNFrc1GUnMEHcVTafEQf6g7NMoGx1N19JaZGs=;
 b=Nph26RuywUFdT1H+qciP2ThXx/d37J/j9jUZa/eFEp+MMpWDaFJr6e9joXP5e6rfx7wr
 eN6oouJWSsnn3uXGDiPks2Lbd2W7R847fO1clNspNZaAQlFgjPhpPcM126GE1uZSAX+c
 /IKxMEIoW/wadh1l9bWoQBsFuX7oCUt0Y4G4OFX+1prA4WmJeRQBMltCPm+Ufl0CILzB
 j4gUN4a+R96I7cycvXvvGqS1nId7uwoDYA3jQkyIq5/VAhkZhceX7t0DxFi1ay6MHvlt
 P4fMsYZfgG0LNRoOvPOIqwrVEyo0UDhZGHXwVxXb7XP5i1KwAkrcM5GzMHYfznOEyJCa Fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 316qrvr0ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 22:48:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMgbAL183808;
        Fri, 22 May 2020 22:48:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 314gmbx81f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 22:48:08 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04MMm7hx022120;
        Fri, 22 May 2020 22:48:07 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 15:48:07 -0700
Date:   Fri, 22 May 2020 15:48:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/24] xfs: make inode reclaim almost non-blocking
Message-ID: <20200522224806.GQ8230@magnolia>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-14-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-14-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=5
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 cotscore=-2147483648 suspectscore=5 adultscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220178
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:18PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that dirty inode writeback doesn't cause read-modify-write
> cycles on the inode cluster buffer under memory pressure, the need
> to throttle memory reclaim to the rate at which we can clean dirty
> inodes goes away. That is due to the fact that we no longer thrash
> inode cluster buffers under memory pressure to clean dirty inodes.
> 
> This means inode writeback no longer stalls on memory allocation
> or read IO, and hence can be done asynchrnously without generating

"...asynchronously..."

> memory pressure. As a result, blocking inode writeback in reclaim is
> no longer necessary to prevent reclaim priority windup as cleaning
> dirty inodes is no longer dependent on having memory reserves
> available for the filesystem to make progress reclaiming inodes.
> 
> Hence we can convert inode reclaim to be non-blocking for shrinker
> callouts, both for direct reclaim and kswapd.
> 
> On a vanilla kernel, running a 16-way fsmark create workload on a
> 4 node/16p/16GB RAM machine, I can reliably pin 14.75GB of RAM via
> userspace mlock(). The OOM killer gets invoked at 15GB of
> pinned RAM.
> 
> With this patch alone, pinning memory triggers premature OOM
> killer invocation, sometimes with as much as 45% of RAM being free.
> It's trivially easy to trigger the OOM killer when reclaim does not
> block.
> 
> With pinning inode clusters in RAM adn then adding this patch, I can
> reliably pin 14.5GB of RAM and still have the fsmark workload run to
> completion. The OOM killer gets invoked 14.75GB of pinned RAM, which
> is only a small amount of memory less than the vanilla kernel. It is
> much more reliable than just with async reclaim alone.

So the lack of OOM kills is the result of not having to do RMW and
ratcheting up the reclaim priority, right?

And, {con|per}versely, can I run fstests with 400MB of RAM now? :D

> simoops shows that allocation stalls go away when async reclaim is
> used. Vanilla kernel:
> 
> Run time: 1924 seconds
> Read latency (p50: 3,305,472) (p95: 3,723,264) (p99: 4,001,792)
> Write latency (p50: 184,064) (p95: 553,984) (p99: 807,936)
> Allocation latency (p50: 2,641,920) (p95: 3,911,680) (p99: 4,464,640)
> work rate = 13.45/sec (avg 13.44/sec) (p50: 13.46) (p95: 13.58) (p99: 13.70)
> alloc stall rate = 3.80/sec (avg: 2.59) (p50: 2.54) (p95: 2.96) (p99: 3.02)
> 
> With inode cluster pinning and async reclaim:
> 
> Run time: 1924 seconds
> Read latency (p50: 3,305,472) (p95: 3,715,072) (p99: 3,977,216)
> Write latency (p50: 187,648) (p95: 553,984) (p99: 789,504)
> Allocation latency (p50: 2,748,416) (p95: 3,919,872) (p99: 4,448,256)

I'm not familiar with simoops, and ElGoog is not helpful.  What are the
units here?

> work rate = 13.28/sec (avg 13.32/sec) (p50: 13.26) (p95: 13.34) (p99: 13.34)
> alloc stall rate = 0.02/sec (avg: 0.02) (p50: 0.01) (p95: 0.03) (p99: 0.03)
> 
> Latencies don't really change much, nor does the work rate. However,
> allocation almost never stalls with these changes, whilst the
> vanilla kernel is sometimes reporting 20 stalls/s over a 60s sample
> period. This difference is due to inode reclaim being largely
> non-blocking now.

<nod>

> IOWs, once we have pinned inode cluster buffers, we can make inode
> reclaim non-blocking without a major risk of premature and/or
> spurious OOM killer invocation, and without any changes to memory
> reclaim infrastructure.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok to me, provided my suppositions are correct...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_icache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index d806d3bfa8936..0f0f8fcd61b03 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1420,7 +1420,7 @@ xfs_reclaim_inodes_nr(
>  	xfs_reclaim_work_queue(mp);
>  	xfs_ail_push_all(mp->m_ail);
>  
> -	return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK | SYNC_WAIT, &nr_to_scan);
> +	return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
>  }
>  
>  /*
> -- 
> 2.26.2.761.g0e0b3e54be
> 
