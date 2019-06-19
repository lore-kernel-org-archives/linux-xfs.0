Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39890 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbfFSBHf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 21:07:35 -0400
Date: Tue, 18 Jun 2019 18:07:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: move xfs_ino_geometry to xfs_mount.h
Message-ID: <20190619010704.GA5402@magnolia>
References: <20190618205935.GS5387@magnolia>
 <20190619004041.GA26375@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619004041.GA26375@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Wed, Jun 19, 2019 at 10:40:41AM +1000, Dave Chinner wrote:
> On Tue, Jun 18, 2019 at 01:59:36PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The inode geometry structure isn't related to ondisk format; it's
> > support for the mount structure.  Move it to xfs_mount.h.
> 
> That means we have to duplicate it in userspace - xfs_mount.h is not
> shared. I'd suggest that libxfs/xfs_shared.h would be a better place
> for it.

Well that will make the patch wayyy bigger since now every file has to
include xfs_shared.h (right now 26 of them do not)...

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
