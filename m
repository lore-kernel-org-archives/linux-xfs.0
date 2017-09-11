Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38942 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751787AbdIKPQL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Sep 2017 11:16:11 -0400
Date: Mon, 11 Sep 2017 09:16:10 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
Message-ID: <20170911151610.GA5014@linux.intel.com>
References: <20170908152805.GA16646@linux.intel.com>
 <20170908212153.14880-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170908212153.14880-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: fstests@vger.kernel.org, Eryu Guan <eguan@redhat.com>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Sep 08, 2017 at 03:21:53PM -0600, Ross Zwisler wrote:
> This adds a regression test for the following kernel patch:
> 
>   xfs: always use DAX if mount option is used
> 
> This test will also pass with kernel v4.14-rc1 and beyond because the XFS
> DAX I/O mount option has been disabled (but not removed), so the
> "chattr -x" to turn off DAX doesn't actually do anything.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Christoph Hellwig <hch@infradead.org>

<>

> +# disable tracing, clear the existing trace buffer and turn on dax tracepoints
> +echo 0 > /sys/kernel/debug/tracing/tracing_on
> +echo > /sys/kernel/debug/tracing/trace
> +echo 1 > /sys/kernel/debug/tracing/events/fs_dax/enable

I think I can do a better job of:

a) detecting whether debugfs is present, and if not just bail the test as not
run

b) recording the current state of the debugfs (tracing_on, fs_dax/enable),
doing what I need to do, then restoring the previous state.

Before I work on a v2, though, I'd love to get feedback on whether or not
using tracepoints is okay in fstests.
