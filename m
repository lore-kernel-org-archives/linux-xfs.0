Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52584 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751541AbdDNCyW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Apr 2017 22:54:22 -0400
Date: Thu, 13 Apr 2017 22:54:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] mdrestore: warn about corruption if log is dirty
Message-ID: <20170414025416.GA28822@bfoster.bfoster>
References: <20170411141237.9274-1-jtulak@redhat.com>
 <20170411141237.9274-3-jtulak@redhat.com>
 <20170411223405.GC12369@dastard>
 <20170412110403.GB6834@bfoster.bfoster>
 <20170413025105.GD12369@dastard>
 <20170413131018.GD24893@bfoster.bfoster>
 <20170414002930.GE12369@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170414002930.GE12369@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Fri, Apr 14, 2017 at 10:29:30AM +1000, Dave Chinner wrote:
> On Thu, Apr 13, 2017 at 09:10:19AM -0400, Brian Foster wrote:
> > IOW, this documentation problem exists because the tool is broken. The
> > tool will remain broken despite the fact that the problem is documented.
> > Therefore, we are not just working around a documentation issue by
> > attempting to improve the tool.
> 
> I'm not sure that you understood my point. That is, if a developer
> tool is considered broken, then adding warnings to tell the /user/
> the developer tool is broken is not solving the "tool is broken"
> problem any better than documenting in the man page. The underlying
> problem is that the log is unobfuscated and so the tool will, by
> your definition, remain "broken" until that problem is fixed.
> 

If xfs_metadump spits out something that doesn't resemble the source fs
from a filesystem coherency perspective, then yes, I consider that a bug
(or "broken"). And yes, I agree that the tool warning about that fact
does not fix the bug. That doesn't mean the usability of the tool cannot
be improved.

What I'm saying is that if xfs_metadump issued a warning about using
obfuscation with a dirty log, then it's much more likely this user would
have disabled obfuscation (as the original problem report was a log
recovery issue), sent a valid metadump and we wouldn't have lost a
valuable metadata image (that I believe had since been repaired) in the
process. Further, if that didn't work, but xfs_mdrestore issued a
similar warning, the support person probably wouldn't have filed a bug
(or even with a bug filed, I wouldn't have wasted time root causing a
spurious filesystem corruption).

In contrast... I can't speak for others with certainty, but I highly
doubt anybody involved in this exchange had a need to refer to the
xfs_metadump manpage. Both xfs_metadump and xfs_mdrestore worked fine
with default parameters from the customer and support personnel
perspective. The user reported a post-log recovery corruption and that's
what the support person observed. I certainly didn't have any impetus to
'man xfs_metadump,' as I generally don't refer to the manpage in
response to encountering runtime filesystem corruption errors.

> And, IMO, "broken" is an incorrect classification of the issue. We
> *chose* not to obfuscate the log because the effort required to
> implement it falls far, far to the wrong side of the cost-benefit
> analysis line. Months of work for something that may be relevant
> only to a developer once or twice a year?  Further, bfuscating the
> log may actually be an unsolvable problem due to the way we do
> relogging and reuse freed blocks - the obfuscation of log entries
> has to exactly match the obfuscation that is done on disk, and we
> may have multiple overwrites of the same directory blocks to
> obfuscate and all need to be correct. It's a damn hard problem that
> I'll still strongly suggest we should never attempt to solve.
> 

I'm pretty sure I stated in my last email that obfuscating the log was
not a realistic solution, so I'm not sure what point you're arguing with
here...

...
> ... they should have rough edges, ...

Then why the fuss about a warning that is otherwise technically
accurate?

Brian

