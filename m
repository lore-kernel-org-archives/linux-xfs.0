Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 94D7D7F37
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 10:37:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 812388F8054
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 08:37:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zhxEUHk1YAEVo5OW for <xfs@oss.sgi.com>;
	Mon, 28 Sep 2015 08:37:42 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id EFC3C70F6B09
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 10:37:41 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 6/7] xfs: per-filesystem stats in sysfs.
References: <1443223380-18870-1-git-send-email-billodo@redhat.com>
	<1443223380-18870-7-git-send-email-billodo@redhat.com>
Message-ID: <56095EC5.102@sandeen.net>
Date: Mon, 28 Sep 2015 10:37:41 -0500
MIME-Version: 1.0
In-Reply-To: <1443223380-18870-7-git-send-email-billodo@redhat.com>
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
> This patch implements per-filesystem stats objects in sysfs. It
> depends on the application of the previous patch series that
> develops the infrastructure to support both xfs global stats and
> xfs per-fs stats in sysfs.
> 
> Stats objects are instantiated when an xfs filesystem is mounted
> and deleted on unmount. With this patch, the stats directory is
> created and populated with the familiar stats and stats_clear files.
> Example:
>         /sys/fs/xfs/sda9/stats/stats
>         /sys/fs/xfs/sda9/stats/stats_clear
> 
> With this patch, the individual counts within the new per-fs
> stats file(s) remain at zero. Functions that use the the macros
> to increment, decrement, and add-to the per-fs stats counts will
> be covered in a separate new patch to follow this one. Note that
> the counts within the global stats file (/sys/fs/xfs/stats/stats)
> advance normally and can be cleared as it was prior to this patch.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  fs/xfs/xfs_linux.h |  4 ++--
>  fs/xfs/xfs_mount.c | 24 +++++++++++++++++++++++-
>  fs/xfs/xfs_mount.h |  1 +
>  fs/xfs/xfs_stats.c | 34 +++++++++++++++++++---------------
>  fs/xfs/xfs_stats.h |  5 ++++-
>  fs/xfs/xfs_super.c | 21 ++++++++++++++++-----
>  fs/xfs/xfs_sysfs.c |  6 +++---
>  7 files changed, 68 insertions(+), 27 deletions(-)

> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index bf92e0c..5921d18 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -791,11 +791,25 @@ xfs_mountfs(
>  		goto out_free_dir;
>  	}
>  
> +	/*
> +	 * Allocate stats memory and create stats sysfs object.
> +	 */
> +	mp->m_stats.xs_stats = alloc_percpu(struct xfsstats);
> +	if (IS_ERR(mp->m_stats.xs_stats)) {
> +		error = PTR_ERR(mp->m_stats.xs_stats);
> +		goto out_free_perag;
> +	}

alloc_percpu simply returns NULL on failure AFAIK, so looking for IS_ERR
doesn't seem right.

Also, I think the placement of this in the routine is a little odd;
I'd move it up right under where we create the per-fs sysfs entry, i.e.:

        error = xfs_sysfs_init(&mp->m_kobj, &xfs_mp_ktype, NULL, mp->m_fsname);
        if (error)
                goto out;

+	/*
+	 * Allocate stats memory and create stats sysfs object.
+	 */
+	mp->m_stats.xs_stats = alloc_percpu(struct xfsstats);
+	if (!mp->m_stats.xs_stats) {
+		error = -ENOMEM;
+		goto out_free_perag;
+	}

... etc ...

so that all the sysfs gunk is in the same area.


