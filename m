Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58780 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbfF1WZ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 18:25:56 -0400
Date: Fri, 28 Jun 2019 15:25:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix iclog allocation size
Message-ID: <20190628222548.GE1404256@magnolia>
References: <20190627143950.19558-1-hch@lst.de>
 <20190628220253.GF30113@42.do-not-panic.com>
 <20190628221914.GD1404256@magnolia>
 <20190628222310.GL19023@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628222310.GL19023@42.do-not-panic.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com

On Fri, Jun 28, 2019 at 10:23:10PM +0000, Luis Chamberlain wrote:
> On Fri, Jun 28, 2019 at 03:19:14PM -0700, Darrick J. Wong wrote:
> > On Fri, Jun 28, 2019 at 10:02:53PM +0000, Luis Chamberlain wrote:
> > > On Thu, Jun 27, 2019 at 04:39:50PM +0200, Christoph Hellwig wrote:
> > > > Properly allocate the space for the bio_vecs instead of just one byte
> > > > per bio_vec.
> > > > 
> > > > Fixes: 991fc1d2e65e ("xfs: use bios directly to write log buffers")
> > > 
> > > I cannot find 991fc1d2e65e on Linus' tree, nor can I find the subject
> > > name patch on Linus' tree. I'm probably missing some context here?
> > 
> > This patch fixes a bug in for-next. :)
> 
> I figured as much but the commit in question is not even on linux-next
> for today, so I take it that line would be removed from the commit log?

It looks like it is to me...

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=next-20190628&id=991fc1d2e65e381fe8db9038d9a139d45c948f4f

--D

>   Luis
