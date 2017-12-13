Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:34873 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752659AbdLMW27 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 17:28:59 -0500
Date: Wed, 13 Dec 2017 14:23:52 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 8/8] xfs/068: fix variability problems in file/dir count
 output
Message-ID: <20171213222352.GI13436@magnolia>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314505158.18893.11894289091110903029.stgit@magnolia>
 <20171213222046.GA4094@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213222046.GA4094@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Dec 14, 2017 at 09:20:46AM +1100, Dave Chinner wrote:
> On Tue, Dec 12, 2017 at 10:04:11PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In this test we use fsstress to create some number of files and then
> > exercise xfsdump/xfsrestore on them.  Depending on the fsstress config
> > we may end up with a different number of files than is hardcoded in the
> > golden output (particularly after adding reflink support to fsstress)
> > and thereby fail the test.  Since we're not really testing how many
> > files fsstress can create, just turn the counts into XXX/YYY.
> 
> Hmmmm. those numbers were in the golden output specifically because
> fsstress is supposed to be deterministic for a given random seed.
> What it is supposed to be testing is that xfsdump actually dumped
> all the files that were created, and xfs-restore was able to process
> them all. If either barf on a file, they'll silently skip it, and
> the numbers won't come out properly.
> 
> The typical class of bug this test finds is bulkstat iteration
> problems - if bulkstat misses an inode it shouldn't, then the
> xfsrestore numbers come out wrong. By making the data set
> non-deterministic and not checking the numbers, we end up losing the
> ability of this test to check bulkstat iteration and dump/restore
> completeness....

Ah, fun.  Ok, in that case I think the correct fix for this problem is
to turn off clonerange/deduperange in the fsstress command line so that
we get back to deterministic(?) counts...

...unless a better solution to count the number of dirs/files and compare
to whatever xfsrestore says?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
