Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:45845 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751777AbdBIJ5P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2017 04:57:15 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v197sWiX011619
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2017 07:54:32 GMT
Date: Wed, 8 Feb 2017 23:53:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] xfs: allocate direct I/O COW blocks in iomap_begin
Message-ID: <20170209075322.GA6824@birch.djwong.org>
References: <20170206074738.13978-1-hch@lst.de>
 <20170206074738.13978-5-hch@lst.de>
 <20170207014149.GE12378@birch.djwong.org>
 <20170209072107.GA6134@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170209072107.GA6134@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 09, 2017 at 08:21:07AM +0100, Christoph Hellwig wrote:
> On Mon, Feb 06, 2017 at 05:41:49PM -0800, Darrick J. Wong wrote:
> > I'm going to run this series (and all the other stuff I've collected for
> > 4.11) overnight and if nothing screams then you can consider this series:
> 
> Can you push your tree out?  I'd like to verify what made it before
> heading off for a long weekend tonight. I'm especially curious if
> the discard work made it.

It's very late tonight, so all the shiny polish is missing, but here's
what's in my tree for 4.11 right now:
https://git.kernel.org/cgit/fs/xfs/xfs-linux.git/log/?h=xfs-4.11-merge-20170208

Testing isn't done yet, but xfs/222 seems to be blowing up at
ASSERT(!rwsem_is_locked(&inode->i_rwsem)) in xfs_super.c fairly
consistently with blocksize=1k.  I haven't been able to reproduce it
quickly (i.e. without running the whole test suite) so I can't tell if
that's a side effect of something else blowing up or what.  generic/300
seems to blow up periodically and then blows the same assert on umount,
also in the 1k case.  xfs/348 fuzzes the fs, causes "kernel memory
exposure!" BUGs and then asserts with the same i_rwsem thing.
 
The all-defaults 4k blocksize test runs w/ regular disk and pmem all
finished without any new fireworks, though.

(You'll note I didn't merge the duplicate "xfs: improve handling of busy
extents in the low-level allocator"; if you want that done, please let me
know.)

--D
