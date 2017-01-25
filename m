Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36021 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751367AbdAYJNx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jan 2017 04:13:53 -0500
Date: Wed, 25 Jan 2017 10:13:51 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: use per-AG reservations for the finobt
Message-ID: <20170125091351.GA16307@lst.de>
References: <1485288980-17075-1-git-send-email-hch@lst.de> <1485288980-17075-3-git-send-email-hch@lst.de> <20170124204257.GB5726@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124204257.GB5726@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, bfoster@redhat.com, linux-xfs@vger.kernel.org

On Tue, Jan 24, 2017 at 12:42:57PM -0800, Darrick J. Wong wrote:
> > +		if (error) {
> > +			/*
> > +			 * Because we didn't have per-AG reservations when the
> > +			 * finobt feature was added we might not ne able to
> > +			 * reservere all needed blocks.  Warn and fall back to
> 
> "...might not be able to reserve all..."

Fixed.

> So if __xfs_ag_resv_init() returns ENOSPC, we don't actually halt the
> mount attempt, which means that we can start operating with
> mp->m_inotbt_nores = false if there's not even enough space for the
> refcountbt-only reservation.  In theory this is impossible, but I think
> we'd be in a better defensive position by moving this to before the
> __xfs_ag_resv_init call.

Ok.

> >  		xfs_agnumber_t agno, struct xfs_buf **bpp);
> >  
> > -
> >  #endif	/* __XFS_IALLOC_H__ */
> 
> Unnecessary change?

Fixed.
