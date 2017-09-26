Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45066 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965047AbdIZRQk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Sep 2017 13:16:40 -0400
Date: Tue, 26 Sep 2017 11:16:38 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 2/7] xfs: validate bdev support for DAX inode flag
Message-ID: <20170926171638.GA20159@linux.intel.com>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-3-ross.zwisler@linux.intel.com>
 <20170926063650.GE6870@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170926063650.GE6870@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, "J. Bruce Fields" <bfields@fieldses.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Tue, Sep 26, 2017 at 08:36:50AM +0200, Christoph Hellwig wrote:
> On Mon, Sep 25, 2017 at 05:13:59PM -0600, Ross Zwisler wrote:
> > Currently only the blocksize is checked, but we should really be calling
> > bdev_dax_supported() which also tests to make sure we can get a
> > struct dax_device and that the dax_direct_access() path is working.
> > 
> > This is the same check that we do for the "-o dax" mount option in
> > xfs_fs_fill_super().
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> I think we just want to pick this up ASAP.  And between my vague
> memoried and that reviewed-by tag it already was part of a different
> series, wasn't it?

Yep, the first 2 patches were part of this series:

https://lkml.org/lkml/2017/9/7/552

which you reviewed.  I included them in this series because the later patches
needed to build on them.  It looks like they are now in Darrick's
xfs-4.14-fixes branch, but haven't yet made it upstream.
