Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 06:41:11 -0800 (PST)
Received: from amsfep11-int.chello.nl (amsfep19-int.chello.nl [213.46.243.16] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0OEf2qw022475
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 06:41:04 -0800
Subject: Re: [PATCH 1/2]: Fix BUG in cancel_dirty_pages on XFS
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <45B7627B.8050202@yahoo.com.au>
References: <20070123223702.GF33919298@melbourne.sgi.com>
	 <1169640835.6189.14.camel@twins>  <45B7627B.8050202@yahoo.com.au>
Content-Type: text/plain
Date: Wed, 24 Jan 2007 15:40:04 +0100
Message-Id: <1169649604.6189.27.camel@twins>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@osdl.org

On Thu, 2007-01-25 at 00:43 +1100, Nick Piggin wrote:

> > Have you seen the new launder_page() a_op? called from
> > invalidate_inode_pages2_range()
> 
> It would have been nice to make that one into a more potentially
> useful generic callback.

That can still be done when the need arises, right?

> But why was it introduced, exactly? I can't tell from the code or
> the discussion why NFS couldn't start the IO, and signal the caller
> to wait_on_page_writeback and retry? That seemed to me like the
> convetional fix.

to quote a bit:

On Tue, 19 Dec 2006 18:19:38 -0500
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

>     NFS: Fix race in nfs_release_page()
>     
>     invalidate_inode_pages2() may set the dirty bit on a page owing to the call
>     to unmap_mapping_range() after the page was locked. In order to fix this,
>     NFS has hooked the releasepage() method. This, however leads to deadlocks
>     in other parts of the VM.

and:

> > Now, arguably the VM shouldn't be calling try_to_release_page() with
> > __GFP_FS when it's holding a lock on a page.
> > 
> > But otoh, NFS should never be running lock_page() within nfs_release_page()
> > against the page which was passed into nfs_release_page().  It'll deadlock
> > for sure.
> 
> The reason why it is happening is that the last dirty page from that
> inode gets cleaned, resulting in a call to dput().
