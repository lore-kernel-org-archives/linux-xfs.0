Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54830 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750708AbdAXOCs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 09:02:48 -0500
Date: Tue, 24 Jan 2017 15:02:47 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: use per-AG reservations for the finobt
Message-ID: <20170124140247.GA26149@lst.de>
References: <1485194742-23185-1-git-send-email-hch@lst.de> <20170123192847.GM12985@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170123192847.GM12985@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Jan 23, 2017 at 11:28:47AM -0800, Darrick J. Wong wrote:
> I also want to warn more loudly about AGs that don't actually have
> enough space to handle the reservation.

> > +			xfs_warn(mp,
> > +"Per-AG reservation for finobt failed.  File System may run out of space.\n");
> > +			mp->m_inotbt_nores = true;
> > +		}

Any suggestion for a better warning than this one?  Except for this
bit I'm ready to resend the series.
