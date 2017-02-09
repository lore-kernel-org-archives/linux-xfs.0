Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53456 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752748AbdBIRXZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Feb 2017 12:23:25 -0500
Date: Thu, 9 Feb 2017 18:22:16 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/4] xfs: allocate direct I/O COW blocks in iomap_begin
Message-ID: <20170209172216.GA5382@lst.de>
References: <20170206074738.13978-1-hch@lst.de> <20170206074738.13978-5-hch@lst.de> <20170207014149.GE12378@birch.djwong.org> <20170209072107.GA6134@lst.de> <20170209075322.GA6824@birch.djwong.org> <20170209075841.GA6578@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170209075841.GA6578@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Feb 09, 2017 at 08:58:41AM +0100, Christoph Hellwig wrote:
> On Wed, Feb 08, 2017 at 11:53:22PM -0800, Darrick J. Wong wrote:
> > Testing isn't done yet, but xfs/222 seems to be blowing up at
> > ASSERT(!rwsem_is_locked(&inode->i_rwsem)) in xfs_super.c fairly
> > consistently with blocksize=1k.  I haven't been able to reproduce it
> > quickly (i.e. without running the whole test suite) so I can't tell if
> > that's a side effect of something else blowing up or what.  generic/300
> > seems to blow up periodically and then blows the same assert on umount,
> > also in the 1k case.  xfs/348 fuzzes the fs, causes "kernel memory
> > exposure!" BUGs and then asserts with the same i_rwsem thing.
> 
> I'll take a look at the umount assert while you're asleep.  348 is
> a pretty new test, so I doubt it's a regrewssion.

I could not reproduce the issue here.
