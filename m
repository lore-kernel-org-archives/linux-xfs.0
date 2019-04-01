Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:47446 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725889AbfDAVqg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Apr 2019 17:46:36 -0400
Date: Tue, 2 Apr 2019 08:46:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] bootfs: simple bootloader filesystem
Message-ID: <20190401214632.GS26298@dastard>
References: <20190401070001.GJ1173@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190401070001.GJ1173@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Mon, Apr 01, 2019 at 12:00:01AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Does your computer use a bootloader which arrogantly declares that it can
> read boot files off a filesystem but isn't sophisticated enough even to
> recognize when that filesystem needs journal recovery?
> 
> Does your system software deployment program foolishly omit system calls
> to flush newly unwrapped packages to disk?  Do you sometimes wonder if
> they've forgotten that old maxim, "wait for the disk drive light to turn
> off /before/ you power down"?
> 
> Are your computer operators aggressively derpy?  Do they have a habit of
> leaving disk cables on the floor so they can trip over them twenty times
> a day?  Does this leave you with sad files full of zeroes?
> 
> If so, bootfs is for you!  This new filesystem type uses journalling to
> ensure metadata integrity, but forces all writes and directory tree
> updates to be synchronous, fsyncs files on close, and checkpoints its
> journal whenever a synchronization event happens.  Some allege this is
> very slow, but I've been able to max out the iops on both of my double
> height floppy drives!  In a power-cycling stress test, I found that the
> switch broke off in my hand before I lost any data.  This concept may
> sound terrible, but like any good crutch, it _is_ made of wood!
> 
> Singed-off-by: Darrick J. Wong <djwong@kernel.org>
  ^^^^^^^^^^

Ooooo - such a hot topic! Finally bootfs is more than just
we-really-should-do-this conference talk!

Looks good to me - with this we can finally move on from LILO....

Acked-by: Dave Chinner <david@fromorbit.com>

FWIW, Should this have a cc: stable@kernel.org tag on
it so it gets out into distro-world ASAP?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
