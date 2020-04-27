Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D92A4C54FCB
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 17:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEBCB2076A
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 17:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588008602;
	bh=ZdSG41fFUlbC/UHMat4zJ2C7QtQ3OkJpXWPhWLCwozw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Jrj3ULO9AR/KU+dLXRF5QombzypAVmTyM0EI/sHJFZdekfOHmONfdPAe2vIA3h8N5
	 gNRYM4X/VPKwPE0iOb1TqNZvokLVPv3iY8LJErlhcFIej2yVPi1t0sSGw3WIxzKaE5
	 x9QUWog885e3eXU/ObXsjoo1Kx766Zxiv6uSVIn0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgD0RaC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 13:30:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbgD0RaC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Apr 2020 13:30:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8224206D9;
        Mon, 27 Apr 2020 17:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588008601;
        bh=ZdSG41fFUlbC/UHMat4zJ2C7QtQ3OkJpXWPhWLCwozw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E6nTa2bR+ycpBp1H1A9OnuHkKwx/PwOvQkehou+5mBKQoMtScpAGilGmZhWaOHpcU
         iVNXFzB1eQL8jTiCLd3i9fzlbf3zEZRjI3nGvvDH9tyA+CFa+6VJXkI7r5l7C4XVFG
         DHRRgEW+jV01RgqTIg9PrtCSi3PQ+BOYJoZchWs8=
Date:   Mon, 27 Apr 2020 19:29:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Nishad Kamdar <nishadkamdar@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Use the correct style for SPDX License Identifier
Message-ID: <20200427172959.GB3936841@kroah.com>
References: <20200425133504.GA11354@nishad>
 <20200427155617.GY6749@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427155617.GY6749@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 08:56:18AM -0700, Darrick J. Wong wrote:
