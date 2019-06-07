Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbfFGNVC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jun 2019 09:21:02 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2A24164464
        for <linux-xfs@vger.kernel.org>; Fri,  7 Jun 2019 13:21:02 +0000 (UTC)
Date: Fri, 7 Jun 2019 09:20:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: show build options in sysfs
Message-ID: <20190607132057.GD57123@bfoster>
References: <97e16da4-e5ad-3049-0f6b-c1e24462e035@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97e16da4-e5ad-3049-0f6b-c1e24462e035@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Jun 06, 2019 at 10:30:09PM -0500, Eric Sandeen wrote:
> This adds the "build options" string to a sysfs entry:
> 
> # cat /sys/fs/xfs/features/build_opts 
> ACLs, security attributes, realtime, scrub, no debug
> 
> because right now we only get it in dmesg and scraping dmesg
> is not a great option.
> 
> This is really /build options/, not features as in "on-disk,
> superblock features" like XFS_SB_FEAT_* - putting this under a
> features/ dir will leave the window open open to do supported
> superblock features ala ext4 & f2fs in the future if desired.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> No sure if it would make sense to have i.e.
> 
> /sys/fs/xfs/features/build_options
> /sys/fs/xfs/features/finobt
> /sys/fs/xfs/features/rmapbt
> ...
> 
> all in the same features/ dir ?
> 

What's the purpose of the features dir, and why an entry per feature as
opposed to a single 'features' file like we're adding for build_opts?
Would those per-feature files present any data? The patch seems
reasonable to me in general, but I'd prefer to see the directory
structure thing at least hashed out before we decide on this kind of
placement (as opposed to something like /sys/fs/xfs/build_opts, if that
is possible).

I see that ext4 has a per-file feature dir along these lines:

$ ls /sys/fs/ext4/features/
batched_discard  encryption  lazy_itable_init  meta_bg_resize  metadata_csum_seed
$ cat /sys/fs/ext4/features/*
supported
supported
supported
supported
supported

I'm not sure if those files disappear when a feature is not available or
persist and return something other than "supported?" Are those files
used by anything in userspace?

> Also I didn't test module unload/teardown as I'm testing on xfs root.
> 

insmod/rmmod works on a quick test on one of my VMs.

Brian

> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index a14d11d78bd8..bc0e7fd63567 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -55,9 +55,10 @@
>  static const struct super_operations xfs_super_operations;
>  struct bio_set xfs_ioend_bioset;
>  
> -static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
> +static struct kset *xfs_kset;			/* top-level xfs sysfs dir */
> +static struct xfs_kobj xfs_features_kobj;	/* global features */
>  #ifdef DEBUG
> -static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
> +static struct xfs_kobj xfs_dbg_kobj;		/* global debug sysfs attrs */
>  #endif
>  
>  /*
> @@ -2134,11 +2135,16 @@ init_xfs_fs(void)
>  	if (error)
>  		goto out_free_stats;
>  
> +	xfs_features_kobj.kobject.kset = xfs_kset;
> +	error = xfs_sysfs_init(&xfs_features_kobj, &xfs_features_ktype,
> +				NULL, "features");
> +	if (error)
> +		goto out_remove_stats_kobj;
>  #ifdef DEBUG
>  	xfs_dbg_kobj.kobject.kset = xfs_kset;
>  	error = xfs_sysfs_init(&xfs_dbg_kobj, &xfs_dbg_ktype, NULL, "debug");
>  	if (error)
> -		goto out_remove_stats_kobj;
> +		goto out_remove_features_kobj;
>  #endif
>  
>  	error = xfs_qm_init();
> @@ -2155,8 +2161,10 @@ init_xfs_fs(void)
>   out_remove_dbg_kobj:
>  #ifdef DEBUG
>  	xfs_sysfs_del(&xfs_dbg_kobj);
> - out_remove_stats_kobj:
> + out_remove_features_kobj:
>  #endif
> +	xfs_sysfs_del(&xfs_features_kobj);
> + out_remove_stats_kobj:
>  	xfs_sysfs_del(&xfsstats.xs_kobj);
>   out_free_stats:
>  	free_percpu(xfsstats.xs_stats);
> @@ -2186,6 +2194,7 @@ exit_xfs_fs(void)
>  #ifdef DEBUG
>  	xfs_sysfs_del(&xfs_dbg_kobj);
>  #endif
> +	xfs_sysfs_del(&xfs_features_kobj);
>  	xfs_sysfs_del(&xfsstats.xs_kobj);
>  	free_percpu(xfsstats.xs_stats);
>  	kset_unregister(xfs_kset);
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index cabda13f3c64..98f36ad16237 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -222,6 +222,28 @@ struct kobj_type xfs_dbg_ktype = {
>  
>  #endif /* DEBUG */
>  
> +/* features */
> +
> +STATIC ssize_t
> +build_opts_show(
> +	struct kobject	*kobject,
> +	char		*buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%s\n", XFS_BUILD_OPTIONS);
> +}
> +XFS_SYSFS_ATTR_RO(build_opts);
> +
> +static struct attribute *xfs_features_attrs[] = {
> +	ATTR_LIST(build_opts),
> +	NULL,
> +};
> +
> +struct kobj_type xfs_features_ktype = {
> +	.release = xfs_sysfs_release,
> +	.sysfs_ops = &xfs_sysfs_ops,
> +	.default_attrs = xfs_features_attrs,
> +};
> +
>  /* stats */
>  
>  static inline struct xstats *
> diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
> index e9f810fc6731..e475f6b7eb91 100644
> --- a/fs/xfs/xfs_sysfs.h
> +++ b/fs/xfs/xfs_sysfs.h
> @@ -11,6 +11,7 @@ extern struct kobj_type xfs_mp_ktype;	/* xfs_mount */
>  extern struct kobj_type xfs_dbg_ktype;	/* debug */
>  extern struct kobj_type xfs_log_ktype;	/* xlog */
>  extern struct kobj_type xfs_stats_ktype;	/* stats */
> +extern struct kobj_type xfs_features_ktype;	/* features*/
>  
>  static inline struct xfs_kobj *
>  to_kobj(struct kobject *kobject)
> 
