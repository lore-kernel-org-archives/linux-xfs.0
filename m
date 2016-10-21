Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50636 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752338AbcJUDWM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Oct 2016 23:22:12 -0400
Date: Thu, 20 Oct 2016 20:21:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] misc: fix more xfs_db open-coding instances
Message-ID: <20161021032134.GC5257@birch.djwong.org>
References: <147674215521.23842.13841682595738466897.stgit@birch.djwong.org>
 <147674217475.23842.9304657231302422666.stgit@birch.djwong.org>
 <20161020144459.GL27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161020144459.GL27776@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, hch@infradead.org, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org

On Thu, Oct 20, 2016 at 10:44:59PM +0800, Eryu Guan wrote:
> On Mon, Oct 17, 2016 at 03:09:34PM -0700, Darrick J. Wong wrote:
> > Convert some more cases of 'xfs_db $SCRATCH_DEV' to _scratch_xfs_db
> > that were left out of the initial cleanup patch.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  tests/xfs/004 |    2 +-
> >  tests/xfs/007 |    8 ++++----
> >  tests/xfs/021 |    4 ++--
> >  tests/xfs/044 |    2 +-
> >  tests/xfs/052 |    2 +-
> >  tests/xfs/116 |    4 ++--
> >  tests/xfs/136 |    6 +++---
> >  tests/xfs/199 |    6 +++---
> >  tests/xfs/278 |   16 ++++++++--------
> >  tests/xfs/291 |    2 +-
> >  tests/xfs/307 |   20 ++++++++++----------
> >  tests/xfs/308 |   20 ++++++++++----------
> >  12 files changed, 46 insertions(+), 46 deletions(-)
> > 
> > 
> > diff --git a/tests/xfs/004 b/tests/xfs/004
> > index 59b8997..09da2fe 100755
> > --- a/tests/xfs/004
> > +++ b/tests/xfs/004
> > @@ -74,7 +74,7 @@ eval `$DF_PROG $SCRATCH_MNT 2>&1 \
> >  echo "df gave: blocks=$blocks used=$used avail=$avail" >>$seqres.full
> >  echo "blocksize from mkfs is '$dbsize'" >>$seqres.full
> >  
> > -xfs_db -r -c "freesp -s" $SCRATCH_DEV >$tmp.xfs_db
> > +_scratch_xfs_db -r -c "freesp -s"  >$tmp.xfs_db
> >  echo "xfs_db for $SCRATCH_DEV" >>$seqres.full
> >  cat $tmp.xfs_db >>$seqres.full
> >  
> > diff --git a/tests/xfs/007 b/tests/xfs/007
> > index f2e3584..eb2c9b3 100755
> > --- a/tests/xfs/007
> > +++ b/tests/xfs/007
> > @@ -68,8 +68,8 @@ do_test()
> >  			grep $qino_2 | awk '{print $NF}'`
> >  
> >  	echo "*** Usage before quotarm ***"
> > -	xfs_db -c "inode $QINO_1" -c "p core.nblocks" $SCRATCH_DEV
> > -	xfs_db -c "inode $QINO_2" -c "p core.nblocks" $SCRATCH_DEV
> > +	_scratch_xfs_db -c "inode $QINO_1" -c "p core.nblocks" 
> > +	_scratch_xfs_db -c "inode $QINO_2" -c "p core.nblocks" 
> 
> I removed the trailing whitespace at commit time added by above lines
> and some other lines in this patch.

Ok, thank you. :)

--D

> 
> Thanks,
> Eryu
