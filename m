Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47082 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbcI3Hvm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:51:42 -0400
Date: Fri, 30 Sep 2016 00:51:41 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 42/63] xfs: add clone file and clone range vfs functions
Message-ID: <20160930075141.GC17618@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520501393.29434.5617758777691039165.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520501393.29434.5617758777691039165.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 29, 2016 at 08:10:14PM -0700, Darrick J. Wong wrote:
> Define two VFS functions which allow userspace to reflink a range of
> blocks between two files or to reflink one file's contents to another.
> These functions fit the new VFS ioctls that standardize the checking
> for the btrfs CLONE and CLONE RANGE ioctls.

FYI, I really believe the way forward is to make sure vfs_copy_range
calls the clone handler first if present and handles all the differences
between the two.  The only thing that held me back from doing that
is the complete lack of test coverage for the copy functionality.

Otherwise this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
