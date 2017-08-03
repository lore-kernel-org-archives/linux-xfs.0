Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:30712 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751599AbdHCWJa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 18:09:30 -0400
Date: Fri, 4 Aug 2017 08:09:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Intermittent zeroed pages with AIO+DIO+XFS
Message-ID: <20170803220922.GA21024@dastard>
References: <dac170a5-d11f-c8ce-3890-8b5629364c18@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dac170a5-d11f-c8ce-3890-8b5629364c18@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org, Glauber Costa <glauber@scylladb.com>, Raphael Carvalho <raphaelsc@scylladb.com>

On Thu, Aug 03, 2017 at 05:52:45PM +0300, Avi Kivity wrote:
> Hello,
> 

Hi Avi,

> I have an application that uses AIO+DIO to write data to a file on
> XFS. The writes use 128k buffers. Very rarely, I see aligned 4k
> blocks within the file that are zeroed. The blocks are not aligned
> to 128k boundary, just 4k. The buffers are allocated in anonymous
> memory, which is usually using transparent hugepages.  The files are
> fully allocated, not sparse (checked post-mortem).

Did you check that the extents are written? i.e. there aren't
sporadic 4k unwritten extents in the file? (xfs_bmap -vvp output)

If you turn off transparent huge pages, does the problem go
away?

What kernel version is this seen on? We've changed the XFS DIO
IO path implementation substantially in recent times....

> The writes are concurrent and adjacent. To avoid serialization, we
> ftruncate() the file to a larger size, then ftruncate() it back when
> we know its final size.

So it's not extending the file on the writes, so it shouldn't be
triggering EOF block zeroing. The only thing I can think of is
either the data contains zeros or there's an occasional unwritten
extent in the file.

> Does this trigger anything in anyone's mind?

Nope - do you have a reproducer you can share?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
