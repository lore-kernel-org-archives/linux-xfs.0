Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 583387CA0
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 15:44:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2B2B28F8050
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 13:44:37 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7HqJfjQVG8ppcYfz for <xfs@oss.sgi.com>;
	Thu, 10 Mar 2016 13:44:34 -0800 (PST)
Date: Fri, 11 Mar 2016 08:44:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/16] xfs: first part of rmapbt functionality
Message-ID: <20160310214432.GX30721@dastard>
References: <1457410578-30233-1-git-send-email-david@fromorbit.com>
	<20160310141434.GA29058@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160310141434.GA29058@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Mar 10, 2016 at 06:14:34AM -0800, Christoph Hellwig wrote:
> On Tue, Mar 08, 2016 at 03:16:02PM +1100, Dave Chinner wrote:
> > This isn't all of the rmap functionality. It's patches up to the
> > point where I've come across the first piece that needs to be
> > reworked (the rmap intent execution code), so there's no point
> > holding these back until I've sorted that out. This builds on top of
> > for-next and the patch set I posted yesterday.
> > 
> > Darrick, I've changed the authorship of the patches to reflect
> > the original series this has come from - can you check to see if
> > there's anything I got wrong when I did that?
> 
> I'll come some minor bits on the actual patches, but I'd like to
> understand a few fundamental things first:
> 
> For one Darrick has introduced a new rmapxbt btree recently, which
> allows using a rmap on reflink enabled file systems.  In his tree
> we thus have two different implementation of a reverse mapping
> btree.  Is there any good reason to keep it this way?  For one
> reflinks are a compelling feature that I doubt people want to
> disable in the long run, so most filesystem will be using rmapxbt.
> I also don't think having these two implementations is good for the
> testing matrix in the long run.

I haven't got as far as the rmapxbt code yet - it's currently at the
end of the entire series, and I'm trying to sort out problems in
infrastructure right now (i.e. rmapbt modifications are atomic and
crash safe w.r.t. bmapbt changes and EFI processing).

I'm planning on re-ordering the rmapxbt and interval query tree
stuff to before the reflink code is included, but I haven't got
hatfar yet so I haven't looked at the code yet. It's slow going, and
right now I don't think I'm going to have even a complete rmapbt
series done in time for the merge 4.6 merge window, let alone all
the extra stuff Darrick has done.

So with only a couple of days left before the merge window opens, I
think this all needs to slip to the next merge window while we sort
out what disk format we are going to use and rework the series to
introduce only that format.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
