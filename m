Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24897 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968489AbdIZTBz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Sep 2017 15:01:55 -0400
Date: Tue, 26 Sep 2017 13:01:51 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 7/7] xfs: re-enable XFS per-inode DAX
Message-ID: <20170926190151.GC31146@linux.intel.com>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-8-ross.zwisler@linux.intel.com>
 <20170926063611.GD6870@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170926063611.GD6870@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, "J. Bruce Fields" <bfields@fieldses.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Tue, Sep 26, 2017 at 08:36:11AM +0200, Christoph Hellwig wrote:
> On Mon, Sep 25, 2017 at 05:14:04PM -0600, Ross Zwisler wrote:
> > Re-enable the XFS per-inode DAX flag, preventing S_DAX from changing when
> > any mappings are present.
> 
> Before we re-enable it please come up with a coherent description
> of the per-inode DAX flag that makes sense to a user.  We'll also need
> to find a good place to document it, e.g. a new ioctl_setflags man
> page.

I agree that documentation is a great place to start, if we can just agree on
what we want the functionality to be. :)
