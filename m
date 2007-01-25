Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 16:06:38 -0800 (PST)
Received: from smtp107.mail.mud.yahoo.com (smtp107.mail.mud.yahoo.com [209.191.85.217])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0P06Tqw020608
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 16:06:30 -0800
Message-ID: <45B7F43B.9060905@yahoo.com.au>
Date: Thu, 25 Jan 2007 11:05:15 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2]: Fix BUG in cancel_dirty_pages on XFS
References: <20070123223702.GF33919298@melbourne.sgi.com>	 <1169640835.6189.14.camel@twins>  <45B7627B.8050202@yahoo.com.au> <1169649604.6189.27.camel@twins>
In-Reply-To: <1169649604.6189.27.camel@twins>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@osdl.org

Peter Zijlstra wrote:
> On Thu, 2007-01-25 at 00:43 +1100, Nick Piggin wrote:
> 
> 
>>>Have you seen the new launder_page() a_op? called from
>>>invalidate_inode_pages2_range()
>>
>>It would have been nice to make that one into a more potentially
>>useful generic callback.
> 
> 
> That can still be done when the need arises, right?

Yeah I guess so.

>>But why was it introduced, exactly? I can't tell from the code or
>>the discussion why NFS couldn't start the IO, and signal the caller
>>to wait_on_page_writeback and retry? That seemed to me like the
>>convetional fix.
> 
> 
> to quote a bit:
> 
> On Tue, 19 Dec 2006 18:19:38 -0500
> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> 
>>    NFS: Fix race in nfs_release_page()
>>    
>>    invalidate_inode_pages2() may set the dirty bit on a page owing to the call
>>    to unmap_mapping_range() after the page was locked. In order to fix this,
>>    NFS has hooked the releasepage() method. This, however leads to deadlocks
>>    in other parts of the VM.
> 
> 
> and:
> 
> 
>>>Now, arguably the VM shouldn't be calling try_to_release_page() with
>>>__GFP_FS when it's holding a lock on a page.
>>>
>>>But otoh, NFS should never be running lock_page() within nfs_release_page()
>>>against the page which was passed into nfs_release_page().  It'll deadlock
>>>for sure.
>>
>>The reason why it is happening is that the last dirty page from that
>>inode gets cleaned, resulting in a call to dput().

OK but what's the problem with just failing to release the page if it
is dirty, I wonder? In the worst case, page reclaim will just end up
doing a writeout to clean it.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
