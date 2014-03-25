Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D27457F3F
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 09:16:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BB8BF8F8037
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 07:16:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id O7HUxI5W8ppyRmcz for
	<xfs@oss.sgi.com>; Tue, 25 Mar 2014 07:16:02 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2PEFwoO018598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 10:15:59 -0400
Date: Tue, 25 Mar 2014 10:15:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] remove ancient sys_getdents code paths
Message-ID: <20140325141553.GB18691@bfoster.bfoster>
References: <20140324181920.GG23291@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140324181920.GG23291@redacted.bos.redhat.com>
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
To: Kyle McMartin <kmcmarti@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Mar 24, 2014 at 02:19:20PM -0400, Kyle McMartin wrote:
> Everything since 2.4.1 has supported getdents64... so let's remove all
> the legacy code paths to handle it and just rely on getdents64 existing
> everywhere. Also re-indent the function to not look entirely awful.
> 
> ---
>  common/getdents.c | 246 +++++++++++++++---------------------------------------
>  1 file changed, 69 insertions(+), 177 deletions(-)

:)

> 
> diff --git a/common/getdents.c b/common/getdents.c
> index 49d0d03..957bb5a 100644
> --- a/common/getdents.c
> +++ b/common/getdents.c
> @@ -35,47 +35,13 @@
>  
>  #include <linux/posix_types.h>
>  
> -/* For Linux we need a special version of this file since the
> -   definition of `struct dirent' is not the same for the kernel and
> -   the libc.  There is one additional field which might be introduced
> -   in the kernel structure in the future.
> -
> -   Here is the kernel definition of `struct dirent' as of 2.1.20:  */
> -
> -struct kernel_dirent
> -  {
> -    long int d_ino;
> -    __kernel_off_t d_off;
> -    unsigned short int d_reclen;
> -    char d_name[256];
> -  };
> -
> -struct kernel_dirent64
> -  {
> -    uint64_t		d_ino;
> -    int64_t		d_off;
> -    unsigned short int	d_reclen;
> -    unsigned char	d_type;
> -    char		d_name[256];
> -  };
> -
> -#define DIRENT_SET_DP_INO(dp, value) (dp)->d_ino = (value)
> -
> -#define __set_errno(e) (errno = (e))
> -
> -int __have_no_getdents64;
> -
> -#ifdef __NR_getdents64
> -# define __SYS_GETDENTS64(fd, buf, len) (syscall(SYS_getdents64, fd, buf, len))
> -#else
> -# define __SYS_GETDENTS64(fd, buf, len) ({ __set_errno(ENOSYS); -1; })
> -#endif
> -
> -#ifdef __NR_getdents
> -# define __SYS_GETDENTS(fd, buf, len) (syscall(SYS_getdents, fd, buf, len))
> -#else
> -# define __SYS_GETDENTS(fd, buf, len) ({ __set_errno(ENOSYS); -1; })
> -#endif
> +struct kernel_dirent64 {
> +	uint64_t d_ino;
> +	int64_t d_off;
> +	unsigned short int d_reclen;
> +	unsigned char d_type;
> +	char d_name[256];
> +};
>  
>  /* The problem here is that we cannot simply read the next NBYTES
>     bytes.  We need to take the additional field into account.  We use
> @@ -85,148 +51,74 @@ int __have_no_getdents64;
>     reasonable number of bytes to read.  If we should be wrong, we can
>     reset the file descriptor.  In practice the kernel is limiting the
>     amount of data returned much more then the reduced buffer size.  */
> -int
> -getdents_wrap (int fd, char *buf, size_t nbytes)
> +int getdents_wrap(int fd, char *buf, size_t nbytes)
>  {
> -  struct dirent *dp;
> -  off64_t last_offset = -1;
> -  ssize_t retval;
> -
> -  if (!__have_no_getdents64)
> -    {
> -      int saved_errno = errno;
> -      char *kbuf = buf;
> -      size_t kbytes = nbytes;
> -      if (offsetof (struct dirent, d_name)
> -	  < offsetof (struct kernel_dirent64, d_name)
> -	  && nbytes <= sizeof (struct dirent))
> -	{
> -	  kbytes = nbytes + offsetof (struct kernel_dirent64, d_name)
> -		   - offsetof (struct dirent, d_name);
> -	  kbuf = alloca(kbytes);
> +	struct dirent *dp;
> +	struct kernel_dirent64 *kdp;
> +	off64_t last_offset = -1;
> +	ssize_t retval;
> +	char *kbuf = buf;
> +	size_t kbytes = nbytes;
> +	const size_t size_diff = (offsetof(struct kernel_dirent64, d_name)
> +				  - offsetof(struct dirent, d_name));
> +
> +	if (offsetof(struct dirent, d_name)
> +	    < offsetof(struct kernel_dirent64, d_name)
> +	    && nbytes <= sizeof(struct dirent)) {
> +		kbytes = nbytes + size_diff;
> +		kbuf = alloca(kbytes);
>  	}

I wonder if we could clean up the d_name offset checks to check it once
and use a flag. Or use a signed type for size_diff and trigger off that.
Just a thought, fwiw.

> -      retval = __SYS_GETDENTS64(fd, kbuf, kbytes);
> -      if (retval != -1)
> -	{
> -	  struct kernel_dirent64 *kdp;
> -	  const size_t size_diff = (offsetof (struct kernel_dirent64, d_name)
> -				    - offsetof (struct dirent, d_name));
> -
> -	  /* If the structure returned by the kernel is identical to what we
> -	     need, don't do any conversions.  */
> -	  if (offsetof (struct dirent, d_name)
> -	      == offsetof (struct kernel_dirent64, d_name)
> -	      && sizeof (dp->d_ino) == sizeof (kdp->d_ino)
> -	      && sizeof (dp->d_off) == sizeof (kdp->d_off))
> -	    return retval;
> -
> -	  dp = (struct dirent *)buf;
> -	  kdp = (struct kernel_dirent64 *) kbuf;
> -	  while ((char *) kdp < kbuf + retval)
> -	    {
> -	      const size_t alignment = __alignof__ (struct dirent);
> -	      /* Since kdp->d_reclen is already aligned for the kernel
> -		 structure this may compute a value that is bigger
> -		 than necessary.  */
> -	      size_t old_reclen = kdp->d_reclen;
> -	      size_t new_reclen = ((old_reclen - size_diff + alignment - 1)
> -				  & ~(alignment - 1));
> -	      uint64_t d_ino = kdp->d_ino;
> -	      int64_t d_off = kdp->d_off;
> -	      unsigned char d_type = kdp->d_type;
>  
> -	      DIRENT_SET_DP_INO (dp, d_ino);
> -	      dp->d_off = d_off;
> -	      if ((sizeof (dp->d_ino) != sizeof (kdp->d_ino)
> -		   && dp->d_ino != d_ino)
> -		  || (sizeof (dp->d_off) != sizeof (kdp->d_off)
> -		      && dp->d_off != d_off))
> -		{
> -		  /* Overflow.  If there was at least one entry
> -		     before this one, return them without error,
> -		     otherwise signal overflow.  */
> -		  if (last_offset != -1)
> -		    {
> -		      lseek64 (fd, last_offset, SEEK_SET);
> -		      return (char *) dp - buf;
> -		    }
> -		  __set_errno (EOVERFLOW);
> -		  return -1;
> +	retval = syscall(SYS_getdents64, fd, kbuf, kbytes);
> +	if (retval != -1)
> +		return retval;
> +

I suspect you want to return if retval == -1 here.

> +	/* If the structure returned by the kernel is identical to what we
> +	   need, don't do any conversions.  */
> +	if (offsetof(struct dirent, d_name)
> +	    == offsetof(struct kernel_dirent64, d_name)
> +	    && sizeof(dp->d_ino) == sizeof(kdp->d_ino)
> +	    && sizeof(dp->d_off) == sizeof(kdp->d_off))
> +		return retval;
> +
> +	dp = (struct dirent *)buf;
> +	kdp = (struct kernel_dirent64 *)kbuf;
> +	while ((char *)kdp < kbuf + retval) {
> +		const size_t alignment = __alignof__(struct dirent);
> +		/* Since kdp->d_reclen is already aligned for the kernel
> +		   structure this may compute a value that is bigger
> +		   than necessary.  */
> +		size_t old_reclen = kdp->d_reclen;
> +		size_t new_reclen = ((old_reclen - size_diff + alignment - 1)
> +				     & ~(alignment - 1));
> +		uint64_t d_ino = kdp->d_ino;
> +		int64_t d_off = kdp->d_off;
> +		unsigned char d_type = kdp->d_type;
> +
> +		dp->d_ino = d_ino;
> +		dp->d_off = d_off;
> +		if ((sizeof(dp->d_ino) != sizeof(kdp->d_ino))
> +		    || (sizeof(dp->d_off) != sizeof(kdp->d_off))) {

Hmm. We check the d_ino/d_off sizes above use that as part of the logic
to drop into this conversion loop, which suggests this alone should not
be a problem. If I read this right, we'd still want the dp->d_ino !=
d_ino and similar for d_off checks here to determine whether we did in
fact overflow one of those values..?

One final thought on the style fixes... it might be nice to push the
logical operators and whatnot to the end of the line rather than the
start of the subsequent. If you feel like it of course. I don't want to
be too picky about this code. ;)

Brian

> +			/* Overflow.  If there was at least one entry
> +			   before this one, return them without error,
> +			   otherwise signal overflow.  */
> +			if (last_offset != -1) {
> +				lseek64(fd, last_offset, SEEK_SET);
> +				return (char *)dp - buf;
> +			}
> +			errno = EOVERFLOW;
> +			return -1;
>  		}
>  
> -	      last_offset = d_off;
> -	      dp->d_reclen = new_reclen;
> -	      dp->d_type = d_type;
> -	      memmove (dp->d_name, kdp->d_name,
> -		       old_reclen - offsetof (struct kernel_dirent64, d_name));
> +		last_offset = d_off;
> +		dp->d_reclen = new_reclen;
> +		dp->d_type = d_type;
> +		memmove(dp->d_name, kdp->d_name,
> +			old_reclen - offsetof(struct kernel_dirent64, d_name));
>  
> -	      dp = (struct dirent *) ((char *) dp + new_reclen);
> -	      kdp = (struct kernel_dirent64 *) ((char *) kdp + old_reclen);
> -	    }
> -
> -	  return (char *) dp - buf;
> +		dp = (struct dirent *)((char *)dp + new_reclen);
> +		kdp = (struct kernel_dirent64 *)((char *)kdp + old_reclen);
>  	}
>  
> -      __set_errno (saved_errno);
> -      __have_no_getdents64 = 1;
> -    }
> -
> -  /* fallback to getdents */
> -  {
> -    size_t red_nbytes;
> -    struct kernel_dirent *skdp, *kdp;
> -    const size_t size_diff = (offsetof (struct dirent, d_name)
> -			      - offsetof (struct kernel_dirent, d_name));
> -
> -    red_nbytes = MIN (nbytes
> -		      - ((nbytes / (offsetof (struct dirent, d_name) + 14))
> -			 * size_diff),
> -		      nbytes - size_diff);
> -
> -    dp = (struct dirent *) buf;
> -    skdp = kdp = alloca (red_nbytes);
> -
> -    retval = __SYS_GETDENTS(fd, kdp, red_nbytes);
> -    if (retval == -1)
> -      return -1;
> -
> -    while ((char *) kdp < (char *) skdp + retval)
> -      {
> -	const size_t alignment = __alignof__ (struct dirent);
> -	/* Since kdp->d_reclen is already aligned for the kernel structure
> -	   this may compute a value that is bigger than necessary.  */
> -	size_t new_reclen = ((kdp->d_reclen + size_diff + alignment - 1)
> -			     & ~(alignment - 1));
> -	if ((char *) dp + new_reclen > buf + nbytes)
> -	  {
> -	    /* Our heuristic failed.  We read too many entries.  Reset
> -	       the stream.  */
> -	    assert (last_offset != -1);
> -	    lseek64 (fd, last_offset, SEEK_SET);
> -
> -	    if ((char *) dp == buf)
> -	      {
> -		/* The buffer the user passed in is too small to hold even
> -		   one entry.  */
> -		__set_errno (EINVAL);
> -		return -1;
> -	      }
> -
> -	    break;
> -	  }
> -
> -	last_offset = kdp->d_off;
> -	DIRENT_SET_DP_INO(dp, kdp->d_ino);
> -	dp->d_off = kdp->d_off;
> -	dp->d_reclen = new_reclen;
> -	dp->d_type = DT_UNKNOWN;
> -	memcpy (dp->d_name, kdp->d_name,
> -		kdp->d_reclen - offsetof (struct kernel_dirent, d_name));
> -
> -	dp = (struct dirent *) ((char *) dp + new_reclen);
> -	kdp = (struct kernel_dirent *) (((char *) kdp) + kdp->d_reclen);
> -      }
> -    }
> -
> -  return (char *) dp - buf;
> +	return (char *)dp - buf;
>  }
> -- 
> 1.8.5.3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
