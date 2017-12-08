Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39893 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750758AbdLHGgM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Dec 2017 01:36:12 -0500
Date: Fri, 8 Dec 2017 14:36:10 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [fstests PATCH v6 2/2] generic: add test for DAX MAP_SYNC support
Message-ID: <20171208063610.GH2749@eguan.usersys.redhat.com>
References: <20171207103657.GF2749@eguan.usersys.redhat.com>
 <20171207231950.9023-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171207231950.9023-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>, Amir Goldstein <amir73il@gmail.com>

On Thu, Dec 07, 2017 at 04:19:50PM -0700, Ross Zwisler wrote:
> This test creates a file and writes to it via an mmap(), but never syncs
> via fsync/msync.  This process is tracked via dm-log-writes, then replayed.
> 
> If MAP_SYNC is working the dm-log-writes replay will show the test file
> with 1 MiB of on-media block allocations.  This is because each allocating
> page fault included an implicit metadata sync.  If MAP_SYNC isn't working
> (which you can test by removing the "-S" flag to xfs_io mmap) the file
> will be smaller or missing entirely.
> 
> Note that dm-log-writes doesn't track the data that we write via the
> mmap(), so we can't do any data integrity checking.  We can only verify
> that the metadata writes for the page faults happened.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> ---
> 
> Changes since v5:
>  - Addressed Eryu's comments.  Thanks for the review.

Thanks for the explanation on the dm-log-writes dax support! I agree
that we should keep _require_log_writes_dax for now till dm-log-writes
gains full dax support. I added some comments about this above the
helper definition and queued the patchset for next fstests update. (Test
was re-numbered as generic/470, BTW.)

Thanks,
Eryu
