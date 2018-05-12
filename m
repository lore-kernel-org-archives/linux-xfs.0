Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52904 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750747AbeELA27 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 20:28:59 -0400
Date: Fri, 11 May 2018 17:28:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: add mount delay debug option
Message-ID: <20180512002856.GN11261@magnolia>
References: <20180511020943.10132-1-david@fromorbit.com>
 <20180511020943.10132-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180511020943.10132-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, May 11, 2018 at 12:09:42PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Similar to log_recovery_delay, this delay occurs between the VFS
> superblock being initialised and the xfs_mount being fully
> initialised. It also poisons the per-ag radix tree node so that it
> can be used for triggering shrinker races during mount
> such as the following:
> 
> <run memory pressure workload in background>
> 
> $ cat dirty-mount.sh
> #! /bin/bash
> 
> umount -f /dev/pmem0
> mkfs.xfs -f /dev/pmem0
> mount /dev/pmem0 /mnt/test
> rm -f /mnt/test/foo
> xfs_io -fxc "pwrite 0 4k" -c fsync -c "shutdown" /mnt/test/foo
> umount /dev/pmem0
> 
> # let's crash it now!
> echo 30 > /sys/fs/xfs/debug/mount_delay
> mount /dev/pmem0 /mnt/test
> echo 0 > /sys/fs/xfs/debug/mount_delay
> umount /dev/pmem0
> $ sudo ./dirty-mount.sh
> .....
> [   60.378118] CPU: 3 PID: 3577 Comm: fs_mark Tainted: G      D W        4.16.0-rc5-dgc #440
> [   60.378120] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
> [   60.378124] RIP: 0010:radix_tree_next_chunk+0x76/0x320
> [   60.378127] RSP: 0018:ffffc9000276f4f8 EFLAGS: 00010282
> [   60.383670] RAX: a5a5a5a5a5a5a5a4 RBX: 0000000000000010 RCX: 000000000000001a
> [   60.385277] RDX: 0000000000000000 RSI: ffffc9000276f540 RDI: 0000000000000000
> [   60.386554] RBP: 0000000000000000 R08: 0000000000000000 R09: a5a5a5a5a5a5a5a5
> [   60.388194] R10: 0000000000000006 R11: 0000000000000001 R12: ffffc9000276f598
> [   60.389288] R13: 0000000000000040 R14: 0000000000000228 R15: ffff880816cd6458
> [   60.390827] FS:  00007f5c124b9740(0000) GS:ffff88083fc00000(0000) knlGS:0000000000000000
> [   60.392253] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   60.393423] CR2: 00007f5c11bba0b8 CR3: 000000035580e001 CR4: 00000000000606e0
> [   60.394519] Call Trace:
> [   60.395252]  radix_tree_gang_lookup_tag+0xc4/0x130
> [   60.395948]  xfs_perag_get_tag+0x37/0xf0
> [   60.396522]  xfs_reclaim_inodes_count+0x32/0x40
> [   60.397178]  xfs_fs_nr_cached_objects+0x11/0x20
> [   60.397837]  super_cache_count+0x35/0xc0
> [   60.399159]  shrink_slab.part.66+0xb1/0x370
> [   60.400194]  shrink_node+0x7e/0x1a0
> [   60.401058]  try_to_free_pages+0x199/0x470
> [   60.402081]  __alloc_pages_slowpath+0x3a1/0xd20
> [   60.403729]  __alloc_pages_nodemask+0x1c3/0x200
> [   60.404941]  cache_grow_begin+0x20b/0x2e0
> [   60.406164]  fallback_alloc+0x160/0x200
> [   60.407088]  kmem_cache_alloc+0x111/0x4e0
> [   60.408038]  ? xfs_buf_rele+0x61/0x430
> [   60.408925]  kmem_zone_alloc+0x61/0xe0
> [   60.409965]  xfs_inode_alloc+0x24/0x1d0
> .....
> 
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks ok, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_globals.c |  1 +
>  fs/xfs/xfs_super.c   | 11 +++++++++++
>  fs/xfs/xfs_sysctl.h  |  1 +
>  fs/xfs/xfs_sysfs.c   | 31 +++++++++++++++++++++++++++++++
>  4 files changed, 44 insertions(+)
> 
> diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
> index 3e1cc3001bcb..fdde17a2333c 100644
> --- a/fs/xfs/xfs_globals.c
> +++ b/fs/xfs/xfs_globals.c
> @@ -47,6 +47,7 @@ xfs_param_t xfs_params = {
>  
>  struct xfs_globals xfs_globals = {
>  	.log_recovery_delay	=	0,	/* no delay by default */
> +	.mount_delay		=	0,	/* no delay by default */
>  #ifdef XFS_ASSERT_FATAL
>  	.bug_on_assert		=	true,	/* assert failures BUG() */
>  #else
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 5726ef496980..a523eaeb3f29 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1635,6 +1635,17 @@ xfs_fs_fill_super(
>  #endif
>  	sb->s_op = &xfs_super_operations;
>  
> +	/*
> +	 * Delay mount work if the debug hook is set. This is debug
> +	 * instrumention to coordinate simulation of xfs mount failures with
> +	 * VFS superblock operations
> +	 */
> +	if (xfs_globals.mount_delay) {
> +		xfs_notice(mp, "Delaying mount for %d seconds.",
> +			xfs_globals.mount_delay);
> +		msleep(xfs_globals.mount_delay * 1000);
> +	}
> +
>  	if (silent)
>  		flags |= XFS_MFSI_QUIET;
>  
> diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
> index 82afee005140..b53a33e69932 100644
> --- a/fs/xfs/xfs_sysctl.h
> +++ b/fs/xfs/xfs_sysctl.h
> @@ -95,6 +95,7 @@ extern xfs_param_t	xfs_params;
>  
>  struct xfs_globals {
>  	int	log_recovery_delay;	/* log recovery delay (secs) */
> +	int	mount_delay;		/* mount setup delay (secs) */
>  	bool	bug_on_assert;		/* BUG() the kernel on assert failure */
>  };
>  extern struct xfs_globals	xfs_globals;
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 8b2ccc234f36..2d5cd2529f8e 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -165,9 +165,40 @@ log_recovery_delay_show(
>  }
>  XFS_SYSFS_ATTR_RW(log_recovery_delay);
>  
> +STATIC ssize_t
> +mount_delay_store(
> +	struct kobject	*kobject,
> +	const char	*buf,
> +	size_t		count)
> +{
> +	int		ret;
> +	int		val;
> +
> +	ret = kstrtoint(buf, 0, &val);
> +	if (ret)
> +		return ret;
> +
> +	if (val < 0 || val > 60)
> +		return -EINVAL;
> +
> +	xfs_globals.mount_delay = val;
> +
> +	return count;
> +}
> +
> +STATIC ssize_t
> +mount_delay_show(
> +	struct kobject	*kobject,
> +	char		*buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.mount_delay);
> +}
> +XFS_SYSFS_ATTR_RW(mount_delay);
> +
>  static struct attribute *xfs_dbg_attrs[] = {
>  	ATTR_LIST(bug_on_assert),
>  	ATTR_LIST(log_recovery_delay),
> +	ATTR_LIST(mount_delay),
>  	NULL,
>  };
>  
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
