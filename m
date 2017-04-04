Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:39448 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932232AbdDDRxj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Apr 2017 13:53:39 -0400
Date: Tue, 4 Apr 2017 13:53:38 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Message-ID: <20170404175338.GB14303@fieldses.org>
References: <20170321183006.GD17872@fieldses.org>
 <1490122013.2593.1.camel@redhat.com>
 <20170329111507.GA18467@quack2.suse.cz>
 <1490810071.2678.6.camel@redhat.com>
 <20170330064724.GA21542@quack2.suse.cz>
 <1490872308.2694.1.camel@redhat.com>
 <20170330161231.GA9824@fieldses.org>
 <20170401230526.GW23007@dastard>
 <20170403140055.GF15168@quack2.suse.cz>
 <20170404123414.GA23007@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170404123414.GA23007@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Apr 04, 2017 at 10:34:14PM +1000, Dave Chinner wrote:
> On Mon, Apr 03, 2017 at 04:00:55PM +0200, Jan Kara wrote:
> > What filesystems can or cannot easily do obviously differs. Ext4 has a
> > recovery flag set in superblock on RW mount/remount and cleared on
> > umount/RO remount.
> 
> Even this doesn't help. A recent bug that was reported to the XFS
> list - turns out that systemd can't remount-ro the root
> filesystem sucessfully on shutdown because there are open write fds
> on the root filesystem when it attempts the remount. So it just
> reboots without a remount-ro.

I'd certainly rather not invalidate caches on *every* boot.

On the other hand, if the only cases involve the root filesystem, then
from the point of view of NFS, we probably don't care much.

> > This flag being set on mount would imply incrementing the crash
> > counter. It should be pretty easy for each filesystem to implement
> > such flag and the counter but I agree it requires an on-disk
> > format change.
> 
> Yup, anything we want that is persistent and consistent across
> filesystems will need on-disk format changes. Hence we need a solid
> specification first, not to mention tests to validate correct
> behaviour across all filesystems in xfstests...

For xfstests we'll need a way to get i_version (patch it into statx, I
guess?).  Ideally we'd have a way to test behavior across crashes too,
any advice there?

--b.
