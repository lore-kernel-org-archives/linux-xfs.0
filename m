Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54953 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752415AbdJPPn7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Oct 2017 11:43:59 -0400
Date: Mon, 16 Oct 2017 17:43:57 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 14/19] dax: Implement dax_finish_sync_fault()
Message-ID: <20171016154357.GK9762@quack2.suse.cz>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-15-jack@suse.cz>
 <20171013072101.GE9105@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171013072101.GE9105@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri 13-10-17 00:21:01, Christoph Hellwig wrote:
> On Wed, Oct 11, 2017 at 10:05:58PM +0200, Jan Kara wrote:
> > Implement a function that filesystems can call to finish handling of
> > synchronous page faults. It takes care of syncing appropriare file range
> > and insertion of page table entry.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Looks fine except for a few nitpicks below:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks! Implemented all your comments.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
