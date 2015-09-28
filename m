Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9689F7F37
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 10:40:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 83A128F8059
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 08:40:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Z7mE6izjbDBtWaEF for <xfs@oss.sgi.com>;
	Mon, 28 Sep 2015 08:40:39 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 9ED5D70F6B09
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 10:40:39 -0500 (CDT)
Subject: Re: [PATCH 5/7] xfs: incorporate sysfs/kobject in xfsstats: handlers
	take kobjects.
References: <1443223380-18870-1-git-send-email-billodo@redhat.com>
	<1443223380-18870-6-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56095F77.7030403@sandeen.net>
Date: Mon, 28 Sep 2015 10:40:39 -0500
MIME-Version: 1.0
In-Reply-To: <1443223380-18870-6-git-send-email-billodo@redhat.com>
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

On 9/25/15 6:22 PM, Bill O'Donnell wrote:
> This patch is the next step toward per-fs xfs stats. Allocate &
> deallocate per-fs stats structures and set up the sysfs entries for them.
> 
> Instead of a single global xfsstats structure, add kobject and a pointer
> to a per-cpu struct xfsstats. Modify the macros that manipulate the stats
> accordingly: XFS_STATS_INC, XFS_STATS_DEC, and XFS_STATS_ADD now access
> xfsstats->xs_stats.
> 
> The sysfs functions need to get from the kobject back to the xfsstats
> structure which contains it, and pass the pointer to the ->xs_stats
> percpu structure into the show & clear routines.
> 
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>

<snip>

> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 0dfc53b..23e5681 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -61,7 +61,6 @@ static kmem_zone_t *xfs_ioend_zone;
>  mempool_t *xfs_ioend_pool;
>  
>  static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
> -static struct xfs_kobj xfs_stats_kobj;	/* global stats sysfs attrs */
>  #ifdef DEBUG
>  static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
>  #endif
> @@ -1802,6 +1801,7 @@ xfs_destroy_workqueues(void)
>  	destroy_workqueue(xfs_alloc_wq);
>  }
>  
> +
>  STATIC int __init
>  init_xfs_fs(void)
>  {
> @@ -1842,8 +1842,9 @@ init_xfs_fs(void)
>  		goto out_sysctl_unregister;
>  	}
>  
> -	xfs_stats_kobj.kobject.kset = xfs_kset;
> -	error = xfs_sysfs_init(&xfs_stats_kobj, &xfs_stats_ktype, NULL,
> +	xfsstats.xs_stats = alloc_percpu(struct xfsstats);

alloc_percpu can fail, so:

if (!xfsstats.xs_stats) {
	error = -ENOMEM;
	goto out_kset_unregister ...
}

> +	xfsstats.xs_kobj.kobject.kset = xfs_kset;
> +	error = xfs_sysfs_init(&xfsstats.xs_kobj, &xfs_stats_ktype, NULL,
>  			       "stats");
>  	if (error)
>  		goto out_kset_unregister;

If this fails, you need to free the percpu allocation, so this would
be "goto out_free_stats" I think

> @@ -1852,7 +1853,7 @@ init_xfs_fs(void)
>  	xfs_dbg_kobj.kobject.kset = xfs_kset;
>  	error = xfs_sysfs_init(&xfs_dbg_kobj, &xfs_dbg_ktype, NULL, "debug");
>  	if (error)
> -		goto out_remove_stats_kobj;
> +		goto out_remove_stats;

And this remains as out_remove_stats_kobj, I think.

>  #endif
>  
>  	error = xfs_qm_init();
> @@ -1869,9 +1870,9 @@ init_xfs_fs(void)
>   out_remove_dbg_kobj:
>  #ifdef DEBUG
>  	xfs_sysfs_del(&xfs_dbg_kobj);
> - out_remove_stats_kobj:
> + out_remove_stats:
>  #endif
> -	xfs_sysfs_del(&xfs_stats_kobj);
> +	free_percpu(xfsstats.xs_stats);

hm, now nothing deletes the stats kobject?

xfs_sysfs_del(&xfsstats.xs_kobj);

but there should be another goto target ...
there's one more thing to unwind (the percpu allocation) so you should
end up with more unwind goto target (i.e. out_free_stats), but you still
need the unwind target for the stats kobject sysfs deletion.

something like:

out_remove_dbg_kobj:
#ifdef DEBUG
	xfs_sysfs_del(&xfs_dbg_kobj);
out_remove_stats_kobj:
#endif
	xfs_sysfs_del(&xfs_stats_kobj);
out_free_stats:
	free_percpu(xfsstats.xs_stats);
out_kset_unregister:
	kset_unregister(xfs_kset);
out_sysctl_unregister:

but double-check me ;)

>   out_kset_unregister:
>  	kset_unregister(xfs_kset);
>   out_sysctl_unregister:
> @@ -1898,7 +1899,7 @@ exit_xfs_fs(void)
>  #ifdef DEBUG
>  	xfs_sysfs_del(&xfs_dbg_kobj);
>  #endif
> -	xfs_sysfs_del(&xfs_stats_kobj);
> +	free_percpu(xfsstats.xs_stats);


here as well, you still need to delete the stats kobject:

	xfs_sysfs_del(&xfsstats.xs_kobj); 

>  	kset_unregister(xfs_kset);
>  	xfs_sysctl_unregister();
>  	xfs_cleanup_procfs();

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
