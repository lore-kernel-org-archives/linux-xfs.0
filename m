Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 07:51:01 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l54EosWt023117
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 07:50:58 -0700
Date: Mon, 4 Jun 2007 15:50:54 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review - writing to multiple non-contiguous unwritten extents within a page is broken.
Message-ID: <20070604145054.GA28033@infradead.org>
References: <20070523092103.GT85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523092103.GT85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, May 23, 2007 at 07:21:03PM +1000, David Chinner wrote:
> Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-05-23 16:33:04.000000000 +1000
> +++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c	2007-05-23 17:52:15.540456674 +1000
> @@ -1008,6 +1008,8 @@ xfs_page_state_convert(
>  		if (buffer_unwritten(bh) || buffer_delay(bh) ||
>  		    ((buffer_uptodate(bh) || PageUptodate(page)) &&
>  		     !buffer_mapped(bh) && (unmapped || startio))) {
> +			int new_ioend = 0;
> +
>  			/*
>  			 * Make sure we don't use a read-only iomap
>  			 */
> @@ -1026,6 +1028,15 @@ xfs_page_state_convert(
>  			}
>  
>  			if (!iomap_valid) {
> +				/*
> +				 * if we didn't have a valid mapping then we
> +				 * need to ensure that we put the new mapping
> +				 * in a new ioend structure. This needs to be
> +				 * done to ensure that the ioends correctly
> +				 * reflect the block mappings at io completion
> +				 * for unwritten extent conversion.
> +				 */
> +				new_ioend = 1;
>  				if (type == IOMAP_NEW) {
>  					size = xfs_probe_cluster(inode,
>  							page, bh, head, 0);
> @@ -1045,7 +1056,7 @@ xfs_page_state_convert(
>  				if (startio) {
>  					xfs_add_to_ioend(inode, bh, offset,
>  							type, &ioend,
> -							!iomap_valid);
> +							new_ioend);

Looks good.  I'm pretty sure that we had something like a new_ioend variable
in the initial versions of this code, but I don't know when and why we
got rid of it.
