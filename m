Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E62D8C47097
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 21:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF984613F8
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 21:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhFCVTs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 17:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230081AbhFCVTr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jun 2021 17:19:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A200613D8;
        Thu,  3 Jun 2021 21:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622755082;
        bh=SCq0BRIKyg3kWqhmYgEkY7DOcjLpgFg4qYUVUgOIENY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WatQam3qvMVCwjRG9ZVIBDANxf9Ak5c6oA7eMYPXA9tJvO5cG5R0gM1fFMgl4u0n2
         jpmDY3fHOS5u2yNfucdyo1pOPkPs9ad0NAN8Bpmhb0PiUz4fsCaBh7XXhX/Gw/JOcG
         2FofmACgsaPJY/jeLsjtafeR/lYcTdfHx1S4HeDvBzyx/7g3I/CaOe7iXbAnRqACeW
         3QikXQE7QIx8OgENH9qKX694agXYulTbXxEgQCeramUbQr55PTedbrHUz6RsxYm7dk
         xJt1cFZpCljccrLhr6VzDtKF8wTdf25VICwsC4rBCSyBb0caoiJ0O0dZ0/AIwNPxR0
         e+Tmu4TNP7Bpg==
Date:   Thu, 3 Jun 2021 14:18:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: rename struct xfs_eofblocks to xfs_icwalk
Message-ID: <20210603211802.GD26380@locust>
References: <162268997425.2724263.18220495607834735216.stgit@locust>
 <162268998538.2724263.16964371295618826505.stgit@locust>
 <20210603045531.GS664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603045531.GS664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 03, 2021 at 02:55:31PM +1000, Dave Chinner wrote:
> On Wed, Jun 02, 2021 at 08:13:05PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The xfs_eofblocks structure is no longer well-named -- nowadays it
> > provides optional filtering criteria to any walk of the incore inode
> > cache.  Only one of the cache walk goals has anything to do with
> > clearing of speculative post-EOF preallocations, so change the name to
> > be more appropriate.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_file.c   |    6 +-
> >  fs/xfs/xfs_icache.c |  154 ++++++++++++++++++++++++++-------------------------
> >  fs/xfs/xfs_icache.h |   14 ++---
> >  fs/xfs/xfs_ioctl.c  |   30 +++++-----
> >  fs/xfs/xfs_trace.h  |   36 ++++++------
> >  5 files changed, 120 insertions(+), 120 deletions(-)
> .....
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 1fe4c1fc0aea..a0fcadb1a04f 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1875,7 +1875,7 @@ xfs_ioc_setlabel(
> >  static inline int
> >  xfs_fs_eofblocks_from_user(
> >  	struct xfs_fs_eofblocks		*src,
> > -	struct xfs_eofblocks		*dst)
> > +	struct xfs_icwalk		*dst)
> >  {
> >  	if (src->eof_version != XFS_EOFBLOCKS_VERSION)
> >  		return -EINVAL;
> > @@ -1887,21 +1887,21 @@ xfs_fs_eofblocks_from_user(
> >  	    memchr_inv(src->pad64, 0, sizeof(src->pad64)))
> >  		return -EINVAL;
> >  
> > -	dst->eof_flags = src->eof_flags;
> > -	dst->eof_prid = src->eof_prid;
> > -	dst->eof_min_file_size = src->eof_min_file_size;
> > +	dst->icw_flags = src->eof_flags;
> > +	dst->icw_prid = src->eof_prid;
> > +	dst->icw_min_file_size = src->eof_min_file_size;
> 
> Ah, ok, that's why the flags were encoded to have the same values as
> the user API - it's just a straight value copy of the field.
> 
> Hmmmm. What happens in future if we've added new internal flags and
> then add a new API flag and they overlap in value? That seems like
> a bit of landmine?

As mentioned in the previous reply, I'll separate them completely then.

	dst->icw_flags = 0;
	if (src->eof_flags & XFS_EOF_FLAGS_SYNC)
		dst->icw_flags |= XFS_ICWALK_FLAG_SYNC;
	if (src->eof_flags & XFS_EOF_FLAGS_UID)
		dst->icw_flags |= XFS_ICWALK_FLAG_UID;
	if (src->eof_flags & XFS_EOF_FLAGS_GID)
		dst->icw_flags |= XFS_ICWALK_FLAG_GID;
	if (src->eof_flags & XFS_EOF_FLAGS_PRID)
		dst->icw_flags |= XFS_ICWALK_FLAG_PRID;
	if (src->eof_flags & XFS_EOF_FLAGS_MINFILESIZE)
		dst->icw_flags |= XFS_ICWALK_FLAG_MINFILESIZE;

--D

> 
> Otherwise the change looks good.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
