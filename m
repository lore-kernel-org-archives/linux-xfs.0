Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:56354 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751642AbdJWReM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2017 13:34:12 -0400
Received: by mail-qk0-f195.google.com with SMTP id l194so22950789qke.13
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2017 10:34:11 -0700 (PDT)
Date: Mon, 23 Oct 2017 13:34:09 -0400
From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 2/2] dm log writes: add support for DAX
Message-ID: <20171023173408.z6gog67bdp5s7jzy@destiny>
References: <20171020052404.13762-1-ross.zwisler@linux.intel.com>
 <20171020052404.13762-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171020052404.13762-2-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Josef Bacik <jbacik@fb.com>, Alasdair Kergon <agk@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com, linux-nvdimm@lists.01.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Thu, Oct 19, 2017 at 11:24:04PM -0600, Ross Zwisler wrote:
> Now that we have the ability log filesystem writes using a flat buffer, add
> support for DAX.  Unfortunately we can't easily track data that has been
> written via mmap() now that the dax_flush() abstraction was removed by this
> commit:
> 
> commit c3ca015fab6d ("dax: remove the pmem_dax_ops->flush abstraction")
> 
> Otherwise we could just treat each flush as a big write, and store the data
> that is being synced to media.  It may be worthwhile to add the dax_flush()
> entry point back, just as a notifier so we can do this logging.
> 
> The motivation for this support is the need for an xfstest that can test
> the new MAP_SYNC DAX flag.  By logging the filesystem activity with
> dm-log-writes we can show that the MAP_SYNC page faults are writing out
> their metadata as they happen, instead of requiring an explicit
> msync/fsync.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---

Ok this is just my ignorance of how DAX works shining through, but do we need a
new flag to indicate this is DAX data?  You are logging it like it's just normal
data going to a certain sector, is that good enough?  If it is then hooray this
looks fine to me, I'm just slightly confused.  Thanks,

Josef
