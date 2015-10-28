Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EAE0429DF5
	for <xfs@oss.sgi.com>; Wed, 28 Oct 2015 17:35:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A4BF030405F
	for <xfs@oss.sgi.com>; Wed, 28 Oct 2015 15:35:46 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1oQfAbzq5Oj9oIrA for <xfs@oss.sgi.com>;
	Wed, 28 Oct 2015 15:35:43 -0700 (PDT)
Date: Thu, 29 Oct 2015 09:35:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/8] xfsdump: Ouchie! My bleeding eyes!
Message-ID: <20151028223542.GR8773@dastard>
References: <1444959901-31319-1-git-send-email-david@fromorbit.com>
	<20151028115138.GB50552@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151028115138.GB50552@bfoster.bfoster>
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

On Wed, Oct 28, 2015 at 07:51:39AM -0400, Brian Foster wrote:
> On Fri, Oct 16, 2015 at 12:44:53PM +1100, Dave Chinner wrote:
> > Hi folks,
> > 
> > Turns out that changes to exported XFS headers in xfsprogs v4.2.0
> > broke the xfsdump build. the XFS dump build was implicitly including
> > the platform definitions calculated for the xfsprogs build and so
> > removing them from the xfsprogs headers made xfsdump very unhappy.
> > 
> ...
> > 
> > So, now the code base is a little bit cleaner, a lot less dependent
> > on the xfsprogs header files, compiles cleanly on xfsprogs 3.2.x and
> > 4.x releases, can easily have asserts build in or excluded (distro
> > packages need to use "export DEBUG=-DNDEBUG" to exclude asserts),
> > passes xfstests with asserts enabled and disabled, and best of all
> > the source code is a little less eye-bleedy.
> > 
> > I really don't expect anyone to review this closely - it's *huge*
> > chunk of boring search/replace change:
> > 
> >  94 files changed, 2929 insertions(+), 2652 deletions(-)
> > 
> > but I would like people to comment on/ack the approach I've taken
> > here. If nobody objects/cares, I'll then do a 3.1.6 release early
> > next week....
> > 
> 
> I sent some comments on patch 1, otherwise the rest looks reasonable to
> me on a quick pass through. The only thing I noticed is that the series
> introduced a handful of whitespace problems. I didn't go and track them
> into the individual patches, but here's the full output from my patch
> import:

it didn't add any whitespace problems...

> 
> Applying: cleanup: get rid of ASSERT
> /home/bfoster/repos/xfsdump/.git/rebase-apply/patch:3725: space before tab in indent.
>         assert( namebuf );
> /home/bfoster/repos/xfsdump/.git/rebase-apply/patch:5656: trailing whitespace.
>         assert ( ent != NULL );
> /home/bfoster/repos/xfsdump/.git/rebase-apply/patch:5855: trailing whitespace.
>         assert ( ent != NULL );

s/ASSERT/assert/ does not change any of the whitespace, but it will
complain about it because the new line has whitespace problems
because they existed in the old line...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
