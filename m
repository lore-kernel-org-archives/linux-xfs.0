Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60688 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751794AbeEGOio (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 May 2018 10:38:44 -0400
Date: Mon, 7 May 2018 16:41:59 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/13] xfs: remove xfs_qm_dqread flags argument
Message-ID: <20180507144159.GA30951@lst.de>
References: <152506698177.21553.13500862866416804148.stgit@magnolia> <152506705098.21553.6894396720813018127.stgit@magnolia> <20180502163431.GB27020@lst.de> <20180502165856.GX4127@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502165856.GX4127@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, bfoster@redhat.com

On Wed, May 02, 2018 at 09:58:56AM -0700, Darrick J. Wong wrote:
> > I really see no point in doing the wrapper.  I'd much rather keep
> > xfs_qm_dqread with a the additional argument, be that a flags value
> > or a bool.  For example the same patch with the new xfs_dquot_setup
> > kept as xfs_qm_dqread and everyone calling it with an additional
> > false argument would seem much nicer to me.
> 
> I'm trying to avoid having a can_alloc argument for the exported _dqread
> interface because none of the callers outside of xfs_dquot.c set it to
> true.

That's not really a good reason on its own..
