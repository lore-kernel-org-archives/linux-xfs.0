Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14196 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752351AbdLURlM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Dec 2017 12:41:12 -0500
Date: Thu, 21 Dec 2017 10:41:10 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [xfsprogs PATCH v2 2/3] xfs_io: add MAP_SYNC support to mmap()
Message-ID: <20171221174110.GD2158@linux.intel.com>
References: <20171205235651.17102-1-ross.zwisler@linux.intel.com>
 <20171205235651.17102-3-ross.zwisler@linux.intel.com>
 <20171221170908.GT12613@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171221170908.GT12613@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, fstests <fstests@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>

On Thu, Dec 21, 2017 at 09:09:08AM -0800, Darrick J. Wong wrote:
> On Tue, Dec 05, 2017 at 04:56:50PM -0700, Ross Zwisler wrote:

> > @@ -195,6 +200,13 @@ mmap_f(
> >  		case 'x':
> >  			prot |= PROT_EXEC;
> >  			break;
> > +		case 'S':
> > +			flags = MAP_SYNC | MAP_SHARED_VALIDATE;
> > +			if (!flags) {
> 
> Heh, subtle. :)
> 
> /me wonders if it'd be better to do this explicitly:
> 
> #ifdef HAVE_MAP_SYNC
> 	flags = MAP_SYNC | MAP_SHARED_VALIDATE;
> #else
> 	printf("MAP_SYNC not supported\n");
> 	return 1;
> #endif
> 
> ...though it's ugly.

Yea, I was trying to avoid #ifdefery.  If you prefer this, though, I'm happy
to change it.  Or maybe a comment would be enough?

/*
 * If MAP_SYNC and MAP_SHARED_VALIDATE aren't defined in the system headers we
 * will have defined them both as 0.
 */

?

> > +				printf("MAP_SYNC not supported\n");
> > +				return 0;
> 
> Are we supposed to be returning nonzero values for failing commands?

I don't think so.  All the other error conditions in this function also return
0.  I think the important thing is that 'exitcode' is set to 1 at the
beginning of the function per Dave's patch,

https://www.spinics.net/lists/linux-xfs/msg13605.html

which I pulled into my baseline:

https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/xfsprogs-dev.git/refs/?h=map_sync_v3

So, I likewise leave 'exitcode' as 1, bail out with a return code of 0, and
then you get the overall failure return of 1 from xfs_io at the shell.

> > @@ -764,7 +764,7 @@ Each (sec, nsec) pair constitutes a single timestamp value.
> >  
> >  .SH MEMORY MAPPED I/O COMMANDS
> >  .TP
> > -.BI "mmap [ " N " | [[ \-rwx ] [\-s " size " ] " "offset length " ]]
> > +.BI "mmap [ " N " | [[ \-rwxS ] [\-s " size " ] " "offset length " ]]
> >  With no arguments,
> >  .B mmap
> >  shows the current mappings. Specifying a single numeric argument
> > @@ -780,6 +780,10 @@ PROT_WRITE
> >  .RB ( \-w ),
> >  and PROT_EXEC
> >  .RB ( \-x ).
> > +The mapping will be created with the MAP_SHARED flag by default, or with the
> > +Linux specific (MAP_SYNC | MAP_SHARED_VALIDATE) flags if
> 
> I assume I'll be able to look up exactly what MAP_SYNC provides in the mmap
> manpage, right?

Yep, Jan updated the man page for both MAP_SYNC and MAP_SHARED_VALIDATE:
https://lists.01.org/pipermail/linux-nvdimm/2017-November/013158.html

Thank you for the review.
