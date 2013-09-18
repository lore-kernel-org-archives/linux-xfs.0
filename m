Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 419177F6D
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 18:24:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1B2E7304043
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 16:24:28 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	dsFdmXWlky1CnavY for <xfs@oss.sgi.com>;
	Wed, 18 Sep 2013 16:24:26 -0700 (PDT)
Date: Thu, 19 Sep 2013 09:24:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs: lookaside cache for xfs_buf_find
Message-ID: <20130918232409.GF9901@dastard>
References: <1378690396-15792-1-git-send-email-david@fromorbit.com>
	<523A1FBD.4010701@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <523A1FBD.4010701@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 18, 2013 at 04:48:45PM -0500, Mark Tinguely wrote:
> On 09/08/13 20:33, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >CPU overhead of buffer lookups dominate most metadata intensive
> >workloads. The thing is, most such workloads are hitting a
> >relatively small number of buffers repeatedly, and so caching
> >recently hit buffers is a good idea.
> >
> >Add a hashed lookaside buffer that records the recent buffer
> >lookup successes and is searched first before doing a rb-tree
> >lookup. If we get a hit, we avoid the expensive rbtree lookup and
> >greatly reduce the overhead of the lookup. If we get a cache miss,
> >then we've added an extra CPU cacheline miss into the lookup.
....
> 
> Low cost, possible higher return. Idea looks good to me.
> 
> What happens in xfs_buf_get_map() when we lose the xfs_buf_find() race?

What race is that?

> I don't see a removal of the losing lookaside entry inserted in the
> xfs_buf_find().

Why would we want to do removal of an entry if some other lookup
aliases to the same slot and doesn't match? If the buffer we are
looking up isn't in cache at all, then we've just removed something
that has had previous cache hits and is still in cache without
inserting anything in it's place. If the buffer is in the cache,
then we do an insert once we've found it. i.e. there is no need to
do removal on lookup miss...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
