Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48472 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752746AbdK0RvH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Nov 2017 12:51:07 -0500
Date: Mon, 27 Nov 2017 09:50:53 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: log recovery should replay deferred ops in order
Message-ID: <20171127175053.GD19379@magnolia>
References: <20171122182949.GH2135@magnolia>
 <20171123133640.GA27935@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171123133640.GA27935@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Hou Tao <houtao1@huawei.com>, Amir Goldstein <amir73il@gmail.com>

On Thu, Nov 23, 2017 at 02:36:40PM +0100, Christoph Hellwig wrote:
> Hi Darrick,
> 
> this looks generally good to me:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But I have a few nitpicks below:
> 
> > +	/*
> > +	 * We're finishing the defer_ops that accumulated as a result of
> > +	 * recovering unfinished intent items during log recovery.  We
> > +	 * reserve an itruncate transaction because it is the largest
> > +	 * permanent transaction type.  Since we're the only user of the
> > +	 * fs right now, take 93% of the available free blocks.  Use
> > +	 * weird math to avoid a 64-bit division.
> > +	 */
> 
> Those magic 93% are 15/16th, maybe better to write it that way :)

Ok, will update comment.

> That being said / 16 still is a 64-bit division, and I'm pretty sure
> we'll run into an old gcc on some weird architecture that will not
> turn it into a shift, so better write it as a shift to start with.

It shouldn't be, since resblks is unsigned int, which afaik is 32-bit.
But meh, I'll just change it to ">> 4" to make it obvious.

> > +	freeblks = percpu_counter_sum(&mp->m_fdblocks);
> > +	resblks = min_t(s64, UINT_MAX, freeblks);
> 
> Didn't I just got called out for using u* types?  The same applies
> to s*, so use int64_t here to be consistent.

Yeah... I pulled the return type directly from percpu_counter_sum, sigh.
Will change to int64_t.

> > +		/*
> > +		 * NOTE: If your intent processing routine can create
> > +		 * more deferred ops, you /must/ attach them to the
> > +		 * dfops in this routine or else those subsequent
> > +		 * intents will get replayed in the wrong order!
> > +		 */
> 
> Please use up all available 80 characters for your comments.

Ok, will fix the comment.

--D

> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
