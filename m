Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F153E7F57
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2014 17:10:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D1460304048
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2014 15:10:21 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	RRaVUtuUterelStw for <xfs@oss.sgi.com>;
	Mon, 06 Oct 2014 15:10:19 -0700 (PDT)
Date: Tue, 7 Oct 2014 09:10:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/16] xfs: add xfs_nameops for utf8 and utf8+casefold.
Message-ID: <20141006221016.GH2301@dastard>
References: <20141003214758.GY1865@sgi.com>
 <20141003220118.GJ1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141003220118.GJ1865@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, olaf@sgi.com, xfs@oss.sgi.com

On Fri, Oct 03, 2014 at 05:01:18PM -0500, Ben Myers wrote:
> From: Olaf Weber <olaf@sgi.com>
> 
> The xfs_utf8_nameops use the nfkdi normalization when comparing filenames,
> and are installed if the utf8bit is set in the super block.
> 
> The xfs_utf8_ci_nameops use the nfkdicf normalization when comparing
> filenames, and are installed if both the utf8bit and the borgbit are set
> in the superblock.
> 
> Normalized filenames are not stored on disk. Normalization will fail if a
> filename is not valid UTF-8, in which case the filename is treated as an
> opaque blob.
> 
> Signed-off-by: Olaf Weber <olaf@sgi.com>
> 
> ---
> [v2: updated to use utf8norm.ko module;
>      compiled conditionally on CONFIG_XFS_UTF8=y;
>      utf8version is now a function;
>      move xfs_utf8.[ch] into libxfs. --bpm]
> [v3: pass utf8version from the superblock through xfs_nameops
>      instead of the max version of the normalization module. --bpm]
> ---
>  fs/xfs/Kconfig           |   9 ++
>  fs/xfs/Makefile          |   2 +
>  fs/xfs/libxfs/xfs_dir2.c |   4 +-
>  fs/xfs/libxfs/xfs_utf8.c | 208 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_utf8.h |   3 +
>  fs/xfs/xfs_iops.c        |   2 +-
>  6 files changed, 225 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index 5d47b4d..1e8a463 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -95,3 +95,12 @@ config XFS_DEBUG
>  	  not useful unless you are debugging a particular problem.
>  
>  	  Say N unless you are an XFS developer, or you play one on TV.
> +
> +config XFS_UTF8
> +	bool "XFS UTF-8 support"
> +	depends on XFS_FS
> +	select CONFIG_UTF8_NORMALIZATION
> +	help
> +	  Say Y here to enable utf8 normalization support in XFS.  You
> +	  will be able to mount and use filesystems created with the
> +	  utf8 mkfs.xfs option.

"created with UTF8 support enabled."

> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index d617999..192aaca 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -114,6 +114,8 @@ xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
>  				   xfs_qm.o \
>  				   xfs_quotaops.o
>  
> +xfs-$(CONFIG_XFS_UTF8)		+= libxfs/xfs_utf8.o
> +

libxfs definitions come first. Also, please use the same prefixing
syntax that the other libxfs rules use.

>  # xfs_rtbitmap is shared with libxfs
>  xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 2c89211..9cfbd6b 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -165,9 +165,9 @@ xfs_da_mount(
>  		/* XXX these are replaced in the next patch need
>  		   to do some kind of reordering here */
>  		if (xfs_sb_version_hasasciici(&mp->m_sb))
> -			mp->m_dirnameops = &xfs_ascii_ci_nameops;
> +			mp->m_dirnameops = &xfs_utf8_ci_nameops;
>  		else
> -			mp->m_dirnameops = &xfs_default_nameops;
> +			mp->m_dirnameops = &xfs_utf8_nameops;
>  #else

xfs_sb_version_hasasciici()? The overloading of the asciici bit is
still used for the utf8 CI functionality? Please fix this for the
next version of the patchset.

>  		xfs_warn(mp,
>  "Recompile XFS with CONFIG_XFS_UTF8 to mount this filesystem");
> diff --git a/fs/xfs/libxfs/xfs_utf8.c b/fs/xfs/libxfs/xfs_utf8.c
> index 7e63111..1e75299 100644
> --- a/fs/xfs/libxfs/xfs_utf8.c
> +++ b/fs/xfs/libxfs/xfs_utf8.c
> @@ -68,3 +68,211 @@ xfs_utf8_version_ok(
>  
>  	return 0;
>  }
> +
> +/*
> + * xfs nameops using nfkdi
> + */

Remind me again what nfkdi means? I I can't remember the details
after a week or two, then perhaps better explanitory comments are
needed in the code?

> +static xfs_dahash_t
> +xfs_utf8_hashname(
> +	const unsigned char *name,
> +	int len,
> +	unsigned int sb_utf8version)

Please use the same indentation levels for the declartions. i.e

	const unsigned char	*name,
	int			len,
	unsigned int		sb_utf8version)

Can you go through all the XFS code and make sure this is done?

> +{
> +	utf8data_t	nfkdi;
> +	struct utf8cursor u8c;
> +	xfs_dahash_t	hash;
> +	int		val;

And these shold line up, too.

> +
> +	nfkdi = utf8nfkdi(sb_utf8version);
> +	hash = 0;

initialise at declaration.

> +	if (utf8ncursor(&u8c, nfkdi, name, len) < 0)
> +		goto blob;

Still has the "invalid binary blob" issue.

> +	while ((val = utf8byte(&u8c)) > 0)
> +		hash = val ^ rol32(hash, 7);
> +	/* In case of error treat the name as a binary blob. */
> +	if (val == 0)
> +		return hash;
> +blob:
> +	return xfs_da_hashname(name, len);
> +}
> +
> +static int
> +xfs_utf8_normhash(

More commments needed explaining what is going on.

> +	struct xfs_da_args *args)
> +{
> +	utf8data_t	nfkdi;
> +	struct utf8cursor u8c;
> +	unsigned char	*norm;
> +	ssize_t		normlen;
> +	int		c;
> +	unsigned int	sb_utf8version =
> +		args->dp->i_mount->m_sb.sb_utf8version;

Urk. Initialise on a separate line.

> +
> +	nfkdi = utf8nfkdi(sb_utf8version);
> +	/* Failure to normalize is treated as a blob. */
> +	if ((normlen = utf8nlen(nfkdi, args->name, args->namelen)) < 0)
> +		goto blob;

No assignments in logic statements, please.

	normlen = utf8nlen(nfkdi, args->name, args->namelen);
	if (normlen < 0)

This is all through the code - can you please go through and fix up
all the patches to remove this pattern? checkpatch might be helpful
here....

As it is, still has the invalid binary blob issue.


> +	if (utf8ncursor(&u8c, nfkdi, args->name, args->namelen) < 0)
> +		goto blob;
> +	if (!(norm = kmem_alloc(normlen + 1, KM_NOFS|KM_MAYFAIL)))
> +		return -ENOMEM;

Urk.

So, what happens if this memory allocation fails in the middle of a
create transaction?

(Hint: transaction is dirty at this point in time)

The rest of the code in this patch has similar issues to what I've
already pointed out.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
