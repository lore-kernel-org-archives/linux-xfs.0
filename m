Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9A0CF7F3F
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 16:29:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1442CAC002
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 14:29:40 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	rbEkGJB1KpVrjrEP for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 14:29:37 -0800 (PST)
Date: Thu, 5 Mar 2015 09:29:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] dax: don't abuse get_block mapping for endio callbacks
Message-ID: <20150304222935.GY18360@dastard>
References: <1425425427-16283-1-git-send-email-david@fromorbit.com>
	<1425425427-16283-2-git-send-email-david@fromorbit.com>
	<20150304155408.GA2799@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150304155408.GA2799@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, xfs@oss.sgi.com

On Wed, Mar 04, 2015 at 04:54:08PM +0100, Jan Kara wrote:
> On Wed 04-03-15 10:30:22, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > @@ -269,7 +269,8 @@ static int copy_user_bh(struct page *to, struct buffer_head *bh,
> >  }
> >  
> >  static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
> > -			struct vm_area_struct *vma, struct vm_fault *vmf)
> > +			struct vm_area_struct *vma, struct vm_fault *vmf,
> > +			dax_iodone_t complete_unwritten)
> >  {
> >  	struct address_space *mapping = inode->i_mapping;
> >  	sector_t sector = bh->b_blocknr << (inode->i_blkbits - 9);
> > @@ -310,14 +311,14 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
> >   out:
> >  	i_mmap_unlock_read(mapping);
> >  
> > -	if (bh->b_end_io)
> > -		bh->b_end_io(bh, 1);
> > +	if (buffer_unwritten(bh))
> > +		complete_unwritten(bh, 1);
> >  
> >  	return error;
> >  }
>   So frankly I don't see a big point in passing completion callback into
> dax_insert_mapping() only to call the function at the end of it. We could
> as well call the completion function from do_dax_fault() where it would
> seem more natural to me. But I don't feel too strongly about this.

On further review, I think the code is incorrect as is, even without
this change - we shouldn't be running unwritten extent conversion
if the block zeroing failed. So this needs fixing anyway. I'll pull
the completion back to do_dax_fault(), where it willonly be run if
there was no error inserting the mapping.

> Instead of the above I was also thinking about some way to pass information
> out of do_dax_fault() into filesystem so that it could just call completion
> handler itself but the completion callback is more standard interface I
> guess.

That seems unbalanced to me, as internal mapping state would need to
be leaked back out to the caller so they could run conversion. I
think it's cleaner to pass in the callback and leave all that
mapping state internal to do_dax_fault()....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
