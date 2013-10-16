Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AF7EB7F53
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 17:52:04 -0500 (CDT)
Date: Wed, 16 Oct 2013 17:52:04 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 19/19] xfs: convert directory vector functions to constants
Message-ID: <20131016225204.GE1935@sgi.com>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
	<1381789085-21923-20-git-send-email-david@fromorbit.com>
	<20131016211615.GD1935@sgi.com> <20131016222317.GM4446@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131016222317.GM4446@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 17, 2013 at 09:23:17AM +1100, Dave Chinner wrote:
> On Wed, Oct 16, 2013 at 04:16:15PM -0500, Ben Myers wrote:
> > On Tue, Oct 15, 2013 at 09:18:05AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Many of the vectorised function calls now take no parameters and
> > > return a constant value. There is no reason for these to be vectored
> > > functions, so convert them to constants
> > > 
> > > Binary sizes:
> > > 
> > >    text    data     bss     dec     hex filename
> > >  794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
> > >  792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
> > >  792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
> > >  789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
> > >  789005   96802    1096  886903   d8997 fs/xfs/xfs.o.p4
> > >  789061   96802    1096  886959   d88af fs/xfs/xfs.o.p5
> > >  789733   96802    1096  887631   d8b4f fs/xfs/xfs.o.p6
> > >  791421   96802    1096  889319   d91e7 fs/xfs/xfs.o.p7
> > >  791701   96802    1096  889599   d92ff fs/xfs/xfs.o.p8
> > >  791205   96802    1096  889103   d91cf fs/xfs/xfs.o.p9
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > 
> > Hmmm.  This one doesn't seem to apply.  Maybe it's just me.
> 
> Applies without mismatch here on an 3.12-rc5 + oss-xfs/master tree
> here. What's the reject that you get?

Like so:

$ q pu
Applying patch xfs-convert-directory-vector-functions-to-constants.patch
patching file fs/xfs/xfs_da_btree.c
patching file fs/xfs/xfs_da_format.c
Hunk #13 FAILED at 571.
Hunk #14 FAILED at 608.
Hunk #15 succeeded at 641 (offset -74 lines).
Hunk #16 FAILED at 729.
Hunk #17 succeeded at 683 (offset -82 lines).
Hunk #18 FAILED at 779.
Hunk #19 succeeded at 728 (offset -87 lines).
Hunk #20 FAILED at 829.
5 out of 20 hunks FAILED -- rejects in file fs/xfs/xfs_da_format.c
patching file fs/xfs/xfs_dir2.c
patching file fs/xfs/xfs_dir2.h
Hunk #4 FAILED at 92.
1 out of 4 hunks FAILED -- rejects in file fs/xfs/xfs_dir2.h
patching file fs/xfs/xfs_dir2_block.c
patching file fs/xfs/xfs_dir2_data.c
patching file fs/xfs/xfs_dir2_leaf.c
patching file fs/xfs/xfs_dir2_node.c
Hunk #1 FAILED at 274.
Hunk #2 succeeded at 1267 (offset -1 lines).
Hunk #3 succeeded at 1299 (offset -1 lines).
Hunk #4 succeeded at 1408 (offset -1 lines).
1 out of 4 hunks FAILED -- rejects in file fs/xfs/xfs_dir2_node.c
patching file fs/xfs/xfs_dir2_readdir.c
patching file fs/xfs/xfs_dir2_sf.c
Patch xfs-convert-directory-vector-functions-to-constants.patch does not apply (enforce with -f)

That's on 74564fb48.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
