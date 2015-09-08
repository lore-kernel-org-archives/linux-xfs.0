Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 57D1F7F37
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2015 11:23:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D0B74AC001
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2015 09:23:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sJzWH7UnCIBCESwr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 08 Sep 2015 09:23:03 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 678F4461D2
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2015 16:23:02 +0000 (UTC)
Date: Tue, 8 Sep 2015 12:23:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4] xfs: consolidate sysfs ops (dbg, stats, log)
Message-ID: <20150908162300.GC5305@bfoster.bfoster>
References: <1441724972-7086-1-git-send-email-billodo@redhat.com>
	<1441724972-7086-5-git-send-email-billodo@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1441724972-7086-5-git-send-email-billodo@redhat.com>
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

On Tue, Sep 08, 2015 at 10:09:32AM -0500, Bill O'Donnell wrote:
>     As a part of the series to move xfs global stats from procfs to sysfs,
>     this patch consolidates the sysfs ops functions and removes redundancy.
> 
>     Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  fs/xfs/xfs_stats.c |   2 +-
>  fs/xfs/xfs_sysfs.c | 147 ++++++++++++++++++-----------------------------------
>  2 files changed, 51 insertions(+), 98 deletions(-)
> 
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index 05d5227..dc6ca67 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -92,7 +92,7 @@ int xfs_stats_format(char *buf)
>  		0);
>  #endif
>  
> -return len;
> +	return len;

Looks like this snuck in from a fix to a previous patch.

