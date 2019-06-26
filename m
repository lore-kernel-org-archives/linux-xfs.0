Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36515 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfFZDSE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 23:18:04 -0400
Date: Wed, 26 Jun 2019 11:17:57 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] shared/011: run on all file system that support cgroup
 writeback
Message-ID: <20190626031757.GB7943@desktop>
References: <20190624134407.21365-1-hch@lst.de>
 <20190624150839.GB6350@mit.edu>
 <20190624151910.GJ5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624151910.GJ5387@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 08:19:10AM -0700, Darrick J. Wong wrote:
> On Mon, Jun 24, 2019 at 11:08:39AM -0400, Theodore Ts'o wrote:
> > On Mon, Jun 24, 2019 at 03:44:07PM +0200, Christoph Hellwig wrote:
> > > Run the cgroup writeback test on xfs, for which I've just posted
> > > a patch to support cgroup writeback as well as ext2 and f2fs, which
> > > have supported cgroup writeback for a while now.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  tests/shared/011 | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/tests/shared/011 b/tests/shared/011
> > > index a0ac375d..96ce9d1c 100755
> > > --- a/tests/shared/011
> > > +++ b/tests/shared/011
> > > @@ -39,7 +39,7 @@ rm -f $seqres.full
> > >  # real QA test starts here
> > >  
> > >  # Modify as appropriate.
> > > -_supported_fs ext4 btrfs
> > > +_supported_fs ext2 ext4 f2fs btrfs xfs
> > 
> > Per my comments in another e-mail thread, given how many of the
> > primary file systems support cgroup-aware writeback, maybe we should
> > just remove the _supported_fs line and move this test to generic?
> > 
> > Whether we like it or not, there are more and more userspace tools
> > which assume that cgroup-aware writeback is a thing.
> > 
> > Alternatively, maybe we should have some standardized way so the
> > kernel can signal whether or not a particular mounted file system
> > supports cgroup-aware writeback?
> 
> I prefer this second option because I'd rather the test suite do the
> work to figure out if cgroup aware writeback is enabled and therefore
> worth testing rather than making everyone's QA department to add another
> conditional known-failure entry for when they want to run new fstests on
> some old LTS/distro kernel.

Agreed, a standard way to query cgroup-aware writeback support status
would be the best.

Thanks,
Eryu

> 
> --D
> 
> > 						- Ted
