Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 896A27F52
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 17:10:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6B2C9304039
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 15:10:11 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	dTHPiuoCR4gBgwtI for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 15:10:09 -0700 (PDT)
Date: Thu, 2 May 2013 08:10:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs-3.1.11 pre-release   please test!
Message-ID: <20130501221007.GP10481@dastard>
References: <51817712.6000807@sgi.com> <51817C88.4060208@sgi.com>
	<518182BA.4010406@sandeen.net> <51818679.1030408@sgi.com>
	<518187D0.6000809@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <518187D0.6000809@sandeen.net>
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
Cc: Rich Johnston <rjohnston@sgi.com>, Mark Tinguely <tinguely@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, May 01, 2013 at 04:23:28PM -0500, Eric Sandeen wrote:
> On 5/1/13 4:17 PM, Mark Tinguely wrote:
> > On 05/01/13 16:01, Eric Sandeen wrote:
> >> On 5/1/13 3:35 PM, Mark Tinguely wrote:
> >>> On 05/01/13 15:12, Rich Johnston wrote:
> >>>> I have placed a pre-release tarball here:
> >>>>
> >>>> ftp://oss.sgi.com/projects/xfs/cmd_tars/pre-release/xfsprogs-pre-3.1.11-3.tar.gz
> >>>>
> >>>>
> >>>> Please take a look and report any issues before next Wednesday (08 May
> >>>> 2013). If there are other patches which you feel are essential, now is
> >>>> the time to say so.
> >>>>
> >>>> Regards
> >>>> --Rich
> >>>
> >>> The new lines (below) in xfs_check.sh breaks older xfstests:
> >>>
> >>>    xfs_check is deprecated and scheduled for removal in June 2014.
> >>>    Please use xfs_repair -n<dev>  instead.
> >>
> >> Hum, I thought xfstests stopped calling xfs_check.sh and implemented
> >> its own xfs_check internally:
> >>
> >> commit 187bccd310dc253feaebd69df4ccdda21eee12d0
> >> Author: Chandra Seetharaman<sekharan@us.ibm.com>
> >> Date:   Thu Apr 18 17:44:02 2013 +0000
> >>
> >>      xfstests: Remove dependence of xfs_check script
> >>
> >>      Replace the usage of the script xfs_check and add the relevant code to
> >>      xfstests.
> >>
> >> ...
> >> -        [ "$XFS_CHECK_PROG" = "" ]&&  _fatal "xfs_check not found"
> >> ... etc ...
> >>
> >> where is check getting called directly?
> >>
> >> (Or: is your xfstests up to date?)
> >>
> >> -Eric
> > 
> > I disclosed it as an older xfstests.
> 
> Sorry, I missed that.
> 
> > It is conceivable that people will install the latest xfsprogs and not upgrade xfstests. I can hear it now, "It used to just work..." :)
> 
> So what's the proposed solution? ;)

Upgrade xfstests.

> TBH I think xfstests is the kind of thing that is in so much flux
> you should always assume you need a newer version.

That has always been the case.

> And since it's mostly qe/devel types using it, I'd submit that
> they can figure it out, but if you have a better idea, I'm all
> ears!

Given the number of people that are likely to hit this, then I think
leaving it as it stands is just fine. The expectation is that you
should be using an xfstests that matches the age of your userspace
tools, otherwise you are not going be running all the tests necessary
to exercise the current userspace functionality you have installed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
