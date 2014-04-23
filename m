Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BADFF7F53
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 18:09:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9F06C8F804B
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 16:09:18 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	u3K0wQYlC2ZCAVqj for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 16:09:16 -0700 (PDT)
Date: Thu, 24 Apr 2014 09:09:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfs: introduce new large ACL test
Message-ID: <20140423230915.GV15995@dastard>
References: <1398204274-2113-1-git-send-email-david@fromorbit.com>
	<1398204274-2113-4-git-send-email-david@fromorbit.com>
	<20140423152313.GC26128@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140423152313.GC26128@infradead.org>
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

On Wed, Apr 23, 2014 at 08:23:13AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 23, 2014 at 08:04:31AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Having just removed the largeacl test from the shared ACL test,
> > reintroduce the same test as an XFS specific test so that we can
> > handle the different limits in supported ACL count appropriately.
> 
> I'd prefer to have this as a shared test, and define a _max_acl_size
> function in common.acl that does a switch for the fs type.  Only
> start with XFS for now, but if the maintainers of other filesystems
> care enough they could add their limits.

Ok, I'll add it as a generic test, along with a _max_acl_size
function and a _requires_max_acl_size helper....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
