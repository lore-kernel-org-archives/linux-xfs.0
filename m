Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5ED7C7F37
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 06:49:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 406D58F8052
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 04:49:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JIbDRCcCGDtZCrUz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 09 Sep 2015 04:49:18 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 79E0F91DAC
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 11:49:17 +0000 (UTC)
Date: Wed, 9 Sep 2015 07:49:16 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: simplify /proc teardown & error handling
Message-ID: <20150909114915.GB30015@bfoster.bfoster>
References: <55EF3BAE.5010904@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55EF3BAE.5010904@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Sep 08, 2015 at 02:49:02PM -0500, Eric Sandeen wrote:
> remove_proc_subtree() was added in 3.9, and can be
> used to simplify our procfile creation error handling
> and cleanup, removing the nested gotos.  It simply
> removes fs/xfs and everything created under it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> This goes after Bill's patches, I just noticed it
> while reviewing them.
> 
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index 05d5227..009a860 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -168,41 +168,29 @@ int
>  xfs_init_procfs(void)
>  {
>  	if (!proc_mkdir("fs/xfs", NULL))
> -		goto out;
> +		return -ENOMEM;
>  
>  	if (!proc_symlink("fs/xfs/stat", NULL,
>  			  "/sys/fs/xfs/stats/stats"))
> -		goto out_remove_xfs_dir;
> +		goto out;
>  
>  #ifdef CONFIG_XFS_QUOTA
>  	if (!proc_create("fs/xfs/xqmstat", 0, NULL,
>  			 &xqmstat_proc_fops))
> -		goto out_remove_stat_file;
> +		goto out;
>  	if (!proc_create("fs/xfs/xqm", 0, NULL,
>  			 &xqm_proc_fops))
> -		goto out_remove_xqmstat_file;
> +		goto out;
>  #endif
>  	return 0;
>  
> -#ifdef CONFIG_XFS_QUOTA
> - out_remove_xqmstat_file:
> -	remove_proc_entry("fs/xfs/xqmstat", NULL);
> - out_remove_stat_file:
> -	remove_proc_entry("fs/xfs/stat", NULL);
> -#endif
> - out_remove_xfs_dir:
> -	remove_proc_entry("fs/xfs", NULL);
> - out:
> +out:
> +	remove_proc_subtree("fs/xfs", NULL);
>  	return -ENOMEM;
>  }
>  
>  void
>  xfs_cleanup_procfs(void)
>  {
> -#ifdef CONFIG_XFS_QUOTA
> -	remove_proc_entry("fs/xfs/xqm", NULL);
> -	remove_proc_entry("fs/xfs/xqmstat", NULL);
> -#endif
> -	remove_proc_entry("fs/xfs/stat", NULL);
> -	remove_proc_entry("fs/xfs", NULL);
> +	remove_proc_subtree("fs/xfs", NULL);
>  }
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
