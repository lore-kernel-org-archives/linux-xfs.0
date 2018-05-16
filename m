Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:52019 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751402AbeEPAvm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 20:51:42 -0400
Date: Wed, 16 May 2018 10:51:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V3] test online label ioctl
Message-ID: <20180516005139.GI10363@dastard>
References: <2a743318-585d-9eb1-5430-2b07246348ab@redhat.com>
 <d65893a4-c6d8-1d85-4650-e63d04e8366a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d65893a4-c6d8-1d85-4650-e63d04e8366a@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>

On Tue, May 15, 2018 at 10:22:37AM -0500, Eric Sandeen wrote:
> This tests the online label ioctl that btrfs has, which has been
> recently proposed for XFS.
> 
> To run, it requires an updated xfs_io with the label command and a
> filesystem that supports it
> 
> A slight change here to _require_xfs_io_command as well, so that tests
> which simply fail with "Inappropriate ioctl" can be caught in the
> common case.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> (urgh send as proper new thread, sorry)
> 
> This passes on btrfs, _notruns on xfs/ext4 of yore, and passes
> on xfs w/ my online label patchset (as long as xfs_io has the new
> capability)
> 
> V2: Add a max label length helper
>     Set the proper btrfs max label length o_O oops
>     Filter trailing whitespace from blkid output
> 
> V3: lowercase local vars, simplify max label len function

Looks good now, but I wondered about one thing the test doesn't
cover: can you clear the label by setting it to a null string?
i.e you check max length bounds, but don't check empty string
behaviour...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
