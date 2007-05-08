Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 17:20:05 -0700 (PDT)
Received: from over.ny.us.ibm.com (over.ny.us.ibm.com [32.97.182.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l480K1fB022916
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 17:20:02 -0700
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
	by pokfb.esmtp.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l4800TK3031704
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 20:00:30 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4800Rgk009304
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 20:00:27 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4800RNf186946
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 18:00:27 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4800QhU006734
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 18:00:27 -0600
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
In-Reply-To: <20070507135825.f8545a65.akpm@linux-foundation.org>
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
Content-Type: text/plain
Date: Mon, 07 May 2007 17:00:24 -0700
Message-Id: <1178582424.3933.39.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger@clusterfs.com>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com

On Mon, 2007-05-07 at 13:58 -0700, Andrew Morton wrote:
> On Mon, 7 May 2007 05:37:54 -0600
> Andreas Dilger <adilger@clusterfs.com> wrote:
> 
> > > > +	block = offset >> blkbits;
> > > > +	max_blocks = (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
> > > > +			 - block;
> > > > +	mutex_lock(&EXT4_I(inode)->truncate_mutex);
> > > > +	credits = ext4_ext_calc_credits_for_insert(inode, NULL);
> > > > +	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
> > > 
> > > Now I'm mystified.  Given that we're allocating an arbitrary amount of disk
> > > space, and that this disk space will require an arbitrary amount of
> > > metadata, how can we work out how much journal space we'll be needing
> > > without at least looking at `len'?
> > 
> > Good question.
> > 
> > The uninitialized extent can cover up to 128MB with a single entry.
> > If @path isn't specified, then ext4_ext_calc_credits_for_insert()
> > function returns the maximum number of extents needed to insert a leaf,
> > including splitting all of the index blocks.  That would allow up to 43GB
> > (340 extents/block * 128MB) to be preallocated, but it still needs to take
> > the size of the preallocation into account (adding 3 blocks per 43GB - a
> > leaf block, a bitmap block and a group descriptor).
> 
> I think the use of ext4_journal_extend() (as Amit has proposed) will help
> here, but it is not sufficient.
> 
> Because under some circumstances, a journal_extend() failure could mean
> that we fail to allocate all the required disk space.  If it is infrequent
> enough, that is acceptable when the caller is using fallocate() for
> performance reasons.
> 
> But it is very much not acceptable if the caller is using fallocate() for
> space-reservation reasons.  If you used fallocate to reserve 1GB of disk
> and fallocate() "succeeded" and you later get ENOSPC then you'd have a
> right to get a bit upset.
> 
> So I think the ext3/4 fallocate() implementation will need to be
> implemented as a loop: 
> 
> 	while (len) {
> 		journal_start();
> 		len -= do_fallocate(len, ...);
> 		journal_stop();
> 	}
> 
> 

I agree.  There is already a loop in Amit's current's patch to call
ext4_ext_get_blocks() thoug. Question is how much credit should ext4 to
ask for in each journal_start()?
> +/*
> + * ext4_fallocate:
> + * preallocate space for a file
> + * mode is for future use, e.g. for unallocating preallocated blocks etc.
> + */
> +int ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
> +{
....

> +       mutex_lock(&EXT4_I(inode)->truncate_mutex);
> +       credits = ext4_ext_calc_credits_for_insert(inode, NULL);
> +       mutex_unlock(&EXT4_I(inode)->truncate_mutex);

I think the calculation is based on the assumption that there is only a
single extent to be inserted, which is the ideal case. But in some cases
we may end up allocating several chunk of blocks(extents) for this
single preallocation request when fs is fragmented (or part of
preallocation request is already fulfilled)

I think we should move this calculation inside the loop as well,and we
really do not need to grab the lock to calculate the credit if the @path
is always NULL, all the function does is mathmatics.

I can't think of any good way to estimate the total credits needed for
this whole preallocation request. Looked at ext4_get_block(), which is
used for DIO code to deal with large amount of block allocation. The
credit reservation is quite weak there too. The DIO_CREDIT is only
(EXT4_RESERVE_TRANS_BLOCKS + 32)

> +       handle=ext4_journal_start(inode, credits +
> +                                       EXT4_DATA_TRANS_BLOCKS(inode->i_sb)+1);
> +       if (IS_ERR(handle))
> +               return PTR_ERR(handle);
> +retry:
> +       ret = 0;
> +       while (ret >= 0 && ret < max_blocks) {
> +               block = block + ret;
> +               max_blocks = max_blocks - ret;
> +               ret = ext4_ext_get_blocks(handle, inode, block,
> +                                         max_blocks, &map_bh,
> +                                         EXT4_CREATE_UNINITIALIZED_EXT, 0);
> +               BUG_ON(!ret);
> +               if (ret > 0 && test_bit(BH_New, &map_bh.b_state)
> +                       && ((block + ret) > (i_size_read(inode) << blkbits)))
> +                       nblocks = nblocks + ret;
> +       }
> +
> +       if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> +               goto retry;
> +
> Now the interesting question is: what do we do if we get halfway through
> this loop and then run out of space?  We could leave the disk all filled up
> and then return failure to the caller, but that's pretty poor behaviour,
> IMO.
> 
The current code handles earlier ENOSPC by three times retries. After
that if we still run out of space, then it's propably right to notify
the caller there isn't much space left.

We could extend the block reservation window size before the while loop
so we could get a lower chance to get more fragmented.

> 
> Does the proposed implementation handle quotas correctly, btw?  Has that
> been tested?
> 
I think so. The ext4_ext_get_blocks() will end up calling
ext4_new_blocks() to do the real block allocation, quota is being
handled there, therefor is tested already.


Mingming
