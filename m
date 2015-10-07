Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B9D887F37
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:37:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 462A9AC005
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 20:37:53 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id VFsaKXu2SoagXn5P for <xfs@oss.sgi.com>;
	Tue, 06 Oct 2015 20:37:52 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 0652D653B8AC
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:37:51 -0500 (CDT)
Subject: Re: [PATCH 7/7 v11] xfs: per-filesystem stats counter implementation
References: <1443802960-26662-1-git-send-email-billodo@redhat.com>
	<1443802960-26662-8-git-send-email-billodo@redhat.com>
	<20151006213553.GA21334@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5614938F.3020000@sandeen.net>
Date: Tue, 6 Oct 2015 22:37:51 -0500
MIME-Version: 1.0
In-Reply-To: <20151006213553.GA21334@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com



On 10/6/15 4:35 PM, Bill O'Donnell wrote:
> UPDATE:
> -v11: fix errors in dfs_dquot.c functions touching stats counts.
> 
> This patch modifies the stats counting macros and the callers
> to those macros to properly increment, decrement, and add-to
> the xfs stats counts. The counts for global and per-fs stats
> are correctly advanced, and cleared by writing a "1" to the
> corresponding clear file.
> 
> global counts: /sys/fs/xfs/stats/stats
> per-fs counts: /sys/fs/xfs/sda*/stats/stats
> 
> global clear:  /sys/fs/xfs/stats/stats_clear
> per-fs clear:  /sys/fs/xfs/sda*/stats/stats_clear
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---

...

> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> index 54f2260..2ab82c5 100644
> --- a/fs/xfs/xfs_stats.h
> +++ b/fs/xfs/xfs_stats.h
> @@ -218,14 +218,23 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf);
>  void xfs_stats_clearall(struct xfsstats __percpu *stats);
>  extern struct xstats xfsstats;
>  
> -#define XFS_STATS_INC(v)	\
> -	(per_cpu_ptr(xfsstats.xs_stats, current_cpu())->v++)
> +#define XFS_STATS_INC(mp, v)					\
> +do {								\
> +	per_cpu_ptr(xfsstats.xs_stats, current_cpu())->v++;	\
> +	per_cpu_ptr(mp->m_stats.xs_stats, current_cpu())->v++;	\
> +} while (0)
>  
> -#define XFS_STATS_DEC(v)	\
> -	(per_cpu_ptr(xfsstats.xs_stats, current_cpu())->v--)
> +#define XFS_STATS_DEC(mp, v)					\
> +do {								\
> +	per_cpu_ptr(xfsstats.xs_stats, current_cpu())->v--;	\
> +	per_cpu_ptr(mp->m_stats.xs_stats, current_cpu())->v--;	\
> +} while (0)
>  
> -#define XFS_STATS_ADD(v, inc)	\
> -	(per_cpu_ptr(xfsstats.xs_stats, current_cpu())->v += (inc))
> +#define XFS_STATS_ADD(mp, v, inc)					\
> +do {									\
> +	per_cpu_ptr(xfsstats.xs_stats, current_cpu())->v += (inc);	\
> +	per_cpu_ptr(mp->m_stats.xs_stats, current_cpu())->v += (inc);	\
> +} while (0)
>  
>  extern int xfs_init_procfs(void);
>  extern void xfs_cleanup_procfs(void);

One other thing that I just caught looking at the code (not enough context
in the patch to see it) - this is all under #ifdef CONFIG_PROC_FS, and now
that it's all moved to sysfs, we should just remove that conditional from
this file.  The only thing that matters w.r.t. procfs is the symlink
creation, and that's already handled in xfs_init_procfs() definitions.

Dave, maybe you can just fix that on commit ...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
