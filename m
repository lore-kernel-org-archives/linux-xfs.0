Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 511717F58
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 19:59:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2B96A8F8059
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 17:59:48 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	1ulrSsWfbqXm1tpV for <xfs@oss.sgi.com>;
	Mon, 07 Oct 2013 17:59:46 -0700 (PDT)
Date: Tue, 8 Oct 2013 11:59:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: fix inadvertent mkfs default change for
	projid32bit
Message-ID: <20131008005943.GV4446@dastard>
References: <5251C2F8.80009@redhat.com> <20131008003713.GQ4446@dastard>
	<525355EA.9080100@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <525355EA.9080100@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Oct 07, 2013 at 07:46:34PM -0500, Eric Sandeen wrote:
> On 10/7/13 7:37 PM, Dave Chinner wrote:
> > On Sun, Oct 06, 2013 at 03:07:20PM -0500, Eric Sandeen wrote:
> >> This commit:
> >>
> >> f3edb66a mkfs.xfs: validate options for CRCs up front.
> >>
> >> seems to have inadvertently switched to 32bit project IDs by default:
> >>
> >> -       int                     projid32bit;
> >> +       int                     projid16bit;
> >> ...
> >> -       projid32bit = 0;
> >> +       projid16bit = 0;
> >>
> >> Switch back to 16 bit project ID by default, at least until we
> >> intentionally make that change.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> >> index eafbed3..ebab09d 100644
> >> --- a/mkfs/xfs_mkfs.c
> >> +++ b/mkfs/xfs_mkfs.c
> >> @@ -965,7 +965,7 @@ main(
> >>  	textdomain(PACKAGE);
> >>  
> >>  	attrversion = 2;
> >> -	projid16bit = 0;
> >> +	projid16bit = 1;
> >>  	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
> >>  	blocklog = blocksize = 0;
> >>  	sectorlog = lsectorlog = XFS_MIN_SECTORSIZE_LOG;
> > 
> > And so:
> > 
> >                 /* 32 bit project quota always on */
> >                 /* attr2 always on */
> >                 if (projid16bit == 1) {
> >                         fprintf(stderr,
> > _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
> >                         usage();
> >                 }
> > 
> > That will prevent mkfs from making a CRC enabled filesystem.
> 
> Well, that's quite fixable.
> 
> > And, realistically, what's the problem with enabling 32 bit project
> > IDs by default for all new filesystems in 3.2.0? I'm of the opinion
> > we should just leave the code as it is because all kernels since
> > 2.6.37 support 32 bit projid and any kernel picking up
> > xfsprogs-3.2.0 when it is released will have a kernel that supports
> > it....
> 
> Doesn't really bother me -
> 
> But please send a man page patch.  ;)
> 
> And then we need to fix up xfstests... at least one fails as a result of
> this IIRC, I'll have to go look again.

See the link in my reply to the xfstests patch....

> 
> I don't care if the defaults change but I'd prefer it to not
> have happened accidentally via
> 
> "mkfs.xfs: validate options for CRCs up front" ;)
> 
> It wasn't documented & didn't seem intentional, so it needs
> fixing one way or the other.

It was intentional (see above), just not documented ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
