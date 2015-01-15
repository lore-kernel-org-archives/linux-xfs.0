Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5AC7D7F55
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2015 07:28:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4929E8F8066
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2015 05:28:06 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fA1nC2GHrNjxZB19 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Jan 2015 05:28:03 -0800 (PST)
Date: Thu, 15 Jan 2015 08:28:01 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: Remove some useless flags tests
Message-ID: <20150115132800.GB23696@bfoster.bfoster>
References: <1421317085-14350-1-git-send-email-jack@suse.cz>
	<1421317085-14350-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421317085-14350-3-git-send-email-jack@suse.cz>
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

On Thu, Jan 15, 2015 at 11:18:04AM +0100, Jan Kara wrote:
> 'flags' have XFS_ALL_QUOTA_ACCT cleared immediately on function entry.
> There's no point in checking these bits later in the function. Also
> because we check something is going to change, we know some enforcement
> bits are being added and thus there's no point in testing that later.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_qm_syscalls.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index b8a565edb4ae..a8c673dbff32 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -326,22 +326,16 @@ xfs_qm_scall_quotaon(
>  		return -EINVAL;
>  	}
>  
> -	/* No fs can turn on quotas with a delayed effect */
> -	ASSERT((flags & XFS_ALL_QUOTA_ACCT) == 0);
> -
>  	/*
>  	 * Can't enforce without accounting. We check the superblock
>  	 * qflags here instead of m_qflags because rootfs can have
>  	 * quota acct on ondisk without m_qflags' knowing.
>  	 */
> -	if (((flags & XFS_UQUOTA_ACCT) == 0 &&
> -	     (mp->m_sb.sb_qflags & XFS_UQUOTA_ACCT) == 0 &&
> +	if (((mp->m_sb.sb_qflags & XFS_UQUOTA_ACCT) == 0 &&
>  	     (flags & XFS_UQUOTA_ENFD)) ||
> -	    ((flags & XFS_GQUOTA_ACCT) == 0 &&
> -	     (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) == 0 &&
> +	    ((mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) == 0 &&
>  	     (flags & XFS_GQUOTA_ENFD)) ||
> -	    ((flags & XFS_PQUOTA_ACCT) == 0 &&
> -	     (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) == 0 &&
> +	    ((mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) == 0 &&
>  	     (flags & XFS_PQUOTA_ENFD))) {
>  		xfs_debug(mp,
>  			"%s: Can't enforce without acct, flags=%x sbflags=%x",
> @@ -380,8 +374,7 @@ xfs_qm_scall_quotaon(
>  	     ((mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) !=
>  	     (mp->m_qflags & XFS_PQUOTA_ACCT)) ||
>  	     ((mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) !=
> -	     (mp->m_qflags & XFS_GQUOTA_ACCT)) ||
> -	    (flags & XFS_ALL_QUOTA_ENFD) == 0)
> +	     (mp->m_qflags & XFS_GQUOTA_ACCT)))
>  		return 0;
>  
>  	if (! XFS_IS_QUOTA_RUNNING(mp))
> -- 
> 2.1.2
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
