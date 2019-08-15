Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55388 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730150AbfHOHNU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 03:13:20 -0400
Date: Thu, 15 Aug 2019 00:13:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 01/18] xfs: compat_ioctl: use compat_ptr()
Message-ID: <20190815071314.GA6960@infradead.org>
References: <20190814204259.120942-1-arnd@arndb.de>
 <20190814204259.120942-2-arnd@arndb.de>
 <20190814213753.GP6129@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814213753.GP6129@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Allison Collins <allison.henderson@oracle.com>, Nick Bowler <nbowler@draconx.ca>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <dchinner@redhat.com>

On Thu, Aug 15, 2019 at 07:37:53AM +1000, Dave Chinner wrote:
> > @@ -576,7 +576,7 @@ xfs_file_compat_ioctl(
> >  	case XFS_IOC_SCRUB_METADATA:
> >  	case XFS_IOC_BULKSTAT:
> >  	case XFS_IOC_INUMBERS:
> > -		return xfs_file_ioctl(filp, cmd, p);
> > +		return xfs_file_ioctl(filp, cmd, (unsigned long)arg);
> 
> I don't really like having to sprinkle special casts through the
> code because of this.

True.  But the proper fix is to not do the indirection through
xfs_file_ioctl but instead to call xfs_ioc_scrub_metadata,
xfs_ioc_bulkstat, etc directly which all take a void __user
arguments already.
