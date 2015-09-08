Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BA7C17F37
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2015 16:06:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A97838F8033
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2015 14:06:49 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	m18S2g4T86RjA1xt for <xfs@oss.sgi.com>;
	Tue, 08 Sep 2015 14:06:47 -0700 (PDT)
Date: Wed, 9 Sep 2015 07:06:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: consolidate sysfs ops (dbg, stats, log)
Message-ID: <20150908210644.GK3902@dastard>
References: <1441734594-4175-1-git-send-email-billodo@redhat.com>
	<1441734594-4175-5-git-send-email-billodo@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1441734594-4175-5-git-send-email-billodo@redhat.com>
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

On Tue, Sep 08, 2015 at 12:49:54PM -0500, Bill O'Donnell wrote:
> As a part of the series to move xfs global stats from procfs to sysfs,
> this patch consolidates the sysfs ops functions and removes redundancy.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  fs/xfs/xfs_stats.c |   2 +-
>  fs/xfs/xfs_sysfs.c | 144 +++++++++++++++++------------------------------------
>  2 files changed, 48 insertions(+), 98 deletions(-)
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
>  }
>  
>  void xfs_stats_clearall(void)
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index a094e20..6fd597b 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -54,6 +54,50 @@ struct kobj_type xfs_mp_ktype = {
>  	.release = xfs_sysfs_release,
>  };
>  
> +static inline struct xlog *
> +to_xlog(struct kobject *kobject)
> +{
> +	struct xfs_kobj *kobj = to_kobj(kobject);
> +
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
> +	void *data = NULL;
> +
> +	if (ktype == &xfs_log_ktype)
> +		data = to_xlog(kobject);

Move the to_xlog(kobject) to the relevant ->show/->store operations
and just pass the kobject to them. Otherwise we'll end up with a lot
of non-generic functionality in these functions.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
