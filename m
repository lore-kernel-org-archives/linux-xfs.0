Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:15384 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753294AbdDNAcZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 20:32:25 -0400
Date: Fri, 14 Apr 2017 10:29:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] mdrestore: warn about corruption if log is dirty
Message-ID: <20170414002930.GE12369@dastard>
References: <20170411141237.9274-1-jtulak@redhat.com>
 <20170411141237.9274-3-jtulak@redhat.com>
 <20170411223405.GC12369@dastard>
 <20170412110403.GB6834@bfoster.bfoster>
 <20170413025105.GD12369@dastard>
 <20170413131018.GD24893@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170413131018.GD24893@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Thu, Apr 13, 2017 at 09:10:19AM -0400, Brian Foster wrote:
> IOW, this documentation problem exists because the tool is broken. The
> tool will remain broken despite the fact that the problem is documented.
> Therefore, we are not just working around a documentation issue by
> attempting to improve the tool.

I'm not sure that you understood my point. That is, if a developer
tool is considered broken, then adding warnings to tell the /user/
the developer tool is broken is not solving the "tool is broken"
problem any better than documenting in the man page. The underlying
problem is that the log is unobfuscated and so the tool will, by
your definition, remain "broken" until that problem is fixed.

And, IMO, "broken" is an incorrect classification of the issue. We
*chose* not to obfuscate the log because the effort required to
implement it falls far, far to the wrong side of the cost-benefit
analysis line. Months of work for something that may be relevant
only to a developer once or twice a year?  Further, bfuscating the
log may actually be an unsolvable problem due to the way we do
relogging and reuse freed blocks - the obfuscation of log entries
has to exactly match the obfuscation that is done on disk, and we
may have multiple overwrites of the same directory blocks to
obfuscate and all need to be correct. It's a damn hard problem that
I'll still strongly suggest we should never attempt to solve.

Part of playing the maintainer game is knowing how many resources
you have available, the relative complexity of the problems that
need to be solved and guiding the use of your limited resources
appropriately.  Debug tools that are rarely used are at the low end
of the priority list - they should have rough edges, because that
indicates we spend more time caring about making the production code
reliable than we do about polishing tools that are only used when
the production code has failed....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
