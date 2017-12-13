Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:1156 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751128AbdLMWUt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 17:20:49 -0500
Date: Thu, 14 Dec 2017 09:20:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/8] xfs/068: fix variability problems in file/dir count
 output
Message-ID: <20171213222046.GA4094@dastard>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314505158.18893.11894289091110903029.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151314505158.18893.11894289091110903029.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Dec 12, 2017 at 10:04:11PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In this test we use fsstress to create some number of files and then
> exercise xfsdump/xfsrestore on them.  Depending on the fsstress config
> we may end up with a different number of files than is hardcoded in the
> golden output (particularly after adding reflink support to fsstress)
> and thereby fail the test.  Since we're not really testing how many
> files fsstress can create, just turn the counts into XXX/YYY.

Hmmmm. those numbers were in the golden output specifically because
fsstress is supposed to be deterministic for a given random seed.
What it is supposed to be testing is that xfsdump actually dumped
all the files that were created, and xfs-restore was able to process
them all. If either barf on a file, they'll silently skip it, and
the numbers won't come out properly.

The typical class of bug this test finds is bulkstat iteration
problems - if bulkstat misses an inode it shouldn't, then the
xfsrestore numbers come out wrong. By making the data set
non-deterministic and not checking the numbers, we end up losing the
ability of this test to check bulkstat iteration and dump/restore
completeness....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
