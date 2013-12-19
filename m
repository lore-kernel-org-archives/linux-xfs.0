Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 83DE129DF8
	for <xfs@oss.sgi.com>; Thu, 19 Dec 2013 16:04:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 679D98F809E
	for <xfs@oss.sgi.com>; Thu, 19 Dec 2013 14:04:55 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	fQ89AFWYox5QWB4Z for <xfs@oss.sgi.com>;
	Thu, 19 Dec 2013 14:04:50 -0800 (PST)
Date: Fri, 20 Dec 2013 09:04:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Userspace and xfstests releases
Message-ID: <20131219220446.GA31386@dastard>
References: <52B06E51.1020504@sgi.com> <52B32CE0.5070701@sgi.com>
	<20131219193314.GX1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131219193314.GX1935@sgi.com>
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
Cc: Rich Johnston <rjohnston@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Dec 19, 2013 at 01:33:14PM -0600, Ben Myers wrote:
> Hey Rich,
> 
> On Thu, Dec 19, 2013 at 11:29:04AM -0600, Rich Johnston wrote:
> > On 12/17/2013 09:31 AM, Rich Johnston wrote:
> > >I was planning on a xfsdump and xfstests release this week before I go
> > >on vacation. Any objections?
> > Currently xfstests is not released, should this be changed?
> > 
> > I will wait until I return on Jan 2 to release xfsprogs.
> > 
> > >
> > >Release versions for xfsprogs are still being discussed. Are there any
> > >more comments on this subject?
> > Here is one of the threads discussing this.
> > 
> > http://oss.sgi.com/archives/xfs/2013-10/msg00421.html
> > Christoph were you saying you create xfsprogs branches?
> > 
> > Is there a consensus on version names/branches for xfsprogs?
> 
> I suggest a branch directly off of 3.1.11 release, and then we can troll the
> log between refs/tags/3.1.11 and master for bugfixes.
> 
> e.g. git checkout -b for-3.1.12 refs/tags/3.1.11
> 
> And then push it up to oss.

Agreed - we're not really ready for a 3.2.0 release yet. I also
think that we'll need a couple of weeks to test any 3.1.12 branch
that is made before it can be released, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
