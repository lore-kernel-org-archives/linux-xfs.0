Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36874 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753805AbeCFXjr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Mar 2018 18:39:47 -0500
Date: Tue, 6 Mar 2018 15:39:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/5 V2] libxfs: Catch non-empty zones on destroy
Message-ID: <20180306233939.GS18989@magnolia>
References: <d81cf576-6082-008b-761e-82c487e6a87a@redhat.com>
 <c2dd15a8-a048-6373-2fad-3ffd28a606e0@sandeen.net>
 <7fe7fc2a-8ed6-80d7-0727-0093b19f3164@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fe7fc2a-8ed6-80d7-0727-0093b19f3164@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Mar 06, 2018 at 05:37:06PM -0600, Eric Sandeen wrote:
> Create and use a kmem_zone_destroy which warns if we are
> releasing a non-empty zone when the LIBXFS_LEAK_CHECK
> environment variable is set, wire this into libxfs_destroy(),
> and call that when various tools exit.
> 
> The LIBXFS_LEAK_CHECK environment variable also causes
> the program to exit with failure when a leak is detected,
> useful for failing automated tests if leaks are encountered.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> v2 fprintf, stderr
> 
>  include/kmem.h |  1 +
>  libxfs/init.c  | 36 +++++++++++++++++++++++-------------
>  libxfs/kmem.c  | 14 ++++++++++++++
>  3 files changed, 38 insertions(+), 13 deletions(-)
> 
> 
> 
> diff --git a/include/kmem.h b/include/kmem.h
> index 65f0ade..572a4fa 100644
> --- a/include/kmem.h
> +++ b/include/kmem.h
> @@ -33,6 +33,7 @@ typedef struct kmem_zone {
>  extern kmem_zone_t *kmem_zone_init(int, char *);
>  extern void	*kmem_zone_alloc(kmem_zone_t *, int);
>  extern void	*kmem_zone_zalloc(kmem_zone_t *, int);
> +extern int	kmem_zone_destroy(kmem_zone_t *);
>  
>  static inline void
>  kmem_zone_free(kmem_zone_t *zone, void *ptr)
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 3456cb5..a65c86c 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -43,7 +43,7 @@ int libxfs_bhash_size;		/* #buckets in bcache */
>  
>  int	use_xfs_buf_lock;	/* global flag: use xfs_buf_t locks for MT */
>  
> -static void manage_zones(int);	/* setup global zones */
> +static int manage_zones(int);	/* setup/teardown global zones */
>  
>  /*
>   * dev_map - map open devices to fd.
> @@ -372,7 +372,7 @@ done:
>  /*
>   * Initialize/destroy all of the zone allocators we use.
>   */
> -static void
> +static int
>  manage_zones(int release)
>  {
>  	extern kmem_zone_t	*xfs_buf_zone;
> @@ -388,16 +388,20 @@ manage_zones(int release)
>  	extern void		xfs_dir_startup();
>  
>  	if (release) {	/* free zone allocation */
> -		kmem_free(xfs_buf_zone);
> -		kmem_free(xfs_inode_zone);
> -		kmem_free(xfs_ifork_zone);
> -		kmem_free(xfs_buf_item_zone);
> -		kmem_free(xfs_da_state_zone);
> -		kmem_free(xfs_btree_cur_zone);
> -		kmem_free(xfs_bmap_free_item_zone);
> -		kmem_free(xfs_trans_zone);
> -		kmem_free(xfs_log_item_desc_zone);
> -		return;
> +		int	leaked = 0;
> +
> +		leaked += kmem_zone_destroy(xfs_buf_zone);
> +		leaked += kmem_zone_destroy(xfs_ili_zone);
> +		leaked += kmem_zone_destroy(xfs_inode_zone);
> +		leaked += kmem_zone_destroy(xfs_ifork_zone);
> +		leaked += kmem_zone_destroy(xfs_buf_item_zone);
> +		leaked += kmem_zone_destroy(xfs_da_state_zone);
> +		leaked += kmem_zone_destroy(xfs_btree_cur_zone);
> +		leaked += kmem_zone_destroy(xfs_bmap_free_item_zone);
> +		leaked += kmem_zone_destroy(xfs_trans_zone);
> +		leaked += kmem_zone_destroy(xfs_log_item_desc_zone);
> +
> +		return leaked;
>  	}
>  	/* otherwise initialise zone allocation */
>  	xfs_buf_zone = kmem_zone_init(sizeof(xfs_buf_t), "xfs_buffer");
> @@ -419,6 +423,8 @@ manage_zones(int release)
>  	xfs_log_item_desc_zone = kmem_zone_init(
>  			sizeof(struct xfs_log_item_desc), "xfs_log_item_desc");
>  	xfs_dir_startup();
> +
> +	return 0;
>  }
>  
>  /*
> @@ -887,11 +893,15 @@ libxfs_umount(xfs_mount_t *mp)
>  void
>  libxfs_destroy(void)
>  {
> +	int	leaked;
> +
>  	/* Free everything from the buffer cache before freeing buffer zone */
>  	libxfs_bcache_purge();
>  	libxfs_bcache_free();
>  	cache_destroy(libxfs_bcache);
> -	manage_zones(1);
> +	leaked = manage_zones(1);
> +	if (getenv("LIBXFS_LEAK_CHECK") && leaked)
> +		exit(1);
>  }
>  
>  int
> diff --git a/libxfs/kmem.c b/libxfs/kmem.c
> index c8bcb50..256db94 100644
> --- a/libxfs/kmem.c
> +++ b/libxfs/kmem.c
> @@ -23,6 +23,20 @@ kmem_zone_init(int size, char *name)
>  	return ptr;
>  }
>  
> +int
> +kmem_zone_destroy(kmem_zone_t *zone)
> +{
> +	int	leaked = 0;
> +
> +	if (getenv("LIBXFS_LEAK_CHECK") && zone->allocated) {
> +		leaked = 1;
> +		fprintf(stderr, "zone %s freed with %d items allocated\n",
> +				zone->zone_name, zone->allocated);
> +	}
> +	free(zone);
> +	return leaked;
> +}
> +
>  void *
>  kmem_zone_alloc(kmem_zone_t *zone, int flags)
>  {
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
