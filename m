Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:48337 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725822AbfDBVhv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Apr 2019 17:37:51 -0400
Date: Wed, 3 Apr 2019 08:37:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: File system corruption in two hard disks
Message-ID: <20190402213748.GV26298@dastard>
References: <20181211183203.7fdbca0f@lud1.home>
 <20190331224918.GO23020@dastard>
 <20190401181311.334e96e8@lud1.home>
 <20190401213226.GR26298@dastard>
 <20190402132357.0f72e3a9@lud1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402132357.0f72e3a9@lud1.home>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luciano ES <lucmove@gmail.com>
Cc: XFS mailing list <linux-xfs@vger.kernel.org>

On Tue, Apr 02, 2019 at 01:23:57PM -0300, Luciano ES wrote:
> On Tue, 2 Apr 2019 08:32:26 +1100, Dave Chinner wrote:
> > At this point, I suspect your problems are the USB enclosure your
> > are using. Plug the disks directly into a SATA port and see if that
> > makes the IO errors go away. This looks like hardware problems, not
> > XFS issues...
> 
> **************************
> 
> Hi. Thank you for your kind attention again.
> 
> I tested the disks directly connected to the SATA ports this time. 
> One of them worked flawlessly. 

That's good!

> Damn! It's the third USB enclosure that fails on me in one year!

That's about par for the course, I think. I simply don't trust USB
storage enclosures at all...

> The other disk failed again. Here is some dmesg:

....

> [    3.790315] sd 1:0:0:0: [sdb] tag#12 Sense Key : Medium Error [current] 
> [    3.790318] sd 1:0:0:0: [sdb] tag#12 Add. Sense: Unrecovered read error - auto reallocate failed

Basically, this is saying the sector on the disk is bad, and there
is no spare sectors on the disk for recovery of that sector. i.e
the sector is now permanently dead. The drive is essentially
unusable at this point - it will only continue to get worse and
lose more data.

AFAICT, the only way you'll get anything off this drive is via
ddrescue to image it and then perform data recovery on the
decayed corpse it extracts....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
