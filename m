Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50020 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfE2Sc2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 14:32:28 -0400
Date: Wed, 29 May 2019 11:31:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 07/13] xfs: use file_modified() helper
Message-ID: <20190529183149.GG5231@magnolia>
References: <20190529174318.22424-1-amir73il@gmail.com>
 <20190529174318.22424-8-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529174318.22424-8-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org

On Wed, May 29, 2019 at 08:43:11PM +0300, Amir Goldstein wrote:
> Note that by using the helper, the order of calling file_remove_privs()
> after file_update_mtime() in xfs_file_aio_write_checks() has changed.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/xfs/xfs_file.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 76748255f843..916a35cae5e9 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -367,20 +367,7 @@ xfs_file_aio_write_checks(
>  	 * lock above.  Eventually we should look into a way to avoid
>  	 * the pointless lock roundtrip.
>  	 */
> -	if (likely(!(file->f_mode & FMODE_NOCMTIME))) {

...especially since here we think NOCMTIME is likely /not/ to be set.

> -		error = file_update_time(file);
> -		if (error)
> -			return error;
> -	}
> -
> -	/*
> -	 * If we're writing the file then make sure to clear the setuid and
> -	 * setgid bits if the process is not being run by root.  This keeps
> -	 * people from modifying setuid and setgid binaries.
> -	 */
> -	if (!IS_NOSEC(inode))
> -		return file_remove_privs(file);

Hm, file_modified doesn't have the !IS_NOSEC check guarding
file_remove_privs, are you sure it's ok to remove the suid bits
unconditionally?  Even if SB_NOSEC (and therefore S_NOSEC) are set?

--D

> -	return 0;
> +	return file_modified(file);
>  }
>  
>  static int
> -- 
> 2.17.1
> 
