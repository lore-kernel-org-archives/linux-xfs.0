Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56468 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752085AbdJFSBk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Oct 2017 14:01:40 -0400
Subject: Re: [GIT PULL] xfsprogs: mkfs refactor
References: <20171003080607.GM15067@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <eca367b2-03de-517d-9ef5-5400e8a4739e@sandeen.net>
Date: Fri, 6 Oct 2017 13:01:39 -0500
MIME-Version: 1.0
In-Reply-To: <20171003080607.GM15067@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 10/3/17 3:06 AM, Dave Chinner wrote:
> Hi Eric,
> 
> I've put the latest mkfs refactor code that I have up in place
> you can pull it from. I've rebased it against the current for-next
> tree (4.13.1 release) and fixed all the problems that xfstests
> exposes. The only thing I haven't fixed is xfs/191 that does mkfs
> command line behaviour verification because the refactored version
> fixes several problems that the old mkfs didn't handle correctly
> (e.g. being able to specify certain things like agsize in blocks or
> sectors).
> 
> There's a small filter patch needed for xfstests that I'll post in
> a reply to this pull request that will filter out the new "defaults
> sourced from ..." output and so prevent spurious xfstests failures.
> 
> If you want I can tag the branch with a signed tag for you to pull
> from (same process as Linus prefers) rather than just a branch in a
> tree. If you'd prefer that I post this as patches instead, then let
> me know and I'll bomb the list instead.

Thanks Dave.  Trying to un-swamp from other things.

Only advantage to patchbombing is having a permanent record of discussions,
but maybe it can happen in reference to patches as follows.... mostly
minor nits.

> mkfs: can't specify sector size of internal log

commit log is a bit vague/misleading; I think you mean that
it should be /disallowed/ because it must match the filesystem's
/sector/ size when it's internal?  It's not actually clear to me why
an external log can have a "mismatched" sector size but internal can't.

> mkfs: introduce a structure to hold CLI options

"between th einput"  (the input)

Comment mentions initialization to -1 or 0 but I don't see that this
gets done, at least not in this patch? (Am I missing it?)  I took
this to mean that before anything happens this would be initialized
so we know what was and was not specified after everything was parsed...

> mkfs: introduce a structure to hold CLI options

+/* quick way of checking is a parameter was set on the CLI */
                         "if"

> mkfs: factor naming subopts parser

no "nvflag" in "temp don't break" code?  Oh, nice - write-only var.  Ok.
do we still test it for respec, or care?  Will check later.

> mkfs: Introduce mkfs configuration structure

would be nice to proofread commit log a bit ;)

> mkfs: Introduce mkfs configuration structure

s/teh/the/

<ok stopping here for now, will send more later>

