Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7700 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761424AbdKQUsC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Nov 2017 15:48:02 -0500
Date: Fri, 17 Nov 2017 13:48:01 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [xfsprogs PATCH 2/2] xfs_io: add a new 'log_writes' command
Message-ID: <20171117204801.GA16597@linux.intel.com>
References: <20171117202524.24696-1-ross.zwisler@linux.intel.com>
 <20171117202524.24696-3-ross.zwisler@linux.intel.com>
 <84006b9c-90db-7eea-0bdc-b73da1bb1394@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84006b9c-90db-7eea-0bdc-b73da1bb1394@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, fstests <fstests@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>

On Fri, Nov 17, 2017 at 02:39:07PM -0600, Eric Sandeen wrote:
> On 11/17/17 2:25 PM, Ross Zwisler wrote:
> > Add a new 'log_writes' command to xfs_io so that we can add dm-log-writes
> > log marks via the external 'dmsetup' executable.  It's helpful to allow
> > users of xfs_io to adds these marks from within xfs_io instead of waiting
> > until after xfs_io exits because then they are able to replay the
> > dm-log-writes log up to immediately after another xfs_io operation such as
> > mwrite.  This isolates the log replay from other operations that happen as
> > part of xfs_io exiting (file handles being closed, mmaps being torn down,
> > etc.).  This also allows users to insert multiple marks between different
> > xfs_io commands.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> 
> Without reviewing in detail, what is the advantage of wrapping dmsetup
> into xfs_io?  My first inclination is that there is none at all, and
> xfstests can call dmsetup as easily as they can call xfs_io.  No?
> 
> -Eric

I commented on this a bit in the changelog for the 2nd patch:

It's helpful to allow users of xfs_io to adds these marks from within xfs_io
instead of waiting until after xfs_io exits because then they are able to
replay the dm-log-writes log up to immediately after another xfs_io operation
such as mwrite.  This isolates the log replay from other operations that
happen as part of xfs_io exiting (file handles being closed, mmaps being torn
down, etc.).  This also allows users to insert multiple marks between
different xfs_io commands.

I agree that the shell-out to dmsetup isn't awesome...  For the current test I
have written I think we can get away with just assuming that the xfs_io exit
stuff won't interact too heavily with the dm-log-writes log, and we could
potentially move the dmsetup call back into the fstest.  This is how I
initially had it, and moved it into the C program via shell-out in response to
Amir's feedback:

https://lists.01.org/pipermail/linux-nvdimm/2017-October/012976.html
