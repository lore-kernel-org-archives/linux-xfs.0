Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E14E47FAC
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2015 22:31:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D045C8F804B
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2015 20:31:25 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	BgUjqbI9tn6XGThM for <xfs@oss.sgi.com>;
	Fri, 04 Sep 2015 20:31:23 -0700 (PDT)
Date: Sat, 5 Sep 2015 13:31:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: create global stats and stats_clear in sysfs
Message-ID: <20150905033121.GN26895@dastard>
References: <1441400050-8455-1-git-send-email-billodo@redhat.com>
	<1441400050-8455-2-git-send-email-billodo@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1441400050-8455-2-git-send-email-billodo@redhat.com>
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

On Fri, Sep 04, 2015 at 03:54:08PM -0500, Bill O'Donnell wrote:
> Currently, xfs global stats are in procfs. This patch introduces
> (replicates) the global stats in sysfs. Additionally a stats_clear file
> is introduced in sysfs.
> 
....
>  
> +int xfs_stats_format(char *buf)
> +{
> +	int		i, j;
> +	int		len = 0;
> +	__uint64_t	xs_xstrat_bytes = 0;
> +	__uint64_t	xs_write_bytes = 0;
> +	__uint64_t	xs_read_bytes = 0;
....
> +	len += snprintf(buf+len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
> +			xs_xstrat_bytes, xs_write_bytes, xs_read_bytes);
> +	len += snprintf(buf+len, PATH_MAX-len, "debug %u\n",
> +#if defined(DEBUG)
> +		1);
> +#else
> +		0);
> +#endif
> +
> +return len;
> +}

missing tab on return.

....
> +STATIC ssize_t
> +xfs_stats_show(
> +	struct kobject		*kobject,
> +	struct attribute	*attr,
> +	char			*buf)
> +{
> +	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
> +
> +	return xfs_attr->show ? xfs_attr->show(buf, NULL) : 0;
> +}
> +
> +STATIC ssize_t
> +xfs_stats_store(
> +	struct kobject		*kobject,
> +	struct attribute	*attr,
> +	const char		*buf,
> +	size_t			count)
> +{
> +	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
> +
> +	return xfs_attr->store ? xfs_attr->store(buf, count, NULL) : 0;
> +}
> +
> +static struct sysfs_ops xfs_stats_ops = {
> +	.show = xfs_stats_show,
> +	.store = xfs_stats_store,
> +};

Hmmm, I'm wondering if we can reduce this boiler plate code here.
It's basically indentical to xfs_log_show/store and
xfs_dbg_show/store. TO make them indentical, all we need to do is
pass the kobject through as the data object, and have the show/store
function decode it if necessary (i.e. call to_xlog() for the xfs log
attributes).  This them means that all the sysfs entries
attributes use the same sysfs_ops structure.

That can be done as a patch on top of this, though (i.e. patch #4).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
