Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:29967 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750782AbeEREDn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 May 2018 00:03:43 -0400
Date: Fri, 18 May 2018 14:03:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V4] test online label ioctl
Message-ID: <20180518040341.GK23861@dastard>
References: <2a743318-585d-9eb1-5430-2b07246348ab@redhat.com>
 <f912f4ae-20b1-d19e-3b38-317b9ef46a6d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f912f4ae-20b1-d19e-3b38-317b9ef46a6d@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>

On Thu, May 17, 2018 at 10:28:26AM -0500, Eric Sandeen wrote:
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
> Now with new and improved sequential V4 versioning!

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
