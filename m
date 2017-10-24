Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:49067 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750908AbdJXTaZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Oct 2017 15:30:25 -0400
Date: Tue, 24 Oct 2017 13:30:22 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 2/2] dm log writes: add support for DAX
Message-ID: <20171024193022.GA4251@linux.intel.com>
References: <20171020052404.13762-1-ross.zwisler@linux.intel.com>
 <20171020052404.13762-2-ross.zwisler@linux.intel.com>
 <20171024192222.GB22902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171024192222.GB22902@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Josef Bacik <jbacik@fb.com>, Alasdair Kergon <agk@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com, linux-nvdimm@lists.01.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Tue, Oct 24, 2017 at 03:22:23PM -0400, Mike Snitzer wrote:
> On Fri, Oct 20 2017 at  1:24am -0400,
> Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
> 
> > Now that we have the ability log filesystem writes using a flat buffer, add
> > support for DAX.  Unfortunately we can't easily track data that has been
> > written via mmap() now that the dax_flush() abstraction was removed by this
> > commit:
> > 
> > commit c3ca015fab6d ("dax: remove the pmem_dax_ops->flush abstraction")
> > 
> > Otherwise we could just treat each flush as a big write, and store the data
> > that is being synced to media.  It may be worthwhile to add the dax_flush()
> > entry point back, just as a notifier so we can do this logging.
> > 
> > The motivation for this support is the need for an xfstest that can test
> > the new MAP_SYNC DAX flag.  By logging the filesystem activity with
> > dm-log-writes we can show that the MAP_SYNC page faults are writing out
> > their metadata as they happen, instead of requiring an explicit
> > msync/fsync.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> I've picked this up, please see:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-4.15/dm&id=ae613bbb0144e84cb3c0ebfa9f4fd4d1507c2f0e
> 
> I tweaked the header and tweaked a couple whitespace nits.  Also
> switched version bump from 1.0.1 to 1.1.0.
> 
> Thanks,
> Mike

Sure, your tweaks look fine.  Thanks!
