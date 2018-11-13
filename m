Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:11668
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725783AbeKNIKS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Nov 2018 03:10:18 -0500
Date: Wed, 14 Nov 2018 09:10:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: file write that exceeds thin device capacity
Message-ID: <20181113221004.GT19305@dastard>
References: <18125274-1c2e-6171-a597-4e2ffb165162@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <18125274-1c2e-6171-a597-4e2ffb165162@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Todd Gill <tgill@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 13, 2018 at 02:57:18PM -0500, Todd Gill wrote:
> Hi,
> 
> This script creates a 1 TB thin device (device mapper)  backed by 1 GB
> of physical space.  The script then writes more than 1 GB via
> $BLOCK_SIZE files to XFS.  I'm testing to see if recovery can be
> automated.
> 
> https://paste.fedoraproject.org/paste/ropelNyOQWCjk3hfK0jltA
> 
> When the $BLOCK_SIZE passed to dd is 4k - dd gets an error on the file
> write that exceeds the physical capacity that backs the thin device.
> XFS doesn't indicate any problems.

user data write error.

> If I set the $BLOCK_SIZE to 32k - I see entries in the system log that
> indicate XFS loops retrying the writes.
> 
> Is that expected?  Is it just more likely to happen with larger block
> sizes?
> 
> I’m looking to understand how to recover when a thin device runs out of
> space under XFS.
> 
> Example system log entries:
> 
> [  +5.048997] XFS (dm-3): metadata I/O error: block 0xf0000
> ("xfs_buf_iodone_callback_error") error 28 numblks 32
> [  +1.376913] XFS: Failing async write: 1164 callbacks suppressed
> [  +0.000004] XFS (dm-3): Failing async write on buffer block 0xf0020.
> Retrying async write.

Filesystem Metadata write error. XFS is configured to retry them by
default. Failing this write will shut down the filesystem as it is a
corruption vector.

If you expand your thin device at this point, the
write will then succeed and the filesystem will continue to operate
normally.

If you configure your filesystem (through
/sys/fs/xfs/<dev>/error/...) to fail metadata writes on ENOSPC
errors, then it will shutdown the filesystem rather than wait for
the thinp device to be expanded.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
