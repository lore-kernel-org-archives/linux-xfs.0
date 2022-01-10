Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C4A6C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 19:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245149AbiAJT7L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 14:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243444AbiAJT7I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 14:59:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76424C06173F
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 11:59:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F8E3B817D2
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 19:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E40C36AE9;
        Mon, 10 Jan 2022 19:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641844746;
        bh=E0HE9WwGHlWoDwrARTmMUiPw2q2ACe9tTuQg7iS5PYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=he+nk0uf/cQuNxbdX/bFlP49Q/ax+0qdyeoXRhhSUpA0w3ATGC9rhpr0IkkpiZBOq
         E++y2R4DkBiiY1RMn10kS4P/keNHieCi0lXkbD4X6Bra+ltYvZnWZwJZnWtg05bgde
         7zyFDO0szrlDxLPuAC0wnGUp8K6EZAMqJfZBn1ZceL0CctRqvZ8x9Gq4VzMpMUDxWF
         NgXC2RVMWPpOtDdMaPb2idSS3eXwzvzZ9YBpF2wBi5FWIwCKdo03Djv3ZjI1jGYGWF
         NxALvfppbKPNHeUBxTKNJQuxtN+VWn3y+4vqh1QrpN7f1Uy4xrWGayRfWsf0mzTqrg
         2IoaqsfAwOjag==
Date:   Mon, 10 Jan 2022 11:59:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <esandeen@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: hide the XFS_IOC_{ALLOC,FREE}SP* definitions
Message-ID: <20220110195905.GZ656707@magnolia>
References: <20220110174827.GW656707@magnolia>
 <20220110175154.GX656707@magnolia>
 <ea019905-ebbe-9082-0399-7ea0e6be553c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea019905-ebbe-9082-0399-7ea0e6be553c@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 10, 2022 at 12:39:59PM -0600, Eric Sandeen wrote:
> On 1/10/22 11:51 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Now that we've made these ioctls defunct, move them from xfs_fs.h to
> > xfs_ioctl.c, which effectively removes them from the publicly supported
> > ioctl interfaces for XFS.
> 
> You pointed out on IRC that you need to hide the 32-bit/compat ones too,
> so I'll wait for a V2 on that?  (XFS_IOC_ALLOCSP_32 & friends).

Will send.

--D

> But the approach seems fine.
> 
> Thanks,
> -Eric
> 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >   fs/xfs/libxfs/xfs_fs.h |    8 ++++----
> >   fs/xfs/xfs_ioctl.c     |    9 +++++++++
> >   2 files changed, 13 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index c43877c8a279..49c0e583d6bb 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -781,13 +781,13 @@ struct xfs_scrub_metadata {
> >    * For 'documentation' purposed more than anything else,
> >    * the "cmd #" field reflects the IRIX fcntl number.
> >    */
> > -#define XFS_IOC_ALLOCSP		_IOW ('X', 10, struct xfs_flock64)
> > -#define XFS_IOC_FREESP		_IOW ('X', 11, struct xfs_flock64)
> > +/*	XFS_IOC_ALLOCSP ------- deprecated 10	 */
> > +/*	XFS_IOC_FREESP -------- deprecated 11	 */
> >   #define XFS_IOC_DIOINFO		_IOR ('X', 30, struct dioattr)
> >   #define XFS_IOC_FSGETXATTR	FS_IOC_FSGETXATTR
> >   #define XFS_IOC_FSSETXATTR	FS_IOC_FSSETXATTR
> > -#define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
> > -#define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
> > +/*	XFS_IOC_ALLOCSP64 ----- deprecated 36	 */
> > +/*	XFS_IOC_FREESP64 ------ deprecated 37	 */
> >   #define XFS_IOC_GETBMAP		_IOWR('X', 38, struct getbmap)
> >   #define XFS_IOC_FSSETDM		_IOW ('X', 39, struct fsdmidata)
> >   #define XFS_IOC_RESVSP		_IOW ('X', 40, struct xfs_flock64)
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 38b2a1e881a6..15ec3d4a1516 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1854,6 +1854,15 @@ xfs_fs_eofblocks_from_user(
> >   	return 0;
> >   }
> > +/*
> > + * These long-unused ioctls were removed from the official ioctl API in 5.17,
> > + * but retain these definitions so that we can log warnings about them.
> > + */
> > +#define XFS_IOC_ALLOCSP		_IOW ('X', 10, struct xfs_flock64)
> > +#define XFS_IOC_FREESP		_IOW ('X', 11, struct xfs_flock64)
> > +#define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
> > +#define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
> > +
> >   /*
> >    * Note: some of the ioctl's return positive numbers as a
> >    * byte count indicating success, such as readlink_by_handle.
> > 
> 
