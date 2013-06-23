Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4C5E27F37
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 18:44:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 37E1C8F8033
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 16:44:33 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jfGTvFnqtv55n202 for <xfs@oss.sgi.com>;
	Sun, 23 Jun 2013 16:44:31 -0700 (PDT)
Date: Mon, 24 Jun 2013 09:44:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: group for tests that are dangerous for verifiers?
Message-ID: <20130623234427.GG29376@dastard>
References: <51C341E1.8000302@sgi.com> <51C49F5A.3020907@sandeen.net>
	<20130623225053.GA29376@dastard> <51C77D6D.4020107@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51C77D6D.4020107@sandeen.net>
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
Cc: Mark Tinguely <tinguely@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Sun, Jun 23, 2013 at 05:57:49PM -0500, Eric Sandeen wrote:
> On 6/23/13 5:50 PM, Dave Chinner wrote:
> > On Fri, Jun 21, 2013 at 01:45:46PM -0500, Eric Sandeen wrote:
> >> On 6/20/13 12:54 PM, Mark Tinguely wrote:
> >>> Do we need a xfstest verifier dangerous group?
> >>>
> >>> xfstest 111 purposely damages inodes. In hindsight it make sense
> >>> that it asserts when running with verifiers.
> >>
> >> But it only asserts on a debug kernel... 
> > 
> > Right, and it has done so for years - blaming verifiers for
> > triggering the assert failure is simply shooting the messenger.
> 
> But this test *intentionally* corrupts, right?  So it's prudent
> to not run a test which you *know* will explode if it runs
> as designed.

Common sense, really.

> >> This isn't the only place where corruption could ASSERT on debug;
> >> see xlog_recover_add_to_trans() for example.
> >>
> >> But if the test intentionally corrupts it and that leads to
> >> an ASSERT that does seem problematic for anyone testing w/ debug
> >> enabled.
> > 
> > Yup, it runs src/itrash.c which corrupts every inode it can find.
> > 
> > That's the reason this test is not part of the auto group - it's
> > a test that will cause the system to stop. We've got other tests
> > that are not part of the auto group for exactly the same reason -
> > they cause some kind of terminal failure and so aren't candidates
> > for regression testing.
> 
> Then maybe just part of the normal dangerous group would be enough.

It will only run from the ioctl group today (bulkstat, I guess), so
I'd say that adding it to the dangerous group doesn't add any real
value except documentation. And it's just as easy to remove the
ASSERT() as it is really unnecessary....

> Except this isn't transient (today) - it's not a case where old kernels
> may oops, it's where it's *designed* to oops on this test, with a debug
> kernel.
> 
> So I guess I could see a debug-dangerous group ;)
> 
> >> I guess I'd vote for removing the ASSERT unless there's
> >> some reason it should be there - Dave?
> > 
> > I'm fine with it being removed - we catch the failure just fine. If
> > that then makes 111 work as a regression test (i.e. doesn't trigger
> > the bad-inode bulkstat loop it was designed to test) then perhaps we
> > can consider making that part of the auto group, too...
> 
> Removing it sounds like the best option then.

*nod*

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
