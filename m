Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51788 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbeEBQ7S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 12:59:18 -0400
Date: Wed, 2 May 2018 09:58:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/13] xfs: remove xfs_qm_dqread flags argument
Message-ID: <20180502165856.GX4127@magnolia>
References: <152506698177.21553.13500862866416804148.stgit@magnolia>
 <152506705098.21553.6894396720813018127.stgit@magnolia>
 <20180502163431.GB27020@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502163431.GB27020@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

On Wed, May 02, 2018 at 06:34:31PM +0200, Christoph Hellwig wrote:
> On Sun, Apr 29, 2018 at 10:44:11PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move the _qm_dqread functionality to _qm_dqensure, then remove the flags
> > argument from xfs_qm_dqread since the only DQALLOC users were internal
> > to xfs_dquot.c anyway.
> 
> I really see no point in doing the wrapper.  I'd much rather keep
> xfs_qm_dqread with a the additional argument, be that a flags value
> or a bool.  For example the same patch with the new xfs_dquot_setup
> kept as xfs_qm_dqread and everyone calling it with an additional
> false argument would seem much nicer to me.

I'm trying to avoid having a can_alloc argument for the exported _dqread
interface because none of the callers outside of xfs_dquot.c set it to
true.

Later on, in online repair I'll need some kind of interface to allocate
and get a dquot with a given transaction, but we can argue about that
when we get there.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
