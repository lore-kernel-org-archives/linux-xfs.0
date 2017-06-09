Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55612 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751524AbdFIMid (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Jun 2017 08:38:33 -0400
Date: Fri, 9 Jun 2017 08:38:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS journal write ordering constraints?
Message-ID: <20170609123829.GA10685@bfoster.bfoster>
References: <CALoZfD4-uqhRSfEh0Y+v8jjSDY2KkAh-hhwdLnRgZopHEETUXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALoZfD4-uqhRSfEh0Y+v8jjSDY2KkAh-hhwdLnRgZopHEETUXA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sweet Tea Dorminy <sweettea@permabit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 08, 2017 at 11:42:11AM -0400, Sweet Tea Dorminy wrote:
> Greetings;
> 
> When using XFS with a 1k block size atop our device, we regularly get
> "log record CRC mismatch"es when mounting XFS after a crash, and we
> are attempting to understand why. We are using RHEL7.3 with its kernel
> 3.10.0-514.10.2.el7.x86_64, xfsprogs version 4.5.0.
> 
> Tracing indicates the following situation occurs:
>        Some pair of consecutive locations contains data A1 and B1, respectively.
>        The XFS journal issues new writes to those locations,
> containing data A2 and B2.
>        The write of B' finishes, but A' is still outstanding at the
> time of the crash.
>        Crash occurs. The data on disk is A1 and B2, respectively.
>        XFS fails to mount, complaining that the checksum mismatches.
> 
> Does XFS expect sequentially issued journal IO to be committed to disk
> in the order of issuance due to the use of FUA?
> 

Hmm, I don't believe there is any such sequential I/O ordering
constraint, but the log is complex and I could be missing something. We
do have higher level ordering rules in various places. For example,
commit records are written to the in-core logs in order. It also looks
like in-core log I/O completion takes explicit measures to process
callbacks in order in the event that the associated I/Os do not complete
in order. That tends to imply there is no explicit log I/O submission
ordering in place.

Of course, that also implies that log recovery should be able to handle
this situation just the same. I'm not quite sure what the expected log
recovery behavior is off the top of my head, but my initial guess would
be that the log LSN stamping could help us identify the valid part of
the log during head/tail discovery.

Anyways, I think more information is required to try and understand what
is happening in your situation. What is the xfs_info for this
filesystem? What granularity are these A and B regions (sectors or
larger)? Are you running on some kind of special block device that
reproduces this? Do you have a consistent reproducer and/or have you
reproduced on an upstream kernel? Could you provide an xfs_metadump
image of the filesystem that fails log recovery with CRC errors?

Brian

> Thanks!
> 
> Sweet Tea Dorminy
> Permabit Technology Corporation
> Cambridge, MA
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