> On Sat, Apr 25, 2020 at 07:05:09PM +0530, Nishad Kamdar wrote:
> > This patch corrects the SPDX License Identifier style in
> > header files related to XFS File System support.
> > For C header files Documentation/process/license-rules.rst
> > mandates C-like comments (opposed to C source files where
> > C++ style should be used).
> > 
> > Changes made by using a script provided by Joe Perches here:
> > https://lkml.org/lkml/2019/2/7/46.
> > 
> > Suggested-by: Joe Perches <joe@perches.com>
> > Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
> > ---
> >  fs/xfs/kmem.h                      | 2 +-
> >  fs/xfs/libxfs/xfs_ag_resv.h        | 2 +-
> >  fs/xfs/libxfs/xfs_alloc.h          | 2 +-
> >  fs/xfs/libxfs/xfs_alloc_btree.h    | 2 +-
> >  fs/xfs/libxfs/xfs_attr.h           | 2 +-
> >  fs/xfs/libxfs/xfs_attr_leaf.h      | 2 +-
> >  fs/xfs/libxfs/xfs_attr_remote.h    | 2 +-
> >  fs/xfs/libxfs/xfs_attr_sf.h        | 2 +-
> >  fs/xfs/libxfs/xfs_bit.h            | 2 +-
> >  fs/xfs/libxfs/xfs_bmap.h           | 2 +-
> >  fs/xfs/libxfs/xfs_bmap_btree.h     | 2 +-
> >  fs/xfs/libxfs/xfs_btree.h          | 2 +-
> >  fs/xfs/libxfs/xfs_da_btree.h       | 2 +-
> >  fs/xfs/libxfs/xfs_da_format.h      | 2 +-
> >  fs/xfs/libxfs/xfs_defer.h          | 2 +-
> >  fs/xfs/libxfs/xfs_dir2.h           | 2 +-
> >  fs/xfs/libxfs/xfs_dir2_priv.h      | 2 +-
> >  fs/xfs/libxfs/xfs_errortag.h       | 2 +-
> >  fs/xfs/libxfs/xfs_format.h         | 2 +-
> >  fs/xfs/libxfs/xfs_fs.h             | 2 +-
> >  fs/xfs/libxfs/xfs_health.h         | 2 +-
> >  fs/xfs/libxfs/xfs_ialloc.h         | 2 +-
> >  fs/xfs/libxfs/xfs_ialloc_btree.h   | 2 +-
> >  fs/xfs/libxfs/xfs_inode_buf.h      | 2 +-
> >  fs/xfs/libxfs/xfs_inode_fork.h     | 2 +-
> >  fs/xfs/libxfs/xfs_log_format.h     | 2 +-
> >  fs/xfs/libxfs/xfs_log_recover.h    | 2 +-
> >  fs/xfs/libxfs/xfs_quota_defs.h     | 2 +-
> >  fs/xfs/libxfs/xfs_refcount.h       | 2 +-
> >  fs/xfs/libxfs/xfs_refcount_btree.h | 2 +-
> >  fs/xfs/libxfs/xfs_rmap.h           | 2 +-
> >  fs/xfs/libxfs/xfs_rmap_btree.h     | 2 +-
> >  fs/xfs/libxfs/xfs_sb.h             | 2 +-
> >  fs/xfs/libxfs/xfs_shared.h         | 2 +-
> >  fs/xfs/libxfs/xfs_trans_resv.h     | 2 +-
> >  fs/xfs/libxfs/xfs_trans_space.h    | 2 +-
> >  fs/xfs/libxfs/xfs_types.h          | 2 +-
> >  fs/xfs/mrlock.h                    | 2 +-
> >  fs/xfs/scrub/bitmap.h              | 2 +-
> >  fs/xfs/scrub/btree.h               | 2 +-
> >  fs/xfs/scrub/common.h              | 2 +-
> >  fs/xfs/scrub/dabtree.h             | 2 +-
> >  fs/xfs/scrub/health.h              | 2 +-
> >  fs/xfs/scrub/repair.h              | 2 +-
> >  fs/xfs/scrub/scrub.h               | 2 +-
> >  fs/xfs/scrub/trace.h               | 2 +-
> >  fs/xfs/scrub/xfs_scrub.h           | 2 +-
> >  fs/xfs/xfs.h                       | 2 +-
> >  fs/xfs/xfs_acl.h                   | 2 +-
> >  fs/xfs/xfs_aops.h                  | 2 +-
> >  fs/xfs/xfs_bmap_item.h             | 2 +-
> >  fs/xfs/xfs_bmap_util.h             | 2 +-
> >  fs/xfs/xfs_buf.h                   | 2 +-
> >  fs/xfs/xfs_buf_item.h              | 2 +-
> >  fs/xfs/xfs_dquot.h                 | 2 +-
> >  fs/xfs/xfs_dquot_item.h            | 2 +-
> >  fs/xfs/xfs_error.h                 | 2 +-
> >  fs/xfs/xfs_export.h                | 2 +-
> >  fs/xfs/xfs_extent_busy.h           | 2 +-
> >  fs/xfs/xfs_extfree_item.h          | 2 +-
> >  fs/xfs/xfs_filestream.h            | 2 +-
> >  fs/xfs/xfs_fsmap.h                 | 2 +-
> >  fs/xfs/xfs_fsops.h                 | 2 +-
> >  fs/xfs/xfs_icache.h                | 2 +-
> >  fs/xfs/xfs_icreate_item.h          | 2 +-
> >  fs/xfs/xfs_inode.h                 | 2 +-
> >  fs/xfs/xfs_inode_item.h            | 2 +-
> >  fs/xfs/xfs_ioctl.h                 | 2 +-
> >  fs/xfs/xfs_ioctl32.h               | 2 +-
> >  fs/xfs/xfs_iomap.h                 | 2 +-
> >  fs/xfs/xfs_iops.h                  | 2 +-
> >  fs/xfs/xfs_itable.h                | 2 +-
> >  fs/xfs/xfs_linux.h                 | 2 +-
> >  fs/xfs/xfs_log.h                   | 2 +-
> >  fs/xfs/xfs_log_priv.h              | 2 +-
> >  fs/xfs/xfs_mount.h                 | 2 +-
> >  fs/xfs/xfs_mru_cache.h             | 2 +-
> >  fs/xfs/xfs_ondisk.h                | 2 +-
> >  fs/xfs/xfs_qm.h                    | 2 +-
> >  fs/xfs/xfs_quota.h                 | 2 +-
> >  fs/xfs/xfs_refcount_item.h         | 2 +-
> >  fs/xfs/xfs_reflink.h               | 2 +-
> >  fs/xfs/xfs_rmap_item.h             | 2 +-
> >  fs/xfs/xfs_rtalloc.h               | 2 +-
> >  fs/xfs/xfs_stats.h                 | 2 +-
> >  fs/xfs/xfs_super.h                 | 2 +-
> >  fs/xfs/xfs_symlink.h               | 2 +-
> >  fs/xfs/xfs_sysctl.h                | 2 +-
> >  fs/xfs/xfs_sysfs.h                 | 2 +-
> >  fs/xfs/xfs_trace.h                 | 2 +-
> >  fs/xfs/xfs_trans.h                 | 2 +-
> >  fs/xfs/xfs_trans_priv.h            | 2 +-
> >  92 files changed, 92 insertions(+), 92 deletions(-)
> > 
> > diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> > index 6143117770e9..fc87ea9f6843 100644
> > --- a/fs/xfs/kmem.h
> > +++ b/fs/xfs/kmem.h
> > @@ -1,4 +1,4 @@
> > -// SPDX-License-Identifier: GPL-2.0
> > +/* SPDX-License-Identifier: GPL-2.0 */
> >  /*
> >   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
> >   * All Rights Reserved.
> > diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
> > index c0352edc8e41..f3fd0ee9a7f7 100644
> > --- a/fs/xfs/libxfs/xfs_ag_resv.h
> > +++ b/fs/xfs/libxfs/xfs_ag_resv.h
> > @@ -1,4 +1,4 @@
> > -// SPDX-License-Identifier: GPL-2.0+
> > +/* SPDX-License-Identifier: GPL-2.0+ */
> 
> I thought we were supposed to use 'GPL-2.0-or-newer' because 'GPL-2.0+'
> is deprecated in some newer version of the SPDX standard?
> 
> <shrug>

The kernel follows the "older" SPDX standard, but will accept either,
it's up to the author.  It is all documented in LICENSES/ if people
really want to make sure.

thanks,

greg k-h
