Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B23C76196
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 02:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbjDDCQC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Apr 2023 22:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjDDCQC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Apr 2023 22:16:02 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B955BEE
        for <linux-xfs@vger.kernel.org>; Mon,  3 Apr 2023 19:16:00 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id d22so18751706pgw.2
        for <linux-xfs@vger.kernel.org>; Mon, 03 Apr 2023 19:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1680574560;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lsaUPDFJHbzJkj6RErJ7OL/wEFgz1sk+h+F7hWfluaw=;
        b=Fb5rFlblskvsp6iJc7LvZ298/qw9NGWD/2v/C4/Xq6OnlpOTIqsej/91IaIcNnmFem
         8ECTt/wU6X/MUqHSuXVjFrnok61wBvQ4+7NKKFVhawSeHzaTyFQ7ixH5F7jR+Wgaueq0
         PuWH/6GHtklvLT6gMOhiBKwYYvRcvCA+BeHe2tqAZ8XnlJhx8tGvUhtc+POmPBxqNELb
         fqQgxaT8EbO4na6zpakswzhNeaIbPGjHA18DIPtUI8d/4s8TXGkOJscY/BEXQdRfQj02
         5xt684QIjf1imgS6DHBfFPebGV/vp4EuxF29Qvv1LR6jYSCDjeb1Mavtj/Bapq1exwJf
         PiZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680574560;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lsaUPDFJHbzJkj6RErJ7OL/wEFgz1sk+h+F7hWfluaw=;
        b=jY0g8YmYwQN+htgktyyK/oF4BMrupNKOHYz8MYdKlYPczelWdyn/mVQlp5tNEcROPx
         aUQF61CjRtXKx/b95Ywdp7Etypchg2O8A5o4wSRtT1n3PUOUY+Ix5iyC+9SPR0XoPSkt
         Lp7nxnCbCFltql3HBMiCbOPWjzkkDP21wRKNnZH69WMBFLEarYmhmmDJefBQWzWW7fDf
         gdRvhWweZUNJCKcZPBF3W9Ti7J+I/sVyRfQ4Ok4rRhSmc46SPJA5OsRr/GtLuzEngmHq
         GYEIESKpAuVh+YaCQG3U/fgC+8sSX9qGxlYeJuLSKSO7YGXZDNCRK8SSmSYdiQ/R0QCy
         WT9A==
X-Gm-Message-State: AAQBX9cDKscYtCbYgMI9fpT85jMoohkwVB1cz1JFCO5W+9IkvHKIKx76
        TmFfEy6OO+NCNBhMRXUjiZFBmKbLs2JY6HkV3FY=
X-Google-Smtp-Source: AKy350beOqP/XdjPuKx7LHFjcngzE2e/qj/4Y5AG2JeSvvbIqqBHkVN7F9iWnZlzV7+CDjidxvwMng==
X-Received: by 2002:aa7:9f47:0:b0:627:fb40:7cb4 with SMTP id h7-20020aa79f47000000b00627fb407cb4mr559496pfr.30.1680574560025;
        Mon, 03 Apr 2023 19:16:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-91-157.pa.nsw.optusnet.com.au. [49.181.91.157])
        by smtp.gmail.com with ESMTPSA id g20-20020a62e314000000b0062b5a55835dsm7490155pfh.213.2023.04.03.19.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 19:15:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pjWDE-00GlRs-Ov; Tue, 04 Apr 2023 12:15:56 +1000
Date:   Tue, 4 Apr 2023 12:15:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     allison.henderson@oracle.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE 1/2] xfs-linux: scrub-strengthen-rmap-checking updated
 to 64e6494e1175
Message-ID: <20230404021556.GK3223426@dread.disaster.area>
References: <168054442640.1440442.6704636180612529931.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168054442640.1440442.6704636180612529931.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 03, 2023 at 10:55:57AM -0700, Darrick J. Wong wrote:
> Hi folks,
> 
> The scrub-strengthen-rmap-checking branch of my xfs-linux repository at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git
> 
> has just been updated for your review.
> 
> This code snapshot has been rebased against recent upstream, freshly
> QA'd, and is ready for people to examine.  For veteran readers, the new
> snapshot can be diffed against the previous snapshot; and for new
> readers, this is a reasonable place to begin reading.  For the best
> experience, it is recommended to pull this branch and walk the commits
> instead of trying to read any patch deluge.
> 
> Here's the rebase against 6.3-rc5 of the online fsck design
> documentation and all pending scrub fixes.  I've fixed most of the
> low-hanging fruit that Dave commented on in #xfs.
> 
> (This isn't a true deluge, since I'm only posting this notice, not the
> entire patchset.)

Notes as I go through the code (I'm ignoring the Documentation/
stuff as Allison has been going through that with a fine toothed
comb). I'm simply reading the output of:

$ git reset --hard v6.3-rc5
$ git merge djwong/scrub-strengthen-rmap-checking
$ git diff v6.3-rc5.. fs/xfs
....

and commenting as I see things, also leaning on the notes I had from
the first, much slower, pass I did through this code over the past 3
weeks.

---

+xfs-$(CONFIG_XFS_DRAIN_INTENTS)        += xfs_drain.o

"drain" is kinda generic. That shows up like this:

+               xfs_drain_init(&pag->pag_intents);

