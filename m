Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3BEBA7F37
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 14:32:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3216730405F
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 12:32:25 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id HpA5xCvxfaWyP25s (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 12:32:23 -0700 (PDT)
Date: Mon, 17 Aug 2015 12:32:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/11] xfsprogs: missing and dummy calls for OS X support
Message-ID: <20150817193223.GE26222@infradead.org>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-6-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439828606-7886-6-git-send-email-jtulak@redhat.com>
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
Cc: hch@infradead.org, xfs@oss.sgi.com

On Mon, Aug 17, 2015 at 06:23:20PM +0200, Jan Tulak wrote:
> Add and update various API, macros and types where is some change
> in OS X or xfsprogs. Most changes are in darwin.h.
> 
> Add dummy implementations where native support is nonexistent
> and the tools are not expected to work anyway, so all tools can be
> at least compiled.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fsr/xfs_fsr.c    |   8 +++
>  include/darwin.h | 153 +++++++++++++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 145 insertions(+), 16 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 7c1d776..b4ff136 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -43,6 +43,14 @@
>  #define _PATH_FSRLAST		"/var/tmp/.fsrlast_xfs"
>  #define _PATH_PROC_MOUNTS	"/proc/mounts"
>  
> +#ifdef USE_DUMMY_XATTR
> +	/* OS X has fsetxattr with different number of arguments.
> +	 * Because it won't work anyway (no fstab/mtab and so on),
> +	 * hijack the call to a dummy function so it can at least
> +	 * compile.
> +	 */
> +#  define fsetxattr(a,b,c,d,e) dummy_fsetxattr(a,b,c,d,e)
> +#endif

I don't think this is the right way to do it.  I'd rather:

a) check for fsetxattr using autoconf, and
b) stub out the whole code calling it.
c) make this a patch on it's own

>  
>  char *progname;
>  
> diff --git a/include/darwin.h b/include/darwin.h
> index 8b5a661..775dfc8 100644
> --- a/include/darwin.h
> +++ b/include/darwin.h
> @@ -76,45 +76,37 @@ static __inline__ void platform_getoptreset(void)
>  
>  static __inline__ int platform_uuid_compare(uuid_t *uu1, uuid_t *uu2)
>  {
> -	return uuid_compare(uu1, uu2, NULL);
> +	return uuid_compare((const unsigned char *) uu1, (const unsigned char*) uu2);

Do you have any idea why MacOS defines a uuid_t, but wants unsigned
char arguments to uuid_compare?

Or given that the others work with pointer dereferences why doesn't:

	return uuid_compare(*uu1, *uu2);

work?

Also please make the uuid changes a patch on it's own.

> -#define ENOATTR		989     /* Attribute not found */
>  #define EFSCORRUPTED	990	/* Filesystem is corrupted */
>  #define EFSBADCRC	991	/* Bad CRC detected */
>  #define constpp		char * const *

> +#define XATTR_SIZE_MAX 65536    /* size of an extended attribute value (64k) */
> +#define XATTR_LIST_MAX 65536    /* size of extended attribute namelist (64k) */

Eww, looks like we depend on these Linux values in the on disk
defintion.  I think we need to add new XFS_XATTR_SIZE_MAX and
XFS_XATTR_LIST_MAX defintions to xfs_format.h and use them where
we currently use these.

> +/*
> + * Dummy POSIX timer replacement
> + */
> +#define CLOCK_REALTIME 1
> +typedef uint64_t timer_t;
> +typedef double   timer_c;
> +typedef clock_id_t clockid_t;
> +struct itimerspec
> +  {
> +    struct timespec it_interval;
> +    struct timespec it_value;
> +  };
> +
> +static inline int timer_create (clockid_t __clock_id,
> +                         struct sigevent *__restrict __evp,
> +                         timer_t *__restrict __timerid)
> +{
> +	return 0;
> +}
> +
> +static inline int timer_settime (timer_t __timerid, int __flags,
> +                          const struct itimerspec *__restrict __value,
> +                          struct itimerspec *__restrict __ovalue)
> +{
> +	return 0;
> +}
> +
> +static inline int timer_delete (timer_t __timerid)
> +{
> +	return 0;
> +}
> +
> +static inline int timer_gettime (timer_t __timerid, struct itimerspec *__value)
> +{
> +	return 0;
> +}

I don't think these stubs will work.  It might be worth to figure
out what people use as replacement for realtime clocks on MacOS
by searching various programming resoures on the internet.

> +static inline int nftw64(const char *path, int (*fn)(const char *, const struct stat *ptr, int flag, struct FTW *), int depth,
> +         int flags)
> +{
> +	return nftw(path, fn, depth, flags);
> +}
> +
> +#define MREMAP_FIXED 1
> +#define MREMAP_MAYMOVE 2
> +static inline void *mremap(void *old_address, size_t old_size,
> +                    size_t new_size, int flags, ... /* void *new_address */)
> +{
> +	return NULL;
> +}
> +
> +/* FSR */

Please just build the mremap file in xfs_io conditional.

> +typedef int __fsblkcnt_t;
> +typedef int __fsfilcnt_t;
> +typedef long long int __fsblkcnt64_t;
> +typedef long long int __fsfilcnt64_t;
> +
> +struct statvfs64
> +{
> +	unsigned long int f_bsize;
> +	unsigned long int f_frsize;
> +	__fsblkcnt64_t f_blocks;
> +	__fsblkcnt64_t f_bfree;
> +	__fsblkcnt64_t f_bavail;
> +	__fsfilcnt64_t f_files;
> +	__fsfilcnt64_t f_ffree;
> +	__fsfilcnt64_t f_favail;
> +	unsigned long int f_fsid;
> +	int __f_unused;
> +	unsigned long int f_flag;
> +	unsigned long int f_namemax;
> +	int __f_spare[6];
> +};

Does MacOS support statvfs? or statfs?  We should use the proper API
here instead of a dummy.  Or maybe just not build fsr on OSX for now,
as that would solve the fsetxattr issue as well.

> +struct mntent
> +{

Another fsr issue, right?  Seems like it would need similar getmntinfo
based code.  As a stopgap I'd suggest we stop building fsr on OSX for
now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
