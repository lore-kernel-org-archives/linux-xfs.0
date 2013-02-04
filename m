Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AC01A7F54
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 07:18:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B610AC004
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 05:18:32 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	8pXmzfXXX6PLZ7Cj for <xfs@oss.sgi.com>;
	Mon, 04 Feb 2013 05:18:23 -0800 (PST)
Date: Tue, 5 Feb 2013 00:18:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: add agskip=value mount option
Message-ID: <20130204131811.GM2667@dastard>
References: <20130129153914.801475275@sgi.com>
	<20130129153914.976867239@sgi.com>
	<20130130010430.GE7255@disturbed.disaster>
	<20130130233203.GP27055@sgi.com>
	<20130131061321.GI32297@disturbed.disaster>
	<510AD2E2.1020309@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <510AD2E2.1020309@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Thu, Jan 31, 2013 at 02:24:02PM -0600, Rich Johnston wrote:
> On 01/31/2013 12:13 AM, Dave Chinner wrote:
> >On Wed, Jan 30, 2013 at 05:32:03PM -0600, Ben Myers wrote:
> >>Hey Dave,
> >>
> >>On Wed, Jan 30, 2013 at 12:04:30PM +1100, Dave Chinner wrote:
> >>>On Tue, Jan 29, 2013 at 09:39:15AM -0600, rjohnston@sgi.com wrote:
> >>>>The agskip mount option specifies  the allocation group, (AG) for a new
> >>>>file, relative to the start of the last created file. agskip has the
> >>>>opposite effect of the rotorstep  system tunable  parameter.   Each
> >>>>new  file  to  be placed in the location lastAG + agskipValue,
> >>>>where lastAG is the allocation group of the last created file.
> >>>>
> >>>>For example, agskip=3 means each new file will be  allocated  three  AGs  away
> >>>>from the starting AG of the most recently created file.
> >>>
> >>>Overall, I'm wondering if this is the right way to approach this
> >>>problem.
> 
> I did not see any references to the patchset you referenced below
> when I was  working on submitting this patchset. Thanks for pointing
> it out.
> 
> >http://oss.sgi.com/archives/xfs/2009-02/msg00250.html
> 
> The patchset (pluggable allocation policies) above looks very
> promising and I would like to port it to top of tree and use it
> instead of my agskip proposal.  Are there any changes to this
> patchset we should discuss before I start.

Well, apart from the fact you'll probably have to rewrite parts of
it from the ground up because the xfs_bmap.c code and inode
allocation code has been significantly factored since those patches
were written. Porting them, IMO, is mostly not an option because the
chance of missing bug fixes and enhancements from the past 5 years
is too great.

Also, the patchset was still at the proof of concept stage, and some
of the stuff may not be supportable. e.g. the policy templates and
multiple instantiation code. They were wild ideas I was trying to
see if I could get to work, so they may well be something we don't
really want to try to do.

Also, the patch set is really an encoding of work in progress, not a
finished and refined patch set. Several of the patches rework the
same code over and over again and, for example, the on-disk
representation of the allocation policy is changed at least once
during the series. The on-disk format should be defined once during
a mergable patch series and not changed at all, so this shows that
the patch set is really a line of research rather than a
ready-for-production piece of work.

Further, the userspace interfaces will need to be completely
rethought. Looking at the per-parameter ioctl interface, it's pretty
nasty and convoluted probably isn't eaily usable - i never wrote any
userspace code for it, so it's just an encoding of an idea more than
anything.

Finally, it doesn't have any of the storage configuration
information encoded into it (eg. for a generic ag_skip like
solution) and no interface to add that information.  That was work
that was going to build on this policy interface, but now I think it
is completely orthogonal to the policy interface as it has
completely separate uses (like defining failure domains).

Right now I think that it is better to add the storage layout
information to the filesystem, then worry about how generic
allocation policies can use that information. However, doing an
initial abstraction of the inode and data allocation code (patches
3-7) configured via the existing mount options and making stuff like
the "everything inherits from the parent inode" functionality and
the inode64->inode32 transitions during growfs work correctly would
be a good set of functionality that coul dbe pulled mostly unchanged
from the patch set. That abstraction is relatively straight
forward and lays the foundation for more complex allocation policies
to be implemented, but doesn't go as far as some of the semi-insane
ideas I was trying out later in the series...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
