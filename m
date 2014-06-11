Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 511E87F69
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 04:11:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C8460AC005
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 02:11:02 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Otf6YVAgu6VYBBpY for <xfs@oss.sgi.com>;
	Wed, 11 Jun 2014 02:11:00 -0700 (PDT)
Date: Wed, 11 Jun 2014 19:10:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [DISCUSS] Planning for new dev cycle (3.17)
Message-ID: <20140611091020.GO4453@dastard>
References: <20140609223320.GE9508@dastard>
	<20140610115857.GC46344@bfoster.bfoster>
	<20140610214850.GH9508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140610214850.GH9508@dastard>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 11, 2014 at 07:48:50AM +1000, Dave Chinner wrote:
> On Tue, Jun 10, 2014 at 07:58:57AM -0400, Brian Foster wrote:
> > On Tue, Jun 10, 2014 at 08:33:20AM +1000, Dave Chinner wrote:
> > > The issue is the negative error number patchset, and how to handle
> > > review and testing. The patchset is already 62 patches long and it
> > > converts roughly half the code base. It'll take me another couple of
> > > days to convert the rest of the code, and that will probably take
> > > another 60 patches.
> > > 
> > > I understand that reviewing 100+ patches is going to be a pain, but
> > > each patch currently averages about +/- 10 lines. The current
> > > diffstat is:
> > > 
> > > 	37 files changed, 723 insertions(+), 722 deletions(-)
> > > 
> > > And that will probably double, so it's still going to be a fair
> > > amount of change.
> > 
> > Is there any sort of more coarse logical breakdown of this series, or do
> > we want/need to convert the entire codebase all at once? The individual
> > patches sound relatively small... is there a particular method at play
> > there? E.g., a patch per function? file? call chain?
> 
> I'm doing it layer by layer, starting from the linux interface
> layers and working my way down. e.g. fs/xfs/xfs_file.c first,
> the fs/xfs/xfs_iops.c, and so on, and there are multiple patches per
> file for each (roughly) logical change. e.g. converting xfs_iops.c:
[...]

I've decided that there really is too much unnecessary code churn
from this approach. I end up converting all the call sites to negate
the error sign, and then end up converting them back to the original
code some time later, leaving only the source of the errors with a
changed sign.

So, I stopped doing that to see just what the brute force, change
source and conversions only, and I found with a few simple searches
I could identify all the locations that need changing. So, in a
couple of hours I churned out the patch that converted everything.
Still pretty large, even though it only changes error values and
conversion points.

67 files changed, 879 insertions(+), 884 deletions(-)

Not sure how I could break this up - it really is an all-or-nothing
patch this Big Hammer approach....

> > Perhaps if we just make a branch available with the patches, put a
> > notification on the list, and we can use that as a review
> > thread..?
> 
> I'll push the series to the git tree at the end of the day - I'm
> hoping to have the conversion mostly done by then. I did most of the
> rebase of the existing patchset on top of the libxfs addition last
> night, so I should e able to knock off most of the rest of the
> changes today. I wanted to see what people thought about the concept
> without cluttering the issue with a huge code dump...

Ok, so the version I pushed to the rebased xfs-libxfs-restructure
branch is the big hammer patch from above (commit fcec2eb "xfs:
global error sign conversion"). I also folded in the fix for the
problem Eric pointed out (which is why it's a rebase).  That branch
is running xfstests right now on several machines and hasn't gone
boom, so i can't have screwed it up too badly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
