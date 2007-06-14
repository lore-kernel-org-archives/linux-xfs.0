Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Jun 2007 15:21:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5EMLLWt006218
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2007 15:21:23 -0700
Date: Fri, 15 Jun 2007 08:21:09 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: iov_iter_fault_in_readable fix
Message-ID: <20070614222109.GF86004887@sgi.com>
References: <200705292119.l4TLJtAD011726@shell0.pdx.osdl.net> <20070613134005.GA13815@localhost.sw.ru> <20070613135759.GD13815@localhost.sw.ru> <20070614173153.GA14771@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614173153.GA14771@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, npiggin@suse.de, mark.fasheh@oracle.com, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jun 14, 2007 at 06:31:53PM +0100, Christoph Hellwig wrote:
> On Wed, Jun 13, 2007 at 05:57:59PM +0400, Dmitriy Monakhov wrote:
> >  	Function prerform check for signgle region, with out respect to
> >  	segment nature of iovec, For example writev no longer works :)
> 
> Btw, could someone please start to collect all sniplets like this in
> a nice simple regression test suite?  If no one wants to start a new
> one we should probably just put it into xfsqa (which should be useable
> for other filesystems aswell despite the name)

Yeah, it can run a subset of the tests on NFS and UDF filesystems as well and
there are some specific UDF-only tests in it too.  I think the NFS test group
is mostly generic tests that don't use or test specific XFS features.

I'd be happy to accumulate tests like these in xfsqa...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
