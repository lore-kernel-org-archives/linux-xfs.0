Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 17:16:15 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [65.172.181.25])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l480GBfB022224
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 17:16:12 -0700
Date: Mon, 7 May 2007 17:15:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
Message-Id: <20070507171541.5370a36a.akpm@linux-foundation.org>
In-Reply-To: <1178582424.3933.39.camel@dyn9047017103.beaverton.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org>
	<20070330071417.GI355@devserv.devel.redhat.com>
	<20070417125514.GA7574@amitarora.in.ibm.com>
	<20070418130600.GW5967@schatzie.adilger.int>
	<20070420135146.GA21352@amitarora.in.ibm.com>
	<20070420145918.GY355@devserv.devel.redhat.com>
	<20070424121632.GA10136@amitarora.in.ibm.com>
	<20070426175056.GA25321@amitarora.in.ibm.com>
	<20070426181332.GD7209@amitarora.in.ibm.com>
	<20070503213133.d1559f52.akpm@linux-foundation.org>
	<20070507113753.GA5439@schatzie.adilger.int>
	<20070507135825.f8545a65.akpm@linux-foundation.org>
	<1178582424.3933.39.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: cmm@us.ibm.com
Cc: Andreas Dilger <adilger@clusterfs.com>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com

On Mon, 07 May 2007 17:00:24 -0700
Mingming Cao <cmm@us.ibm.com> wrote:

> > +       while (ret >= 0 && ret < max_blocks) {
> > +               block = block + ret;
> > +               max_blocks = max_blocks - ret;
> > +               ret = ext4_ext_get_blocks(handle, inode, block,
> > +                                         max_blocks, &map_bh,
> > +                                         EXT4_CREATE_UNINITIALIZED_EXT, 0);
> > +               BUG_ON(!ret);
> > +               if (ret > 0 && test_bit(BH_New, &map_bh.b_state)
> > +                       && ((block + ret) > (i_size_read(inode) << blkbits)))
> > +                       nblocks = nblocks + ret;
> > +       }
> > +
> > +       if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> > +               goto retry;
> > +
> > Now the interesting question is: what do we do if we get halfway through
> > this loop and then run out of space?  We could leave the disk all filled up
> > and then return failure to the caller, but that's pretty poor behaviour,
> > IMO.
> > 
> The current code handles earlier ENOSPC by three times retries. After
> that if we still run out of space, then it's propably right to notify
> the caller there isn't much space left.
> 
> We could extend the block reservation window size before the while loop
> so we could get a lower chance to get more fragmented.

yes, but my point is that the proposed behaviour is really quite bad.

We will attempt to allocate the disk space and then we will return failure,
having consumed all the disk space and having partially and uselessly
populated an unknown amount of the file.

Userspace could presumably repair the mess in most situations by truncating
the file back again.  The kernel cannot do that because there might be live
data in amongst there.

So we'd need to either keep track of which blocks were newly-allocated and
then free them all again on the error path (doesn't work right across
commit+crash+recovery) or we could later use the space-reservation scheme which
delayed allocation will need to introduce.

Or we could decide to live with the above IMO-crappy behaviour.
