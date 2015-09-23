Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F2CBE7F37
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 22:37:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7E4B1AC00C
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 20:37:07 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	EpEUZo0I40W6NsLa for <xfs@oss.sgi.com>;
	Tue, 22 Sep 2015 20:37:04 -0700 (PDT)
Date: Wed, 23 Sep 2015 13:36:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/14] xfsprogs: make fsr use mntinfo when there is no
	mntent
Message-ID: <20150923033655.GQ3902@dastard>
References: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
	<1442311164-12921-13-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1442311164-12921-13-git-send-email-jtulak@redhat.com>
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

On Tue, Sep 15, 2015 at 11:59:22AM +0200, Jan Tulak wrote:
> For what fsr needs, mntinfo can be used instead of mntent.
> Custom mntent struct is used to avoid too big ifdefs:
> We only change few lines and the rest of the code can still
> use mntent as before.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  fsr/Makefile     |  8 +++++++
>  fsr/xfs_fsr.c    | 69 ++++++++++++++++++++++++++++++++++++++++++++++++--------
>  include/darwin.h | 20 ++++++++++++++++
>  3 files changed, 87 insertions(+), 10 deletions(-)
> 
> diff --git a/fsr/Makefile b/fsr/Makefile
> index a9d1bf6..d3521b2 100644
> --- a/fsr/Makefile
> +++ b/fsr/Makefile
> @@ -9,6 +9,14 @@ LTCOMMAND = xfs_fsr
>  CFILES = xfs_fsr.c
>  LLDLIBS = $(LIBHANDLE)
>  
> +ifeq ($(HAVE_GETMNTENT),yes)
> +LCFLAGS += -DHAVE_GETMNTENT
> +endif
> +
> +ifeq ($(HAVE_GETMNTINFO),yes)
> +LCFLAGS += -DHAVE_GETMNTINFO
> +endif
> +
>  default: depend $(LTCOMMAND)
>  
>  include $(BUILDRULES)
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 5f95cdc..ff791d3 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -32,8 +32,10 @@
>  #include <sys/statvfs.h>
>  #include <sys/xattr.h>
>  
> -#ifdef HAVE_MNTENT
> +#if defined(HAVE_GETMNTENT)
>  #  include <mntent.h>
> +#elif defined(HAVE_GETMNTINFO)
> +#  include <sys/mount.h>
>  #endif
>  
>  #ifdef __APPLE__
> @@ -191,9 +193,10 @@ find_mountpoint(char *mtab, char *argname, struct stat64 *sb)
>  {
>  	struct mntent *t;
>  	struct stat64 ms;
> -	FILE *mtabp;
>  	char *mntp = NULL;
>  
> +#if defined(HAVE_GETMNTENT)
> +	FILE *mtabp;
>  	mtabp = setmntent(mtab, "r");
>  	if (!mtabp) {
>  		fprintf(stderr, _("%s: cannot read %s\n"),
> @@ -202,6 +205,27 @@ find_mountpoint(char *mtab, char *argname, struct stat64 *sb)
>  	}
>  
>  	while ((t = getmntent(mtabp))) {
> +#elif defined(HAVE_GETMNTINFO)
> +	struct statfs	*stats;
> +	int error, i, count;
> +	// because "t" is a pointer, but we don't need to use
> +	// malloc for this usage
> +	struct mntent t_tmp;
> +	t = &t_tmp;
> +
> +		
> +	error = 0;
> +	if ((count = getmntinfo(&stats, 0)) < 0) {
> +		fprintf(stderr, _("%s: getmntinfo() failed: %s\n"),
> +				progname, strerror(errno));
> +		return 0;
> +	}
> +
> +	for (i = 0; i < count; i++) {
> +		mntinfo2mntent(&stats[i], t);
> +#else
> +# error "How do I extract info about mounted filesystems on this platform?"
> +#endif

No, please don't do that. Having a loop iterator split across two
separate defines is unmaintainable. Write two separate functions
with the different loop iterators, then factor the common bit out
of them into a single function.

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
> +

Same again here.


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
