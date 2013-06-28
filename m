Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A87AB7F3F
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 11:08:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 46788AC002
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 09:08:08 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id NQvWkApNPvfnb1H8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Jun 2013 09:08:08 -0700 (PDT)
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 28 Jun 2013 10:08:07 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id EFA633E40030
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 10:07:45 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP
	id r5SG83ID099028
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 10:08:03 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5SG80I2019754
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 10:08:01 -0600
Subject: Re: [PATCH 15/15] xfs: implement inode change count
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1372313099-8121-16-git-send-email-david@fromorbit.com>
References: <1372313099-8121-1-git-send-email-david@fromorbit.com>
	<1372313099-8121-16-git-send-email-david@fromorbit.com>
Date: Fri, 28 Jun 2013 11:07:11 -0500
Message-ID: <1372435631.8341.114.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, 2013-06-27 at 16:04 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> For CRC enabled filesystems, add support for the monotonic inode
> version change counter that is needed by protocols like NFSv4 for
> determining if the inode has changed in any way at all between two
> unrelated operations on the inode.
> 
> This bumps the change count the first time an inode is dirtied in a
> transaction. Since all modifications to the inode are logged, this
> will catch all changes that are made to the inode, including
> timestamp updates that occur during data writes.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>

> ---
>  fs/xfs/xfs_super.c       |    4 ++++
>  fs/xfs/xfs_trans_inode.c |   11 +++++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f59e27f..a1587f9 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1482,6 +1482,10 @@ xfs_fs_fill_super(
>  	sb->s_time_gran = 1;
>  	set_posix_acl_flag(sb);
> 
> +	/* version 5 superblocks support inode version counters. */
> +	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
> +		sb->s_flags |= MS_I_VERSION;
> +
>  	error = xfs_mountfs(mp);
>  	if (error)
>  		goto out_filestream_unmount;
> diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
> index ac6d567..53dfe46 100644
> --- a/fs/xfs/xfs_trans_inode.c
> +++ b/fs/xfs/xfs_trans_inode.c
> @@ -112,6 +112,17 @@ xfs_trans_log_inode(
>  	ASSERT(ip->i_itemp != NULL);
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> 
> +	/*
> +	 * First time we log the inode in a transaction, bump the inode change
> +	 * counter if it is configured for this to occur.
> +	 */
> +	if (!(ip->i_itemp->ili_item.li_desc->lid_flags & XFS_LID_DIRTY) &&
> +	    IS_I_VERSION(VFS_I(ip))) {
> +		inode_inc_iversion(VFS_I(ip));
> +		ip->i_d.di_changecount = VFS_I(ip)->i_version;
> +		flags |= XFS_ILOG_CORE;
> +	}
> +
>  	tp->t_flags |= XFS_TRANS_DIRTY;
>  	ip->i_itemp->ili_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
