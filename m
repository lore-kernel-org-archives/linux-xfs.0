Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E75357CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 09:39:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A7AF28F8050
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 07:39:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oKWtBoOs5q9GSg8O (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 May 2016 07:39:30 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id D60C510B84F
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 14:39:29 +0000 (UTC)
Received: from redhat.com (unused [10.10.50.219] (may be forged))
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4BEdP2e012451
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Wed, 11 May 2016 10:39:28 -0400
Date: Wed, 11 May 2016 16:39:25 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 7/7] xfs: add "fail at unmount" error handling
	configuration
Message-ID: <20160511143925.GA7828@redhat.com>
References: <1462882581-30859-1-git-send-email-cmaiolino@redhat.com>
	<1462882581-30859-8-git-send-email-cmaiolino@redhat.com>
	<20160511141550.GD42410@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160511141550.GD42410@bfoster.bfoster>
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

On Wed, May 11, 2016 at 10:15:51AM -0400, Brian Foster wrote:
> On Tue, May 10, 2016 at 02:16:21PM +0200, Carlos Maiolino wrote:
> > If we take "retry forever" literally on metadata IO errors, we can
> > hang at unmount, once it retries those writes forever. This is the
> > default behavior, unfortunately.
> > 
> > Add an error configuration option for this behavior and default it to "fail" so
> > that an unmount will trigger actuall errors, a shutdown and allow the unmount to
> > succeed. It will be noisy, though, as it will log the errors and shutdown that
> > occurs.
> > 
> > To fix this, we need to mark the filesystem as being in the process of
> > unmounting. Do this with a mount flag that is added at the appropriate time
> > (i.e. before the blocking AIL sync). We also need to add this flag if mount
> > fails after the initial phase of log recovery has been run.
> > 
> > Changelog:
> > 
> > V3:
> > 	- No major changes have been done to this patch, only the ones needed to
> > 	  accomodate it on top of the remaining patches
> > V4:
> > 	- Make fail_at_unmount a global configuration option into
> > 	  ../xfs/<dev>/error directory
> > 	- Add m_fail_unmount boolean to xfs_mount, to keep track of unmount
> > 	  error behavior
> > 	- Create err_to_mp() helper, to translate a kobject, from m_error_kobj
> > 	  into its xfs_mount
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/xfs_buf_item.c |  4 ++++
> >  fs/xfs/xfs_mount.c    | 12 ++++++++++++
> >  fs/xfs/xfs_mount.h    |  2 ++
> >  fs/xfs/xfs_sysfs.c    | 46 ++++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 64 insertions(+)
> > 
> ...
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index eda3906..1bcee7e 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> ...
> > @@ -1012,6 +1016,14 @@ xfs_unmountfs(
> >  	xfs_log_force(mp, XFS_LOG_SYNC);
> >  
> >  	/*
> > +	 * We now need to tell the world we are unmounting. This will allow
> > +	 * us to detect that the filesystem is going away and we should error
> > +	 * out anything that we have been retrying in the background. This will
> > +	 * prevent neverending retries iin AIL pushing from hanging the unmount.
> 
> Spelling:			       in
> 

Dave, would you be able to fix it or do you want me to re-send this patch again?

> Otherwise looks good:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +	 */
> > +	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
> > +
> > +	/*
> >  	 * Flush all pending changes from the AIL.
> >  	 */
> >  	xfs_ail_push_all_sync(mp->m_ail);
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index 72ec3e3..9063a9c 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -177,6 +177,7 @@ typedef struct xfs_mount {
> >  	 */
> >  	__uint32_t		m_generation;
> >  
> > +	bool			m_fail_unmount;
> >  #ifdef DEBUG
> >  	/*
> >  	 * DEBUG mode instrumentation to test and/or trigger delayed allocation
> > @@ -195,6 +196,7 @@ typedef struct xfs_mount {
> >  #define XFS_MOUNT_WSYNC		(1ULL << 0)	/* for nfs - all metadata ops
> >  						   must be synchronous except
> >  						   for space allocations */
> > +#define XFS_MOUNT_UNMOUNTING	(1ULL << 1)	/* filesystem is unmounting */
> >  #define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
> >  #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
> >  						   operations, typically for
> > diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> > index 084a606..4c2c550 100644
> > --- a/fs/xfs/xfs_sysfs.c
> > +++ b/fs/xfs/xfs_sysfs.c
> > @@ -381,6 +381,13 @@ to_error_cfg(struct kobject *kobject)
> >  	return container_of(kobj, struct xfs_error_cfg, kobj);
> >  }
> >  
> > +static inline struct xfs_mount *
> > +err_to_mp(struct kobject *kobject)
> > +{
> > +	struct xfs_kobj *kobj = to_kobj(kobject);
> > +	return container_of(kobj, struct xfs_mount, m_error_kobj);
> > +}
> > +
> >  static ssize_t
> >  max_retries_show(
> >  	struct kobject	*kobject,
> > @@ -447,6 +454,38 @@ retry_timeout_seconds_store(
> >  }
> >  XFS_SYSFS_ATTR_RW(retry_timeout_seconds);
> >  
> > +static ssize_t
> > +fail_at_unmount_show(
> > +	struct kobject	*kobject,
> > +	char		*buf)
> > +{
> > +	struct xfs_mount	*mp = err_to_mp(kobject);
> > +
> > +	return snprintf(buf, PAGE_SIZE, "%d\n", mp->m_fail_unmount);
> > +}
> > +
> > +static ssize_t
> > +fail_at_unmount_store(
> > +	struct kobject	*kobject,
> > +	const char	*buf,
> > +	size_t		count)
> > +{
> > +	struct xfs_mount	*mp = err_to_mp(kobject);
> > +	int		ret;
> > +	int		val;
> > +
> > +	ret = kstrtoint(buf, 0, &val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (val < 0 || val > 1)
> > +		return -EINVAL;
> > +
> > +	mp->m_fail_unmount = val;
> > +	return count;
> > +}
> > +XFS_SYSFS_ATTR_RW(fail_at_unmount);
> > +
> >  static struct attribute *xfs_error_attrs[] = {
> >  	ATTR_LIST(max_retries),
> >  	ATTR_LIST(retry_timeout_seconds),
> > @@ -462,6 +501,7 @@ struct kobj_type xfs_error_cfg_ktype = {
> >  
> >  struct kobj_type xfs_error_ktype = {
> >  	.release = xfs_sysfs_release,
> > +	.sysfs_ops = &xfs_sysfs_ops,
> >  };
> >  
> >  /*
> > @@ -548,6 +588,12 @@ xfs_error_sysfs_init(
> >  	if (error)
> >  		return error;
> >  
> > +	error = sysfs_create_file(&mp->m_error_kobj.kobject,
> > +				  ATTR_LIST(fail_at_unmount));
> > +
> > +	if (error)
> > +		goto out_error;
> > +
> >  	/* .../xfs/<dev>/error/metadata/ */
> >  	error = xfs_error_sysfs_init_class(mp, XFS_ERR_METADATA,
> >  				"metadata", &mp->m_error_meta_kobj,
> > -- 
> > 2.4.11
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
