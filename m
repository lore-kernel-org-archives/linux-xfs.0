Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Nov 2007 05:15:59 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAMDFm3f009971
	for <xfs@oss.sgi.com>; Thu, 22 Nov 2007 05:15:52 -0800
Date: Fri, 23 Nov 2007 00:15:39 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
Message-ID: <20071122131539.GX114266761@sgi.com>
References: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com> <p73oddnhzoq.fsf@bingen.suse.de> <20071122011214.GR114266761@sgi.com> <1195702123.8369.78.camel@localhost.localdomain> <20071122120611.GA3573@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122120611.GA3573@one.firstfloor.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: Stewart Smith <stewart@mysql.com>, David Chinner <dgc@sgi.com>, xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

On Thu, Nov 22, 2007 at 01:06:11PM +0100, Andi Kleen wrote:
> > FWIW from a "real time" database POV this seems to make sense to me...
> > in fact, we probably rely on filesystem metadata way too much
> > (historically it's just "worked".... although we do seem to get issues
> > on ext3).
> 
> For that case you really would need priority inheritance: any metadata
> IO on behalf or blocking a process needs to use the process' block IO 
> priority.

How do you do that when the processes are blocking on semaphores,
mutexes or rw-semaphores in the fileysystem three layers removed from
the I/O in progress?

e.g. a low priority process transaction is holding the AGF buffer
locked but the transaction is blocked waiting for some other
metadata I/O it has issued needed in the transaction.  That metadata
I/O is being held out by a higher priority process doing lots of
I/O.

Another process at the same priority creates a file, requiring
inodes to be allocated so it locks the directory into the
transaction and later blocks on the AGF buffer semaphore trying to
allocate space for the new inode.

A very high priority process now comes along and tries to read the
directory locked in the create transaction, and blocks on the
directory inode ilock because it's already held in write mode.

That's three processes all blocked on locks unrelated to the I/O
that is being held out, and there is no direct connection that can
be used to pass the priority down to the blocked I/O that is causing
all the problems.....

It's a Bad Idea.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
