Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35648 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751230AbeDQSo7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 14:44:59 -0400
Date: Tue, 17 Apr 2018 11:44:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3] xfs: prevent creating negative-sized file via
 INSERT_RANGE
Message-ID: <20180417184440.GE24738@magnolia>
References: <20180416204630.177682-1-ebiggers3@gmail.com>
 <20180417175530.GD24738@magnolia>
 <20180417180054.GA9237@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417180054.GA9237@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>, Christoph Hellwig <hch@infradead.org>

On Tue, Apr 17, 2018 at 11:00:54AM -0700, Eric Biggers wrote:
> Hi Darrick,
> 
> On Tue, Apr 17, 2018 at 10:55:30AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > During the "insert range" fallocate operation, i_size grows by the
> > specified 'len' bytes.  XFS verifies that i_size + len < s_maxbytes, as
> > it should.  But this comparison is done using the signed 'loff_t', and
> > 'i_size + len' can wrap around to a negative value, causing the check to
> > incorrectly pass, resulting in an inode with "negative" i_size.  This is
> > possible on 64-bit platforms, where XFS sets s_maxbytes = LLONG_MAX.
> > ext4 and f2fs don't run into this because they set a smaller s_maxbytes.
> > 
> > Fix it by doing an unsigned comparison instead.
> > 
> 
> Can you fix this sentence of the commit message?  It's not doing an unsigned
> comparison anymore.  Otherwise this looks fine -- thanks!

Will do. Thanks!

--D

> 
> > Reproducer:
> >     xfs_io -f file -c "truncate $(((1<<63)-1))" -c "finsert 0 4096"
> > 
> > Fixes: a904b1ca5751 ("xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate")
> > Cc: <stable@vger.kernel.org> # v4.1+
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > Originally-From: Eric Biggers <ebiggers@google.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > [darrick: fix signed integer addition overflow too]
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v3: rearrange the changes to churn less
> > v2: fix signed integer overflow when adding isize and len
> > ---
> >  fs/xfs/xfs_file.c |   14 +++++++++-----
> >  1 file changed, 9 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 9fd9dd7..1ac05ab 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -778,22 +778,26 @@ xfs_file_fallocate(
> >  		if (error)
> >  			goto out_unlock;
> >  	} else if (mode & FALLOC_FL_INSERT_RANGE) {
> > -		unsigned int blksize_mask = i_blocksize(inode) - 1;
> > +		unsigned int	blksize_mask = i_blocksize(inode) - 1;
> > +		loff_t		isize = i_size_read(inode);
> >  
> > -		new_size = i_size_read(inode) + len;
> >  		if (offset & blksize_mask || len & blksize_mask) {
> >  			error = -EINVAL;
> >  			goto out_unlock;
> >  		}
> >  
> > -		/* check the new inode size does not wrap through zero */
> > -		if (new_size > inode->i_sb->s_maxbytes) {
> > +		/*
> > +		 * New inode size must not exceed ->s_maxbytes, accounting for
> > +		 * possible signed overflow.
> > +		 */
> > +		if (inode->i_sb->s_maxbytes - isize < len) {
> >  			error = -EFBIG;
> >  			goto out_unlock;
> >  		}
> > +		new_size = isize + len;
> >  
> >  		/* Offset should be less than i_size */
> > -		if (offset >= i_size_read(inode)) {
> > +		if (offset >= isize) {
> >  			error = -EINVAL;
> >  			goto out_unlock;
> >  		}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
