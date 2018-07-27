Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41776 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732097AbeG0Q3F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Jul 2018 12:29:05 -0400
Date: Fri, 27 Jul 2018 17:10:39 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/6] xfs: avoid COW fork extent lookups in writeback if
        the fork didn't change
Message-ID: <20180727151039.GA29982@lst.de>
References: <20180717232405.18511-1-hch@lst.de> <20180717232405.18511-7-hch@lst.de> <20180721232311.GA1691@dastard> <20180723074940.GA18816@lst.de> <20180724223523.GO4813@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180724223523.GO4813@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Tue, Jul 24, 2018 at 03:35:23PM -0700, Darrick J. Wong wrote:
> > mutex_unlock contains a barrier, and the sequence is a single register
> > read.  There is nothing holding a lock here would help us with.
> 
> Which mutex_unlock is that?

Actually an up_write (on i_lock), but the result is the same.

> I took a second look at the i_cowfp access
> and realized that we don't take ILOCK_SHARED until after the comparison.
> Writeback doesn't take any of the other inode locks AFAIK... so either
> there's some locking subtlety here that ought to be explained in a
> comment, or is this a bug waiting to happen?

What would you want the lock to protect?  As said above the if_seq
field itself doesn't need a lock, it can be read atomic because it
is a register or less.

And for the actual imap we don't have a lock anywhere in the writeback
code - as soon as we did the lookup or allocation we drop the i_lock
and keep using it.  That is generally fine because we only ever remove
extents from it after previously waiting for writeback and using
the iolock to prevent new writeback from being started.  The only new
bit with reflink support is that a valid data fork block mapping might
now be shadowed by a new reflink mapping, and that is exactly what the
sequence count protects against (instead of doing a lookup in the
cowfp and then instanctly dropping the lock before)
