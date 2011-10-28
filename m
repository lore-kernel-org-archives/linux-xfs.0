Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9S9PNTO144024 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 04:25:23 -0500
Received: from mx3-phx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21A581CC6AB7
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 02:25:22 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id ozVLSRhyHqLU8DTO for
	<xfs@oss.sgi.com>; Fri, 28 Oct 2011 02:25:22 -0700 (PDT)
Date: Fri, 28 Oct 2011 05:25:16 -0400 (EDT)
From: Boris Ranto <branto@redhat.com>
Subject: Re: [PATCH] xfstests 016: Do not discard blocks at the mkfs time
Message-ID: <7b17b1e4-538b-48ff-bced-ab67fc5bd49b@zmail16.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20111027160434.GA21551@infradead.org>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <esandeen@redhat.com>, xfs <xfs@oss.sgi.com>

On Thu, Oct 27, 2011, Christoph Hellwig wrote:
> On Wed, Oct 26, 2011 at 12:46:23PM +0200, Boris Ranto wrote:
> > The test 016 fills scratch device with some data and then creates
> > xfs fs
> > on the scratch device. Later, the test assumes that the previously
> > written data are still in there and checks for them at specific
> > locations. On ssd drive this will lead to failure since the blocks
> > are
> > discarded by default when the mkfs command is run.
> > This simple patch that adds -K to stop the discarding (if the mkfs
> > command supports it) fixed the issue for me:
> > 
> > Signed-off-by: Boris Ranto <branto@redhat.com>
> > 
> > diff --git a/016 b/016
> > index 9275ade..db76398 100755
> > --- a/016
> > +++ b/016
> > @@ -65,6 +65,8 @@ _init()
> >      $here/src/devzero -b 2048 -n 50 -v 198 $SCRATCH_DEV
> >      echo "*** mkfs"
> >      force_opts="-dsize=50m -lsize=$log_size"
> > +    # Do not discard blocks, we need them for further reads
> > +    _scratch_mkfs_xfs -N -K $force_opts >/dev/null 2>&1 &&
> > force_opts="-K $force_opts"
> >      echo mkfs_xfs $force_opts $SCRATCH_DEV >>$seq.full
> >      _scratch_mkfs_xfs $force_opts >$tmp.mkfs0 2>&1
> 
> It took me very long understanding why you do mkfs.xfs calls here,
> but I suspect now that it is to detect if -K is supported?
> 
> If so please document it in a comment, and maybe also write the
> code a bit more verbose, e.g.
> 
> 	#
> 	# Do not discard blocks as we check for patterns in freespace.
> 	#
> 	# Given that older xfsprogs versions do not have the -K option
> 	# make sure it works first.
> 	#
> 	if _scratch_mkfs_xfs -N -K $force_opts >/dev/null 2>&1; then
> 	    force_opts="-K $force_opts"
> 	fi
> 
> Otherwise the test looks good and will fix the 016 failure on TP /
> TRIM
> capable devices that I've been seeing for a while.
> 
> Thanks a lot for doing this!
> 

Yes, the dry mkfs.xfs call is there just to check whether mkfs supports the '-K' option.
I'll resend the patch in its more verbose form to make it more clear.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
