Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45226 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727501AbfBEOYH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Feb 2019 09:24:07 -0500
Date: Tue, 5 Feb 2019 09:24:04 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 09/10] xfs: add tracepoints for high level iunlink
 operations
Message-ID: <20190205142404.GC51421@bfoster>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930319873.31814.12430374692247625444.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154930319873.31814.12430374692247625444.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 09:59:58AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add tracepoints so we can associate high level operations with low level
> updates.  No functional changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_inode.c |    2 ++
>  fs/xfs/xfs_trace.h |   25 +++++++++++++++++++++++++
>  2 files changed, 27 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index fac9562ecd39..b9696d762c8f 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2023,6 +2023,7 @@ xfs_iunlink(
>  
>  	ASSERT(VFS_I(ip)->i_mode != 0);
>  	pag = xfs_perag_get(mp, agno);
> +	trace_xfs_iunlink(ip);
>  
>  	/* Get the agi buffer first.  It ensures lock ordering on the list. */
>  	error = xfs_read_agi(mp, tp, agno, &agibp);
> @@ -2188,6 +2189,7 @@ xfs_iunlink_remove(
>  	int			error;
>  
>  	pag = xfs_perag_get(mp, agno);
> +	trace_xfs_iunlink_remove(ip);
>  
>  	/* Get the agi buffer first.  It ensures lock ordering on the list. */
>  	error = xfs_read_agi(mp, tp, agno, &agibp);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index fbec8f0e1a9a..a6e384a642b1 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3423,6 +3423,31 @@ TRACE_EVENT(xfs_iunlink_update_dinode,
>  		  __entry->new_ptr)
>  );
>  
> +DECLARE_EVENT_CLASS(xfs_ag_inode_class,
> +	TP_PROTO(struct xfs_inode *ip),
> +	TP_ARGS(ip),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_agnumber_t, agno)
> +		__field(xfs_agino_t, agino)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> +		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
> +		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
> +	),
> +	TP_printk("dev %d:%d agno %u agino %u",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->agno, __entry->agino)
> +)
> +
> +#define DEFINE_AGINODE_EVENT(name) \
> +DEFINE_EVENT(xfs_ag_inode_class, name, \
> +	TP_PROTO(struct xfs_inode *ip), \
> +	TP_ARGS(ip))
> +DEFINE_AGINODE_EVENT(xfs_iunlink);
> +DEFINE_AGINODE_EVENT(xfs_iunlink_remove);
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> 
