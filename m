Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:35877 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751315AbeDFDaZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Apr 2018 23:30:25 -0400
Date: Fri, 6 Apr 2018 13:30:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] xfs: pass xfs_dqblk to
 xfs_dquot_verify/xfs_dquot_repair
Message-ID: <20180406033022.GR23861@dastard>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <c92cfdb8-88c2-0f5b-7383-e5208fef6f5e@redhat.com>
 <20180405035241.GB7500@magnolia>
 <5c02fc77-28b6-4665-82f3-699fda82688c@sandeen.net>
 <20180405224033.GG23861@dastard>
 <3d482958-bf06-86f4-56e1-c679e9490495@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d482958-bf06-86f4-56e1-c679e9490495@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Apr 05, 2018 at 09:50:01PM -0500, Eric Sandeen wrote:
> 
> 
> On 4/5/18 5:40 PM, Dave Chinner wrote:
> > On Wed, Apr 04, 2018 at 11:13:03PM -0500, Eric Sandeen wrote:
> >> On 4/4/18 10:52 PM, Darrick J. Wong wrote:
> >>> On Wed, Apr 04, 2018 at 01:54:26PM -0500, Eric Sandeen wrote:
> >>>> In order to validate the UUID in xfs_dquot_verify, we need
> >>>> the full xfs_qblk, not just the xfs_disk_dquot_t (which is
> >>>
> >>>           ^^^^^^^^^ xfs_dqblk, right?
> >>
> >> yup
> >>
> >> ...
> >>
> >>>> @@ -192,14 +191,10 @@
> >>>
> >>> Any way you can get your diff generator to add -p to spit out the
> >>> alleged function this chunk is supposed to land in?  It makes reviewing
> >>> patches somewhat easier for me. :)
> >>
> >> No doubt ... I don't know why it doesn't do so, sorry.  :/  Will try
> >> to figure that out.  Sorry about that.
> > 
> > diff -up
> 
> I am actually familiar with diff, thanks ;)  I couldn't figure out why
> git & guilt weren't giving me the expected results.
> 
> For some reason I had this in this particular repo:
> 
> $ cat .gitattributes
> *.c   diff=cpp
> *.h   diff=cpp
> 
> Getting rid of that fixes it, I don't actually know why it was there.

That's in all my kernel repos, but not in xfs repos. It works like
.gitignore apparently, so it's something that comes along with the
repo.

$ gl .gitattributes 
commit 218dd85887da3d7d08119de18e9d325fcf30d7a4
Author: Jean Delvare <jdelvare@suse.de>
Date:   Fri Oct 7 17:03:04 2016 -0700

    .gitattributes: set git diff driver for C source code files
    
    Git can be told to apply language-specific rules when generating diffs.
    Enable this for C source code files (*.c and *.h) so that function names
    are printed right.  Specifically, doing so prevents "git diff" from
    mistakenly considering unindented goto labels as function names.
    
    Link: http://lkml.kernel.org/r/20160907143403.1449324f@endymion
    Signed-off-by: Jean Delvare <jdelvare@suse.de>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Joe Perches <joe@perches.com>
    Cc: Jonathan Corbet <corbet@lwn.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


$ man 5 gitattributes
....
Defining a custom hunk-header
	  Each group of changes (called a "hunk") in the textual
	  diff output is prefixed with a line of the form:

		 @@ -k,l +n,m @@ TEXT
.....
	.... The following built in patterns are available:
.....
		- cpp suitable for source code in the C and C++ languages.


It doesn't seem to make any difference when I copy it into my local
xfs repos, except:

$ git status
On branch guilt/working
Untracked files:
  (use "git add <file>..." to include in what will be committed)

	.gitattributes

nothing added to commit but untracked files present (use "git add" to track)
$

/me shrugs.

Git became far too complex for mere mortals to understand a long
time ago....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
