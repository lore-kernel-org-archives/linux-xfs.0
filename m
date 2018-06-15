Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:41183 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965123AbeFOC40 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 22:56:26 -0400
Date: Fri, 15 Jun 2018 10:56:19 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] xfs/170: increase agsize for bigger internal log size
Message-ID: <20180615025619.GG2780@desktop>
References: <20180611091040.31495-1-zlang@redhat.com>
 <20180614153036.GD9432@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180614153036.GD9432@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Jun 14, 2018 at 08:30:36AM -0700, Darrick J. Wong wrote:
> On Mon, Jun 11, 2018 at 05:10:40PM +0800, Zorro Lang wrote:
> > xfs/170 always fails on xfs with "-m rmapbt=1,reflink=1", because
> > XFS need bigger internal log size if rmapbt and reflink are both
> > enabled.
> > 
> > One line of xfs/170 as below:
> > 
> >   _test_streams 8 16 4 8 3 0 0
> > 
> > Refer to common/filestreams, we can see xfs/170 trys to create a
> > 128M XFS (agcount=8, agsize=16M), then each stream writes
> > 24M (8 * 3M files), and there're 4 streams.
> > 
> > So the case expects each stream takes 2 AGs, 4 streams takes
> > different 8 AGs just enough. But internal log will break this
> > balance. For example:
> > 
> > "mkfs.xfs -f -b size=4k -m rmapbt=1,reflink=1 $dev" will take 3075
> > 4k blocks (12M) by default:
> >   meta-data=/dev/mapper/xxxx-xfscratch isize=512    agcount=8, agsize=4096 blks
> >   ...
> >   log      =internal               bsize=4096   blocks=3075, version=2
> >            =                       sectsz=512   sunit=0 blks, lazy-count=1
> >   ...
> > 
> > And the internal log is in the 4th AG:
> >   # xfs_logprint: /dev/mapper/xxxx-xfscratch
> >   xfs_logprint:
> >       data device: 0xfd03
> >       log device: 0xfd03 daddr: 131120 length: 24600
> >   # xfs_db -c "convert daddr 131120 agno" /dev/mapper/xxxx-xfscratch
> >   0x4 (4)
> > 
> > Then if one stream write data into AG-1 at first, then turn to AG-4
> > after fill 16M agsize. But AG-4 has 12M space for log section, so
> > only 4M free space for data. Then this stream have to turn to the
> > next AG after fill the 4M space. All these as below:
> > 
> >   # xfs_bmap -vp stream2-dir/*
> >   stream2-dir/frame-1:
> >    EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> >      0: [0..6143]:       32960..39103      1 (192..6335)       6144 000000
> >   ...
> >   ...
> >   stream2-dir/frame-5:
> >    EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> >      0: [0..6143]:       57536..63679      1 (24768..30911)    6144 000000
> >   stream2-dir/frame-6:
> >    EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> >      0: [0..6143]:       155776..161919    4 (24704..30847)    6144 000000
> >   stream2-dir/frame-7:
> >    EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> >      0: [0..6143]:       170088..176231    5 (6248..12391)     6144 000000
> >   stream2-dir/frame-8:
> >    EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> >      0: [0..6143]:       176232..182375    5 (12392..18535)    6144 000000
> > 
> > Later _test_streams maybe takes AG-5 again, and cause two streams use
> > AG-5. To avoid this failure, increase the agsize from 16M to 22M,
> > others stay the same, each stream still writes 2 AGs. Even internal
> > log takes some space from someone AG, left space should be enough to
> > write (24 - 22)=2M data.
> 
> Looks ok and seems to pass... at least until we bump log size again. :/
> Thank you for fixing this!

Then I take it as an ACK, please let me know if you didn't really mean
that :)

Thanks,
Eryu

> 
> --D
> 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> >  tests/xfs/170     | 9 ++++-----
> >  tests/xfs/170.out | 8 ++++----
> >  2 files changed, 8 insertions(+), 9 deletions(-)
> > 
> > diff --git a/tests/xfs/170 b/tests/xfs/170
> > index f82df69d..eb26764a 100755
> > --- a/tests/xfs/170
> > +++ b/tests/xfs/170
> > @@ -42,11 +42,10 @@ _check_filestreams_support || _notrun "filestreams not available"
> >  _set_stream_timeout_centisecs 3000
> >  
> >  # test streams does a mkfs and mount
> > -_test_streams 8 16 4 8 3 0 0
> > -_test_streams 8 16 4 8 3 1 0
> > -_test_streams 8 16 4 8 3 0 1
> > -_test_streams 8 16 4 8 3 1 1
> > +_test_streams 8 22 4 8 3 0 0
> > +_test_streams 8 22 4 8 3 1 0
> > +_test_streams 8 22 4 8 3 0 1
> > +_test_streams 8 22 4 8 3 1 1
> >  
> >  status=0
> >  exit
> > -
> > diff --git a/tests/xfs/170.out b/tests/xfs/170.out
> > index a1339cec..e71515e9 100644
> > --- a/tests/xfs/170.out
> > +++ b/tests/xfs/170.out
> > @@ -1,20 +1,20 @@
> >  QA output created by 170
> > -# testing 8 16 4 8 3 0 0 ....
> > +# testing 8 22 4 8 3 0 0 ....
> >  # streaming
> >  # sync AGs...
> >  # checking stream AGs...
> >  + passed, streams are in seperate AGs
> > -# testing 8 16 4 8 3 1 0 ....
> > +# testing 8 22 4 8 3 1 0 ....
> >  # streaming
> >  # sync AGs...
> >  # checking stream AGs...
> >  + passed, streams are in seperate AGs
> > -# testing 8 16 4 8 3 0 1 ....
> > +# testing 8 22 4 8 3 0 1 ....
> >  # streaming
> >  # sync AGs...
> >  # checking stream AGs...
> >  + passed, streams are in seperate AGs
> > -# testing 8 16 4 8 3 1 1 ....
> > +# testing 8 22 4 8 3 1 1 ....
> >  # streaming
> >  # sync AGs...
> >  # checking stream AGs...
> > -- 
> > 2.14.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
