Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36778 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727680AbfE3HUc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 May 2019 03:20:32 -0400
Date: Thu, 30 May 2019 15:20:23 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH ] xfs: check for COW overflows in i_delayed_blks
Message-ID: <20190530072023.GR15846@desktop>
References: <155839150599.62947.16097306072591964009.stgit@magnolia>
 <155839151219.62947.9627045046429149685.stgit@magnolia>
 <20190526142735.GP15846@desktop>
 <20190528170132.GA5231@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528170132.GA5231@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, May 28, 2019 at 10:01:32AM -0700, Darrick J. Wong wrote:
> On Sun, May 26, 2019 at 10:27:35PM +0800, Eryu Guan wrote:
> > On Mon, May 20, 2019 at 03:31:52PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > With the new copy on write functionality it's possible to reserve so
> > > much COW space for a file that we end up overflowing i_delayed_blks.
> > > The only user-visible effect of this is to cause totally wrong i_blocks
> > > output in stat, so check for that.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > I hit xfs_db killed by OOM killer (2 vcpu, 8G memory kvm guest) when
> > trying this test and the test takes too long time (I changed the fs size
> > from 300T to 300G and tried a test run), perhaps that's why you don't
> > put it in auto group?
> 
> Oh.  Right.  I forget that I patched out xfs_db from
> check_xfs_filesystem on my dev tree years ago.
> 
> Um... do we want to remove xfs_db from the check function?  Or just open
> code a call to xfs_repair $SCRATCH_MNT/a.img at the end of the test?

If XFS maintainer removes the xfs_check call in _check_xfs_filesystem(),
I'd say I like to see it being removed :)

> 
> As for the 300T size, the reason I picked that is to force the
> filesystem to have large enough AGs to support the maximum cowextsize
> hint.  I'll see if it still works with a 4TB filesystem.

After removeing the xfs_db call, I can finish the test within 20s on the
same test vm, and a.img only takes 159MB space on $SCRATCH_DEV, so I
think 300T fs size is fine.

Thanks,
Eryu
