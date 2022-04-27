Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF8DC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 16:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243351AbiD0QtG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 12:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243518AbiD0QtA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 12:49:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955AA2359EC
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 09:45:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 348F061DD1
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 16:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5C6C385AC;
        Wed, 27 Apr 2022 16:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651077947;
        bh=S9l0Dr+A3uQbfd1BavNyfJr5EeogGE+IAPRLwvyNRFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kw2RBex75syXr8CP7n+TJN9nOEyAOTyYHq3sJR2KUx0D6TKN6lDWJYnplPKyIq844
         HgtLKtUJBjkefGHAFb2BWVm5DI3Ff4a+1I6qqcRv79HlcrAoIUi03C41/McxJNDFg0
         7GvBRE/rvs+uXcVOaF67ZBUK/Qdx1lDLHNbHV1J3F5yjNqKh76bL7q6DZmytvnWGOl
         M4Z2mi3869uauTxTc+TtNgBEbEtcuyELnXjIC2AJ2uz0OXQtpSQ3TK/pilasdALSx0
         II/rE5TpyPPXINcDDMVjT6VwqdkTHJkzMh7f1WF4ECQ38gqKD/nKYHGTXiBpGtvczC
         L0xJPn9tTUSNA==
Date:   Wed, 27 Apr 2022 09:45:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: hide log iovec alignment constraints
Message-ID: <20220427164546.GI17025@magnolia>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-2-david@fromorbit.com>
 <20220427031445.GD17025@magnolia>
 <20220427045034.GL1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427045034.GL1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 02:50:34PM +1000, Dave Chinner wrote:
> On Tue, Apr 26, 2022 at 08:14:45PM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 27, 2022 at 12:22:52PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Callers currently have to round out the size of buffers to match the
> > > aligment constraints of log iovecs and xlog_write(). They should not
> > > need to know this detail, so introduce a new function to calculate
> > > the iovec length (for use in ->iop_size implementations). Also
> > > modify xlog_finish_iovec() to round up the length to the correct
> > > alignment so the callers don't need to do this, either.
> > > 
> > > Convert the only user - inode forks - of this alignment rounding to
> > > use the new interface.
> > 
> > Hmm.  So currently, we require that the inode fork buffer be rounded up
> > to the next 4 bytes, and then I guess the log will copy that into the
> > log iovec?  IOWs, if we have a 37-byte data fork, we'll allocate a 40
> > byte buffer for the xfs_ifork, and the log will copy all 40 bytes into a
> > 40 byte iovec.
> 
> Yes, that's how the current code works. It ends up leaking whatever
> was in those 3 bytes into the shadow buffer that we then copy into
> the log region. i.e. the existing code "leaks" non-zeroed allocated
> memory to the journal.
> 
> > Now it looks like we'd allocate a 37-byte buffer for the xfs_ifork, but
> > the log iovec will still be 40 bytes.  So ... do we copy 37 bytes out of
> > the ifork buffer and zero the last 3 bytes in the iovec?
> 
> Yes, we copy 37 bytes out of the ifork buffer now into the shadow
> buffer so we do not overrun the inode fork buffer.
> 
> > Does we leak
> > kernel memory in those last 3 bytes?
> 
> We does indeed still leak the remaining 3 bytes as they are not
> zeroed.
> 
> > Or do we copy 40 bytes and
> > overrun?
> 
> No, we definitely don't do that - KASAN gets very unhappy when you
> do that...
> 
> > It sorta looks like (at least for the local format case) xlog_copy_iovec
> > will copy 37 bytes and leave the last 3 bytes of the iovec in whatever
> > state it was in previously.  Is that zeroed?  Because it then looks like
> > xlog_finish_iovec will round that 37 up to 40.
> 
> The shadow buffer is only partially zeroed - the part that makes io
> the header and iovec pointer array is zeroed, but the region that
> the journal data is written to is not zeroed.
> 
> > (FWIW I'm just checking for kernel memory exposure vectors here.)
> 
> Yup, I hadn't even considered that aspect of the code because we
> aren't actually leaking anything to userspace. If an unprivileged
> user can read 3 bytes of uninitialised data out of the journal we've
> got much, much bigger security problems to deal with.
> 
> It should be trivial to fix, though. I'll do the initial fix as a
> standalone patch, though, and then roll it into this one because the
> problem has been around for a long while and fixing this patch
> doesn't produce an easily backportable fix...

<nod> I agree that it's a very minor disclosure vulnerability (certainly
less severe than ALLOCSP) since you'd need CAP_SYS_RAWIO to exploit it.
But certainly worth patching before someone discovers that a former
pagecache page with your credit card numbers on it got recycled into a
log vector page.  Thanks for doing the fix. :)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
