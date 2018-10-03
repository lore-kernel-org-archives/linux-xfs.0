Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44556 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbeJCWHC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Oct 2018 18:07:02 -0400
Date: Wed, 3 Oct 2018 08:18:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: Fix xqmstats offsets in /proc/fs/xfs/xqmstat
Message-ID: <20181003151808.GG19324@magnolia>
References: <20181003123537.30965-1-cmaiolino@redhat.com>
 <20181003123537.30965-2-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181003123537.30965-2-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 03, 2018 at 02:35:36PM +0200, Carlos Maiolino wrote:
> The addition of FIBT, RMAP and REFCOUNT changed the offsets into
> __xfssats structure.
> 
> Although this didn't cause any direct issue,  xqmstat_proc_show() relied
> on the old offsets to display the xqm statistics.
> 
> Fix it.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_stats.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index 4e4423153071..740ac9674848 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -119,7 +119,7 @@ static int xqmstat_proc_show(struct seq_file *m, void *v)
>  	int j;
>  
>  	seq_printf(m, "qm");
> -	for (j = XFSSTAT_END_IBT_V2; j < XFSSTAT_END_XQMSTAT; j++)
> +	for (j = XFSSTAT_END_REFCOUNT; j < XFSSTAT_END_XQMSTAT; j++)

/me totally missed that when I was writing reflink, sorry. :(

Can we have a:

  #define XFSSTAT_START_XQMSTAT (XFSSTAT_END_REFCOUNT)

in xfs_stats.h right above the XFSSTAT_END_XQMSTAT definition so that
future authors don't have to remember that some code use _END_REFCOUNT
to mean "start of next thing"?

--D

>  		seq_printf(m, " %u", counter_val(xfsstats.xs_stats, j));
>  	seq_putc(m, '\n');
>  	return 0;
> -- 
> 2.17.1
> 
