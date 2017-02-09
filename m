Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50950 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751604AbdBIIXf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Feb 2017 03:23:35 -0500
Date: Thu, 9 Feb 2017 09:00:11 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/4] xfs: allocate direct I/O COW blocks in iomap_begin
Message-ID: <20170209080011.GA6628@lst.de>
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
> I'll take a look at the umount assert while you're asleep.  348 is
> a pretty new test, so I doubt it's a regrewssion.
> 
> > (You'll note I didn't merge the duplicate "xfs: improve handling of busy
> > extents in the low-level allocator"; if you want that done, please let me
> > know.)
> 
> Yes, it should be folded into the first patch of that name and descriptions.
> It contains the fixups that Brian requested.

Actually the tree seems to have both now that I'm actually reading
through it.  But if you happen to rebase again please fold the second
into the first.
