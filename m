Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:15053
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753142AbdHODXL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 23:23:11 -0400
Date: Tue, 15 Aug 2017 13:23:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 02/13] xfs: get directory offset when removing
 directory name
Message-ID: <20170815032307.GH21024@dastard>
References: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
 <1502329293-4091-3-git-send-email-allison.henderson@oracle.com>
 <20170814235653.GQ4796@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170814235653.GQ4796@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs@vger.kernel.org

On Mon, Aug 14, 2017 at 04:56:53PM -0700, Darrick J. Wong wrote:
> The biggest complaint I have about this patch series is that we end up
> using separate transactions for each phase of the link/unlink
> operations.  There's no guarantee that once we start the process of
> expand-dir, add-name-to-dir, log-inode-cores, expand-attr,
> add-pptr-to-attrs that we actually get all the way to the end of that
> process, particularly if we crash in the middle and have to recover the
> log coming back up.

Yes, that's a problem that we had not been solved at the point in
time I wrote that patchset. After making the parent pointer
attributes be added and removed correctly, then next thing to do was
to make them atomic and replayable. And that's the bit I never got
to.

> Obviously, back in 2014 when Dave started on these patches there was no
> defer_ops, so a lot of effort goes into passing parameters up and down
> the stack and fiddling with the transaction reservation type
> declarations in order to guarantee that we can shove everything into a
> single transaction.  Now that we have a more general mechanism to split
> complex updates into a chain of smaller updates (and make log recovery
> pick up where we left off) it's time to figure out how to make attr (and
> maybe dir) updates a deferrable operation.

Right. We've got the infrastructure now, but it's nasty to retrofit
to all the attr code.

> This adds complexity to the log because we have to define an "attr add
> KEY:VALUE" and a "attr delete KEY" deferred op that hooks into the
> existing attr code.  For parent pointers it's not a big deal to log
> values since they're not big, but for the general case this idea needs
> more thought, or a decision that we'll just keep doing things the same
> way.

The problem with this is that it requires us to log the entire
attribute value, which could be 64k in size. That used to be a big
issue because log bandwidth was at a premium. That isn't so much a
problem now, so logging the attr value and getting rid of the
unlogged sync write for remote attr updates is the way I think we
should head.

> Anyway, assuming the existence of a "attr delete KEY" log intent item we
> no longer have to pass the offsets around everywhere because instead
> _dir_removename attaches the defer item to the defer_ops and
> _defer_finish takes care of rolling through the updates.
> 
> Thoughts?

Yup, it will simplify some things.

However, if we're going to start converting complex operations into
smaller, simpler ops chained via intents and deferred ops, lets
let's take a step back here and think about how we'd like them to be
defined, maintained and executed. If we're going to take a big step
to convert the dir/attr code to run from deferred ops, I want to
make sure we can make the most of it in future.

FYI, what I'd really like to do is to be able to statically define
the individual operations needed to make a modification as a set of
deferred ops sorta like the way we build up transaction
reservations. I'm thinking of defer ops being somewhat akin to a
state machine in definition and implementation. i.e. rather than
being opaque things that are built up by dynamic events, they become
mostly static ops with some dynamically driven events.

Hence a directory addition is simply a case of selecting the correct
defer_ops structure and starting it to run on the directory inode
and new dirent name. The high level code would need to check what
directory features are enabled to select the ops that need to run,
but otherwise there's nothing more to do but hand it to the
xfs_deferops_start(). Parent pointers then just becomes a different
set of deferops. If possible, it'd be nice to use the definition of
each op to determine the log/block reservations needed for the op to
run, too.

Expanding this filesystem wide, we'd end up with an engine that runs
defer ops in the most efficient manner possible and a bunch of
smaller, simpler operations linked by intent/done log entries. These
ops could be run sync or async by the engine, which would give us a
path towards async metadata ops and bulk metadata update
optimisations...

Yeah, I'm getting way ahead of myself here, but I think you get the
idea. Does that even remotely sound plausible, or have I just been
hitting the hard stuff too much recently?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
