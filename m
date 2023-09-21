Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFFF3E7D0AB
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Sep 2023 22:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbjIUW23 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 18:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbjIUW2M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2023 18:28:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2031026AE
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2023 15:26:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCF2C433CA;
        Thu, 21 Sep 2023 22:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695335188;
        bh=02z3Mw6XwEVmWztySgohN5lh7CQSBmybPtlDjzv/ElY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sbxVENEr6POr49LD4zRnzMXeYiMUulvMLimKS9XcXV6zQYP7/fxUwF5L3G627ib0S
         d1tHuVU20NjaDi3kh4br1BY8r2KB9rt1U9cvgttMZ9ciG8mPyphGZOSravouqc/Sxt
         RjTpEn0DvvQgVkm48A50ffy1O6phrsmQKmaWNZ7iUE7h9rEHyRqFcMA478LLKDOXwl
         BXvc5wjrg9K2NgI9Hm47xFVtGM0oYlmPtVjijfQYTZDLKZUpAqDuLkdLiEuqvAUyDX
         lCBZL+2QdI6ev0D9QeWCi3azYBQ3CcPml1YHCOSNkY3iJvMu4iSewEFw0SL4bbs93D
         1YOnkGFmn9eBA==
Date:   Thu, 21 Sep 2023 15:26:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: proposal: enhance 'cp --reflink' to expose ioctl_ficlonerange
Message-ID: <20230921222628.GF11391@frogsfrogsfrogs>
References: <8911B94D-DD29-4D6E-B5BC-32EAF1866245@oracle.com>
 <ZQk23NIAcY0BDpfI@dread.disaster.area>
 <20230920000058.GF348037@frogsfrogsfrogs>
 <ZQpF2bRLN3lQk1j1@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQpF2bRLN3lQk1j1@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 20, 2023 at 11:07:37AM +1000, Dave Chinner wrote:
> On Tue, Sep 19, 2023 at 05:00:58PM -0700, Darrick J. Wong wrote:
> > On Tue, Sep 19, 2023 at 03:51:24PM +1000, Dave Chinner wrote:
> > > On Tue, Sep 19, 2023 at 02:43:32AM +0000, Catherine Hoang wrote:
> > > The XFS clone implementation takes the IOLOCK_EXCL high up, and
> > > then lower down it iterates one extent doing the sharing operation.
> > > It holds the ILOCK_EXCL while it is modifying the extent in both the
> > > source and destination files, then commits the transaction and drops
> > > the ILOCKs.
> > > 
> > > OK, so we have fine-grained ILOCK serialisation during the clone for
> > > access/modification to the extent list. Excellent, I think we can
> > > make this work.
> > > 
> > > So:
> > > 
> > > 1. take IOLOCK_EXCL like we already do on the source and destination
> > > files.
> > > 
> > > 2. Once all the pre work is done, set a "clone in progress" flag on
> > > the in-memory source inode.
> > > 
> > > 3. atomically demote the source inode IOLOCK_EXCL to IOLOCK_SHARED.
> > > 
> > > 4. read IO and the clone serialise access to the extent list via the
> > > ILOCK. We know this works fine, because that's how the extent list
> > > access serialisation for concurrent read and write direct IO works.
> > > 
> > > 5. buffered writes take the IOLOCK_EXCL, so they block until the
> > > clone completes. Same behaviour as right now, all good.
> > 
> > I think pnfs layouts and DAX writes also take IOLOCK_EXCL, right?  So
> > once reflink breaks the layouts, we're good there too?
> 
> I think so.
> 
> <looks to confirm>
> 
> The pnfs code in xfs_fs_map_blocks() will reject mappings on any
> inode marked with shared extents, so I think the fact that we
> set the inode as having shared extents before we finish
> xfs_reflink_remap_prep() will cause pnfs mappings to kick out before
> we even take the IOLOCK.
> 
> But, regardless of that, both new PNFS mappings and DAX writes use
> IOLOCK_EXCL, and xfs_ilock2_io_mmap() breaks both PNFS and DAX
> layouts which will force them to finish what they are doing and sync
> data before the clone operation grabs the IOLOCK_EXCL. They'll block
> on the clone holding the IOLOCK from that point onwards, so I think
> we're good here.
> 
> hmmmmm.
> 
> <notes that xfs_ilock2_io_mmap() calls filemap_invalidate_lock_two()>
> 
> Sigh.
> 
> That will block buffered reads trying to instantiate new pages
> in the page cache. However, this isn't why the invalidate lock is
> held - that's being held to lock out lock page faults (i.e. mmap()
> access) whilst the clone is running.
> 
> 
> We really only need to lock out mmap writes, and the only way to do
> that is to prevent write faults from making progress whilst the
> clone is running.
> 
> __xfs_filemap_fault() currently takes XFS_MMAPLOCK_SHARED for write
> faults - I think we need it to look at the "clone in progress" flag
> for write faults, too, and use XFS_MMAPLOCK_EXCL in that case.
> 
> That would then allow us to demote the invalidate lock on the source
> file the same way we do the IOLOCK, allowing buffered reads to
> populate the page caceh but have write faults block until the clone
> completes (as they do now, same as writes).
> 
> Is there anything else I missed?

I think that's it.  I'd wondered how much we really care about reflink
stalling read faults, but yeah, let's fix both.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
