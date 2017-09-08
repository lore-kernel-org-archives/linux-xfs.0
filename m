Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58612 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754397AbdIHP2I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Sep 2017 11:28:08 -0400
Date: Fri, 8 Sep 2017 09:28:05 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/2] xfs: always use DAX if mount option is used
Message-ID: <20170908152805.GA16646@linux.intel.com>
References: <20170907210832.17969-1-ross.zwisler@linux.intel.com>
 <20170907210832.17969-2-ross.zwisler@linux.intel.com>
 <20170908072027.GA27725@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170908072027.GA27725@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Sep 08, 2017 at 12:20:28AM -0700, Christoph Hellwig wrote:
> On Thu, Sep 07, 2017 at 03:08:31PM -0600, Ross Zwisler wrote:
> > Before support for the per-inode DAX flag was disabled the XFS the code had
> > an issue where the user couldn't reliably tell whether or not DAX was being
> > used to service page faults and I/O when the DAX mount option was used.  In
> > this case each inode within the mounted filesystem started with S_DAX set
> > due to the mount option, but it could be cleared if someone touched the
> > individual inode flag.
> 
> Looks good, but can you please add a testcase to xfstests for this?

Hmm...aside from looking at tracepoints, I'm not sure how to detect whether or
not S_DAX is actually being used for an inode.  I don't see any other xfstests
that try and look at the trace buffer, but I guess that could work.

Do you know of a better way to detect this test failure/success?

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for the review!
