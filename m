Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:28987 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751344AbdIIXMT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Sep 2017 19:12:19 -0400
Date: Sun, 10 Sep 2017 09:12:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS and sector size on thin volumes
Message-ID: <20170909231215.GK17782@dastard>
References: <d95f09118ee6cb2fe0562ad35303715c@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d95f09118ee6cb2fe0562ad35303715c@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Sun, Sep 10, 2017 at 12:11:56AM +0200, Gionatan Danti wrote:
> Hi all,
> I noticed that, when using both LVM thin volumes and ZVOLs, mkfs.xfs
> default to using 512-byte sector size.
> 
> Would setting sector size to 4K be benefical for filesystem performance?

Probably not. And, worse, you open up the possibility of torn
"single sector" writes if the underlying device isn't a native 4k
sector device.

> From what I know, sector size only affect journal and metadata
> writes. So, should I manually set sector size to 4K or it is not
> worth the (minor) inconvenience?

Only the log might matter for performance, the AG headers are only
read at mount and rarely written because they are so frequently
logged. But, really, the difference between 512 byte and 4k sectors
for the log is going to be pretty damn small. Just use the defaults
and only consider changing them if you observe problems...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
