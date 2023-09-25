Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C7FCE79A4
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbjIYV2t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233464AbjIYV2p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:28:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E38A1B3
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:28:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330C5C433C7;
        Mon, 25 Sep 2023 21:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695677316;
        bh=KM7OgKEtYn0xr8Kni6EgeZO29YU95eOPyXhumPO3lkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aqxXOHXtRzkP2f0DCiB/GgmF+lGQwds9iNvWJYi7Y72dpXYjna8xsn8jlKF9+nkWr
         HMFMFpCyMJUlg1vtZOuCX1wso/+C19JPJgp+RampP3DnTIb2LZpGw18/Ok/pDl5gyN
         fGZaCZeW9BIkb03fZyVteJVXxZ4MYcON+khUcqBYCPlP1EEo+PO6DwcTasftNw9N69
         WuukOsbg2Lwlit6jmJ3BG2/wrklDYGFt4O37g8x64BJehfc1WXPOZHNWKiwW1ZwPlK
         edg5Njt0kF09assSEXccLu3wU37yEtOUFHKgAQSOKKLef5hkOd1GFnhnPYQM88wbGz
         O0STz9brsZ5qQ==
Date:   Mon, 25 Sep 2023 14:28:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: proposal: enhance 'cp --reflink' to expose ioctl_ficlonerange
Message-ID: <20230925212835.GB11439@frogsfrogsfrogs>
References: <8911B94D-DD29-4D6E-B5BC-32EAF1866245@oracle.com>
 <ZQk23NIAcY0BDpfI@dread.disaster.area>
 <20230920000058.GF348037@frogsfrogsfrogs>
 <ZQpF2bRLN3lQk1j1@dread.disaster.area>
 <20230921222628.GF11391@frogsfrogsfrogs>
 <ZQzPWJ/iojT0Vumi@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQzPWJ/iojT0Vumi@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 22, 2023 at 09:18:48AM +1000, Dave Chinner wrote:
> On Thu, Sep 21, 2023 at 03:26:28PM -0700, Darrick J. Wong wrote:
> > On Wed, Sep 20, 2023 at 11:07:37AM +1000, Dave Chinner wrote:
> > > On Tue, Sep 19, 2023 at 05:00:58PM -0700, Darrick J. Wong wrote:
> > > > On Tue, Sep 19, 2023 at 03:51:24PM +1000, Dave Chinner wrote:
> > > > > On Tue, Sep 19, 2023 at 02:43:32AM +0000, Catherine Hoang wrote:
> > > > > The XFS clone implementation takes the IOLOCK_EXCL high up, and
> > > > > then lower down it iterates one extent doing the sharing operation.
> > > > > It holds the ILOCK_EXCL while it is modifying the extent in both the
> > > > > source and destination files, then commits the transaction and drops
> > > > > the ILOCKs.
> > > > > 
> > > > > OK, so we have fine-grained ILOCK serialisation during the clone for
> > > > > access/modification to the extent list. Excellent, I think we can
> > > > > make this work.
> > > > > 
> > > > > So:
> > > > > 
> > > > > 1. take IOLOCK_EXCL like we already do on the source and destination
> > > > > files.
> > > > > 
> > > > > 2. Once all the pre work is done, set a "clone in progress" flag on
> > > > > the in-memory source inode.
> > > > > 
> > > > > 3. atomically demote the source inode IOLOCK_EXCL to IOLOCK_SHARED.
> > > > > 
> > > > > 4. read IO and the clone serialise access to the extent list via the
> > > > > ILOCK. We know this works fine, because that's how the extent list
> > > > > access serialisation for concurrent read and write direct IO works.
> > > > > 
> > > > > 5. buffered writes take the IOLOCK_EXCL, so they block until the
> > > > > clone completes. Same behaviour as right now, all good.
> > > > 
> > > > I think pnfs layouts and DAX writes also take IOLOCK_EXCL, right?  So
> > > > once reflink breaks the layouts, we're good there too?
> > > 
> > > I think so.
> > > 
> > > <looks to confirm>
> > > 
> > > The pnfs code in xfs_fs_map_blocks() will reject mappings on any
> > > inode marked with shared extents, so I think the fact that we
> > > set the inode as having shared extents before we finish
> > > xfs_reflink_remap_prep() will cause pnfs mappings to kick out before
> > > we even take the IOLOCK.
> > > 
> > > But, regardless of that, both new PNFS mappings and DAX writes use
> > > IOLOCK_EXCL, and xfs_ilock2_io_mmap() breaks both PNFS and DAX
> > > layouts which will force them to finish what they are doing and sync
> > > data before the clone operation grabs the IOLOCK_EXCL. They'll block
> > > on the clone holding the IOLOCK from that point onwards, so I think
> > > we're good here.
> > > 
> > > hmmmmm.
> > > 
> > > <notes that xfs_ilock2_io_mmap() calls filemap_invalidate_lock_two()>
> > > 
> > > Sigh.
> > > 
> > > That will block buffered reads trying to instantiate new pages
> > > in the page cache. However, this isn't why the invalidate lock is
> > > held - that's being held to lock out lock page faults (i.e. mmap()
> > > access) whilst the clone is running.
> > > 
> > > 
> > > We really only need to lock out mmap writes, and the only way to do
> > > that is to prevent write faults from making progress whilst the
> > > clone is running.
> > > 
> > > __xfs_filemap_fault() currently takes XFS_MMAPLOCK_SHARED for write
> > > faults - I think we need it to look at the "clone in progress" flag
> > > for write faults, too, and use XFS_MMAPLOCK_EXCL in that case.
> > > 
> > > That would then allow us to demote the invalidate lock on the source
> > > file the same way we do the IOLOCK, allowing buffered reads to
> > > populate the page caceh but have write faults block until the clone
> > > completes (as they do now, same as writes).
> > > 
> > > Is there anything else I missed?
> > 
> > I think that's it.  I'd wondered how much we really care about reflink
> > stalling read faults, but yeah, let's fix both.
> 
> Well, it's not so much about mmap as the fact that holding
> invalidate lock exclusive prevents adding or removing folios to the
> page cache from any path. Hence the change as I originally proposed
> would block the buffered read path trying to add pages to the page
> cache the same as it will block the read fault path....

Ah, ok.

Catherine: Do you have enough information to get started on a proof of
concept?

--D

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
