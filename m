Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50390 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751082AbdFTQVD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2017 12:21:03 -0400
Date: Tue, 20 Jun 2017 09:20:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't crash on unexpected holes in dir/attr btrees
Message-ID: <20170620162032.GC4740@birch.djwong.org>
References: <20170616175337.GE5421@birch.djwong.org>
 <8076750C-88B9-4E8E-BAFE-332222BCD7C7@jabberwocky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8076750C-88B9-4E8E-BAFE-332222BCD7C7@jabberwocky.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Shaw <dshaw@jabberwocky.com>
Cc: list@jonas-server.de, Emmanuel Florac <eflorac@intellique.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Jun 20, 2017 at 09:01:11AM -0400, David Shaw wrote:
> On Jun 16, 2017, at 1:53 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > Hi all,
> > 
> > So I /think/ the xfs_attr_inactive crashes that both of you have been
> > seeing are a result of XFS assuming that there aren't ever any mapping
> > holes in the extended attribute fork and crashing when it tries to
> > grab a buffer for the hole and fails to notice that holes don't have
> > buffers.  This lightly tested patch gets rid of /that/ problem.
> > 
> > So, if you're willing, can you try this out and see if the crashes go
> > away?  Granted, this might only enable us to lurch on whatever's next...
> 
> I can give this a try.
> 
> Now that you have an idea of what caused the issue, is there some way
> to (easily or not) reproduce it, ideally in userspace?  Part of the
> problem we're having is that we can't reproduce it on a test machine
> so are forced to wait for it to happen in the field under load, where
> it inconveniences users.

I know what caused the crash, but I don't know what caused the hole in
the xattr fork that caused the crash.  It would appear that the xattr
hash tree contains a pointer to an xattr fork offset that is no longer
mapped, but I don't know how we end up with a dangling pointer --
whether this is corruption going on in the attribute fork, or merely a
bug in the routine that tears down the attribute fork and accidentally
tries to delete something twice.

Unfortunately, the metadumps you've both sent me don't seem to contain
any inodes with sparse attribute forks, so evidently something cleaned
up the filesystem before the metadump was taken.

It might help to know a little more about what's going on with the
xattrs that are being attached to those files.  A fair number of the
inodes seem to have extended attributes with 2k values attached.  Does
your workload involve adding and deleting a large number of xattrs?  A
number of large xattrs?  A large number of large xattrs?

That said, if we're tearing down the inode anyway, maybe it doesn't
matter if there's a hole in the map, seeing as the attr_inactive
function already knows how to handle holes and the blocks are all
getting freed anyway.

--D

> 
> David
> 
