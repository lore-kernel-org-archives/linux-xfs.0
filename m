Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23753 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdAXQsm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2017 11:48:42 -0500
Date: Tue, 24 Jan 2017 08:48:37 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: use per-AG reservations for the finobt
Message-ID: <20170124164837.GI4780@birch.djwong.org>
References: <1485194742-23185-1-git-send-email-hch@lst.de>
 <20170123192847.GM12985@birch.djwong.org>
 <20170124140247.GA26149@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124140247.GA26149@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 24, 2017 at 03:02:47PM +0100, Christoph Hellwig wrote:
> On Mon, Jan 23, 2017 at 11:28:47AM -0800, Darrick J. Wong wrote:
> > I also want to warn more loudly about AGs that don't actually have
> > enough space to handle the reservation.
> 
> > > +			xfs_warn(mp,
> > > +"Per-AG reservation for finobt failed.  File System may run out of space.\n");
> > > +			mp->m_inotbt_nores = true;
> > > +		}
> 
> Any suggestion for a better warning than this one?  Except for this
> bit I'm ready to resend the series.

I'd just print out:

"Per-AG reservation for AG ${agno} failed.  Filesystem may run out of space."

if any of the (now three) invocations of __xfs_ag_resv_init() returns
ENOSPC, since the AG is more than 98% full.  Some day, a sysadmin could
then use the fsmap data to identify which inodes are using the most
space in that AG and arrange to migrate/remove/etc the data to another
AG.

--D
