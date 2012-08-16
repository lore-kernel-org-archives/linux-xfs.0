Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7GMRBfc195985 for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 17:27:11 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	VVqreXDCQmAhrC0H for <xfs@oss.sgi.com>;
	Thu, 16 Aug 2012 15:27:10 -0700 (PDT)
Date: Fri, 17 Aug 2012 08:27:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfstests: loop devices vs umount stupidity
Message-ID: <20120816222706.GW2877@dastard>
References: <1343291706-14882-1-git-send-email-david@fromorbit.com>
	<1343291706-14882-3-git-send-email-david@fromorbit.com>
	<502D470C.6070506@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <502D470C.6070506@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 16, 2012 at 02:16:28PM -0500, Rich Johnston wrote:
> On 07/26/2012 03:35 AM, Dave Chinner wrote:
> >From: Dave Chinner <dchinner@redhat.com>
> >
> >Unmounting a fileystem mounted on a loop device doesn't always tear
> >down the loop device. Its racy, and it causes tests to randomly
> >fail.
> >
> >To avoid that, we have to use umount -d to ensure that we destroy
> >loop devices under filesystems in case the kernel doesn't tear it
> >down automatically to prevent the test from failing.  However, if
> >the kernel does tear it down automatically, umount now issues a
> >warning that it couldn't tear down the loop device because it
> >couldn't find it, and that causes the test to fail. *facepalm*
> >
> >So, convert all the loop device unmounts to use -d, and direct the
> >output of all of them to /dev/null.
> >
> >Signed-off-by: Dave Chinner <dchinner@redhat.com>
.....
> 
> Test 250 Fails but a bug is already created for this, PV1026237.

News to me. Recording failures in non-public bug trackers, and then
alluding to it via a number that nobody can look up is not very
helpful.  If you are going to track mainline kernel
failures/regressions in a bug tracker, please use the oss.sgi.com
bugzilla so that the issues are publicly visible....

> Other than that it looks good and the bug is not related to this
> patch, so ...

.... what is the failure you are seeing?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
