Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2F05329DF5
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2015 06:20:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C860FAC001
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2015 04:20:39 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ZUqZkxXxZxHdITUt for <xfs@oss.sgi.com>;
	Mon, 02 Nov 2015 04:20:32 -0800 (PST)
Date: Mon, 2 Nov 2015 23:20:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/5] xfs: SGI ACL Fixes
Message-ID: <20151102122018.GH10656@dastard>
References: <1446217508-22157-1-git-send-email-agruenba@redhat.com>
	<20151102025352.GY19199@dastard>
	<CAHc6FU7As8=jA7FMC0N_gDuECxeb15iKn=uXpu2b57LHtcFPaA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU7As8=jA7FMC0N_gDuECxeb15iKn=uXpu2b57LHtcFPaA@mail.gmail.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, Nov 02, 2015 at 04:41:30AM +0100, Andreas Gruenbacher wrote:
> On Mon, Nov 2, 2015 at 3:53 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Oct 30, 2015 at 04:05:03PM +0100, Andreas Gruenbacher wrote:
> >> Here is a reworked patch queue that also handles setting SGI_ACL_{FILE,DEFAULT}
> >> via XFS_IOC_ATTRMULTI_BY_HANDLE.  Please review.
> >>
> >> Thanks,
> >> Andreas
> >>
> >> Andreas Gruenbacher (5):
> >>   xfs: Validate the length of on-disk ACLs
> >>   xfs: Plug memory leak in xfs_attrmulti_attr_set
> >
> > Ok, I've taken these two patches for the upcoming merge window as
> > they fix bugs, but I've taken Brian's cached ACL invalidation patch
> > instead of these:
> >
> >>   xfs: SGI ACLs: Fix caching and mode setting
> >>   xfs: Add namespace parameter to the xfs kuid/kgid <=> uid/gid wrappers
> >>   xfs: SGI ACLs: Map uid/gid namespaces
> >
> > I'm not yet convinced that these patches are the right way to solve
> > the given issue as they may interact badly with xfsdump/restore.
> 
> Well, what else do you need to be convinced? I guess it won't help if
> I try to explain everything all over again?

No, it won't. There are bigger picture questions and issues that
need to be sorted out first.

We've basically got zero regression test coverage of the "set the
ACL in on-disk format directly" code path, so we don't know if we're
breaking anything. That's a big red flag to me, because I can't
easily validate that the changes are working as expected..

IOWs, I don't know how the changes will impact dump/restore, apart
from the fact that dump/restore expects to be able to set the ACL
directly in the on-disk format without the kernel screwing with the
mode.  i.e. dump pulls the inode mode and ACLs in disk format from
the disk via bulkstat and restore expects to be able to recreate
them exactly without the kernel getting in it's way. Again, we have
basically no test coverage here, so again there's nothing I can do
to easily validate that the changes have not broken dump/restore in
subtle but important ways.

Further, we have no user namespace regression test coverage. I have
absolutely no idea if xfs_restore will even run in a user namespace,
let alone run correctly.  We already know that xfsdump cannot be
made to work in a confined user namespace due to it's use of
bulkstat, so do we really care whether xfs_restore works in a
namespace or not?  As such, it's not immediately obvious to me that
we should even allow setting acls directly in on-disk format in
user namespaces. And if we don't allow it, then the last two patches
can simply be dropped and replaced with simple CAP_SYS_ADMIN check.

I don't have time to sit down and write special point tests to
validate every change that comes through. However, ACLs are a security
mechanism and so we have to get them right and that means we need
such tests. If you want to convince me that your changes are
correct, are needed and don't break anything, then provide the
regression tests that prove it. Otherwise you're simply going to
have to wait for me to find the time to do it myself - I've got a
real long list of stuff I'd prefer to do than write ACL regression
tests....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
