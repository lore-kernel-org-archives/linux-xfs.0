Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38840 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726979AbeHHLMZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Aug 2018 07:12:25 -0400
Date: Wed, 8 Aug 2018 10:53:39 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] [PATCH] xfs: Close race between direct IO and
 xfs_break_layouts()
Message-ID: <20180808085339.GD15413@quack2.suse.cz>
References: <153367989755.37314.6889218648604435494.stgit@djiang5-desk3.ch.intel.com>
 <153367990333.37314.16218849614019392916.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153367990333.37314.16218849614019392916.stgit@djiang5-desk3.ch.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Jiang <dave.jiang@intel.com>
Cc: tytso@mit.edu, darrick.wong@oracle.com, jack@suse.cz, zwisler@kernel.org, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, lczerner@redhat.com, linux-ext4@vger.kernel.org, hch@lst.de

On Tue 07-08-18 15:11:43, Dave Jiang wrote:
> This patch is the duplicate of ross's fix for ext4 for xfs.
> 
> If the refcount of a page is lowered between the time that it is returned
> by dax_busy_page() and when the refcount is again checked in
> xfs_break_layouts() => ___wait_var_event(), the waiting function
> xfs_wait_dax_page() will never be called.  This means that
> xfs_break_layouts() will still have 'retry' set to false, so we'll stop
> looping and never check the refcount of other pages in this inode.
> 
> Instead, always continue looping as long as dax_layout_busy_page() gives us
> a page which it found with an elevated refcount.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

Just one minor nit below:

> @@ -746,9 +744,10 @@ xfs_break_dax_layouts(
>  	if (!page)
>  		return 0;
>  
> +	*did_unlock = true;

I think it would be more understandable to name the argument of
xfs_break_dax_layouts() as 'retry' instead of 'did_unlock' as it's not
about unlocking anymore.

							Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
