Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56486 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757043AbdKQUjK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Nov 2017 15:39:10 -0500
Subject: Re: [xfsprogs PATCH 2/2] xfs_io: add a new 'log_writes' command
References: <20171117202524.24696-1-ross.zwisler@linux.intel.com>
 <20171117202524.24696-3-ross.zwisler@linux.intel.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <84006b9c-90db-7eea-0bdc-b73da1bb1394@sandeen.net>
Date: Fri, 17 Nov 2017 14:39:07 -0600
MIME-Version: 1.0
In-Reply-To: <20171117202524.24696-3-ross.zwisler@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-xfs <linux-xfs@vger.kernel.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, fstests <fstests@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>

On 11/17/17 2:25 PM, Ross Zwisler wrote:
> Add a new 'log_writes' command to xfs_io so that we can add dm-log-writes
> log marks via the external 'dmsetup' executable.  It's helpful to allow
> users of xfs_io to adds these marks from within xfs_io instead of waiting
> until after xfs_io exits because then they are able to replay the
> dm-log-writes log up to immediately after another xfs_io operation such as
> mwrite.  This isolates the log replay from other operations that happen as
> part of xfs_io exiting (file handles being closed, mmaps being torn down,
> etc.).  This also allows users to insert multiple marks between different
> xfs_io commands.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Dave Chinner <david@fromorbit.com>

Without reviewing in detail, what is the advantage of wrapping dmsetup
into xfs_io?  My first inclination is that there is none at all, and
xfstests can call dmsetup as easily as they can call xfs_io.  No?

-Eric
