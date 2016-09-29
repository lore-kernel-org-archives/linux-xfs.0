Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:35596 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934559AbcI2SXk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Sep 2016 14:23:40 -0400
Date: Thu, 29 Sep 2016 12:23:37 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 00/11] re-enable DAX PMD support
Message-ID: <20160929182337.GB20307@linux.intel.com>
References: <1475009282-9818-1-git-send-email-ross.zwisler@linux.intel.com>
 <20160928020842.GA4428@infradead.org>
 <20160928045550.GF27872@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160928045550.GF27872@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@ml01.01.org, linux-xfs@vger.kernel.org

On Wed, Sep 28, 2016 at 02:55:50PM +1000, Dave Chinner wrote:
> On Tue, Sep 27, 2016 at 07:08:42PM -0700, Christoph Hellwig wrote:
> > On Tue, Sep 27, 2016 at 02:47:51PM -0600, Ross Zwisler wrote:
> > > DAX PMDs have been disabled since Jan Kara introduced DAX radix tree based
> > > locking.  This series allows DAX PMDs to participate in the DAX radix tree
> > > based locking scheme so that they can be re-enabled.
> > > 
> > > Jan and Christoph, can you please help review these changes?
> > 
> > About to get on a plane, so it might take a bit to do a real review.
> > In general this looks fine, but I guess the first two ext4 patches
> > should just go straight to Ted independent of the rest?
> > 
> > Also Jan just posted a giant DAX patchbomb, we'll need to find a way
> > to integrate all that work, and maybe prioritize things if we want
> > to get bits into 4.9 still.
> 
> I'm not going to have time to do much review or testing of the DAX
> changes (apart from the cursor comments I've already made) because
> of the huge pile of XFS reflink changes I've got ot get through
> first. However, I've already got the iomap dax bits in the XFS tree
> so I can pull everything through there if review and testing is
> covered otherwise......

Frankly I'd love it if my changes could make it into v4.9 through the XFS
tree.  They've passed xfstests both with and without DAX, and they've passed
all the targeted testing I've been able to throw at them.  If that works, we
can integrate Jan's changes on top of them during the v4.9 cycle and merge for
v4.10.

I'll work on incorporating changes for your feedback, Dave, and hopefully have
a v4 out by the end of the day.
