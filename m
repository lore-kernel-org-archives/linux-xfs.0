Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:62811 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932714AbdC2XWu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Mar 2017 19:22:50 -0400
Date: Thu, 30 Mar 2017 10:22:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: largely extend aild sleep time if no work has to be
 done
Message-ID: <20170329232246.GM17542@dastard>
References: <20170329204224.6412-1-dev@lynxeye.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170329204224.6412-1-dev@lynxeye.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lucas Stach <dev@lynxeye.de>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Wed, Mar 29, 2017 at 10:42:24PM +0200, Lucas Stach wrote:
> If the AIL has been pushed up to the target LSN, there is no
> point in waking up every 50ms to check if there is more work
> to do. All functions that move the target LSN forward make sure
> to wake aild as appropriate.
> 
> Keep the timeout wakeup as a watchdog in case we miss the
> wakeup from a target LSN update to guarantee forward progress,
> but extend the timeout to 10 seconds.
> 
> This keeps the safety net, but also makes laptop users happy
> as it gets rid of almost all the wakeups caused by a lightly
> loaded FS.

The aild already has an idle capability that occurs when the target
has been reached. See xfsaild() - it will ignore the timeout and
schedule indefinitely when the AIL has been emptied and the target
has not been updated during the last push. i.e. this timeout is
not a watchdog, just a backoff for the next check if there is still
work to be done.

Keep in mind that XFS doesn't fully empty the AIL until the log has
been covered, and this takes 60-90s to occur after the last
modification has occurred to the filesystem. Delaying pushes on an
uncovered log risks breaking the covering state machine (it's
dependent on writeback from the AIL occurring within a certain time)
and so changes like this may break idling on more machines that it
"fixes".

FYI, filesystems that refuse to idle are typically a sign of
userspace touching the filesystem every 2-3 minutes. IIRC, the XFS
ail event tracing will tell you if metadata is being dirtied
regularly and so whether the AIL is staying empty or not and
hence whether it should actually be idle...

Yes, there have been bugs in this code in the past, and there may be
bugs now. However, just bumping the timeout up to something massive
is not a solution if there is a still bugs lurking here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
