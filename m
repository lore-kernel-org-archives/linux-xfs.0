Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34483 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751267AbdEDLyK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 07:54:10 -0400
Date: Thu, 4 May 2017 04:54:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: handle large CoW remapping requests
Message-ID: <20170504115409.GA22052@infradead.org>
References: <20170427212754.GB19158@birch.djwong.org>
 <20170502075021.GA7916@infradead.org>
 <20170502180220.GA5973@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170502180220.GA5973@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>

On Tue, May 02, 2017 at 11:02:20AM -0700, Darrick J. Wong wrote:
> Nowhere, at the moment.  I had O_ATOMIC in mind for this though, since
> it'll call end_cow on the entire file at fsync time.  What if you've
> written 8GB to a file that you've opened with ATOMIC and then fsync it?
> That would trigger a remap longer than MAX_RW_COUNT which will blow the
> assert, right?

Yeah, good point.

> The current remapping mechanism only guarantees that whatever little
> part of the data fork we've bunmapi'd for each cow fork extent will also
> get remapped.  There isn't anything in there that guarantees a remap of
> the parts we haven't touched yet.  If one CoW fork extent maps to 2000
> data fork extents, we'll atomically remap each of the 2000 extents.  If
> we fail at extent 900, the remaining 1100 extents are fed to the CoW
> cleanup at the next mount time.  This patch doesn't try to change that
> behavior.

And that's perfectly fine, as long as we ensure after the mount time
cleanup everything is either remapped or not.

> Second half-baked idea: play games with a shadow inode -- allocate an
> unlinked inode, persist all the written CoW fork extents to the shadow
> inode, and reflink the extents from the shadow to the original inode.
> If we crash then we can just re-reflink everything in the shadow inode.

That was actually my very first implementation before reflink, and
using a swapext variant instead of reflinks.  Maybe it's actually better
in the end.
