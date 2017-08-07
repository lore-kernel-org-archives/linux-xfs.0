Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:15680 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751371AbdHGAZw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Aug 2017 20:25:52 -0400
Date: Mon, 7 Aug 2017 10:25:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/5] fs, xfs: introduce S_IOMAP_IMMUTABLE
Message-ID: <20170807002502.GI21024@dastard>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150181369070.32119.1019092252036976783.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170805094708.GB14930@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170805094708.GB14930@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, darrick.wong@oracle.com, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>

On Sat, Aug 05, 2017 at 11:47:08AM +0200, Christoph Hellwig wrote:
> NAK^4.
> 
> We should not allow users to create immutable files.  We have
> proper ways to synchronize I/O, and this is just an invitation
> for horrible abuses that should not be allowed, and which we've
> always people told not to do.

We've always told people not to do those "horrible abuses" because
of the TOCTOU race conditions inherent in getting accurate
BMAP/FIEMAP information to userspace. However, immutable extent maps
solve the TOCTOU problem and so removes the only *technical* barrier
in the way of using extent maps to implement functionality such as
userspace pNFS servers.

The core requirement for a userspace pNFS block server to be able to
safely export the block map of a file to remote clients is that the
extent map is allocated and will not change while the client has
been granted access to it. Immutable extent maps provide that
functionality to userspace.  However, for this to work, us
filesystem developers have to give up the idea that only the
filesystem can access the storage underlying the filesystem.

I'm not writing this for your benefit, Christoph, but for everyone
else who doesn't know about existing direct remote storage access
protocols and implementations. That is, I'm letting everyone know
we've already had to give up the exclusive storage device access
model...

.... when you implemented the kernel pNFS server code that provides
unknown third parties with the *remote direct access* to the storage
underlying the XFS filesystem.

Yup, we already allow third parties to arbitrate and directly access
to the XFS block device map. That "horrible abuse" was allowed
because it could be done safely via NFSv4 delegations and a new API
that provided a "blocks will always be allocated before a write and
won't change while the remote client has access" guarantee from XFS
to the kernel pNFS server (i.e. ->map_blocks()/->commit_blocks()
export ops and the break_layouts() API).

Immutable extent maps provide userspace with this same guarantee, so
what used to be considered a "horrible abuse" can now be done safely
and without risking data and/or filesystem corruption.  So, really,
calling this an "invitation to horrible abuses that should not be
allowed" ignores the reality that you were the architect that
introduced this "safe remote direct access" model to convert a
"horrible abuse" into a set of safe, supportable operations.

In the end, all I care about is that everyone understands the
technical merits of the proposals being considered rather than
discussion and review being shut down because "Christoph shouted
nasty words at me but I still don't understand why?".....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
