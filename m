Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39872 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727365AbeLRRO1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Dec 2018 12:14:27 -0500
Subject: Re: [PATCH 1/6] xfs: fix symbolic enum printing in ftrace output
References: <154344773243.4341.5458822684407979916.stgit@magnolia>
 <154344773868.4341.11083191144188175339.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <833aab42-5b40-a896-937e-fda7a3cdfa53@sandeen.net>
Date: Tue, 18 Dec 2018 11:14:25 -0600
MIME-Version: 1.0
In-Reply-To: <154344773868.4341.11083191144188175339.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 11/28/18 5:28 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> ftrace's __print_symbolic() has a (very poorly documented) requirement
> that any enum values used in the symbol to string translation table be
> wrapped in a TRACE_DEFINE_ENUM so that the enum value can be encoded in
> the ftrace ring buffer.  Fix this unsatisfied requirement.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_trace.h |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index cabe5c8010b0..dcde4e9907f7 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -640,6 +640,16 @@ DEFINE_INODE_EVENT(xfs_inode_set_cowblocks_tag);
>  DEFINE_INODE_EVENT(xfs_inode_clear_cowblocks_tag);
>  DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
>  
> +/*
> + * ftrace's __print_symbolic requires that all enum values be wrapped in the
> + * TRACE_DEFINE_ENUM macro so that the enum value can be encoded in the ftrace
> + * ring buffer.  Somehow this was only worth mentioning in the ftrace sample
> + * code.
> + */
> +TRACE_DEFINE_ENUM(PE_SIZE_PTE);
> +TRACE_DEFINE_ENUM(PE_SIZE_PMD);
> +TRACE_DEFINE_ENUM(PE_SIZE_PUD);
> +
>  TRACE_EVENT(xfs_filemap_fault,
>  	TP_PROTO(struct xfs_inode *ip, enum page_entry_size pe_size,
>  		 bool write_fault),
> @@ -1208,6 +1218,12 @@ DEFINE_EVENT(xfs_readpage_class, name,	\
>  DEFINE_READPAGE_EVENT(xfs_vm_readpage);
>  DEFINE_READPAGE_EVENT(xfs_vm_readpages);
>  
> +TRACE_DEFINE_ENUM(XFS_IO_HOLE);
> +TRACE_DEFINE_ENUM(XFS_IO_DELALLOC);
> +TRACE_DEFINE_ENUM(XFS_IO_UNWRITTEN);
> +TRACE_DEFINE_ENUM(XFS_IO_OVERWRITE);
> +TRACE_DEFINE_ENUM(XFS_IO_COW);
> +
>  DECLARE_EVENT_CLASS(xfs_imap_class,
>  	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,
>  		 int type, struct xfs_bmbt_irec *irec),
> 
