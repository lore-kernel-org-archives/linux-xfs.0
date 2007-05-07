Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 12:49:44 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l47JnbfB023617
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 12:49:39 -0700
Date: Mon, 7 May 2007 05:37:54 -0600
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
Message-ID: <20070507113753.GA5439@schatzie.adilger.int>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426181332.GD7209@amitarora.in.ibm.com> <20070503213133.d1559f52.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503213133.d1559f52.akpm@linux-foundation.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On May 03, 2007  21:31 -0700, Andrew Morton wrote:
> On Thu, 26 Apr 2007 23:43:32 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> > + * ext4_fallocate:
> > + * preallocate space for a file
> > + * mode is for future use, e.g. for unallocating preallocated blocks etc.
> > + */
> 
> This description is rather thin.  What is the filesystem's actual behaviour
> here?  If the file is using extents then the implementation will do
> <something>.  If the file is using bitmaps then we will do <something else>.
> 
> But what?   Here is where it should be described.

My understanding is that glibc will handle zero-filling of files for
filesystems that do not support fallocate().

> > +int ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
> > +{
> > +	handle_t *handle;
> > +	ext4_fsblk_t block, max_blocks;
> > +	int ret, ret2, nblocks = 0, retries = 0;
> > +	struct buffer_head map_bh;
> > +	unsigned int credits, blkbits = inode->i_blkbits;
> > +
> > +	/* Currently supporting (pre)allocate mode _only_ */
> > +	if (mode != FA_ALLOCATE)
> > +		return -EOPNOTSUPP;
> > +
> > +	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> > +		return -ENOTTY;
> 
> So we don't implement fallocate on bitmap-based files!  Well that's huge
> news.  The changelog would be an appropriate place to communicate this,
> along with reasons why, or a description of the plan to fix it.
> 
> Also, posix says nothing about fallocate() returning ENOTTY.

I _think_ this is to convince glibc to do the zero-filling in userspace,
but I'm not up on the API specifics.

> > +	block = offset >> blkbits;
> > +	max_blocks = (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
> > +			 - block;
> > +	mutex_lock(&EXT4_I(inode)->truncate_mutex);
> > +	credits = ext4_ext_calc_credits_for_insert(inode, NULL);
> > +	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
> 
> Now I'm mystified.  Given that we're allocating an arbitrary amount of disk
> space, and that this disk space will require an arbitrary amount of
> metadata, how can we work out how much journal space we'll be needing
> without at least looking at `len'?

Good question.

The uninitialized extent can cover up to 128MB with a single entry.
If @path isn't specified, then ext4_ext_calc_credits_for_insert()
function returns the maximum number of extents needed to insert a leaf,
including splitting all of the index blocks.  That would allow up to 43GB
(340 extents/block * 128MB) to be preallocated, but it still needs to take
the size of the preallocation into account (adding 3 blocks per 43GB - a
leaf block, a bitmap block and a group descriptor).

Also, since @path is not being given then truncate_mutex is not needed.

> > +		ret = ext4_ext_get_blocks(handle, inode, block,
> > +					  max_blocks, &map_bh,
> > +					  EXT4_CREATE_UNINITIALIZED_EXT, 0);
> > +		BUG_ON(!ret);
> 
> BUG_ON is vicious.  Is it really justified here?  Possibly a WARN_ON and
> ext4_error() would be safer and more useful here.

Ouch, not very friendly error handling.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
