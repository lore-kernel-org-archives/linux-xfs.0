Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 185ED7D21
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 12:34:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 84172AC002
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 10:34:07 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Onk392a28ZcP5O0u (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 01 Aug 2016 10:34:05 -0700 (PDT)
Date: Mon, 1 Aug 2016 10:33:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/47] xfs: add function pointers for get/update keys to
	the btree
Message-ID: <20160801173331.GC8590@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907700604.25461.2181974283557088355.stgit@birch.djwong.org>
	<20160801063902.GI15590@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160801063902.GI15590@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

On Sun, Jul 31, 2016 at 11:39:02PM -0700, Christoph Hellwig wrote:
> On Wed, Jul 20, 2016 at 09:56:46PM -0700, Darrick J. Wong wrote:
> > Add some function pointers to bc_ops to get the btree keys for
> > leaf and node blocks, and to update parent keys of a block.
> > Convert the _btree_updkey calls to use our new pointer, and
> > modify the tree shape changing code to call the appropriate
> > get_*_keys pointer instead of _btree_copy_keys because the
> > overlapping btree has to calculate high key values.
> 
> I don't really like to add ops for something that isn't really
> per-btree type.  Can you just add an overlapping flag and act based on
> that?

That's roughly the approach I took in previous versions of this patch,
but using the OVERLAPPING flag to dispatch the overlapped vs. non-
versions of the get*keys and updkey* functions confused Dave, so he
asked me to add to function pointers[1] to the btree ops and dispatch
that way.  There are still a few places where we need to know if it's
an overlapped btree (like when we update a block and have to update
the high keys, which only applies to overlapped trees), so the flag
didn't entirely go away.

Now, one thing I could do differently is move those new function
pointers to the btree cursor and add a xfs_btree_init_cursor() that
checks the flag and sets the function pointers accordingly.  It
seems a little funny to me to be sprinking function pointers in both
btree_cursor and btree_ops, but I suppose the flag is in the cursor,
so having function pointers there too probably isn't so bad.

That encapsulates some btree details so that each btree doesn't have
to get them right, so I'll at least code this up and add it to the end
of my -experimental tree.  I'm not sure how far Dave has gotten in
evaluating/fixing/whatever the for-next-for-4.8-2 tree to send to
Linus, so I'll hold off on folding that fix into the existing
patch unless Dave wants it for his second merge-window pull request.

--D

[1] https://www.spinics.net/lists/xfs/msg40870.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
