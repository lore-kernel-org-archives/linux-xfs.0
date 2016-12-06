Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36438 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752483AbcLFQbK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Dec 2016 11:31:10 -0500
Date: Wed, 7 Dec 2016 00:31:08 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [BUG] xfs/109 crashed 2k block size reflink enabled XFS
Message-ID: <20161206163108.GZ29149@eguan.usersys.redhat.com>
References: <20161205092112.GS29149@eguan.usersys.redhat.com>
 <20161206134847.GA10181@infradead.org>
 <20161206152409.GY29149@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161206152409.GY29149@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 06, 2016 at 11:24:09PM +0800, Eryu Guan wrote:
> On Tue, Dec 06, 2016 at 05:48:47AM -0800, Christoph Hellwig wrote:
> > Hi Eryu,
> > 
> > my attempts at reproducing this are still not very reliable, someimes
> > it takes three iterations, sometimes it's doing fine for 100+.
> > 
> > Can you try reverting commit 0af32fb46 ("xfs: fix bogus space
> > reservation in xfs_iomap_write_allocate") and give this a spin on your
> > test setup?  I wonder if somehow our accounting for the case where
> 
> Sure, test is running now.

XFS with this patch reverted still crashes in the same way, at the 36th
iteration this time.

Thanks,
Eryu
