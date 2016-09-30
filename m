Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25404 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932430AbcI3SFU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 14:05:20 -0400
Date: Fri, 30 Sep 2016 11:04:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 42/63] xfs: add clone file and clone range vfs functions
Message-ID: <20160930180452.GR14092@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520501393.29434.5617758777691039165.stgit@birch.djwong.org>
 <20160930075141.GC17618@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160930075141.GC17618@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Sep 30, 2016 at 12:51:41AM -0700, Christoph Hellwig wrote:
> On Thu, Sep 29, 2016 at 08:10:14PM -0700, Darrick J. Wong wrote:
> > Define two VFS functions which allow userspace to reflink a range of
> > blocks between two files or to reflink one file's contents to another.
> > These functions fit the new VFS ioctls that standardize the checking
> > for the btrfs CLONE and CLONE RANGE ioctls.
> 
> FYI, I really believe the way forward is to make sure vfs_copy_range
> calls the clone handler first if present and handles all the differences
> between the two.  The only thing that held me back from doing that
> is the complete lack of test coverage for the copy functionality.

I've been pondering if there's some way to leverage the existing pile of
clone/clonerange interface tests for copy_file_range without essentially
duplicating all the existing generic/* clone tests, but this time calling
c_f_r instead of _cp_reflink or _reflink_range.  OTOH maybe it's good to
keep them separate since they are separate interfaces.

--D

> 
> Otherwise this looks fine to me:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
