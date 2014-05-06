Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 230607FF0
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 04:06:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1B979304032
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 02:06:39 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	f0NCcVRJgFBbsOpn for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 02:06:38 -0700 (PDT)
Date: Tue, 6 May 2014 19:06:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] xfs: turn NLINK feature on by default
Message-ID: <20140506090636.GJ5421@dastard>
References: <1399348559-19889-1-git-send-email-david@fromorbit.com>
	<1399348559-19889-4-git-send-email-david@fromorbit.com>
	<20140506081518.GB24143@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140506081518.GB24143@infradead.org>
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

On Tue, May 06, 2014 at 01:15:18AM -0700, Christoph Hellwig wrote:
> >  
> > @@ -1112,7 +1085,7 @@ xfs_bumplink(
> >  		 * system to do this, then we need to bump the superblock
> >  		 * version number as well.
> >  		 */
> > -		xfs_bump_ino_vers2(tp, ip);
> > +		xfs_bump_ino_vers2(ip);
> 
> The comment here is certainly out of date now.
> 
> But I think keeping these xfs_bump_ino_vers2 calls around everywhere is
> wrong to start with.  xfs_iread should make sure all inodes are version
> 1, that allows to kill xfs_bump_ino_vers2 entirely, and probably also
> simplify xfs_ialloc a little more.  At the point we won't have to deal
> with v1 inodes anywhere but in xfs_iread, and we can have a big fat
> comment in that place why we even bother with the v1 inodes, because
> the fact that we have the hasnlink bit but inodes might still be old
> format is something we'll all have forgotten about in a few years,
> and new developers will never figure out by themselves.

OK, I'll look at reworking it aong those lines.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