>  }
>  
>  void xfs_stats_clearall(void)
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index a094e20..6c44e95 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -54,6 +54,53 @@ struct kobj_type xfs_mp_ktype = {
>  	.release = xfs_sysfs_release,
>  };
>  
> +static inline struct xlog *
> +to_xlog(struct kobject *kobject)
> +{
> +	struct xfs_kobj *kobj = to_kobj(kobject);
> +	return container_of(kobj, struct xlog, l_kobj);
> +}
> +
> +STATIC ssize_t
> +xfs_sysfs_object_show(
> +	struct kobject		*kobject,
> +	struct attribute	*attr,
> +	char			*buf)
> +{
> +	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
> +	struct kobj_type *ktype = get_ktype(kobject);
> +
> +	if (ktype == &xfs_log_ktype) {
> +		struct xlog *log = to_xlog(kobject);
> +		return xfs_attr->show ? xfs_attr->show(buf, log) : 0;
> +	}
> +	else
> +		return xfs_attr->show ? xfs_attr->show(buf, NULL) : 0;

Could we just set a void pointer to the object and not duplicate the
function call? The attribute handler parameter is a void * anyways.
E.g.:

	void *data = NULL;
	...
	if (...)
		data = to_xlog(kobject);
	return xfs_attr->show ? xfs_attr->show(buf, data) : 0;

(and in the store path as well). Otherwise, looks like a nice cleanup to
me.

Brian

P.S., It's good practice to include a brief, but running changelog in
the cover letter to call out precisely what changed from the previous
version(s) to help out reviewers. For example:

v4:
- Fixed up whitespace in patch N.
- Added patch 4.
...
v3:
...


> +}
> +
> +STATIC ssize_t
> +xfs_sysfs_object_store(
> +	struct kobject		*kobject,
> +	struct attribute	*attr,
> +	const char		*buf,
> +	size_t			count)
> +{
> +	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
> +	struct kobj_type *ktype = get_ktype(kobject);
> +
> +	if (ktype == &xfs_log_ktype) {
> +		struct xlog *log = to_xlog(kobject);
> +		return xfs_attr->store ? xfs_attr->store(buf, count, log) : 0;
> +	}
> +	else
> +		return xfs_attr->store ? xfs_attr->store(buf, count, NULL) : 0;
> +}
> +
> +static struct sysfs_ops xfs_sysfs_ops = {
> +	.show = xfs_sysfs_object_show,
> +	.store = xfs_sysfs_object_store,
> +};
> +
>  #ifdef DEBUG
>  /* debug */
>  
> @@ -92,43 +139,14 @@ static struct attribute *xfs_dbg_attrs[] = {
>  	NULL,
>  };
>  
> -STATIC ssize_t
> -xfs_dbg_show(
> -	struct kobject		*kobject,
> -	struct attribute	*attr,
> -	char			*buf)
> -{
> -	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
> -
> -	return xfs_attr->show ? xfs_attr->show(buf, NULL) : 0;
> -}
> -
> -STATIC ssize_t
> -xfs_dbg_store(
> -	struct kobject		*kobject,
> -	struct attribute	*attr,
> -	const char		*buf,
> -	size_t			count)
> -{
> -	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
> -
> -	return xfs_attr->store ? xfs_attr->store(buf, count, NULL) : 0;
> -}
> -
> -static struct sysfs_ops xfs_dbg_ops = {
> -	.show = xfs_dbg_show,
> -	.store = xfs_dbg_store,
> -};
> -
>  struct kobj_type xfs_dbg_ktype = {
>  	.release = xfs_sysfs_release,
> -	.sysfs_ops = &xfs_dbg_ops,
> +	.sysfs_ops = &xfs_sysfs_ops,
>  	.default_attrs = xfs_dbg_attrs,
>  };
>  
>  #endif /* DEBUG */
>  
> -
>  /* stats */
>  
>  STATIC ssize_t
> @@ -166,37 +184,9 @@ static struct attribute *xfs_stats_attrs[] = {
>  	NULL,
>  };
>  
> -STATIC ssize_t
> -xfs_stats_show(
> -	struct kobject		*kobject,
> -	struct attribute	*attr,
> -	char			*buf)
> -{
> -	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
> -
> -	return xfs_attr->show ? xfs_attr->show(buf, NULL) : 0;
> -}
> -
> -STATIC ssize_t
> -xfs_stats_store(
> -	struct kobject		*kobject,
> -	struct attribute	*attr,
> -	const char		*buf,
> -	size_t			count)
> -{
> -	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
> -
> -	return xfs_attr->store ? xfs_attr->store(buf, count, NULL) : 0;
> -}
> -
> -static struct sysfs_ops xfs_stats_ops = {
> -	.show = xfs_stats_show,
> -	.store = xfs_stats_store,
> -};
> -
>  struct kobj_type xfs_stats_ktype = {
>  	.release = xfs_sysfs_release,
> -	.sysfs_ops = &xfs_stats_ops,
> +	.sysfs_ops = &xfs_sysfs_ops,
>  	.default_attrs = xfs_stats_attrs,
>  };
>  
> @@ -270,45 +260,8 @@ static struct attribute *xfs_log_attrs[] = {
>  	NULL,
>  };
>  
> -static inline struct xlog *
> -to_xlog(struct kobject *kobject)
> -{
> -	struct xfs_kobj *kobj = to_kobj(kobject);
> -	return container_of(kobj, struct xlog, l_kobj);
> -}
> -
> -STATIC ssize_t
> -xfs_log_show(
> -	struct kobject		*kobject,
> -	struct attribute	*attr,
> -	char			*buf)
> -{
> -	struct xlog *log = to_xlog(kobject);
> -	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
> -
> -	return xfs_attr->show ? xfs_attr->show(buf, log) : 0;
> -}
> -
> -STATIC ssize_t
> -xfs_log_store(
> -	struct kobject		*kobject,
> -	struct attribute	*attr,
> -	const char		*buf,
> -	size_t			count)
> -{
> -	struct xlog *log = to_xlog(kobject);
> -	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
> -
> -	return xfs_attr->store ? xfs_attr->store(buf, count, log) : 0;
> -}
> -
> -static struct sysfs_ops xfs_log_ops = {
> -	.show = xfs_log_show,
> -	.store = xfs_log_store,
> -};
> -
>  struct kobj_type xfs_log_ktype = {
>  	.release = xfs_sysfs_release,
> -	.sysfs_ops = &xfs_log_ops,
> +	.sysfs_ops = &xfs_sysfs_ops,
>  	.default_attrs = xfs_log_attrs,
>  };
> -- 
> 2.4.3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
