Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58658 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfBTO61 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Feb 2019 09:58:27 -0500
Date: Wed, 20 Feb 2019 15:58:25 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 8/8] xfs: introduce an always_cow mode
Message-ID: <20190220145825.GA27724@lst.de>
References: <20190218091827.12619-1-hch@lst.de> <20190218091827.12619-9-hch@lst.de> <20190219052545.GG32253@magnolia> <20190219175358.GH32253@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190219175358.GH32253@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Feb 19, 2019 at 09:53:58AM -0800, Darrick J. Wong wrote:
> xfsrestore tries to RESVSP space for its index file and fails,
> presumably because the vfs intercepts the RESVSP ioctl and calls
> vfs_fallocate.  But then xfsrestore seems to run ALLOCSP, which afaict
> succeeds... ?

s/ALLOCSP/fallocate/ I think.

But not, fallocate on an always_cow inode does not work, because
it can't (modulo the non-persistent delalloc only idea from Dave).

> 
> Two questions:
> 
> - Are you going to mask off xfs_ioc_space from alwayscow inodes like you
>   did for xfs_file_fallocate?

xfs_ioc_space does a few different things:

 - it contains a RESVP implementation that actually is dead code,
   as the VFS takes care of it.
 - it contains a UNRESVSP implementation, this is supported by
   always_cow
 - it contains a ZERO_RANGE implementation, also supported by
   always_cow

So nothing to do there.

> - What are we going to do for xfsrestore if it encounters a filesystem
>   where everything is alwayscow?
> 
> > xfs/205
> 
> "disk full, expected" ?
> 
> /me wonders, since this is an ENOSPC test, why would it fail if we run
> out of space.

As far as I can tell because we run out of space too early due to the
transient double block usage due to the COW writes.
