Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6635caQ129171 for <xfs@oss.sgi.com>; Thu, 5 Jul 2012 22:05:38 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	0Hys0mJ7PxVBtPEK for <xfs@oss.sgi.com>;
	Thu, 05 Jul 2012 20:05:35 -0700 (PDT)
Date: Fri, 6 Jul 2012 13:05:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V3] xfs: cleanup the mount options
Message-ID: <20120706030532.GU19223@dastard>
References: <20120702062625.GB20804@infradead.org>
	<1341212714-13508-1-git-send-email-gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1341212714-13508-1-git-send-email-gaowanlong@cn.fujitsu.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Zach Brown <zab@zabbo.net>, xfs@oss.sgi.com

On Mon, Jul 02, 2012 at 03:05:14PM +0800, Wanlong Gao wrote:
> remove the mount options macro, use tokens instead.
> 
> CC: Ben Myers <bpm@sgi.com>
> CC: Christoph Hellwig <hch@infradead.org>
> CC: Dave Chinner <david@fromorbit.com>
> CC: Zach Brown <zab@zabbo.net>
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> ---
>  fs/xfs/xfs_super.c | 510 ++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 307 insertions(+), 203 deletions(-)
....

One thing about duplication:

> +#define	MNTOPT_LOGBUFS		"logbufs"
> +#define	MNTOPT_LOGBSIZE		"logbsize"
> +#define	MNTOPT_LOGDEV		"logdev"

....

>  static const match_table_t tokens = {
> -	{Opt_barrier, "barrier"},
> -	{Opt_nobarrier, "nobarrier"},
> +	{Opt_logbufs, "logbufs=%d"},	/* number of XFS log buffers */
> +	{Opt_logbsize, "logbsize=%s"},	/* size of XFS log buffers */
> +	{Opt_logdev, "logdev=%s"},	/* log device */

You're effectively defining each string twice, which is almost
certainly going to lead to one but nothe other being updated in
future.

Can something like:

	{Opt_logbufs, MNTOPT_LOGBUFS "=%d"},	/* number of XFS log buffers */
	{Opt_logbsize,MNTOPT_LOGBSIZE "=%s"},	/* size of XFS log buffers */
	{Opt_logdev,  MNTOPT_LOGDEV "=%s"},	/* log device */

be done to avoid that duplication?

> +		token = match_token(p, tokens, args);
> +		switch (token) {
> +		case Opt_logbufs:
> +			intarg = 0;
> +			ret = EINVAL;
> +			match_int(args, &intarg);
> +			if (!intarg)
> +				goto free_orig;

Why is a value of zero an error? match_int() returns an error if it
fails....

> +			mp->m_logbufs = intarg;
> +			break;

I don't really like the "set error, call function, jump to error"
pattern. I'd prefer just to set the error value when an error
returns as it makes the code much easier and more logical to read.
i.e:

		token = match_token(p, tokens, args);
		switch (token) {
		case Opt_logbufs:
			ret = match_int(args, &intarg);
			if (ret)
				goto free_orig;
			mp->m_logbufs = intarg;
			break;

> +		case Opt_logbsize:
> +			ret = ENOMEM;
> +			string = match_strdup(args);
> +			if (!string)
> +				goto free_orig;
> +			ret = EINVAL;
> +			intarg = suffix_strtoul(string, &eov, 0);
> +			if (!intarg)
> +				goto free_string;

So this is just an open coded version of match_int() using the
suffix_strtoul() rather than simple_strtoul() directly. Please write
a "suffix_match_int()" wrapper for it, and that avoids all the messy
error handling in this code....

> +			break;
> +		case Opt_logdev:
> +			ret = ENOMEM;
> +			string = match_strdup(args);
> +			if (!string)
> +				goto free_orig;
> +
> +			mp->m_logname = kstrndup(string, MAXNAMELEN, GFP_KERNEL);
>  			if (!mp->m_logname)
> +				goto free_string;

and is consistent with this and other similar code.

> +		case Opt_biosize:
> +			intarg = 0;
> +			ret = EINVAL;
> +			intarg = match_int(args, &intarg);

That's not valid. match_int() returns either 0 or -EINVAL/-ENOMEM,
and that will overwrite whatever value match_int() writes into
intarg when it decodes it.

> +			if (!intarg)
> +				goto free_orig;

hence on a correct mount option with value, it will abort with no
error.

> +			iosizelog = ffs(intarg) - 1;

And on a bad value, it will write something bad into iosizelog and
continue.

> +		case Opt_allocsize:
> +			ret = ENOMEM;
> +			string = match_strdup(args);
> +			if (!string)
> +				goto free_orig;
> +			ret = EINVAL;
> +			intarg = suffix_strtoul(string, &eov, 0);
> +			if (!intarg)
> +				goto free_string;

Why is a value of zero an error?

....

> +		case Opt_delaylog:
>  			xfs_warn(mp,
> +		"delaylog is the default now, option is deprecated.");
> +			break;
> +		case Opt_nodelaylog:
>  			xfs_warn(mp,
> +		"nodelaylog support has been removed, option is deprecated.");

Hard coding mount options here again.....

> +			break;
> +		case Opt_discard:
>  			mp->m_flags |= XFS_MOUNT_DISCARD;
> +			break;
> +		case Opt_nodiscard:
>  			mp->m_flags &= ~XFS_MOUNT_DISCARD;
> +			break;

Move these above all the deprecated options.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
