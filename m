Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:32360 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727026AbeH1D6r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Aug 2018 23:58:47 -0400
Date: Tue, 28 Aug 2018 10:08:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Trying to write to read-only block-device from XFS
Message-ID: <20180828000836.GI2234@dastard>
References: <20180824233756.kkvmkmm5mdlx77je@two.firstfloor.org>
 <a4d32107-abc0-60d3-8306-b091fbffefd8@sandeen.net>
 <20180825140951.a3dsz3efwnjsj2pz@two.firstfloor.org>
 <c6bcbef0-0c5b-a7a1-adb6-38085db98ce9@sandeen.net>
 <20180827081254.zat4lvxqviwgd4zn@odin.usersys.redhat.com>
 <20180827164342.4vlg3zaehkzcj6od@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180827164342.4vlg3zaehkzcj6od@two.firstfloor.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Aug 27, 2018 at 09:43:43AM -0700, Andi Kleen wrote:
> 
> Adding linux-fsdevel. Keeping full quote for context.
> 
> On Mon, Aug 27, 2018 at 10:12:54AM +0200, Carlos Maiolino wrote:
> > Essentially, this isn't a XFS problem, and most likely you are using XFS on top
> > of some layer like LVM, and/or using snapshots, and your underlying volume went
> > read-only behind XFS for some reason.
> 
> Ok, so the blame is assigned, but the question is still how to avoid the
> warning:
> 
> (1) either XFS needs to check for read only underlying more often
> or
> (2) the warning needs to be removed.
> 
> I assume (2) is far easier. Is (1) even possible without races? 

I doubt (1) is possible to handle at all.

e.g. What's the filesystem supposed to do when the device goes RO
under it without warning? We've now got a heap of dirty state in
memory that we can't write, so in reality if this ever happens our
only option is to shutdown the filesystem, toss everything away and
unmount it.

And because the device is now read only, we can't get the filesystem
back into a consistent state by mounting it again because it can't
run log recovery as that requires writing to the device.

IOWs, having devices turn read only underneath active read/write
filesystems without warning is an unrecoverable failure from the
filesystem perspective.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
