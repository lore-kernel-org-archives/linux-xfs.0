Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Feb 2007 08:49:09 -0800 (PST)
Received: from rgminet02.oracle.com (rgminet02.oracle.com [148.87.113.119])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l17Gmxm7003766
	for <xfs@oss.sgi.com>; Wed, 7 Feb 2007 08:49:00 -0800
Received: from rgminet01.oracle.com (rgminet01.oracle.com [148.87.113.118])
	by rgminet02.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l17FtAmE031931
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 7 Feb 2007 08:55:10 -0700
Date: Wed, 7 Feb 2007 10:52:45 -0500
From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1 of 2] Implement generic block_page_mkwrite() functionality
Message-ID: <20070207155245.GB11967@think.oraclecorp.com>
References: <20070207124922.GK44411608@melbourne.sgi.com> <Pine.LNX.4.64.0702071256530.25060@blonde.wat.veritas.com> <20070207144415.GN44411608@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070207144415.GN44411608@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Thu, Feb 08, 2007 at 01:44:15AM +1100, David Chinner wrote:
> On Wed, Feb 07, 2007 at 01:00:28PM +0000, Hugh Dickins wrote:
> > On Wed, 7 Feb 2007, David Chinner wrote:
> > 
> > > On Christoph's suggestion, take the guts of the proposed
> > > xfs_vm_page_mkwrite function and implement it as a generic
> > > core function as it used no specific XFS code at all.
> > > 
> > > This allows any filesystem to easily hook the ->page_mkwrite()
> > > VM callout to allow them to set up pages dirtied by mmap
> > > writes correctly for later writeout.
> > > 
> > > Signed-Off-By: Dave Chinner <dgc@sgi.com>
> > 
> > I'm worried about concurrent truncation.  Isn't it the case that
> > i_mutex is held when prepare_write and commit_write are normally
> > called?  But not here when page_mkwrite is called.
> 
> I'm not holding i_mutex. I assumed that it was probably safe to do
> because we are likely to be reading the page off disk just before we
> call mkwrite and that has to be synchronised with truncate in some
> manner....

In general, commit_write is allowed to update i_size, and prepare/commit
are called with i_mutex.  block_prepare_write and block_commit_write
both look safe to me for calling with only the page lock held.  It more
or less translates to: call get_block in a sane fashion and zero out the
parts of the page past eof.

But, if someone copies the code and puts their own fancy
prepare/commit_write in there, they will get in trouble in a hurry...

> 
> So, do I need to grab the i_mutex here? Is that safe to do that in
> the middle of a page fault? If we do race with a truncate and the
> page is now beyond EOF, what am I supposed to return?

Should it check to make sure the page is still in the address space
after locking it?

-chris
