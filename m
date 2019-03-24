Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:59344 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729031AbfCXXDc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Mar 2019 19:03:32 -0400
Date: Mon, 25 Mar 2019 10:03:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: generic/475 deadlock?
Message-ID: <20190324230327.GZ23020@dastard>
References: <20190320050408.GA24923@magnolia>
 <20190320170305.GA29010@bfoster>
 <20190320174551.GA1186@magnolia>
 <20190320175922.GB29010@bfoster>
 <20190320214938.GU23020@dastard>
 <20190321121152.GA33001@bfoster>
 <20190321211051.GV23020@dastard>
 <20190321215307.GA35644@bfoster>
 <20190321235045.GW23020@dastard>
 <20190322120136.GA37888@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190322120136.GA37888@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 22, 2019 at 08:01:36AM -0400, Brian Foster wrote:
> On Fri, Mar 22, 2019 at 10:50:45AM +1100, Dave Chinner wrote:
> > > > 	return pinned;
> > > > 
> > > 
> > > "detect skipped buffers at delwri queue submit time (i.e., due to being
> > > pinned)"
> > 
> > If the AIL code was detecting skipped buffers, it would do:
> > 
> > 	xfs_buf_delwri_submit_nowait(&ailp->ail_buf_list);
> > 	if (!list_empty(&ailp->ail_buf_list)) {
> > 		/* we skipped buffers */
> > 		.....
> > 	}
> > 
> > But it's not doing this.
> > 
> 
> In general, if you think I'm mischaracterizing code/behavior, it's
> helpful to point out how you interpret the specified reasoning so we can
> correct mistaken assumptions/understandings, clarify descriptions or use
> better terminology or whatever. That helps to get onto the same page
> more efficiently, particularly for cases where it so happens we were
> talking about the same exact thing in the first place and just happen to
> think about it a bit differently. ;)

Well, i didn't realise you had mis-applied the terminology until you
replied to me saying "we're describing the same thing". It's easy to
say in hindsight "-you- should have just point out the problem", but
that's laying blame for something that nobody is at fault for.

> For example, to just say "We can, but not for the reasons you are
> suggesting." doesn't tell me much about how you interpreted my
> reasoning.

I think you're being unreasonable here, Brian - I explained the
skipped vs pinned difference once I understood there was a
terminology mismatch issue. :/

I don't expect to have to rewrite emails in my own words just so the
other party can determine if I've understood the terms they used
correctly. We have definitions and try to use common, clear
terminology so that code and communication is efficient and we don't
need to endlessly repeat what the other person has said.

Misunderstandings over terminology are relatively rare - as soon as
I understood that you were using terminology with a different
definition to the code you were refering to, I pointed it out and
explained where the misunderstanding was.

I cannot do any more than that, and to expect more from /anyone/ is
entirely unreasonable.

> I missed where the busy extent stuff came into play here.. are you
> pointing out that log forces from the busy extent code can occur under
> buffer locks and thus we're susceptible to similar problems there? If
> so, aren't we protected by the transaction in that context?

I'm not sure - as I said I have not traced/reasoned the logic right
through yet.  All I was doing is pointing out that these are other
places we are doing a log force with buffers locked so might have
the same problem, and....

> IOW, wouldn't a log force from busy extent context always occur with
> locked buffers joined to a transaction? If so, then doesn't the active
> transaction hold a bli reference and prevent such items from being
> "freed" in log completion context (i.e. xfs_buf_item_unpin()) if they
> happened to be pinned? Perhaps I'm missing something...

... now you've looked at it in more detail that I have.

What you've described is why it was considered to be safe, but now
we have things like defered AGFL block freeing that pick up and drop
the AGF lock repeatedly as the single transaction rolls and -
eventually - starts calling xfs_trans_reserve() on transaction roll.
That's something we never used to do.  It may still be safe, but it
is unclear to me how this all interacts in the presence of
filesystem shutdown conditions.....

---

What it comes down to is that the only way I can answer questions
like this is to do the complete analysis myself, which simply does
not scale. Having to jump between multiple separate complex
questions completely derails my own workflow, and it's recently been
resulting in me spending >75% of every day answering complex
questions like this. Duplication of effort is not an efficient use
of our time or expertise.

If I see something and say "these other code paths look similar, we
should check them too", all it means that I noticed a pattern of
usage and they need to be checked for similar issues.  It does not
mean "dave has enough spare time on hand and can drop everything to
analyse the code in question and answer every little detail about
the similar problem path he noticed."

Brian, you're way better than me at analysing these complex
interactions. Be confident in your analysis, just say "no, it's safe
because...." rather than asking a question that requires me to
repeat the analysis you've already done.  If there's something that
you've missed that I spot, I'll point it out, but I really don't
want to have to repeat everything you've already done just to answer
a "did I miss anything" question.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
