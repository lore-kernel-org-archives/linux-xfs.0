Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:47250 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726538AbfEaX26 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 May 2019 19:28:58 -0400
Date: Sat, 1 Jun 2019 09:28:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC][PATCH] link.2: AT_ATOMIC_DATA and AT_ATOMIC_METADATA
Message-ID: <20190531232852.GG29573@dread.disaster.area>
References: <20190527172655.9287-1-amir73il@gmail.com>
 <20190528202659.GA12412@mit.edu>
 <CAOQ4uxgo5jmwQbLAKQre9=7pLQw=CwMgDaWPaJxi-5NGnPEVPQ@mail.gmail.com>
 <CAOQ4uxgj94WR82iHE4PDGSD0UDxG5sCtr+Sv+t1sOHHmnXFYzQ@mail.gmail.com>
 <20190531164136.GA3066@mit.edu>
 <20190531224549.GF29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531224549.GF29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>, Chris Mason <clm@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>

On Sat, Jun 01, 2019 at 08:45:49AM +1000, Dave Chinner wrote:
> Given that we can already use AIO to provide this sort of ordering,
> and AIO is vastly faster than synchronous IO, I don't see any point
> in adding complex barrier interfaces that can be /easily implemented
> in userspace/ using existing AIO primitives. You should start
> thinking about expanding libaio with stuff like
> "link_after_fdatasync()" and suddenly the whole problem of
> filesystem data vs metadata ordering goes away because the
> application directly controls all ordering without blocking and
> doesn't need to care what the filesystem under it does....

And let me point out that this is also how userspace can do an
efficient atomic rename - rename_after_fdatasync(). i.e. on
completion of the AIO_FSYNC, run the rename. This guarantees that
the application will see either the old file of the complete new
file, and it *doesn't have to wait for the operation to complete*.
Once it is in flight, the file will contain the old data until some
point in the near future when will it contain the new data....

Seriously, sit down and work out all the "atomic" data vs metadata
behaviours you want, and then tell me how many of them cannot be
implemented as "AIO_FSYNC w/ completion callback function" in
userspace. This mechanism /guarantees ordering/ at the application
level, the application does not block waiting for these data
integrity operations to complete, and you don't need any new kernel
side functionality to implement this.

Fundamentally, the assertion that disk cache flushes are not what
causes fsync "to be slow" is incorrect. It's the synchronous
"waiting for IO completion" that makes fsync "slow". AIO_FSYNC
avoids needing to wait for IO completion, allowing the application
to do useful work (like issue more DI ops) while data integrity
operations are in flight. At this point, fsync is no longer a "slow"
operation - it's just another background async data flush operation
like the BDI flusher thread...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
