Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Feb 2007 06:44:37 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l17EiRm7029446
	for <xfs@oss.sgi.com>; Wed, 7 Feb 2007 06:44:29 -0800
Date: Thu, 8 Feb 2007 01:44:15 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1 of 2] Implement generic block_page_mkwrite() functionality
Message-ID: <20070207144415.GN44411608@melbourne.sgi.com>
References: <20070207124922.GK44411608@melbourne.sgi.com> <Pine.LNX.4.64.0702071256530.25060@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702071256530.25060@blonde.wat.veritas.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Hugh Dickins <hugh@veritas.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, Feb 07, 2007 at 01:00:28PM +0000, Hugh Dickins wrote:
> On Wed, 7 Feb 2007, David Chinner wrote:
> 
> > On Christoph's suggestion, take the guts of the proposed
> > xfs_vm_page_mkwrite function and implement it as a generic
> > core function as it used no specific XFS code at all.
> > 
> > This allows any filesystem to easily hook the ->page_mkwrite()
> > VM callout to allow them to set up pages dirtied by mmap
> > writes correctly for later writeout.
> > 
> > Signed-Off-By: Dave Chinner <dgc@sgi.com>
> 
> I'm worried about concurrent truncation.  Isn't it the case that
> i_mutex is held when prepare_write and commit_write are normally
> called?  But not here when page_mkwrite is called.

I'm not holding i_mutex. I assumed that it was probably safe to do
because we are likely to be reading the page off disk just before we
call mkwrite and that has to be synchronised with truncate in some
manner....

So, do I need to grab the i_mutex here? Is that safe to do that in
the middle of a page fault? If we do race with a truncate and the
page is now beyond EOF, what am I supposed to return?

I'm fishing for what I'm supposed to be doing here because there's
zero implementations of this callout in the kernel and the comments
in the code explaining the interface constraints are
non-existant....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
