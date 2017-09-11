Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51033 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751065AbdIKIrj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Sep 2017 04:47:39 -0400
Date: Mon, 11 Sep 2017 10:47:33 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/9] add ext4 per-inode DAX flag
Message-ID: <20170911084733.GB7120@quack2.suse.cz>
References: <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
 <20170906170754.GB17663@linux.intel.com>
 <CAPcyv4hfhDT9NFRXL+MT5epiqWHJ0RLraV4P3CZ4EJM6L-s0Nw@mail.gmail.com>
 <20170907211303.GA23212@linux.intel.com>
 <5F58D3F5-D93B-4648-AE01-8A46956FBB4B@dilger.ca>
 <20170907215148.GA12669@linux.intel.com>
 <20170907221201.GZ17782@dastard>
 <20170907221900.GB12669@linux.intel.com>
 <20170907232543.GB17782@dastard>
 <20170908153913.jjhzogjs5zpeea5v@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170908153913.jjhzogjs5zpeea5v@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Andreas Dilger <adilger@dilger.ca>, Dan Williams <dan.j.williams@intel.com>, Eric Sandeen <sandeen@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, xfs <linux-xfs@vger.kernel.org>

On Fri 08-09-17 11:39:13, Ted Tso wrote:
> On Fri, Sep 08, 2017 at 09:25:43AM +1000, Dave Chinner wrote:
> > > Okay, so other ideas (which you have also probably already though of) include:
> > > 
> > > 1) Just return -EBUSY if anyone tries to change the DAX flag of an inode with
> > > open mappings or any open file handles.
> > 
> > You have to have an open fd to change the flag. :)
> 
> What if we only allow the S_DAX flag to be *set*, when i_size and
> i_blocks is zero?  We could also require that only one file descriptor
> be open against the inode, and that it be opened O_RDONLY.

We could do something like that but IMHO it will be a pain to use (e.g.
think how difficult it would be to switch your existing database to use DAX
for data files). We can make transition reliable whenever
inode->i_mapping->i_mmap RB tree is empty (effectively: whenever the file
is not mmaped). And that should be relaxed enough for most usecases... But
I agree that it will be somewhat tricky to prevent creation of new mappings
while we are switching S_DAX flag so it needs more though.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
