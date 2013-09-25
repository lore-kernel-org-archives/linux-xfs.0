Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 998E07F37
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 13:38:20 -0500 (CDT)
Date: Wed, 25 Sep 2013 13:38:17 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: v2 fix node forward in xfs_node_toosmall
Message-ID: <20130925183816.GL1935@sgi.com>
References: <20130920220519.585903357@sgi.com>
	<20130923171911.273669684@sgi.com> <20130923234819.GW9901@dastard>
	<5241CD70.7050800@sgi.com> <20130924210653.GB26872@dastard>
	<5242057D.8030404@sgi.com> <20130924233331.GC26872@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130924233331.GC26872@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Mark Tinguely <tinguely@sgi.com>, stable@vger.kernel.org, xfs@oss.sgi.com

Hey Dave,

On Wed, Sep 25, 2013 at 09:33:31AM +1000, Dave Chinner wrote:
> On Tue, Sep 24, 2013 at 04:34:53PM -0500, Mark Tinguely wrote:
> > On 09/24/13 16:06, Dave Chinner wrote:
> > >On Tue, Sep 24, 2013 at 12:35:44PM -0500, Mark Tinguely wrote:
> > >>On 09/23/13 18:48, Dave Chinner wrote:
> > >>>On Mon, Sep 23, 2013 at 12:18:58PM -0500, Mark Tinguely wrote:
> > >>>>Commit f5ea1100 cleans up the disk to host conversions for
> > >>>>node directory entries, but because a variable is reused in
> > >>>>xfs_node_toosmall() the next node is not correctly found.
> > >>>>If the original node is small enough (<= 3/8 of the node size),
> > >>>>this change may incorrectly cause a node collapse when it should
> > >>>>not.
> ....
> > >>>Also, the "next node" is correctly termed a "sibling", and it's
> > >>>either the forwards or backwards sibling, not the "next" sibling as
> > >>>the direction of movement is important. So perhaps this
> > >>>is better written as:
> > >>>
> > >>>"When a node is considered for a merge with a sibling, it overwrites
> > >>>the sibling pointers of the original node with the sibling's
> > >>>pointers. This leads to loop considering the original node as a
> > >>>merge candidate with itself in the second pass, and so it
> > >>>incorrectly determines a merge should occur."
> > >>>
> > >>
> > >>Are you done ranting? Get the @#$% bug patched.
> > >
> > >I'm deeply sorry you feel that way about the review process - it's
> > >not just code that matters. Experience has shown us time and time
> > >again that accurate and complete commit messages are extremely
> > >valuable as they document the symptoms of a problem being fixed and
> > >why the fix was needed.
> .....
> > 
> > You do not always practice what you preach - here is the commit
> > message from the patch that caused this whole problem:
> > 
> > commit f5ea110044fa858925a880b4fa9f551bfa2dfc38
> > Author: Dave Chinner <dchinner@redhat.com>
> > Date:   Wed Apr 24 18:58:02 2013 +1000
> > 
> >     xfs: add CRCs to dir2/da node blocks
> > 
> >     Signed-off-by: Dave Chinner <dchinner@redhat.com>
> >     Reviewed-by: Ben Myers <bpm@sgi.com>
> >     Signed-off-by: Ben Myers <bpm@sgi.com>
> > 
> > Did this patch just add CRCs to node blocks? no.
> > 
> > And how about your patches that do not need a commit message at all?!
> 
> The above commit has a very different context surrounding it - it
> was in the middle of a major feaure addition series where the
> process of additions had been described in the previous commits, and
> the one-line description is sufficient for future readers to
> determine that the commit is not a bug fix.
> 
> If a reviewer doesn't speak up about something, then that implies
> the reviewer considers it acceptible.

I disagree with that statement.  A reviewer might not speak up about a
flaw in a work for for other reasons.  There are more than two
alternatives in this context.  For example...

> In this case, the reviewer
> (Ben) seemed to think the one-line description of the commit was
> acceptible for the context in which it was being proposed and
> committed.

I wasn't happy with the lack of the description in those commits, and
probably should have spoken up about it.  In this case I weighed the
frustration due to the argument that would almost certainly have ensued
against the benefit of a decent commit message, and punted.

That's similar to what happened when I pulled in the 1st half of the
userspace crc-dev work after you refused to address my concerns in
review.  I punted again, because the argument would have been more
nuisance than it was worth.

Clearly I need to stop punting so often.  But since many a suggestion
made by Mark or myself is taken as a bloody travesty and an argument
ensues... I have to admit to some fatigue in this area.

> > Are these exceptions? No, I have done enough reviews of your
> > patches, and some of your commit message are less than stunning.
> 
> Sure, some of my commit messages need work, especially as I'm
> spelling and grammar challenged at the best of times. I make no
> claim that they are perfect, but I do try to make the sufficient for
> the context in which they are being proposed.
> 
> However - it is *your responsibility as a reviewer* to ask the
> author to write a more complete change log or fix omissions or
> clarify parts of the commit message that need improvement. 

...

> If the
> reviewer does not ask for improvements or you chose not to review
> the proposed patches, then you have no grounds to complain about the
> contents of patches that were committed on your watch...

I disagree.  The act of committing a patch does not necessarily imply an
agreement regarding it's contents.  I am often in a position where I
have to commit patches that I don't fully agree with.  This doesn't
imply that I've waived my right to whine about bad commits later.  ;)

> > when your preaching, and not so subtle digs at me or SGI gets to the
> > point of rewriting commit messages even I can't hold my tongue any
> > more.
> 
> You are reading way too much into a simple request, Mark.
> Constructive criticism of your code is not a personal attack.

I suspect the issue is not really with this particular request.  There
is a cumulative effect to the toxicity that you seem to feel the need to
bring to the list, and it sounds like Mark is full up.

This is gonna sound soft coming from a grown man, but I'll call it for
what I think it is:  Bullying.  And to the extent that I've taken part
or watched others get planed and done nothing, I think I have to take
this as a stain on my own character.

The constructive criticism is fine.  The bullying needs to stop.
Technical prowess is not license to act badly.  Knock it off.
 
> Quite frankly, I don't care who submits the code or who they work for
> - I apply the same *peer review criteria* to all code that is
> proposed.  I'm here to make sure the code is robust, solid and
> maintainable into the forseeable future. I'm here to tear your patches
> apart and then help put it back together better than it was before. It
> simply doesn't matter who submits the code...

I'm pleased to hear that you don't care who submits code, but it sure
seems like you're grinding an axe for Mark to me.

> > PS. I told Ben that I do not appreciate commit messages being
> > changed.
> 
> Ben did the right thing. Maintainers rewrite commit messages to
> improve them all the time...

I handled it badly.  It was probably ok to pull in your suggestion into
the commit message as long as it was attributed properly, but it was
more aggressive than was necessary, and I can understand why Mark didn't
appreciate it.  Also, I really needn't have been snarky about it.
Apologies to Mark.

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
