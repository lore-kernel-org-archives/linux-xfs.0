Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:39818 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966025AbcIWWV6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2016 18:21:58 -0400
Date: Sat, 24 Sep 2016 08:21:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: quiesce the filesystem after recovery on readonly
 mount
Message-ID: <20160923222153.GQ340@dastard>
References: <1474589500-13584-1-git-send-email-david@fromorbit.com>
 <af65b5ae-2ff8-c344-0e04-cbbef3efe197@sandeen.net>
 <f693b1a2-1cdb-ed9f-caa0-af9407034927@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f693b1a2-1cdb-ed9f-caa0-af9407034927@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Sep 23, 2016 at 11:24:53AM -0500, Eric Sandeen wrote:
> On 9/22/16 8:39 PM, Eric Sandeen wrote:
> > On 9/22/16 7:11 PM, Dave Chinner wrote:
> >> From: Dave Chinner <dchinner@redhat.com>
> 
> ...
> 
> >> To avoid this problem, we need to ensure that a read-only mount
> >> always updates the log when it completes the second phase of
> >> recovery. We already handle this sort of issue with rw->ro remount
> >> transitions, so the solution is as simple as quiescing the
> >> filesystem at the appropriate time during the mount process. This
> >> results in the log being marked clean so the mount behaviour
> >> recorded in the logs on repeated RO mounts will change (i.e. log
> >> recovery will no longer be run on every mount until a RW mount is
> >> done). This is a user visible change in behaviour, but it is
> >> harmless.
> > 
> > Excellent idea :)
> > 
> > Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> Actually ...  after playing with this a bit ...
> 
> Should we restrict this to only when the log got
> replayed, with a !XFS_LAST_UNMOUNT_WAS_CLEAN(mp) test?
> 
> Maybe it's harmless as it is, but it seems we should restrict
> it to the log-got-replayed case.

Well, writing another unmount record should be harmless. The thing
is that the quiesce call also serves to shut down periodic log
functions that are started when the second phase of recovery is run,
These are started regardless of whether the mount was clean or not.
Hence we are currently running periodic log work on ro mounts and
tryin gto cover/sync the log every so often. For rw mounts this is
needed, but for ro mounts once we know everything is clean we can
shut them down, jus tlike we do for a rw->ro remount.

So I think that just treating the ro mount like a rw mount followed
by a rw->ro transition after potential mount time modifications are
complete is the best approach for consistency of RO behaviour....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
