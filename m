Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4522A7FA8
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 01:29:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AFC61AC005
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 23:29:20 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dmkOD8uYBFeYfn1x for <xfs@oss.sgi.com>;
	Tue, 06 Oct 2015 23:29:17 -0700 (PDT)
Date: Wed, 7 Oct 2015 17:29:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/7] xfs: per-filesystem stats in sysfs.
Message-ID: <20151007062913.GR27164@dastard>
References: <1443802960-26662-1-git-send-email-billodo@redhat.com>
	<1443802960-26662-7-git-send-email-billodo@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1443802960-26662-7-git-send-email-billodo@redhat.com>
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
To: Bill O'Donnell <billodo@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 02, 2015 at 11:22:39AM -0500, Bill O'Donnell wrote:
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

.....

> @@ -1047,6 +1065,10 @@ xfs_unmountfs(
>  		xfs_warn(mp, "Unable to update superblock counters. "
>  				"Freespace may not be correct on next mount.");
>  
> +	/* remove the stats kobject and free stats memory */
> +	xfs_sysfs_del(&mp->m_stats.xs_kobj);
> +	free_percpu(mp->m_stats.xs_stats);
> +
>  	xfs_log_unmount(mp);

Ok, there's an obvious (to me!) problem here. xfs_log_unmount() is
called while there are still active objects in the AIL, which means
there is still AIL operations that need to be done. The AIL
operations have stats in them, so this will result in use-after-free
of the mp->m_stats structure here.

Actually, looking at the alloc side of this patch, we're doing a
XFS_STATS_INC(xb_create) through:

xfs_fs_fill_super
  xfs_readsb
    xfs_buf_read_uncached
      xfs_buf_get_uncached
        _xfs_buf_alloc
	  XFS_STATS_INC(target->bt_mount, xb_create)

at mount time before we've set up mp->m_stats. Ok, so the
initialisation and teardown of the per-mount stats memory is being
done at the wrong layer - it needs to be done in xfs_fs_fill_super()
before we do any IO at all and dropped in xfs_fs_put_super() after
we've torn down all the IO structures. The sysfs object
initialisation is fine where it is, but the actual stats storage is
needed earlier/later than the sysfs object is.

/me now wonders why this doesn't go kaboom at mount time...

Reworked patch is inline below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: per-filesystem stats in sysfs

From: Bill O'Donnell <billodo@redhat.com>

This patch implements per-filesystem stats objects in sysfs. It
depends on the application of the previous patch series that
develops the infrastructure to support both xfs global stats and
xfs per-fs stats in sysfs.

Stats objects are instantiated when an xfs filesystem is mounted
and deleted on unmount. With this patch, the stats directory is
created and populated with the familiar stats and stats_clear files.
Example:
        /sys/fs/xfs/sda9/stats/stats
        /sys/fs/xfs/sda9/stats/stats_clear

With this patch, the individual counts within the new per-fs
stats file(s) remain at zero. Functions that use the the macros
to increment, decrement, and add-to the per-fs stats counts will
be covered in a separate new patch to follow this one. Note that
the counts within the global stats file (/sys/fs/xfs/stats/stats)
advance normally and can be cleared as it was prior to this patch.

[dchinner: move setup/teardown to xfs_fs_{fill|put}_super() so
it is down before/after any path that uses the per-mount stats. ]

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>

---
 fs/xfs/xfs_mount.c | 11 ++++++++++-
 fs/xfs/xfs_mount.h |  1 +
 fs/xfs/xfs_super.c | 14 ++++++++++++--
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bf92e0c..eb498ce 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -693,10 +693,15 @@ xfs_mountfs(
 	if (error)
 		goto out;
 
-	error = xfs_uuid_mount(mp);
+	error = xfs_sysfs_init(&mp->m_stats.xs_kobj, &xfs_stats_ktype,
+			       &mp->m_kobj, "stats");
 	if (error)
 		goto out_remove_sysfs;
 
+	error = xfs_uuid_mount(mp);
+	if (error)
+		goto out_del_stats;
+
 	/*
 	 * Set the minimum read and write sizes
 	 */
@@ -971,6 +976,8 @@ xfs_mountfs(
 	xfs_da_unmount(mp);
  out_remove_uuid:
 	xfs_uuid_unmount(mp);
+ out_del_stats:
+	xfs_sysfs_del(&mp->m_stats.xs_kobj);
  out_remove_sysfs:
 	xfs_sysfs_del(&mp->m_kobj);
  out:
@@ -1047,6 +1054,7 @@ xfs_unmountfs(
 		xfs_warn(mp, "Unable to update superblock counters. "
 				"Freespace may not be correct on next mount.");
 
+
 	xfs_log_unmount(mp);
 	xfs_da_unmount(mp);
 	xfs_uuid_unmount(mp);
@@ -1056,6 +1064,7 @@ xfs_unmountfs(
 #endif
 	xfs_free_perag(mp);
 
+	xfs_sysfs_del(&mp->m_stats.xs_kobj);
 	xfs_sysfs_del(&mp->m_kobj);
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 404bfa5..f20e5de 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -127,6 +127,7 @@ typedef struct xfs_mount {
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
 	struct xfs_kobj		m_kobj;
+	struct xstats		m_stats;	/* per-fs stats */
 
 	struct workqueue_struct *m_buf_workqueue;
 	struct workqueue_struct	*m_data_workqueue;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e1a35a5..9d11d3e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1474,9 +1474,16 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_destroy_workqueues;
 
+	/* Allocate stats memory before we do operations that might use it */
+	mp->m_stats.xs_stats = alloc_percpu(struct xfsstats);
+	if (!mp->m_stats.xs_stats) {
+		error = PTR_ERR(mp->m_stats.xs_stats);
+		goto out_destroy_counters;
+	}
+
 	error = xfs_readsb(mp, flags);
 	if (error)
-		goto out_destroy_counters;
+		goto out_free_stats;
 
 	error = xfs_finish_flags(mp);
 	if (error)
@@ -1545,9 +1552,11 @@ xfs_fs_fill_super(
 	xfs_filestream_unmount(mp);
  out_free_sb:
 	xfs_freesb(mp);
+ out_free_stats:
+	free_percpu(mp->m_stats.xs_stats);
  out_destroy_counters:
 	xfs_destroy_percpu_counters(mp);
-out_destroy_workqueues:
+ out_destroy_workqueues:
 	xfs_destroy_mount_workqueues(mp);
  out_close_devices:
 	xfs_close_devices(mp);
@@ -1574,6 +1583,7 @@ xfs_fs_put_super(
 	xfs_unmountfs(mp);
 
 	xfs_freesb(mp);
+	free_percpu(mp->m_stats.xs_stats);
 	xfs_destroy_percpu_counters(mp);
 	xfs_destroy_mount_workqueues(mp);
 	xfs_close_devices(mp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
