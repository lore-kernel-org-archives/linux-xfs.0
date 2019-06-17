Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39436 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfFQSWc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jun 2019 14:22:32 -0400
Date: Mon, 17 Jun 2019 11:22:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_info: limit findmnt to find mounted xfs filesystems
Message-ID: <20190617182226.GM3773859@magnolia>
References: <20190617095447.3748-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617095447.3748-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Mon, Jun 17, 2019 at 12:54:47PM +0300, Amir Goldstein wrote:
> When running xfstests with -overlay, the xfs mount point
> (a.k.a $OVL_BASE_SCRATCH_MNT) is used as the $SCRATCH_DEV argument
> to the overlay mount, like this:
> 
> /dev/vdf /vdf xfs rw,relatime,attr2,inode64,noquota 0 0
> /vdf /vdf/ovl-mnt overlay rw,lowerdir=/vdf/lower,upperdir=/vdf/upper...
> 
> Ever since commit bbb43745, when xfs_info started using findmnt,
> when calling the helper `_supports_filetype /vdf` it returns false,
> and reports: "/vdf/ovl-mnt: Not on a mounted XFS filesystem".
> 
> Fix this ambiguity by preferring to query a mounted XFS filesystem,
> if one can be found.
> 
> Fixes: bbb43745 ("xfs_info: use findmnt to handle mounted block devices")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Looks good to me, so long as findmnt /has/ a -t option in, uh, whatever
enterprise distro(s) for which the xfsprogs maintainer might be a
stakeholder. :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> Eric,
> 
> FYI, I don't *need* to fix xfs_info in order to fix xfstests
> and I do plan to send an independent fix to xfstests, but this
> seems like a correct fix regardless of the specific xfstests
> regression.
> 
> Thanks,
> Amir.
> 
>  spaceman/xfs_info.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/spaceman/xfs_info.sh b/spaceman/xfs_info.sh
> index 1bf6d2c3..3b10dc14 100755
> --- a/spaceman/xfs_info.sh
> +++ b/spaceman/xfs_info.sh
> @@ -40,7 +40,7 @@ case $# in
>  
>  		# If we find a mountpoint for the device, do a live query;
>  		# otherwise try reading the fs with xfs_db.
> -		if mountpt="$(findmnt -f -n -o TARGET "${arg}" 2> /dev/null)"; then
> +		if mountpt="$(findmnt -t xfs -f -n -o TARGET "${arg}" 2> /dev/null)"; then
>  			xfs_spaceman -p xfs_info -c "info" $OPTS "${mountpt}"
>  			status=$?
>  		else
> -- 
> 2.17.1
> 
