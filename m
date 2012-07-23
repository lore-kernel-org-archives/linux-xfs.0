Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6NNY972255124 for <xfs@oss.sgi.com>; Mon, 23 Jul 2012 18:34:10 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	FpFACZ7Sn85RaLCv for <xfs@oss.sgi.com>;
	Mon, 23 Jul 2012 16:34:07 -0700 (PDT)
Date: Tue, 24 Jul 2012 09:28:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V5] xfs: cleanup the mount options
Message-ID: <20120723232813.GL23387@dastard>
References: <20120711022609.GX19223@dastard>
	<1341988145-12994-1-git-send-email-gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1341988145-12994-1-git-send-email-gaowanlong@cn.fujitsu.com>
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

On Wed, Jul 11, 2012 at 02:29:05PM +0800, Wanlong Gao wrote:
> -	return simple_strtoul((const char *)s, endp, base) << shift_left_factor;
> +	string = match_strdup(s);

GFP_KERNEL allocation....

> +	if (!string)
> +		return ENOMEM;
> +
> +	*result = simple_strtoul((const char *)string, NULL, 0) <<
> +			shift_left_factor;
> +
> +	kfree(string);
> +	return 0;
> +}
> +
> +STATIC int
> +match_name_strdup(substring_t *s, char *name)
> +{
> +	char *string;
> +	string = match_strdup(s);

GFP_KERNEL allocation....

> +	if (!string)
> +		return ENOMEM;
> +
> +	name = kstrndup(string, MAXNAMELEN, GFP_KERNEL);

GFP_KERNEL allocation....

> +	if (!name)
> +		goto free;
> +	return 0;

Leaks string - it should always be freed.

> +free:
> +	kfree(string);
> +	return ENOMEM;
>  }
>  
>  /*
> @@ -166,11 +246,15 @@ xfs_parseargs(
>  	char			*options)
>  {
>  	struct super_block	*sb = mp->m_super;
> -	char			*this_char, *value, *eov;
> +	char			*p;
>  	int			dsunit = 0;
>  	int			dswidth = 0;
> -	int			iosize = 0;
>  	__uint8_t		iosizelog = 0;
> +	int			intarg;
> +	unsigned long		ularg;
> +	substring_t		args[MAX_OPT_ARGS];
> +	char			*orig = NULL;
> +	int			ret = 0;
>  
>  	/*
>  	 * set up the mount name first so all the errors will refer to the
> @@ -208,175 +292,192 @@ xfs_parseargs(
>  	if (!options)
>  		goto done;
>  
> -	while ((this_char = strsep(&options, ",")) != NULL) {
> -		if (!*this_char)
> +	options = kstrdup(options, GFP_NOFS);

GFP_NOFS allocation. Why is this GFP_NOFS, and all the other
allocations GFP_KERNEL? If it is not safe to use GFP_KERNEL
allocations here, then all of the above allocations need to be
GFP_NOFS, too.


> +	if (!options) {
> +		ret = ENOMEM;
> +		goto done;
> +	}
> +
> +	orig = options;

Also, no need to set up orig like this. Just a simple:

	orig = kstrdup(options, GFP_NOFS);
	if (!orig) {
		ret = ENOMEM;
		goto done;
	}

will work fine.

....

>  	if (mp->m_logbufs > 0)
> -		seq_printf(m, "," MNTOPT_LOGBUFS "=%d", mp->m_logbufs);
> +		seq_printf(seq, "," MNTOPT_LOGBUFS "=%d", mp->m_logbufs);
>  	if (mp->m_logbsize > 0)
> -		seq_printf(m, "," MNTOPT_LOGBSIZE "=%dk", mp->m_logbsize >> 10);
> +		seq_printf(seq, "," MNTOPT_LOGBSIZE "=%dk",
> +				mp->m_logbsize >> 10);

Change of user visible output format here. That will break any
scripts that are parsing the output and expecting numbers. Just
leave it as a raw number.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
