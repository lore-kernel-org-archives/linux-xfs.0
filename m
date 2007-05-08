Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 17:42:01 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l480ftfB025394
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 17:41:56 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l480cMBk002369
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 20:38:22 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l480fgcB102890
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 18:41:42 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l480ffZE025439
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 18:41:42 -0600
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
In-Reply-To: <20070507171541.5370a36a.akpm@linux-foundation.org>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org>
	 <20070330071417.GI355@devserv.devel.redhat.com>
	 <20070417125514.GA7574@amitarora.in.ibm.com>
	 <20070507171541.5370a36a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 07 May 2007 17:41:39 -0700
Message-Id: <1178584899.3933.73.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger@clusterfs.com>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com

On Mon, 2007-05-07 at 17:15 -0700, Andrew Morton wrote:
> On Mon, 07 May 2007 17:00:24 -0700
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > > +       while (ret >= 0 && ret < max_blocks) {
> > > +               block = block + ret;
> > > +               max_blocks = max_blocks - ret;
> > > +               ret = ext4_ext_get_blocks(handle, inode, block,
> > > +                                         max_blocks, &map_bh,
> > > +                                         EXT4_CREATE_UNINITIALIZED_EXT, 0);
> > > +               BUG_ON(!ret);
> > > +               if (ret > 0 && test_bit(BH_New, &map_bh.b_state)
> > > +                       && ((block + ret) > (i_size_read(inode) << blkbits)))
> > > +                       nblocks = nblocks + ret;
> > > +       }
> > > +
> > > +       if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> > > +               goto retry;
> > > +
> > > Now the interesting question is: what do we do if we get halfway through
> > > this loop and then run out of space?  We could leave the disk all filled up
> > > and then return failure to the caller, but that's pretty poor behaviour,
> > > IMO.
> > > 
> > The current code handles earlier ENOSPC by three times retries. After
> > that if we still run out of space, then it's propably right to notify
> > the caller there isn't much space left.
> > 
> > We could extend the block reservation window size before the while loop
> > so we could get a lower chance to get more fragmented.
> 
> yes, but my point is that the proposed behaviour is really quite bad.
> 
I agree your point, that's why I mention it only helped the
fragmentation issue but not the ENOSPC case.


> We will attempt to allocate the disk space and then we will return failure,
> having consumed all the disk space and having partially and uselessly
> populated an unknown amount of the file.
> 

Not totally useless I think. If only half of the space is preallocated
because run out of space, the application can decide whether it's good
enough to start to use this preallocated space or wait for the fs to
have more free space.

> Userspace could presumably repair the mess in most situations by truncating
> the file back again.  The kernel cannot do that because there might be live
> data in amongst there.
> 
> So we'd need to either keep track of which blocks were newly-allocated and
> then free them all again on the error path (doesn't work right across
> commit+crash+recovery) or we could later use the space-reservation scheme which
> delayed allocation will need to introduce.
> 
> Or we could decide to live with the above IMO-crappy behaviour.

In fact Amit and I had raised this issue before, whether it's okay to do
allow partial preallocation. At that moment the feedback is it's no much
different than the current zero-out-preallocation behavior: people might
preallocating half-way then later deal with ENOSPC.

We could check the total number of fs free blocks account before
preallocation happens, if there isn't enough space left, there is no
need to bother preallocating.

If there is enough free space, we could make a reservation window that
have at least N free blocks and mark it not stealable by other files. So
later we will not run into the ENOSPC error.

The fs free blocks account is just a estimate though.


Mingming
