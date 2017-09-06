Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24113 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754275AbdIFRH4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Sep 2017 13:07:56 -0400
Date: Wed, 6 Sep 2017 11:07:54 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/9] add ext4 per-inode DAX flag
Message-ID: <20170906170754.GB17663@linux.intel.com>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
 <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, Lukas Czerner <lczerner@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Tue, Sep 05, 2017 at 09:12:35PM -0500, Eric Sandeen wrote:
> On 9/5/17 5:35 PM, Ross Zwisler wrote:
> > The original intent of this series was to add a per-inode DAX flag to ext4
> > so that it would be consistent with XFS.  In my travels I found and fixed
> > several related issues in both ext4 and XFS.
> 
> Hi Ross -
> 
> hch had a lot of reasons to nuke the dax flag from orbit, and we just
> /disabled/ it in xfs due to its habit of crashing the kernel...

Ah, sorry, I wasn't CC'd on those threads and missed them.  For any interested
bystanders:

https://www.spinics.net/lists/linux-ext4/msg57840.html
https://www.spinics.net/lists/linux-xfs/msg09831.html
https://www.spinics.net/lists/linux-xfs/msg10124.html

> so a couple questions:
> 
> 1) does this series pass hch's "test the per-inode DAX flag" fstest?

Nope, it has the exact same problems as the XFS per-inode DAX flag.

> 2) do we have an agreement that we need this flag at all, or is this
>    just a parity item because xfs has^whad a per-inode flag?

It was for parity, and because it allows admins finer grained control over
their system.  Basically all things discussed in response to Lukas's original
patch in the first link above.

The way this series ended up the first 8 patches were all fixes for the
existing code, and only patch 9 introduced the new per-inode flag.  I'll drop
patch 9 for now and rework the first 8 patches so we can get safer behavior of
the existing DAX mount option in ext4.  We can try patch 9 again later if we
come to an agreement that re-enables the XFS per-inode DAX option.
