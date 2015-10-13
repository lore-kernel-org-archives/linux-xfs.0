Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6180E7F37
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 23:54:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BF4A8AC007
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 21:54:57 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	vkm7RuGIuqonKwyE for <xfs@oss.sgi.com>;
	Mon, 12 Oct 2015 21:54:55 -0700 (PDT)
Date: Tue, 13 Oct 2015 15:54:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/14 v2] xfsprogs: make fsr use mntinfo when there is no
	mntent
Message-ID: <20151013045442.GG31326@dastard>
References: <1442311164-12921-13-git-send-email-jtulak@redhat.com>
	<1443542653-10525-1-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1443542653-10525-1-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 29, 2015 at 06:04:13PM +0200, Jan Tulak wrote:
> UPDATE:
> - refactor ifdefs to platform_ functions
> 
> For what fsr needs, mntinfo can be used instead of mntent on some
> platforms. Exctract the platform-specific code to platform headers.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

I haven't commited this patch - I think it still needs some work
to clean up....

>  static void
>  initallfs(char *mtab)
>  {
> -	FILE *fp;
>  	struct mntent *mp;
>  	int mi;
>  	char *cp;
>  	struct stat64 sb;
>  
> -	fp = setmntent(mtab, "r");
> -	if (fp == NULL) {
> -		fsrprintf(_("could not open mtab file: %s\n"), mtab);
> -		exit(1);
> -	}
> -
>  	/* malloc a number of descriptors, increased later if needed */
>  	if (!(fsbase = (fsdesc_t *)malloc(fsbufsize * sizeof(fsdesc_t)))) {
>  		fsrprintf(_("out of memory: %s\n"), strerror(errno));
> @@ -427,7 +425,36 @@ initallfs(char *mtab)
>  	/* find all rw xfs file systems */
>  	mi = 0;
>  	fs = fsbase;
> +
> +#if defined(HAVE_GETMNTENT)
> +	FILE *fp;
> +	fp = setmntent(mtab, "r");
> +	if (fp == NULL) {
> +		fsrprintf(_("could not open mtab file: %s\n"), mtab);
> +		exit(1);
> +	}
> +
>  	while ((mp = getmntent(fp))) {
> +#elif defined(HAVE_GETMNTINFO)
> +	struct statfs	*stats;
> +	int error, i, count;
> +	// because "t" is a pointer, but we don't need to use
> +	// malloc for this usage
> +	struct mntent mp_tmp;
> +	mp = &mp_tmp;
> +	error = 0;
> +	if ((count = getmntinfo(&stats, 0)) < 0) {
> +		fprintf(stderr, _("%s: getmntinfo() failed: %s\n"),
> +				progname, strerror(errno));
> +		exit(1);
> +	}
> +
> +	for (i = 0; i < count; i++) {
> +		mntinfo2mntent(&stats[i], mp);
> +#else
> +# error "How do I extract info about mounted filesystems on this platform?"
> +#endif

this stuff here. This iteration should be able to be done via the
cursor abstraction, such as by keeping the iteration information
within the cursor...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
