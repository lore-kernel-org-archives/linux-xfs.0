Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:42606 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751456AbdIGVNO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Sep 2017 17:13:14 -0400
Date: Thu, 7 Sep 2017 15:13:03 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/9] add ext4 per-inode DAX flag
Message-ID: <20170907211303.GA23212@linux.intel.com>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
 <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
 <20170906170754.GB17663@linux.intel.com>
 <CAPcyv4hfhDT9NFRXL+MT5epiqWHJ0RLraV4P3CZ4EJM6L-s0Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hfhDT9NFRXL+MT5epiqWHJ0RLraV4P3CZ4EJM6L-s0Nw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Eric Sandeen <sandeen@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-xfs@vger.kernel.org

On Thu, Sep 07, 2017 at 01:54:45PM -0700, Dan Williams wrote:
> On Wed, Sep 6, 2017 at 10:07 AM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > On Tue, Sep 05, 2017 at 09:12:35PM -0500, Eric Sandeen wrote:
> >> On 9/5/17 5:35 PM, Ross Zwisler wrote:
> >> > The original intent of this series was to add a per-inode DAX flag to ext4
> >> > so that it would be consistent with XFS.  In my travels I found and fixed
> >> > several related issues in both ext4 and XFS.
> >>
> >> Hi Ross -
> >>
> >> hch had a lot of reasons to nuke the dax flag from orbit, and we just
> >> /disabled/ it in xfs due to its habit of crashing the kernel...
> >
> > Ah, sorry, I wasn't CC'd on those threads and missed them.  For any interested
> > bystanders:
> >
> > https://www.spinics.net/lists/linux-ext4/msg57840.html
> > https://www.spinics.net/lists/linux-xfs/msg09831.html
> > https://www.spinics.net/lists/linux-xfs/msg10124.html
> >
> >> so a couple questions:
> >>
> >> 1) does this series pass hch's "test the per-inode DAX flag" fstest?
> >
> > Nope, it has the exact same problems as the XFS per-inode DAX flag.
> >
> >> 2) do we have an agreement that we need this flag at all, or is this
> >>    just a parity item because xfs has^whad a per-inode flag?
> >
> > It was for parity, and because it allows admins finer grained control over
> > their system.  Basically all things discussed in response to Lukas's original
> > patch in the first link above.
> 
> I think it's more than parity. When pmem is slower than page cache it
> is actively harmful to have DAX enabled globally for a filesystem. So,
> not only should we push for per-inode DAX control, we should also push
> to deprecate the mount option. I agree with Christoph that we should
> try to automatically and transparently enable DAX where it makes
> sense, but we also need a finer-grained mechanism than a mount flag to
> force the behavior one way or the other.

Yep, agreed.  I'll play with how to make this work after I've sorted out all
the data corruptions I've found. :)
