Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37841 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752789AbcJCJgF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Oct 2016 05:36:05 -0400
Date: Mon, 3 Oct 2016 11:36:03 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 05/12] dax: make 'wait_table' global variable static
Message-ID: <20161003093603.GK6457@quack2.suse.cz>
References: <1475189370-31634-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475189370-31634-6-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475189370-31634-6-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Thu 29-09-16 16:49:23, Ross Zwisler wrote:
> The global 'wait_table' variable is only used within fs/dax.c, and
> generates the following sparse warning:
> 
> fs/dax.c:39:19: warning: symbol 'wait_table' was not declared. Should it be static?
> 
> Make it static so it has scope local to fs/dax.c, and to make sparse happy.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Looks fine. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/dax.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 9b9be8a..ac28cdf 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -52,7 +52,7 @@
>  #define DAX_WAIT_TABLE_BITS 12
>  #define DAX_WAIT_TABLE_ENTRIES (1 << DAX_WAIT_TABLE_BITS)
>  
> -wait_queue_head_t wait_table[DAX_WAIT_TABLE_ENTRIES];
> +static wait_queue_head_t wait_table[DAX_WAIT_TABLE_ENTRIES];
>  
>  static int __init init_dax_wait_table(void)
>  {
> -- 
> 2.7.4
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
