Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45223 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751660AbdG1JkD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Jul 2017 05:40:03 -0400
Date: Fri, 28 Jul 2017 11:40:01 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/7] dax: Add sync argument to dax_iomap_fault()
Message-ID: <20170728094001.GC29433@quack2.suse.cz>
References: <20170727131245.28279-1-jack@suse.cz>
 <20170727131245.28279-3-jack@suse.cz>
 <20170727220637.GC22000@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170727220637.GC22000@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Andy Lutomirski <luto@kernel.org>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>

On Thu 27-07-17 16:06:37, Ross Zwisler wrote:
> On Thu, Jul 27, 2017 at 03:12:40PM +0200, Jan Kara wrote:
> > Add 'sync' argument to dax_iomap_fault(). It will be used to communicate
> > the fact that synchronous fault is requested.
> 
> I don't actually think you need to pass this 'sync' parameter around.  I think
> you can completely rely on IOMAP_F_NEEDSYNC being set in iomap.flags.  The DAX
> fault handlers can call ops->iomap_begin() and use that flag for all the
> tests and make it our once source of truth.
> 
> That flag also tells us that we are doing a write fault (from
> ext4_iomap_begin()):
> 
> 	if ((flags & IOMAP_FAULT) && (flags & IOMAP_WRITE) && IS_SYNC(inode) &&
> 	    !jbd2_transaction_committed(EXT4_SB(inode->i_sb)->s_journal,
> 					EXT4_I(inode)->i_datasync_tid))
> 		iomap->flags |= IOMAP_F_NEEDDSYNC;
> 
> So conditionals like this from dax_iomap_pte_fault():
> 
> 	force_ro = (vmf->flags & FAULT_FLAG_WRITE) && sync &&
> 			(iomap.flags & IOMAP_F_NEEDDSYNC);
> 
> can be simplified to:
> 
> 	force_ro = (iomap.flags & IOMAP_F_NEEDDSYNC);

Yeah, probably you're right. I'll look into changing this.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
