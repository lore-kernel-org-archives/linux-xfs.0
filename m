Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46442 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfDBW0z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Apr 2019 18:26:55 -0400
Date: Tue, 2 Apr 2019 15:22:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] bootfs: simple bootloader filesystem
Message-ID: <20190402222244.GH5147@magnolia>
References: <20190401070001.GJ1173@magnolia>
 <20190401214632.GS26298@dastard>
 <20190402045519.GK1173@magnolia>
 <E2E8A5E4-D174-4E90-8D8F-F1D69E98F20E@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2E8A5E4-D174-4E90-8D8F-F1D69E98F20E@dilger.ca>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Dilger <adilger@dilger.ca>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Tue, Apr 02, 2019 at 03:52:59PM -0600, Andreas Dilger wrote:
> On Apr 1, 2019, at 10:55 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > On Tue, Apr 02, 2019 at 08:46:32AM +1100, Dave Chinner wrote:
> >> On Mon, Apr 01, 2019 at 12:00:01AM -0700, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <djwong@kernel.org>
> >>> 
> >>> Does your computer use a bootloader which arrogantly declares that it can
> >>> read boot files off a filesystem but isn't sophisticated enough even to
> >>> recognize when that filesystem needs journal recovery?
> >>> 
> >>> Does your system software deployment program foolishly omit system calls
> >>> to flush newly unwrapped packages to disk?  Do you sometimes wonder if
> >>> they've forgotten that old maxim, "wait for the disk drive light to turn
> >>> off /before/ you power down"?
> >>> 
> >>> Are your computer operators aggressively derpy?  Do they have a habit of
> >>> leaving disk cables on the floor so they can trip over them twenty times
> >>> a day?  Does this leave you with sad files full of zeroes?
> >>> 
> >>> If so, bootfs is for you!  This new filesystem type uses journalling to
> >>> ensure metadata integrity, but forces all writes and directory tree
> >>> updates to be synchronous, fsyncs files on close, and checkpoints its
> >>> journal whenever a synchronization event happens.  Some allege this is
> >>> very slow, but I've been able to max out the iops on both of my double
> >>> height floppy drives!  In a power-cycling stress test, I found that the
> >>> switch broke off in my hand before I lost any data.  This concept may
> >>> sound terrible, but like any good crutch, it _is_ made of wood!
> >>> 
> >>> Singed-off-by: Darrick J. Wong <djwong@kernel.org>
> >>  ^^^^^^^^^^
> >> 
> >> Ooooo - such a hot topic! Finally bootfs is more than just
> >> we-really-should-do-this conference talk!
> >> 
> >> Looks good to me - with this we can finally move on from LILO....
> > 
> > When Ted is done laughing, I really would like to consider something
> > like this to solve the problem of grub-style bootloaders requiring a
> > lease on the blocks underneath a file with a term exceeding that of the
> > running kernel.
> > 
> > We can probably skip the harsh synchronous writes in favor of fsync on
> > close, but we would need to keep the critical component of checkpointing
> > the journal on fsync and syncfs.
> 
> Wouldn't it be enough if Grub marked the file IMMUTABLE so that it didn't
> get remapped/rewritten?  The RPM pre/post kernel update scripts already
> have hooks to rerun grub and update /etc/grub.conf, so they should also
> be able to handle set/clear of the immutable flag during upgrade.

It would not, because the fundamental problem (with grub) is that it
stumbles if the log hasn't been checkpointed.  The transaction to add
the immutable flag will just end up pending in the log like any other
metadata change, because that doesn't force a log checkpoint.

(Unless you're suggesting that adding IMMUTABLE also checkpoint the log,
which would be a lot of disk writing work...)

--D

> Cheers, Andreas
> 
> 
> 
> 
> 
