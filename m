Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:18728 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758095AbcIMWoI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Sep 2016 18:44:08 -0400
Date: Tue, 13 Sep 2016 16:43:57 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 01/10] iomap: add IOMAP_F_NEW flag
Message-ID: <20160913224357.GA26002@linux.intel.com>
References: <1473438884-674-1-git-send-email-hch@lst.de>
 <1473438884-674-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473438884-674-2-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org

On Fri, Sep 09, 2016 at 06:34:35PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Though I guess I've never seen a patch with a completely empty changelog
before?  :)   Maybe it's okay for really easy patches?  I just thought I'd get
shouted down for doing it.

> ---
>  fs/xfs/xfs_iomap.c    | 2 ++
>  include/linux/iomap.h | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index f96c8ff..5d06a2d 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -635,6 +635,7 @@ retry:
>  	if (end_fsb != orig_end_fsb)
>  		xfs_inode_set_eofblocks_tag(ip);
>  
> +	iomap->flags = IOMAP_F_NEW;
>  	trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
>  done:
>  	if (isnullstartblock(got.br_startblock))
> @@ -1000,6 +1001,7 @@ xfs_file_iomap_begin(
>  		if (error)
>  			return error;
>  
> +		iomap->flags = IOMAP_F_NEW;
>  		trace_xfs_iomap_alloc(ip, offset, length, 0, &imap);
>  	} else {
>  		ASSERT(nimaps);
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 3d70ece..14d7067 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -22,6 +22,7 @@ struct vm_fault;
>   * Flags for iomap mappings:
>   */
>  #define IOMAP_F_MERGED	0x01	/* contains multiple blocks/extents */
> +#define IOMAP_F_NEW	0x02	/* blocks have been newly allocated */
>  
>  /*
>   * Magic value for blkno:
> -- 
> 2.1.4
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
