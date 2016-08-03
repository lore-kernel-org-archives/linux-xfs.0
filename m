Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 83FD07CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 17:58:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3984D304048
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 15:58:01 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	asVicowDv8Dkrvty for <xfs@oss.sgi.com>;
	Wed, 03 Aug 2016 15:57:58 -0700 (PDT)
Date: Thu, 4 Aug 2016 08:57:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/47] xfs: move deferred operations into a separate file
Message-ID: <20160803225756.GW16044@dastard>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907703710.25461.16650495404061662831.stgit@birch.djwong.org>
	<20160801080223.GB30547@infradead.org>
	<20160802223950.GN16044@dastard>
	<20160803091627.GA5289@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160803091627.GA5289@infradead.org>
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

On Wed, Aug 03, 2016 at 02:16:27AM -0700, Christoph Hellwig wrote:
> On Wed, Aug 03, 2016 at 08:39:50AM +1000, Dave Chinner wrote:
> > Rather than have to make major changes to core infrastructure now,
> > let's work this out as a separate patchset to clean up the rmap and
> > reflink code in the next couple of releases. It's going to be better
> > to get working code out there now under the experimental tag than it
> > is is to keep it as an out of tree patchset for another cycle.
> 
> The problm is that this does not only affect the rmap code (for which
> I suspect it actually is fine), but also regresses the freed extent
> logging.  If you want minimal changes we should simply drop the patches
> to move over the freed extent tracking to the new deferred ops
> mechanism for now.

I haven't said I want "minimal changes". 

What I don't want to do is make large, untested changes at the last
minute, especially when there's no evidence that there is a
regression caused by the code being changed. We need this kind of
infrastructure for reflink, and there's no point rewriting the rmap
code to remove it just to then have to immediately re-introduce it
back into to the rmap code so it works with reflink. It's pointless
churn and invalidates all the testing we've done on rmap up to this
point.

I don't understand what problem or regression you think this code
causes, mainly because it hasn't been explained or demonstrated. I
don't understand the solution being proposed, because the little
that has been described tells me nothing about what the problem it
solves is, nor how it solves the atomicity and ordering requirements
that updating the bmbt, refcountbt and rmapbt have.

I have no issues with fixing the code if it is broken, but first
everyone needs to undestand how it is broken. It's time to make
progress on this functionality - if we wait for the code to be
perfect before it gets merged, we'll never make any progress.

So, please explain in more detail what the problem is and what the
proposed solution is so I (and probably Darrick, too) have some
understanding of the issue you see with this code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
