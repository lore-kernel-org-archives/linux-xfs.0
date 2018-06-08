Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:21177 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752280AbeFHAsb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jun 2018 20:48:31 -0400
Date: Fri, 8 Jun 2018 10:48:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: xfs_reflink_convert_cow() memory allocation
 deadlock
Message-ID: <20180608004829.GX10363@dastard>
References: <20180607052132.6207-1-david@fromorbit.com>
 <20180607052132.6207-3-david@fromorbit.com>
 <20180607114140.GB7798@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180607114140.GB7798@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 07, 2018 at 07:41:40AM -0400, Brian Foster wrote:
> On Thu, Jun 07, 2018 at 03:21:32PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_reflink_convert_cow() manipulates the incore extent list
> > in GFP_KERNEL context in the IO submission path whilst holding
> > locked pages under writeback. This is a memory reclaim deadlock
> > vector. This code is not in a transaction, so any memory allocations
> > it makes aren't protected via the memalloc_nofs_save() context that
> > transactions carry.
> > 
> > Hence we need to run this call under memalloc_nofs_save() context to
> > prevent potential memory allocations from being run as GFP_KERNEL
> > and deadlocking.
> > 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Looks fine modulo the header thing Allison already pointed out:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> BTW, shouldn't we also be using XFS_TRANS_NOFS in
> xfs_iomap_write_allocate()?

Most likely, yes.

However, I think the whole ->writepages path should be moved under
memalloc_nofs_save() context. I'm kinda waiting for the bufferhead
removal to land before auditing it fully and determining the scope
we should be covering by nofs alloc contexts. This was just a
drive-by patch to fix a problem that was reported...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
