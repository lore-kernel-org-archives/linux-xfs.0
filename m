Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C7FA77CA0
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 18:44:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 36D55AC005
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 16:44:19 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	vBqi4JE47NltcQzE for <xfs@oss.sgi.com>;
	Thu, 04 Aug 2016 16:44:16 -0700 (PDT)
Date: Fri, 5 Aug 2016 09:44:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/47] xfs: move deferred operations into a separate file
Message-ID: <20160804234413.GB16044@dastard>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907703710.25461.16650495404061662831.stgit@birch.djwong.org>
	<20160801080223.GB30547@infradead.org>
	<20160802223950.GN16044@dastard>
	<20160803091627.GA5289@infradead.org>
	<20160803225756.GW16044@dastard>
	<20160804160007.GA7649@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160804160007.GA7649@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Thu, Aug 04, 2016 at 09:00:07AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 04, 2016 at 08:57:56AM +1000, Dave Chinner wrote:
> > So, please explain in more detail what the problem is and what the
> > proposed solution is so I (and probably Darrick, too) have some
> > understanding of the issue you see with this code.
> 
> We were doing 1 (actually 2 with the busy extent tracking) allocations
> for each free extent, and now we're up to three.  We need to get this
> down to 1 and not increase it for no benefit.

Oh, it's memory allocations in the extent freeing path you're
worried about? That's a minor concern at this point, really. We do
some many other allocations in these paths (e.g. multiple
allocations for every metadata buffer that is not in cache) that
another is not going to make any difference to the system stability
or performance.

Yes, it would be good to reduce the number of allocations, but it's
not critical to the correct functioning of the code. hence it
doesn't need to be solved right now, and We can work on optimising
this over the next few months as we clean up all the rough edges we
find.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
