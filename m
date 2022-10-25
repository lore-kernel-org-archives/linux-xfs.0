Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA17ECDFA1
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 22:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiJYWIa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 18:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbiJYWI3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 18:08:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC5B286D6
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 15:08:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3A3B61BB8
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 22:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238AEC433D6;
        Tue, 25 Oct 2022 22:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666735707;
        bh=wSr+Ezuvpw+7BgI9CS8tenLePgWoWJpLHdTW9zp4rrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MF2LF58Wm7TRVaQm/mJ47fburAbkWjZpsWOpJwDbEra6gT7zzAOBZ509etcZ12OFj
         uRPTq4ahArC+FNNq9ridT9Z9QJzOReFfSxzc81eU8j+VuxdbcgR9ImmhrE9TKo8hwh
         AE8KnuQjXl3kUF7BduTlc7DXXsswY5mQiI48Fxuwwn+TAk+JS6lEkTW2jP2+O9bZzi
         98O0AQy6mWIJOScivrjPBXFYp8eS8ovcIBQfBEdpDniyad5n6G/dSHs9JwNThqzPCu
         iVf1fwn1UvMCvBsJK23cBM59xbdJ3VGGlX9SJHVOBK6tBMXad4Mdm5sa9VpwBBaYM4
         Ftdfm5q8mDVpg==
Date:   Tue, 25 Oct 2022 15:08:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: refactor all the EFI/EFD log item sizeof logic
Message-ID: <Y1heWlHlPLaxmDQe@magnolia>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
 <166664718541.2688790.5847203715269286943.stgit@magnolia>
 <20221025220543.GG3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025220543.GG3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 26, 2022 at 09:05:43AM +1100, Dave Chinner wrote:
> On Mon, Oct 24, 2022 at 02:33:05PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Refactor all the open-coded sizeof logic for EFI/EFD log item and log
> > format structures into common helper functions whose names reflect the
> > struct names.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_log_format.h |   48 ++++++++++++++++++++++++++++
> >  fs/xfs/xfs_extfree_item.c      |   69 ++++++++++++----------------------------
> >  fs/xfs/xfs_extfree_item.h      |   16 +++++++++
> >  fs/xfs/xfs_super.c             |   12 ++-----
> >  4 files changed, 88 insertions(+), 57 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> > index 2f41fa8477c9..f13e0809dc63 100644
> > --- a/fs/xfs/libxfs/xfs_log_format.h
> > +++ b/fs/xfs/libxfs/xfs_log_format.h
> > @@ -616,6 +616,14 @@ typedef struct xfs_efi_log_format {
> >  	xfs_extent_t		efi_extents[];	/* array of extents to free */
> >  } xfs_efi_log_format_t;
> >  
> > +static inline size_t
> > +xfs_efi_log_format_sizeof(
> > +	unsigned int		nr)
> > +{
> > +	return sizeof(struct xfs_efi_log_format) +
> > +			nr * sizeof(struct xfs_extent);
> > +}
> 
> FWIW, I'm not really a fan of placing inline code in the on-disk
> format definition headers because combining code and type
> definitions eventually leads to dependency hell.
> 
> I'm going to say it's OK for these functions to be placed here
> because they have no external dependencies and are directly related
> to the on-disk structures, but I think we need to be careful about
> how much code we include into this header as opposed to the type
> specific header files (such as fs/xfs/xfs_extfree_item.h)...
> 
> > @@ -345,9 +318,8 @@ xfs_trans_get_efd(
> >  	ASSERT(nextents > 0);
> >  
> >  	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
> > -		efdp = kmem_zalloc(sizeof(struct xfs_efd_log_item) +
> > -				nextents * sizeof(struct xfs_extent),
> > -				0);
> > +		efdp = kmem_zalloc(xfs_efd_log_item_sizeof(nextents),
> > +				GFP_KERNEL | __GFP_NOFAIL);
> 
> That looks like a broken kmem->kmalloc conversion. Did you mean to
> convert this to allocation to use kzalloc() at the same time?

Oops, yeah.

> Everything else looks ok, so with the above fixed up
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks!

--D

> 
> -- 
> Dave Chinner
> david@fromorbit.com
