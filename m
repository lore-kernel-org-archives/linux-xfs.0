Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B6CC47082
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 21:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F88C6139A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 21:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhFCVQH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 17:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhFCVQH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jun 2021 17:16:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EFD5613EA;
        Thu,  3 Jun 2021 21:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622754862;
        bh=PKJ5RhN6KG+UDpQk6IVyj/WrnzaDWWk1AlmcuyjKju0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XHzB9JehNNdfb2s546MrYpU5Gb8cjCqofXQUiwALDPrFxb9iRvoczUX3+w1u9k1oK
         fcIaWeXGgLuIkpyN1v9lukBeLCXNri4IXSeh3IGKdbxh59G9n6x12i/tE0t97+p+nv
         KxEnFMSk5UYPacrAPVxMI9GYTOfRhUV3G9jK2ODlj3L64AgwZR/G0EFsriRleViuit
         vNj4E44WEMbw6QRiIHad5DqPOD3PYvuFb0ue15o3nleqUTajioazyTZ+yrUXCzQ0Er
         LwUpUu3pkw+j50QEPuaqUZWWYLC6LaUk9gE23KaJc7DT0bGSKFvLe7z95j7WYiYmRj
         q0dyDP4E7EFdA==
Date:   Thu, 3 Jun 2021 14:14:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: change the prefix of XFS_EOF_FLAGS_* to
 XFS_ICWALK_FLAG_
Message-ID: <20210603211421.GC26380@locust>
References: <162268997425.2724263.18220495607834735216.stgit@locust>
 <162268997987.2724263.8793609361184652026.stgit@locust>
 <20210603044622.GR664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603044622.GR664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 03, 2021 at 02:46:22PM +1000, Dave Chinner wrote:
> On Wed, Jun 02, 2021 at 08:12:59PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In preparation for renaming struct xfs_eofblocks to struct xfs_icwalk,
> > change the prefix of the existing XFS_EOF_FLAGS_* flags to
> > XFS_ICWALK_FLAG_ and convert all the existing users.  This adds a degree
> > of interface separation between the ioctl definitions and the incore
> > parameters.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_file.c   |    4 ++--
> >  fs/xfs/xfs_icache.c |   40 ++++++++++++++++++++--------------------
> >  fs/xfs/xfs_icache.h |   19 +++++++++++++++++--
> >  3 files changed, 39 insertions(+), 24 deletions(-)
> 
> .....
> 
> > diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> > index 191620a069af..2f4a27a3109c 100644
> > --- a/fs/xfs/xfs_icache.h
> > +++ b/fs/xfs/xfs_icache.h
> > @@ -18,6 +18,21 @@ struct xfs_eofblocks {
> >  	int		icw_scan_limit;
> >  };
> >  
> > +/* Flags that we borrowed from struct xfs_fs_eofblocks */
> 
> "Flags that reflect xfs_fs_eofblocks functionality"

Changed.

> > +#define XFS_ICWALK_FLAG_SYNC		(XFS_EOF_FLAGS_SYNC)
> > +#define XFS_ICWALK_FLAG_UID		(XFS_EOF_FLAGS_UID)
> > +#define XFS_ICWALK_FLAG_GID		(XFS_EOF_FLAGS_GID)
> > +#define XFS_ICWALK_FLAG_PRID		(XFS_EOF_FLAGS_PRID)
> > +#define XFS_ICWALK_FLAG_MINFILESIZE	(XFS_EOF_FLAGS_MINFILESIZE)
> > +#define XFS_ICWALK_FLAG_UNION		(XFS_EOF_FLAGS_UNION)
> 
> Do these internal flags need to have the same values as the user
> API?

Not necessarily.  Given your comments in the next patch, I'll give each
an independent definition, hide FLAG_UNION inside xfs_icache.c, and make
xfs_fs_eofblocks_from_user more careful about converting flags values.

--D

> 
> Otherwise OK.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
