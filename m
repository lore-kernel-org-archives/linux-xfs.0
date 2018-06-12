Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:13606 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934418AbeFLWkb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jun 2018 18:40:31 -0400
Date: Wed, 13 Jun 2018 08:40:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bug report: kernel hangs when mounting a crafted xfs image
Message-ID: <20180612224028.GD10363@dastard>
References: <5B6AC96A-7049-48D7-82A1-4AB42322D38B@gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B6AC96A-7049-48D7-82A1-4AB42322D38B@gatech.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Xu, Wen" <wen.xu@gatech.edu>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Mon, Jun 11, 2018 at 07:36:48PM +0000, Xu, Wen wrote:
> When mounting a crafted xfs v4 image, the kernel hangs and never returns for mount operation. Suspect potential deadlock in log recovery exists. Not sure it is considered as a bug or not.
> 
> - Reproduce (on 4.17 upstream kernel)
> # mkdir mnt
> # mount -t xfs 0.img mnt
> 
> The image file (0.img.zip) is available here: https://bugzilla.kernel.org/attachment.cgi?id=276475

So it's a filesystem with a log that has bit corruptions in it's log
record headers, and log CRCs are turned off. All kernels since late
2012 have CRC'd log records for both v4 and v5 filesystems.  Hence
any remotely recent kernel faced wih bit errors in the journal are
going to behave differently - corruption warnings will be issued
first, and while v4 filesystems will continue to try to mount, a v5
filesystem will refuse to mount. And kernels old enough not to CRC
log records are unlikely to ever get bug fixes for maliciously
corrupted log records.

As such, I'm going to consider this a low priority right now.
Protecting log recovery against anything more than random bit errors
is a fairly major undertaking, and not something I plan on doing
in the near term...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
