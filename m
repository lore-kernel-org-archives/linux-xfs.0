Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66333C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25FF064E22
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhA1SQn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 13:16:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231648AbhA1SHA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 13:07:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD9C264E1C;
        Thu, 28 Jan 2021 18:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611857179;
        bh=xiuEHDthf+/f6tG7OkYG7NrxMpOTlW2xQ1I8QuecKfk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FVWXBqk/vpclwrPPLKXtZ1+gIe6FWPIwIww3dhjrexBdQLltoYfr/9fYW7YNvyNBI
         YaFGUbTML2qrNdRs5vaQQKQo7VTbV1kzhsSoV9MkcgE2w8QnDI1sTrzYjuFC/rZ0OC
         6PkqLvqjvEonaxxhmzaGA/AEiAcmkaEW5sth0qN71PXi/7vqYkmISdUntlZ3hc5Dm+
         DeukssBIrfV/tLh/lan4KaZR7rOX1w59hMgAc//uMlZU7ay2qb+QtfzjCms0P719VQ
         GypCwnfmW6SlHEO1d2jzurc4B4+KSoNbfTHQL2oj1f5mYj6tdVxFncBqFDXvOTd5w+
         sb1epXSwtx95A==
Date:   Thu, 28 Jan 2021 10:06:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 09/13] xfs: refactor reflink functions to use
 xfs_trans_alloc_inode
Message-ID: <20210128180619.GU7698@magnolia>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181371557.1523592.14364313318301403930.stgit@magnolia>
 <20210128095345.GE1973802@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128095345.GE1973802@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 09:53:45AM +0000, Christoph Hellwig wrote:
> On Wed, Jan 27, 2021 at 10:01:55PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The two remaining callers of xfs_trans_reserve_quota_nblks are in the
> > reflink code.  These conversions aren't as uniform as the previous
> > conversions, so call that out in a separate patch.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_reflink.c |   58 +++++++++++++++++++++-----------------------------
> >  1 file changed, 24 insertions(+), 34 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 0778b5810c26..ded86cc4764c 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -376,16 +376,15 @@ xfs_reflink_allocate_cow(
> >  	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
> >  
> >  	xfs_iunlock(ip, *lockmode);
> >  
> > +	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks, 0,
> > +			false, &tp);
> > +	if (error) {
> > +		/* This function must return with ILOCK_EXCL held. */
> > +		*lockmode = XFS_ILOCK_EXCL;
> > +		xfs_ilock(ip, *lockmode);
> >  		return error;
> > +	}
> 
> The only thing that the only caller of xfs_reflink_allocate_cow does
> on error is to immediately release the lock.  So I think we are better
> off changing the calling convention instead of relocking here.

Ok, will do.

--D
