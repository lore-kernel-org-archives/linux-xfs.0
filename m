Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 902627CA0
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 10:58:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4130B8F8040
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 08:57:59 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 5ykynyij83ooZRmI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Mar 2016 08:57:57 -0800 (PST)
Date: Thu, 10 Mar 2016 08:57:17 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/16] xfs: first part of rmapbt functionality
Message-ID: <20160310165717.GH27973@birch.djwong.org>
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

The only compelling reason for the split rmapbt/rmapxbt is to increase the
fanout factor for (!reflink && rmap) by a factor of 5.  If we assume a 4K
block size, that works out to the rmapbt occupying about 0.023% more space.
(It's half a percent for a 1k block size, but I assume that's not a common
case.)

Functionality-wise, there's no reason why we can't just run the rmapxbt
even if reflink is disabled.  If our notion is to introduce both features
at the same time then Christoph is probably right that we don't need to
have both tree types.

--D

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
