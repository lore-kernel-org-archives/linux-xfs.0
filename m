Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EF9F97F56
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 10:35:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8A02AAC002
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 08:35:54 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4KxchoInGaGHL0AX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 08:35:53 -0800 (PST)
Date: Tue, 2 Dec 2014 11:35:48 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: Correctly lock inode when removing suid and
	security marks
Message-ID: <20141202163548.GB2113@laptop.bfoster>
References: <1417532489-26580-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1417532489-26580-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Tue, Dec 02, 2014 at 04:01:29PM +0100, Jan Kara wrote:
> Currently XFS calls file_remove_suid() without holding i_mutex. This is
> wrong because that function can end up messing with file permissions and
> security xattrs for which we need i_mutex held.
> 
> Fix the problem by grabbing iolock exclusively when we will need to
> change anything in permissions / xattrs.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

Hi Jan,

This doesn't compile... it looks like we need to include the security.h
header. FWIW, even then I get an undefined symbol error when compiling
as a module (security_inode_need_killpriv() does not appear to be
exported).

Brian

>  fs/xfs/xfs_file.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index eb596b419942..ad6636ac4943 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -521,6 +521,18 @@ restart:
>  	if (error)
>  		return error;
>  
> +	/* For changing security info in file_remove_suid() we need i_mutex */
> +	if (!IS_NOSEC(inode) && *iolock == XFS_IOLOCK_SHARED) {
> +		struct dentry *dentry = file->f_path.dentry;
> +
> +		if (should_remove_suid(dentry) ||
> +		    security_inode_need_killpriv(dentry)) {
> +			xfs_rw_iunlock(ip, *iolock);
> +			*iolock = XFS_IOLOCK_EXCL;
> +			xfs_rw_ilock(ip, *iolock);
> +			goto restart;
> +		}
> +	}
>  	/*
>  	 * If the offset is beyond the size of the file, we need to zero any
>  	 * blocks that fall between the existing EOF and the start of this
> -- 
> 1.8.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
