Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8A7487F3F
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 17:48:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 17248AC004
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 15:48:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	QGEmiUyDovgReUfx for <xfs@oss.sgi.com>;
	Tue, 15 Oct 2013 15:48:35 -0700 (PDT)
Date: Wed, 16 Oct 2013 09:48:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: projid32bit=1 default in xfsprogs-3.2.0
Message-ID: <20131015224831.GZ4446@dastard>
References: <525C1C15.7020204@sandeen.net> <20131014211659.GI5663@dastard>
	<20131014212347.GB1935@sgi.com> <525C6108.6010108@sandeen.net>
	<20131015194609.GC32095@infradead.org>
	<20131015204342.GA24997@infradead.org>
	<20131015212214.GC1935@sgi.com>
	<20131015213110.GA5895@infradead.org>
	<20131015214910.GX10553@sgi.com> <525DBA50.5000202@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <525DBA50.5000202@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Oct 15, 2013 at 04:57:36PM -0500, Eric Sandeen wrote:
> On 10/15/13 4:49 PM, Ben Myers wrote:
> > Hey,
> > 
> > On Tue, Oct 15, 2013 at 02:31:10PM -0700, Christoph Hellwig wrote:
> >> On Tue, Oct 15, 2013 at 04:22:14PM -0500, Ben Myers wrote:
> >>> The tags are out there:
> >>> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsprogs.git;a=tags
> >>
> >> I managed to somehow miss them.  Sorry!
> > 
> > np
> >  
> >>> That's an interesting idea.  We hadn't discussed a 3.1.12 release.  No
> >>> particular objection to doing that, it's just that we didn't branch for the
> >>> v3.0.5->v3.1.0 set of releases.  Maybe it is better if we all focus on 3.2.0.
> >>
> >> With git you can easily branch from a past commit, e.g.:
> >>
> >> hch@brick:~/work/xfsprogs$ git checkout -b release-3.1 v3.1.11
> >> Switched to a new branch 'release-3.1'
> > 
> > Yep.  If folks want a 3.1.12 we should certainly kick the idea around a bit.
> > I'm just guessing that most would prefer to focus on a 3.2.0 in the near term.
> > Maybe I'm mistaken about that though.  ;)
> 
> I'm not super keen to divide the focus; I've already updated the distros I
> care about to 3.2.0-alpha1, so I wouldn't go backwards to a 3.1.12.

I'd prefer we focus on getting stuff reviewed and integrated into
3.2.0 more quickly than we are now.  At this point in the cycle, we
really need the 3.2 branch and xfstests to be updated daily with the
changes that were reviewed in the past 24 hours so that we can
iterate test cycles with the latest fixes more easily.

This will give us a clearer idea of the problems we still need to
fix before the release can progress without everyone having to keep
their own private trees up to date with what everyone else is
changing/fixing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
