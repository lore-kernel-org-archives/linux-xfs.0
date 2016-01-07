Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 83EE47F37
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 06:53:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5E0B28F8040
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 04:53:12 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WYakEVn9o5J9OpDS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Jan 2016 04:53:11 -0800 (PST)
Date: Thu, 7 Jan 2016 07:53:09 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: add tracepoints to readpage calls
Message-ID: <20160107125306.GB33327@bfoster.bfoster>
References: <1452123087-13892-1-git-send-email-david@fromorbit.com>
	<1452123087-13892-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1452123087-13892-2-git-send-email-david@fromorbit.com>
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

On Thu, Jan 07, 2016 at 10:31:26AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This allows us to see page cache driven readahead in action as it
> passes through XFS. This helps to understand buffered read
> throughput problems such as readahead IO IO sizes being too small

Extra "IO" above:			^

> for the underlying device to reach max throughput.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_aops.c  |  2 ++
>  fs/xfs/xfs_trace.h | 26 ++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 29e7e5d..379c089 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1917,6 +1917,7 @@ xfs_vm_readpage(
>  	struct file		*unused,
>  	struct page		*page)
>  {
> +	trace_xfs_vm_readpage(page->mapping->host, 1);
>  	return mpage_readpage(page, xfs_get_blocks);
>  }
>  
> @@ -1927,6 +1928,7 @@ xfs_vm_readpages(
>  	struct list_head	*pages,
>  	unsigned		nr_pages)
>  {
> +	trace_xfs_vm_readpages(mapping->host, nr_pages);
>  	return mpage_readpages(mapping, pages, nr_pages, xfs_get_blocks);
>  }
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 877079eb..391d797 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1222,6 +1222,32 @@ DEFINE_PAGE_EVENT(xfs_writepage);
>  DEFINE_PAGE_EVENT(xfs_releasepage);
>  DEFINE_PAGE_EVENT(xfs_invalidatepage);
>  
> +DECLARE_EVENT_CLASS(xfs_readpage_class,
> +	TP_PROTO(struct inode *inode, int nr_pages),
> +	TP_ARGS(inode, nr_pages),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_ino_t, ino)
> +		__field(int, nr_pages)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = inode->i_sb->s_dev;
> +		__entry->ino = inode->i_ino;
> +		__entry->nr_pages = nr_pages;
> +	),
> +	TP_printk("dev %d:%d ino 0x%llx nr_pages %d",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->ino,
> +		  __entry->nr_pages)
> +)
> +
> +#define DEFINE_READPAGE_EVENT(name)		\
> +DEFINE_EVENT(xfs_readpage_class, name,	\
> +	TP_PROTO(struct inode *inode, int nr_pages), \
> +	TP_ARGS(inode, nr_pages))
> +DEFINE_READPAGE_EVENT(xfs_vm_readpage);
> +DEFINE_READPAGE_EVENT(xfs_vm_readpages);
> +
>  DECLARE_EVENT_CLASS(xfs_imap_class,
>  	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,
>  		 int type, struct xfs_bmbt_irec *irec),
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
