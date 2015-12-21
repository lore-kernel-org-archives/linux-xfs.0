Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0C1C87F37
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 11:32:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A005DAC002
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 09:32:08 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id BsdSPvm6hAM6dean (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Dec 2015 09:32:05 -0800 (PST)
Date: Mon, 21 Dec 2015 18:32:02 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 5/7] ext2: call dax_pfn_mkwrite() for DAX fsync/msync
Message-ID: <20151221173202.GB7030@quack.suse.cz>
References: <1450502540-8744-1-git-send-email-ross.zwisler@linux.intel.com>
	<1450502540-8744-6-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1450502540-8744-6-git-send-email-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Fri 18-12-15 22:22:18, Ross Zwisler wrote:
> To properly support the new DAX fsync/msync infrastructure filesystems
> need to call dax_pfn_mkwrite() so that DAX can track when user pages are
> dirtied.

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  fs/ext2/file.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/file.c b/fs/ext2/file.c
> index 11a42c5..2c88d68 100644
> --- a/fs/ext2/file.c
> +++ b/fs/ext2/file.c
> @@ -102,8 +102,8 @@ static int ext2_dax_pfn_mkwrite(struct vm_area_struct *vma,
>  {
>  	struct inode *inode = file_inode(vma->vm_file);
>  	struct ext2_inode_info *ei = EXT2_I(inode);
> -	int ret = VM_FAULT_NOPAGE;
>  	loff_t size;
> +	int ret;
>  
>  	sb_start_pagefault(inode->i_sb);
>  	file_update_time(vma->vm_file);
> @@ -113,6 +113,8 @@ static int ext2_dax_pfn_mkwrite(struct vm_area_struct *vma,
>  	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
>  	if (vmf->pgoff >= size)
>  		ret = VM_FAULT_SIGBUS;
> +	else
> +		ret = dax_pfn_mkwrite(vma, vmf);
>  
>  	up_read(&ei->dax_sem);
>  	sb_end_pagefault(inode->i_sb);
> -- 
> 2.5.0
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
