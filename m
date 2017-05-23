Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41782 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752317AbdEWNYt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 May 2017 09:24:49 -0400
Subject: Re: Shutdown filesystem when a thin pool become full
References: <c25a8ccc-f143-989d-3d49-3fe8753aa6f7@assyoma.it>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8eb6b192-50fa-d283-3aa6-59bf75dde8b8@sandeen.net>
Date: Tue, 23 May 2017 08:24:47 -0500
MIME-Version: 1.0
In-Reply-To: <c25a8ccc-f143-989d-3d49-3fe8753aa6f7@assyoma.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>, linux-xfs@vger.kernel.org

On 5/22/17 9:25 AM, Gionatan Danti wrote:
> Hi all, I have a question regarding how to automatically shutdown (or
> put in read-only mode) an XFS filesystem which reside on a full thin
> pool.
> 
> Background info: when a thin pool become full, it will deny any new
> unallocated writes, but will continue to allow writes to
> already-allocated storage chunks. So, it behave as a badly damaged
> disk, where some places can be written, but others throw an error.
> 
> Playing with dmsetup table it is possible to deny *all* I/O to the
> volume, but it require careful monitor and a sensible script to do
> the right thing (tm).
> 
> From my testing, it happear that XFS will shutdown itself when a
> metadata write fails, however, failed *data* update will continue
> without triggering any filesystem response. Is this by design? Can I
> do something about that?

It is pretty much by design - keeping in mind that XFS predates the
general notion of thin storage by a decade or two.  ;)

In the big picture, xfs's shutdown behavior is there to preserve the
consistency of the filesystem - if metadata writes are failing,
continuing would likely lead to corruption.

If /data/ writes are failing, that's for the application to deal with.

Shutting down the filesystem for an unwritable data block is probably not
what people want to see, in general.

> As a side note, I perfectly understand that async writes should *not*
> put the filesystem in suspended state; however, I found this behavior
> for synchronized writes also.

I would expect that synchronous writes and/or things like fsync calls
would return errors if the underlying data IO fails.

As for your question about ENOSPC vs EIO, even though the storage may
return ENOSPC, I believe that gets turned into an EIO when it passes
through XFS to userspace.

Historically, ENOSPC meant that the filesystem itself has run out of
blocks, and EIO meant that the underlying device could not complete the
IO - so it's a matter of semantics, and I'm not sure anyone has
really settled on a consistent story with thin devices.

-Eric

> Thanks.
> 
