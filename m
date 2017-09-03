Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33531 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbdICI4D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 04:56:03 -0400
Date: Sun, 3 Sep 2017 01:56:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/3] XFS real-time device tweaks
Message-ID: <20170903085602.GF32385@infradead.org>
References: <20170902224145.1291030-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170902224145.1291030-1-rwareing@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, darrick.wong@oracle.com

On Sat, Sep 02, 2017 at 03:41:42PM -0700, Richard Wareing wrote:
> - Replaced rtdefault with rtdisable, this yields similar operational
> benefits when combined with the existing mkfs time setting of the inheritance
> flag on the root directory.  Allows temporary disabling of real-time allocation
> without having to walk entire FS to remove flags (which could be time consuming).
> I still don't think it's super obvious to an admin the real-time flag was put
> there at mkfs time (vs. rtdefault being in mount flags), but this gets me
> half of what I'm after.

I still don't understand this option.  What is the use case of
dynamically switching on/off these default to the rt device?

> - rtfallocmin no changes, need to think more about this.  Still a pretty big
> fan of this option for reasons already stated; at least until a more elegant
> solution such as preferred AGs (we'd need a tunable size for the "preferred"
> AG, since our SSD partitions are a fraction of the size of a normal AG) can 
> be implemented.  The only other idea I have is to make a new ioctl e.g. 
> "norealtime", which causes the RT bits to stay cleared regardless of 
> inheritance bits on the containing directory.  This would allowing the 
> "steering" of files to the data device (e.g. SSD); this is probably a safer 
> design than defaulting to SSD and steering to the HDD via the realtime ioctl.  

Jens just added a nice new fcntl to declare the life time of write
streams (and in theory can add other I/O hints).

How about a a mount option that moves all I/O with a given hint
to the RT device?  E.g. rt=longlife would direct I/O on a file
with an rw hint of RWH_WRITE_LIFE_LONG or RWH_WRITE_LIFE_EXTREME to the
RT subvolume as long as there aren't any previous extents.
