Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51138 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934116AbcIPNc0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Sep 2016 09:32:26 -0400
Date: Fri, 16 Sep 2016 08:32:22 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH] xfs_quota: fix free command for foreign fs
Message-ID: <20160916133222.GC12342@redhat.com>
References: <4a5fdfec-d1a7-cef6-ba3d-50703dc56d44@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a5fdfec-d1a7-cef6-ba3d-50703dc56d44@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org

On Thu, Sep 15, 2016 at 06:23:58PM -0500, Eric Sandeen wrote:
> The "free" command is really just a fancy df that knows about
> log space and realtime blocks for an xfs filesystem.
> 
> We can simply use statfs to get more or less the same thing
> on a non-xfs filesystem, so, ah, do that I guess, and re-enable
> it.
> 
> # quota/xfs_quota -f -x -c path -c free /mnt/test
>           Filesystem          Pathname
> [000] (F) /mnt/test           /dev/sdb1 (uquota)
> 
> Filesystem           1K-blocks       Used  Available  Use% Pathname
> /dev/sdb1             20511356      45000   20466356    0% /mnt/test
> 
> Fix the short help text for -N while we're at it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
> 
> diff --git a/quota/free.c b/quota/free.c
> index 3c8a5ce..cee15ee 100644
> --- a/quota/free.c
> +++ b/quota/free.c
> @@ -77,34 +77,50 @@ mount_free_space_data(
>  		close(fd);
>  		return 0;
>  	}
> -	if ((xfsctl(mount->fs_dir, fd, XFS_IOC_FSGEOMETRY_V1, &fsgeo)) < 0) {
> -		perror("XFS_IOC_FSGEOMETRY_V1");
> -		close(fd);
> -		return 0;
> -	}
> -	if ((xfsctl(mount->fs_dir, fd, XFS_IOC_FSCOUNTS, &fscounts)) < 0) {
> -		perror("XFS_IOC_FSCOUNTS");
> -		close(fd);
> -		return 0;
> +
> +	if (!(mount->fs_flags & FS_FOREIGN)) {
> +		if ((xfsctl(mount->fs_dir, fd, XFS_IOC_FSGEOMETRY_V1,
> +							&fsgeo)) < 0) {
> +			perror("XFS_IOC_FSGEOMETRY_V1");
> +			close(fd);
> +			return 0;
> +		}
> +		if ((xfsctl(mount->fs_dir, fd, XFS_IOC_FSCOUNTS,
> +							&fscounts)) < 0) {
> +			perror("XFS_IOC_FSCOUNTS");
> +			close(fd);
> +			return 0;
> +		}
> +
> +		logsize = fsgeo.logstart ? fsgeo.logblocks : 0;
> +		count = (fsgeo.datablocks - logsize) * fsgeo.blocksize;
> +		free  = fscounts.freedata * fsgeo.blocksize;
> +		*bcount = BTOBB(count);
> +		*bfree  = BTOBB(free);
> +		*bused  = BTOBB(count - free);
> +
> +		count = fsgeo.rtextents * fsgeo.rtextsize * fsgeo.blocksize;
> +		free  = fscounts.freertx * fsgeo.rtextsize * fsgeo.blocksize;
> +		*rcount = BTOBB(count);
> +		*rfree  = BTOBB(free);
> +		*rused  = BTOBB(count - free);
> +	} else {
> +		count = st.f_blocks * st.f_bsize;
> +		free = st.f_bfree * st.f_bsize;
> +		*bcount = BTOBB(count);
> +		*bfree  = BTOBB(free);
> +		*bused  = BTOBB(count - free);
> +
> +		*rcount = BTOBB(0);
> +		*rfree  = BTOBB(0);
> +		*rused  = BTOBB(0);
>  	}
>  
> -	logsize = fsgeo.logstart ? fsgeo.logblocks : 0;
> -	count = (fsgeo.datablocks - logsize) * fsgeo.blocksize;
> -	free  = fscounts.freedata * fsgeo.blocksize;
> -	*bcount = BTOBB(count);
> -	*bfree  = BTOBB(free);
> -	*bused  = BTOBB(count - free);
>  
>  	*icount = st.f_files;
>  	*ifree  = st.f_ffree;
>  	*iused  = st.f_files - st.f_ffree;
>  
> -	count = fsgeo.rtextents * fsgeo.rtextsize * fsgeo.blocksize;
> -	free  = fscounts.freertx * fsgeo.rtextsize * fsgeo.blocksize;
> -	*rcount = BTOBB(count);
> -	*rfree  = BTOBB(free);
> -	*rused  = BTOBB(count - free);
> -
>  	close(fd);
>  	return 1;
>  }
> @@ -369,9 +385,10 @@ free_init(void)
>  	free_cmd.cfunc = free_f;
>  	free_cmd.argmin = 0;
>  	free_cmd.argmax = -1;
> -	free_cmd.args = _("[-bir] [-hn] [-f file]");
> +	free_cmd.args = _("[-bir] [-hN] [-f file]");
>  	free_cmd.oneline = _("show free and used counts for blocks and inodes");
>  	free_cmd.help = free_help;
> +	free_cmd.flags = CMD_FLAG_FOREIGN_OK;
>  
>  	add_command(&free_cmd);
>  }
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
