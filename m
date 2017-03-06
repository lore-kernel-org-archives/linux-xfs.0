Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:45668 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753140AbdCFVz0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2017 16:55:26 -0500
Date: Tue, 7 Mar 2017 08:47:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: allow zero-length symlinks (and directories), sort
 of
Message-ID: <20170306214755.GM17542@dastard>
References: <20170304000529.GB5073@birch.djwong.org>
 <20170306135143.GC3223@bfoster.bfoster>
 <20170306172205.GA5280@birch.djwong.org>
 <20170306181820.GE3223@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170306181820.GE3223@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Mon, Mar 06, 2017 at 01:18:20PM -0500, Brian Foster wrote:
> On Mon, Mar 06, 2017 at 09:22:05AM -0800, Darrick J. Wong wrote:
> > On Mon, Mar 06, 2017 at 08:51:44AM -0500, Brian Foster wrote:
> > > On Fri, Mar 03, 2017 at 04:05:29PM -0800, Darrick J. Wong wrote:
> > > > In commit ef388e2054 ("don't allow di_size with high bit set") and
> > > > commit 3c6f46eacd87 ("sanity check directory inode di_size") we
> > > > erroneously fail the inode verification checks for symlinks or
> > > > directories with di_size == 0.
> > > > 
> > > > This is proven incorrect by generic/388 because the unlink process uses
> > > > multiple unconnected transactions to truncate the remote symlink /
> > > > directory and to unlink and free the inode.  If the fs goes down after
> > > > the truncate commit but before the unlink happens, we are left with a
> > > > zero-length inode.  Worse yet, if the unlink /does/ commit, log recovery
> > > > will now break after the first transaction because we've zeroed di_size.
> > 
> > Ugh, I misspoke slightly.  Truncate and *ifree* are separate
> > transactions that can lose each other in the mist after a crash.
> > 
> > So that separates this discussion into two classes of problem -- the
> > first is the case of "truncate, crash, forget to ifree", which at least
> > isn't a user-visible problem because the inode has been unlinked from
> > the directory tree at that point.  Log recovery breaks if iget ->
> > dinode_verify stumbles over the zero-length inode.
> > 
> 
> Ok, that change seems reasonable.

Not to me, though - it's indicative of an atomicity problem, and not
something we should work around by considering the intermediate
"corrupt" state on disk valid. Remember that one of the main reasons
for checks like these in the verifiers is that they tell us where
our transactional change atomicity is broken. Gutting the verifier
because it's indicated we have a change atomicity problem is not the
solution.

i.e. I think we should be looking at changing xfs_inactive() to use
the deferred ops state machine for the multiple {truncate-data,
truncata-attr, free inode} transactions. Then we don't need to care
about temporary incomplete state on disk - if we get the first
transaction completed, log recovery will have an intent one disk for
the next transaction, and we can complete the inode freeing
process rather than leaving a dangling chad.

Making an exception in a verifier for a special log recovery state
is fine - we have to handle all sorts of interesting intermediate
states in log recovery - but as a general rule if it's an invalid
state the verifier should always be catching it....

[snip]

> Essentially what I'm saying is that if it is not possible to have a
> zero-sized symlink in a directory except for a bug or external
> modification, or there is otherwise no path to recover outside of
> xfs_repair (i.e., the current verify failure behavior) then EFSCORRUPTED
> makes sense to me.

*nod*

> If it is possible (even if it only occurs as an
> artifact of log recovery) and everything works except for reading the
> actual link returns an error (i.e., it can be renamed, unlinked), then
> I'm not sure EFSCORRUPTED is the right error.

We shouldn't ever get that far on a zero-length symlink/directory
because the inode is clearly in an invalid state....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
