Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39405 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755026AbdIHHU3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2017 03:20:29 -0400
Date: Fri, 8 Sep 2017 00:20:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: always use DAX if mount option is used
Message-ID: <20170908072027.GA27725@infradead.org>
References: <20170907210832.17969-1-ross.zwisler@linux.intel.com>
 <20170907210832.17969-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907210832.17969-2-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Sep 07, 2017 at 03:08:31PM -0600, Ross Zwisler wrote:
> Before support for the per-inode DAX flag was disabled the XFS the code had
> an issue where the user couldn't reliably tell whether or not DAX was being
> used to service page faults and I/O when the DAX mount option was used.  In
> this case each inode within the mounted filesystem started with S_DAX set
> due to the mount option, but it could be cleared if someone touched the
> individual inode flag.

Looks good, but can you please add a testcase to xfstests for this?

Reviewed-by: Christoph Hellwig <hch@lst.de>
