Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43882 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726775AbeIKU0a (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Sep 2018 16:26:30 -0400
Date: Tue, 11 Sep 2018 17:26:41 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 1/2] ext4: Close race between direct IO and
 ext4_break_layouts()
Message-ID: <20180911152641.GF6104@quack2.suse.cz>
References: <153374910694.40645.17166196534680658204.stgit@djiang5-desk3.ch.intel.com>
 <e5232336-757e-2338-5b28-7dfadc8eb2c8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5232336-757e-2338-5b28-7dfadc8eb2c8@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: Dave Jiang <dave.jiang@intel.com>, tytso@mit.edu, darrick.wong@oracle.com, jack@suse.cz, zwisler@kernel.org, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, lczerner@redhat.com, linux-ext4@vger.kernel.org, hch@lst.de

On Mon 10-09-18 11:23:56, Eric Sandeen wrote:
> On 8/8/18 12:25 PM, Dave Jiang wrote:
> > From: Ross Zwisler <zwisler@kernel.org>
> > 
> > If the refcount of a page is lowered between the time that it is returned
> > by dax_busy_page() and when the refcount is again checked in
> > ext4_break_layouts() => ___wait_var_event(), the waiting function
> > ext4_wait_dax_page() will never be called.  This means that
> > ext4_break_layouts() will still have 'retry' set to false, so we'll stop
> > looping and never check the refcount of other pages in this inode.
> > 
> > Instead, always continue looping as long as dax_layout_busy_page() gives us
> > a page which it found with an elevated refcount.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Ted - wondering if this one is still on your radar?

Resent the patch to Ted to catch more attention.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
