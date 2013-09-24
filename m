Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9EB5229DFB
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 16:07:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2FD5CAC009
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 14:07:24 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DN3HdnRCAioHHGQt for <xfs@oss.sgi.com>;
	Tue, 24 Sep 2013 14:07:21 -0700 (PDT)
Date: Wed, 25 Sep 2013 07:06:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: v2 fix node forward in xfs_node_toosmall
Message-ID: <20130924210653.GB26872@dastard>
References: <20130920220519.585903357@sgi.com>
	<20130923171911.273669684@sgi.com> <20130923234819.GW9901@dastard>
	<5241CD70.7050800@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5241CD70.7050800@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: stable@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 24, 2013 at 12:35:44PM -0500, Mark Tinguely wrote:
> On 09/23/13 18:48, Dave Chinner wrote:
> >On Mon, Sep 23, 2013 at 12:18:58PM -0500, Mark Tinguely wrote:
> >>Commit f5ea1100 cleans up the disk to host conversions for
> >>node directory entries, but because a variable is reused in
> >>xfs_node_toosmall() the next node is not correctly found.
> >>If the original node is small enough (<= 3/8 of the node size),
> >>this change may incorrectly cause a node collapse when it should
> >>not.
> >
> >The comment about the size of the node triggering a collapse is
> >irrelevant - nodes always collapse at that given size. What this
> >doesn't tell us is why the crash occurs - "the next node is not
> >correctly found" is not particularly obvious, and would require
> >quite a bit of code reading to work out from first principles a
> >couple of years down the track.
> >
> >The commit message should be more precise and describe what the
> >underlying cause of the failure was. i.e. that the node is finding itself as the merge
> >candidate because we go forward, overwrite the pointers and the new
> >block's backward sibling is the original block which is where we end
> >up on teh second loop.  And vice versa if we go backwards first...
> >
> >Also, the "next node" is correctly termed a "sibling", and it's
> >either the forwards or backwards sibling, not the "next" sibling as
> >the direction of movement is important. So perhaps this
> >is better written as:
> >
> >"When a node is considered for a merge with a sibling, it overwrites
> >the sibling pointers of the original node with the sibling's
> >pointers. This leads to loop considering the original node as a
> >merge candidate with itself in the second pass, and so it
> >incorrectly determines a merge should occur."
> >
> 
> Are you done ranting? Get the @#$% bug patched.

I'm deeply sorry you feel that way about the review process - it's
not just code that matters. Experience has shown us time and time
again that accurate and complete commit messages are extremely
valuable as they document the symptoms of a problem being fixed and
why the fix was needed.

If someone needs to look at this commit in a couple of years to
determine if it matches a problem that a customer reported, they
shouldn't have to work out what the problem was and guess at it's
symptoms and impact from code analysis. The commit message should
tell them all the information they need(*).

It took you quite some time and effort to find the problem, so it's
worthy of spending a few minutes to document that effort for
posterity. That way when someone asks you a question about the
problem, all you need to do is point them at the commit and all the
information is right at their fingertips.

I'm not asking you to do anything I don't do already.  Have you ever
wondered why I write long, verbose commit messages and changes with
verbose comments? They aren't for the reviewer - I can answer
questions in real-time about the change. The message is for someone
looking at the change in 2-3 years time when when nobody remembers
the exact circumstances of the fix anymore.

IOWs, by clearly documenting the problem being fixed, the root cause
analysis and verification that was performed *using standard
terminology*, we make it far easier for someone to come along in 2-3
years time and understand the fix without needing any further
information about it.

Software engineering best practices have come a long way since the
early 90's - writing meaningful commit messages to go along with
your code changes has been considered a best practise for at least
the last 10 years....

Cheers,

Dave.

(*) If you've ever spent any time looking at the old XFS archives,
then you'll understand exactly why what I've asked for is important.
Trying to reverse-engineer why a change was made in the old XFS code
is just about impossible because all they generally have is single
line commit messages and nothing else to describe the change.
Sometimes they just point at a bug number, without any other
information at all.....
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
