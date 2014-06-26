Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E21EE7F6D
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 23:47:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8AF598F804B
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 21:47:40 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	hAAHP3R47BTU7vSs for <xfs@oss.sgi.com>;
	Wed, 25 Jun 2014 21:47:37 -0700 (PDT)
Date: Thu, 26 Jun 2014 14:47:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] xfs: add xlog sysfs kobject and attribute handlers
Message-ID: <20140626044719.GX4453@dastard>
References: <1402060414-22075-1-git-send-email-bfoster@redhat.com>
	<1402060414-22075-5-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1402060414-22075-5-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 06, 2014 at 09:13:32AM -0400, Brian Foster wrote:
> Embed a kobject into the xfs log data structure (xlog). This creates a
> 'log' subdirectory for every XFS mount instance in sysfs. The lifecycle
> of the log kobject is tied to the lifecycle of the log.
> 
> Also define a set of generic attribute handlers associated with the log
> kobject in preparation for the addition of attributes.

The code works fine, but....
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_log.c      |  9 +++++++++
>  fs/xfs/xfs_log_priv.h |  3 +++
>  fs/xfs/xfs_sysfs.c    | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_sysfs.h    |  1 +
>  4 files changed, 66 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 292308d..8eb10d5 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -34,6 +34,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_fsops.h"
>  #include "xfs_cksum.h"
> +#include "xfs_sysfs.h"
>  
>  kmem_zone_t	*xfs_log_ticket_zone;
>  
> @@ -707,6 +708,11 @@ xfs_log_mount(
>  		}
>  	}
>  
> +	error = xfs_sysfs_init(&mp->m_log->l_kobject, &xfs_log_ktype,
> +			&mp->m_log->l_kobject_complete, &mp->m_kobject, "log");
> +	if (error)
> +		goto out_destroy_ail;

... that's, ummm, rather verbose.  At minimum, a local log variable,
but I suspect that if the pattern of "all sysfs dirs have a kobject
and a completion" and they are always used together that maybe
we should have a:

struct xfs_kobj {
	struct kobject		kobj;
	struct completion	complete;
};

And we pass them around instead. that would make this:

	error = xfs_sysfs_init(&log->l_kobj, &xfs_log_ktype,
			       &mp->m_kobj, "log");

which is much easier to read....

> +
>  	/* Normal transactions can now occur */
>  	mp->m_log->l_flags &= ~XLOG_ACTIVE_RECOVERY;
>  
> @@ -947,6 +953,9 @@ xfs_log_unmount(
>  	xfs_log_quiesce(mp);
>  
>  	xfs_trans_ail_destroy(mp);
> +
> +	xfs_sysfs_del(&mp->m_log->l_kobject, &mp->m_log->l_kobject_complete);

And that would become:

	xfs_sysfs_del(&log->l_kobj);

> +
>  	xlog_dealloc_log(mp->m_log);
>  }
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 9bc403a..ce1eee2 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -405,6 +405,9 @@ struct xlog {
>  	struct xlog_grant_head	l_reserve_head;
>  	struct xlog_grant_head	l_write_head;
>  
> +	struct kobject		l_kobject;
> +	struct completion	l_kobject_complete;

	struct xfs_kobj		l_kobj;

> +
>  	/* The following field are used for debugging; need to hold icloglock */
>  #ifdef DEBUG
>  	char			*l_iclog_bak[XLOG_MAX_ICLOGS];
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 41365fe..f837527 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -54,3 +54,56 @@ xfs_mp_release(struct kobject *kobj)
>  struct kobj_type xfs_mp_ktype = {
>  	.release = xfs_mp_release,
>  };
> +
> +/* xlog */
> +
> +static struct attribute *xfs_log_attrs[] = {
> +	NULL,
> +};
> +
> +STATIC ssize_t
> +xfs_log_show(
> +	struct kobject		*kobj,
> +	struct attribute	*attr,
> +	char			*buf)
> +{
> +	struct xlog *log = container_of(kobj, struct xlog, l_kobject);

> +	struct xfs_sysfs_attr *xfs_attr = container_of(attr,
> +		struct xfs_sysfs_attr, attr);
> +
> +	return xfs_attr->show ? xfs_attr->show(buf, log) : 0;

I think this could be made much less verbose:

static inline struct xlog *
to_xlog(struct kobject *kobj)
{
	return container_of(...)
}

static inline struct xfs_sysfs_attr *
to_attr(struct attribute *attr)
{
	return container_of(...)
}

so this becomes:

{
	struct xlog		*log = to_xlog(kobj);
	struct xfs_sysfs_attr	*attr = to_attr(kattr);

	return attr->show ? attr->show(buf, log) : 0;
}


> +}
> +
> +STATIC ssize_t
> +xfs_log_store(
> +	struct kobject		*kobj,
> +	struct attribute	*attr,
> +	const char		*buf,
> +	size_t			count)
> +{
> +	struct xlog *log = container_of(kobj, struct xlog, l_kobject);
> +	struct xfs_sysfs_attr *xfs_attr = container_of(attr,
> +		struct xfs_sysfs_attr, attr);
> +
> +	return xfs_attr->store ? xfs_attr->store(buf, count, log) : 0;
> +}
> +
> +static struct sysfs_ops xfs_log_ops = {
> +	.show = xfs_log_show,
> +	.store = xfs_log_store,
> +};
> +
> +STATIC void
> +xfs_log_release(struct kobject *kobj)
> +{
> +	struct xlog *log = container_of(kobj, struct xlog, l_kobject);
> +
> +	complete(&log->l_kobject_complete);
> +}

If the release funtion is common with other types, then the xfs_kobj
structure is perfect for this use - it will prevent a heap of
duplicated release functions...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
