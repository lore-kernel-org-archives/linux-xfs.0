Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 494E5C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 05:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2441720679
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 05:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgCPFZS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 01:25:18 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46772 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726821AbgCPFZS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 01:25:18 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B733382042D;
        Mon, 16 Mar 2020 16:25:12 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jDiFT-00076l-18; Mon, 16 Mar 2020 16:25:11 +1100
Date:   Mon, 16 Mar 2020 16:25:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Andi Kleen <andi@firstfloor.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Shutdown preventing umount
Message-ID: <20200316052510.GQ10776@dread.disaster.area>
References: <20200314133107.4rv25sp4bvhbjjsx@two.firstfloor.org>
 <20200316020342.GP10776@dread.disaster.area>
 <20200316033717.bnofrpg5yrciyhvz@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316033717.bnofrpg5yrciyhvz@two.firstfloor.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=WfulkdPnAAAA:8 a=7-415B0cAAAA:8 a=hXqpQO_lWkdwtiK-EDoA:9
        a=CjuIK1q_8ugA:10 a=56QPVbyS4OZCpcuOg7Z9:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 15, 2020 at 08:37:19PM -0700, Andi Kleen wrote:
> On Mon, Mar 16, 2020 at 01:03:42PM +1100, Dave Chinner wrote:
> > On Sat, Mar 14, 2020 at 06:31:10AM -0700, Andi Kleen wrote:
> > > 
> > > Hi,
> > > 
> > > I had a cable problem on a USB connected XFS file system, triggering 
> > > some IO errors, and the result was that any access to the mount point
> > > resulted in EIO. This prevented unmounting the file system to recover
> > > from the problem. 
> > 
> > Full dmesg output, please.
> 
> http://www.firstfloor.org/~andi/dmesg-xfs-umount

So /dev/sdd went away, XFS shutdown eventually. There's no
indication that an XFS unmount has started, because the first thing
XFS does in it's ->put_super method is emit this to the log:

XFS (dm-4): Unmounting Filesystem

and that is missing. Hence the VFS unmount path has not reached as
far as XFS before it has errorred out. THis is confirmed by....

> > > 
> > > XFS (...): log I/O error -5
> > > 
> > > scsi 7:0:0:0: rejecting I/O to dead device
> > 
> > Where is unmount stuck? 'echo w > /proc/sysrq-trigger' output if it
> > is hung, 'echo l > /proc/sysrq-trigger' if it is spinning, please?
> 
> It's not stuck. It always errored out with EIO.

... the fact that filesystems cannot return errors from unmount
proceedings as generic_shutdown_super() is a void function.  Hence
where this EIO is coming from is not obvious - it isn't from XFS
failing to unmount the filesystem as it's not gettting that far into
the unmount path.

You're going to need to strace umount to find what syscall is
failing, then probably use tracepoints or some one kernel
introspection tool to work out where the EIO is coming from...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
