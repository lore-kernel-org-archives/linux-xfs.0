Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42298 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756510AbdIHPjd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Sep 2017 11:39:33 -0400
Date: Fri, 8 Sep 2017 11:39:13 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/9] add ext4 per-inode DAX flag
Message-ID: <20170908153913.jjhzogjs5zpeea5v@thunk.org>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
 <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
 <20170906170754.GB17663@linux.intel.com>
 <CAPcyv4hfhDT9NFRXL+MT5epiqWHJ0RLraV4P3CZ4EJM6L-s0Nw@mail.gmail.com>
 <20170907211303.GA23212@linux.intel.com>
 <5F58D3F5-D93B-4648-AE01-8A46956FBB4B@dilger.ca>
 <20170907215148.GA12669@linux.intel.com>
 <20170907221201.GZ17782@dastard>
 <20170907221900.GB12669@linux.intel.com>
 <20170907232543.GB17782@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907232543.GB17782@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Andreas Dilger <adilger@dilger.ca>, Dan Williams <dan.j.williams@intel.com>, Eric Sandeen <sandeen@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, xfs <linux-xfs@vger.kernel.org>

On Fri, Sep 08, 2017 at 09:25:43AM +1000, Dave Chinner wrote:
> > Okay, so other ideas (which you have also probably already though of) include:
> > 
> > 1) Just return -EBUSY if anyone tries to change the DAX flag of an inode with
> > open mappings or any open file handles.
> 
> You have to have an open fd to change the flag. :)

What if we only allow the S_DAX flag to be *set*, when i_size and
i_blocks is zero?  We could also require that only one file descriptor
be open against the inode, and that it be opened O_RDONLY.

						- Ted
