Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11445CE79A9
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Sep 2023 00:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjITABH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Sep 2023 20:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjITABH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2023 20:01:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A0CA4
        for <linux-xfs@vger.kernel.org>; Tue, 19 Sep 2023 17:01:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFB1C433C7;
        Wed, 20 Sep 2023 00:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695168059;
        bh=VaxmaCmQ6NYLPnvzc494TbOZNPIswyf1DPS8h0fvzE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cXZzLPH6L8zsK3p6tahAwTddIp6mB6OeSitUS8MfipeIGUPjIWDip4Z0CYf5iu/7M
         7u28jag3KPDyEB8620ruS0zo5uY/9MbZT8+LJyAiibjpFhYE5MHtmynaV6+ixcu1J0
         vjO9XcvJ7AN4D4pjUZS7ytmRdWWKcxGyKA0qFoQ45yA62J305rglwSivOk8lRmvfM1
         RVytt6OGbHIOO+c/CpuCcwFh1erFhWAet94eHGavjtD8GEXyoADAL784CyFeEyx33v
         Q9oGj+m4fHfCTmIZbxTRFN9Yh5mieyhykkDO7GFN2dvVfc83f8jqO5rUQcKzPUAHi3
         HFr75Zaw8cWfA==
Date:   Tue, 19 Sep 2023 17:00:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: proposal: enhance 'cp --reflink' to expose ioctl_ficlonerange
Message-ID: <20230920000058.GF348037@frogsfrogsfrogs>
References: <8911B94D-DD29-4D6E-B5BC-32EAF1866245@oracle.com>
 <ZQk23NIAcY0BDpfI@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQk23NIAcY0BDpfI@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 19, 2023 at 03:51:24PM +1000, Dave Chinner wrote:
> On Tue, Sep 19, 2023 at 02:43:32AM +0000, Catherine Hoang wrote:
> > Hi all,
> > 
> > Darrick and I have been working on designing a new ioctl FICLONERANGE2. The
> > following text attempts to explain our needs and reasoning behind this decision. 
> > 
> > 
> > Contents
> > --------
> > 1. Problem Statement
> > 2. Proof of Concept
> > 3. Proposed Solution
> > 4. User Interface
> > 5. Testing Plan
> > 
> > 
> > 1. Problem Statement
> > --------------------
> > 
> > One of our VM cluster management products needs to snapshot KVM image files
> > so that they can be restored in case of failure. Snapshotting is done by
> > redirecting VM disk writes to a sidecar file and using reflink on the disk
> > image, specifically the FICLONE ioctl as used by "cp --reflink". Reflink
> > locks the source and destination files while it operates, which means that
> > reads from the main vm disk image are blocked, causing the vm to stall. When
> > an image file is heavily fragmented, the copy process could take several
> > minutes. Some of the vm image files have 50-100 million extent records, and
> > duplicating that much metadata locks the file for 30 minutes or more. Having
> > activities suspended for such a long time in a cluster node could result in
> > node eviction. A node eviction occurs when the cluster manager determines
> > that the vm is unresponsive. One of the criteria for determining that a VM
> > is unresponsive is the failure of filesystems in the guest to respond for an
> > unacceptably long time. In order to solve this problem, we need to provide a
> > variant of FICLONE that releases the file locks periodically to allow reads
> > to occur as vmbackup runs. The purpose of this feature is to allow vmbackup
> > to run without causing downtime.
> 
> Interesting problem to have - let me see if I understand it
> properly.
> 
> Writes are redirected away from the file being cloned, but reads go
> directly to the source file being cloned?
> 
> But cloning can take a long time, so breaking up the clone operation
> into multiple discrete ranges will allow reads through
> to the file being cloned with minimal latency. However, you don't
> want writes to the source file because that results in the
> atomicity of the clone operation being violated and corrupting the
> snapshot.
> 
> Hence the redirected writes ensure that the file being cloned does
> not change from syscall to syscall. This means the time interrupted
> clone operation can restart from where it left off and you still get
> an consistent image clone for the snapshot.
> 
> Did I get that right?

Right.

> If so, I'm wondering about the general usefulness of this
> multi-syscall construct - having to ensure that it isn't written to
> between syscalls is quite the constraint.

Write isolation is not that much of a constraint.  Qemu can set up the
sidecar internally and commit the sidecar back into the original image.
libvirt wraps this functionality.

> I wonder if we can do better than that and not need a new syscall;
> shared read + clone seems more like an inode extent list access
> serialisation problem than anything else...
> 
> <thinks for a bit>
> 
> Ok. a clone does not change any data in the source file.

Right.  The only modifications it does is to fsync the range, and that's
only an implementation detail of ocfs2 & xfs.

> Neither do read IO operations.
> 
> Hence from a data integrity perspective, there's no reason why read
> IO and FICLONE can't run concurrently on the source file.

<nod>

> Writes we still need to block so that the clone is an atomic
> point in time image of the file, but reads could be allowed.

<nod>

> The XFS clone implementation takes the IOLOCK_EXCL high up, and
> then lower down it iterates one extent doing the sharing operation.
> It holds the ILOCK_EXCL while it is modifying the extent in both the
> source and destination files, then commits the transaction and drops
> the ILOCKs.
> 
> OK, so we have fine-grained ILOCK serialisation during the clone for
> access/modification to the extent list. Excellent, I think we can
> make this work.
> 
> So:
> 
> 1. take IOLOCK_EXCL like we already do on the source and destination
> files.
> 
> 2. Once all the pre work is done, set a "clone in progress" flag on
> the in-memory source inode.
> 
> 3. atomically demote the source inode IOLOCK_EXCL to IOLOCK_SHARED.
> 
> 4. read IO and the clone serialise access to the extent list via the
> ILOCK. We know this works fine, because that's how the extent list
> access serialisation for concurrent read and write direct IO works.
> 
> 5. buffered writes take the IOLOCK_EXCL, so they block until the
> clone completes. Same behaviour as right now, all good.

I think pnfs layouts and DAX writes also take IOLOCK_EXCL, right?  So
once reflink breaks the layouts, we're good there too?

> 6. direct IO writes need to be modified to check the "clone in
> progress" flag after taking the IOLOCK_SHARED. If it is set, we have
> to drop the IOLOCK_SHARED and take it IOLOCK_EXCL. This will block
> until the clone completes.
> 
> 7. when the clone completes, we clear the "clone in progress" flag
> and drop all the IOLOCKs that are held.
> 
> AFAICT, this will give us shared clone vs read and exclusive clone
> vs write IO semantics for all clone operations. And if I've
> understood the problem statement correctly, this will avoid the
> read IO latency problems that long running clone operations cause
> without needing a new syscall.
> 
> Thoughts?

I think that'll work.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
