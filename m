Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5D1667F5F
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 04:23:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3DD318F804B
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 02:23:36 -0700 (PDT)
Received: from mail-wi0-f179.google.com (mail-wi0-f179.google.com
	[209.85.212.179]) by cuda.sgi.com with ESMTP id
	bfK5Br9hhQi28wzp (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 02 Sep 2015 02:23:34 -0700 (PDT)
Received: by wicge5 with SMTP id ge5so33504044wic.0
	for <xfs@oss.sgi.com>; Wed, 02 Sep 2015 02:23:33 -0700 (PDT)
Message-ID: <55E6C013.5050907@plexistor.com>
Date: Wed, 02 Sep 2015 12:23:31 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: add ->pfn_mkwrite support for DAX
References: <1441157100-1658-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1441157100-1658-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: kirill.shutemov@linux.intel.com

On 09/02/2015 04:25 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> ->pfn_mkwrite support is needed so that when a page with allocated
> backing store first takes a write fault the timestamps on the
> file are updated. THis fixes a generic/080 failure.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Boaz Harrosh <boaz@plexistor.com>

I made a patch for this yesterday, but yours is better of-course
I feel guilty because I sent the patch for the pfn_mkwrite thing,
at the time xfs-dax was not yet in, but I forgot all about it when
reviewing the xfs-dax. My bad, sorry.

Thanks Dave
Boaz

> ---
>  fs/xfs/xfs_file.c  | 11 +++++++++++
>  fs/xfs/xfs_trace.h |  1 +
>  2 files changed, 12 insertions(+)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index de2c237..26535ba 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1546,10 +1546,21 @@ xfs_filemap_fault(
>  	return ret;
>  }
>  
> +static int
> +xfs_filemap_pfn_mkwrite(
> +	struct vm_area_struct	*vma,
> +	struct vm_fault		*vmf)
> +{
> +	trace_xfs_filemap_pfn_mkwrite(XFS_I(file_inode(vma->vm_file)));
> +
> +	return dax_pfn_mkwrite(vma, vmf);
> +}
> +
>  static const struct vm_operations_struct xfs_file_vm_ops = {
>  	.fault		= xfs_filemap_fault,
>  	.map_pages	= filemap_map_pages,
>  	.page_mkwrite	= xfs_filemap_page_mkwrite,
> +	.pfn_mkwrite	= xfs_filemap_pfn_mkwrite,
>  };
>  
>  STATIC int
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 8b5432e..63d87f2 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -688,6 +688,7 @@ DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
>  
>  DEFINE_INODE_EVENT(xfs_filemap_fault);
>  DEFINE_INODE_EVENT(xfs_filemap_page_mkwrite);
> +DEFINE_INODE_EVENT(xfs_filemap_pfn_mkwrite);
>  
>  DECLARE_EVENT_CLASS(xfs_iref_class,
>  	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
