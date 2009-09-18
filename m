Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8I4rZoO008746 for <xfs@oss.sgi.com>; Thu, 17 Sep 2009 23:53:35 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7FB421688652
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2009 21:54:50 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 8RpZ2K7dUaojYXA3 for
	<xfs@oss.sgi.com>; Thu, 17 Sep 2009 21:54:50 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id E3B50AAE38D
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2009 23:54:49 -0500 (CDT)
Message-ID: <4AB312A3.6000403@sandeen.net>
Date: Thu, 17 Sep 2009 23:54:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: fix record_allocation list manipulation
References: <4AB300CC.5020707@sandeen.net>
In-Reply-To: <4AB300CC.5020707@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> clang found this one too as a "Dead assignment"
> 
> Unless my pointer-fu is totally messed up, this function
> was never actually updating the list head.
> 
> This would mean that the later free_allocations() calls in
> incore_ext_teardown() and free_rt_dup_extent_tree() don't
> actually free more than one item, and therefore leak memory.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> clang record:
> http://sandeen.net/clang/xfsprogs/2009-09-09-1/report-1Jnl15.html#EndPath
> 
> diff --git a/repair/incore.c b/repair/incore.c
> index 84626c9..77f4630 100644
> --- a/repair/incore.c
> +++ b/repair/incore.c
> @@ -33,7 +33,7 @@ void
> record_allocation(ba_rec_t *addr, ba_rec_t *list)
> {
>     addr->next = list;
> -    list = addr;
> +    *list = addr;

argh that's not right, I swear I built it, oops.

Will send an update later.

> 
>     return;
> }
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