> +	error = xfs_sysfs_init(&mp->m_stats.xs_kobj, &xfs_stats_ktype,
> +				&mp->m_kobj,
> +				"stats");
> +	if (error)
> +		goto out_free_stats;
> +
>  	if (!sbp->sb_logblocks) {
>  		xfs_warn(mp, "no log defined");
>  		XFS_ERROR_REPORT("xfs_mountfs", XFS_ERRLEVEL_LOW, mp);
>  		error = -EFSCORRUPTED;
> -		goto out_free_perag;
> +		goto out_del_stats;
>  	}
>  
>  	/*
> @@ -965,6 +979,10 @@ xfs_mountfs(
>  	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
>  		xfs_wait_buftarg(mp->m_logdev_targp);
>  	xfs_wait_buftarg(mp->m_ddev_targp);
> + out_del_stats:
> +	xfs_sysfs_del(&mp->m_stats.xs_kobj);
> + out_free_stats:
> +	free_percpu(mp->m_stats.xs_stats);
>   out_free_perag:
>  	xfs_free_perag(mp);
>   out_free_dir:
> @@ -1047,6 +1065,10 @@ xfs_unmountfs(
>  		xfs_warn(mp, "Unable to update superblock counters. "
>  				"Freespace may not be correct on next mount.");
>  
> +	/* remove the stats kobject and free stats memory */
> +	xfs_sysfs_del(&mp->m_stats.xs_kobj);
> +	free_percpu(mp->m_stats.xs_stats);
> +
>  	xfs_log_unmount(mp);
>  	xfs_da_unmount(mp);
>  	xfs_uuid_unmount(mp);
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 7999e91..8795272 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -127,6 +127,7 @@ typedef struct xfs_mount {
>  	int64_t			m_low_space[XFS_LOWSP_MAX];
>  						/* low free space thresholds */
>  	struct xfs_kobj		m_kobj;
> +	struct xstats		m_stats;	/* per-fs stats */
>  
>  	struct workqueue_struct *m_buf_workqueue;
>  	struct workqueue_struct	*m_data_workqueue;
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index ab79973..d5b3704 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -18,6 +18,11 @@
>  #include "xfs.h"
>  #include <linux/proc_fs.h>
>  
> +#include "xfs_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_sysfs.h"

AFAICT, none of these includes are needed

...

> @@ -1843,17 +1842,26 @@ init_xfs_fs(void)
>  	}
>  
>  	xfsstats.xs_stats = alloc_percpu(struct xfsstats);
> +	if (!xfsstats.xs_stats) {
> +		error = -ENOMEM;
> +		goto out_kset_unregister;
> +	}

This error checking should be added when xs_stats is introduced
in patch 5.

>  	xfsstats.xs_kobj.kobject.kset = xfs_kset;
> +	if (!xfsstats.xs_kobj.kobject.kset) {
> +		error = -ENOMEM;
> +		goto out_free_stats;
> +	}
> +

this can't fail, you're just assigning one thing to another, no need
for this test.  We already tested for failure to allocate xfs_kset.

>  	error = xfs_sysfs_init(&xfsstats.xs_kobj, &xfs_stats_ktype, NULL,
> -			       "stats");
> +				"stats");

if this is the alignment you want, do it in the patch that introduced it...

>  	if (error)
> -		goto out_kset_unregister;
> +		goto out_free_stats;
>  
>  #ifdef DEBUG
>  	xfs_dbg_kobj.kobject.kset = xfs_kset;
>  	error = xfs_sysfs_init(&xfs_dbg_kobj, &xfs_dbg_ktype, NULL, "debug");
>  	if (error)
> -		goto out_remove_stats;
> +		goto out_del_stats;
>  #endif
>  
>  	error = xfs_qm_init();
> @@ -1870,8 +1878,10 @@ init_xfs_fs(void)
>   out_remove_dbg_kobj:
>  #ifdef DEBUG
>  	xfs_sysfs_del(&xfs_dbg_kobj);
> - out_remove_stats:
> + out_del_stats:

hm, why that name?  If we have:

 out_remove_dbg_kobj:
 	xfs_sysfs_del(&xfs_dbg_kobj);

then we should have:

 out_remove_stats_kobj:
	xfs_sysfs_del(&xfsstats.xs_kobj);

for consistency, I think.


> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> index 672fe83..00afc13 100644
> --- a/fs/xfs/xfs_stats.h
> +++ b/fs/xfs/xfs_stats.h
> @@ -218,13 +218,16 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf);
>  void xfs_stats_clearall(struct xfsstats __percpu *stats);
>  extern struct xstats xfsstats;
>  
> +struct xfs_mount;

I don't think that's needed.

-Eric

> +
>  /*
>   * We don't disable preempt, not too worried about poking the
>   * wrong CPU's stat for now (also aggregated before reporting).
>   */



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
