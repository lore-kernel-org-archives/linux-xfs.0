Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 05 Aug 2007 22:56:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l765udbm030668
	for <xfs@oss.sgi.com>; Sun, 5 Aug 2007 22:56:41 -0700
Message-ID: <46B6B88F.1020401@sgi.com>
Date: Mon, 06 Aug 2007 15:58:39 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] dmapi: simplify slab cache creation
References: <20070802212926.GA24834@lst.de>
In-Reply-To: <20070802212926.GA24834@lst.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

It is looking good Christoph,

Regards,
Vlad

Christoph Hellwig wrote:
> Currently two out of three slab caches are created on-demand on
> dmapi_register.  Move them into dmapi_init as the others are to clean up
> all the mess about checking whether dmapi_register has been called
> before or is in the process of beeing called.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: linux-2.6-xfs/fs/dmapi/dmapi_mountinfo.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/dmapi/dmapi_mountinfo.c	2007-08-02 16:00:52.000000000 +0200
> +++ linux-2.6-xfs/fs/dmapi/dmapi_mountinfo.c	2007-08-02 16:07:13.000000000 +0200
> @@ -471,40 +471,7 @@ dmapi_register(
>  	struct filesystem_dmapi_operations *dmapiops)
>  {
>  	dm_vector_map_t *proto;
> -	static int initialized = 0;
>  
> -wait_cache:
> -	spin_lock(&dm_fsys_lock);
> -	if (initialized == -1) {
> -		spin_unlock(&dm_fsys_lock);
> -		goto wait_cache;
> -	}
> -	if (initialized == 0)
> -		initialized = -1;
> -	spin_unlock(&dm_fsys_lock);
> -
> -	if (initialized == -1) {
> -		ASSERT(dm_fsys_map_cachep == NULL);
> -		ASSERT(dm_fsys_vptr_cachep == NULL);
> -
> -		dm_fsys_map_cachep = kmem_cache_create("dm_fsys_map",
> -					sizeof(dm_vector_map_t), 0, 0, NULL, NULL);
> -
> -		dm_fsys_vptr_cachep = kmem_cache_create("dm_fsys_vptr",
> -					sizeof(dm_fsys_vector_t), 0, 0, NULL, NULL);
> -
> -		spin_lock(&dm_fsys_lock);
> -		if ((dm_fsys_map_cachep == NULL) ||
> -		    (dm_fsys_map_cachep == NULL)) {
> -			initialized = 0;
> -			spin_unlock(&dm_fsys_lock);
> -			goto out_cache_free;
> -		}
> -		initialized = 1;
> -		spin_unlock(&dm_fsys_lock);
> -	}
> -
> -	ASSERT_ALWAYS(initialized == 1);
>  	proto = kmem_cache_alloc(dm_fsys_map_cachep, GFP_KERNEL);
>  	if (proto == NULL) {
>  		printk("%s/%d: kmem_cache_alloc(dm_fsys_map_cachep) returned NULL\n", __FUNCTION__, __LINE__);
> @@ -521,21 +488,8 @@ wait_cache:
>  	list_add(&proto->ftype_list, &dm_fsys_map);
>  	ftype_list();
>  	spin_unlock(&dm_fsys_lock);
> -
> -	return;
> -
> -out_cache_free:
> -	if (dm_fsys_map_cachep) {
> -		kmem_cache_destroy(dm_fsys_map_cachep);
> -		dm_fsys_map_cachep = NULL;
> -	}
> -	if (dm_fsys_vptr_cachep) {
> -		kmem_cache_destroy(dm_fsys_vptr_cachep);
> -		dm_fsys_vptr_cachep = NULL;
> -	}
>  }
>  
> -
>  /* Called by a filesystem module that is unloading from the kernel */
>  void
>  dmapi_unregister(
> Index: linux-2.6-xfs/fs/dmapi/dmapi_sysent.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/dmapi/dmapi_sysent.c	2007-08-02 16:03:21.000000000 +0200
> +++ linux-2.6-xfs/fs/dmapi/dmapi_sysent.c	2007-08-02 16:09:46.000000000 +0200
> @@ -740,35 +740,47 @@ int __init dmapi_init(void)
>  	dm_tokdata_cachep = kmem_cache_create("dm_tokdata",
>  				sizeof(struct dm_tokdata), 0, 0, NULL, NULL);
>  	if (dm_tokdata_cachep == NULL)
> -		goto out_cache_free;
> +		goto out;
>  
>  	dm_fsreg_cachep = kmem_cache_create("dm_fsreg",
>  				sizeof(struct dm_fsreg), 0, 0, NULL, NULL);
>  	if (dm_fsreg_cachep == NULL)
> -		goto out_cache_free;
> +		goto out_free_tokdata_cachep;
>  
>  	dm_session_cachep = kmem_cache_create("dm_session",
>  				sizeof(struct dm_session), 0, 0, NULL, NULL);
>  	if (dm_session_cachep == NULL)
> -		goto out_cache_free;
> +		goto out_free_fsreg_cachep;
> +
> +	dm_fsys_map_cachep = kmem_cache_create("dm_fsys_map",
> +				sizeof(dm_vector_map_t), 0, 0, NULL, NULL);
> +	if (dm_fsys_map_cachep == NULL)
> +		goto out_free_session_cachep;
> +	dm_fsys_vptr_cachep = kmem_cache_create("dm_fsys_vptr",
> +				sizeof(dm_fsys_vector_t), 0, 0, NULL, NULL);
> +	if (dm_fsys_vptr_cachep == NULL)
> +		goto out_free_fsys_map_cachep;
>  
>  	ret = misc_register(&dmapi_dev);
> -	if( ret != 0 )
> +	if (ret) {
>  		printk(KERN_ERR "dmapi_init: misc_register returned %d\n", ret);
> +		goto out_free_fsys_vptr_cachep;
> +	}
> +
>  	dmapi_init_procfs(dmapi_dev.minor);
>  	return 0;
>  
> -out_cache_free:
> -	if (dm_tokdata_cachep)
> -		kmem_cache_destroy(dm_tokdata_cachep);
> -	if (dm_fsreg_cachep)
> -		kmem_cache_destroy(dm_fsreg_cachep);
> -	if (dm_session_cachep)
> -		kmem_cache_destroy(dm_session_cachep);
> -	if (dm_fsys_map_cachep)
> -		kmem_cache_destroy(dm_fsys_map_cachep);
> -	if (dm_fsys_vptr_cachep)
> -		kmem_cache_destroy(dm_fsys_vptr_cachep);
> + out_free_fsys_vptr_cachep:
> +	kmem_cache_destroy(dm_fsys_vptr_cachep);
> + out_free_fsys_map_cachep:
> +	kmem_cache_destroy(dm_fsys_map_cachep);
> + out_free_session_cachep:
> +	kmem_cache_destroy(dm_session_cachep);
> + out_free_fsreg_cachep:
> +	kmem_cache_destroy(dm_fsreg_cachep);
> + out_free_tokdata_cachep:
> +	kmem_cache_destroy(dm_tokdata_cachep);
> + out:
>  	return -ENOMEM;
>  }
>  
>
>   
