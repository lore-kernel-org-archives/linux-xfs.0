Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 860F67F83
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 05:45:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6693B8F8050
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 03:45:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id E3jKhkRJs44Qq18s (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 03:45:39 -0700 (PDT)
Date: Thu, 3 Sep 2015 06:45:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix null pointer dereference when mapping is NULL
Message-ID: <20150903104537.GA46225@bfoster.bfoster>
References: <1441274260-10120-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1441274260-10120-1-git-send-email-colin.king@canonical.com>
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
To: Colin King <colin.king@canonical.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Sep 03, 2015 at 10:57:40AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> xfs_vm_set_page_dirty checks to see if mapping is NULL however
> before this unlikely check it already dereferenced mapping when
> initializing inode. Move the inode initialization after the mapping
> null check to avoid a potential null pointer dereference.
> 
> Fixes: 22e757a49cf0 ("xfs: don't dirty buffers beyond EOF")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_aops.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index c77499b..d15ae85 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1935,7 +1935,7 @@ xfs_vm_set_page_dirty(
>  	struct page		*page)
>  {
>  	struct address_space	*mapping = page->mapping;
> -	struct inode		*inode = mapping->host;
> +	struct inode		*inode;
>  	loff_t			end_offset;
>  	loff_t			offset;
>  	int			newly_dirty;
> @@ -1944,6 +1944,7 @@ xfs_vm_set_page_dirty(
>  	if (unlikely(!mapping))
>  		return !TestSetPageDirty(page);
>  
> +	inode = mapping->host;
>  	end_offset = i_size_read(inode);
>  	offset = page_offset(page);
>  
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
