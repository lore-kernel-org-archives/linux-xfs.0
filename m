Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:56369 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750748AbdLMXuL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 18:50:11 -0500
Date: Thu, 14 Dec 2017 10:42:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/8] xfs/068: fix variability problems in file/dir count
 output
Message-ID: <20171213234239.GE5858@dastard>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314505158.18893.11894289091110903029.stgit@magnolia>
 <20171213222046.GA4094@dastard>
 <20171213222352.GI13436@magnolia>
 <20171213224552.GB4094@dastard>
 <20171213231745.GS19219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213231745.GS19219@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Dec 13, 2017 at 03:17:45PM -0800, Darrick J. Wong wrote:
> On Thu, Dec 14, 2017 at 09:45:53AM +1100, Dave Chinner wrote:
> > On Wed, Dec 13, 2017 at 02:23:52PM -0800, Darrick J. Wong wrote:
> > > On Thu, Dec 14, 2017 at 09:20:46AM +1100, Dave Chinner wrote:
> > > > On Tue, Dec 12, 2017 at 10:04:11PM -0800, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > 
> > > > > In this test we use fsstress to create some number of files and then
> > > > > exercise xfsdump/xfsrestore on them.  Depending on the fsstress config
> > > > > we may end up with a different number of files than is hardcoded in the
> > > > > golden output (particularly after adding reflink support to fsstress)
> > > > > and thereby fail the test.  Since we're not really testing how many
> > > > > files fsstress can create, just turn the counts into XXX/YYY.
> > > > 
> > > > Hmmmm. those numbers were in the golden output specifically because
> > > > fsstress is supposed to be deterministic for a given random seed.
> > > > What it is supposed to be testing is that xfsdump actually dumped
> > > > all the files that were created, and xfs-restore was able to process
> > > > them all. If either barf on a file, they'll silently skip it, and
> > > > the numbers won't come out properly.
> > > > 
> > > > The typical class of bug this test finds is bulkstat iteration
> > > > problems - if bulkstat misses an inode it shouldn't, then the
> > > > xfsrestore numbers come out wrong. By making the data set
> > > > non-deterministic and not checking the numbers, we end up losing the
> > > > ability of this test to check bulkstat iteration and dump/restore
> > > > completeness....
> > > 
> > > Ah, fun.  Ok, in that case I think the correct fix for this problem is
> > > to turn off clonerange/deduperange in the fsstress command line so that
> > > we get back to deterministic(?) counts...
> > 
> > Why aren't the clonerange/deduperange operations deterministic?
> > Shouldn't these always do the same thing from the POV of
> > xfsdump/restore?
> 
> The operations themselves are deterministic, but adding the two commands
> for clone & dedupe changed the size of the ops table, which means that
> fsstress pursues a different sequence of operations for a given nproc
> and seed input.  Furthermore, the outcome of the operations will differ
> depending on whether or not the xfs supports reflink, because a
> clonerange that fails with EOPNOTSUPP causes the commands' frequency to
> be zeroed in the command table.

Ah, ok. So it's the dynamic nature of newly supported operations
that causes the problems for this test, not that the options arei
supported. Seems reasonable just to disable them for these tests,
then.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
