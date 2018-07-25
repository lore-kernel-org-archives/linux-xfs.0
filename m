Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45788 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729335AbeGYUZl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 16:25:41 -0400
Date: Wed, 25 Jul 2018 12:12:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: clean up IRELE/iput callsites
Message-ID: <20180725191221.GT4813@magnolia>
References: <153248128617.28208.11803349732053454018.stgit@magnolia>
 <153248129832.28208.4218463670080722161.stgit@magnolia>
 <20180725045823.GB31006@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180725045823.GB31006@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 24, 2018 at 09:58:23PM -0700, Christoph Hellwig wrote:
> On Tue, Jul 24, 2018 at 06:14:58PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Replace the IRELE macro with a proper function so that we can do proper
> > typechecking and so that we can stop open-coding iput in scrub, which
> > means that we'll be able to ftrace inode lifetimes going through scrub
> > correctly.
> 
> Why do we need a function to be able to use IRELE in scrub?

In short, the tracepoint in IRELE.

Early on in scrub's development I decided to give xfs_scrub its own
tracepoints.  I didn't want the scrub C files to have to include all the
xfs headers needed to support xfs_trace.h and I also didn't want to
shove even more tracepoint into that file because it's already a
horrible macro mess.  I also didn't want to have to include all the
scrub definitions treewide since you can leave scrub off in Kconfig.

Unfortunately, the ftrace macros also didn't like having multiple trace
headers for a single TRACE_SUBSYSTEM (and the gcc traceback when I tried
it was 50+ screens long and totally undebuggable) so it was easier to
give scrub its own tracepoint subsystem separate from regular XFS.  A
downside of that is that xfs and xfs_scrub cannot link to each other's
tracepoints, so until now scrub just open-coded calls to iput, which
made it hard to debug iget/iput leaks in scrub.

That wasn't a big deal, but since I was cleaning up the inode macros I
figured I might as well switch everyone to xfs_irele().

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
