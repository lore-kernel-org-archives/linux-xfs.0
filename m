Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46782 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752848AbeEHAEs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 20:04:48 -0400
Date: Mon, 7 May 2018 17:04:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/13] xfs: remove xfs_qm_dqread flags argument
Message-ID: <20180508000425.GY11261@magnolia>
References: <152506698177.21553.13500862866416804148.stgit@magnolia>
 <152506705098.21553.6894396720813018127.stgit@magnolia>
 <20180502163431.GB27020@lst.de>
 <20180502165856.GX4127@magnolia>
 <20180507144159.GA30951@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180507144159.GA30951@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

On Mon, May 07, 2018 at 04:41:59PM +0200, Christoph Hellwig wrote:
> On Wed, May 02, 2018 at 09:58:56AM -0700, Darrick J. Wong wrote:
> > > I really see no point in doing the wrapper.  I'd much rather keep
> > > xfs_qm_dqread with a the additional argument, be that a flags value
> > > or a bool.  For example the same patch with the new xfs_dquot_setup
> > > kept as xfs_qm_dqread and everyone calling it with an additional
> > > false argument would seem much nicer to me.
> > 
> > I'm trying to avoid having a can_alloc argument for the exported _dqread
> > interface because none of the callers outside of xfs_dquot.c set it to
> > true.
> 
> That's not really a good reason on its own..

Hm, I talked to Dave on IRC, and after some spelunking we unearthed that
the whole point of calling _dqread directly was to obtain an uncached
dquot that isn't linked into any lists/radix trees/caches/whatever.
That way if we end up doing quotacheck we won't have any dquots in
memory that are now garbage.

>From that perspective it's not as big of a jump to re-hide dqread and
add a _dqget_uncached that has a much better comment justifying why it's
there and who uses it...

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
