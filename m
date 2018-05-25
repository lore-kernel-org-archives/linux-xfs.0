Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41786 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967408AbeEYR2T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 May 2018 13:28:19 -0400
Subject: Re: Temporary drive failure leads to massive data corruption?
References: <CAKGkouuK6Dz82JBx2s8cccC-ST_enhF3jyVCHr+w=O_-QeppRw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1b397e88-0e1f-5f33-7def-a38a4a1e484a@sandeen.net>
Date: Fri, 25 May 2018 12:28:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAKGkouuK6Dz82JBx2s8cccC-ST_enhF3jyVCHr+w=O_-QeppRw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Patrick J. LoPresti" <lopresti@gmail.com>, linux-xfs@vger.kernel.org

On 5/25/18 12:02 PM, Patrick J. LoPresti wrote:
> Hi. We are using XFS on a hardware RAID6 container with around 100
> terabytes of data in 500K files. (Actually, we have four such
> containers per server and around a dozen servers.)
> 
> Anyway, we had a power event a couple of nights ago that took several
> of the drives -- and thus the container -- offline.
> 
> We got the drives, and thus the hardware RAID6, back online, but when
> we tried to mount the file system the message said it was corrupted
> and we should run xfs_repair. Running xfs_repair complained that there
> were uncommitted entries in the transaction log and we should try to
> mount the file system.
> 
> Ultimately, we had to use "xfs_repair -L" to get the file system to mount.
> 
> Now, I understand that any files or directories being modified during
> the event could be corrupted. But we are seeing something completely
> different; namely...
> 
> Tens of thousands of our files -- each 100-ish megabytes -- appear to
> have had large sections replaced with zeroes. (We are still evaluating
> the damage.) None of these files were being modified at the time; in
> fact, the majority were written years ago and are never changed.
> 
> Is this an expected failure mode for XFS? I understand we may have
> corrupted a few disk blocks, but should we expect that to corrupt a
> significant fraction of our at-rest data?
> 
> This is using Red Hat Enterprise Linux 6.6 (kernel
> 2.6.32-504.16.2.el6.x86_64 of Tue Apr 21 10:35:19 CDT 2015), if it
> makes a difference.

I'm sure you won't like this answer, and I can't base it on empirical
evidence, but my first hunch would be that your controller did a poor job
of recovering from the error, and damaged the storage beneath the
filesystem.

I'd at least take a good look at controller logs (if any?) and see what
it did.  In general, you absolutely must make sure that the storage is
in proper shape before running the higher level fs repair tools.

On a more concrete note, it would be interestting to run xfs_bmap -vv
on some of those files with zeros and see what extents, if any,
cover the zeroed ranges.  i.e. are they holes, allocated, unwritten, etc.

-Eric
