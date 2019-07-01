Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34540 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbfGAPvv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 11:51:51 -0400
Date: Mon, 1 Jul 2019 08:49:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Adding some trees to linux-next?
Message-ID: <20190701154944.GL1404256@magnolia>
References: <20190701110603.5abcbb2c@canb.auug.org.au>
 <20190701153552.GJ1404256@magnolia>
 <20190702014210.1c95f9f1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702014210.1c95f9f1@canb.auug.org.au>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-xfs@vger.kernel.org, Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Tue, Jul 02, 2019 at 01:42:10AM +1000, Stephen Rothwell wrote:
> Hi Darrick,
> 
> On Mon, 1 Jul 2019 08:35:52 -0700 "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> >
> > Could you add my iomap-for-next and vfs-for-next branches to linux-next,
> > please?  They can be found here:
> > 
> > git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git#iomap-for-next
> > git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git#vfs-for-next
> > 
> > I've decided that trying to munge all that through the xfs for-next
> > branch is too much insanity and splitting them up will help me prevent
> > my head from falling off.
> 
> Just out of interest, do you intend to send these directly to Linus, or
> via another tree?

The iomap stuff I'd definitely send directly to Linus.

For vfs stuff, it depends.  For work in the core vfs I'll probably just
keep sending patches through Al, but for treewide things like ioctl
cleanups I suspect it'll be easier to let them soak in -next and then
send them directly.

I also dropped the f2fs parts of the setflags/fssetxattr patches because
while I think your fix from yesterday's for-next is correct, I prefer to
let Eric Biggers' cleanup land through the f2fs tree before I try to
clean up f2fs again.  There shouldn't be any harm in letting that lag a
little while longer.

--D

> -- 
> Cheers,
> Stephen Rothwell
