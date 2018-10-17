Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54272 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbeJRAci (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Oct 2018 20:32:38 -0400
Date: Wed, 17 Oct 2018 09:35:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 17/26] vfs: enable remap callers that can handle short
 operations
Message-ID: <20181017163537.GO28243@magnolia>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153965999426.3607.3221368918901209000.stgit@magnolia>
 <20181017083652.GF16896@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181017083652.GF16896@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, Oct 17, 2018 at 01:36:52AM -0700, Christoph Hellwig wrote:
> >  /* Update inode timestamps and remove security privileges when remapping. */
> > @@ -2023,7 +2034,8 @@ loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
> >  {
> >  	loff_t ret;
> >  
> > -	WARN_ON_ONCE(remap_flags & ~(REMAP_FILE_DEDUP));
> > +	WARN_ON_ONCE(remap_flags & ~(REMAP_FILE_DEDUP |
> > +				     REMAP_FILE_CAN_SHORTEN));
> 
> I guess this is where you could actually use REMAP_FILE_VALID_FLAGS..
> 
> >  /* REMAP_FILE flags taken care of by the vfs. */
> > -#define REMAP_FILE_ADVISORY		(0)
> > +#define REMAP_FILE_ADVISORY		(REMAP_FILE_CAN_SHORTEN)
> 
> And btw, they are not 'taken care of by the VFS', they need to be
> taken care of by the fs (possibly using helpers) to take affect,
> but they can be safely ignored.

Ok, I'll update the comment.

> > +		if (!IS_ALIGNED(count, bs)) {
> > +			if (remap_flags & REMAP_FILE_CAN_SHORTEN)
> > +				count = ALIGN_DOWN(count, bs);
> > +			else
> > +				return -EINVAL;
> 
> 			if (!(remap_flags & REMAP_FILE_CAN_SHORTEN))
> 				return -EINVAL;
> 			count = ALIGN_DOWN(count, bs);

Seeing as we return EINVAL on shortened count and !CAN_SHORTEN below
this, I think this can be simplified further:

	if (pos_in + count == size_in) {
		bcount = ALIGN(size_in, bs) - pos_in;
	} else {
		if (!IS_ALIGNED(count, bs))
			count = ALIGN_DOWN(count, bs);
		bcount = count;
	}

--D
