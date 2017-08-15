Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:27226
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751666AbdHOFrp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2017 01:47:45 -0400
Date: Tue, 15 Aug 2017 15:47:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 02/13] xfs: get directory offset when removing
 directory name
Message-ID: <20170815054738.GJ21024@dastard>
References: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
 <1502329293-4091-3-git-send-email-allison.henderson@oracle.com>
 <20170814235653.GQ4796@magnolia>
 <20170815032307.GH21024@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170815032307.GH21024@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Aug 15, 2017 at 01:23:07PM +1000, Dave Chinner wrote:
> On Mon, Aug 14, 2017 at 04:56:53PM -0700, Darrick J. Wong wrote:
> > The biggest complaint I have about this patch series is that we end up
> > using separate transactions for each phase of the link/unlink
> > operations.  There's no guarantee that once we start the process of
> > expand-dir, add-name-to-dir, log-inode-cores, expand-attr,
> > add-pptr-to-attrs that we actually get all the way to the end of that
> > process, particularly if we crash in the middle and have to recover the
> > log coming back up.
> 
> Yes, that's a problem that we had not been solved at the point in
> time I wrote that patchset. After making the parent pointer
> attributes be added and removed correctly, then next thing to do was
> to make them atomic and replayable. And that's the bit I never got
> to.
> 
> > Obviously, back in 2014 when Dave started on these patches there was no
> > defer_ops, so a lot of effort goes into passing parameters up and down
> > the stack and fiddling with the transaction reservation type
> > declarations in order to guarantee that we can shove everything into a
> > single transaction.  Now that we have a more general mechanism to split
> > complex updates into a chain of smaller updates (and make log recovery
> > pick up where we left off) it's time to figure out how to make attr (and
> > maybe dir) updates a deferrable operation.
> 
> Right. We've got the infrastructure now, but it's nasty to retrofit
> to all the attr code.
> 
> > This adds complexity to the log because we have to define an "attr add
> > KEY:VALUE" and a "attr delete KEY" deferred op that hooks into the
> > existing attr code.  For parent pointers it's not a big deal to log
> > values since they're not big, but for the general case this idea needs
> > more thought, or a decision that we'll just keep doing things the same
> > way.
> 
> The problem with this is that it requires us to log the entire
> attribute value, which could be 64k in size. That used to be a big
> issue because log bandwidth was at a premium. That isn't so much a
> problem now, so logging the attr value and getting rid of the
> unlogged sync write for remote attr updates is the way I think we
> should head.

Just had another thought about this - if we rewrite any code to use
a different set of transaction structures, we're going to need to
use log incompat flags to identify each of the changed transaction
sets that require redo item support to replay. That's not a huge
deal - it just means that people taking filesystems back to old
kernels will need to make sure the log is clean. i.e. mount sets,
unmount/remount-ro clears the relevant log incompat flags.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
