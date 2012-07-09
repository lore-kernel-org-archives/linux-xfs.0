Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q690MPEC173964 for <xfs@oss.sgi.com>; Sun, 8 Jul 2012 19:22:25 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	5VnIWVUd0qpLDaBZ for <xfs@oss.sgi.com>;
	Sun, 08 Jul 2012 17:22:23 -0700 (PDT)
Date: Mon, 9 Jul 2012 10:22:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V4] xfs: cleanup the mount options
Message-ID: <20120709002218.GW19223@dastard>
References: <20120706030532.GU19223@dastard>
	<1341747397-10649-1-git-send-email-gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1341747397-10649-1-git-send-email-gaowanlong@cn.fujitsu.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Zach Brown <zab@zabbo.net>, XFS <xfs@oss.sgi.com>

On Sun, Jul 08, 2012 at 07:36:37PM +0800, Wanlong Gao wrote:
> remove the mount options macro, use tokens instead.
> 
> CC: Ben Myers <bpm@sgi.com>
> CC: Christoph Hellwig <hch@infradead.org>
> CC: Dave Chinner <david@fromorbit.com>
> CC: Zach Brown <zab@zabbo.net>
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> ---

A "what's changed in this version" list would be handy here.

>  fs/xfs/xfs_super.c |  539 +++++++++++++++++++++++++++++++---------------------
>  1 file changed, 320 insertions(+), 219 deletions(-)

....

> -
> -STATIC unsigned long
> -suffix_strtoul(char *s, char **endp, unsigned int base)
> +STATIC int
> +suffix_match_int(substring_t *s, int *result)

I'm not sure ints are the best unit to use here....

>  {
> -	int	last, shift_left_factor = 0;
> -	char	*value = s;
> +	int ret;
> +	int last, shift_left_factor = 0;
> +	char *value = s->to - 1;
>  
> -	last = strlen(value) - 1;
> -	if (value[last] == 'K' || value[last] == 'k') {
> +	if (*value == 'K' || *value == 'k') {
>  		shift_left_factor = 10;
> -		value[last] = '\0';
> +		s->to--;
>  	}
> -	if (value[last] == 'M' || value[last] == 'm') {
> +	if (*value == 'M' || *value == 'm') {
>  		shift_left_factor = 20;
> -		value[last] = '\0';
> +		s->to--;
>  	}
> -	if (value[last] == 'G' || value[last] == 'g') {
> +	if (*value == 'G' || *value == 'g') {
>  		shift_left_factor = 30;
> -		value[last] = '\0';
> +		s->to--;
>  	}
>  
> -	return simple_strtoul((const char *)s, endp, base) << shift_left_factor;
> +	ret = match_number(s, result, 0);
> +	*result = *result << shift_left_factor;

Because this overflows or gives the negative values for numbers like
2G far too easily. I think this function needs to return an unsigned
long.

> +	ret = ENOMEM;
> +	options = kstrdup(options, GFP_NOFS);
> +	if (!options)
> +		goto done;

I commented on this error form previously. Can you convert them all
to be consistent with the rest of the code? i.e:

	options = kstrdup(options, GFP_NOFS);
	if (!options) {
		ret = ENOMEM;
		goto done;
	}

i.e. set the error value (if necessary) in the error branch....

> +	orig = options;
> +
> +	while ((p = strsep(&orig, ",")) != NULL) {
> +		int token;
> +		if (!*p)
>  			continue;
> +
> +		token = match_token(p, tokens, args);
> +		switch (token) {
> +		case Opt_logbufs:
> +			intarg = 0;

Please move the initialisation of intarg up above the switch
statement so that it is initialised once for all cases instead of
individually in the cases that use it. That means we don't have to
remember to do it in future for new or changed mount options...

> +			ret = match_int(args, &intarg);
> +			if (ret)
> +				goto free_orig;
> +			mp->m_logbufs = intarg;
> +			break;
> +		case Opt_logbsize:
> +			ret = suffix_match_int(args, &intarg);
> +			if (ret)
> +				goto free_orig;
> +			mp->m_logbsize = intarg;
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

This match_strdup/kstrndup pattern is repeated a couple of times,
and requires a special failure case (goto free_string) - wrapping it
in helper function is probably a good idea so that the special
failure case can be removed from this main parse loop...

> +		case Opt_biosize:
> +			intarg = 0;
> +			ret = match_int(args, &intarg);
> +			if (ret)
> +				goto free_orig;
> +			iosizelog = ffs(intarg) - 1;
> +			break;
> +		case Opt_allocsize:
> +			ret = suffix_match_int(args, &intarg);
> +			if (ret)
> +				goto free_orig;
> +			iosizelog = ffs(intarg) - 1;
> +			break;

These two can be collapsed into:

		case Opt_biosize:
		case Opt_allocsize:
			ret = suffix_match_int(args, &intarg);
			if (ret)
				goto free_orig;
			iosizelog = ffs(intarg) - 1;
			break;

Also, these two a a good example of why intarg should be initialised
to zero outside the switch statement - they both do almost exactly
the same thing, but one initialises intarg and the other doesn't. Is
that a bug? I can't tell without looking at the implementations of
match_int and suffix_match_int....

> +		case Opt_delaylog:
> +			xfs_warn(mp,
> +		"delaylog is the default now, option is deprecated.");

As preivously mentioned, duplication of the mount option is here.

Adding something like:

#define MNTOPT_DEPRECATED "has no effect, option is deprecated"

Means these can become:

		case Opt_delaylog:
			xfs_warn(mp, MNTOPT_DELAYLOG MNTOPT_DEPRECATED);
			break;

> +		case Opt_nodelaylog:
> +			xfs_warn(mp,
> +		"nodelaylog support has been removed, option is deprecated.");

			xfs_warn(mp, MNTOPT_NODELAYLOG MNTOPT_DEPRECATED);

> +			break;
> +		case Opt_ihashsize:
>  			xfs_warn(mp,
> +		"ihashsize no longer used, option is deprecated.");

			xfs_warn(mp, MNTOPT_IHASHSIZE MNTOPT_DEPRECATED);

And so on for all the deprecated options. That way we get a
consistent mesage for all deprecated options and it's easy to keep
that way in the future.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
