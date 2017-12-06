Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:33568 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751894AbdLFEiO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Dec 2017 23:38:14 -0500
Date: Tue, 5 Dec 2017 21:38:13 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [xfsprogs PATCH v2 3/3] xfs_io: add a new 'log_writes' command
Message-ID: <20171206043813.GA31657@linux.intel.com>
References: <20171205235651.17102-1-ross.zwisler@linux.intel.com>
 <20171205235651.17102-4-ross.zwisler@linux.intel.com>
 <20171206002946.GD5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171206002946.GD5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, fstests <fstests@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>

On Wed, Dec 06, 2017 at 11:29:46AM +1100, Dave Chinner wrote:
> On Tue, Dec 05, 2017 at 04:56:51PM -0700, Ross Zwisler wrote:
> > Add a new 'log_writes' command to xfs_io so that we can add dm-log-writes
> > log marks.  It's helpful to allow users of xfs_io to adds these marks from
> > within xfs_io instead of waiting until after xfs_io exits because then they
> > are able to replay the dm-log-writes log up to immediately after another
> > xfs_io operation such as mwrite.  This isolates the log replay from other
> > operations that happen as part of xfs_io exiting (file handles being
> > closed, mmaps being torn down, etc.).  This also allows users to insert
> > multiple marks between different xfs_io commands.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> 
> having just looked at the xfs_io mess, this new command needs to set
> "exitcode = 1" on failure. I haven't looked at anything else in the
> patch.

Ah, yea, I did think it was odd that when hitting errors in xfs_io it always
still returned 0.  I'll fix up for the next version.  Is someone else working
on making the rest of the error cases in xfs_io return 1 as well, or should I
throw that at the front of the series?
