Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CACAC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 04:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239599AbiD0Exw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 00:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237234AbiD0Exr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 00:53:47 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D5D19377F6
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 21:50:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F3616538514;
        Wed, 27 Apr 2022 14:50:36 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njZdK-0051X7-Vq; Wed, 27 Apr 2022 14:50:35 +1000
Date:   Wed, 27 Apr 2022 14:50:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: hide log iovec alignment constraints
Message-ID: <20220427045034.GL1098723@dread.disaster.area>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-2-david@fromorbit.com>
 <20220427031445.GD17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427031445.GD17025@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6268cb9d
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=uW1Ypf2kw1EuoSEU8UIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 08:14:45PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 27, 2022 at 12:22:52PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Callers currently have to round out the size of buffers to match the
> > aligment constraints of log iovecs and xlog_write(). They should not
> > need to know this detail, so introduce a new function to calculate
> > the iovec length (for use in ->iop_size implementations). Also
> > modify xlog_finish_iovec() to round up the length to the correct
> > alignment so the callers don't need to do this, either.
> > 
> > Convert the only user - inode forks - of this alignment rounding to
> > use the new interface.
> 
> Hmm.  So currently, we require that the inode fork buffer be rounded up
> to the next 4 bytes, and then I guess the log will copy that into the
> log iovec?  IOWs, if we have a 37-byte data fork, we'll allocate a 40
> byte buffer for the xfs_ifork, and the log will copy all 40 bytes into a
> 40 byte iovec.

Yes, that's how the current code works. It ends up leaking whatever
was in those 3 bytes into the shadow buffer that we then copy into
the log region. i.e. the existing code "leaks" non-zeroed allocated
memory to the journal.

> Now it looks like we'd allocate a 37-byte buffer for the xfs_ifork, but
> the log iovec will still be 40 bytes.  So ... do we copy 37 bytes out of
> the ifork buffer and zero the last 3 bytes in the iovec?

Yes, we copy 37 bytes out of the ifork buffer now into the shadow
buffer so we do not overrun the inode fork buffer.

> Does we leak
> kernel memory in those last 3 bytes?

We does indeed still leak the remaining 3 bytes as they are not
zeroed.

> Or do we copy 40 bytes and
> overrun?

No, we definitely don't do that - KASAN gets very unhappy when you
do that...

> It sorta looks like (at least for the local format case) xlog_copy_iovec
> will copy 37 bytes and leave the last 3 bytes of the iovec in whatever
> state it was in previously.  Is that zeroed?  Because it then looks like
> xlog_finish_iovec will round that 37 up to 40.

The shadow buffer is only partially zeroed - the part that makes io
the header and iovec pointer array is zeroed, but the region that
the journal data is written to is not zeroed.

> (FWIW I'm just checking for kernel memory exposure vectors here.)

Yup, I hadn't even considered that aspect of the code because we
aren't actually leaking anything to userspace. If an unprivileged
user can read 3 bytes of uninitialised data out of the journal we've
got much, much bigger security problems to deal with.

It should be trivial to fix, though. I'll do the initial fix as a
standalone patch, though, and then roll it into this one because the
problem has been around for a long while and fixing this patch
doesn't produce an easily backportable fix...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
