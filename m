Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC52C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Dec 2021 23:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhLLXJJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Dec 2021 18:09:09 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:36961 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229532AbhLLXJJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Dec 2021 18:09:09 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id D494886B190;
        Mon, 13 Dec 2021 10:09:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mwXxe-002M2g-IE; Mon, 13 Dec 2021 10:08:54 +1100
Date:   Mon, 13 Dec 2021 10:08:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chanchal Mathew <chanch13@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS journal log resetting
Message-ID: <20211212230854.GR449541@dread.disaster.area>
References: <20211210213649.GQ449541@dread.disaster.area>
 <F6A3B616-EF69-4AFF-BB12-17D6E53AC8D3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F6A3B616-EF69-4AFF-BB12-17D6E53AC8D3@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=61b68113
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=IkcTkHD0fZMA:10 a=IOMw9HtfNCkA:10 a=7-415B0cAAAA:8 a=nt1UNTH2AAAA:8
        a=rxauI3Egz9cH9F7IEyYA:9 a=QEXdDO2ut3YA:10 a=1jnEqRSf4vEA:10
        a=biEYGPWJfzWAr4FL6Ov7:22 a=7AW3Uk2BEroXwU7YnAE8:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 10, 2021 at 04:04:59PM -0800, Chanchal Mathew wrote:
> 
> Thank you for the explanation! My response in-line.
> 
> >> Hi
> >> 
> >> A question for the developers -
> >> 
> >> Is there a reason why a clean unmount on an XFS filesystem
> >> would not reset the log numbers to 0? The xfs_logprint output
> >> shows the head and tail log numbers to have the same number > 0
> >> and as CLEAN. But the log number is not reset to 0 without
> >> running a xfs_repair -L. Is there a reason it’s not done as
> >> part of the unmount?
> > 
> > Yes.
> > 
> > Log sequence numbers are a persistent record of when a given
> > metadata object was modified. They are stored in all metadata,
> > not just the log, and are used to determine if the modification
> > in the log found at recovery time is already present in the
> > on-disk metadata or not.
> > 
> > Resetting the number back to zero basically breaks this recovery
> > ordering verification, and takes us back to the bad old days of
> > the v4 filesystem format where log recovery could overwrite
> > newer changes in metadata. That could cause data loss and
> > corruption problems when recovering newly allocated inodes and
> > subsequent changes....
> 
> Wouldn’t we expect zero pending modification or no unwritten data
> when a device is cleanly unmounted?

Yes, but how do we determine that when mounting the filesystem?

> Or do you mean, a successful
> ‘umount’ run on the device doesn’t guarantee there are no pending
> changes?

No, the log is left clean via an unmount record that is written to
the log during unmount.

IOWs, to determine there is zero pending modification at mount time,
the next mount *has to find that unmount record* to determine
that the log was cleanly unmounted and does not require recovery.
That's what xlog_find_tail() does.

> >> The problem I’m noticing is, the higher the log number, it takes
> >> longer for it to be mounted. Most time seems spent on the
> >> xlog_find_tail() call. 
> > 
> > The log sequence number has nothign to do with how long
> > xlog_find_tail() takes to run. entirely dependent on the size
> > of the log and time it takes to binary search the journal to find
> > the head. The head then points at the tail, which then gets
> > verified. Once the head and tail are found, the journal contents
> > between the head and tail are CRC checked, and the time this takes
> > is entirely dependent on the distance between the head and tail of
> > the log (i.e. up to 2GB of journal space might get CRC'd here).
> > 
> > But at no point do larger LSNs make this take any longer.  The upper
> > 32 bits of the LSN is just a cycle number, and it is always
> > interpreted as "past, current, next" by the xlog_find_tail()
> > process no matter what it's magnitude is. i.e. log recvoery only has
> > 3 cycle states it cares about, regardless of how many cycles the log
> > has actually run.
> > 
> > -Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 
> The devices I’m testing on are image files with same amount of data. One with lower log number is quicker to mount. 
> 
> $ sudo xfs_logprint -t /dev/mapper/loop0p1
> …
>     log tail: 451 head: 451 state: <CLEAN>
> 
> Whereas, the one with higher log number, such as the one below, is about 4-5 times slower running xlog_find_tail().

This log hasn't even been written once. 

> $ sudo xfs_logprint -t /dev/mapper/loop0p1
> …
>     log tail: 17658 head: 17658 state: <CLEAN>
> 
> The images are of same size, and have same amount of data as well (as verified by df and df -i once mounted)

And this log hasn't even been written once here, either.

As the cycle number is zero in both cases, that means it is likely
that the only difference between the two cases is the number of IOs
performed in the binary search to find the unmount record. i.e. we
have a IO count and seek pattern difference.

Absent any timing information, I would only expect the difference
here to be a few tens of milliseconds between the two cases as it
will only be a handful of disk seeks that are different.

However, I can only guess at this, because you're not including raw
timing information or any other information about the filesystem or
starage.  Can you please attach the scripts the timing information
that you are using to determine that xlog_find_tail() is slower?
i.e. post the commands *and the output* of the scripts you are using
so that we can run the tests ourselves to try to replicate the
problem you are seeing.

We'll also need to know what storage this is running on, etc:

https://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> The only way I can work around this delay for an instance started
> from an image file with higher log number is, to reset it to 0
> with xfs_repair.

Which, since v4.3.0 was released in ~October 2015, xfs_repair does
not do do on v5 filesystems because it can corrupt the filesystem
(as I previously described). Hence I have to guess that you are
either using the deprecated v4 filesystem format or your xfs_repair
version is older than v4.3.0. Either way, you've got a problem when
you upgrade these systems to newer OS versions...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
