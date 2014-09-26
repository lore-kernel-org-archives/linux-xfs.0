Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DEFCA7FE0
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 20:59:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B023A8F8035
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 18:59:42 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	OyDZSEEPjHNnCZvW for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 18:59:34 -0700 (PDT)
Date: Fri, 26 Sep 2014 11:59:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: borrow indirect blocks from freed extent when
	available
Message-ID: <20140926015931.GL4945@dastard>
References: <1411500538-6831-1-git-send-email-bfoster@redhat.com>
	<20140923215816.GC4322@dastard>
	<20140924122746.GA53094@bfoster.bfoster>
	<20140924233014.GB4758@dastard>
	<20140925150703.GB47304@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140925150703.GB47304@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 25, 2014 at 11:07:04AM -0400, Brian Foster wrote:
> On Thu, Sep 25, 2014 at 09:30:14AM +1000, Dave Chinner wrote:
> > I knew I'd looked at this before:
> > 
> > http://oss.sgi.com/archives/xfs/2014-03/msg00314.html
> > 
> > That got lost because I wrote it in a topic branch and not my usual
> > working branch, so when I dropped the topic branch. Guilt, however,
> > keeps all the patches from topic branches around, and so when I just
> > did a grep for da_new across .git/patch, this showed up.
> > 
> > It's basically the same "steal blocks from the deleted extent
> > reservation fix, and it was trying to address the above failure.
> > However, there are some other details in it (like changing the
> > location of delalloc accounting updates) that might be relevant.
> > 
> 
> Ah, right. I thought I had seen something like this before. In fact I
> had it in my head that we already did something like this when I
> narrowed in on the code so I was somewhat surprised, but I didn't go
> back and look through the list. That explains that. :)
> 
> This version moves the entire delalloc accounting hunk after the
> xfs_bmap_del_extent() call. I think the problem with that is the sb
> counter is the only record keeping that encompasses data blocks and
> indirect blocks, which is why I only moved that update in xfs_bunmapi().
> That's also precisely why I consider using a separate parameter rather
> than updating br_blockcount.
> 
> Let me know if you wanted to resurrect this one, otherwise I'll try to
> double check all of that when I get back to reworking mine...

It doesn't need to be resurrected if you've got a better fix. ;)

> > I'm pretty sure the test case was simply something like:
> > 
> > xfs_io -f -c "pwrite 0 1m" \
> > 	  -c "fzero 4k 8k" \
> > 	  -c "fzero 16k 8k" \
> > 	  -c "fzero 32k 8k" \
> > 	  -c "fzero 64k 8k" \
> > 	 .....
> > 
> > To basically split the delalloc extent repeatedly and hence drain
> > the reservation.
> > 
> 
> Yep, thanks. I assume you saw the test I posted:
> 
> http://oss.sgi.com/archives/xfs/2014-09/msg00371.html

Yup, I did see that later in the day....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
