Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 79A4A7F3F
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 18:33:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 17B12AC005
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 16:33:38 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HRB2jhASKHcutZXv for <xfs@oss.sgi.com>;
	Tue, 24 Sep 2013 16:33:36 -0700 (PDT)
Date: Wed, 25 Sep 2013 09:33:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: v2 fix node forward in xfs_node_toosmall
Message-ID: <20130924233331.GC26872@dastard>
References: <20130920220519.585903357@sgi.com>
	<20130923171911.273669684@sgi.com> <20130923234819.GW9901@dastard>
	<5241CD70.7050800@sgi.com> <20130924210653.GB26872@dastard>
	<5242057D.8030404@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5242057D.8030404@sgi.com>
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

On Tue, Sep 24, 2013 at 04:34:53PM -0500, Mark Tinguely wrote:
> On 09/24/13 16:06, Dave Chinner wrote:
> >On Tue, Sep 24, 2013 at 12:35:44PM -0500, Mark Tinguely wrote:
> >>On 09/23/13 18:48, Dave Chinner wrote:
> >>>On Mon, Sep 23, 2013 at 12:18:58PM -0500, Mark Tinguely wrote:
> >>>>Commit f5ea1100 cleans up the disk to host conversions for
> >>>>node directory entries, but because a variable is reused in
> >>>>xfs_node_toosmall() the next node is not correctly found.
> >>>>If the original node is small enough (<= 3/8 of the node size),
> >>>>this change may incorrectly cause a node collapse when it should
> >>>>not.
....
> >>>Also, the "next node" is correctly termed a "sibling", and it's
> >>>either the forwards or backwards sibling, not the "next" sibling as
> >>>the direction of movement is important. So perhaps this
> >>>is better written as:
> >>>
> >>>"When a node is considered for a merge with a sibling, it overwrites
> >>>the sibling pointers of the original node with the sibling's
> >>>pointers. This leads to loop considering the original node as a
> >>>merge candidate with itself in the second pass, and so it
> >>>incorrectly determines a merge should occur."
> >>>
> >>
> >>Are you done ranting? Get the @#$% bug patched.
> >
> >I'm deeply sorry you feel that way about the review process - it's
> >not just code that matters. Experience has shown us time and time
> >again that accurate and complete commit messages are extremely
> >valuable as they document the symptoms of a problem being fixed and
> >why the fix was needed.
.....
> 
> You do not always practice what you preach - here is the commit
> message from the patch that caused this whole problem:
> 
> commit f5ea110044fa858925a880b4fa9f551bfa2dfc38
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Wed Apr 24 18:58:02 2013 +1000
> 
>     xfs: add CRCs to dir2/da node blocks
> 
>     Signed-off-by: Dave Chinner <dchinner@redhat.com>
>     Reviewed-by: Ben Myers <bpm@sgi.com>
>     Signed-off-by: Ben Myers <bpm@sgi.com>
> 
> Did this patch just add CRCs to node blocks? no.
> 
> And how about your patches that do not need a commit message at all?!

The above commit has a very different context surrounding it - it
was in the middle of a major feaure addition series where the
process of additions had been described in the previous commits, and
the one-line description is sufficient for future readers to
determine that the commit is not a bug fix.

If a reviewer doesn't speak up about something, then that implies
the reviewer considers it acceptible. In this case, the reviewer
(Ben) seemed to think the one-line description of the commit was
acceptible for the context in which it was being proposed and
committed.

> Are these exceptions? No, I have done enough reviews of your
> patches, and some of your commit message are less than stunning.

Sure, some of my commit messages need work, especially as I'm
spelling and grammar challenged at the best of times. I make no
claim that they are perfect, but I do try to make the sufficient for
the context in which they are being proposed.

However - it is *your responsibility as a reviewer* to ask the
author to write a more complete change log or fix omissions or
clarify parts of the commit message that need improvement. If the
reviewer does not ask for improvements or you chose not to review
the proposed patches, then you have no grounds to complain about the
contents of patches that were committed on your watch...

> when your preaching, and not so subtle digs at me or SGI gets to the
> point of rewriting commit messages even I can't hold my tongue any
> more.

You are reading way too much into a simple request, Mark.
Constructive criticism of your code is not a personal attack.

Quite frankly, I don't care who submits the code or who they work
for - I apply the same *peer review criteria* to all code that is
proposed.  I'm here to make sure the code is robust, solid and
maintainable into the forseeable future. I'm here to tear your
patches apart and then help put it back together better than it was
before. It simply doesn't matter who submits the code...

> PS. I told Ben that I do not appreciate commit messages being changed.

Ben did the right thing. Maintainers rewrite commit messages to
improve them all the time...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