Where it's clear that it's an intent drain. More generically, I think
this is a deferred work drain which just happens to be a set of
linked intents.

We already have the xfs_defer_* namespace for managing deferred
work chains, so perhaps this API should be named xfs_defer_drain*
to indicate what subsystem it interacts with.

---

xfs_perag_drain_intents -> xfs_perag_intent_drain()
xfs_perag_intents_busy -> xfs_perag_intent_busy()

to keep namespace consistent with _intent_hold/rele() interface.

---

xfs_extent_free_get_group(), xfs_extent_free_put_group().

These are actually grabbing/dropping the perag and bumping the
deferred work drain count held in the pag->pag_intents. I'd much
prefer a common interface that looks like:

xfs_perag_intent_get(mp, agno)
{
	pag = xfs_perag_get(mp, agno);
	xfs_perag_intent_hold(pag);
	return pag;
}

and then we have:

	xefi->xefi_pag = xfs_perag_intent_get(mp,
				XFS_FSB_TO_AGNO(mp, xefi->xefi_startblock);

and:

	xfs_perag_intent_put(xefi->xefi_pag);

instead of the type specific wrappers that all do the same thing.

IOWs, we have an API where:

xfs_perag_intent_get()
xfs_perag_intent_put()

Are used to get a perag reference with an intent drain hold, and:

xfs_perag_intent_hold()
xfs_perag_intent_rele()

Are used to bump/drop the intent drain count when the intent already
has a perag reference.

[ Repeat these comments for all intent _get/put_group() functions. ]

---

General observation.

As a cleanup - not for this patchset - we should pass the perag to
tracepoints, not the agno vi pag->pag_agno.

---

General observation.

I like how the perag is migrating outward from the core alloc code
into the callers (e.g. __xfs_free_extent()) as callers start to
track perag references themselves. I also like ho9w callers are now
asking for operations on {perag, agbno, len} tuples instead of
{fsbno, len} tuples.

---

xfs_alloc_complain_bad_rec(), xfs_bmap_complain_bad_rec(), et al.

Should these also dump a trace event recording the bad record?

---

General observation.

->diff_two_keys() method. Should we rename that ->keycmp()?

---

xfs_rmap_count_owners_helper():

First delta calc has a cast to (int64_t), second one doesn't. Don't
both need the same cast (or lack of cast)?

	roc->results->nono_matches++;

Clever name, but it's not a "no no" match (as in a match that should
never happen) - that's what "badno_matches" are.

It's a non-owner match, so I think the variable names should be
"nonowner_matches" and "bad_nonowner_matches" to avoid confusion
when I next read the code....

---

xbitmap conversion to use interval trees. The logic looks ok and the
way the callers use it look fine, but I'm not going to find
off-by-one bugs in it just by reading the code. It's definitely an
improvement on the previous code, though.

---

xchk_perag_lock() isn't really locking the perag. It's locking the
AGF+AGI and ensuring there are no deferred operation chains in
progress in the AG. xchk_ag_drain_and_lock()?

---

xchk_iget_agi() is a bit nasty. Lets chase that through.

read/lock AGI
xfs_iget(tp, NORETRY|UNTRUSTED)
  cache hit
    can't get inode because, say, NEEDGC
    return -EAGAIN
  cache miss
    xfs_imap
      xfs_imap_lookup() (because UNTRUSTED)
        read AGI
	  works only because AGI is locked in this transaction.

Ok, so the -EAGAIN return is only going to come through cache hit
path, the cache miss path is not going to deadlock even though it
needs the AGI we already have locked. Incore lookup will fail with
EAGAIN if inactivation on the inode is required, and that may remove
the inode from the unlinked list and hence need the AGI. Hence
xchk_iget_agi() needs to drop the AGI lock on EAGAIN to allow
inodegc to make progress and move the inode to IRECLAIMABLE state
where xfs_iget will be able to return it again if it can lock the
inode.

OK. Nasty, but looks like it is deadlock free. The comment above the
function needs to document this special case handling for xfs_iget()
returning -EAGAIN and the dependence on having a valid transaction
context for the cache miss case to avoid deadlocking in
xfs_imap_lookup() on the AGI lock.

---

Looks like a lot of commonality between xchk_setup_inode() and
xchk_iget_for_scrubbing() - same xfs-iget/xfs_iget_agi/xfs_imap
checking logic - so maybe scope for a common helper function there?

---

scrub/readdir.c

This looks to be a reimplementation of the normal readdir code just
with a different callback to process the names that are found. I'd
prefer not to have two copies of the readdir implementation in the
code base - is it possible to use the filldir context and the
existing readdir code to perform the scrub readdir walk function?

Maybe that is for a later patchset....

---

That's all I've noticed reading through the code - I'm not going to
find off-by-one errors in the logic reading through a diff of this
size:

73 files changed, 4976 insertions(+), 1794 deletions(-)

The code changes largely make sense, the impact on the code outside
fs/xfs/scrub appears to be largely minimal and there are some good
cleanups and improvements in the code. I'll start running this
through my limited QA resources right now (hardware failure has
taken out my large test machine) but if it's anything like the
previous version, I don't expect to find any regressions.

I'll probably start on the second set of commits tomorrow....

Cheers,

-Dave.
-- 
Dave Chinner
david@fromorbit.com
