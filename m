Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36772 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbeJCTkA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Oct 2018 15:40:00 -0400
Subject: Re: [PATCH 2/2] xfs: Add new constant to mark start of xqmstat
References: <20181003123537.30965-1-cmaiolino@redhat.com>
 <20181003123537.30965-3-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <eacf197c-98d7-4507-a40f-cf32d49bb5eb@sandeen.net>
Date: Wed, 3 Oct 2018 07:51:43 -0500
MIME-Version: 1.0
In-Reply-To: <20181003123537.30965-3-cmaiolino@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On 10/3/18 7:35 AM, Carlos Maiolino wrote:
> xqmstat information under __xfsstats is used directly by the
> /proc/fs/xfs/xqmstat show method, which makes use of struct offsets to
> print out the values.
> 
> Currently, the function is setup to start printing values from the offset of
> the last marker before xqmstat, so, an update to __xfsstats structure
> may also require an update of xqmstat_proc_show() function.
> 
> By adding a new constant, we concentrate any updates do __xfsstats
> structure fields locally to the file xfs_stats.h, reducing the
> likelyhood of future bugs if an update to xqmstat_proc_show is
> forgotten as have happened before.

did 

BUILD_BUG_ON(offsetof(struct __xfsstats, xs_qm_dqreclaims)/sizeof(uint32_t)) != XFSSTAT_START_XQMSTAT);

and/or

#define XFSSTAT_START_XQMSTAT	(offsetof(struct __xfsstats, xs_qm_dqreclaims)/sizeof(uint32_t))

not work out?

> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_stats.c | 2 +-
>  fs/xfs/xfs_stats.h | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index 740ac9674848..09121c36a062 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -119,7 +119,7 @@ static int xqmstat_proc_show(struct seq_file *m, void *v)
>  	int j;
>  
>  	seq_printf(m, "qm");
> -	for (j = XFSSTAT_END_REFCOUNT; j < XFSSTAT_END_XQMSTAT; j++)
> +	for (j = XFSSTAT_START_XQMSTAT; j < XFSSTAT_END_XQMSTAT; j++)
>  		seq_printf(m, " %u", counter_val(xfsstats.xs_stats, j));
>  	seq_putc(m, '\n');
>  	return 0;
> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> index 130db070e4d8..102e794addac 100644
> --- a/fs/xfs/xfs_stats.h
> +++ b/fs/xfs/xfs_stats.h
> @@ -147,6 +147,7 @@ struct __xfsstats {
>  	uint32_t		xs_rmap_2[__XBTS_MAX];
>  #define XFSSTAT_END_REFCOUNT		(XFSSTAT_END_RMAP_V2 + __XBTS_MAX)
>  	uint32_t		xs_refcbt_2[__XBTS_MAX];
> +#define XFSSTAT_START_XQMSTAT		XFSSTAT_END_REFCOUNT
>  #define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_REFCOUNT + 6)
>  	uint32_t		xs_qm_dqreclaims;
>  	uint32_t		xs_qm_dqreclaim_misses;
> 
