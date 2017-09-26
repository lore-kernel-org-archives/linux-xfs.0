Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:63294 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030980AbdIZRa7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Sep 2017 13:30:59 -0400
Date: Tue, 26 Sep 2017 11:30:57 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/7] xfs: always use DAX if mount option is used
Message-ID: <20170926173057.GB20159@linux.intel.com>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-2-ross.zwisler@linux.intel.com>
 <20170925233812.GM10955@dastard>
 <20170926093548.GB13627@quack2.suse.cz>
 <20170926110957.GR10955@dastard>
 <20170926143743.GB18758@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170926143743.GB18758@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, "J. Bruce Fields" <bfields@fieldses.org>, Dan Williams <dan.j.williams@intel.com>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Tue, Sep 26, 2017 at 04:37:43PM +0200, Christoph Hellwig wrote:
> On Tue, Sep 26, 2017 at 09:09:57PM +1000, Dave Chinner wrote:
> > Well, quite frankly, I never wanted the mount option for XFS. It was
> > supposed to be for initial testing only, then we'd /always/ use the
> > the inode flags. For a filesystem to default to using DAX, we
> > set the DAX flag on the root inode at mkfs time, and then everything
> > inode flag based just works.
> 
> And I deeply fundamentally disagree.  The mount option is a nice
> enough big hammer to try a mode without encoding nitty gritty details
> into the application ABI.
> 
> The per-inode persistent flag is the biggest nightmare ever, as we see
> in all these discussions about it.
> 
> What does it even mean?  Right now it forces direct addressing as long
> as the underlying media supports that.  But what about media that
> you directly access but you really don't want to because it's really slow?
> Or media that is so god damn fast that you never want to buffer?  Or
> media where you want to buffer for writes (or at least some of them)
> but not for reads?
> 
> It encodes a very specific mechanism for an early direct access
> implementation into the ABI.  What we really need is for applications
> to declare an intent, not specify a particular mechanism.

I agree that Christoph's idea about having the system intelligently adjust to
use DAX based on performance information it gathers about the underlying
persistent memory (probably via the HMAT on x86_64 systems) is interesting,
but I think we're still a ways away from that.

FWIW, as my patches suggest and Jan observed I think that we should allow
users to turn on DAX by treating the inode flag and the mount flag as an 'or'
operation.  i.e. you get DAX if either the mount option is specified or if the
inode flag is set, and you can continue to manipulate the per-inode flag as
you want regardless of the mount option.  I think this provides maximum
flexibility of the mechanism to select DAX without enforcing policy.

In the end, though, I think what's really important is that we figure out what
the various options mean, have the same story for both XFS and ext4, and
document it as hch suggested in response to my patch 7 in this series.

Does it make sense at this point to just start a "dax" man page that can
contain info about the mount options, inode flags, kernel config options, how
to get PMDs, etc?  Or does this documentation need to be sprinkled around more
in existing man pages?
