Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43234 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbfAXCEr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Jan 2019 21:04:47 -0500
Date: Wed, 23 Jan 2019 18:04:35 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/22] xfs: refactor kernel-specific parts of xfs_ialloc
Message-ID: <20190124020435.GB4368@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
 <154630917828.18437.11659667761358440410.stgit@magnolia>
 <20190117142221.GD16270@infradead.org>
 <20190117232808.GJ4424@magnolia>
 <20190118071708.GB4288@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190118071708.GB4288@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 17, 2019 at 11:17:08PM -0800, Christoph Hellwig wrote:
> On Thu, Jan 17, 2019 at 03:28:08PM -0800, Darrick J. Wong wrote:
> > > This is just too ugly and pointless.  Can you explain (or even better
> > > show code) why we really need this for xfsprogs?
> > 
> > To avoid having a useless lock_flags argument to xfs_iget in userspace?
> > It wasn't so long ago that Eric removed it, but I don't mind adding it
> > back to avoid this kind of ugliness.
> 
> I'd rather have prototypes match in userspace then working around
> mismatches in the kernel.

The other thing about the userspace iget is that you can pass in a
custom set of inode fork verifiers.  xfs_repair uses this to deal with
broken '..' pointers by leaving them unfixed until phase 6, at which
point it knows enough to reset the pointer, but then wants to be able to
iget the directory to fix it.

We could work around that with a libxfs_iget_fork_ops variant so that
xfs_iget remains the same between kernel and userspace.  How about that?

> > The mkfs protofile platform_init also has some code to set other
> > attributes from a struct fsxattr, but I think I can just set them once
> > the inode allocation function returns to the protofile code.
> 
> And we are killing that anyway, right?

Yeah.  I think?  Eric? :)

--D
