Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52616 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751670AbdEVXJv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 May 2017 19:09:51 -0400
Date: Tue, 23 May 2017 01:09:46 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Shutdown filesystem when a thin pool become full
Message-ID: <20170522230946.s3sdg4gd73oj7r5u@eorzea.usersys.redhat.com>
References: <c25a8ccc-f143-989d-3d49-3fe8753aa6f7@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c25a8ccc-f143-989d-3d49-3fe8753aa6f7@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

Hi,

On Mon, May 22, 2017 at 04:25:37PM +0200, Gionatan Danti wrote:
> Hi all,
> I have a question regarding how to automatically shutdown (or put in
> read-only mode) an XFS filesystem which reside on a full thin pool.
> 

If you want that XFS shut down when it hits an error, you can configure it
through sysfs in:

/sys/fs/xfs/<dev>/error/

directory.

You can find detailed info in Documentation/filesystems/xfs.txt (from linux
source).

Although, I should say this is a bad idea. A full thin pool will return an
ENOSPC error to the filesystem, and, the filesystem should act accordingly.

Would you want the filesystem to shut down because it hit an ENOSPC, or report
to the user and let him/her to take the appropriate action, like freeing space
or increasing the dm-thin pool size?

> Background info: when a thin pool become full, it will deny any new
> unallocated writes, but will continue to allow writes to already-allocated
> storage chunks. So, it behave as a badly damaged disk, where some places can
> be written, but others throw an error.
> 

The behavior really depends on several configurations, including how dm-thin
will deal with ENOSPC situations, dm-thin can be configured to queue new
incoming IOs, fail the IO, etc, but, even in a full disk situation, you can
still rewrite data, so this behavior doesn't change much from what would happen
if you fill up a regular block device, XFS will try to allocate a new block, the
block device returns an ENOSPC and XFS acts accordingly.

> Playing with dmsetup table it is possible to deny *all* I/O to the volume,
> but it require careful monitor and a sensible script to do the right thing
> (tm).
> 
> From my testing, it happear that XFS will shutdown itself when a metadata
> write fails, however, failed *data* update will continue without triggering
> any filesystem response. Is this by design? Can I do something about that?
> 

What exactly do you mean by failed data update? As long as you don't need to
allocate any new block either for data of metadata, you should be able to rewrite
data normally if the device is full.

How dm-thin and XFS will work together, really depends on how you configure both
of them. XFS has a configuration system that you can use to set how it will
behave in some error situations according to your preferences, it can be set to
retry the writes for a specific amount of time, or simply fail immediately and
shut down the filesystem.


Worth to mention though, there is a bug that might be triggered when you
overcommit the space (creates a virtual device larger than the real physical
space), it's not too easy to trigger it though, and the fix is already WIP.



Cheers.

-- 
Carlos
