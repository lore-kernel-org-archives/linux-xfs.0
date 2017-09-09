Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:14343 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750807AbdIIXx0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Sep 2017 19:53:26 -0400
Date: Sun, 10 Sep 2017 09:53:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS and sector size on thin volumes
Message-ID: <20170909235323.GL17782@dastard>
References: <d95f09118ee6cb2fe0562ad35303715c@assyoma.it>
 <20170909231215.GK17782@dastard>
 <0c59ba403f83e571d695a716ccad5d0a@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c59ba403f83e571d695a716ccad5d0a@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Sun, Sep 10, 2017 at 01:26:42AM +0200, Gionatan Danti wrote:
> Il 10-09-2017 01:12 Dave Chinner ha scritto:
> >
> >Probably not. And, worse, you open up the possibility of torn
> >"single sector" writes if the underlying device isn't a native 4k
> >sector device.
> 
> Good catch, I was not thinking on how sectsize=4K could interact
> with non-4K disks.
> 
> However, if using only 4K disks below the thin volumes/ZVOLs, should
> I manually set sectsize=4K?
> Or, again, I should stick with the default and stop worring?

If a block device is presented with 512 sectors on 4k-only sector
drives, then that's a bug. If it's doing so with 512e drives,
then that's still a bug because it should be presenting as a
512 byte logical, 4096 byte physical sector size device and in that
case mkfs.xfs will choose 4k sectors by default.

IOWs, if the underlying device is correctly presented to mkfs.xfs
then it will choose the correct sector size by default.  dm-thinp
does the right thing with sector sizes, but I have no idea about
ZoL.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
