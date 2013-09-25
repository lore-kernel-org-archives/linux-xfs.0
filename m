Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 64C537F4E
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 17:11:38 -0500 (CDT)
Date: Wed, 25 Sep 2013 17:11:34 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: v2 fix node forward in xfs_node_toosmall
Message-ID: <20130925221134.GM1935@sgi.com>
References: <20130920220519.585903357@sgi.com>
	<20130923171911.273669684@sgi.com> <20130923234819.GW9901@dastard>
	<5241CD70.7050800@sgi.com> <20130924210653.GB26872@dastard>
	<5242057D.8030404@sgi.com> <20130924233331.GC26872@dastard>
	<20130925183816.GL1935@sgi.com> <52434F8A.9040703@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52434F8A.9040703@sandeen.net>
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
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

Hey,

On Wed, Sep 25, 2013 at 04:03:06PM -0500, Eric Sandeen wrote:
> [stable@vger.kernel.org stripped from this fascinating thread]

Good idea.  I should have done, in retrospect.

> On 9/25/13 1:38 PM, Ben Myers wrote:
> > Hey Dave,
> > 
> > On Wed, Sep 25, 2013 at 09:33:31AM +1000, Dave Chinner wrote:
> 
> <snip>
> 
> >> If a reviewer doesn't speak up about something, then that implies
> >> the reviewer considers it acceptible.
> > 
> > I disagree with that statement.  A reviewer might not speak up about a
> > flaw in a work for for other reasons.  There are more than two
> > alternatives in this context.  For example...
> 
> <snip>
> 
> <apologies if I snipped too much context, not my intention>
> 
> >> If the
> >> reviewer does not ask for improvements or you chose not to review
> >> the proposed patches, then you have no grounds to complain about the
> >> contents of patches that were committed on your watch...
> > 
> > I disagree.  The act of committing a patch does not necessarily imply an
> > agreement regarding it's contents.  I am often in a position where I
> > have to commit patches that I don't fully agree with.  This doesn't
> > imply that I've waived my right to whine about bad commits later.  ;)
> 
> If you don't like it, don't add reviewed-by.
> 
> If you don't like the reviews, don't sign off, don't merge it.
> As maintainer you have that right, but to be a good maintainer,
> you need a strong reason.  And if you have a strong technical concern,
> then it's the patch author's duty to take it seriously, or risk not
> getting the patch merged.  And the author might argue back.  And other
> people might argue back.  And in the end, if we can all keep our cool,
> the code will be better for it.  If you apply clear and consistent merge
> criteria then people will know what to expect.
> 
> When you send a Reviewed-by: that's a pretty strong indication of agreement.

Gah.  Yeah, I overstated.  Maybe 'does not necessarily imply an agreement'
should read something more like 'does not necessarily imply it is beyond
criticism', that's a bit more reasonable.

> There shouldn't be a lot of misunderstanding about what it means;
> the kernel doc (Documentation/SubmittingPatches) is very clear:
> 
> ===
>         Reviewer's statement of oversight
> 
>         By offering my Reviewed-by: tag, I state that:
> 
>          (a) I have carried out a technical review of this patch to
>              evaluate its appropriateness and readiness for inclusion into
>              the mainline kernel.
> 
>          (b) Any problems, concerns, or questions relating to the patch
>              have been communicated back to the submitter.  I am satisfied
>              with the submitter's response to my comments.
> 
>          (c) While there may be things that could be improved with this
>              submission, I believe that it is, at this time, (1) a
>              worthwhile modification to the kernel, and (2) free of known
>              issues which would argue against its inclusion.
> 
>          (d) While I have reviewed the patch and believe it to be sound, I
>              do not (unless explicitly stated elsewhere) make any
>              warranties or guarantees that it will achieve its stated
>              purpose or function properly in any given situation.
> ===
> 
> If you can't get behind that, don't add your Reviewed-by: and continue to
> work it out until you can.  Reviewers should be sure to pay attention to
> point (c) as well, something I sometimes forget myself.

I haven't read that in awhile.  Nice to have a brush up, thanks.  I think it
probably comes short of '...you have no grounds to complain about the contents
of patches that were committed on your watch...', which is the idea I disagree
with.  Maybe others don't think so, you could argue that I failed on point b in
my review by not choosing to hound Dave for a commit message.  ;)

> Reviews don't have to be heeded, either.  They don't have to be gauntlets
> thrown down or lines in the sand.  "You've corrupted memory here" is
> different from "you could use an args struct instead of 8 arguments"
> or "your commit log isn't very descriptive."  Discretion abounds.
>
> As a reviewer once said on another list, "I'm free to share
> what occurs to me and you're free to tell me to go jump in a lake."
> Especially for cosmetic issues, that's a pretty good POV.  Sometimes
> it's trickier.
> 
> As maintainer I guess you get to decide if a review concern has enough
> merit to hold up merging.  Ignoring a compelling technical concern
> could be risky.

I agree that ignoring a compelling technical concern can be risky.

> Maybe one reviewer is dissatisfied, and another is satisfied.  Then
> you get to play Solomon again.  Life goes on, I hope.

Yeah.  Life goes on.

Thanks Eric,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
