Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6JIq0aI230440 for <xfs@oss.sgi.com>; Mon, 19 Jul 2010 13:52:01 -0500
Subject: Re: Slow delete
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <201007121417.14097@zmi.at>
References: <AANLkTinPmhJRD3CDdsHtkLFzYd2jF9ee7gPqgO6XBSfl@mail.gmail.com>
	<20100705233448.GB24712@dastard>  <201007121417.14097@zmi.at>
Date: Mon, 19 Jul 2010 13:54:57 -0500
Message-ID: <1279565697.1855.136.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Mon, 2010-07-12 at 14:17 +0200, Michael Monnerie wrote:
> On Dienstag, 6. Juli 2010 Dave Chinner wrote:
> > For a detailed explanation of the concept and how delayed logging
> > takes advantage of it to speed up stuff like deleting a large number
> > of files, see:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=bl
> > ob;f=Documentation/filesystems/xfs-delayed-logging-design.txt
>  
> Great docu, although my head still exploded on reading this, and at some 
> point I started to just read over it. Luckily, I'm no dev, otherwise I'd 
> need to grow a second head for the extra brain space needed to 
> understand all that stuff, and that would make my appearance even worse 
> than it is already. Also, I'm not sure if the two-head solution isn't 
> patented by Zaphod Beeblebrox already, at least in the U.S. region.

Assuming your single head is still in good enough shape
to understand this, here's a high-level (though imprecise)
explanation.

Like many operations in XFS, deleting an entry from a
directory requires the creation of entries in the XFS
log.  These entries record the net effect of the delete
operation, allowing the delete operation to be reconstructed
(more or less) in the event of a crash.

A transaction in the log records information about
critical data structures and how they will change as
the result of an operation.  Log entries get saved to
disk in such a way that following a crash, the file
system can be put into a consistent state quickly by
"replaying" entries recently recorded to the log.

If you perform a number of operations on the same object
(such as removing multiple files from the same directory),
XFS currently sends copies of some of the affected data
structures to the log repeatedly--once for each operation
in sequence.

So for example if you delete lots of files from the same
directory, there is a consequently large volume of log
activity that needs to be performed, often describing
updates to the same data structure.  Such a structure
will (currently) get written to disk many many times
as a result.

Dave recently added support for "delayed logging" to
XFS.  It's currently an experimental feature, enabled
via a mount option.  When delayed logging is active,
some log activity is held off, allowing numerous
updates to the same data structure to be aggregated.
A logged data structure can then be committed to disk
much less frequently, reducing the amount of data that
needs to be written to disk while preserving the ability
to recover the file system following a crash.

This optimization allows certain operations (like
mass deletions) to be completed much more efficiently,
and in the case of large directories the performance
improvement that results can be significant.

In any crash situation, there will be a certain amount
of file system activity underway at the time of the
crash that will be lost; logging file system operations
doesn't eliminate that possibility.  The down side of
delayed logging is this type of loss is likely to be
greater than it would be with the more conventional
XFS logging mechanism.  This is a tradeoff between
file system performance in normal operation and the
amount that can be recovered after a crash.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
