Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JKdh6b161088 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 15:39:43 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	QoR3kMy5Jx7MbK0I for <xfs@oss.sgi.com>;
	Tue, 19 Jun 2012 13:39:41 -0700 (PDT)
Date: Wed, 20 Jun 2012 06:39:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Message-ID: <20120619203938.GM25389@dastard>
References: <20120619031241.GA3884@redhat.com>
	<alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
	<20120619131649.GA6811@redhat.com>
	<alpine.LFD.2.00.1206191519320.21961@dhcp-1-248.brq.redhat.com>
	<20120619133041.GB6811@redhat.com> <4FE0840F.2050704@shiftmail.org>
	<20120619144413.GA7225@redhat.com>
	<20120619184858.GA8841@redhat.com> <20120619200631.GL25389@dastard>
	<20120619202130.GF22805@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120619202130.GF22805@thunk.org>
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
To: Ted Ts'o <tytso@mit.edu>
Cc: Mike Snitzer <snitzer@redhat.com>, xfs@oss.sgi.com, device-mapper development <dm-devel@redhat.com>, Spelic <spelic@shiftmail.org>, =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org

On Tue, Jun 19, 2012 at 04:21:30PM -0400, Ted Ts'o wrote:
> On Wed, Jun 20, 2012 at 06:06:31AM +1000, Dave Chinner wrote:
> > > But in general xfs is issuing discards with much smaller extents than
> > > ext4 does, e.g.:
> > 
> > THat's normal when you use -o discard - XFS sends extremely
> > fine-grained discards as the have to be issued during the checkpoint
> > commit that frees the extent. Hence they can't be aggregated like is
> > done in ext4.
> 
> Actually, ext4 is also sending the discards during (well, actually,
> after) the commit which frees the extent/inode.  We do aggregate them
> while the commit is open, but once the transaction is committed, we
> send out the discards.  I suspect the difference is in the granularity
> of the transactions between ext4 and xfs.

Exactly - XFS transactions are fine grained, checkpoints are coarse.
We don't merge extents freed in fine grained transactions inside
checkpoints. We probably could, but, well, it's complex to do in XFS
and merging adjacent requests is something the block layer is
supposed to do....

> > As it is, no-one really should be using -o discard - it is extremely
> > inefficient compared to a background fstrim run given that discards
> > are unqueued, blocking IOs. It's just a bad idea until the lower
> > layers get fixed to allow asynchronous, vectored discards and SATA
> > supports queued discards...
> 
> What Dave said.  :-) This is true for both ext4 and xfs.
> 
> As a result, I can very easily see there being a distinction made
> between when we *do* want to pass the discards all the way down to the
> device, and when we only want the thinp layer to process them ---
> because for current devices, sending discards down to the physical
> device is very heavyweight.
> 
> I'm not sure how we could do this without a nasty layering violation,
> but some way in which we could label fstrim discards versus "we've
> committed the unlink/truncate and so thinp can feel free to reuse
> these blocks" discards would be interesting to consider.

I think if we had better discard support from the block layer, it
wouldn't matter from a filesystem POV what discard support is
present in the block layer below it. I think it's better to get the
block layer interface fixed than to add new request types/labels to
filesystems to work around the current deficiencies.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
