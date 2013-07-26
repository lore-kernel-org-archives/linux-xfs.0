Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4B6D67F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 19:39:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2E9B78F8033
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 17:39:59 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	xgZPuAtlt7Iwlwu1 for <xfs@oss.sgi.com>;
	Thu, 25 Jul 2013 17:39:57 -0700 (PDT)
Date: Fri, 26 Jul 2013 10:39:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/48] libxfs: add crc format changes to generic btrees
Message-ID: <20130726003953.GA21982@dastard>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-4-git-send-email-david@fromorbit.com>
	<20130723182648.GI3111@sgi.com> <20130725004821.GC11222@dastard>
	<20130725171509.GZ3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130725171509.GZ3111@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 25, 2013 at 12:15:09PM -0500, Ben Myers wrote:
> Dave,
> 
> On Thu, Jul 25, 2013 at 10:48:21AM +1000, Dave Chinner wrote:
> > On Tue, Jul 23, 2013 at 01:26:48PM -0500, Ben Myers wrote:
> > > On Fri, Jun 07, 2013 at 10:25:26AM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > 
> > > This patch mostly corresponds to commit ee1a47ab0e, and in some areas it is
> > > equivalent but slightly different.  There are some other things in here too:
> > > 
> > > * Addition of XFS_BUF_DADDR_NULL
> > > * rename of b_blkno to b_bn in struct xfs_buf
> > > * rename of b_fsprivate to b_fspriv in struct xfs_buf
> > > * addition of uuid_copy and uuid_equal, and libuuid to build
> > > 
> > > It all looks fine to me, except as below:
> > 
> > I think you'll find they are fixed up in later patches in the
> > series.
> > 
> > Indeed, I think it's a little late to asking for these patches to be
> > changed, considering that making significant changes to these first
> > few patches will mean that I have to rebase a 100 or so subsequent
> > patches.
> 
> You are mistaken...

Mistaken about what, exactly? That a rebase will take days to do and
retest, while an additional patch will take minutes? 

I don't even have this series set up with guilt anymore - it's
been so long since it was committed to the crc-dev branch that I
moved over to working on that branch and adding patches on top of it
to fix issues. I've simply assumed that this patchset is fixed in
concrete and any problems will be layered on top.

People are already using this code, so we've already got a
significant amount of test exposure to it. Going back and modifying
and completely rebasing it invalidates all that test coverage.
Rebasing is not a risk-free operation, and when that is combined
with the amount of time needed for a rebase of such a series, I'd
much prefer that code that is in the crc-dev tree remains untouched
and we layer fixes on top of it...

> > For issues that aren't fixed in later patches, I'll add new patches
> > to the end of the current series to fix them.
> 
> ...but I have no objection to taking this approach, so long as my
> concerns are addressed.

Which, for this patch, have already been addressed in subsequent
patches....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
