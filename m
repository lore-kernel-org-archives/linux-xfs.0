Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 75FA47F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 23:06:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E3307AC008
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 21:05:56 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id MUPsM8QeP46HQDoy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 21:05:52 -0700 (PDT)
Date: Tue, 25 Aug 2015 21:05:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/11] libxfs: clear buffer state flags in libxfs_getbuf
	and variants
Message-ID: <20150826040546.GX10043@birch.djwong.org>
References: <20150826003220.23973.59731.stgit@birch.djwong.org>
	<20150826003246.23973.12895.stgit@birch.djwong.org>
	<20150826010232.GT714@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150826010232.GT714@dastard>
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

On Wed, Aug 26, 2015 at 11:02:32AM +1000, Dave Chinner wrote:
> On Tue, Aug 25, 2015 at 05:32:46PM -0700, Darrick J. Wong wrote:
> > When we're running xfs_repair with prefetch enabled, it's possible
> > that repair will decide to clear an inode without examining all
> > metadata blocks owned by that inode.  This leaves the unreferenced
> > prefetched buffers marked UNCHECKED, which will cause a subsequent CRC
> > error if the block is reallocated to a different structure and read
> > more than once.  Typically this happens when a large directory is
> > corrupted and lost+found has to grow to accomodate all the
> > disconnected inodes.
> > 
> > In libxfs_getbuf*(), we're supposed to return an unused buffer which
> > has a clean state.  Unfortunately, things like UNCHECKED can hang
> > around to cause incorrect verifier errors later, so change those
> > functions to launder the state bits clean.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  libxfs/rdwr.c |   47 +++++++++++++++++++++++++++++++++++++++++------
> >  1 file changed, 41 insertions(+), 6 deletions(-)
> > 
> > 
> > diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> > index 4f8212f..d28cea8 100644
> > --- a/libxfs/rdwr.c
> > +++ b/libxfs/rdwr.c
> > @@ -631,15 +631,39 @@ libxfs_getbuf_flags(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len,
> >  	return __cache_lookup(&key, flags);
> >  }
> >  
> > +/*
> > + * Clean the buffer flags for libxfs_getbuf*(), which wants to return
> > + * an unused buffer with clean state.  This prevents CRC errors on a
> > + * re-read of a corrupt block that was prefetched and freed.  This
> > + * can happen with a massively corrupt directory that is discarded,
> > + * but whose blocks are then recycled into expanding lost+found.
> > + *
> > + * Note however that if the buffer's dirty (prefetch calls getbuf)
> > + * we'll leave the state alone because we don't want to discard blocks
> > + * that have been fixed.
> > + */
> > +static void
> > +try_clean_buf(
> 
> Only thing I don't like about this patch is the name of this
> function. It's really a "reset buffer state" function, so I think
> that calling it something like reset_buf_state() would be more
> appropriate.

Done.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
