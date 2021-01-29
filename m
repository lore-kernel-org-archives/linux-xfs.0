Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4D2C433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 17:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FF8664D9A
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 17:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhA2RJm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Jan 2021 12:09:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:60036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231511AbhA2RJd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 29 Jan 2021 12:09:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CC1164D9A;
        Fri, 29 Jan 2021 17:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611940117;
        bh=jlamJm3CbO06+b6SaECNTrj8BDXN1SDz9JbmkZ47bPc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DsfI+fwoPuMofwSJbVOHvgo38IcXc5xYkloT/XT91ANDpOHTHGm1PqrX9RivDABOr
         xbNXgMIhUGR5I4lmqepnUTf3AFL+7MRNtpvFNjVNr6zo59OEaGs871GN3iRDfyztYL
         xOVi2Vt7vhr/O83XGs5ZIgMenw0usEjpp8tW0zDlaaB0gVHRDamLHykdHJqM0eHWm8
         uPx2zGBfm5Amqtui8ZOC3w56Yj0+amgckBnOVFWk6vKHpyU6VJDcpXxutw3T9lEzWG
         U1CxqXcUn+RwDCy5pMAoOxPaaXvSlq1vj3TYwDwv7Qm91w4Na8SirB612e3YFco032
         Z0eUuOU9jxMIw==
Date:   Fri, 29 Jan 2021 09:08:36 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] xfs: Fix 'set but not used' warning in
 xfs_bmap_compute_alignments()
Message-ID: <20210129170836.GG7695@magnolia>
References: <20210127090537.2640164-1-chandanrlinux@gmail.com>
 <20210128153412.GD2599027@bfoster>
 <20210128174447.GS7698@magnolia>
 <87k0rwi433.fsf@garuda>
 <20210129124638.GA2660974@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129124638.GA2660974@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 29, 2021 at 07:46:38AM -0500, Brian Foster wrote:
> On Fri, Jan 29, 2021 at 01:10:00PM +0530, Chandan Babu R wrote:
> > On 28 Jan 2021 at 23:14, Darrick J. Wong wrote:
> > > On Thu, Jan 28, 2021 at 10:34:12AM -0500, Brian Foster wrote:
> > >> On Wed, Jan 27, 2021 at 02:35:37PM +0530, Chandan Babu R wrote:
> > >> > With both CONFIG_XFS_DEBUG and CONFIG_XFS_WARN disabled, the only reference to
> > >> > local variable "error" in xfs_bmap_compute_alignments() gets eliminated during
> > >> > pre-processing stage of the compilation process. This causes the compiler to
> > >> > generate a "set but not used" warning.
> > >> >
> > >> > Reported-by: kernel test robot <lkp@intel.com>
> > >> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > >> > ---
> > >> > This patch is applicable on top of current xfs-linux/for-next branch.
> > >> >
> > >> >  fs/xfs/libxfs/xfs_bmap.c | 9 ++++-----
> > >> >  1 file changed, 4 insertions(+), 5 deletions(-)
> > >> >
> > >> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > >> > index 2cd24bb06040..ba56554e8c05 100644
> > >> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > >> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > >> > @@ -3471,7 +3471,6 @@ xfs_bmap_compute_alignments(
> > >> >  	struct xfs_mount	*mp = args->mp;
> > >> >  	xfs_extlen_t		align = 0; /* minimum allocation alignment */
> > >> >  	int			stripe_align = 0;
> > >> > -	int			error;
> > >> >
> > >> >  	/* stripe alignment for allocation is determined by mount parameters */
> > >> >  	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> > >> > @@ -3484,10 +3483,10 @@ xfs_bmap_compute_alignments(
> > >> >  	else if (ap->datatype & XFS_ALLOC_USERDATA)
> > >> >  		align = xfs_get_extsz_hint(ap->ip);
> > >> >  	if (align) {
> > >> > -		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
> > >> > -						align, 0, ap->eof, 0, ap->conv,
> > >> > -						&ap->offset, &ap->length);
> > >> > -		ASSERT(!error);
> > >> > +		if (xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
> > >> > +			align, 0, ap->eof, 0, ap->conv, &ap->offset,
> > >> > +			&ap->length))
> > >> > +			ASSERT(0);
> > >>
> > >> I was wondering if we should just make xfs_bmap_extsize_align() return
> > >> void and push the asserts down into the function itself, but it looks
> > >> like xfs_bmap_rtalloc() actually handles the error. Any idea on why we
> > >> might have that inconsistency?
> > >
> > > It only returns nonzero if isrt (the fifth parameter) is nonzero, and
> > > only if the requested range is still not aligned to the rt extent size
> > > after aligning it and eliminating any overlaps with existing extents.
> > >
> > 
> > Adding to what Darrick has mentioned above ...
> > 
> > Space on realtime devices are tracked at a granularity of "rextsize"
> > bytes. Each bit held in the data blocks of xfs_mount->m_rbmip represents usage
> > status of a single rextsized block. Most likely this seems to be underlying
> > reason for strict allocation alignment requirements for realtime files.
> > 
> 
> Ah, I see. Could you fix the indentation/alignment of the call so it
> looks something like the following?
> 
> 		if (xfs_bmap_extsize_align(mp, &ap->got, &ap->prev, align, 0,
> 					   ap->eof, 0, ap->conv, &ap->offset,
> 					   &ap->length))
> 			ASSERT(0);
> 
> Otherwise the patch seems fine to me.

Yeah, I'll fix it in my tree before I push out for-next again.

--D

> Brian
> 
> > --
> > chandan
> > 
> 
