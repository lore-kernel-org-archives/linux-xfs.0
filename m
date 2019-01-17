Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47880 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfAQXgR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 18:36:17 -0500
Date: Thu, 17 Jan 2019 15:36:08 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 00/13] xfs: metadata inode directories
Message-ID: <20190117233608.GL4424@magnolia>
References: <154630934595.21716.17416691804044507782.stgit@magnolia>
 <20190117142636.GH16270@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117142636.GH16270@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 17, 2019 at 06:26:36AM -0800, Christoph Hellwig wrote:
> On Mon, Dec 31, 2018 at 06:22:26PM -0800, Darrick J. Wong wrote:
> > Hi all,
> > 
> > This series delivers a new feature -- metadata inode directories.  This
> > is a separate directory tree (rooted in the superblock) that contains
> > only inodes that contain filesystem metadata.  Different metadata
> > objects can be looked up with regular paths.
> 
> If we use path names we should just use regular VFS path lookup for
> them.

I'll research how to do that, since I'm not /that/ familiar with how to
create dentries and do path lookups for a fs root that isn't really
rooted anywhere.

> But why do we even need names?  Can't we just work based on inode
> numbers?

How would that work, particularly if we start to create larger metadata
directory trees?  I might just be misreading your question, though.

The reason to take this series (metadir) is so that we can do things
like supporting multiple rt devices:

%meta%/realtime/$device.bitmap
                $device.summary
                $device.rmap
                $device.refcount

For some arbitrary number of realtime devices.  We don't need it to
support the XFS we have right now.

--D
