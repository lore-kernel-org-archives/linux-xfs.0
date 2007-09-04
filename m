Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Sep 2007 17:14:49 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l850Ej4p006337
	for <xfs@oss.sgi.com>; Tue, 4 Sep 2007 17:14:48 -0700
Message-ID: <46DDE4A2.1070204@agami.com>
Date: Tue, 04 Sep 2007 16:05:06 -0700
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: [PATCH] log replay should not overwrite newer ondisk inodes
References: <46D6279F.40601@sgi.com>
In-Reply-To: <46D6279F.40601@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Hi,
      Can someone explain how not checking the flushiter can losse 
filesize updates.
Let me the take the case mentioned here in the fix statement:

a. Clustered inode create -  flush iter - X( 0)
b. size update  --> flush iter --> Y

X and Y will always hold as: X <= Y, that is, it is not possible to have 
X >Y (unless size update is non -transactional. As far as I know, size 
update is always transactional.)

There are 2 cases here:
a) log of Y reached to the disk  --> 1) inode with flush iter was 
reached 2) inode didn't make.
b) log of Y didn't reach the disk --> flush_iter Y should have never 
reached disk

In none of cases, I can see the possibility that size update can be lost 
becuase of replaying of the logs in the sequential order. If Log of Y 
didn't reach, does it not make sense to have the flush_iter and size 
correctly set to the last known transaction on the disk. To me, it 
appears unsafe to do as the inode state will not match the state of the 
last known transaction after recovery.

Regards,
Shailendra
Lachlan McIlroy wrote:
> Log replay of clustered inodes currently ignores the flushiter
> field in the inode that is used to determine if the on-disk inode
> is more up to date than the copy in the log.  As a result during
> log replay the newer inode is being overwritten with an older
> version and file size updates are being lost.
>
> I haven't handled the case of the flushiter counter overflowing
> but that shouldn't be a problem in this case.  The log buffer
> contains newly created inodes so their flushiter values will be 0
> and the on-disk inodes should not be much greater.
>
> Lachlan
> ------------------------------------------------------------------------
>
> --- fs/xfs/xfs_log_recover.c_1.322	2007-08-27 17:45:45.000000000 +1000
> +++ fs/xfs/xfs_log_recover.c	2007-08-30 11:50:44.000000000 +1000
> @@ -1866,6 +1866,27 @@ xlog_recover_do_inode_buffer(
>  }
>  
>  /*
> + * Check if we need to recover an inode from a buffer
> + */
> +int
> +xfs_recover_inode(
> +	char	*dest,
> +	char	*src)
> +{
> +	xfs_dinode_t	*dip = (xfs_dinode_t *)dest;
> +	xfs_dinode_t	*dilp = (xfs_dinode_t*)src;
> +
> +	if ((be16_to_cpu(dip->di_core.di_magic) == XFS_DINODE_MAGIC) &&
> +		(be16_to_cpu(dilp->di_core.di_magic) == XFS_DINODE_MAGIC) &&
> +		(be16_to_cpu(dilp->di_core.di_flushiter) <
> +			be16_to_cpu(dip->di_core.di_flushiter))) {
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
>   * Perform a 'normal' buffer recovery.  Each logged region of the
>   * buffer should be copied over the corresponding region in the
>   * given buffer.  The bitmap in the buf log format structure indicates
> @@ -1917,6 +1938,13 @@ xlog_recover_do_reg_buffer(
>  					       -1, 0, XFS_QMOPT_DOWARN,
>  					       "dquot_buf_recover");
>  		}
> +		/*
> +		 * Sanity check if this is an inode buffer.
> +		 */
> +		if (!error)
> +			error = xfs_recover_inode(xfs_buf_offset(bp,
> +					(uint)bit << XFS_BLI_SHIFT),
> +					item->ri_buf[i].i_addr);
>  		if (!error)
>  			memcpy(xfs_buf_offset(bp,
>  				(uint)bit << XFS_BLI_SHIFT),	/* dest */
>   
