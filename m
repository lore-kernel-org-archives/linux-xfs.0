Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 13:58:46 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [65.172.181.25])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l47KwffB028868
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 13:58:42 -0700
Date: Mon, 7 May 2007 13:58:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
Message-Id: <20070507135825.f8545a65.akpm@linux-foundation.org>
In-Reply-To: <20070507113753.GA5439@schatzie.adilger.int>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Dilger <adilger@clusterfs.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Mon, 7 May 2007 05:37:54 -0600
Andreas Dilger <adilger@clusterfs.com> wrote:

> > > +	block = offset >> blkbits;
> > > +	max_blocks = (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
> > > +			 - block;
> > > +	mutex_lock(&EXT4_I(inode)->truncate_mutex);
> > > +	credits = ext4_ext_calc_credits_for_insert(inode, NULL);
> > > +	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
> > 
> > Now I'm mystified.  Given that we're allocating an arbitrary amount of disk
> > space, and that this disk space will require an arbitrary amount of
> > metadata, how can we work out how much journal space we'll be needing
> > without at least looking at `len'?
> 
> Good question.
> 
> The uninitialized extent can cover up to 128MB with a single entry.
> If @path isn't specified, then ext4_ext_calc_credits_for_insert()
> function returns the maximum number of extents needed to insert a leaf,
> including splitting all of the index blocks.  That would allow up to 43GB
> (340 extents/block * 128MB) to be preallocated, but it still needs to take
> the size of the preallocation into account (adding 3 blocks per 43GB - a
> leaf block, a bitmap block and a group descriptor).

I think the use of ext4_journal_extend() (as Amit has proposed) will help
here, but it is not sufficient.

Because under some circumstances, a journal_extend() failure could mean
that we fail to allocate all the required disk space.  If it is infrequent
enough, that is acceptable when the caller is using fallocate() for
performance reasons.

But it is very much not acceptable if the caller is using fallocate() for
space-reservation reasons.  If you used fallocate to reserve 1GB of disk
and fallocate() "succeeded" and you later get ENOSPC then you'd have a
right to get a bit upset.

So I think the ext3/4 fallocate() implementation will need to be
implemented as a loop: 

	while (len) {
		journal_start();
		len -= do_fallocate(len, ...);
		journal_stop();
	}


Now the interesting question is: what do we do if we get halfway through
this loop and then run out of space?  We could leave the disk all filled up
and then return failure to the caller, but that's pretty poor behaviour,
IMO.



Does the proposed implementation handle quotas correctly, btw?  Has that
been tested?


Final point: it's fairly disappointing that the present implementation is
ext4-only, and extent-only.  I do think we should be aiming at an ext4
bitmap-based implementation and an ext3 implementation.
