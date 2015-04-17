Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 080E17F3F
	for <xfs@oss.sgi.com>; Fri, 17 Apr 2015 17:07:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EC67C8F8050
	for <xfs@oss.sgi.com>; Fri, 17 Apr 2015 15:07:11 -0700 (PDT)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id 5BinRiMhNVTTYCIi for <xfs@oss.sgi.com>;
	Fri, 17 Apr 2015 15:07:10 -0700 (PDT)
Date: Fri, 17 Apr 2015 18:07:09 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH v3 3/3] NFSD: Add support for encoding multiple segments
Message-ID: <20150417220709.GC28426@fieldses.org>
References: <5515A9C8.6090400@Netapp.com>
	<CAHQdGtRaUYxU2JAAWErH7FT=Gy5JLzAKi-RtqqBSkNFZrhaB9Q@mail.gmail.com>
	<5515C1BF.8000907@Netapp.com> <20150327205414.GD27889@fieldses.org>
	<5515C3BE.3040807@Netapp.com> <20150327210839.GE27889@fieldses.org>
	<552EBCB2.1040609@Netapp.com> <20150415195614.GA31407@fieldses.org>
	<20150415200016.GB31407@fieldses.org>
	<20150415225002.GV13731@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150415225002.GV13731@dastard>
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
Cc: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, Marc Eshel <eshel@us.ibm.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-nfs-owner@vger.kernel.org, Anna Schumaker <Anna.Schumaker@netapp.com>

On Thu, Apr 16, 2015 at 08:50:02AM +1000, Dave Chinner wrote:
> On Wed, Apr 15, 2015 at 04:00:16PM -0400, J. Bruce Fields wrote:
> > On Wed, Apr 15, 2015 at 03:56:14PM -0400, J. Bruce Fields wrote:
> > > On Wed, Apr 15, 2015 at 03:32:02PM -0400, Anna Schumaker wrote:
> > > > I just ran some more tests comparing the directio case across
> > > > different filesystem types.  These tests used three 1G files:  100%
> > > > data, 100% hole, and mixed file with alternating 4k data and hole
> > > > segments.  The mixed case seems to be consistently slower compared to
> > > > NFS v4.1, and I'm at a loss for anything I could do to make it faster.
> > > > Here are my numbers:
> > > 
> > > Have you tried the implementation we discussed that always returns a
> > > single segment covering the whole requested range, by treating holes as
> > > data if necessary when they don't cover the whole range?

Uh, sorry, I forgot, I think you're running with the patches that
support full multi-segment READ_PLUS on both sides so there's not that
issue with multiplying RPC's in this case.

Still, might be interesting to compare.  And wouldn't hurt to remind us
of these details when you repost this stuff to help keep my forgetful
self going in circles.

> > > (Also: I assume it's the same as before, but: when you post test
> > > results, could you repost if necessary:
> > > 
> > > 	- what the actual test is
> > > 	- what the hardware/software setup is on client and server
> > > 
> > > so that we have reproduceable results for posterity's sake.)
> > > 
> > > Interesting that "Mixed" is a little slower even before READ_PLUS.
> > > 
> > > And I guess we should really report this to ext4 people, looks like they
> > > may have a bug.
> > 
> > FWIW, this is what I was using to test SEEK_HOLE/SEEK_DATA and map out
> > holes on files on my local disk.  Might be worth checking whether the
> > ext4 slowdowns are reproduceable just with something like this, to rule
> > out protocol problems.
> 
> Wheel reinvention. :)

xfs_io appears to have a lot of wheels.  OK, I'll go read that man page
one of these days.

--b.

> 
> $ rm -f /mnt/scratch/bar
> $ for i in `seq 20 -2 0`; do
> > sudo xfs_io -f -c "pwrite $((i * 8192)) 4096" /mnt/scratch/bar
> > done
> .....
> $ sync
> $ sudo xfs_io -c "seek -ar 0" /mnt/scratch/bar
> Whence  Result
> DATA    0
> HOLE    4096
> DATA    16384
> HOLE    20480
> DATA    32768
> HOLE    36864
> DATA    49152
> HOLE    53248
> DATA    65536
> HOLE    69632
> DATA    81920
> HOLE    86016
> DATA    98304
> HOLE    102400
> DATA    114688
> HOLE    118784
> DATA    131072
> HOLE    135168
> DATA    147456
> HOLE    151552
> DATA    163840
> HOLE    167936
> $
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
